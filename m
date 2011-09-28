Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab1I1WlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:41:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729Ab1I1WlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:41:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:31 2011
Message-Id: <20110928220131.674180699@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@elte.hu>
Subject: [061/244] sched: Separate the scheduler entry for preemption
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit c259e01a1ec90063042f758e409cd26b2a0963c8 upstream.

Block-IO and workqueues call into notifier functions from the
scheduler core code with interrupts and preemption disabled. These
calls should be made before entering the scheduler core.

To simplify this, separate the scheduler core code into
__schedule(). __schedule() is directly called from the places which
set PREEMPT_ACTIVE and from schedule(). This allows us to add the work
checks into schedule(), so they are only called when a task voluntary
goes to sleep.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110622174918.813258321@linutronix.de
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4242,9 +4242,9 @@ pick_next_task(struct rq *rq)
 }
 
 /*
- * schedule() is the main scheduler function.
+ * __schedule() is the main scheduler function.
  */
-asmlinkage void __sched schedule(void)
+static void __sched __schedule(void)
 {
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
@@ -4332,6 +4332,11 @@ need_resched:
 	if (need_resched())
 		goto need_resched;
 }
+
+asmlinkage void schedule(void)
+{
+	__schedule();
+}
 EXPORT_SYMBOL(schedule);
 
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
@@ -4405,7 +4410,7 @@ asmlinkage void __sched notrace preempt_
 
 	do {
 		add_preempt_count_notrace(PREEMPT_ACTIVE);
-		schedule();
+		__schedule();
 		sub_preempt_count_notrace(PREEMPT_ACTIVE);
 
 		/*
@@ -4433,7 +4438,7 @@ asmlinkage void __sched preempt_schedule
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
 		local_irq_enable();
-		schedule();
+		__schedule();
 		local_irq_disable();
 		sub_preempt_count(PREEMPT_ACTIVE);
 
@@ -5558,7 +5563,7 @@ static inline int should_resched(void)
 static void __cond_resched(void)
 {
 	add_preempt_count(PREEMPT_ACTIVE);
-	schedule();
+	__schedule();
 	sub_preempt_count(PREEMPT_ACTIVE);
 }
 


