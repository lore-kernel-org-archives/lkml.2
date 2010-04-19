Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0DSTNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:13:00 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:58524 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0DSTM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:12:56 -0400
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: [PATCH 1/2] lib: fix the use of LZO to decompress initramfs images
Date: Mon, 19 Apr 2010 21:03:52 +0200
Message-Id: <1271703833-20058-2-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271703833-20058-1-git-send-email-albin.tonnerre@free-electrons.com>
References: <1271703833-20058-1-git-send-email-albin.tonnerre@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes 2 issues with the LZO decompressor:
 - It doesn't handle the case where a block isn't compressed at all. In
   this case, calling lzo1x_decompress_safe will fail, so we need to
   just use memcpy() instead (the upstream LZO code does something
   similar)
 - Since commit 54291362d2a5738e1b0495df2abcb9e6b0563a3f, the
   decompressor return code is checked in the init/initramfs.c
   The LZO decompressor didn't return the expected value, causing the
   initramfs code to falsely believe a decompression error occured

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Tested-By: bert schulze <spambemyguest@googlemail.com>
--
 lib/decompress_unlzo.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/lib/decompress_unlzo.c b/lib/decompress_unlzo.c
index db521f4..bcb3a4b 100644
--- a/lib/decompress_unlzo.c
+++ b/lib/decompress_unlzo.c
@@ -97,7 +97,7 @@ STATIC inline int INIT unlzo(u8 *input, int in_len,
 	u32 src_len, dst_len;
 	size_t tmp;
 	u8 *in_buf, *in_buf_save, *out_buf;
-	int obytes_processed = 0;
+	int ret = -1;
 
 	set_error_fn(error_fn);
 
@@ -174,15 +174,22 @@ STATIC inline int INIT unlzo(u8 *input, int in_len,
 
 		/* decompress */
 		tmp = dst_len;
-		r = lzo1x_decompress_safe((u8 *) in_buf, src_len,
+
+		/* When the input data is not compressed at all,
+		 * lzo1x_decompress_safe will fail, so call memcpy()
+		 * instead */
+		if (unlikely(dst_len == src_len))
+			memcpy(out_buf, in_buf, src_len);
+		else {
+			r = lzo1x_decompress_safe((u8 *) in_buf, src_len,
 						out_buf, &tmp);
 
-		if (r != LZO_E_OK || dst_len != tmp) {
-			error("Compressed data violation");
-			goto exit_2;
+			if (r != LZO_E_OK || dst_len != tmp) {
+				error("Compressed data violation");
+				goto exit_2;
+			}
 		}
 
-		obytes_processed += dst_len;
 		if (flush)
 			flush(out_buf, dst_len);
 		if (output)
@@ -196,6 +203,7 @@ STATIC inline int INIT unlzo(u8 *input, int in_len,
 			in_buf += src_len;
 	}
 
+	ret = 0;
 exit_2:
 	if (!input)
 		free(in_buf);
@@ -203,7 +211,7 @@ exit_1:
 	if (!output)
 		free(out_buf);
 exit:
-	return obytes_processed;
+	return ret;
 }
 
 #define decompress unlzo
-- 
1.7.0.4

