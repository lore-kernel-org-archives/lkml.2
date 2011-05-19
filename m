Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934527Ab1ESTjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:39:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934419Ab1ESTik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:38:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, axboe@kernel.dk
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 06/13] blk-throttle: Dynamically allocate root group
Date: Thu, 19 May 2011 15:38:24 -0400
Message-Id: <1305833911-7717-7-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
References: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we allocate root throtl_grp statically. But as we will be
introducing per cpu stat pointers and that will be allocated
dynamically even for root group, we might as well make whole root
throtl_grp allocation dynamic and treat it in same manner as other
groups.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c201967..68f2ac3 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -88,7 +88,7 @@ struct throtl_data
 	/* service tree for active throtl groups */
 	struct throtl_rb_root tg_service_tree;
 
-	struct throtl_grp root_tg;
+	struct throtl_grp *root_tg;
 	struct request_queue *queue;
 
 	/* Total Number of queued bios on READ and WRITE lists */
@@ -233,7 +233,7 @@ throtl_grp *throtl_find_tg(struct throtl_data *td, struct blkio_cgroup *blkcg)
  	 * Avoid lookup in this case
  	 */
 	if (blkcg == &blkio_root_cgroup)
-		tg = &td->root_tg;
+		tg = td->root_tg;
 	else
 		tg = tg_of_blkg(blkiocg_lookup_group(blkcg, key));
 
@@ -313,7 +313,7 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 
 	/* Group allocation failed. Account the IO to root group */
 	if (!tg) {
-		tg = &td->root_tg;
+		tg = td->root_tg;
 		return tg;
 	}
 
@@ -1153,18 +1153,16 @@ int blk_throtl_init(struct request_queue *q)
 	td->limits_changed = false;
 	INIT_DELAYED_WORK(&td->throtl_work, blk_throtl_work);
 
-	/* Init root group */
-	tg = &td->root_tg;
-	throtl_init_group(tg);
+	/* alloc and Init root group. */
+	td->queue = q;
+	tg = throtl_alloc_tg(td);
 
-	/*
-	 * Set root group reference to 2. One reference will be dropped when
-	 * all groups on tg_list are being deleted during queue exit. Other
-	 * reference will remain there as we don't want to delete this group
-	 * as it is statically allocated and gets destroyed when throtl_data
-	 * goes away.
-	 */
-	atomic_inc(&tg->ref);
+	if (!tg) {
+		kfree(td);
+		return -ENOMEM;
+	}
+
+	td->root_tg = tg;
 
 	rcu_read_lock();
 	blkiocg_add_blkio_group(&blkio_root_cgroup, &tg->blkg, (void *)td,
@@ -1173,7 +1171,6 @@ int blk_throtl_init(struct request_queue *q)
 	throtl_add_group_to_td_list(td, tg);
 
 	/* Attach throtl data to request queue */
-	td->queue = q;
 	q->td = td;
 	return 0;
 }
-- 
1.7.4.4

