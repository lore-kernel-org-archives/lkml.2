Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1HYPhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:37:09 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32955 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1HYPJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:03 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 013/118] drbd: Add interval tree data structure
Date: Thu, 25 Aug 2011 17:07:09 +0200
Message-Id: <1314284934-17999-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/Makefile        |    1 +
 drivers/block/drbd/drbd_interval.c |  156 ++++++++++++++++++++++++++++++++++++
 drivers/block/drbd/drbd_interval.h |   31 +++++++
 3 files changed, 188 insertions(+), 0 deletions(-)
 create mode 100644 drivers/block/drbd/drbd_interval.c
 create mode 100644 drivers/block/drbd/drbd_interval.h

diff --git a/drivers/block/drbd/Makefile b/drivers/block/drbd/Makefile
index 0d3f337..cacbb04 100644
--- a/drivers/block/drbd/Makefile
+++ b/drivers/block/drbd/Makefile
@@ -1,5 +1,6 @@
 drbd-y := drbd_bitmap.o drbd_proc.o
 drbd-y += drbd_worker.o drbd_receiver.o drbd_req.o drbd_actlog.o
 drbd-y += drbd_main.o drbd_strings.o drbd_nl.o
+drbd-y += drbd_interval.o
 
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd.o
diff --git a/drivers/block/drbd/drbd_interval.c b/drivers/block/drbd/drbd_interval.c
new file mode 100644
index 0000000..2511dd9
--- /dev/null
+++ b/drivers/block/drbd/drbd_interval.c
@@ -0,0 +1,156 @@
+#include "drbd_interval.h"
+
+/**
+ * interval_end  -  return end of @node
+ */
+static inline
+sector_t interval_end(struct rb_node *node)
+{
+	struct drbd_interval *this = rb_entry(node, struct drbd_interval, rb);
+	return this->end;
+}
+
+/**
+ * update_interval_end  -  recompute end of @node
+ *
+ * The end of an interval is the highest (start + (size >> 9)) value of this
+ * node and of its children.  Called for @node and its parents whenever the end
+ * may have changed.
+ */
+static void
+update_interval_end(struct rb_node *node, void *__unused)
+{
+	struct drbd_interval *this = rb_entry(node, struct drbd_interval, rb);
+	sector_t end;
+
+	end = this->sector + (this->size >> 9);
+	if (node->rb_left) {
+		sector_t left = interval_end(node->rb_left);
+		if (left > end)
+			end = left;
+	}
+	if (node->rb_right) {
+		sector_t right = interval_end(node->rb_right);
+		if (right > end)
+			end = right;
+	}
+	this->end = end;
+}
+
+/**
+ * drbd_insert_interval  -  insert a new interval into a tree
+ */
+bool
+drbd_insert_interval(struct rb_root *root, struct drbd_interval *this)
+{
+	struct rb_node **new = &root->rb_node, *parent = NULL;
+
+	BUG_ON(!IS_ALIGNED(this->size, 512));
+
+	while (*new) {
+		struct drbd_interval *here =
+			rb_entry(*new, struct drbd_interval, rb);
+
+		parent = *new;
+		if (this->sector < here->sector)
+			new = &(*new)->rb_left;
+		else if (this->sector > here->sector)
+			new = &(*new)->rb_right;
+		else if (this < here)
+			new = &(*new)->rb_left;
+		else if (this->sector > here->sector)
+			new = &(*new)->rb_right;
+			return false;
+	}
+
+	rb_link_node(&this->rb, parent, new);
+	rb_insert_color(&this->rb, root);
+	rb_augment_insert(&this->rb, update_interval_end, NULL);
+	return true;
+}
+
+/**
+ * drbd_contains_interval  -  check if a tree contains a given interval
+ * @sector:	start sector of @interval
+ * @interval:	may not be a valid pointer
+ *
+ * Returns if the tree contains the node @interval with start sector @start.
+ * Does not dereference @interval until @interval is known to be a valid object
+ * in @tree.  Returns %false if @interval is in the tree but with a different
+ * sector number.
+ */
+bool
+drbd_contains_interval(struct rb_root *root, sector_t sector,
+		       struct drbd_interval *interval)
+{
+	struct rb_node *node = root->rb_node;
+
+	while (node) {
+		struct drbd_interval *here =
+			rb_entry(node, struct drbd_interval, rb);
+
+		if (sector < here->sector)
+			node = node->rb_left;
+		else if (sector > here->sector)
+			node = node->rb_right;
+		else if (interval < here)
+			node = node->rb_left;
+		else if (interval > here)
+			node = node->rb_right;
+		else
+			return interval->sector == sector;
+	}
+	return false;
+}
+
+/**
+ * drbd_remove_interval  -  remove an interval from a tree
+ */
+void
+drbd_remove_interval(struct rb_root *root, struct drbd_interval *this)
+{
+	struct rb_node *deepest;
+
+	deepest = rb_augment_erase_begin(&this->rb);
+	rb_erase(&this->rb, root);
+	rb_augment_erase_end(deepest, update_interval_end, NULL);
+}
+
+/**
+ * drbd_find_overlap  - search for an interval overlapping with [sector, sector + size)
+ * @sector:	start sector
+ * @size:	size, aligned to 512 bytes
+ *
+ * Returns the interval overlapping with [sector, sector + size), or NULL.
+ * When there is more than one overlapping interval in the tree, the interval
+ * with the lowest start sector is returned.
+ */
+struct drbd_interval *
+drbd_find_overlap(struct rb_root *root, sector_t sector, unsigned int size)
+{
+	struct rb_node *node = root->rb_node;
+	struct drbd_interval *overlap = NULL;
+	sector_t end = sector + (size >> 9);
+
+	BUG_ON(!IS_ALIGNED(size, 512));
+
+	while (node) {
+		struct drbd_interval *here =
+			rb_entry(node, struct drbd_interval, rb);
+
+		if (node->rb_left &&
+		    sector < interval_end(node->rb_left)) {
+			/* Overlap if any must be on left side */
+			node = node->rb_left;
+		} else if (here->sector < end &&
+			   sector < here->sector + (here->size >> 9)) {
+			overlap = here;
+			break;
+		} else if (sector >= here->sector) {
+			/* Overlap if any must be on right side */
+			node = node->rb_right;
+		} else
+			break;
+	}
+	return overlap;
+}
diff --git a/drivers/block/drbd/drbd_interval.h b/drivers/block/drbd/drbd_interval.h
new file mode 100644
index 0000000..bf8dcf7
--- /dev/null
+++ b/drivers/block/drbd/drbd_interval.h
@@ -0,0 +1,31 @@
+#ifndef __DRBD_INTERVAL_H
+#define __DRBD_INTERVAL_H
+
+#include <linux/types.h>
+#include <linux/rbtree.h>
+
+struct drbd_interval {
+	struct rb_node rb;
+	sector_t sector;	/* start sector of the interval */
+	unsigned int size;	/* size in bytes */
+	sector_t end;		/* highest interval end in subtree */
+};
+
+static inline void drbd_clear_interval(struct drbd_interval *i)
+{
+	RB_CLEAR_NODE(&i->rb);
+}
+
+static inline bool drbd_interval_empty(struct drbd_interval *i)
+{
+	return RB_EMPTY_NODE(&i->rb);
+}
+
+bool drbd_insert_interval(struct rb_root *, struct drbd_interval *);
+struct drbd_interval *drbd_find_interval(struct rb_root *, sector_t,
+					 struct drbd_interval *);
+void drbd_remove_interval(struct rb_root *, struct drbd_interval *);
+struct drbd_interval *drbd_find_overlap(struct rb_root *, sector_t,
+					unsigned int);
+
+#endif  /* __DRBD_INTERVAL_H */
-- 
1.7.4.1

