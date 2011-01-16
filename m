Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab1APNLD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:11:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48314 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab1APNJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:09:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Z9I93enI6ftYMW7YE7syp4oNMvYJCXJtxEyvkE6laApQraGnPiJaCJoZVb0RohFUqV
         Khhs9eJcuHFmOBe39EuOFbFE//rplcrkVMYsIA7DjyEE92swFmM6uXa5GqOYx4TTECMv
         DEGhK+ChR9tsGy2i6ib37Fg5iZlL27QbpunDs=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 17/24] reiserfs: use little-endian bitops
Date: Sun, 16 Jan 2011 22:08:46 +0900
Message-Id: <1295183333-13802-18-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
References: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v3:
 - change to the post-fix notation e.g. s/test_le_bit/test_bit_le/

The whole series is available in the git repository at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v4

 include/linux/reiserfs_fs.h |   34 ++++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index c21072a..ca43d57 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -1124,15 +1124,21 @@ struct reiserfs_de_head {
 #   define aligned_address(addr)           ((void *)((long)(addr) & ~((1UL << ADDR_UNALIGNED_BITS) - 1)))
 #   define unaligned_offset(addr)          (((int)((long)(addr) & ((1 << ADDR_UNALIGNED_BITS) - 1))) << 3)
 
-#   define set_bit_unaligned(nr, addr)     ext2_set_bit((nr) + unaligned_offset(addr), aligned_address(addr))
-#   define clear_bit_unaligned(nr, addr)   ext2_clear_bit((nr) + unaligned_offset(addr), aligned_address(addr))
-#   define test_bit_unaligned(nr, addr)    ext2_test_bit((nr) + unaligned_offset(addr), aligned_address(addr))
+#   define set_bit_unaligned(nr, addr)	\
+	__test_and_set_bit_le((nr) + unaligned_offset(addr), aligned_address(addr))
+#   define clear_bit_unaligned(nr, addr)	\
+	__test_and_clear_bit_le((nr) + unaligned_offset(addr), aligned_address(addr))
+#   define test_bit_unaligned(nr, addr)	\
+	test_bit_le((nr) + unaligned_offset(addr), aligned_address(addr))
 
 #else
 
-#   define set_bit_unaligned(nr, addr)     ext2_set_bit(nr, addr)
-#   define clear_bit_unaligned(nr, addr)   ext2_clear_bit(nr, addr)
-#   define test_bit_unaligned(nr, addr)    ext2_test_bit(nr, addr)
+#   define set_bit_unaligned(nr, addr)	\
+	__test_and_set_bit_le(nr, (unsigned long *)(addr))
+#   define clear_bit_unaligned(nr, addr)	\
+	__test_and_clear_bit_le(nr, (unsigned long *)(addr))
+#   define test_bit_unaligned(nr, addr)	\
+	test_bit_le(nr, (unsigned long *)(addr))
 
 #endif
 
@@ -2329,14 +2335,14 @@ __u32 keyed_hash(const signed char *msg, int len);
 __u32 yura_hash(const signed char *msg, int len);
 __u32 r5_hash(const signed char *msg, int len);
 
-/* the ext2 bit routines adjust for big or little endian as
-** appropriate for the arch, so in our laziness we use them rather
-** than using the bit routines they call more directly.  These
-** routines must be used when changing on disk bitmaps.  */
-#define reiserfs_test_and_set_le_bit   ext2_set_bit
-#define reiserfs_test_and_clear_le_bit ext2_clear_bit
-#define reiserfs_test_le_bit           ext2_test_bit
-#define reiserfs_find_next_zero_le_bit ext2_find_next_zero_bit
+#define reiserfs_test_and_set_le_bit(nr, addr)	\
+	__test_and_set_bit_le((nr), (unsigned long *)(addr))
+#define reiserfs_test_and_clear_le_bit(nr, addr)	\
+	__test_and_clear_bit_le((nr), (unsigned long *)(addr))
+#define reiserfs_test_le_bit(nr, addr)	\
+	test_bit_le((nr), (unsigned long *)(addr))
+#define reiserfs_find_next_zero_le_bit(addr, size, off)	\
+	find_next_zero_bit_le((unsigned long *)(addr), (size), (off))
 
 /* sometimes reiserfs_truncate may require to allocate few new blocks
    to perform indirect2direct conversion. People probably used to
-- 
1.7.3.4

