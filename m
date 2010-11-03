Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab0KCQ40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:56:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52870 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab0KCQya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:54:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lr+86S4gTkk7siF12v2GdHKHIlOhyO8vTejn/1YWD4uZIKFFwt5rz3MfkMqU32Ritc
         IeeiwC0oclGURpSVyBQASCq5oh+jYgsZWu1l9ahKuW4sEi0rv3UFUoQK0aSm4nAkaULD
         CT4xRe0heKyUftu8QcOgOlW8Q5R0yk+zf4IAw=
From: cdhmanning@gmail.com
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 3/9] Add yaffs checkpointing, blockinfo, nameval and os context
Date: Thu,  4 Nov 2010 05:53:18 +1300
Message-Id: <1288803204-3849-4-git-send-email-cdhmanning@gmail.com>
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
 fs/yaffs2/yaffs_checkptrw.c    |  419 ++++++++++++++++++++++++++++++++++++++++
 fs/yaffs2/yaffs_checkptrw.h    |   33 +++
 fs/yaffs2/yaffs_getblockinfo.h |   36 ++++
 fs/yaffs2/yaffs_linux.h        |   41 ++++
 fs/yaffs2/yaffs_nameval.c      |  199 +++++++++++++++++++
 fs/yaffs2/yaffs_nameval.h      |   28 +++
 6 files changed, 756 insertions(+), 0 deletions(-)
 create mode 100644 fs/yaffs2/yaffs_checkptrw.c
 create mode 100644 fs/yaffs2/yaffs_checkptrw.h
 create mode 100644 fs/yaffs2/yaffs_getblockinfo.h
 create mode 100644 fs/yaffs2/yaffs_linux.h
 create mode 100644 fs/yaffs2/yaffs_nameval.c
 create mode 100644 fs/yaffs2/yaffs_nameval.h

