Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab0I0FoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:44:20 -0400
Received: from crca.org.au ([74.207.252.120]:39698 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932703Ab0I0FoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:17 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 08/23] Hibernation: Generic extents support.
Date: Mon, 27 Sep 2010 15:43:43 +1000
Message-Id: <1285566238-10966-9-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out the extent storage and manipulation into a separate
file and make them more generic, so we can also use extents for
recording what sectors are used and (later) support multiple
storage devices more easily.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/Makefile  |    2 +-
 kernel/power/extents.c |  125 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/extents.h |   35 +++++++++++++
 kernel/power/swap.c    |  117 +++++---------------------------------------
 4 files changed, 175 insertions(+), 104 deletions(-)
 create mode 100644 kernel/power/extents.c
 create mode 100644 kernel/power/extents.h

diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 2eb134d..f8f03e4 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
-				   block_io.o compress.o
+				   block_io.o compress.o extents.o
 obj-$(CONFIG_SUSPEND_NVS)	+= nvs.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
diff --git a/kernel/power/extents.c b/kernel/power/extents.c
new file mode 100644
index 0000000..172322d
--- /dev/null
+++ b/kernel/power/extents.c
@@ -0,0 +1,125 @@
+/*
+ * linux/kernel/power/extents.c
+ *
+ * This file provides functions for storing and using a series of
+ * extents.
+ *
+ * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@suse.cz>
+ * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
+ * Copyright (C) 2010 Nigel Cunningham <nigel@tuxonice.net>
+ *
+ * This file is released under the GPLv2.
+ *
+ */
+
+#include <linux/slab.h>
+#include "extents.h"
+
+int hib_extents_empty(struct hib_extent_state *pos)
+{
+	return RB_EMPTY_ROOT(&pos->root);
+}
+
+void hib_reset_extent_pos(struct hib_extent_state *pos)
+{
+	if (hib_extents_empty(pos))
+		return;
+
+	pos->node = rb_first(&pos->root);
+
+	if (!pos->node) {
+		pos->cur_ext = NULL;
+		pos->offset = 0;
+		return;
+	}
+
+	pos->cur_ext = container_of(pos->node, struct hib_extent, node);
+	pos->offset = pos->cur_ext->start;
+}
+
+unsigned long hib_extent_current(struct hib_extent_state *pos)
+{
+	return (pos->node) ? pos->offset : 0;
+}
+
+unsigned long hib_extent_next(struct hib_extent_state *pos)
+{
+	if (!pos->node)
+		return 0;
+
+	if (pos->cur_ext->end >= pos->offset)
+		return pos->offset++;
+
+	pos->node = rb_next(pos->node);
+	if (!pos->node)
+		return 0;
+
+	pos->cur_ext = container_of(pos->node, struct hib_extent, node);
+	pos->offset = pos->cur_ext->start;
+	return pos->offset;
+}
+
+int hib_extents_insert(struct hib_extent_state *pos, unsigned long value)
+{
+	struct rb_node **new = &(pos->root.rb_node);
+	struct rb_node *parent = NULL;
+	struct hib_extent *ext;
+
+	/* Figure out where to put the new node */
+	while (*new) {
+		ext = container_of(*new, struct hib_extent, node);
+		parent = *new;
+		if (value < ext->start) {
+			/* Try to merge */
+			if (value == ext->start - 1) {
+				ext->start--;
+				return 0;
+			}
+			new = &((*new)->rb_left);
+		} else if (value > ext->end) {
+			/* Try to merge */
+			if (value == ext->end + 1) {
+				ext->end++;
+				return 0;
+			}
+			new = &((*new)->rb_right);
+		} else {
+			/* It already is in the tree */
+			return -EINVAL;
+		}
+	}
+	/* Add the new node and rebalance the tree. */
+	ext = kzalloc(sizeof(struct hib_extent), GFP_KERNEL);
+	if (!ext)
+		return -ENOMEM;
+
+	ext->start = value;
+	ext->end = value;
+	rb_link_node(&ext->node, parent, new);
+	rb_insert_color(&ext->node, &pos->root);
+	pos->num_extents++;
+	return 0;
+}
+
+/**
+ *	free_all_swap_pages - free swap pages allocated for saving image data.
+ *	It also frees the extents used to register which swap entres had been
+ *	allocated.
+ */
+
+void hib_extents_clear(struct hib_extent_state *pos)
+{
+	struct rb_node *node;
+
+	if (hib_extents_empty(pos))
+		return;
+
+	while ((node = pos->root.rb_node)) {
+		struct hib_extent *ext;
+
+		ext = container_of(node, struct hib_extent, node);
+		rb_erase(node, &pos->root);
+		pos->num_extents--;
+		kfree(ext);
+	}
+}
diff --git a/kernel/power/extents.h b/kernel/power/extents.h
new file mode 100644
index 0000000..0b69b8e
--- /dev/null
+++ b/kernel/power/extents.h
@@ -0,0 +1,35 @@
+/*
+ * linux/kernel/power/extents.h
+ *
+ * Copyright (C) 2010 Nigel Cunningham <nigel@tuxonice.net>
+ *
+ * This file is released under the GPLv2.
+ *
+ */
+
+#include <linux/rbtree.h>
+
+struct hib_extent {
+	struct rb_node node;
+	unsigned long start;
+	unsigned long end;
+};
+
+struct hib_extent_state {
+	/* Tree */
+	struct rb_root root;
+	int num_extents;
+
+	/* Current position */
+	struct rb_node *node;
+	struct hib_extent *cur_ext;
+	unsigned long offset;
+};
+
+
+void hib_reset_extent_pos(struct hib_extent_state *pos);
+unsigned long hib_extent_current(struct hib_extent_state *pos);
+unsigned long hib_extent_next(struct hib_extent_state *pos);
+int hib_extents_insert(struct hib_extent_state *pos, unsigned long value);
+void hib_extents_clear(struct hib_extent_state *pos);
+int hib_extents_empty(struct hib_extent_state *pos);
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index fbda5cd..f16e973 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -14,11 +14,11 @@
 #include <linux/buffer_head.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
