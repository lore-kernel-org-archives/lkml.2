Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426Ab2FEDlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 23:41:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49586 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab2FEDlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 23:41:12 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        fengguang.wu@intel.com, hughd@google.com, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/10] blkcg: __blkg_lookup_create() doesn't need radix preload
Date: Mon,  4 Jun 2012 20:40:51 -0700
Message-Id: <1338867660-4689-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1338867660-4689-1-git-send-email-tj@kernel.org>
References: <1338867660-4689-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no point in calling radix_tree_preload() if preloading doesn't
use more permissible GFP mask.  Drop preloading from
__blkg_lookup_create().

While at it, drop sparse locking annotation which no longer applies.

v2: Vivek pointed out the odd preload usage.  Instead of updating,
    just drop it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4ab7420..af61db0 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -177,7 +177,6 @@ EXPORT_SYMBOL_GPL(blkg_lookup);
 
 static struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 					     struct request_queue *q)
-	__releases(q->queue_lock) __acquires(q->queue_lock)
 {
 	struct blkcg_gq *blkg;
 	int ret;
@@ -203,10 +202,6 @@ static struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 		goto err_put;
 
 	/* insert */
-	ret = radix_tree_preload(GFP_ATOMIC);
-	if (ret)
-		goto err_free;
-
 	spin_lock(&blkcg->lock);
 	ret = radix_tree_insert(&blkcg->blkg_tree, q->id, blkg);
 	if (likely(!ret)) {
@@ -215,14 +210,11 @@ static struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 	}
 	spin_unlock(&blkcg->lock);
 
-	radix_tree_preload_end();
-
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

