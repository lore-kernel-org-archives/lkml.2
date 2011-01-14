Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab1ANDHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:07:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47952 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1ANDHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:07:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=yGmMs4RdV57JaOjzyTQQfNBIjoGxe3ork3N3peEVrZV82UDuqdpZ9b2ODtIvS5fno0
         O25SgNSRYNY75ISL8TUv9HxLKuZaT2ZrMLUjj+VP7D/L3CscoeZJzxkXMyQhRyFbUKSl
         aH/cO6FTXkUf8rZmDYQhSeaIq8bFEw+gSoMx0=
From: Charles Manning <cdhmanning@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 01/10] Add yaffs2 file system: Allocation, block handling and bitmapping code
Date: Fri, 14 Jan 2011 16:06:00 +1300
Message-Id: <1294974369-31647-2-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294974369-31647-1-git-send-email-cdhmanning@gmail.com>
References: <1294974369-31647-1-git-send-email-cdhmanning@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Manning <cdhmanning@gmail.com>
---
 fs/yaffs2/yaffs_allocator.c    |  387 ++++++++++++++++++++++++++++++++++++++++
 fs/yaffs2/yaffs_allocator.h    |   30 +++
 fs/yaffs2/yaffs_bitmap.c       |   97 ++++++++++
 fs/yaffs2/yaffs_bitmap.h       |   33 ++++
 fs/yaffs2/yaffs_getblockinfo.h |   35 ++++
 5 files changed, 582 insertions(+), 0 deletions(-)
 create mode 100644 fs/yaffs2/yaffs_allocator.c
 create mode 100644 fs/yaffs2/yaffs_allocator.h
 create mode 100644 fs/yaffs2/yaffs_bitmap.c
 create mode 100644 fs/yaffs2/yaffs_bitmap.h
 create mode 100644 fs/yaffs2/yaffs_getblockinfo.h

