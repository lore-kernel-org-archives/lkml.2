Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab2DSX3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:29:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42641 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab2DSX3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:29:36 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] blkcg: fix blkcg->css ref leak in __blkg_lookup_create()
Date: Thu, 19 Apr 2012 16:29:23 -0700
Message-Id: <1334878164-24788-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334878164-24788-1-git-send-email-tj@kernel.org>
References: <1334878164-24788-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__blkg_lookup_create() leaked blkcg->css ref if blkg allocation
failed.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8228385..30a7a9c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -174,6 +174,7 @@ static struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 	__releases(q->queue_lock) __acquires(q->queue_lock)
 {
 	struct blkcg_gq *blkg;
+	int ret;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	lockdep_assert_held(q->queue_lock);
@@ -186,24 +187,22 @@ static struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 	if (!css_tryget(&blkcg->css))
 		return ERR_PTR(-EINVAL);
 
-	/*
-	 * Allocate and initialize.
-	 */
+	/* allocate */
+	ret = -ENOMEM;
 	blkg = blkg_alloc(blkcg, q);
-
-	/* did alloc fail? */
-	if (unlikely(!blkg)) {
-		blkg = ERR_PTR(-ENOMEM);
-		goto out;
-	}
+	if (unlikely(!blkg))
+		goto err_put;
 
 	/* insert */
 	spin_lock(&blkcg->lock);
 	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
 	list_add(&blkg->q_node, &q->blkg_list);
 	spin_unlock(&blkcg->lock);
-out:
 	return blkg;
+
+err_put:
+	css_put(&blkcg->css);
+	return ERR_PTR(ret);
 }
 
 struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
-- 
1.7.7.3

