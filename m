Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab0KVRvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 12:51:00 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:5641 "EHLO mailfw02.zoner.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab0KVRu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 12:50:58 -0500
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Nov 2010 12:50:58 EST
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Decompressors: Get rid of set_error_fn() macro
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
From: Lasse Collin <lasse.collin@tukaani.org>
Date: Mon, 22 Nov 2010 19:50:32 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011221950.32903.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

set_error_fn() has become a useless complication after the commit
c1e7c3ae59b065bf7ff24a05cb609b2f9e314db6 fixed the use of error()
in malloc(). Only decompress_unlzma.c had some use for it and that
was easy to change too.

This also gets rid of the static function pointer "error", which
should have been marked as __initdata.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

 include/linux/decompress/mm.h |    5 -----
 lib/decompress_bunzip2.c      |    7 +++----
 lib/decompress_inflate.c      |    3 +--
 lib/decompress_unlzma.c       |   11 ++++++-----
 lib/decompress_unlzo.c        |    4 +---
 5 files changed, 11 insertions(+), 19 deletions(-)

diff -uprN linux-2.6.37-rc3.orig/include/linux/decompress/mm.h linux-2.6.37-rc3/include/linux/decompress/mm.h
--- linux-2.6.37-rc3.orig/include/linux/decompress/mm.h	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/include/linux/decompress/mm.h	2010-11-22 14:38:17.000000000 +0200
@@ -61,8 +61,6 @@ static void free(void *where)
 #define large_malloc(a) malloc(a)
 #define large_free(a) free(a)
 
-#define set_error_fn(x)
-
 #define INIT
 
 #else /* STATIC */
@@ -84,9 +82,6 @@ static void free(void *where)
 #define large_malloc(a) vmalloc(a)
 #define large_free(a) vfree(a)
 
-static void(*error)(char *m);
-#define set_error_fn(x) error = x;
-
 #define INIT __init
 #define STATIC
 
diff -uprN linux-2.6.37-rc3.orig/lib/decompress_bunzip2.c linux-2.6.37-rc3/lib/decompress_bunzip2.c
--- linux-2.6.37-rc3.orig/lib/decompress_bunzip2.c	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/lib/decompress_bunzip2.c	2010-11-22 14:38:17.000000000 +0200
@@ -682,13 +682,12 @@ STATIC int INIT bunzip2(unsigned char *b
 			int(*flush)(void*, unsigned int),
 			unsigned char *outbuf,
 			int *pos,
-			void(*error_fn)(char *x))
+			void(*error)(char *x))
 {
 	struct bunzip_data *bd;
 	int i = -1;
 	unsigned char *inbuf;
 
-	set_error_fn(error_fn);
 	if (flush)
 		outbuf = malloc(BZIP2_IOBUF_SIZE);
 
@@ -751,8 +750,8 @@ STATIC int INIT decompress(unsigned char
 			int(*flush)(void*, unsigned int),
 			unsigned char *outbuf,
 			int *pos,
-			void(*error_fn)(char *x))
+			void(*error)(char *x))
 {
-	return bunzip2(buf, len - 4, fill, flush, outbuf, pos, error_fn);
+	return bunzip2(buf, len - 4, fill, flush, outbuf, pos, error);
 }
 #endif
diff -uprN linux-2.6.37-rc3.orig/lib/decompress_inflate.c linux-2.6.37-rc3/lib/decompress_inflate.c
--- linux-2.6.37-rc3.orig/lib/decompress_inflate.c	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/lib/decompress_inflate.c	2010-11-22 14:38:17.000000000 +0200
@@ -38,13 +38,12 @@ STATIC int INIT gunzip(unsigned char *bu
 		       int(*flush)(void*, unsigned int),
 		       unsigned char *out_buf,
 		       int *pos,
-		       void(*error_fn)(char *x)) {
+		       void(*error)(char *x)) {
 	u8 *zbuf;
 	struct z_stream_s *strm;
 	int rc;
 	size_t out_len;
 
-	set_error_fn(error_fn);
 	rc = -1;
 	if (flush) {
 		out_len = 0x8000; /* 32 K */
diff -uprN linux-2.6.37-rc3.orig/lib/decompress_unlzma.c linux-2.6.37-rc3/lib/decompress_unlzma.c
--- linux-2.6.37-rc3.orig/lib/decompress_unlzma.c	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/lib/decompress_unlzma.c	2010-11-22 14:38:17.000000000 +0200
@@ -74,6 +74,7 @@ struct rc {
 	uint32_t code;
 	uint32_t range;
 	uint32_t bound;
+	void (*error)(char *);
 };
 
 
@@ -92,7 +93,7 @@ static void INIT rc_read(struct rc *rc)
 {
 	rc->buffer_size = rc->fill((char *)rc->buffer, LZMA_IOBUF_SIZE);
 	if (rc->buffer_size <= 0)
-		error("unexpected EOF");
+		rc->error("unexpected EOF");
 	rc->ptr = rc->buffer;
 	rc->buffer_end = rc->buffer + rc->buffer_size;
 }
@@ -536,7 +537,7 @@ STATIC inline int INIT unlzma(unsigned c
 			      int(*flush)(void*, unsigned int),
 			      unsigned char *output,
 			      int *posp,
-			      void(*error_fn)(char *x)
+			      void(*error)(char *x)
 	)
 {
 	struct lzma_header header;
@@ -552,7 +553,7 @@ STATIC inline int INIT unlzma(unsigned c
 	unsigned char *inbuf;
 	int ret = -1;
 
-	set_error_fn(error_fn);
+	rc.error = error;
 
 	if (buf)
 		inbuf = buf;
@@ -659,9 +660,9 @@ STATIC int INIT decompress(unsigned char
 			      int(*flush)(void*, unsigned int),
 			      unsigned char *output,
 			      int *posp,
-			      void(*error_fn)(char *x)
+			      void(*error)(char *x)
 	)
 {
-	return unlzma(buf, in_len - 4, fill, flush, output, posp, error_fn);
+	return unlzma(buf, in_len - 4, fill, flush, output, posp, error);
 }
 #endif
diff -uprN linux-2.6.37-rc3.orig/lib/decompress_unlzo.c linux-2.6.37-rc3/lib/decompress_unlzo.c
--- linux-2.6.37-rc3.orig/lib/decompress_unlzo.c	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/lib/decompress_unlzo.c	2010-11-22 14:38:17.000000000 +0200
@@ -91,7 +91,7 @@ STATIC inline int INIT unlzo(u8 *input,
 				int (*fill) (void *, unsigned int),
 				int (*flush) (void *, unsigned int),
 				u8 *output, int *posp,
-				void (*error_fn) (char *x))
+				void (*error) (char *x))
 {
 	u8 skip = 0, r = 0;
 	u32 src_len, dst_len;
@@ -99,8 +99,6 @@ STATIC inline int INIT unlzo(u8 *input,
 	u8 *in_buf, *in_buf_save, *out_buf;
 	int ret = -1;
 
-	set_error_fn(error_fn);
-
 	if (output) {
 		out_buf = output;
 	} else if (!flush) {
