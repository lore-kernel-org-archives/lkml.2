Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab0KWKTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:19:43 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:38932 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab0KWKTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:19:42 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] Decompressors: Check for read errors in decompress_unlzma.c
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
From: Lasse Collin <lasse.collin@tukaani.org>
Date: Tue, 23 Nov 2010 12:19:14 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011231219.14850.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

Return value of rc->fill() is checked in rc_read() and error()
is called when needed, but then the code continues as if nothing
had happened.

rc_read() is a void function and it's on the top of performance
critical call stacks, so propagating the error code via return
values doesn't sound like the best fix. It seems better to check
rc->buffer_size (which holds the return value of rc->fill()) in
the main loop. It does nothing bad that the code runs a little
with unknown data after a failed rc->fill().

This fixes an infinite loop in initramfs decompression if the
LZMA-compressed initramfs image is corrupt.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

--- linux-2.6.37-rc3/lib/decompress_unlzma.c.orig	2010-11-23 11:07:28.000000000 +0200
+++ linux-2.6.37-rc3/lib/decompress_unlzma.c	2010-11-23 11:10:07.000000000 +0200
@@ -637,6 +637,8 @@ STATIC inline int INIT unlzma(unsigned c
 			if (cst.rep0 == 0)
 				break;
 		}
+		if (rc.buffer_size <= 0)
+			goto exit_3;
 	}
 
 	if (posp)
@@ -644,6 +646,7 @@ STATIC inline int INIT unlzma(unsigned c
 	if (wr.flush)
 		wr.flush(wr.buffer, wr.buffer_pos);
 	ret = 0;
+exit_3:
 	large_free(p);
 exit_2:
 	if (!output)
