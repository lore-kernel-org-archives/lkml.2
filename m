Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab2AVD3n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 22:29:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34431 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab2AVD0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 22:26:00 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/17] blkcg: add blkio_policy[] array and allow one policy per policy ID
Date: Sat, 21 Jan 2012 19:25:20 -0800
Message-Id: <1327202725-3383-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327202725-3383-1-git-send-email-tj@kernel.org>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block cgroup policies are maintained in a linked list and,
theoretically, multiple policies sharing the same policy ID are
allowed.

This patch temporarily restricts one policy per plid and adds
blkio_policy[] array which indexes registered policy types by plid.
Both the restriction and blkio_policy[] array are transitional and
will be removed once API cleanup is complete.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   10 ++++++++++
 block/blk-cgroup.h |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 572499a..a175551 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -28,6 +28,8 @@ static LIST_HEAD(blkio_list);
 struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
 EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
+static struct blkio_policy_type *blkio_policy[BLKIO_NR_POLICIES];
+
 static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
 						  struct cgroup *);
 static int blkiocg_can_attach(struct cgroup_subsys *, struct cgroup *,
@@ -1674,7 +1676,11 @@ static void blkiocg_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 void blkio_policy_register(struct blkio_policy_type *blkiop)
 {
 	spin_lock_irq(&blkio_list_lock);
+
+	BUG_ON(blkio_policy[blkiop->plid]);
+	blkio_policy[blkiop->plid] = blkiop;
 	list_add_tail(&blkiop->list, &blkio_list);
+
 	spin_unlock_irq(&blkio_list_lock);
 }
 EXPORT_SYMBOL_GPL(blkio_policy_register);
@@ -1682,7 +1688,11 @@ EXPORT_SYMBOL_GPL(blkio_policy_register);
 void blkio_policy_unregister(struct blkio_policy_type *blkiop)
 {
 	spin_lock_irq(&blkio_list_lock);
+
+	BUG_ON(blkio_policy[blkiop->plid] != blkiop);
+	blkio_policy[blkiop->plid] = NULL;
 	list_del_init(&blkiop->list);
+
 	spin_unlock_irq(&blkio_list_lock);
 }
 EXPORT_SYMBOL_GPL(blkio_policy_unregister);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index d91718b..fd72890 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -19,6 +19,8 @@
 enum blkio_policy_id {
 	BLKIO_POLICY_PROP = 0,		/* Proportional Bandwidth division */
 	BLKIO_POLICY_THROTL,		/* Throttling */
+
+	BLKIO_NR_POLICIES,
 };
 
 /* Max limits for throttle policy */
-- 
1.7.7.3

