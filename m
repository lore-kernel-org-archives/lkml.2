Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab0JOJrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:47:52 -0400
Received: from [150.82.175.143] ([150.82.175.143]:37655 "EHLO
	dhcpa11143.tky.aist.go.jp" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755477Ab0JOJor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:44:47 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/22] arm: introduce little endian bitops
Date: Fri, 15 Oct 2010 18:46:03 +0900
Message-Id: <1287135981-17604-5-git-send-email-akinobu.mita@gmail.com>
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
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/include/asm/bitops.h |   46 +++++++++++++++++++++++++++++-----------
 1 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index 338ff19..d8af4af 100644
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -303,41 +303,61 @@ static inline int fls(int x)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
+#define __set_le_bit(nr, p)			\
+	__set_bit(WORD_BITOFF_TO_LE(nr), (p))
+#define __clear_le_bit(nr, p)			\
+	__clear_bit(WORD_BITOFF_TO_LE(nr), (p))
+#define __test_and_set_le_bit(nr, p)			\
+		__test_and_set_bit(WORD_BITOFF_TO_LE(nr), (p))
+#define test_and_set_le_bit(lock, nr, p)          \
+		test_and_set_bit(WORD_BITOFF_TO_LE(nr), (p))
+#define __test_and_clear_le_bit(nr, p)			\
+		__test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (p))
+#define test_and_clear_le_bit(lock, nr, p)	\
+		test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (p))
+#define test_le_bit(nr, p)			\
+		test_bit(WORD_BITOFF_TO_LE(nr), (p))
+#define find_first_zero_le_bit(p, sz)		\
+		_find_first_zero_bit_le(p, sz)
+#define find_next_zero_le_bit(p, sz, off)	\
+		_find_next_zero_bit_le(p, sz, off)
+#define find_next_le_bit(p, sz, off) \
+		_find_next_bit_le(p, sz, off)
 /*
  * Ext2 is defined to use little-endian byte ordering.
  * These do not need to be atomic.
  */
 #define ext2_set_bit(nr,p)			\
-		__test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		__test_and_set_le_bit(nr, (unsigned long *)(p))
 #define ext2_set_bit_atomic(lock,nr,p)          \
-                test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		test_and_set_le_bit(nr, (unsigned long *)(p))
 #define ext2_clear_bit(nr,p)			\
-		__test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		__test_and_clear_le_bit(nr, (unsigned long *)(p))
 #define ext2_clear_bit_atomic(lock,nr,p)        \
-                test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		test_and_clear_le_bit(nr, (unsigned long *)(p))
 #define ext2_test_bit(nr,p)			\
-		test_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		test_le_bit(nr, (unsigned long *)(p))
 #define ext2_find_first_zero_bit(p,sz)		\
-		_find_first_zero_bit_le(p,sz)
+		find_first_zero_le_bit((unsigned long *)(p), sz)
 #define ext2_find_next_zero_bit(p,sz,off)	\
-		_find_next_zero_bit_le(p,sz,off)
+		find_next_zero_le_bit((unsigned long *)(p), sz, off)
 #define ext2_find_next_bit(p, sz, off) \
-		_find_next_bit_le(p, sz, off)
+		find_next_le_bit((unsigned long *)(p), sz, off)
 
 /*
  * Minix is defined to use little-endian byte ordering.
  * These do not need to be atomic.
  */
 #define minix_set_bit(nr,p)			\
-		__set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		__set_le_bit(nr, (unsigned long *)(p))
 #define minix_test_bit(nr,p)			\
-		test_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		test_le_bit(nr, (unsigned long *)(p))
 #define minix_test_and_set_bit(nr,p)		\
-		__test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		__test_and_set_le_bit(nr, (unsigned long *)(p))
 #define minix_test_and_clear_bit(nr,p)		\
-		__test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
+		__test_and_clear_le_bit(nr, (unsigned long *)(p))
 #define minix_find_first_zero_bit(p,sz)		\
-		_find_first_zero_bit_le(p,sz)
+		find_first_zero_le_bit((unsigned long *)(p), sz)
 
 #endif /* __KERNEL__ */
 
-- 
1.7.1.231.gd0b16

