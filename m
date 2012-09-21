Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab2IUSl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:41:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37671 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab2IUSly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:41:54 -0400
Date: Fri, 21 Sep 2012 19:41:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Cyril Chemparathy <cyril@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        catalin.marinas@arm.com, grant.likely@secretlab.ca,
        will.deacon@arm.com, Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH v3 10/17] ARM: LPAE: use phys_addr_t in switch_mm()
Message-ID: <20120921184143.GH15609@n2100.arm.linux.org.uk>
References: <1347385155-11643-1-git-send-email-cyril@ti.com> <1347385155-11643-11-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1209211433110.6667@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1209211433110.6667@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 02:33:43PM -0400, Nicolas Pitre wrote:
> On Tue, 11 Sep 2012, Cyril Chemparathy wrote:
> 
> > This patch modifies the switch_mm() processor functions to use phys_addr_t.
> > On LPAE systems, we now honor the upper 32-bits of the physical address that
> > is being passed in, and program these into TTBR as expected.
> > 
> > Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> > Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> 
> Reviewed-by: Nicolas Pitre <nico@linaro.org>

Err... you may have reviewed it but did you read it?

> > diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
> > index f3628fb..75b5f14 100644
> > --- a/arch/arm/include/asm/proc-fns.h
> > +++ b/arch/arm/include/asm/proc-fns.h
> > @@ -60,7 +60,7 @@ extern struct processor {
> >  	/*
> >  	 * Set the page table
> >  	 */
> > -	void (*switch_mm)(unsigned long pgd_phys, struct mm_struct *mm);
> > +	void (*switch_mm)(phys_addr_t pgd_phys, struct mm_struct *mm);
> >  	/*
> >  	 * Set a possibly extended PTE.  Non-extended PTEs should
> >  	 * ignore 'ext'.
> > @@ -82,7 +82,7 @@ extern void cpu_proc_init(void);
> >  extern void cpu_proc_fin(void);
> >  extern int cpu_do_idle(void);
> >  extern void cpu_dcache_clean_area(void *, int);
> > -extern void cpu_do_switch_mm(unsigned long pgd_phys, struct mm_struct *mm);
> > +extern void cpu_do_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);

phys_addr_t can be either 64-bit or 32-bit.  Which it ends up depends on
a configuration option.  If it's 32-bit, then mm is in r1, otherwise it
is in r2...

> >  #ifdef CONFIG_MMU
> > -	ldr	r1, [r1, #MM_CONTEXT_ID]	@ get mm->context.id
> > -	and	r3, r1, #0xff
> > -	mov	r3, r3, lsl #(48 - 32)		@ ASID
> > -	mcrr	p15, 0, r0, r3, c2		@ set TTB 0
> > +	ldr	r2, [r2, #MM_CONTEXT_ID]	@ get mm->context.id

which breaks this when phys_addr_t is 32-bit.

Doing it this way means we have to have similar conditionals in other
files which make use of the 'mm' argument.

Moving the 'mm' argument into arg0 would mean that stays as r0, but
then the pgd_phys argument is passed in either r1 when 32-bit, or
r2,r3 when 64-bit on EABI and r1,r2 on OABI.  That's hardly desirable
behaviour either, because it all too easily allows bugs to creap in.

The easiest solution would be to just change pgd_phys to be uint64_t
and be done with it.  Then you always know in assembly what registers
values are going to be passed in (except for the LE/BE issue with r0/r1).
