Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab0K3V6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:58:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52281 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab0K3V6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:58:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=liTaBish5tATJKvVdLNKlBh8GMj28O1HM7HPyU3aiLhZ3SmaWe8pwkzf8hz2Mpy9aG
         OR9avu59gpJGSdSA2HDgM9meyd/c3Yf2t7R95YYmbrEN+ieG4vkxymMbXVe3K+YliIu2
         trqXzMlmONqipBb8gqvJCBdJ8FwfJ5IGLhVm0=
From: Charles Manning <cdhmanning@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 3/8] Add yaffs2 file system: guts code
Date: Wed,  1 Dec 2010 10:57:29 +1300
Message-Id: <1291154254-22533-4-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Manning <cdhmanning@gmail.com>
---
 fs/yaffs2/yaffs_guts.c   | 5236 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/yaffs2/yaffs_guts.h   |  915 ++++++++
 fs/yaffs2/yaffs_yaffs1.c |  437 ++++
 fs/yaffs2/yaffs_yaffs1.h |   22 +
 fs/yaffs2/yaffs_yaffs2.c | 1620 ++++++++++++++
 fs/yaffs2/yaffs_yaffs2.h |   39 +
 6 files changed, 8269 insertions(+), 0 deletions(-)
 create mode 100644 fs/yaffs2/yaffs_guts.c
 create mode 100644 fs/yaffs2/yaffs_guts.h
 create mode 100644 fs/yaffs2/yaffs_yaffs1.c
 create mode 100644 fs/yaffs2/yaffs_yaffs1.h
 create mode 100644 fs/yaffs2/yaffs_yaffs2.c
 create mode 100644 fs/yaffs2/yaffs_yaffs2.h

