Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab2CSWMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:12:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64547 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372Ab2CSWLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:11:09 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] blkcg: add blkcg->id
Date: Mon, 19 Mar 2012 15:10:56 -0700
Message-Id: <1332195059-2750-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332195059-2750-1-git-send-email-tj@kernel.org>
References: <1332195059-2750-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 64bit unique id to blkcg.  This will be used by policies which
want blkcg identity test to tell whether the associated blkcg has
changed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |    3 +++
 block/blk-cgroup.h |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b15a517..30e0730 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/genhd.h>
 #include <linux/delay.h>
+#include <linux/atomic.h>
 #include "blk-cgroup.h"
 #include "blk.h"
 
@@ -1622,6 +1623,7 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 static struct cgroup_subsys_state *
 blkiocg_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 {
+	static atomic64_t id_seq = ATOMIC64_INIT(0);
 	struct blkio_cgroup *blkcg;
 	struct cgroup *parent = cgroup->parent;
 
@@ -1635,6 +1637,7 @@ blkiocg_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 		return ERR_PTR(-ENOMEM);
 
 	blkcg->weight = BLKIO_WEIGHT_DEFAULT;
+	blkcg->id = atomic64_inc_return(&id_seq); /* root is 0, start from 1 */
 done:
 	spin_lock_init(&blkcg->lock);
 	INIT_HLIST_HEAD(&blkcg->blkg_list);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 9df5ab0..1cb8f76 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -116,6 +116,9 @@ struct blkio_cgroup {
 	unsigned int weight;
 	spinlock_t lock;
 	struct hlist_head blkg_list;
+
+	/* for policies to test whether associated blkcg has changed */
+	uint64_t id;
 };
 
 struct blkio_group_stats {
-- 
1.7.7.3

