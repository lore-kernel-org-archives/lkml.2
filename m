Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab0K3V61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:58:27 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34410 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab0K3V6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:58:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Jw8iZ0hS7oq//CDJCSau2290UXYRnO2bhB6RD7tFhqolgbnI4Ocjk9K3+OKSBO0PZE
         hL15/9uT3M9k2+CtP3y3O43dXipn2Uo+FSz1AokddI7ZwZoppGNTE2MD6vmf6MrzXdDt
         KvI56gHRTVIxh92i9EJptMG8iloVgEkLA+TZ8=
From: Charles Manning <cdhmanning@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 7/8] Add yaffs2 file system: verification code and other headers
Date: Wed,  1 Dec 2010 10:57:33 +1300
Message-Id: <1291154254-22533-8-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Manning <cdhmanning@gmail.com>
---
 fs/yaffs2/yaffs_getblockinfo.h |   36 +++
 fs/yaffs2/yaffs_linux.h        |   41 +++
 fs/yaffs2/yaffs_tagsvalidity.c |   27 ++
 fs/yaffs2/yaffs_tagsvalidity.h |   23 ++
 fs/yaffs2/yaffs_trace.h        |   59 +++++
 fs/yaffs2/yaffs_verify.c       |  546 ++++++++++++++++++++++++++++++++++++++++
 fs/yaffs2/yaffs_verify.h       |   43 ++++
 fs/yaffs2/yportenv.h           |   91 +++++++
 8 files changed, 866 insertions(+), 0 deletions(-)
 create mode 100644 fs/yaffs2/yaffs_getblockinfo.h
 create mode 100644 fs/yaffs2/yaffs_linux.h
 create mode 100644 fs/yaffs2/yaffs_tagsvalidity.c
 create mode 100644 fs/yaffs2/yaffs_tagsvalidity.h
 create mode 100644 fs/yaffs2/yaffs_trace.h
 create mode 100644 fs/yaffs2/yaffs_verify.c
 create mode 100644 fs/yaffs2/yaffs_verify.h
 create mode 100644 fs/yaffs2/yportenv.h

