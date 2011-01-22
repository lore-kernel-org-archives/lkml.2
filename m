Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1AVNOG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:14:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52422 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab1AVNOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:14:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tSyF2lKKevLsMTVSJOS75dsv4E43O64bN5qu/wRqk5/4D+sXwqCkUZ0WxNZGlJyRGR
         ni7TL16X8X5C0Up3j9FScl9oyFWHwlPeCmf7Ih2+nccNtFF1RnjBXfvPYbbQTeS/qh0Q
         PK8AjkQhtKYkPCcOigK8Rn860pTOTTYte60iI=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH v5 09/27] m68k: introduce little-endian bitops
Date: Sat, 22 Jan 2011 22:13:41 +0900
Message-Id: <1295702039-23186-10-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
References: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce little-endian bit operations by renaming native ext2 bit
operations and changing find_*_bit_le() to take a "void *".
The ext2 bit operations are kept as wrapper macros using
little-endian bit operations to maintain bisectability until the
conversions are finished.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v4:
 - change the prototypes and casts in the macro to take any pointer types

The whole series is available in the git branch at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v5

 arch/m68k/include/asm/bitops_mm.h |   80 ++++++++++++++++++++++++-------------
 1 files changed, 52 insertions(+), 28 deletions(-)

diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index 31a16d4..ba1ce43 100644
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
+/* Bitmap functions for the little endian bitmap. */
+
+#define __set_bit_le(nr, addr)	\
+	__set_bit((nr) ^ 24, (unsigned long *)(addr))
+#define __clear_bit_le(nr, addr)	\
+	__clear_bit((nr) ^ 24, (unsigned long *)(addr))
+#define __test_and_set_bit_le(nr, addr)	\
+	__test_and_set_bit((nr) ^ 24, (unsigned long *)(addr))
+#define test_and_set_bit_le(nr, addr)	\
+	test_and_set_bit((nr) ^ 24, (unsigned long *)(addr))
+#define __test_and_clear_bit_le(nr, addr)	\
+	__test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
+#define test_and_clear_bit_le(nr, addr)	\
+	test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
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
@@ -393,33 +397,36 @@ static inline int ext2_find_first_zero_bit(const void *vaddr, unsigned size)
 
 	--p;
 	for (res = 0; res < 32; res++)
-		if (!ext2_test_bit (res, p))
+		if (!test_bit_le(res, p))
 			break;
 	return (p - addr) * 32 + res;
 }
 
-static inline unsigned long find_next_zero_bit_le(const unsigned long *addr,
+static inline unsigned long find_next_zero_bit_le(const void *addr,
 		unsigned long size, unsigned long offset)
 {
-	const unsigned long *p = addr + (offset >> 5);
+	const unsigned long *p = addr;
 	int bit = offset & 31UL, res;
 
 	if (offset >= size)
 		return size;
 
+	p += offset >> 5;
+
 	if (bit) {
+		offset -= bit;
 		/* Look for zero in first longword */
 		for (res = bit; res < 32; res++)
-			if (!ext2_test_bit (res, p))
-				return (p - addr) * 32 + res;
+			if (!test_bit_le(res, p))
+				return offset + res;
 		p++;
+		offset += 32;
 	}
 	/* No zero yet, search remaining full bytes for a zero */
-	res = ext2_find_first_zero_bit (p, size - 32 * (p - addr));
-	return (p - addr) * 32 + res;
+	return offset + find_first_zero_bit_le(p, size - offset);
 }
 
-static inline int ext2_find_first_bit(const void *vaddr, unsigned size)
+static inline int find_first_bit_le(const void *vaddr, unsigned size)
 {
 	const unsigned long *p = vaddr, *addr = vaddr;
 	int res;
@@ -435,32 +442,49 @@ static inline int ext2_find_first_bit(const void *vaddr, unsigned size)
 
 	--p;
 	for (res = 0; res < 32; res++)
-		if (ext2_test_bit(res, p))
+		if (test_bit_le(res, p))
 			break;
 	return (p - addr) * 32 + res;
 }
 
-static inline unsigned long find_next_bit_le(const unsigned long *addr,
+static inline unsigned long find_next_bit_le(const void *addr,
 		unsigned long size, unsigned long offset)
 {
-	const unsigned long *p = addr + (offset >> 5);
+	const unsigned long *p = addr;
 	int bit = offset & 31UL, res;
 
 	if (offset >= size)
 		return size;
 
+	p += offset >> 5;
+
 	if (bit) {
+		offset -= bit;
 		/* Look for one in first longword */
 		for (res = bit; res < 32; res++)
-			if (ext2_test_bit(res, p))
-				return (p - addr) * 32 + res;
+			if (test_bit_le(res, p))
+				return offset + res;
 		p++;
+		offset += 32;
 	}
 	/* No set bit yet, search remaining full bytes for a set bit */
-	res = ext2_find_first_bit(p, size - 32 * (p - addr));
-	return (p - addr) * 32 + res;
+	return offset + find_first_bit_le(p, size - offset);
 }
 
+/* Bitmap functions for the ext2 filesystem. */
+
+#define ext2_set_bit __test_and_set_bit_le
+#define ext2_set_bit_atomic(lock, nr, addr)	\
+	test_and_set_bit_le(nr, addr)
+#define ext2_clear_bit __test_and_clear_bit_le
+#define ext2_clear_bit_atomic(lock, nr, addr)	\
+	test_and_clear_bit_le(nr, addr)
+#define ext2_find_next_zero_bit find_next_zero_bit_le
+#define ext2_find_next_bit find_next_bit_le
+#define ext2_test_bit test_bit_le
+#define ext2_find_first_zero_bit find_first_zero_bit_le
+#define ext2_find_first_bit find_first_bit_le
+
 #endif /* __KERNEL__ */
 
 #endif /* _M68K_BITOPS_H */
-- 
1.7.3.4

