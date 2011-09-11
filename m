Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188Ab1IKOrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 10:47:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:41899 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab1IKOrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 10:47:15 -0400
Subject: RE: [patch v3 24/36] Hexagon: Provide basic implementation and/or
 stubs for I/O routines.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Taylor Simpson <tsimpson@codeaurora.org>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Linas Vepstas (Code Aurora)'" <linas@codeaurora.org>,
        "'Richard Kuo'" <rkuo@codeaurora.org>, linux-arch@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <000001cc6ff4$8d706b00$a8514100$@org>
References: <20110909010847.294039464@codeaurora.org>
	 <20110909010916.993872033@codeaurora.org>
	 <20110909191412.GB2034@codeaurora.org> <1883807.RYWKjfNqKd@wuerfel>
	 <000001cc6ff4$8d706b00$a8514100$@org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Sep 2011 11:46:55 -0300
Message-ID: <1315752415.455.47.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-09-10 at 15:02 -0500, Taylor Simpson wrote:
> Using "memory" is a pretty big hammer.  Wouldn't it be better to use a
> memory operand?
>      asm volatile(
>              "memb(%0) = %1;"
>              : "m" (*(u8*)addr)
>              : "r" (data)
>      );

No you probably really want a full "memory" clobber, because typically
your IO ops should also act as barriers. The compiler has no way to know
for example that you want to order previous stores to memory (some DMA
descriptor you are populating) vs. an MMIO access that will trigger the
DMA from that location.

Linux defines the readX/writeX accessors as being fully ordered in that
case.

In fact, I'm not familiar with Hexagon, but if it's a weakly ordered
memory model you may also need some kind of memory barrier in those
accessors.

Cheers,
Ben.

> This may be a dumb question, but why do we need inline asm?  Why can't we
> write this with plain C code?
> /*
>  * writeb - write a byte to a memory location
>  * @data: data to write to
>  * @addr:  pointer to memory
>  *
>  */
> static inline void writeb(u8 data, volatile void __iomem *addr) {
> 	volatile u8 *ptr = (volatile u8*)addr;
> 	*ptr = data;
> }
> 
> 
> Taylor
> 
> 
> 
> -----Original Message-----
> From: linux-hexagon-owner@vger.kernel.org
> [mailto:linux-hexagon-owner@vger.kernel.org] On Behalf Of Arnd Bergmann
> Sent: Friday, September 09, 2011 4:13 PM
> To: Linas Vepstas (Code Aurora)
> Cc: Richard Kuo; linux-arch@vger.kernel.org; linux-hexagon@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [patch v3 24/36] Hexagon: Provide basic implementation and/or
> stubs for I/O routines.
> 
> On Friday 09 September 2011 14:14:13 Linas Vepstas wrote:
> > On Thu, Sep 08, 2011 at 08:09:11PM -0500, Richard Kuo wrote:
> > > +     asm volatile(
> > > +             "memb(%0) = %1;"
> > > +             :
> > > +             : "r" (addr), "r" (data)
> > > +     );
> > 
> > I'm kind-of vague on this, but I think that this also needs a
> > : "memory" at the end (to indicate that the asm snippet clobbers
> > memory), as otherwise the compiler may be tempted to reorder
> > these around other memory accesses. That is, the "volatile"
> > keyword is not enough (well, I'm not sure...), but I think
> > "volatile" only prevents the compiler from optimizing these
> > away completely, but is not enough to prevent unwanted
> > re-ordering.
> 
> Yes, absolutely correct. Specifically, this is required for the
> case where you first store values into regular memory and then
> use the writel() to trigger a DMA operation. Without the memory
> clobber, the dma may read from memory before the CPU has accessed
> it in case the store gets scheduled after the writel by the compiler.
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-hexagon" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


