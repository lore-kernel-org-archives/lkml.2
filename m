Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1GSFml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 01:42:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42831 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab1GSFmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 01:42:40 -0400
X-AuditID: cbfee61a-b7cf0ae000006bc6-9c-4e25194e73fa
Date: Tue, 19 Jul 2011 14:41:57 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH] cpufreq: exynos4210: Show list of available frequencies
To: cpufreq@vger.kernel.org
Cc: davej@redhat.com, kgene.kim@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-kernel@vger.kernel.org
Message-id: <1311054117-11587-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 19 Jul 2011 05:43:02.0295 (UTC)
 FILETIME=[B969FA70:01CC45D6]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables 'scaling_available_frequencies' attribute
showing list of available frequencies.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
---
 drivers/cpufreq/exynos4210-cpufreq.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/exynos4210-cpufreq.c b/drivers/cpufreq/exynos4210-cpufreq.c
index b7c3a84..6f88757 100644
--- a/drivers/cpufreq/exynos4210-cpufreq.c
+++ b/drivers/cpufreq/exynos4210-cpufreq.c
@@ -464,6 +464,8 @@ static int exynos4_cpufreq_resume(struct cpufreq_policy *policy)
 
 static int exynos4_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
+	int ret;
+
 	policy->cur = policy->min = policy->max = exynos4_getspeed(policy->cpu);
 
 	cpufreq_frequency_table_get_attr(exynos4_freq_table, policy->cpu);
@@ -479,16 +481,35 @@ static int exynos4_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	 */
 	cpumask_setall(policy->cpus);
 
-	return cpufreq_frequency_table_cpuinfo(policy, exynos4_freq_table);
+	ret = cpufreq_frequency_table_cpuinfo(policy, exynos4_freq_table);
+	if (ret)
+		return ret;
+
+	cpufreq_frequency_table_get_attr(exynos4_freq_table, policy->cpu);
+
+	return 0;
 }
 
+static int exynos4_cpufreq_cpu_exit(struct cpufreq_policy *policy)
+{
+	cpufreq_frequency_table_put_attr(policy->cpu);
+	return 0;
+}
+
+static struct freq_attr *exynos4_cpufreq_attr[] = {
+	&cpufreq_freq_attr_scaling_available_freqs,
+	NULL,
+};
+
 static struct cpufreq_driver exynos4_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= exynos4_verify_speed,
 	.target		= exynos4_target,
 	.get		= exynos4_getspeed,
 	.init		= exynos4_cpufreq_cpu_init,
+	.exit		= exynos4_cpufreq_cpu_exit,
 	.name		= "exynos4_cpufreq",
+	.attr		= exynos4_cpufreq_attr,
 #ifdef CONFIG_PM
 	.suspend	= exynos4_cpufreq_suspend,
 	.resume		= exynos4_cpufreq_resume,
-- 
1.7.4.1

