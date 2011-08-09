Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1HIJqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 05:46:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56154 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1HIJqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 05:46:11 -0400
Subject: Re: [PATCH] slub: fix check_bytes() for slub debugging
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org
In-Reply-To: <CAC5umyhLuhNK55WDXTii2SFsqPNau1B9F1z+E0r0CaLNkGZfDg@mail.gmail.com>
References: <1312709438-7608-1-git-send-email-akinobu.mita@gmail.com>
	 <1312859440.2531.20.camel@edumazet-laptop>
	 <1312860783.2531.31.camel@edumazet-laptop>
	 <CAC5umyhLuhNK55WDXTii2SFsqPNau1B9F1z+E0r0CaLNkGZfDg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 11:46:09 +0200
Message-ID: <1312883169.2371.16.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 09 août 2011 à 18:38 +0900, Akinobu Mita a écrit :
> 2011/8/9 Eric Dumazet <eric.dumazet@gmail.com>:
> 
> >> > diff --git a/mm/slub.c b/mm/slub.c
> >> > index eb5a8f9..5695f92 100644
> >> > --- a/mm/slub.c
> >> > +++ b/mm/slub.c
> >> > @@ -701,7 +701,7 @@ static u8 *check_bytes(u8 *start, u8 value, unsigned int bytes)
> >> >             return check_bytes8(start, value, bytes);
> >> >
> >> >     value64 = value | value << 8 | value << 16 | value << 24;
> >> > -   value64 = value64 | value64 << 32;
> >> > +   value64 = (value64 & 0xffffffff) | value64 << 32;
> >> >     prefix = 8 - ((unsigned long)start) % 8;
> >> >
> >> >     if (prefix) {
> >>
> >> Still buggy I am afraid. Could we use the following ?
> >>
> >>
> >>       value64 = value;
> >>       value64 |= value64 << 8;
> >>       value64 |= value64 << 16;
> >>       value64 |= value64 << 32;
> >>
> >>
> >
> > Well, 'buggy' was not well chosen.
> >
> > Another possibility would be to use a multiply if arch has a fast
> > multiplier...
> >
> >
> >        value64 = value;
> > #if defined(ARCH_HAS_FAST_MULTIPLIER) && BITS_PER_LONG == 64
> >        value64 *= 0x0101010101010101;
> > #elif defined(ARCH_HAS_FAST_MULTIPLIER)
> >        value64 *= 0x01010101;
> >        value64 |= value64 << 32;
> > #else
> >        value64 |= value64 << 8;
> >        value64 |= value64 << 16;
> >        value64 |= value64 << 32;
> > #endif
> 
> I don't really care about which one should be used.  So tell me if I need
> to resend it with this improvement.

It would be nice to fix all bugs while we review this code.

Lets push your patch and I'll submit a patch for next kernel.

For example, following code is suboptimal :

        prefix = 8 - ((unsigned long)start) % 8;

        if (prefix) {
                u8 *r = check_bytes8(start, value, prefix);
                if (r)
                        return r;
                start += prefix;
                bytes -= prefix;
        }


Since we always have prefix = 8 if 'start' is longword aligned, so we
call check_bytes8() at least once with 8 bytes to compare...

Also, 32bit arches should be taken into account properly.

Oh well...



