Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab0KWUAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 15:00:49 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:50888 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0KWUAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 15:00:48 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Decompressors: Check input size in decompress_unlzo.c
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
From: Lasse Collin <lasse.collin@tukaani.org>
Date: Tue, 23 Nov 2010 22:00:18 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011232200.18949.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

The code assumes that the input is valid and not truncated.
Add checks to avoid reading past the end of the input buffer.
Change the type of "skip" from u8 to int to fix a possible
integer overflow.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

--- linux-2.6.37-rc3/lib/decompress_unlzo.c.orig	2010-11-23 12:57:46.000000000 +0200
+++ linux-2.6.37-rc3/lib/decompress_unlzo.c	2010-11-23 15:54:00.000000000 +0200
@@ -49,14 +49,25 @@ static const unsigned char lzop_magic[]
 
 #define LZO_BLOCK_SIZE        (256*1024l)
 #define HEADER_HAS_FILTER      0x00000800L
+#define HEADER_SIZE_MIN       (9 + 7     + 4 + 8     + 1       + 4)
+#define HEADER_SIZE_MAX       (9 + 7 + 1 + 8 + 8 + 4 + 1 + 255 + 4)
 
-STATIC inline int INIT parse_header(u8 *input, u8 *skip)
+STATIC inline int INIT parse_header(u8 *input, int *skip, int in_len)
 {
 	int l;
 	u8 *parse = input;
+	u8 *end = input + in_len;
 	u8 level = 0;
 	u16 version;
 
+	/*
+	 * Check that there's enough input to possibly have a valid header.
+	 * Then it is possible to parse several fields until the minimum
+	 * size may have been used.
+	 */
+	if (in_len < HEADER_SIZE_MIN)
+		return 0;
+
 	/* read magic: 9 first bits */
 	for (l = 0; l < 9; l++) {
 		if (*parse++ != lzop_magic[l])
@@ -74,6 +85,15 @@ STATIC inline int INIT parse_header(u8 *
 	else
 		parse += 4; /* flags */
 
+	/*
+	 * At least mode, mtime_low, filename length, and checksum must
+	 * be left to be parsed. If also mtime_high is present, it's OK
+	 * because the next input buffer check is after reading the
+	 * filename length.
+	 */
+	if (end - parse < 8 + 1 + 4)
+		return 0;
+
 	/* skip mode and mtime_low */
 	parse += 8;
 	if (version >= 0x0940)
@@ -81,6 +101,8 @@ STATIC inline int INIT parse_header(u8 *
 
 	l = *parse++;
 	/* don't care about the file name, and skip checksum */
+	if (end - parse < l + 4)
+		return 0;
 	parse += l + 4;
 
 	*skip = parse - input;
@@ -93,7 +115,8 @@ STATIC inline int INIT unlzo(u8 *input,
 				u8 *output, int *posp,
 				void (*error_fn) (char *x))
 {
-	u8 skip = 0, r = 0;
+	u8 r = 0;
+	int skip = 0;
 	u32 src_len, dst_len;
 	size_t tmp;
 	u8 *in_buf, *in_buf_save, *out_buf;
@@ -137,19 +160,25 @@ STATIC inline int INIT unlzo(u8 *input,
 	if (fill)
 		fill(in_buf, lzo1x_worst_compress(LZO_BLOCK_SIZE));
 
-	if (!parse_header(input, &skip)) {
+	if (!parse_header(input, &skip, in_len)) {
 		error("invalid header");
 		goto exit_2;
 	}
 	in_buf += skip;
+	in_len -= skip;
 
 	if (posp)
 		*posp = skip;
 
 	for (;;) {
 		/* read uncompressed block size */
+		if (in_len < 4) {
+			error("file corrupted");
+			goto exit_2;
+		}
 		dst_len = get_unaligned_be32(in_buf);
 		in_buf += 4;
+		in_len -= 4;
 
 		/* exit if last block */
 		if (dst_len == 0) {
@@ -164,10 +193,15 @@ STATIC inline int INIT unlzo(u8 *input,
 		}
 
 		/* read compressed block size, and skip block checksum info */
+		if (in_len < 8) {
+			error("file corrupted");
+			goto exit_2;
+		}
 		src_len = get_unaligned_be32(in_buf);
 		in_buf += 8;
+		in_len -= 8;
 
-		if (src_len <= 0 || src_len > dst_len) {
+		if (src_len <= 0 || src_len > dst_len || src_len > in_len) {
 			error("file corrupted");
 			goto exit_2;
 		}
@@ -199,8 +233,10 @@ STATIC inline int INIT unlzo(u8 *input,
 		if (fill) {
 			in_buf = in_buf_save;
 			fill(in_buf, lzo1x_worst_compress(LZO_BLOCK_SIZE));
-		} else
+		} else {
 			in_buf += src_len;
+			in_len -= src_len;
+		}
 	}
 
 	ret = 0;
