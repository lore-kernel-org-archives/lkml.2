Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab0KWUHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 15:07:24 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:61323 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0KWUHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 15:07:23 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Decompressors: Fix callback-to-callback mode in decompress_unlzo.c
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
From: Lasse Collin <lasse.collin@tukaani.org>
Date: Tue, 23 Nov 2010 22:06:53 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011232206.53497.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

Callback-to-callback decompression mode is used for initrd
(not initramfs). The LZO wrapper is broken for this use case
for two reasons:

  - The argument validation is needlessly too strict by
    requiring that "posp" is non-NULL when "fill" is non-NULL.

  - The buffer handling code didn't work at all for this
    use case.

I tested with LZO-compressed kernel, initramfs, initrd, and
corrupt (truncated) initramfs and initrd images.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

Avoiding memmove() for pre-boot compatibility is ugly.

Is lzo1x_worst_compress() needed in this file at all? src_len
is required to not exceed dst_len, and dst_len must not exceed
LZO_BLOCK_SIZE.

Since LZO-compressed initrd is clearly not very important
(initramfs works), maybe it would be simpler and smaller
to explicitly drop support for callback-to-callback API in
the LZO wrapper.

--- linux-2.6.37-rc3/lib/decompress_unlzo.c.orig	2010-11-23 15:54:00.000000000 +0200
+++ linux-2.6.37-rc3/lib/decompress_unlzo.c	2010-11-23 18:26:59.000000000 +0200
@@ -142,8 +142,8 @@ STATIC inline int INIT unlzo(u8 *input,
 		goto exit_1;
 	} else if (input) {
 		in_buf = input;
-	} else if (!fill || !posp) {
-		error("NULL input pointer and missing position pointer or fill function");
+	} else if (!fill) {
+		error("NULL input pointer and missing fill function");
 		goto exit_1;
 	} else {
 		in_buf = malloc(lzo1x_worst_compress(LZO_BLOCK_SIZE));
@@ -157,21 +157,40 @@ STATIC inline int INIT unlzo(u8 *input,
 	if (posp)
 		*posp = 0;
 
-	if (fill)
-		fill(in_buf, lzo1x_worst_compress(LZO_BLOCK_SIZE));
+	if (fill) {
+		/*
+		 * Start from in_buf + HEADER_SIZE_MAX to make it possible
+		 * to use memcpy() to copy the unused data to the beginning
+		 * of the buffer. This way memmove() isn't needed which
+		 * is missing from pre-boot environments of most archs.
+		 */
+		in_buf += HEADER_SIZE_MAX;
+		in_len = fill(in_buf, HEADER_SIZE_MAX);
+	}
 
-	if (!parse_header(input, &skip, in_len)) {
+	if (!parse_header(in_buf, &skip, in_len)) {
 		error("invalid header");
 		goto exit_2;
 	}
 	in_buf += skip;
 	in_len -= skip;
 
+	if (fill) {
+		/* Move the unused data to the beginning of the buffer. */
+		memcpy(in_buf_save, in_buf, in_len);
+		in_buf = in_buf_save;
+	}
+
 	if (posp)
 		*posp = skip;
 
 	for (;;) {
 		/* read uncompressed block size */
+		if (fill && in_len < 4) {
+			skip = fill(in_buf + in_len, 4 - in_len);
+			if (skip > 0)
+				in_len += skip;
+		}
 		if (in_len < 4) {
 			error("file corrupted");
 			goto exit_2;
@@ -193,6 +212,11 @@ STATIC inline int INIT unlzo(u8 *input,
 		}
 
 		/* read compressed block size, and skip block checksum info */
+		if (fill && in_len < 8) {
+			skip = fill(in_buf + in_len, 8 - in_len);
+			if (skip > 0)
+				in_len += skip;
+		}
 		if (in_len < 8) {
 			error("file corrupted");
 			goto exit_2;
@@ -201,12 +225,21 @@ STATIC inline int INIT unlzo(u8 *input,
 		in_buf += 8;
 		in_len -= 8;
 
-		if (src_len <= 0 || src_len > dst_len || src_len > in_len) {
+		if (src_len <= 0 || src_len > dst_len) {
 			error("file corrupted");
 			goto exit_2;
 		}
 
 		/* decompress */
+		if (fill && in_len < src_len) {
+			skip = fill(in_buf + in_len, src_len - in_len);
+			if (skip > 0)
+				in_len += skip;
+		}
+		if (in_len < src_len) {
+			error("file corrupted");
+			goto exit_2;
+		}
 		tmp = dst_len;
 
 		/* When the input data is not compressed at all,
@@ -230,12 +263,19 @@ STATIC inline int INIT unlzo(u8 *input,
 			out_buf += dst_len;
 		if (posp)
 			*posp += src_len + 12;
+
+		in_buf += src_len;
+		in_len -= src_len;
 		if (fill) {
+			/*
+			 * If there happens to still be unused data left in
+			 * in_buf, move it to the beginning of the buffer.
+			 * Use a loop to avoid memmove() dependency.
+			 */
+			if (in_len > 0)
+				for (skip = 0; skip < in_len; ++skip)
+					in_buf_save[skip] = in_buf[skip];
 			in_buf = in_buf_save;
-			fill(in_buf, lzo1x_worst_compress(LZO_BLOCK_SIZE));
-		} else {
-			in_buf += src_len;
-			in_len -= src_len;
 		}
 	}
 
