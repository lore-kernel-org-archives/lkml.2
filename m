Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab1I1Wlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:41:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab1I1Wlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:41:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:31 2011
Message-Id: <20110928220131.778186763@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@elte.hu>
Subject: [062/244] sched: Move blk_schedule_flush_plug() out of __schedule()
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 9c40cef2b799f9b5e7fa5de4d2ad3a0168ba118c upstream.

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
Link: http://lkml.kernel.org/n/tip-dwfxtra7yg1b5r65m32ywtct@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4285,16 +4285,6 @@ need_resched:
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
@@ -4333,8 +4323,23 @@ need_resched:
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


