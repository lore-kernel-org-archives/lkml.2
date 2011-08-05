Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab1HENe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 09:34:28 -0400
Received: from gw1.transmode.se ([195.58.98.146]:56444 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab1HENe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 09:34:27 -0400
In-Reply-To: <OF14136E0E.3F2388EF-ONC12578E3.00301969-C12578E3.00338524@LocalDomain>
References: <OF4AE0115F.3AA5397E-ONC12578DF.002EC6DF-C12578DF.003348E5@transmode.se> <01dc01cc5159$317879a0$94696ce0$@systemfabricworks.com> <OF83CC7C9C.07EC5D4A-ONC12578E2.0024F5AE-C12578E2.004163C1@transmode.se> <019501cc52d7$c8688100$59398300$@systemfabricworks.com> <OF14136E0E.3F2388EF-ONC12578E3.00301969-C12578E3.00338524@LocalDomain>
Subject: RE: [PATCH] add slice by 8 algorithm to crc32.c
X-KeepSent: 747F0842:77172E9E-C12578E3:004987D0;
 type=4; name=$KeepSent
Cc: "Bob Pearson" <rpearson@systemfabricworks.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'frank zago'" <fzago@systemfabricworks.com>,
        linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF747F0842.77172E9E-ONC12578E3.004987D0-C12578E3.004A8FCA@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Fri, 5 Aug 2011 15:34:24 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/05/2011 15:34:24
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joakim Tjernlund/Transmode wrote on 2011/08/05 11:22:44:
>
> "Bob Pearson" <rpearson@systemfabricworks.com> wrote on 2011/08/04 20:53:20:
> >
> > Sure... See below.
> >
> > > -----Original Message-----
> > > From: Joakim Tjernlund [mailto:joakim.tjernlund@transmode.se]
> > > Sent: Thursday, August 04, 2011 6:54 AM
> > > To: Bob Pearson
> > > Cc: 'Andrew Morton'; 'frank zago'; linux-kernel@vger.kernel.org
> > > Subject: RE: [PATCH] add slice by 8 algorithm to crc32.c
> > >
> > > "Bob Pearson" <rpearson@systemfabricworks.com> wrote on 2011/08/02
> > > 23:14:39:
> > > >
> > > > Hi Joakim,
> > > >
> > > > Sorry to take so long to respond.
> > >
> > > No problem but please insert you answers in correct context(like I did).
> > This
> > > makes it much easier to read and comment on.
> > >
> > > >
> > > > Here are some performance data collected from the original and modified
> > > > crc32 algorithms.
> > > > The following is a simple test loop that computes the time to compute
> > 1000
> > > > crc's over 4096 bytes of data aligned on an 8 byte boundary after
> > warming
> > > > the cache. You could make other measurements but this is sort of a best
> > > > case.
> > > >
> > > > These measurements were made on a dual socket Nehalem 2.267 GHz
> > > system.
> > >
> > > Measurements on your SPARC would be good too.
> >
> > Will do. But it is decrepit and quite slow. My main motivation is to run a
> > 10G protocol so I am mostly motivated to get x86_64 going as fast as
> > possible.
>
> 64 bits may be faster on x86_64 but not on ppc32. Your latest patch gives:
>  crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
>  crc32: self tests passed, processed 225944 bytes in 3987640 nsec
>  crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
>  crc32: self tests passed, processed 225944 bytes in 2003630 nsec
> Almost a factor 2 slower.
> So in any case I don't think 64 bits should be default for all archs.
> Probably only for 64 bit archs.

I checked the asm on ppc for 32 bits crc32 and compared yours vs. mine. PPC suffers
from your version. The startup cost is much higher. I did notice one win with your
version though. The inner loop was reduced with 3 insns if one use separate arrays.
However, loading 4 separate arrays are 16 insns on PPC so I did the best thing for
ppc:

diff --git a/lib/crc32.c b/lib/crc32.c
index 4855995..e3e391f 100644
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
+		t1[(crc >> 8) & 255] ^ \
+		t2[(crc >> 16) & 255] ^ \
+		t3[(crc >> 24) & 255]
 # endif
 	const u32 *b;
 	size_t    rem_len;
+	const u32 *t0=tab[0], *t1=t0 + 256, *t2=t1 + 256, *t3=t2 + 256;

 	/* Align it */
 	if (unlikely((long)buf & 3 && len)) {

This reduces the inner loop with 3 insns while adding only 5 insns startup cost.
I hope this brings my crc32(32 bits) in line with yours, even on x86_64.
Please test.

 Jocke

