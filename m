Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab1FAOjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 10:39:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56359 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab1FAOjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 10:39:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OL7rSqaoLeryHQDSFHACF9yBxeO7IeSKEhoIuCg1RIAr/lPxGe9BICZLt0NgLhNgRD
         BXELJtDa9EerWzMxttVakKehYBpoyXilCfvQ4QNQBZ12jSK2r8bCASNURBUNbJLAnFVE
         UQSqZVGtMiymjLFAZpUK6yqKZx6ksAiOX/kgM=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, reiserfs-devel@vger.kernel.org
Subject: [PATCH v2 1/2] reiserfs: use proper little-endian bitops
Date: Wed,  1 Jun 2011 23:39:57 +0900
Message-Id: <1306939198-11356-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using __test_and_{set,clear}_bit_le() with ignoring its return value
can be replaced with __{set,clear}_bit_le().

This introduces reiserfs_{set,clear}_le_bit for __{set,clear}_bit_le
and does the above change with them.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: reiserfs-devel@vger.kernel.org
---
v2: rewritten to keep reiserfs_*_le_bit() macros

 fs/reiserfs/bitmap.c        |    2 +-
 fs/reiserfs/resize.c        |    6 +++---
 include/linux/reiserfs_fs.h |    2 ++
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
index 483442e..567385a 100644
--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -214,7 +214,7 @@ static int scan_bitmap_block(struct reiserfs_transaction_handle *th,
 					}
 					/* otherwise we clear all bit were set ... */
 					while (--i >= *beg)
-						reiserfs_test_and_clear_le_bit
+						reiserfs_clear_le_bit
 						    (i, bh->b_data);
 					reiserfs_restore_prepared_buffer(s, bh);
 					*beg = org;
diff --git a/fs/reiserfs/resize.c b/fs/reiserfs/resize.c
index b3a94d2..b6b9b1f 100644
--- a/fs/reiserfs/resize.c
+++ b/fs/reiserfs/resize.c
@@ -136,7 +136,7 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 				return -EIO;
 			}
 			memset(bh->b_data, 0, sb_blocksize(sb));
-			reiserfs_test_and_set_le_bit(0, bh->b_data);
+			reiserfs_set_le_bit(0, bh->b_data);
 			reiserfs_cache_bitmap_metadata(s, bh, bitmap + i);
 
 			set_buffer_uptodate(bh);
@@ -172,7 +172,7 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 
 	reiserfs_prepare_for_journal(s, bh, 1);
 	for (i = block_r; i < s->s_blocksize * 8; i++)
-		reiserfs_test_and_clear_le_bit(i, bh->b_data);
+		reiserfs_clear_le_bit(i, bh->b_data);
 	info->free_count += s->s_blocksize * 8 - block_r;
 
 	journal_mark_dirty(&th, s, bh);
@@ -190,7 +190,7 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 
 	reiserfs_prepare_for_journal(s, bh, 1);
 	for (i = block_r_new; i < s->s_blocksize * 8; i++)
-		reiserfs_test_and_set_le_bit(i, bh->b_data);
+		reiserfs_set_le_bit(i, bh->b_data);
 	journal_mark_dirty(&th, s, bh);
 	brelse(bh);
 
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index eca75df..96d465f 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -2332,7 +2332,9 @@ __u32 keyed_hash(const signed char *msg, int len);
 __u32 yura_hash(const signed char *msg, int len);
 __u32 r5_hash(const signed char *msg, int len);
 
+#define reiserfs_set_le_bit		__set_bit_le
 #define reiserfs_test_and_set_le_bit	__test_and_set_bit_le
+#define reiserfs_clear_le_bit		__clear_bit_le
 #define reiserfs_test_and_clear_le_bit	__test_and_clear_bit_le
 #define reiserfs_test_le_bit		test_bit_le
 #define reiserfs_find_next_zero_le_bit	find_next_zero_bit_le
-- 
1.7.4.4

