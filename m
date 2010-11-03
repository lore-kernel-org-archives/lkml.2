Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab0KCQy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:54:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39131 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab0KCQyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OcpT/8drCmi/kOogoli8MfLCNiTpGnufQXxLEieOe64UZeRoqoLkuDRrbZqLDrJtPT
         yFHz56yEJu1w+49OfMbpF5Nz27BtuOqL9zxnVwpa9zTwtJFtqX30lSFhSZ1WXfz+SET9
         4BunNf0WJWcI5cVHCwO50irD3GYBa+8xU9JVE=
From: cdhmanning@gmail.com
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 8/9] Add yaffs verification and version specific code.
Date: Thu,  4 Nov 2010 05:53:23 +1300
Message-Id: <1288803204-3849-9-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com>
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Manning <cdhmanning@gmail.com>

Adding yaffs2 file system.

Signed-off-by: Charles Manning <cdhmanning@gmail.com>
---
 fs/yaffs2/yaffs_verify.c |  546 ++++++++++++++++
 fs/yaffs2/yaffs_verify.h |   43 ++
 fs/yaffs2/yaffs_yaffs1.c |  438 +++++++++++++
 fs/yaffs2/yaffs_yaffs1.h |   22 +
 fs/yaffs2/yaffs_yaffs2.c | 1618 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/yaffs2/yaffs_yaffs2.h |   39 ++
 6 files changed, 2706 insertions(+), 0 deletions(-)
 create mode 100644 fs/yaffs2/yaffs_verify.c
 create mode 100644 fs/yaffs2/yaffs_verify.h
 create mode 100644 fs/yaffs2/yaffs_yaffs1.c
 create mode 100644 fs/yaffs2/yaffs_yaffs1.h
 create mode 100644 fs/yaffs2/yaffs_yaffs2.c
 create mode 100644 fs/yaffs2/yaffs_yaffs2.h

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
diff --git a/fs/yaffs2/yaffs_yaffs1.c b/fs/yaffs2/yaffs_yaffs1.c
new file mode 100644
index 0000000..4ab0f22
--- /dev/null
+++ b/fs/yaffs2/yaffs_yaffs1.c
@@ -0,0 +1,438 @@
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
+#include "yaffs_yaffs1.h"
+#include "yportenv.h"
+#include "yaffs_trace.h"
+#include "yaffs_bitmap.h"
+#include "yaffs_getblockinfo.h"
+#include "yaffs_nand.h"
+#include "yaffs_attribs.h"
+
+int yaffs1_scan(struct yaffs_dev *dev)
+{
+	struct yaffs_ext_tags tags;
+	int blk;
+	int result;
+
+	int chunk;
+	int c;
+	int deleted;
+	enum yaffs_block_state state;
+	struct yaffs_obj *hard_list = NULL;
+	struct yaffs_block_info *bi;
+	u32 seq_number;
+	struct yaffs_obj_hdr *oh;
+	struct yaffs_obj *in;
+	struct yaffs_obj *parent;
+
+	int alloc_failed = 0;
+
+	struct yaffs_shadow_fixer *shadow_fixers = NULL;
+
+	u8 *chunk_data;
+
+	T(YAFFS_TRACE_SCAN,
+	  (TSTR("yaffs1_scan starts  intstartblk %d intendblk %d..." TENDSTR),
+	   dev->internal_start_block, dev->internal_end_block));
+
+	chunk_data = yaffs_get_temp_buffer(dev, __LINE__);
+
+	dev->seq_number = YAFFS_LOWEST_SEQUENCE_NUMBER;
+
+	/* Scan all the blocks to determine their state */
+	bi = dev->block_info;
+	for (blk = dev->internal_start_block; blk <= dev->internal_end_block;
+	     blk++) {
+		yaffs_clear_chunk_bits(dev, blk);
+		bi->pages_in_use = 0;
+		bi->soft_del_pages = 0;
+
+		yaffs_query_init_block_state(dev, blk, &state, &seq_number);
+
+		bi->block_state = state;
+		bi->seq_number = seq_number;
+
+		if (bi->seq_number == YAFFS_SEQUENCE_BAD_BLOCK)
+			bi->block_state = state = YAFFS_BLOCK_STATE_DEAD;
+
+		T(YAFFS_TRACE_SCAN_DEBUG,
+		  (TSTR("Block scanning block %d state %d seq %d" TENDSTR), blk,
+		   state, seq_number));
+
+		if (state == YAFFS_BLOCK_STATE_DEAD) {
+			T(YAFFS_TRACE_BAD_BLOCKS,
+			  (TSTR("block %d is bad" TENDSTR), blk));
+		} else if (state == YAFFS_BLOCK_STATE_EMPTY) {
+			T(YAFFS_TRACE_SCAN_DEBUG,
+			  (TSTR("Block empty " TENDSTR)));
+			dev->n_erased_blocks++;
+			dev->n_free_chunks += dev->param.chunks_per_block;
+		}
+		bi++;
+	}
+
+	/* For each block.... */
+	for (blk = dev->internal_start_block;
+	     !alloc_failed && blk <= dev->internal_end_block; blk++) {
+
+		YYIELD();
+
+		bi = yaffs_get_block_info(dev, blk);
+		state = bi->block_state;
+
+		deleted = 0;
+
+		/* For each chunk in each block that needs scanning.... */
+		for (c = 0; !alloc_failed && c < dev->param.chunks_per_block &&
+		     state == YAFFS_BLOCK_STATE_NEEDS_SCANNING; c++) {
+			/* Read the tags and decide what to do */
+			chunk = blk * dev->param.chunks_per_block + c;
+
+			result = yaffs_rd_chunk_tags_nand(dev, chunk, NULL,
+							  &tags);
+
+			/* Let's have a good look at this chunk... */
+
+			if (tags.ecc_result == YAFFS_ECC_RESULT_UNFIXED
+			    || tags.is_deleted) {
+				/* YAFFS1 only...
+				 * A deleted chunk
+				 */
+				deleted++;
+				dev->n_free_chunks++;
+				/*T((" %d %d deleted\n",blk,c)); */
+			} else if (!tags.chunk_used) {
+				/* An unassigned chunk in the block
+				 * This means that either the block is empty or
+				 * this is the one being allocated from
+				 */
+
+				if (c == 0) {
+					/* We're looking at the first chunk in the block so the block is unused */
+					state = YAFFS_BLOCK_STATE_EMPTY;
+					dev->n_erased_blocks++;
+				} else {
+					/* this is the block being allocated from */
+					T(YAFFS_TRACE_SCAN,
+					  (TSTR
+					   (" Allocating from %d %d" TENDSTR),
+					   blk, c));
+					state = YAFFS_BLOCK_STATE_ALLOCATING;
+					dev->alloc_block = blk;
+					dev->alloc_page = c;
+					dev->alloc_block_finder = blk;
+					/* Set block finder here to encourage the allocator to go forth from here. */
+
+				}
+
+				dev->n_free_chunks +=
+				    (dev->param.chunks_per_block - c);
+			} else if (tags.chunk_id > 0) {
+				/* chunk_id > 0 so it is a data chunk... */
+				unsigned int endpos;
+
+				yaffs_set_chunk_bit(dev, blk, c);
+				bi->pages_in_use++;
+
+				in = yaffs_find_or_create_by_number(dev,
+								    tags.obj_id,
+								    YAFFS_OBJECT_TYPE_FILE);
+				/* PutChunkIntoFile checks for a clash (two data chunks with
+				 * the same chunk_id).
+				 */
+
+				if (!in)
+					alloc_failed = 1;
+
+				if (in) {
+					if (!yaffs_put_chunk_in_file
+					    (in, tags.chunk_id, chunk, 1))
+						alloc_failed = 1;
+				}
+
+				endpos =
+				    (tags.chunk_id -
+				     1) * dev->data_bytes_per_chunk +
+				    tags.n_bytes;
+				if (in
+				    && in->variant_type ==
+				    YAFFS_OBJECT_TYPE_FILE
+				    && in->variant.file_variant.scanned_size <
+				    endpos) {
+					in->variant.file_variant.scanned_size =
+					    endpos;
+					if (!dev->param.use_header_file_size) {
+						in->variant.
+						    file_variant.file_size =
+						    in->variant.
+						    file_variant.scanned_size;
+					}
+
+				}
+				/* T((" %d %d data %d %d\n",blk,c,tags.obj_id,tags.chunk_id));   */
+			} else {
+				/* chunk_id == 0, so it is an ObjectHeader.
+				 * Thus, we read in the object header and make the object
+				 */
+				yaffs_set_chunk_bit(dev, blk, c);
+				bi->pages_in_use++;
+
+				result = yaffs_rd_chunk_tags_nand(dev, chunk,
+								  chunk_data,
+								  NULL);
+
+				oh = (struct yaffs_obj_hdr *)chunk_data;
+
+				in = yaffs_find_by_number(dev, tags.obj_id);
+				if (in && in->variant_type != oh->type) {
+					/* This should not happen, but somehow
+					 * Wev'e ended up with an obj_id that has been reused but not yet
+					 * deleted, and worse still it has changed type. Delete the old object.
+					 */
+
+					yaffs_del_obj(in);
+
+					in = 0;
+				}
+
+				in = yaffs_find_or_create_by_number(dev,
+								    tags.obj_id,
+								    oh->type);
+
+				if (!in)
+					alloc_failed = 1;
+
+				if (in && oh->shadows_obj > 0) {
+
+					struct yaffs_shadow_fixer *fixer;
+					fixer =
+					    YMALLOC(sizeof
+						    (struct
+						     yaffs_shadow_fixer));
+					if (fixer) {
+						fixer->next = shadow_fixers;
+						shadow_fixers = fixer;
+						fixer->obj_id = tags.obj_id;
+						fixer->shadowed_id =
+						    oh->shadows_obj;
+						T(YAFFS_TRACE_SCAN,
+						  (TSTR
+						   (" Shadow fixer: %d shadows %d"
+						    TENDSTR), fixer->obj_id,
+						   fixer->shadowed_id));
+
+					}
+
+				}
+
+				if (in && in->valid) {
+					/* We have already filled this one. We have a duplicate and need to resolve it. */
+
+					unsigned existing_serial = in->serial;
+					unsigned new_serial =
+					    tags.serial_number;
+
+					if (((existing_serial + 1) & 3) ==
+					    new_serial) {
+						/* Use new one - destroy the exisiting one */
+						yaffs_chunk_del(dev,
+								in->hdr_chunk,
+								1, __LINE__);
+						in->valid = 0;
+					} else {
+						/* Use existing - destroy this one. */
+						yaffs_chunk_del(dev, chunk, 1,
+								__LINE__);
+					}
+				}
+
+				if (in && !in->valid &&
+				    (tags.obj_id == YAFFS_OBJECTID_ROOT ||
+				     tags.obj_id ==
+				     YAFFS_OBJECTID_LOSTNFOUND)) {
+					/* We only load some info, don't fiddle with directory structure */
+					in->valid = 1;
+					in->variant_type = oh->type;
+
+					in->yst_mode = oh->yst_mode;
+					yaffs_load_attribs(in, oh);
+					in->hdr_chunk = chunk;
+					in->serial = tags.serial_number;
+
+				} else if (in && !in->valid) {
+					/* we need to load this info */
+
+					in->valid = 1;
+					in->variant_type = oh->type;
+
+					in->yst_mode = oh->yst_mode;
+					yaffs_load_attribs(in, oh);
+					in->hdr_chunk = chunk;
+					in->serial = tags.serial_number;
+
+					yaffs_set_obj_name_from_oh(in, oh);
+					in->dirty = 0;
+
+					/* directory stuff...
+					 * hook up to parent
+					 */
+
+					parent =
+					    yaffs_find_or_create_by_number
+					    (dev, oh->parent_obj_id,
+					     YAFFS_OBJECT_TYPE_DIRECTORY);
+					if (!parent)
+						alloc_failed = 1;
+					if (parent && parent->variant_type ==
+					    YAFFS_OBJECT_TYPE_UNKNOWN) {
+						/* Set up as a directory */
+						parent->variant_type =
+						    YAFFS_OBJECT_TYPE_DIRECTORY;
+						INIT_LIST_HEAD(&parent->
+							       variant.dir_variant.children);
+					} else if (!parent
+						   || parent->variant_type !=
+						   YAFFS_OBJECT_TYPE_DIRECTORY)
+					{
+						/* Hoosterman, another problem....
+						 * We're trying to use a non-directory as a directory
+						 */
+
+						T(YAFFS_TRACE_ERROR,
+						  (TSTR
+						   ("yaffs tragedy: attempting to use non-directory as a directory in scan. Put in lost+found."
+						    TENDSTR)));
+						parent = dev->lost_n_found;
+					}
+
+					yaffs_add_obj_to_dir(parent, in);
+
+					if (0 && (parent == dev->del_dir ||
+						  parent ==
+						  dev->unlinked_dir)) {
+						in->deleted = 1;	/* If it is unlinked at start up then it wants deleting */
+						dev->n_deleted_files++;
+					}
+					/* Note re hardlinks.
+					 * Since we might scan a hardlink before its equivalent object is scanned
+					 * we put them all in a list.
+					 * After scanning is complete, we should have all the objects, so we run through this
+					 * list and fix up all the chains.
+					 */
+
+					switch (in->variant_type) {
+					case YAFFS_OBJECT_TYPE_UNKNOWN:
+						/* Todo got a problem */
+						break;
+					case YAFFS_OBJECT_TYPE_FILE:
+						if (dev->param.
+						    use_header_file_size)
+
+							in->variant.
+							    file_variant.file_size
+							    = oh->file_size;
+
+						break;
+					case YAFFS_OBJECT_TYPE_HARDLINK:
+						in->variant.
+						    hardlink_variant.equiv_id =
+						    oh->equiv_id;
+						in->hard_links.next =
+						    (struct list_head *)
+						    hard_list;
+						hard_list = in;
+						break;
+					case YAFFS_OBJECT_TYPE_DIRECTORY:
+						/* Do nothing */
+						break;
+					case YAFFS_OBJECT_TYPE_SPECIAL:
+						/* Do nothing */
+						break;
+					case YAFFS_OBJECT_TYPE_SYMLINK:
+						in->variant.symlink_variant.
+						    alias =
+						    yaffs_clone_str(oh->alias);
+						if (!in->variant.
+						    symlink_variant.alias)
+							alloc_failed = 1;
+						break;
+					}
+
+				}
+			}
+		}
+
+		if (state == YAFFS_BLOCK_STATE_NEEDS_SCANNING) {
+			/* If we got this far while scanning, then the block is fully allocated. */
+			state = YAFFS_BLOCK_STATE_FULL;
+		}
+
+		if (state == YAFFS_BLOCK_STATE_ALLOCATING) {
+			/* If the block was partially allocated then treat it as fully allocated. */
+			state = YAFFS_BLOCK_STATE_FULL;
+			dev->alloc_block = -1;
+		}
+
+		bi->block_state = state;
+
+		/* Now let's see if it was dirty */
+		if (bi->pages_in_use == 0 &&
+		    !bi->has_shrink_hdr &&
+		    bi->block_state == YAFFS_BLOCK_STATE_FULL) {
+			yaffs_block_became_dirty(dev, blk);
+		}
+
+	}
+
+	/* Ok, we've done all the scanning.
+	 * Fix up the hard link chains.
+	 * We should now have scanned all the objects, now it's time to add these
+	 * hardlinks.
+	 */
+
+	yaffs_link_fixup(dev, hard_list);
+
+	/* Fix up any shadowed objects */
+	{
+		struct yaffs_shadow_fixer *fixer;
+		struct yaffs_obj *obj;
+
+		while (shadow_fixers) {
+			fixer = shadow_fixers;
+			shadow_fixers = fixer->next;
+			/* Complete the rename transaction by deleting the shadowed object
+			 * then setting the object header to unshadowed.
+			 */
+			obj = yaffs_find_by_number(dev, fixer->shadowed_id);
+			if (obj)
+				yaffs_del_obj(obj);
+
+			obj = yaffs_find_by_number(dev, fixer->obj_id);
+
+			if (obj)
+				yaffs_update_oh(obj, NULL, 1, 0, 0, NULL);
+
+			YFREE(fixer);
+		}
+	}
+
+	yaffs_release_temp_buffer(dev, chunk_data, __LINE__);
+
+	if (alloc_failed)
+		return YAFFS_FAIL;
+
+	T(YAFFS_TRACE_SCAN, (TSTR("yaffs1_scan ends" TENDSTR)));
+
+	return YAFFS_OK;
+}
diff --git a/fs/yaffs2/yaffs_yaffs1.h b/fs/yaffs2/yaffs_yaffs1.h
new file mode 100644
index 0000000..db23e04
--- /dev/null
+++ b/fs/yaffs2/yaffs_yaffs1.h
@@ -0,0 +1,22 @@
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
+#ifndef __YAFFS_YAFFS1_H__
+#define __YAFFS_YAFFS1_H__
+
+#include "yaffs_guts.h"
+int yaffs1_scan(struct yaffs_dev *dev);
+
+#endif
diff --git a/fs/yaffs2/yaffs_yaffs2.c b/fs/yaffs2/yaffs_yaffs2.c
new file mode 100644
index 0000000..97dac45
--- /dev/null
+++ b/fs/yaffs2/yaffs_yaffs2.c
@@ -0,0 +1,1618 @@
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
+#include "yaffs_guts.h"
+#include "yaffs_trace.h"
+#include "yaffs_yaffs2.h"
+#include "yaffs_checkptrw.h"
+#include "yaffs_bitmap.h"
+#include "yaffs_nand.h"
+#include "yaffs_getblockinfo.h"
+#include "yaffs_verify.h"
+#include "yaffs_attribs.h"
+
+/*
+ * Checkpoints are really no benefit on very small partitions.
+ *
+ * To save space on small partitions don't bother with checkpoints unless
+ * the partition is at least this big.
+ */
+#define YAFFS_CHECKPOINT_MIN_BLOCKS 60
+
+#define YAFFS_SMALL_HOLE_THRESHOLD 4
+
+/*
+ * Oldest Dirty Sequence Number handling.
+ */
+
+/* yaffs_calc_oldest_dirty_seq()
+ * yaffs2_find_oldest_dirty_seq()
+ * Calculate the oldest dirty sequence number if we don't know it.
+ */
+void yaffs_calc_oldest_dirty_seq(struct yaffs_dev *dev)
+{
+	int i;
+	unsigned seq;
+	unsigned block_no = 0;
+	struct yaffs_block_info *b;
+
+	if (!dev->param.is_yaffs2)
+		return;
+
+	/* Find the oldest dirty sequence number. */
+	seq = dev->seq_number + 1;
+	b = dev->block_info;
+	for (i = dev->internal_start_block; i <= dev->internal_end_block; i++) {
+		if (b->block_state == YAFFS_BLOCK_STATE_FULL &&
+		    (b->pages_in_use - b->soft_del_pages) <
+		    dev->param.chunks_per_block && b->seq_number < seq) {
+			seq = b->seq_number;
+			block_no = i;
+		}
+		b++;
+	}
+
+	if (block_no) {
+		dev->oldest_dirty_seq = seq;
+		dev->oldest_dirty_block = block_no;
+	}
+
+}
+
+void yaffs2_find_oldest_dirty_seq(struct yaffs_dev *dev)
+{
+	if (!dev->param.is_yaffs2)
+		return;
+
+	if (!dev->oldest_dirty_seq)
+		yaffs_calc_oldest_dirty_seq(dev);
+}
+
+/*
+ * yaffs_clear_oldest_dirty_seq()
+ * Called when a block is erased or marked bad. (ie. when its seq_number
+ * becomes invalid). If the value matches the oldest then we clear 
+ * dev->oldest_dirty_seq to force its recomputation.
+ */
+void yaffs2_clear_oldest_dirty_seq(struct yaffs_dev *dev,
+				   struct yaffs_block_info *bi)
+{
+
+	if (!dev->param.is_yaffs2)
+		return;
+
+	if (!bi || bi->seq_number == dev->oldest_dirty_seq) {
+		dev->oldest_dirty_seq = 0;
+		dev->oldest_dirty_block = 0;
+	}
+}
+
+/*
+ * yaffs2_update_oldest_dirty_seq()
+ * Update the oldest dirty sequence number whenever we dirty a block.
+ * Only do this if the oldest_dirty_seq is actually being tracked.
+ */
+void yaffs2_update_oldest_dirty_seq(struct yaffs_dev *dev, unsigned block_no,
+				    struct yaffs_block_info *bi)
+{
+	if (!dev->param.is_yaffs2)
+		return;
+
+	if (dev->oldest_dirty_seq) {
+		if (dev->oldest_dirty_seq > bi->seq_number) {
+			dev->oldest_dirty_seq = bi->seq_number;
+			dev->oldest_dirty_block = block_no;
+		}
+	}
+}
+
+int yaffs_block_ok_for_gc(struct yaffs_dev *dev, struct yaffs_block_info *bi)
+{
+
+	if (!dev->param.is_yaffs2)
+		return 1;	/* disqualification only applies to yaffs2. */
+
+	if (!bi->has_shrink_hdr)
+		return 1;	/* can gc */
+
+	yaffs2_find_oldest_dirty_seq(dev);
+
+	/* Can't do gc of this block if there are any blocks older than this one that have
+	 * discarded pages.
+	 */
+	return (bi->seq_number <= dev->oldest_dirty_seq);
+}
+
+/*
+ * yaffs2_find_refresh_block()
+ * periodically finds the oldest full block by sequence number for refreshing.
+ * Only for yaffs2.
+ */
+u32 yaffs2_find_refresh_block(struct yaffs_dev * dev)
+{
+	u32 b;
+
+	u32 oldest = 0;
+	u32 oldest_seq = 0;
+
+	struct yaffs_block_info *bi;
+
+	if (!dev->param.is_yaffs2)
+		return oldest;
+
+	/*
+	 * If refresh period < 10 then refreshing is disabled.
+	 */
+	if (dev->param.refresh_period < 10)
+		return oldest;
+
+	/*
+	 * Fix broken values.
+	 */
+	if (dev->refresh_skip > dev->param.refresh_period)
+		dev->refresh_skip = dev->param.refresh_period;
+
+	if (dev->refresh_skip > 0)
+		return oldest;
+
+	/*
+	 * Refresh skip is now zero.
+	 * We'll do a refresh this time around....
+	 * Update the refresh skip and find the oldest block.
+	 */
+	dev->refresh_skip = dev->param.refresh_period;
+	dev->refresh_count++;
+	bi = dev->block_info;
+	for (b = dev->internal_start_block; b <= dev->internal_end_block; b++) {
+
+		if (bi->block_state == YAFFS_BLOCK_STATE_FULL) {
+
+			if (oldest < 1 || bi->seq_number < oldest_seq) {
+				oldest = b;
+				oldest_seq = bi->seq_number;
+			}
+		}
+		bi++;
+	}
+
+	if (oldest > 0) {
+		T(YAFFS_TRACE_GC,
+		  (TSTR
+		   ("GC refresh count %d selected block %d with seq_number %d"
+		    TENDSTR), dev->refresh_count, oldest, oldest_seq));
+	}
+
+	return oldest;
+}
+
+int yaffs2_checkpt_required(struct yaffs_dev *dev)
+{
+	int nblocks;
+
+	if (!dev->param.is_yaffs2)
+		return 0;
+
+	nblocks = dev->internal_end_block - dev->internal_start_block + 1;
+
+	return !dev->param.skip_checkpt_wr &&
+	    !dev->read_only && (nblocks >= YAFFS_CHECKPOINT_MIN_BLOCKS);
+}
+
+int yaffs_calc_checkpt_blocks_required(struct yaffs_dev *dev)
+{
+	int retval;
+
+	if (!dev->param.is_yaffs2)
+		return 0;
+
+	if (!dev->checkpoint_blocks_required && yaffs2_checkpt_required(dev)) {
+		/* Not a valid value so recalculate */
+		int n_bytes = 0;
+		int n_blocks;
+		int dev_blocks =
+		    (dev->param.end_block - dev->param.start_block + 1);
+
+		n_bytes += sizeof(struct yaffs_checkpt_validity);
+		n_bytes += sizeof(struct yaffs_checkpt_dev);
+		n_bytes += dev_blocks * sizeof(struct yaffs_block_info);
+		n_bytes += dev_blocks * dev->chunk_bit_stride;
+		n_bytes +=
+		    (sizeof(struct yaffs_checkpt_obj) +
+		     sizeof(u32)) * (dev->n_obj);
+		n_bytes += (dev->tnode_size + sizeof(u32)) * (dev->n_tnodes);
+		n_bytes += sizeof(struct yaffs_checkpt_validity);
+		n_bytes += sizeof(u32);	/* checksum */
+
+		/* Round up and add 2 blocks to allow for some bad blocks, so add 3 */
+
+		n_blocks =
+		    (n_bytes /
+		     (dev->data_bytes_per_chunk *
+		      dev->param.chunks_per_block)) + 3;
+
+		dev->checkpoint_blocks_required = n_blocks;
+	}
+
+	retval = dev->checkpoint_blocks_required - dev->blocks_in_checkpt;
+	if (retval < 0)
+		retval = 0;
+	return retval;
+}
+
+/*--------------------- Checkpointing --------------------*/
+
+static int yaffs2_wr_checkpt_validity_marker(struct yaffs_dev *dev, int head)
+{
+	struct yaffs_checkpt_validity cp;
+
+	memset(&cp, 0, sizeof(cp));
+
+	cp.struct_type = sizeof(cp);
+	cp.magic = YAFFS_MAGIC;
+	cp.version = YAFFS_CHECKPOINT_VERSION;
+	cp.head = (head) ? 1 : 0;
+
+	return (yaffs2_checkpt_wr(dev, &cp, sizeof(cp)) == sizeof(cp)) ? 1 : 0;
+}
+
+static int yaffs2_rd_checkpt_validity_marker(struct yaffs_dev *dev, int head)
+{
+	struct yaffs_checkpt_validity cp;
+	int ok;
+
+	ok = (yaffs2_checkpt_rd(dev, &cp, sizeof(cp)) == sizeof(cp));
+
+	if (ok)
+		ok = (cp.struct_type == sizeof(cp)) &&
+		    (cp.magic == YAFFS_MAGIC) &&
+		    (cp.version == YAFFS_CHECKPOINT_VERSION) &&
+		    (cp.head == ((head) ? 1 : 0));
+	return ok ? 1 : 0;
+}
+
+static void yaffs2_dev_to_checkpt_dev(struct yaffs_checkpt_dev *cp,
+				      struct yaffs_dev *dev)
+{
+	cp->n_erased_blocks = dev->n_erased_blocks;
+	cp->alloc_block = dev->alloc_block;
+	cp->alloc_page = dev->alloc_page;
+	cp->n_free_chunks = dev->n_free_chunks;
+
+	cp->n_deleted_files = dev->n_deleted_files;
+	cp->n_unlinked_files = dev->n_unlinked_files;
+	cp->n_bg_deletions = dev->n_bg_deletions;
+	cp->seq_number = dev->seq_number;
+
+}
+
+static void yaffs_checkpt_dev_to_dev(struct yaffs_dev *dev,
+				     struct yaffs_checkpt_dev *cp)
+{
+	dev->n_erased_blocks = cp->n_erased_blocks;
+	dev->alloc_block = cp->alloc_block;
+	dev->alloc_page = cp->alloc_page;
+	dev->n_free_chunks = cp->n_free_chunks;
+
+	dev->n_deleted_files = cp->n_deleted_files;
+	dev->n_unlinked_files = cp->n_unlinked_files;
+	dev->n_bg_deletions = cp->n_bg_deletions;
+	dev->seq_number = cp->seq_number;
+}
+
+static int yaffs2_wr_checkpt_dev(struct yaffs_dev *dev)
+{
+	struct yaffs_checkpt_dev cp;
+	u32 n_bytes;
+	u32 n_blocks =
+	    (dev->internal_end_block - dev->internal_start_block + 1);
+
+	int ok;
+
+	/* Write device runtime values */
+	yaffs2_dev_to_checkpt_dev(&cp, dev);
+	cp.struct_type = sizeof(cp);
+
+	ok = (yaffs2_checkpt_wr(dev, &cp, sizeof(cp)) == sizeof(cp));
+
+	/* Write block info */
+	if (ok) {
+		n_bytes = n_blocks * sizeof(struct yaffs_block_info);
+		ok = (yaffs2_checkpt_wr(dev, dev->block_info, n_bytes) ==
+		      n_bytes);
+	}
+
+	/* Write chunk bits */
+	if (ok) {
+		n_bytes = n_blocks * dev->chunk_bit_stride;
+		ok = (yaffs2_checkpt_wr(dev, dev->chunk_bits, n_bytes) ==
+		      n_bytes);
+	}
+	return ok ? 1 : 0;
+
+}
+
+static int yaffs2_rd_checkpt_dev(struct yaffs_dev *dev)
+{
+	struct yaffs_checkpt_dev cp;
+	u32 n_bytes;
+	u32 n_blocks =
+	    (dev->internal_end_block - dev->internal_start_block + 1);
+
+	int ok;
+
+	ok = (yaffs2_checkpt_rd(dev, &cp, sizeof(cp)) == sizeof(cp));
+	if (!ok)
+		return 0;
+
+	if (cp.struct_type != sizeof(cp))
+		return 0;
+
+	yaffs_checkpt_dev_to_dev(dev, &cp);
+
+	n_bytes = n_blocks * sizeof(struct yaffs_block_info);
+
+	ok = (yaffs2_checkpt_rd(dev, dev->block_info, n_bytes) == n_bytes);
+
+	if (!ok)
+		return 0;
+	n_bytes = n_blocks * dev->chunk_bit_stride;
+
+	ok = (yaffs2_checkpt_rd(dev, dev->chunk_bits, n_bytes) == n_bytes);
+
+	return ok ? 1 : 0;
+}
+
+static void yaffs2_obj_checkpt_obj(struct yaffs_checkpt_obj *cp,
+				   struct yaffs_obj *obj)
+{
+
+	cp->obj_id = obj->obj_id;
+	cp->parent_id = (obj->parent) ? obj->parent->obj_id : 0;
+	cp->hdr_chunk = obj->hdr_chunk;
+	cp->variant_type = obj->variant_type;
+	cp->deleted = obj->deleted;
+	cp->soft_del = obj->soft_del;
+	cp->unlinked = obj->unlinked;
+	cp->fake = obj->fake;
+	cp->rename_allowed = obj->rename_allowed;
+	cp->unlink_allowed = obj->unlink_allowed;
+	cp->serial = obj->serial;
+	cp->n_data_chunks = obj->n_data_chunks;
+
+	if (obj->variant_type == YAFFS_OBJECT_TYPE_FILE)
+		cp->size_or_equiv_obj = obj->variant.file_variant.file_size;
+	else if (obj->variant_type == YAFFS_OBJECT_TYPE_HARDLINK)
+		cp->size_or_equiv_obj = obj->variant.hardlink_variant.equiv_id;
+}
+
+static int taffs2_checkpt_obj_to_obj(struct yaffs_obj *obj,
+				     struct yaffs_checkpt_obj *cp)
+{
+
+	struct yaffs_obj *parent;
+
+	if (obj->variant_type != cp->variant_type) {
+		T(YAFFS_TRACE_ERROR, (TSTR("Checkpoint read object %d type %d "
+					   TCONT
+					   ("chunk %d does not match existing object type %d")
+					   TENDSTR), cp->obj_id,
+				      cp->variant_type, cp->hdr_chunk,
+				      obj->variant_type));
+		return 0;
+	}
+
+	obj->obj_id = cp->obj_id;
+
+	if (cp->parent_id)
+		parent = yaffs_find_or_create_by_number(obj->my_dev,
+							cp->parent_id,
+							YAFFS_OBJECT_TYPE_DIRECTORY);
+	else
+		parent = NULL;
+
+	if (parent) {
+		if (parent->variant_type != YAFFS_OBJECT_TYPE_DIRECTORY) {
+			T(YAFFS_TRACE_ALWAYS,
+			  (TSTR
+			   ("Checkpoint read object %d parent %d type %d"
+			    TCONT(" chunk %d Parent type, %d, not directory")
+			    TENDSTR), cp->obj_id, cp->parent_id,
+			   cp->variant_type, cp->hdr_chunk,
+			   parent->variant_type));
+			return 0;
+		}
+		yaffs_add_obj_to_dir(parent, obj);
+	}
+
+	obj->hdr_chunk = cp->hdr_chunk;
+	obj->variant_type = cp->variant_type;
+	obj->deleted = cp->deleted;
+	obj->soft_del = cp->soft_del;
+	obj->unlinked = cp->unlinked;
+	obj->fake = cp->fake;
+	obj->rename_allowed = cp->rename_allowed;
+	obj->unlink_allowed = cp->unlink_allowed;
+	obj->serial = cp->serial;
+	obj->n_data_chunks = cp->n_data_chunks;
+
+	if (obj->variant_type == YAFFS_OBJECT_TYPE_FILE)
+		obj->variant.file_variant.file_size = cp->size_or_equiv_obj;
+	else if (obj->variant_type == YAFFS_OBJECT_TYPE_HARDLINK)
+		obj->variant.hardlink_variant.equiv_id = cp->size_or_equiv_obj;
+
+	if (obj->hdr_chunk > 0)
+		obj->lazy_loaded = 1;
+	return 1;
+}
+
+static int yaffs2_checkpt_tnode_worker(struct yaffs_obj *in,
+				       struct yaffs_tnode *tn, u32 level,
+				       int chunk_offset)
+{
+	int i;
+	struct yaffs_dev *dev = in->my_dev;
+	int ok = 1;
+
+	if (tn) {
+		if (level > 0) {
+
+			for (i = 0; i < YAFFS_NTNODES_INTERNAL && ok; i++) {
+				if (tn->internal[i]) {
+					ok = yaffs2_checkpt_tnode_worker(in,
+									 tn->
+									 internal
+									 [i],
+									 level -
+									 1,
+									 (chunk_offset
+									  <<
+									  YAFFS_TNODES_INTERNAL_BITS)
+									 + i);
+				}
+			}
+		} else if (level == 0) {
+			u32 base_offset =
+			    chunk_offset << YAFFS_TNODES_LEVEL0_BITS;
+			ok = (yaffs2_checkpt_wr
+			      (dev, &base_offset,
+			       sizeof(base_offset)) == sizeof(base_offset));
+			if (ok)
+				ok = (yaffs2_checkpt_wr
+				      (dev, tn,
+				       dev->tnode_size) == dev->tnode_size);
+		}
+	}
+
+	return ok;
+
+}
+
+static int yaffs2_wr_checkpt_tnodes(struct yaffs_obj *obj)
+{
+	u32 end_marker = ~0;
+	int ok = 1;
+
+	if (obj->variant_type == YAFFS_OBJECT_TYPE_FILE) {
+		ok = yaffs2_checkpt_tnode_worker(obj,
+						 obj->variant.file_variant.top,
+						 obj->variant.file_variant.
+						 top_level, 0);
+		if (ok)
+			ok = (yaffs2_checkpt_wr
+			      (obj->my_dev, &end_marker,
+			       sizeof(end_marker)) == sizeof(end_marker));
+	}
+
+	return ok ? 1 : 0;
+}
+
+static int yaffs2_rd_checkpt_tnodes(struct yaffs_obj *obj)
+{
+	u32 base_chunk;
+	int ok = 1;
+	struct yaffs_dev *dev = obj->my_dev;
+	struct yaffs_file_var *file_stuct_ptr = &obj->variant.file_variant;
+	struct yaffs_tnode *tn;
+	int nread = 0;
+
+	ok = (yaffs2_checkpt_rd(dev, &base_chunk, sizeof(base_chunk)) ==
+	      sizeof(base_chunk));
+
+	while (ok && (~base_chunk)) {
+		nread++;
+		/* Read level 0 tnode */
+
+		tn = yaffs_get_tnode(dev);
+		if (tn) {
+			ok = (yaffs2_checkpt_rd(dev, tn, dev->tnode_size) ==
+			      dev->tnode_size);
+		} else
+			ok = 0;
+
+		if (tn && ok)
+			ok = yaffs_add_find_tnode_0(dev,
+						    file_stuct_ptr,
+						    base_chunk, tn) ? 1 : 0;
+
+		if (ok)
+			ok = (yaffs2_checkpt_rd
+			      (dev, &base_chunk,
+			       sizeof(base_chunk)) == sizeof(base_chunk));
+
+	}
+
+	T(YAFFS_TRACE_CHECKPOINT,
+	  (TSTR("Checkpoint read tnodes %d records, last %d. ok %d" TENDSTR),
+	   nread, base_chunk, ok));
+
+	return ok ? 1 : 0;
+}
+
+static int yaffs2_wr_checkpt_objs(struct yaffs_dev *dev)
+{
+	struct yaffs_obj *obj;
+	struct yaffs_checkpt_obj cp;
+	int i;
+	int ok = 1;
+	struct list_head *lh;
+
+	/* Iterate through the objects in each hash entry,
+	 * dumping them to the checkpointing stream.
+	 */
+
+	for (i = 0; ok && i < YAFFS_NOBJECT_BUCKETS; i++) {
+		list_for_each(lh, &dev->obj_bucket[i].list) {
+			if (lh) {
+				obj =
+				    list_entry(lh, struct yaffs_obj, hash_link);
+				if (!obj->defered_free) {
+					yaffs2_obj_checkpt_obj(&cp, obj);
+					cp.struct_type = sizeof(cp);
+
+					T(YAFFS_TRACE_CHECKPOINT,
+					  (TSTR
+					   ("Checkpoint write object %d parent %d type %d chunk %d obj addr %p"
+					    TENDSTR), cp.obj_id, cp.parent_id,
+					   cp.variant_type, cp.hdr_chunk, obj));
+
+					ok = (yaffs2_checkpt_wr
+					      (dev, &cp,
+					       sizeof(cp)) == sizeof(cp));
+
+					if (ok
+					    && obj->variant_type ==
+					    YAFFS_OBJECT_TYPE_FILE)
+						ok = yaffs2_wr_checkpt_tnodes
+						    (obj);
+				}
+			}
+		}
+	}
+
+	/* Dump end of list */
+	memset(&cp, 0xFF, sizeof(struct yaffs_checkpt_obj));
+	cp.struct_type = sizeof(cp);
+
+	if (ok)
+		ok = (yaffs2_checkpt_wr(dev, &cp, sizeof(cp)) == sizeof(cp));
+
+	return ok ? 1 : 0;
+}
+
+static int yaffs2_rd_checkpt_objs(struct yaffs_dev *dev)
+{
+	struct yaffs_obj *obj;
+	struct yaffs_checkpt_obj cp;
+	int ok = 1;
+	int done = 0;
+	struct yaffs_obj *hard_list = NULL;
+
+	while (ok && !done) {
+		ok = (yaffs2_checkpt_rd(dev, &cp, sizeof(cp)) == sizeof(cp));
+		if (cp.struct_type != sizeof(cp)) {
+			T(YAFFS_TRACE_CHECKPOINT,
+			  (TSTR("struct size %d instead of %d ok %d" TENDSTR),
+			   cp.struct_type, (int)sizeof(cp), ok));
+			ok = 0;
+		}
+
+		T(YAFFS_TRACE_CHECKPOINT,
+		  (TSTR
+		   ("Checkpoint read object %d parent %d type %d chunk %d "
+		    TENDSTR), cp.obj_id, cp.parent_id, cp.variant_type,
+		   cp.hdr_chunk));
+
+		if (ok && cp.obj_id == ~0)
+			done = 1;
+		else if (ok) {
+			obj =
+			    yaffs_find_or_create_by_number(dev, cp.obj_id,
+							   cp.variant_type);
+			if (obj) {
+				ok = taffs2_checkpt_obj_to_obj(obj, &cp);
+				if (!ok)
+					break;
+				if (obj->variant_type == YAFFS_OBJECT_TYPE_FILE) {
+					ok = yaffs2_rd_checkpt_tnodes(obj);
+				} else if (obj->variant_type ==
+					   YAFFS_OBJECT_TYPE_HARDLINK) {
+					obj->hard_links.next =
+					    (struct list_head *)hard_list;
+					hard_list = obj;
+				}
+			} else
+				ok = 0;
+		}
+	}
+
+	if (ok)
+		yaffs_link_fixup(dev, hard_list);
+
+	return ok ? 1 : 0;
+}
+
+static int yaffs2_wr_checkpt_sum(struct yaffs_dev *dev)
+{
+	u32 checkpt_sum;
+	int ok;
+
+	yaffs2_get_checkpt_sum(dev, &checkpt_sum);
+
+	ok = (yaffs2_checkpt_wr(dev, &checkpt_sum, sizeof(checkpt_sum)) ==
+	      sizeof(checkpt_sum));
+
+	if (!ok)
+		return 0;
+
+	return 1;
+}
+
+static int yaffs2_rd_checkpt_sum(struct yaffs_dev *dev)
+{
+	u32 checkpt_sum0;
+	u32 checkpt_sum1;
+	int ok;
+
+	yaffs2_get_checkpt_sum(dev, &checkpt_sum0);
+
+	ok = (yaffs2_checkpt_rd(dev, &checkpt_sum1, sizeof(checkpt_sum1)) ==
+	      sizeof(checkpt_sum1));
+
+	if (!ok)
+		return 0;
+
+	if (checkpt_sum0 != checkpt_sum1)
+		return 0;
+
+	return 1;
+}
+
+static int yaffs2_wr_checkpt_data(struct yaffs_dev *dev)
+{
+	int ok = 1;
+
+	if (!yaffs2_checkpt_required(dev)) {
+		T(YAFFS_TRACE_CHECKPOINT,
+		  (TSTR("skipping checkpoint write" TENDSTR)));
+		ok = 0;
+	}
+
+	if (ok)
+		ok = yaffs2_checkpt_open(dev, 1);
+
+	if (ok) {
+		T(YAFFS_TRACE_CHECKPOINT,
+		  (TSTR("write checkpoint validity" TENDSTR)));
+		ok = yaffs2_wr_checkpt_validity_marker(dev, 1);
+	}
+	if (ok) {
+		T(YAFFS_TRACE_CHECKPOINT,
+		  (TSTR("write checkpoint device" TENDSTR)));
+		ok = yaffs2_wr_checkpt_dev(dev);
+	}
+	if (ok) {
+		T(YAFFS_TRACE_CHECKPOINT,
+		  (TSTR("write checkpoint objects" TENDSTR)));
+		ok = yaffs2_wr_checkpt_objs(dev);
+	}
+	if (ok) {
+		T(YAFFS_TRACE_CHECKPOINT,
+		  (TSTR("write checkpoint validity" TENDSTR)));
+		ok = yaffs2_wr_checkpt_validity_marker(dev, 0);
+	}
+
+	if (ok)
+		ok = yaffs2_wr_checkpt_sum(dev);
+
+	if (!yaffs_checkpt_close(dev))
+		ok = 0;
+
+	if (ok)
+		dev->is_checkpointed = 1;
+	else
+		dev->is_checkpointed = 0;
+
+	return dev->is_checkpointed;
+}
+
+static int yaffs2_rd_checkpt_data(struct yaffs_dev *dev)
+{
+	int ok = 1;
+
+	if (!dev->param.is_yaffs2)
+		ok = 0;
+
+	if (ok && dev->param.skip_checkpt_rd) {
+		T(YAFFS_TRACE_CHECKPOINT,
+		  (TSTR("skipping checkpoint read" TENDSTR)));
+		ok = 0;
+	}
+
+	if (ok)
+		ok = yaffs2_checkpt_open(dev, 0);	/* open for read */
+
+	if (ok) {
+		T(YAFFS_TRACE_CHECKPOINT,
+		  (TSTR("read checkpoint validity" TENDSTR)));
+		ok = yaffs2_rd_checkpt_validity_marker(dev, 1);
+	}
+	if (ok) {
+		T(YAFFS_TRACE_CHECKPOINT,
+		  (TSTR("read checkpoint device" TENDSTR)));
+		ok = yaffs2_rd_checkpt_dev(dev);
+	}
+	if (ok) {
+		T(YAFFS_TRACE_CHECKPOINT,
+		  (TSTR("read checkpoint objects" TENDSTR)));
+		ok = yaffs2_rd_checkpt_objs(dev);
+	}
+	if (ok) {
+		T(YAFFS_TRACE_CHECKPOINT,
+		  (TSTR("read checkpoint validity" TENDSTR)));
+		ok = yaffs2_rd_checkpt_validity_marker(dev, 0);
+	}
+
+	if (ok) {
+		ok = yaffs2_rd_checkpt_sum(dev);
+		T(YAFFS_TRACE_CHECKPOINT,
+		  (TSTR("read checkpoint checksum %d" TENDSTR), ok));
+	}
+
+	if (!yaffs_checkpt_close(dev))
+		ok = 0;
+
+	if (ok)
+		dev->is_checkpointed = 1;
+	else
+		dev->is_checkpointed = 0;
+
+	return ok ? 1 : 0;
+
+}
+
+void yaffs2_checkpt_invalidate(struct yaffs_dev *dev)
+{
+	if (dev->is_checkpointed || dev->blocks_in_checkpt > 0) {
+		dev->is_checkpointed = 0;
+		yaffs2_checkpt_invalidate_stream(dev);
+	}
+	if (dev->param.sb_dirty_fn)
+		dev->param.sb_dirty_fn(dev);
+}
+
+int yaffs_checkpoint_save(struct yaffs_dev *dev)
+{
+
+	T(YAFFS_TRACE_CHECKPOINT,
+	  (TSTR("save entry: is_checkpointed %d" TENDSTR),
+	   dev->is_checkpointed));
+
+	yaffs_verify_objects(dev);
+	yaffs_verify_blocks(dev);
+	yaffs_verify_free_chunks(dev);
+
+	if (!dev->is_checkpointed) {
+		yaffs2_checkpt_invalidate(dev);
+		yaffs2_wr_checkpt_data(dev);
+	}
+
+	T(YAFFS_TRACE_ALWAYS,
+	  (TSTR("save exit: is_checkpointed %d" TENDSTR),
+	   dev->is_checkpointed));
+
+	return dev->is_checkpointed;
+}
+
+int yaffs2_checkpt_restore(struct yaffs_dev *dev)
+{
+	int retval;
+	T(YAFFS_TRACE_CHECKPOINT,
+	  (TSTR("restore entry: is_checkpointed %d" TENDSTR),
+	   dev->is_checkpointed));
+
+	retval = yaffs2_rd_checkpt_data(dev);
+
+	if (dev->is_checkpointed) {
+		yaffs_verify_objects(dev);
+		yaffs_verify_blocks(dev);
+		yaffs_verify_free_chunks(dev);
+	}
+
+	T(YAFFS_TRACE_CHECKPOINT,
+	  (TSTR("restore exit: is_checkpointed %d" TENDSTR),
+	   dev->is_checkpointed));
+
+	return retval;
+}
+
+int yaffs2_handle_hole(struct yaffs_obj *obj, loff_t new_size)
+{
+	/* if new_size > old_file_size.
+	 * We're going to be writing a hole.
+	 * If the hole is small then write zeros otherwise write a start of hole marker.
+	 */
+
+	loff_t old_file_size;
+	int increase;
+	int small_hole;
+	int result = YAFFS_OK;
+	struct yaffs_dev *dev = NULL;
+
+	u8 *local_buffer = NULL;
+
+	int small_increase_ok = 0;
+
+	if (!obj)
+		return YAFFS_FAIL;
+
+	if (obj->variant_type != YAFFS_OBJECT_TYPE_FILE)
+		return YAFFS_FAIL;
+
+	dev = obj->my_dev;
+
+	/* Bail out if not yaffs2 mode */
+	if (!dev->param.is_yaffs2)
+		return YAFFS_OK;
+
+	old_file_size = obj->variant.file_variant.file_size;
+
+	if (new_size <= old_file_size)
+		return YAFFS_OK;
+
+	increase = new_size - old_file_size;
+
+	if (increase < YAFFS_SMALL_HOLE_THRESHOLD * dev->data_bytes_per_chunk &&
+	    yaffs_check_alloc_available(dev, YAFFS_SMALL_HOLE_THRESHOLD + 1))
+		small_hole = 1;
+	else
+		small_hole = 0;
+
+	if (small_hole)
+		local_buffer = yaffs_get_temp_buffer(dev, __LINE__);
+
+	if (local_buffer) {
+		/* fill hole with zero bytes */
+		int pos = old_file_size;
+		int this_write;
+		int written;
+		memset(local_buffer, 0, dev->data_bytes_per_chunk);
+		small_increase_ok = 1;
+
+		while (increase > 0 && small_increase_ok) {
+			this_write = increase;
+			if (this_write > dev->data_bytes_per_chunk)
+				this_write = dev->data_bytes_per_chunk;
+			written =
+			    yaffs_do_file_wr(obj, local_buffer, pos, this_write,
+					     0);
+			if (written == this_write) {
+				pos += this_write;
+				increase -= this_write;
+			} else
+				small_increase_ok = 0;
+		}
+
+		yaffs_release_temp_buffer(dev, local_buffer, __LINE__);
+
+		/* If we were out of space then reverse any chunks we've added */
+		if (!small_increase_ok)
+			yaffs_resize_file_down(obj, old_file_size);
+	}
+
+	if (!small_increase_ok &&
+	    obj->parent &&
+	    obj->parent->obj_id != YAFFS_OBJECTID_UNLINKED &&
+	    obj->parent->obj_id != YAFFS_OBJECTID_DELETED) {
+		/* Write a hole start header with the old file size */
+		yaffs_update_oh(obj, NULL, 0, 1, 0, NULL);
+	}
+
+	return result;
+
+}
+
+struct yaffs_block_index {
+	int seq;
+	int block;
+};
+
+static int yaffs2_ybicmp(const void *a, const void *b)
+{
+	int aseq = ((struct yaffs_block_index *)a)->seq;
+	int bseq = ((struct yaffs_block_index *)b)->seq;
+	int ablock = ((struct yaffs_block_index *)a)->block;
+	int bblock = ((struct yaffs_block_index *)b)->block;
+	if (aseq == bseq)
+		return ablock - bblock;
+	else
+		return aseq - bseq;
+}
+
+int yaffs2_scan_backwards(struct yaffs_dev *dev)
+{
+	struct yaffs_ext_tags tags;
+	int blk;
+	int block_iter;
+	int start_iter;
+	int end_iter;
+	int n_to_scan = 0;
+
+	int chunk;
+	int result;
+	int c;
+	int deleted;
+	enum yaffs_block_state state;
+	struct yaffs_obj *hard_list = NULL;
+	struct yaffs_block_info *bi;
+	u32 seq_number;
+	struct yaffs_obj_hdr *oh;
+	struct yaffs_obj *in;
+	struct yaffs_obj *parent;
+	int n_blocks = dev->internal_end_block - dev->internal_start_block + 1;
+	int is_unlinked;
+	u8 *chunk_data;
+
+	int file_size;
+	int is_shrink;
+	int found_chunks;
+	int equiv_id;
+	int alloc_failed = 0;
+
+	struct yaffs_block_index *block_index = NULL;
+	int alt_block_index = 0;
+
+	T(YAFFS_TRACE_SCAN,
+	  (TSTR
+	   ("yaffs2_scan_backwards starts  intstartblk %d intendblk %d..."
+	    TENDSTR), dev->internal_start_block, dev->internal_end_block));
+
+	dev->seq_number = YAFFS_LOWEST_SEQUENCE_NUMBER;
+
+	block_index = YMALLOC(n_blocks * sizeof(struct yaffs_block_index));
+
+	if (!block_index) {
+		block_index =
+		    YMALLOC_ALT(n_blocks * sizeof(struct yaffs_block_index));
+		alt_block_index = 1;
+	}
+
+	if (!block_index) {
+		T(YAFFS_TRACE_SCAN,
+		  (TSTR
+		   ("yaffs2_scan_backwards() could not allocate block index!"
+		    TENDSTR)));
+		return YAFFS_FAIL;
+	}
+
+	dev->blocks_in_checkpt = 0;
+
+	chunk_data = yaffs_get_temp_buffer(dev, __LINE__);
+
+	/* Scan all the blocks to determine their state */
+	bi = dev->block_info;
+	for (blk = dev->internal_start_block; blk <= dev->internal_end_block;
+	     blk++) {
+		yaffs_clear_chunk_bits(dev, blk);
+		bi->pages_in_use = 0;
+		bi->soft_del_pages = 0;
+
+		yaffs_query_init_block_state(dev, blk, &state, &seq_number);
+
+		bi->block_state = state;
+		bi->seq_number = seq_number;
+
+		if (bi->seq_number == YAFFS_SEQUENCE_CHECKPOINT_DATA)
+			bi->block_state = state = YAFFS_BLOCK_STATE_CHECKPOINT;
+		if (bi->seq_number == YAFFS_SEQUENCE_BAD_BLOCK)
+			bi->block_state = state = YAFFS_BLOCK_STATE_DEAD;
+
+		T(YAFFS_TRACE_SCAN_DEBUG,
+		  (TSTR("Block scanning block %d state %d seq %d" TENDSTR), blk,
+		   state, seq_number));
+
+		if (state == YAFFS_BLOCK_STATE_CHECKPOINT) {
+			dev->blocks_in_checkpt++;
+
+		} else if (state == YAFFS_BLOCK_STATE_DEAD) {
+			T(YAFFS_TRACE_BAD_BLOCKS,
+			  (TSTR("block %d is bad" TENDSTR), blk));
+		} else if (state == YAFFS_BLOCK_STATE_EMPTY) {
+			T(YAFFS_TRACE_SCAN_DEBUG,
+			  (TSTR("Block empty " TENDSTR)));
+			dev->n_erased_blocks++;
+			dev->n_free_chunks += dev->param.chunks_per_block;
+		} else if (state == YAFFS_BLOCK_STATE_NEEDS_SCANNING) {
+
+			/* Determine the highest sequence number */
+			if (seq_number >= YAFFS_LOWEST_SEQUENCE_NUMBER &&
+			    seq_number < YAFFS_HIGHEST_SEQUENCE_NUMBER) {
+
+				block_index[n_to_scan].seq = seq_number;
+				block_index[n_to_scan].block = blk;
+
+				n_to_scan++;
+
+				if (seq_number >= dev->seq_number)
+					dev->seq_number = seq_number;
+			} else {
+				/* TODO: Nasty sequence number! */
+				T(YAFFS_TRACE_SCAN,
+				  (TSTR
+				   ("Block scanning block %d has bad sequence number %d"
+				    TENDSTR), blk, seq_number));
+
+			}
+		}
+		bi++;
+	}
+
+	T(YAFFS_TRACE_SCAN,
+	  (TSTR("%d blocks to be sorted..." TENDSTR), n_to_scan));
+
+	YYIELD();
+
+	/* Sort the blocks by sequence number */
+	yaffs_sort(block_index, n_to_scan, sizeof(struct yaffs_block_index),
+		   yaffs2_ybicmp);
+
+	YYIELD();
+
+	T(YAFFS_TRACE_SCAN, (TSTR("...done" TENDSTR)));
+
+	/* Now scan the blocks looking at the data. */
+	start_iter = 0;
+	end_iter = n_to_scan - 1;
+	T(YAFFS_TRACE_SCAN_DEBUG,
+	  (TSTR("%d blocks to be scanned" TENDSTR), n_to_scan));
+
+	/* For each block.... backwards */
+	for (block_iter = end_iter; !alloc_failed && block_iter >= start_iter;
+	     block_iter--) {
+		/* Cooperative multitasking! This loop can run for so
+		   long that watchdog timers expire. */
+		YYIELD();
+
+		/* get the block to scan in the correct order */
+		blk = block_index[block_iter].block;
+
+		bi = yaffs_get_block_info(dev, blk);
+
+		state = bi->block_state;
+
+		deleted = 0;
+
+		/* For each chunk in each block that needs scanning.... */
+		found_chunks = 0;
+		for (c = dev->param.chunks_per_block - 1;
+		     !alloc_failed && c >= 0 &&
+		     (state == YAFFS_BLOCK_STATE_NEEDS_SCANNING ||
+		      state == YAFFS_BLOCK_STATE_ALLOCATING); c--) {
+			/* Scan backwards...
+			 * Read the tags and decide what to do
+			 */
+
+			chunk = blk * dev->param.chunks_per_block + c;
+
+			result = yaffs_rd_chunk_tags_nand(dev, chunk, NULL,
+							  &tags);
+
+			/* Let's have a good look at this chunk... */
+
+			if (!tags.chunk_used) {
+				/* An unassigned chunk in the block.
+				 * If there are used chunks after this one, then
+				 * it is a chunk that was skipped due to failing the erased
+				 * check. Just skip it so that it can be deleted.
+				 * But, more typically, We get here when this is an unallocated
+				 * chunk and his means that either the block is empty or
+				 * this is the one being allocated from
+				 */
+
+				if (found_chunks) {
+					/* This is a chunk that was skipped due to failing the erased check */
+				} else if (c == 0) {
+					/* We're looking at the first chunk in the block so the block is unused */
+					state = YAFFS_BLOCK_STATE_EMPTY;
+					dev->n_erased_blocks++;
+				} else {
+					if (state ==
+					    YAFFS_BLOCK_STATE_NEEDS_SCANNING
+					    || state ==
+					    YAFFS_BLOCK_STATE_ALLOCATING) {
+						if (dev->seq_number ==
+						    bi->seq_number) {
+							/* this is the block being allocated from */
+
+							T(YAFFS_TRACE_SCAN,
+							  (TSTR
+							   (" Allocating from %d %d"
+							    TENDSTR), blk, c));
+
+							state =
+							    YAFFS_BLOCK_STATE_ALLOCATING;
+							dev->alloc_block = blk;
+							dev->alloc_page = c;
+							dev->
+							    alloc_block_finder =
+							    blk;
+						} else {
+							/* This is a partially written block that is not
+							 * the current allocation block.
+							 */
+
+							T(YAFFS_TRACE_SCAN,
+							  (TSTR
+							   ("Partially written block %d detected"
+							    TENDSTR), blk));
+						}
+					}
+				}
+
+				dev->n_free_chunks++;
+
+			} else if (tags.ecc_result == YAFFS_ECC_RESULT_UNFIXED) {
+				T(YAFFS_TRACE_SCAN,
+				  (TSTR
+				   (" Unfixed ECC in chunk(%d:%d), chunk ignored"
+				    TENDSTR), blk, c));
+
+				dev->n_free_chunks++;
+
+			} else if (tags.obj_id > YAFFS_MAX_OBJECT_ID ||
+				   tags.chunk_id > YAFFS_MAX_CHUNK_ID ||
+				   (tags.chunk_id > 0
+				    && tags.n_bytes > dev->data_bytes_per_chunk)
+				   || tags.seq_number != bi->seq_number) {
+				T(YAFFS_TRACE_SCAN,
+				  (TSTR
+				   ("Chunk (%d:%d) with bad tags:obj = %d, chunk_id = %d, n_bytes = %d, ignored"
+				    TENDSTR), blk, c, tags.obj_id,
+				   tags.chunk_id, tags.n_bytes));
+
+				dev->n_free_chunks++;
+
+			} else if (tags.chunk_id > 0) {
+				/* chunk_id > 0 so it is a data chunk... */
+				unsigned int endpos;
+				u32 chunk_base =
+				    (tags.chunk_id -
+				     1) * dev->data_bytes_per_chunk;
+
+				found_chunks = 1;
+
+				yaffs_set_chunk_bit(dev, blk, c);
+				bi->pages_in_use++;
+
+				in = yaffs_find_or_create_by_number(dev,
+								    tags.obj_id,
+								    YAFFS_OBJECT_TYPE_FILE);
+				if (!in) {
+					/* Out of memory */
+					alloc_failed = 1;
+				}
+
+				if (in &&
+				    in->variant_type == YAFFS_OBJECT_TYPE_FILE
+				    && chunk_base <
+				    in->variant.file_variant.shrink_size) {
+					/* This has not been invalidated by a resize */
+					if (!yaffs_put_chunk_in_file
+					    (in, tags.chunk_id, chunk, -1)) {
+						alloc_failed = 1;
+					}
+
+					/* File size is calculated by looking at the data chunks if we have not
+					 * seen an object header yet. Stop this practice once we find an object header.
+					 */
+					endpos = chunk_base + tags.n_bytes;
+
+					if (!in->valid &&	/* have not got an object header yet */
+					    in->variant.file_variant.
+					    scanned_size < endpos) {
+						in->variant.file_variant.
+						    scanned_size = endpos;
+						in->variant.file_variant.
+						    file_size = endpos;
+					}
+
+				} else if (in) {
+					/* This chunk has been invalidated by a resize, or a past file deletion
+					 * so delete the chunk*/
+					yaffs_chunk_del(dev, chunk, 1,
+							__LINE__);
+
+				}
+			} else {
+				/* chunk_id == 0, so it is an ObjectHeader.
+				 * Thus, we read in the object header and make the object
+				 */
+				found_chunks = 1;
+
+				yaffs_set_chunk_bit(dev, blk, c);
+				bi->pages_in_use++;
+
+				oh = NULL;
+				in = NULL;
+
+				if (tags.extra_available) {
+					in = yaffs_find_or_create_by_number(dev,
+									    tags.
+									    obj_id,
+									    tags.
+									    extra_obj_type);
+					if (!in)
+						alloc_failed = 1;
+				}
+
+				if (!in ||
+				    (!in->valid && dev->param.disable_lazy_load)
+				    || tags.extra_shadows || (!in->valid
+							      && (tags.obj_id ==
+								  YAFFS_OBJECTID_ROOT
+								  || tags.
+								  obj_id ==
+								  YAFFS_OBJECTID_LOSTNFOUND)))
+				{
+
+					/* If we don't have  valid info then we need to read the chunk
+					 * TODO In future we can probably defer reading the chunk and
+					 * living with invalid data until needed.
+					 */
+
+					result = yaffs_rd_chunk_tags_nand(dev,
+									  chunk,
+									  chunk_data,
+									  NULL);
+
+					oh = (struct yaffs_obj_hdr *)chunk_data;
+
+					if (dev->param.inband_tags) {
+						/* Fix up the header if they got corrupted by inband tags */
+						oh->shadows_obj =
+						    oh->inband_shadowed_obj_id;
+						oh->is_shrink =
+						    oh->inband_is_shrink;
+					}
+
+					if (!in) {
+						in = yaffs_find_or_create_by_number(dev, tags.obj_id, oh->type);
+						if (!in)
+							alloc_failed = 1;
+					}
+
+				}
+
+				if (!in) {
+					/* TODO Hoosterman we have a problem! */
+					T(YAFFS_TRACE_ERROR,
+					  (TSTR
+					   ("yaffs tragedy: Could not make object for object  %d at chunk %d during scan"
+					    TENDSTR), tags.obj_id, chunk));
+					continue;
+				}
+
+				if (in->valid) {
+					/* We have already filled this one.
+					 * We have a duplicate that will be discarded, but
+					 * we first have to suck out resize info if it is a file.
+					 */
+
+					if ((in->variant_type ==
+					     YAFFS_OBJECT_TYPE_FILE) && ((oh
+									  &&
+									  oh->
+									  type
+									  ==
+									  YAFFS_OBJECT_TYPE_FILE)
+									 ||
+									 (tags.
+									  extra_available
+									  &&
+									  tags.
+									  extra_obj_type
+									  ==
+									  YAFFS_OBJECT_TYPE_FILE)))
+					{
+						u32 this_size =
+						    (oh) ? oh->
+						    file_size :
+						    tags.extra_length;
+						u32 parent_obj_id =
+						    (oh) ? oh->parent_obj_id :
+						    tags.extra_parent_id;
+
+						is_shrink =
+						    (oh) ? oh->
+						    is_shrink :
+						    tags.extra_is_shrink;
+
+						/* If it is deleted (unlinked at start also means deleted)
+						 * we treat the file size as being zeroed at this point.
+						 */
+						if (parent_obj_id ==
+						    YAFFS_OBJECTID_DELETED
+						    || parent_obj_id ==
+						    YAFFS_OBJECTID_UNLINKED) {
+							this_size = 0;
+							is_shrink = 1;
+						}
+
+						if (is_shrink
+						    && in->variant.file_variant.
+						    shrink_size > this_size)
+							in->variant.
+							    file_variant.
+							    shrink_size =
+							    this_size;
+
+						if (is_shrink)
+							bi->has_shrink_hdr = 1;
+
+					}
+					/* Use existing - destroy this one. */
+					yaffs_chunk_del(dev, chunk, 1,
+							__LINE__);
+
+				}
+
+				if (!in->valid && in->variant_type !=
+				    (oh ? oh->type : tags.extra_obj_type))
+					T(YAFFS_TRACE_ERROR,
+					  (TSTR
+					   ("yaffs tragedy: Bad object type, "
+					    TCONT
+					    ("%d != %d, for object %d at chunk ")
+					    TCONT("%d during scan")
+					    TENDSTR), oh ?
+					   oh->type : tags.extra_obj_type,
+					   in->variant_type, tags.obj_id,
+					   chunk));
+
+				if (!in->valid &&
+				    (tags.obj_id == YAFFS_OBJECTID_ROOT ||
+				     tags.obj_id ==
+				     YAFFS_OBJECTID_LOSTNFOUND)) {
+					/* We only load some info, don't fiddle with directory structure */
+					in->valid = 1;
+
+					if (oh) {
+
+						in->yst_mode = oh->yst_mode;
+						yaffs_load_attribs(in, oh);
+						in->lazy_loaded = 0;
+					} else
+						in->lazy_loaded = 1;
+
+					in->hdr_chunk = chunk;
+
+				} else if (!in->valid) {
+					/* we need to load this info */
+
+					in->valid = 1;
+					in->hdr_chunk = chunk;
+
+					if (oh) {
+						in->variant_type = oh->type;
+
+						in->yst_mode = oh->yst_mode;
+						yaffs_load_attribs(in, oh);
+
+						if (oh->shadows_obj > 0)
+							yaffs_handle_shadowed_obj
+							    (dev,
+							     oh->shadows_obj,
+							     1);
+
+						yaffs_set_obj_name_from_oh(in,
+									   oh);
+						parent =
+						    yaffs_find_or_create_by_number
+						    (dev, oh->parent_obj_id,
+						     YAFFS_OBJECT_TYPE_DIRECTORY);
+
+						file_size = oh->file_size;
+						is_shrink = oh->is_shrink;
+						equiv_id = oh->equiv_id;
+
+					} else {
+						in->variant_type =
+						    tags.extra_obj_type;
+						parent =
+						    yaffs_find_or_create_by_number
+						    (dev, tags.extra_parent_id,
+						     YAFFS_OBJECT_TYPE_DIRECTORY);
+						file_size = tags.extra_length;
+						is_shrink =
+						    tags.extra_is_shrink;
+						equiv_id = tags.extra_equiv_id;
+						in->lazy_loaded = 1;
+
+					}
+					in->dirty = 0;
+
+					if (!parent)
+						alloc_failed = 1;
+
+					/* directory stuff...
+					 * hook up to parent
+					 */
+
+					if (parent && parent->variant_type ==
+					    YAFFS_OBJECT_TYPE_UNKNOWN) {
+						/* Set up as a directory */
+						parent->variant_type =
+						    YAFFS_OBJECT_TYPE_DIRECTORY;
+						INIT_LIST_HEAD(&parent->
+							       variant.dir_variant.children);
+					} else if (!parent
+						   || parent->variant_type !=
+						   YAFFS_OBJECT_TYPE_DIRECTORY)
+					{
+						/* Hoosterman, another problem....
+						 * We're trying to use a non-directory as a directory
+						 */
+
+						T(YAFFS_TRACE_ERROR,
+						  (TSTR
+						   ("yaffs tragedy: attempting to use non-directory as a directory in scan. Put in lost+found."
+						    TENDSTR)));
+						parent = dev->lost_n_found;
+					}
+
+					yaffs_add_obj_to_dir(parent, in);
+
+					is_unlinked = (parent == dev->del_dir)
+					    || (parent == dev->unlinked_dir);
+
+					if (is_shrink) {
+						/* Mark the block as having a shrink header */
+						bi->has_shrink_hdr = 1;
+					}
+
+					/* Note re hardlinks.
+					 * Since we might scan a hardlink before its equivalent object is scanned
+					 * we put them all in a list.
+					 * After scanning is complete, we should have all the objects, so we run
+					 * through this list and fix up all the chains.
+					 */
+
+					switch (in->variant_type) {
+					case YAFFS_OBJECT_TYPE_UNKNOWN:
+						/* Todo got a problem */
+						break;
+					case YAFFS_OBJECT_TYPE_FILE:
+
+						if (in->variant.
+						    file_variant.scanned_size <
+						    file_size) {
+							/* This covers the case where the file size is greater
+							 * than where the data is
+							 * This will happen if the file is resized to be larger
+							 * than its current data extents.
+							 */
+							in->variant.
+							    file_variant.
+							    file_size =
+							    file_size;
+							in->variant.
+							    file_variant.
+							    scanned_size =
+							    file_size;
+						}
+
+						if (in->variant.file_variant.
+						    shrink_size > file_size)
+							in->variant.
+							    file_variant.
+							    shrink_size =
+							    file_size;
+
+						break;
+					case YAFFS_OBJECT_TYPE_HARDLINK:
+						if (!is_unlinked) {
+							in->variant.
+							    hardlink_variant.
+							    equiv_id = equiv_id;
+							in->hard_links.next =
+							    (struct list_head *)
+							    hard_list;
+							hard_list = in;
+						}
+						break;
+					case YAFFS_OBJECT_TYPE_DIRECTORY:
+						/* Do nothing */
+						break;
+					case YAFFS_OBJECT_TYPE_SPECIAL:
+						/* Do nothing */
+						break;
+					case YAFFS_OBJECT_TYPE_SYMLINK:
+						if (oh) {
+							in->variant.
+							    symlink_variant.
+							    alias =
+							    yaffs_clone_str(oh->
+									    alias);
+							if (!in->variant.
+							    symlink_variant.
+							    alias)
+								alloc_failed =
+								    1;
+						}
+						break;
+					}
+
+				}
+
+			}
+
+		}		/* End of scanning for each chunk */
+
+		if (state == YAFFS_BLOCK_STATE_NEEDS_SCANNING) {
+			/* If we got this far while scanning, then the block is fully allocated. */
+			state = YAFFS_BLOCK_STATE_FULL;
+		}
+
+		bi->block_state = state;
+
+		/* Now let's see if it was dirty */
+		if (bi->pages_in_use == 0 &&
+		    !bi->has_shrink_hdr &&
+		    bi->block_state == YAFFS_BLOCK_STATE_FULL) {
+			yaffs_block_became_dirty(dev, blk);
+		}
+
+	}
+
+	yaffs_skip_rest_of_block(dev);
+
+	if (alt_block_index)
+		YFREE_ALT(block_index);
+	else
+		YFREE(block_index);
+
+	/* Ok, we've done all the scanning.
+	 * Fix up the hard link chains.
+	 * We should now have scanned all the objects, now it's time to add these
+	 * hardlinks.
+	 */
+	yaffs_link_fixup(dev, hard_list);
+
+	yaffs_release_temp_buffer(dev, chunk_data, __LINE__);
+
+	if (alloc_failed)
+		return YAFFS_FAIL;
+
+	T(YAFFS_TRACE_SCAN, (TSTR("yaffs2_scan_backwards ends" TENDSTR)));
+
+	return YAFFS_OK;
+}
diff --git a/fs/yaffs2/yaffs_yaffs2.h b/fs/yaffs2/yaffs_yaffs2.h
new file mode 100644
index 0000000..e1a9287
--- /dev/null
+++ b/fs/yaffs2/yaffs_yaffs2.h
@@ -0,0 +1,39 @@
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
+#ifndef __YAFFS_YAFFS2_H__
+#define __YAFFS_YAFFS2_H__
+
+#include "yaffs_guts.h"
+
+void yaffs_calc_oldest_dirty_seq(struct yaffs_dev *dev);
+void yaffs2_find_oldest_dirty_seq(struct yaffs_dev *dev);
+void yaffs2_clear_oldest_dirty_seq(struct yaffs_dev *dev,
+				   struct yaffs_block_info *bi);
+void yaffs2_update_oldest_dirty_seq(struct yaffs_dev *dev, unsigned block_no,
+				    struct yaffs_block_info *bi);
+int yaffs_block_ok_for_gc(struct yaffs_dev *dev, struct yaffs_block_info *bi);
+u32 yaffs2_find_refresh_block(struct yaffs_dev *dev);
+int yaffs2_checkpt_required(struct yaffs_dev *dev);
+int yaffs_calc_checkpt_blocks_required(struct yaffs_dev *dev);
+
+void yaffs2_checkpt_invalidate(struct yaffs_dev *dev);
+int yaffs2_checkpt_save(struct yaffs_dev *dev);
+int yaffs2_checkpt_restore(struct yaffs_dev *dev);
+
+int yaffs2_handle_hole(struct yaffs_obj *obj, loff_t new_size);
+int yaffs2_scan_backwards(struct yaffs_dev *dev);
+
+#endif
-- 
1.7.1

