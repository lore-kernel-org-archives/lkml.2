Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab1IADDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 23:03:25 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:60181 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757379Ab1IADDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 23:03:24 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=eBnEfeSLl9YA:10 a=xO0yJxRua38A:10 a=ozIaqLvjkoIA:10 a=8nJEP1OIZ-IA:10 a=r17jK6sfZkYSxad0qIwqKg==:17 a=YORvzBCaAAAA:8 a=5zvW-lYbKXGL-XNPXjkA:9 a=6x0XxjX2yZxIvtcKrm4A:7 a=wPNLvfGTeEIA:10 a=VV2__AUApEoA:10 a=r17jK6sfZkYSxad0qIwqKg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 24.153.165.185
Message-ID: <4E5EF5F9.9020006@systemfabricworks.com>
Date: Wed, 31 Aug 2011 22:03:21 -0500
From: Bob Pearson <rpearson@systemfabricworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: fzago@systemfabricworks.com, rpearson@systemfabricworks.com,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        George Spelvin <linux@horizon.com>, akpm@linux-foundation.org
Subject: Re: [PATCH v6 08/10] crc32-add-slicing-by-8.diff
References: <20110831213729.395283830@systemfabricworks.com>
In-Reply-To: <20110831213729.395283830@systemfabricworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been looking at this stuff for too long! I just noticed that
crc32_body incorrectly always uses CRC_LE_BITS to pick algorithm.
Replace with a function parameter that will get optimized out
by the compiler since crc32_body is inlined.

add slicing-by-8 algorithm to the existing
slicing-by-4 algorithm. This consists of:
	- extend largest BITS size from 32 to 64
	- extend tables from tab[4][256] to up to tab[8][256]
	- Add code for inner loop.

Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>

---
 lib/crc32.c          |   51 ++++++++++++++++++++++++++++++++++-----------------
 lib/crc32defs.h      |   29 +++++++++++++++++++++--------
 lib/gen_crc32table.c |   43 +++++++++++++++++++++++++++----------------
 3 files changed, 82 insertions(+), 41 deletions(-)

Index: for-next/lib/crc32.c
===================================================================
--- for-next.orig/lib/crc32.c
+++ for-next/lib/crc32.c
@@ -47,25 +47,29 @@ MODULE_LICENSE("GPL");
 
 #if CRC_LE_BITS > 8 || CRC_BE_BITS > 8
 
+/* implements slicing-by-4 or slicing-by-8 algorithm */
 static inline u32
-crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
+crc32_body(u32 crc, unsigned char const *buf, size_t len,
+	   const u32 (*tab)[256], const unsigned bits)
 {
 # ifdef __LITTLE_ENDIAN
 #  define DO_CRC(x) (crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8))
-#  define DO_CRC4 crc = t3[(crc) & 255] ^ \
-			t2[(crc >> 8) & 255] ^ \
-			t1[(crc >> 16) & 255] ^ \
-			t0[(crc >> 24) & 255]
+#  define DO_CRC4 (t3[(q) & 255] ^ t2[(q >> 8) & 255] ^ \
+		   t1[(q >> 16) & 255] ^ t0[(q >> 24) & 255])
+#  define DO_CRC8 (t7[(q) & 255] ^ t6[(q >> 8) & 255] ^ \
+		   t5[(q >> 16) & 255] ^ t4[(q >> 24) & 255])
 # else
 #  define DO_CRC(x) (crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8))
-#  define DO_CRC4 crc = t0[(crc) & 255] ^ \
-			t1[(crc >> 8) & 255] ^ \
-			t2[(crc >> 16) & 255] ^ \
-			t3[(crc >> 24) & 255]
+#  define DO_CRC4 (t0[(q) & 255] ^ t1[(q >> 8) & 255] ^ \
+		   t2[(q >> 16) & 255] ^ t3[(q >> 24) & 255])
+#  define DO_CRC8 (t4[(q) & 255] ^ t5[(q >> 8) & 255] ^ \
+		   t6[(q >> 16) & 255] ^ t7[(q >> 24) & 255])
 # endif
 	const u32 *b;
-	size_t    rem_len;
+	size_t rem_len;
 	const u32 *t0 = tab[0], *t1 = tab[1], *t2 = tab[2], *t3 = tab[3];
+	const u32 *t4 = tab[4], *t5 = tab[5], *t6 = tab[6], *t7 = tab[7];
+	u32 q;
 
 	/* Align it */
 	if (unlikely((long)buf & 3 && len)) {
@@ -73,13 +77,25 @@ crc32_body(u32 crc, unsigned char const 
 			DO_CRC(*buf++);
 		} while ((--len) && ((long)buf)&3);
 	}
