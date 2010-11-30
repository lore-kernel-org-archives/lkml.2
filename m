Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab0K3V6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:58:20 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52281 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0K3V6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:58:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ovyYx6Vj7TKgzpNHwiN6BIu/oipwPWZVXTdboKHu+WEfvnyWIXMSLkyuGhaD8aQFOK
         A5ftq5eSONlQmkeMJlU/GEewmEqX6i7e5oRLqiP2QE7dI6MUBuSDDZGyH88ewF0LY/+B
         G1S7R6mKA9OJadislkt6KTGxEn8HfXRke3AB0=
From: Charles Manning <cdhmanning@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 5/8] Add yaffs2 file system: mtd and flash handling code
Date: Wed,  1 Dec 2010 10:57:31 +1300
Message-Id: <1291154254-22533-6-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Manning <cdhmanning@gmail.com>
---
 fs/yaffs2/yaffs_mtdif.c  |   54 ++++++++
 fs/yaffs2/yaffs_mtdif.h  |   23 ++++
 fs/yaffs2/yaffs_mtdif1.c |  331 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/yaffs2/yaffs_mtdif1.h |   29 ++++
 fs/yaffs2/yaffs_mtdif2.c |  226 +++++++++++++++++++++++++++++++
 fs/yaffs2/yaffs_mtdif2.h |   29 ++++
 fs/yaffs2/yaffs_nand.c   |  128 ++++++++++++++++++
 fs/yaffs2/yaffs_nand.h   |   38 ++++++
 8 files changed, 858 insertions(+), 0 deletions(-)
 create mode 100644 fs/yaffs2/yaffs_mtdif.c
 create mode 100644 fs/yaffs2/yaffs_mtdif.h
 create mode 100644 fs/yaffs2/yaffs_mtdif1.c
 create mode 100644 fs/yaffs2/yaffs_mtdif1.h
 create mode 100644 fs/yaffs2/yaffs_mtdif2.c
 create mode 100644 fs/yaffs2/yaffs_mtdif2.h
 create mode 100644 fs/yaffs2/yaffs_nand.c
 create mode 100644 fs/yaffs2/yaffs_nand.h

