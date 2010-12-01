Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab0LAXN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 18:13:56 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:58395 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753581Ab0LAXNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 18:13:54 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2dK936eK1432N98dNef8K853kzz1202hzz8275bh8275dhz2fh2a8h691h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4CF6D694.4030003@am.sony.com>
Date: Wed, 1 Dec 2010 15:13:24 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        tglx <tglx@linutronix.de>
Subject: Re: [PATCH RFC] reduce runqueue lock contention
References: <20100520204810.GA19188@think>	 <1277114522.1875.469.camel@laptop> <1277117647.1875.503.camel@laptop>	 <1277125479.1875.510.camel@laptop> <1277213586.1875.704.camel@laptop>	 <20100622211141.GC21149@elte.hu> <1277284257.1875.820.camel@laptop>
In-Reply-To: <1277284257.1875.820.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/10 02:10, Peter Zijlstra wrote:
> On Tue, 2010-06-22 at 23:11 +0200, Ingo Molnar wrote:
>> * Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>> So this one boots and builds a kernel on a dual-socket nehalem.
>>>
>>> there's still quite a number of XXXs to fix, but I don't think any of the 
>>> races are crashing potential, mostly wrong accounting and scheduling iffies 
>>> like.
>>>
>>> But give it a go.. see what it does for you (x86 only for now).
>>>
>>> Ingo, any comments other than, eew, scary? :-)
>>
>> None, other than a question: which future kernel do you aim it for? I'd prefer 
>> v2.6.50 or later ;-)
> 
> Well, assuming it all works out and actually reduces runqueue lock
> contention we still need to sort out all those XXXs in there, I'd say at
> the soonest somewhere near .38/.39 or so.
> 
> Its definitely not something we should rush in.

This thread was started by Chris Mason back in May:
   http://lkml.indiana.edu/hypermail/linux/kernel/1005.2/02329.html

The problem he was trying to fix is:

> Many different workloads end
> up hammering very hard on try_to_wake_up, to the point where the
> runqueue locks dominate CPU profiles.
> 
> This includes benchmarking really fast IO subsystems, fast networking,
> fast pipes...well anywhere that we lots of procs on lots of cpus waiting
> for short periods on lots of different things.

Chris provided some code as a starting point for a solution.

Peter Zijlstra had some good ideas, and came up with some alternate code,
culminating with:

   http://lkml.indiana.edu/hypermail/linux/kernel/1006.2/02381.html

Building on this previous work, I have another patch to try to address
the problem.  I have taken some of Peter's code (the cmpxchg() based
queueing and unqueueing, plus the cross cpu interrupt), but taken a
simpler (and hopefully less scary) approach otherwise:

  If the task to be woken is on a run queue on a different cpu then use
  cmpxchg() to put it onto a pending try_to_wake_up list on the different
  cpu.  Then send an interrupt to the different cpu to cause that cpu to
  call try_to_wake_up() for each process on the try_to_wake_up list.

  The result is that the initial run queue lock acquired by try_to_wake_up()
  will be on the cpu we are currently executing on, not a different cpu.

  This patch does not address the run queue lock contention that may occur
  if try_to_wake_up() chooses to move the waking process to another cpu,
  based on the result returned by select_task_rq().

  The patch was created on the -top tree.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>


Chris, can you check the performance of this patch on your large system?


Limitations
  x86 only

Tests
  - tested on 2 cpu x86_64
  - very simplistic workload
  - results:
     rq->lock contention count reduced by ~ 95%
     rq->lock contention wait time reduced by ~ 90%
     test duration reduced by ~ 0.5% - 4% (in the noise)

Review goals:
  (1) performance results
  (2) architectural comments

Review non-goal:
  code style, etc (but will be a goal in a future review round)

Todo:
  - add support for additional architectures
  - polish code style
  - add a schedule feature to control whether to use the new algorithm
  - verify that smp_wmb() is implied by cmpxchg() on x86, so that the explicit
    smp_wmb() in ttwu_queue_wake_up() can be removed.

---
 arch/x86/kernel/smp.c |    1 	1 +	0 -	0 !
 include/linux/sched.h |    5 	5 +	0 -	0 !
 kernel/sched.c        |  105 	99 +	6 -	0 !
 3 files changed, 105 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smp.c
+++ linux-2.6/arch/x86/kernel/smp.c
@@ -205,6 +205,7 @@ void smp_reschedule_interrupt(struct pt_
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
+	sched_ttwu_pending();
 }
 
 void smp_call_function_interrupt(struct pt_regs *regs)
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1038,6 +1038,7 @@ struct sched_domain;
  */
 #define WF_SYNC		0x01		/* waker goes to sleep after wakup */
 #define WF_FORK		0x02		/* child wakeup after fork */
+#define WF_LOAD		0x04		/* for queued try_to_wake_up() */
 
 #define ENQUEUE_WAKEUP		1
 #define ENQUEUE_WAKING		2
