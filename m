Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab0KWK0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:26:20 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:58653 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab0KWK0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:26:19 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Decompressors: Validate match distance in decompress_unlzma.c
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
From: Lasse Collin <lasse.collin@tukaani.org>
Date: Tue, 23 Nov 2010 12:25:42 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011231225.42440.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

Validate the newly decoded distance (rep0) in process_bit1().
This is to detect corrupt LZMA data quickly. The old code can
run for long time producing garbage until it hits the end of
the input.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

--- linux-2.6.37-rc3/lib/decompress_unlzma.c.orig	2010-11-23 11:11:58.000000000 +0200
+++ linux-2.6.37-rc3/lib/decompress_unlzma.c	2010-11-23 11:13:30.000000000 +0200
@@ -528,6 +528,9 @@ static inline int INIT process_bit1(stru
 			cst->rep0 = pos_slot;
 		if (++(cst->rep0) == 0)
 			return 0;
+		if (cst->rep0 > wr->header->dict_size
+				|| cst->rep0 > get_pos(wr))
+			return -1;
 	}
 
 	len += LZMA_MATCH_MIN_LEN;
