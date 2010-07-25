Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab0GYIaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:30:10 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49910 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0GYI3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:29:51 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCHv5 09/15] writeback: restructure bdi forker loop a little
Date: Sun, 25 Jul 2010 11:29:35 +0300
Message-Id: <1280046581-23623-10-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
References: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 Jul 2010 08:29:46.0784 (UTC) FILETIME=[8A419A00:01CB2BD3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This patch re-structures the bdi forker a little:
1. Add 'bdi_cap_flush_forker(bdi)' condition check to the bdi loop. The reason
   for this is that the forker thread can start _before_ the 'BDI_registered'
   flag is set (see 'bdi_register()'), so the WARN() statement will fire for
   the default bdi. I observed this warning at boot-up.

2. Introduce an enum 'action' and use "switch" statement in the outer loop.
   This is a preparation to the further patch which will teach the forker
   thread killing bdi threads, so we'll have another case in the "switch"
   statement. This change was suggested by Christoph Hellwig.

This patch is just a small step towards the coming change where the forker
thread will kill the bdi threads. It should simplify reviewing the following
changes, which would otherwise be larger.

This patch also amends comments a little.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mm/backing-dev.c |   69 ++++++++++++++++++++++++++++++-----------------------
 1 files changed, 39 insertions(+), 30 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 672c17b..e104e32 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -329,9 +329,12 @@ static int bdi_forker_thread(void *ptr)
 	set_user_nice(current, 0);
 
 	for (;;) {
-		bool fork = false;
 		struct task_struct *task;
 		struct backing_dev_info *bdi;
+		enum {
+			NO_ACTION,   /* Nothing to do */
+			FORK_THREAD, /* Fork bdi thread */
+		} action = NO_ACTION;
 
 		/*
 		 * Temporary measure, we want to make sure we don't see
@@ -348,25 +351,31 @@ static int bdi_forker_thread(void *ptr)
 		 * a thread registered. If so, set that up.
 		 */
 		list_for_each_entry(bdi, &bdi_list, bdi_list) {
-			if (!bdi_cap_writeback_dirty(bdi))
-				continue;
-			if (bdi->wb.task)
-				continue;
-			if (list_empty(&bdi->work_list) &&
-			    !bdi_has_dirty_io(bdi))
+			bool have_dirty_io;
+
+			if (!bdi_cap_writeback_dirty(bdi) ||
+			     bdi_cap_flush_forker(bdi))
 				continue;
 
 			WARN(!test_bit(BDI_registered, &bdi->state),
 			     "bdi %p/%s is not registered!\n", bdi, bdi->name);
 
-			fork = true;
+			have_dirty_io = !list_empty(&bdi->work_list) ||
+					wb_has_dirty_io(&bdi->wb);
 
 			/*
-			 * Set the pending bit - if someone will try to
-			 * unregister this bdi - it'll wait on this bit.
+			 * If the bdi has work to do, but the thread does not
+			 * exist - create it.
 			 */
-			set_bit(BDI_pending, &bdi->state);
-			break;
+			if (!bdi->wb.task && have_dirty_io) {
+				/*
+				 * Set the pending bit - if someone will try to
+				 * unregister this bdi - it'll wait on this bit.
+				 */
+				set_bit(BDI_pending, &bdi->state);
+				action = FORK_THREAD;
+				break;
+			}
 		}
 		spin_unlock_bh(&bdi_lock);
 
@@ -374,30 +383,30 @@ static int bdi_forker_thread(void *ptr)
 		if (!list_empty(&me->bdi->work_list))
 			__set_current_state(TASK_RUNNING);
 
-		if (!fork) {
-			unsigned long wait;
+		switch (action) {
+		case FORK_THREAD:
+			__set_current_state(TASK_RUNNING);
+			task = kthread_run(bdi_writeback_thread, &bdi->wb, "flush-%s",
+					   dev_name(bdi->dev));
+			if (IS_ERR(task)) {
+				/*
+				 * If thread creation fails, force writeout of
+				 * the bdi from the thread.
+				 */
+				bdi_flush_io(bdi);
+			} else
+				bdi->wb.task = task;
+			break;
 
-			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
-			if (wait)
-				schedule_timeout(wait);
+		case NO_ACTION:
+			if (dirty_writeback_interval)
+				schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
 			else
 				schedule();
 			try_to_freeze();
+			/* Back to the main loop */
 			continue;
 		}
-
-		__set_current_state(TASK_RUNNING);
-
-		task = kthread_run(bdi_writeback_thread, &bdi->wb, "flush-%s",
-				   dev_name(bdi->dev));
-		if (IS_ERR(task)) {
-			/*
-			 * If thread creation fails, force writeout of the bdi
-			 * from the thread.
-			 */
-			bdi_flush_io(bdi);
-		} else
-			bdi->wb.task = task;
 	}
 
 	return 0;
-- 
1.7.1.1

