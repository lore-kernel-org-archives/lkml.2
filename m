Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1HHLm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 07:42:57 -0400
Received: from gw1.transmode.se ([195.58.98.146]:42975 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab1HHLmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 07:42:54 -0400
In-Reply-To: <20110808105201.25396.qmail@science.horizon.com>
References: <OF53580ACE.F420CB68-ONC12578E6.0039189A-C12578E6.0039CD0F@transmode.se> <20110808105201.25396.qmail@science.horizon.com>
Subject: Re: [PATCH] add slice by 8 algorithm to crc32.c
X-KeepSent: 4BB89E7A:F9308AC6-C12578E6:00402167;
 type=4; name=$KeepSent
To: "George Spelvin" <linux@horizon.com>
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com,
        linux-kernel@vger.kernel.org, rpearson@systemfabricworks.com
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF4BB89E7A.F9308AC6-ONC12578E6.00402167-C12578E6.0040598B@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Mon, 8 Aug 2011 13:42:52 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/08/2011 13:42:52
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"George Spelvin" <linux@horizon.com> wrote on 2011/08/08 12:52:01:
>
> > I prefer to keep the current code which (at the time) generated good code
> > for at least ppc:
> >    /* Align it */
> >    if (unlikely((long)buf & 3 && len)) {
> >       do {
> >          DO_CRC(*buf++);
> >       } while ((--len) && ((long)buf)&3);
> >    }
>
> Ah, I was looking at fzago's initial patch; I hadn't realized you'd
> tweaked it.  That's pretty much what I was talking about.
>
> Would
>     if (unlikely((long)buf & 3) && len) {
>
> give the compiler better hints?  len != 0 is awfully
> likely, actually.

This is my current hack. Not ideal yet, just to give you a hint:
diff --git a/lib/crc32.c b/lib/crc32.c
index b06d1e7..d822ceb 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -28,13 +28,13 @@
 #include <linux/init.h>
 #include <asm/atomic.h>
 #include "crc32defs.h"
-#if CRC_LE_BITS == 8
+#if CRC_LE_BITS == 32 || CRC_LE_BITS == 64
 # define tole(x) __constant_cpu_to_le32(x)
 #else
 # define tole(x) (x)
 #endif

-#if CRC_BE_BITS == 8
+#if CRC_BE_BITS == 32 || CRC_BE_BITS == 64
 # define tobe(x) __constant_cpu_to_be32(x)
 #else
 # define tobe(x) (x)
@@ -45,27 +45,32 @@ MODULE_AUTHOR("Matt Domsch <Matt_Domsch@dell.com>");
 MODULE_DESCRIPTION("Ethernet CRC32 calculations");
 MODULE_LICENSE("GPL");

-#if CRC_LE_BITS == 8 || CRC_BE_BITS == 8
+#if CRC_LE_BITS == 32 || CRC_BE_BITS == 64

 static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
 # ifdef __LITTLE_ENDIAN
 #  define DO_CRC(x) crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8)
-#  define DO_CRC4 crc = t3[(crc) & 255] ^ \
-		t2[(crc >> 8) & 255] ^ \
-		t1[(crc >> 16) & 255] ^ \
-		t0[(crc >> 24) & 255]
+#  define DO_CRC4(crc, x0, x1, x2, x3) \
+	x3[(crc) & 255] ^		\
+		x2[(crc >> 8) & 255] ^	\
+		x1[(crc >> 16) & 255] ^ \
+		x0[(crc >> 24) & 255]
 # else
 #  define DO_CRC(x) crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
-#  define DO_CRC4 crc = t0[(crc) & 255] ^ \
-		t1[(crc >> 8) & 255] ^  \
-		t2[(crc >> 16) & 255] ^	\
-		t3[(crc >> 24) & 255]
+#  define DO_CRC4(crc, x0, x1, x2, x3) \
+	x0[(crc) & 255] ^		\
+		x1[(crc >> 8) & 255] ^  \
+		x2[(crc >> 16) & 255] ^	\
+		x3[(crc >> 24) & 255]
 # endif
 	const u32 *b;
 	size_t    rem_len;
 	const u32 *t0=tab[0], *t1=tab[1], *t2=tab[2], *t3=tab[3];
+#if CRC_LE_BITS == 64 || CRC_BE_BITS == 64
+	const u32 *t4=tab[4], *t5=tab[5], *t6=tab[6], *t7=tab[7];
+#endif

 	/* Align it */
 	if (unlikely((long)buf & 3 && len)) {
@@ -73,13 +78,25 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 			DO_CRC(*buf++);
 		} while ((--len) && ((long)buf)&3);
 	}
+#if CRC_LE_BITS == 64 || CRC_BE_BITS == 64
+	rem_len = len & 7;
+	len = len >> 3;
+#else
 	rem_len = len & 3;
-	/* load data 32 bits wide, xor data 32 bits wide. */
 	len = len >> 2;
+#endif
+	/* load data 32 bits wide, xor data 32 bits wide. */
 	b = (const u32 *)buf;
 	for (--b; len; --len) {
 		crc ^= *++b; /* use pre increment for speed */
-		DO_CRC4;
+#if CRC_LE_BITS == 64 || CRC_BE_BITS == 64
+		crc = DO_CRC4(crc, t4, t5, t6, t7);
+		++b;
+		crc ^= DO_CRC4(*b, t0, t1, t2, t3);
+#else
+		crc = DO_CRC4(crc, t0, t1, t2, t3);
+#endif
+
 	}
 	len = rem_len;
 	/* And the last few bytes */
@@ -123,7 +140,7 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)

 u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
