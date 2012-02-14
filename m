Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab2BNBOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:14:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57106 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2BNBOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:14:31 -0500
Date: Mon, 13 Feb 2012 17:14:27 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH UPDATED block/for-linus] block: blk-throttle should be
 drained regardless of q->elevator
Message-ID: <20120214011427.GJ12117@google.com>
References: <20120213225248.GH12117@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120213225248.GH12117@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, blk_cleanup_queue() doesn't call elv_drain_elevator() if
q->elevator doesn't exist; however, bio based drivers don't have
elevator initialized but can still use blk-throttle.  This patch moves
q->elevator test inside blk_drain_queue() such that only
elv_drain_elevator() is skipped if !q->elevator.

-v2: loop can have registered queue which has NULL request_fn.  Make
     sure we don't call into __blk_run_queue() in such cases.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
Added check against NULL q->request_fn for loop driver.  Thanks.

 block/blk-core.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

Index: work/block/blk-core.c
===================================================================
--- work.orig/block/blk-core.c
+++ work/block/blk-core.c
@@ -365,17 +365,24 @@ void blk_drain_queue(struct request_queu
 
 		spin_lock_irq(q->queue_lock);
 
-		elv_drain_elevator(q);
+		/*
+		 * The caller might be trying to drain @q before its
+		 * elevator is initialized.
+		 */
+		if (q->elevator)
+			elv_drain_elevator(q);
+
 		if (drain_all)
 			blk_throtl_drain(q);
 
 		/*
 		 * This function might be called on a queue which failed
-		 * driver init after queue creation.  Some drivers
-		 * (e.g. fd) get unhappy in such cases.  Kick queue iff
-		 * dispatch queue has something on it.
+		 * driver init after queue creation or is not yet fully
+		 * active yet.  Some drivers (e.g. fd and loop) get unhappy
+		 * in such cases.  Kick queue iff dispatch queue has
+		 * something on it and @q has request_fn set.
 		 */
-		if (!list_empty(&q->queue_head))
+		if (!list_empty(&q->queue_head) && q->request_fn)
 			__blk_run_queue(q);
 
 		drain |= q->rq.elvpriv;
@@ -428,13 +435,8 @@ void blk_cleanup_queue(struct request_qu
 	spin_unlock_irq(lock);
 	mutex_unlock(&q->sysfs_lock);
 
-	/*
-	 * Drain all requests queued before DEAD marking.  The caller might
-	 * be trying to tear down @q before its elevator is initialized, in
-	 * which case we don't want to call into draining.
-	 */
-	if (q->elevator)
-		blk_drain_queue(q, true);
+	/* drain all requests queued before DEAD marking */
+	blk_drain_queue(q, true);
 
 	/* @q won't process any more request, flush async actions */
 	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
