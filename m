Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab2C1WDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:03:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:21201 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758531Ab2C1WDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:03:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124507479"
Message-Id: <20120328131153.305137134@intel.com>
User-Agent: quilt/0.51-1
Date: Wed, 28 Mar 2012 20:13:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linux Memory Management List <linux-mm@kvack.org>
cc: Vivek Goyal <vgoyal@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>
cc: Suresh Jayaraman <sjayaraman@suse.com>,
        Andrea Righi <andrea@betterlinux.com>
cc: Jeff Moyer <jmoyer@redhat.com>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] blk-cgroup: buffered write IO controller - bandwidth weight
References: <20120328121308.568545879@intel.com>
Content-Disposition: inline; filename=writeback-io-controller-weight.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkcg->weight can be trivially supported for buffered writes by directly
scaling task_ratelimit in balance_dirty_pages().

However the sementics are not quite the same with direct IO.

- for direct IO, weight is normally applied to disk time
- for buffered writes, weight is applied to dirty rate

Notes about the (balanced_dirty_ratelimit > write_bw) check removal:

When there is only one dd running and its weight is set to
BLKIO_WEIGHT_MIN=10, bdi->dirty_ratelimit will end up balancing around

	write_bw * BLKIO_WEIGHT_DEFAULT / BLKIO_WEIGHT_MIN 
	= write_bw * 50

So the limit should now be raised to (write_bw * 50) to deal with the
above extreme case, which seems too large to be useful for normal cases.
So just remove it.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 include/linux/blk-cgroup.h |   18 ++++++++++++++----
 mm/page-writeback.c        |   10 +++++-----
 2 files changed, 19 insertions(+), 9 deletions(-)

--- linux-next.orig/include/linux/blk-cgroup.h	2012-03-28 13:42:26.686233288 +0800
+++ linux-next/include/linux/blk-cgroup.h	2012-03-28 14:25:16.150180560 +0800
@@ -21,6 +21,10 @@ enum blkio_policy_id {
 	BLKIO_POLICY_THROTL,		/* Throttling */
 };
 
+#define BLKIO_WEIGHT_MIN	10
+#define BLKIO_WEIGHT_MAX	1000
+#define BLKIO_WEIGHT_DEFAULT	500
+
 /* Max limits for throttle policy */
 #define THROTL_IOPS_MAX		UINT_MAX
 
@@ -209,6 +213,11 @@ extern unsigned int blkcg_get_read_iops(
 extern unsigned int blkcg_get_write_iops(struct blkio_cgroup *blkcg,
 				     dev_t dev);
 
+static inline unsigned int blkcg_weight(struct blkio_cgroup *blkcg)
+{
+	return blkcg->weight;
+}
+
 typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
 
 typedef void (blkio_update_group_weight_fn) (void *key,
@@ -259,11 +268,12 @@ static inline void blkio_policy_unregist
 
 static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
 
-#endif
+static inline unsigned int blkcg_weight(struct blkio_cgroup *blkcg)
+{
+	return BLKIO_WEIGHT_DEFAULT;
+}
 
-#define BLKIO_WEIGHT_MIN	10
-#define BLKIO_WEIGHT_MAX	1000
-#define BLKIO_WEIGHT_DEFAULT	500
+#endif
 
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 void blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg);
--- linux-next.orig/mm/page-writeback.c	2012-03-28 13:42:26.678233289 +0800
+++ linux-next/mm/page-writeback.c	2012-03-28 14:26:02.694179605 +0800
@@ -905,11 +905,6 @@ static void bdi_update_dirty_ratelimit(s
 	 */
 	balanced_dirty_ratelimit = div_u64((u64)task_ratelimit * write_bw,
 					   dirty_rate | 1);
-	/*
-	 * balanced_dirty_ratelimit ~= (write_bw / N) <= write_bw
-	 */
-	if (unlikely(balanced_dirty_ratelimit > write_bw))
-		balanced_dirty_ratelimit = write_bw;
 
 	/*
 	 * We could safely do this and return immediately:
@@ -1263,6 +1258,11 @@ static void balance_dirty_pages(struct a
 					       bdi_thresh, bdi_dirty);
 		task_ratelimit = ((u64)dirty_ratelimit * pos_ratio) >>
 							RATELIMIT_CALC_SHIFT;
+
+		if (blkcg_weight(blkcg) != BLKIO_WEIGHT_DEFAULT)
+			task_ratelimit = (u64)task_ratelimit *
+				blkcg_weight(blkcg) / BLKIO_WEIGHT_DEFAULT;
+
 		max_pause = bdi_max_pause(bdi, bdi_dirty);
 		min_pause = bdi_min_pause(bdi, max_pause,
 					  task_ratelimit, dirty_ratelimit,