-# if CRC_LE_BITS == 8
+# if CRC_LE_BITS == 32 || CRC_LE_BITS == 64
 	const u32      (*tab)[] = crc32table_le;

 	crc = __cpu_to_le32(crc);
@@ -132,17 +149,17 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 # elif CRC_LE_BITS == 4
 	while (len--) {
 		crc ^= *p++;
-		crc = (crc >> 4) ^ crc32table_le[crc & 15];
-		crc = (crc >> 4) ^ crc32table_le[crc & 15];
+		crc = (crc >> 4) ^ crc32table_le[0][crc & 15];
+		crc = (crc >> 4) ^ crc32table_le[0][crc & 15];
 	}
 	return crc;
 # elif CRC_LE_BITS == 2
 	while (len--) {
 		crc ^= *p++;
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
 	}
 	return crc;
 # endif
@@ -180,7 +197,7 @@ u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 #else				/* Table-based approach */
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
-# if CRC_BE_BITS == 8
+# if CRC_BE_BITS == 32 || CRC_BE_BITS == 64
 	const u32      (*tab)[] = crc32table_be;

 	crc = __cpu_to_be32(crc);
@@ -189,17 +206,17 @@ u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 # elif CRC_BE_BITS == 4
 	while (len--) {
 		crc ^= *p++ << 24;
-		crc = (crc << 4) ^ crc32table_be[crc >> 28];
-		crc = (crc << 4) ^ crc32table_be[crc >> 28];
+		crc = (crc << 4) ^ crc32table_be[0][crc >> 28];
+		crc = (crc << 4) ^ crc32table_be[0][crc >> 28];
 	}
 	return crc;
 # elif CRC_BE_BITS == 2
 	while (len--) {
 		crc ^= *p++ << 24;
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
 	}
 	return crc;
 # endif
diff --git a/lib/crc32defs.h b/lib/crc32defs.h
index 9b6773d..c5fa3eb 100644
--- a/lib/crc32defs.h
+++ b/lib/crc32defs.h
@@ -8,25 +8,25 @@

 /* How many bits at a time to use.  Requires a table of 4<<CRC_xx_BITS bytes. */
 /* For less performance-sensitive, use 4 */
-#ifndef CRC_LE_BITS
-# define CRC_LE_BITS 8
+#ifndef CRC_LE_BITS
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
+#if CRC_LE_BITS > 64 || CRC_LE_BITS < 1 || CRC_LE_BITS & CRC_LE_BITS-1
+# error CRC_LE_BITS must be a power of 2 between 1 and 64
 #endif

 /*
  * Big-endian CRC computation.  Used with serial bit streams sent
  * msbit-first.  Be sure to use cpu_to_be32() to append the computed CRC.
  */
-#if CRC_BE_BITS > 8 || CRC_BE_BITS < 1 || CRC_BE_BITS & CRC_BE_BITS-1
+#if CRC_BE_BITS > 64 || CRC_BE_BITS < 1 || CRC_BE_BITS & CRC_BE_BITS-1
 # error CRC_BE_BITS must be a power of 2 between 1 and 8
 #endif
