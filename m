Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab2K2HYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 02:24:38 -0500
Received: from zimbra.linbit.com ([212.69.161.123]:35765 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2K2HYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 02:24:36 -0500
Date: Thu, 29 Nov 2012 08:24:33 +0100
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, Lukas Czerner <lczerner@redhat.com>
Subject: Re: linux-next: build warnings after merge of the akpm tree
Message-ID: <20121129072433.GC674@soda.linbit>
References: <20121129171939.8539a56adf1f0f7ae518f4ce@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129171939.8539a56adf1f0f7ae518f4ce@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 05:19:39PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (x86_64
> allmodconfig) produced these warnings:


> In file included from drivers/block/drbd/drbd_bitmap.c:32:0:
> drivers/block/drbd/drbd_int.h:2339:0: warning: "__wait_event_lock_irq" redefined [enabled by default]
> include/linux/wait.h:554:0: note: this is the location of the previous definition

> Introduced by the interaction of commit c1fd29a11f43 ("drbd: Fix a race
> condition that can lead to a BUG()") from the block tree and commit
> "wait: add wait_event_lock_irq() interface" from the akpm tree.

Thanks.
We can just drop our copy-n-paste-from-md.h then.

	Lars

---------------------------

commit 2712ab592def9f0171b6d47349879e975db57657
Author: Lars Ellenberg <lars.ellenberg@linbit.com>
Date:   Thu Nov 29 08:20:27 2012 +0100

    drbd: fix merge clash: wait_event_lock_irq() is now defined in wait.h
    
    Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index ef72a72..6b51afa 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -2334,30 +2334,3 @@ static inline void drbd_md_flush(struct drbd_conf *mdev)
 }
 
 #endif
-
-/* This is defined in drivers/md/md.h as well. Should go into wait.h */
-#define __wait_event_lock_irq(wq, condition, lock, cmd) 		\
-do {									\
-	wait_queue_t __wait;						\
-	init_waitqueue_entry(&__wait, current);				\
-									\
-	add_wait_queue(&wq, &__wait);					\
-	for (;;) {							\
-		set_current_state(TASK_UNINTERRUPTIBLE);		\
-		if (condition)						\
-			break;						\
-		spin_unlock_irq(&lock);					\
-		cmd;							\
-		schedule();						\
-		spin_lock_irq(&lock);					\
-	}								\
-	current->state = TASK_RUNNING;					\
-	remove_wait_queue(&wq, &__wait);				\
-} while (0)
-
-#define wait_event_lock_irq(wq, condition, lock, cmd) 			\
-do {									\
-	if (condition)	 						\
-		break;							\
-	__wait_event_lock_irq(wq, condition, lock, cmd);		\
-} while (0)
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 69ef352..53bf618 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1800,8 +1800,7 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 		spin_lock_irq(&tconn->req_lock);
 		wait_event_lock_irq(tconn->ping_wait,
 				(rv = _conn_rq_cond(tconn, mask, val)),
-				tconn->req_lock,
-				);
+				tconn->req_lock);
 		clear_bit(CONN_WD_ST_CHG_REQ, &tconn->flags);
 		if (rv < SS_SUCCESS)
 			goto abort;


