Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab2C1Wwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:52:54 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55435 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758949Ab2C1WwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:52:01 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/21] blkcg: add blkio_policy_ops operations for exit and stat reset
Date: Wed, 28 Mar 2012 15:51:25 -0700
Message-Id: <1332975091-10950-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332975091-10950-1-git-send-email-tj@kernel.org>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add blkio_policy_ops->blkio_exit_group_fn() and
->blkio_reset_group_stats_fn().  These will be used to further
modularize blkcg policy implementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c |   16 ++++++++++++----
 block/blk-cgroup.h |    4 ++++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 16158e5..e4848ee 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -131,12 +131,17 @@ static void blkg_free(struct blkio_group *blkg)
 		return;
 
 	for (i = 0; i < BLKIO_NR_POLICIES; i++) {
+		struct blkio_policy_type *pol = blkio_policy[i];
 		struct blkg_policy_data *pd = blkg->pd[i];
 
-		if (pd) {
-			free_percpu(pd->stats_cpu);
-			kfree(pd);
-		}
+		if (!pd)
+			continue;
+
+		if (pol && pol->ops.blkio_exit_group_fn)
+			pol->ops.blkio_exit_group_fn(blkg);
+
+		free_percpu(pd->stats_cpu);
+		kfree(pd);
 	}
 
 	kfree(blkg);
@@ -432,6 +437,9 @@ blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 			blkg_stat_reset(&stats->empty_time);
 #endif
 			blkio_reset_stats_cpu(blkg, pol->plid);
+
+			if (pol->ops.blkio_reset_group_stats_fn)
+				pol->ops.blkio_reset_group_stats_fn(blkg);
 		}
 	}
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index c82de47..d0ee649 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -153,9 +153,13 @@ struct blkio_group {
 };
 
 typedef void (blkio_init_group_fn)(struct blkio_group *blkg);
+typedef void (blkio_exit_group_fn)(struct blkio_group *blkg);
+typedef void (blkio_reset_group_stats_fn)(struct blkio_group *blkg);
 
 struct blkio_policy_ops {
 	blkio_init_group_fn *blkio_init_group_fn;
+	blkio_exit_group_fn *blkio_exit_group_fn;
+	blkio_reset_group_stats_fn *blkio_reset_group_stats_fn;
 };
 
 struct blkio_policy_type {
-- 
1.7.7.3

