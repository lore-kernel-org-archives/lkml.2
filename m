Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1BSSav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 13:30:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52478 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab1BSSat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 13:30:49 -0500
Date: Sat, 19 Feb 2011 18:30:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 12/19] ARM: LPAE: Add context switching support
Message-ID: <20110219183027.GT29493@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-13-git-send-email-catalin.marinas@arm.com> <20110212104400.GF15616@n2100.arm.linux.org.uk> <1297689846.31111.43.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297689846.31111.43.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 01:24:06PM +0000, Catalin Marinas wrote:
> On Sat, 2011-02-12 at 10:44 +0000, Russell King - ARM Linux wrote:
> > On Mon, Jan 24, 2011 at 05:55:54PM +0000, Catalin Marinas wrote:
> > > +#ifdef CONFIG_ARM_LPAE
> > > +#define cpu_set_asid(asid) {                                         \
> > > +     unsigned long ttbl, ttbh;                                       \
> > > +     asm("   mrrc    p15, 0, %0, %1, c2              @ read TTBR0\n" \
> > > +         "   mov     %1, %1, lsl #(48 - 32)          @ set ASID\n"   \
> > > +         "   mcrr    p15, 0, %0, %1, c2              @ set TTBR0\n"  \
> > > +         : "=r" (ttbl), "=r" (ttbh)                                  \
> > > +         : "r" (asid & ~ASID_MASK));                                 \
> > 
> > This is wrong:
> > 1. It does nothing with %2 (the new asid)
> > 2. it shifts the high address bits of TTBR0 left 16 places each time its
> >    called.
> 
> It was worse actually, not even compiled in because it had output
> arguments but it wasn't volatile. Some early clobber is also needed.
> What about this:
> 
> #define cpu_set_asid(asid) {						\
> 	unsigned long ttbl, ttbh;					\
> 	asm volatile(							\
> 	"	mrrc	p15, 0, %0, %1, c2		@ read TTBR0\n"	\
> 	"	mov	%1, %2, lsl #(48 - 32)		@ set ASID\n"	\
> 	"	mcrr	p15, 0, %0, %1, c2		@ set TTBR0\n"	\
> 	: "=&r" (ttbl), "=&r" (ttbh)					\
> 	: "r" (asid & ~ASID_MASK));					\
> }

So we don't care about the low 16 bits of ttbh which can be simply zeroed?
