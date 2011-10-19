Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab1JSE0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:26:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40977 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab1JSE0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:26:36 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com
Cc: ctalbott@google.com, ni@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/10] block: move blk_throtl prototypes to block/blk.h
Date: Tue, 18 Oct 2011 21:26:17 -0700
Message-Id: <1318998384-22525-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1318998384-22525-1-git-send-email-tj@kernel.org>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_throtl interface is block internal and there's no reason to have
them in linux/blkdev.h.  Move them to block/blk.h.

This patch doesn't introduce any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-throttle.c   |    1 +
 block/blk.h            |   15 ++++++++++++++-
 include/linux/blkdev.h |   14 --------------
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index a19f58c..f3f495e 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -10,6 +10,7 @@
 #include <linux/bio.h>
 #include <linux/blktrace_api.h>
 #include "blk-cgroup.h"
+#include "blk.h"
 
 /* Max dispatch from a group in 1 round */
 static int throtl_grp_quantum = 8;
diff --git a/block/blk.h b/block/blk.h
index 20b900a..da247ba 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -188,4 +188,17 @@ static inline int blk_do_io_stat(struct request *rq)
 	        (rq->cmd_flags & REQ_DISCARD));
 }
 
-#endif
+#ifdef CONFIG_BLK_DEV_THROTTLING
+extern int blk_throtl_bio(struct request_queue *q, struct bio **bio);
+extern int blk_throtl_init(struct request_queue *q);
+extern void blk_throtl_exit(struct request_queue *q);
+#else /* CONFIG_BLK_DEV_THROTTLING */
+static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
+{
+	return 0;
+}
+static inline int blk_throtl_init(struct request_queue *q) { return 0; }
+static inline void blk_throtl_exit(struct request_queue *q) { }
+#endif /* CONFIG_BLK_DEV_THROTTLING */
+
+#endif /* BLK_INTERNAL_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bf65f06..d98d7d6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1198,20 +1198,6 @@ static inline uint64_t rq_io_start_time_ns(struct request *req)
 }
 #endif
 
-#ifdef CONFIG_BLK_DEV_THROTTLING
-extern int blk_throtl_init(struct request_queue *q);
-extern void blk_throtl_exit(struct request_queue *q);
-extern int blk_throtl_bio(struct request_queue *q, struct bio **bio);
-#else /* CONFIG_BLK_DEV_THROTTLING */
-static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
-{
-	return 0;
-}
-
-static inline int blk_throtl_init(struct request_queue *q) { return 0; }
-static inline int blk_throtl_exit(struct request_queue *q) { return 0; }
-#endif /* CONFIG_BLK_DEV_THROTTLING */
-
 #define MODULE_ALIAS_BLOCKDEV(major,minor) \
 	MODULE_ALIAS("block-major-" __stringify(major) "-" __stringify(minor))
 #define MODULE_ALIAS_BLOCKDEV_MAJOR(major) \
-- 
1.7.3.1