diff --git a/fs/yaffs2/yaffs_mtdif.c b/fs/yaffs2/yaffs_mtdif.c
new file mode 100644
index 0000000..7cf53b3
--- /dev/null
+++ b/fs/yaffs2/yaffs_mtdif.c
@@ -0,0 +1,54 @@
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
+
+#include "yaffs_mtdif.h"
+
+#include "linux/mtd/mtd.h"
+#include "linux/types.h"
+#include "linux/time.h"
+#include "linux/mtd/nand.h"
+
+#include "yaffs_linux.h"
+
+int nandmtd_erase_block(struct yaffs_dev *dev, int block_no)
+{
+	struct mtd_info *mtd = yaffs_dev_to_mtd(dev);
+	u32 addr =
+	    ((loff_t) block_no) * dev->param.total_bytes_per_chunk
+	    * dev->param.chunks_per_block;
+	struct erase_info ei;
+
+	int retval = 0;
+
+	ei.mtd = mtd;
+	ei.addr = addr;
+	ei.len = dev->param.total_bytes_per_chunk * dev->param.chunks_per_block;
+	ei.time = 1000;
+	ei.retries = 2;
+	ei.callback = NULL;
+	ei.priv = (u_long) dev;
+
+	retval = mtd->erase(mtd, &ei);
+
+	if (retval == 0)
+		return YAFFS_OK;
+	else
+		return YAFFS_FAIL;
+}
+
+int nandmtd_initialise(struct yaffs_dev *dev)
+{
+	return YAFFS_OK;
+}
diff --git a/fs/yaffs2/yaffs_mtdif.h b/fs/yaffs2/yaffs_mtdif.h
new file mode 100644
index 0000000..6665074
--- /dev/null
+++ b/fs/yaffs2/yaffs_mtdif.h
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
+#ifndef __YAFFS_MTDIF_H__
+#define __YAFFS_MTDIF_H__
+
+#include "yaffs_guts.h"
+
+int nandmtd_erase_block(struct yaffs_dev *dev, int block_no);
+int nandmtd_initialise(struct yaffs_dev *dev);
+#endif
diff --git a/fs/yaffs2/yaffs_mtdif1.c b/fs/yaffs2/yaffs_mtdif1.c
new file mode 100644
index 0000000..a0bc04f
--- /dev/null
+++ b/fs/yaffs2/yaffs_mtdif1.c
@@ -0,0 +1,331 @@
+/*
+ * YAFFS: Yet another FFS. A NAND-flash specific file system.
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
+ * This module provides the interface between yaffs_nand.c and the
+ * MTD API.  This version is used when the MTD interface supports the
+ * 'mtd_oob_ops' style calls to read_oob and write_oob, circa 2.6.17,
+ * and we have small-page NAND device.
+ *
+ * These functions are invoked via function pointers in yaffs_nand.c.
+ * This replaces functionality provided by functions in yaffs_mtdif.c
+ * and the yaffs_tags compatability functions in yaffs_tagscompat.c that are
+ * called in yaffs_mtdif.c when the function pointers are NULL.
+ * We assume the MTD layer is performing ECC (use_nand_ecc is true).
+ */
+
+#include "yportenv.h"
+#include "yaffs_trace.h"
+#include "yaffs_guts.h"
+#include "yaffs_packedtags1.h"
+#include "yaffs_tagscompat.h"	/* for yaffs_calc_tags_ecc */
+#include "yaffs_linux.h"
+
+#include "linux/kernel.h"
+#include "linux/version.h"
+#include "linux/types.h"
+#include "linux/mtd/mtd.h"
+
+#ifndef CONFIG_YAFFS_9BYTE_TAGS
+# define YTAG1_SIZE 8
+#else
+# define YTAG1_SIZE 9
+#endif
+
+/* Write a chunk (page) of data to NAND.
+ *
+ * Caller always provides ExtendedTags data which are converted to a more
+ * compact (packed) form for storage in NAND.  A mini-ECC runs over the
+ * contents of the tags meta-data; used to valid the tags when read.
+ *
+ *  - Pack ExtendedTags to packed_tags1 form
+ *  - Compute mini-ECC for packed_tags1
+ *  - Write data and packed tags to NAND.
+ *
+ * Note: Due to the use of the packed_tags1 meta-data which does not include
+ * a full sequence number (as found in the larger packed_tags2 form) it is
+ * necessary for Yaffs to re-write a chunk/page (just once) to mark it as
+ * discarded and dirty.  This is not ideal: newer NAND parts are supposed
+ * to be written just once.  When Yaffs performs this operation, this
+ * function is called with a NULL data pointer -- calling MTD write_oob
+ * without data is valid usage (2.6.17).
+ *
+ * Any underlying MTD error results in YAFFS_FAIL.
+ * Returns YAFFS_OK or YAFFS_FAIL.
+ */
+int nandmtd1_write_chunk_tags(struct yaffs_dev *dev,
+			      int nand_chunk, const u8 * data,
+			      const struct yaffs_ext_tags *etags)
+{
+	struct mtd_info *mtd = yaffs_dev_to_mtd(dev);
+	int chunk_bytes = dev->data_bytes_per_chunk;
+	loff_t addr = ((loff_t) nand_chunk) * chunk_bytes;
+	struct mtd_oob_ops ops;
+	struct yaffs_packed_tags1 pt1;
+	int retval;
+
+	/* we assume that packed_tags1 and struct yaffs_tags are compatible */
+	compile_time_assertion(sizeof(struct yaffs_packed_tags1) == 12);
+	compile_time_assertion(sizeof(struct yaffs_tags) == 8);
+
+	yaffs_pack_tags1(&pt1, etags);
+	yaffs_calc_tags_ecc((struct yaffs_tags *)&pt1);
+
+	/* When deleting a chunk, the upper layer provides only skeletal
+	 * etags, one with is_deleted set.  However, we need to update the
+	 * tags, not erase them completely.  So we use the NAND write property
+	 * that only zeroed-bits stick and set tag bytes to all-ones and
+	 * zero just the (not) deleted bit.
+	 */
+#ifndef CONFIG_YAFFS_9BYTE_TAGS
+	if (etags->is_deleted) {
+		memset(&pt1, 0xff, 8);
+		/* clear delete status bit to indicate deleted */
+		pt1.deleted = 0;
+	}
+#else
+	((u8 *) & pt1)[8] = 0xff;
+	if (etags->is_deleted) {
+		memset(&pt1, 0xff, 8);
+		/* zero page_status byte to indicate deleted */
+		((u8 *) & pt1)[8] = 0;
+	}
+#endif
+
+	memset(&ops, 0, sizeof(ops));
+	ops.mode = MTD_OOB_AUTO;
+	ops.len = (data) ? chunk_bytes : 0;
+	ops.ooblen = YTAG1_SIZE;
+	ops.datbuf = (u8 *) data;
+	ops.oobbuf = (u8 *) & pt1;
+
+	retval = mtd->write_oob(mtd, addr, &ops);
+	if (retval) {
+		T(YAFFS_TRACE_MTD,
+		  (TSTR("write_oob failed, chunk %d, mtd error %d" TENDSTR),
+		   nand_chunk, retval));
+	}
+	return retval ? YAFFS_FAIL : YAFFS_OK;
+}
+
+/* Return with empty ExtendedTags but add ecc_result.
+ */
+static int rettags(struct yaffs_ext_tags *etags, int ecc_result, int retval)
+{
+	if (etags) {
+		memset(etags, 0, sizeof(*etags));
+		etags->ecc_result = ecc_result;
+	}
+	return retval;
+}
+
+/* Read a chunk (page) from NAND.
+ *
+ * Caller expects ExtendedTags data to be usable even on error; that is,
+ * all members except ecc_result and block_bad are zeroed.
+ *
+ *  - Check ECC results for data (if applicable)
+ *  - Check for blank/erased block (return empty ExtendedTags if blank)
+ *  - Check the packed_tags1 mini-ECC (correct if necessary/possible)
+ *  - Convert packed_tags1 to ExtendedTags
+ *  - Update ecc_result and block_bad members to refect state.
+ *
+ * Returns YAFFS_OK or YAFFS_FAIL.
+ */
+int nandmtd1_read_chunk_tags(struct yaffs_dev *dev,
+			     int nand_chunk, u8 * data,
+			     struct yaffs_ext_tags *etags)
+{
+	struct mtd_info *mtd = yaffs_dev_to_mtd(dev);
+	int chunk_bytes = dev->data_bytes_per_chunk;
+	loff_t addr = ((loff_t) nand_chunk) * chunk_bytes;
+	int eccres = YAFFS_ECC_RESULT_NO_ERROR;
+	struct mtd_oob_ops ops;
+	struct yaffs_packed_tags1 pt1;
+	int retval;
+	int deleted;
+
+	memset(&ops, 0, sizeof(ops));
+	ops.mode = MTD_OOB_AUTO;
+	ops.len = (data) ? chunk_bytes : 0;
+	ops.ooblen = YTAG1_SIZE;
+	ops.datbuf = data;
+	ops.oobbuf = (u8 *) & pt1;
+
+	/* Read page and oob using MTD.
+	 * Check status and determine ECC result.
+	 */
+	retval = mtd->read_oob(mtd, addr, &ops);
+	if (retval) {
+		T(YAFFS_TRACE_MTD,
+		  (TSTR("read_oob failed, chunk %d, mtd error %d" TENDSTR),
+		   nand_chunk, retval));
+	}
+
+	switch (retval) {
+	case 0:
+		/* no error */
+		break;
+
+	case -EUCLEAN:
+		/* MTD's ECC fixed the data */
+		eccres = YAFFS_ECC_RESULT_FIXED;
+		dev->n_ecc_fixed++;
+		break;
+
+	case -EBADMSG:
+		/* MTD's ECC could not fix the data */
+		dev->n_ecc_unfixed++;
+		/* fall into... */
+	default:
+		rettags(etags, YAFFS_ECC_RESULT_UNFIXED, 0);
+		etags->block_bad = (mtd->block_isbad) (mtd, addr);
+		return YAFFS_FAIL;
+	}
+
+	/* Check for a blank/erased chunk.
+	 */
+	if (yaffs_check_ff((u8 *) & pt1, 8)) {
+		/* when blank, upper layers want ecc_result to be <= NO_ERROR */
+		return rettags(etags, YAFFS_ECC_RESULT_NO_ERROR, YAFFS_OK);
+	}
+#ifndef CONFIG_YAFFS_9BYTE_TAGS
+	/* Read deleted status (bit) then return it to it's non-deleted
+	 * state before performing tags mini-ECC check. pt1.deleted is
+	 * inverted.
+	 */
+	deleted = !pt1.deleted;
+	pt1.deleted = 1;
+#else
+	deleted = (yaffs_count_bits(((u8 *) & pt1)[8]) < 7);
+#endif
+
+	/* Check the packed tags mini-ECC and correct if necessary/possible.
+	 */
+	retval = yaffs_check_tags_ecc((struct yaffs_tags *)&pt1);
+	switch (retval) {
+	case 0:
+		/* no tags error, use MTD result */
+		break;
+	case 1:
+		/* recovered tags-ECC error */
+		dev->n_tags_ecc_fixed++;
+		if (eccres == YAFFS_ECC_RESULT_NO_ERROR)
+			eccres = YAFFS_ECC_RESULT_FIXED;
+		break;
+	default:
+		/* unrecovered tags-ECC error */
+		dev->n_tags_ecc_unfixed++;
+		return rettags(etags, YAFFS_ECC_RESULT_UNFIXED, YAFFS_FAIL);
+	}
+
+	/* Unpack the tags to extended form and set ECC result.
+	 * [set should_be_ff just to keep yaffs_unpack_tags1 happy]
+	 */
+	pt1.should_be_ff = 0xFFFFFFFF;
+	yaffs_unpack_tags1(etags, &pt1);
+	etags->ecc_result = eccres;
+
+	/* Set deleted state */
+	etags->is_deleted = deleted;
+	return YAFFS_OK;
+}
+
+/* Mark a block bad.
+ *
+ * This is a persistant state.
+ * Use of this function should be rare.
+ *
+ * Returns YAFFS_OK or YAFFS_FAIL.
+ */
+int nandmtd1_mark_block_bad(struct yaffs_dev *dev, int block_no)
+{
+	struct mtd_info *mtd = yaffs_dev_to_mtd(dev);
+	int blocksize = dev->param.chunks_per_block * dev->data_bytes_per_chunk;
+	int retval;
+
+	T(YAFFS_TRACE_BAD_BLOCKS,
+	  (TSTR("marking block %d bad" TENDSTR), block_no));
+
+	retval = mtd->block_markbad(mtd, (loff_t) blocksize * block_no);
+	return (retval) ? YAFFS_FAIL : YAFFS_OK;
+}
+
+/* Check any MTD prerequists.
+ *
+ * Returns YAFFS_OK or YAFFS_FAIL.
+ */
+static int nandmtd1_test_prerequists(struct mtd_info *mtd)
+{
+	/* 2.6.18 has mtd->ecclayout->oobavail */
+	/* 2.6.21 has mtd->ecclayout->oobavail and mtd->oobavail */
+	int oobavail = mtd->ecclayout->oobavail;
+
+	if (oobavail < YTAG1_SIZE) {
+		T(YAFFS_TRACE_ERROR,
+		  (TSTR
+		   ("mtd device has only %d bytes for tags, need %d" TENDSTR),
+		   oobavail, YTAG1_SIZE));
+		return YAFFS_FAIL;
+	}
+	return YAFFS_OK;
+}
+
+/* Query for the current state of a specific block.
+ *
+ * Examine the tags of the first chunk of the block and return the state:
+ *  - YAFFS_BLOCK_STATE_DEAD, the block is marked bad
+ *  - YAFFS_BLOCK_STATE_NEEDS_SCANNING, the block is in use
+ *  - YAFFS_BLOCK_STATE_EMPTY, the block is clean
+ *
+ * Always returns YAFFS_OK.
+ */
+int nandmtd1_query_block(struct yaffs_dev *dev, int block_no,
+			 enum yaffs_block_state *state_ptr, u32 * seq_ptr)
+{
+	struct mtd_info *mtd = yaffs_dev_to_mtd(dev);
+	int chunk_num = block_no * dev->param.chunks_per_block;
+	loff_t addr = (loff_t) chunk_num * dev->data_bytes_per_chunk;
+	struct yaffs_ext_tags etags;
+	int state = YAFFS_BLOCK_STATE_DEAD;
+	int seqnum = 0;
+	int retval;
+
+	/* We don't yet have a good place to test for MTD config prerequists.
+	 * Do it here as we are called during the initial scan.
+	 */
+	if (nandmtd1_test_prerequists(mtd) != YAFFS_OK)
+		return YAFFS_FAIL;
+
+	retval = nandmtd1_read_chunk_tags(dev, chunk_num, NULL, &etags);
+	etags.block_bad = (mtd->block_isbad) (mtd, addr);
+	if (etags.block_bad) {
+		T(YAFFS_TRACE_BAD_BLOCKS,
+		  (TSTR("block %d is marked bad" TENDSTR), block_no));
+		state = YAFFS_BLOCK_STATE_DEAD;
+	} else if (etags.ecc_result != YAFFS_ECC_RESULT_NO_ERROR) {
+		/* bad tags, need to look more closely */
+		state = YAFFS_BLOCK_STATE_NEEDS_SCANNING;
+	} else if (etags.chunk_used) {
+		state = YAFFS_BLOCK_STATE_NEEDS_SCANNING;
+		seqnum = etags.seq_number;
+	} else {
+		state = YAFFS_BLOCK_STATE_EMPTY;
+	}
+
+	*state_ptr = state;
+	*seq_ptr = seqnum;
+
+	/* query always succeeds */
+	return YAFFS_OK;
+}
diff --git a/fs/yaffs2/yaffs_mtdif1.h b/fs/yaffs2/yaffs_mtdif1.h
new file mode 100644
index 0000000..07ce452
--- /dev/null
+++ b/fs/yaffs2/yaffs_mtdif1.h
@@ -0,0 +1,29 @@
+/*
+ * YAFFS: Yet another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+#ifndef __YAFFS_MTDIF1_H__
+#define __YAFFS_MTDIF1_H__
+
+int nandmtd1_write_chunk_tags(struct yaffs_dev *dev, int nand_chunk,
+			      const u8 * data,
+			      const struct yaffs_ext_tags *tags);
+
+int nandmtd1_read_chunk_tags(struct yaffs_dev *dev, int nand_chunk,
+			     u8 * data, struct yaffs_ext_tags *tags);
+
+int nandmtd1_mark_block_bad(struct yaffs_dev *dev, int block_no);
+
+int nandmtd1_query_block(struct yaffs_dev *dev, int block_no,
+			 enum yaffs_block_state *state, u32 * seq_number);
+
+#endif
diff --git a/fs/yaffs2/yaffs_mtdif2.c b/fs/yaffs2/yaffs_mtdif2.c
new file mode 100644
index 0000000..0835078
--- /dev/null
+++ b/fs/yaffs2/yaffs_mtdif2.c
@@ -0,0 +1,226 @@
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
+/* mtd interface for YAFFS2 */
+
+#include "yportenv.h"
+#include "yaffs_trace.h"
+
+#include "yaffs_mtdif2.h"
+
+#include "linux/mtd/mtd.h"
+#include "linux/types.h"
+#include "linux/time.h"
+
+#include "yaffs_packedtags2.h"
+
+#include "yaffs_linux.h"
+
+/* NB For use with inband tags....
+ * We assume that the data buffer is of size total_bytes_per_chunk so that we can also
+ * use it to load the tags.
+ */
+int nandmtd2_write_chunk_tags(struct yaffs_dev *dev, int nand_chunk,
+			      const u8 * data,
+			      const struct yaffs_ext_tags *tags)
+{
+	struct mtd_info *mtd = yaffs_dev_to_mtd(dev);
+	struct mtd_oob_ops ops;
+	int retval = 0;
+
+	loff_t addr;
+
+	struct yaffs_packed_tags2 pt;
+
+	int packed_tags_size =
+	    dev->param.no_tags_ecc ? sizeof(pt.t) : sizeof(pt);
+	void *packed_tags_ptr =
+	    dev->param.no_tags_ecc ? (void *)&pt.t : (void *)&pt;
+
+	T(YAFFS_TRACE_MTD,
+	  (TSTR
+	   ("nandmtd2_write_chunk_tags chunk %d data %p tags %p"
+	    TENDSTR), nand_chunk, data, tags));
+
+	addr = ((loff_t) nand_chunk) * dev->param.total_bytes_per_chunk;
+
+	/* For yaffs2 writing there must be both data and tags.
+	 * If we're using inband tags, then the tags are stuffed into
+	 * the end of the data buffer.
+	 */
+	if (!data || !tags)
+		BUG();
+	else if (dev->param.inband_tags) {
+		struct yaffs_packed_tags2_tags_only *pt2tp;
+		pt2tp =
+		    (struct yaffs_packed_tags2_tags_only *)(data +
+							    dev->
+							    data_bytes_per_chunk);
+		yaffs_pack_tags2_tags_only(pt2tp, tags);
+	} else {
+		yaffs_pack_tags2(&pt, tags, !dev->param.no_tags_ecc);
+        }
+
+	ops.mode = MTD_OOB_AUTO;
+	ops.ooblen = (dev->param.inband_tags) ? 0 : packed_tags_size;
+	ops.len = dev->param.total_bytes_per_chunk;
+	ops.ooboffs = 0;
+	ops.datbuf = (u8 *) data;
+	ops.oobbuf = (dev->param.inband_tags) ? NULL : packed_tags_ptr;
+	retval = mtd->write_oob(mtd, addr, &ops);
+
+	if (retval == 0)
+		return YAFFS_OK;
+	else
+		return YAFFS_FAIL;
+}
+
+int nandmtd2_read_chunk_tags(struct yaffs_dev *dev, int nand_chunk,
+			     u8 * data, struct yaffs_ext_tags *tags)
+{
+	struct mtd_info *mtd = yaffs_dev_to_mtd(dev);
+	struct mtd_oob_ops ops;
+
+	size_t dummy;
+	int retval = 0;
+	int local_data = 0;
+
+	loff_t addr = ((loff_t) nand_chunk) * dev->param.total_bytes_per_chunk;
+
+	struct yaffs_packed_tags2 pt;
+
+	int packed_tags_size =
+	    dev->param.no_tags_ecc ? sizeof(pt.t) : sizeof(pt);
+	void *packed_tags_ptr =
+	    dev->param.no_tags_ecc ? (void *)&pt.t : (void *)&pt;
+
+	T(YAFFS_TRACE_MTD,
+	  (TSTR
+	   ("nandmtd2_read_chunk_tags chunk %d data %p tags %p"
+	    TENDSTR), nand_chunk, data, tags));
+
+	if (dev->param.inband_tags) {
+
+		if (!data) {
+			local_data = 1;
+			data = yaffs_get_temp_buffer(dev, __LINE__);
+		}
+
+	}
+
+	if (dev->param.inband_tags || (data && !tags))
+		retval = mtd->read(mtd, addr, dev->param.total_bytes_per_chunk,
+				   &dummy, data);
+	else if (tags) {
+		ops.mode = MTD_OOB_AUTO;
+		ops.ooblen = packed_tags_size;
+		ops.len = data ? dev->data_bytes_per_chunk : packed_tags_size;
+		ops.ooboffs = 0;
+		ops.datbuf = data;
+		ops.oobbuf = yaffs_dev_to_lc(dev)->spare_buffer;
+		retval = mtd->read_oob(mtd, addr, &ops);
+	}
+
+	if (dev->param.inband_tags) {
+		if (tags) {
+			struct yaffs_packed_tags2_tags_only *pt2tp;
+			pt2tp =
+			    (struct yaffs_packed_tags2_tags_only *)&data[dev->
+									 data_bytes_per_chunk];
+			yaffs_unpack_tags2_tags_only(tags, pt2tp);
+		}
+	} else {
+		if (tags) {
+			memcpy(packed_tags_ptr,
+			       yaffs_dev_to_lc(dev)->spare_buffer,
+			       packed_tags_size);
+			yaffs_unpack_tags2(tags, &pt, !dev->param.no_tags_ecc);
+		}
+	}
+
+	if (local_data)
+		yaffs_release_temp_buffer(dev, data, __LINE__);
+
+	if (tags && retval == -EBADMSG
+	    && tags->ecc_result == YAFFS_ECC_RESULT_NO_ERROR) {
+		tags->ecc_result = YAFFS_ECC_RESULT_UNFIXED;
+		dev->n_ecc_unfixed++;
+	}
+	if (tags && retval == -EUCLEAN
+	    && tags->ecc_result == YAFFS_ECC_RESULT_NO_ERROR) {
+		tags->ecc_result = YAFFS_ECC_RESULT_FIXED;
+		dev->n_ecc_fixed++;
+	}
+	if (retval == 0)
+		return YAFFS_OK;
+	else
+		return YAFFS_FAIL;
+}
+
+int nandmtd2_mark_block_bad(struct yaffs_dev *dev, int block_no)
+{
+	struct mtd_info *mtd = yaffs_dev_to_mtd(dev);
+	int retval;
+	T(YAFFS_TRACE_MTD,
+	  (TSTR("nandmtd2_mark_block_bad %d" TENDSTR), block_no));
+
+	retval =
+	    mtd->block_markbad(mtd,
+			       block_no * dev->param.chunks_per_block *
+			       dev->param.total_bytes_per_chunk);
+
+	if (retval == 0)
+		return YAFFS_OK;
+	else
+		return YAFFS_FAIL;
+
+}
+
+int nandmtd2_query_block(struct yaffs_dev *dev, int block_no,
+			 enum yaffs_block_state *state, u32 * seq_number)
+{
+	struct mtd_info *mtd = yaffs_dev_to_mtd(dev);
+	int retval;
+
+	T(YAFFS_TRACE_MTD, (TSTR("nandmtd2_query_block %d" TENDSTR), block_no));
+	retval =
+	    mtd->block_isbad(mtd,
+			     block_no * dev->param.chunks_per_block *
+			     dev->param.total_bytes_per_chunk);
+
+	if (retval) {
+		T(YAFFS_TRACE_MTD, (TSTR("block is bad" TENDSTR)));
+
+		*state = YAFFS_BLOCK_STATE_DEAD;
+		*seq_number = 0;
+	} else {
+		struct yaffs_ext_tags t;
+		nandmtd2_read_chunk_tags(dev, block_no *
+					 dev->param.chunks_per_block, NULL, &t);
+
+		if (t.chunk_used) {
+			*seq_number = t.seq_number;
+			*state = YAFFS_BLOCK_STATE_NEEDS_SCANNING;
+		} else {
+			*seq_number = 0;
+			*state = YAFFS_BLOCK_STATE_EMPTY;
+		}
+	}
+	T(YAFFS_TRACE_MTD,
+	  (TSTR("block is bad seq %d state %d" TENDSTR), *seq_number, *state));
+
+	if (retval == 0)
+		return YAFFS_OK;
+	else
+		return YAFFS_FAIL;
+}
diff --git a/fs/yaffs2/yaffs_mtdif2.h b/fs/yaffs2/yaffs_mtdif2.h
new file mode 100644
index 0000000..d821126
--- /dev/null
+++ b/fs/yaffs2/yaffs_mtdif2.h
@@ -0,0 +1,29 @@
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
+#ifndef __YAFFS_MTDIF2_H__
+#define __YAFFS_MTDIF2_H__
+
+#include "yaffs_guts.h"
+int nandmtd2_write_chunk_tags(struct yaffs_dev *dev, int nand_chunk,
+			      const u8 * data,
+			      const struct yaffs_ext_tags *tags);
+int nandmtd2_read_chunk_tags(struct yaffs_dev *dev, int nand_chunk,
+			     u8 * data, struct yaffs_ext_tags *tags);
+int nandmtd2_mark_block_bad(struct yaffs_dev *dev, int block_no);
+int nandmtd2_query_block(struct yaffs_dev *dev, int block_no,
+			 enum yaffs_block_state *state, u32 * seq_number);
+
+#endif
diff --git a/fs/yaffs2/yaffs_nand.c b/fs/yaffs2/yaffs_nand.c
new file mode 100644
index 0000000..84ab0f0
--- /dev/null
+++ b/fs/yaffs2/yaffs_nand.c
@@ -0,0 +1,128 @@
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
+#include "yaffs_nand.h"
+#include "yaffs_tagscompat.h"
+#include "yaffs_tagsvalidity.h"
+
+#include "yaffs_getblockinfo.h"
+
+int yaffs_rd_chunk_tags_nand(struct yaffs_dev *dev, int nand_chunk,
+			     u8 * buffer, struct yaffs_ext_tags *tags)
+{
+	int result;
+	struct yaffs_ext_tags local_tags;
+
+	int realigned_chunk = nand_chunk - dev->chunk_offset;
+
+	dev->n_page_reads++;
+
+	/* If there are no tags provided, use local tags to get prioritised gc working */
+	if (!tags)
+		tags = &local_tags;
+
+	if (dev->param.read_chunk_tags_fn)
+		result =
+		    dev->param.read_chunk_tags_fn(dev, realigned_chunk, buffer,
+						  tags);
+	else
+		result = yaffs_tags_compat_rd(dev,
+					      realigned_chunk, buffer, tags);
+	if (tags && tags->ecc_result > YAFFS_ECC_RESULT_NO_ERROR) {
+
+		struct yaffs_block_info *bi;
+		bi = yaffs_get_block_info(dev,
+					  nand_chunk /
+					  dev->param.chunks_per_block);
+		yaffs_handle_chunk_error(dev, bi);
+	}
+
+	return result;
+}
+
+int yaffs_wr_chunk_tags_nand(struct yaffs_dev *dev,
+			     int nand_chunk,
+			     const u8 * buffer, struct yaffs_ext_tags *tags)
+{
+
+	dev->n_page_writes++;
+
+	nand_chunk -= dev->chunk_offset;
+
+	if (tags) {
+		tags->seq_number = dev->seq_number;
+		tags->chunk_used = 1;
+		if (!yaffs_validate_tags(tags)) {
+			T(YAFFS_TRACE_ERROR,
+			  (TSTR("Writing uninitialised tags" TENDSTR)));
+			YBUG();
+		}
+		T(YAFFS_TRACE_WRITE,
+		  (TSTR("Writing chunk %d tags %d %d" TENDSTR), nand_chunk,
+		   tags->obj_id, tags->chunk_id));
+	} else {
+		T(YAFFS_TRACE_ERROR, (TSTR("Writing with no tags" TENDSTR)));
+		YBUG();
+	}
+
+	if (dev->param.write_chunk_tags_fn)
+		return dev->param.write_chunk_tags_fn(dev, nand_chunk, buffer,
+						      tags);
+	else
+		return yaffs_tags_compat_wr(dev, nand_chunk, buffer, tags);
+}
+
+int yaffs_mark_bad(struct yaffs_dev *dev, int block_no)
+{
+	block_no -= dev->block_offset;
+
+	if (dev->param.bad_block_fn)
+		return dev->param.bad_block_fn(dev, block_no);
+	else
+		return yaffs_tags_compat_mark_bad(dev, block_no);
+}
+
+int yaffs_query_init_block_state(struct yaffs_dev *dev,
+				 int block_no,
+				 enum yaffs_block_state *state,
+				 u32 * seq_number)
+{
+	block_no -= dev->block_offset;
+
+	if (dev->param.query_block_fn)
+		return dev->param.query_block_fn(dev, block_no, state,
+						 seq_number);
+	else
+		return yaffs_tags_compat_query_block(dev, block_no,
+						     state, seq_number);
+}
+
+int yaffs_erase_block(struct yaffs_dev *dev, int flash_block)
+{
+	int result;
+
+	flash_block -= dev->block_offset;
+
+	dev->n_erasures++;
+
+	result = dev->param.erase_fn(dev, flash_block);
+
+	return result;
+}
+
+int yaffs_init_nand(struct yaffs_dev *dev)
+{
+	if (dev->param.initialise_flash_fn)
+		return dev->param.initialise_flash_fn(dev);
+	return YAFFS_OK;
+}
diff --git a/fs/yaffs2/yaffs_nand.h b/fs/yaffs2/yaffs_nand.h
new file mode 100644
index 0000000..543f198
--- /dev/null
+++ b/fs/yaffs2/yaffs_nand.h
@@ -0,0 +1,38 @@
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
+#ifndef __YAFFS_NAND_H__
+#define __YAFFS_NAND_H__
+#include "yaffs_guts.h"
+
+int yaffs_rd_chunk_tags_nand(struct yaffs_dev *dev, int nand_chunk,
+			     u8 * buffer, struct yaffs_ext_tags *tags);
+
+int yaffs_wr_chunk_tags_nand(struct yaffs_dev *dev,
+			     int nand_chunk,
+			     const u8 * buffer, struct yaffs_ext_tags *tags);
+
+int yaffs_mark_bad(struct yaffs_dev *dev, int block_no);
+
+int yaffs_query_init_block_state(struct yaffs_dev *dev,
+				 int block_no,
+				 enum yaffs_block_state *state,
+				 unsigned *seq_number);
+
+int yaffs_erase_block(struct yaffs_dev *dev, int flash_block);
+
+int yaffs_init_nand(struct yaffs_dev *dev);
+
+#endif
-- 
1.7.1

