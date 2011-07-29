Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab1G2B7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 21:59:41 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:36711 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754657Ab1G2B7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 21:59:40 -0400
X-Greylist: delayed 721 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jul 2011 21:59:40 EDT
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=I7fHHdvOj7QA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=r17jK6sfZkYSxad0qIwqKg==:17 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=8z7O-gMTxPnXxmXU2oEA:9 a=P2RnRK3n6tcGGvgpyykA:7 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=r17jK6sfZkYSxad0qIwqKg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 24.153.165.185
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'frank zago'" <fzago@systemfabricworks.com>
Cc: <linux-kernel@vger.kernel.org>, "'Roland Dreier'" <roland@kernel.org>
References: <4E27547E.4000100@systemfabricworks.com> <20110728151619.8b4cc4e3.akpm@linux-foundation.org>
In-Reply-To: <20110728151619.8b4cc4e3.akpm@linux-foundation.org>
Subject: RE: [PATCH] add slice by 8 algorithm to crc32.c
Date: Thu, 28 Jul 2011 20:47:36 -0500
Message-ID: <034001cc4d91$7f232c70$7d698550$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQLRCrecWqERhazes6VfMp782sYlxgKHGXnEkuTAvCA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

A few  questions/comments below that will help resending the patch.

Thanks,

Bob Pearson

> 
> Are you sure that the code doesn't add any unaligned accesses?  Those are
> very bad on some non-x86 architectures.

Agreed. P8 is byte aligned. P32 is 32/64 bit aligned for the 32/64 bit
algorithms. I will try to make it clearer.

> 
> > --- lib/crc32.c
> > +++ lib/crc32.c
> 
> Please prepare patches in `patch -p1' form.  So that should have been

OK

> 
> --- a/lib/crc32.c
> +++ a/lib/crc32.c
> 
> >
> > ...
> >
> > @@ -28,14 +31,17 @@
> >  #include <linux/init.h>
> >  #include <asm/atomic.h>
> >  #include "crc32defs.h"
> > -#if CRC_LE_BITS == 8
> > -# define tole(x) __constant_cpu_to_le32(x)
> > +
> > +#include <asm/msr.h>
> 
> That breaks the build on all non-x86.  Fortunately the inclusion appears
to be
> unnecessary.

Oops! Was part of some performance measurement code that got taken out.

> 

General comment. The use of le/be in this and the previous version of
crc32.c is confusing because it does not refer to little/big endian cpu
architecture but rather to the arbitrary choice made by different protocols
as to whether the bits in a byte are presented to the CRC in little/big
*BIT* order. Some protocols (e.g. Ethernet, InfiniBand) process the bits
starting from the LSB and some (e.g. atm) process the bits in MSB order.
These routines (crc32_le and crc32_be) compute the CRC as a u32 in cpu byte
order. The caller has to then get the CRC into the correct order for
inclusion into the message. As a result there are four versions of the
calculation:
BE bit order on BE byte order cpu, BE bit order on LE byte order cpu, etc.

Some calculations are simplified by arranging the bits sequentially in WORDS
when we are going to process them in a certain order within each byte. This
means that the tables used to compute crc32_be are easier to use in BE byte
order and that tables used to compute crc32_le are easier to use in LE byte
order. That is the logic behind the following weird looking macros which are
kept the same as the previous version except for the inclusion of __force to
pass sparse with -D__CHECK_ENDIAN__.

> > +#if CRC_LE_BITS > 8
> > +# define tole(x) (__force u32) __constant_cpu_to_le32(x)
> >  #else
> >  # define tole(x) (x)
> >  #endif

> > -#if CRC_LE_BITS == 8 || CRC_BE_BITS == 8
> > +#if CRC_LE_BITS > 8
> > +static inline u32 crc32_le_body(u32 crc, u8 const *buf, size_t len)
> 
> `inline' is largely ignored by gcc, with gcc-version dependencies.
> __always_inline is more likely to succeed.  But the compiler would inline
this
> all by itself anyway.

Agreed. Inherited from previous version and happy to delete it.

> > +	p32 = (u32 *)(((uintptr_t)p8 + 7) & ~7);
> 
> Perhaps using ALIGN() would be clearer.

OK by me.  Its cleaner.

> 
> > +
> > +	init_bytes = (uintptr_t)p32 - (uintptr_t)p8;
> 
> Please take a look at the types of init_bytes and end_bytes.
> ptrdiff_t, size_t and uint would all eb more appropriate than `int'.

Is there a performance difference on 32 bit machines from using a long to
hold something that is in the range [0,7]? Which of these would you
recommend?

> > +	p32 = (u32 *)(((uintptr_t)p8 + 3) & ~3);
> 
> ALIGN()?

Sure.

> 
> > +	init_bytes = (uintptr_t)p32 - (uintptr_t)p8;
> > +	if (init_bytes > len)
> > +		init_bytes = len;
> 
> max()?

Maybe. First line is the main thought and the if handles the exception where
the unrolled loop doesn't have a middle. Happy to oblige though. How about
an unlikely in the if?

> > +	for (i = 0; i < init_bytes; i++) {
> > +#ifdef __LITTLE_ENDIAN
> > +		i0 = *p8++ ^ crc;
> > +		crc = t0_le[i0] ^ (crc >> 8);
> > +#else
> > +		i0 = *p8++ ^ (crc >> 24);
> > +		crc = t0_le[i0] ^ (crc << 8);
> > +#endif
> > +	}
> 
> All the ifdeffing in here bursts my brain.

Agreed. But this is basically the same as the original code except that the
#ifdefs were buried in the macros. I couldn't figure out how to save the
CRC4 macros and for consistent style decided to get rid of all of them.
I'm not sure how to avoid it except to replicate the subroutines 4X.

> 
> Has this code been carefully tested in LE and BE?

Yes. My Big Endian test machine collection just consists of an old Ultra
Sparc machine. But we have 64 and 32 bit X86 systems. The patch adds one new
option to an existing collection of different ways to compute each CRC,
which have not really changed. In particular the 1 bit versions are
identical by inspection to the original. That allows us to compare the
results for different inputs and optional versions of the algorithm and of
course the unpatched file.

One change to the original was the removal of the 2D arrays in the table and
replacement with 1D arrays. I have the opinion that this makes the inner
loop shorter but to do this required making two copies of the 'body'
subroutine. Perhaps someone can comment on this. I have looked and I can't
see any way to shorten the code in the slice by 8 code from what gcc does
but almost anything that I do to the loop makes it longer.

I have doubts about the need to have 6 versions with different trade-offs
between table size and speed but I was afraid to make radical changes to the
original code. People who make small embedded systems probably care a lot
but I don't have a good feel for the issue.

> 

I left in the unit test and documentation without change but from the looks
of it no one has run it for a while and I have doubts about whether it works
anymore. What do you think about moving the documentation to Documentation
and ditching the unit tests?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

