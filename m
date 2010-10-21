Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab0JUOoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:44:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48175 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553Ab0JUOog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:44:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=v5KaXEaHMk+jMZ37x+VFvfObHv6WyBlOECDrjv9KqM+RJkDDWZgCgpFvqilQTC3qC+
         FVb5JUYXx8nejGGq5uOpkl5AOgER2egTsZ7j3htyLyy35CTBNFusZG+Fc826kUhI7EjV
         VVEFxvoy9tByHTWX4DjYGsnyL3TdloXkooZII=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, reiserfs-devel@vger.kernel.org
Subject: [PATCH v2 15/22] reiserfs: use little-endian bitops
Date: Thu, 21 Oct 2010 23:41:10 +0900
Message-Id: <1287672077-5797-16-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
References: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h. This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: reiserfs-devel@vger.kernel.org
---
No change from previous submission

 include/linux/reiserfs_fs.h |   34 ++++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 91a4177..8d5f122 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -1125,15 +1125,21 @@ struct reiserfs_de_head {
 #   define aligned_address(addr)           ((void *)((long)(addr) & ~((1UL << ADDR_UNALIGNED_BITS) - 1)))
 #   define unaligned_offset(addr)          (((int)((long)(addr) & ((1 << ADDR_UNALIGNED_BITS) - 1))) << 3)
 
-#   define set_bit_unaligned(nr, addr)     ext2_set_bit((nr) + unaligned_offset(addr), aligned_address(addr))
-#   define clear_bit_unaligned(nr, addr)   ext2_clear_bit((nr) + unaligned_offset(addr), aligned_address(addr))
-#   define test_bit_unaligned(nr, addr)    ext2_test_bit((nr) + unaligned_offset(addr), aligned_address(addr))
+#   define set_bit_unaligned(nr, addr)	\
+	__test_and_set_le_bit((nr) + unaligned_offset(addr), aligned_address(addr))
+#   define clear_bit_unaligned(nr, addr)	\
+	__test_and_clear_le_bit((nr) + unaligned_offset(addr), aligned_address(addr))
+#   define test_bit_unaligned(nr, addr)	\
+	test_le_bit((nr) + unaligned_offset(addr), aligned_address(addr))
 
 #else
 
-#   define set_bit_unaligned(nr, addr)     ext2_set_bit(nr, addr)
-#   define clear_bit_unaligned(nr, addr)   ext2_clear_bit(nr, addr)
-#   define test_bit_unaligned(nr, addr)    ext2_test_bit(nr, addr)
+#   define set_bit_unaligned(nr, addr)	\
+	__test_and_set_le_bit(nr, (unsigned long *)(addr))
+#   define clear_bit_unaligned(nr, addr)	\
+	__test_and_clear_le_bit(nr, (unsigned long *)(addr))
+#   define test_bit_unaligned(nr, addr)	\
+	test_le_bit(nr, (unsigned long *)(addr))
 
 #endif
 
@@ -2328,14 +2334,14 @@ __u32 keyed_hash(const signed char *msg, int len);
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
+	__test_and_set_le_bit((nr), (unsigned long *)(addr))
+#define reiserfs_test_and_clear_le_bit(nr, addr)	\
+	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
+#define reiserfs_test_le_bit(nr, addr)	\
+	test_le_bit((nr), (unsigned long *)(addr))
+#define reiserfs_find_next_zero_le_bit(addr, size, off)	\
+	find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
 
 /* sometimes reiserfs_truncate may require to allocate few new blocks
    to perform indirect2direct conversion. People probably used to
-- 
1.7.1.231.gd0b16

