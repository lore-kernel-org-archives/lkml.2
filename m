Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0KVNNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:13:12 -0500
Received: from service87.mimecast.com ([94.185.240.25]:54506 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752433Ab0KVNNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:13:12 -0500
X-Greylist: delayed 777 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Nov 2010 08:13:11 EST
Subject: Re: [PATCH v2 01/20] ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead
 of PGDIR_*
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101122124353.GB31227@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	 <1289584840-18097-2-git-send-email-catalin.marinas@arm.com>
	 <20101122124353.GB31227@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Mon, 22 Nov 2010 13:00:10 +0000
Message-ID: <1290430810.29754.9.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 22 Nov 2010 13:00:10.0742 (UTC) FILETIME=[320F2160:01CB8A45]
X-MC-Unique: 110112213001200301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 12:43 +0000, Russell King - ARM Linux wrote:
> On Fri, Nov 12, 2010 at 06:00:21PM +0000, Catalin Marinas wrote:
> > diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> > index 8c19595..40b386c 100644
> > --- a/arch/arm/kernel/smp.c
> > +++ b/arch/arm/kernel/smp.c
> > @@ -78,7 +78,7 @@ static inline void identity_mapping_add(pgd_t *pgd, unsigned long start,
> >       if (cpu_architecture() <= CPU_ARCH_ARMv5TEJ && !cpu_is_xscale())
> >               prot |= PMD_BIT4;
> > 
> > -     for (addr = start & PGDIR_MASK; addr < end;) {
> > +     for (addr = start & PMD_MASK; addr < end;) {
> >               pmd = pmd_offset(pgd + pgd_index(addr), addr);
> >               pmd[0] = __pmd(addr | prot);
> >               addr += SECTION_SIZE;
> > @@ -95,7 +95,7 @@ static inline void identity_mapping_del(pgd_t *pgd, unsigned long start,
> >       unsigned long addr;
> >       pmd_t *pmd;
> > 
> > -     for (addr = start & PGDIR_MASK; addr < end; addr += PGDIR_SIZE) {
> > +     for (addr = start & PMD_MASK; addr < end; addr += PMD_SIZE) {
> >               pmd = pmd_offset(pgd + pgd_index(addr), addr);
> >               pmd[0] = __pmd(0);
> >               pmd[1] = __pmd(0);
> ...
> > @@ -1068,12 +1068,12 @@ void setup_mm_for_reboot(char mode)
> >               base_pmdval |= PMD_BIT4;
> > 
> >       for (i = 0; i < FIRST_USER_PGD_NR + USER_PTRS_PER_PGD; i++, pgd++) {
> > -             unsigned long pmdval = (i << PGDIR_SHIFT) | base_pmdval;
> > +             unsigned long pmdval = (i << PMD_SHIFT) | base_pmdval;
> >               pmd_t *pmd;
> > 
> > -             pmd = pmd_off(pgd, i << PGDIR_SHIFT);
> > +             pmd = pmd_off(pgd, i << PMD_SHIFT);
> >               pmd[0] = __pmd(pmdval);
> > -             pmd[1] = __pmd(pmdval + (1 << (PGDIR_SHIFT - 1)));
> > +             pmd[1] = __pmd(pmdval + (1 << (PMD_SHIFT - 1)));
> >               flush_pmd_entry(pmd);
> >       }
> > 
> 
> This lot really does need unifying - and in any case this last addition
> should be using 'SECTION SIZE' not something related to PMD shifts.

On the classic page tables, the PMD_SHIFT is 21 while the SECTION_SHIFT
is 20. They have slightly different meaning.

But we currently have some hacks to cope with PMD_SHIFT being 21 by
writing the pmd[0] and pmd[1] in the same call. The way I see to use
SECTION_SHIFT is to drop the pmd[] array (but haven't looked closely
enough). With LPAE I have a few #ifndef around pmd[1] setting.

> Strangely, it's something I've done over the weekend...

OK, the more clean-up the better.

-- 
Catalin


