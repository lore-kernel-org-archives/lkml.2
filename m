Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934579Ab1ESTkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:40:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934492Ab1ESTig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:38:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, axboe@kernel.dk
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 07/13] blk-throttle: Introduce a helper function to fill in device details
Date: Thu, 19 May 2011 15:38:25 -0400
Message-Id: <1305833911-7717-8-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
References: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A helper function for the code which is used at 2-3 places. Makes reading
code little easier.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   35 +++++++++++++++++++++++------------
 1 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 68f2ac3..97ea7f8 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -188,16 +188,34 @@ throtl_add_group_to_td_list(struct throtl_data *td, struct throtl_grp *tg)
 	td->nr_undestroyed_grps++;
 }
 
-static void throtl_init_add_tg_lists(struct throtl_data *td,
-			struct throtl_grp *tg, struct blkio_cgroup *blkcg)
+static void
+__throtl_tg_fill_dev_details(struct throtl_data *td, struct throtl_grp *tg)
 {
 	struct backing_dev_info *bdi = &td->queue->backing_dev_info;
 	unsigned int major, minor;
 
+	if (!tg || tg->blkg.dev)
+		return;
+
+	/*
+	 * Fill in device details for a group which might not have been
+	 * filled at group creation time as queue was being instantiated
+	 * and driver had not attached a device yet
+	 */
+	if (bdi->dev && dev_name(bdi->dev)) {
+		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+		tg->blkg.dev = MKDEV(major, minor);
+	}
+}
+
+static void throtl_init_add_tg_lists(struct throtl_data *td,
+			struct throtl_grp *tg, struct blkio_cgroup *blkcg)
+{
+	__throtl_tg_fill_dev_details(td, tg);
+
 	/* Add group onto cgroup list */
-	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
 	blkiocg_add_blkio_group(blkcg, &tg->blkg, (void *)td,
-				MKDEV(major, minor), BLKIO_POLICY_THROTL);
+				tg->blkg.dev, BLKIO_POLICY_THROTL);
 
 	tg->bps[READ] = blkcg_get_read_bps(blkcg, tg->blkg.dev);
 	tg->bps[WRITE] = blkcg_get_write_bps(blkcg, tg->blkg.dev);
@@ -225,8 +243,6 @@ throtl_grp *throtl_find_tg(struct throtl_data *td, struct blkio_cgroup *blkcg)
 {
 	struct throtl_grp *tg = NULL;
 	void *key = td;
-	struct backing_dev_info *bdi = &td->queue->backing_dev_info;
-	unsigned int major, minor;
 
 	/*
 	 * This is the common case when there are no blkio cgroups.
@@ -237,12 +253,7 @@ throtl_grp *throtl_find_tg(struct throtl_data *td, struct blkio_cgroup *blkcg)
 	else
 		tg = tg_of_blkg(blkiocg_lookup_group(blkcg, key));
 
-	/* Fill in device details for root group */
-	if (tg && !tg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
-		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-		tg->blkg.dev = MKDEV(major, minor);
-	}
-
+	__throtl_tg_fill_dev_details(td, tg);
 	return tg;
 }
 
-- 
1.7.4.4

