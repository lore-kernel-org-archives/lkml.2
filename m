Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab2HaHGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 03:06:38 -0400
Received: from bosmailout11.eigbox.net ([66.96.186.11]:46721 "EHLO
	bosmailout11.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab2HaHGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 03:06:36 -0400
X-Greylist: delayed 2375 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Aug 2012 03:06:36 EDT
X-Authority-Analysis: v=2.0 cv=aPZHX8Bm c=1 sm=1
 a=EVDLJLhrg0sUKeqAW2r0xw==:17 a=bc2JKO6qiGsA:10 a=tW0haWE2Y5YA:10
 a=KKK01639J3UA:10 a=8nJEP1OIZ-IA:10 a=mLKWYZFlQ1UA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=gfktABbqsrHBgD1PsWcA:9 a=wPNLvfGTeEIA:10
 a=AnsiuLKgxXFeB68GILQVjQ==:117
X-EN-OrigOutIP: 10.20.18.14
X-EN-IMPSID: tJSz1j0060JCtq201JSzKP
Message-ID: <504058B2.2080901@yahoo.es>
Date: Fri, 31 Aug 2012 14:24:50 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-embedded@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>, hpa@linux.intel.com
Subject: [PATCH]  lib/decompress.c adding __init to decompress_method and
 data
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.60.254
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every time when compiling a new Linux kernel, I'm surprised that
this warning still occurs:

WARNING: vmlinux.o(.text+0x14cfd8): Section mismatch in
reference from the variable compressed_formats to the function
.init.text:gunzip()
The function compressed_formats() references
the function __init gunzip().
etc..

This patch should solve it:

Within decompress.c, compressed_formats[] needs 'a __initdata annotation', because
some of it's data members refer to functions which will be unloaded after init.

Consequently, it's user decompress_method() will get the __init prefix.

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
---
 lib/decompress.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/decompress.c b/lib/decompress.c
index 3d766b7..31a8042 100644
--- a/lib/decompress.c
+++ b/lib/decompress.c
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/string.h>
+#include <linux/init.h>
 
 #ifndef CONFIG_DECOMPRESS_GZIP
 # define gunzip NULL
@@ -31,11 +32,13 @@
 # define unlzo NULL
 #endif
 
-static const struct compress_format {
+struct compress_format {
 	unsigned char magic[2];
 	const char *name;
 	decompress_fn decompressor;
-} compressed_formats[] = {
+};
+
+static const struct compress_format compressed_formats[] __initdata = {
 	{ {037, 0213}, "gzip", gunzip },
 	{ {037, 0236}, "gzip", gunzip },
 	{ {0x42, 0x5a}, "bzip2", bunzip2 },
@@ -45,7 +48,7 @@ static const struct compress_format {
 	{ {0, 0}, NULL, NULL }
 };
 
-decompress_fn decompress_method(const unsigned char *inbuf, int len,
+decompress_fn __init decompress_method(const unsigned char *inbuf, int len,
 				const char **name)
 {
 	const struct compress_format *cf;
-- 
1.7.8.0