diff --git a/fs/yaffs2/yaffs_getblockinfo.h b/fs/yaffs2/yaffs_getblockinfo.h
new file mode 100644
index 0000000..108c361
--- /dev/null
+++ b/fs/yaffs2/yaffs_getblockinfo.h
@@ -0,0 +1,36 @@
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
+static Y_INLINE struct yaffs_block_info *yaffs_get_block_info(struct yaffs_dev
+							      *dev, int blk)
+{
+	if (blk < dev->internal_start_block || blk > dev->internal_end_block) {
+		T(YAFFS_TRACE_ERROR,
+		  (TSTR
+		   ("**>> yaffs: get_block_info block %d is not valid" TENDSTR),
+		   blk));
+		YBUG();
+	}
+	return &dev->block_info[blk - dev->internal_start_block];
+}
+
+#endif
diff --git a/fs/yaffs2/yaffs_linux.h b/fs/yaffs2/yaffs_linux.h
new file mode 100644
index 0000000..3b508cb
--- /dev/null
+++ b/fs/yaffs2/yaffs_linux.h
@@ -0,0 +1,41 @@
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
+#ifndef __YAFFS_LINUX_H__
+#define __YAFFS_LINUX_H__
+
+#include "yportenv.h"
+
+struct yaffs_linux_context {
+	struct list_head context_list;	/* List of these we have mounted */
+	struct yaffs_dev *dev;
+	struct super_block *super;
+	struct task_struct *bg_thread;	/* Background thread for this device */
+	int bg_running;
+	struct mutex gross_lock;	/* Gross locking mutex*/
+	u8 *spare_buffer;	/* For mtdif2 use. Don't know the size of the buffer
+				 * at compile time so we have to allocate it.
+				 */
+	struct list_head search_contexts;
+	void (*put_super_fn) (struct super_block * sb);
+
+	struct task_struct *readdir_process;
+	unsigned mount_id;
+};
+
+#define yaffs_dev_to_lc(dev) ((struct yaffs_linux_context *)((dev)->os_context))
+#define yaffs_dev_to_mtd(dev) ((struct mtd_info *)((dev)->driver_context))
+
+#endif
diff --git a/fs/yaffs2/yaffs_tagsvalidity.c b/fs/yaffs2/yaffs_tagsvalidity.c
new file mode 100644
index 0000000..4358d79
--- /dev/null
+++ b/fs/yaffs2/yaffs_tagsvalidity.c
@@ -0,0 +1,27 @@
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
+#include "yaffs_tagsvalidity.h"
+
+void yaffs_init_tags(struct yaffs_ext_tags *tags)
+{
+	memset(tags, 0, sizeof(struct yaffs_ext_tags));
+	tags->validity0 = 0xAAAAAAAA;
+	tags->validity1 = 0x55555555;
+}
+
+int yaffs_validate_tags(struct yaffs_ext_tags *tags)
+{
+	return (tags->validity0 == 0xAAAAAAAA && tags->validity1 == 0x55555555);
+
+}
diff --git a/fs/yaffs2/yaffs_tagsvalidity.h b/fs/yaffs2/yaffs_tagsvalidity.h
new file mode 100644
index 0000000..36a021f
--- /dev/null
+++ b/fs/yaffs2/yaffs_tagsvalidity.h
@@ -0,0 +1,23 @@
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
+#ifndef __YAFFS_TAGS_VALIDITY_H__
+#define __YAFFS_TAGS_VALIDITY_H__
+
+#include "yaffs_guts.h"
+
+void yaffs_init_tags(struct yaffs_ext_tags *tags);
+int yaffs_validate_tags(struct yaffs_ext_tags *tags);
+#endif
diff --git a/fs/yaffs2/yaffs_trace.h b/fs/yaffs2/yaffs_trace.h
new file mode 100644
index 0000000..8f632ff
--- /dev/null
+++ b/fs/yaffs2/yaffs_trace.h
@@ -0,0 +1,59 @@
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
+#ifndef __YTRACE_H__
+#define __YTRACE_H__
+
+extern unsigned int yaffs_trace_mask;
+extern unsigned int yaffs_wr_attempts;
+
+/*
+ * Tracing flags.
+ * The flags masked in YAFFS_TRACE_ALWAYS are always traced.
+ */
+
+#define YAFFS_TRACE_OS			0x00000002
+#define YAFFS_TRACE_ALLOCATE		0x00000004
+#define YAFFS_TRACE_SCAN		0x00000008
+#define YAFFS_TRACE_BAD_BLOCKS		0x00000010
+#define YAFFS_TRACE_ERASE		0x00000020
+#define YAFFS_TRACE_GC			0x00000040
+#define YAFFS_TRACE_WRITE		0x00000080
+#define YAFFS_TRACE_TRACING		0x00000100
+#define YAFFS_TRACE_DELETION		0x00000200
+#define YAFFS_TRACE_BUFFERS		0x00000400
+#define YAFFS_TRACE_NANDACCESS		0x00000800
+#define YAFFS_TRACE_GC_DETAIL		0x00001000
+#define YAFFS_TRACE_SCAN_DEBUG		0x00002000
+#define YAFFS_TRACE_MTD			0x00004000
+#define YAFFS_TRACE_CHECKPOINT		0x00008000
+
+#define YAFFS_TRACE_VERIFY		0x00010000
+#define YAFFS_TRACE_VERIFY_NAND		0x00020000
+#define YAFFS_TRACE_VERIFY_FULL		0x00040000
+#define YAFFS_TRACE_VERIFY_ALL		0x000F0000
+
+#define YAFFS_TRACE_SYNC		0x00100000
+#define YAFFS_TRACE_BACKGROUND		0x00200000
+#define YAFFS_TRACE_LOCK		0x00400000
+#define YAFFS_TRACE_MOUNT		0x00800000
+
+#define YAFFS_TRACE_ERROR		0x40000000
+#define YAFFS_TRACE_BUG			0x80000000
+#define YAFFS_TRACE_ALWAYS		0xF0000000
+
+#define T(mask, p) do { if ((mask) & (yaffs_trace_mask | YAFFS_TRACE_ALWAYS)) TOUT(p); } while (0)
+
+#endif
diff --git a/fs/yaffs2/yaffs_verify.c b/fs/yaffs2/yaffs_verify.c
new file mode 100644
index 0000000..fee3a1e
--- /dev/null
+++ b/fs/yaffs2/yaffs_verify.c
@@ -0,0 +1,546 @@
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
+#include "yaffs_verify.h"
+#include "yaffs_trace.h"
+#include "yaffs_bitmap.h"
+#include "yaffs_getblockinfo.h"
+#include "yaffs_nand.h"
+
+int yaffs_skip_verification(struct yaffs_dev *dev)
+{
+	dev = dev;
+	return !(yaffs_trace_mask &
+		 (YAFFS_TRACE_VERIFY | YAFFS_TRACE_VERIFY_FULL));
+}
+
+static int yaffs_skip_full_verification(struct yaffs_dev *dev)
+{
+	dev = dev;
+	return !(yaffs_trace_mask & (YAFFS_TRACE_VERIFY_FULL));
+}
+
+static int yaffs_skip_nand_verification(struct yaffs_dev *dev)
+{
+	dev = dev;
+	return !(yaffs_trace_mask & (YAFFS_TRACE_VERIFY_NAND));
+}
+
+static const char *block_state_name[] = {
+	"Unknown",
+	"Needs scanning",
+	"Scanning",
+	"Empty",
+	"Allocating",
+	"Full",
+	"Dirty",
+	"Checkpoint",
+	"Collecting",
+	"Dead"
+};
+
+void yaffs_verify_blk(struct yaffs_dev *dev, struct yaffs_block_info *bi, int n)
+{
+	int actually_used;
+	int in_use;
+
+	if (yaffs_skip_verification(dev))
+		return;
+
+	/* Report illegal runtime states */
+	if (bi->block_state >= YAFFS_NUMBER_OF_BLOCK_STATES)
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("Block %d has undefined state %d" TENDSTR), n,
+		   bi->block_state));
+
+	switch (bi->block_state) {
+	case YAFFS_BLOCK_STATE_UNKNOWN:
+	case YAFFS_BLOCK_STATE_SCANNING:
+	case YAFFS_BLOCK_STATE_NEEDS_SCANNING:
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("Block %d has bad run-state %s" TENDSTR), n,
+		   block_state_name[bi->block_state]));
+	}
+
+	/* Check pages in use and soft deletions are legal */
+
+	actually_used = bi->pages_in_use - bi->soft_del_pages;
+
+	if (bi->pages_in_use < 0
+	    || bi->pages_in_use > dev->param.chunks_per_block
+	    || bi->soft_del_pages < 0
+	    || bi->soft_del_pages > dev->param.chunks_per_block
+	    || actually_used < 0 || actually_used > dev->param.chunks_per_block)
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR
+		   ("Block %d has illegal values pages_in_used %d soft_del_pages %d"
+		    TENDSTR), n, bi->pages_in_use, bi->soft_del_pages));
+
+	/* Check chunk bitmap legal */
+	in_use = yaffs_count_chunk_bits(dev, n);
+	if (in_use != bi->pages_in_use)
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR
+		   ("Block %d has inconsistent values pages_in_use %d counted chunk bits %d"
+		    TENDSTR), n, bi->pages_in_use, in_use));
+
+}
+
+void yaffs_verify_collected_blk(struct yaffs_dev *dev,
+				struct yaffs_block_info *bi, int n)
+{
+	yaffs_verify_blk(dev, bi, n);
+
+	/* After collection the block should be in the erased state */
+
+	if (bi->block_state != YAFFS_BLOCK_STATE_COLLECTING &&
+	    bi->block_state != YAFFS_BLOCK_STATE_EMPTY) {
+		T(YAFFS_TRACE_ERROR,
+		  (TSTR
+		   ("Block %d is in state %d after gc, should be erased"
+		    TENDSTR), n, bi->block_state));
+	}
+}
+
+void yaffs_verify_blocks(struct yaffs_dev *dev)
+{
+	int i;
+	int state_count[YAFFS_NUMBER_OF_BLOCK_STATES];
+	int illegal_states = 0;
+
+	if (yaffs_skip_verification(dev))
+		return;
+
+	memset(state_count, 0, sizeof(state_count));
+
+	for (i = dev->internal_start_block; i <= dev->internal_end_block; i++) {
+		struct yaffs_block_info *bi = yaffs_get_block_info(dev, i);
+		yaffs_verify_blk(dev, bi, i);
+
+		if (bi->block_state < YAFFS_NUMBER_OF_BLOCK_STATES)
+			state_count[bi->block_state]++;
+		else
+			illegal_states++;
+	}
+
+	T(YAFFS_TRACE_VERIFY, (TSTR("" TENDSTR)));
+	T(YAFFS_TRACE_VERIFY, (TSTR("Block summary" TENDSTR)));
+
+	T(YAFFS_TRACE_VERIFY,
+	  (TSTR("%d blocks have illegal states" TENDSTR), illegal_states));
+	if (state_count[YAFFS_BLOCK_STATE_ALLOCATING] > 1)
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("Too many allocating blocks" TENDSTR)));
+
+	for (i = 0; i < YAFFS_NUMBER_OF_BLOCK_STATES; i++)
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("%s %d blocks" TENDSTR),
+		   block_state_name[i], state_count[i]));
+
+	if (dev->blocks_in_checkpt != state_count[YAFFS_BLOCK_STATE_CHECKPOINT])
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("Checkpoint block count wrong dev %d count %d" TENDSTR),
+		   dev->blocks_in_checkpt,
+		   state_count[YAFFS_BLOCK_STATE_CHECKPOINT]));
+
+	if (dev->n_erased_blocks != state_count[YAFFS_BLOCK_STATE_EMPTY])
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("Erased block count wrong dev %d count %d" TENDSTR),
+		   dev->n_erased_blocks, state_count[YAFFS_BLOCK_STATE_EMPTY]));
+
+	if (state_count[YAFFS_BLOCK_STATE_COLLECTING] > 1)
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("Too many collecting blocks %d (max is 1)" TENDSTR),
+		   state_count[YAFFS_BLOCK_STATE_COLLECTING]));
+
+	T(YAFFS_TRACE_VERIFY, (TSTR("" TENDSTR)));
+
+}
+
+/*
+ * Verify the object header. oh must be valid, but obj and tags may be NULL in which
+ * case those tests will not be performed.
+ */
+void yaffs_verify_oh(struct yaffs_obj *obj, struct yaffs_obj_hdr *oh,
+		     struct yaffs_ext_tags *tags, int parent_check)
+{
+	if (obj && yaffs_skip_verification(obj->my_dev))
+		return;
+
+	if (!(tags && obj && oh)) {
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("Verifying object header tags %p obj %p oh %p" TENDSTR),
+		   tags, obj, oh));
+		return;
+	}
+
+	if (oh->type <= YAFFS_OBJECT_TYPE_UNKNOWN ||
+	    oh->type > YAFFS_OBJECT_TYPE_MAX)
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("Obj %d header type is illegal value 0x%x" TENDSTR),
+		   tags->obj_id, oh->type));
+
+	if (tags->obj_id != obj->obj_id)
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("Obj %d header mismatch obj_id %d" TENDSTR),
+		   tags->obj_id, obj->obj_id));
+
+	/*
+	 * Check that the object's parent ids match if parent_check requested.
+	 *
+	 * Tests do not apply to the root object.
+	 */
+
+	if (parent_check && tags->obj_id > 1 && !obj->parent)
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR
+		   ("Obj %d header mismatch parent_id %d obj->parent is NULL"
+		    TENDSTR), tags->obj_id, oh->parent_obj_id));
+
+	if (parent_check && obj->parent &&
+	    oh->parent_obj_id != obj->parent->obj_id &&
+	    (oh->parent_obj_id != YAFFS_OBJECTID_UNLINKED ||
+	     obj->parent->obj_id != YAFFS_OBJECTID_DELETED))
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR
+		   ("Obj %d header mismatch parent_id %d parent_obj_id %d"
+		    TENDSTR), tags->obj_id, oh->parent_obj_id,
+		   obj->parent->obj_id));
+
+	if (tags->obj_id > 1 && oh->name[0] == 0)	/* Null name */
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("Obj %d header name is NULL" TENDSTR), obj->obj_id));
+
+	if (tags->obj_id > 1 && ((u8) (oh->name[0])) == 0xff)	/* Trashed name */
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("Obj %d header name is 0xFF" TENDSTR), obj->obj_id));
+}
+
+void yaffs_verify_file(struct yaffs_obj *obj)
+{
+	int required_depth;
+	int actual_depth;
+	u32 last_chunk;
+	u32 x;
+	u32 i;
+	struct yaffs_dev *dev;
+	struct yaffs_ext_tags tags;
+	struct yaffs_tnode *tn;
+	u32 obj_id;
+
+	if (!obj)
+		return;
+
+	if (yaffs_skip_verification(obj->my_dev))
+		return;
+
+	dev = obj->my_dev;
+	obj_id = obj->obj_id;
+
+	/* Check file size is consistent with tnode depth */
+	last_chunk =
+	    obj->variant.file_variant.file_size / dev->data_bytes_per_chunk + 1;
+	x = last_chunk >> YAFFS_TNODES_LEVEL0_BITS;
+	required_depth = 0;
+	while (x > 0) {
+		x >>= YAFFS_TNODES_INTERNAL_BITS;
+		required_depth++;
+	}
+
+	actual_depth = obj->variant.file_variant.top_level;
+
+	/* Check that the chunks in the tnode tree are all correct.
+	 * We do this by scanning through the tnode tree and
+	 * checking the tags for every chunk match.
+	 */
+
+	if (yaffs_skip_nand_verification(dev))
+		return;
+
+	for (i = 1; i <= last_chunk; i++) {
+		tn = yaffs_find_tnode_0(dev, &obj->variant.file_variant, i);
+
+		if (tn) {
+			u32 the_chunk = yaffs_get_group_base(dev, tn, i);
+			if (the_chunk > 0) {
+				/* T(~0,(TSTR("verifying (%d:%d) %d"TENDSTR),obj_id,i,the_chunk)); */
+				yaffs_rd_chunk_tags_nand(dev, the_chunk, NULL,
+							 &tags);
+				if (tags.obj_id != obj_id || tags.chunk_id != i) {
+					T(~0,
+					  (TSTR
+					   ("Object %d chunk_id %d NAND mismatch chunk %d tags (%d:%d)"
+					    TENDSTR), obj_id, i, the_chunk,
+					   tags.obj_id, tags.chunk_id));
+				}
+			}
+		}
+	}
+}
+
+void yaffs_verify_link(struct yaffs_obj *obj)
+{
+	if (obj && yaffs_skip_verification(obj->my_dev))
+		return;
+
+	/* Verify sane equivalent object */
+}
+
+void yaffs_verify_symlink(struct yaffs_obj *obj)
+{
+	if (obj && yaffs_skip_verification(obj->my_dev))
+		return;
+
+	/* Verify symlink string */
+}
+
+void yaffs_verify_special(struct yaffs_obj *obj)
+{
+	if (obj && yaffs_skip_verification(obj->my_dev))
+		return;
+}
+
+void yaffs_verify_obj(struct yaffs_obj *obj)
+{
+	struct yaffs_dev *dev;
+
+	u32 chunk_min;
+	u32 chunk_max;
+
+	u32 chunk_id_ok;
+	u32 chunk_in_range;
+	u32 chunk_wrongly_deleted;
+	u32 chunk_valid;
+
+	if (!obj)
+		return;
+
+	if (obj->being_created)
+		return;
+
+	dev = obj->my_dev;
+
+	if (yaffs_skip_verification(dev))
+		return;
+
+	/* Check sane object header chunk */
+
+	chunk_min = dev->internal_start_block * dev->param.chunks_per_block;
+	chunk_max =
+	    (dev->internal_end_block + 1) * dev->param.chunks_per_block - 1;
+
+	chunk_in_range = (((unsigned)(obj->hdr_chunk)) >= chunk_min &&
+			  ((unsigned)(obj->hdr_chunk)) <= chunk_max);
+	chunk_id_ok = chunk_in_range || (obj->hdr_chunk == 0);
+	chunk_valid = chunk_in_range &&
+	    yaffs_check_chunk_bit(dev,
+				  obj->hdr_chunk / dev->param.chunks_per_block,
+				  obj->hdr_chunk % dev->param.chunks_per_block);
+	chunk_wrongly_deleted = chunk_in_range && !chunk_valid;
+
+	if (!obj->fake && (!chunk_id_ok || chunk_wrongly_deleted)) {
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("Obj %d has chunk_id %d %s %s" TENDSTR),
+		   obj->obj_id, obj->hdr_chunk,
+		   chunk_id_ok ? "" : ",out of range",
+		   chunk_wrongly_deleted ? ",marked as deleted" : ""));
+	}
+
+	if (chunk_valid && !yaffs_skip_nand_verification(dev)) {
+		struct yaffs_ext_tags tags;
+		struct yaffs_obj_hdr *oh;
+		u8 *buffer = yaffs_get_temp_buffer(dev, __LINE__);
+
+		oh = (struct yaffs_obj_hdr *)buffer;
+
+		yaffs_rd_chunk_tags_nand(dev, obj->hdr_chunk, buffer, &tags);
+
+		yaffs_verify_oh(obj, oh, &tags, 1);
+
+		yaffs_release_temp_buffer(dev, buffer, __LINE__);
+	}
+
+	/* Verify it has a parent */
+	if (obj && !obj->fake && (!obj->parent || obj->parent->my_dev != dev)) {
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR
+		   ("Obj %d has parent pointer %p which does not look like an object"
+		    TENDSTR), obj->obj_id, obj->parent));
+	}
+
+	/* Verify parent is a directory */
+	if (obj->parent
+	    && obj->parent->variant_type != YAFFS_OBJECT_TYPE_DIRECTORY) {
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("Obj %d's parent is not a directory (type %d)" TENDSTR),
+		   obj->obj_id, obj->parent->variant_type));
+	}
+
+	switch (obj->variant_type) {
+	case YAFFS_OBJECT_TYPE_FILE:
+		yaffs_verify_file(obj);
+		break;
+	case YAFFS_OBJECT_TYPE_SYMLINK:
+		yaffs_verify_symlink(obj);
+		break;
+	case YAFFS_OBJECT_TYPE_DIRECTORY:
+		yaffs_verify_dir(obj);
+		break;
+	case YAFFS_OBJECT_TYPE_HARDLINK:
+		yaffs_verify_link(obj);
+		break;
+	case YAFFS_OBJECT_TYPE_SPECIAL:
+		yaffs_verify_special(obj);
+		break;
+	case YAFFS_OBJECT_TYPE_UNKNOWN:
+	default:
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("Obj %d has illegaltype %d" TENDSTR),
+		   obj->obj_id, obj->variant_type));
+		break;
+	}
+}
+
+void yaffs_verify_objects(struct yaffs_dev *dev)
+{
+	struct yaffs_obj *obj;
+	int i;
+	struct list_head *lh;
+
+	if (yaffs_skip_verification(dev))
+		return;
+
+	/* Iterate through the objects in each hash entry */
+
+	for (i = 0; i < YAFFS_NOBJECT_BUCKETS; i++) {
+		list_for_each(lh, &dev->obj_bucket[i].list) {
+			if (lh) {
+				obj =
+				    list_entry(lh, struct yaffs_obj, hash_link);
+				yaffs_verify_obj(obj);
+			}
+		}
+	}
+}
+
+void yaffs_verify_obj_in_dir(struct yaffs_obj *obj)
+{
+	struct list_head *lh;
+	struct yaffs_obj *list_obj;
+
+	int count = 0;
+
+	if (!obj) {
+		T(YAFFS_TRACE_ALWAYS, (TSTR("No object to verify" TENDSTR)));
+		YBUG();
+		return;
+	}
+
+	if (yaffs_skip_verification(obj->my_dev))
+		return;
+
+	if (!obj->parent) {
+		T(YAFFS_TRACE_ALWAYS,
+		  (TSTR("Object does not have parent" TENDSTR)));
+		YBUG();
+		return;
+	}
+
+	if (obj->parent->variant_type != YAFFS_OBJECT_TYPE_DIRECTORY) {
+		T(YAFFS_TRACE_ALWAYS,
+		  (TSTR("Parent is not directory" TENDSTR)));
+		YBUG();
+	}
+
+	/* Iterate through the objects in each hash entry */
+
+	list_for_each(lh, &obj->parent->variant.dir_variant.children) {
+		if (lh) {
+			list_obj = list_entry(lh, struct yaffs_obj, siblings);
+			yaffs_verify_obj(list_obj);
+			if (obj == list_obj)
+				count++;
+		}
+	}
+
+	if (count != 1) {
+		T(YAFFS_TRACE_ALWAYS,
+		  (TSTR("Object in directory %d times" TENDSTR), count));
+		YBUG();
+	}
+}
+
+void yaffs_verify_dir(struct yaffs_obj *directory)
+{
+	struct list_head *lh;
+	struct yaffs_obj *list_obj;
+
+	if (!directory) {
+		YBUG();
+		return;
+	}
+
+	if (yaffs_skip_full_verification(directory->my_dev))
+		return;
+
+	if (directory->variant_type != YAFFS_OBJECT_TYPE_DIRECTORY) {
+		T(YAFFS_TRACE_ALWAYS,
+		  (TSTR("Directory has wrong type: %d" TENDSTR),
+		   directory->variant_type));
+		YBUG();
+	}
+
+	/* Iterate through the objects in each hash entry */
+
+	list_for_each(lh, &directory->variant.dir_variant.children) {
+		if (lh) {
+			list_obj = list_entry(lh, struct yaffs_obj, siblings);
+			if (list_obj->parent != directory) {
+				T(YAFFS_TRACE_ALWAYS,
+				  (TSTR
+				   ("Object in directory list has wrong parent %p"
+				    TENDSTR), list_obj->parent));
+				YBUG();
+			}
+			yaffs_verify_obj_in_dir(list_obj);
+		}
+	}
+}
+
+static int yaffs_free_verification_failures;
+
+void yaffs_verify_free_chunks(struct yaffs_dev *dev)
+{
+	int counted;
+	int difference;
+
+	if (yaffs_skip_verification(dev))
+		return;
+
+	counted = yaffs_count_free_chunks(dev);
+
+	difference = dev->n_free_chunks - counted;
+
+	if (difference) {
+		T(YAFFS_TRACE_ALWAYS,
+		  (TSTR("Freechunks verification failure %d %d %d" TENDSTR),
+		   dev->n_free_chunks, counted, difference));
+		yaffs_free_verification_failures++;
+	}
+}
+
+int yaffs_verify_file_sane(struct yaffs_obj *in)
+{
+	in = in;
+	return YAFFS_OK;
+}
diff --git a/fs/yaffs2/yaffs_verify.h b/fs/yaffs2/yaffs_verify.h
new file mode 100644
index 0000000..cc6f889
--- /dev/null
+++ b/fs/yaffs2/yaffs_verify.h
@@ -0,0 +1,43 @@
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
+#ifndef __YAFFS_VERIFY_H__
+#define __YAFFS_VERIFY_H__
+
+#include "yaffs_guts.h"
+
+void yaffs_verify_blk(struct yaffs_dev *dev, struct yaffs_block_info *bi,
+		      int n);
+void yaffs_verify_collected_blk(struct yaffs_dev *dev,
+				struct yaffs_block_info *bi, int n);
+void yaffs_verify_blocks(struct yaffs_dev *dev);
+
+void yaffs_verify_oh(struct yaffs_obj *obj, struct yaffs_obj_hdr *oh,
+		     struct yaffs_ext_tags *tags, int parent_check);
+void yaffs_verify_file(struct yaffs_obj *obj);
+void yaffs_verify_link(struct yaffs_obj *obj);
+void yaffs_verify_symlink(struct yaffs_obj *obj);
+void yaffs_verify_special(struct yaffs_obj *obj);
+void yaffs_verify_obj(struct yaffs_obj *obj);
+void yaffs_verify_objects(struct yaffs_dev *dev);
+void yaffs_verify_obj_in_dir(struct yaffs_obj *obj);
+void yaffs_verify_dir(struct yaffs_obj *directory);
+void yaffs_verify_free_chunks(struct yaffs_dev *dev);
+
+int yaffs_verify_file_sane(struct yaffs_obj *obj);
+
+int yaffs_skip_verification(struct yaffs_dev *dev);
+
+#endif
diff --git a/fs/yaffs2/yportenv.h b/fs/yaffs2/yportenv.h
new file mode 100644
index 0000000..8fd0da5
--- /dev/null
+++ b/fs/yaffs2/yportenv.h
@@ -0,0 +1,91 @@
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
+#ifndef __YPORTENV_LINUX_H__
+#define __YPORTENV_LINUX_H__
+
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/xattr.h>
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/stat.h>
+#include <linux/sort.h>
+#include <linux/bitops.h>
+
+#define YCHAR char
+#define YUCHAR unsigned char
+#define _Y(x)     x
+#define yaffs_strcat(a, b)     strcat(a, b)
+#define yaffs_strcpy(a, b)     strcpy(a, b)
+#define yaffs_strncpy(a, b, c) strncpy(a, b, c)
+#define yaffs_strncmp(a, b, c) strncmp(a, b, c)
+#define yaffs_strnlen(s,m)	strnlen(s,m)
+#define yaffs_sprintf	       sprintf
+#define yaffs_toupper(a)       toupper(a)
+
+#define yaffs_sort(base, n, sz, cmp_fn)	sort(base, n, sz, cmp_fn, NULL)
+
+#define Y_INLINE __inline__
+
+#define YAFFS_LOSTNFOUND_NAME		"lost+found"
+#define YAFFS_LOSTNFOUND_PREFIX		"obj"
+
+#define YMALLOC(x) kmalloc(x, GFP_NOFS)
+#define YFREE(x)   kfree(x)
+#define YMALLOC_ALT(x) vmalloc(x)
+#define YFREE_ALT(x)   vfree(x)
+#define YMALLOC_DMA(x) YMALLOC(x)
+
+#define YYIELD() schedule()
+#define Y_DUMP_STACK() dump_stack()
+
+#define YAFFS_ROOT_MODE			0755
+#define YAFFS_LOSTNFOUND_MODE		0700
+
+#define Y_CURRENT_TIME CURRENT_TIME.tv_sec
+#define Y_TIME_CONVERT(x) (x).tv_sec
+
+#define yaffs_sum_cmp(x, y) ((x) == (y))
+#define yaffs_strcmp(a, b) strcmp(a, b)
+
+#define TENDSTR "\n"
+#define TSTR(x) KERN_DEBUG x
+#define TCONT(x) x
+#define TOUT(p) printk p
+
+#define compile_time_assertion(assertion) \
+	({ int x = __builtin_choose_expr(assertion, 0, (void)0); (void) x; })
+
+#ifndef Y_DUMP_STACK
+#define Y_DUMP_STACK() do { } while (0)
+#endif
+
+#ifndef YBUG
+#define YBUG() do {\
+	T(YAFFS_TRACE_BUG,\
+		(TSTR("==>> yaffs bug: " __FILE__ " %d" TENDSTR),\
+		__LINE__));\
+	Y_DUMP_STACK();\
+} while (0)
+#endif
+
+#endif
-- 
1.7.1

