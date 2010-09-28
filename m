Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab0I1RLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:11:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757224Ab0I1RLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:11:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com
Subject: [PATCH 3/4] blkio: Add root group to td->tg_list
Date: Tue, 28 Sep 2010 13:10:58 -0400
Message-Id: <1285693859-13591-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1285693859-13591-1-git-send-email-vgoyal@redhat.com>
References: <1285693859-13591-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Currently all the dynamically allocated groups, except root grp is added
  to td->tg_list. This was not a problem so far but in next patch I will
  travel through td->tg_list to process any updates of limits on the group.
  If root group is not in tg_list, then root group's updates are not
  processed.

o It is better to root group also to tg_list instead of doing special
  processing for it during limit updates.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index af53f37..bc2936b 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -87,7 +87,7 @@ struct throtl_data
 	unsigned int nr_queued[2];
 
 	/*
-	 * number of total undestroyed groups (excluding root group)
+	 * number of total undestroyed groups
 	 */
 	unsigned int nr_undestroyed_grps;
 
@@ -940,7 +940,17 @@ int blk_throtl_init(struct request_queue *q)
 	/* Practically unlimited BW */
 	tg->bps[0] = tg->bps[1] = -1;
 	tg->iops[0] = tg->iops[1] = -1;
-	atomic_set(&tg->ref, 1);
+
+	/*
+	 * Set root group reference to 2. One reference will be dropped when
+	 * all groups on tg_list are being deleted during queue exit. Other
+	 * reference will remain there as we don't want to delete this group
+	 * as it is statically allocated and gets destroyed when throtl_data
+	 * goes away.
+	 */
+	atomic_set(&tg->ref, 2);
+	hlist_add_head(&tg->tg_node, &td->tg_list);
+	td->nr_undestroyed_grps++;
 
 	INIT_DELAYED_WORK(&td->throtl_work, blk_throtl_work);
 
@@ -966,10 +976,9 @@ void blk_throtl_exit(struct request_queue *q)
 
 	spin_lock_irq(q->queue_lock);
 	throtl_release_tgs(td);
-	blkiocg_del_blkio_group(&td->root_tg.blkg);
 
 	/* If there are other groups */
-	if (td->nr_undestroyed_grps >= 1)
+	if (td->nr_undestroyed_grps > 0)
 		wait = true;
 
 	spin_unlock_irq(q->queue_lock);
-- 
1.7.2.3

