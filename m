Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1HJPsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:48:46 -0400
Received: from gw1.transmode.se ([195.58.98.146]:38848 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab1HJPsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:48:45 -0400
In-Reply-To: <002601cc576f$ff062180$fd126480$@systemfabricworks.com>
References: <4E40C5C7.2050609@systemfabricworks.com> <00d401cc565c$98eeab60$cacc0220$@systemfabricworks.com> <OF4E555F7A.DF08D1FB-ONC12578E7.005FA1A8-C12578E7.0060F7CA@transmode.se> <019701cc56e8$e606f9c0$b214ed40$@systemfabricworks.com> <OF3719A120.AE2CD7D2-ONC12578E8.00342C83-C12578E8.00402A3E@transmode.se> <002601cc576f$ff062180$fd126480$@systemfabricworks.com>
Subject: RE: [patch v3 7/7] crc32: final-cleanup.diff
X-KeepSent: D6F63A43:07F043D9-C12578E8:00565019;
 type=4; name=$KeepSent
To: "Bob Pearson" <rpearson@systemfabricworks.com>
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com,
        "'George Spelvin'" <linux@horizon.com>, linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OFD6F63A43.07F043D9-ONC12578E8.00565019-C12578E8.0056DB9D@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 10 Aug 2011 17:48:43 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/10/2011 17:48:43
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Bob Pearson" <rpearson@systemfabricworks.com> wrote on 2011/08/10 17:13:00:

> From: "Bob Pearson" <rpearson@systemfabricworks.com>
> To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>
> Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>, "'George Spelvin'" <linux@horizon.com>, <linux-kernel@vger.kernel.org>
> Date: 2011/08/10 17:13
> Subject: RE: [patch v3 7/7] crc32: final-cleanup.diff
>
> OK. Can you post your current version of crc32.c? I'll try to merge them
> together.

OK, here it comes again, prefably this should be the first patch
in the series.

>From f5268d74f1a81610820e92785397f1247946ce15 Mon Sep 17 00:00:00 2001
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Date: Fri, 5 Aug 2011 17:49:42 +0200
Subject: [PATCH] crc32: Optimize inner loop.

taking a pointer reference to each row in the crc table matrix,
one can reduce the inner loop with a few insn's on RISC
archs like PowerPC.
---
 lib/crc32.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/lib/crc32.c b/lib/crc32.c
index 4855995..b06d1e7 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -51,20 +51,21 @@ static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
 # ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255] ^ (crc >> 8)
-#  define DO_CRC4 crc = tab[3][(crc) & 255] ^ \
-		tab[2][(crc >> 8) & 255] ^ \
-		tab[1][(crc >> 16) & 255] ^ \
-		tab[0][(crc >> 24) & 255]
+#  define DO_CRC(x) crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8)
+#  define DO_CRC4 crc = t3[(crc) & 255] ^ \
+		t2[(crc >> 8) & 255] ^ \
+		t1[(crc >> 16) & 255] ^ \
+		t0[(crc >> 24) & 255]
 # else
-#  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
-#  define DO_CRC4 crc = tab[0][(crc) & 255] ^ \
-		tab[1][(crc >> 8) & 255] ^ \
-		tab[2][(crc >> 16) & 255] ^ \
-		tab[3][(crc >> 24) & 255]
+#  define DO_CRC(x) crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
+#  define DO_CRC4 crc = t0[(crc) & 255] ^ \
+		t1[(crc >> 8) & 255] ^  \
+		t2[(crc >> 16) & 255] ^	\
+		t3[(crc >> 24) & 255]
 # endif
 	const u32 *b;
 	size_t    rem_len;
+	const u32 *t0=tab[0], *t1=tab[1], *t2=tab[2], *t3=tab[3];

 	/* Align it */
 	if (unlikely((long)buf & 3 && len)) {
--
1.7.3.4

