Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab1IBWyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 18:54:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506Ab1IBWy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 18:54:28 -0400
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] mm: Cleanup clearing of BDI_pending bit in bdi_forker_thread()
Date: Sat,  3 Sep 2011 00:54:18 +0200
Message-Id: <1315004059-9844-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1315004059-9844-1-git-send-email-jack@suse.cz>
References: <1315004059-9844-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bdi_forker_thread() clears BDI_pending bit at the end of the main loop.
However clearing of this bit must not be done in some cases which is handled by
calling 'continue' from switch statement. That's kind of unusual construct and
without a good reason so change the function into more intuitive code flow.

CC: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/backing-dev.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d6edf8d..94a047b 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -359,6 +359,17 @@ static unsigned long bdi_longest_inactive(void)
 	return max(5UL * 60 * HZ, interval);
 }
 
+/*
+ * Clear pending bit and wakeup anybody waiting for flusher thread creation or
+ * shutdown
+ */
+static void bdi_clear_pending(struct backing_dev_info *bdi)
+{
+	clear_bit(BDI_pending, &bdi->state);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&bdi->state, BDI_pending);
+}
+
 static int bdi_forker_thread(void *ptr)
 {
 	struct bdi_writeback *me = ptr;
@@ -469,11 +480,13 @@ static int bdi_forker_thread(void *ptr)
 				spin_unlock_bh(&bdi->wb_lock);
 				wake_up_process(task);
 			}
+			bdi_clear_pending(bdi);
 			break;
 
 		case KILL_THREAD:
 			__set_current_state(TASK_RUNNING);
 			kthread_stop(task);
+			bdi_clear_pending(bdi);
 			break;
 
 		case NO_ACTION:
@@ -489,16 +502,8 @@ static int bdi_forker_thread(void *ptr)
 			else
 				schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
 			try_to_freeze();
-			/* Back to the main loop */
-			continue;
+			break;
 		}
-
-		/*
-		 * Clear pending bit and wakeup anybody waiting to tear us down.
-		 */
-		clear_bit(BDI_pending, &bdi->state);
-		smp_mb__after_clear_bit();
-		wake_up_bit(&bdi->state, BDI_pending);
 	}
 
 	return 0;
-- 
1.7.1

