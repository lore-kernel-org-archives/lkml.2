Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab2AVD0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 22:26:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34431 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab2AVDZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 22:25:48 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/17] blkcg: make blkio_list_lock irq-safe
Date: Sat, 21 Jan 2012 19:25:15 -0800
Message-Id: <1327202725-3383-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327202725-3383-1-git-send-email-tj@kernel.org>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scheduled blkcg API cleanup requires nesting queue lock under
blkio_list_lock.  Make it irq-safe.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 7bfc574..cbaad8c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1046,8 +1046,8 @@ static void blkio_update_policy_node_blkg(struct blkio_cgroup *blkcg,
 	struct blkio_group *blkg;
 	struct hlist_node *n;
 
-	spin_lock(&blkio_list_lock);
-	spin_lock_irq(&blkcg->lock);
+	spin_lock_irq(&blkio_list_lock);
+	spin_lock(&blkcg->lock);
 
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
 		if (pn->dev != blkg->dev || pn->plid != blkg->plid)
@@ -1055,8 +1055,8 @@ static void blkio_update_policy_node_blkg(struct blkio_cgroup *blkcg,
 		blkio_update_blkg_policy(blkcg, blkg, pn);
 	}
 
-	spin_unlock_irq(&blkcg->lock);
-	spin_unlock(&blkio_list_lock);
+	spin_unlock(&blkcg->lock);
+	spin_unlock_irq(&blkio_list_lock);
 }
 
 static int blkiocg_file_write(struct cgroup *cgrp, struct cftype *cft,
@@ -1321,8 +1321,8 @@ static int blkio_weight_write(struct blkio_cgroup *blkcg, u64 val)
 	if (val < BLKIO_WEIGHT_MIN || val > BLKIO_WEIGHT_MAX)
 		return -EINVAL;
 
-	spin_lock(&blkio_list_lock);
-	spin_lock_irq(&blkcg->lock);
+	spin_lock_irq(&blkio_list_lock);
+	spin_lock(&blkcg->lock);
 	blkcg->weight = (unsigned int)val;
 
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
@@ -1333,8 +1333,8 @@ static int blkio_weight_write(struct blkio_cgroup *blkcg, u64 val)
 
 		blkio_update_group_weight(blkg, blkcg->weight);
 	}
-	spin_unlock_irq(&blkcg->lock);
-	spin_unlock(&blkio_list_lock);
+	spin_unlock(&blkcg->lock);
+	spin_unlock_irq(&blkio_list_lock);
 	return 0;
 }
 
@@ -1575,13 +1575,13 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 		 * going away. Let all the IO controlling policies know about
 		 * this event.
 		 */
-		spin_lock(&blkio_list_lock);
+		spin_lock_irqsave(&blkio_list_lock, flags);
 		list_for_each_entry(blkiop, &blkio_list, list) {
 			if (blkiop->plid != blkg->plid)
 				continue;
 			blkiop->ops.blkio_unlink_group_fn(key, blkg);
 		}
-		spin_unlock(&blkio_list_lock);
+		spin_unlock_irqrestore(&blkio_list_lock, flags);
 	} while (1);
 
 	list_for_each_entry_safe(pn, pntmp, &blkcg->policy_list, node) {
@@ -1663,16 +1663,16 @@ static void blkiocg_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 
 void blkio_policy_register(struct blkio_policy_type *blkiop)
 {
-	spin_lock(&blkio_list_lock);
+	spin_lock_irq(&blkio_list_lock);
 	list_add_tail(&blkiop->list, &blkio_list);
-	spin_unlock(&blkio_list_lock);
+	spin_unlock_irq(&blkio_list_lock);
 }
 EXPORT_SYMBOL_GPL(blkio_policy_register);
 
 void blkio_policy_unregister(struct blkio_policy_type *blkiop)
 {
-	spin_lock(&blkio_list_lock);
+	spin_lock_irq(&blkio_list_lock);
 	list_del_init(&blkiop->list);
-	spin_unlock(&blkio_list_lock);
+	spin_unlock_irq(&blkio_list_lock);
 }
 EXPORT_SYMBOL_GPL(blkio_policy_unregister);
-- 
1.7.7.3

