Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2HOXoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 19:44:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55538 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab2HOXoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 19:44:15 -0400
From: Mike Turquette <mturquette@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <shawn.guo@linaro.org>, <linus.walleij@linaro.org>,
        <rob.herring@calxeda.com>, <pdeschrijver@nvidia.com>,
        <pgaikwad@nvidia.com>, <viresh.kumar@linaro.org>, <rnayak@ti.com>,
        <paul@pwsan.com>, <broonie@opensource.wolfsonmicro.com>,
        <ccross@android.com>, <linux-arm-kernel@lists.infradead.org>,
        <myungjoo.ham@samsung.com>, <rajagopal.venkat@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v2 3/4] [RFC] cpufreq: omap: scale regulator from clk notifier
Date: Wed, 15 Aug 2012 16:43:33 -0700
Message-ID: <1345074214-17531-4-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345074214-17531-1-git-send-email-mturquette@linaro.org>
References: <1345074214-17531-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves direct control of the MPU voltage regulator out of the
cpufreq driver .target callback and instead uses the common dvfs clk
rate-change notifier infrastructure.

Ideally it would be nice to reduce the .target callback for omap's
cpufreq driver to a simple call to clk_set_rate.  For now there is still
some other stuff needed there (jiffies per loop, rounding the rate, etc
etc).

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/cpufreq/omap-cpufreq.c |   85 +++++++++++-----------------------------
 1 file changed, 22 insertions(+), 63 deletions(-)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 17fa04d..2f7de30 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -55,7 +55,7 @@ static atomic_t freq_table_users = ATOMIC_INIT(0);
 static struct clk *mpu_clk;
 static char *mpu_clk_name;
 static struct device *mpu_dev;
-static struct regulator *mpu_reg;
+static struct dvfs_info *di;
 
 static int omap_verify_speed(struct cpufreq_policy *policy)
 {
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
@@ -286,6 +244,8 @@ static struct cpufreq_driver omap_driver = {
 
 static int __init omap_cpufreq_init(void)
 {
+	struct dvfs_info_init dii;
+
 	if (cpu_is_omap24xx())
 		mpu_clk_name = "virt_prcm_set";
 	else if (cpu_is_omap34xx())
@@ -298,34 +258,33 @@ static int __init omap_cpufreq_init(void)
 		return -EINVAL;
 	}
 
+	mpu_clk = clk_get(NULL, mpu_clk_name);
+	if (IS_ERR(mpu_clk))
+		return PTR_ERR(mpu_clk);
+
 	mpu_dev = omap_device_get_by_hwmod_name("mpu");
 	if (!mpu_dev) {
 		pr_warning("%s: unable to get the mpu device\n", __func__);
-		return -EINVAL;
+		goto out;
 	}
 
-	mpu_reg = regulator_get(mpu_dev, "vcc");
-	if (IS_ERR(mpu_reg)) {
-		pr_warning("%s: unable to get MPU regulator\n", __func__);
-		mpu_reg = NULL;
-	} else {
-		/* 
-		 * Ensure physical regulator is present.
-		 * (e.g. could be dummy regulator.)
-		 */
-		if (regulator_get_voltage(mpu_reg) < 0) {
-			pr_warn("%s: physical regulator not present for MPU\n",
+	dii.dev = mpu_dev;
+	dii.con_id = mpu_clk_name;
+	dii.reg_id = "vcc";
+	dii.tol = OPP_TOLERANCE;
+
+	di = dvfs_clk_notifier_register(&dii);
+	if (IS_ERR(di))
+		pr_warning("%s: failed to register dvfs clk notifier\n",
 				__func__);
-			regulator_put(mpu_reg);
-			mpu_reg = NULL;
-		}
-	}
 
+out:
 	return cpufreq_register_driver(&omap_driver);
 }
 
 static void __exit omap_cpufreq_exit(void)
 {
+	dvfs_clk_notifier_unregister(di);
 	cpufreq_unregister_driver(&omap_driver);
 }
 
-- 
1.7.9.5

