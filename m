Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab1APNIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:08:45 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49634 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab1APNIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:08:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sh1W31Skbg6HQ8d+j/q0fTCDVqV27lmUFXL9GNSDBw7hFYxupM9fLVYGhKP98NVFXx
         QiATctJ0TlqJfLwj+GFuehbsiwSO3Ca1zVUOmmIAPNzdTZtl/p8m0tw5YM+73HWESHfO
         kOUZ5AYd1SvvjIoijxhV2udUTGGrTPSBUR7Ns=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH v4 05/24] arm: introduce little-endian bitops
Date: Sun, 16 Jan 2011 22:08:34 +0900
Message-Id: <1295183333-13802-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
References: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce little-endian bit operations by renaming native ext2 bit
operations.  The ext2 bit operations are kept as wrapper macros using
little-endian bit operations to maintain bisectability until the
conversions are finished.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v3:
 - change to the post-fix notation e.g. s/test_le_bit/test_bit_le/

The whole series is available in the git repository at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v4

 arch/arm/include/asm/bitops.h |   46 +++++++++++++++++++++++++++++-----------
 1 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index 338ff19..37736f6 100644
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -303,41 +303,61 @@ static inline int fls(int x)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
+#define __set_bit_le(nr, p)			\
+	__set_bit(WORD_BITOFF_TO_LE(nr), (p))
+#define __clear_bit_le(nr, p)			\
+	__clear_bit(WORD_BITOFF_TO_LE(nr), (p))
+#define __test_and_set_bit_le(nr, p)			\
+		__test_and_set_bit(WORD_BITOFF_TO_LE(nr), (p))
+#define test_and_set_bit_le(nr, p)          \
+		test_and_set_bit(WORD_BITOFF_TO_LE(nr), (p))
+#define __test_and_clear_bit_le(nr, p)			\
+		__test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (p))
+#define test_and_clear_bit_le(nr, p)	\
+		test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (p))
+#define test_bit_le(nr, p)			\
+		test_bit(WORD_BITOFF_TO_LE(nr), (p))
+#define find_first_zero_bit_le(p, sz)		\
+		_find_first_zero_bit_le(p, sz)
+#define find_next_zero_bit_le(p, sz, off)	\
+		_find_next_zero_bit_le(p, sz, off)
+#define find_next_bit_le(p, sz, off) \
+		_find_next_bit_le(p, sz, off)
 /*
  * Ext2 is defined to use little-endian byte ordering.
  * These do not need to be atomic.
  */
 #define ext2_set_bit(nr,p)			\
-		__test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		__test_and_set_bit_le(nr, (unsigned long *)(p))
 #define ext2_set_bit_atomic(lock,nr,p)          \
-                test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		test_and_set_bit_le(nr, (unsigned long *)(p))
 #define ext2_clear_bit(nr,p)			\
-		__test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		__test_and_clear_bit_le(nr, (unsigned long *)(p))
 #define ext2_clear_bit_atomic(lock,nr,p)        \
-                test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		test_and_clear_bit_le(nr, (unsigned long *)(p))
 #define ext2_test_bit(nr,p)			\
-		test_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		test_bit_le(nr, (unsigned long *)(p))
 #define ext2_find_first_zero_bit(p,sz)		\
-		_find_first_zero_bit_le(p,sz)
+		find_first_zero_bit_le((unsigned long *)(p), sz)
 #define ext2_find_next_zero_bit(p,sz,off)	\
-		_find_next_zero_bit_le(p,sz,off)
+		find_next_zero_bit_le((unsigned long *)(p), sz, off)
 #define ext2_find_next_bit(p, sz, off) \
-		_find_next_bit_le(p, sz, off)
+		find_next_bit_le((unsigned long *)(p), sz, off)
 
 /*
  * Minix is defined to use little-endian byte ordering.
  * These do not need to be atomic.
  */
 #define minix_set_bit(nr,p)			\
-		__set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		__set_bit_le(nr, (unsigned long *)(p))
 #define minix_test_bit(nr,p)			\
-		test_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		test_bit_le(nr, (unsigned long *)(p))
 #define minix_test_and_set_bit(nr,p)		\
-		__test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		__test_and_set_bit_le(nr, (unsigned long *)(p))
 #define minix_test_and_clear_bit(nr,p)		\
-		__test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		__test_and_clear_bit_le(nr, (unsigned long *)(p))
 #define minix_find_first_zero_bit(p,sz)		\
-		_find_first_zero_bit_le(p,sz)
+		find_first_zero_bit_le((unsigned long *)(p), sz)
 
 #endif /* __KERNEL__ */
 
-- 
1.7.3.4

