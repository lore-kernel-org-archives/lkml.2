Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414Ab2DZV7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:59:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53858 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117Ab2DZV7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:59:40 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/11] blkcg: __blkg_lookup_create() doesn't have to fail on radix tree preload failure
Date: Thu, 26 Apr 2012 14:59:12 -0700
Message-Id: <1335477561-11131-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1335477561-11131-1-git-send-email-tj@kernel.org>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__blkg_lookup_create() currently fails if radix_tree_preload() fails;
however, preload failrue doesn't imply insertion failure.  Don't fail
__blkg_lookup_create() on preload failure.

While at it, drop sparse locking annotation which no longer applies.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4ab7420..197fb50 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -177,9 +177,9 @@ EXPORT_SYMBOL_GPL(blkg_lookup);
 
 static struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 					     struct request_queue *q)
-	__releases(q->queue_lock) __acquires(q->queue_lock)
 {
 	struct blkcg_gq *blkg;
+	bool preloaded;
 	int ret;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
@@ -203,9 +203,7 @@ static struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 		goto err_put;
 
 	/* insert */
-	ret = radix_tree_preload(GFP_ATOMIC);
-	if (ret)
-		goto err_free;
+	preloaded = !radix_tree_preload(GFP_ATOMIC);
 
 	spin_lock(&blkcg->lock);
 	ret = radix_tree_insert(&blkcg->blkg_tree, q->id, blkg);
@@ -215,14 +213,13 @@ static struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 	}
 	spin_unlock(&blkcg->lock);
 
-	radix_tree_preload_end();
-
+	if (preloaded)
+		radix_tree_preload_end();
 	if (!ret)
 		return blkg;
-err_free:
-	blkg_free(blkg);
 err_put:
 	css_put(&blkcg->css);
+	blkg_free(blkg);
 	return ERR_PTR(ret);
 }
 
-- 
1.7.7.3

