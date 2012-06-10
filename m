Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab2FJJUv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 05:20:51 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58491 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab2FJJUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 05:20:48 -0400
Message-ID: <4FD4656B.1070303@gmail.com>
Date: Sun, 10 Jun 2012 11:14:19 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/17] pramfs: block operations
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Block allocation operations.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-3.5-rc2-orig/fs/pramfs/balloc.c linux-3.5-rc2/fs/pramfs/balloc.c
--- linux-3.5-rc2-orig/fs/pramfs/balloc.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.5-rc2/fs/pramfs/balloc.c	2012-06-10 10:08:28.000000000 +0200
@@ -0,0 +1,160 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * The blocks allocation and deallocation routines.
+ *
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/fs.h>
+#include <linux/bitops.h>
+#include "pram.h"
+
+void pram_bitmap_fill(unsigned long *dst, int nbits)
+{
+	size_t nlongs = BITS_TO_LONGS(nbits);
+	if (!small_const_nbits(nbits)) {
+		int len = (nlongs - 1) * sizeof(unsigned long);
+		memset(dst, 0xff,  len);
+	}
+	if (BITS_PER_LONG == 64)
+		dst[nlongs - 1] = cpu_to_le64(BITMAP_LAST_WORD_MASK(nbits));
+	else
+		dst[nlongs - 1] = cpu_to_le32(BITMAP_LAST_WORD_MASK(nbits));
+}
+
+/*
+ * This just marks in-use the blocks that make up the bitmap.
+ * The bitmap must be writeable before calling.
+ */
+void pram_init_bitmap(struct super_block *sb)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	unsigned long *bitmap = pram_get_bitmap(sb);
+	int blocks = be32_to_cpu(ps->s_bitmap_blocks);
+
+	memset(bitmap, 0, blocks << sb->s_blocksize_bits);
+
+	pram_bitmap_fill(bitmap, blocks);
+}
+
+
+/* Free absolute blocknr */
+void pram_free_block(struct super_block *sb, unsigned long blocknr)
+{
+	struct pram_super_block *ps;
+	u64 bitmap_block;
+	unsigned long bitmap_bnr;
+	void *bitmap;
+	void *bp;
+
+	lock_super(sb);
+
+	bitmap = pram_get_bitmap(sb);
+	/*
+	 * find the block within the bitmap that contains the inuse bit
+	 * for the block we need to free. We need to unlock this bitmap
+	 * block to clear the inuse bit.
+	 */
+	bitmap_bnr = blocknr >> (3 + sb->s_blocksize_bits);
+	bitmap_block = pram_get_block_off(sb, bitmap_bnr);
+	bp = pram_get_block(sb, bitmap_block);
+
+	pram_memunlock_block(sb, bp);
+	pram_clear_bit(blocknr, bitmap); /* mark the block free */
+	pram_memlock_block(sb, bp);
+
+	ps = pram_get_super(sb);
+	pram_memunlock_super(sb, ps);
+
+	if (blocknr < be32_to_cpu(ps->s_free_blocknr_hint))
+		ps->s_free_blocknr_hint = cpu_to_be32(blocknr);
+	be32_add_cpu(&ps->s_free_blocks_count, 1);
+	pram_memlock_super(sb, ps);
+
+	unlock_super(sb);
+}
+
+
+/*
+ * allocate a block and return it's absolute blocknr. Zeroes out the
+ * block if zero set.
+ */
+int pram_new_block(struct super_block *sb, unsigned long *blocknr, int zero)
+{
+	struct pram_super_block *ps;
+	u64 bitmap_block;
+	unsigned long bnr, bitmap_bnr;
+	int errval;
+	void *bitmap;
+	void *bp;
+
+	lock_super(sb);
+	ps = pram_get_super(sb);
+	bitmap = pram_get_bitmap(sb);
+
+	if (ps->s_free_blocks_count) {
+		/* find the oldest unused block */
+		bnr = pram_find_next_zero_bit(bitmap,
+					 be32_to_cpu(ps->s_blocks_count),
+					 be32_to_cpu(ps->s_free_blocknr_hint));
+
+		if (bnr < be32_to_cpu(ps->s_bitmap_blocks) ||
+				bnr >= be32_to_cpu(ps->s_blocks_count)) {
+			pram_dbg("no free blocks found!\n");
+			errval = -ENOSPC;
+			goto fail;
+		}
+
+		pram_memunlock_super(sb, ps);
+		be32_add_cpu(&ps->s_free_blocks_count, -1);
+		if (bnr < (be32_to_cpu(ps->s_blocks_count)-1))
+			ps->s_free_blocknr_hint = cpu_to_be32(bnr+1);
+		else
+			ps->s_free_blocknr_hint = 0;
+		pram_memlock_super(sb, ps);
+	} else {
+		pram_dbg("all blocks allocated\n");
+		errval = -ENOSPC;
+		goto fail;
+	}
+
+	/*
+	 * find the block within the bitmap that contains the inuse bit
+	 * for the unused block we just found. We need to unlock it to
+	 * set the inuse bit.
+	 */
+	bitmap_bnr = bnr >> (3 + sb->s_blocksize_bits);
+	bitmap_block = pram_get_block_off(sb, bitmap_bnr);
+	bp = pram_get_block(sb, bitmap_block);
+
+	pram_memunlock_block(sb, bp);
+	pram_set_bit(bnr, bitmap); /* mark the new block in use */
+	pram_memlock_block(sb, bp);
+
+	if (zero) {
+		bp = pram_get_block(sb, pram_get_block_off(sb, bnr));
+		pram_memunlock_block(sb, bp);
+		memset(bp, 0, sb->s_blocksize);
+		pram_memlock_block(sb, bp);
+	}
+
+	*blocknr = bnr;
+	pram_dbg("allocated blocknr %lu", bnr);
+	errval = 0;
+ fail:
+	unlock_super(sb);
+	return errval;
+}
+
+unsigned long pram_count_free_blocks(struct super_block *sb)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	return be32_to_cpu(ps->s_free_blocks_count);
+}
