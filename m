Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab2IUSxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:53:25 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39066 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553Ab2IUSxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:53:24 -0400
Date: Fri, 21 Sep 2012 14:53:22 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Cyril Chemparathy <cyril@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        catalin.marinas@arm.com, grant.likely@secretlab.ca,
        will.deacon@arm.com, Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH v3 10/17] ARM: LPAE: use phys_addr_t in switch_mm()
In-Reply-To: <20120921184143.GH15609@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1209211449150.6667@xanadu.home>
References: <1347385155-11643-1-git-send-email-cyril@ti.com> <1347385155-11643-11-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1209211433110.6667@xanadu.home> <20120921184143.GH15609@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2012, Russell King - ARM Linux wrote:

> On Fri, Sep 21, 2012 at 02:33:43PM -0400, Nicolas Pitre wrote:
> > On Tue, 11 Sep 2012, Cyril Chemparathy wrote:
> > 
> > > This patch modifies the switch_mm() processor functions to use phys_addr_t.
> > > On LPAE systems, we now honor the upper 32-bits of the physical address that
> > > is being passed in, and program these into TTBR as expected.
> > > 
> > > Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> > > Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> > 
> > Reviewed-by: Nicolas Pitre <nico@linaro.org>
> 
> Err... you may have reviewed it but did you read it?

Sure I did.

> > > diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
> > > index f3628fb..75b5f14 100644
> > > --- a/arch/arm/include/asm/proc-fns.h
> > > +++ b/arch/arm/include/asm/proc-fns.h
> > > @@ -60,7 +60,7 @@ extern struct processor {
> > >  	/*
> > >  	 * Set the page table
> > >  	 */
> > > -	void (*switch_mm)(unsigned long pgd_phys, struct mm_struct *mm);
> > > +	void (*switch_mm)(phys_addr_t pgd_phys, struct mm_struct *mm);
> > >  	/*
> > >  	 * Set a possibly extended PTE.  Non-extended PTEs should
> > >  	 * ignore 'ext'.
> > > @@ -82,7 +82,7 @@ extern void cpu_proc_init(void);
> > >  extern void cpu_proc_fin(void);
> > >  extern int cpu_do_idle(void);
> > >  extern void cpu_dcache_clean_area(void *, int);
> > > -extern void cpu_do_switch_mm(unsigned long pgd_phys, struct mm_struct *mm);
> > > +extern void cpu_do_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);
> 
> phys_addr_t can be either 64-bit or 32-bit.  Which it ends up depends on
> a configuration option.  If it's 32-bit, then mm is in r1, otherwise it
> is in r2...

Right.  And that configuration option is CONFIG_ARM_LPAE.

> > >  #ifdef CONFIG_MMU
> > > -	ldr	r1, [r1, #MM_CONTEXT_ID]	@ get mm->context.id
> > > -	and	r3, r1, #0xff
> > > -	mov	r3, r3, lsl #(48 - 32)		@ ASID
> > > -	mcrr	p15, 0, r0, r3, c2		@ set TTB 0
> > > +	ldr	r2, [r2, #MM_CONTEXT_ID]	@ get mm->context.id
> 
> which breaks this when phys_addr_t is 32-bit.

... which can't happen in this case because this code is only compiled 
when CONFIG_ARM_LPAE=y.

> Doing it this way means we have to have similar conditionals in other
> files which make use of the 'mm' argument.

No because none of the other files may ever be used when 
CONFIG_ARM_LPAE=y.


Nicolas
