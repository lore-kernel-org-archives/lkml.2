Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab1HaWaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:30:30 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:36671 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757156Ab1HaWa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:30:27 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=eBnEfeSLl9YA:10 a=1ZmBndCTZbgA:10 a=ozIaqLvjkoIA:10 a=8nJEP1OIZ-IA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=YORvzBCaAAAA:8 a=uIhRfg8bZ1sTBjkDpCsA:9 a=D5P6R_fy1EJ1YqQ4GdcA:7 a=wPNLvfGTeEIA:10 a=VV2__AUApEoA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
Message-ID: <4E5EB602.5080707@systemfabricworks.com>
Date: Wed, 31 Aug 2011 17:30:26 -0500
From: Bob Pearson <rpearson@systemfabricworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: fzago@systemfabricworks.com, rpearson@systemfabricworks.com,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        George Spelvin <linux@horizon.com>, akpm@linux-foundation.org
Subject: [PATCH v6 07/10] crc32-add-real-8-bit.diff
References: <20110831213729.395283830@systemfabricworks.com>
In-Reply-To: <20110831213729.395283830@systemfabricworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crc32.c provides a choice of one of several algorithms for
computing the LSB and LSB versions of the CRC32 checksum
based on the parameters CRC_LE_BITS and CRC_BE_BITS. In the
original version the values 1, 2, 4 and 8 respectively selected
versions of the alrogithm that computed the crc 1, 2, 4 and 32
bits as a time. This patch series adds a new version that computes
the CRC 64 bits at a time. To make things easier to understand
the parameter has been reinterpreted to actually stand for the
number of bits processed in each step of the algorithm so that
the old value 8 has been replaced with the value 32. This also
allows us to add in a widely used crc algorithm that
computes the crc 8 bits at a time called the Sarwate algorithm.

Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>

---
 lib/crc32.c          |   17 ++++++++++++++---
 lib/crc32defs.h      |   18 ++++++++++--------
 lib/gen_crc32table.c |   11 ++++++++++-
 3 files changed, 34 insertions(+), 12 deletions(-)

Index: for-next/lib/crc32.c
===================================================================
--- for-next.orig/lib/crc32.c
+++ for-next/lib/crc32.c
@@ -27,13 +27,13 @@
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
@@ -45,7 +45,7 @@ MODULE_AUTHOR("Matt Domsch <Matt_Domsch@
 MODULE_DESCRIPTION("Ethernet CRC32 calculations");
 MODULE_LICENSE("GPL");
 
-#if CRC_LE_BITS == 8 || CRC_BE_BITS == 8
+#if CRC_LE_BITS > 8 || CRC_BE_BITS > 8
 
 static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
@@ -126,6 +126,12 @@ u32 __pure crc32_le(u32 crc, unsigned ch
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
@@ -169,6 +175,11 @@ u32 __pure crc32_be(u32 crc, unsigned ch
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
Index: for-next/lib/crc32defs.h
===================================================================
--- for-next.orig/lib/crc32defs.h
+++ for-next/lib/crc32defs.h
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
Index: for-next/lib/gen_crc32table.c
===================================================================
--- for-next.orig/lib/gen_crc32table.c
+++ for-next/lib/gen_crc32table.c
@@ -4,8 +4,17 @@
 
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
 
 static uint32_t crc32table_le[4][256];
 static uint32_t crc32table_be[4][256];
@@ -24,7 +33,7 @@ static void crc32init_le(void)
 
 	crc32table_le[0][0] = 0;
 
-	for (i = 1 << (CRC_LE_BITS - 1); i; i >>= 1) {
+	for (i = LE_TABLE_SIZE >> 1; i; i >>= 1) {
 		crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
 		for (j = 0; j < LE_TABLE_SIZE; j += 2 * i)
 			crc32table_le[0][i + j] = crc ^ crc32table_le[0][j];


