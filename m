Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab1DCNLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 09:11:39 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:40422 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab1DCNL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 09:11:28 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH 2/2] m68k: bitops - Never step beyond the end of the bitmap
Date: Sun,  3 Apr 2011 15:11:17 +0200
Message-Id: <1301836277-30185-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1301836277-30185-1-git-send-email-geert@linux-m68k.org>
References: <1301836277-30185-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_next bitops on m68k (find_next_zero_bit, find_next_bit, and
find_next_bit_le) may cause out of bounds memory access
when the bitmap size in bits % 32 != 0 and offset (the bitnumber
to start searching at) is very close to the bitmap size.

For example,

       unsigned long bitmap[2] = { 0, 0 };
       find_next_bit(bitmap, 63, 62);

1. find_next_bit() tries to find any set bits in bitmap[1],
   but no bits set.

2. Then find_first_bit(bimap + 2, -1)

3. Unfortunately find_first_bit() takes unsigned int as the size argument.

4. find_first_bit will access bitmap[2~] until it find any set bits.

Add missing tests for stepping beyond the end of the bitmap to all
find_{first,next}_*() functions, and make sure they never return a value
larger than the bitmap size.

Reported-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>
---
 arch/m68k/include/asm/bitops_mm.h |   81 +++++++++++++++++++++++++------------
 1 files changed, 55 insertions(+), 26 deletions(-)

diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index 5bd3afa..e9020f8 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -181,14 +181,15 @@ static inline int find_first_zero_bit(const unsigned long *vaddr,
 {
 	const unsigned long *p = vaddr;
 	int res = 32;
+	unsigned int words;
 	unsigned long num;
 
 	if (!size)
 		return 0;
 
-	size = (size + 31) >> 5;
+	words = (size + 31) >> 5;
 	while (!(num = ~*p++)) {
-		if (!--size)
+		if (!--words)
 			goto out;
 	}
 
@@ -196,7 +197,8 @@ static inline int find_first_zero_bit(const unsigned long *vaddr,
 			      : "=d" (res) : "d" (num & -num));
 	res ^= 31;
 out:
-	return ((long)p - (long)vaddr - 4) * 8 + res;
+	res += ((long)p - (long)vaddr - 4) * 8;
+	return res < size ? res : size;
 }
 
 static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
@@ -215,9 +217,14 @@ static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
 		/* Look for zero in first longword */
 		__asm__ __volatile__ ("bfffo %1{#0,#0},%0"
 				      : "=d" (res) : "d" (num & -num));
-		if (res < 32)
-			return offset + (res ^ 31);
+		if (res < 32) {
+			offset += res ^ 31;
+			return offset < size ? offset : size;
+		}
 		offset += 32;
+
+		if (offset >= size)
+			return size;
 	}
 	/* No zero yet, search remaining full bytes for a zero */
 	return offset + find_first_zero_bit(p, size - offset);
@@ -227,14 +234,15 @@ static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
 {
 	const unsigned long *p = vaddr;
 	int res = 32;
+	unsigned int words;
 	unsigned long num;
 
 	if (!size)
 		return 0;
 
-	size = (size + 31) >> 5;
+	words = (size + 31) >> 5;
 	while (!(num = *p++)) {
-		if (!--size)
+		if (!--words)
 			goto out;
 	}
 
@@ -242,7 +250,8 @@ static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
 			      : "=d" (res) : "d" (num & -num));
 	res ^= 31;
 out:
-	return ((long)p - (long)vaddr - 4) * 8 + res;
+	res += ((long)p - (long)vaddr - 4) * 8;
+	return res < size ? res : size;
 }
 
 static inline int find_next_bit(const unsigned long *vaddr, int size,
@@ -261,9 +270,14 @@ static inline int find_next_bit(const unsigned long *vaddr, int size,
 		/* Look for one in first longword */
 		__asm__ __volatile__ ("bfffo %1{#0,#0},%0"
 				      : "=d" (res) : "d" (num & -num));
-		if (res < 32)
-			return offset + (res ^ 31);
+		if (res < 32) {
+			offset += res ^ 31;
+			return offset < size ? offset : size;
+		}
 		offset += 32;
+
+		if (offset >= size)
+			return size;
 	}
 	/* No one yet, search remaining full bytes for a one */
 	return offset + find_first_bit(p, size - offset);
@@ -364,23 +378,25 @@ static inline int test_bit_le(int nr, const void *vaddr)
 static inline int find_first_zero_bit_le(const void *vaddr, unsigned size)
 {
 	const unsigned long *p = vaddr, *addr = vaddr;
-	int res;
+	int res = 0;
+	unsigned int words;
 
 	if (!size)
 		return 0;
 
-	size = (size >> 5) + ((size & 31) > 0);
-	while (*p++ == ~0UL)
-	{
-		if (--size == 0)
-			return (p - addr) << 5;
+	words = (size >> 5) + ((size & 31) > 0);
+	while (*p++ == ~0UL) {
+		if (--words == 0)
+			goto out;
 	}
 
 	--p;
 	for (res = 0; res < 32; res++)
 		if (!test_bit_le(res, p))
 			break;
-	return (p - addr) * 32 + res;
+out:
+	res += (p - addr) * 32;
+	return res < size ? res : size;
 }
 
 static inline unsigned long find_next_zero_bit_le(const void *addr,
@@ -398,10 +414,15 @@ static inline unsigned long find_next_zero_bit_le(const void *addr,
 		offset -= bit;
 		/* Look for zero in first longword */
 		for (res = bit; res < 32; res++)
-			if (!test_bit_le(res, p))
-				return offset + res;
+			if (!test_bit_le(res, p)) {
+				offset += res;
+				return offset < size ? offset : size;
+			}
 		p++;
 		offset += 32;
+
+		if (offset >= size)
+			return size;
 	}
 	/* No zero yet, search remaining full bytes for a zero */
 	return offset + find_first_zero_bit_le(p, size - offset);
@@ -410,22 +431,25 @@ static inline unsigned long find_next_zero_bit_le(const void *addr,
 static inline int find_first_bit_le(const void *vaddr, unsigned size)
 {
 	const unsigned long *p = vaddr, *addr = vaddr;
-	int res;
+	int res = 0;
+	unsigned int words;
 
 	if (!size)
 		return 0;
 
-	size = (size >> 5) + ((size & 31) > 0);
+	words = (size >> 5) + ((size & 31) > 0);
 	while (*p++ == 0UL) {
-		if (--size == 0)
-			return (p - addr) << 5;
+		if (--words == 0)
+			goto out;
 	}
 
 	--p;
 	for (res = 0; res < 32; res++)
 		if (test_bit_le(res, p))
 			break;
-	return (p - addr) * 32 + res;
+out:
+	res += (p - addr) * 32;
+	return res < size ? res : size;
 }
 
 static inline unsigned long find_next_bit_le(const void *addr,
@@ -443,10 +467,15 @@ static inline unsigned long find_next_bit_le(const void *addr,
 		offset -= bit;
 		/* Look for one in first longword */
 		for (res = bit; res < 32; res++)
-			if (test_bit_le(res, p))
-				return offset + res;
+			if (test_bit_le(res, p)) {
+				offset += res;
+				return offset < size ? offset : size;
+			}
 		p++;
 		offset += 32;
+
+		if (offset >= size)
+			return size;
 	}
 	/* No set bit yet, search remaining full bytes for a set bit */
 	return offset + find_first_bit_le(p, size - offset);
-- 
1.7.0.4

