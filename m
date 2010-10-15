Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab0JOJo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:44:58 -0400
Received: from [150.82.175.143] ([150.82.175.143]:37673 "EHLO
	dhcpa11143.tky.aist.go.jp" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755532Ab0JOJo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:44:56 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 05/22] m68k: introduce le bitops
Date: Fri, 15 Oct 2010 18:46:04 +0900
Message-Id: <1287135981-17604-6-git-send-email-akinobu.mita@gmail.com>
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
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 arch/m68k/include/asm/bitops_mm.h |   64 +++++++++++++++++++++++++-----------
 1 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index f1010ab..8b3059d 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -359,24 +359,28 @@ static inline int minix_test_bit(int nr, const void *vaddr)
 	return (p[nr >> 4] & (1U << (nr & 15))) != 0;
 }
 
-/* Bitmap functions for the ext2 filesystem. */
-
-#define ext2_set_bit(nr, addr)			__test_and_set_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_set_bit_atomic(lock, nr, addr)	test_and_set_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_clear_bit(nr, addr)		__test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock, nr, addr)	test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_find_next_zero_bit(addr, size, offset) \
-	find_next_zero_le_bit((unsigned long *)addr, size, offset)
-#define ext2_find_next_bit(addr, size, offset) \
-	find_next_le_bit((unsigned long *)addr, size, offset)
-
-static inline int ext2_test_bit(int nr, const void *vaddr)
+/* Bitmap functions for little endian. */
+
+#define __set_le_bit(nr, addr)	\
+	__set_bit((nr) ^ 24, (addr))
+#define __clear_le_bit(nr, addr)	\
+	__clear_bit((nr) ^ 24, (addr))
+#define __test_and_set_le_bit(nr, addr)	\
+	__test_and_set_bit((nr) ^ 24, (addr))
+#define test_and_set_le_bit(lock, nr, addr)	\
+	test_and_set_bit((nr) ^ 24, (addr))
+#define __test_and_clear_le_bit(nr, addr)	\
+	__test_and_clear_bit((nr) ^ 24, (addr))
+#define test_and_clear_le_bit(lock, nr, addr)	\
+	test_and_clear_bit((nr) ^ 24, (addr))
+
+static inline int test_le_bit(int nr, const void *vaddr)
 {
 	const unsigned char *p = vaddr;
 	return (p[nr >> 3] & (1U << (nr & 7))) != 0;
 }
 
-static inline int ext2_find_first_zero_bit(const void *vaddr, unsigned size)
+static inline int find_first_zero_le_bit(const void *vaddr, unsigned size)
 {
 	const unsigned long *p = vaddr, *addr = vaddr;
 	int res;
@@ -393,7 +397,7 @@ static inline int ext2_find_first_zero_bit(const void *vaddr, unsigned size)
 
 	--p;
 	for (res = 0; res < 32; res++)
-		if (!ext2_test_bit (res, p))
+		if (!test_le_bit(res, p))
 			break;
 	return (p - addr) * 32 + res;
 }
@@ -410,16 +414,16 @@ static inline unsigned long find_next_zero_le_bit(const unsigned long *addr,
 	if (bit) {
 		/* Look for zero in first longword */
 		for (res = bit; res < 32; res++)
-			if (!ext2_test_bit (res, p))
+			if (!test_le_bit(res, p))
 				return (p - addr) * 32 + res;
 		p++;
 	}
 	/* No zero yet, search remaining full bytes for a zero */
-	res = ext2_find_first_zero_bit (p, size - 32 * (p - addr));
+	res = find_first_zero_le_bit(p, size - 32 * (p - addr));
 	return (p - addr) * 32 + res;
 }
 
-static inline int ext2_find_first_bit(const void *vaddr, unsigned size)
+static inline int find_first_le_bit(const void *vaddr, unsigned size)
 {
 	const unsigned long *p = vaddr, *addr = vaddr;
 	int res;
@@ -435,7 +439,7 @@ static inline int ext2_find_first_bit(const void *vaddr, unsigned size)
 
 	--p;
 	for (res = 0; res < 32; res++)
-		if (ext2_test_bit(res, p))
+		if (test_le_bit(res, p))
 			break;
 	return (p - addr) * 32 + res;
 }
@@ -452,15 +456,35 @@ static inline unsigned long find_next_le_bit(const unsigned long *addr,
 	if (bit) {
 		/* Look for one in first longword */
 		for (res = bit; res < 32; res++)
-			if (ext2_test_bit(res, p))
+			if (test_le_bit(res, p))
 				return (p - addr) * 32 + res;
 		p++;
 	}
 	/* No set bit yet, search remaining full bytes for a set bit */
-	res = ext2_find_first_bit(p, size - 32 * (p - addr));
+	res = find_first_le_bit(p, size - 32 * (p - addr));
 	return (p - addr) * 32 + res;
 }
 
+/* Bitmap functions for the ext2 filesystem. */
+
+#define ext2_set_bit(nr, addr)	\
+	__test_and_set_le_bit(nr, (unsigned long *)(addr))
+#define ext2_set_bit_atomic(lock, nr, addr)	\
+	test_and_set_le_bit(nr, (unsigned long *)(addr))
+#define ext2_clear_bit(nr, addr)	\
+	__test_and_clear_le_bit(nr, (unsigned long *)(addr))
+#define ext2_clear_bit_atomic(lock, nr, addr)	\
+	test_and_clear_le_bit(nr, (unsigned long *)(addr))
+#define ext2_find_next_zero_bit(addr, size, offset) \
+	find_next_zero_le_bit((unsigned long *)(addr), size, offset)
+#define ext2_find_next_bit(addr, size, offset) \
+	find_next_le_bit((unsigned long *)(addr), size, offset)
+#define ext2_test_bit(nr, vaddr)	test_le_bit(nr, vaddr)
+#define ext2_find_first_zero_bit(vaddr, size)	\
+	find_first_zero_le_bit((unsigned long *)(vaddr), size)
+#define ext2_find_first_bit(vaddr, size)	\
+	find_first_le_bit((unsigned long *)(vaddr), size)
+
 #endif /* __KERNEL__ */
 
 #endif /* _M68K_BITOPS_H */
-- 
1.7.1.231.gd0b16

