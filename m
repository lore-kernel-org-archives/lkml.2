Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0EWJH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 05:07:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:54208 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751796Ab0EWJHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 05:07:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18g0qY6fKcgAsrqJIayd5WfAOH7XUdpBKzZ7o5gFO
	PAG5CpdhdrEaMx
Subject: Re: [PATCH v2] Make sure timers have migrated before killing
 migration_thread
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1274340483.5605.13161.camel@twins>
References: <20100519090557.GA15237@amitarora.in.ibm.com>
	 <1274261515.5605.10423.camel@twins>
	 <20100519121356.GB15237@amitarora.in.ibm.com>
	 <1274340483.5605.13161.camel@twins>
Content-Type: text/plain
Date: Sun, 23 May 2010 11:07:18 +0200
Message-Id: <1274605638.9340.25.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 09:28 +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-19 at 17:43 +0530, Amit K. Arora wrote:
> > Alternate Solution considered : Another option considered was to
> > increase the priority of the hrtimer cpu offline notifier, such that it
> > gets to run before scheduler's migration cpu offline notifier. In this
> > way we are sure that the timers will get migrated before migration_call
> > tries to kill migration_thread. But, this can have some non-obvious
> > implications, suggested Srivatsa.
> 
> 
> > On Wed, May 19, 2010 at 11:31:55AM +0200, Peter Zijlstra wrote:
> > > The other problem is more urgent though, CPU_POST_DEAD runs outside of
> > > the hotplug lock and thus the above becomes a race where we could
> > > possible kill off the migration thread of a newly brought up cpu:
> > > 
> > >  cpu0 - down 2
> > >  cpu1 - up 2 (allocs a new migration thread, and leaks the old one)
> > >  cpu0 - post_down 2 - frees the migration thread -- oops!
> > 
> > Ok. So, how about adding a check in CPU_UP_PREPARE event handling too ?
> > The cpuset_lock will synchronize, and thus avoid race between killing of
> > migration_thread in up_prepare and post_dead events. 
> > 
> > Here is the updated patch. If you don't like this one too, do you mind
> > suggesting an alternate approach to tackle the problem ? Thanks !
> 
> Right, so this isn't pretty at all..

Since the problem seems to stem from interfering with a critical thread,
how about create a SCHED_SYSTEM_CRITICAL flag ala SCHED_RESET_ON_FORK?

Not particularly beautiful, and completely untested (well, it compiles).

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6cc43e0..23da2cf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -40,6 +40,8 @@
 #define SCHED_IDLE		5
 /* Can be ORed in to make sure the process is reverted back to SCHED_NORMAL on fork */
 #define SCHED_RESET_ON_FORK     0x40000000
+/* Can be ORed in to flag a thread as being system critical.  Not inherited. */
+#define SCHED_SYSTEM_CRITICAL	0x20000000
 
 #ifdef __KERNEL__
 
@@ -1240,6 +1242,9 @@ struct task_struct {
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
 
+	/* System critical thread.  Cleared on fork. */
+	unsigned sched_system_critical:1;
+
 	pid_t pid;
 	pid_t tgid;
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 2d17e3b..caf8b95 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2511,6 +2511,11 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	 */
 	p->prio = current->normal_prio;
 
+	/*
+	 * System critical policy flag is not inherited.
+	 */
+	p->sched_system_critical = 0;
+
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
@@ -4486,7 +4491,7 @@ static int __sched_setscheduler(struct task_struct *p, int policy,
 	unsigned long flags;
 	const struct sched_class *prev_class;
 	struct rq *rq;
-	int reset_on_fork;
+	int reset_on_fork, system_critical;
 
 	/* may grab non-irq protected spin_locks */
 	BUG_ON(in_interrupt());
@@ -4494,10 +4499,12 @@ recheck:
 	/* double check policy once rq lock held */
 	if (policy < 0) {
 		reset_on_fork = p->sched_reset_on_fork;
+		system_critical = p->sched_system_critical;
 		policy = oldpolicy = p->policy;
 	} else {
 		reset_on_fork = !!(policy & SCHED_RESET_ON_FORK);
-		policy &= ~SCHED_RESET_ON_FORK;
+		system_critical = !!(policy & SCHED_SYSTEM_CRITICAL);
+		policy &= ~(SCHED_RESET_ON_FORK|SCHED_SYSTEM_CRITICAL);
 
 		if (policy != SCHED_FIFO && policy != SCHED_RR &&
 				policy != SCHED_NORMAL && policy != SCHED_BATCH &&
@@ -4552,6 +4559,10 @@ recheck:
 		/* Normal users shall not reset the sched_reset_on_fork flag */
 		if (p->sched_reset_on_fork && !reset_on_fork)
 			return -EPERM;
+
+		/* Normal users shall not reset the sched_system_critical flag */
+		if (p->sched_system_critical && !system_critical)
+			return -EPERM;
 	}
 
 	if (user) {
@@ -4560,7 +4571,7 @@ recheck:
 		 * Do not allow realtime tasks into groups that have no runtime
 		 * assigned.
 		 */
-		if (rt_bandwidth_enabled() && rt_policy(policy) &&
+		if (rt_bandwidth_enabled() && rt_policy(policy) && !system_critical &&
 				task_group(p)->rt_bandwidth.rt_runtime == 0)
 			return -EPERM;
 #endif
@@ -4595,6 +4606,7 @@ recheck:
 		p->sched_class->put_prev_task(rq, p);
 
 	p->sched_reset_on_fork = reset_on_fork;
+	p->sched_system_critical = system_critical;
 
 	oldprio = p->prio;
 	prev_class = p->sched_class;
@@ -4712,9 +4724,13 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
 	p = find_process_by_pid(pid);
 	if (p) {
 		retval = security_task_getscheduler(p);
-		if (!retval)
-			retval = p->policy
-				| (p->sched_reset_on_fork ? SCHED_RESET_ON_FORK : 0);
+		if (!retval) {
+			retval = p->policy;
+			if (p->sched_reset_on_fork)
+				retval |= SCHED_RESET_ON_FORK;
+			if (p->sched_system_critical)
+				retval |= SCHED_SYSTEM_CRITICAL;
+		}
 	}
 	rcu_read_unlock();
 	return retval;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 8afb953..4fb5ced 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -605,6 +605,7 @@ static void update_curr_rt(struct rq *rq)
 	struct sched_rt_entity *rt_se = &curr->rt;
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	u64 delta_exec;
+	int system_critical = curr->sched_system_critical;
 
 	if (!task_has_rt_policy(curr))
 		return;
@@ -621,9 +622,13 @@ static void update_curr_rt(struct rq *rq)
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
 
-	sched_rt_avg_update(rq, delta_exec);
+	/*
+	 * System critical tasks do not contribute to bandwidth consumption,
+	 * nor are they evicted when runtime is exceeded.
+	 */
+	sched_rt_avg_update(rq, system_critical ? 0 : delta_exec);
 
-	if (!rt_bandwidth_enabled())
+	if (!rt_bandwidth_enabled() || system_critical)
 		return;
 
 	for_each_sched_rt_entity(rt_se) {
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index b4e7431..6cbea9a 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -304,7 +304,7 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 				   cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
+		sched_setscheduler_nocheck(p, SCHED_FIFO|SCHED_SYSTEM_CRITICAL, &param);
 		get_task_struct(p);
 		stopper->thread = p;
 		break;


