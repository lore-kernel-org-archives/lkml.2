Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab0DVPXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 11:23:49 -0400
Received: from gw1.transmode.se ([213.115.205.20]:39729 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701Ab0DVPXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 11:23:47 -0400
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Subject: [PATCH 1/2] crc32: Major optimization.
Date: Thu, 22 Apr 2010 17:23:28 +0200
Message-Id: <1271949809-24030-1-git-send-email-Joakim.Tjernlund@transmode.se>
X-Mailer: git-send-email 1.6.4.4
X-MIMETrack: Itemize by SMTP Server on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-04-22 17:23:45,
	Serialize by Router on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-04-22 17:23:45,
	Serialize complete at 2010-04-22 17:23:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Precompute more crc32 values(0xcc00, 0xcc0000 and 0xcc000000) into tables.
This increases the table size from 1KB to 4KB but the performance
benfit makes it worth it:
28% faster on MPC8321, 266 MHz
2x faster on Core 2 Duo, 3.1GHz

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
---
 lib/crc32.c          |   24 +++++++++++++++---------
 lib/gen_crc32table.c |   47 ++++++++++++++++++++++++++++++++---------------
 2 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/lib/crc32.c b/lib/crc32.c
index 0f45fbf..54ca885 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -49,12 +49,20 @@ MODULE_LICENSE("GPL");
 #if CRC_LE_BITS == 8 || CRC_BE_BITS == 8
 
 static inline u32
-crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 *tab)
+crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
 # ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[(crc ^ (x)) & 255 ] ^ (crc >> 8)
+#  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255 ] ^ (crc >> 8)
+#  define DO_CRC4 crc = tab[3][(crc) & 255 ] ^ \
+		tab[2][(crc >> 8) & 255 ] ^ \
+		tab[1][(crc >> 16) & 255 ] ^ \
+		tab[0][(crc >> 24) & 255 ]
 # else
-#  define DO_CRC(x) crc = tab[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
+#  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
+#  define DO_CRC4 crc = tab[0][(crc) & 255 ] ^ \
+		tab[1][(crc >> 8) & 255 ] ^ \
+		tab[2][(crc >> 16) & 255 ] ^ \
+		tab[3][(crc >> 24) & 255 ]
 # endif
 	const u32 *b;
 	size_t    rem_len;
@@ -71,10 +79,7 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 *tab)
 	b = (const u32 *)buf;
 	for (--b; len; --len) {
 		crc ^= *++b; /* use pre increment for speed */
-		DO_CRC(0);
-		DO_CRC(0);
-		DO_CRC(0);
-		DO_CRC(0);
+		DO_CRC4;
 	}
 	len = rem_len;
 	/* And the last few bytes */
@@ -86,6 +91,7 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 *tab)
 	}
 	return crc;
 #undef DO_CRC
