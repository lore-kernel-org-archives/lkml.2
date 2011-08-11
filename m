Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab1HKSFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:05:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51563 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1HKSFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:05:51 -0400
Subject: Re: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Sander <tim.sander@hbm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>
Date: Thu, 11 Aug 2011 20:05:25 +0200
References: <1312580681.28695.44.camel@twins>
	 <201108111330.28168.tim.sander@hbm.com> <1313066498.8491.1.camel@twins>
	 <201108111804.11136.tim.sander@hbm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313085926.8491.8.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 18:14 +0200, Peter Zijlstra wrote:
> On Thu, 2011-08-11 at 18:04 +0200, Tim Sander wrote:
> > 
> > kernel BUG at kernel/posix-cpu-timers.c:1315!
> > Unable to handle kernel NULL pointer dereference at virtual address 00000000
> > pgd = c0004000
> > [00000000] *pgd=00000000
> > Internal error: Oops: 817 [#1] PREEMPT
> > Modules linked in: i2c_imx(+) netx netx_reset dspload fpgaload mxc_nand(+) nand nand_ids nand_ecc
> > CPU: 0    Not tainted  (3.0.0-pmx-rt8-00009-g39305ab #167)
> > PC is at __bug+0x24/0x30
> > LR is at walk_stackframe+0x24/0x40
> > pc : [<c002cbf0>]    lr : [<c002cbb0>]    psr: 60000113
> > sp : c782ff40  ip : c782fe28  fp : c782ff4c
> > r10: 00000001  r9 : 00000000  r8 : c78663c0
> > r7 : c030463c  r6 : c782e000  r5 : 00000000  r4 : c78663c0
> > r3 : 00000000  r2 : 00000001  r1 : c782fe58  r0 : 00000034
> > Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> > Control: 00c5387d  Table: 87b70008  DAC: 00000017
> > Process posixcputmr/0 (pid: 6, stack limit = 0xc782e268)
> > Stack: (0xc782ff40 to 0xc7830000)
> > ff40: c782ff8c c782ff50 c005a5c0 c002cbd8 00000000 c782ff54 c782ff54 00000000
> > ff60: 00000000 c78663c0 00000000 c782e000 c030463c c78663c0 00000000 00000001
> > ff80: c782ffbc c782ff90 c005a88c c005a594 00000000 c7817f28 00000000 c782ffcc
> > ffa0: c005a800 00000000 00000000 00000000 c782fff4 c782ffc0 c00570f0 c005a80c
> > ffc0: c7817f28 00000000 00000000 00000000 c782ffd0 c782ffd0 c7817f28 c0057064
> > ffe0: c0040868 00000013 00000000 c782fff8 c0040868 c0057070 cccdcd6c ffdec890
> > Backtrace: 
> > [<c002cbcc>] (__bug+0x0/0x30) from [<c005a5c0>] (__run_posix_cpu_timers+0x38/0x278)
> > [<c005a588>] (__run_posix_cpu_timers+0x0/0x278) from [<c005a88c>] (posix_cpu_timers_thread+0x8c/0x124)
> > [<c005a800>] (posix_cpu_timers_thread+0x0/0x124) from [<c00570f0>] (kthread+0x8c/0x94)
> > [<c0057064>] (kthread+0x0/0x94) from [<c0040868>] (do_exit+0x0/0x2d8)
> >  r7:00000013 r6:c0040868 r5:c0057064 r4:c7817f28
> > Code: e59f0010 e1a01003 eb086a88 e3a03000 (e5833000) 
> > ---[ end trace d632afeaa11559d4 ]--- 
> 
> Yay a new one, and this is a PREEMPT_LL build right? /me goes poke at
> it.

---
Subject: posix-cpu-timer: Fixup PREEMPT_LL build
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Aug 11 19:18:23 CEST 2011


Cc: john stultz <johnstul@us.ibm.com>
Reported-by: Tim Sander <tim.sander@hbm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/init_task.h |    8 +++++++-
 include/linux/sched.h     |    2 ++
 kernel/fork.c             |    2 ++
 kernel/posix-cpu-timers.c |   24 ++++++++++++++++--------
 4 files changed, 27 insertions(+), 9 deletions(-)

Index: linux-2.6/include/linux/init_task.h
===================================================================
--- linux-2.6.orig/include/linux/init_task.h
+++ linux-2.6/include/linux/init_task.h
@@ -126,6 +126,12 @@ extern struct cred init_cred;
 # define INIT_PERF_EVENTS(tsk)
 #endif
 
+#ifdef CONFIG_PREEMPT_RT_BASE
+# define INIT_TIMER_LIST		.posix_timer_list = NULL,
+#else
+# define INIT_TIMER_LIST
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -179,7 +185,7 @@ extern struct cred init_cred;
 	.fs_excl	= ATOMIC_INIT(0),				\
 	.pi_lock	= __RAW_SPIN_LOCK_UNLOCKED(tsk.pi_lock),	\
 	.timer_slack_ns = 50000, /* 50 usec default slack */		\
-	.posix_timer_list = NULL,					\
+	INIT_TIMER_LIST							\
 	.pids = {							\
 		[PIDTYPE_PID]  = INIT_PID_LINK(PIDTYPE_PID),		\
 		[PIDTYPE_PGID] = INIT_PID_LINK(PIDTYPE_PGID),		\
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1364,7 +1364,9 @@ struct task_struct {
 
 	struct task_cputime cputime_expires;
 	struct list_head cpu_timers[3];
+#ifdef CONFIG_PREEMPT_RT_BASE
 	struct task_struct *posix_timer_list;
+#endif
 
 /* process credentials */
 	const struct cred __rcu *real_cred; /* objective and real subjective task
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -1054,7 +1054,9 @@ void mm_init_owner(struct mm_struct *mm,
  */
 static void posix_cpu_timers_init(struct task_struct *tsk)
 {
+#ifdef CONFIG_PREEMPT_RT_BASE
 	tsk->posix_timer_list = NULL;
+#endif
 	tsk->cputime_expires.prof_exp = cputime_zero;
 	tsk->cputime_expires.virt_exp = cputime_zero;
 	tsk->cputime_expires.sched_exp = 0;
Index: linux-2.6/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6.orig/kernel/posix-cpu-timers.c
+++ linux-2.6/kernel/posix-cpu-timers.c
@@ -1370,6 +1370,7 @@ static void __run_posix_cpu_timers(struc
 	}
 }
 
+#ifdef CONFIG_PREEMPT_RT_BASE
 #include <linux/kthread.h>
 #include <linux/cpu.h>
 DEFINE_PER_CPU(struct task_struct *, posix_timer_task);
@@ -1532,14 +1533,26 @@ static struct notifier_block __devinitda
 
 static int __init posix_cpu_thread_init(void)
 {
-	void *cpu = (void *)(long)smp_processor_id();
+	void *hcpu = (void *)(long)smp_processor_id();
 	/* Start one for boot CPU. */
-	posix_cpu_thread_call(&posix_cpu_thread_notifier, CPU_UP_PREPARE, cpu);
-	posix_cpu_thread_call(&posix_cpu_thread_notifier, CPU_ONLINE, cpu);
+	unsigned long cpu;
+
+	/* init the per-cpu posix_timer_tasklets */
+	for_each_cpu_mask(cpu, cpu_possible_map)
+		per_cpu(posix_timer_tasklist, cpu) = NULL;
+
+	posix_cpu_thread_call(&posix_cpu_thread_notifier, CPU_UP_PREPARE, hcpu);
+	posix_cpu_thread_call(&posix_cpu_thread_notifier, CPU_ONLINE, hcpu);
 	register_cpu_notifier(&posix_cpu_thread_notifier);
 	return 0;
 }
 early_initcall(posix_cpu_thread_init);
+#else /* CONFIG_PREEMPT_RT_BASE */
+void run_posix_cpu_timers(struct task_struct *tsk)
+{
+	__run_posix_cpu_timers(tsk);
+}
+#endif /* CONFIG_PREEMPT_RT_BASE */
 
 /*
  * Set one of the process-wide special case CPU timers or RLIMIT_CPU.
@@ -1789,11 +1802,6 @@ static __init int init_posix_cpu_timers(
 		.timer_create	= thread_cpu_timer_create,
 	};
 	struct timespec ts;
-	unsigned long cpu;
-
-	/* init the per-cpu posix_timer_tasklets */
-	for_each_cpu_mask(cpu, cpu_possible_map)
-		per_cpu(posix_timer_tasklist, cpu) = NULL;
 
 	posix_timers_register_clock(CLOCK_PROCESS_CPUTIME_ID, &process);
 	posix_timers_register_clock(CLOCK_THREAD_CPUTIME_ID, &thread);

