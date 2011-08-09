Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab1HIFZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 01:25:52 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:43769 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab1HIFZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 01:25:51 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=869cbtyjxWwA:10 a=FvignuLujMYA:10 a=ozIaqLvjkoIA:10 a=8nJEP1OIZ-IA:10 a=r17jK6sfZkYSxad0qIwqKg==:17 a=YORvzBCaAAAA:8 a=25BmBtgtBz-B4cJdUwMA:9 a=KOLmSzaFiPA_HFRUbdgA:7 a=wPNLvfGTeEIA:10 a=VV2__AUApEoA:10 a=r17jK6sfZkYSxad0qIwqKg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 24.153.165.185
Message-ID: <4E40C4DD.90109@systemfabricworks.com>
Date: Tue, 09 Aug 2011 00:25:49 -0500
From: Bob Pearson <rpearson@systemfabricworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux@horizon.com,
        joakim.tjernlund@transmode.se, fzago@systemfabricworks.com,
        rpearson@systemfabricworks.com, akpm@linux-foundation.org
Subject: [patch v3 5/7] crc32: add-real-8-bit.diff
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crc32.c encodes an algorithm that processes 32 bits at a time
with the value BITS = 8 and leaves out the most common 8 bit algorithm
for computing the crc. This patch reencodes the 32 bit algorithm
with the value 32 and adds back the 'standard' 8 bit algorithm.

Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>

---
 lib/crc32.c          |   17 ++++++++++++++---
 lib/crc32defs.h      |   18 ++++++++++--------
 lib/gen_crc32table.c |   27 ++++++++++++++++++---------
 3 files changed, 42 insertions(+), 20 deletions(-)

Index: infiniband/lib/crc32.c
===================================================================
--- infiniband.orig/lib/crc32.c
+++ infiniband/lib/crc32.c
@@ -25,13 +25,13 @@
 #include <linux/types.h>
 #include "crc32defs.h"

-#if CRC_LE_BITS == 8
+#if CRC_LE_BITS > 8
 # define tole(x) (__force u32) __constant_cpu_to_le32(x)
 #else
 # define tole(x) (x)
 #endif

-#if CRC_BE_BITS == 8
+#if CRC_BE_BITS > 8
 # define tobe(x) (__force u32) __constant_cpu_to_be32(x)
 #else
 # define tobe(x) (x)