diff --git a/fs/yaffs2/yaffs_guts.c b/fs/yaffs2/yaffs_guts.c
new file mode 100644
index 0000000..c56e060
--- /dev/null
+++ b/fs/yaffs2/yaffs_guts.c
@@ -0,0 +1,5236 @@
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
+#include "yportenv.h"
+#include "yaffs_trace.h"
+
+#include "yaffs_guts.h"
+#include "yaffs_tagsvalidity.h"
+#include "yaffs_getblockinfo.h"
+
+#include "yaffs_tagscompat.h"
+
+#include "yaffs_nand.h"
+
+#include "yaffs_yaffs1.h"
+#include "yaffs_yaffs2.h"
+#include "yaffs_bitmap.h"
+#include "yaffs_verify.h"
+
+#include "yaffs_nand.h"
+#include "yaffs_packedtags2.h"
+
+#include "yaffs_nameval.h"
+#include "yaffs_allocator.h"
+
+#include "yaffs_attribs.h"
+
+/* Note YAFFS_GC_GOOD_ENOUGH must be <= YAFFS_GC_PASSIVE_THRESHOLD */
+#define YAFFS_GC_GOOD_ENOUGH 2
+#define YAFFS_GC_PASSIVE_THRESHOLD 4
+
+#include "yaffs_ecc.h"
+
+/* Robustification (if it ever comes about...) */
+static void yaffs_retire_block(struct yaffs_dev *dev, int flash_block);
+static void yaffs_handle_chunk_wr_error(struct yaffs_dev *dev, int nand_chunk,
+					int erased_ok);
+static void yaffs_handle_chunk_wr_ok(struct yaffs_dev *dev, int nand_chunk,
+				     const u8 * data,
+				     const struct yaffs_ext_tags *tags);
+static void yaffs_handle_chunk_update(struct yaffs_dev *dev, int nand_chunk,
+				      const struct yaffs_ext_tags *tags);
+
+/* Other local prototypes */
+static void yaffs_update_parent(struct yaffs_obj *obj);
+static int yaffs_unlink_obj(struct yaffs_obj *obj);
+static int yaffs_obj_cache_dirty(struct yaffs_obj *obj);
+
+static int yaffs_write_new_chunk(struct yaffs_dev *dev,
+				 const u8 * buffer,
+				 struct yaffs_ext_tags *tags, int use_reserver);
+
+static struct yaffs_obj *yaffs_new_obj(struct yaffs_dev *dev, int number,
+				       enum yaffs_obj_type type);
+
+static int yaffs_apply_xattrib_mod(struct yaffs_obj *obj, char *buffer,
+				   struct yaffs_xattr_mod *xmod);
+
+static void yaffs_remove_obj_from_dir(struct yaffs_obj *obj);
+static int yaffs_generic_obj_del(struct yaffs_obj *in);
+
+static int yaffs_check_chunk_erased(struct yaffs_dev *dev, int nand_chunk);
+
+static int yaffs_unlink_worker(struct yaffs_obj *obj);
+
+static int yaffs_tags_match(const struct yaffs_ext_tags *tags, int obj_id,
+			    int chunk_obj);
+
+static int yaffs_alloc_chunk(struct yaffs_dev *dev, int use_reserver,
+			     struct yaffs_block_info **block_ptr);
+
+static void yaffs_check_obj_details_loaded(struct yaffs_obj *in);
+
+static void yaffs_invalidate_whole_cache(struct yaffs_obj *in);
+static void yaffs_invalidate_chunk_cache(struct yaffs_obj *object,
+					 int chunk_id);
+
+static int yaffs_find_chunk_in_file(struct yaffs_obj *in, int inode_chunk,
+				    struct yaffs_ext_tags *tags);
+
+static int yaffs_verify_chunk_written(struct yaffs_dev *dev,
+				      int nand_chunk,
+				      const u8 * data,
+				      struct yaffs_ext_tags *tags);
+
+static void yaffs_load_name_from_oh(struct yaffs_dev *dev, YCHAR * name,
+				    const YCHAR * oh_name, int buff_size);
+static void yaffs_load_oh_from_name(struct yaffs_dev *dev, YCHAR * oh_name,
+				    const YCHAR * name);
+
+/* Function to calculate chunk and offset */
+
+static void yaffs_addr_to_chunk(struct yaffs_dev *dev, loff_t addr,
+				int *chunk_out, u32 * offset_out)
+{
+	int chunk;
+	u32 offset;
+
+	chunk = (u32) (addr >> dev->chunk_shift);
+
+	if (dev->chunk_div == 1) {
+		/* easy power of 2 case */
+		offset = (u32) (addr & dev->chunk_mask);
+	} else {
+		/* Non power-of-2 case */
+
+		loff_t chunk_base;
+
+		chunk /= dev->chunk_div;
+
+		chunk_base = ((loff_t) chunk) * dev->data_bytes_per_chunk;
+		offset = (u32) (addr - chunk_base);
+	}
+
+	*chunk_out = chunk;
+	*offset_out = offset;
+}
+
+/* Function to return the number of shifts for a power of 2 greater than or
+ * equal to the given number
+ * Note we don't try to cater for all possible numbers and this does not have to
+ * be hellishly efficient.
+ */
+
+static u32 calc_shifts_ceiling(u32 x)
+{
+	int extra_bits;
+	int shifts;
+
+	shifts = extra_bits = 0;
+
+	while (x > 1) {
+		if (x & 1)
+			extra_bits++;
+		x >>= 1;
+		shifts++;
+	}
+
+	if (extra_bits)
+		shifts++;
+
+	return shifts;
+}
+
+/* Function to return the number of shifts to get a 1 in bit 0
+ */
+
+static u32 calc_shifts(u32 x)
+{
+	u32 shifts;
+
+	shifts = 0;
+
+	if (!x)
+		return 0;
+
+	while (!(x & 1)) {
+		x >>= 1;
+		shifts++;
+	}
+
+	return shifts;
+}
+
+/*
+ * Temporary buffer manipulations.
+ */
+
+static int yaffs_init_tmp_buffers(struct yaffs_dev *dev)
+{
+	int i;
+	u8 *buf = (u8 *) 1;
+
+	memset(dev->temp_buffer, 0, sizeof(dev->temp_buffer));
+
+	for (i = 0; buf && i < YAFFS_N_TEMP_BUFFERS; i++) {
+		dev->temp_buffer[i].line = 0;	/* not in use */
+		dev->temp_buffer[i].buffer = buf =
+		    YMALLOC_DMA(dev->param.total_bytes_per_chunk);
+	}
+
+	return buf ? YAFFS_OK : YAFFS_FAIL;
+}
+
+u8 *yaffs_get_temp_buffer(struct yaffs_dev * dev, int line_no)
+{
+	int i, j;
+
+	dev->temp_in_use++;
+	if (dev->temp_in_use > dev->max_temp)
+		dev->max_temp = dev->temp_in_use;
+
+	for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++) {
+		if (dev->temp_buffer[i].line == 0) {
+			dev->temp_buffer[i].line = line_no;
+			if ((i + 1) > dev->max_temp) {
+				dev->max_temp = i + 1;
+				for (j = 0; j <= i; j++)
+					dev->temp_buffer[j].max_line =
+					    dev->temp_buffer[j].line;
+			}
+
+			return dev->temp_buffer[i].buffer;
+		}
+	}
+
+	T(YAFFS_TRACE_BUFFERS,
+	  (TSTR("Out of temp buffers at line %d, other held by lines:"),
+	   line_no));
+	for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++)
+		T(YAFFS_TRACE_BUFFERS,
+		  (TSTR(" %d "), dev->temp_buffer[i].line));
+
+	T(YAFFS_TRACE_BUFFERS, (TSTR(" " TENDSTR)));
+
+	/*
+	 * If we got here then we have to allocate an unmanaged one
+	 * This is not good.
+	 */
+
+	dev->unmanaged_buffer_allocs++;
+	return YMALLOC(dev->data_bytes_per_chunk);
+
+}
+
+void yaffs_release_temp_buffer(struct yaffs_dev *dev, u8 * buffer, int line_no)
+{
+	int i;
+
+	dev->temp_in_use--;
+
+	for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++) {
+		if (dev->temp_buffer[i].buffer == buffer) {
+			dev->temp_buffer[i].line = 0;
+			return;
+		}
+	}
+
+	if (buffer) {
+		/* assume it is an unmanaged one. */
+		T(YAFFS_TRACE_BUFFERS,
+		  (TSTR("Releasing unmanaged temp buffer in line %d" TENDSTR),
+		   line_no));
+		YFREE(buffer);
+		dev->unmanaged_buffer_deallocs++;
+	}
+
+}
+
+/*
+ * Determine if we have a managed buffer.
+ */
+int yaffs_is_managed_tmp_buffer(struct yaffs_dev *dev, const u8 * buffer)
+{
+	int i;
+
+	for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++) {
+		if (dev->temp_buffer[i].buffer == buffer)
+			return 1;
+	}
+
+	for (i = 0; i < dev->param.n_caches; i++) {
+		if (dev->cache[i].data == buffer)
+			return 1;
+	}
+
+	if (buffer == dev->checkpt_buffer)
+		return 1;
+
+	T(YAFFS_TRACE_ALWAYS,
+	  (TSTR("yaffs: unmaged buffer detected.\n" TENDSTR)));
+	return 0;
+}
+
+/*
+ * Verification code
+ */
+
+/*
+ *  Simple hash function. Needs to have a reasonable spread
+ */
+
+static Y_INLINE int yaffs_hash_fn(int n)
+{
+	n = abs(n);
+	return n % YAFFS_NOBJECT_BUCKETS;
+}
+
+/*
+ * Access functions to useful fake objects.
+ * Note that root might have a presence in NAND if permissions are set.
+ */
+
+struct yaffs_obj *yaffs_root(struct yaffs_dev *dev)
+{
+	return dev->root_dir;
+}
+
+struct yaffs_obj *yaffs_lost_n_found(struct yaffs_dev *dev)
+{
+	return dev->lost_n_found;
+}
+
+/*
+ *  Erased NAND checking functions
+ */
+
+int yaffs_check_ff(u8 * buffer, int n_bytes)
+{
+	/* Horrible, slow implementation */
+	while (n_bytes--) {
+		if (*buffer != 0xFF)
+			return 0;
+		buffer++;
+	}
+	return 1;
+}
+
+static int yaffs_check_chunk_erased(struct yaffs_dev *dev, int nand_chunk)
+{
+	int retval = YAFFS_OK;
+	u8 *data = yaffs_get_temp_buffer(dev, __LINE__);
+	struct yaffs_ext_tags tags;
+	int result;
+
+	result = yaffs_rd_chunk_tags_nand(dev, nand_chunk, data, &tags);
+
+	if (tags.ecc_result > YAFFS_ECC_RESULT_NO_ERROR)
+		retval = YAFFS_FAIL;
+
+	if (!yaffs_check_ff(data, dev->data_bytes_per_chunk) || tags.chunk_used) {
+		T(YAFFS_TRACE_NANDACCESS,
+		  (TSTR("Chunk %d not erased" TENDSTR), nand_chunk));
+		retval = YAFFS_FAIL;
+	}
+
+	yaffs_release_temp_buffer(dev, data, __LINE__);
+
+	return retval;
+
+}
+
+static int yaffs_verify_chunk_written(struct yaffs_dev *dev,
+				      int nand_chunk,
+				      const u8 * data,
+				      struct yaffs_ext_tags *tags)
+{
+	int retval = YAFFS_OK;
+	struct yaffs_ext_tags temp_tags;
+	u8 *buffer = yaffs_get_temp_buffer(dev, __LINE__);
+	int result;
+
+	result = yaffs_rd_chunk_tags_nand(dev, nand_chunk, buffer, &temp_tags);
+	if (memcmp(buffer, data, dev->data_bytes_per_chunk) ||
+	    temp_tags.obj_id != tags->obj_id ||
+	    temp_tags.chunk_id != tags->chunk_id ||
+	    temp_tags.n_bytes != tags->n_bytes)
+		retval = YAFFS_FAIL;
+
+	yaffs_release_temp_buffer(dev, buffer, __LINE__);
+
+	return retval;
+}
+
+static int yaffs_write_new_chunk(struct yaffs_dev *dev,
+				 const u8 * data,
+				 struct yaffs_ext_tags *tags, int use_reserver)
+{
+	int attempts = 0;
+	int write_ok = 0;
+	int chunk;
+
+	yaffs2_checkpt_invalidate(dev);
+
+	do {
+		struct yaffs_block_info *bi = 0;
+		int erased_ok = 0;
+
+		chunk = yaffs_alloc_chunk(dev, use_reserver, &bi);
+		if (chunk < 0) {
+			/* no space */
+			break;
+		}
+
+		/* First check this chunk is erased, if it needs
+		 * checking.  The checking policy (unless forced
+		 * always on) is as follows:
+		 *
+		 * Check the first page we try to write in a block.
+		 * If the check passes then we don't need to check any
+		 * more.        If the check fails, we check again...
+		 * If the block has been erased, we don't need to check.
+		 *
+		 * However, if the block has been prioritised for gc,
+		 * then we think there might be something odd about
+		 * this block and stop using it.
+		 *
+		 * Rationale: We should only ever see chunks that have
+		 * not been erased if there was a partially written
+		 * chunk due to power loss.  This checking policy should
+		 * catch that case with very few checks and thus save a
+		 * lot of checks that are most likely not needed.
+		 *
+		 * Mods to the above
+		 * If an erase check fails or the write fails we skip the 
+		 * rest of the block.
+		 */
+
+		/* let's give it a try */
+		attempts++;
+
+		if (dev->param.always_check_erased)
+			bi->skip_erased_check = 0;
+
+		if (!bi->skip_erased_check) {
+			erased_ok = yaffs_check_chunk_erased(dev, chunk);
+			if (erased_ok != YAFFS_OK) {
+				T(YAFFS_TRACE_ERROR,
+				  (TSTR("**>> yaffs chunk %d was not erased"
+					TENDSTR), chunk));
+
+				/* If not erased, delete this one,
+				 * skip rest of block and
+				 * try another chunk */
+				yaffs_chunk_del(dev, chunk, 1, __LINE__);
+				yaffs_skip_rest_of_block(dev);
+				continue;
+			}
+		}
+
+		write_ok = yaffs_wr_chunk_tags_nand(dev, chunk, data, tags);
+
+		if (!bi->skip_erased_check)
+			write_ok =
+			    yaffs_verify_chunk_written(dev, chunk, data, tags);
+
+		if (write_ok != YAFFS_OK) {
+			/* Clean up aborted write, skip to next block and
+			 * try another chunk */
+			yaffs_handle_chunk_wr_error(dev, chunk, erased_ok);
+			continue;
+		}
+
+		bi->skip_erased_check = 1;
+
+		/* Copy the data into the robustification buffer */
+		yaffs_handle_chunk_wr_ok(dev, chunk, data, tags);
+
+	} while (write_ok != YAFFS_OK &&
+		 (yaffs_wr_attempts <= 0 || attempts <= yaffs_wr_attempts));
+
+	if (!write_ok)
+		chunk = -1;
+
+	if (attempts > 1) {
+		T(YAFFS_TRACE_ERROR,
+		  (TSTR("**>> yaffs write required %d attempts" TENDSTR),
+		   attempts));
+
+		dev->n_retired_writes += (attempts - 1);
+	}
+
+	return chunk;
+}
+
+/*
+ * Block retiring for handling a broken block.
+ */
+
+static void yaffs_retire_block(struct yaffs_dev *dev, int flash_block)
+{
+	struct yaffs_block_info *bi = yaffs_get_block_info(dev, flash_block);
+
+	yaffs2_checkpt_invalidate(dev);
+
+	yaffs2_clear_oldest_dirty_seq(dev, bi);
+
+	if (yaffs_mark_bad(dev, flash_block) != YAFFS_OK) {
+		if (yaffs_erase_block(dev, flash_block) != YAFFS_OK) {
+			T(YAFFS_TRACE_ALWAYS,
+			  (TSTR
+			   ("yaffs: Failed to mark bad and erase block %d"
+			    TENDSTR), flash_block));
+		} else {
+			struct yaffs_ext_tags tags;
+			int chunk_id =
+			    flash_block * dev->param.chunks_per_block;
+
+			u8 *buffer = yaffs_get_temp_buffer(dev, __LINE__);
+
+			memset(buffer, 0xff, dev->data_bytes_per_chunk);
+			yaffs_init_tags(&tags);
+			tags.seq_number = YAFFS_SEQUENCE_BAD_BLOCK;
+			if (dev->param.write_chunk_tags_fn(dev, chunk_id -
+							   dev->chunk_offset,
+							   buffer,
+							   &tags) != YAFFS_OK)
+				T(YAFFS_TRACE_ALWAYS,
+				  (TSTR
+				   ("yaffs: Failed to "
+				    TCONT("write bad block marker to block %d")
+				    TENDSTR), flash_block));
+
+			yaffs_release_temp_buffer(dev, buffer, __LINE__);
+		}
+	}
+
+	bi->block_state = YAFFS_BLOCK_STATE_DEAD;
+	bi->gc_prioritise = 0;
+	bi->needs_retiring = 0;
+
+	dev->n_retired_blocks++;
+}
+
+/*
+ * Functions for robustisizing TODO
+ *
+ */
+
+static void yaffs_handle_chunk_wr_ok(struct yaffs_dev *dev, int nand_chunk,
+				     const u8 * data,
+				     const struct yaffs_ext_tags *tags)
+{
+	dev = dev;
+	nand_chunk = nand_chunk;
+	data = data;
+	tags = tags;
+}
+
+static void yaffs_handle_chunk_update(struct yaffs_dev *dev, int nand_chunk,
+				      const struct yaffs_ext_tags *tags)
+{
+	dev = dev;
+	nand_chunk = nand_chunk;
+	tags = tags;
+}
+
+void yaffs_handle_chunk_error(struct yaffs_dev *dev,
+			      struct yaffs_block_info *bi)
+{
+	if (!bi->gc_prioritise) {
+		bi->gc_prioritise = 1;
+		dev->has_pending_prioritised_gc = 1;
+		bi->chunk_error_strikes++;
+
+		if (bi->chunk_error_strikes > 3) {
+			bi->needs_retiring = 1;	/* Too many stikes, so retire this */
+			T(YAFFS_TRACE_ALWAYS,
+			  (TSTR("yaffs: Block struck out" TENDSTR)));
+
+		}
+	}
+}
+
+static void yaffs_handle_chunk_wr_error(struct yaffs_dev *dev, int nand_chunk,
+					int erased_ok)
+{
+	int flash_block = nand_chunk / dev->param.chunks_per_block;
+	struct yaffs_block_info *bi = yaffs_get_block_info(dev, flash_block);
+
+	yaffs_handle_chunk_error(dev, bi);
+
+	if (erased_ok) {
+		/* Was an actual write failure, so mark the block for retirement  */
+		bi->needs_retiring = 1;
+		T(YAFFS_TRACE_ERROR | YAFFS_TRACE_BAD_BLOCKS,
+		  (TSTR("**>> Block %d needs retiring" TENDSTR), flash_block));
+	}
+
+	/* Delete the chunk */
+	yaffs_chunk_del(dev, nand_chunk, 1, __LINE__);
+	yaffs_skip_rest_of_block(dev);
+}
+
+/*---------------- Name handling functions ------------*/
+
+static u16 yaffs_calc_name_sum(const YCHAR * name)
+{
+	u16 sum = 0;
+	u16 i = 1;
+
+	const YUCHAR *bname = (const YUCHAR *)name;
+	if (bname) {
+		while ((*bname) && (i < (YAFFS_MAX_NAME_LENGTH / 2))) {
+
+			/* 0x1f mask is case insensitive */
+			sum += ((*bname) & 0x1f) * i;
+			i++;
+			bname++;
+		}
+	}
+	return sum;
+}
+
+void yaffs_set_obj_name(struct yaffs_obj *obj, const YCHAR * name)
+{
+#ifndef CONFIG_YAFFS_NO_SHORT_NAMES
+	memset(obj->short_name, 0, sizeof(obj->short_name));
+	if (name && 
+	        yaffs_strnlen(name, YAFFS_SHORT_NAME_LENGTH + 1) <=
+	    YAFFS_SHORT_NAME_LENGTH)
+		yaffs_strcpy(obj->short_name, name);
+	else
+		obj->short_name[0] = _Y('\0');
+#endif
+	obj->sum = yaffs_calc_name_sum(name);
+}
+
+void yaffs_set_obj_name_from_oh(struct yaffs_obj *obj,
+				const struct yaffs_obj_hdr *oh)
+{
+#ifdef CONFIG_YAFFS_AUTO_UNICODE
+	YCHAR tmp_name[YAFFS_MAX_NAME_LENGTH + 1];
+	memset(tmp_name, 0, sizeof(tmp_name));
+	yaffs_load_name_from_oh(obj->my_dev, tmp_name, oh->name,
+				YAFFS_MAX_NAME_LENGTH + 1);
+	yaffs_set_obj_name(obj, tmp_name);
+#else
+	yaffs_set_obj_name(obj, oh->name);
+#endif
+}
+
+/*-------------------- TNODES -------------------
+
+ * List of spare tnodes
+ * The list is hooked together using the first pointer
+ * in the tnode.
+ */
+
+struct yaffs_tnode *yaffs_get_tnode(struct yaffs_dev *dev)
+{
+	struct yaffs_tnode *tn = yaffs_alloc_raw_tnode(dev);
+	if (tn) {
+		memset(tn, 0, dev->tnode_size);
+		dev->n_tnodes++;
+	}
+
+	dev->checkpoint_blocks_required = 0;	/* force recalculation */
+
+	return tn;
+}
+
+/* FreeTnode frees up a tnode and puts it back on the free list */
+static void yaffs_free_tnode(struct yaffs_dev *dev, struct yaffs_tnode *tn)
+{
+	yaffs_free_raw_tnode(dev, tn);
+	dev->n_tnodes--;
+	dev->checkpoint_blocks_required = 0;	/* force recalculation */
+}
+
+static void yaffs_deinit_tnodes_and_objs(struct yaffs_dev *dev)
+{
+	yaffs_deinit_raw_tnodes_and_objs(dev);
+	dev->n_obj = 0;
+	dev->n_tnodes = 0;
+}
+
+void yaffs_load_tnode_0(struct yaffs_dev *dev, struct yaffs_tnode *tn,
+			unsigned pos, unsigned val)
+{
+	u32 *map = (u32 *) tn;
+	u32 bit_in_map;
+	u32 bit_in_word;
+	u32 word_in_map;
+	u32 mask;
+
+	pos &= YAFFS_TNODES_LEVEL0_MASK;
+	val >>= dev->chunk_grp_bits;
+
+	bit_in_map = pos * dev->tnode_width;
+	word_in_map = bit_in_map / 32;
+	bit_in_word = bit_in_map & (32 - 1);
+
+	mask = dev->tnode_mask << bit_in_word;
+
+	map[word_in_map] &= ~mask;
+	map[word_in_map] |= (mask & (val << bit_in_word));
+
+	if (dev->tnode_width > (32 - bit_in_word)) {
+		bit_in_word = (32 - bit_in_word);
+		word_in_map++;;
+		mask =
+		    dev->tnode_mask >> ( /*dev->tnode_width - */ bit_in_word);
+		map[word_in_map] &= ~mask;
+		map[word_in_map] |= (mask & (val >> bit_in_word));
+	}
+}
+
+u32 yaffs_get_group_base(struct yaffs_dev *dev, struct yaffs_tnode *tn,
+			 unsigned pos)
+{
+	u32 *map = (u32 *) tn;
+	u32 bit_in_map;
+	u32 bit_in_word;
+	u32 word_in_map;
+	u32 val;
+
+	pos &= YAFFS_TNODES_LEVEL0_MASK;
+
+	bit_in_map = pos * dev->tnode_width;
+	word_in_map = bit_in_map / 32;
+	bit_in_word = bit_in_map & (32 - 1);
+
+	val = map[word_in_map] >> bit_in_word;
+
+	if (dev->tnode_width > (32 - bit_in_word)) {
+		bit_in_word = (32 - bit_in_word);
+		word_in_map++;;
+		val |= (map[word_in_map] << bit_in_word);
+	}
+
+	val &= dev->tnode_mask;
+	val <<= dev->chunk_grp_bits;
+
+	return val;
+}
+
+/* ------------------- End of individual tnode manipulation -----------------*/
+
+/* ---------Functions to manipulate the look-up tree (made up of tnodes) ------
+ * The look up tree is represented by the top tnode and the number of top_level
+ * in the tree. 0 means only the level 0 tnode is in the tree.
+ */
+
+/* FindLevel0Tnode finds the level 0 tnode, if one exists. */
+struct yaffs_tnode *yaffs_find_tnode_0(struct yaffs_dev *dev,
+				       struct yaffs_file_var *file_struct,
+				       u32 chunk_id)
+{
+	struct yaffs_tnode *tn = file_struct->top;
+	u32 i;
+	int required_depth;
+	int level = file_struct->top_level;
+
+	dev = dev;
+
+	/* Check sane level and chunk Id */
+	if (level < 0 || level > YAFFS_TNODES_MAX_LEVEL)
+		return NULL;
+
+	if (chunk_id > YAFFS_MAX_CHUNK_ID)
+		return NULL;
+
+	/* First check we're tall enough (ie enough top_level) */
+
+	i = chunk_id >> YAFFS_TNODES_LEVEL0_BITS;
+	required_depth = 0;
+	while (i) {
+		i >>= YAFFS_TNODES_INTERNAL_BITS;
+		required_depth++;
+	}
+
+	if (required_depth > file_struct->top_level)
+		return NULL;	/* Not tall enough, so we can't find it */
+
+	/* Traverse down to level 0 */
+	while (level > 0 && tn) {
+		tn = tn->internal[(chunk_id >>
+				   (YAFFS_TNODES_LEVEL0_BITS +
+				    (level - 1) *
+				    YAFFS_TNODES_INTERNAL_BITS)) &
+				  YAFFS_TNODES_INTERNAL_MASK];
+		level--;
+	}
+
+	return tn;
+}
+
+/* AddOrFindLevel0Tnode finds the level 0 tnode if it exists, otherwise first expands the tree.
+ * This happens in two steps:
+ *  1. If the tree isn't tall enough, then make it taller.
+ *  2. Scan down the tree towards the level 0 tnode adding tnodes if required.
+ *
+ * Used when modifying the tree.
+ *
+ *  If the tn argument is NULL, then a fresh tnode will be added otherwise the specified tn will
+ *  be plugged into the ttree.
+ */
+
+struct yaffs_tnode *yaffs_add_find_tnode_0(struct yaffs_dev *dev,
+					   struct yaffs_file_var *file_struct,
+					   u32 chunk_id,
+					   struct yaffs_tnode *passed_tn)
+{
+	int required_depth;
+	int i;
+	int l;
+	struct yaffs_tnode *tn;
+
+	u32 x;
+
+	/* Check sane level and page Id */
+	if (file_struct->top_level < 0
+	    || file_struct->top_level > YAFFS_TNODES_MAX_LEVEL)
+		return NULL;
+
+	if (chunk_id > YAFFS_MAX_CHUNK_ID)
+		return NULL;
+
+	/* First check we're tall enough (ie enough top_level) */
+
+	x = chunk_id >> YAFFS_TNODES_LEVEL0_BITS;
+	required_depth = 0;
+	while (x) {
+		x >>= YAFFS_TNODES_INTERNAL_BITS;
+		required_depth++;
+	}
+
+	if (required_depth > file_struct->top_level) {
+		/* Not tall enough, gotta make the tree taller */
+		for (i = file_struct->top_level; i < required_depth; i++) {
+
+			tn = yaffs_get_tnode(dev);
+
+			if (tn) {
+				tn->internal[0] = file_struct->top;
+				file_struct->top = tn;
+				file_struct->top_level++;
+			} else {
+				T(YAFFS_TRACE_ERROR,
+				  (TSTR("yaffs: no more tnodes" TENDSTR)));
+				return NULL;
+			}
+		}
+	}
+
+	/* Traverse down to level 0, adding anything we need */
+
+	l = file_struct->top_level;
+	tn = file_struct->top;
+
+	if (l > 0) {
+		while (l > 0 && tn) {
+			x = (chunk_id >>
+			     (YAFFS_TNODES_LEVEL0_BITS +
+			      (l - 1) * YAFFS_TNODES_INTERNAL_BITS)) &
+			    YAFFS_TNODES_INTERNAL_MASK;
+
+			if ((l > 1) && !tn->internal[x]) {
+				/* Add missing non-level-zero tnode */
+				tn->internal[x] = yaffs_get_tnode(dev);
+				if (!tn->internal[x])
+					return NULL;
+			} else if (l == 1) {
+				/* Looking from level 1 at level 0 */
+				if (passed_tn) {
+					/* If we already have one, then release it. */
+					if (tn->internal[x])
+						yaffs_free_tnode(dev,
+								 tn->
+								 internal[x]);
+					tn->internal[x] = passed_tn;
+
+				} else if (!tn->internal[x]) {
+					/* Don't have one, none passed in */
+					tn->internal[x] = yaffs_get_tnode(dev);
+					if (!tn->internal[x])
+						return NULL;
+				}
+			}
+
+			tn = tn->internal[x];
+			l--;
+		}
+	} else {
+		/* top is level 0 */
+		if (passed_tn) {
+			memcpy(tn, passed_tn,
+			       (dev->tnode_width * YAFFS_NTNODES_LEVEL0) / 8);
+			yaffs_free_tnode(dev, passed_tn);
+		}
+	}
+
+	return tn;
+}
+
+static int yaffs_find_chunk_in_group(struct yaffs_dev *dev, int the_chunk,
+				     struct yaffs_ext_tags *tags, int obj_id,
+				     int inode_chunk)
+{
+	int j;
+
+	for (j = 0; the_chunk && j < dev->chunk_grp_size; j++) {
+		if (yaffs_check_chunk_bit
+		    (dev, the_chunk / dev->param.chunks_per_block,
+		     the_chunk % dev->param.chunks_per_block)) {
+
+			if (dev->chunk_grp_size == 1)
+				return the_chunk;
+			else {
+				yaffs_rd_chunk_tags_nand(dev, the_chunk, NULL,
+							 tags);
+				if (yaffs_tags_match(tags, obj_id, inode_chunk)) {
+					/* found it; */
+					return the_chunk;
+				}
+			}
+		}
+		the_chunk++;
+	}
+	return -1;
+}
+
+static void yaffs_soft_del_chunk(struct yaffs_dev *dev, int chunk)
+{
+	struct yaffs_block_info *the_block;
+	unsigned block_no;
+
+	T(YAFFS_TRACE_DELETION, (TSTR("soft delete chunk %d" TENDSTR), chunk));
+
+	block_no = chunk / dev->param.chunks_per_block;
+	the_block = yaffs_get_block_info(dev, block_no);
+	if (the_block) {
+		the_block->soft_del_pages++;
+		dev->n_free_chunks++;
+		yaffs2_update_oldest_dirty_seq(dev, block_no, the_block);
+	}
+}
+
+/* SoftDeleteWorker scans backwards through the tnode tree and soft deletes all the chunks in the file.
+ * All soft deleting does is increment the block's softdelete count and pulls the chunk out
+ * of the tnode.
+ * Thus, essentially this is the same as DeleteWorker except that the chunks are soft deleted.
+ */
+
+static int yaffs_soft_del_worker(struct yaffs_obj *in, struct yaffs_tnode *tn,
+				 u32 level, int chunk_offset)
+{
+	int i;
+	int the_chunk;
+	int all_done = 1;
+	struct yaffs_dev *dev = in->my_dev;
+
+	if (tn) {
+		if (level > 0) {
+
+			for (i = YAFFS_NTNODES_INTERNAL - 1; all_done && i >= 0;
+			     i--) {
+				if (tn->internal[i]) {
+					all_done =
+					    yaffs_soft_del_worker(in,
+								  tn->internal
+								  [i],
+								  level - 1,
+								  (chunk_offset
+								   <<
+								   YAFFS_TNODES_INTERNAL_BITS)
+								  + i);
+					if (all_done) {
+						yaffs_free_tnode(dev,
+								 tn->internal
+								 [i]);
+						tn->internal[i] = NULL;
+					} else {
+						/* Hoosterman... how could this happen? */
+					}
+				}
+			}
+			return (all_done) ? 1 : 0;
+		} else if (level == 0) {
+
+			for (i = YAFFS_NTNODES_LEVEL0 - 1; i >= 0; i--) {
+				the_chunk = yaffs_get_group_base(dev, tn, i);
+				if (the_chunk) {
+					/* Note this does not find the real chunk, only the chunk group.
+					 * We make an assumption that a chunk group is not larger than
+					 * a block.
+					 */
+					yaffs_soft_del_chunk(dev, the_chunk);
+					yaffs_load_tnode_0(dev, tn, i, 0);
+				}
+
+			}
+			return 1;
+
+		}
+
+	}
+
+	return 1;
+
+}
+
+static void yaffs_soft_del_file(struct yaffs_obj *obj)
+{
+	if (obj->deleted &&
+	    obj->variant_type == YAFFS_OBJECT_TYPE_FILE && !obj->soft_del) {
+		if (obj->n_data_chunks <= 0) {
+			/* Empty file with no duplicate object headers, just delete it immediately */
+			yaffs_free_tnode(obj->my_dev,
+					 obj->variant.file_variant.top);
+			obj->variant.file_variant.top = NULL;
+			T(YAFFS_TRACE_TRACING,
+			  (TSTR("yaffs: Deleting empty file %d" TENDSTR),
+			   obj->obj_id));
+			yaffs_generic_obj_del(obj);
+		} else {
+			yaffs_soft_del_worker(obj,
+					      obj->variant.file_variant.top,
+					      obj->variant.
+					      file_variant.top_level, 0);
+			obj->soft_del = 1;
+		}
+	}
+}
+
+/* Pruning removes any part of the file structure tree that is beyond the
+ * bounds of the file (ie that does not point to chunks).
+ *
+ * A file should only get pruned when its size is reduced.
+ *
+ * Before pruning, the chunks must be pulled from the tree and the
+ * level 0 tnode entries must be zeroed out.
+ * Could also use this for file deletion, but that's probably better handled
+ * by a special case.
+ *
+ * This function is recursive. For levels > 0 the function is called again on
+ * any sub-tree. For level == 0 we just check if the sub-tree has data.
+ * If there is no data in a subtree then it is pruned.
+ */
+
+static struct yaffs_tnode *yaffs_prune_worker(struct yaffs_dev *dev,
+					      struct yaffs_tnode *tn, u32 level,
+					      int del0)
+{
+	int i;
+	int has_data;
+
+	if (tn) {
+		has_data = 0;
+
+		if (level > 0) {
+			for (i = 0; i < YAFFS_NTNODES_INTERNAL; i++) {
+				if (tn->internal[i]) {
+					tn->internal[i] =
+					    yaffs_prune_worker(dev,
+							       tn->internal[i],
+							       level - 1,
+							       (i ==
+								0) ? del0 : 1);
+				}
+
+				if (tn->internal[i])
+					has_data++;
+			}
+		} else {
+			int tnode_size_u32 = dev->tnode_size / sizeof(u32);
+			u32 *map = (u32 *) tn;
+
+			for (i = 0; !has_data && i < tnode_size_u32; i++) {
+				if (map[i])
+					has_data++;
+			}
+		}
+
+		if (has_data == 0 && del0) {
+			/* Free and return NULL */
+
+			yaffs_free_tnode(dev, tn);
+			tn = NULL;
+		}
+
+	}
+
+	return tn;
+
+}
+
+static int yaffs_prune_tree(struct yaffs_dev *dev,
+			    struct yaffs_file_var *file_struct)
+{
+	int i;
+	int has_data;
+	int done = 0;
+	struct yaffs_tnode *tn;
+
+	if (file_struct->top_level > 0) {
+		file_struct->top =
+		    yaffs_prune_worker(dev, file_struct->top,
+				       file_struct->top_level, 0);
+
+		/* Now we have a tree with all the non-zero branches NULL but the height
+		 * is the same as it was.
+		 * Let's see if we can trim internal tnodes to shorten the tree.
+		 * We can do this if only the 0th element in the tnode is in use
+		 * (ie all the non-zero are NULL)
+		 */
+
+		while (file_struct->top_level && !done) {
+			tn = file_struct->top;
+
+			has_data = 0;
+			for (i = 1; i < YAFFS_NTNODES_INTERNAL; i++) {
+				if (tn->internal[i])
+					has_data++;
+			}
+
+			if (!has_data) {
+				file_struct->top = tn->internal[0];
+				file_struct->top_level--;
+				yaffs_free_tnode(dev, tn);
+			} else {
+				done = 1;
+			}
+		}
+	}
+
+	return YAFFS_OK;
+}
+
+/*-------------------- End of File Structure functions.-------------------*/
+
+/* AllocateEmptyObject gets us a clean Object. Tries to make allocate more if we run out */
+static struct yaffs_obj *yaffs_alloc_empty_obj(struct yaffs_dev *dev)
+{
+	struct yaffs_obj *obj = yaffs_alloc_raw_obj(dev);
+
+	if (obj) {
+		dev->n_obj++;
+
+		/* Now sweeten it up... */
+
+		memset(obj, 0, sizeof(struct yaffs_obj));
+		obj->being_created = 1;
+
+		obj->my_dev = dev;
+		obj->hdr_chunk = 0;
+		obj->variant_type = YAFFS_OBJECT_TYPE_UNKNOWN;
+		INIT_LIST_HEAD(&(obj->hard_links));
+		INIT_LIST_HEAD(&(obj->hash_link));
+		INIT_LIST_HEAD(&obj->siblings);
+
+		/* Now make the directory sane */
+		if (dev->root_dir) {
+			obj->parent = dev->root_dir;
+			list_add(&(obj->siblings),
+				 &dev->root_dir->variant.dir_variant.children);
+		}
+
+		/* Add it to the lost and found directory.
+		 * NB Can't put root or lost-n-found in lost-n-found so
+		 * check if lost-n-found exists first
+		 */
+		if (dev->lost_n_found)
+			yaffs_add_obj_to_dir(dev->lost_n_found, obj);
+
+		obj->being_created = 0;
+	}
+
+	dev->checkpoint_blocks_required = 0;	/* force recalculation */
+
+	return obj;
+}
+
+static struct yaffs_obj *yaffs_create_fake_dir(struct yaffs_dev *dev,
+					       int number, u32 mode)
+{
+
+	struct yaffs_obj *obj =
+	    yaffs_new_obj(dev, number, YAFFS_OBJECT_TYPE_DIRECTORY);
+	if (obj) {
+		obj->fake = 1;	/* it is fake so it might have no NAND presence... */
+		obj->rename_allowed = 0;	/* ... and we're not allowed to rename it... */
+		obj->unlink_allowed = 0;	/* ... or unlink it */
+		obj->deleted = 0;
+		obj->unlinked = 0;
+		obj->yst_mode = mode;
+		obj->my_dev = dev;
+		obj->hdr_chunk = 0;	/* Not a valid chunk. */
+	}
+
+	return obj;
+
+}
+
+static void yaffs_unhash_obj(struct yaffs_obj *obj)
+{
+	int bucket;
+	struct yaffs_dev *dev = obj->my_dev;
+
+	/* If it is still linked into the bucket list, free from the list */
+	if (!list_empty(&obj->hash_link)) {
+		list_del_init(&obj->hash_link);
+		bucket = yaffs_hash_fn(obj->obj_id);
+		dev->obj_bucket[bucket].count--;
+	}
+}
+
+/*  FreeObject frees up a Object and puts it back on the free list */
+static void yaffs_free_obj(struct yaffs_obj *obj)
+{
+	struct yaffs_dev *dev = obj->my_dev;
+
+	T(YAFFS_TRACE_OS,
+	  (TSTR("FreeObject %p inode %p" TENDSTR), obj, obj->my_inode));
+
+	if (!obj)
+		YBUG();
+	if (obj->parent)
+		YBUG();
+	if (!list_empty(&obj->siblings))
+		YBUG();
+
+	if (obj->my_inode) {
+		/* We're still hooked up to a cached inode.
+		 * Don't delete now, but mark for later deletion
+		 */
+		obj->defered_free = 1;
+		return;
+	}
+
+	yaffs_unhash_obj(obj);
+
+	yaffs_free_raw_obj(dev, obj);
+	dev->n_obj--;
+	dev->checkpoint_blocks_required = 0;	/* force recalculation */
+}
+
+void yaffs_handle_defered_free(struct yaffs_obj *obj)
+{
+	if (obj->defered_free)
+		yaffs_free_obj(obj);
+}
+
+static void yaffs_init_tnodes_and_objs(struct yaffs_dev *dev)
+{
+	int i;
+
+	dev->n_obj = 0;
+	dev->n_tnodes = 0;
+
+	yaffs_init_raw_tnodes_and_objs(dev);
+
+	for (i = 0; i < YAFFS_NOBJECT_BUCKETS; i++) {
+		INIT_LIST_HEAD(&dev->obj_bucket[i].list);
+		dev->obj_bucket[i].count = 0;
+	}
+}
+
+static int yaffs_find_nice_bucket(struct yaffs_dev *dev)
+{
+	int i;
+	int l = 999;
+	int lowest = 999999;
+
+	/* Search for the shortest list or one that
+	 * isn't too long.
+	 */
+
+	for (i = 0; i < 10 && lowest > 4; i++) {
+		dev->bucket_finder++;
+		dev->bucket_finder %= YAFFS_NOBJECT_BUCKETS;
+		if (dev->obj_bucket[dev->bucket_finder].count < lowest) {
+			lowest = dev->obj_bucket[dev->bucket_finder].count;
+			l = dev->bucket_finder;
+		}
+
+	}
+
+	return l;
+}
+
+static int yaffs_new_obj_id(struct yaffs_dev *dev)
+{
+	int bucket = yaffs_find_nice_bucket(dev);
+
+	/* Now find an object value that has not already been taken
+	 * by scanning the list.
+	 */
+
+	int found = 0;
+	struct list_head *i;
+
+	u32 n = (u32) bucket;
+
+	/* yaffs_check_obj_hash_sane();  */
+
+	while (!found) {
+		found = 1;
+		n += YAFFS_NOBJECT_BUCKETS;
+		if (1 || dev->obj_bucket[bucket].count > 0) {
+			list_for_each(i, &dev->obj_bucket[bucket].list) {
+				/* If there is already one in the list */
+				if (i && list_entry(i, struct yaffs_obj,
+						    hash_link)->obj_id == n) {
+					found = 0;
+				}
+			}
+		}
+	}
+
+	return n;
+}
+
+static void yaffs_hash_obj(struct yaffs_obj *in)
+{
+	int bucket = yaffs_hash_fn(in->obj_id);
+	struct yaffs_dev *dev = in->my_dev;
+
+	list_add(&in->hash_link, &dev->obj_bucket[bucket].list);
+	dev->obj_bucket[bucket].count++;
+}
+
+struct yaffs_obj *yaffs_find_by_number(struct yaffs_dev *dev, u32 number)
+{
+	int bucket = yaffs_hash_fn(number);
+	struct list_head *i;
+	struct yaffs_obj *in;
+
+	list_for_each(i, &dev->obj_bucket[bucket].list) {
+		/* Look if it is in the list */
+		if (i) {
+			in = list_entry(i, struct yaffs_obj, hash_link);
+			if (in->obj_id == number) {
+
+				/* Don't tell the VFS about this one if it is defered free */
+				if (in->defered_free)
+					return NULL;
+
+				return in;
+			}
+		}
+	}
+
+	return NULL;
+}
+
+struct yaffs_obj *yaffs_new_obj(struct yaffs_dev *dev, int number,
+				enum yaffs_obj_type type)
+{
+	struct yaffs_obj *the_obj = NULL;
+	struct yaffs_tnode *tn = NULL;
+
+	if (number < 0)
+		number = yaffs_new_obj_id(dev);
+
+	if (type == YAFFS_OBJECT_TYPE_FILE) {
+		tn = yaffs_get_tnode(dev);
+		if (!tn)
+			return NULL;
+	}
+
+	the_obj = yaffs_alloc_empty_obj(dev);
+	if (!the_obj) {
+		if (tn)
+			yaffs_free_tnode(dev, tn);
+		return NULL;
+	}
+
+	if (the_obj) {
+		the_obj->fake = 0;
+		the_obj->rename_allowed = 1;
+		the_obj->unlink_allowed = 1;
+		the_obj->obj_id = number;
+		yaffs_hash_obj(the_obj);
+		the_obj->variant_type = type;
+		yaffs_load_current_time(the_obj, 1, 1);
+
+		switch (type) {
+		case YAFFS_OBJECT_TYPE_FILE:
+			the_obj->variant.file_variant.file_size = 0;
+			the_obj->variant.file_variant.scanned_size = 0;
+			the_obj->variant.file_variant.shrink_size = ~0;	/* max */
+			the_obj->variant.file_variant.top_level = 0;
+			the_obj->variant.file_variant.top = tn;
+			break;
+		case YAFFS_OBJECT_TYPE_DIRECTORY:
+			INIT_LIST_HEAD(&the_obj->variant.dir_variant.children);
+			INIT_LIST_HEAD(&the_obj->variant.dir_variant.dirty);
+			break;
+		case YAFFS_OBJECT_TYPE_SYMLINK:
+		case YAFFS_OBJECT_TYPE_HARDLINK:
+		case YAFFS_OBJECT_TYPE_SPECIAL:
+			/* No action required */
+			break;
+		case YAFFS_OBJECT_TYPE_UNKNOWN:
+			/* todo this should not happen */
+			break;
+		}
+	}
+
+	return the_obj;
+}
+
+struct yaffs_obj *yaffs_find_or_create_by_number(struct yaffs_dev *dev,
+						 int number,
+						 enum yaffs_obj_type type)
+{
+	struct yaffs_obj *the_obj = NULL;
+
+	if (number > 0)
+		the_obj = yaffs_find_by_number(dev, number);
+
+	if (!the_obj)
+		the_obj = yaffs_new_obj(dev, number, type);
+
+	return the_obj;
+
+}
+
+YCHAR *yaffs_clone_str(const YCHAR * str)
+{
+	YCHAR *new_str = NULL;
+	int len;
+
+	if (!str)
+		str = _Y("");
+
+	len = yaffs_strnlen(str, YAFFS_MAX_ALIAS_LENGTH);
+	new_str = YMALLOC((len + 1) * sizeof(YCHAR));
+	if (new_str) {
+		yaffs_strncpy(new_str, str, len);
+		new_str[len] = 0;
+	}
+	return new_str;
+
+}
+
+/*
+ * Mknod (create) a new object.
+ * equiv_obj only has meaning for a hard link;
+ * alias_str only has meaning for a symlink.
+ * rdev only has meaning for devices (a subset of special objects)
+ */
+
+static struct yaffs_obj *yaffs_create_obj(enum yaffs_obj_type type,
+					  struct yaffs_obj *parent,
+					  const YCHAR * name,
+					  u32 mode,
+					  u32 uid,
+					  u32 gid,
+					  struct yaffs_obj *equiv_obj,
+					  const YCHAR * alias_str, u32 rdev)
+{
+	struct yaffs_obj *in;
+	YCHAR *str = NULL;
+
+	struct yaffs_dev *dev = parent->my_dev;
+
+	/* Check if the entry exists. If it does then fail the call since we don't want a dup. */
+	if (yaffs_find_by_name(parent, name))
+		return NULL;
+
+	if (type == YAFFS_OBJECT_TYPE_SYMLINK) {
+		str = yaffs_clone_str(alias_str);
+		if (!str)
+			return NULL;
+	}
+
+	in = yaffs_new_obj(dev, -1, type);
+
+	if (!in) {
+		if (str)
+			YFREE(str);
+		return NULL;
+	}
+
+	if (in) {
+		in->hdr_chunk = 0;
+		in->valid = 1;
+		in->variant_type = type;
+
+		in->yst_mode = mode;
+
+		yaffs_attribs_init(in, gid, uid, rdev);
+
+		in->n_data_chunks = 0;
+
+		yaffs_set_obj_name(in, name);
+		in->dirty = 1;
+
+		yaffs_add_obj_to_dir(parent, in);
+
+		in->my_dev = parent->my_dev;
+
+		switch (type) {
+		case YAFFS_OBJECT_TYPE_SYMLINK:
+			in->variant.symlink_variant.alias = str;
+			break;
+		case YAFFS_OBJECT_TYPE_HARDLINK:
+			in->variant.hardlink_variant.equiv_obj = equiv_obj;
+			in->variant.hardlink_variant.equiv_id =
+			    equiv_obj->obj_id;
+			list_add(&in->hard_links, &equiv_obj->hard_links);
+			break;
+		case YAFFS_OBJECT_TYPE_FILE:
+		case YAFFS_OBJECT_TYPE_DIRECTORY:
+		case YAFFS_OBJECT_TYPE_SPECIAL:
+		case YAFFS_OBJECT_TYPE_UNKNOWN:
+			/* do nothing */
+			break;
+		}
+
+		if (yaffs_update_oh(in, name, 0, 0, 0, NULL) < 0) {
+			/* Could not create the object header, fail the creation */
+			yaffs_del_obj(in);
+			in = NULL;
+		}
+
+		yaffs_update_parent(parent);
+	}
+
+	return in;
+}
+
+struct yaffs_obj *yaffs_create_file(struct yaffs_obj *parent,
+				    const YCHAR * name, u32 mode, u32 uid,
+				    u32 gid)
+{
+	return yaffs_create_obj(YAFFS_OBJECT_TYPE_FILE, parent, name, mode,
+				uid, gid, NULL, NULL, 0);
+}
+
+struct yaffs_obj *yaffs_create_dir(struct yaffs_obj *parent, const YCHAR * name,
+				   u32 mode, u32 uid, u32 gid)
+{
+	return yaffs_create_obj(YAFFS_OBJECT_TYPE_DIRECTORY, parent, name,
+				mode, uid, gid, NULL, NULL, 0);
+}
+
+struct yaffs_obj *yaffs_create_special(struct yaffs_obj *parent,
+				       const YCHAR * name, u32 mode, u32 uid,
+				       u32 gid, u32 rdev)
+{
+	return yaffs_create_obj(YAFFS_OBJECT_TYPE_SPECIAL, parent, name, mode,
+				uid, gid, NULL, NULL, rdev);
+}
+
+struct yaffs_obj *yaffs_create_symlink(struct yaffs_obj *parent,
+				       const YCHAR * name, u32 mode, u32 uid,
+				       u32 gid, const YCHAR * alias)
+{
+	return yaffs_create_obj(YAFFS_OBJECT_TYPE_SYMLINK, parent, name, mode,
+				uid, gid, NULL, alias, 0);
+}
+
+/* yaffs_link_obj returns the object id of the equivalent object.*/
+struct yaffs_obj *yaffs_link_obj(struct yaffs_obj *parent, const YCHAR * name,
+				 struct yaffs_obj *equiv_obj)
+{
+	/* Get the real object in case we were fed a hard link as an equivalent object */
+	equiv_obj = yaffs_get_equivalent_obj(equiv_obj);
+
+	if (yaffs_create_obj
+	    (YAFFS_OBJECT_TYPE_HARDLINK, parent, name, 0, 0, 0,
+	     equiv_obj, NULL, 0)) {
+		return equiv_obj;
+	} else {
+		return NULL;
+	}
+
+}
+
+static int yaffs_change_obj_name(struct yaffs_obj *obj,
+				 struct yaffs_obj *new_dir,
+				 const YCHAR * new_name, int force, int shadows)
+{
+	int unlink_op;
+	int del_op;
+
+	struct yaffs_obj *existing_target;
+
+	if (new_dir == NULL)
+		new_dir = obj->parent;	/* use the old directory */
+
+	if (new_dir->variant_type != YAFFS_OBJECT_TYPE_DIRECTORY) {
+		T(YAFFS_TRACE_ALWAYS,
+		  (TSTR
+		   ("tragedy: yaffs_change_obj_name: new_dir is not a directory"
+		    TENDSTR)));
+		YBUG();
+	}
+
+	/* TODO: Do we need this different handling for YAFFS2 and YAFFS1?? */
+	if (obj->my_dev->param.is_yaffs2)
+		unlink_op = (new_dir == obj->my_dev->unlinked_dir);
+	else
+		unlink_op = (new_dir == obj->my_dev->unlinked_dir
+			     && obj->variant_type == YAFFS_OBJECT_TYPE_FILE);
+
+	del_op = (new_dir == obj->my_dev->del_dir);
+
+	existing_target = yaffs_find_by_name(new_dir, new_name);
+
+	/* If the object is a file going into the unlinked directory,
+	 *   then it is OK to just stuff it in since duplicate names are allowed.
+	 *   else only proceed if the new name does not exist and if we're putting
+	 *   it into a directory.
+	 */
+	if ((unlink_op ||
+	     del_op ||
+	     force ||
+	     (shadows > 0) ||
+	     !existing_target) &&
+	    new_dir->variant_type == YAFFS_OBJECT_TYPE_DIRECTORY) {
+		yaffs_set_obj_name(obj, new_name);
+		obj->dirty = 1;
+
+		yaffs_add_obj_to_dir(new_dir, obj);
+
+		if (unlink_op)
+			obj->unlinked = 1;
+
+		/* If it is a deletion then we mark it as a shrink for gc purposes. */
+		if (yaffs_update_oh(obj, new_name, 0, del_op, shadows, NULL) >=
+		    0)
+			return YAFFS_OK;
+	}
+
+	return YAFFS_FAIL;
+}
+
+
+/* Note:
+ * If old_name is NULL then we take old_dir as the object to be renamed.
+ */
+int yaffs_rename_obj(struct yaffs_obj *old_dir, const YCHAR * old_name,
+		     struct yaffs_obj *new_dir, const YCHAR * new_name)
+{
+	struct yaffs_obj *obj = NULL;
+	struct yaffs_obj *existing_target = NULL;
+	int force = 0;
+	int result;
+	struct yaffs_dev *dev;
+
+	if (!old_dir || old_dir->variant_type != YAFFS_OBJECT_TYPE_DIRECTORY)
+		YBUG();
+	if (!new_dir || new_dir->variant_type != YAFFS_OBJECT_TYPE_DIRECTORY)
+		YBUG();
+
+	dev = old_dir->my_dev;
+
+#ifdef CONFIG_YAFFS_CASE_INSENSITIVE
+	/* Special case for case insemsitive systems.
+	 * While look-up is case insensitive, the name isn't.
+	 * Therefore we might want to change x.txt to X.txt
+	 */
+	if (old_dir == new_dir && 
+		old_name && new_name && 
+		yaffs_strcmp(old_name, new_name) == 0)
+		force = 1;
+#endif
+
+	if (yaffs_strnlen(new_name, YAFFS_MAX_NAME_LENGTH + 1) >
+	    YAFFS_MAX_NAME_LENGTH)
+		/* ENAMETOOLONG */
+		return YAFFS_FAIL;
+
+	if(old_name)
+		obj = yaffs_find_by_name(old_dir, old_name);
+	else{
+		obj = old_dir;
+		old_dir = obj->parent;
+	}
+
+
+	if (obj && obj->rename_allowed) {
+
+		/* Now do the handling for an existing target, if there is one */
+
+		existing_target = yaffs_find_by_name(new_dir, new_name);
+		if (yaffs_is_non_empty_dir(existing_target)){
+			return YAFFS_FAIL;	/* ENOTEMPTY */
+		} else if (existing_target && existing_target != obj) {
+			/* Nuke the target first, using shadowing,
+			 * but only if it isn't the same object.
+			 *
+			 * Note we must disable gc otherwise it can mess up the shadowing.
+			 *
+			 */
+			dev->gc_disable = 1;
+			yaffs_change_obj_name(obj, new_dir, new_name, force,
+					      existing_target->obj_id);
+			existing_target->is_shadowed = 1;
+			yaffs_unlink_obj(existing_target);
+			dev->gc_disable = 0;
+		}
+
+		result = yaffs_change_obj_name(obj, new_dir, new_name, 1, 0);
+
+		yaffs_update_parent(old_dir);
+		if (new_dir != old_dir)
+			yaffs_update_parent(new_dir);
+
+		return result;
+	}
+	return YAFFS_FAIL;
+}
+
+/*------------------------- Block Management and Page Allocation ----------------*/
+
+static int yaffs_init_blocks(struct yaffs_dev *dev)
+{
+	int n_blocks = dev->internal_end_block - dev->internal_start_block + 1;
+
+	dev->block_info = NULL;
+	dev->chunk_bits = NULL;
+
+	dev->alloc_block = -1;	/* force it to get a new one */
+
+	/* If the first allocation strategy fails, thry the alternate one */
+	dev->block_info = YMALLOC(n_blocks * sizeof(struct yaffs_block_info));
+	if (!dev->block_info) {
+		dev->block_info =
+		    YMALLOC_ALT(n_blocks * sizeof(struct yaffs_block_info));
+		dev->block_info_alt = 1;
+	} else {
+		dev->block_info_alt = 0;
+        }
+
+	if (dev->block_info) {
+		/* Set up dynamic blockinfo stuff. */
+		dev->chunk_bit_stride = (dev->param.chunks_per_block + 7) / 8;	/* round up bytes */
+		dev->chunk_bits = YMALLOC(dev->chunk_bit_stride * n_blocks);
+		if (!dev->chunk_bits) {
+			dev->chunk_bits =
+			    YMALLOC_ALT(dev->chunk_bit_stride * n_blocks);
+			dev->chunk_bits_alt = 1;
+		} else {
+			dev->chunk_bits_alt = 0;
+                }
+	}
+
+	if (dev->block_info && dev->chunk_bits) {
+		memset(dev->block_info, 0,
+		       n_blocks * sizeof(struct yaffs_block_info));
+		memset(dev->chunk_bits, 0, dev->chunk_bit_stride * n_blocks);
+		return YAFFS_OK;
+	}
+
+	return YAFFS_FAIL;
+}
+
+static void yaffs_deinit_blocks(struct yaffs_dev *dev)
+{
+	if (dev->block_info_alt && dev->block_info)
+		YFREE_ALT(dev->block_info);
+	else if (dev->block_info)
+		YFREE(dev->block_info);
+
+	dev->block_info_alt = 0;
+
+	dev->block_info = NULL;
+
+	if (dev->chunk_bits_alt && dev->chunk_bits)
+		YFREE_ALT(dev->chunk_bits);
+	else if (dev->chunk_bits)
+		YFREE(dev->chunk_bits);
+	dev->chunk_bits_alt = 0;
+	dev->chunk_bits = NULL;
+}
+
+void yaffs_block_became_dirty(struct yaffs_dev *dev, int block_no)
+{
+	struct yaffs_block_info *bi = yaffs_get_block_info(dev, block_no);
+
+	int erased_ok = 0;
+
+	/* If the block is still healthy erase it and mark as clean.
+	 * If the block has had a data failure, then retire it.
+	 */
+
+	T(YAFFS_TRACE_GC | YAFFS_TRACE_ERASE,
+	  (TSTR("yaffs_block_became_dirty block %d state %d %s" TENDSTR),
+	   block_no, bi->block_state,
+	   (bi->needs_retiring) ? "needs retiring" : ""));
+
+	yaffs2_clear_oldest_dirty_seq(dev, bi);
+
+	bi->block_state = YAFFS_BLOCK_STATE_DIRTY;
+
+	/* If this is the block being garbage collected then stop gc'ing this block */
+	if (block_no == dev->gc_block)
+		dev->gc_block = 0;
+
+	/* If this block is currently the best candidate for gc then drop as a candidate */
+	if (block_no == dev->gc_dirtiest) {
+		dev->gc_dirtiest = 0;
+		dev->gc_pages_in_use = 0;
+	}
+
+	if (!bi->needs_retiring) {
+		yaffs2_checkpt_invalidate(dev);
+		erased_ok = yaffs_erase_block(dev, block_no);
+		if (!erased_ok) {
+			dev->n_erase_failures++;
+			T(YAFFS_TRACE_ERROR | YAFFS_TRACE_BAD_BLOCKS,
+			  (TSTR("**>> Erasure failed %d" TENDSTR), block_no));
+		}
+	}
+
+	if (erased_ok &&
+	    ((yaffs_trace_mask & YAFFS_TRACE_ERASE)
+	     || !yaffs_skip_verification(dev))) {
+		int i;
+		for (i = 0; i < dev->param.chunks_per_block; i++) {
+			if (!yaffs_check_chunk_erased
+			    (dev, block_no * dev->param.chunks_per_block + i)) {
+				T(YAFFS_TRACE_ERROR,
+				  (TSTR
+				   (">>Block %d erasure supposedly OK, but chunk %d not erased"
+				    TENDSTR), block_no, i));
+			}
+		}
+	}
+
+	if (erased_ok) {
+		/* Clean it up... */
+		bi->block_state = YAFFS_BLOCK_STATE_EMPTY;
+		bi->seq_number = 0;
+		dev->n_erased_blocks++;
+		bi->pages_in_use = 0;
+		bi->soft_del_pages = 0;
+		bi->has_shrink_hdr = 0;
+		bi->skip_erased_check = 1;	/* This is clean, so no need to check */
+		bi->gc_prioritise = 0;
+		yaffs_clear_chunk_bits(dev, block_no);
+
+		T(YAFFS_TRACE_ERASE,
+		  (TSTR("Erased block %d" TENDSTR), block_no));
+	} else {
+		dev->n_free_chunks -= dev->param.chunks_per_block;	/* We lost a block of free space */
+
+		yaffs_retire_block(dev, block_no);
+		T(YAFFS_TRACE_ERROR | YAFFS_TRACE_BAD_BLOCKS,
+		  (TSTR("**>> Block %d retired" TENDSTR), block_no));
+	}
+}
+
+static int yaffs_find_alloc_block(struct yaffs_dev *dev)
+{
+	int i;
+
+	struct yaffs_block_info *bi;
+
+	if (dev->n_erased_blocks < 1) {
+		/* Hoosterman we've got a problem.
+		 * Can't get space to gc
+		 */
+		T(YAFFS_TRACE_ERROR,
+		  (TSTR("yaffs tragedy: no more erased blocks" TENDSTR)));
+
+		return -1;
+	}
+
+	/* Find an empty block. */
+
+	for (i = dev->internal_start_block; i <= dev->internal_end_block; i++) {
+		dev->alloc_block_finder++;
+		if (dev->alloc_block_finder < dev->internal_start_block
+		    || dev->alloc_block_finder > dev->internal_end_block) {
+			dev->alloc_block_finder = dev->internal_start_block;
+		}
+
+		bi = yaffs_get_block_info(dev, dev->alloc_block_finder);
+
+		if (bi->block_state == YAFFS_BLOCK_STATE_EMPTY) {
+			bi->block_state = YAFFS_BLOCK_STATE_ALLOCATING;
+			dev->seq_number++;
+			bi->seq_number = dev->seq_number;
+			dev->n_erased_blocks--;
+			T(YAFFS_TRACE_ALLOCATE,
+			  (TSTR("Allocated block %d, seq  %d, %d left" TENDSTR),
+			   dev->alloc_block_finder, dev->seq_number,
+			   dev->n_erased_blocks));
+			return dev->alloc_block_finder;
+		}
+	}
+
+	T(YAFFS_TRACE_ALWAYS,
+	  (TSTR
+	   ("yaffs tragedy: no more erased blocks, but there should have been %d"
+	    TENDSTR), dev->n_erased_blocks));
+
+	return -1;
+}
+
+/*
+ * Check if there's space to allocate...
+ * Thinks.... do we need top make this ths same as yaffs_get_free_chunks()?
+ */
+int yaffs_check_alloc_available(struct yaffs_dev *dev, int n_chunks)
+{
+	int reserved_chunks;
+	int reserved_blocks = dev->param.n_reserved_blocks;
+	int checkpt_blocks;
+
+	checkpt_blocks = yaffs_calc_checkpt_blocks_required(dev);
+
+	reserved_chunks =
+	    ((reserved_blocks + checkpt_blocks) * dev->param.chunks_per_block);
+
+	return (dev->n_free_chunks > (reserved_chunks + n_chunks));
+}
+
+static int yaffs_alloc_chunk(struct yaffs_dev *dev, int use_reserver,
+			     struct yaffs_block_info **block_ptr)
+{
+	int ret_val;
+	struct yaffs_block_info *bi;
+
+	if (dev->alloc_block < 0) {
+		/* Get next block to allocate off */
+		dev->alloc_block = yaffs_find_alloc_block(dev);
+		dev->alloc_page = 0;
+	}
+
+	if (!use_reserver && !yaffs_check_alloc_available(dev, 1)) {
+		/* Not enough space to allocate unless we're allowed to use the reserve. */
+		return -1;
+	}
+
+	if (dev->n_erased_blocks < dev->param.n_reserved_blocks
+	    && dev->alloc_page == 0) {
+		T(YAFFS_TRACE_ALLOCATE, (TSTR("Allocating reserve" TENDSTR)));
+	}
+
+	/* Next page please.... */
+	if (dev->alloc_block >= 0) {
+		bi = yaffs_get_block_info(dev, dev->alloc_block);
+
+		ret_val = (dev->alloc_block * dev->param.chunks_per_block) +
+		    dev->alloc_page;
+		bi->pages_in_use++;
+		yaffs_set_chunk_bit(dev, dev->alloc_block, dev->alloc_page);
+
+		dev->alloc_page++;
+
+		dev->n_free_chunks--;
+
+		/* If the block is full set the state to full */
+		if (dev->alloc_page >= dev->param.chunks_per_block) {
+			bi->block_state = YAFFS_BLOCK_STATE_FULL;
+			dev->alloc_block = -1;
+		}
+
+		if (block_ptr)
+			*block_ptr = bi;
+
+		return ret_val;
+	}
+
+	T(YAFFS_TRACE_ERROR,
+	  (TSTR("!!!!!!!!! Allocator out !!!!!!!!!!!!!!!!!" TENDSTR)));
+
+	return -1;
+}
+
+static int yaffs_get_erased_chunks(struct yaffs_dev *dev)
+{
+	int n;
+
+	n = dev->n_erased_blocks * dev->param.chunks_per_block;
+
+	if (dev->alloc_block > 0)
+		n += (dev->param.chunks_per_block - dev->alloc_page);
+
+	return n;
+
+}
+
+/*
+ * yaffs_skip_rest_of_block() skips over the rest of the allocation block
+ * if we don't want to write to it.
+ */
+void yaffs_skip_rest_of_block(struct yaffs_dev *dev)
+{
+	if (dev->alloc_block > 0) {
+		struct yaffs_block_info *bi =
+		    yaffs_get_block_info(dev, dev->alloc_block);
+		if (bi->block_state == YAFFS_BLOCK_STATE_ALLOCATING) {
+			bi->block_state = YAFFS_BLOCK_STATE_FULL;
+			dev->alloc_block = -1;
+		}
+	}
+}
+
+static int yaffs_gc_block(struct yaffs_dev *dev, int block, int whole_block)
+{
+	int old_chunk;
+	int new_chunk;
+	int mark_flash;
+	int ret_val = YAFFS_OK;
+	int i;
+	int is_checkpt_block;
+	int matching_chunk;
+	int max_copies;
+
+	int chunks_before = yaffs_get_erased_chunks(dev);
+	int chunks_after;
+
+	struct yaffs_ext_tags tags;
+
+	struct yaffs_block_info *bi = yaffs_get_block_info(dev, block);
+
+	struct yaffs_obj *object;
+
+	is_checkpt_block = (bi->block_state == YAFFS_BLOCK_STATE_CHECKPOINT);
+
+	T(YAFFS_TRACE_TRACING,
+	  (TSTR
+	   ("Collecting block %d, in use %d, shrink %d, whole_block %d"
+	    TENDSTR), block, bi->pages_in_use, bi->has_shrink_hdr,
+	   whole_block));
+
+	/*yaffs_verify_free_chunks(dev); */
+
+	if (bi->block_state == YAFFS_BLOCK_STATE_FULL)
+		bi->block_state = YAFFS_BLOCK_STATE_COLLECTING;
+
+	bi->has_shrink_hdr = 0;	/* clear the flag so that the block can erase */
+
+	dev->gc_disable = 1;
+
+	if (is_checkpt_block || !yaffs_still_some_chunks(dev, block)) {
+		T(YAFFS_TRACE_TRACING,
+		  (TSTR
+		   ("Collecting block %d that has no chunks in use" TENDSTR),
+		   block));
+		yaffs_block_became_dirty(dev, block);
+	} else {
+
+		u8 *buffer = yaffs_get_temp_buffer(dev, __LINE__);
+
+		yaffs_verify_blk(dev, bi, block);
+
+		max_copies = (whole_block) ? dev->param.chunks_per_block : 5;
+		old_chunk = block * dev->param.chunks_per_block + dev->gc_chunk;
+
+		for ( /* init already done */ ;
+		     ret_val == YAFFS_OK &&
+		     dev->gc_chunk < dev->param.chunks_per_block &&
+		     (bi->block_state == YAFFS_BLOCK_STATE_COLLECTING) &&
+		     max_copies > 0; dev->gc_chunk++, old_chunk++) {
+			if (yaffs_check_chunk_bit(dev, block, dev->gc_chunk)) {
+
+				/* This page is in use and might need to be copied off */
+
+				max_copies--;
+
+				mark_flash = 1;
+
+				yaffs_init_tags(&tags);
+
+				yaffs_rd_chunk_tags_nand(dev, old_chunk,
+							 buffer, &tags);
+
+				object = yaffs_find_by_number(dev, tags.obj_id);
+
+				T(YAFFS_TRACE_GC_DETAIL,
+				  (TSTR
+				   ("Collecting chunk in block %d, %d %d %d "
+				    TENDSTR), dev->gc_chunk, tags.obj_id,
+				   tags.chunk_id, tags.n_bytes));
+
+				if (object && !yaffs_skip_verification(dev)) {
+					if (tags.chunk_id == 0)
+						matching_chunk =
+						    object->hdr_chunk;
+					else if (object->soft_del)
+						matching_chunk = old_chunk;	/* Defeat the test */
+					else
+						matching_chunk =
+						    yaffs_find_chunk_in_file
+						    (object, tags.chunk_id,
+						     NULL);
+
+					if (old_chunk != matching_chunk)
+						T(YAFFS_TRACE_ERROR,
+						  (TSTR
+						   ("gc: page in gc mismatch: %d %d %d %d"
+						    TENDSTR), old_chunk,
+						   matching_chunk, tags.obj_id,
+						   tags.chunk_id));
+
+				}
+
+				if (!object) {
+					T(YAFFS_TRACE_ERROR,
+					  (TSTR
+					   ("page %d in gc has no object: %d %d %d "
+					    TENDSTR), old_chunk,
+					   tags.obj_id, tags.chunk_id,
+					   tags.n_bytes));
+				}
+
+				if (object &&
+				    object->deleted &&
+				    object->soft_del && tags.chunk_id != 0) {
+					/* Data chunk in a soft deleted file, throw it away
+					 * It's a soft deleted data chunk,
+					 * No need to copy this, just forget about it and
+					 * fix up the object.
+					 */
+
+					/* Free chunks already includes softdeleted chunks.
+					 * How ever this chunk is going to soon be really deleted
+					 * which will increment free chunks.
+					 * We have to decrement free chunks so this works out properly.
+					 */
+					dev->n_free_chunks--;
+					bi->soft_del_pages--;
+
+					object->n_data_chunks--;
+
+					if (object->n_data_chunks <= 0) {
+						/* remeber to clean up the object */
+						dev->gc_cleanup_list[dev->
+								     n_clean_ups]
+						    = tags.obj_id;
+						dev->n_clean_ups++;
+					}
+					mark_flash = 0;
+				} else if (0) {
+					/* Todo object && object->deleted && object->n_data_chunks == 0 */
+					/* Deleted object header with no data chunks.
+					 * Can be discarded and the file deleted.
+					 */
+					object->hdr_chunk = 0;
+					yaffs_free_tnode(object->my_dev,
+							 object->
+							 variant.file_variant.
+							 top);
+					object->variant.file_variant.top = NULL;
+					yaffs_generic_obj_del(object);
+
+				} else if (object) {
+					/* It's either a data chunk in a live file or
+					 * an ObjectHeader, so we're interested in it.
+					 * NB Need to keep the ObjectHeaders of deleted files
+					 * until the whole file has been deleted off
+					 */
+					tags.serial_number++;
+
+					dev->n_gc_copies++;
+
+					if (tags.chunk_id == 0) {
+						/* It is an object Id,
+						 * We need to nuke the shrinkheader flags first
+						 * Also need to clean up shadowing.
+						 * We no longer want the shrink_header flag since its work is done
+						 * and if it is left in place it will mess up scanning.
+						 */
+
+						struct yaffs_obj_hdr *oh;
+						oh = (struct yaffs_obj_hdr *)
+						    buffer;
+
+						oh->is_shrink = 0;
+						tags.extra_is_shrink = 0;
+
+						oh->shadows_obj = 0;
+						oh->inband_shadowed_obj_id = 0;
+						tags.extra_shadows = 0;
+
+						/* Update file size */
+						if (object->variant_type ==
+						    YAFFS_OBJECT_TYPE_FILE) {
+							oh->file_size =
+							    object->variant.
+							    file_variant.
+							    file_size;
+							tags.extra_length =
+							    oh->file_size;
+						}
+
+						yaffs_verify_oh(object, oh,
+								&tags, 1);
+						new_chunk =
+						    yaffs_write_new_chunk(dev,
+									  (u8 *)
+									  oh,
+									  &tags,
+									  1);
+					} else {
+						new_chunk =
+						    yaffs_write_new_chunk(dev,
+									  buffer,
+									  &tags,
+									  1);
+                                        }
+
+					if (new_chunk < 0) {
+						ret_val = YAFFS_FAIL;
+					} else {
+
+						/* Ok, now fix up the Tnodes etc. */
+
+						if (tags.chunk_id == 0) {
+							/* It's a header */
+							object->hdr_chunk =
+							    new_chunk;
+							object->serial =
+							    tags.serial_number;
+						} else {
+							/* It's a data chunk */
+							int ok;
+							ok = yaffs_put_chunk_in_file(object, tags.chunk_id, new_chunk, 0);
+						}
+					}
+				}
+
+				if (ret_val == YAFFS_OK)
+					yaffs_chunk_del(dev, old_chunk,
+							mark_flash, __LINE__);
+
+			}
+		}
+
+		yaffs_release_temp_buffer(dev, buffer, __LINE__);
+
+	}
+
+	yaffs_verify_collected_blk(dev, bi, block);
+
+	if (bi->block_state == YAFFS_BLOCK_STATE_COLLECTING) {
+		/*
+		 * The gc did not complete. Set block state back to FULL
+		 * because checkpointing does not restore gc.
+		 */
+		bi->block_state = YAFFS_BLOCK_STATE_FULL;
+	} else {
+		/* The gc completed. */
+		/* Do any required cleanups */
+		for (i = 0; i < dev->n_clean_ups; i++) {
+			/* Time to delete the file too */
+			object =
+			    yaffs_find_by_number(dev, dev->gc_cleanup_list[i]);
+			if (object) {
+				yaffs_free_tnode(dev,
+						 object->variant.
+						 file_variant.top);
+				object->variant.file_variant.top = NULL;
+				T(YAFFS_TRACE_GC,
+				  (TSTR
+				   ("yaffs: About to finally delete object %d"
+				    TENDSTR), object->obj_id));
+				yaffs_generic_obj_del(object);
+				object->my_dev->n_deleted_files--;
+			}
+
+		}
+
+		chunks_after = yaffs_get_erased_chunks(dev);
+		if (chunks_before >= chunks_after) {
+			T(YAFFS_TRACE_GC,
+			  (TSTR
+			   ("gc did not increase free chunks before %d after %d"
+			    TENDSTR), chunks_before, chunks_after));
+		}
+		dev->gc_block = 0;
+		dev->gc_chunk = 0;
+		dev->n_clean_ups = 0;
+	}
+
+	dev->gc_disable = 0;
+
+	return ret_val;
+}
+
+/*
+ * FindBlockForgarbageCollection is used to select the dirtiest block (or close enough)
+ * for garbage collection.
+ */
+
+static unsigned yaffs_find_gc_block(struct yaffs_dev *dev,
+				    int aggressive, int background)
+{
+	int i;
+	int iterations;
+	unsigned selected = 0;
+	int prioritised = 0;
+	int prioritised_exist = 0;
+	struct yaffs_block_info *bi;
+	int threshold;
+
+	/* First let's see if we need to grab a prioritised block */
+	if (dev->has_pending_prioritised_gc && !aggressive) {
+		dev->gc_dirtiest = 0;
+		bi = dev->block_info;
+		for (i = dev->internal_start_block;
+		     i <= dev->internal_end_block && !selected; i++) {
+
+			if (bi->gc_prioritise) {
+				prioritised_exist = 1;
+				if (bi->block_state == YAFFS_BLOCK_STATE_FULL &&
+				    yaffs_block_ok_for_gc(dev, bi)) {
+					selected = i;
+					prioritised = 1;
+				}
+			}
+			bi++;
+		}
+
+		/*
+		 * If there is a prioritised block and none was selected then
+		 * this happened because there is at least one old dirty block gumming
+		 * up the works. Let's gc the oldest dirty block.
+		 */
+
+		if (prioritised_exist &&
+		    !selected && dev->oldest_dirty_block > 0)
+			selected = dev->oldest_dirty_block;
+
+		if (!prioritised_exist)	/* None found, so we can clear this */
+			dev->has_pending_prioritised_gc = 0;
+	}
+
+	/* If we're doing aggressive GC then we are happy to take a less-dirty block, and
+	 * search harder.
+	 * else (we're doing a leasurely gc), then we only bother to do this if the
+	 * block has only a few pages in use.
+	 */
+
+	if (!selected) {
+		int pages_used;
+		int n_blocks =
+		    dev->internal_end_block - dev->internal_start_block + 1;
+		if (aggressive) {
+			threshold = dev->param.chunks_per_block;
+			iterations = n_blocks;
+		} else {
+			int max_threshold;
+
+			if (background)
+				max_threshold = dev->param.chunks_per_block / 2;
+			else
+				max_threshold = dev->param.chunks_per_block / 8;
+
+			if (max_threshold < YAFFS_GC_PASSIVE_THRESHOLD)
+				max_threshold = YAFFS_GC_PASSIVE_THRESHOLD;
+
+			threshold = background ? (dev->gc_not_done + 2) * 2 : 0;
+			if (threshold < YAFFS_GC_PASSIVE_THRESHOLD)
+				threshold = YAFFS_GC_PASSIVE_THRESHOLD;
+			if (threshold > max_threshold)
+				threshold = max_threshold;
+
+			iterations = n_blocks / 16 + 1;
+			if (iterations > 100)
+				iterations = 100;
+		}
+
+		for (i = 0;
+		     i < iterations &&
+		     (dev->gc_dirtiest < 1 ||
+		      dev->gc_pages_in_use > YAFFS_GC_GOOD_ENOUGH); i++) {
+			dev->gc_block_finder++;
+			if (dev->gc_block_finder < dev->internal_start_block ||
+			    dev->gc_block_finder > dev->internal_end_block)
+				dev->gc_block_finder =
+				    dev->internal_start_block;
+
+			bi = yaffs_get_block_info(dev, dev->gc_block_finder);
+
+			pages_used = bi->pages_in_use - bi->soft_del_pages;
+
+			if (bi->block_state == YAFFS_BLOCK_STATE_FULL &&
+			    pages_used < dev->param.chunks_per_block &&
+			    (dev->gc_dirtiest < 1
+			     || pages_used < dev->gc_pages_in_use)
+			    && yaffs_block_ok_for_gc(dev, bi)) {
+				dev->gc_dirtiest = dev->gc_block_finder;
+				dev->gc_pages_in_use = pages_used;
+			}
+		}
+
+		if (dev->gc_dirtiest > 0 && dev->gc_pages_in_use <= threshold)
+			selected = dev->gc_dirtiest;
+	}
+
+	/*
+	 * If nothing has been selected for a while, try selecting the oldest dirty
+	 * because that's gumming up the works.
+	 */
+
+	if (!selected && dev->param.is_yaffs2 &&
+	    dev->gc_not_done >= (background ? 10 : 20)) {
+		yaffs2_find_oldest_dirty_seq(dev);
+		if (dev->oldest_dirty_block > 0) {
+			selected = dev->oldest_dirty_block;
+			dev->gc_dirtiest = selected;
+			dev->oldest_dirty_gc_count++;
+			bi = yaffs_get_block_info(dev, selected);
+			dev->gc_pages_in_use =
+			    bi->pages_in_use - bi->soft_del_pages;
+		} else {
+			dev->gc_not_done = 0;
+                }
+	}
+
+	if (selected) {
+		T(YAFFS_TRACE_GC,
+		  (TSTR
+		   ("GC Selected block %d with %d free, prioritised:%d"
+		    TENDSTR), selected,
+		   dev->param.chunks_per_block - dev->gc_pages_in_use,
+		   prioritised));
+
+		dev->n_gc_blocks++;
+		if (background)
+			dev->bg_gcs++;
+
+		dev->gc_dirtiest = 0;
+		dev->gc_pages_in_use = 0;
+		dev->gc_not_done = 0;
+		if (dev->refresh_skip > 0)
+			dev->refresh_skip--;
+	} else {
+		dev->gc_not_done++;
+		T(YAFFS_TRACE_GC,
+		  (TSTR
+		   ("GC none: finder %d skip %d threshold %d dirtiest %d using %d oldest %d%s"
+		    TENDSTR), dev->gc_block_finder, dev->gc_not_done, threshold,
+		   dev->gc_dirtiest, dev->gc_pages_in_use,
+		   dev->oldest_dirty_block, background ? " bg" : ""));
+	}
+
+	return selected;
+}
+
+/* New garbage collector
+ * If we're very low on erased blocks then we do aggressive garbage collection
+ * otherwise we do "leasurely" garbage collection.
+ * Aggressive gc looks further (whole array) and will accept less dirty blocks.
+ * Passive gc only inspects smaller areas and will only accept more dirty blocks.
+ *
+ * The idea is to help clear out space in a more spread-out manner.
+ * Dunno if it really does anything useful.
+ */
+static int yaffs_check_gc(struct yaffs_dev *dev, int background)
+{
+	int aggressive = 0;
+	int gc_ok = YAFFS_OK;
+	int max_tries = 0;
+	int min_erased;
+	int erased_chunks;
+	int checkpt_block_adjust;
+
+	if (dev->param.gc_control && (dev->param.gc_control(dev) & 1) == 0)
+		return YAFFS_OK;
+
+	if (dev->gc_disable) {
+		/* Bail out so we don't get recursive gc */
+		return YAFFS_OK;
+	}
+
+	/* This loop should pass the first time.
+	 * We'll only see looping here if the collection does not increase space.
+	 */
+
+	do {
+		max_tries++;
+
+		checkpt_block_adjust = yaffs_calc_checkpt_blocks_required(dev);
+
+		min_erased =
+		    dev->param.n_reserved_blocks + checkpt_block_adjust + 1;
+		erased_chunks =
+		    dev->n_erased_blocks * dev->param.chunks_per_block;
+
+		/* If we need a block soon then do aggressive gc. */
+		if (dev->n_erased_blocks < min_erased)
+			aggressive = 1;
+		else {
+			if (!background
+			    && erased_chunks > (dev->n_free_chunks / 4))
+				break;
+
+			if (dev->gc_skip > 20)
+				dev->gc_skip = 20;
+			if (erased_chunks < dev->n_free_chunks / 2 ||
+			    dev->gc_skip < 1 || background)
+				aggressive = 0;
+			else {
+				dev->gc_skip--;
+				break;
+			}
+		}
+
+		dev->gc_skip = 5;
+
+		/* If we don't already have a block being gc'd then see if we should start another */
+
+		if (dev->gc_block < 1 && !aggressive) {
+			dev->gc_block = yaffs2_find_refresh_block(dev);
+			dev->gc_chunk = 0;
+			dev->n_clean_ups = 0;
+		}
+		if (dev->gc_block < 1) {
+			dev->gc_block =
+			    yaffs_find_gc_block(dev, aggressive, background);
+			dev->gc_chunk = 0;
+			dev->n_clean_ups = 0;
+		}
+
+		if (dev->gc_block > 0) {
+			dev->all_gcs++;
+			if (!aggressive)
+				dev->passive_gc_count++;
+
+			T(YAFFS_TRACE_GC,
+			  (TSTR
+			   ("yaffs: GC n_erased_blocks %d aggressive %d"
+			    TENDSTR), dev->n_erased_blocks, aggressive));
+
+			gc_ok = yaffs_gc_block(dev, dev->gc_block, aggressive);
+		}
+
+		if (dev->n_erased_blocks < (dev->param.n_reserved_blocks)
+		    && dev->gc_block > 0) {
+			T(YAFFS_TRACE_GC,
+			  (TSTR
+			   ("yaffs: GC !!!no reclaim!!! n_erased_blocks %d after try %d block %d"
+			    TENDSTR), dev->n_erased_blocks, max_tries,
+			   dev->gc_block));
+		}
+	} while ((dev->n_erased_blocks < dev->param.n_reserved_blocks) &&
+		 (dev->gc_block > 0) && (max_tries < 2));
+
+	return aggressive ? gc_ok : YAFFS_OK;
+}
+
+/*
+ * yaffs_bg_gc()
+ * Garbage collects. Intended to be called from a background thread.
+ * Returns non-zero if at least half the free chunks are erased.
+ */
+int yaffs_bg_gc(struct yaffs_dev *dev, unsigned urgency)
+{
+	int erased_chunks = dev->n_erased_blocks * dev->param.chunks_per_block;
+
+	T(YAFFS_TRACE_BACKGROUND, (TSTR("Background gc %u" TENDSTR), urgency));
+
+	yaffs_check_gc(dev, 1);
+	return erased_chunks > dev->n_free_chunks / 2;
+}
+
+/*-------------------------  TAGS --------------------------------*/
+
+static int yaffs_tags_match(const struct yaffs_ext_tags *tags, int obj_id,
+			    int chunk_obj)
+{
+	return (tags->chunk_id == chunk_obj &&
+		tags->obj_id == obj_id && !tags->is_deleted) ? 1 : 0;
+
+}
+
+/*-------------------- Data file manipulation -----------------*/
+
+static int yaffs_find_chunk_in_file(struct yaffs_obj *in, int inode_chunk,
+				    struct yaffs_ext_tags *tags)
+{
+	/*Get the Tnode, then get the level 0 offset chunk offset */
+	struct yaffs_tnode *tn;
+	int the_chunk = -1;
+	struct yaffs_ext_tags local_tags;
+	int ret_val = -1;
+
+	struct yaffs_dev *dev = in->my_dev;
+
+	if (!tags) {
+		/* Passed a NULL, so use our own tags space */
+		tags = &local_tags;
+	}
+
+	tn = yaffs_find_tnode_0(dev, &in->variant.file_variant, inode_chunk);
+
+	if (tn) {
+		the_chunk = yaffs_get_group_base(dev, tn, inode_chunk);
+
+		ret_val =
+		    yaffs_find_chunk_in_group(dev, the_chunk, tags, in->obj_id,
+					      inode_chunk);
+	}
+	return ret_val;
+}
+
+static int yaffs_find_del_file_chunk(struct yaffs_obj *in, int inode_chunk,
+				     struct yaffs_ext_tags *tags)
+{
+	/* Get the Tnode, then get the level 0 offset chunk offset */
+	struct yaffs_tnode *tn;
+	int the_chunk = -1;
+	struct yaffs_ext_tags local_tags;
+
+	struct yaffs_dev *dev = in->my_dev;
+	int ret_val = -1;
+
+	if (!tags) {
+		/* Passed a NULL, so use our own tags space */
+		tags = &local_tags;
+	}
+
+	tn = yaffs_find_tnode_0(dev, &in->variant.file_variant, inode_chunk);
+
+	if (tn) {
+
+		the_chunk = yaffs_get_group_base(dev, tn, inode_chunk);
+
+		ret_val =
+		    yaffs_find_chunk_in_group(dev, the_chunk, tags, in->obj_id,
+					      inode_chunk);
+
+		/* Delete the entry in the filestructure (if found) */
+		if (ret_val != -1)
+			yaffs_load_tnode_0(dev, tn, inode_chunk, 0);
+	}
+
+	return ret_val;
+}
+
+int yaffs_put_chunk_in_file(struct yaffs_obj *in, int inode_chunk,
+			    int nand_chunk, int in_scan)
+{
+	/* NB in_scan is zero unless scanning.
+	 * For forward scanning, in_scan is > 0;
+	 * for backward scanning in_scan is < 0
+	 *
+	 * nand_chunk = 0 is a dummy insert to make sure the tnodes are there.
+	 */
+
+	struct yaffs_tnode *tn;
+	struct yaffs_dev *dev = in->my_dev;
+	int existing_cunk;
+	struct yaffs_ext_tags existing_tags;
+	struct yaffs_ext_tags new_tags;
+	unsigned existing_serial, new_serial;
+
+	if (in->variant_type != YAFFS_OBJECT_TYPE_FILE) {
+		/* Just ignore an attempt at putting a chunk into a non-file during scanning
+		 * If it is not during Scanning then something went wrong!
+		 */
+		if (!in_scan) {
+			T(YAFFS_TRACE_ERROR,
+			  (TSTR
+			   ("yaffs tragedy:attempt to put data chunk into a non-file"
+			    TENDSTR)));
+			YBUG();
+		}
+
+		yaffs_chunk_del(dev, nand_chunk, 1, __LINE__);
+		return YAFFS_OK;
+	}
+
+	tn = yaffs_add_find_tnode_0(dev,
+				    &in->variant.file_variant,
+				    inode_chunk, NULL);
+	if (!tn)
+		return YAFFS_FAIL;
+
+	if (!nand_chunk)
+		/* Dummy insert, bail now */
+		return YAFFS_OK;
+
+	existing_cunk = yaffs_get_group_base(dev, tn, inode_chunk);
+
+	if (in_scan != 0) {
+		/* If we're scanning then we need to test for duplicates
+		 * NB This does not need to be efficient since it should only ever
+		 * happen when the power fails during a write, then only one
+		 * chunk should ever be affected.
+		 *
+		 * Correction for YAFFS2: This could happen quite a lot and we need to think about efficiency! TODO
+		 * Update: For backward scanning we don't need to re-read tags so this is quite cheap.
+		 */
+
+		if (existing_cunk > 0) {
+			/* NB Right now existing chunk will not be real chunk_id if the chunk group size > 1
+			 *    thus we have to do a FindChunkInFile to get the real chunk id.
+			 *
+			 * We have a duplicate now we need to decide which one to use:
+			 *
+			 * Backwards scanning YAFFS2: The old one is what we use, dump the new one.
+			 * Forward scanning YAFFS2: The new one is what we use, dump the old one.
+			 * YAFFS1: Get both sets of tags and compare serial numbers.
+			 */
+
+			if (in_scan > 0) {
+				/* Only do this for forward scanning */
+				yaffs_rd_chunk_tags_nand(dev,
+							 nand_chunk,
+							 NULL, &new_tags);
+
+				/* Do a proper find */
+				existing_cunk =
+				    yaffs_find_chunk_in_file(in, inode_chunk,
+							     &existing_tags);
+			}
+
+			if (existing_cunk <= 0) {
+				/*Hoosterman - how did this happen? */
+
+				T(YAFFS_TRACE_ERROR,
+				  (TSTR
+				   ("yaffs tragedy: existing chunk < 0 in scan"
+				    TENDSTR)));
+
+			}
+
+			/* NB The deleted flags should be false, otherwise the chunks will
+			 * not be loaded during a scan
+			 */
+
+			if (in_scan > 0) {
+				new_serial = new_tags.serial_number;
+				existing_serial = existing_tags.serial_number;
+			}
+
+			if ((in_scan > 0) &&
+			    (existing_cunk <= 0 ||
+			     ((existing_serial + 1) & 3) == new_serial)) {
+				/* Forward scanning.
+				 * Use new
+				 * Delete the old one and drop through to update the tnode
+				 */
+				yaffs_chunk_del(dev, existing_cunk, 1,
+						__LINE__);
+			} else {
+				/* Backward scanning or we want to use the existing one
+				 * Use existing.
+				 * Delete the new one and return early so that the tnode isn't changed
+				 */
+				yaffs_chunk_del(dev, nand_chunk, 1, __LINE__);
+				return YAFFS_OK;
+			}
+		}
+
+	}
+
+	if (existing_cunk == 0)
+		in->n_data_chunks++;
+
+	yaffs_load_tnode_0(dev, tn, inode_chunk, nand_chunk);
+
+	return YAFFS_OK;
+}
+
+static int yaffs_rd_data_obj(struct yaffs_obj *in, int inode_chunk, u8 * buffer)
+{
+	int nand_chunk = yaffs_find_chunk_in_file(in, inode_chunk, NULL);
+
+	if (nand_chunk >= 0)
+		return yaffs_rd_chunk_tags_nand(in->my_dev, nand_chunk,
+						buffer, NULL);
+	else {
+		T(YAFFS_TRACE_NANDACCESS,
+		  (TSTR("Chunk %d not found zero instead" TENDSTR),
+		   nand_chunk));
+		/* get sane (zero) data if you read a hole */
+		memset(buffer, 0, in->my_dev->data_bytes_per_chunk);
+		return 0;
+	}
+
+}
+
+void yaffs_chunk_del(struct yaffs_dev *dev, int chunk_id, int mark_flash,
+		     int lyn)
+{
+	int block;
+	int page;
+	struct yaffs_ext_tags tags;
+	struct yaffs_block_info *bi;
+
+	if (chunk_id <= 0)
+		return;
+
+	dev->n_deletions++;
+	block = chunk_id / dev->param.chunks_per_block;
+	page = chunk_id % dev->param.chunks_per_block;
+
+	if (!yaffs_check_chunk_bit(dev, block, page))
+		T(YAFFS_TRACE_VERIFY,
+		  (TSTR("Deleting invalid chunk %d" TENDSTR), chunk_id));
+
+	bi = yaffs_get_block_info(dev, block);
+
+	yaffs2_update_oldest_dirty_seq(dev, block, bi);
+
+	T(YAFFS_TRACE_DELETION,
+	  (TSTR("line %d delete of chunk %d" TENDSTR), lyn, chunk_id));
+
+	if (!dev->param.is_yaffs2 && mark_flash &&
+	    bi->block_state != YAFFS_BLOCK_STATE_COLLECTING) {
+
+		yaffs_init_tags(&tags);
+
+		tags.is_deleted = 1;
+
+		yaffs_wr_chunk_tags_nand(dev, chunk_id, NULL, &tags);
+		yaffs_handle_chunk_update(dev, chunk_id, &tags);
+	} else {
+		dev->n_unmarked_deletions++;
+	}
+
+	/* Pull out of the management area.
+	 * If the whole block became dirty, this will kick off an erasure.
+	 */
+	if (bi->block_state == YAFFS_BLOCK_STATE_ALLOCATING ||
+	    bi->block_state == YAFFS_BLOCK_STATE_FULL ||
+	    bi->block_state == YAFFS_BLOCK_STATE_NEEDS_SCANNING ||
+	    bi->block_state == YAFFS_BLOCK_STATE_COLLECTING) {
+		dev->n_free_chunks++;
+
+		yaffs_clear_chunk_bit(dev, block, page);
+
+		bi->pages_in_use--;
+
+		if (bi->pages_in_use == 0 &&
+		    !bi->has_shrink_hdr &&
+		    bi->block_state != YAFFS_BLOCK_STATE_ALLOCATING &&
+		    bi->block_state != YAFFS_BLOCK_STATE_NEEDS_SCANNING) {
+			yaffs_block_became_dirty(dev, block);
+		}
+
+	}
+
+}
+
+static int yaffs_wr_data_obj(struct yaffs_obj *in, int inode_chunk,
+			     const u8 * buffer, int n_bytes, int use_reserve)
+{
+	/* Find old chunk Need to do this to get serial number
+	 * Write new one and patch into tree.
+	 * Invalidate old tags.
+	 */
+
+	int prev_chunk_id;
+	struct yaffs_ext_tags prev_tags;
+
+	int new_chunk_id;
+	struct yaffs_ext_tags new_tags;
+
+	struct yaffs_dev *dev = in->my_dev;
+
+	yaffs_check_gc(dev, 0);
+
+	/* Get the previous chunk at this location in the file if it exists.
+	 * If it does not exist then put a zero into the tree. This creates
+	 * the tnode now, rather than later when it is harder to clean up.
+	 */
+	prev_chunk_id = yaffs_find_chunk_in_file(in, inode_chunk, &prev_tags);
+	if (prev_chunk_id < 1 &&
+	    !yaffs_put_chunk_in_file(in, inode_chunk, 0, 0))
+		return 0;
+
+	/* Set up new tags */
+	yaffs_init_tags(&new_tags);
+
+	new_tags.chunk_id = inode_chunk;
+	new_tags.obj_id = in->obj_id;
+	new_tags.serial_number =
+	    (prev_chunk_id > 0) ? prev_tags.serial_number + 1 : 1;
+	new_tags.n_bytes = n_bytes;
+
+	if (n_bytes < 1 || n_bytes > dev->param.total_bytes_per_chunk) {
+		T(YAFFS_TRACE_ERROR,
+		  (TSTR("Writing %d bytes to chunk!!!!!!!!!" TENDSTR),
+		   n_bytes));
+		YBUG();
+	}
+
+	new_chunk_id =
+	    yaffs_write_new_chunk(dev, buffer, &new_tags, use_reserve);
+
+	if (new_chunk_id > 0) {
+		yaffs_put_chunk_in_file(in, inode_chunk, new_chunk_id, 0);
+
+		if (prev_chunk_id > 0)
+			yaffs_chunk_del(dev, prev_chunk_id, 1, __LINE__);
+
+		yaffs_verify_file_sane(in);
+	}
+	return new_chunk_id;
+
+}
+
+/* UpdateObjectHeader updates the header on NAND for an object.
+ * If name is not NULL, then that new name is used.
+ */
+int yaffs_update_oh(struct yaffs_obj *in, const YCHAR * name, int force,
+		    int is_shrink, int shadows, struct yaffs_xattr_mod *xmod)
+{
+
+	struct yaffs_block_info *bi;
+
+	struct yaffs_dev *dev = in->my_dev;
+
+	int prev_chunk_id;
+	int ret_val = 0;
+	int result = 0;
+
+	int new_chunk_id;
+	struct yaffs_ext_tags new_tags;
+	struct yaffs_ext_tags old_tags;
+	const YCHAR *alias = NULL;
+
+	u8 *buffer = NULL;
+	YCHAR old_name[YAFFS_MAX_NAME_LENGTH + 1];
+
+	struct yaffs_obj_hdr *oh = NULL;
+
+	yaffs_strcpy(old_name, _Y("silly old name"));
+
+	if (!in->fake || in == dev->root_dir ||	/* The root_dir should also be saved */
+	    force || xmod) {
+
+		yaffs_check_gc(dev, 0);
+		yaffs_check_obj_details_loaded(in);
+
+		buffer = yaffs_get_temp_buffer(in->my_dev, __LINE__);
+		oh = (struct yaffs_obj_hdr *)buffer;
+
+		prev_chunk_id = in->hdr_chunk;
+
+		if (prev_chunk_id > 0) {
+			result = yaffs_rd_chunk_tags_nand(dev, prev_chunk_id,
+							  buffer, &old_tags);
+
+			yaffs_verify_oh(in, oh, &old_tags, 0);
+
+			memcpy(old_name, oh->name, sizeof(oh->name));
+			memset(buffer, 0xFF, sizeof(struct yaffs_obj_hdr));
+		} else {
+			memset(buffer, 0xFF, dev->data_bytes_per_chunk);
+                }
+
+		oh->type = in->variant_type;
+		oh->yst_mode = in->yst_mode;
+		oh->shadows_obj = oh->inband_shadowed_obj_id = shadows;
+
+		yaffs_load_attribs_oh(oh, in);
+
+		if (in->parent)
+			oh->parent_obj_id = in->parent->obj_id;
+		else
+			oh->parent_obj_id = 0;
+
+		if (name && *name) {
+			memset(oh->name, 0, sizeof(oh->name));
+			yaffs_load_oh_from_name(dev, oh->name, name);
+		} else if (prev_chunk_id > 0) {
+			memcpy(oh->name, old_name, sizeof(oh->name));
+		} else {
+			memset(oh->name, 0, sizeof(oh->name));
+                }
+
+		oh->is_shrink = is_shrink;
+
+		switch (in->variant_type) {
+		case YAFFS_OBJECT_TYPE_UNKNOWN:
+			/* Should not happen */
+			break;
+		case YAFFS_OBJECT_TYPE_FILE:
+			oh->file_size =
+			    (oh->parent_obj_id == YAFFS_OBJECTID_DELETED
+			     || oh->parent_obj_id ==
+			     YAFFS_OBJECTID_UNLINKED) ? 0 : in->
+			    variant.file_variant.file_size;
+			break;
+		case YAFFS_OBJECT_TYPE_HARDLINK:
+			oh->equiv_id = in->variant.hardlink_variant.equiv_id;
+			break;
+		case YAFFS_OBJECT_TYPE_SPECIAL:
+			/* Do nothing */
+			break;
+		case YAFFS_OBJECT_TYPE_DIRECTORY:
+			/* Do nothing */
+			break;
+		case YAFFS_OBJECT_TYPE_SYMLINK:
+			alias = in->variant.symlink_variant.alias;
+			if (!alias)
+				alias = _Y("no alias");
+			yaffs_strncpy(oh->alias, alias, YAFFS_MAX_ALIAS_LENGTH);
+			oh->alias[YAFFS_MAX_ALIAS_LENGTH] = 0;
+			break;
+		}
+
+		/* process any xattrib modifications */
+		if (xmod)
+			yaffs_apply_xattrib_mod(in, (char *)buffer, xmod);
+
+		/* Tags */
+		yaffs_init_tags(&new_tags);
+		in->serial++;
+		new_tags.chunk_id = 0;
+		new_tags.obj_id = in->obj_id;
+		new_tags.serial_number = in->serial;
+
+		/* Add extra info for file header */
+
+		new_tags.extra_available = 1;
+		new_tags.extra_parent_id = oh->parent_obj_id;
+		new_tags.extra_length = oh->file_size;
+		new_tags.extra_is_shrink = oh->is_shrink;
+		new_tags.extra_equiv_id = oh->equiv_id;
+		new_tags.extra_shadows = (oh->shadows_obj > 0) ? 1 : 0;
+		new_tags.extra_obj_type = in->variant_type;
+
+		yaffs_verify_oh(in, oh, &new_tags, 1);
+
+		/* Create new chunk in NAND */
+		new_chunk_id =
+		    yaffs_write_new_chunk(dev, buffer, &new_tags,
+					  (prev_chunk_id > 0) ? 1 : 0);
+
+		if (new_chunk_id >= 0) {
+
+			in->hdr_chunk = new_chunk_id;
+
+			if (prev_chunk_id > 0) {
+				yaffs_chunk_del(dev, prev_chunk_id, 1,
+						__LINE__);
+			}
+
+			if (!yaffs_obj_cache_dirty(in))
+				in->dirty = 0;
+
+			/* If this was a shrink, then mark the block that the chunk lives on */
+			if (is_shrink) {
+				bi = yaffs_get_block_info(in->my_dev,
+							  new_chunk_id /
+							  in->my_dev->param.
+							  chunks_per_block);
+				bi->has_shrink_hdr = 1;
+			}
+
+		}
+
+		ret_val = new_chunk_id;
+
+	}
+
+	if (buffer)
+		yaffs_release_temp_buffer(dev, buffer, __LINE__);
+
+	return ret_val;
+}
+
+/*------------------------ Short Operations Cache ----------------------------------------
+ *   In many situations where there is no high level buffering  a lot of
+ *   reads might be short sequential reads, and a lot of writes may be short
+ *   sequential writes. eg. scanning/writing a jpeg file.
+ *   In these cases, a short read/write cache can provide a huge perfomance
+ *   benefit with dumb-as-a-rock code.
+ *   In Linux, the page cache provides read buffering and the short op cache 
+ *   provides write buffering.
+ *
+ *   There are a limited number (~10) of cache chunks per device so that we don't
+ *   need a very intelligent search.
+ */
+
+static int yaffs_obj_cache_dirty(struct yaffs_obj *obj)
+{
+	struct yaffs_dev *dev = obj->my_dev;
+	int i;
+	struct yaffs_cache *cache;
+	int n_caches = obj->my_dev->param.n_caches;
+
+	for (i = 0; i < n_caches; i++) {
+		cache = &dev->cache[i];
+		if (cache->object == obj && cache->dirty)
+			return 1;
+	}
+
+	return 0;
+}
+
+static void yaffs_flush_file_cache(struct yaffs_obj *obj)
+{
+	struct yaffs_dev *dev = obj->my_dev;
+	int lowest = -99;	/* Stop compiler whining. */
+	int i;
+	struct yaffs_cache *cache;
+	int chunk_written = 0;
+	int n_caches = obj->my_dev->param.n_caches;
+
+	if (n_caches > 0) {
+		do {
+			cache = NULL;
+
+			/* Find the dirty cache for this object with the lowest chunk id. */
+			for (i = 0; i < n_caches; i++) {
+				if (dev->cache[i].object == obj &&
+				    dev->cache[i].dirty) {
+					if (!cache
+					    || dev->cache[i].chunk_id <
+					    lowest) {
+						cache = &dev->cache[i];
+						lowest = cache->chunk_id;
+					}
+				}
+			}
+
+			if (cache && !cache->locked) {
+				/* Write it out and free it up */
+
+				chunk_written =
+				    yaffs_wr_data_obj(cache->object,
+						      cache->chunk_id,
+						      cache->data,
+						      cache->n_bytes, 1);
+				cache->dirty = 0;
+				cache->object = NULL;
+			}
+
+		} while (cache && chunk_written > 0);
+
+		if (cache) {
+			/* Hoosterman, disk full while writing cache out. */
+			T(YAFFS_TRACE_ERROR,
+			  (TSTR
+			   ("yaffs tragedy: no space during cache write"
+			    TENDSTR)));
+
+		}
+	}
+
+}
+
+/*yaffs_flush_whole_cache(dev)
+ *
+ *
+ */
+
+void yaffs_flush_whole_cache(struct yaffs_dev *dev)
+{
+	struct yaffs_obj *obj;
+	int n_caches = dev->param.n_caches;
+	int i;
+
+	/* Find a dirty object in the cache and flush it...
+	 * until there are no further dirty objects.
+	 */
+	do {
+		obj = NULL;
+		for (i = 0; i < n_caches && !obj; i++) {
+			if (dev->cache[i].object && dev->cache[i].dirty)
+				obj = dev->cache[i].object;
+
+		}
+		if (obj)
+			yaffs_flush_file_cache(obj);
+
+	} while (obj);
+
+}
+
+/* Grab us a cache chunk for use.
+ * First look for an empty one.
+ * Then look for the least recently used non-dirty one.
+ * Then look for the least recently used dirty one...., flush and look again.
+ */
+static struct yaffs_cache *yaffs_grab_chunk_worker(struct yaffs_dev *dev)
+{
+	int i;
+
+	if (dev->param.n_caches > 0) {
+		for (i = 0; i < dev->param.n_caches; i++) {
+			if (!dev->cache[i].object)
+				return &dev->cache[i];
+		}
+	}
+
+	return NULL;
+}
+
+static struct yaffs_cache *yaffs_grab_chunk_cache(struct yaffs_dev *dev)
+{
+	struct yaffs_cache *cache;
+	struct yaffs_obj *the_obj;
+	int usage;
+	int i;
+	int pushout;
+
+	if (dev->param.n_caches > 0) {
+		/* Try find a non-dirty one... */
+
+		cache = yaffs_grab_chunk_worker(dev);
+
+		if (!cache) {
+			/* They were all dirty, find the last recently used object and flush
+			 * its cache, then  find again.
+			 * NB what's here is not very accurate, we actually flush the object
+			 * the last recently used page.
+			 */
+
+			/* With locking we can't assume we can use entry zero */
+
+			the_obj = NULL;
+			usage = -1;
+			cache = NULL;
+			pushout = -1;
+
+			for (i = 0; i < dev->param.n_caches; i++) {
+				if (dev->cache[i].object &&
+				    !dev->cache[i].locked &&
+				    (dev->cache[i].last_use < usage
+				     || !cache)) {
+					usage = dev->cache[i].last_use;
+					the_obj = dev->cache[i].object;
+					cache = &dev->cache[i];
+					pushout = i;
+				}
+			}
+
+			if (!cache || cache->dirty) {
+				/* Flush and try again */
+				yaffs_flush_file_cache(the_obj);
+				cache = yaffs_grab_chunk_worker(dev);
+			}
+
+		}
+		return cache;
+	} else {
+		return NULL;
+        }
+}
+
+/* Find a cached chunk */
+static struct yaffs_cache *yaffs_find_chunk_cache(const struct yaffs_obj *obj,
+						  int chunk_id)
+{
+	struct yaffs_dev *dev = obj->my_dev;
+	int i;
+	if (dev->param.n_caches > 0) {
+		for (i = 0; i < dev->param.n_caches; i++) {
+			if (dev->cache[i].object == obj &&
+			    dev->cache[i].chunk_id == chunk_id) {
+				dev->cache_hits++;
+
+				return &dev->cache[i];
+			}
+		}
+	}
+	return NULL;
+}
+
+/* Mark the chunk for the least recently used algorithym */
+static void yaffs_use_cache(struct yaffs_dev *dev, struct yaffs_cache *cache,
+			    int is_write)
+{
+
+	if (dev->param.n_caches > 0) {
+		if (dev->cache_last_use < 0 || dev->cache_last_use > 100000000) {
+			/* Reset the cache usages */
+			int i;
+			for (i = 1; i < dev->param.n_caches; i++)
+				dev->cache[i].last_use = 0;
+
+			dev->cache_last_use = 0;
+		}
+
+		dev->cache_last_use++;
+
+		cache->last_use = dev->cache_last_use;
+
+		if (is_write)
+			cache->dirty = 1;
+	}
+}
+
+/* Invalidate a single cache page.
+ * Do this when a whole page gets written,
+ * ie the short cache for this page is no longer valid.
+ */
+static void yaffs_invalidate_chunk_cache(struct yaffs_obj *object, int chunk_id)
+{
+	if (object->my_dev->param.n_caches > 0) {
+		struct yaffs_cache *cache =
+		    yaffs_find_chunk_cache(object, chunk_id);
+
+		if (cache)
+			cache->object = NULL;
+	}
+}
+
+/* Invalidate all the cache pages associated with this object
+ * Do this whenever ther file is deleted or resized.
+ */
+static void yaffs_invalidate_whole_cache(struct yaffs_obj *in)
+{
+	int i;
+	struct yaffs_dev *dev = in->my_dev;
+
+	if (dev->param.n_caches > 0) {
+		/* Invalidate it. */
+		for (i = 0; i < dev->param.n_caches; i++) {
+			if (dev->cache[i].object == in)
+				dev->cache[i].object = NULL;
+		}
+	}
+}
+
+/*--------------------- File read/write ------------------------
+ * Read and write have very similar structures.
+ * In general the read/write has three parts to it
+ * An incomplete chunk to start with (if the read/write is not chunk-aligned)
+ * Some complete chunks
+ * An incomplete chunk to end off with
+ *
+ * Curve-balls: the first chunk might also be the last chunk.
+ */
+
+int yaffs_file_rd(struct yaffs_obj *in, u8 * buffer, loff_t offset, int n_bytes)
+{
+
+	int chunk;
+	u32 start;
+	int n_copy;
+	int n = n_bytes;
+	int n_done = 0;
+	struct yaffs_cache *cache;
+
+	struct yaffs_dev *dev;
+
+	dev = in->my_dev;
+
+	while (n > 0) {
+		/* chunk = offset / dev->data_bytes_per_chunk + 1; */
+		/* start = offset % dev->data_bytes_per_chunk; */
+		yaffs_addr_to_chunk(dev, offset, &chunk, &start);
+		chunk++;
+
+		/* OK now check for the curveball where the start and end are in
+		 * the same chunk.
+		 */
+		if ((start + n) < dev->data_bytes_per_chunk)
+			n_copy = n;
+		else
+			n_copy = dev->data_bytes_per_chunk - start;
+
+		cache = yaffs_find_chunk_cache(in, chunk);
+
+		/* If the chunk is already in the cache or it is less than a whole chunk
+		 * or we're using inband tags then use the cache (if there is caching)
+		 * else bypass the cache.
+		 */
+		if (cache || n_copy != dev->data_bytes_per_chunk
+		    || dev->param.inband_tags) {
+			if (dev->param.n_caches > 0) {
+
+				/* If we can't find the data in the cache, then load it up. */
+
+				if (!cache) {
+					cache =
+					    yaffs_grab_chunk_cache(in->my_dev);
+					cache->object = in;
+					cache->chunk_id = chunk;
+					cache->dirty = 0;
+					cache->locked = 0;
+					yaffs_rd_data_obj(in, chunk,
+							  cache->data);
+					cache->n_bytes = 0;
+				}
+
+				yaffs_use_cache(dev, cache, 0);
+
+				cache->locked = 1;
+
+				memcpy(buffer, &cache->data[start], n_copy);
+
+				cache->locked = 0;
+			} else {
+				/* Read into the local buffer then copy.. */
+
+				u8 *local_buffer =
+				    yaffs_get_temp_buffer(dev, __LINE__);
+				yaffs_rd_data_obj(in, chunk, local_buffer);
+
+				memcpy(buffer, &local_buffer[start], n_copy);
+
+				yaffs_release_temp_buffer(dev, local_buffer,
+							  __LINE__);
+			}
+
+		} else {
+
+			/* A full chunk. Read directly into the supplied buffer. */
+			yaffs_rd_data_obj(in, chunk, buffer);
+
+		}
+
+		n -= n_copy;
+		offset += n_copy;
+		buffer += n_copy;
+		n_done += n_copy;
+
+	}
+
+	return n_done;
+}
+
+int yaffs_do_file_wr(struct yaffs_obj *in, const u8 * buffer, loff_t offset,
+		     int n_bytes, int write_trhrough)
+{
+
+	int chunk;
+	u32 start;
+	int n_copy;
+	int n = n_bytes;
+	int n_done = 0;
+	int n_writeback;
+	int start_write = offset;
+	int chunk_written = 0;
+	u32 n_bytes_read;
+	u32 chunk_start;
+
+	struct yaffs_dev *dev;
+
+	dev = in->my_dev;
+
+	while (n > 0 && chunk_written >= 0) {
+		yaffs_addr_to_chunk(dev, offset, &chunk, &start);
+
+		if (chunk * dev->data_bytes_per_chunk + start != offset ||
+		    start >= dev->data_bytes_per_chunk) {
+			T(YAFFS_TRACE_ERROR,
+			  (TSTR
+			   ("AddrToChunk of offset %d gives chunk %d start %d"
+			    TENDSTR), (int)offset, chunk, start));
+		}
+		chunk++;	/* File pos to chunk in file offset */
+
+		/* OK now check for the curveball where the start and end are in
+		 * the same chunk.
+		 */
+
+		if ((start + n) < dev->data_bytes_per_chunk) {
+			n_copy = n;
+
+			/* Now folks, to calculate how many bytes to write back....
+			 * If we're overwriting and not writing to then end of file then
+			 * we need to write back as much as was there before.
+			 */
+
+			chunk_start = ((chunk - 1) * dev->data_bytes_per_chunk);
+
+			if (chunk_start > in->variant.file_variant.file_size)
+				n_bytes_read = 0;	/* Past end of file */
+			else
+				n_bytes_read =
+				    in->variant.file_variant.file_size -
+				    chunk_start;
+
+			if (n_bytes_read > dev->data_bytes_per_chunk)
+				n_bytes_read = dev->data_bytes_per_chunk;
+
+			n_writeback =
+			    (n_bytes_read >
+			     (start + n)) ? n_bytes_read : (start + n);
+
+			if (n_writeback < 0
+			    || n_writeback > dev->data_bytes_per_chunk)
+				YBUG();
+
+		} else {
+			n_copy = dev->data_bytes_per_chunk - start;
+			n_writeback = dev->data_bytes_per_chunk;
+		}
+
+		if (n_copy != dev->data_bytes_per_chunk
+		    || dev->param.inband_tags) {
+			/* An incomplete start or end chunk (or maybe both start and end chunk),
+			 * or we're using inband tags, so we want to use the cache buffers.
+			 */
+			if (dev->param.n_caches > 0) {
+				struct yaffs_cache *cache;
+				/* If we can't find the data in the cache, then load the cache */
+				cache = yaffs_find_chunk_cache(in, chunk);
+
+				if (!cache
+				    && yaffs_check_alloc_available(dev, 1)) {
+					cache = yaffs_grab_chunk_cache(dev);
+					cache->object = in;
+					cache->chunk_id = chunk;
+					cache->dirty = 0;
+					cache->locked = 0;
+					yaffs_rd_data_obj(in, chunk,
+							  cache->data);
+				} else if (cache &&
+					   !cache->dirty &&
+					   !yaffs_check_alloc_available(dev,
+									1)) {
+					/* Drop the cache if it was a read cache item and
+					 * no space check has been made for it.
+					 */
+					cache = NULL;
+				}
+
+				if (cache) {
+					yaffs_use_cache(dev, cache, 1);
+					cache->locked = 1;
+
+					memcpy(&cache->data[start], buffer,
+					       n_copy);
+
+					cache->locked = 0;
+					cache->n_bytes = n_writeback;
+
+					if (write_trhrough) {
+						chunk_written =
+						    yaffs_wr_data_obj
+						    (cache->object,
+						     cache->chunk_id,
+						     cache->data,
+						     cache->n_bytes, 1);
+						cache->dirty = 0;
+					}
+
+				} else {
+					chunk_written = -1;	/* fail the write */
+				}
+			} else {
+				/* An incomplete start or end chunk (or maybe both start and end chunk)
+				 * Read into the local buffer then copy, then copy over and write back.
+				 */
+
+				u8 *local_buffer =
+				    yaffs_get_temp_buffer(dev, __LINE__);
+
+				yaffs_rd_data_obj(in, chunk, local_buffer);
+
+				memcpy(&local_buffer[start], buffer, n_copy);
+
+				chunk_written =
+				    yaffs_wr_data_obj(in, chunk,
+						      local_buffer,
+						      n_writeback, 0);
+
+				yaffs_release_temp_buffer(dev, local_buffer,
+							  __LINE__);
+
+			}
+
+		} else {
+			/* A full chunk. Write directly from the supplied buffer. */
+
+			chunk_written =
+			    yaffs_wr_data_obj(in, chunk, buffer,
+					      dev->data_bytes_per_chunk, 0);
+
+			/* Since we've overwritten the cached data, we better invalidate it. */
+			yaffs_invalidate_chunk_cache(in, chunk);
+		}
+
+		if (chunk_written >= 0) {
+			n -= n_copy;
+			offset += n_copy;
+			buffer += n_copy;
+			n_done += n_copy;
+		}
+
+	}
+
+	/* Update file object */
+
+	if ((start_write + n_done) > in->variant.file_variant.file_size)
+		in->variant.file_variant.file_size = (start_write + n_done);
+
+	in->dirty = 1;
+
+	return n_done;
+}
+
+int yaffs_wr_file(struct yaffs_obj *in, const u8 * buffer, loff_t offset,
+		  int n_bytes, int write_trhrough)
+{
+	yaffs2_handle_hole(in, offset);
+	return yaffs_do_file_wr(in, buffer, offset, n_bytes, write_trhrough);
+}
+
+/* ---------------------- File resizing stuff ------------------ */
+
+static void yaffs_prune_chunks(struct yaffs_obj *in, int new_size)
+{
+
+	struct yaffs_dev *dev = in->my_dev;
+	int old_size = in->variant.file_variant.file_size;
+
+	int last_del = 1 + (old_size - 1) / dev->data_bytes_per_chunk;
+
+	int start_del = 1 + (new_size + dev->data_bytes_per_chunk - 1) /
+	    dev->data_bytes_per_chunk;
+	int i;
+	int chunk_id;
+
+	/* Delete backwards so that we don't end up with holes if
+	 * power is lost part-way through the operation.
+	 */
+	for (i = last_del; i >= start_del; i--) {
+		/* NB this could be optimised somewhat,
+		 * eg. could retrieve the tags and write them without
+		 * using yaffs_chunk_del
+		 */
+
+		chunk_id = yaffs_find_del_file_chunk(in, i, NULL);
+		if (chunk_id > 0) {
+			if (chunk_id <
+			    (dev->internal_start_block *
+			     dev->param.chunks_per_block)
+			    || chunk_id >=
+			    ((dev->internal_end_block +
+			      1) * dev->param.chunks_per_block)) {
+				T(YAFFS_TRACE_ALWAYS,
+				  (TSTR
+				   ("Found daft chunk_id %d for %d" TENDSTR),
+				   chunk_id, i));
+			} else {
+				in->n_data_chunks--;
+				yaffs_chunk_del(dev, chunk_id, 1, __LINE__);
+			}
+		}
+	}
+
+}
+
+void yaffs_resize_file_down(struct yaffs_obj *obj, loff_t new_size)
+{
+	int new_full;
+	u32 new_partial;
+	struct yaffs_dev *dev = obj->my_dev;
+
+	yaffs_addr_to_chunk(dev, new_size, &new_full, &new_partial);
+
+	yaffs_prune_chunks(obj, new_size);
+
+	if (new_partial != 0) {
+		int last_chunk = 1 + new_full;
+		u8 *local_buffer = yaffs_get_temp_buffer(dev, __LINE__);
+
+		/* Got to read and rewrite the last chunk with its new size and zero pad */
+		yaffs_rd_data_obj(obj, last_chunk, local_buffer);
+		memset(local_buffer + new_partial, 0,
+		       dev->data_bytes_per_chunk - new_partial);
+
+		yaffs_wr_data_obj(obj, last_chunk, local_buffer,
+				  new_partial, 1);
+
+		yaffs_release_temp_buffer(dev, local_buffer, __LINE__);
+	}
+
+	obj->variant.file_variant.file_size = new_size;
+
+	yaffs_prune_tree(dev, &obj->variant.file_variant);
+}
+
+int yaffs_resize_file(struct yaffs_obj *in, loff_t new_size)
+{
+	struct yaffs_dev *dev = in->my_dev;
+	int old_size = in->variant.file_variant.file_size;
+
+	yaffs_flush_file_cache(in);
+	yaffs_invalidate_whole_cache(in);
+
+	yaffs_check_gc(dev, 0);
+
+	if (in->variant_type != YAFFS_OBJECT_TYPE_FILE)
+		return YAFFS_FAIL;
+
+	if (new_size == old_size)
+		return YAFFS_OK;
+
+	if (new_size > old_size) {
+		yaffs2_handle_hole(in, new_size);
+		in->variant.file_variant.file_size = new_size;
+	} else {
+		/* new_size < old_size */
+		yaffs_resize_file_down(in, new_size);
+	}
+
+	/* Write a new object header to reflect the resize.
+	 * show we've shrunk the file, if need be
+	 * Do this only if the file is not in the deleted directories
+	 * and is not shadowed.
+	 */
+	if (in->parent &&
+	    !in->is_shadowed &&
+	    in->parent->obj_id != YAFFS_OBJECTID_UNLINKED &&
+	    in->parent->obj_id != YAFFS_OBJECTID_DELETED)
+		yaffs_update_oh(in, NULL, 0, 0, 0, NULL);
+
+	return YAFFS_OK;
+}
+
+int yaffs_flush_file(struct yaffs_obj *in, int update_time, int data_sync)
+{
+	int ret_val;
+	if (in->dirty) {
+		yaffs_flush_file_cache(in);
+		if (data_sync)	/* Only sync data */
+			ret_val = YAFFS_OK;
+		else {
+			if (update_time)
+				yaffs_load_current_time(in, 0, 0);
+
+			ret_val = (yaffs_update_oh(in, NULL, 0, 0, 0, NULL) >=
+				   0) ? YAFFS_OK : YAFFS_FAIL;
+		}
+	} else {
+		ret_val = YAFFS_OK;
+	}
+
+	return ret_val;
+
+}
+
+static int yaffs_generic_obj_del(struct yaffs_obj *in)
+{
+
+	/* First off, invalidate the file's data in the cache, without flushing. */
+	yaffs_invalidate_whole_cache(in);
+
+	if (in->my_dev->param.is_yaffs2 && (in->parent != in->my_dev->del_dir)) {
+		/* Move to the unlinked directory so we have a record that it was deleted. */
+		yaffs_change_obj_name(in, in->my_dev->del_dir, _Y("deleted"), 0,
+				      0);
+
+	}
+
+	yaffs_remove_obj_from_dir(in);
+	yaffs_chunk_del(in->my_dev, in->hdr_chunk, 1, __LINE__);
+	in->hdr_chunk = 0;
+
+	yaffs_free_obj(in);
+	return YAFFS_OK;
+
+}
+
+/* yaffs_del_file deletes the whole file data
+ * and the inode associated with the file.
+ * It does not delete the links associated with the file.
+ */
+static int yaffs_unlink_file_if_needed(struct yaffs_obj *in)
+{
+
+	int ret_val;
+	int del_now = 0;
+	struct yaffs_dev *dev = in->my_dev;
+
+	if (!in->my_inode)
+		del_now = 1;
+
+	if (del_now) {
+		ret_val =
+		    yaffs_change_obj_name(in, in->my_dev->del_dir,
+					  _Y("deleted"), 0, 0);
+		T(YAFFS_TRACE_TRACING,
+		  (TSTR("yaffs: immediate deletion of file %d" TENDSTR),
+		   in->obj_id));
+		in->deleted = 1;
+		in->my_dev->n_deleted_files++;
+		if (dev->param.disable_soft_del || dev->param.is_yaffs2)
+			yaffs_resize_file(in, 0);
+		yaffs_soft_del_file(in);
+	} else {
+		ret_val =
+		    yaffs_change_obj_name(in, in->my_dev->unlinked_dir,
+					  _Y("unlinked"), 0, 0);
+	}
+
+	return ret_val;
+}
+
+int yaffs_del_file(struct yaffs_obj *in)
+{
+	int ret_val = YAFFS_OK;
+	int deleted;		/* Need to cache value on stack if in is freed */
+	struct yaffs_dev *dev = in->my_dev;
+
+	if (dev->param.disable_soft_del || dev->param.is_yaffs2)
+		yaffs_resize_file(in, 0);
+
+	if (in->n_data_chunks > 0) {
+		/* Use soft deletion if there is data in the file.
+		 * That won't be the case if it has been resized to zero.
+		 */
+		if (!in->unlinked)
+			ret_val = yaffs_unlink_file_if_needed(in);
+
+		deleted = in->deleted;
+
+		if (ret_val == YAFFS_OK && in->unlinked && !in->deleted) {
+			in->deleted = 1;
+			deleted = 1;
+			in->my_dev->n_deleted_files++;
+			yaffs_soft_del_file(in);
+		}
+		return deleted ? YAFFS_OK : YAFFS_FAIL;
+	} else {
+		/* The file has no data chunks so we toss it immediately */
+		yaffs_free_tnode(in->my_dev, in->variant.file_variant.top);
+		in->variant.file_variant.top = NULL;
+		yaffs_generic_obj_del(in);
+
+		return YAFFS_OK;
+	}
+}
+
+int yaffs_is_non_empty_dir(struct yaffs_obj *obj)
+{
+	return (obj &&
+	        obj->variant_type == YAFFS_OBJECT_TYPE_DIRECTORY) &&
+	        !(list_empty(&obj->variant.dir_variant.children));
+}
+
+static int yaffs_del_dir(struct yaffs_obj *obj)
+{
+	/* First check that the directory is empty. */
+	if (yaffs_is_non_empty_dir(obj))
+		return YAFFS_FAIL;
+
+	return yaffs_generic_obj_del(obj);
+}
+
+static int yaffs_del_symlink(struct yaffs_obj *in)
+{
+	if (in->variant.symlink_variant.alias)
+		YFREE(in->variant.symlink_variant.alias);
+	in->variant.symlink_variant.alias = NULL;
+
+	return yaffs_generic_obj_del(in);
+}
+
+static int yaffs_del_link(struct yaffs_obj *in)
+{
+	/* remove this hardlink from the list assocaited with the equivalent
+	 * object
+	 */
+	list_del_init(&in->hard_links);
+	return yaffs_generic_obj_del(in);
+}
+
+int yaffs_del_obj(struct yaffs_obj *obj)
+{
+	int ret_val = -1;
+	switch (obj->variant_type) {
+	case YAFFS_OBJECT_TYPE_FILE:
+		ret_val = yaffs_del_file(obj);
+		break;
+	case YAFFS_OBJECT_TYPE_DIRECTORY:
+		if (!list_empty(&obj->variant.dir_variant.dirty)) {
+			T(YAFFS_TRACE_BACKGROUND,
+			  (TSTR
+			   ("Remove object %d from dirty directories" TENDSTR),
+			   obj->obj_id));
+			list_del_init(&obj->variant.dir_variant.dirty);
+		}
+		return yaffs_del_dir(obj);
+		break;
+	case YAFFS_OBJECT_TYPE_SYMLINK:
+		ret_val = yaffs_del_symlink(obj);
+		break;
+	case YAFFS_OBJECT_TYPE_HARDLINK:
+		ret_val = yaffs_del_link(obj);
+		break;
+	case YAFFS_OBJECT_TYPE_SPECIAL:
+		ret_val = yaffs_generic_obj_del(obj);
+		break;
+	case YAFFS_OBJECT_TYPE_UNKNOWN:
+		ret_val = 0;
+		break;		/* should not happen. */
+	}
+
+	return ret_val;
+}
+
+static int yaffs_unlink_worker(struct yaffs_obj *obj)
+{
+
+	int del_now = 0;
+
+	if (!obj->my_inode)
+		del_now = 1;
+
+	if (obj)
+		yaffs_update_parent(obj->parent);
+
+	if (obj->variant_type == YAFFS_OBJECT_TYPE_HARDLINK) {
+		return yaffs_del_link(obj);
+	} else if (!list_empty(&obj->hard_links)) {
+		/* Curve ball: We're unlinking an object that has a hardlink.
+		 *
+		 * This problem arises because we are not strictly following
+		 * The Linux link/inode model.
+		 *
+		 * We can't really delete the object.
+		 * Instead, we do the following:
+		 * - Select a hardlink.
+		 * - Unhook it from the hard links
+		 * - Move it from its parent directory (so that the rename can work)
+		 * - Rename the object to the hardlink's name.
+		 * - Delete the hardlink
+		 */
+
+		struct yaffs_obj *hl;
+		struct yaffs_obj *parent;
+		int ret_val;
+		YCHAR name[YAFFS_MAX_NAME_LENGTH + 1];
+
+		hl = list_entry(obj->hard_links.next, struct yaffs_obj,
+				hard_links);
+
+		yaffs_get_obj_name(hl, name, YAFFS_MAX_NAME_LENGTH + 1);
+		parent = hl->parent;
+
+		list_del_init(&hl->hard_links);
+
+		yaffs_add_obj_to_dir(obj->my_dev->unlinked_dir, hl);
+
+		ret_val = yaffs_change_obj_name(obj, parent, name, 0, 0);
+
+		if (ret_val == YAFFS_OK)
+			ret_val = yaffs_generic_obj_del(hl);
+
+		return ret_val;
+
+	} else if (del_now) {
+		switch (obj->variant_type) {
+		case YAFFS_OBJECT_TYPE_FILE:
+			return yaffs_del_file(obj);
+			break;
+		case YAFFS_OBJECT_TYPE_DIRECTORY:
+			list_del_init(&obj->variant.dir_variant.dirty);
+			return yaffs_del_dir(obj);
+			break;
+		case YAFFS_OBJECT_TYPE_SYMLINK:
+			return yaffs_del_symlink(obj);
+			break;
+		case YAFFS_OBJECT_TYPE_SPECIAL:
+			return yaffs_generic_obj_del(obj);
+			break;
+		case YAFFS_OBJECT_TYPE_HARDLINK:
+		case YAFFS_OBJECT_TYPE_UNKNOWN:
+		default:
+			return YAFFS_FAIL;
+		}
+	} else if (yaffs_is_non_empty_dir(obj)) {
+		return YAFFS_FAIL;
+	} else {
+		return yaffs_change_obj_name(obj, obj->my_dev->unlinked_dir,
+					     _Y("unlinked"), 0, 0);
+        }
+}
+
+static int yaffs_unlink_obj(struct yaffs_obj *obj)
+{
+
+	if (obj && obj->unlink_allowed)
+		return yaffs_unlink_worker(obj);
+
+	return YAFFS_FAIL;
+
+}
+
+int yaffs_unlinker(struct yaffs_obj *dir, const YCHAR * name)
+{
+	struct yaffs_obj *obj;
+
+	obj = yaffs_find_by_name(dir, name);
+	return yaffs_unlink_obj(obj);
+}
+
+/*----------------------- Initialisation Scanning ---------------------- */
+
+void yaffs_handle_shadowed_obj(struct yaffs_dev *dev, int obj_id,
+			       int backward_scanning)
+{
+	struct yaffs_obj *obj;
+
+	if (!backward_scanning) {
+		/* Handle YAFFS1 forward scanning case
+		 * For YAFFS1 we always do the deletion
+		 */
+
+	} else {
+		/* Handle YAFFS2 case (backward scanning)
+		 * If the shadowed object exists then ignore.
+		 */
+		obj = yaffs_find_by_number(dev, obj_id);
+		if (obj)
+			return;
+	}
+
+	/* Let's create it (if it does not exist) assuming it is a file so that it can do shrinking etc.
+	 * We put it in unlinked dir to be cleaned up after the scanning
+	 */
+	obj =
+	    yaffs_find_or_create_by_number(dev, obj_id, YAFFS_OBJECT_TYPE_FILE);
+	if (!obj)
+		return;
+	obj->is_shadowed = 1;
+	yaffs_add_obj_to_dir(dev->unlinked_dir, obj);
+	obj->variant.file_variant.shrink_size = 0;
+	obj->valid = 1;		/* So that we don't read any other info for this file */
+
+}
+
+void yaffs_link_fixup(struct yaffs_dev *dev, struct yaffs_obj *hard_list)
+{
+	struct yaffs_obj *hl;
+	struct yaffs_obj *in;
+
+	while (hard_list) {
+		hl = hard_list;
+		hard_list = (struct yaffs_obj *)(hard_list->hard_links.next);
+
+		in = yaffs_find_by_number(dev,
+					  hl->variant.
+					  hardlink_variant.equiv_id);
+
+		if (in) {
+			/* Add the hardlink pointers */
+			hl->variant.hardlink_variant.equiv_obj = in;
+			list_add(&hl->hard_links, &in->hard_links);
+		} else {
+			/* Todo Need to report/handle this better.
+			 * Got a problem... hardlink to a non-existant object
+			 */
+			hl->variant.hardlink_variant.equiv_obj = NULL;
+			INIT_LIST_HEAD(&hl->hard_links);
+
+		}
+	}
+}
+
+static void yaffs_strip_deleted_objs(struct yaffs_dev *dev)
+{
+	/*
+	 *  Sort out state of unlinked and deleted objects after scanning.
+	 */
+	struct list_head *i;
+	struct list_head *n;
+	struct yaffs_obj *l;
+
+	if (dev->read_only)
+		return;
+
+	/* Soft delete all the unlinked files */
+	list_for_each_safe(i, n,
+			   &dev->unlinked_dir->variant.dir_variant.children) {
+		if (i) {
+			l = list_entry(i, struct yaffs_obj, siblings);
+			yaffs_del_obj(l);
+		}
+	}
+
+	list_for_each_safe(i, n, &dev->del_dir->variant.dir_variant.children) {
+		if (i) {
+			l = list_entry(i, struct yaffs_obj, siblings);
+			yaffs_del_obj(l);
+		}
+	}
+
+}
+
+/*
+ * This code iterates through all the objects making sure that they are rooted.
+ * Any unrooted objects are re-rooted in lost+found.
+ * An object needs to be in one of:
+ * - Directly under deleted, unlinked
+ * - Directly or indirectly under root.
+ *
+ * Note:
+ *  This code assumes that we don't ever change the current relationships between
+ *  directories:
+ *   root_dir->parent == unlinked_dir->parent == del_dir->parent == NULL
+ *   lost-n-found->parent == root_dir
+ *
+ * This fixes the problem where directories might have inadvertently been deleted
+ * leaving the object "hanging" without being rooted in the directory tree.
+ */
+
+static int yaffs_has_null_parent(struct yaffs_dev *dev, struct yaffs_obj *obj)
+{
+	return (obj == dev->del_dir ||
+		obj == dev->unlinked_dir || obj == dev->root_dir);
+}
+
+static void yaffs_fix_hanging_objs(struct yaffs_dev *dev)
+{
+	struct yaffs_obj *obj;
+	struct yaffs_obj *parent;
+	int i;
+	struct list_head *lh;
+	struct list_head *n;
+	int depth_limit;
+	int hanging;
+
+	if (dev->read_only)
+		return;
+
+	/* Iterate through the objects in each hash entry,
+	 * looking at each object.
+	 * Make sure it is rooted.
+	 */
+
+	for (i = 0; i < YAFFS_NOBJECT_BUCKETS; i++) {
+		list_for_each_safe(lh, n, &dev->obj_bucket[i].list) {
+			if (lh) {
+				obj =
+				    list_entry(lh, struct yaffs_obj, hash_link);
+				parent = obj->parent;
+
+				if (yaffs_has_null_parent(dev, obj)) {
+					/* These directories are not hanging */
+					hanging = 0;
+				} else if (!parent
+					   || parent->variant_type !=
+					   YAFFS_OBJECT_TYPE_DIRECTORY) {
+					hanging = 1;
+				} else if (yaffs_has_null_parent(dev, parent)) {
+					hanging = 0;
+				} else {
+					/*
+					 * Need to follow the parent chain to see if it is hanging.
+					 */
+					hanging = 0;
+					depth_limit = 100;
+
+					while (parent != dev->root_dir &&
+					       parent->parent &&
+					       parent->parent->variant_type ==
+					       YAFFS_OBJECT_TYPE_DIRECTORY
+					       && depth_limit > 0) {
+						parent = parent->parent;
+						depth_limit--;
+					}
+					if (parent != dev->root_dir)
+						hanging = 1;
+				}
+				if (hanging) {
+					T(YAFFS_TRACE_SCAN,
+					  (TSTR
+					   ("Hanging object %d moved to lost and found"
+					    TENDSTR), obj->obj_id));
+					yaffs_add_obj_to_dir(dev->lost_n_found,
+							     obj);
+				}
+			}
+		}
+	}
+}
+
+/*
+ * Delete directory contents for cleaning up lost and found.
+ */
+static void yaffs_del_dir_contents(struct yaffs_obj *dir)
+{
+	struct yaffs_obj *obj;
+	struct list_head *lh;
+	struct list_head *n;
+
+	if (dir->variant_type != YAFFS_OBJECT_TYPE_DIRECTORY)
+		YBUG();
+
+	list_for_each_safe(lh, n, &dir->variant.dir_variant.children) {
+		if (lh) {
+			obj = list_entry(lh, struct yaffs_obj, siblings);
+			if (obj->variant_type == YAFFS_OBJECT_TYPE_DIRECTORY)
+				yaffs_del_dir_contents(obj);
+
+			T(YAFFS_TRACE_SCAN,
+			  (TSTR("Deleting lost_found object %d" TENDSTR),
+			   obj->obj_id));
+
+			/* Need to use UnlinkObject since Delete would not handle
+			 * hardlinked objects correctly.
+			 */
+			yaffs_unlink_obj(obj);
+		}
+	}
+
+}
+
+static void yaffs_empty_l_n_f(struct yaffs_dev *dev)
+{
+	yaffs_del_dir_contents(dev->lost_n_found);
+}
+
+static void yaffs_check_obj_details_loaded(struct yaffs_obj *in)
+{
+	u8 *chunk_data;
+	struct yaffs_obj_hdr *oh;
+	struct yaffs_dev *dev;
+	struct yaffs_ext_tags tags;
+	int result;
+	int alloc_failed = 0;
+
+	if (!in)
+		return;
+
+	dev = in->my_dev;
+
+	if (in->lazy_loaded && in->hdr_chunk > 0) {
+		in->lazy_loaded = 0;
+		chunk_data = yaffs_get_temp_buffer(dev, __LINE__);
+
+		result =
+		    yaffs_rd_chunk_tags_nand(dev, in->hdr_chunk, chunk_data,
+					     &tags);
+		oh = (struct yaffs_obj_hdr *)chunk_data;
+
+		in->yst_mode = oh->yst_mode;
+		yaffs_load_attribs(in, oh);
+		yaffs_set_obj_name_from_oh(in, oh);
+
+		if (in->variant_type == YAFFS_OBJECT_TYPE_SYMLINK) {
+			in->variant.symlink_variant.alias =
+			    yaffs_clone_str(oh->alias);
+			if (!in->variant.symlink_variant.alias)
+				alloc_failed = 1;	/* Not returned to caller */
+		}
+
+		yaffs_release_temp_buffer(dev, chunk_data, __LINE__);
+	}
+}
+
+/*------------------------------  Directory Functions ----------------------------- */
+
+/*
+ *yaffs_update_parent() handles fixing a directories mtime and ctime when a new
+ * link (ie. name) is created or deleted in the directory.
+ *
+ * ie.
+ *   create dir/a : update dir's mtime/ctime
+ *   rm dir/a:   update dir's mtime/ctime
+ *   modify dir/a: don't update dir's mtimme/ctime
+ *
+ * This can be handled immediately or defered. Defering helps reduce the number
+ * of updates when many files in a directory are changed within a brief period.
+ *
+ * If the directory updating is defered then yaffs_update_dirty_dirs must be
+ * called periodically.
+ */
+
+static void yaffs_update_parent(struct yaffs_obj *obj)
+{
+	struct yaffs_dev *dev;
+	if (!obj)
+		return;
+	dev = obj->my_dev;
+	obj->dirty = 1;
+	yaffs_load_current_time(obj, 0, 1);
+	if (dev->param.defered_dir_update) {
+		struct list_head *link = &obj->variant.dir_variant.dirty;
+
+		if (list_empty(link)) {
+			list_add(link, &dev->dirty_dirs);
+			T(YAFFS_TRACE_BACKGROUND,
+			  (TSTR("Added object %d to dirty directories" TENDSTR),
+			   obj->obj_id));
+		}
+
+	} else {
+		yaffs_update_oh(obj, NULL, 0, 0, 0, NULL);
+        }
+}
+
+void yaffs_update_dirty_dirs(struct yaffs_dev *dev)
+{
+	struct list_head *link;
+	struct yaffs_obj *obj;
+	struct yaffs_dir_var *d_s;
+	union yaffs_obj_var *o_v;
+
+	T(YAFFS_TRACE_BACKGROUND, (TSTR("Update dirty directories" TENDSTR)));
+
+	while (!list_empty(&dev->dirty_dirs)) {
+		link = dev->dirty_dirs.next;
+		list_del_init(link);
+
+		d_s = list_entry(link, struct yaffs_dir_var, dirty);
+		o_v = list_entry(d_s, union yaffs_obj_var, dir_variant);
+		obj = list_entry(o_v, struct yaffs_obj, variant);
+
+		T(YAFFS_TRACE_BACKGROUND,
+		  (TSTR("Update directory %d" TENDSTR), obj->obj_id));
+
+		if (obj->dirty)
+			yaffs_update_oh(obj, NULL, 0, 0, 0, NULL);
+	}
+}
+
+static void yaffs_remove_obj_from_dir(struct yaffs_obj *obj)
+{
+	struct yaffs_dev *dev = obj->my_dev;
+	struct yaffs_obj *parent;
+
+	yaffs_verify_obj_in_dir(obj);
+	parent = obj->parent;
+
+	yaffs_verify_dir(parent);
+
+	if (dev && dev->param.remove_obj_fn)
+		dev->param.remove_obj_fn(obj);
+
+	list_del_init(&obj->siblings);
+	obj->parent = NULL;
+
+	yaffs_verify_dir(parent);
+}
+
+void yaffs_add_obj_to_dir(struct yaffs_obj *directory, struct yaffs_obj *obj)
+{
+	if (!directory) {
+		T(YAFFS_TRACE_ALWAYS,
+		  (TSTR
+		   ("tragedy: Trying to add an object to a null pointer directory"
+		    TENDSTR)));
+		YBUG();
+		return;
+	}
+	if (directory->variant_type != YAFFS_OBJECT_TYPE_DIRECTORY) {
+		T(YAFFS_TRACE_ALWAYS,
+		  (TSTR
+		   ("tragedy: Trying to add an object to a non-directory"
+		    TENDSTR)));
+		YBUG();
+	}
+
+	if (obj->siblings.prev == NULL) {
+		/* Not initialised */
+		YBUG();
+	}
+
+	yaffs_verify_dir(directory);
+
+	yaffs_remove_obj_from_dir(obj);
+
+	/* Now add it */
+	list_add(&obj->siblings, &directory->variant.dir_variant.children);
+	obj->parent = directory;
+
+	if (directory == obj->my_dev->unlinked_dir
+	    || directory == obj->my_dev->del_dir) {
+		obj->unlinked = 1;
+		obj->my_dev->n_unlinked_files++;
+		obj->rename_allowed = 0;
+	}
+
+	yaffs_verify_dir(directory);
+	yaffs_verify_obj_in_dir(obj);
+}
+
+struct yaffs_obj *yaffs_find_by_name(struct yaffs_obj *directory,
+				     const YCHAR * name)
+{
+	int sum;
+
+	struct list_head *i;
+	YCHAR buffer[YAFFS_MAX_NAME_LENGTH + 1];
+
+	struct yaffs_obj *l;
+
+	if (!name)
+		return NULL;
+
+	if (!directory) {
+		T(YAFFS_TRACE_ALWAYS,
+		  (TSTR
+		   ("tragedy: yaffs_find_by_name: null pointer directory"
+		    TENDSTR)));
+		YBUG();
+		return NULL;
+	}
+	if (directory->variant_type != YAFFS_OBJECT_TYPE_DIRECTORY) {
+		T(YAFFS_TRACE_ALWAYS,
+		  (TSTR("tragedy: yaffs_find_by_name: non-directory" TENDSTR)));
+		YBUG();
+	}
+
+	sum = yaffs_calc_name_sum(name);
+
+	list_for_each(i, &directory->variant.dir_variant.children) {
+		if (i) {
+			l = list_entry(i, struct yaffs_obj, siblings);
+
+			if (l->parent != directory)
+				YBUG();
+
+			yaffs_check_obj_details_loaded(l);
+
+			/* Special case for lost-n-found */
+			if (l->obj_id == YAFFS_OBJECTID_LOSTNFOUND) {
+				if (!yaffs_strcmp(name, YAFFS_LOSTNFOUND_NAME))
+					return l;
+			} else if (yaffs_sum_cmp(l->sum, sum)
+				   || l->hdr_chunk <= 0) {
+				/* LostnFound chunk called Objxxx
+				 * Do a real check
+				 */
+				yaffs_get_obj_name(l, buffer,
+						   YAFFS_MAX_NAME_LENGTH + 1);
+				if (yaffs_strncmp
+				    (name, buffer, YAFFS_MAX_NAME_LENGTH) == 0)
+					return l;
+			}
+		}
+	}
+
+	return NULL;
+}
+
+/* GetEquivalentObject dereferences any hard links to get to the
+ * actual object.
+ */
+
+struct yaffs_obj *yaffs_get_equivalent_obj(struct yaffs_obj *obj)
+{
+	if (obj && obj->variant_type == YAFFS_OBJECT_TYPE_HARDLINK) {
+		/* We want the object id of the equivalent object, not this one */
+		obj = obj->variant.hardlink_variant.equiv_obj;
+		yaffs_check_obj_details_loaded(obj);
+	}
+	return obj;
+}
+
+/*
+ *  A note or two on object names.
+ *  * If the object name is missing, we then make one up in the form objnnn
+ *
+ *  * ASCII names are stored in the object header's name field from byte zero
+ *  * Unicode names are historically stored starting from byte zero.
+ *
+ * Then there are automatic Unicode names...
+ * The purpose of these is to save names in a way that can be read as
+ * ASCII or Unicode names as appropriate, thus allowing a Unicode and ASCII
+ * system to share files.
+ *
+ * These automatic unicode are stored slightly differently...
+ *  - If the name can fit in the ASCII character space then they are saved as 
+ *    ascii names as per above.
+ *  - If the name needs Unicode then the name is saved in Unicode
+ *    starting at oh->name[1].
+
+ */
+static void yaffs_fix_null_name(struct yaffs_obj *obj, YCHAR * name,
+				int buffer_size)
+{
+	/* Create an object name if we could not find one. */
+	if (yaffs_strnlen(name, YAFFS_MAX_NAME_LENGTH) == 0) {
+		YCHAR local_name[20];
+		YCHAR num_string[20];
+		YCHAR *x = &num_string[19];
+		unsigned v = obj->obj_id;
+		num_string[19] = 0;
+		while (v > 0) {
+			x--;
+			*x = '0' + (v % 10);
+			v /= 10;
+		}
+		/* make up a name */
+		yaffs_strcpy(local_name, YAFFS_LOSTNFOUND_PREFIX);
+		yaffs_strcat(local_name, x);
+		yaffs_strncpy(name, local_name, buffer_size - 1);
+	}
+}
+
+static void yaffs_load_name_from_oh(struct yaffs_dev *dev, YCHAR * name,
+				    const YCHAR * oh_name, int buff_size)
+{
+#ifdef CONFIG_YAFFS_AUTO_UNICODE
+	if (dev->param.auto_unicode) {
+		if (*oh_name) {
+			/* It is an ASCII name, so do an ASCII to unicode conversion */
+			const char *ascii_oh_name = (const char *)oh_name;
+			int n = buff_size - 1;
+			while (n > 0 && *ascii_oh_name) {
+				*name = *ascii_oh_name;
+				name++;
+				ascii_oh_name++;
+				n--;
+			}
+		} else {
+			yaffs_strncpy(name, oh_name + 1, buff_size - 1);
+                }
+	} else {
+#else
+        {
+#endif
+		yaffs_strncpy(name, oh_name, buff_size - 1);
+        }
+}
+
+static void yaffs_load_oh_from_name(struct yaffs_dev *dev, YCHAR * oh_name,
+				    const YCHAR * name)
+{
+#ifdef CONFIG_YAFFS_AUTO_UNICODE
+
+	int is_ascii;
+	YCHAR *w;
+
+	if (dev->param.auto_unicode) {
+
+		is_ascii = 1;
+		w = name;
+
+		/* Figure out if the name will fit in ascii character set */
+		while (is_ascii && *w) {
+			if ((*w) & 0xff00)
+				is_ascii = 0;
+			w++;
+		}
+
+		if (is_ascii) {
+			/* It is an ASCII name, so do a unicode to ascii conversion */
+			char *ascii_oh_name = (char *)oh_name;
+			int n = YAFFS_MAX_NAME_LENGTH - 1;
+			while (n > 0 && *name) {
+				*ascii_oh_name = *name;
+				name++;
+				ascii_oh_name++;
+				n--;
+			}
+		} else {
+			/* It is a unicode name, so save starting at the second YCHAR */
+			*oh_name = 0;
+			yaffs_strncpy(oh_name + 1, name,
+				      YAFFS_MAX_NAME_LENGTH - 2);
+		}
+	} else {
+#else
+        {
+#endif
+		yaffs_strncpy(oh_name, name, YAFFS_MAX_NAME_LENGTH - 1);
+        }
+
+}
+
+int yaffs_get_obj_name(struct yaffs_obj *obj, YCHAR * name, int buffer_size)
+{
+	memset(name, 0, buffer_size * sizeof(YCHAR));
+
+	yaffs_check_obj_details_loaded(obj);
+
+	if (obj->obj_id == YAFFS_OBJECTID_LOSTNFOUND) {
+		yaffs_strncpy(name, YAFFS_LOSTNFOUND_NAME, buffer_size - 1);
+	}
+#ifndef CONFIG_YAFFS_NO_SHORT_NAMES
+	else if (obj->short_name[0]) {
+		yaffs_strcpy(name, obj->short_name);
+	}
+#endif
+	else if (obj->hdr_chunk > 0) {
+		int result;
+		u8 *buffer = yaffs_get_temp_buffer(obj->my_dev, __LINE__);
+
+		struct yaffs_obj_hdr *oh = (struct yaffs_obj_hdr *)buffer;
+
+		memset(buffer, 0, obj->my_dev->data_bytes_per_chunk);
+
+		if (obj->hdr_chunk > 0) {
+			result = yaffs_rd_chunk_tags_nand(obj->my_dev,
+							  obj->hdr_chunk,
+							  buffer, NULL);
+		}
+		yaffs_load_name_from_oh(obj->my_dev, name, oh->name,
+					buffer_size);
+
+		yaffs_release_temp_buffer(obj->my_dev, buffer, __LINE__);
+	}
+
+	yaffs_fix_null_name(obj, name, buffer_size);
+
+	return yaffs_strnlen(name, YAFFS_MAX_NAME_LENGTH);
+}
+
+int yaffs_get_obj_length(struct yaffs_obj *obj)
+{
+	/* Dereference any hard linking */
+	obj = yaffs_get_equivalent_obj(obj);
+
+	if (obj->variant_type == YAFFS_OBJECT_TYPE_FILE)
+		return obj->variant.file_variant.file_size;
+	if (obj->variant_type == YAFFS_OBJECT_TYPE_SYMLINK) {
+		if (!obj->variant.symlink_variant.alias)
+			return 0;
+		return yaffs_strnlen(obj->variant.symlink_variant.alias,
+				     YAFFS_MAX_ALIAS_LENGTH);
+	} else {
+		/* Only a directory should drop through to here */
+		return obj->my_dev->data_bytes_per_chunk;
+	}
+}
+
+int yaffs_get_obj_link_count(struct yaffs_obj *obj)
+{
+	int count = 0;
+	struct list_head *i;
+
+	if (!obj->unlinked)
+		count++;	/* the object itself */
+
+	list_for_each(i, &obj->hard_links)
+	    count++;		/* add the hard links; */
+
+	return count;
+}
+
+int yaffs_get_obj_inode(struct yaffs_obj *obj)
+{
+	obj = yaffs_get_equivalent_obj(obj);
+
+	return obj->obj_id;
+}
+
+unsigned yaffs_get_obj_type(struct yaffs_obj *obj)
+{
+	obj = yaffs_get_equivalent_obj(obj);
+
+	switch (obj->variant_type) {
+	case YAFFS_OBJECT_TYPE_FILE:
+		return DT_REG;
+		break;
+	case YAFFS_OBJECT_TYPE_DIRECTORY:
+		return DT_DIR;
+		break;
+	case YAFFS_OBJECT_TYPE_SYMLINK:
+		return DT_LNK;
+		break;
+	case YAFFS_OBJECT_TYPE_HARDLINK:
+		return DT_REG;
+		break;
+	case YAFFS_OBJECT_TYPE_SPECIAL:
+		if (S_ISFIFO(obj->yst_mode))
+			return DT_FIFO;
+		if (S_ISCHR(obj->yst_mode))
+			return DT_CHR;
+		if (S_ISBLK(obj->yst_mode))
+			return DT_BLK;
+		if (S_ISSOCK(obj->yst_mode))
+			return DT_SOCK;
+	default:
+		return DT_REG;
+		break;
+	}
+}
+
+YCHAR *yaffs_get_symlink_alias(struct yaffs_obj *obj)
+{
+	obj = yaffs_get_equivalent_obj(obj);
+	if (obj->variant_type == YAFFS_OBJECT_TYPE_SYMLINK)
+		return yaffs_clone_str(obj->variant.symlink_variant.alias);
+	else
+		return yaffs_clone_str(_Y(""));
+}
+
+static int yaffs_do_xattrib_mod(struct yaffs_obj *obj, int set,
+				const YCHAR * name, const void *value, int size,
+				int flags)
+{
+	struct yaffs_xattr_mod xmod;
+
+	int result;
+
+	xmod.set = set;
+	xmod.name = name;
+	xmod.data = value;
+	xmod.size = size;
+	xmod.flags = flags;
+	xmod.result = -ENOSPC;
+
+	result = yaffs_update_oh(obj, NULL, 0, 0, 0, &xmod);
+
+	if (result > 0)
+		return xmod.result;
+	else
+		return -ENOSPC;
+}
+
+static int yaffs_apply_xattrib_mod(struct yaffs_obj *obj, char *buffer,
+				   struct yaffs_xattr_mod *xmod)
+{
+	int retval = 0;
+	int x_offs = sizeof(struct yaffs_obj_hdr);
+	struct yaffs_dev *dev = obj->my_dev;
+	int x_size = dev->data_bytes_per_chunk - sizeof(struct yaffs_obj_hdr);
+
+	char *x_buffer = buffer + x_offs;
+
+	if (xmod->set)
+		retval =
+		    nval_set(x_buffer, x_size, xmod->name, xmod->data,
+			     xmod->size, xmod->flags);
+	else
+		retval = nval_del(x_buffer, x_size, xmod->name);
+
+	obj->has_xattr = nval_hasvalues(x_buffer, x_size);
+	obj->xattr_known = 1;
+
+	xmod->result = retval;
+
+	return retval;
+}
+
+static int yaffs_do_xattrib_fetch(struct yaffs_obj *obj, const YCHAR * name,
+				  void *value, int size)
+{
+	char *buffer = NULL;
+	int result;
+	struct yaffs_ext_tags tags;
+	struct yaffs_dev *dev = obj->my_dev;
+	int x_offs = sizeof(struct yaffs_obj_hdr);
+	int x_size = dev->data_bytes_per_chunk - sizeof(struct yaffs_obj_hdr);
+
+	char *x_buffer;
+
+	int retval = 0;
+
+	if (obj->hdr_chunk < 1)
+		return -ENODATA;
+
+	/* If we know that the object has no xattribs then don't do all the
+	 * reading and parsing.
+	 */
+	if (obj->xattr_known && !obj->has_xattr) {
+		if (name)
+			return -ENODATA;
+		else
+			return 0;
+	}
+
+	buffer = (char *)yaffs_get_temp_buffer(dev, __LINE__);
+	if (!buffer)
+		return -ENOMEM;
+
+	result =
+	    yaffs_rd_chunk_tags_nand(dev, obj->hdr_chunk, (u8 *) buffer, &tags);
+
+	if (result != YAFFS_OK)
+		retval = -ENOENT;
+	else {
+		x_buffer = buffer + x_offs;
+
+		if (!obj->xattr_known) {
+			obj->has_xattr = nval_hasvalues(x_buffer, x_size);
+			obj->xattr_known = 1;
+		}
+
+		if (name)
+			retval = nval_get(x_buffer, x_size, name, value, size);
+		else
+			retval = nval_list(x_buffer, x_size, value, size);
+	}
+	yaffs_release_temp_buffer(dev, (u8 *) buffer, __LINE__);
+	return retval;
+}
+
+int yaffs_set_xattrib(struct yaffs_obj *obj, const YCHAR * name,
+		      const void *value, int size, int flags)
+{
+	return yaffs_do_xattrib_mod(obj, 1, name, value, size, flags);
+}
+
+int yaffs_remove_xattrib(struct yaffs_obj *obj, const YCHAR * name)
+{
+	return yaffs_do_xattrib_mod(obj, 0, name, NULL, 0, 0);
+}
+
+int yaffs_get_xattrib(struct yaffs_obj *obj, const YCHAR * name, void *value,
+		      int size)
+{
+	return yaffs_do_xattrib_fetch(obj, name, value, size);
+}
+
+int yaffs_list_xattrib(struct yaffs_obj *obj, char *buffer, int size)
+{
+	return yaffs_do_xattrib_fetch(obj, NULL, buffer, size);
+}
+
+/*---------------------------- Initialisation code -------------------------------------- */
+
+static int yaffs_check_dev_fns(const struct yaffs_dev *dev)
+{
+
+	/* Common functions, gotta have */
+	if (!dev->param.erase_fn || !dev->param.initialise_flash_fn)
+		return 0;
+
+#ifdef CONFIG_YAFFS_YAFFS2
+
+	/* Can use the "with tags" style interface for yaffs1 or yaffs2 */
+	if (dev->param.write_chunk_tags_fn &&
+	    dev->param.read_chunk_tags_fn &&
+	    !dev->param.write_chunk_fn &&
+	    !dev->param.read_chunk_fn &&
+	    dev->param.bad_block_fn && dev->param.query_block_fn)
+		return 1;
+#endif
+
+	/* Can use the "spare" style interface for yaffs1 */
+	if (!dev->param.is_yaffs2 &&
+	    !dev->param.write_chunk_tags_fn &&
+	    !dev->param.read_chunk_tags_fn &&
+	    dev->param.write_chunk_fn &&
+	    dev->param.read_chunk_fn &&
+	    !dev->param.bad_block_fn && !dev->param.query_block_fn)
+		return 1;
+
+	return 0;		/* bad */
+}
+
+static int yaffs_create_initial_dir(struct yaffs_dev *dev)
+{
+	/* Initialise the unlinked, deleted, root and lost and found directories */
+
+	dev->lost_n_found = dev->root_dir = NULL;
+	dev->unlinked_dir = dev->del_dir = NULL;
+
+	dev->unlinked_dir =
+	    yaffs_create_fake_dir(dev, YAFFS_OBJECTID_UNLINKED, S_IFDIR);
+
+	dev->del_dir =
+	    yaffs_create_fake_dir(dev, YAFFS_OBJECTID_DELETED, S_IFDIR);
+
+	dev->root_dir =
+	    yaffs_create_fake_dir(dev, YAFFS_OBJECTID_ROOT,
+				  YAFFS_ROOT_MODE | S_IFDIR);
+	dev->lost_n_found =
+	    yaffs_create_fake_dir(dev, YAFFS_OBJECTID_LOSTNFOUND,
+				  YAFFS_LOSTNFOUND_MODE | S_IFDIR);
+
+	if (dev->lost_n_found && dev->root_dir && dev->unlinked_dir
+	    && dev->del_dir) {
+		yaffs_add_obj_to_dir(dev->root_dir, dev->lost_n_found);
+		return YAFFS_OK;
+	}
+
+	return YAFFS_FAIL;
+}
+
+int yaffs_guts_initialise(struct yaffs_dev *dev)
+{
+	int init_failed = 0;
+	unsigned x;
+	int bits;
+
+	T(YAFFS_TRACE_TRACING,
+	  (TSTR("yaffs: yaffs_guts_initialise()" TENDSTR)));
+
+	/* Check stuff that must be set */
+
+	if (!dev) {
+		T(YAFFS_TRACE_ALWAYS, (TSTR("yaffs: Need a device" TENDSTR)));
+		return YAFFS_FAIL;
+	}
+
+	dev->internal_start_block = dev->param.start_block;
+	dev->internal_end_block = dev->param.end_block;
+	dev->block_offset = 0;
+	dev->chunk_offset = 0;
+	dev->n_free_chunks = 0;
+
+	dev->gc_block = 0;
+
+	if (dev->param.start_block == 0) {
+		dev->internal_start_block = dev->param.start_block + 1;
+		dev->internal_end_block = dev->param.end_block + 1;
+		dev->block_offset = 1;
+		dev->chunk_offset = dev->param.chunks_per_block;
+	}
+
+	/* Check geometry parameters. */
+
+	if ((!dev->param.inband_tags && dev->param.is_yaffs2 && dev->param.total_bytes_per_chunk < 1024) || (!dev->param.is_yaffs2 && dev->param.total_bytes_per_chunk < 512) || (dev->param.inband_tags && !dev->param.is_yaffs2) || dev->param.chunks_per_block < 2 || dev->param.n_reserved_blocks < 2 || dev->internal_start_block <= 0 || dev->internal_end_block <= 0 || dev->internal_end_block <= (dev->internal_start_block + dev->param.n_reserved_blocks + 2)) {	/* otherwise it is too small */
+		T(YAFFS_TRACE_ALWAYS,
+		  (TSTR
+		   ("yaffs: NAND geometry problems: chunk size %d, type is yaffs%s, inband_tags %d "
+		    TENDSTR), dev->param.total_bytes_per_chunk,
+		   dev->param.is_yaffs2 ? "2" : "", dev->param.inband_tags));
+		return YAFFS_FAIL;
+	}
+
+	if (yaffs_init_nand(dev) != YAFFS_OK) {
+		T(YAFFS_TRACE_ALWAYS,
+		  (TSTR("yaffs: InitialiseNAND failed" TENDSTR)));
+		return YAFFS_FAIL;
+	}
+
+	/* Sort out space for inband tags, if required */
+	if (dev->param.inband_tags)
+		dev->data_bytes_per_chunk =
+		    dev->param.total_bytes_per_chunk -
+		    sizeof(struct yaffs_packed_tags2_tags_only);
+	else
+		dev->data_bytes_per_chunk = dev->param.total_bytes_per_chunk;
+
+	/* Got the right mix of functions? */
+	if (!yaffs_check_dev_fns(dev)) {
+		/* Function missing */
+		T(YAFFS_TRACE_ALWAYS,
+		  (TSTR
+		   ("yaffs: device function(s) missing or wrong\n" TENDSTR)));
+
+		return YAFFS_FAIL;
+	}
+
+	if (dev->is_mounted) {
+		T(YAFFS_TRACE_ALWAYS,
+		  (TSTR("yaffs: device already mounted\n" TENDSTR)));
+		return YAFFS_FAIL;
+	}
+
+	/* Finished with most checks. One or two more checks happen later on too. */
+
+	dev->is_mounted = 1;
+
+	/* OK now calculate a few things for the device */
+
+	/*
+	 *  Calculate all the chunk size manipulation numbers:
+	 */
+	x = dev->data_bytes_per_chunk;
+	/* We always use dev->chunk_shift and dev->chunk_div */
+	dev->chunk_shift = calc_shifts(x);
+	x >>= dev->chunk_shift;
+	dev->chunk_div = x;
+	/* We only use chunk mask if chunk_div is 1 */
+	dev->chunk_mask = (1 << dev->chunk_shift) - 1;
+
+	/*
+	 * Calculate chunk_grp_bits.
+	 * We need to find the next power of 2 > than internal_end_block
+	 */
+
+	x = dev->param.chunks_per_block * (dev->internal_end_block + 1);
+
+	bits = calc_shifts_ceiling(x);
+
+	/* Set up tnode width if wide tnodes are enabled. */
+	if (!dev->param.wide_tnodes_disabled) {
+		/* bits must be even so that we end up with 32-bit words */
+		if (bits & 1)
+			bits++;
+		if (bits < 16)
+			dev->tnode_width = 16;
+		else
+			dev->tnode_width = bits;
+	} else {
+		dev->tnode_width = 16;
+        }
+
+	dev->tnode_mask = (1 << dev->tnode_width) - 1;
+
+	/* Level0 Tnodes are 16 bits or wider (if wide tnodes are enabled),
+	 * so if the bitwidth of the
+	 * chunk range we're using is greater than 16 we need
+	 * to figure out chunk shift and chunk_grp_size
+	 */
+
+	if (bits <= dev->tnode_width)
+		dev->chunk_grp_bits = 0;
+	else
+		dev->chunk_grp_bits = bits - dev->tnode_width;
+
+	dev->tnode_size = (dev->tnode_width * YAFFS_NTNODES_LEVEL0) / 8;
+	if (dev->tnode_size < sizeof(struct yaffs_tnode))
+		dev->tnode_size = sizeof(struct yaffs_tnode);
+
+	dev->chunk_grp_size = 1 << dev->chunk_grp_bits;
+
+	if (dev->param.chunks_per_block < dev->chunk_grp_size) {
+		/* We have a problem because the soft delete won't work if
+		 * the chunk group size > chunks per block.
+		 * This can be remedied by using larger "virtual blocks".
+		 */
+		T(YAFFS_TRACE_ALWAYS,
+		  (TSTR("yaffs: chunk group too large\n" TENDSTR)));
+
+		return YAFFS_FAIL;
+	}
+
+	/* OK, we've finished verifying the device, lets continue with initialisation */
+
+	/* More device initialisation */
+	dev->all_gcs = 0;
+	dev->passive_gc_count = 0;
+	dev->oldest_dirty_gc_count = 0;
+	dev->bg_gcs = 0;
+	dev->gc_block_finder = 0;
+	dev->buffered_block = -1;
+	dev->doing_buffered_block_rewrite = 0;
+	dev->n_deleted_files = 0;
+	dev->n_bg_deletions = 0;
+	dev->n_unlinked_files = 0;
+	dev->n_ecc_fixed = 0;
+	dev->n_ecc_unfixed = 0;
+	dev->n_tags_ecc_fixed = 0;
+	dev->n_tags_ecc_unfixed = 0;
+	dev->n_erase_failures = 0;
+	dev->n_erased_blocks = 0;
+	dev->gc_disable = 0;
+	dev->has_pending_prioritised_gc = 1;	/* Assume the worst for now, will get fixed on first GC */
+	INIT_LIST_HEAD(&dev->dirty_dirs);
+	dev->oldest_dirty_seq = 0;
+	dev->oldest_dirty_block = 0;
+
+	/* Initialise temporary buffers and caches. */
+	if (!yaffs_init_tmp_buffers(dev))
+		init_failed = 1;
+
+	dev->cache = NULL;
+	dev->gc_cleanup_list = NULL;
+
+	if (!init_failed && dev->param.n_caches > 0) {
+		int i;
+		void *buf;
+		int cache_bytes =
+		    dev->param.n_caches * sizeof(struct yaffs_cache);
+
+		if (dev->param.n_caches > YAFFS_MAX_SHORT_OP_CACHES)
+			dev->param.n_caches = YAFFS_MAX_SHORT_OP_CACHES;
+
+		dev->cache = YMALLOC(cache_bytes);
+
+		buf = (u8 *) dev->cache;
+
+		if (dev->cache)
+			memset(dev->cache, 0, cache_bytes);
+
+		for (i = 0; i < dev->param.n_caches && buf; i++) {
+			dev->cache[i].object = NULL;
+			dev->cache[i].last_use = 0;
+			dev->cache[i].dirty = 0;
+			dev->cache[i].data = buf =
+			    YMALLOC_DMA(dev->param.total_bytes_per_chunk);
+		}
+		if (!buf)
+			init_failed = 1;
+
+		dev->cache_last_use = 0;
+	}
+
+	dev->cache_hits = 0;
+
+	if (!init_failed) {
+		dev->gc_cleanup_list =
+		    YMALLOC(dev->param.chunks_per_block * sizeof(u32));
+		if (!dev->gc_cleanup_list)
+			init_failed = 1;
+	}
+
+	if (dev->param.is_yaffs2)
+		dev->param.use_header_file_size = 1;
+
+	if (!init_failed && !yaffs_init_blocks(dev))
+		init_failed = 1;
+
+	yaffs_init_tnodes_and_objs(dev);
+
+	if (!init_failed && !yaffs_create_initial_dir(dev))
+		init_failed = 1;
+
+	if (!init_failed) {
+		/* Now scan the flash. */
+		if (dev->param.is_yaffs2) {
+			if (yaffs2_checkpt_restore(dev)) {
+				yaffs_check_obj_details_loaded(dev->root_dir);
+				T(YAFFS_TRACE_CHECKPOINT | YAFFS_TRACE_MOUNT,
+				  (TSTR
+				   ("yaffs: restored from checkpoint"
+				    TENDSTR)));
+			} else {
+
+				/* Clean up the mess caused by an aborted checkpoint load
+				 * and scan backwards.
+				 */
+				yaffs_deinit_blocks(dev);
+
+				yaffs_deinit_tnodes_and_objs(dev);
+
+				dev->n_erased_blocks = 0;
+				dev->n_free_chunks = 0;
+				dev->alloc_block = -1;
+				dev->alloc_page = -1;
+				dev->n_deleted_files = 0;
+				dev->n_unlinked_files = 0;
+				dev->n_bg_deletions = 0;
+
+				if (!init_failed && !yaffs_init_blocks(dev))
+					init_failed = 1;
+
+				yaffs_init_tnodes_and_objs(dev);
+
+				if (!init_failed
+				    && !yaffs_create_initial_dir(dev))
+					init_failed = 1;
+
+				if (!init_failed && !yaffs2_scan_backwards(dev))
+					init_failed = 1;
+			}
+		} else if (!yaffs1_scan(dev)) {
+			init_failed = 1;
+                }
+
+		yaffs_strip_deleted_objs(dev);
+		yaffs_fix_hanging_objs(dev);
+		if (dev->param.empty_lost_n_found)
+			yaffs_empty_l_n_f(dev);
+	}
+
+	if (init_failed) {
+		/* Clean up the mess */
+		T(YAFFS_TRACE_TRACING,
+		  (TSTR("yaffs: yaffs_guts_initialise() aborted.\n" TENDSTR)));
+
+		yaffs_deinitialise(dev);
+		return YAFFS_FAIL;
+	}
+
+	/* Zero out stats */
+	dev->n_page_reads = 0;
+	dev->n_page_writes = 0;
+	dev->n_erasures = 0;
+	dev->n_gc_copies = 0;
+	dev->n_retired_writes = 0;
+
+	dev->n_retired_blocks = 0;
+
+	yaffs_verify_free_chunks(dev);
+	yaffs_verify_blocks(dev);
+
+	/* Clean up any aborted checkpoint data */
+	if (!dev->is_checkpointed && dev->blocks_in_checkpt > 0)
+		yaffs2_checkpt_invalidate(dev);
+
+	T(YAFFS_TRACE_TRACING,
+	  (TSTR("yaffs: yaffs_guts_initialise() done.\n" TENDSTR)));
+	return YAFFS_OK;
+
+}
+
+void yaffs_deinitialise(struct yaffs_dev *dev)
+{
+	if (dev->is_mounted) {
+		int i;
+
+		yaffs_deinit_blocks(dev);
+		yaffs_deinit_tnodes_and_objs(dev);
+		if (dev->param.n_caches > 0 && dev->cache) {
+
+			for (i = 0; i < dev->param.n_caches; i++) {
+				if (dev->cache[i].data)
+					YFREE(dev->cache[i].data);
+				dev->cache[i].data = NULL;
+			}
+
+			YFREE(dev->cache);
+			dev->cache = NULL;
+		}
+
+		YFREE(dev->gc_cleanup_list);
+
+		for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++)
+			YFREE(dev->temp_buffer[i].buffer);
+
+		dev->is_mounted = 0;
+
+		if (dev->param.deinitialise_flash_fn)
+			dev->param.deinitialise_flash_fn(dev);
+	}
+}
+
+int yaffs_count_free_chunks(struct yaffs_dev *dev)
+{
+	int n_free = 0;
+	int b;
+
+	struct yaffs_block_info *blk;
+
+	blk = dev->block_info;
+	for (b = dev->internal_start_block; b <= dev->internal_end_block; b++) {
+		switch (blk->block_state) {
+		case YAFFS_BLOCK_STATE_EMPTY:
+		case YAFFS_BLOCK_STATE_ALLOCATING:
+		case YAFFS_BLOCK_STATE_COLLECTING:
+		case YAFFS_BLOCK_STATE_FULL:
+			n_free +=
+			    (dev->param.chunks_per_block - blk->pages_in_use +
+			     blk->soft_del_pages);
+			break;
+		default:
+			break;
+		}
+		blk++;
+	}
+
+	return n_free;
+}
+
+int yaffs_get_n_free_chunks(struct yaffs_dev *dev)
+{
+	/* This is what we report to the outside world */
+
+	int n_free;
+	int n_dirty_caches;
+	int blocks_for_checkpt;
+	int i;
+
+	n_free = dev->n_free_chunks;
+	n_free += dev->n_deleted_files;
+
+	/* Now count the number of dirty chunks in the cache and subtract those */
+
+	for (n_dirty_caches = 0, i = 0; i < dev->param.n_caches; i++) {
+		if (dev->cache[i].dirty)
+			n_dirty_caches++;
+	}
+
+	n_free -= n_dirty_caches;
+
+	n_free -=
+	    ((dev->param.n_reserved_blocks + 1) * dev->param.chunks_per_block);
+
+	/* Now we figure out how much to reserve for the checkpoint and report that... */
+	blocks_for_checkpt = yaffs_calc_checkpt_blocks_required(dev);
+
+	n_free -= (blocks_for_checkpt * dev->param.chunks_per_block);
+
+	if (n_free < 0)
+		n_free = 0;
+
+	return n_free;
+
+}
diff --git a/fs/yaffs2/yaffs_guts.h b/fs/yaffs2/yaffs_guts.h
new file mode 100644
index 0000000..307eba2
--- /dev/null
+++ b/fs/yaffs2/yaffs_guts.h
@@ -0,0 +1,915 @@
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
+#ifndef __YAFFS_GUTS_H__
+#define __YAFFS_GUTS_H__
+
+#include "yportenv.h"
+
+#define YAFFS_OK	1
+#define YAFFS_FAIL  0
+
+/* Give us a  Y=0x59,
+ * Give us an A=0x41,
+ * Give us an FF=0xFF
+ * Give us an S=0x53
+ * And what have we got...
+ */
+#define YAFFS_MAGIC			0x5941FF53
+
+#define YAFFS_NTNODES_LEVEL0	  	16
+#define YAFFS_TNODES_LEVEL0_BITS	4
+#define YAFFS_TNODES_LEVEL0_MASK	0xf
+
+#define YAFFS_NTNODES_INTERNAL 		(YAFFS_NTNODES_LEVEL0 / 2)
+#define YAFFS_TNODES_INTERNAL_BITS 	(YAFFS_TNODES_LEVEL0_BITS - 1)
+#define YAFFS_TNODES_INTERNAL_MASK	0x7
+#define YAFFS_TNODES_MAX_LEVEL		6
+
+#ifndef CONFIG_YAFFS_NO_YAFFS1
+#define YAFFS_BYTES_PER_SPARE		16
+#define YAFFS_BYTES_PER_CHUNK		512
+#define YAFFS_CHUNK_SIZE_SHIFT		9
+#define YAFFS_CHUNKS_PER_BLOCK		32
+#define YAFFS_BYTES_PER_BLOCK		(YAFFS_CHUNKS_PER_BLOCK*YAFFS_BYTES_PER_CHUNK)
+#endif
+
+#define YAFFS_MIN_YAFFS2_CHUNK_SIZE 	1024
+#define YAFFS_MIN_YAFFS2_SPARE_SIZE	32
+
+#define YAFFS_MAX_CHUNK_ID		0x000FFFFF
+
+#define YAFFS_ALLOCATION_NOBJECTS	100
+#define YAFFS_ALLOCATION_NTNODES	100
+#define YAFFS_ALLOCATION_NLINKS		100
+
+#define YAFFS_NOBJECT_BUCKETS		256
+
+#define YAFFS_OBJECT_SPACE		0x40000
+#define YAFFS_MAX_OBJECT_ID		(YAFFS_OBJECT_SPACE -1)
+
+#define YAFFS_CHECKPOINT_VERSION 	4
+
+#ifdef CONFIG_YAFFS_UNICODE
+#define YAFFS_MAX_NAME_LENGTH		127
+#define YAFFS_MAX_ALIAS_LENGTH		79
+#else
+#define YAFFS_MAX_NAME_LENGTH		255
+#define YAFFS_MAX_ALIAS_LENGTH		159
+#endif
+
+#define YAFFS_SHORT_NAME_LENGTH		15
+
+/* Some special object ids for pseudo objects */
+#define YAFFS_OBJECTID_ROOT		1
+#define YAFFS_OBJECTID_LOSTNFOUND	2
+#define YAFFS_OBJECTID_UNLINKED		3
+#define YAFFS_OBJECTID_DELETED		4
+
+/* Pseudo object ids for checkpointing */
+#define YAFFS_OBJECTID_SB_HEADER	0x10
+#define YAFFS_OBJECTID_CHECKPOINT_DATA	0x20
+#define YAFFS_SEQUENCE_CHECKPOINT_DATA  0x21
+
+#define YAFFS_MAX_SHORT_OP_CACHES	20
+
+#define YAFFS_N_TEMP_BUFFERS		6
+
+/* We limit the number attempts at sucessfully saving a chunk of data.
+ * Small-page devices have 32 pages per block; large-page devices have 64.
+ * Default to something in the order of 5 to 10 blocks worth of chunks.
+ */
+#define YAFFS_WR_ATTEMPTS		(5*64)
+
+/* Sequence numbers are used in YAFFS2 to determine block allocation order.
+ * The range is limited slightly to help distinguish bad numbers from good.
+ * This also allows us to perhaps in the future use special numbers for
+ * special purposes.
+ * EFFFFF00 allows the allocation of 8 blocks per second (~1Mbytes) for 15 years,
+ * and is a larger number than the lifetime of a 2GB device.
+ */
+#define YAFFS_LOWEST_SEQUENCE_NUMBER	0x00001000
+#define YAFFS_HIGHEST_SEQUENCE_NUMBER	0xEFFFFF00
+
+/* Special sequence number for bad block that failed to be marked bad */
+#define YAFFS_SEQUENCE_BAD_BLOCK	0xFFFF0000
+
+/* ChunkCache is used for short read/write operations.*/
+struct yaffs_cache {
+	struct yaffs_obj *object;
+	int chunk_id;
+	int last_use;
+	int dirty;
+	int n_bytes;		/* Only valid if the cache is dirty */
+	int locked;		/* Can't push out or flush while locked. */
+	u8 *data;
+};
+
+/* Tags structures in RAM
+ * NB This uses bitfield. Bitfields should not straddle a u32 boundary otherwise
+ * the structure size will get blown out.
+ */
+
+#ifndef CONFIG_YAFFS_NO_YAFFS1
+struct yaffs_tags {
+	unsigned chunk_id:20;
+	unsigned serial_number:2;
+	unsigned n_bytes_lsb:10;
+	unsigned obj_id:18;
+	unsigned ecc:12;
+	unsigned n_bytes_msb:2;
+};
+
+union yaffs_tags_union {
+	struct yaffs_tags as_tags;
+	u8 as_bytes[8];
+};
+
+#endif
+
+/* Stuff used for extended tags in YAFFS2 */
+
+enum yaffs_ecc_result {
+	YAFFS_ECC_RESULT_UNKNOWN,
+	YAFFS_ECC_RESULT_NO_ERROR,
+	YAFFS_ECC_RESULT_FIXED,
+	YAFFS_ECC_RESULT_UNFIXED
+};
+
+enum yaffs_obj_type {
+	YAFFS_OBJECT_TYPE_UNKNOWN,
+	YAFFS_OBJECT_TYPE_FILE,
+	YAFFS_OBJECT_TYPE_SYMLINK,
+	YAFFS_OBJECT_TYPE_DIRECTORY,
+	YAFFS_OBJECT_TYPE_HARDLINK,
+	YAFFS_OBJECT_TYPE_SPECIAL
+};
+
+#define YAFFS_OBJECT_TYPE_MAX YAFFS_OBJECT_TYPE_SPECIAL
+
+struct yaffs_ext_tags {
+
+	unsigned validity0;
+	unsigned chunk_used;	/*  Status of the chunk: used or unused */
+	unsigned obj_id;	/* If 0 then this is not part of an object (unused) */
+	unsigned chunk_id;	/* If 0 then this is a header, else a data chunk */
+	unsigned n_bytes;	/* Only valid for data chunks */
+
+	/* The following stuff only has meaning when we read */
+	enum yaffs_ecc_result ecc_result;
+	unsigned block_bad;
+
+	/* YAFFS 1 stuff */
+	unsigned is_deleted;	/* The chunk is marked deleted */
+	unsigned serial_number;	/* Yaffs1 2-bit serial number */
+
+	/* YAFFS2 stuff */
+	unsigned seq_number;	/* The sequence number of this block */
+
+	/* Extra info if this is an object header (YAFFS2 only) */
+
+	unsigned extra_available;	/* There is extra info available if this is not zero */
+	unsigned extra_parent_id;	/* The parent object */
+	unsigned extra_is_shrink;	/* Is it a shrink header? */
+	unsigned extra_shadows;	/* Does this shadow another object? */
+
+	enum yaffs_obj_type extra_obj_type;	/* What object type? */
+
+	unsigned extra_length;	/* Length if it is a file */
+	unsigned extra_equiv_id;	/* Equivalent object Id if it is a hard link */
+
+	unsigned validity1;
+
+};
+
+/* Spare structure for YAFFS1 */
+struct yaffs_spare {
+	u8 tb0;
+	u8 tb1;
+	u8 tb2;
+	u8 tb3;
+	u8 page_status;		/* set to 0 to delete the chunk */
+	u8 block_status;
+	u8 tb4;
+	u8 tb5;
+	u8 ecc1[3];
+	u8 tb6;
+	u8 tb7;
+	u8 ecc2[3];
+};
+
+/*Special structure for passing through to mtd */
+struct yaffs_nand_spare {
+	struct yaffs_spare spare;
+	int eccres1;
+	int eccres2;
+};
+
+/* Block data in RAM */
+
+enum yaffs_block_state {
+	YAFFS_BLOCK_STATE_UNKNOWN = 0,
+
+	YAFFS_BLOCK_STATE_SCANNING,
+	/* Being scanned */
+
+	YAFFS_BLOCK_STATE_NEEDS_SCANNING,
+	/* The block might have something on it (ie it is allocating or full, perhaps empty)
+	 * but it needs to be scanned to determine its true state.
+	 * This state is only valid during scanning.
+	 * NB We tolerate empty because the pre-scanner might be incapable of deciding
+	 * However, if this state is returned on a YAFFS2 device, then we expect a sequence number
+	 */
+
+	YAFFS_BLOCK_STATE_EMPTY,
+	/* This block is empty */
+
+	YAFFS_BLOCK_STATE_ALLOCATING,
+	/* This block is partially allocated.
+	 * At least one page holds valid data.
+	 * This is the one currently being used for page
+	 * allocation. Should never be more than one of these.
+	 * If a block is only partially allocated at mount it is treated as full.
+	 */
+
+	YAFFS_BLOCK_STATE_FULL,
+	/* All the pages in this block have been allocated.
+	 * If a block was only partially allocated when mounted we treat
+	 * it as fully allocated.
+	 */
+
+	YAFFS_BLOCK_STATE_DIRTY,
+	/* The block was full and now all chunks have been deleted.
+	 * Erase me, reuse me.
+	 */
+
+	YAFFS_BLOCK_STATE_CHECKPOINT,
+	/* This block is assigned to holding checkpoint data. */
+
+	YAFFS_BLOCK_STATE_COLLECTING,
+	/* This block is being garbage collected */
+
+	YAFFS_BLOCK_STATE_DEAD
+	    /* This block has failed and is not in use */
+};
+
+#define	YAFFS_NUMBER_OF_BLOCK_STATES (YAFFS_BLOCK_STATE_DEAD + 1)
+
+struct yaffs_block_info {
+
+	int soft_del_pages:10;	/* number of soft deleted pages */
+	int pages_in_use:10;	/* number of pages in use */
+	unsigned block_state:4;	/* One of the above block states. NB use unsigned because enum is sometimes an int */
+	u32 needs_retiring:1;	/* Data has failed on this block, need to get valid data off */
+	/* and retire the block. */
+	u32 skip_erased_check:1;	/* If this is set we can skip the erased check on this block */
+	u32 gc_prioritise:1;	/* An ECC check or blank check has failed on this block.
+				   It should be prioritised for GC */
+	u32 chunk_error_strikes:3;	/* How many times we've had ecc etc failures on this block and tried to reuse it */
+
+#ifdef CONFIG_YAFFS_YAFFS2
+	u32 has_shrink_hdr:1;	/* This block has at least one shrink object header */
+	u32 seq_number;		/* block sequence number for yaffs2 */
+#endif
+
+};
+
+/* -------------------------- Object structure -------------------------------*/
+/* This is the object structure as stored on NAND */
+
+struct yaffs_obj_hdr {
+	enum yaffs_obj_type type;
+
+	/* Apply to everything  */
+	int parent_obj_id;
+	u16 sum_no_longer_used;	/* checksum of name. No longer used */
+	YCHAR name[YAFFS_MAX_NAME_LENGTH + 1];
+
+	/* The following apply to directories, files, symlinks - not hard links */
+	u32 yst_mode;		/* protection */
+
+	u32 yst_uid;
+	u32 yst_gid;
+	u32 yst_atime;
+	u32 yst_mtime;
+	u32 yst_ctime;
+
+	/* File size  applies to files only */
+	int file_size;
+
+	/* Equivalent object id applies to hard links only. */
+	int equiv_id;
+
+	/* Alias is for symlinks only. */
+	YCHAR alias[YAFFS_MAX_ALIAS_LENGTH + 1];
+
+	u32 yst_rdev;		/* device stuff for block and char devices (major/min) */
+
+	u32 win_ctime[2];
+	u32 win_atime[2];
+	u32 win_mtime[2];
+
+	u32 inband_shadowed_obj_id;
+	u32 inband_is_shrink;
+
+	u32 reserved[2];
+	int shadows_obj;	/* This object header shadows the specified object if > 0 */
+
+	/* is_shrink applies to object headers written when we shrink the file (ie resize) */
+	u32 is_shrink;
+
+};
+
+/*--------------------------- Tnode -------------------------- */
+
+struct yaffs_tnode {
+	struct yaffs_tnode *internal[YAFFS_NTNODES_INTERNAL];
+};
+
+/*------------------------  Object -----------------------------*/
+/* An object can be one of:
+ * - a directory (no data, has children links
+ * - a regular file (data.... not prunes :->).
+ * - a symlink [symbolic link] (the alias).
+ * - a hard link
+ */
+
+struct yaffs_file_var {
+	u32 file_size;
+	u32 scanned_size;
+	u32 shrink_size;
+	int top_level;
+	struct yaffs_tnode *top;
+};
+
+struct yaffs_dir_var {
+	struct list_head children;	/* list of child links */
+	struct list_head dirty;	/* Entry for list of dirty directories */
+};
+
+struct yaffs_symlink_var {
+	YCHAR *alias;
+};
+
+struct yaffs_hardlink_var {
+	struct yaffs_obj *equiv_obj;
+	u32 equiv_id;
+};
+
+union yaffs_obj_var {
+	struct yaffs_file_var file_variant;
+	struct yaffs_dir_var dir_variant;
+	struct yaffs_symlink_var symlink_variant;
+	struct yaffs_hardlink_var hardlink_variant;
+};
+
+struct yaffs_obj {
+	u8 deleted:1;		/* This should only apply to unlinked files. */
+	u8 soft_del:1;		/* it has also been soft deleted */
+	u8 unlinked:1;		/* An unlinked file. The file should be in the unlinked directory. */
+	u8 fake:1;		/* A fake object has no presence on NAND. */
+	u8 rename_allowed:1;	/* Some objects are not allowed to be renamed. */
+	u8 unlink_allowed:1;
+	u8 dirty:1;		/* the object needs to be written to flash */
+	u8 valid:1;		/* When the file system is being loaded up, this
+				 * object might be created before the data
+				 * is available (ie. file data records appear before the header).
+				 */
+	u8 lazy_loaded:1;	/* This object has been lazy loaded and is missing some detail */
+
+	u8 defered_free:1;	/* For Linux kernel. Object is removed from NAND, but is
+				 * still in the inode cache. Free of object is defered.
+				 * until the inode is released.
+				 */
+	u8 being_created:1;	/* This object is still being created so skip some checks. */
+	u8 is_shadowed:1;	/* This object is shadowed on the way to being renamed. */
+
+	u8 xattr_known:1;	/* We know if this has object has xattribs or not. */
+	u8 has_xattr:1;		/* This object has xattribs. Valid if xattr_known. */
+
+	u8 serial;		/* serial number of chunk in NAND. Cached here */
+	u16 sum;		/* sum of the name to speed searching */
+
+	struct yaffs_dev *my_dev;	/* The device I'm on */
+
+	struct list_head hash_link;	/* list of objects in this hash bucket */
+
+	struct list_head hard_links;	/* all the equivalent hard linked objects */
+
+	/* directory structure stuff */
+	/* also used for linking up the free list */
+	struct yaffs_obj *parent;
+	struct list_head siblings;
+
+	/* Where's my object header in NAND? */
+	int hdr_chunk;
+
+	int n_data_chunks;	/* Number of data chunks attached to the file. */
+
+	u32 obj_id;		/* the object id value */
+
+	u32 yst_mode;
+
+#ifndef CONFIG_YAFFS_NO_SHORT_NAMES
+	YCHAR short_name[YAFFS_SHORT_NAME_LENGTH + 1];
+#endif
+
+#ifdef CONFIG_YAFFS_WINCE
+	u32 win_ctime[2];
+	u32 win_mtime[2];
+	u32 win_atime[2];
+#else
+	u32 yst_uid;
+	u32 yst_gid;
+	u32 yst_atime;
+	u32 yst_mtime;
+	u32 yst_ctime;
+#endif
+
+	u32 yst_rdev;
+
+	void *my_inode;
+
+	enum yaffs_obj_type variant_type;
+
+	union yaffs_obj_var variant;
+
+};
+
+struct yaffs_obj_bucket {
+	struct list_head list;
+	int count;
+};
+
+/* yaffs_checkpt_obj holds the definition of an object as dumped
+ * by checkpointing.
+ */
+
+struct yaffs_checkpt_obj {
+	int struct_type;
+	u32 obj_id;
+	u32 parent_id;
+	int hdr_chunk;
+	enum yaffs_obj_type variant_type:3;
+	u8 deleted:1;
+	u8 soft_del:1;
+	u8 unlinked:1;
+	u8 fake:1;
+	u8 rename_allowed:1;
+	u8 unlink_allowed:1;
+	u8 serial;
+	int n_data_chunks;
+	u32 size_or_equiv_obj;
+};
+
+/*--------------------- Temporary buffers ----------------
+ *
+ * These are chunk-sized working buffers. Each device has a few
+ */
+
+struct yaffs_buffer {
+	u8 *buffer;
+	int line;		/* track from whence this buffer was allocated */
+	int max_line;
+};
+
+/*----------------- Device ---------------------------------*/
+
+struct yaffs_param {
+	const YCHAR *name;
+
+	/*
+	 * Entry parameters set up way early. Yaffs sets up the rest.
+	 * The structure should be zeroed out before use so that unused
+	 * and defualt values are zero.
+	 */
+
+	int inband_tags;	/* Use unband tags */
+	u32 total_bytes_per_chunk;	/* Should be >= 512, does not need to be a power of 2 */
+	int chunks_per_block;	/* does not need to be a power of 2 */
+	int spare_bytes_per_chunk;	/* spare area size */
+	int start_block;	/* Start block we're allowed to use */
+	int end_block;		/* End block we're allowed to use */
+	int n_reserved_blocks;	/* We want this tuneable so that we can reduce */
+	/* reserved blocks on NOR and RAM. */
+
+	int n_caches;		/* If <= 0, then short op caching is disabled, else
+				 * the number of short op caches (don't use too many).
+				 * 10 to 20 is a good bet.
+				 */
+	int use_nand_ecc;	/* Flag to decide whether or not to use NANDECC on data (yaffs1) */
+	int no_tags_ecc;	/* Flag to decide whether or not to do ECC on packed tags (yaffs2) */
+
+	int is_yaffs2;		/* Use yaffs2 mode on this device */
+
+	int empty_lost_n_found;	/* Auto-empty lost+found directory on mount */
+
+	int refresh_period;	/* How often we should check to do a block refresh */
+
+	/* Checkpoint control. Can be set before or after initialisation */
+	u8 skip_checkpt_rd;
+	u8 skip_checkpt_wr;
+
+	int enable_xattr;	/* Enable xattribs */
+
+	/* NAND access functions (Must be set before calling YAFFS) */
+
+	int (*write_chunk_fn) (struct yaffs_dev * dev,
+			       int nand_chunk, const u8 * data,
+			       const struct yaffs_spare * spare);
+	int (*read_chunk_fn) (struct yaffs_dev * dev,
+			      int nand_chunk, u8 * data,
+			      struct yaffs_spare * spare);
+	int (*erase_fn) (struct yaffs_dev * dev, int flash_block);
+	int (*initialise_flash_fn) (struct yaffs_dev * dev);
+	int (*deinitialise_flash_fn) (struct yaffs_dev * dev);
+
+#ifdef CONFIG_YAFFS_YAFFS2
+	int (*write_chunk_tags_fn) (struct yaffs_dev * dev,
+				    int nand_chunk, const u8 * data,
+				    const struct yaffs_ext_tags * tags);
+	int (*read_chunk_tags_fn) (struct yaffs_dev * dev,
+				   int nand_chunk, u8 * data,
+				   struct yaffs_ext_tags * tags);
+	int (*bad_block_fn) (struct yaffs_dev * dev, int block_no);
+	int (*query_block_fn) (struct yaffs_dev * dev, int block_no,
+			       enum yaffs_block_state * state,
+			       u32 * seq_number);
+#endif
+
+	/* The remove_obj_fn function must be supplied by OS flavours that
+	 * need it.
+	 * yaffs direct uses it to implement the faster readdir.
+	 * Linux uses it to protect the directory during unlocking.
+	 */
+	void (*remove_obj_fn) (struct yaffs_obj * obj);
+
+	/* Callback to mark the superblock dirty */
+	void (*sb_dirty_fn) (struct yaffs_dev * dev);
+
+	/*  Callback to control garbage collection. */
+	unsigned (*gc_control) (struct yaffs_dev * dev);
+
+	/* Debug control flags. Don't use unless you know what you're doing */
+	int use_header_file_size;	/* Flag to determine if we should use file sizes from the header */
+	int disable_lazy_load;	/* Disable lazy loading on this device */
+	int wide_tnodes_disabled;	/* Set to disable wide tnodes */
+	int disable_soft_del;	/* yaffs 1 only: Set to disable the use of softdeletion. */
+
+	int defered_dir_update;	/* Set to defer directory updates */
+
+#ifdef CONFIG_YAFFS_AUTO_UNICODE
+	int auto_unicode;
+#endif
+	int always_check_erased;	/* Force chunk erased check always on */
+};
+
+struct yaffs_dev {
+	struct yaffs_param param;
+
+	/* Context storage. Holds extra OS specific data for this device */
+
+	void *os_context;
+	void *driver_context;
+
+	struct list_head dev_list;
+
+	/* Runtime parameters. Set up by YAFFS. */
+	int data_bytes_per_chunk;
+
+	/* Non-wide tnode stuff */
+	u16 chunk_grp_bits;	/* Number of bits that need to be resolved if
+				 * the tnodes are not wide enough.
+				 */
+	u16 chunk_grp_size;	/* == 2^^chunk_grp_bits */
+
+	/* Stuff to support wide tnodes */
+	u32 tnode_width;
+	u32 tnode_mask;
+	u32 tnode_size;
+
+	/* Stuff for figuring out file offset to chunk conversions */
+	u32 chunk_shift;	/* Shift value */
+	u32 chunk_div;		/* Divisor after shifting: 1 for power-of-2 sizes */
+	u32 chunk_mask;		/* Mask to use for power-of-2 case */
+
+	int is_mounted;
+	int read_only;
+	int is_checkpointed;
+
+	/* Stuff to support block offsetting to support start block zero */
+	int internal_start_block;
+	int internal_end_block;
+	int block_offset;
+	int chunk_offset;
+
+	/* Runtime checkpointing stuff */
+	int checkpt_page_seq;	/* running sequence number of checkpoint pages */
+	int checkpt_byte_count;
+	int checkpt_byte_offs;
+	u8 *checkpt_buffer;
+	int checkpt_open_write;
+	int blocks_in_checkpt;
+	int checkpt_cur_chunk;
+	int checkpt_cur_block;
+	int checkpt_next_block;
+	int *checkpt_block_list;
+	int checkpt_max_blocks;
+	u32 checkpt_sum;
+	u32 checkpt_xor;
+
+	int checkpoint_blocks_required;	/* Number of blocks needed to store current checkpoint set */
+
+	/* Block Info */
+	struct yaffs_block_info *block_info;
+	u8 *chunk_bits;		/* bitmap of chunks in use */
+	unsigned block_info_alt:1;	/* was allocated using alternative strategy */
+	unsigned chunk_bits_alt:1;	/* was allocated using alternative strategy */
+	int chunk_bit_stride;	/* Number of bytes of chunk_bits per block.
+				 * Must be consistent with chunks_per_block.
+				 */
+
+	int n_erased_blocks;
+	int alloc_block;	/* Current block being allocated off */
+	u32 alloc_page;
+	int alloc_block_finder;	/* Used to search for next allocation block */
+
+	/* Object and Tnode memory management */
+	void *allocator;
+	int n_obj;
+	int n_tnodes;
+
+	int n_hardlinks;
+
+	struct yaffs_obj_bucket obj_bucket[YAFFS_NOBJECT_BUCKETS];
+	u32 bucket_finder;
+
+	int n_free_chunks;
+
+	/* Garbage collection control */
+	u32 *gc_cleanup_list;	/* objects to delete at the end of a GC. */
+	u32 n_clean_ups;
+
+	unsigned has_pending_prioritised_gc;	/* We think this device might have pending prioritised gcs */
+	unsigned gc_disable;
+	unsigned gc_block_finder;
+	unsigned gc_dirtiest;
+	unsigned gc_pages_in_use;
+	unsigned gc_not_done;
+	unsigned gc_block;
+	unsigned gc_chunk;
+	unsigned gc_skip;
+
+	/* Special directories */
+	struct yaffs_obj *root_dir;
+	struct yaffs_obj *lost_n_found;
+
+	/* Buffer areas for storing data to recover from write failures TODO
+	 *      u8            buffered_data[YAFFS_CHUNKS_PER_BLOCK][YAFFS_BYTES_PER_CHUNK];
+	 *      struct yaffs_spare buffered_spare[YAFFS_CHUNKS_PER_BLOCK];
+	 */
+
+	int buffered_block;	/* Which block is buffered here? */
+	int doing_buffered_block_rewrite;
+
+	struct yaffs_cache *cache;
+	int cache_last_use;
+
+	/* Stuff for background deletion and unlinked files. */
+	struct yaffs_obj *unlinked_dir;	/* Directory where unlinked and deleted files live. */
+	struct yaffs_obj *del_dir;	/* Directory where deleted objects are sent to disappear. */
+	struct yaffs_obj *unlinked_deletion;	/* Current file being background deleted. */
+	int n_deleted_files;	/* Count of files awaiting deletion; */
+	int n_unlinked_files;	/* Count of unlinked files. */
+	int n_bg_deletions;	/* Count of background deletions. */
+
+	/* Temporary buffer management */
+	struct yaffs_buffer temp_buffer[YAFFS_N_TEMP_BUFFERS];
+	int max_temp;
+	int temp_in_use;
+	int unmanaged_buffer_allocs;
+	int unmanaged_buffer_deallocs;
+
+	/* yaffs2 runtime stuff */
+	unsigned seq_number;	/* Sequence number of currently allocating block */
+	unsigned oldest_dirty_seq;
+	unsigned oldest_dirty_block;
+
+	/* Block refreshing */
+	int refresh_skip;	/* A skip down counter. Refresh happens when this gets to zero. */
+
+	/* Dirty directory handling */
+	struct list_head dirty_dirs;	/* List of dirty directories */
+
+	/* Statistcs */
+	u32 n_page_writes;
+	u32 n_page_reads;
+	u32 n_erasures;
+	u32 n_erase_failures;
+	u32 n_gc_copies;
+	u32 all_gcs;
+	u32 passive_gc_count;
+	u32 oldest_dirty_gc_count;
+	u32 n_gc_blocks;
+	u32 bg_gcs;
+	u32 n_retired_writes;
+	u32 n_retired_blocks;
+	u32 n_ecc_fixed;
+	u32 n_ecc_unfixed;
+	u32 n_tags_ecc_fixed;
+	u32 n_tags_ecc_unfixed;
+	u32 n_deletions;
+	u32 n_unmarked_deletions;
+	u32 refresh_count;
+	u32 cache_hits;
+
+};
+
+/* The CheckpointDevice structure holds the device information that changes at runtime and
+ * must be preserved over unmount/mount cycles.
+ */
+struct yaffs_checkpt_dev {
+	int struct_type;
+	int n_erased_blocks;
+	int alloc_block;	/* Current block being allocated off */
+	u32 alloc_page;
+	int n_free_chunks;
+
+	int n_deleted_files;	/* Count of files awaiting deletion; */
+	int n_unlinked_files;	/* Count of unlinked files. */
+	int n_bg_deletions;	/* Count of background deletions. */
+
+	/* yaffs2 runtime stuff */
+	unsigned seq_number;	/* Sequence number of currently allocating block */
+
+};
+
+struct yaffs_checkpt_validity {
+	int struct_type;
+	u32 magic;
+	u32 version;
+	u32 head;
+};
+
+struct yaffs_shadow_fixer {
+	int obj_id;
+	int shadowed_id;
+	struct yaffs_shadow_fixer *next;
+};
+
+/* Structure for doing xattr modifications */
+struct yaffs_xattr_mod {
+	int set;		/* If 0 then this is a deletion */
+	const YCHAR *name;
+	const void *data;
+	int size;
+	int flags;
+	int result;
+};
+
+/*----------------------- YAFFS Functions -----------------------*/
+
+int yaffs_guts_initialise(struct yaffs_dev *dev);
+void yaffs_deinitialise(struct yaffs_dev *dev);
+
+int yaffs_get_n_free_chunks(struct yaffs_dev *dev);
+
+int yaffs_rename_obj(struct yaffs_obj *old_dir, const YCHAR * old_name,
+		     struct yaffs_obj *new_dir, const YCHAR * new_name);
+
+int yaffs_unlinker(struct yaffs_obj *dir, const YCHAR * name);
+int yaffs_del_obj(struct yaffs_obj *obj);
+
+int yaffs_get_obj_name(struct yaffs_obj *obj, YCHAR * name, int buffer_size);
+int yaffs_get_obj_length(struct yaffs_obj *obj);
+int yaffs_get_obj_inode(struct yaffs_obj *obj);
+unsigned yaffs_get_obj_type(struct yaffs_obj *obj);
+int yaffs_get_obj_link_count(struct yaffs_obj *obj);
+
+/* File operations */
+int yaffs_file_rd(struct yaffs_obj *obj, u8 * buffer, loff_t offset,
+		  int n_bytes);
+int yaffs_wr_file(struct yaffs_obj *obj, const u8 * buffer, loff_t offset,
+		  int n_bytes, int write_trhrough);
+int yaffs_resize_file(struct yaffs_obj *obj, loff_t new_size);
+
+struct yaffs_obj *yaffs_create_file(struct yaffs_obj *parent,
+				    const YCHAR * name, u32 mode, u32 uid,
+				    u32 gid);
+
+int yaffs_flush_file(struct yaffs_obj *obj, int update_time, int data_sync);
+
+/* Flushing and checkpointing */
+void yaffs_flush_whole_cache(struct yaffs_dev *dev);
+
+int yaffs_checkpoint_save(struct yaffs_dev *dev);
+int yaffs_checkpoint_restore(struct yaffs_dev *dev);
+
+/* Directory operations */
+struct yaffs_obj *yaffs_create_dir(struct yaffs_obj *parent, const YCHAR * name,
+				   u32 mode, u32 uid, u32 gid);
+struct yaffs_obj *yaffs_find_by_name(struct yaffs_obj *the_dir,
+				     const YCHAR * name);
+struct yaffs_obj *yaffs_find_by_number(struct yaffs_dev *dev, u32 number);
+
+/* Link operations */
+struct yaffs_obj *yaffs_link_obj(struct yaffs_obj *parent, const YCHAR * name,
+				 struct yaffs_obj *equiv_obj);
+
+struct yaffs_obj *yaffs_get_equivalent_obj(struct yaffs_obj *obj);
+
+/* Symlink operations */
+struct yaffs_obj *yaffs_create_symlink(struct yaffs_obj *parent,
+				       const YCHAR * name, u32 mode, u32 uid,
+				       u32 gid, const YCHAR * alias);
+YCHAR *yaffs_get_symlink_alias(struct yaffs_obj *obj);
+
+/* Special inodes (fifos, sockets and devices) */
+struct yaffs_obj *yaffs_create_special(struct yaffs_obj *parent,
+				       const YCHAR * name, u32 mode, u32 uid,
+				       u32 gid, u32 rdev);
+
+int yaffs_set_xattrib(struct yaffs_obj *obj, const YCHAR * name,
+		      const void *value, int size, int flags);
+int yaffs_get_xattrib(struct yaffs_obj *obj, const YCHAR * name, void *value,
+		      int size);
+int yaffs_list_xattrib(struct yaffs_obj *obj, char *buffer, int size);
+int yaffs_remove_xattrib(struct yaffs_obj *obj, const YCHAR * name);
+
+/* Special directories */
+struct yaffs_obj *yaffs_root(struct yaffs_dev *dev);
+struct yaffs_obj *yaffs_lost_n_found(struct yaffs_dev *dev);
+
+void yaffs_handle_defered_free(struct yaffs_obj *obj);
+
+void yaffs_update_dirty_dirs(struct yaffs_dev *dev);
+
+int yaffs_bg_gc(struct yaffs_dev *dev, unsigned urgency);
+
+/* Debug dump  */
+int yaffs_dump_obj(struct yaffs_obj *obj);
+
+void yaffs_guts_test(struct yaffs_dev *dev);
+
+/* A few useful functions to be used within the core files*/
+void yaffs_chunk_del(struct yaffs_dev *dev, int chunk_id, int mark_flash,
+		     int lyn);
+int yaffs_check_ff(u8 * buffer, int n_bytes);
+void yaffs_handle_chunk_error(struct yaffs_dev *dev,
+			      struct yaffs_block_info *bi);
+
+u8 *yaffs_get_temp_buffer(struct yaffs_dev *dev, int line_no);
+void yaffs_release_temp_buffer(struct yaffs_dev *dev, u8 * buffer, int line_no);
+
+struct yaffs_obj *yaffs_find_or_create_by_number(struct yaffs_dev *dev,
+						 int number,
+						 enum yaffs_obj_type type);
+int yaffs_put_chunk_in_file(struct yaffs_obj *in, int inode_chunk,
+			    int nand_chunk, int in_scan);
+void yaffs_set_obj_name(struct yaffs_obj *obj, const YCHAR * name);
+void yaffs_set_obj_name_from_oh(struct yaffs_obj *obj,
+				const struct yaffs_obj_hdr *oh);
+void yaffs_add_obj_to_dir(struct yaffs_obj *directory, struct yaffs_obj *obj);
+YCHAR *yaffs_clone_str(const YCHAR * str);
+void yaffs_link_fixup(struct yaffs_dev *dev, struct yaffs_obj *hard_list);
+void yaffs_block_became_dirty(struct yaffs_dev *dev, int block_no);
+int yaffs_update_oh(struct yaffs_obj *in, const YCHAR * name,
+		    int force, int is_shrink, int shadows,
+		    struct yaffs_xattr_mod *xop);
+void yaffs_handle_shadowed_obj(struct yaffs_dev *dev, int obj_id,
+			       int backward_scanning);
+int yaffs_check_alloc_available(struct yaffs_dev *dev, int n_chunks);
+struct yaffs_tnode *yaffs_get_tnode(struct yaffs_dev *dev);
+struct yaffs_tnode *yaffs_add_find_tnode_0(struct yaffs_dev *dev,
+					   struct yaffs_file_var *file_struct,
+					   u32 chunk_id,
+					   struct yaffs_tnode *passed_tn);
+
+int yaffs_do_file_wr(struct yaffs_obj *in, const u8 * buffer, loff_t offset,
+		     int n_bytes, int write_trhrough);
+void yaffs_resize_file_down(struct yaffs_obj *obj, loff_t new_size);
+void yaffs_skip_rest_of_block(struct yaffs_dev *dev);
+
+int yaffs_count_free_chunks(struct yaffs_dev *dev);
+
+struct yaffs_tnode *yaffs_find_tnode_0(struct yaffs_dev *dev,
+				       struct yaffs_file_var *file_struct,
+				       u32 chunk_id);
+
+u32 yaffs_get_group_base(struct yaffs_dev *dev, struct yaffs_tnode *tn,
+			 unsigned pos);
+
+int yaffs_is_non_empty_dir(struct yaffs_obj *obj);
+#endif
diff --git a/fs/yaffs2/yaffs_yaffs1.c b/fs/yaffs2/yaffs_yaffs1.c
new file mode 100644
index 0000000..b6c43e5
--- /dev/null
+++ b/fs/yaffs2/yaffs_yaffs1.c
@@ -0,0 +1,437 @@
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
+						   YAFFS_OBJECT_TYPE_DIRECTORY) {
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
index 0000000..4f11765
--- /dev/null
+++ b/fs/yaffs2/yaffs_yaffs2.c
@@ -0,0 +1,1620 @@
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
+		} else {
+			ok = 0;
+                }
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
+		if (ok && cp.obj_id == ~0) {
+			done = 1;
+		} else if (ok) {
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
+			} else {
+				ok = 0;
+                        }
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
+	T(YAFFS_TRACE_CHECKPOINT | YAFFS_TRACE_MOUNT,
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
+			} else {
+				small_increase_ok = 0;
+                        }
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
+					} else {
+						in->lazy_loaded = 1;
+                                        }
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
+						   YAFFS_OBJECT_TYPE_DIRECTORY) {
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

