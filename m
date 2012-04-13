Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab2DMUMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 16:12:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37922 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab2DMUMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 16:12:06 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/11] blkcg: shoot down blkgs if all policies are deactivated
Date: Fri, 13 Apr 2012 13:11:35 -0700
Message-Id: <1334347895-6268-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334347895-6268-1-git-send-email-tj@kernel.org>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason to keep blkgs around if no policy is activated for
the queue.  This patch moves queue locking out of blkg_destroy_all()
and call it from blkg_deactivate_policy() on deactivation of the last
policy on the queue.

This change was suggested by Vivek.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 10f0d2f..b1807d4 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -258,7 +258,7 @@ static void blkg_destroy_all(struct request_queue *q)
 {
 	struct blkio_group *blkg, *n;
 
-	spin_lock_irq(q->queue_lock);
+	lockdep_assert_held(q->queue_lock);
 
 	list_for_each_entry_safe(blkg, n, &q->blkg_list, q_node) {
 		struct blkio_cgroup *blkcg = blkg->blkcg;
@@ -267,8 +267,6 @@ static void blkg_destroy_all(struct request_queue *q)
 		blkg_destroy(blkg);
 		spin_unlock(&blkcg->lock);
 	}
-
-	spin_unlock_irq(q->queue_lock);
 }
 
 static void blkg_rcu_free(struct rcu_head *rcu_head)
@@ -646,7 +644,10 @@ void blkcg_drain_queue(struct request_queue *q)
  */
 void blkcg_exit_queue(struct request_queue *q)
 {
+	spin_lock_irq(q->queue_lock);
 	blkg_destroy_all(q);
+	spin_unlock_irq(q->queue_lock);
+
 	blk_throtl_exit(q);
 }
 
@@ -802,6 +803,10 @@ void blkcg_deactivate_policy(struct request_queue *q,
 
 	__clear_bit(pol->plid, q->blkcg_pols);
 
+	/* if no policy is left, no need for blkgs - shoot them down */
+	if (bitmap_empty(q->blkcg_pols, BLKCG_MAX_POLS))
+		blkg_destroy_all(q);
+
 	list_for_each_entry(blkg, &q->blkg_list, q_node) {
 		/* grab blkcg lock too while removing @pd from @blkg */
 		spin_lock(&blkg->blkcg->lock);
-- 
1.7.7.3

