Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934447Ab2FIAu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 20:50:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59124 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab2FIAu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 20:50:56 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 2/9] qnx4fs: use memweight()
Date: Sat,  9 Jun 2012 09:50:31 +0900
Message-Id: <1339203038-13069-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
References: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use memweight() to count the total number of bits clear in memory area.

Note that this memweight() call can't be replaced with a single
bitmap_weight() call, although the pointer to the memory area is
aligned to long-word boundary.  Because the size of the memory area
may not be a multiple of BITS_PER_LONG, then it returns wrong value on
big-endian architecture.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Anders Larsen <al@alarsen.net>
---
v3: add note in the patch description
v2: put whitespace before '-'

 fs/qnx4/bitmap.c |   24 +++++-------------------
 1 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/fs/qnx4/bitmap.c b/fs/qnx4/bitmap.c
index 22e0d60..76a7a69 100644
--- a/fs/qnx4/bitmap.c
+++ b/fs/qnx4/bitmap.c
@@ -17,23 +17,6 @@
 #include <linux/bitops.h>
 #include "qnx4.h"
 
-static void count_bits(register const char *bmPart, register int size,
-		       int *const tf)
-{
-	char b;
-	int tot = *tf;
-
-	if (size > QNX4_BLOCK_SIZE) {
-		size = QNX4_BLOCK_SIZE;
-	}
-	do {
-		b = *bmPart++;
-		tot += 8 - hweight8(b);
-		size--;
-	} while (size != 0);
-	*tf = tot;
-}
-
 unsigned long qnx4_count_free_blocks(struct super_block *sb)
 {
 	int start = le32_to_cpu(qnx4_sb(sb)->BitMap->di_first_xtnt.xtnt_blk) - 1;
@@ -44,13 +27,16 @@ unsigned long qnx4_count_free_blocks(struct super_block *sb)
 	struct buffer_head *bh;
 
 	while (total < size) {
+		int bytes = min(size - total, QNX4_BLOCK_SIZE);
+
 		if ((bh = sb_bread(sb, start + offset)) == NULL) {
 			printk(KERN_ERR "qnx4: I/O error in counting free blocks\n");
 			break;
 		}
-		count_bits(bh->b_data, size - total, &total_free);
+		total_free += bytes * BITS_PER_BYTE -
+				memweight(bh->b_data, bytes);
 		brelse(bh);
-		total += QNX4_BLOCK_SIZE;
+		total += bytes;
 		offset++;
 	}
 
-- 
1.7.7.6

