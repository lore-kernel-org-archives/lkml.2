Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1H3JF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:05:58 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38185 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1H3JFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:05:52 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/15] drbd: Iterate over all overlapping intervals in a tree
Date: Tue, 30 Aug 2011 11:05:36 +0200
Message-Id: <1314695149-387-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
References: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Add a macro and helper function for doing that.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_interval.c |   18 ++++++++++++++++++
 drivers/block/drbd/drbd_interval.h |   16 ++++++++++++----
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_interval.c b/drivers/block/drbd/drbd_interval.c
index 14dbe2d..0e53f10 100644
--- a/drivers/block/drbd/drbd_interval.c
+++ b/drivers/block/drbd/drbd_interval.c
@@ -157,3 +157,21 @@ drbd_find_overlap(struct rb_root *root, sector_t sector, unsigned int size)
 	}
 	return overlap;
 }
+
+struct drbd_interval *
+drbd_next_overlap(struct drbd_interval *i, sector_t sector, unsigned int size)
+{
+	sector_t end = sector + (size >> 9);
+	struct rb_node *node;
+
+	for (;;) {
+		node = rb_next(&i->rb);
+		if (!node)
+			return NULL;
+		i = rb_entry(node, struct drbd_interval, rb);
+		if (i->sector >= end)
+			return NULL;
+		if (sector < i->sector + (i->size >> 9))
+			return i;
+	}
+}
diff --git a/drivers/block/drbd/drbd_interval.h b/drivers/block/drbd/drbd_interval.h
index 4010ad9..f38fcb0 100644
--- a/drivers/block/drbd/drbd_interval.h
+++ b/drivers/block/drbd/drbd_interval.h
@@ -23,10 +23,18 @@ static inline bool drbd_interval_empty(struct drbd_interval *i)
 	return RB_EMPTY_NODE(&i->rb);
 }
 
-bool drbd_insert_interval(struct rb_root *, struct drbd_interval *);
-bool drbd_contains_interval(struct rb_root *, sector_t, struct drbd_interval *);
-void drbd_remove_interval(struct rb_root *, struct drbd_interval *);
-struct drbd_interval *drbd_find_overlap(struct rb_root *, sector_t,
+extern bool drbd_insert_interval(struct rb_root *, struct drbd_interval *);
+extern bool drbd_contains_interval(struct rb_root *, sector_t,
+				   struct drbd_interval *);
+extern void drbd_remove_interval(struct rb_root *, struct drbd_interval *);
+extern struct drbd_interval *drbd_find_overlap(struct rb_root *, sector_t,
 					unsigned int);
+extern struct drbd_interval *drbd_next_overlap(struct drbd_interval *, sector_t,
+					unsigned int);
+
+#define drbd_for_each_overlap(i, root, sector, size)		\
+	for (i = drbd_find_overlap(root, sector, size);		\
+	     i;							\
+	     i = drbd_next_overlap(i, sector, size))
 
 #endif  /* __DRBD_INTERVAL_H */
-- 
1.7.4.1