diff --git a/fs/yaffs2/yaffs_allocator.c b/fs/yaffs2/yaffs_allocator.c
new file mode 100644
index 0000000..59cce04
--- /dev/null
+++ b/fs/yaffs2/yaffs_allocator.c
@@ -0,0 +1,387 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
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
+#ifdef CONFIG_YAFFS_KMALLOC_ALLOCATOR
+/* This is an alternative debug allocator. Don't use for production code. */
+
+void yaffs_deinit_raw_tnodes_and_objs(struct yaffs_dev *dev)
+{
+	dev = dev;
+}
+
+void yaffs_init_raw_tnodes_and_objs(struct yaffs_dev *dev)
+{
+	dev = dev;
+}
+
+struct yaffs_tnode *yaffs_alloc_raw_tnode(struct yaffs_dev *dev)
+{
+	return kmalloc(dev->tnode_size, GFP_NOFS);
+}
+
+void yaffs_free_raw_tnode(struct yaffs_dev *dev, struct yaffs_tnode *tn)
+{
+	dev = dev;
+	kfree(tn);
+}
+
+void yaffs_init_raw_objs(struct yaffs_dev *dev)
+{
+	dev = dev;
+}
+
+void yaffs_deinit_raw_objs(struct yaffs_dev *dev)
+{
+	dev = dev;
+}
+
+struct yaffs_obj *yaffs_alloc_raw_obj(struct yaffs_dev *dev)
+{
+	dev = dev;
+	return kmalloc(sizeof(struct yaffs_obj));
+}
+
+void yaffs_free_raw_obj(struct yaffs_dev *dev, struct yaffs_obj *obj)
+{
+
+	dev = dev;
+	kfree(obj);
+}
+
+#else
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
+	struct yaffs_obj *free_objs;
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
+		YBUG();
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
+	if (allocator) {
+		allocator->alloc_tnode_list = NULL;
+		allocator->free_tnodes = NULL;
+		allocator->n_free_tnodes = 0;
+		allocator->n_tnodes_created = 0;
+	} else {
+		YBUG();
+	}
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
+		YBUG();
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
+		YBUG();
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
+		YBUG();
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
+static void yaffs_init_raw_objs(struct yaffs_dev *dev)
+{
+	struct yaffs_allocator *allocator = dev->allocator;
+
+	if (allocator) {
+		allocator->allocated_obj_list = NULL;
+		allocator->free_objs = NULL;
+		allocator->n_free_objects = 0;
+	} else {
+		YBUG();
+	}
+}
+
+static void yaffs_deinit_raw_objs(struct yaffs_dev *dev)
+{
+	struct yaffs_allocator *allocator = dev->allocator;
+	struct yaffs_obj_list *tmp;
+
+	if (!allocator) {
+		YBUG();
+		return;
+	}
+
+	while (allocator->allocated_obj_list) {
+		tmp = allocator->allocated_obj_list->next;
+		kfree(allocator->allocated_obj_list->objects);
+		kfree(allocator->allocated_obj_list);
+
+		allocator->allocated_obj_list = tmp;
+	}
+
+	allocator->free_objs = NULL;
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
+		YBUG();
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
+	for (i = 0; i < n_obj - 1; i++) {
+		new_objs[i].siblings.next =
+		    (struct list_head *)(&new_objs[i + 1]);
+	}
+
+	new_objs[n_obj - 1].siblings.next = (void *)allocator->free_objs;
+	allocator->free_objs = new_objs;
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
+	struct yaffs_allocator *allocator = dev->allocator;
+
+	if (!allocator) {
+		YBUG();
+		return obj;
+	}
+
+	/* If there are none left make more */
+	if (!allocator->free_objs)
+		yaffs_create_free_objs(dev, YAFFS_ALLOCATION_NOBJECTS);
+
+	if (allocator->free_objs) {
+		obj = allocator->free_objs;
+		allocator->free_objs =
+		    (struct yaffs_obj *)(allocator->free_objs->siblings.next);
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
+	if (!allocator)
+		YBUG();
+	else {
+		/* Link into the free list. */
+		obj->siblings.next = (struct list_head *)(allocator->free_objs);
+		allocator->free_objs = obj;
+		allocator->n_free_objects++;
+	}
+}
+
+void yaffs_deinit_raw_tnodes_and_objs(struct yaffs_dev *dev)
+{
+	if (dev->allocator) {
+		yaffs_deinit_raw_tnodes(dev);
+		yaffs_deinit_raw_objs(dev);
+
+		kfree(dev->allocator);
+		dev->allocator = NULL;
+	} else {
+		YBUG();
+	}
+}
+
+void yaffs_init_raw_tnodes_and_objs(struct yaffs_dev *dev)
+{
+	struct yaffs_allocator *allocator;
+
+	if (!dev->allocator) {
+		allocator = kmalloc(sizeof(struct yaffs_allocator), GFP_NOFS);
+		if (allocator) {
+			dev->allocator = allocator;
+			yaffs_init_raw_tnodes(dev);
+			yaffs_init_raw_objs(dev);
+		}
+	} else {
+		YBUG();
+	}
+}
+
+#endif
diff --git a/fs/yaffs2/yaffs_allocator.h b/fs/yaffs2/yaffs_allocator.h
new file mode 100644
index 0000000..4d5f2ae
--- /dev/null
+++ b/fs/yaffs2/yaffs_allocator.h
@@ -0,0 +1,30 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
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
index 0000000..dc673e8
--- /dev/null
+++ b/fs/yaffs2/yaffs_bitmap.c
@@ -0,0 +1,97 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
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
+		YBUG();
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
+		YBUG();
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
index 0000000..cf9ea58
--- /dev/null
+++ b/fs/yaffs2/yaffs_bitmap.h
@@ -0,0 +1,33 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
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
index 0000000..d87acbd
--- /dev/null
+++ b/fs/yaffs2/yaffs_getblockinfo.h
@@ -0,0 +1,35 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
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
+		YBUG();
+	}
+	return &dev->block_info[blk - dev->internal_start_block];
+}
+
+#endif
-- 
1.7.1

