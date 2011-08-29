Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1H2O4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:56:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:34467 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab1H2O4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:56:13 -0400
Date: Mon, 29 Aug 2011 14:55:20 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-c259e01a1ec90063042f758e409cd26b2a0963c8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, axboe@kernel.dk, a.p.zijlstra@chello.nl,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, axboe@kernel.dk, torvalds@linux-foundation.org,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110622174918.813258321@linutronix.de>
References: <20110622174918.813258321@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Separate the scheduler entry for preemption
Git-Commit-ID: c259e01a1ec90063042f758e409cd26b2a0963c8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Mon, 29 Aug 2011 14:55:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c259e01a1ec90063042f758e409cd26b2a0963c8
Gitweb:     http://git.kernel.org/tip/c259e01a1ec90063042f758e409cd26b2a0963c8
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 22 Jun 2011 19:47:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 29 Aug 2011 12:26:57 +0200

sched: Separate the scheduler entry for preemption

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
Cc: stable@kernel.org # 2.6.39+
Link: http://lkml.kernel.org/r/20110622174918.813258321@linutronix.de
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ccacdbd..ec15e81 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4279,9 +4279,9 @@ pick_next_task(struct rq *rq)
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
@@ -4369,6 +4369,11 @@ need_resched:
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
@@ -4435,7 +4440,7 @@ asmlinkage void __sched notrace preempt_schedule(void)
 
 	do {
 		add_preempt_count_notrace(PREEMPT_ACTIVE);
-		schedule();
+		__schedule();
 		sub_preempt_count_notrace(PREEMPT_ACTIVE);
 
 		/*
@@ -4463,7 +4468,7 @@ asmlinkage void __sched preempt_schedule_irq(void)
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
 		local_irq_enable();
-		schedule();
+		__schedule();
 		local_irq_disable();
 		sub_preempt_count(PREEMPT_ACTIVE);
 
@@ -5588,7 +5593,7 @@ static inline int should_resched(void)
 static void __cond_resched(void)
 {
 	add_preempt_count(PREEMPT_ACTIVE);
-	schedule();
+	__schedule();
 	sub_preempt_count(PREEMPT_ACTIVE);
 }
 
