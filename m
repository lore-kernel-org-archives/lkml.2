Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab1HaWaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:30:21 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:64456 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756945Ab1HaWaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:30:14 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=QcSFu2tMqX8VyBnwf4xZriMeG3TVj1s8v1Rcea0EwGI= c=1 sm=0 a=eBnEfeSLl9YA:10 a=p5954LWMHmoA:10 a=ozIaqLvjkoIA:10 a=8nJEP1OIZ-IA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=YORvzBCaAAAA:8 a=iLNU1ar6AAAA:8 a=ReeRsqV8rGRsiGjCO4EA:9 a=TrVgIPLUMpz64aA65oYA:7 a=wPNLvfGTeEIA:10 a=VV2__AUApEoA:10 a=-XwJ49_kmwcA:10 a=KjnhiPwAdLhhVGBe:21 a=JWcn-0_uLNeNe3Pa:21 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
Message-ID: <4E5EB5F4.6010105@systemfabricworks.com>
Date: Wed, 31 Aug 2011 17:30:12 -0500
From: Bob Pearson <rpearson@systemfabricworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: fzago@systemfabricworks.com, rpearson@systemfabricworks.com,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        George Spelvin <linux@horizon.com>, akpm@linux-foundation.org
Subject: [PATCH v6 05/10] crc32-misc-cleanup.diff
References: <20110831213729.395283830@systemfabricworks.com>
In-Reply-To: <20110831213729.395283830@systemfabricworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Misc cleanup of lib/crc32.c and related files
	- removed unnecessary header files.
	- straightened out some convoluted ifdef's
	- rewrote some references to 2 dimensional arrays as 1 dimensional
	  arrays to make them correct. I.e. replaced tab[i] with tab[0][i].
	- a few trivial whitespace changes
	- fixed a warning in gen_crc32tables.c caused by a mismatch in the
	  type of the pointer passed to output table. Since the table is
	  only used at kernel compile time, it is simpler to make the table
	  big enough to hold the largest column size used. One cannot make the
	  column size smaller in output_table because it has to be used by
	  both the le and be tables and they can have different column sizes.

Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>

---
 lib/crc32.c          |  104 +++++++++++++++++----------------------------------
 lib/gen_crc32table.c |    6 +-
 2 files changed, 39 insertions(+), 71 deletions(-)

Index: for-next/lib/crc32.c
===================================================================
--- for-next.orig/lib/crc32.c
+++ for-next/lib/crc32.c
@@ -23,13 +23,10 @@
 /* see: Documentation/crc32.txt for a description of algorithms */
 
 #include <linux/crc32.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/compiler.h>
 #include <linux/types.h>
-#include <linux/init.h>
-#include <asm/atomic.h>
 #include "crc32defs.h"
+
 #if CRC_LE_BITS == 8
 # define tole(x) __constant_cpu_to_le32(x)
 #else
@@ -41,6 +38,7 @@
 #else
 # define tobe(x) (x)
 #endif
+
 #include "crc32table.h"
 
 MODULE_AUTHOR("Matt Domsch <Matt_Domsch@dell.com>");
@@ -96,6 +94,7 @@ crc32_body(u32 crc, unsigned char const 
 #undef DO_CRC4
 }
 #endif
+
 /**
  * crc32_le() - Calculate bitwise little-endian Ethernet AUTODIN II CRC32
  * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
@@ -103,53 +102,39 @@ crc32_body(u32 crc, unsigned char const 
  * @p: pointer to buffer over which CRC is run
  * @len: length of buffer @p
  */
-u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len);
-
-#if CRC_LE_BITS == 1
-/*
- * In fact, the table-based code will work in this case, but it can be
- * simplified by inlining the table in ?: form.
- */
-
 u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
+#if CRC_LE_BITS == 1
 	int i;
 	while (len--) {
 		crc ^= *p++;
 		for (i = 0; i < 8; i++)
 			crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
 	}
