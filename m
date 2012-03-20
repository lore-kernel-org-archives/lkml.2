Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897Ab2CTMRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 08:17:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43139 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759863Ab2CTMRe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 08:17:34 -0400
Message-ID: <1332245842.18960.413.camel@twins>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
From: Peter Zijlstra <peterz@infradead.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Date: Tue, 20 Mar 2012 13:17:22 +0100
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A05A6BF@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
	 <1331546307.18960.26.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com>
	 <1331654251.18960.78.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com>
	 <1331718197.18960.106.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com>
	 <1331808391.18960.160.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05806B@SHSMSX101.ccr.corp.intel.com>
	 <1331891364.18960.221.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A058AAE@SHSMSX101.ccr.corp.intel.com>
	 <1332151397.18960.252.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05A6BF@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 00:22 +0000, Liu, Chuansheng wrote:
> Thanks to give some time to have a look.
> 
Does the below on top of current tip/master work?
> 
---
 include/linux/cpuset.h |    6 +---
 kernel/cpuset.c        |   20 +++------------
 kernel/sched/core.c    |   62 +++++++++++++++++++++++++++++++++++------------
 3 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index e9eaec5..e0ffaf0 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -22,7 +22,7 @@ extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_update_active_cpus(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
-extern int cpuset_cpus_allowed_fallback(struct task_struct *p);
+extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -144,10 +144,8 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
 	cpumask_copy(mask, cpu_possible_mask);
 }
 
-static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
+static inline void cpuset_cpus_allowed_fallback(struct task_struct *p)
 {
-	do_set_cpus_allowed(p, cpu_possible_mask);
-	return cpumask_any(cpu_active_mask);
 }
 
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index a09ac2b..c9837b7 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2195,7 +2195,7 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 	mutex_unlock(&callback_mutex);
 }
 
-int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
+void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 {
 	const struct cpuset *cs;
 	int cpu;
@@ -2219,22 +2219,10 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 	 * changes in tsk_cs()->cpus_allowed. Otherwise we can temporary
 	 * set any mask even if it is not right from task_cs() pov,
 	 * the pending set_cpus_allowed_ptr() will fix things.
+	 *
+	 * select_fallback_rq() will fix things ups and set cpu_possible_mask
+	 * if required.
 	 */
-
-	cpu = cpumask_any_and(&tsk->cpus_allowed, cpu_active_mask);
-	if (cpu >= nr_cpu_ids) {
-		/*
-		 * Either tsk->cpus_allowed is wrong (see above) or it
-		 * is actually empty. The latter case is only possible
-		 * if we are racing with remove_tasks_in_empty_cpuset().
-		 * Like above we can temporary set any mask and rely on
-		 * set_cpus_allowed_ptr() as synchronization point.
-		 */
-		do_set_cpus_allowed(tsk, cpu_possible_mask);
-		cpu = cpumask_any(cpu_active_mask);
-	}
-
-	return cpu;
 }
 
 void cpuset_init_current_mems_allowed(void)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e37c9af..04d3f7f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1263,29 +1263,59 @@ EXPORT_SYMBOL_GPL(kick_process);
  */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
-	int dest_cpu;
 	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
+	enum { cpuset, possible, fail } state = cpuset;
+	int dest_cpu;
 
 	/* Look for allowed, online CPU in same node. */
-	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
+	for_each_cpu_mask(dest_cpu, *nodemask) {
+		if (!cpu_online(dest_cpu))
+			continue;
+		if (!cpu_active(dest_cpu))
+			continue;
 		if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
 			return dest_cpu;
+	}
 
-	/* Any allowed, online CPU? */
-	dest_cpu = cpumask_any_and(tsk_cpus_allowed(p), cpu_active_mask);
-	if (dest_cpu < nr_cpu_ids)
-		return dest_cpu;
+	for (;;) {
+		/* Any allowed, online CPU? */
+		for_each_cpu_mask(dest_cpu, *tsk_cpus_allowed(p)) {
+			if (!cpu_online(dest_cpu))
+				continue;
+			if (!cpu_active(dest_cpu))
+				continue;
+			goto out;
+		}
 
-	/* No more Mr. Nice Guy. */
-	dest_cpu = cpuset_cpus_allowed_fallback(p);
-	/*
-	 * Don't tell them about moving exiting tasks or
-	 * kernel threads (both mm NULL), since they never
-	 * leave kernel.
-	 */
-	if (p->mm && printk_ratelimit()) {
-		printk_sched("process %d (%s) no longer affine to cpu%d\n",
-				task_pid_nr(p), p->comm, cpu);
+		switch (state) {
+		case cpuset:
+			/* No more Mr. Nice Guy. */
+			cpuset_cpus_allowed_fallback(p);
+			state = possible;
+			break;
+
+		case possible:
+			do_set_cpus_allowed(p, cpu_possible_mask);
+			state = fail;
+			break;
+
+		case fail:
+			BUG();
+			break;
+		}
+	}
+
+out:
+	if (state != cpuset) {
+		/*
+		 * Don't tell them about moving exiting tasks or
+		 * kernel threads (both mm NULL), since they never
+		 * leave kernel.
+		 */
+		if (p->mm && printk_ratelimit()) {
+			printk_sched("process %d (%s) no longer affine to cpu%d\n",
+					task_pid_nr(p), p->comm, cpu);
+		}
 	}
 
 	return dest_cpu;

