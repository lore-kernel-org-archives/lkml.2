Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab0JOJq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:46:27 -0400
Received: from [150.82.175.143] ([150.82.175.143]:37674 "EHLO
	dhcpa11143.tky.aist.go.jp" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754838Ab0JOJo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:44:57 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 06/22] m68knommu: introduce little endian bitops
Date: Fri, 15 Oct 2010 18:46:05 +0900
Message-Id: <1287135981-17604-7-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-Reply-To: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce little endian bit operations by renaming native ext2 bit
operations. The ext2 bit operations are kept by using little endian
bit operations until the conversions are finished.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 arch/m68k/include/asm/bitops_no.h |   40 +++++++++++++++++++++++++++++-------
 1 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/m68k/include/asm/bitops_no.h b/arch/m68k/include/asm/bitops_no.h
index 292e1ce..9f5eb02 100644
--- a/arch/m68k/include/asm/bitops_no.h
+++ b/arch/m68k/include/asm/bitops_no.h
@@ -196,7 +196,15 @@ static __inline__ int __test_bit(int nr, const volatile unsigned long * addr)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
-static __inline__ int ext2_set_bit(int nr, volatile void * addr)
+#define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
+
+#define __set_le_bit(nr, addr) \
+	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+
+#define __clear_le_bit(nr, addr) \
+	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+
+static inline int __test_and_set_le_bit(int nr, volatile void *addr)
 {
 	char retval;
 
@@ -215,7 +223,7 @@ static __inline__ int ext2_set_bit(int nr, volatile void * addr)
 	return retval;
 }
 
-static __inline__ int ext2_clear_bit(int nr, volatile void * addr)
+static inline int __test_and_clear_le_bit(int nr, volatile void *addr)
 {
 	char retval;
 
@@ -238,7 +246,7 @@ static __inline__ int ext2_clear_bit(int nr, volatile void * addr)
 	({						\
 		int ret;				\
 		spin_lock(lock);			\
-		ret = ext2_set_bit((nr), (addr));	\
+		ret = __test_and_set_le_bit((nr), (addr));	\
 		spin_unlock(lock);			\
 		ret;					\
 	})
@@ -247,12 +255,12 @@ static __inline__ int ext2_clear_bit(int nr, volatile void * addr)
 	({						\
 		int ret;				\
 		spin_lock(lock);			\
-		ret = ext2_clear_bit((nr), (addr));	\
+		ret = __test_and_clear_le_bit((nr), (addr));	\
 		spin_unlock(lock);			\
 		ret;					\
 	})
 
-static __inline__ int ext2_test_bit(int nr, const volatile void * addr)
+static inline int test_le_bit(int nr, const volatile void *addr)
 {
 	char retval;
 
@@ -271,10 +279,10 @@ static __inline__ int ext2_test_bit(int nr, const volatile void * addr)
 	return retval;
 }
 
-#define ext2_find_first_zero_bit(addr, size) \
-        ext2_find_next_zero_bit((addr), (size), 0)
+#define find_first_zero_le_bit(addr, size)	\
+	find_next_zero_le_bit((addr), (size), 0)
 
-static __inline__ unsigned long ext2_find_next_zero_bit(void *addr, unsigned long size, unsigned long offset)
+static inline unsigned long find_next_zero_le_bit(void *addr, unsigned long size, unsigned long offset)
 {
 	unsigned long *p = ((unsigned long *) addr) + (offset >> 5);
 	unsigned long result = offset & ~31UL;
@@ -324,8 +332,24 @@ found_middle:
 	return result + ffz(__swab32(tmp));
 }
 
+#define ext2_set_bit(nr, addr)	\
+	__test_and_set_le_bit(nr, addr)
+
+#define ext2_clear_bit(nr, addr)	\
+	test_and_clear_le_bit(nr, addr)
+
+#define ext2_test_bit(nr, addr)	\
+	test_le_bit(nr, addr)
+
+#define ext2_find_first_zero_bit(addr, size) \
+	find_first_zero_le_bit(addr, size)
+
+#define ext2_find_next_zero_bit(addr, size, offset)	\
+	find_next_zero_le_bit(addr, size, offset)
+
 #define ext2_find_next_bit(addr, size, off) \
 	find_next_le_bit((unsigned long *)(addr), (size), (off))
+
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
-- 
1.7.1.231.gd0b16