-	return crc;
-}
-#else				/* Table-based approach */
-
-u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
-{
-# if CRC_LE_BITS == 8
-	const u32      (*tab)[] = crc32table_le;
-
-	crc = __cpu_to_le32(crc);
-	crc = crc32_body(crc, p, len, tab);
-	return __le32_to_cpu(crc);
-# elif CRC_LE_BITS == 4
+# elif CRC_LE_BITS == 2
 	while (len--) {
 		crc ^= *p++;
-		crc = (crc >> 4) ^ crc32table_le[crc & 15];
-		crc = (crc >> 4) ^ crc32table_le[crc & 15];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
 	}
-	return crc;
-# elif CRC_LE_BITS == 2
+# elif CRC_LE_BITS == 4
 	while (len--) {
 		crc ^= *p++;
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
+		crc = (crc >> 4) ^ crc32table_le[0][crc & 15];
+		crc = (crc >> 4) ^ crc32table_le[0][crc & 15];
 	}
+# elif CRC_LE_BITS == 8
+	const u32      (*tab)[] = crc32table_le;
+
+	crc = __cpu_to_le32(crc);
+	crc = crc32_body(crc, p, len, tab);
+	crc = __le32_to_cpu(crc);
+#endif
 	return crc;
-# endif
 }
-#endif
+EXPORT_SYMBOL(crc32_le);
 
 /**
  * crc32_be() - Calculate bitwise big-endian Ethernet AUTODIN II CRC32
@@ -158,16 +143,9 @@ u32 __pure crc32_le(u32 crc, unsigned ch
  * @p: pointer to buffer over which CRC is run
  * @len: length of buffer @p
  */
-u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len);
-
-#if CRC_BE_BITS == 1
-/*
- * In fact, the table-based code will work in this case, but it can be
- * simplified by inlining the table in ?: form.
- */
-
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
+#if CRC_BE_BITS == 1
 	int i;
 	while (len--) {
 		crc ^= *p++ << 24;
@@ -176,39 +154,29 @@ u32 __pure crc32_be(u32 crc, unsigned ch
 			    (crc << 1) ^ ((crc & 0x80000000) ? CRCPOLY_BE :
 					  0);
 	}
-	return crc;
-}
-
-#else				/* Table-based approach */
-u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
-{
-# if CRC_BE_BITS == 8
-	const u32      (*tab)[] = crc32table_be;
-
-	crc = __cpu_to_be32(crc);
-	crc = crc32_body(crc, p, len, tab);
-	return __be32_to_cpu(crc);
-# elif CRC_BE_BITS == 4
+# elif CRC_BE_BITS == 2
 	while (len--) {
 		crc ^= *p++ << 24;
-		crc = (crc << 4) ^ crc32table_be[crc >> 28];
-		crc = (crc << 4) ^ crc32table_be[crc >> 28];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
 	}
-	return crc;
-# elif CRC_BE_BITS == 2
+# elif CRC_BE_BITS == 4
 	while (len--) {
 		crc ^= *p++ << 24;
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
+		crc = (crc << 4) ^ crc32table_be[0][crc >> 28];
+		crc = (crc << 4) ^ crc32table_be[0][crc >> 28];
 	}
-	return crc;
+# elif CRC_BE_BITS == 8
+	const u32      (*tab)[] = crc32table_be;
+
+	crc = __cpu_to_be32(crc);
+	crc = crc32_body(crc, p, len, tab);
+	crc = __be32_to_cpu(crc);
 # endif
+	return crc;
 }
-#endif
-
-EXPORT_SYMBOL(crc32_le);
 EXPORT_SYMBOL(crc32_be);
 
 #ifdef CONFIG_CRC32_SELFTEST
Index: for-next/lib/gen_crc32table.c
===================================================================
--- for-next.orig/lib/gen_crc32table.c
+++ for-next/lib/gen_crc32table.c
@@ -7,8 +7,8 @@
 #define LE_TABLE_SIZE (1 << CRC_LE_BITS)
 #define BE_TABLE_SIZE (1 << CRC_BE_BITS)
 
-static uint32_t crc32table_le[4][LE_TABLE_SIZE];
-static uint32_t crc32table_be[4][BE_TABLE_SIZE];
+static uint32_t crc32table_le[4][256];
+static uint32_t crc32table_be[4][256];
 
 /**
  * crc32init_le() - allocate and initialize LE table data
@@ -62,7 +62,7 @@ static void crc32init_be(void)
 	}
 }
 
-static void output_table(uint32_t table[4][256], int len, char *trans)
+static void output_table(uint32_t (*table)[256], int len, char *trans)
 {
 	int i, j;
 


