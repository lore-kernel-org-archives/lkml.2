Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2BVBzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:55:52 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45648 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab2BVBrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:47:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.129.137 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/36] block: blk-throttle should be drained regardless of q->elevator
Date: Tue, 21 Feb 2012 17:46:28 -0800
Message-Id: <1329875223-5102-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
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
---
 block/blk-core.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3a78b00..7752ec2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -365,17 +365,24 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 
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
@@ -428,13 +435,8 @@ void blk_cleanup_queue(struct request_queue *q)
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
-- 
1.7.7.3

