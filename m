Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1HIRjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:39:12 -0400
Received: from gw1.transmode.se ([195.58.98.146]:36471 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab1HIRjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:39:11 -0400
In-Reply-To: <00d401cc565c$98eeab60$cacc0220$@systemfabricworks.com>
References: <4E40C5C7.2050609@systemfabricworks.com> <00d401cc565c$98eeab60$cacc0220$@systemfabricworks.com>
Subject: RE: [patch v3 7/7] crc32: final-cleanup.diff
X-KeepSent: 4E555F7A:DF08D1FB-C12578E7:005FA1A8;
 type=4; name=$KeepSent
To: "Bob Pearson" <rpearson@systemfabricworks.com>
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com, linux@horizon.com,
        linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF4E555F7A.DF08D1FB-ONC12578E7.005FA1A8-C12578E7.0060F7CA@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Tue, 9 Aug 2011 19:39:08 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/09/2011 19:39:09
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Bob Pearson" <rpearson@systemfabricworks.com> wrote on 2011/08/09 08:21:38:
>
> Additional comments.
>
>
> > Some final cleanup changes
> >
> >    - added a comment at the top of crc32.c
> >    - moved macros ahead of function prototype
> >    - replaced loops with for (i = 0; i < xxx; i++) which
> >      requires fewer instructions on x86 since the
> >      buffer lookups can use i as an index.

Doing this adds one insn to ppc. What is good for x86 isn't for
pcc32 (and I guess any modern arch).

> >
> > -/* implements slicing-by-4 or slicing-by-8 algorithm */
> > -static inline u32
> > -crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32
> > (*tab)[256])
>
> After careful measurements and looking at asm code I figured out that there
> was no penalty for using 2D array. That allowed me to go back to the
> original form.

What about my suggestion to assign each table to a ptr? This was good
for ppc so if it doesn't slow x86 it should be added.

>
> > -{
> >  # ifdef __LITTLE_ENDIAN
> >  #  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255] ^ (crc >> 8)
> > -#  define DO_CRC4 crc = tab[3][(crc) & 255] ^ \
> > -      tab[2][(crc >> 8) & 255] ^ \
> > -      tab[1][(crc >> 16) & 255] ^ \
> > -      tab[0][(crc >> 24) & 255]
> > -#  define DO_CRC8a (tab[7][(q) & 255] ^ \
> > -      tab[6][(q >> 8) & 255] ^ \
> > -      tab[5][(q >> 16) & 255] ^ \
> > -      tab[4][(q >> 24) & 255])
> > -#  define DO_CRC8b (tab[3][(q) & 255] ^ \
> > +#  define DO_CRC4 (tab[3][(q) & 255] ^ \
> >        tab[2][(q >> 8) & 255] ^ \
> >        tab[1][(q >> 16) & 255] ^ \
> >        tab[0][(q >> 24) & 255])
>
> By changing the syntax a little so that the assignment is done down below
> the 4 byte and 8 byte algorithms can share DO_CRC4.
>
> > +#  define DO_CRC8 (tab[7][(q) & 255] ^ \
> > +      tab[6][(q >> 8) & 255] ^ \
> > +      tab[5][(q >> 16) & 255] ^ \
> > +      tab[4][(q >> 24) & 255])
> >  # else
> >  #  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
> > -#  define DO_CRC4 crc = tab[0][(crc) & 255] ^ \
> > -      tab[1][(crc >> 8) & 255] ^ \
> > -      tab[2][(crc >> 16) & 255] ^ \
> > -      tab[3][(crc >> 24) & 255]
> > -#  define DO_CRC8a (tab[4][(q) & 255] ^ \
> > -      tab[5][(q >> 8) & 255] ^ \
> > -      tab[6][(q >> 16) & 255] ^ \
> > -      tab[8][(q >> 24) & 255])
> > -#  define DO_CRC8b (tab[0][(q) & 255] ^ \
> > +#  define DO_CRC4 (tab[0][(q) & 255] ^ \
> >        tab[1][(q >> 8) & 255] ^ \
> >        tab[2][(q >> 16) & 255] ^ \
> >        tab[3][(q >> 24) & 255])
> > +#  define DO_CRC8 (tab[4][(q) & 255] ^ \
> > +      tab[5][(q >> 8) & 255] ^ \
> > +      tab[6][(q >> 16) & 255] ^ \
> > +      tab[7][(q >> 24) & 255])
> >  # endif
> > +
> > +/* implements slicing-by-4 or slicing-by-8 algorithm */
> > +static inline u32 crc32_body(u32 crc, unsigned char const *buf,
> > +              size_t len, const u32 (*tab)[256])
> > +{
> >     const u32 *b;
> > +   u8 *p;
> > +   u32 q;
> >     size_t init_len;
> >     size_t middle_len;
> >     size_t rem_len;
> > +   size_t i;
> >
> >     /* break buf into init_len bytes before and
> >      * rem_len bytes after a middle section with
> > @@ -96,37 +96,34 @@ crc32_body(u32 crc, unsigned char const
> >     rem_len = (len - init_len) & 7;
> >  # endif
> >
> > -   /* Align it */
> > -   if (unlikely(init_len)) {
> > -      do {
> > -         DO_CRC(*buf++);
> > -      } while (--init_len);
> > -   }
> > -   b = (const u32 *)buf;
> > -   for (--b; middle_len; --middle_len) {
> > +   /* process unaligned initial bytes */
> > +   for (i = 0; i < init_len; i++)
> > +      DO_CRC(*buf++);
> > +
> > +   /* process aligned words */
> > +   b = (const u32 *)(buf - 4);
> > +
> > +   for (i = 0; i < middle_len; i++) {
> >  # if CRC_LE_BITS == 32
> > -      crc ^= *++b; /* use pre increment for speed */
> > -      DO_CRC4;
> > +      /* slicing-by-4 algorithm */
> > +      q = crc ^ *++b; /* use pre increment for speed */
> > +      crc = DO_CRC4;
> >  # else
> > -      u32 q;
> > +      /* slicing-by-8 algorithm */
> >        q = crc ^ *++b;
> > -      crc = DO_CRC8a;
> > +      crc = DO_CRC8;
> >        q = *++b;
> > -      crc ^= DO_CRC8b;
> > +      crc ^= DO_CRC4;
> >  # endif
>
> This really shows how close the two algorithms are.

Indeed. Look at the WIP patch I sent. There it is even closer :)

>
> >     }
> > -   /* And the last few bytes */
> > -   if (rem_len) {
> > -      u8 *p = (u8 *)(b + 1) - 1;
> > -      do {
> > -         DO_CRC(*++p); /* use pre increment for speed */
> > -      } while (--rem_len);
> > -   }
> > +
> > +   /* process unaligned remaining bytes */
> > +   p = (u8 *)(b + 1) - 1;
> > +
> > +   for (i = 0; i < rem_len; i++)
> > +      DO_CRC(*++p); /* use pre increment for speed */
> > +
> >     return crc;
> > -#undef DO_CRC
> > -#undef DO_CRC4
> > -#undef DO_CRC8a
> > -#undef DO_CRC8b
> >  }
> >  #endif
>
>

