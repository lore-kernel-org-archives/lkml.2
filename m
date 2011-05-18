Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654Ab1ERTNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:13:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933607Ab1ERTN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:13:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 02/14] blk-throttle: Do the new group initialization with the help of a function
Date: Wed, 18 May 2011 15:13:14 -0400
Message-Id: <1305746006-5837-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305746006-5837-1-git-send-email-vgoyal@redhat.com>
References: <1305746006-5837-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group initialization code seems to be at two places. root group
initialization in blk_throtl_init() and dynamically allocated group
in throtl_find_alloc_tg(). Create a common function and use at both
the places.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   64 +++++++++++++++++++++++++++----------------------
 1 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 252a81a..fa9a900 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -159,6 +159,35 @@ static void throtl_put_tg(struct throtl_grp *tg)
 	kfree(tg);
 }
 
+static void throtl_init_group(struct throtl_grp *tg)
+{
+	INIT_HLIST_NODE(&tg->tg_node);
+	RB_CLEAR_NODE(&tg->rb_node);
+	bio_list_init(&tg->bio_lists[0]);
+	bio_list_init(&tg->bio_lists[1]);
+	tg->limits_changed = false;
+
+	/* Practically unlimited BW */
+	tg->bps[0] = tg->bps[1] = -1;
+	tg->iops[0] = tg->iops[1] = -1;
+
+	/*
+	 * Take the initial reference that will be released on destroy
+	 * This can be thought of a joint reference by cgroup and
+	 * request queue which will be dropped by either request queue
+	 * exit or cgroup deletion path depending on who is exiting first.
+	 */
+	atomic_set(&tg->ref, 1);
+}
+
+/* Should be called with rcu read lock held (needed for blkcg) */
+static void
+throtl_add_group_to_td_list(struct throtl_data *td, struct throtl_grp *tg)
+{
+	hlist_add_head(&tg->tg_node, &td->tg_list);
+	td->nr_undestroyed_grps++;
+}
+
 static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
 			struct blkio_cgroup *blkcg)
 {
@@ -196,19 +225,7 @@ static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
 	if (!tg)
 		goto done;
 
-	INIT_HLIST_NODE(&tg->tg_node);
-	RB_CLEAR_NODE(&tg->rb_node);
-	bio_list_init(&tg->bio_lists[0]);
-	bio_list_init(&tg->bio_lists[1]);
-	td->limits_changed = false;
-
-	/*
-	 * Take the initial reference that will be released on destroy
-	 * This can be thought of a joint reference by cgroup and
-	 * request queue which will be dropped by either request queue
-	 * exit or cgroup deletion path depending on who is exiting first.
-	 */
-	atomic_set(&tg->ref, 1);
+	throtl_init_group(tg);
 
 	/* Add group onto cgroup list */
 	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
@@ -220,8 +237,7 @@ static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
 	tg->iops[READ] = blkcg_get_read_iops(blkcg, tg->blkg.dev);
 	tg->iops[WRITE] = blkcg_get_write_iops(blkcg, tg->blkg.dev);
 
-	hlist_add_head(&tg->tg_node, &td->tg_list);
-	td->nr_undestroyed_grps++;
+	throtl_add_group_to_td_list(td, tg);
 done:
 	return tg;
 }
@@ -1060,18 +1076,11 @@ int blk_throtl_init(struct request_queue *q)
 	INIT_HLIST_HEAD(&td->tg_list);
 	td->tg_service_tree = THROTL_RB_ROOT;
 	td->limits_changed = false;
+	INIT_DELAYED_WORK(&td->throtl_work, blk_throtl_work);
 
 	/* Init root group */
 	tg = &td->root_tg;
-	INIT_HLIST_NODE(&tg->tg_node);
-	RB_CLEAR_NODE(&tg->rb_node);
-	bio_list_init(&tg->bio_lists[0]);
-	bio_list_init(&tg->bio_lists[1]);
-
-	/* Practically unlimited BW */
-	tg->bps[0] = tg->bps[1] = -1;
-	tg->iops[0] = tg->iops[1] = -1;
-	td->limits_changed = false;
+	throtl_init_group(tg);
 
 	/*
 	 * Set root group reference to 2. One reference will be dropped when
@@ -1080,16 +1089,13 @@ int blk_throtl_init(struct request_queue *q)
 	 * as it is statically allocated and gets destroyed when throtl_data
 	 * goes away.
 	 */
-	atomic_set(&tg->ref, 2);
-	hlist_add_head(&tg->tg_node, &td->tg_list);
-	td->nr_undestroyed_grps++;
-
-	INIT_DELAYED_WORK(&td->throtl_work, blk_throtl_work);
+	atomic_inc(&tg->ref);
 
 	rcu_read_lock();
 	blkiocg_add_blkio_group(&blkio_root_cgroup, &tg->blkg, (void *)td,
 					0, BLKIO_POLICY_THROTL);
 	rcu_read_unlock();
+	throtl_add_group_to_td_list(td, tg);
 
 	/* Attach throtl data to request queue */
 	td->queue = q;
-- 
1.7.1

