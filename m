Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1H2O4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:56:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:34495 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab1H2O4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:56:40 -0400
Date: Mon, 29 Aug 2011 14:55:52 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-dwfxtra7yg1b5r65m32ywtct@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, axboe@kernel.dk, a.p.zijlstra@chello.nl,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, axboe@kernel.dk, torvalds@linux-foundation.org,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Move blk_schedule_flush_plug() out of __schedule()
Git-Commit-ID: 9c40cef2b799f9b5e7fa5de4d2ad3a0168ba118c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Mon, 29 Aug 2011 14:56:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c40cef2b799f9b5e7fa5de4d2ad3a0168ba118c
Gitweb:     http://git.kernel.org/tip/9c40cef2b799f9b5e7fa5de4d2ad3a0168ba118c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 22 Jun 2011 19:47:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 29 Aug 2011 12:26:59 +0200

sched: Move blk_schedule_flush_plug() out of __schedule()

There is no real reason to run blk_schedule_flush_plug() with
interrupts and preemption disabled.

Move it into schedule() and call it when the task is going voluntarily
to sleep. There might be false positives when the task is woken
between that call and actually scheduling, but that's not really
different from being woken immediately after switching away.

This fixes a deadlock in the scheduler where the
blk_schedule_flush_plug() callchain enables interrupts and thereby
allows a wakeup to happen of the task that's going to sleep.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@kernel.org # 2.6.39+
Link: http://lkml.kernel.org/n/tip-dwfxtra7yg1b5r65m32ywtct@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ec15e81..511732c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4322,16 +4322,6 @@ need_resched:
 				if (to_wakeup)
 					try_to_wake_up_local(to_wakeup);
 			}
-
-			/*
-			 * If we are going to sleep and we have plugged IO
-			 * queued, make sure to submit it to avoid deadlocks.
-			 */
-			if (blk_needs_flush_plug(prev)) {
-				raw_spin_unlock(&rq->lock);
-				blk_schedule_flush_plug(prev);
-				raw_spin_lock(&rq->lock);
-			}
 		}
 		switch_count = &prev->nvcsw;
 	}
@@ -4370,8 +4360,23 @@ need_resched:
 		goto need_resched;
 }
 
+static inline void sched_submit_work(struct task_struct *tsk)
+{
+	if (!tsk->state)
+		return;
+	/*
+	 * If we are going to sleep and we have plugged IO queued,
+	 * make sure to submit it to avoid deadlocks.
+	 */
+	if (blk_needs_flush_plug(tsk))
+		blk_schedule_flush_plug(tsk);
+}
+
 asmlinkage void schedule(void)
 {
+	struct task_struct *tsk = current;
+
+	sched_submit_work(tsk);
 	__schedule();
 }
 EXPORT_SYMBOL(schedule);
