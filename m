Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab1FPHFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:05:13 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33836 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756256Ab1FPHFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:05:07 -0400
X-Sasl-enc: bK+ObXngIb+Im/CnfB4ZFtk1Rh4cdD9nWqEwnpBjZuED 1308207906
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:16:09 2011
Message-Id: <20110616001609.690074048@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:15:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Finney <steven.finney@palm.com>, Dave Jones <davej@redhat.com>
Subject: [04/91] [CPUFREQ] Fix memory leak in cpufreq_stat
In-Reply-To: <20110616001900.GA25375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: steven finney <Steven.Finney@palm.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/cpufreq/cpufreq_stats.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -164,17 +164,27 @@ static int freq_table_get_index(struct c
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
@@ -315,6 +325,9 @@ static int __cpuinit cpufreq_stat_cpu_ca
 	case CPU_ONLINE_FROZEN:
 		cpufreq_update_policy(cpu);
 		break;
+	case CPU_DOWN_PREPARE:
+		cpufreq_stats_free_sysfs(cpu);
+		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		cpufreq_stats_free_table(cpu);
@@ -323,9 +336,11 @@ static int __cpuinit cpufreq_stat_cpu_ca
 	return NOTIFY_OK;
 }
 
+/* priority=1 so this will get called before cpufreq_remove_dev */
 static struct notifier_block cpufreq_stat_cpu_notifier __refdata =
 {
 	.notifier_call = cpufreq_stat_cpu_callback,
+	.priority = 1,
 };
 
 static struct notifier_block notifier_policy_block = {


