Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1BID0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 22:26:38 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47507 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab1BID0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 22:26:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tZ8fmS15uUfROUl/rYDb33clfDO97iC3elWtHa5/uKoc0ox0tAtyILuFkpI/V4SWTl
         EJiuphKJjkYfjpy3mQtLSZ4nh1tOWUkhljAal8WGGLV0gkHC3kADGe5M1XmSk2hgPV2e
         tAoT+IPK+wkbOSt/+aeVfC+NT+m/nQ2tvbat8=
From: Charles Manning <cdhmanning@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ryan@bluewatersys.com, akpm@linux-foundation.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 01/10] Add yaffs2 file system: allocators, bitmap and block handling
Date: Wed,  9 Feb 2011 16:25:59 +1300
Message-Id: <1297221968-6747-2-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Manning <cdhmanning@gmail.com>
---
 fs/yaffs2/yaffs_allocator.c    |  357 ++++++++++++++++++++++++++++++++++++++++
 fs/yaffs2/yaffs_allocator.h    |   30 ++++
 fs/yaffs2/yaffs_bitmap.c       |   97 +++++++++++
 fs/yaffs2/yaffs_bitmap.h       |   33 ++++
 fs/yaffs2/yaffs_getblockinfo.h |   35 ++++
 5 files changed, 552 insertions(+), 0 deletions(-)
 create mode 100644 fs/yaffs2/yaffs_allocator.c
 create mode 100644 fs/yaffs2/yaffs_allocator.h
 create mode 100644 fs/yaffs2/yaffs_bitmap.c
 create mode 100644 fs/yaffs2/yaffs_bitmap.h
 create mode 100644 fs/yaffs2/yaffs_getblockinfo.h

