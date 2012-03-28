Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283Ab2C1W4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:56:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44424 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758961Ab2C1Wvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:51:47 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/21] blkcg: drop blkiocg_file_write_u64()
Date: Wed, 28 Mar 2012 15:51:15 -0700
Message-Id: <1332975091-10950-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332975091-10950-1-git-send-email-tj@kernel.org>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkiocg_file_write_u64() has single switch case.  Drop
blkiocg_file_write_u64(), rename blkio_weight_write() to
blkcg_set_weight() and use it directly for .write_u64 callback.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c |   35 +++++++----------------------------
 1 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f670217..ae539d3 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1207,8 +1207,9 @@ static int blkiocg_file_read(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 }
 
-static int blkio_weight_write(struct blkio_cgroup *blkcg, int plid, u64 val)
+static int blkcg_set_weight(struct cgroup *cgrp, struct cftype *cft, u64 val)
 {
+	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgrp);
 	struct blkio_group *blkg;
 	struct hlist_node *n;
 
@@ -1220,10 +1221,11 @@ static int blkio_weight_write(struct blkio_cgroup *blkcg, int plid, u64 val)
 	blkcg->weight = (unsigned int)val;
 
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
-		struct blkg_policy_data *pd = blkg->pd[plid];
+		struct blkg_policy_data *pd = blkg->pd[BLKIO_POLICY_PROP];
 
-		if (!pd->conf.weight)
-			blkio_update_group_weight(blkg, plid, blkcg->weight);
+		if (pd && !pd->conf.weight)
+			blkio_update_group_weight(blkg, BLKIO_POLICY_PROP,
+						  blkcg->weight);
 	}
 
 	spin_unlock_irq(&blkcg->lock);
@@ -1251,29 +1253,6 @@ static u64 blkiocg_file_read_u64 (struct cgroup *cgrp, struct cftype *cft) {
 	return 0;
 }
 
-static int
-blkiocg_file_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
-{
-	struct blkio_cgroup *blkcg;
-	enum blkio_policy_id plid = BLKIOFILE_POLICY(cft->private);
-	int name = BLKIOFILE_ATTR(cft->private);
-
-	blkcg = cgroup_to_blkio_cgroup(cgrp);
-
-	switch(plid) {
-	case BLKIO_POLICY_PROP:
-		switch(name) {
-		case BLKIO_PROP_weight:
-			return blkio_weight_write(blkcg, plid, val);
-		}
-		break;
-	default:
-		BUG();
-	}
-
-	return 0;
-}
-
 struct cftype blkio_files[] = {
 	{
 		.name = "weight_device",
@@ -1288,7 +1267,7 @@ struct cftype blkio_files[] = {
 		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
 				BLKIO_PROP_weight),
 		.read_u64 = blkiocg_file_read_u64,
-		.write_u64 = blkiocg_file_write_u64,
+		.write_u64 = blkcg_set_weight,
 	},
 	{
 		.name = "time",
-- 
1.7.7.3

