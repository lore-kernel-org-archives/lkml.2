Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928Ab1IJUCY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 16:02:24 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35655 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab1IJUCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 16:02:23 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6465"; a="117421197"
From: "Taylor Simpson" <tsimpson@codeaurora.org>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Linas Vepstas \(Code Aurora\)'" <linas@codeaurora.org>
Cc: "'Richard Kuo'" <rkuo@codeaurora.org>, <linux-arch@vger.kernel.org>,
        <linux-hexagon@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20110909010847.294039464@codeaurora.org> <20110909010916.993872033@codeaurora.org> <20110909191412.GB2034@codeaurora.org> <1883807.RYWKjfNqKd@wuerfel>
In-Reply-To: <1883807.RYWKjfNqKd@wuerfel>
Subject: RE: [patch v3 24/36] Hexagon: Provide basic implementation and/or stubs for I/O routines.
Date: Sat, 10 Sep 2011 15:02:21 -0500
Message-ID: <000001cc6ff4$8d706b00$a8514100$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcxvNVSWG5NI4/7ETDuEAYpYlrFI9wAvyVew
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using "memory" is a pretty big hammer.  Wouldn't it be better to use a
memory operand?
     asm volatile(
             "memb(%0) = %1;"
             : "m" (*(u8*)addr)
             : "r" (data)
     );

This may be a dumb question, but why do we need inline asm?  Why can't we
write this with plain C code?
/*
 * writeb - write a byte to a memory location
 * @data: data to write to
 * @addr:  pointer to memory
 *
 */
static inline void writeb(u8 data, volatile void __iomem *addr) {
	volatile u8 *ptr = (volatile u8*)addr;
	*ptr = data;
}


Taylor



-----Original Message-----
From: linux-hexagon-owner@vger.kernel.org
[mailto:linux-hexagon-owner@vger.kernel.org] On Behalf Of Arnd Bergmann
Sent: Friday, September 09, 2011 4:13 PM
To: Linas Vepstas (Code Aurora)
Cc: Richard Kuo; linux-arch@vger.kernel.org; linux-hexagon@vger.kernel.org;
linux-kernel@vger.kernel.org
Subject: Re: [patch v3 24/36] Hexagon: Provide basic implementation and/or
stubs for I/O routines.

On Friday 09 September 2011 14:14:13 Linas Vepstas wrote:
> On Thu, Sep 08, 2011 at 08:09:11PM -0500, Richard Kuo wrote:
> > +     asm volatile(
> > +             "memb(%0) = %1;"
> > +             :
> > +             : "r" (addr), "r" (data)
> > +     );
> 
> I'm kind-of vague on this, but I think that this also needs a
> : "memory" at the end (to indicate that the asm snippet clobbers
> memory), as otherwise the compiler may be tempted to reorder
> these around other memory accesses. That is, the "volatile"
> keyword is not enough (well, I'm not sure...), but I think
> "volatile" only prevents the compiler from optimizing these
> away completely, but is not enough to prevent unwanted
> re-ordering.

Yes, absolutely correct. Specifically, this is required for the
case where you first store values into regular memory and then
use the writel() to trigger a DMA operation. Without the memory
clobber, the dma may read from memory before the CPU has accessed
it in case the store gets scheduled after the writel by the compiler.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-hexagon" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

