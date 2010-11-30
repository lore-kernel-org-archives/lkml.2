Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0K3V56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:57:58 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:33923 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab0K3V54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:57:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=f9zX/ReLVbOrG9lEMbNNKDNPMyFYXiii8ob5FjHSsgwDuyJfQ0ujYx8WAPKZaXgk+x
         Dq/gCv5XrlFbyxdilFo2Yr03kXTUjZav+C5ju6IgUfRXGOrfTsMwrTq4R7+x3ZnEkFux
         vlPqKpvw11Wc8fVomhRcgqxcsFxOHLgSlb180=
From: Charles Manning <cdhmanning@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 2/8] Add yaffs2 file system: checkpoint and ecc code
Date: Wed,  1 Dec 2010 10:57:28 +1300
Message-Id: <1291154254-22533-3-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Manning <cdhmanning@gmail.com>
---
 fs/yaffs2/yaffs_checkptrw.c |  420 +++++++++++++++++++++++++++++++++++++++++++
 fs/yaffs2/yaffs_checkptrw.h |   33 ++++
 fs/yaffs2/yaffs_ecc.c       |  298 ++++++++++++++++++++++++++++++
 fs/yaffs2/yaffs_ecc.h       |   44 +++++
 4 files changed, 795 insertions(+), 0 deletions(-)
 create mode 100644 fs/yaffs2/yaffs_checkptrw.c
 create mode 100644 fs/yaffs2/yaffs_checkptrw.h
 create mode 100644 fs/yaffs2/yaffs_ecc.c
 create mode 100644 fs/yaffs2/yaffs_ecc.h

