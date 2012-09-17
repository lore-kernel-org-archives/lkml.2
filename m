Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab2IQUR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:17:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56670 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab2IQUR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:17:26 -0400
Date: Mon, 17 Sep 2012 13:17:21 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Duncan <1i5t5.duncan@cox.net>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [PATCH 3.6-rc6] cpufreq/powernow-k8: workqueue user shouldn't
 migrate the kworker to another CPU
Message-ID: <20120917201721.GJ18677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powernowk8_target() runs off a per-cpu work item and if the
cpufreq_policy->cpu is different from the current one, it migrates the
kworker to the target CPU by manipulating current->cpus_allowed.  The
function migrates the kworker back to the original CPU but this is
still broken.  Workqueue concurrency management requires the kworkers
to stay on the same CPU and powernowk8_target() ends up triggerring
BUG_ON(rq != this_rq()) in try_to_wake_up_local() if it contends on
fidvid_mutex and sleeps.

It is unclear why this bug is being reported now.  Duncan says it
appeared to be a regression of 3.6-rc1 and couldn't reproduce it on
3.5.  Bisection seemed to point to 63d95a91 "workqueue: use @pool
instead of @gcwq or @cpu where applicable" which is an non-functional
change.  Given that the reproduce case sometimes took upto days to
trigger, it's easy to be misled while bisecting.  Maybe something made
contention on fidvid_mutex more likely?  I don't know.

This patch fixes the bug by punting to another per-cpu work item on
the target CPU if it isn't the same as the current one.  The code
assumes that cpufreq_policy->cpu is kept online by the caller, which
Rafael tells me is the case.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Duncan <1i5t5.duncan@cox.net>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: stable@kernel.org
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47301
---

While it's very late in the merge cycle, the fix is limited in scope
and fairly safe, so it wouldn't be too crazy to merge but then again
this can go through the next -rc1 and then -stable.  Linus, Rafael,
what do you guys think?

Thanks.

 drivers/cpufreq/powernow-k8.c |   89 +++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 36 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index c0e8164..53db9de 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -35,7 +35,6 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/cpumask.h>
-#include <linux/sched.h>	/* for current / set_cpus_allowed() */
 #include <linux/io.h>
 #include <linux/delay.h>
 
@@ -1139,46 +1138,43 @@ static int transition_frequency_pstate(struct powernow_k8_data *data,
 	return res;
 }
 
-/* Driver entry point to switch to the target frequency */
-static int powernowk8_target(struct cpufreq_policy *pol,
-		unsigned targfreq, unsigned relation)
+struct powernowk8_target_work {
+	struct work_struct		work;
+	struct cpufreq_policy		*pol;
+	unsigned			targfreq;
+	unsigned			relation;
+	int				ret;
+};
+
+static void powernowk8_target_on_cpu(struct work_struct *work)
 {
-	cpumask_var_t oldmask;
+	struct powernowk8_target_work *tw =
+		container_of(work, struct powernowk8_target_work, work);
+	struct cpufreq_policy *pol = tw->pol;
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
 	unsigned int newstate;
-	int ret = -EIO;
 
+	tw->ret = -EINVAL;
 	if (!data)
-		return -EINVAL;
+		return;
+
+	tw->ret = -EIO;
 
 	checkfid = data->currfid;
 	checkvid = data->currvid;
 
-	/* only run on specific CPU from here on. */
-	/* This is poor form: use a workqueue or smp_call_function_single */
-	if (!alloc_cpumask_var(&oldmask, GFP_KERNEL))
-		return -ENOMEM;
-
-	cpumask_copy(oldmask, tsk_cpus_allowed(current));
-	set_cpus_allowed_ptr(current, cpumask_of(pol->cpu));
-
-	if (smp_processor_id() != pol->cpu) {
-		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
-		goto err_out;
-	}
-
 	if (pending_bit_stuck()) {
 		printk(KERN_ERR PFX "failing targ, change pending bit set\n");
-		goto err_out;
+		return;
 	}
 
 	pr_debug("targ: cpu %d, %d kHz, min %d, max %d, relation %d\n",
-		pol->cpu, targfreq, pol->min, pol->max, relation);
+		pol->cpu, tw->targfreq, pol->min, pol->max, tw->relation);
 
 	if (query_current_values_with_pending_wait(data))
-		goto err_out;
+		return;
 
 	if (cpu_family != CPU_HW_PSTATE) {
 		pr_debug("targ: curr fid 0x%x, vid 0x%x\n",
@@ -1195,23 +1191,23 @@ static int powernowk8_target(struct cpufreq_policy *pol,
 	}
 
 	if (cpufreq_frequency_table_target(pol, data->powernow_table,
-				targfreq, relation, &newstate))
-		goto err_out;
+				tw->targfreq, tw->relation, &newstate))
+		return;
 
 	mutex_lock(&fidvid_mutex);
 
 	powernow_k8_acpi_pst_values(data, newstate);
 
 	if (cpu_family == CPU_HW_PSTATE)
-		ret = transition_frequency_pstate(data,
-			data->powernow_table[newstate].index);
+		tw->ret = transition_frequency_pstate(data,
+				data->powernow_table[newstate].index);
 	else
-		ret = transition_frequency_fidvid(data, newstate);
-	if (ret) {
+		tw->ret = transition_frequency_fidvid(data, newstate);
+	if (tw->ret) {
 		printk(KERN_ERR PFX "transition frequency failed\n");
-		ret = 1;
+		tw->ret = 1;
 		mutex_unlock(&fidvid_mutex);
-		goto err_out;
+		return;
 	}
 	mutex_unlock(&fidvid_mutex);
 
@@ -1220,12 +1216,33 @@ static int powernowk8_target(struct cpufreq_policy *pol,
 				data->powernow_table[newstate].index);
 	else
 		pol->cur = find_khz_freq_from_fid(data->currfid);
-	ret = 0;
 
-err_out:
-	set_cpus_allowed_ptr(current, oldmask);
-	free_cpumask_var(oldmask);
-	return ret;
+	tw->ret = 0;
+}
+
+/* Driver entry point to switch to the target frequency */
+static int powernowk8_target(struct cpufreq_policy *pol,
+		unsigned targfreq, unsigned relation)
+{
+	struct powernowk8_target_work tw;
+
+	/*
+	 * Must run on @pol->cpu.  Bounce to workqueue if necessary.
+	 * cpufreq core is responsible for ensuring the cpu stays online.
+	 */
+	INIT_WORK_ONSTACK(&tw.work, powernowk8_target_on_cpu);
+	tw.pol = pol;
+	tw.targfreq = targfreq;
+	tw.relation = relation;
+
+	if (smp_processor_id() == pol->cpu) {
+		powernowk8_target_on_cpu(&tw.work);
+	} else {
+		schedule_work_on(pol->cpu, &tw.work);
+		flush_work(&tw.work);
+	}
+
+	return tw.ret;
 }
 
 /* Driver entry point to verify the policy and range of frequencies */
