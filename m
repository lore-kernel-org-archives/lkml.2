Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0KVN2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:28:48 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55916 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0KVN2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:28:47 -0500
Date: Mon, 22 Nov 2010 13:28:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/20] ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead
	of PGDIR_*
Message-ID: <20101122132831.GH31227@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-2-git-send-email-catalin.marinas@arm.com> <20101122124353.GB31227@n2100.arm.linux.org.uk> <1290430810.29754.9.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290430810.29754.9.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 01:00:10PM +0000, Catalin Marinas wrote:
> On Mon, 2010-11-22 at 12:43 +0000, Russell King - ARM Linux wrote:
> > On Fri, Nov 12, 2010 at 06:00:21PM +0000, Catalin Marinas wrote:
> > > diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> > > index 8c19595..40b386c 100644
> > > --- a/arch/arm/kernel/smp.c
> > > +++ b/arch/arm/kernel/smp.c
> > > @@ -78,7 +78,7 @@ static inline void identity_mapping_add(pgd_t *pgd, unsigned long start,
> > >       if (cpu_architecture() <= CPU_ARCH_ARMv5TEJ && !cpu_is_xscale())
> > >               prot |= PMD_BIT4;
> > > 
> > > -     for (addr = start & PGDIR_MASK; addr < end;) {
> > > +     for (addr = start & PMD_MASK; addr < end;) {
> > >               pmd = pmd_offset(pgd + pgd_index(addr), addr);
> > >               pmd[0] = __pmd(addr | prot);
> > >               addr += SECTION_SIZE;
> > > @@ -95,7 +95,7 @@ static inline void identity_mapping_del(pgd_t *pgd, unsigned long start,
> > >       unsigned long addr;
> > >       pmd_t *pmd;
> > > 
> > > -     for (addr = start & PGDIR_MASK; addr < end; addr += PGDIR_SIZE) {
> > > +     for (addr = start & PMD_MASK; addr < end; addr += PMD_SIZE) {
> > >               pmd = pmd_offset(pgd + pgd_index(addr), addr);
> > >               pmd[0] = __pmd(0);
> > >               pmd[1] = __pmd(0);
> > ...
> > > @@ -1068,12 +1068,12 @@ void setup_mm_for_reboot(char mode)
> > >               base_pmdval |= PMD_BIT4;
> > > 
> > >       for (i = 0; i < FIRST_USER_PGD_NR + USER_PTRS_PER_PGD; i++, pgd++) {
> > > -             unsigned long pmdval = (i << PGDIR_SHIFT) | base_pmdval;
> > > +             unsigned long pmdval = (i << PMD_SHIFT) | base_pmdval;
> > >               pmd_t *pmd;
> > > 
> > > -             pmd = pmd_off(pgd, i << PGDIR_SHIFT);
> > > +             pmd = pmd_off(pgd, i << PMD_SHIFT);
> > >               pmd[0] = __pmd(pmdval);
> > > -             pmd[1] = __pmd(pmdval + (1 << (PGDIR_SHIFT - 1)));
> > > +             pmd[1] = __pmd(pmdval + (1 << (PMD_SHIFT - 1)));
> > >               flush_pmd_entry(pmd);
> > >       }
> > > 
> > 
> > This lot really does need unifying - and in any case this last addition
> > should be using 'SECTION SIZE' not something related to PMD shifts.
> 
> On the classic page tables, the PMD_SHIFT is 21 while the SECTION_SHIFT
> is 20. They have slightly different meaning.

Correct, and if you look at the code again and analyze what it's doing,
you'll see that it's using the wrong thing.  The code pre-exists the
SECTION_* macros, and was never fixed up when they were introduced.

SECTION_SIZE is the right thing here - it's setting up sections.

Just look at identity_mapping_add() to see how the code _should_ be.