diff --git a/fs/yaffs2/yaffs_allocator.c b/fs/yaffs2/yaffs_allocator.c
new file mode 100644
index 0000000..c8f2861
--- /dev/null
+++ b/fs/yaffs2/yaffs_allocator.c
@@ -0,0 +1,357 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2011 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "yaffs_allocator.h"
+#include "yaffs_guts.h"
+#include "yaffs_trace.h"
+#include "yportenv.h"
+
+/*
+ * Each entry in yaffs_tnode_list and yaffs_obj_list hold blocks
+ * of approx 100 objects that are themn allocated singly.
+ * This is basically a simplified slab allocator.
+ *
+ * We don't use the Linux slab allocator because slab does not allow
+ * us to dump all the objects in one hit when we do a umount and tear
+ * down  all the tnodes and objects. slab requires that we first free
+ * the individual objects.
+ *
+ * Once yaffs has been mainlined I shall try to motivate for a change
+ * to slab to provide the extra features we need here.
+ */
+
+struct yaffs_tnode_list {
+	struct yaffs_tnode_list *next;
+	struct yaffs_tnode *tnodes;
+};
+
+struct yaffs_obj_list {
+	struct yaffs_obj_list *next;
+	struct yaffs_obj *objects;
+};
+
+struct yaffs_allocator {
+	int n_tnodes_created;
+	struct yaffs_tnode *free_tnodes;
+	int n_free_tnodes;
+	struct yaffs_tnode_list *alloc_tnode_list;
+
+	int n_obj_created;
+	struct list_head free_objs;
+	int n_free_objects;
+
+	struct yaffs_obj_list *allocated_obj_list;
+};
+
+static void yaffs_deinit_raw_tnodes(struct yaffs_dev *dev)
+{
+	struct yaffs_allocator *allocator =
+	    (struct yaffs_allocator *)dev->allocator;
+	struct yaffs_tnode_list *tmp;
+
+	if (!allocator) {
+		BUG();
+		return;
+	}
+
+	while (allocator->alloc_tnode_list) {
+		tmp = allocator->alloc_tnode_list->next;
+
+		kfree(allocator->alloc_tnode_list->tnodes);
+		kfree(allocator->alloc_tnode_list);
+		allocator->alloc_tnode_list = tmp;
+	}
+
+	allocator->free_tnodes = NULL;
+	allocator->n_free_tnodes = 0;
+	allocator->n_tnodes_created = 0;
+}
+
+static void yaffs_init_raw_tnodes(struct yaffs_dev *dev)
+{
+	struct yaffs_allocator *allocator = dev->allocator;
+
+	if (!allocator) {
+		BUG();
+		return;
+	}
+
+	allocator->alloc_tnode_list = NULL;
+	allocator->free_tnodes = NULL;
+	allocator->n_free_tnodes = 0;
+	allocator->n_tnodes_created = 0;
+}
+
+static int yaffs_create_tnodes(struct yaffs_dev *dev, int n_tnodes)
+{
+	struct yaffs_allocator *allocator =
+	    (struct yaffs_allocator *)dev->allocator;
+	int i;
+	struct yaffs_tnode *new_tnodes;
+	u8 *mem;
+	struct yaffs_tnode *curr;
+	struct yaffs_tnode *next;
+	struct yaffs_tnode_list *tnl;
+
+	if (!allocator) {
+		BUG();
+		return YAFFS_FAIL;
+	}
+
+	if (n_tnodes < 1)
+		return YAFFS_OK;
+
+	/* make these things */
+	new_tnodes = kmalloc(n_tnodes * dev->tnode_size, GFP_NOFS);
+	mem = (u8 *) new_tnodes;
+
+	if (!new_tnodes) {
+		yaffs_trace(YAFFS_TRACE_ERROR,
+			"yaffs: Could not allocate Tnodes");
+		return YAFFS_FAIL;
+	}
+
+	/* New hookup for wide tnodes */
+	for (i = 0; i < n_tnodes - 1; i++) {
+		curr = (struct yaffs_tnode *)&mem[i * dev->tnode_size];
+		next = (struct yaffs_tnode *)&mem[(i + 1) * dev->tnode_size];
+		curr->internal[0] = next;
+	}
+
+	curr = (struct yaffs_tnode *)&mem[(n_tnodes - 1) * dev->tnode_size];
+	curr->internal[0] = allocator->free_tnodes;
+	allocator->free_tnodes = (struct yaffs_tnode *)mem;
+
+	allocator->n_free_tnodes += n_tnodes;
+	allocator->n_tnodes_created += n_tnodes;
+
+	/* Now add this bunch of tnodes to a list for freeing up.
+	 * NB If we can't add this to the management list it isn't fatal
+	 * but it just means we can't free this bunch of tnodes later.
+	 */
+	tnl = kmalloc(sizeof(struct yaffs_tnode_list), GFP_NOFS);
+	if (!tnl) {
+		yaffs_trace(YAFFS_TRACE_ERROR,
+			"Could not add tnodes to management list");
+		return YAFFS_FAIL;
+	} else {
+		tnl->tnodes = new_tnodes;
+		tnl->next = allocator->alloc_tnode_list;
+		allocator->alloc_tnode_list = tnl;
+	}
+
+	yaffs_trace(YAFFS_TRACE_ALLOCATE, "Tnodes added");
+
+	return YAFFS_OK;
+}
+
+struct yaffs_tnode *yaffs_alloc_raw_tnode(struct yaffs_dev *dev)
+{
+	struct yaffs_allocator *allocator =
+	    (struct yaffs_allocator *)dev->allocator;
+	struct yaffs_tnode *tn = NULL;
+
+	if (!allocator) {
+		BUG();
+		return NULL;
+	}
+
+	/* If there are none left make more */
+	if (!allocator->free_tnodes)
+		yaffs_create_tnodes(dev, YAFFS_ALLOCATION_NTNODES);
+
+	if (allocator->free_tnodes) {
+		tn = allocator->free_tnodes;
+		allocator->free_tnodes = allocator->free_tnodes->internal[0];
+		allocator->n_free_tnodes--;
+	}
+
+	return tn;
+}
+
+/* FreeTnode frees up a tnode and puts it back on the free list */
+void yaffs_free_raw_tnode(struct yaffs_dev *dev, struct yaffs_tnode *tn)
+{
+	struct yaffs_allocator *allocator = dev->allocator;
+
+	if (!allocator) {
+		BUG();
+		return;
+	}
+
+	if (tn) {
+		tn->internal[0] = allocator->free_tnodes;
+		allocator->free_tnodes = tn;
+		allocator->n_free_tnodes++;
+	}
+	dev->checkpoint_blocks_required = 0;	/* force recalculation */
+}
+
+/*--------------- yaffs_obj alloaction ------------------------
+ *
+ * Free yaffs_objs are stored in a list using obj->siblings.
+ * The blocks of allocated objects are stored in a linked list.
+ */
+
+static void yaffs_init_raw_objs(struct yaffs_dev *dev)
+{
+	struct yaffs_allocator *allocator = dev->allocator;
+
+	if (!allocator) {
+		BUG();
+		return;
+	}
+
+	allocator->allocated_obj_list = NULL;
+	INIT_LIST_HEAD(&allocator->free_objs);
+	allocator->n_free_objects = 0;
+}
+
+static void yaffs_deinit_raw_objs(struct yaffs_dev *dev)
+{
+	struct yaffs_allocator *allocator = dev->allocator;
+	struct yaffs_obj_list *tmp;
+
+	if (!allocator) {
+		BUG();
+		return;
+	}
+
+	while (allocator->allocated_obj_list) {
+		tmp = allocator->allocated_obj_list->next;
+		kfree(allocator->allocated_obj_list->objects);
+		kfree(allocator->allocated_obj_list);
+		allocator->allocated_obj_list = tmp;
+	}
+
+	INIT_LIST_HEAD(&allocator->free_objs);
+	allocator->n_free_objects = 0;
+	allocator->n_obj_created = 0;
+}
+
+static int yaffs_create_free_objs(struct yaffs_dev *dev, int n_obj)
+{
+	struct yaffs_allocator *allocator = dev->allocator;
+	int i;
+	struct yaffs_obj *new_objs;
+	struct yaffs_obj_list *list;
+
+	if (!allocator) {
+		BUG();
+		return YAFFS_FAIL;
+	}
+
+	if (n_obj < 1)
+		return YAFFS_OK;
+
+	/* make these things */
+	new_objs = kmalloc(n_obj * sizeof(struct yaffs_obj), GFP_NOFS);
+	list = kmalloc(sizeof(struct yaffs_obj_list), GFP_NOFS);
+
+	if (!new_objs || !list) {
+		kfree(new_objs);
+		new_objs = NULL;
+		kfree(list);
+		list = NULL;
+		yaffs_trace(YAFFS_TRACE_ALLOCATE,
+			"Could not allocate more objects");
+		return YAFFS_FAIL;
+	}
+
+	/* Hook them into the free list */
+	for (i = 0; i < n_obj; i++)
+		list_add(&new_objs[i].siblings, &allocator->free_objs);
+
+	allocator->n_free_objects += n_obj;
+	allocator->n_obj_created += n_obj;
+
+	/* Now add this bunch of Objects to a list for freeing up. */
+
+	list->objects = new_objs;
+	list->next = allocator->allocated_obj_list;
+	allocator->allocated_obj_list = list;
+
+	return YAFFS_OK;
+}
+
+struct yaffs_obj *yaffs_alloc_raw_obj(struct yaffs_dev *dev)
+{
+	struct yaffs_obj *obj = NULL;
+	struct list_head *lh;
+	struct yaffs_allocator *allocator = dev->allocator;
+
+	if (!allocator) {
+		BUG();
+		return obj;
+	}
+
+	/* If there are none left make more */
+	if (list_empty(&allocator->free_objs))
+		yaffs_create_free_objs(dev, YAFFS_ALLOCATION_NOBJECTS);
+
+	if (!list_empty(&allocator->free_objs)) {
+		lh = allocator->free_objs.next;
+		obj = list_entry(lh, struct yaffs_obj, siblings);
+		list_del_init(lh);
+		allocator->n_free_objects--;
+	}
+
+	return obj;
+}
+
+void yaffs_free_raw_obj(struct yaffs_dev *dev, struct yaffs_obj *obj)
+{
+
+	struct yaffs_allocator *allocator = dev->allocator;
+
+	if (!allocator) {
+		BUG();
+		return;
+	}
+
+	/* Link into the free list. */
+	list_add(&obj->siblings, &allocator->free_objs);
+	allocator->n_free_objects++;
+}
+
+void yaffs_deinit_raw_tnodes_and_objs(struct yaffs_dev *dev)
+{
+
+	if (!dev->allocator) {
+		BUG();
+		return;
+	}
+
+	yaffs_deinit_raw_tnodes(dev);
+	yaffs_deinit_raw_objs(dev);
+	kfree(dev->allocator);
+	dev->allocator = NULL;
+}
+
+void yaffs_init_raw_tnodes_and_objs(struct yaffs_dev *dev)
+{
+	struct yaffs_allocator *allocator;
+
+	if (dev->allocator) {
+		BUG();
+		return;
+	}
+
+	allocator = kmalloc(sizeof(struct yaffs_allocator), GFP_NOFS);
+	if (allocator) {
+		dev->allocator = allocator;
+		yaffs_init_raw_tnodes(dev);
+		yaffs_init_raw_objs(dev);
+	}
+}
+
diff --git a/fs/yaffs2/yaffs_allocator.h b/fs/yaffs2/yaffs_allocator.h
new file mode 100644
index 0000000..a8cc322
--- /dev/null
+++ b/fs/yaffs2/yaffs_allocator.h
@@ -0,0 +1,30 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2011 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+#ifndef __YAFFS_ALLOCATOR_H__
+#define __YAFFS_ALLOCATOR_H__
+
+#include "yaffs_guts.h"
+
+void yaffs_init_raw_tnodes_and_objs(struct yaffs_dev *dev);
+void yaffs_deinit_raw_tnodes_and_objs(struct yaffs_dev *dev);
+
+struct yaffs_tnode *yaffs_alloc_raw_tnode(struct yaffs_dev *dev);
+void yaffs_free_raw_tnode(struct yaffs_dev *dev, struct yaffs_tnode *tn);
+
+struct yaffs_obj *yaffs_alloc_raw_obj(struct yaffs_dev *dev);
+void yaffs_free_raw_obj(struct yaffs_dev *dev, struct yaffs_obj *obj);
+
+#endif
diff --git a/fs/yaffs2/yaffs_bitmap.c b/fs/yaffs2/yaffs_bitmap.c
new file mode 100644
index 0000000..4440e93
--- /dev/null
+++ b/fs/yaffs2/yaffs_bitmap.c
@@ -0,0 +1,97 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2011 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "yaffs_bitmap.h"
+#include "yaffs_trace.h"
+/*
+ * Chunk bitmap manipulations
+ */
+
+static inline u8 *yaffs_block_bits(struct yaffs_dev *dev, int blk)
+{
+	if (blk < dev->internal_start_block || blk > dev->internal_end_block) {
+		yaffs_trace(YAFFS_TRACE_ERROR,
+			"BlockBits block %d is not valid",
+			blk);
+		BUG();
+	}
+	return dev->chunk_bits +
+	    (dev->chunk_bit_stride * (blk - dev->internal_start_block));
+}
+
+void yaffs_verify_chunk_bit_id(struct yaffs_dev *dev, int blk, int chunk)
+{
+	if (blk < dev->internal_start_block || blk > dev->internal_end_block ||
+	    chunk < 0 || chunk >= dev->param.chunks_per_block) {
+		yaffs_trace(YAFFS_TRACE_ERROR,
+			"Chunk Id (%d:%d) invalid",
+			blk, chunk);
+		BUG();
+	}
+}
+
+void yaffs_clear_chunk_bits(struct yaffs_dev *dev, int blk)
+{
+	u8 *blk_bits = yaffs_block_bits(dev, blk);
+
+	memset(blk_bits, 0, dev->chunk_bit_stride);
+}
+
+void yaffs_clear_chunk_bit(struct yaffs_dev *dev, int blk, int chunk)
+{
+	u8 *blk_bits = yaffs_block_bits(dev, blk);
+
+	yaffs_verify_chunk_bit_id(dev, blk, chunk);
+	blk_bits[chunk / 8] &= ~(1 << (chunk & 7));
+}
+
+void yaffs_set_chunk_bit(struct yaffs_dev *dev, int blk, int chunk)
+{
+	u8 *blk_bits = yaffs_block_bits(dev, blk);
+
+	yaffs_verify_chunk_bit_id(dev, blk, chunk);
+	blk_bits[chunk / 8] |= (1 << (chunk & 7));
+}
+
+int yaffs_check_chunk_bit(struct yaffs_dev *dev, int blk, int chunk)
+{
+	u8 *blk_bits = yaffs_block_bits(dev, blk);
+
+	yaffs_verify_chunk_bit_id(dev, blk, chunk);
+	return (blk_bits[chunk / 8] & (1 << (chunk & 7))) ? 1 : 0;
+}
+
+int yaffs_still_some_chunks(struct yaffs_dev *dev, int blk)
+{
+	u8 *blk_bits = yaffs_block_bits(dev, blk);
+	int i;
+
+	for (i = 0; i < dev->chunk_bit_stride; i++) {
+		if (*blk_bits)
+			return 1;
+		blk_bits++;
+	}
+	return 0;
+}
+
+int yaffs_count_chunk_bits(struct yaffs_dev *dev, int blk)
+{
+	u8 *blk_bits = yaffs_block_bits(dev, blk);
+	int i;
+	int n = 0;
+
+	for (i = 0; i < dev->chunk_bit_stride; i++, blk_bits++)
+		n += hweight8(*blk_bits);
+
+	return n;
+}
diff --git a/fs/yaffs2/yaffs_bitmap.h b/fs/yaffs2/yaffs_bitmap.h
new file mode 100644
index 0000000..e26b37d
--- /dev/null
+++ b/fs/yaffs2/yaffs_bitmap.h
@@ -0,0 +1,33 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2011 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+/*
+ * Chunk bitmap manipulations
+ */
+
+#ifndef __YAFFS_BITMAP_H__
+#define __YAFFS_BITMAP_H__
+
+#include "yaffs_guts.h"
+
+void yaffs_verify_chunk_bit_id(struct yaffs_dev *dev, int blk, int chunk);
+void yaffs_clear_chunk_bits(struct yaffs_dev *dev, int blk);
+void yaffs_clear_chunk_bit(struct yaffs_dev *dev, int blk, int chunk);
+void yaffs_set_chunk_bit(struct yaffs_dev *dev, int blk, int chunk);
+int yaffs_check_chunk_bit(struct yaffs_dev *dev, int blk, int chunk);
+int yaffs_still_some_chunks(struct yaffs_dev *dev, int blk);
+int yaffs_count_chunk_bits(struct yaffs_dev *dev, int blk);
+
+#endif
diff --git a/fs/yaffs2/yaffs_getblockinfo.h b/fs/yaffs2/yaffs_getblockinfo.h
new file mode 100644
index 0000000..8fd0802
--- /dev/null
+++ b/fs/yaffs2/yaffs_getblockinfo.h
@@ -0,0 +1,35 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2011 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+#ifndef __YAFFS_GETBLOCKINFO_H__
+#define __YAFFS_GETBLOCKINFO_H__
+
+#include "yaffs_guts.h"
+#include "yaffs_trace.h"
+
+/* Function to manipulate block info */
+static inline struct yaffs_block_info *yaffs_get_block_info(struct yaffs_dev
+							      *dev, int blk)
+{
+	if (blk < dev->internal_start_block || blk > dev->internal_end_block) {
+		yaffs_trace(YAFFS_TRACE_ERROR,
+			"**>> yaffs: get_block_info block %d is not valid",
+			blk);
+		BUG();
+	}
+	return &dev->block_info[blk - dev->internal_start_block];
+}
+
+#endif
-- 
1.7.1