diff --git a/lib/gen_crc32table.c b/lib/gen_crc32table.c
index 85d0e41..16336eb 100644
--- a/lib/gen_crc32table.c
+++ b/lib/gen_crc32table.c
@@ -4,11 +4,22 @@

 #define ENTRIES_PER_LINE 4

-#define LE_TABLE_SIZE (1 << CRC_LE_BITS)
-#define BE_TABLE_SIZE (1 << CRC_BE_BITS)
+#if CRC_LE_BITS > 8
+# define LE_TABLE_SIZE 256
+#else
+# define LE_TABLE_SIZE (1 << CRC_LE_BITS)
+#endif
+#if CRC_BE_BITS > 8
+# define BE_TABLE_SIZE 256
+#else
+# define BE_TABLE_SIZE (1 << CRC_BE_BITS)
+#endif

-static uint32_t crc32table_le[4][LE_TABLE_SIZE];
-static uint32_t crc32table_be[4][BE_TABLE_SIZE];
+#define LE_TABLE_ROWS ((CRC_LE_BITS - 1)/8 + 1)
+#define BE_TABLE_ROWS ((CRC_BE_BITS - 1)/8 + 1)
+
+static uint32_t crc32table_le[LE_TABLE_ROWS][LE_TABLE_SIZE];
+static uint32_t crc32table_be[BE_TABLE_ROWS][BE_TABLE_SIZE];

 /**
  * crc32init_le() - allocate and initialize LE table data
@@ -24,14 +35,14 @@ static void crc32init_le(void)

 	crc32table_le[0][0] = 0;

-	for (i = 1 << (CRC_LE_BITS - 1); i; i >>= 1) {
+	for (i = LE_TABLE_SIZE/2; i; i >>= 1) {
 		crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
 		for (j = 0; j < LE_TABLE_SIZE; j += 2 * i)
 			crc32table_le[0][i + j] = crc ^ crc32table_le[0][j];
 	}
 	for (i = 0; i < LE_TABLE_SIZE; i++) {
 		crc = crc32table_le[0][i];
-		for (j = 1; j < 4; j++) {
+		for (j = 1; j < LE_TABLE_ROWS; j++) {
 			crc = crc32table_le[0][crc & 0xff] ^ (crc >> 8);
 			crc32table_le[j][i] = crc;
 		}
@@ -55,43 +66,47 @@ static void crc32init_be(void)
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

-static void output_table(uint32_t table[4][256], int len, char *trans)
+static void output_table(uint32_t table[], int len, char *trans)
 {
-	int i, j;
-
-	for (j = 0 ; j < 4; j++) {
-		printf("{");
-		for (i = 0; i < len - 1; i++) {
-			if (i % ENTRIES_PER_LINE == 0)
-				printf("\n");
-			printf("%s(0x%8.8xL), ", trans, table[j][i]);
-		}
-		printf("%s(0x%8.8xL)},\n", trans, table[j][len - 1]);
+	int i;
+
+	printf("{");
+	for (i = 0; i < len - 1; i++) {
+		if (i % ENTRIES_PER_LINE == 0)
+			printf("\n");
+		printf("%s(0x%8.8xL), ", trans, table[i]);
 	}
+	printf("%s(0x%8.8xL)},\n", trans, table[len - 1]);
 }

 int main(int argc, char** argv)
 {
+	int i;
+
 	printf("/* this file is generated - do not edit */\n\n");

 	if (CRC_LE_BITS > 1) {
 		crc32init_le();
-		printf("static const u32 crc32table_le[4][256] = {");
-		output_table(crc32table_le, LE_TABLE_SIZE, "tole");
+		printf("static const u32 crc32table_le[%d][%d] = {",
+		       LE_TABLE_ROWS, LE_TABLE_SIZE);
+		for (i = 0 ; i < LE_TABLE_ROWS; i++)
+			output_table(crc32table_le[i], LE_TABLE_SIZE, "tole");
 		printf("};\n");
 	}

 	if (CRC_BE_BITS > 1) {
 		crc32init_be();
-		printf("static const u32 crc32table_be[4][256] = {");
-		output_table(crc32table_be, BE_TABLE_SIZE, "tobe");
+		printf("static const u32 crc32table_be[%d][%d] = {",
+		       BE_TABLE_ROWS, BE_TABLE_SIZE);
+		for (i = 0 ; i < BE_TABLE_ROWS; i++)
+			output_table(crc32table_be[i], BE_TABLE_SIZE, "tobe");
 		printf("};\n");
 	}


