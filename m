Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab0GYIav (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:30:51 -0400
Received: from smtp.nokia.com ([192.100.122.233]:33043 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab0GYIam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:30:42 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCHv5 07/15] writeback: do not remove bdi from bdi_list
Date: Sun, 25 Jul 2010 11:29:33 +0300
Message-Id: <1280046581-23623-8-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
References: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 Jul 2010 08:29:46.0190 (UTC) FILETIME=[89E6F6E0:01CB2BD3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

The forker thread removes bdis from 'bdi_list' before forking the bdi thread.
But this is wrong for at least 2 reasons.

Reason #1: if we temporary remove a bdi from the list, we may miss works which
           would otherwise be given to us.

Reason #2: this is racy; indeed, 'bdi_wb_shutdown()' expects that bdis are
           always in the 'bdi_list' (see 'bdi_remove_from_list()'), and when
           it races with the forker thread, it can shut down the bdi thread
           at the same time as the forker creates it.

This patch makes sure the forker thread never removes bdis from 'bdi_list'
(which was suggested by Christoph Hellwig).

In order to make sure that we do not race with 'bdi_wb_shutdown()', we have to
hold the 'bdi_lock' while walking the 'bdi_list' and setting the 'BDI_pending'
flag.

NOTE! The error path is interesting. Currently, when we fail to create a bdi
thread, we move the bdi to the tail of 'bdi_list'. But if we never remove the
bdi from the list, we cannot move it to the tail either, because then we can
mess up the RCU readers which walk the list. And also, we'll have the race
described above in "Reason #2".

But I not think that adding to the tail is any important so I just do not do
that.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/fs-writeback.c |    7 -------
 mm/backing-dev.c  |   31 ++++++++++---------------------
 2 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8cf53ba..eaef5c9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -804,13 +804,6 @@ int bdi_writeback_thread(void *data)
 	unsigned long wait_jiffies = -1UL;
 	long pages_written;
 
-	/*
-	 * Add us to the active bdi_list
-	 */
-	spin_lock_bh(&bdi_lock);
-	list_add_rcu(&bdi->bdi_list, &bdi_list);
-	spin_unlock_bh(&bdi_lock);
-
 	current->flags |= PF_FLUSHER | PF_SWAPWRITE;
 	set_freezable();
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index dbc6681..672c17b 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -331,7 +331,7 @@ static int bdi_forker_thread(void *ptr)
 	for (;;) {
 		bool fork = false;
 		struct task_struct *task;
-		struct backing_dev_info *bdi, *tmp;
+		struct backing_dev_info *bdi;
 
 		/*
 		 * Temporary measure, we want to make sure we don't see
@@ -347,7 +347,7 @@ static int bdi_forker_thread(void *ptr)
 		 * Check if any existing bdi's have dirty data without
 		 * a thread registered. If so, set that up.
 		 */
-		list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
+		list_for_each_entry(bdi, &bdi_list, bdi_list) {
 			if (!bdi_cap_writeback_dirty(bdi))
 				continue;
 			if (bdi->wb.task)
@@ -359,8 +359,13 @@ static int bdi_forker_thread(void *ptr)
 			WARN(!test_bit(BDI_registered, &bdi->state),
 			     "bdi %p/%s is not registered!\n", bdi, bdi->name);
 
-			list_del_rcu(&bdi->bdi_list);
 			fork = true;
+
+			/*
+			 * Set the pending bit - if someone will try to
+			 * unregister this bdi - it'll wait on this bit.
+			 */
+			set_bit(BDI_pending, &bdi->state);
 			break;
 		}
 		spin_unlock_bh(&bdi_lock);
@@ -383,29 +388,13 @@ static int bdi_forker_thread(void *ptr)
 
 		__set_current_state(TASK_RUNNING);
 
-		/*
-		 * Set the pending bit - if someone will try to unregister this
-		 * bdi - it'll wait on this bit.
-		 */
-		set_bit(BDI_pending, &bdi->state);
-
-		/* Make sure no one uses the picked bdi */
-		synchronize_rcu();
-
 		task = kthread_run(bdi_writeback_thread, &bdi->wb, "flush-%s",
 				   dev_name(bdi->dev));
 		if (IS_ERR(task)) {
 			/*
-			 * If thread creation fails, then readd the bdi back to
-			 * the list and force writeout of the bdi from this
-			 * forker thread. That will free some memory and we can
-			 * try again. Add it to the tail so we get a chance to
-			 * flush other bdi's to free memory.
+			 * If thread creation fails, force writeout of the bdi
+			 * from the thread.
 			 */
-			spin_lock_bh(&bdi_lock);
-			list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
-			spin_unlock_bh(&bdi_lock);
-
 			bdi_flush_io(bdi);
 		} else
 			bdi->wb.task = task;
-- 
1.7.1.1

