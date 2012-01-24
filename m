Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2AXTaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 14:30:05 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39500 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab2AXTaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 14:30:01 -0500
Date: Tue, 24 Jan 2012 11:29:56 -0800
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: [PATCH 13.5] blkcg: make blkg_lookup_create() return ERR_PTR value
 on failure
Message-ID: <20120124192956.GB421@google.com>
References: <1327360193-24679-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327360193-24679-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update blkg_lookup_create() so that it indicates the cause of failure
with ERR_PTR value.  This is primarily to allow the caller to
determine whether the failure is transitional due to queue being
bypassed temporarily.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |   15 +++++++++------
 block/blk-throttle.c |    2 +-
 block/cfq-iosched.c  |    5 ++++-
 3 files changed, 14 insertions(+), 8 deletions(-)

Index: work/block/blk-cgroup.c
===================================================================
--- work.orig/block/blk-cgroup.c
+++ work/block/blk-cgroup.c
@@ -471,8 +471,7 @@ struct blkio_group *blkg_lookup_create(s
 	__releases(q->queue_lock) __acquires(q->queue_lock)
 {
 	struct blkio_policy_type *pol = blkio_policy[plid];
-	struct blkio_group *blkg = NULL;
-	struct blkio_group *new_blkg = NULL;
+	struct blkio_group *blkg, *new_blkg = NULL;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 	lockdep_assert_held(q->queue_lock);
@@ -484,14 +483,14 @@ struct blkio_group *blkg_lookup_create(s
 	 * fail on a bypassing queue.
 	 */
 	if (unlikely(blk_queue_bypass(q)))
-		return NULL;
+		return ERR_PTR(blk_queue_dead(q) ? -EINVAL : -EBUSY);
 
 	blkg = blkg_lookup(blkcg, q, plid);
 	if (blkg)
 		return blkg;
 
 	if (!css_tryget(&blkcg->css))
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	/*
 	 * Allocate and initialize.
@@ -522,8 +521,10 @@ struct blkio_group *blkg_lookup_create(s
 	css_put(&blkcg->css);
 
 	/* did bypass get turned on inbetween? */
-	if (unlikely(blk_queue_bypass(q)))
+	if (unlikely(blk_queue_bypass(q))) {
+		blkg = ERR_PTR(blk_queue_dead(q) ? -EINVAL : -EBUSY);
 		goto out;
+	}
 
 	/* did someone beat us to it? */
 	blkg = blkg_lookup(blkcg, q, plid);
@@ -531,8 +532,10 @@ struct blkio_group *blkg_lookup_create(s
 		goto out;
 
 	/* did alloc fail? */
-	if (unlikely(!new_blkg || !new_blkg->stats_cpu))
+	if (unlikely(!new_blkg || !new_blkg->stats_cpu)) {
+		blkg = ERR_PTR(-ENOMEM);
 		goto out;
+	}
 
 	/* insert */
 	spin_lock(&blkcg->lock);
Index: work/block/blk-throttle.c
===================================================================
--- work.orig/block/blk-throttle.c
+++ work/block/blk-throttle.c
@@ -289,7 +289,7 @@ static struct throtl_grp *throtl_lookup_
 	blkg = blkg_lookup_create(blkcg, q, BLKIO_POLICY_THROTL);
 
 	/* if %NULL and @q is alive, fall back to root_tg */
-	if (blkg)
+	if (!IS_ERR(blkg))
 		tg = tg_of_blkg(blkg);
 	else if (!blk_queue_dead(q))
 		tg = td->root_tg;
Index: work/block/cfq-iosched.c
===================================================================
--- work.orig/block/cfq-iosched.c
+++ work/block/cfq-iosched.c
@@ -1106,7 +1106,10 @@ static struct cfq_group *cfq_lookup_crea
 	struct blkio_group *blkg;
 
 	blkg = blkg_lookup_create(blkcg, cfqd->queue, BLKIO_POLICY_PROP);
-	return cfqg_of_blkg(blkg);
+	if (!IS_ERR(blkg))
+		return cfqg_of_blkg(blkg);
+	else
+		return NULL;
 }
 
 static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