-#include <linux/slab.h>
 
 #include "power.h"
 #include "compress.h"
 #include "swap.h"
+#include "extents.h"
 
 #define SWSUSP_SIG	"S1SUSPEND"
 
@@ -57,97 +57,14 @@ struct swsusp_header {
 
 static struct swsusp_header *swsusp_header;
 
-/**
- *	The following functions are used for tracing the allocated
- *	swap pages, so that they can be freed in case of an error.
- */
-
-struct swsusp_extent {
-	struct rb_node node;
-	unsigned long start;
-	unsigned long end;
-};
-
-static struct rb_root swsusp_extents = RB_ROOT;
-
-struct storage_position {
-	struct rb_node *node;
-	struct swsusp_extent *cur_ext;
-	unsigned long offset;
-};
-
-static struct storage_position pos;
-
-static void reset_storage_pos(void)
-{
-	pos.node = rb_first(&swsusp_extents);
-
-	if (!pos.node) {
-		pos.cur_ext = NULL;
-		pos.offset = 0;
-		return;
-	}
-
-	pos.cur_ext = container_of(pos.node, struct swsusp_extent, node);
-	pos.offset = pos.cur_ext->start;
-}
+static struct hib_extent_state swap_extents;
 
 static sector_t next_swapdev_block(void)
 {
-	if (!pos.node)
-		return 0;
-
-	if (pos.cur_ext->end >= pos.offset)
-		return pos.offset++;
-
-	pos.node = rb_next(pos.node);
-	if (!pos.node)
-		return 0;
-
-	pos.cur_ext = container_of(pos.node, struct swsusp_extent, node);
-	pos.offset = pos.cur_ext->start;
-	return pos.offset;
-}
-
-static int swsusp_extents_insert(unsigned long swap_offset)
-{
-	struct rb_node **new = &(swsusp_extents.rb_node);
-	struct rb_node *parent = NULL;
-	struct swsusp_extent *ext;
-
-	/* Figure out where to put the new node */
-	while (*new) {
-		ext = container_of(*new, struct swsusp_extent, node);
-		parent = *new;
-		if (swap_offset < ext->start) {
-			/* Try to merge */
-			if (swap_offset == ext->start - 1) {
-				ext->start--;
-				return 0;
-			}
-			new = &((*new)->rb_left);
-		} else if (swap_offset > ext->end) {
-			/* Try to merge */
-			if (swap_offset == ext->end + 1) {
-				ext->end++;
-				return 0;
-			}
-			new = &((*new)->rb_right);
-		} else {
-			/* It already is in the tree */
-			return -EINVAL;
-		}
-	}
-	/* Add the new node and rebalance the tree. */
-	ext = kzalloc(sizeof(struct swsusp_extent), GFP_KERNEL);
-	if (!ext)
-		return -ENOMEM;
-
-	ext->start = swap_offset;
-	ext->end = swap_offset;
-	rb_link_node(&ext->node, parent, new);
-	rb_insert_color(&ext->node, &swsusp_extents);
-	return 0;
+	unsigned long res = hib_extent_next(&swap_extents);
+	if (res)
+		res = swapdev_block(root_swap, res);
+	return res;
 }
 
 /**
@@ -161,7 +78,7 @@ sector_t alloc_swapdev_block(int swap)
 
 	offset = swp_offset(get_swap_page_of_type(swap));
 	if (offset) {
-		if (swsusp_extents_insert(offset))
+		if (hib_extents_insert(&swap_extents, offset))
 			swap_free(swp_entry(swap, offset));
 		else
 			return swapdev_block(swap, offset);
@@ -206,7 +123,7 @@ static int allocate_swap(unsigned int nr_pages, unsigned int flags)
 		return 0;
 	}
 
-	reset_storage_pos();
+	hib_reset_extent_pos(&swap_extents);
 	return 1;
 }
 
@@ -218,24 +135,18 @@ static int allocate_swap(unsigned int nr_pages, unsigned int flags)
 
 void free_all_swap_pages(int swap)
 {
-	struct rb_node *node;
-
-	while ((node = swsusp_extents.rb_node)) {
-		struct swsusp_extent *ext;
-		unsigned long offset;
+	unsigned long offset;
 
-		ext = container_of(node, struct swsusp_extent, node);
-		rb_erase(node, &swsusp_extents);
-		for (offset = ext->start; offset <= ext->end; offset++)
-			swap_free(swp_entry(swap, offset));
+	hib_reset_extent_pos(&swap_extents);
+	while ((offset = hib_extent_next(&swap_extents)))
+		swap_free(swp_entry(swap, offset));
 
-		kfree(ext);
-	}
+	hib_extents_clear(&swap_extents);
 }
 
 int swsusp_swap_in_use(void)
 {
-	return (swsusp_extents.rb_node != NULL);
+	return (!hib_extents_empty(&swap_extents));
 }
 
 /*
-- 
1.7.0.4

