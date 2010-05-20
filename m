Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab0ETSmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:42:51 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23900 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab0ETSmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:42:44 -0400
From: Mike Chan <mike@android.com>
Cc: menage@google.com, balbir@in.ibm.com, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org, trenn@suse.de,
       khilman@deeprootsystems.com, linux-omap@vger.kernel.org,
       Mike Chan <mike@android.com>
Subject: [PATCH v2 3/3] omap: cpu: Implement callbacks for cpu frequency tracking in cpuacct
Date: Thu, 20 May 2010 11:42:24 -0700
Message-Id: <1274380944-20947-4-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274380944-20947-1-git-send-email-mike@android.com>
References: <1274380944-20947-1-git-send-email-mike@android.com>
X-System-Of-Record: true
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement OMAP platform specific scheduler callbacks for tracking
cpu frequencies per cpuacct cgroup.

Signed-off-by: Mike Chan <mike@android.com>
---
 arch/arm/plat-omap/cpu-omap.c |   67 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 66 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/cpu-omap.c b/arch/arm/plat-omap/cpu-omap.c
index 6d3d333..176417a 100644
--- a/arch/arm/plat-omap/cpu-omap.c
+++ b/arch/arm/plat-omap/cpu-omap.c
@@ -21,6 +21,8 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/cpuacct.h>
 
 #include <mach/hardware.h>
 #include <plat/clock.h>
@@ -38,6 +40,10 @@ static struct cpufreq_frequency_table *freq_table;
 
 static struct clk *mpu_clk;
 
+#ifdef CONFIG_CGROUP_CPUACCT
+static int freq_index;
+#endif
+
 /* TODO: Add support for SDRAM timing changes */
 
 int omap_verify_speed(struct cpufreq_policy *policy)
@@ -96,6 +102,11 @@ static int omap_target(struct cpufreq_policy *policy,
 	       freqs.old, freqs.new);
 #endif
 	ret = clk_set_rate(mpu_clk, freqs.new * 1000);
+#ifdef CONFIG_CGROUP_CPUACCT
+	/* Update freq_index before cpufreq transition post notification. */
+	cpufreq_frequency_table_target(policy, freq_table, freqs.new,
+			CPUFREQ_RELATION_L, &freq_index);
+#endif
 	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 
 	return ret;
@@ -125,7 +136,14 @@ static int __init omap_cpu_init(struct cpufreq_policy *policy)
 		policy->cpuinfo.max_freq = clk_round_rate(mpu_clk,
 							VERY_HI_RATE) / 1000;
 	}
-
+#ifdef CONFIG_CGROUP_CPUACCT
+	/*
+	 * Update freq_index, since we are using the extact frequency
+	 * we can use any relation.
+	 */
+	cpufreq_frequency_table_target(policy, freq_table, policy->cur,
+			CPUFREQ_RELATION_L, &freq_index);
+#endif
 	/* FIXME: what's the actual transition time? */
 	policy->cpuinfo.transition_latency = 300 * 1000;
 
@@ -169,3 +187,50 @@ arch_initcall(omap_cpufreq_init);
  * cpufreq_frequency_table_put_attr()
  */
 
+#ifdef CONFIG_CGROUP_CPUACCT
+/*
+ * Omap platform calls for cpuacct frequency accounting.
+ */
+
+static void omap_cpuacct_freq_init(void **cpuacct_data)
+{
+	/* MAX_VDD1_OPP is gone, define a table size to fit available values */
+	*cpuacct_data = kzalloc(sizeof(u64) * 8, GFP_KERNEL);
+}
+
+/* Called with rcu_read_lock() held. */
+static void omap_cpuacct_freq_charge(void *cpuacct_data, u64 cputime, unsigned int cpu)
+{
+	u64 *cpuacct_freq = cpuacct_data;
+	if (freq_index < 0)
+		return;
+
+	cpuacct_freq[freq_index] += cputime;
+}
+
+static void omap_cpuacct_freq_show(void *cpuacct_data, struct cgroup_map_cb *cb)
+{
+	int i;
+	char buf[32];
+	u64 *cpuacct_freq = cpuacct_data;
+	for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++) {
+		snprintf(buf, sizeof(buf), "%u", freq_table[i].frequency);
+		cb->fill(cb, buf, cpuacct_freq[i]);
+	}
+}
+
+static struct cpuacct_charge_calls omap_cpuacct_cpufreq = {
+	.init = omap_cpuacct_freq_init,
+	.charge = omap_cpuacct_freq_charge,
+	.cpufreq_show = omap_cpuacct_freq_show,
+};
+
+static int __init omap_cpuacct_init(void)
+{
+	freq_index = -1;
+	cpuacct_charge_register(&omap_cpuacct_cpufreq);
+	return 0;
+}
+
+early_initcall(omap_cpuacct_init);
+#endif
-- 
1.7.0.1

