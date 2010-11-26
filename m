Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0KZSXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 13:23:24 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:10589 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0KZSXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 13:23:23 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Decompressors: Check input size in decompress_inflate.c
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
From: Lasse Collin <lasse.collin@tukaani.org>
Date: Fri, 26 Nov 2010 20:23:43 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011262023.43937.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

Check for end of the input buffer when skipping over
the filename field in the .gz file header.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

diff -uprN linux-2.6.37-rc3.orig/lib/decompress_inflate.c linux-2.6.37-rc3/lib/decompress_inflate.c
--- linux-2.6.37-rc3.orig/lib/decompress_inflate.c	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/lib/decompress_inflate.c	2010-11-26 19:42:15.000000000 +0200
@@ -100,13 +100,22 @@ STATIC int INIT gunzip(unsigned char *bu
 	 * possible asciz filename)
 	 */
 	strm->next_in = zbuf + 10;
+	strm->avail_in = len - 10;
 	/* skip over asciz filename */
 	if (zbuf[3] & 0x8) {
-		while (strm->next_in[0])
-			strm->next_in++;
-		strm->next_in++;
+		do {
+			/*
+			 * If the filename doesn't fit into the buffer,
+			 * the file is very probably corrupt. Don't try
+			 * to read more data.
+			 */
+			if (strm->avail_in == 0) {
+				error("header error");
+				goto gunzip_5;
+			}
+			--strm->avail_in;
+		} while (*strm->next_in++);
 	}
-	strm->avail_in = len - (strm->next_in - zbuf);
 
 	strm->next_out = out_buf;
 	strm->avail_out = out_len;
