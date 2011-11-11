Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab1KKLBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 06:01:08 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55955 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753502Ab1KKLBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 06:01:06 -0500
Date: Fri, 11 Nov 2011 11:00:41 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 09/16] ARM: LPAE: MMU setup for the 3-level page
 table format
Message-ID: <20111111110041.GC23243@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
 <1320682618-1182-10-git-send-email-catalin.marinas@arm.com>
 <alpine.LFD.2.02.1111101707250.3307@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1111101707250.3307@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:24:58PM +0000, Nicolas Pitre wrote:
> On Mon, 7 Nov 2011, Catalin Marinas wrote:
> 
> [...]
> > +	/*
> > +	 * Macro for setting up the TTBRx and TTBCR registers.
> > +	 * - \ttbr1 updated.
> > +	 */
> > +	.macro	v7_ttb_setup, zero, ttbr0, ttbr1, tmp
> > +	mrc	p15, 0, \tmp, c2, c0, 2		@ TTB control register
> > +	orr	\tmp, \tmp, #TTB_EAE
> > +	ALT_SMP(orr	\tmp, \tmp, #TTB_FLAGS_SMP)
> > +	ALT_SMP(orr	\tmp, \tmp, #TTB_FLAGS_SMP << 16)
> > +	ALT_UP(orr	\tmp, \tmp, #TTB_FLAGS_UP)
> > +	ALT_UP(orr	\tmp, \tmp, #TTB_FLAGS_UP << 16)
> 
> The ALT_SMP() and ALT_UP() must always be paired and in the right order.  
> The above certainly won't produce what you expect on UP.

Good catch.

> > +#if PHYS_OFFSET <= PAGE_OFFSET
> 
> Please don't use PHYS_OFFSET like a preprocessor macro anymore.  This is 
> becoming a global variable these days, and already is for the majority 
> of platforms.

That's left from last year when it was still a macro. I will revisit
this code.

> > +	 * TTBR0/TTBR1 split (PAGE_OFFSET):
> > +	 *   0x40000000: T0SZ = 2, T1SZ = 0 (not used)
> > +	 *   0x80000000: T0SZ = 0, T1SZ = 1
> > +	 *   0xc0000000: T0SZ = 0, T1SZ = 2
> > +	 *
> > +	 * Only use this feature if PHYS_OFFSET <= PAGE_OFFSET, otherwise
> > +	 * booting secondary CPUs would end up using TTBR1 for the identity
> > +	 * mapping set up in TTBR0.
> > +	 */
> > +	orr	\tmp, \tmp, #(((PAGE_OFFSET >> 30) - 1) << 16) @ TTBCR.T1SZ
> > +#if defined CONFIG_VMSPLIT_2G
> > +	/* PAGE_OFFSET == 0x80000000, T1SZ == 1 */
> > +	add	\ttbr1, \ttbr1, #1 << 4		@ skip two L1 entries
> > +#elif defined CONFIG_VMSPLIT_3G
> > +	/* PAGE_OFFSET == 0xc0000000, T1SZ == 2 */
> > +	add	\ttbr1, \ttbr1, #4096 * (1 + 3)	@ only L2 used, skip pgd+3*pmd
> > +#endif
> > +#endif	/* PHYS_OFFSET <= PAGE_OFFSET */
> 
> What about CONFIG_VMSPLIT_1G ?

That's the default, we don't use split TTBR for that (I'll add a
comment).

-- 
Catalin
