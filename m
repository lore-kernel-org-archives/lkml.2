Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab0KWKQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:16:17 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:14810 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab0KWKQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:16:16 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Decompressors: Fix header validation in decompress_unlzma.c
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
From: Lasse Collin <lasse.collin@tukaani.org>
Date: Tue, 23 Nov 2010 12:15:48 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011231215.48850.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

Validation of header.pos calls error() but doesn't make the
function return to indicate an error to the caller. Instead
the decoding is attempted with invalid header.pos. This
fixes it.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

--- linux-2.6.37-rc3/lib/decompress_unlzma.c.orig	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/lib/decompress_unlzma.c	2010-11-23 11:07:28.000000000 +0200
@@ -580,8 +580,10 @@ STATIC inline int INIT unlzma(unsigned c
 		((unsigned char *)&header)[i] = *rc.ptr++;
 	}
 
-	if (header.pos >= (9 * 5 * 5))
+	if (header.pos >= (9 * 5 * 5)) {
 		error("bad header");
+		goto exit_1;
+	}
 
 	mi = 0;
 	lc = header.pos;
