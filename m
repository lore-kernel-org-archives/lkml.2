Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab2LBBH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 20:07:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41737 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab2LBBH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 20:07:58 -0500
Date: Sat, 1 Dec 2012 17:07:51 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <mgalbraith@suse.de>,
        Anders Kaseorg <andersk@MIT.EDU>,
        Zlatko Calusic <zlatko.calusic@iskon.hr>,
        Joonsoo Kim <js1304@gmail.com>
Subject: [GIT PULL] workqueue fixes for 3.7-rc7
Message-ID: <20121202010751.GD2685@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Unfortunately, I have two really late fixes.  One was for a
long-standing bug and queued for 3.8 but I found out about a
regression introduced during 3.7-rc1 two days ago, so I'm sending out
the two fixes together.

The first (long-standing) one is rescuer_thread() entering exit path
w/ TASK_INTERRUPTIBLE.  It only triggers on workqueue destructions
which isn't very frequent and the exit path can usually survive being
called with TASK_INTERRUPT, so it was hidden pretty well.  Apparently,
if you're reiserfs, this could lead to the exiting kthread sleeping
indefinitely holding a mutex, which is never good.  The fix is simple
- restoring TASK_RUNNING before returning from the kthread function.

The second one is introduced by the new mod_delayed_work().
mod_delayed_work() was missing special case handling for 0 delay.
Instead of queueing the work item immediately, it queued the timer
which expires on the closest next tick.  Some users of the new
function converted from "[__]cancel_delayed_work() +
queue_delayed_work()" combination became unhappy with the extra delay.
Block unplugging led to noticeably higher number of context switches
and intel 6250 wireless failed to associate with WPA-Enterprise
network.  The fix, again, is fairly simple.  The 0 delay special case
logic from queue_delayed_work_on() should be moved to
__queue_delayed_work() which is shared by both queue_delayed_work_on()
and mod_delayed_work_on().

The first one is difficult to trigger and the failure mode for the
latter isn't completely catastrophic, so missing these two for 3.7
wouldn't make it a disastrous release, but both bugs are nasty and the
fixes are fairly safe, so please consider pulling the following
branch.

   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.7-fixes

Thanks.
---
Mike Galbraith (1):
      workqueue: exit rescuer_thread() as TASK_RUNNING

Tejun Heo (1):
      workqueue: mod_delayed_work_on() shouldn't queue timer on 0 delay

 kernel/workqueue.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 042d221..084aa47 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1364,6 +1364,17 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 	BUG_ON(timer_pending(timer));
 	BUG_ON(!list_empty(&work->entry));
 
+	/*
+	 * If @delay is 0, queue @dwork->work immediately.  This is for
+	 * both optimization and correctness.  The earliest @timer can
+	 * expire is on the closest next tick and delayed_work users depend
+	 * on that there's no such delay when @delay is 0.
+	 */
+	if (!delay) {
+		__queue_work(cpu, wq, &dwork->work);
+		return;
+	}
+
 	timer_stats_timer_set_start_info(&dwork->timer);
 
 	/*
@@ -1417,9 +1428,6 @@ bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	bool ret = false;
 	unsigned long flags;
 
-	if (!delay)
-		return queue_work_on(cpu, wq, &dwork->work);
-
 	/* read the comment in __queue_work() */
 	local_irq_save(flags);
 
@@ -2407,8 +2415,10 @@ static int rescuer_thread(void *__wq)
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	if (kthread_should_stop())
+	if (kthread_should_stop()) {
+		__set_current_state(TASK_RUNNING);
 		return 0;
+	}
 
 	/*
 	 * See whether any cpu is asking for help.  Unbounded
