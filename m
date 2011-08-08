Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab1HHKbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 06:31:23 -0400
Received: from gw1.transmode.se ([195.58.98.146]:53525 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab1HHKbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 06:31:22 -0400
In-Reply-To: <20110808092826.21881.qmail@science.horizon.com>
References: <20110808092826.21881.qmail@science.horizon.com>
Subject: Re: [PATCH] add slice by 8 algorithm to crc32.c
X-KeepSent: 53580ACE:F420CB68-C12578E6:0039189A;
 type=4; name=$KeepSent
To: "George Spelvin" <linux@horizon.com>
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com,
        linux-kernel@vger.kernel.org, rpearson@systemfabricworks.com
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF53580ACE.F420CB68-ONC12578E6.0039189A-C12578E6.0039CD0F@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Mon, 8 Aug 2011 12:31:20 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/08/2011 12:31:20
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George, just a quick comment or two.

"George Spelvin" <linux@horizon.com> wrote on 2011/08/08 11:28:26:
>
> Sorry I didn't see this when first posted.
>
> The "slice by 8" terminology is pretty confusing.  How about
> "Extended Joakim Tjernlund's optimization from commit
> 836e2af92503f1642dbc3c3281ec68ec1dd39d2e to 8-way parallelism."
>
> Which is essentally what you're doing.  The renaming of tab[0] to t0_le
> and t0_be, and removal of the DO_CRC4 macro just increases the diff size.

Yes, and also increases ppc size. The matrix needs to stay. I have proposed
to add this intead:
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

This saves 3 insns for ppc in the hot loop, hopefully x86 is happy with this too.

>
> If you're looking at speeding up the CRC through larger tables, have
> you tried using 10+11+11-bit tables?  That would require 20K of tables
> rather than 8K, but would reduce the number of table lookups per byte.
>
>
> One more stunt you could try to increase parallelism: rather than maintain
> the CRC in one register, maintain it in several, and only XOR and collapse
> them at the end.
>
> Start with your 64-bit code, but imagine that the second code block's
> "q = *p32++" always loads 0, and therefore the whole block can be skipped.
> (Since tab[0] = 0 for all CRC tables.)
>
> This computes the CRC of the even words.  Then do a second one in parallel
> for the odd words into a separate CRC register.  Then combine them at the end.
> (Shift one up by 32 bits and XOR into the other.)
>
> This would let you get away with 5K of tables: t4 through t7, and t0.
> t1 through t3 could be skipped.
>
>
> Ideally, I'd write all this code myself, but I'm a bit crunched at work
> right now so wouldn't be able to get to it for a few days.
>
>
>
> Another possible simplification to the startup code.  There's no need
> to compute init_bytes explicitly; just loop until the pointer is aligned:
>
>    while ((unsigned)buf & 3) {
>       if (!len--)
>          goto done;
> #ifdef __LITTLE_ENDIAN
>       i0 = *buf++ ^ crc;
>       crc = t0_le[i0] ^ (crc >> 8);
> #else
>       i0 = *buf++ ^ (crc >> 24);
>       crc = t0_le[i0] ^ (crc << 8);
> #endif
>    }
>    p32 = (u32 const *)buf;
>    words = len >> 2;
>    end_bytes = len & 3;
>
>
> ... although I'd prefer to keep the DO_CRC() and DO_CRC4 macros, and
> extend them to the 64-bit case, to avoid the nested #ifdefs.  That would
> make:
>
>    while ((unsigned)buf & 3) {
>       if (!len--)
>          goto done;
>       DO_CRC(*buf++);
>    }
>    p32 = (u32 const *)buf;
>    words = len >> 2;
>    end_bytes = len & 3;

I prefer to keep the current code which (at the time) generated good code
for at least ppc:
	/* Align it */
	if (unlikely((long)buf & 3 && len)) {
		do {
			DO_CRC(*buf++);
		} while ((--len) && ((long)buf)&3);
	}