@@ -43,7 +43,7 @@ MODULE_AUTHOR("Matt Domsch <Matt_Domsch@
 MODULE_DESCRIPTION("Ethernet CRC32 calculations");
 MODULE_LICENSE("GPL");

-#if CRC_LE_BITS == 8 || CRC_BE_BITS == 8
+#if CRC_LE_BITS > 8 || CRC_BE_BITS > 8

 static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
@@ -123,6 +123,12 @@ u32 __pure crc32_le(u32 crc, unsigned ch
 		crc = (crc >> 4) ^ crc32table_le[0][crc & 15];
 	}
 # elif CRC_LE_BITS == 8
+	/* aka Sarwate algorithm */
+	while (len--) {
+		crc ^= *p++;
+		crc = (crc >> 8) ^ crc32table_le[0][crc & 255];
+	}
+# else
 	const u32      (*tab)[] = crc32table_le;

 	crc = (__force u32) __cpu_to_le32(crc);
@@ -166,6 +172,11 @@ u32 __pure crc32_be(u32 crc, unsigned ch
 		crc = (crc << 4) ^ crc32table_be[0][crc >> 28];
 	}
 # elif CRC_BE_BITS == 8
+	while (len--) {
+		crc ^= *p++ << 24;
+		crc = (crc << 8) ^ crc32table_be[0][crc >> 24];
+	}
+# else
 	const u32      (*tab)[] = crc32table_be;

 	crc = (__force u32) __cpu_to_be32(crc);
Index: infiniband/lib/crc32defs.h
===================================================================
--- infiniband.orig/lib/crc32defs.h
+++ infiniband/lib/crc32defs.h
@@ -6,27 +6,29 @@
 #define CRCPOLY_LE 0xedb88320
 #define CRCPOLY_BE 0x04c11db7

-/* How many bits at a time to use.  Requires a table of 4<<CRC_xx_BITS bytes. */
-/* For less performance-sensitive, use 4 */
+/* How many bits at a time to use.  Valid values are 1, 2, 4, 8, and 32. */
+/* For less performance-sensitive, use 4 or 8 */
 #ifndef CRC_LE_BITS
-# define CRC_LE_BITS 8
+# define CRC_LE_BITS 32
 #endif
 #ifndef CRC_BE_BITS
-# define CRC_BE_BITS 8
+# define CRC_BE_BITS 32
 #endif

 /*
  * Little-endian CRC computation.  Used with serial bit streams sent
  * lsbit-first.  Be sure to use cpu_to_le32() to append the computed CRC.
  */
-#if CRC_LE_BITS > 8 || CRC_LE_BITS < 1 || CRC_LE_BITS & CRC_LE_BITS-1
-# error CRC_LE_BITS must be a power of 2 between 1 and 8
+#if CRC_LE_BITS > 32 || CRC_LE_BITS < 1 || CRC_LE_BITS == 16 || \
+	CRC_LE_BITS & CRC_LE_BITS-1
+# error "CRC_LE_BITS must be one of {1, 2, 4, 8, 32}"
 #endif

 /*
  * Big-endian CRC computation.  Used with serial bit streams sent
  * msbit-first.  Be sure to use cpu_to_be32() to append the computed CRC.
  */
-#if CRC_BE_BITS > 8 || CRC_BE_BITS < 1 || CRC_BE_BITS & CRC_BE_BITS-1
-# error CRC_BE_BITS must be a power of 2 between 1 and 8
+#if CRC_BE_BITS > 32 || CRC_BE_BITS < 1 || CRC_BE_BITS == 16 || \
+	CRC_BE_BITS & CRC_BE_BITS-1
+# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 32}"
 #endif
Index: infiniband/lib/gen_crc32table.c
===================================================================
--- infiniband.orig/lib/gen_crc32table.c
+++ infiniband/lib/gen_crc32table.c
@@ -4,11 +4,20 @@

 #define ENTRIES_PER_LINE 4

+#if CRC_LE_BITS <= 8
 #define LE_TABLE_SIZE (1 << CRC_LE_BITS)
+#else
+#define LE_TABLE_SIZE 256
+#endif
+
+#if CRC_BE_BITS <= 8
 #define BE_TABLE_SIZE (1 << CRC_BE_BITS)
+#else
+#define BE_TABLE_SIZE 256
+#endif

-static uint32_t crc32table_le[4][LE_TABLE_SIZE];
-static uint32_t crc32table_be[4][BE_TABLE_SIZE];
+static uint32_t crc32table_le[8][256];
+static uint32_t crc32table_be[8][256];

 /**
  * crc32init_le() - allocate and initialize LE table data
@@ -24,14 +33,14 @@ static void crc32init_le(void)

 	crc32table_le[0][0] = 0;

-	for (i = 1 << (CRC_LE_BITS - 1); i; i >>= 1) {
+	for (i = LE_TABLE_SIZE >> 1; i; i >>= 1) {
 		crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
 		for (j = 0; j < LE_TABLE_SIZE; j += 2 * i)
 			crc32table_le[0][i + j] = crc ^ crc32table_le[0][j];
 	}
 	for (i = 0; i < LE_TABLE_SIZE; i++) {
 		crc = crc32table_le[0][i];
-		for (j = 1; j < 4; j++) {
+		for (j = 1; j < 8; j++) {
 			crc = crc32table_le[0][crc & 0xff] ^ (crc >> 8);
 			crc32table_le[j][i] = crc;
 		}
@@ -55,18 +64,18 @@ static void crc32init_be(void)
 	}
 	for (i = 0; i < BE_TABLE_SIZE; i++) {
 		crc = crc32table_be[0][i];
-		for (j = 1; j < 4; j++) {
+		for (j = 1; j < 8; j++) {
 			crc = crc32table_be[0][(crc >> 24) & 0xff] ^ (crc << 8);
 			crc32table_be[j][i] = crc;
 		}
 	}
 }

-static void output_table(uint32_t table[4][256], int len, char *trans)
+static void output_table(uint32_t table[8][256], int len, char *trans)
 {
 	int i, j;

-	for (j = 0 ; j < 4; j++) {
+	for (j = 0 ; j < 8; j++) {
 		printf("{");
 		for (i = 0; i < len - 1; i++) {
 			if (i % ENTRIES_PER_LINE == 0)
@@ -83,14 +92,14 @@ int main(int argc, char** argv)

 	if (CRC_LE_BITS > 1) {
 		crc32init_le();
-		printf("static const u32 crc32table_le[4][256] = {");
+		printf("static const u32 crc32table_le[8][256] = {");
 		output_table(crc32table_le, LE_TABLE_SIZE, "tole");
 		printf("};\n");
 	}

 	if (CRC_BE_BITS > 1) {
 		crc32init_be();
-		printf("static const u32 crc32table_be[4][256] = {");
+		printf("static const u32 crc32table_be[8][256] = {");
 		output_table(crc32table_be, BE_TABLE_SIZE, "tobe");
 		printf("};\n");
 	}