-	rem_len = len & 3;
-	/* load data 32 bits wide, xor data 32 bits wide. */
-	len = len >> 2;
+
+	if (bits == 32) {
+		rem_len = len & 3;
+		len = len >> 2;
+	} else {
+		rem_len = len & 7;
+		len = len >> 3;
+	}
+
 	b = (const u32 *)buf;
 	for (--b; len; --len) {
-		crc ^= *++b; /* use pre increment for speed */
-		DO_CRC4;
+		q = crc ^ *++b; /* use pre increment for speed */
+		if (bits == 32)
+			crc = DO_CRC4;
+		else {
+			crc = DO_CRC8;
+			q = *++b;
+			crc ^= DO_CRC4;
+		}
 	}
 	len = rem_len;
 	/* And the last few bytes */
@@ -92,6 +108,7 @@ crc32_body(u32 crc, unsigned char const 
 	return crc;
 #undef DO_CRC
 #undef DO_CRC4
+#undef DO_CRC8
 }
 #endif
 
@@ -135,7 +152,7 @@ u32 __pure crc32_le(u32 crc, unsigned ch
 	const u32      (*tab)[] = crc32table_le;
 
 	crc = (__force u32) __cpu_to_le32(crc);
-	crc = crc32_body(crc, p, len, tab);
+	crc = crc32_body(crc, p, len, tab, CRC_LE_BITS);
 	crc = __le32_to_cpu((__force __le32)crc);
 #endif
 	return crc;
@@ -183,7 +200,7 @@ u32 __pure crc32_be(u32 crc, unsigned ch
 	const u32      (*tab)[] = crc32table_be;
 
 	crc = (__force u32) __cpu_to_be32(crc);
-	crc = crc32_body(crc, p, len, tab);
+	crc = crc32_body(crc, p, len, tab, CRC_BE_BITS);
 	crc = __be32_to_cpu((__force __be32)crc);
 # endif
 	return crc;
Index: for-next/lib/crc32defs.h
===================================================================
--- for-next.orig/lib/crc32defs.h
+++ for-next/lib/crc32defs.h
@@ -6,29 +6,42 @@
 #define CRCPOLY_LE 0xedb88320
 #define CRCPOLY_BE 0x04c11db7
 
-/* How many bits at a time to use.  Valid values are 1, 2, 4, 8, and 32. */
-/* For less performance-sensitive, use 4 or 8 */
+/*
+ * How many bits at a time to use.  Valid values are 1, 2, 4, 8, 32 and 64.
+ * For less performance-sensitive, use 4 or 8 to save table size.
+ * For larger systems choose same as CPU architecture as default.
+ * This works well on X86_64, SPARC64 systems. This may require some
+ * elaboration after experiments with other architectures.
+ */
 #ifndef CRC_LE_BITS
-# define CRC_LE_BITS 32
+#  ifdef CONFIG_64BIT
+#  define CRC_LE_BITS 64
+#  else
+#  define CRC_LE_BITS 32
+#  endif
 #endif
 #ifndef CRC_BE_BITS
-# define CRC_BE_BITS 32
+#  ifdef CONFIG_64BIT
+#  define CRC_BE_BITS 64
+#  else
+#  define CRC_BE_BITS 32
+#  endif
 #endif
 
 /*
  * Little-endian CRC computation.  Used with serial bit streams sent
  * lsbit-first.  Be sure to use cpu_to_le32() to append the computed CRC.
  */
-#if CRC_LE_BITS > 32 || CRC_LE_BITS < 1 || CRC_LE_BITS == 16 || \
+#if CRC_LE_BITS > 64 || CRC_LE_BITS < 1 || CRC_LE_BITS == 16 || \
 	CRC_LE_BITS & CRC_LE_BITS-1
-# error "CRC_LE_BITS must be one of {1, 2, 4, 8, 32}"
+# error "CRC_LE_BITS must be one of {1, 2, 4, 8, 32, 64}"
 #endif
 
 /*
  * Big-endian CRC computation.  Used with serial bit streams sent
  * msbit-first.  Be sure to use cpu_to_be32() to append the computed CRC.
  */
-#if CRC_BE_BITS > 32 || CRC_BE_BITS < 1 || CRC_BE_BITS == 16 || \
+#if CRC_BE_BITS > 64 || CRC_BE_BITS < 1 || CRC_BE_BITS == 16 || \
 	CRC_BE_BITS & CRC_BE_BITS-1
-# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 32}"
+# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 32, 64}"
 #endif
Index: for-next/lib/gen_crc32table.c
===================================================================
--- for-next.orig/lib/gen_crc32table.c
+++ for-next/lib/gen_crc32table.c
@@ -1,23 +1,28 @@
 #include <stdio.h>
+#include "../include/generated/autoconf.h"
 #include "crc32defs.h"
 #include <inttypes.h>
 
 #define ENTRIES_PER_LINE 4
 
-#if CRC_LE_BITS <= 8
-#define LE_TABLE_SIZE (1 << CRC_LE_BITS)
+#if CRC_LE_BITS > 8
+# define LE_TABLE_ROWS (CRC_LE_BITS/8)
+# define LE_TABLE_SIZE 256
 #else
-#define LE_TABLE_SIZE 256
+# define LE_TABLE_ROWS 1
+# define LE_TABLE_SIZE (1 << CRC_LE_BITS)
 #endif
 
-#if CRC_BE_BITS <= 8
-#define BE_TABLE_SIZE (1 << CRC_BE_BITS)
+#if CRC_BE_BITS > 8
+# define BE_TABLE_ROWS (CRC_BE_BITS/8)
+# define BE_TABLE_SIZE 256
 #else
-#define BE_TABLE_SIZE 256
+# define BE_TABLE_ROWS 1
+# define BE_TABLE_SIZE (1 << CRC_BE_BITS)
 #endif
 
-static uint32_t crc32table_le[4][256];
-static uint32_t crc32table_be[4][256];
+static uint32_t crc32table_le[LE_TABLE_ROWS][256];
+static uint32_t crc32table_be[BE_TABLE_ROWS][256];
 
 /**
  * crc32init_le() - allocate and initialize LE table data
@@ -40,7 +45,7 @@ static void crc32init_le(void)
 	}
 	for (i = 0; i < LE_TABLE_SIZE; i++) {
 		crc = crc32table_le[0][i];
-		for (j = 1; j < 4; j++) {
+		for (j = 1; j < LE_TABLE_ROWS; j++) {
 			crc = crc32table_le[0][crc & 0xff] ^ (crc >> 8);
 			crc32table_le[j][i] = crc;
 		}
@@ -64,18 +69,18 @@ static void crc32init_be(void)
 	}
 	for (i = 0; i < BE_TABLE_SIZE; i++) {
 		crc = crc32table_be[0][i];
-		for (j = 1; j < 4; j++) {
+		for (j = 1; j < BE_TABLE_ROWS; j++) {
 			crc = crc32table_be[0][(crc >> 24) & 0xff] ^ (crc << 8);
 			crc32table_be[j][i] = crc;
 		}
 	}
 }
 
-static void output_table(uint32_t (*table)[256], int len, char *trans)
+static void output_table(uint32_t (*table)[256], int rows, int len, char *trans)
 {
 	int i, j;
 
-	for (j = 0 ; j < 4; j++) {
+	for (j = 0 ; j < rows; j++) {
 		printf("{");
 		for (i = 0; i < len - 1; i++) {
 			if (i % ENTRIES_PER_LINE == 0)
@@ -92,15 +97,21 @@ int main(int argc, char** argv)
 
 	if (CRC_LE_BITS > 1) {
 		crc32init_le();
-		printf("static const u32 crc32table_le[4][256] = {");
-		output_table(crc32table_le, LE_TABLE_SIZE, "tole");
+		printf("static const u32 __cacheline_aligned "
+		       "crc32table_le[%d][%d] = {",
+		       LE_TABLE_ROWS, LE_TABLE_SIZE);
+		output_table(crc32table_le, LE_TABLE_ROWS,
+			     LE_TABLE_SIZE, "tole");
 		printf("};\n");
 	}
 
 	if (CRC_BE_BITS > 1) {
 		crc32init_be();
-		printf("static const u32 crc32table_be[4][256] = {");
-		output_table(crc32table_be, BE_TABLE_SIZE, "tobe");
+		printf("static const u32 __cacheline_aligned "
+		       "crc32table_be[%d][%d] = {",
+		       BE_TABLE_ROWS, BE_TABLE_SIZE);
+		output_table(crc32table_be, LE_TABLE_ROWS,
+			     BE_TABLE_SIZE, "tobe");
 		printf("};\n");
 	}
 