@@ -1193,6 +1194,9 @@ struct task_struct {
 	int lock_depth;		/* BKL lock depth */
 
 #ifdef CONFIG_SMP
+	struct task_struct *ttwu_queue_wake_entry;
+	int ttwu_queue_load;
+	int ttwu_queue_wake_flags;
 #ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	int oncpu;
 #endif
@@ -2017,6 +2021,7 @@ extern void release_uids(struct user_nam
 
 extern void do_timer(unsigned long ticks);
 
+extern void sched_ttwu_pending(void);
 extern int wake_up_state(struct task_struct *tsk, unsigned int state);
 extern int wake_up_process(struct task_struct *tsk);
 extern void wake_up_new_task(struct task_struct *tsk,
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -515,6 +515,8 @@ struct rq {
 	u64 age_stamp;
 	u64 idle_stamp;
 	u64 avg_idle;
+
+	struct task_struct *wake_list;
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
@@ -2332,6 +2334,39 @@ static inline void ttwu_post_activation(
 		wq_worker_waking_up(p, cpu_of(rq));
 }
 
+#ifdef CONFIG_SMP
+static void ttwu_queue_wake_up(struct task_struct *p, int cpu, int wake_flags,
+			       int load)
+{
+	struct task_struct *next = NULL;
+	struct rq *rq = cpu_rq(cpu);
+
+	if (load)
+		wake_flags |= WF_LOAD;
+	p->ttwu_queue_load = load;
+	p->ttwu_queue_wake_flags = wake_flags;
+	/* xxx
+	 * smp_wmb() is implied by cmpxchg()
+	 * (see Documentation/memory-barriers.txt).
+	 * It is the case for arm.
+	 * I don't know about x86, so do it explicitly until I know for sure.
+	 */
+	smp_wmb();
+
+	for (;;) {
+		struct task_struct *old = next;
+
+		p->ttwu_queue_wake_entry = next;
+		next = cmpxchg(&rq->wake_list, old, p);
+		if (next == old)
+			break;
+	}
+
+	if (!next)
+		smp_send_reschedule(cpu);
+}
+#endif
+
 /**
  * try_to_wake_up - wake up a thread
  * @p: the thread to be awakened
@@ -2354,13 +2389,51 @@ static int try_to_wake_up(struct task_st
 	unsigned long flags;
 	unsigned long en_flags = ENQUEUE_WAKEUP;
 	struct rq *rq;
+#ifdef CONFIG_SMP
+	int load;
+#endif
 
 	this_cpu = get_cpu();
 
+	local_irq_save(flags);
+
+#ifdef CONFIG_SMP
+	for (;;) {
+		unsigned int task_state = p->state;
+
+		if (!(task_state & state))
+			goto out_nolock;
+
+		/*
+		 * We've got to store the contributes_to_load state before
+		 * modifying the task state.
+		 */
+		load = task_contributes_to_load(p);
+
+		if (cmpxchg(&p->state, task_state, TASK_WAKING) == task_state) {
+			if (state == TASK_WAKING)
+				load = (wake_flags & WF_LOAD) ? 1 : 0;
+			break;
+		}
+	}
+
+	/*
+	 * There is a race where task_cpu could be set to
+	 * this_cpu while task_state is TASK_WAKING?
+	 *
+	 * That's ok, the destination cpu will just send it back here when
+	 * it calls try_to_wake_up() of this process.
+	 */
+
+	cpu = task_cpu(p);
+	if (cpu != this_cpu) {
+		ttwu_queue_wake_up(p, cpu, wake_flags, load);
+		goto out_nolock;
+	}
+#endif
+
 	smp_wmb();
-	rq = task_rq_lock(p, &flags);
-	if (!(p->state & state))
-		goto out;
+	rq = __task_rq_lock(p);
 
 	if (p->se.on_rq)
 		goto out_running;
@@ -2373,18 +2446,16 @@ static int try_to_wake_up(struct task_st
 		goto out_activate;
 
 	/*
-	 * In order to handle concurrent wakeups and release the rq->lock
-	 * we put the task in TASK_WAKING state.
-	 *
-	 * First fix up the nr_uninterruptible count:
+	 * Can handle concurrent wakeups and release the rq->lock
+	 * since we put the task in TASK_WAKING state.
 	 */
-	if (task_contributes_to_load(p)) {
+
+	if (load) {
 		if (likely(cpu_online(orig_cpu)))
 			rq->nr_uninterruptible--;
 		else
 			this_rq()->nr_uninterruptible--;
 	}
-	p->state = TASK_WAKING;
 
 	if (p->sched_class->task_waking) {
 		p->sched_class->task_waking(rq, p);
@@ -2430,13 +2501,32 @@ out_activate:
 	success = 1;
 out_running:
 	ttwu_post_activation(p, rq, wake_flags, success);
-out:
-	task_rq_unlock(rq, &flags);
+	__task_rq_unlock(rq);
+#ifdef CONFIG_SMP
+out_nolock:
+#endif
+	local_irq_restore(flags);
 	put_cpu();
 
 	return success;
 }
 
+#ifdef CONFIG_SMP
+void sched_ttwu_pending(void)
+{
+	struct rq *rq = this_rq();
+	struct task_struct *p = xchg(&rq->wake_list, NULL);
+
+	if (!p)
+		return;
+
+	while (p) {
+		try_to_wake_up(p, TASK_WAKING, p->ttwu_queue_wake_flags);
+		p = p->ttwu_queue_wake_entry;
+	}
+}
+#endif
+
 /**
  * try_to_wake_up_local - try to wake up a local task with rq lock held
  * @p: the thread to be awakened

