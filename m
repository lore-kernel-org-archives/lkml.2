Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1APNIv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:08:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48314 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab1APNIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:08:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YHsHaO76YMwkBGhxsrKTnSaE5x4XStuZGcq9A5zIxrBxmK4ngr/wRzuBHXTH01kP8z
         KANzJEMSBHkiE1orgwFLtYH4R1qmrmGzmZw8YzQ05Pa0WSE+rDcgn9HSB6ZCvjX63cqw
         lB64lBQ+QScV/QUtSLMgbwlu781nhbeuOuhbg=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Andreas Schwab <schwab@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH v4 08/24] m68knommu: introduce little-endian bitops
Date: Sun, 16 Jan 2011 22:08:37 +0900
Message-Id: <1295183333-13802-9-git-send-email-akinobu.mita@gmail.com>
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
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v3:
 - change to the post-fix notation e.g. s/test_le_bit/test_bit_le/
 - fix m68knommu build

The whole series is available in the git repository at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v4

 arch/m68k/include/asm/bitops_no.h |   40 +++++++++++++++++++++++++++++-------
 arch/m68knommu/Kconfig            |    4 ---
 2 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/m68k/include/asm/bitops_no.h b/arch/m68k/include/asm/bitops_no.h
index 58c67aa..34af922 100644
--- a/arch/m68k/include/asm/bitops_no.h
+++ b/arch/m68k/include/asm/bitops_no.h
@@ -196,7 +196,15 @@ static __inline__ int __test_bit(int nr, const volatile unsigned long * addr)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
-static __inline__ int ext2_set_bit(int nr, volatile void * addr)
+#define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
+
+#define __set_bit_le(nr, addr) \
+	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+
+#define __clear_bit_le(nr, addr) \
+	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+
+static inline int __test_and_set_bit_le(int nr, volatile void *addr)
 {
 	char retval;
 
@@ -215,7 +223,7 @@ static __inline__ int ext2_set_bit(int nr, volatile void * addr)
 	return retval;
 }
 
-static __inline__ int ext2_clear_bit(int nr, volatile void * addr)
+static inline int __test_and_clear_bit_le(int nr, volatile void *addr)
 {
 	char retval;
 
@@ -238,7 +246,7 @@ static __inline__ int ext2_clear_bit(int nr, volatile void * addr)
 	({						\
 		int ret;				\
 		spin_lock(lock);			\
-		ret = ext2_set_bit((nr), (addr));	\
+		ret = __test_and_set_bit_le((nr), (addr));	\
 		spin_unlock(lock);			\
 		ret;					\
 	})
@@ -247,12 +255,12 @@ static __inline__ int ext2_clear_bit(int nr, volatile void * addr)
 	({						\
 		int ret;				\
 		spin_lock(lock);			\
-		ret = ext2_clear_bit((nr), (addr));	\
+		ret = __test_and_clear_bit_le((nr), (addr));	\
 		spin_unlock(lock);			\
 		ret;					\
 	})
 
-static __inline__ int ext2_test_bit(int nr, const volatile void * addr)
+static inline int test_bit_le(int nr, const volatile void *addr)
 {
 	char retval;
 
@@ -271,10 +279,10 @@ static __inline__ int ext2_test_bit(int nr, const volatile void * addr)
 	return retval;
 }
 
-#define ext2_find_first_zero_bit(addr, size) \
-        ext2_find_next_zero_bit((addr), (size), 0)
+#define find_first_zero_bit_le(addr, size)	\
+	find_next_zero_bit_le((addr), (size), 0)
 
-static __inline__ unsigned long ext2_find_next_zero_bit(void *addr, unsigned long size, unsigned long offset)
+static inline unsigned long find_next_zero_bit_le(void *addr, unsigned long size, unsigned long offset)
 {
 	unsigned long *p = ((unsigned long *) addr) + (offset >> 5);
 	unsigned long result = offset & ~31UL;
@@ -324,8 +332,24 @@ found_middle:
 	return result + ffz(__swab32(tmp));
 }
 
+#define ext2_set_bit(nr, addr)	\
+	__test_and_set_bit_le(nr, addr)
+
+#define ext2_clear_bit(nr, addr)	\
+	__test_and_clear_bit_le(nr, addr)
+
+#define ext2_test_bit(nr, addr)	\
+	test_bit_le(nr, addr)
+
+#define ext2_find_first_zero_bit(addr, size) \
+	find_first_zero_bit_le(addr, size)
+
+#define ext2_find_next_zero_bit(addr, size, offset)	\
+	find_next_zero_bit_le(addr, size, offset)
+
 #define ext2_find_next_bit(addr, size, off) \
 	find_next_bit_le((unsigned long *)(addr), (size), (off))
+
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index 87b46f8..fa9f746 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -40,10 +40,6 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_GPIO
 	bool
 	default n
-- 
1.7.3.4

