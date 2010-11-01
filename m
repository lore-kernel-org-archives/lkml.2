Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0KASlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:41:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53969 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab0KASlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:41:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Zi90Zm93M/bSSe+ypf23TRJE3t4ewgTicMh3yYpinhLxZ19ecCQqbR8sBU8oWxK9tW
         coFgugIMoCfxDWTT/qbFuafzmZDseXFYurgsJvkcMk5S4AM+ATGHqtKGy8ILjpJZmxxj
         eefZaIPtXnoQ1YXvg7fJgr4FkwmEAMjArXxdQ=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 06/29] Staging: yaffs2: yaffs_bitmap: Add files
Date: Mon,  1 Nov 2010 14:40:54 -0400
Message-Id: <1288636877-7964-7-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding files to yaffs2 directory.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/yaffs_bitmap.c |  105 +++++++++++++++++++++++++++++++++
 drivers/staging/yaffs2/yaffs_bitmap.h |   33 ++++++++++
 2 files changed, 138 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/yaffs_bitmap.c
 create mode 100644 drivers/staging/yaffs2/yaffs_bitmap.h

diff --git a/drivers/staging/yaffs2/yaffs_bitmap.c b/drivers/staging/yaffs2/yaffs_bitmap.c
new file mode 100644
index 0000000..85c8c1d
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_bitmap.c
@@ -0,0 +1,105 @@
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
+static Y_INLINE __u8 *yaffs_block_bits(yaffs_dev_t *dev, int blk)
+{
+	if (blk < dev->internal_start_block || blk > dev->internal_end_block) {
+		T(YAFFS_TRACE_ERROR,
+			(TSTR("**>> yaffs: BlockBits block %d is not valid" TENDSTR),
+			blk));
+		YBUG();
+	}
+	return dev->chunk_bits +
+		(dev->chunk_bit_stride * (blk - dev->internal_start_block));
+}
+
+void yaffs_verify_chunk_bit_id(yaffs_dev_t *dev, int blk, int chunk)
+{
+	if (blk < dev->internal_start_block || blk > dev->internal_end_block ||
+			chunk < 0 || chunk >= dev->param.chunks_per_block) {
+		T(YAFFS_TRACE_ERROR,
+		(TSTR("**>> yaffs: Chunk Id (%d:%d) invalid"TENDSTR),
+			blk, chunk));
+		YBUG();
+	}
+}
+
+void yaffs_clear_chunk_bits(yaffs_dev_t *dev, int blk)
+{
+	__u8 *blk_bits = yaffs_block_bits(dev, blk);
+
+	memset(blk_bits, 0, dev->chunk_bit_stride);
+}
+
+void yaffs_clear_chunk_bit(yaffs_dev_t *dev, int blk, int chunk)
+{
+	__u8 *blk_bits = yaffs_block_bits(dev, blk);
+
+	yaffs_verify_chunk_bit_id(dev, blk, chunk);
+
+	blk_bits[chunk / 8] &= ~(1 << (chunk & 7));
+}
+
+void yaffs_set_chunk_bit(yaffs_dev_t *dev, int blk, int chunk)
+{
+	__u8 *blk_bits = yaffs_block_bits(dev, blk);
+
+	yaffs_verify_chunk_bit_id(dev, blk, chunk);
+
+	blk_bits[chunk / 8] |= (1 << (chunk & 7));
+}
+
+int yaffs_check_chunk_bit(yaffs_dev_t *dev, int blk, int chunk)
+{
+	__u8 *blk_bits = yaffs_block_bits(dev, blk);
+	yaffs_verify_chunk_bit_id(dev, blk, chunk);
+
+	return (blk_bits[chunk / 8] & (1 << (chunk & 7))) ? 1 : 0;
+}
+
+int yaffs_still_some_chunks(yaffs_dev_t *dev, int blk)
+{
+	__u8 *blk_bits = yaffs_block_bits(dev, blk);
+	int i;
+	for (i = 0; i < dev->chunk_bit_stride; i++) {
+		if (*blk_bits)
+			return 1;
+		blk_bits++;
+	}
+	return 0;
+}
+
+int yaffs_count_chunk_bits(yaffs_dev_t *dev, int blk)
+{
+	__u8 *blk_bits = yaffs_block_bits(dev, blk);
+	int i;
+	int n = 0;
+	for (i = 0; i < dev->chunk_bit_stride; i++) {
+		__u8 x = *blk_bits;
+		while (x) {
+			if (x & 1)
+				n++;
+			x >>= 1;
+		}
+
+		blk_bits++;
+	}
+	return n;
+}
+
diff --git a/drivers/staging/yaffs2/yaffs_bitmap.h b/drivers/staging/yaffs2/yaffs_bitmap.h
new file mode 100644
index 0000000..ea755be
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_bitmap.h
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
+void yaffs_verify_chunk_bit_id(yaffs_dev_t *dev, int blk, int chunk);
+void yaffs_clear_chunk_bits(yaffs_dev_t *dev, int blk);
+void yaffs_clear_chunk_bit(yaffs_dev_t *dev, int blk, int chunk);
+void yaffs_set_chunk_bit(yaffs_dev_t *dev, int blk, int chunk);
+int yaffs_check_chunk_bit(yaffs_dev_t *dev, int blk, int chunk);
+int yaffs_still_some_chunks(yaffs_dev_t *dev, int blk);
+int yaffs_count_chunk_bits(yaffs_dev_t *dev, int blk);
+
+#endif
-- 
1.7.3.2.146.gca209

