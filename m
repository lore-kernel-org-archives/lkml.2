Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab2GNAR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 20:17:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36386 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757072Ab2GNARS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 20:17:18 -0400
From: Mike Turquette <mturquette@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <shawn.guo@linaro.org>, <linus.walleij@linaro.org>,
        <rob.herring@calxeda.com>, <pdeschrijver@nvidia.com>,
        <pgaikwad@nvidia.com>, <viresh.kumar@linaro.org>, <rnayak@ti.com>,
        <paul@pwsan.com>, <broonie@opensource.wolfsonmicro.com>,
        <tglx@linutronix.de>, <ccross@android.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 2/2] [RFC] cpufreq: omap: scale regulator from clk notifier
Date: Fri, 13 Jul 2012 17:16:41 -0700
Message-ID: <1342225001-22962-3-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342225001-22962-1-git-send-email-mturquette@linaro.org>
References: <1342225001-22962-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves direct control of the MPU voltage regulator out of the
cpufreq driver .target callback and instead puts that logic into a clock
rate change notifier callback.

The same frequency/voltage lookup via the OPP library is present, except
that the calls to regulator_set_voltage are done from the clock
framework instead of cpufreq.

Ideally it would be nice to reduce the .target callback for OMAP's
cpufreq driver to a simple call to clk_set_rate.  For now there is still
some other stuff needed there (jiffies per loop, rounding the rate, etc
etc).

