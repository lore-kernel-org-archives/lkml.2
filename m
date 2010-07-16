Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965598Ab0GPMuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:50:08 -0400
Received: from smtp.nokia.com ([192.100.122.233]:54062 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965418Ab0GPMtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:49:20 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 12/16] writeback: add to bdi_list in the forker thread
Date: Fri, 16 Jul 2010 15:45:08 +0300
Message-Id: <1279284312-2411-13-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 16 Jul 2010 12:49:14.0867 (UTC) FILETIME=[4BD6CC30:01CB24E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Before creating a bdi thread, the forker thread first removes the
corresponding bdi from the 'bdi_list', then creates the bdi thread
and wakes it up. The thread then adds itself back to the 'bdi_list'.

There is no problem with this, except that it makes the logic a
tiny bit more twisted, because the code reader has to spend some
time to figure out when the bdi is moved back. But this is minor.

However, this patch makes the forker thread add the bdi back to
the 'bdi_list' itself, rather than letting the bdi thread do this.

The reason of the change is to prepare for further changes. Namely,
the further patches will move the bdi thread exiting logic from
bdi threads to the forker thread. So the forker thread will kill
inactive bdi threads. And for the killing case, the forker thread
will have to add bdi's back to to the 'bdi_list' itself. And to make
the code consistent, it is better if we use the same approach for
the bdi thread creation path as well. This is just more elegant.

Note, bdi threads added themselves to the head of the 'bdi_list',
but in the error path the forker thread added them to the tail of
the 'bdi_list'. This patch modifies the code so that bdi's are
always added to the tail. There is no fundamental reason for this,
this is again, just for consistency and to make the code simpler.
I just do not see any problem adding them back to the tail instead
of the head. And this should even be a bit better, because the
next iteration of the bdi forker thread loop will start looking
to the 'bdi_list' from the head, and it will find a bdi which
requires attention a bit faster.

And for absolutely the same reasons, this patch also moves the
piece of code which clears the BDI_pending bit and wakes up the
waiters from bdi threads to the forker thread.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c |   14 --------------
 mm/backing-dev.c  |   21 +++++++++++++++------
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8469b93..968dc8e 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -803,13 +803,6 @@ int bdi_writeback_thread(void *data)
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
 	wb->last_active = jiffies;
@@ -819,13 +812,6 @@ int bdi_writeback_thread(void *data)
 	 */
 	set_user_nice(current, 0);
 
-	/*
-	 * Clear pending bit and wakeup anybody waiting to tear us down
-	 */
-	clear_bit(BDI_pending, &bdi->state);
-	smp_mb__after_clear_bit();
-	wake_up_bit(&bdi->state, BDI_pending);
-
 	trace_writeback_thread_start(bdi);
 
 	while (!kthread_should_stop()) {
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index a42e5ef..0123d6f 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -390,21 +390,30 @@ static int bdi_forker_thread(void *ptr)
 
 		task = kthread_run(bdi_writeback_thread, &bdi->wb, "flush-%s",
  					dev_name(bdi->dev));
+
+		spin_lock_bh(&bdi_lock);
+		list_add_tail(&bdi->bdi_list, &bdi_list);
+		spin_unlock_bh(&bdi_lock);
+
 		if (IS_ERR(task)) {
 			/*
 			 * If thread creation fails, then readd the bdi back to
 			 * the list and force writeout of the bdi from this
 			 * forker thread. That will free some memory and we can
-			 * try again. Add it to the tail so we get a chance to
-			 * flush other bdi's to free memory.
+			 * try again. The bdi was added to the tail so we'll
+			 * get a chance to flush other bdi's to free memory.
 			 */
-			spin_lock_bh(&bdi_lock);
-			list_add_tail(&bdi->bdi_list, &bdi_list);
-			spin_unlock_bh(&bdi_lock);
-
 			bdi_flush_io(bdi);
 		} else
 			bdi->wb.task = task;
+
+		/*
+		 * Clear pending bit and wakeup anybody waiting to tear us
+		 * down.
+		 */
+		clear_bit(BDI_pending, &bdi->state);
+		smp_mb__after_clear_bit();
+		wake_up_bit(&bdi->state, BDI_pending);
 	}
 
 	return 0;
-- 
1.7.1.1

