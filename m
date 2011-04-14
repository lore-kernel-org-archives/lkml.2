Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1DNIgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:36:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:49691 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758571Ab1DNIgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:36:51 -0400
Date: Thu, 14 Apr 2011 08:36:23 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-2acca55ed98ad9b9aa25e7e587ebe306c0313dc7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152729.192366907@chello.nl>
References: <20110405152729.192366907@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Also serialize ttwu_local() with p->pi_lock
Git-Commit-ID: 2acca55ed98ad9b9aa25e7e587ebe306c0313dc7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:36:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2acca55ed98ad9b9aa25e7e587ebe306c0313dc7
Gitweb:     http://git.kernel.org/tip/2acca55ed98ad9b9aa25e7e587ebe306c0313dc7
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:50 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:37 +0200

sched: Also serialize ttwu_local() with p->pi_lock

Since we now serialize ttwu() using p->pi_lock, we also need to
serialize ttwu_local() using that, otherwise, once we drop the
rq->lock from ttwu() it can race with ttwu_local().

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110405152729.192366907@chello.nl
---
 kernel/sched.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index fd32b78..6b269b7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2566,9 +2566,9 @@ out:
  * try_to_wake_up_local - try to wake up a local task with rq lock held
  * @p: the thread to be awakened
  *
- * Put @p on the run-queue if it's not already there.  The caller must
+ * Put @p on the run-queue if it's not already there. The caller must
  * ensure that this_rq() is locked, @p is bound to this_rq() and not
- * the current task.  this_rq() stays locked over invocation.
+ * the current task.
  */
 static void try_to_wake_up_local(struct task_struct *p)
 {
@@ -2578,14 +2578,22 @@ static void try_to_wake_up_local(struct task_struct *p)
 	BUG_ON(p == current);
 	lockdep_assert_held(&rq->lock);
 
+	if (!raw_spin_trylock(&p->pi_lock)) {
+		raw_spin_unlock(&rq->lock);
+		raw_spin_lock(&p->pi_lock);
+		raw_spin_lock(&rq->lock);
+	}
+
 	if (!(p->state & TASK_NORMAL))
-		return;
+		goto out;
 
 	if (!p->on_rq)
 		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
 
 	ttwu_post_activation(p, rq, 0);
 	ttwu_stat(rq, p, smp_processor_id(), 0);
+out:
+	raw_spin_unlock(&p->pi_lock);
 }
 
 /**
@@ -4114,11 +4122,13 @@ need_resched:
 		if (unlikely(signal_pending_state(prev->state, prev))) {
 			prev->state = TASK_RUNNING;
 		} else {
+			deactivate_task(rq, prev, DEQUEUE_SLEEP);
+			prev->on_rq = 0;
+
 			/*
-			 * If a worker is going to sleep, notify and
-			 * ask workqueue whether it wants to wake up a
-			 * task to maintain concurrency.  If so, wake
-			 * up the task.
+			 * If a worker went to sleep, notify and ask workqueue
+			 * whether it wants to wake up a task to maintain
+			 * concurrency.
 			 */
 			if (prev->flags & PF_WQ_WORKER) {
 				struct task_struct *to_wakeup;
@@ -4128,12 +4138,9 @@ need_resched:
 					try_to_wake_up_local(to_wakeup);
 			}
 
-			deactivate_task(rq, prev, DEQUEUE_SLEEP);
-			prev->on_rq = 0;
-
 			/*
-			 * If we are going to sleep and we have plugged IO queued, make
-			 * sure to submit it to avoid deadlocks.
+			 * If we are going to sleep and we have plugged IO
+			 * queued, make sure to submit it to avoid deadlocks.
 			 */
 			if (blk_needs_flush_plug(prev)) {
 				raw_spin_unlock(&rq->lock);
