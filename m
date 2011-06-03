Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab1FCVI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 17:08:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756286Ab1FCVHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 17:07:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk
Cc: vgoyal@redhat.com, arighi@develer.com, fengguang.wu@intel.com,
        jack@suse.cz, akpm@linux-foundation.org
Subject: [PATCH 8/8] blk-throttle: enable throttling of task while dirtying pages
Date: Fri,  3 Jun 2011 17:06:49 -0400
Message-Id: <1307135209-30539-9-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1307135209-30539-1-git-send-email-vgoyal@redhat.com>
References: <1307135209-30539-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put the blk_throtl_dirty_pages() hook in
balance_dirty_pages_ratelimited_nr() to enable task throttling.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/blkdev.h |    5 +++++
 mm/page-writeback.c    |    3 +++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ae9091a..3ad8f5f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1180,12 +1180,17 @@ static inline uint64_t rq_io_start_time_ns(struct request *req)
 extern int blk_throtl_init(struct request_queue *q);
 extern void blk_throtl_exit(struct request_queue *q);
 extern int blk_throtl_bio(struct request_queue *q, struct bio **bio);
+extern void blk_throtl_dirty_pages(struct address_space *mapping,
+				unsigned long nr_dirty);
 #else /* CONFIG_BLK_DEV_THROTTLING */
 static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
 {
 	return 0;
 }
 
+static inline void blk_throtl_dirty_pages(struct address_space *mapping,
+				unsigned long nr_dirty) {}
+
 static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline int blk_throtl_exit(struct request_queue *q) { return 0; }
 #endif /* CONFIG_BLK_DEV_THROTTLING */
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 31f6988..943e551 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -629,6 +629,9 @@ void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 	unsigned long ratelimit;
 	unsigned long *p;
 
+	/* Subject writes to IO controller throttling */
+	blk_throtl_dirty_pages(mapping, nr_pages_dirtied);
+
 	ratelimit = ratelimit_pages;
 	if (mapping->backing_dev_info->dirty_exceeded)
 		ratelimit = 8;
-- 
1.7.4.4

