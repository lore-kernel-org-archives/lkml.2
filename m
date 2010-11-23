Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab0KWT51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:57:27 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:1405 "EHLO mailfw02.zoner.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab0KWT51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:57:27 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Decompressors: Check for write errors in decompress_unlzo.c
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
From: Lasse Collin <lasse.collin@tukaani.org>
Date: Tue, 23 Nov 2010 21:56:56 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011232156.56374.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

The return value of flush() is not checked in unlzo().
This means that the decompressor won't stop even if the
caller doesn't want more data. This can happen e.g. with
a corrupt LZO-compressed initramfs image.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

--- linux-2.6.37-rc3/lib/decompress_unlzo.c.orig	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/lib/decompress_unlzo.c	2010-11-23 12:57:46.000000000 +0200
@@ -190,8 +190,8 @@ STATIC inline int INIT unlzo(u8 *input,
 			}
 		}
 
-		if (flush)
-			flush(out_buf, dst_len);
+		if (flush && flush(out_buf, dst_len) != dst_len)
+			goto exit_2;
 		if (output)
 			out_buf += dst_len;
 		if (posp)
