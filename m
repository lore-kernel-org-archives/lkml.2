Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab2KNJmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:42:37 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:55082 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932815Ab2KNJmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:42:31 -0500
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [RFC PATCH 03/10] s390/bitops: find leftmost bit instruction support
Date: Wed, 14 Nov 2012 10:41:35 +0100
Message-Id: <33336ef626db644eb40f0840ad33f4f46010ff6e.1352719878.git.jang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <cover.1352719877.git.jang@linux.vnet.ibm.com>
References: <cover.1352719877.git.jang@linux.vnet.ibm.com>
In-Reply-To: <cover.1352719877.git.jang@linux.vnet.ibm.com>
References: <cover.1352719877.git.jang@linux.vnet.ibm.com>
x-cbid: 12111409-6892-0000-0000-000003880BF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flogr instruction scans a bitmap starting from the leftmost bit.
Implement support for these bitops. This could be useful to scan
bitmaps like an interrupt vector set by the hardware starting
at the leftmost bit.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/include/asm/bitops.h | 81 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index 6f57389..1542293 100644
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -640,6 +640,87 @@ static inline unsigned long find_first_bit(const unsigned long * addr,
 }
 #define find_first_bit find_first_bit
 
+/*
+ * Big endian variant whichs starts bit counting from left using
+ * the flogr (find leftmost one) instruction.
+ */
+static inline unsigned long __flo_word(unsigned long nr, unsigned long val)
+{
+	register unsigned long bit asm("2") = val;
+	register unsigned long out asm("3");
+
+	asm volatile (
+		"	.insn	rre,0xb9830000,%[bit],%[bit]\n"
+		: [bit] "+d" (bit), [out] "=d" (out) : : "cc");
+	return nr + bit;
+}
+
+/*
+ * 64 bit special left bitops format:
+ * order in memory:
+ *    00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
+ *    10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f
+ *    20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
+ *    30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f
+ * after that follows the next long with bit numbers
+ *    40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f
+ *    50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
+ *    60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f
+ *    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f
+ * The reason for this bit ordering is the fact that
+ * the hardware sets bits in a bitmap starting at bit 0
+ * and we don't want to scan the bitmap from the 'wrong
+ * end'.
+ */
+static inline unsigned long find_first_bit_left(const unsigned long *addr,
+						unsigned long size)
+{
+	unsigned long bytes, bits;
+
+	if (!size)
+		return 0;
+	bytes = __ffs_word_loop(addr, size);
+	bits = __flo_word(bytes * 8, __load_ulong_be(addr, bytes));
+	return (bits < size) ? bits : size;
+}
+
+static inline int find_next_bit_left(const unsigned long *addr,
+				     unsigned long size,
+				     unsigned long offset)
+{
+	const unsigned long *p;
+	unsigned long bit, set;
+
+	if (offset >= size)
+		return size;
+	bit = offset & (__BITOPS_WORDSIZE - 1);
+	offset -= bit;
+	size -= offset;
+	p = addr + offset / __BITOPS_WORDSIZE;
+	if (bit) {
+		set = __flo_word(0, *p & (~0UL << bit));
+		if (set >= size)
+			return size + offset;
+		if (set < __BITOPS_WORDSIZE)
+			return set + offset;
+		offset += __BITOPS_WORDSIZE;
+		size -= __BITOPS_WORDSIZE;
+		p++;
+	}
+	return offset + find_first_bit_left(p, size);
+}
+
+#define for_each_set_bit_left(bit, addr, size)				\
+	for ((bit) = find_first_bit_left((addr), (size));		\
+	     (bit) < (size);						\
+	     (bit) = find_next_bit_left((addr), (size), (bit) + 1))
+
+/* same as for_each_set_bit() but use bit as value to start with */
+#define for_each_set_bit_left_cont(bit, addr, size)			\
+	for ((bit) = find_next_bit_left((addr), (size), (bit));		\
+	     (bit) < (size);						\
+	     (bit) = find_next_bit_left((addr), (size), (bit) + 1))
+
 /**
  * find_next_zero_bit - find the first zero bit in a memory region
  * @addr: The address to base the search on
-- 
1.7.12.4

