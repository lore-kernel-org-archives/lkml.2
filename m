Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965322Ab2EOCRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:48919 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964839Ab2EOCQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:01 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 004/179] Fix memory leak in cpufreq_stat
Date: Mon, 14 May 2012 22:11:40 -0400
Message-ID: <1337048075-6132-5-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: steven finney <Steven.Finney@palm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 98586ed8b8878e10691203687e89a42fa3355300 upstream.

When a CPU is taken offline in an SMP system, cpufreq_remove_dev()
nulls out the per-cpu policy before cpufreq_stats_free_table() can
make use of it.  cpufreq_stats_free_table() then skips the
call to sysfs_remove_group(), leaving about 100 bytes of sysfs-related
memory unclaimed each time a CPU-removal occurs. Break up
cpu_stats_free_table into sysfs and table portions, and
call the sysfs portion early.

Signed-off-by: Steven Finney <steven.finney@palm.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/cpufreq/cpufreq_stats.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 00d73fc..4f1b8de 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -165,17 +165,27 @@ static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
 	return -1;
 }
 
+/* should be called late in the CPU removal sequence so that the stats
+ * memory is still available in case someone tries to use it.
+ */
 static void cpufreq_stats_free_table(unsigned int cpu)
 {
 	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
-	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
-	if (policy && policy->cpu == cpu)
-		sysfs_remove_group(&policy->kobj, &stats_attr_group);
 	if (stat) {
 		kfree(stat->time_in_state);
 		kfree(stat);
 	}
 	per_cpu(cpufreq_stats_table, cpu) = NULL;
+}
+
+/* must be called early in the CPU removal sequence (before
+ * cpufreq_remove_dev) so that policy is still valid.
+ */
+static void cpufreq_stats_free_sysfs(unsigned int cpu)
+{
+	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
+	if (policy && policy->cpu == cpu)
+		sysfs_remove_group(&policy->kobj, &stats_attr_group);
 	if (policy)
 		cpufreq_cpu_put(policy);
 }
@@ -316,6 +326,9 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 	case CPU_ONLINE_FROZEN:
 		cpufreq_update_policy(cpu);
 		break;
+	case CPU_DOWN_PREPARE:
+		cpufreq_stats_free_sysfs(cpu);
+		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		cpufreq_stats_free_table(cpu);
@@ -324,9 +337,11 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
+/* priority=1 so this will get called before cpufreq_remove_dev */
 static struct notifier_block cpufreq_stat_cpu_notifier __refdata =
 {
 	.notifier_call = cpufreq_stat_cpu_callback,
+	.priority = 1,
 };
 
 static struct notifier_block notifier_policy_block = {
-- 
1.7.9.6

