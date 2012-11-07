Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2KGBsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 20:48:39 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39626 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab2KGBsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 20:48:36 -0500
From: Joshua Emele <jemele@gmail.com>
To: Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-omap@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joshua Emele <jemele@gmail.com>
Subject: [PATCH 1/4] cpufreq: OMAP: if an iva clock name is specified, load iva resources
Date: Tue,  6 Nov 2012 17:47:38 -0800
Message-Id: <1352252861-18384-2-git-send-email-jemele@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1352252861-18384-1-git-send-email-jemele@gmail.com>
References: <1352252861-18384-1-git-send-email-jemele@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joshua Emele <jemele@gmail.com>
---
 drivers/cpufreq/omap-cpufreq.c |   73 ++++++++++++++++++++++++++++++++-------
 1 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 17fa04d..1621208 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -50,11 +50,11 @@ static DEFINE_PER_CPU(struct lpj_info, lpj_ref);
 static struct lpj_info global_lpj_ref;
 #endif
 
-static struct cpufreq_frequency_table *freq_table;
+static struct cpufreq_frequency_table *freq_table, *iva_freq_table;
 static atomic_t freq_table_users = ATOMIC_INIT(0);
-static struct clk *mpu_clk;
-static char *mpu_clk_name;
-static struct device *mpu_dev;
+static struct clk *mpu_clk, *iva_clk;
+static char *mpu_clk_name, *iva_clk_name;
+static struct device *mpu_dev, *iva_dev;
 static struct regulator *mpu_reg;
 
 static int omap_verify_speed(struct cpufreq_policy *policy)
@@ -199,8 +199,49 @@ done:
 
 static inline void freq_table_free(void)
 {
-	if (atomic_dec_and_test(&freq_table_users))
+	if (atomic_dec_and_test(&freq_table_users)) {
 		opp_free_cpufreq_table(mpu_dev, &freq_table);
+		opp_free_cpufreq_table(iva_dev, &iva_freq_table);
+	}
+}
+
+static inline void clk_free(void)
+{
+	if (mpu_clk) {
+		clk_put(mpu_clk);
+		mpu_clk = NULL;
+	}
+	if (iva_clk) {
+		clk_put(iva_clk);
+		iva_clk = NULL;
+	}
+}
+
+static int __cpuinit omap_iva_init(struct cpufreq_policy *policy)
+{
+	int result;
+	if (!iva_clk_name) {
+		pr_info("%s: iva unavailable\n", __func__);
+		return 0;
+	}
+	iva_dev = omap_device_get_by_hwmod_name("iva");
+	if (!iva_dev) {
+		pr_err("%s: unable to get the iva device\n", __func__);
+		return -EINVAL;
+	}
+	iva_clk = clk_get(NULL, iva_clk_name);
+	if (IS_ERR(iva_clk)) {
+		dev_err(iva_dev, "%s: cpu%d: %s clock unavailable\n",
+			__func__, policy->cpu, iva_clk_name);
+		return PTR_ERR(iva_clk);
+	}
+	result = opp_init_cpufreq_table(iva_dev, &iva_freq_table);
+	if (result) {
+		dev_err(iva_dev, "%s: cpu%d: failed creating freq table[%d]\n",
+				__func__, policy->cpu, result);
+		return result;
+	}
+	return 0;
 }
 
 static int __cpuinit omap_cpu_init(struct cpufreq_policy *policy)
@@ -218,13 +259,19 @@ static int __cpuinit omap_cpu_init(struct cpufreq_policy *policy)
 
 	policy->cur = policy->min = policy->max = omap_getspeed(policy->cpu);
 
-	if (atomic_inc_return(&freq_table_users) == 1)
+	if (atomic_inc_return(&freq_table_users) == 1) {
 		result = opp_init_cpufreq_table(mpu_dev, &freq_table);
-
-	if (result) {
-		dev_err(mpu_dev, "%s: cpu%d: failed creating freq table[%d]\n",
-				__func__, policy->cpu, result);
-		goto fail_ck;
+		if (result) {
+			dev_err(mpu_dev, "%s: cpu%d: failed creating freq table[%d]\n",
+					__func__, policy->cpu, result);
+			goto fail_ck;
+		}
+		result = omap_iva_init(policy);
+		if (result) {
+			pr_err("%s: cpu%d: failed to initialize iva[%d]\n",
+					__func__, policy->cpu, result);
+			goto fail_table;
+		}
 	}
 
 	result = cpufreq_frequency_table_cpuinfo(policy, freq_table);
@@ -257,14 +304,14 @@ static int __cpuinit omap_cpu_init(struct cpufreq_policy *policy)
 fail_table:
 	freq_table_free();
 fail_ck:
-	clk_put(mpu_clk);
+	clk_free();
 	return result;
 }
 
 static int omap_cpu_exit(struct cpufreq_policy *policy)
 {
 	freq_table_free();
-	clk_put(mpu_clk);
+	clk_free();
 	return 0;
 }
 
-- 
1.7.6.5

