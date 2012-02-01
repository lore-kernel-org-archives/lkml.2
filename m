Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab2BAV0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:26:18 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34095 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab2BAVTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:31 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/11] blkcg: clear all request_queues on blkcg policy [un]registrations
Date: Wed,  1 Feb 2012 13:19:09 -0800
Message-Id: <1328131156-13290-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328131156-13290-1-git-send-email-tj@kernel.org>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep track of all request_queues which have blkcg initialized and turn
on bypass and invoke blkcg_clear_queue() on all before making changes
to blkcg policies.

This is to prepare for moving blkg management into blkcg core.  Note
that this uses more brute force than necessary.  Finer grained shoot
down will be implemented later and given that policy [un]registration
almost never happens on running systems (blk-throtl can't be built as
a module and cfq usually is the builtin default iosched), this
shouldn't be a problem for the time being.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c     |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blkdev.h |    3 +++
 2 files changed, 50 insertions(+), 1 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 15264d0..10878a4 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -27,6 +27,9 @@
 static DEFINE_SPINLOCK(blkio_list_lock);
 static LIST_HEAD(blkio_list);
 
+static DEFINE_MUTEX(all_q_mutex);
+static LIST_HEAD(all_q_list);
+
 struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
 EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
@@ -1461,9 +1464,20 @@ done:
  */
 int blkcg_init_queue(struct request_queue *q)
 {
+	int ret;
+
 	might_sleep();
 
-	return blk_throtl_init(q);
+	ret = blk_throtl_init(q);
+	if (ret)
+		return ret;
+
+	mutex_lock(&all_q_mutex);
+	INIT_LIST_HEAD(&q->all_q_node);
+	list_add_tail(&q->all_q_node, &all_q_list);
+	mutex_unlock(&all_q_mutex);
+
+	return 0;
 }
 
 /**
@@ -1487,6 +1501,10 @@ void blkcg_drain_queue(struct request_queue *q)
  */
 void blkcg_exit_queue(struct request_queue *q)
 {
+	mutex_lock(&all_q_mutex);
+	list_del_init(&q->all_q_node);
+	mutex_unlock(&all_q_mutex);
+
 	blk_throtl_exit(q);
 }
 
@@ -1532,8 +1550,33 @@ static void blkiocg_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 	}
 }
 
+static void blkcg_bypass_start(void)
+	__acquires(&all_q_mutex)
+{
+	struct request_queue *q;
+
+	mutex_lock(&all_q_mutex);
+
+	list_for_each_entry(q, &all_q_list, all_q_node) {
+		blk_queue_bypass_start(q);
+		blkg_destroy_all(q);
+	}
+}
+
+static void blkcg_bypass_end(void)
+	__releases(&all_q_mutex)
+{
+	struct request_queue *q;
+
+	list_for_each_entry(q, &all_q_list, all_q_node)
+		blk_queue_bypass_end(q);
+
+	mutex_unlock(&all_q_mutex);
+}
+
 void blkio_policy_register(struct blkio_policy_type *blkiop)
 {
+	blkcg_bypass_start();
 	spin_lock(&blkio_list_lock);
 
 	BUG_ON(blkio_policy[blkiop->plid]);
@@ -1541,11 +1584,13 @@ void blkio_policy_register(struct blkio_policy_type *blkiop)
 	list_add_tail(&blkiop->list, &blkio_list);
 
 	spin_unlock(&blkio_list_lock);
+	blkcg_bypass_end();
 }
 EXPORT_SYMBOL_GPL(blkio_policy_register);
 
 void blkio_policy_unregister(struct blkio_policy_type *blkiop)
 {
+	blkcg_bypass_start();
 	spin_lock(&blkio_list_lock);
 
 	BUG_ON(blkio_policy[blkiop->plid] != blkiop);
@@ -1553,5 +1598,6 @@ void blkio_policy_unregister(struct blkio_policy_type *blkiop)
 	list_del_init(&blkiop->list);
 
 	spin_unlock(&blkio_list_lock);
+	blkcg_bypass_end();
 }
 EXPORT_SYMBOL_GPL(blkio_policy_unregister);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f10958b..e38e4d0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -397,6 +397,9 @@ struct request_queue {
 	struct bsg_class_device bsg_dev;
 #endif
 
+#ifdef CONFIG_BLK_CGROUP
+	struct list_head	all_q_node;
+#endif
 #ifdef CONFIG_BLK_DEV_THROTTLING
 	/* Throttle data */
 	struct throtl_data *td;
-- 
1.7.7.3

