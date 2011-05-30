Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab1E3Nwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:52:30 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:65426 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab1E3Nw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:52:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ok12t+9RZhgxcrOid87drnDABuT3Gy3GEckX+Jxn9RE1MzH2qx4vd3x8s0u/yBbcZ0
         QlgI3ky2Mw19Sc8wtXi/7E/DhdyPc6UbDhuQQCm70e8a9VWx5OqdOhQw/glLWiMqJKeQ
         rYVsZ9TcXslDmTZvStF7/5CNdHnuQNPsIXAX8=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, reiserfs-devel@vger.kernel.org
Subject: [PATCH 1/3] reiserfs: use little-endian bitops directly
Date: Mon, 30 May 2011 22:53:13 +0900
Message-Id: <1306763595-13908-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/reiserfs_test_and_set_le_bit/__test_and_set_bit_le/
s/reiserfs_test_and_clear_le_bit/__test_and_clear_bit_le/
s/reiserfs_test_le_bit/test_bit_le/
s/reiserfs_find_next_zero_le_bit/find_next_zero_bit_le/

This change reveals that there are some __test_and_{set,clear}_bit_le()
calls which ignore the return value. These can be replaced with
__{set,clear}_bit_le().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: reiserfs-devel@vger.kernel.org
---
 fs/reiserfs/bitmap.c        |   16 +++++++---------
 fs/reiserfs/resize.c        |    6 +++---
 include/linux/reiserfs_fs.h |    5 -----
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
index 483442e..f70dd69 100644
--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -170,8 +170,7 @@ static int scan_bitmap_block(struct reiserfs_transaction_handle *th,
 		}
 
 		/* search for a first zero bit -- beginning of a window */
-		*beg = reiserfs_find_next_zero_le_bit
-		    ((unsigned long *)(bh->b_data), boundary, *beg);
+		*beg = find_next_zero_bit_le(bh->b_data, boundary, *beg);
 
 		if (*beg + min > boundary) {	/* search for a zero bit fails or the rest of bitmap block
 						 * cannot contain a zero window of minimum size */
@@ -184,7 +183,7 @@ static int scan_bitmap_block(struct reiserfs_transaction_handle *th,
 		/* first zero bit found; we check next bits */
 		for (end = *beg + 1;; end++) {
 			if (end >= *beg + max || end >= boundary
-			    || reiserfs_test_le_bit(end, bh->b_data)) {
+			    || test_bit_le(end, bh->b_data)) {
 				next = end;
 				break;
 			}
@@ -202,8 +201,7 @@ static int scan_bitmap_block(struct reiserfs_transaction_handle *th,
 			/* try to set all blocks used checking are they still free */
 			for (i = *beg; i < end; i++) {
 				/* It seems that we should not check in journal again. */
-				if (reiserfs_test_and_set_le_bit
-				    (i, bh->b_data)) {
+				if (__test_and_set_bit_le(i, bh->b_data)) {
 					/* bit was set by another process
 					 * while we slept in prepare_for_journal() */
 					PROC_INFO_INC(s, scan_bitmap.stolen);
@@ -214,7 +212,7 @@ static int scan_bitmap_block(struct reiserfs_transaction_handle *th,
 					}
 					/* otherwise we clear all bit were set ... */
 					while (--i >= *beg)
-						reiserfs_test_and_clear_le_bit
+						__test_and_clear_bit_le
 						    (i, bh->b_data);
 					reiserfs_restore_prepared_buffer(s, bh);
 					*beg = org;
@@ -411,7 +409,7 @@ static void _reiserfs_free_block(struct reiserfs_transaction_handle *th,
 	reiserfs_prepare_for_journal(s, bmbh, 1);
 
 	/* clear bit for the given block in bit map */
-	if (!reiserfs_test_and_clear_le_bit(offset, bmbh->b_data)) {
+	if (!__test_and_clear_bit_le(offset, bmbh->b_data)) {
 		reiserfs_error(s, "vs-4080",
 			       "block %lu: bit already cleared", block);
 	}
@@ -1215,7 +1213,7 @@ void reiserfs_cache_bitmap_metadata(struct super_block *sb,
 	unsigned long *cur = (unsigned long *)(bh->b_data + bh->b_size);
 
 	/* The first bit must ALWAYS be 1 */
-	if (!reiserfs_test_le_bit(0, (unsigned long *)bh->b_data))
+	if (!test_bit_le(0, bh->b_data))
 		reiserfs_error(sb, "reiserfs-2025", "bitmap block %lu is "
 			       "corrupted: first bit must be 1", bh->b_blocknr);
 
@@ -1229,7 +1227,7 @@ void reiserfs_cache_bitmap_metadata(struct super_block *sb,
 			info->free_count += BITS_PER_LONG;
 		else if (*cur != ~0L)	/* A mix, investigate */
 			for (i = BITS_PER_LONG - 1; i >= 0; i--)
-				if (!reiserfs_test_le_bit(i, cur))
+				if (!test_bit_le(i, cur))
 					info->free_count++;
 	}
 }
diff --git a/fs/reiserfs/resize.c b/fs/reiserfs/resize.c
index b3a94d2..1e6f4c2 100644
--- a/fs/reiserfs/resize.c
+++ b/fs/reiserfs/resize.c
@@ -136,7 +136,7 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 				return -EIO;
 			}
 			memset(bh->b_data, 0, sb_blocksize(sb));
-			reiserfs_test_and_set_le_bit(0, bh->b_data);
+			__test_and_set_bit_le(0, bh->b_data);
 			reiserfs_cache_bitmap_metadata(s, bh, bitmap + i);
 
 			set_buffer_uptodate(bh);
@@ -172,7 +172,7 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 
 	reiserfs_prepare_for_journal(s, bh, 1);
 	for (i = block_r; i < s->s_blocksize * 8; i++)
-		reiserfs_test_and_clear_le_bit(i, bh->b_data);
+		__test_and_clear_bit_le(i, bh->b_data);
 	info->free_count += s->s_blocksize * 8 - block_r;
 
 	journal_mark_dirty(&th, s, bh);
@@ -190,7 +190,7 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 
 	reiserfs_prepare_for_journal(s, bh, 1);
 	for (i = block_r_new; i < s->s_blocksize * 8; i++)
-		reiserfs_test_and_set_le_bit(i, bh->b_data);
+		__test_and_set_bit_le(i, bh->b_data);
 	journal_mark_dirty(&th, s, bh);
 	brelse(bh);
 
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index eca75df..06b965d 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -2332,11 +2332,6 @@ __u32 keyed_hash(const signed char *msg, int len);
 __u32 yura_hash(const signed char *msg, int len);
 __u32 r5_hash(const signed char *msg, int len);
 
-#define reiserfs_test_and_set_le_bit	__test_and_set_bit_le
-#define reiserfs_test_and_clear_le_bit	__test_and_clear_bit_le
-#define reiserfs_test_le_bit		test_bit_le
-#define reiserfs_find_next_zero_le_bit	find_next_zero_bit_le
-
 /* sometimes reiserfs_truncate may require to allocate few new blocks
    to perform indirect2direct conversion. People probably used to
    think, that truncate should work without problems on a filesystem
-- 
1.7.4.4

