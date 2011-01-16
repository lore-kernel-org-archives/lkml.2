Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1APNNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:13:15 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49634 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab1APNIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:08:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EAqwx2vZy48hx0DzA6l3PXWUJqUHXZr+xN+PnB9W85/02fDLO5UqTaGcYZgeoWWm5p
         cK50QDD8IDe2OMM7fwXIV6igS9fEvY2sh/8FVcY0zxJxe65UYa7CMXF3rXnv2FmHBvGO
         QEXCJOyDcemNxqVo7yGAL/AZRvRZcnvGocuYg=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH v4 06/24] m68k: introduce little-endian bitops
Date: Sun, 16 Jan 2011 22:08:35 +0900
Message-Id: <1295183333-13802-7-git-send-email-akinobu.mita@gmail.com>
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
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v3:
 - change to the post-fix notation e.g. s/test_le_bit/test_bit_le/

The whole series is available in the git repository at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v4

 arch/m68k/include/asm/bitops_mm.h |   64 +++++++++++++++++++++++++-----------
 1 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index 31a16d4..0f9b06d 100644
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
-	find_next_zero_bit_le((unsigned long *)addr, size, offset)
-#define ext2_find_next_bit(addr, size, offset) \
-	find_next_bit_le((unsigned long *)addr, size, offset)
-
-static inline int ext2_test_bit(int nr, const void *vaddr)
+/* Bitmap functions for little endian. */
+
+#define __set_bit_le(nr, addr)	\
+	__set_bit((nr) ^ 24, (addr))
+#define __clear_bit_le(nr, addr)	\
+	__clear_bit((nr) ^ 24, (addr))
+#define __test_and_set_bit_le(nr, addr)	\
+	__test_and_set_bit((nr) ^ 24, (addr))
+#define test_and_set_bit_le(nr, addr)	\
+	test_and_set_bit((nr) ^ 24, (addr))
+#define __test_and_clear_bit_le(nr, addr)	\
+	__test_and_clear_bit((nr) ^ 24, (addr))
+#define test_and_clear_bit_le(nr, addr)	\
+	test_and_clear_bit((nr) ^ 24, (addr))
+
+static inline int test_bit_le(int nr, const void *vaddr)
 {
 	const unsigned char *p = vaddr;
 	return (p[nr >> 3] & (1U << (nr & 7))) != 0;
 }
 
-static inline int ext2_find_first_zero_bit(const void *vaddr, unsigned size)
+static inline int find_first_zero_bit_le(const void *vaddr, unsigned size)
 {
 	const unsigned long *p = vaddr, *addr = vaddr;
 	int res;
@@ -393,7 +397,7 @@ static inline int ext2_find_first_zero_bit(const void *vaddr, unsigned size)
 
 	--p;
 	for (res = 0; res < 32; res++)
-		if (!ext2_test_bit (res, p))
+		if (!test_bit_le(res, p))
 			break;
 	return (p - addr) * 32 + res;
 }
@@ -410,16 +414,16 @@ static inline unsigned long find_next_zero_bit_le(const unsigned long *addr,
 	if (bit) {
 		/* Look for zero in first longword */
 		for (res = bit; res < 32; res++)
-			if (!ext2_test_bit (res, p))
+			if (!test_bit_le(res, p))
 				return (p - addr) * 32 + res;
 		p++;
 	}
 	/* No zero yet, search remaining full bytes for a zero */
-	res = ext2_find_first_zero_bit (p, size - 32 * (p - addr));
+	res = find_first_zero_bit_le(p, size - 32 * (p - addr));
 	return (p - addr) * 32 + res;
 }
 
-static inline int ext2_find_first_bit(const void *vaddr, unsigned size)
+static inline int find_first_bit_le(const void *vaddr, unsigned size)
 {
 	const unsigned long *p = vaddr, *addr = vaddr;
 	int res;
@@ -435,7 +439,7 @@ static inline int ext2_find_first_bit(const void *vaddr, unsigned size)
 
 	--p;
 	for (res = 0; res < 32; res++)
-		if (ext2_test_bit(res, p))
+		if (test_bit_le(res, p))
 			break;
 	return (p - addr) * 32 + res;
 }
@@ -452,15 +456,35 @@ static inline unsigned long find_next_bit_le(const unsigned long *addr,
 	if (bit) {
 		/* Look for one in first longword */
 		for (res = bit; res < 32; res++)
-			if (ext2_test_bit(res, p))
+			if (test_bit_le(res, p))
 				return (p - addr) * 32 + res;
 		p++;
 	}
 	/* No set bit yet, search remaining full bytes for a set bit */
-	res = ext2_find_first_bit(p, size - 32 * (p - addr));
+	res = find_first_bit_le(p, size - 32 * (p - addr));
 	return (p - addr) * 32 + res;
 }
 
+/* Bitmap functions for the ext2 filesystem. */
+
+#define ext2_set_bit(nr, addr)	\
+	__test_and_set_bit_le(nr, (unsigned long *)(addr))
+#define ext2_set_bit_atomic(lock, nr, addr)	\
+	test_and_set_bit_le(nr, (unsigned long *)(addr))
+#define ext2_clear_bit(nr, addr)	\
+	__test_and_clear_bit_le(nr, (unsigned long *)(addr))
+#define ext2_clear_bit_atomic(lock, nr, addr)	\
+	test_and_clear_bit_le(nr, (unsigned long *)(addr))
+#define ext2_find_next_zero_bit(addr, size, offset) \
+	find_next_zero_bit_le((unsigned long *)(addr), size, offset)
+#define ext2_find_next_bit(addr, size, offset) \
+	find_next_bit_le((unsigned long *)(addr), size, offset)
+#define ext2_test_bit(nr, vaddr)	test_bit_le(nr, vaddr)
+#define ext2_find_first_zero_bit(vaddr, size)	\
+	find_first_zero_bit_le((unsigned long *)(vaddr), size)
+#define ext2_find_first_bit(vaddr, size)	\
+	find_first_bit_le((unsigned long *)(vaddr), size)
+
 #endif /* __KERNEL__ */
 
 #endif /* _M68K_BITOPS_H */
-- 
1.7.3.4

