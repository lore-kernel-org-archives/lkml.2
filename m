Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0DCHjP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 03:39:15 -0400
Received: from mail.perches.com ([173.55.12.10]:1326 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab0DCHjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 03:39:13 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] lib/hexdump.c: Reduce stack variable size and cleanups
Date: Sat,  3 Apr 2010 00:39:12 -0700
Message-Id: <f767608539d1d343190b4d9401b5b30cde39b407.1270280128.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce char linebuf[200] to the actual size required
which is 32 * 3 + 2 + 32 + 1, ie: linebuf[131]
Change examples to use bool true not int 1
Align multiline argument indentation to open parenthesis
Use temporary for ptr[j] so trigraph fits on single line
Convert printk ptr from %*p, (int)(2 * sizeof(void *)) to %p
as %p uses the same calculation for size

Signed-off-by: Joe Perches <joe@perches.com>
---
 lib/hexdump.c |   36 +++++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/lib/hexdump.c b/lib/hexdump.c
index 39af256..1bd6a97 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -34,7 +34,7 @@ EXPORT_SYMBOL(hex_asc);
  *
  * E.g.:
  *   hex_dump_to_buffer(frame->data, frame->len, 16, 1,
- *			linebuf, sizeof(linebuf), 1);
+ *			linebuf, sizeof(linebuf), true);
  *
  * example output buffer:
  * 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f  @ABCDEFGHIJKLMNO
@@ -65,8 +65,8 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
-				"%s%16.16llx", j ? " " : "",
-				(unsigned long long)*(ptr8 + j));
+					"%s%16.16llx", j ? " " : "",
+					(unsigned long long)*(ptr8 + j));
 		ascii_column = 17 * ngroups + 2;
 		break;
 	}
@@ -77,7 +77,7 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
-				"%s%8.8x", j ? " " : "", *(ptr4 + j));
+					"%s%8.8x", j ? " " : "", *(ptr4 + j));
 		ascii_column = 9 * ngroups + 2;
 		break;
 	}
@@ -88,7 +88,7 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
-				"%s%4.4x", j ? " " : "", *(ptr2 + j));
+					"%s%4.4x", j ? " " : "", *(ptr2 + j));
 		ascii_column = 5 * ngroups + 2;
 		break;
 	}
@@ -111,9 +111,10 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 
 	while (lx < (linebuflen - 1) && lx < (ascii_column - 1))
 		linebuf[lx++] = ' ';
-	for (j = 0; (j < len) && (lx + 2) < linebuflen; j++)
-		linebuf[lx++] = (isascii(ptr[j]) && isprint(ptr[j])) ? ptr[j]
-				: '.';
+	for (j = 0; (j < len) && (lx + 2) < linebuflen; j++) {
+		ch = ptr[j];
+		linebuf[lx++] = (isascii(ch) && isprint(ch)) ? ch : '.';
+	}
 nil:
 	linebuf[lx++] = '\0';
 }
@@ -143,7 +144,7 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
  *
  * E.g.:
  *   print_hex_dump(KERN_DEBUG, "raw data: ", DUMP_PREFIX_ADDRESS,
- *		16, 1, frame->data, frame->len, 1);
+ *		    16, 1, frame->data, frame->len, true);
  *
  * Example output using %DUMP_PREFIX_OFFSET and 1-byte mode:
  * 0009ab42: 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f  @ABCDEFGHIJKLMNO
@@ -151,12 +152,12 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
  * ffffffff88089af0: 73727170 77767574 7b7a7978 7f7e7d7c  pqrstuvwxyz{|}~.
  */
 void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
-			int rowsize, int groupsize,
-			const void *buf, size_t len, bool ascii)
+		    int rowsize, int groupsize,
+		    const void *buf, size_t len, bool ascii)
 {
 	const u8 *ptr = buf;
 	int i, linelen, remaining = len;
-	unsigned char linebuf[200];
+	unsigned char linebuf[32 * 3 + 2 + 32 + 1];
 
 	if (rowsize != 16 && rowsize != 32)
 		rowsize = 16;
@@ -164,13 +165,14 @@ void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
 	for (i = 0; i < len; i += rowsize) {
 		linelen = min(remaining, rowsize);
 		remaining -= rowsize;
+
 		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
-				linebuf, sizeof(linebuf), ascii);
+				   linebuf, sizeof(linebuf), ascii);
 
 		switch (prefix_type) {
 		case DUMP_PREFIX_ADDRESS:
-			printk("%s%s%*p: %s\n", level, prefix_str,
-				(int)(2 * sizeof(void *)), ptr + i, linebuf);
+			printk("%s%s%p: %s\n",
+			       level, prefix_str, ptr + i, linebuf);
 			break;
 		case DUMP_PREFIX_OFFSET:
 			printk("%s%s%.8x: %s\n", level, prefix_str, i, linebuf);
@@ -196,9 +198,9 @@ EXPORT_SYMBOL(print_hex_dump);
  * rowsize of 16, groupsize of 1, and ASCII output included.
  */
 void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
-			const void *buf, size_t len)
+			  const void *buf, size_t len)
 {
 	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, 16, 1,
-			buf, len, 1);
+		       buf, len, true);
 }
 EXPORT_SYMBOL(print_hex_dump_bytes);
-- 
1.7.0.3.311.g6a6955

