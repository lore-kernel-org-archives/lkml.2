Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab0LPTgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 14:36:39 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:56700 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0LPTgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 14:36:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RSJuMSFRxDfJHn4f1NAWpNBYW3hjEzO2MjPZheHMEe5rysAoiTmhZmj/062QTXHq2t
         x8fFsGFwD4ZUkksnwbZDD7SgwSVpYBjGwcCUUbBG/i/qcNGilFLnmLLi4tQba81OssgE
         JoJpaTKm2K+3KtkL4YFkQqqtADJ4fpX51bqac=
Message-ID: <4D0A6A40.2040907@am.sony.com>
Date: Thu, 16 Dec 2010 11:36:32 -0800
From: Frank Rowand <frank.rowand@gmail.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: frank.rowand@am.sony.com, frank.rowand@gmail.com
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/5] Reduce runqueue lock contention -v2
References: <20101216145602.899838254@chello.nl> <4D0A649B.9080505@am.sony.com>
In-Reply-To: <4D0A649B.9080505@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



patch 1 of 2

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>

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
@@ -1193,6 +1194,8 @@ struct task_struct {
 	int lock_depth;		/* BKL lock depth */
 
 #ifdef CONFIG_SMP
+	struct task_struct *ttwu_queue_wake_entry;
+	int ttwu_queue_wake_flags;
 #ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	int oncpu;
 #endif
@@ -2017,6 +2020,7 @@ extern void release_uids(struct user_nam
 
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
@@ -2332,6 +2334,28 @@ static inline void ttwu_post_activation(
 		wq_worker_waking_up(p, cpu_of(rq));
 }
 
+#ifdef CONFIG_SMP
+static void ttwu_queue_wake_up(struct task_struct *p, int cpu, int wake_flags)
+{
+	struct task_struct *next = NULL;
+	struct rq *rq = cpu_rq(cpu);
+
+	p->ttwu_queue_wake_flags = wake_flags;
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
@@ -2350,20 +2374,88 @@ static inline void ttwu_post_activation(
 static int try_to_wake_up(struct task_struct *p, unsigned int state,
 			  int wake_flags)
 {
+/*
+ * xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
+ * todo
+ *  - pass waking cpu with queued wake up, to be used in call to
+ *    select_task_rq().
+ *  - handle cpu being offlined
+ * xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
+ */
 	int cpu, orig_cpu, this_cpu, success = 0;
 	unsigned long flags;
 	unsigned long en_flags = ENQUEUE_WAKEUP;
 	struct rq *rq;
+#ifdef CONFIG_SMP
+	int load;
+#endif
 
 	this_cpu = get_cpu();
 
-	smp_wmb();
-	rq = task_rq_lock(p, &flags);
-	if (!(p->state & state))
-		goto out;
+	local_irq_save(flags);
 
-	if (p->se.on_rq)
-		goto out_running;
+	for (;;) {
+		unsigned int task_state = p->state;
+
+		if (!(task_state & state))
+			goto out_nolock;
+		/*
+		 * task_contributes_to_load() tests p->state
+		 */
+		load = task_contributes_to_load(p);
+
+		if (cmpxchg(&p->state, task_state, TASK_WAKING) == task_state) {
+			if (state == TASK_WAKING)
+				load = wake_flags & WF_LOAD;
+			break;
+		}
+	}
+
+	/*
+	 * Avoid a possible cross cpu rq lock attempt until we know that a
+	 * lock must be acquired.  rq lock is to protect interaction with
+	 * schedule().
+	 *
+	 * p->state == TASK_WAKING protects against any other try_to_wake_up()
+	 * setting p->se.on_rq true after this test.
+	 */
+	if (unlikely(p->se.on_rq)) {
+		smp_wmb();
+		rq = __task_rq_lock(p);
+		if (p->se.on_rq)
+			goto out_running;
+		__task_rq_unlock(rq);
+	}
+
+#ifdef CONFIG_SMP
+	/*
+	 * If task_cpu(p) != this_cpu then the attempt to lock the rq on the
+	 * other cpu can result in rq lock contention.  Queueing this wake up
+	 * on the other cpu may reduce rq lock contention.
+	 *
+	 * All tests that could have led to returning 0 have been completed
+	 * before this point, return value will be 1.  The return value of
+	 * the try_to_wake_up() executed after unqueueing the wake request
+	 * can not be returned to the current caller, so have to know what
+	 * the return value of the queued request will be.
+	 */
+	cpu = task_cpu(p);
+	if (cpu != this_cpu) {
+		if (load)
+			wake_flags |= WF_LOAD;
+		ttwu_queue_wake_up(p, cpu, wake_flags);
+		success = 1;
+		goto out_nolock;
+	}
+#endif
+
+	/*
+	 * task_cpu(p) may have changed since it was checked since rq->lock
+	 * is not held.  Thus may still end up with cross cpu rq lock
+	 * contention.  Encountering this race should be very rare.
+	 */
+	smp_wmb();
+	rq = __task_rq_lock(p);
 
 	cpu = task_cpu(p);
 	orig_cpu = cpu;
@@ -2378,13 +2470,12 @@ static int try_to_wake_up(struct task_st
 	 *
 	 * First fix up the nr_uninterruptible count:
 	 */
-	if (task_contributes_to_load(p)) {
+	if (load) {
 		if (likely(cpu_online(orig_cpu)))
 			rq->nr_uninterruptible--;
 		else
 			this_rq()->nr_uninterruptible--;
 	}
-	p->state = TASK_WAKING;
 
 	if (p->sched_class->task_waking) {
 		p->sched_class->task_waking(rq, p);
@@ -2394,6 +2485,10 @@ static int try_to_wake_up(struct task_st
 	cpu = select_task_rq(rq, p, SD_BALANCE_WAKE, wake_flags);
 	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);
+	/*
+	 * Protected against concurrent wakeups while rq->lock released because
+	 * p is in TASK_WAKING state.
+	 */
 	__task_rq_unlock(rq);
 
 	rq = cpu_rq(cpu);
@@ -2430,13 +2525,30 @@ out_activate:
 	success = 1;
 out_running:
 	ttwu_post_activation(p, rq, wake_flags, success);
-out:
-	task_rq_unlock(rq, &flags);
+	__task_rq_unlock(rq);
+out_nolock:
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
