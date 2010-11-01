Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab0KASnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:43:40 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64991 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0KASmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:42:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=T6nDqoTjKltbYhQwzF91+ktpO/YpZ8rPcaz7M5f8q8X3LQJu8aACZ92hCVeu4uo1Ya
         SkLxO5Fl1v7nn7D7Ci94Sux9z19cI7zYY+Q3t/rZ11iWpGINDC5oNP25wGQFdN6J/9i9
         ixWI1lXqAEiTZxtXUDoy9FJEmStw6Sb9IKZsA=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 24/29] Staging: yaffs2: yaffs_verify: Add files
Date: Mon,  1 Nov 2010 14:41:12 -0400
Message-Id: <1288636877-7964-25-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding files to yaffs2 directory.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/yaffs_verify.c |  631 +++++++++++++++++++++++++++++++++
 drivers/staging/yaffs2/yaffs_verify.h |   41 +++
 2 files changed, 672 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/yaffs_verify.c
 create mode 100644 drivers/staging/yaffs2/yaffs_verify.h

diff --git a/drivers/staging/yaffs2/yaffs_verify.c b/drivers/staging/yaffs2/yaffs_verify.c
new file mode 100644
index 0000000..89e730b
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_verify.c
@@ -0,0 +1,631 @@
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
+
+#include "yaffs_verify.h"
+#include "yaffs_trace.h"
+#include "yaffs_bitmap.h"
+#include "yaffs_getblockinfo.h"
+#include "yaffs_nand.h"
+
+int yaffs_skip_verification(yaffs_dev_t *dev)
+{
+	dev=dev;
+	return !(yaffs_trace_mask & (YAFFS_TRACE_VERIFY | YAFFS_TRACE_VERIFY_FULL));
+}
+
+static int yaffs_skip_full_verification(yaffs_dev_t *dev)
+{
+	dev=dev;
+	return !(yaffs_trace_mask & (YAFFS_TRACE_VERIFY_FULL));
+}
+
+static int yaffs_skip_nand_verification(yaffs_dev_t *dev)
+{
+	dev=dev;
+	return !(yaffs_trace_mask & (YAFFS_TRACE_VERIFY_NAND));
+}
+
+
+static const char *block_state_name[] = {
+"Unknown",
+"Needs scanning",
+"Scanning",
+"Empty",
+"Allocating",
+"Full",
+"Dirty",
+"Checkpoint",
+"Collecting",
+"Dead"
+};
+
+
+void yaffs_verify_blk(yaffs_dev_t *dev, yaffs_block_info_t *bi, int n)
+{
+	int actually_used;
+	int in_use;
+
+	if (yaffs_skip_verification(dev))
+		return;
+
+	/* Report illegal runtime states */
+	if (bi->block_state >= YAFFS_NUMBER_OF_BLOCK_STATES)
+		T(YAFFS_TRACE_VERIFY, (TSTR("Block %d has undefined state %d"TENDSTR), n, bi->block_state));
+
+	switch (bi->block_state) {
+	case YAFFS_BLOCK_STATE_UNKNOWN:
+	case YAFFS_BLOCK_STATE_SCANNING:
+	case YAFFS_BLOCK_STATE_NEEDS_SCANNING:
+		T(YAFFS_TRACE_VERIFY, (TSTR("Block %d has bad run-state %s"TENDSTR),
+		n, block_state_name[bi->block_state]));
+	}
+
+	/* Check pages in use and soft deletions are legal */
+
+	actually_used = bi->pages_in_use - bi->soft_del_pages;
+
+	if (bi->pages_in_use < 0 || bi->pages_in_use > dev->param.chunks_per_block ||
+	   bi->soft_del_pages < 0 || bi->soft_del_pages > dev->param.chunks_per_block ||
+	   actually_used < 0 || actually_used > dev->param.chunks_per_block)
+		T(YAFFS_TRACE_VERIFY, (TSTR("Block %d has illegal values pages_in_used %d soft_del_pages %d"TENDSTR),
+		n, bi->pages_in_use, bi->soft_del_pages));
+
+
+	/* Check chunk bitmap legal */
+	in_use = yaffs_count_chunk_bits(dev, n);
+	if (in_use != bi->pages_in_use)
+		T(YAFFS_TRACE_VERIFY, (TSTR("Block %d has inconsistent values pages_in_use %d counted chunk bits %d"TENDSTR),
+			n, bi->pages_in_use, in_use));
+
+}
+
+
+
+void yaffs_verify_collected_blk(yaffs_dev_t *dev, yaffs_block_info_t *bi, int n)
+{
+	yaffs_verify_blk(dev, bi, n);
+
+	/* After collection the block should be in the erased state */
+
+	if (bi->block_state != YAFFS_BLOCK_STATE_COLLECTING &&
+			bi->block_state != YAFFS_BLOCK_STATE_EMPTY) {
+		T(YAFFS_TRACE_ERROR, (TSTR("Block %d is in state %d after gc, should be erased"TENDSTR),
+			n, bi->block_state));
+	}
+}
+
+void yaffs_verify_blocks(yaffs_dev_t *dev)
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
+		yaffs_block_info_t *bi = yaffs_get_block_info(dev, i);
+		yaffs_verify_blk(dev, bi, i);
+
+		if (bi->block_state < YAFFS_NUMBER_OF_BLOCK_STATES)
+			state_count[bi->block_state]++;
+		else
+			illegal_states++;
+	}
+
+	T(YAFFS_TRACE_VERIFY, (TSTR(""TENDSTR)));
+	T(YAFFS_TRACE_VERIFY, (TSTR("Block summary"TENDSTR)));
+
+	T(YAFFS_TRACE_VERIFY, (TSTR("%d blocks have illegal states"TENDSTR), illegal_states));
+	if (state_count[YAFFS_BLOCK_STATE_ALLOCATING] > 1)
+		T(YAFFS_TRACE_VERIFY, (TSTR("Too many allocating blocks"TENDSTR)));
+
+	for (i = 0; i < YAFFS_NUMBER_OF_BLOCK_STATES; i++)
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("%s %d blocks"TENDSTR),
+		  block_state_name[i], state_count[i]));
+
+	if (dev->blocks_in_checkpt != state_count[YAFFS_BLOCK_STATE_CHECKPOINT])
+		T(YAFFS_TRACE_VERIFY,
+		 (TSTR("Checkpoint block count wrong dev %d count %d"TENDSTR),
+		 dev->blocks_in_checkpt, state_count[YAFFS_BLOCK_STATE_CHECKPOINT]));
+
+	if (dev->n_erased_blocks != state_count[YAFFS_BLOCK_STATE_EMPTY])
+		T(YAFFS_TRACE_VERIFY,
+		 (TSTR("Erased block count wrong dev %d count %d"TENDSTR),
+		 dev->n_erased_blocks, state_count[YAFFS_BLOCK_STATE_EMPTY]));
+
+	if (state_count[YAFFS_BLOCK_STATE_COLLECTING] > 1)
+		T(YAFFS_TRACE_VERIFY,
+		 (TSTR("Too many collecting blocks %d (max is 1)"TENDSTR),
+		 state_count[YAFFS_BLOCK_STATE_COLLECTING]));
+
+	T(YAFFS_TRACE_VERIFY, (TSTR(""TENDSTR)));
+
+}
+
+/*
+ * Verify the object header. oh must be valid, but obj and tags may be NULL in which
+ * case those tests will not be performed.
+ */
+void yaffs_verify_oh(yaffs_obj_t *obj, yaffs_obj_header *oh, yaffs_ext_tags *tags, int parent_check)
+{
+	if (obj && yaffs_skip_verification(obj->my_dev))
+		return;
+
+	if (!(tags && obj && oh)) {
+		T(YAFFS_TRACE_VERIFY,
+				(TSTR("Verifying object header tags %p obj %p oh %p"TENDSTR),
+				tags, obj, oh));
+		return;
+	}
+
+	if (oh->type <= YAFFS_OBJECT_TYPE_UNKNOWN ||
+			oh->type > YAFFS_OBJECT_TYPE_MAX)
+		T(YAFFS_TRACE_VERIFY,
+			(TSTR("Obj %d header type is illegal value 0x%x"TENDSTR),
+			tags->obj_id, oh->type));
+
+	if (tags->obj_id != obj->obj_id)
+		T(YAFFS_TRACE_VERIFY,
+			(TSTR("Obj %d header mismatch obj_id %d"TENDSTR),
+			tags->obj_id, obj->obj_id));
+
+
+	/*
+	 * Check that the object's parent ids match if parent_check requested.
+	 *
+	 * Tests do not apply to the root object.
+	 */
+
+	if (parent_check && tags->obj_id > 1 && !obj->parent)
+		T(YAFFS_TRACE_VERIFY,
+			(TSTR("Obj %d header mismatch parent_id %d obj->parent is NULL"TENDSTR),
+			tags->obj_id, oh->parent_obj_id));
+
+	if (parent_check && obj->parent &&
+			oh->parent_obj_id != obj->parent->obj_id &&
+			(oh->parent_obj_id != YAFFS_OBJECTID_UNLINKED ||
+			obj->parent->obj_id != YAFFS_OBJECTID_DELETED))
+		T(YAFFS_TRACE_VERIFY,
+			(TSTR("Obj %d header mismatch parent_id %d parent_obj_id %d"TENDSTR),
+			tags->obj_id, oh->parent_obj_id, obj->parent->obj_id));
+
+	if (tags->obj_id > 1 && oh->name[0] == 0) /* Null name */
+		T(YAFFS_TRACE_VERIFY,
+			(TSTR("Obj %d header name is NULL"TENDSTR),
+			obj->obj_id));
+
+	if (tags->obj_id > 1 && ((__u8)(oh->name[0])) == 0xff) /* Trashed name */
+		T(YAFFS_TRACE_VERIFY,
+			(TSTR("Obj %d header name is 0xFF"TENDSTR),
+			obj->obj_id));
+}
+
+
+#if 0
+/* Not being used, but don't want to throw away yet */
+int yaffs_verify_tnode_worker(yaffs_obj_t *obj, yaffs_tnode_t *tn,
+					__u32 level, int chunk_offset)
+{
+	int i;
+	yaffs_dev_t *dev = obj->my_dev;
+	int ok = 1;
+
+	if (tn) {
+		if (level > 0) {
+
+			for (i = 0; i < YAFFS_NTNODES_INTERNAL && ok; i++) {
+				if (tn->internal[i]) {
+					ok = yaffs_verify_tnode_worker(obj,
+							tn->internal[i],
+							level - 1,
+							(chunk_offset<<YAFFS_TNODES_INTERNAL_BITS) + i);
+				}
+			}
+		} else if (level == 0) {
+			yaffs_ext_tags tags;
+			__u32 obj_id = obj->obj_id;
+
+			chunk_offset <<=  YAFFS_TNODES_LEVEL0_BITS;
+
+			for (i = 0; i < YAFFS_NTNODES_LEVEL0; i++) {
+				__u32 the_chunk = yaffs_get_group_base(dev, tn, i);
+
+				if (the_chunk > 0) {
+					/* T(~0,(TSTR("verifying (%d:%d) %d"TENDSTR),tags.obj_id,tags.chunk_id,the_chunk)); */
+					yaffs_rd_chunk_tags_nand(dev, the_chunk, NULL, &tags);
+					if (tags.obj_id != obj_id || tags.chunk_id != chunk_offset) {
+						T(~0, (TSTR("Object %d chunk_id %d NAND mismatch chunk %d tags (%d:%d)"TENDSTR),
+							obj_id, chunk_offset, the_chunk,
+							tags.obj_id, tags.chunk_id));
+					}
+				}
+				chunk_offset++;
+			}
+		}
+	}
+
+	return ok;
+
+}
+
+#endif
+
+void yaffs_verify_file(yaffs_obj_t *obj)
+{
+	int required_depth;
+	int actual_depth;
+	__u32 last_chunk;
+	__u32 x;
+	__u32 i;
+	yaffs_dev_t *dev;
+	yaffs_ext_tags tags;
+	yaffs_tnode_t *tn;
+	__u32 obj_id;
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
+	last_chunk =  obj->variant.file_variant.file_size / dev->data_bytes_per_chunk + 1;
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
+			__u32 the_chunk = yaffs_get_group_base(dev, tn, i);
+			if (the_chunk > 0) {
+				/* T(~0,(TSTR("verifying (%d:%d) %d"TENDSTR),obj_id,i,the_chunk)); */
+				yaffs_rd_chunk_tags_nand(dev, the_chunk, NULL, &tags);
+				if (tags.obj_id != obj_id || tags.chunk_id != i) {
+					T(~0, (TSTR("Object %d chunk_id %d NAND mismatch chunk %d tags (%d:%d)"TENDSTR),
+						obj_id, i, the_chunk,
+						tags.obj_id, tags.chunk_id));
+				}
+			}
+		}
+	}
+}
+
+
+void yaffs_verify_link(yaffs_obj_t *obj)
+{
+	if (obj && yaffs_skip_verification(obj->my_dev))
+		return;
+
+	/* Verify sane equivalent object */
+}
+
+void yaffs_verify_symlink(yaffs_obj_t *obj)
+{
+	if (obj && yaffs_skip_verification(obj->my_dev))
+		return;
+
+	/* Verify symlink string */
+}
+
+void yaffs_verify_special(yaffs_obj_t *obj)
+{
+	if (obj && yaffs_skip_verification(obj->my_dev))
+		return;
+}
+
+void yaffs_verify_obj(yaffs_obj_t *obj)
+{
+	yaffs_dev_t *dev;
+
+	__u32 chunk_min;
+	__u32 chunk_max;
+
+	__u32 chunk_id_ok;
+	__u32 chunk_in_range;
+	__u32 chunk_wrongly_deleted;
+	__u32 chunk_valid;
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
+	chunk_max = (dev->internal_end_block+1) * dev->param.chunks_per_block - 1;
+
+	chunk_in_range = (((unsigned)(obj->hdr_chunk)) >= chunk_min && 
+	                ((unsigned)(obj->hdr_chunk)) <= chunk_max);
+	chunk_id_ok = chunk_in_range || (obj->hdr_chunk == 0);
+	chunk_valid = chunk_in_range &&
+			yaffs_check_chunk_bit(dev,
+					obj->hdr_chunk / dev->param.chunks_per_block,
+					obj->hdr_chunk % dev->param.chunks_per_block);
+	chunk_wrongly_deleted = chunk_in_range && !chunk_valid;
+
+	if (!obj->fake &&
+			(!chunk_id_ok || chunk_wrongly_deleted)) {
+		T(YAFFS_TRACE_VERIFY,
+			(TSTR("Obj %d has chunk_id %d %s %s"TENDSTR),
+			obj->obj_id, obj->hdr_chunk,
+			chunk_id_ok ? "" : ",out of range",
+			chunk_wrongly_deleted ? ",marked as deleted" : ""));
+	}
+
+	if (chunk_valid && !yaffs_skip_nand_verification(dev)) {
+		yaffs_ext_tags tags;
+		yaffs_obj_header *oh;
+		__u8 *buffer = yaffs_get_temp_buffer(dev, __LINE__);
+
+		oh = (yaffs_obj_header *)buffer;
+
+		yaffs_rd_chunk_tags_nand(dev, obj->hdr_chunk, buffer,
+				&tags);
+
+		yaffs_verify_oh(obj, oh, &tags, 1);
+
+		yaffs_release_temp_buffer(dev, buffer, __LINE__);
+	}
+
+	/* Verify it has a parent */
+	if (obj && !obj->fake &&
+			(!obj->parent || obj->parent->my_dev != dev)) {
+		T(YAFFS_TRACE_VERIFY,
+			(TSTR("Obj %d has parent pointer %p which does not look like an object"TENDSTR),
+			obj->obj_id, obj->parent));
+	}
+
+	/* Verify parent is a directory */
+	if (obj->parent && obj->parent->variant_type != YAFFS_OBJECT_TYPE_DIRECTORY) {
+		T(YAFFS_TRACE_VERIFY,
+			(TSTR("Obj %d's parent is not a directory (type %d)"TENDSTR),
+			obj->obj_id, obj->parent->variant_type));
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
+		(TSTR("Obj %d has illegaltype %d"TENDSTR),
+		obj->obj_id, obj->variant_type));
+		break;
+	}
+}
+
+void yaffs_verify_objects(yaffs_dev_t *dev)
+{
+	yaffs_obj_t *obj;
+	int i;
+	struct ylist_head *lh;
+
+	if (yaffs_skip_verification(dev))
+		return;
+
+	/* Iterate through the objects in each hash entry */
+
+	for (i = 0; i <  YAFFS_NOBJECT_BUCKETS; i++) {
+		ylist_for_each(lh, &dev->obj_bucket[i].list) {
+			if (lh) {
+				obj = ylist_entry(lh, yaffs_obj_t, hash_link);
+				yaffs_verify_obj(obj);
+			}
+		}
+	}
+}
+
+
+void yaffs_verify_obj_in_dir(yaffs_obj_t *obj)
+{
+	struct ylist_head *lh;
+	yaffs_obj_t *list_obj;
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
+		T(YAFFS_TRACE_ALWAYS, (TSTR("Object does not have parent" TENDSTR)));
+		YBUG();
+		return;
+	}
+
+	if (obj->parent->variant_type != YAFFS_OBJECT_TYPE_DIRECTORY) {
+		T(YAFFS_TRACE_ALWAYS, (TSTR("Parent is not directory" TENDSTR)));
+		YBUG();
+	}
+
+	/* Iterate through the objects in each hash entry */
+
+	ylist_for_each(lh, &obj->parent->variant.dir_variant.children) {
+		if (lh) {
+			list_obj = ylist_entry(lh, yaffs_obj_t, siblings);
+			yaffs_verify_obj(list_obj);
+			if (obj == list_obj)
+				count++;
+		}
+	 }
+
+	if (count != 1) {
+		T(YAFFS_TRACE_ALWAYS, (TSTR("Object in directory %d times" TENDSTR), count));
+		YBUG();
+	}
+}
+
+void yaffs_verify_dir(yaffs_obj_t *directory)
+{
+	struct ylist_head *lh;
+	yaffs_obj_t *list_obj;
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
+		(TSTR("Directory has wrong type: %d" TENDSTR),
+		directory->variant_type));
+		YBUG();
+	}
+
+	/* Iterate through the objects in each hash entry */
+
+	ylist_for_each(lh, &directory->variant.dir_variant.children) {
+		if (lh) {
+			list_obj = ylist_entry(lh, yaffs_obj_t, siblings);
+			if (list_obj->parent != directory) {
+				T(YAFFS_TRACE_ALWAYS, (
+				TSTR("Object in directory list has wrong parent %p" TENDSTR),
+				list_obj->parent));
+				YBUG();
+			}
+			yaffs_verify_obj_in_dir(list_obj);
+		}
+	}
+}
+
+static int yaffs_free_verification_failures;
+
+void yaffs_verify_free_chunks(yaffs_dev_t *dev)
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
+int yaffs_verify_file_sane(yaffs_obj_t *in)
+{
+#if 0
+	int chunk;
+	int n_chunks;
+	int file_size;
+	int failed = 0;
+	int obj_id;
+	yaffs_tnode_t *tn;
+	yaffs_tags_t local_tags;
+	yaffs_tags_t *tags = &local_tags;
+	int the_chunk;
+	int is_deleted;
+
+	if (in->variant_type != YAFFS_OBJECT_TYPE_FILE)
+		return YAFFS_FAIL;
+
+	obj_id = in->obj_id;
+	file_size = in->variant.file_variant.file_size;
+	n_chunks =
+	    (file_size + in->my_dev->data_bytes_per_chunk - 1) / in->my_dev->data_bytes_per_chunk;
+
+	for (chunk = 1; chunk <= n_chunks; chunk++) {
+		tn = yaffs_find_tnode_0(in->my_dev, &in->variant.file_variant,
+					   chunk);
+
+		if (tn) {
+
+			the_chunk = yaffs_get_group_base(dev, tn, chunk);
+
+			if (yaffs_check_chunk_bits
+			    (dev, the_chunk / dev->param.chunks_per_block,
+			     the_chunk % dev->param.chunks_per_block)) {
+
+				yaffs_rd_chunk_tags_nand(in->my_dev, the_chunk,
+							    tags,
+							    &is_deleted);
+				if (yaffs_tags_match
+				    (tags, in->obj_id, chunk, is_deleted)) {
+					/* found it; */
+
+				}
+			} else {
+
+				failed = 1;
+			}
+
+		} else {
+			/* T(("No level 0 found for %d\n", chunk)); */
+		}
+	}
+
+	return failed ? YAFFS_FAIL : YAFFS_OK;
+#else
+	in=in;
+	return YAFFS_OK;
+#endif
+}
diff --git a/drivers/staging/yaffs2/yaffs_verify.h b/drivers/staging/yaffs2/yaffs_verify.h
new file mode 100644
index 0000000..6118afd
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_verify.h
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
+#ifndef __YAFFS_VERIFY_H__
+#define __YAFFS_VERIFY_H__
+
+#include "yaffs_guts.h"
+
+void yaffs_verify_blk(yaffs_dev_t *dev, yaffs_block_info_t *bi, int n);
+void yaffs_verify_collected_blk(yaffs_dev_t *dev, yaffs_block_info_t *bi, int n);
+void yaffs_verify_blocks(yaffs_dev_t *dev);
+
+void yaffs_verify_oh(yaffs_obj_t *obj, yaffs_obj_header *oh, yaffs_ext_tags *tags, int parent_check);
+void yaffs_verify_file(yaffs_obj_t *obj);
+void yaffs_verify_link(yaffs_obj_t *obj);
+void yaffs_verify_symlink(yaffs_obj_t *obj);
+void yaffs_verify_special(yaffs_obj_t *obj);
+void yaffs_verify_obj(yaffs_obj_t *obj);
+void yaffs_verify_objects(yaffs_dev_t *dev);
+void yaffs_verify_obj_in_dir(yaffs_obj_t *obj);
+void yaffs_verify_dir(yaffs_obj_t *directory);
+void yaffs_verify_free_chunks(yaffs_dev_t *dev);
+
+int yaffs_verify_file_sane(yaffs_obj_t *obj);
+
+int yaffs_skip_verification(yaffs_dev_t *dev);
+
+#endif
+
-- 
1.7.3.2.146.gca209