Not-signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/cpufreq/omap-cpufreq.c |  154 +++++++++++++++++++++++++---------------
 1 file changed, 96 insertions(+), 58 deletions(-)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 17fa04d..bf15c49 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -80,10 +80,9 @@ static int omap_target(struct cpufreq_policy *policy,
 		       unsigned int relation)
 {
 	unsigned int i;
-	int r, ret = 0;
+	int ret = 0;
 	struct cpufreq_freqs freqs;
-	struct opp *opp;
-	unsigned long freq, volt = 0, volt_old = 0, tol = 0;
+	unsigned long freq;
 
 	if (!freq_table) {
 		dev_err(mpu_dev, "%s: cpu%d: no freq table!\n", __func__,
@@ -119,47 +118,11 @@ static int omap_target(struct cpufreq_policy *policy,
 
 	freq = freqs.new * 1000;
 
-	if (mpu_reg) {
-		opp = opp_find_freq_ceil(mpu_dev, &freq);
-		if (IS_ERR(opp)) {
-			dev_err(mpu_dev, "%s: unable to find MPU OPP for %d\n",
-				__func__, freqs.new);
-			return -EINVAL;
-		}
-		volt = opp_get_voltage(opp);
-		tol = volt * OPP_TOLERANCE / 100;
-		volt_old = regulator_get_voltage(mpu_reg);
-	}
-
-	dev_dbg(mpu_dev, "cpufreq-omap: %u MHz, %ld mV --> %u MHz, %ld mV\n", 
-		freqs.old / 1000, volt_old ? volt_old / 1000 : -1,
-		freqs.new / 1000, volt ? volt / 1000 : -1);
-
-	/* scaling up?  scale voltage before frequency */
-	if (mpu_reg && (freqs.new > freqs.old)) {
-		r = regulator_set_voltage(mpu_reg, volt - tol, volt + tol);
-		if (r < 0) {
-			dev_warn(mpu_dev, "%s: unable to scale voltage up.\n",
-				 __func__);
-			freqs.new = freqs.old;
-			goto done;
-		}
-	}
+	dev_dbg(mpu_dev, "cpufreq-omap: %u MHz --> %u MHz\n",
+			freqs.old / 1000, freqs.new / 1000); 
 
 	ret = clk_set_rate(mpu_clk, freqs.new * 1000);
 
-	/* scaling down?  scale voltage after frequency */
-	if (mpu_reg && (freqs.new < freqs.old)) {
-		r = regulator_set_voltage(mpu_reg, volt - tol, volt + tol);
-		if (r < 0) {
-			dev_warn(mpu_dev, "%s: unable to scale voltage down.\n",
-				 __func__);
-			ret = clk_set_rate(mpu_clk, freqs.old * 1000);
-			freqs.new = freqs.old;
-			goto done;
-		}
-	}
-
 	freqs.new = omap_getspeed(policy->cpu);
 #ifdef CONFIG_SMP
 	/*
@@ -187,7 +150,6 @@ static int omap_target(struct cpufreq_policy *policy,
 					freqs.new);
 #endif
 
-done:
 	/* notifiers */
 	for_each_cpu(i, policy->cpus) {
 		freqs.cpu = i;
@@ -207,10 +169,6 @@ static int __cpuinit omap_cpu_init(struct cpufreq_policy *policy)
 {
 	int result = 0;
 
-	mpu_clk = clk_get(NULL, mpu_clk_name);
-	if (IS_ERR(mpu_clk))
-		return PTR_ERR(mpu_clk);
-
 	if (policy->cpu >= NR_CPUS) {
 		result = -EINVAL;
 		goto fail_ck;
@@ -284,32 +242,74 @@ static struct cpufreq_driver omap_driver = {
 	.attr		= omap_cpufreq_attr,
 };
 
-static int __init omap_cpufreq_init(void)
+static int mpu_clk_volt_scale_handler(struct notifier_block *nb,
+	unsigned long flags, void *data)
 {
-	if (cpu_is_omap24xx())
-		mpu_clk_name = "virt_prcm_set";
-	else if (cpu_is_omap34xx())
-		mpu_clk_name = "dpll1_ck";
-	else if (cpu_is_omap44xx())
-		mpu_clk_name = "dpll_mpu_ck";
+	struct clk_notifier_data *cnd = data;
+	unsigned long tol;
+	int ret, volt_new, volt_old;
+	struct opp *opp;
 
-	if (!mpu_clk_name) {
-		pr_err("%s: unsupported Silicon?\n", __func__);
-		return -EINVAL;
+	volt_old = regulator_get_voltage(mpu_reg);
+	opp = opp_find_freq_exact(mpu_dev, cnd->new_rate, true);
+	volt_new = opp_get_voltage(opp);
+
+	tol = volt_new * OPP_TOLERANCE / 100;
+
+	/* scaling up?  scale voltage before frequency */
+	if (cnd->new_rate > cnd->old_rate) {
+		dev_dbg(mpu_dev, "cpufreq-omap: %d mV --> %d mV\n",
+				volt_old, volt_new);
+
+		ret = regulator_set_voltage(mpu_reg, volt_new - tol, volt_new + tol);
+
+		if (ret < 0) {
+			dev_warn(mpu_dev, "%s: unable to scale voltage up.\n",
+				 __func__);
+			return NOTIFY_BAD;
+		}
+	}
+
+	/* scaling down?  scale voltage after frequency */
+	if (cnd->new_rate < cnd->old_rate) {
+		dev_dbg(mpu_dev, "cpufreq-omap: %d mV --> %d mV\n",
+				volt_old, volt_new);
+
+		ret = regulator_set_voltage(mpu_reg, volt_new - tol, volt_new + tol);
+
+		if (ret< 0) {
+			dev_warn(mpu_dev, "%s: unable to scale voltage down.\n",
+				 __func__);
+			return NOTIFY_BAD;
+		}
 	}
 
+	return NOTIFY_OK;
+}
+
+static struct notifier_block mpu_clk_volt_scale_nb = {
+	.notifier_call = mpu_clk_volt_scale_handler,
+};
+
+static int __init omap_regulator_init(void)
+{
+	int ret = 0;
+
 	mpu_dev = omap_device_get_by_hwmod_name("mpu");
 	if (!mpu_dev) {
 		pr_warning("%s: unable to get the mpu device\n", __func__);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	mpu_reg = regulator_get(mpu_dev, "vcc");
 	if (IS_ERR(mpu_reg)) {
 		pr_warning("%s: unable to get MPU regulator\n", __func__);
 		mpu_reg = NULL;
+		ret = -ENODEV;
+		goto out;
 	} else {
-		/* 
+		/*
 		 * Ensure physical regulator is present.
 		 * (e.g. could be dummy regulator.)
 		 */
@@ -318,9 +318,47 @@ static int __init omap_cpufreq_init(void)
 				__func__);
 			regulator_put(mpu_reg);
 			mpu_reg = NULL;
+			ret = -ENODEV;
+			goto out;
 		}
 	}
 
+out:
+	return ret;
+}
+
+static int __init omap_cpufreq_init(void)
+{
+	int ret;
+
+	if (cpu_is_omap24xx())
+		mpu_clk_name = "virt_prcm_set";
+	else if (cpu_is_omap34xx())
+		mpu_clk_name = "dpll1_ck";
+	else if (cpu_is_omap44xx())
+		mpu_clk_name = "dpll_mpu_ck";
+
+	if (!mpu_clk_name) {
+		pr_err("%s: unsupported Silicon?\n", __func__);
+		return -EINVAL;
+	}
+
+	mpu_clk = clk_get(NULL, mpu_clk_name);
+	if (IS_ERR(mpu_clk))
+		return PTR_ERR(mpu_clk);
+
+	ret = omap_regulator_init();
+	if (ret) {
+		pr_err("%s: failed to get mpu regulator\n", __func__);
+		pr_err("%s: skipping clk notifier registration\n", __func__);
+		goto out;
+	}
+
+	ret = clk_notifier_register(mpu_clk, &mpu_clk_volt_scale_nb);
+	if (ret)
+		pr_err("%s: failed to register clk notifier\n", __func__);
+
+out:
 	return cpufreq_register_driver(&omap_driver);
 }
 
-- 
1.7.9.5