+#undef DO_CRC4
 }
 #endif
 /**
@@ -118,7 +124,7 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
 # if CRC_LE_BITS == 8
-	const u32      *tab = crc32table_le;
+	const u32      (*tab)[] = crc32table_le;
 
 	crc = __cpu_to_le32(crc);
 	crc = crc32_body(crc, p, len, tab);
@@ -175,7 +181,7 @@ u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 # if CRC_BE_BITS == 8
-	const u32      *tab = crc32table_be;
+	const u32      (*tab)[] = crc32table_be;
 
 	crc = __cpu_to_be32(crc);
 	crc = crc32_body(crc, p, len, tab);
diff --git a/lib/gen_crc32table.c b/lib/gen_crc32table.c
index bea5d97..7c454aa 100644
--- a/lib/gen_crc32table.c
+++ b/lib/gen_crc32table.c
@@ -7,8 +7,8 @@
 #define LE_TABLE_SIZE (1 << CRC_LE_BITS)
 #define BE_TABLE_SIZE (1 << CRC_BE_BITS)
 
-static uint32_t crc32table_le[LE_TABLE_SIZE];
-static uint32_t crc32table_be[BE_TABLE_SIZE];
+static uint32_t crc32table_le[4][LE_TABLE_SIZE];
+static uint32_t crc32table_be[4][BE_TABLE_SIZE];
 
 /**
  * crc32init_le() - allocate and initialize LE table data
@@ -22,12 +22,19 @@ static void crc32init_le(void)
 	unsigned i, j;
 	uint32_t crc = 1;
 
-	crc32table_le[0] = 0;
+	crc32table_le[0][0] = 0;
 
 	for (i = 1 << (CRC_LE_BITS - 1); i; i >>= 1) {
 		crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
 		for (j = 0; j < LE_TABLE_SIZE; j += 2 * i)
-			crc32table_le[i + j] = crc ^ crc32table_le[j];
+			crc32table_le[0][i + j] = crc ^ crc32table_le[0][j];
+	}
+	for (i = 0; i < LE_TABLE_SIZE; i++) {
+		crc = crc32table_le[0][i];
+		for (j = 1; j < 4; j++) {
+			crc = crc32table_le[0][crc & 0xff] ^ (crc >> 8);
+			crc32table_le[j][i] = crc;
+		}
 	}
 }
 
@@ -39,25 +46,35 @@ static void crc32init_be(void)
 	unsigned i, j;
 	uint32_t crc = 0x80000000;
 
-	crc32table_be[0] = 0;
+	crc32table_be[0][0] = 0;
 
 	for (i = 1; i < BE_TABLE_SIZE; i <<= 1) {
 		crc = (crc << 1) ^ ((crc & 0x80000000) ? CRCPOLY_BE : 0);
 		for (j = 0; j < i; j++)
-			crc32table_be[i + j] = crc ^ crc32table_be[j];
+			crc32table_be[0][i + j] = crc ^ crc32table_be[0][j];
+	}
+	for (i = 0; i < BE_TABLE_SIZE; i++) {
+		crc = crc32table_be[0][i];
+		for (j = 1; j < 4; j++) {
+			crc = crc32table_be[0][(crc >> 24) & 0xff] ^ (crc << 8);
+			crc32table_be[j][i] = crc;
+		}
 	}
 }
 
-static void output_table(uint32_t table[], int len, char *trans)
+static void output_table(uint32_t table[4][256], int len, char *trans)
 {
-	int i;
+	int i,j;
 
-	for (i = 0; i < len - 1; i++) {
-		if (i % ENTRIES_PER_LINE == 0)
-			printf("\n");
-		printf("%s(0x%8.8xL), ", trans, table[i]);
+	for (j = 0 ; j < 4; j++) {
+		printf("{");
+		for (i = 0; i < len - 1; i++) {
+			if (i % ENTRIES_PER_LINE == 0)
+				printf("\n");
+			printf("%s(0x%8.8xL), ", trans, table[j][i]);
+		}
+		printf("%s(0x%8.8xL)},\n", trans, table[j][len - 1]);
 	}
-	printf("%s(0x%8.8xL)\n", trans, table[len - 1]);
 }
 
 int main(int argc, char** argv)
@@ -66,14 +83,14 @@ int main(int argc, char** argv)
 
 	if (CRC_LE_BITS > 1) {
 		crc32init_le();
-		printf("static const u32 crc32table_le[] = {");
+		printf("static const u32 crc32table_le[4][256] = {");
 		output_table(crc32table_le, LE_TABLE_SIZE, "tole");
 		printf("};\n");
 	}
 
 	if (CRC_BE_BITS > 1) {
 		crc32init_be();
-		printf("static const u32 crc32table_be[] = {");
+		printf("static const u32 crc32table_be[4][256] = {");
 		output_table(crc32table_be, BE_TABLE_SIZE, "tobe");
 		printf("};\n");
 	}
-- 
1.6.4.4

