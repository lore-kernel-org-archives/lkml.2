Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab1HKRkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:40:31 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:52464 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722Ab1HKRk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:40:29 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=QcSFu2tMqX8VyBnwf4xZriMeG3TVj1s8v1Rcea0EwGI= c=1 sm=0 a=869cbtyjxWwA:10 a=Z0g3SiXiz3EA:10 a=ozIaqLvjkoIA:10 a=8nJEP1OIZ-IA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=YORvzBCaAAAA:8 a=iLNU1ar6AAAA:8 a=76Ud1XHce3gpbvvVtb4A:9 a=-Re3mmayFClvxfzw43wA:7 a=wPNLvfGTeEIA:10 a=VV2__AUApEoA:10 a=-XwJ49_kmwcA:10 a=M4TOY_ltR3JJIW8f:21 a=ty86xH22tAjGWhH-:21 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
Message-ID: <4E44140B.3030203@systemfabricworks.com>
Date: Thu, 11 Aug 2011 12:40:27 -0500
From: Bob Pearson <rpearson@systemfabricworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, joakim.tjernlund@transmode.se,
        akpm@linux-foundation.org, linux@horizon.com,
        fzago@systemfabricworks.com
Subject: [patch v5 resending 4/5] crc32: misc-cleanup.diff
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Misc cleanup of lib/crc32.c
	- removed unnecessary header files. If it passes sparse without
	  it I took it out.
	- straightened out some convoluted ifdef's
	- code incorrectly referenced 2D crc32table_le table as
	  crc32table_l(b)e[x] instead of crc32table_l(b)e[0][x] for
	  BITS = 2 & 4. This failed sparse.
	- a few trivial whitespace changes

Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>

---
 lib/crc32.c |  104 ++++++++++++++++++++----------------------------------------
 1 file changed, 36 insertions(+), 68 deletions(-)

Index: infiniband/lib/crc32.c
===================================================================
--- infiniband.orig/lib/crc32.c
+++ infiniband/lib/crc32.c
@@ -21,13 +21,10 @@
  */

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
@@ -39,6 +36,7 @@
 #else
 # define tobe(x) (x)
 #endif
+
 #include "crc32table.h"

 MODULE_AUTHOR("Matt Domsch <Matt_Domsch@dell.com>");
@@ -94,6 +92,7 @@ crc32_body(u32 crc, unsigned char const
 #undef DO_CRC4
 }
 #endif
+
 /**
  * crc32_le() - Calculate bitwise little-endian Ethernet AUTODIN II CRC32
  * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
@@ -101,53 +100,39 @@ crc32_body(u32 crc, unsigned char const
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
@@ -156,16 +141,9 @@ u32 __pure crc32_le(u32 crc, unsigned ch
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
@@ -174,39 +152,29 @@ u32 __pure crc32_be(u32 crc, unsigned ch
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
