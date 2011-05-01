Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761082Ab1EAQsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 12:48:42 -0400
Received: from mailfw02.zoner.fi ([84.34.147.249]:22824 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760992Ab1EAQsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 12:48:40 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 May 2011 12:48:39 EDT
From: Lasse Collin <lasse.collin@tukaani.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] XZ decompressor: Fix decoding of empty LZMA2 streams
Date: Sun, 1 May 2011 19:38:42 +0300
User-Agent: KMail/1.13.7 (Linux/2.6.38-ARCH; KDE/4.6.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105011938.42851.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

The old code considered valid empty LZMA2 streams to be corrupt.
Note that a typical empty .xz file has no LZMA2 data at all,
and thus most .xz files having no uncompressed data are handled
correctly even without this fix.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

 lib/xz/xz_dec_lzma2.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -uprN linux-2.6.39-rc5-git5.orig/lib/xz/xz_dec_lzma2.c linux-2.6.39-rc5-git5/lib/xz/xz_dec_lzma2.c
--- linux-2.6.39-rc5-git5.orig/lib/xz/xz_dec_lzma2.c	2011-05-01 17:56:38.000000000 +0300
+++ linux-2.6.39-rc5-git5/lib/xz/xz_dec_lzma2.c	2011-05-01 18:06:03.000000000 +0300
@@ -969,6 +969,9 @@ XZ_EXTERN enum xz_ret xz_dec_lzma2_run(s
 			 */
 			tmp = b->in[b->in_pos++];
 
+			if (tmp == 0x00)
+				return XZ_STREAM_END;
+
 			if (tmp >= 0xE0 || tmp == 0x01) {
 				s->lzma2.need_props = true;
 				s->lzma2.need_dict_reset = false;
@@ -1001,9 +1004,6 @@ XZ_EXTERN enum xz_ret xz_dec_lzma2_run(s
 						lzma_reset(s);
 				}
 			} else {
-				if (tmp == 0x00)
-					return XZ_STREAM_END;
-
 				if (tmp > 0x02)
 					return XZ_DATA_ERROR;
 
