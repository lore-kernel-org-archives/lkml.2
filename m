Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab2IXQvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:51:48 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35395 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab2IXQvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:51:46 -0400
Date: Mon, 24 Sep 2012 12:51:42 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Dave Martin <dave.martin@linaro.org>
cc: Cyril Chemparathy <cyril@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>, linus.walleij@linaro.org,
        Will Deacon <will.deacon@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>, paul.gortmaker@windriver.com,
        vincent.guittot@linaro.org, davidb@codeaurora.org,
        plagnioj@jcrosoft.com, Arnd Bergmann <arnd@arndb.de>,
        marc.zyngier@arm.com, rob.herring@calxeda.com, vitalya@ti.com,
        tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        rmallon@gmail.com, frank.rowand@am.sony.com, sjg@chromium.org,
        sboyd@codeaurora.org, linux-kernel@vger.kernel.org, rabin@rab.in,
        hsweeten@visionengravers.com, tj@kernel.org
Subject: Re: [PATCH v3 RESEND 05/17] ARM: LPAE: support 64-bit virt_to_phys
 patching
In-Reply-To: <20120924163146.GD2122@linaro.org>
Message-ID: <alpine.LFD.2.02.1209241236480.6667@xanadu.home>
References: <1348242975-19184-1-git-send-email-cyril@ti.com> <1348242975-19184-6-git-send-email-cyril@ti.com> <20120924163146.GD2122@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2012, Dave Martin wrote:

> On Fri, Sep 21, 2012 at 11:56:03AM -0400, Cyril Chemparathy wrote:
> > This patch adds support for 64-bit physical addresses in virt_to_phys()
> > patching.  This does not do real 64-bit add/sub, but instead patches in the
> > upper 32-bits of the phys_offset directly into the output of virt_to_phys.
> > 
> > There is no corresponding change on the phys_to_virt() side, because
> > computations on the upper 32-bits would be discarded anyway.
> > 
> > Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> > ---
> >  arch/arm/include/asm/memory.h |   38 ++++++++++++++++++++++++++++++++++++--
> >  arch/arm/kernel/head.S        |    4 ++++
> >  arch/arm/kernel/setup.c       |    2 +-
> >  3 files changed, 41 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
> > index 88ca206..f3e8f88 100644
> > --- a/arch/arm/include/asm/memory.h
> > +++ b/arch/arm/include/asm/memory.h
> > @@ -154,13 +154,47 @@
> >  #ifdef CONFIG_ARM_PATCH_PHYS_VIRT
> >  
> >  extern unsigned long	__pv_offset;
> > -extern unsigned long	__pv_phys_offset;
> > +extern phys_addr_t	__pv_phys_offset;
> >  #define PHYS_OFFSET	__virt_to_phys(PAGE_OFFSET)
> >  
> >  static inline phys_addr_t __virt_to_phys(unsigned long x)
> >  {
> > -	unsigned long t;
> > +	phys_addr_t t;
> > +
> > +#ifndef CONFIG_ARM_LPAE
> >  	early_patch_imm8("add", t, x, __pv_offset, 0);
> > +#else
> > +	unsigned long __tmp;
> > +
> > +#ifndef __ARMEB__
> > +#define PV_PHYS_HIGH	"(__pv_phys_offset + 4)"
> > +#else
> > +#define PV_PHYS_HIGH	"__pv_phys_offset"
> > +#endif
> > +
> > +	early_patch_stub(
> > +	/* type */		PATCH_IMM8,
> > +	/* code */
> > +		"ldr		%[tmp], =__pv_offset\n"
> > +		"ldr		%[tmp], [%[tmp]]\n"
> > +		"add		%Q[to], %[from], %[tmp]\n"
> > +		"ldr		%[tmp], =" PV_PHYS_HIGH "\n"
> > +		"ldr		%[tmp], [%[tmp]]\n"
> > +		"mov		%R[to], %[tmp]\n",
> > +	/* pad */		4,
> > +	/* patch_data */
> > +		".long		__pv_offset\n"
> > +		"add		%Q[to], %[from], %[imm]\n"
> > +		".long	"	PV_PHYS_HIGH "\n"
> > +		"mov		%R[to], %[imm]\n",
> > +	/* operands */
> > +		: [to]	 "=r"	(t),
> > +		  [tmp]	 "=&r"	(__tmp)
> > +		: [from] "r"	(x),
> > +		  [imm]	 "I"	(__IMM8),
> > +			 "i"	(&__pv_offset),
> > +			 "i"	(&__pv_phys_offset));
> 
> So, the actual offset we can apply is:
> 
> __pv_phys_offset + __pv_offset
> 
> where:
> 
>  * the high 32 bits of the address being fixed up are assumed to be 0
>    (true, because the kernel is initially always fixed up to an address
>    range <4GB)

The fixed up address is a virtual address.  So yes, by definition it 
must be <4GB on ARM32.

>  * the low 32 bits of __pv_phys_offset are assumed to be 0 (?)

It is typically representable with a shifted 8 bit immediate but not 
necessarily 0, just like on platforms without LPAE.

>  * the full offset is of the form
> 
>         ([..0..]XX[..0..] << 32) | [..0..]YY[..0..] 
> 
> Is this intentional?  It seems like a rather weird constraint...  but
> it may be sensible.  PAGE_OFFSET is probably 0xc0000000 or 0x80000000,
> (so YY can handle that) and the actual RAM above 4GB will likely be
> huge and aligned on some enormous boundary in such situations (so that
> XX can handle that).
> 
> So long as the low RAM alias is not misaligned relative to the high alias
> on a finer granularity than 16MB (so that YY = (PAGE_OFFSET +/- the
> misalignment) is still a legal immediate), I guess there should not be a
> problem.

There are already similar constraints for the current 
ARM_PATCH_PHYS_VIRT code.  So nothing really new here.


Nicolas