diff --git a/fs/yaffs2/yaffs_checkptrw.c b/fs/yaffs2/yaffs_checkptrw.c
new file mode 100644
index 0000000..02b8ce6
--- /dev/null
+++ b/fs/yaffs2/yaffs_checkptrw.c
@@ -0,0 +1,420 @@
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
+	} else {
+		return 0;
+        }
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
diff --git a/fs/yaffs2/yaffs_ecc.c b/fs/yaffs2/yaffs_ecc.c
new file mode 100644
index 0000000..e95a806
--- /dev/null
+++ b/fs/yaffs2/yaffs_ecc.c
@@ -0,0 +1,298 @@
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
+ * This code implements the ECC algorithm used in SmartMedia.
+ *
+ * The ECC comprises 22 bits of parity information and is stuffed into 3 bytes.
+ * The two unused bit are set to 1.
+ * The ECC can correct single bit errors in a 256-byte page of data. Thus, two such ECC
+ * blocks are used on a 512-byte NAND page.
+ *
+ */
+
+/* Table generated by gen-ecc.c
+ * Using a table means we do not have to calculate p1..p4 and p1'..p4'
+ * for each byte of data. These are instead provided in a table in bits7..2.
+ * Bit 0 of each entry indicates whether the entry has an odd or even parity, and therefore
+ * this bytes influence on the line parity.
+ */
+
+#include "yportenv.h"
+
+#include "yaffs_ecc.h"
+
+static const unsigned char column_parity_table[] = {
+	0x00, 0x55, 0x59, 0x0c, 0x65, 0x30, 0x3c, 0x69,
+	0x69, 0x3c, 0x30, 0x65, 0x0c, 0x59, 0x55, 0x00,
+	0x95, 0xc0, 0xcc, 0x99, 0xf0, 0xa5, 0xa9, 0xfc,
+	0xfc, 0xa9, 0xa5, 0xf0, 0x99, 0xcc, 0xc0, 0x95,
+	0x99, 0xcc, 0xc0, 0x95, 0xfc, 0xa9, 0xa5, 0xf0,
+	0xf0, 0xa5, 0xa9, 0xfc, 0x95, 0xc0, 0xcc, 0x99,
+	0x0c, 0x59, 0x55, 0x00, 0x69, 0x3c, 0x30, 0x65,
+	0x65, 0x30, 0x3c, 0x69, 0x00, 0x55, 0x59, 0x0c,
+	0xa5, 0xf0, 0xfc, 0xa9, 0xc0, 0x95, 0x99, 0xcc,
+	0xcc, 0x99, 0x95, 0xc0, 0xa9, 0xfc, 0xf0, 0xa5,
+	0x30, 0x65, 0x69, 0x3c, 0x55, 0x00, 0x0c, 0x59,
+	0x59, 0x0c, 0x00, 0x55, 0x3c, 0x69, 0x65, 0x30,
+	0x3c, 0x69, 0x65, 0x30, 0x59, 0x0c, 0x00, 0x55,
+	0x55, 0x00, 0x0c, 0x59, 0x30, 0x65, 0x69, 0x3c,
+	0xa9, 0xfc, 0xf0, 0xa5, 0xcc, 0x99, 0x95, 0xc0,
+	0xc0, 0x95, 0x99, 0xcc, 0xa5, 0xf0, 0xfc, 0xa9,
+	0xa9, 0xfc, 0xf0, 0xa5, 0xcc, 0x99, 0x95, 0xc0,
+	0xc0, 0x95, 0x99, 0xcc, 0xa5, 0xf0, 0xfc, 0xa9,
+	0x3c, 0x69, 0x65, 0x30, 0x59, 0x0c, 0x00, 0x55,
+	0x55, 0x00, 0x0c, 0x59, 0x30, 0x65, 0x69, 0x3c,
+	0x30, 0x65, 0x69, 0x3c, 0x55, 0x00, 0x0c, 0x59,
+	0x59, 0x0c, 0x00, 0x55, 0x3c, 0x69, 0x65, 0x30,
+	0xa5, 0xf0, 0xfc, 0xa9, 0xc0, 0x95, 0x99, 0xcc,
+	0xcc, 0x99, 0x95, 0xc0, 0xa9, 0xfc, 0xf0, 0xa5,
+	0x0c, 0x59, 0x55, 0x00, 0x69, 0x3c, 0x30, 0x65,
+	0x65, 0x30, 0x3c, 0x69, 0x00, 0x55, 0x59, 0x0c,
+	0x99, 0xcc, 0xc0, 0x95, 0xfc, 0xa9, 0xa5, 0xf0,
+	0xf0, 0xa5, 0xa9, 0xfc, 0x95, 0xc0, 0xcc, 0x99,
+	0x95, 0xc0, 0xcc, 0x99, 0xf0, 0xa5, 0xa9, 0xfc,
+	0xfc, 0xa9, 0xa5, 0xf0, 0x99, 0xcc, 0xc0, 0x95,
+	0x00, 0x55, 0x59, 0x0c, 0x65, 0x30, 0x3c, 0x69,
+	0x69, 0x3c, 0x30, 0x65, 0x0c, 0x59, 0x55, 0x00,
+};
+
+
+/* Calculate the ECC for a 256-byte block of data */
+void yaffs_ecc_cacl(const unsigned char *data, unsigned char *ecc)
+{
+	unsigned int i;
+
+	unsigned char col_parity = 0;
+	unsigned char line_parity = 0;
+	unsigned char line_parity_prime = 0;
+	unsigned char t;
+	unsigned char b;
+
+	for (i = 0; i < 256; i++) {
+		b = column_parity_table[*data++];
+		col_parity ^= b;
+
+		if (b & 0x01) {	/* odd number of bits in the byte */
+			line_parity ^= i;
+			line_parity_prime ^= ~i;
+		}
+	}
+
+	ecc[2] = (~col_parity) | 0x03;
+
+	t = 0;
+	if (line_parity & 0x80)
+		t |= 0x80;
+	if (line_parity_prime & 0x80)
+		t |= 0x40;
+	if (line_parity & 0x40)
+		t |= 0x20;
+	if (line_parity_prime & 0x40)
+		t |= 0x10;
+	if (line_parity & 0x20)
+		t |= 0x08;
+	if (line_parity_prime & 0x20)
+		t |= 0x04;
+	if (line_parity & 0x10)
+		t |= 0x02;
+	if (line_parity_prime & 0x10)
+		t |= 0x01;
+	ecc[1] = ~t;
+
+	t = 0;
+	if (line_parity & 0x08)
+		t |= 0x80;
+	if (line_parity_prime & 0x08)
+		t |= 0x40;
+	if (line_parity & 0x04)
+		t |= 0x20;
+	if (line_parity_prime & 0x04)
+		t |= 0x10;
+	if (line_parity & 0x02)
+		t |= 0x08;
+	if (line_parity_prime & 0x02)
+		t |= 0x04;
+	if (line_parity & 0x01)
+		t |= 0x02;
+	if (line_parity_prime & 0x01)
+		t |= 0x01;
+	ecc[0] = ~t;
+
+#ifdef CONFIG_YAFFS_ECC_WRONG_ORDER
+	/* Swap the bytes into the wrong order */
+	t = ecc[0];
+	ecc[0] = ecc[1];
+	ecc[1] = t;
+#endif
+}
+
+/* Correct the ECC on a 256 byte block of data */
+
+int yaffs_ecc_correct(unsigned char *data, unsigned char *read_ecc,
+		      const unsigned char *test_ecc)
+{
+	unsigned char d0, d1, d2;	/* deltas */
+
+	d0 = read_ecc[0] ^ test_ecc[0];
+	d1 = read_ecc[1] ^ test_ecc[1];
+	d2 = read_ecc[2] ^ test_ecc[2];
+
+	if ((d0 | d1 | d2) == 0)
+		return 0;	/* no error */
+
+	if (((d0 ^ (d0 >> 1)) & 0x55) == 0x55 &&
+	    ((d1 ^ (d1 >> 1)) & 0x55) == 0x55 &&
+	    ((d2 ^ (d2 >> 1)) & 0x54) == 0x54) {
+		/* Single bit (recoverable) error in data */
+
+		unsigned byte;
+		unsigned bit;
+
+#ifdef CONFIG_YAFFS_ECC_WRONG_ORDER
+		/* swap the bytes to correct for the wrong order */
+		unsigned char t;
+
+		t = d0;
+		d0 = d1;
+		d1 = t;
+#endif
+
+		bit = byte = 0;
+
+		if (d1 & 0x80)
+			byte |= 0x80;
+		if (d1 & 0x20)
+			byte |= 0x40;
+		if (d1 & 0x08)
+			byte |= 0x20;
+		if (d1 & 0x02)
+			byte |= 0x10;
+		if (d0 & 0x80)
+			byte |= 0x08;
+		if (d0 & 0x20)
+			byte |= 0x04;
+		if (d0 & 0x08)
+			byte |= 0x02;
+		if (d0 & 0x02)
+			byte |= 0x01;
+
+		if (d2 & 0x80)
+			bit |= 0x04;
+		if (d2 & 0x20)
+			bit |= 0x02;
+		if (d2 & 0x08)
+			bit |= 0x01;
+
+		data[byte] ^= (1 << bit);
+
+		return 1;	/* Corrected the error */
+	}
+
+	if ((hweight8(d0) + hweight8(d1) + hweight8(d2)) == 1) {
+		/* Reccoverable error in ecc */
+
+		read_ecc[0] = test_ecc[0];
+		read_ecc[1] = test_ecc[1];
+		read_ecc[2] = test_ecc[2];
+
+		return 1;	/* Corrected the error */
+	}
+
+	/* Unrecoverable error */
+
+	return -1;
+
+}
+
+/*
+ * ECCxxxOther does ECC calcs on arbitrary n bytes of data
+ */
+void yaffs_ecc_calc_other(const unsigned char *data, unsigned n_bytes,
+			  struct yaffs_ecc_other *ecc_other)
+{
+	unsigned int i;
+
+	unsigned char col_parity = 0;
+	unsigned line_parity = 0;
+	unsigned line_parity_prime = 0;
+	unsigned char b;
+
+	for (i = 0; i < n_bytes; i++) {
+		b = column_parity_table[*data++];
+		col_parity ^= b;
+
+		if (b & 0x01) {
+			/* odd number of bits in the byte */
+			line_parity ^= i;
+			line_parity_prime ^= ~i;
+		}
+
+	}
+
+	ecc_other->col_parity = (col_parity >> 2) & 0x3f;
+	ecc_other->line_parity = line_parity;
+	ecc_other->line_parity_prime = line_parity_prime;
+}
+
+int yaffs_ecc_correct_other(unsigned char *data, unsigned n_bytes,
+			    struct yaffs_ecc_other *read_ecc,
+			    const struct yaffs_ecc_other *test_ecc)
+{
+	unsigned char delta_col;	/* column parity delta */
+	unsigned delta_line;	/* line parity delta */
+	unsigned delta_line_prime;	/* line parity delta */
+	unsigned bit;
+
+	delta_col = read_ecc->col_parity ^ test_ecc->col_parity;
+	delta_line = read_ecc->line_parity ^ test_ecc->line_parity;
+	delta_line_prime =
+	    read_ecc->line_parity_prime ^ test_ecc->line_parity_prime;
+
+	if ((delta_col | delta_line | delta_line_prime) == 0)
+		return 0;	/* no error */
+
+	if (delta_line == ~delta_line_prime &&
+	    (((delta_col ^ (delta_col >> 1)) & 0x15) == 0x15)) {
+		/* Single bit (recoverable) error in data */
+
+		bit = 0;
+
+		if (delta_col & 0x20)
+			bit |= 0x04;
+		if (delta_col & 0x08)
+			bit |= 0x02;
+		if (delta_col & 0x02)
+			bit |= 0x01;
+
+		if (delta_line >= n_bytes)
+			return -1;
+
+		data[delta_line] ^= (1 << bit);
+
+		return 1;	/* corrected */
+	}
+
+	if ((hweight32(delta_line) +
+	     hweight32(delta_line_prime) +
+	     hweight8(delta_col)) == 1) {
+		/* Reccoverable error in ecc */
+
+		*read_ecc = *test_ecc;
+		return 1;	/* corrected */
+	}
+
+	/* Unrecoverable error */
+
+	return -1;
+}
diff --git a/fs/yaffs2/yaffs_ecc.h b/fs/yaffs2/yaffs_ecc.h
new file mode 100644
index 0000000..b0c461d
--- /dev/null
+++ b/fs/yaffs2/yaffs_ecc.h
@@ -0,0 +1,44 @@
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
+ * This code implements the ECC algorithm used in SmartMedia.
+ *
+ * The ECC comprises 22 bits of parity information and is stuffed into 3 bytes.
+ * The two unused bit are set to 1.
+ * The ECC can correct single bit errors in a 256-byte page of data. Thus, two such ECC
+ * blocks are used on a 512-byte NAND page.
+ *
+ */
+
+#ifndef __YAFFS_ECC_H__
+#define __YAFFS_ECC_H__
+
+struct yaffs_ecc_other {
+	unsigned char col_parity;
+	unsigned line_parity;
+	unsigned line_parity_prime;
+};
+
+void yaffs_ecc_cacl(const unsigned char *data, unsigned char *ecc);
+int yaffs_ecc_correct(unsigned char *data, unsigned char *read_ecc,
+		      const unsigned char *test_ecc);
+
+void yaffs_ecc_calc_other(const unsigned char *data, unsigned n_bytes,
+			  struct yaffs_ecc_other *ecc);
+int yaffs_ecc_correct_other(unsigned char *data, unsigned n_bytes,
+			    struct yaffs_ecc_other *read_ecc,
+			    const struct yaffs_ecc_other *test_ecc);
+#endif
-- 
1.7.1