diff --git a/fs/yaffs2/yaffs_checkptrw.c b/fs/yaffs2/yaffs_checkptrw.c
new file mode 100644
index 0000000..2cb144c
--- /dev/null
+++ b/fs/yaffs2/yaffs_checkptrw.c
@@ -0,0 +1,419 @@
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
+#include "yaffs_checkptrw.h"
+#include "yaffs_getblockinfo.h"
+
+static int yaffs2_checkpt_space_ok(struct yaffs_dev *dev)
+{
+	int blocks_avail = dev->n_erased_blocks - dev->param.n_reserved_blocks;
+
+	T(YAFFS_TRACE_CHECKPOINT,
+	  (TSTR("checkpt blocks available = %d" TENDSTR), blocks_avail));
+
+	return (blocks_avail <= 0) ? 0 : 1;
+}
+
+static int yaffs_checkpt_erase(struct yaffs_dev *dev)
+{
+	int i;
+
+	if (!dev->param.erase_fn)
+		return 0;
+	T(YAFFS_TRACE_CHECKPOINT, (TSTR("checking blocks %d to %d" TENDSTR),
+				   dev->internal_start_block,
+				   dev->internal_end_block));
+
+	for (i = dev->internal_start_block; i <= dev->internal_end_block; i++) {
+		struct yaffs_block_info *bi = yaffs_get_block_info(dev, i);
+		if (bi->block_state == YAFFS_BLOCK_STATE_CHECKPOINT) {
+			T(YAFFS_TRACE_CHECKPOINT,
+			  (TSTR("erasing checkpt block %d" TENDSTR), i));
+
+			dev->n_erasures++;
+
+			if (dev->param.
+			    erase_fn(dev,
+				     i - dev->block_offset /* realign */ )) {
+				bi->block_state = YAFFS_BLOCK_STATE_EMPTY;
+				dev->n_erased_blocks++;
+				dev->n_free_chunks +=
+				    dev->param.chunks_per_block;
+			} else {
+				dev->param.bad_block_fn(dev, i);
+				bi->block_state = YAFFS_BLOCK_STATE_DEAD;
+			}
+		}
+	}
+
+	dev->blocks_in_checkpt = 0;
+
+	return 1;
+}
+
+static void yaffs2_checkpt_find_erased_block(struct yaffs_dev *dev)
+{
+	int i;
+	int blocks_avail = dev->n_erased_blocks - dev->param.n_reserved_blocks;
+	T(YAFFS_TRACE_CHECKPOINT,
+	  (TSTR
+	   ("allocating checkpt block: erased %d reserved %d avail %d next %d "
+	    TENDSTR), dev->n_erased_blocks, dev->param.n_reserved_blocks,
+	   blocks_avail, dev->checkpt_next_block));
+
+	if (dev->checkpt_next_block >= 0 &&
+	    dev->checkpt_next_block <= dev->internal_end_block &&
+	    blocks_avail > 0) {
+
+		for (i = dev->checkpt_next_block; i <= dev->internal_end_block;
+		     i++) {
+			struct yaffs_block_info *bi =
+			    yaffs_get_block_info(dev, i);
+			if (bi->block_state == YAFFS_BLOCK_STATE_EMPTY) {
+				dev->checkpt_next_block = i + 1;
+				dev->checkpt_cur_block = i;
+				T(YAFFS_TRACE_CHECKPOINT,
+				  (TSTR("allocating checkpt block %d" TENDSTR),
+				   i));
+				return;
+			}
+		}
+	}
+	T(YAFFS_TRACE_CHECKPOINT, (TSTR("out of checkpt blocks" TENDSTR)));
+
+	dev->checkpt_next_block = -1;
+	dev->checkpt_cur_block = -1;
+}
+
+static void yaffs2_checkpt_find_block(struct yaffs_dev *dev)
+{
+	int i;
+	struct yaffs_ext_tags tags;
+
+	T(YAFFS_TRACE_CHECKPOINT,
+	  (TSTR("find next checkpt block: start:  blocks %d next %d" TENDSTR),
+	   dev->blocks_in_checkpt, dev->checkpt_next_block));
+
+	if (dev->blocks_in_checkpt < dev->checkpt_max_blocks)
+		for (i = dev->checkpt_next_block; i <= dev->internal_end_block;
+		     i++) {
+			int chunk = i * dev->param.chunks_per_block;
+			int realigned_chunk = chunk - dev->chunk_offset;
+
+			dev->param.read_chunk_tags_fn(dev, realigned_chunk,
+						      NULL, &tags);
+			T(YAFFS_TRACE_CHECKPOINT,
+			  (TSTR
+			   ("find next checkpt block: search: block %d oid %d seq %d eccr %d"
+			    TENDSTR), i, tags.obj_id, tags.seq_number,
+			   tags.ecc_result));
+
+			if (tags.seq_number == YAFFS_SEQUENCE_CHECKPOINT_DATA) {
+				/* Right kind of block */
+				dev->checkpt_next_block = tags.obj_id;
+				dev->checkpt_cur_block = i;
+				dev->checkpt_block_list[dev->
+							blocks_in_checkpt] = i;
+				dev->blocks_in_checkpt++;
+				T(YAFFS_TRACE_CHECKPOINT,
+				  (TSTR("found checkpt block %d" TENDSTR), i));
+				return;
+			}
+		}
+
+	T(YAFFS_TRACE_CHECKPOINT,
+	  (TSTR("found no more checkpt blocks" TENDSTR)));
+
+	dev->checkpt_next_block = -1;
+	dev->checkpt_cur_block = -1;
+}
+
+int yaffs2_checkpt_open(struct yaffs_dev *dev, int writing)
+{
+
+	dev->checkpt_open_write = writing;
+
+	/* Got the functions we need? */
+	if (!dev->param.write_chunk_tags_fn ||
+	    !dev->param.read_chunk_tags_fn ||
+	    !dev->param.erase_fn || !dev->param.bad_block_fn)
+		return 0;
+
+	if (writing && !yaffs2_checkpt_space_ok(dev))
+		return 0;
+
+	if (!dev->checkpt_buffer)
+		dev->checkpt_buffer =
+		    YMALLOC_DMA(dev->param.total_bytes_per_chunk);
+	if (!dev->checkpt_buffer)
+		return 0;
+
+	dev->checkpt_page_seq = 0;
+	dev->checkpt_byte_count = 0;
+	dev->checkpt_sum = 0;
+	dev->checkpt_xor = 0;
+	dev->checkpt_cur_block = -1;
+	dev->checkpt_cur_chunk = -1;
+	dev->checkpt_next_block = dev->internal_start_block;
+
+	/* Erase all the blocks in the checkpoint area */
+	if (writing) {
+		memset(dev->checkpt_buffer, 0, dev->data_bytes_per_chunk);
+		dev->checkpt_byte_offs = 0;
+		return yaffs_checkpt_erase(dev);
+	} else {
+		int i;
+		/* Set to a value that will kick off a read */
+		dev->checkpt_byte_offs = dev->data_bytes_per_chunk;
+		/* A checkpoint block list of 1 checkpoint block per 16 block is (hopefully)
+		 * going to be way more than we need */
+		dev->blocks_in_checkpt = 0;
+		dev->checkpt_max_blocks =
+		    (dev->internal_end_block - dev->internal_start_block) / 16 +
+		    2;
+		dev->checkpt_block_list =
+		    YMALLOC(sizeof(int) * dev->checkpt_max_blocks);
+		if (!dev->checkpt_block_list)
+			return 0;
+
+		for (i = 0; i < dev->checkpt_max_blocks; i++)
+			dev->checkpt_block_list[i] = -1;
+	}
+
+	return 1;
+}
+
+int yaffs2_get_checkpt_sum(struct yaffs_dev *dev, u32 * sum)
+{
+	u32 composite_sum;
+	composite_sum = (dev->checkpt_sum << 8) | (dev->checkpt_xor & 0xFF);
+	*sum = composite_sum;
+	return 1;
+}
+
+static int yaffs2_checkpt_flush_buffer(struct yaffs_dev *dev)
+{
+	int chunk;
+	int realigned_chunk;
+
+	struct yaffs_ext_tags tags;
+
+	if (dev->checkpt_cur_block < 0) {
+		yaffs2_checkpt_find_erased_block(dev);
+		dev->checkpt_cur_chunk = 0;
+	}
+
+	if (dev->checkpt_cur_block < 0)
+		return 0;
+
+	tags.is_deleted = 0;
+	tags.obj_id = dev->checkpt_next_block;	/* Hint to next place to look */
+	tags.chunk_id = dev->checkpt_page_seq + 1;
+	tags.seq_number = YAFFS_SEQUENCE_CHECKPOINT_DATA;
+	tags.n_bytes = dev->data_bytes_per_chunk;
+	if (dev->checkpt_cur_chunk == 0) {
+		/* First chunk we write for the block? Set block state to
+		   checkpoint */
+		struct yaffs_block_info *bi =
+		    yaffs_get_block_info(dev, dev->checkpt_cur_block);
+		bi->block_state = YAFFS_BLOCK_STATE_CHECKPOINT;
+		dev->blocks_in_checkpt++;
+	}
+
+	chunk =
+	    dev->checkpt_cur_block * dev->param.chunks_per_block +
+	    dev->checkpt_cur_chunk;
+
+	T(YAFFS_TRACE_CHECKPOINT,
+	  (TSTR
+	   ("checkpoint wite buffer nand %d(%d:%d) objid %d chId %d" TENDSTR),
+	   chunk, dev->checkpt_cur_block, dev->checkpt_cur_chunk, tags.obj_id,
+	   tags.chunk_id));
+
+	realigned_chunk = chunk - dev->chunk_offset;
+
+	dev->n_page_writes++;
+
+	dev->param.write_chunk_tags_fn(dev, realigned_chunk,
+				       dev->checkpt_buffer, &tags);
+	dev->checkpt_byte_offs = 0;
+	dev->checkpt_page_seq++;
+	dev->checkpt_cur_chunk++;
+	if (dev->checkpt_cur_chunk >= dev->param.chunks_per_block) {
+		dev->checkpt_cur_chunk = 0;
+		dev->checkpt_cur_block = -1;
+	}
+	memset(dev->checkpt_buffer, 0, dev->data_bytes_per_chunk);
+
+	return 1;
+}
+
+int yaffs2_checkpt_wr(struct yaffs_dev *dev, const void *data, int n_bytes)
+{
+	int i = 0;
+	int ok = 1;
+
+	u8 *data_bytes = (u8 *) data;
+
+	if (!dev->checkpt_buffer)
+		return 0;
+
+	if (!dev->checkpt_open_write)
+		return -1;
+
+	while (i < n_bytes && ok) {
+		dev->checkpt_buffer[dev->checkpt_byte_offs] = *data_bytes;
+		dev->checkpt_sum += *data_bytes;
+		dev->checkpt_xor ^= *data_bytes;
+
+		dev->checkpt_byte_offs++;
+		i++;
+		data_bytes++;
+		dev->checkpt_byte_count++;
+
+		if (dev->checkpt_byte_offs < 0 ||
+		    dev->checkpt_byte_offs >= dev->data_bytes_per_chunk)
+			ok = yaffs2_checkpt_flush_buffer(dev);
+	}
+
+	return i;
+}
+
+int yaffs2_checkpt_rd(struct yaffs_dev *dev, void *data, int n_bytes)
+{
+	int i = 0;
+	int ok = 1;
+	struct yaffs_ext_tags tags;
+
+	int chunk;
+	int realigned_chunk;
+
+	u8 *data_bytes = (u8 *) data;
+
+	if (!dev->checkpt_buffer)
+		return 0;
+
+	if (dev->checkpt_open_write)
+		return -1;
+
+	while (i < n_bytes && ok) {
+
+		if (dev->checkpt_byte_offs < 0 ||
+		    dev->checkpt_byte_offs >= dev->data_bytes_per_chunk) {
+
+			if (dev->checkpt_cur_block < 0) {
+				yaffs2_checkpt_find_block(dev);
+				dev->checkpt_cur_chunk = 0;
+			}
+
+			if (dev->checkpt_cur_block < 0)
+				ok = 0;
+			else {
+				chunk = dev->checkpt_cur_block *
+				    dev->param.chunks_per_block +
+				    dev->checkpt_cur_chunk;
+
+				realigned_chunk = chunk - dev->chunk_offset;
+
+				dev->n_page_reads++;
+
+				/* read in the next chunk */
+				dev->param.read_chunk_tags_fn(dev,
+							      realigned_chunk,
+							      dev->
+							      checkpt_buffer,
+							      &tags);
+
+				if (tags.chunk_id != (dev->checkpt_page_seq + 1)
+				    || tags.ecc_result > YAFFS_ECC_RESULT_FIXED
+				    || tags.seq_number !=
+				    YAFFS_SEQUENCE_CHECKPOINT_DATA)
+					ok = 0;
+
+				dev->checkpt_byte_offs = 0;
+				dev->checkpt_page_seq++;
+				dev->checkpt_cur_chunk++;
+
+				if (dev->checkpt_cur_chunk >=
+				    dev->param.chunks_per_block)
+					dev->checkpt_cur_block = -1;
+			}
+		}
+
+		if (ok) {
+			*data_bytes =
+			    dev->checkpt_buffer[dev->checkpt_byte_offs];
+			dev->checkpt_sum += *data_bytes;
+			dev->checkpt_xor ^= *data_bytes;
+			dev->checkpt_byte_offs++;
+			i++;
+			data_bytes++;
+			dev->checkpt_byte_count++;
+		}
+	}
+
+	return i;
+}
+
+int yaffs_checkpt_close(struct yaffs_dev *dev)
+{
+
+	if (dev->checkpt_open_write) {
+		if (dev->checkpt_byte_offs != 0)
+			yaffs2_checkpt_flush_buffer(dev);
+	} else if (dev->checkpt_block_list) {
+		int i;
+		for (i = 0;
+		     i < dev->blocks_in_checkpt
+		     && dev->checkpt_block_list[i] >= 0; i++) {
+			int blk = dev->checkpt_block_list[i];
+			struct yaffs_block_info *bi = NULL;
+			if (dev->internal_start_block <= blk
+			    && blk <= dev->internal_end_block)
+				bi = yaffs_get_block_info(dev, blk);
+			if (bi && bi->block_state == YAFFS_BLOCK_STATE_EMPTY)
+				bi->block_state = YAFFS_BLOCK_STATE_CHECKPOINT;
+			else {
+				/* Todo this looks odd... */
+			}
+		}
+		YFREE(dev->checkpt_block_list);
+		dev->checkpt_block_list = NULL;
+	}
+
+	dev->n_free_chunks -=
+	    dev->blocks_in_checkpt * dev->param.chunks_per_block;
+	dev->n_erased_blocks -= dev->blocks_in_checkpt;
+
+	T(YAFFS_TRACE_CHECKPOINT, (TSTR("checkpoint byte count %d" TENDSTR),
+				   dev->checkpt_byte_count));
+
+	if (dev->checkpt_buffer) {
+		/* free the buffer */
+		YFREE(dev->checkpt_buffer);
+		dev->checkpt_buffer = NULL;
+		return 1;
+	} else
+		return 0;
+}
+
+int yaffs2_checkpt_invalidate_stream(struct yaffs_dev *dev)
+{
+	/* Erase the checkpoint data */
+
+	T(YAFFS_TRACE_CHECKPOINT,
+	  (TSTR("checkpoint invalidate of %d blocks" TENDSTR),
+	   dev->blocks_in_checkpt));
+
+	return yaffs_checkpt_erase(dev);
+}
diff --git a/fs/yaffs2/yaffs_checkptrw.h b/fs/yaffs2/yaffs_checkptrw.h
new file mode 100644
index 0000000..361c606
--- /dev/null
+++ b/fs/yaffs2/yaffs_checkptrw.h
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
+#ifndef __YAFFS_CHECKPTRW_H__
+#define __YAFFS_CHECKPTRW_H__
+
+#include "yaffs_guts.h"
+
+int yaffs2_checkpt_open(struct yaffs_dev *dev, int writing);
+
+int yaffs2_checkpt_wr(struct yaffs_dev *dev, const void *data, int n_bytes);
+
+int yaffs2_checkpt_rd(struct yaffs_dev *dev, void *data, int n_bytes);
+
+int yaffs2_get_checkpt_sum(struct yaffs_dev *dev, u32 * sum);
+
+int yaffs_checkpt_close(struct yaffs_dev *dev);
+
+int yaffs2_checkpt_invalidate_stream(struct yaffs_dev *dev);
+
+#endif
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
diff --git a/fs/yaffs2/yaffs_nameval.c b/fs/yaffs2/yaffs_nameval.c
new file mode 100644
index 0000000..d7cb72a
--- /dev/null
+++ b/fs/yaffs2/yaffs_nameval.c
@@ -0,0 +1,199 @@
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
+/*
+ * This simple implementation of a name-value store assumes a small number of values and fits
+ * into a small finite buffer.
+ *
+ * Each attribute is stored as a record:
+ *  sizeof(int) bytes   record size.
+ *  strnlen+1 bytes name null terminated.
+ *  nbytes    value.
+ *  ----------
+ *  total size  stored in record size 
+ *
+ * This code has not been tested with unicode yet.
+ */
+
+#include "yaffs_nameval.h"
+
+#include "yportenv.h"
+
+static int nval_find(const char *xb, int xb_size, const YCHAR * name,
+		     int *exist_size)
+{
+	int pos = 0;
+	int size;
+
+	memcpy(&size, xb, sizeof(int));
+	while (size > 0 && (size < xb_size) && (pos + size < xb_size)) {
+		if (yaffs_strncmp
+		    ((YCHAR *) (xb + pos + sizeof(int)), name, size) == 0) {
+			if (exist_size)
+				*exist_size = size;
+			return pos;
+		}
+		pos += size;
+		if (pos < xb_size - sizeof(int))
+			memcpy(&size, xb + pos, sizeof(int));
+		else
+			size = 0;
+	}
+	if (exist_size)
+		*exist_size = 0;
+	return -1;
+}
+
+static int nval_used(const char *xb, int xb_size)
+{
+	int pos = 0;
+	int size;
+
+	memcpy(&size, xb + pos, sizeof(int));
+	while (size > 0 && (size < xb_size) && (pos + size < xb_size)) {
+		pos += size;
+		if (pos < xb_size - sizeof(int))
+			memcpy(&size, xb + pos, sizeof(int));
+		else
+			size = 0;
+	}
+	return pos;
+}
+
+int nval_del(char *xb, int xb_size, const YCHAR * name)
+{
+	int pos = nval_find(xb, xb_size, name, NULL);
+	int size;
+
+	if (pos >= 0 && pos < xb_size) {
+		/* Find size, shift rest over this record, then zero out the rest of buffer */
+		memcpy(&size, xb + pos, sizeof(int));
+		memcpy(xb + pos, xb + pos + size, xb_size - (pos + size));
+		memset(xb + (xb_size - size), 0, size);
+		return 0;
+	} else
+		return -ENODATA;
+}
+
+int nval_set(char *xb, int xb_size, const YCHAR * name, const char *buf,
+	     int bsize, int flags)
+{
+	int pos;
+	int namelen = yaffs_strnlen(name, xb_size);
+	int reclen;
+	int size_exist = 0;
+	int space;
+	int start;
+
+	pos = nval_find(xb, xb_size, name, &size_exist);
+
+	if (flags & XATTR_CREATE && pos >= 0)
+		return -EEXIST;
+	if (flags & XATTR_REPLACE && pos < 0)
+		return -ENODATA;
+
+	start = nval_used(xb, xb_size);
+	space = xb_size - start + size_exist;
+
+	reclen = (sizeof(int) + namelen + 1 + bsize);
+
+	if (reclen > space)
+		return -ENOSPC;
+
+	if (pos >= 0) {
+		nval_del(xb, xb_size, name);
+		start = nval_used(xb, xb_size);
+	}
+
+	pos = start;
+
+	memcpy(xb + pos, &reclen, sizeof(int));
+	pos += sizeof(int);
+	yaffs_strncpy((YCHAR *) (xb + pos), name, reclen);
+	pos += (namelen + 1);
+	memcpy(xb + pos, buf, bsize);
+	return 0;
+}
+
+int nval_get(const char *xb, int xb_size, const YCHAR * name, char *buf,
+	     int bsize)
+{
+	int pos = nval_find(xb, xb_size, name, NULL);
+	int size;
+
+	if (pos >= 0 && pos < xb_size) {
+
+		memcpy(&size, xb + pos, sizeof(int));
+		pos += sizeof(int);	/* advance past record length */
+		size -= sizeof(int);
+
+		/* Advance over name string */
+		while (xb[pos] && size > 0 && pos < xb_size) {
+			pos++;
+			size--;
+		}
+		/*Advance over NUL */
+		pos++;
+		size--;
+
+		if (size <= bsize) {
+			memcpy(buf, xb + pos, size);
+			return size;
+		}
+
+	}
+	if (pos >= 0)
+		return -ERANGE;
+	else
+		return -ENODATA;
+}
+
+int nval_list(const char *xb, int xb_size, char *buf, int bsize)
+{
+	int pos = 0;
+	int size;
+	int name_len;
+	int ncopied = 0;
+	int filled = 0;
+
+	memcpy(&size, xb + pos, sizeof(int));
+	while (size > sizeof(int) && size <= xb_size && (pos + size) < xb_size
+	       && !filled) {
+		pos += sizeof(int);
+		size -= sizeof(int);
+		name_len = yaffs_strnlen((YCHAR *) (xb + pos), size);
+		if (ncopied + name_len + 1 < bsize) {
+			memcpy(buf, xb + pos, name_len * sizeof(YCHAR));
+			buf += name_len;
+			*buf = '\0';
+			buf++;
+			if (sizeof(YCHAR) > 1) {
+				*buf = '\0';
+				buf++;
+			}
+			ncopied += (name_len + 1);
+		} else
+			filled = 1;
+		pos += size;
+		if (pos < xb_size - sizeof(int))
+			memcpy(&size, xb + pos, sizeof(int));
+		else
+			size = 0;
+	}
+	return ncopied;
+}
+
+int nval_hasvalues(const char *xb, int xb_size)
+{
+	return nval_used(xb, xb_size) > 0;
+}
diff --git a/fs/yaffs2/yaffs_nameval.h b/fs/yaffs2/yaffs_nameval.h
new file mode 100644
index 0000000..2bb02b6
--- /dev/null
+++ b/fs/yaffs2/yaffs_nameval.h
@@ -0,0 +1,28 @@
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
+#ifndef __NAMEVAL_H__
+#define __NAMEVAL_H__
+
+#include "yportenv.h"
+
+int nval_del(char *xb, int xb_size, const YCHAR * name);
+int nval_set(char *xb, int xb_size, const YCHAR * name, const char *buf,
+	     int bsize, int flags);
+int nval_get(const char *xb, int xb_size, const YCHAR * name, char *buf,
+	     int bsize);
+int nval_list(const char *xb, int xb_size, char *buf, int bsize);
+int nval_hasvalues(const char *xb, int xb_size);
+#endif
-- 
1.7.1

