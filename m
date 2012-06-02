Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966619Ab2FBNmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 09:42:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58159 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759735Ab2FBNkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 09:40:49 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 03/10] qnx4fs: use memweight()
Date: Sat,  2 Jun 2012 22:40:09 +0900
Message-Id: <1338644416-11417-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
References: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use memweight() to count the total number of bits clear in memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Anders Larsen <al@alarsen.net>
---

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

