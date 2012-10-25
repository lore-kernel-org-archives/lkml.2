Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795Ab2JYHzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:55:17 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57051 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab2JYHzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:55:14 -0400
Date: Thu, 25 Oct 2012 09:55:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, jacob.shin@amd.com,
        tglx@linutronix.de, trini@ti.com, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, mm: Find_early_table_space based on ranges
 that are actually being mapped
Message-ID: <20121025075508.GD3712@gmail.com>
References: <20121024195311.GB11779@jshin-Toonie>
 <tip-844ab6f993b1d32eb40512503d35ff6ad0c57030@git.kernel.org>
 <CAE9FiQX0MvxAsZKFwH50joR5qz1oGhbXz+BD9W-QC_BrD9zKFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQX0MvxAsZKFwH50joR5qz1oGhbXz+BD9W-QC_BrD9zKFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Wed, Oct 24, 2012 at 2:49 PM, tip-bot for Jacob Shin
> <jacob.shin@amd.com> wrote:
> > Commit-ID:  844ab6f993b1d32eb40512503d35ff6ad0c57030
> > Gitweb:     http://git.kernel.org/tip/844ab6f993b1d32eb40512503d35ff6ad0c57030
> > Author:     Jacob Shin <jacob.shin@amd.com>
> > AuthorDate: Wed, 24 Oct 2012 14:24:44 -0500
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Wed, 24 Oct 2012 13:37:04 -0700
> >
> > x86, mm: Find_early_table_space based on ranges that are actually being mapped
> >
> > Current logic finds enough space for direct mapping page tables from 0
> > to end. Instead, we only need to find enough space to cover mr[0].start
> > to mr[nr_range].end -- the range that is actually being mapped by
> > init_memory_mapping()
> >
> > This is needed after 1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a, to address
> > the panic reported here:
> >
> >   https://lkml.org/lkml/2012/10/20/160
> >   https://lkml.org/lkml/2012/10/21/157
> >
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> > Link: http://lkml.kernel.org/r/20121024195311.GB11779@jshin-Toonie
> > Tested-by: Tom Rini <trini@ti.com>
> > Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > ---
> >  arch/x86/mm/init.c |   70 ++++++++++++++++++++++++++++++---------------------
> >  1 files changed, 41 insertions(+), 29 deletions(-)
> >
> > diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> > index 8653b3a..bc287d6 100644
> > --- a/arch/x86/mm/init.c
> > +++ b/arch/x86/mm/init.c
> > @@ -29,36 +29,54 @@ int direct_gbpages
> >  #endif
> >  ;
> >
> > -static void __init find_early_table_space(unsigned long end, int use_pse,
> > -                                         int use_gbpages)
> > +struct map_range {
> > +       unsigned long start;
> > +       unsigned long end;
> > +       unsigned page_size_mask;
> > +};
> > +
> > +/*
> > + * First calculate space needed for kernel direct mapping page tables to cover
> > + * mr[0].start to mr[nr_range - 1].end, while accounting for possible 2M and 1GB
> > + * pages. Then find enough contiguous space for those page tables.
> > + */
> > +static void __init find_early_table_space(struct map_range *mr, int nr_range)
> >  {
> > -       unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
> > +       int i;
> > +       unsigned long puds = 0, pmds = 0, ptes = 0, tables;
> > +       unsigned long start = 0, good_end;
> >         phys_addr_t base;
> >
> > -       puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
> > -       tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
> > +       for (i = 0; i < nr_range; i++) {
> > +               unsigned long range, extra;
> >
> > -       if (use_gbpages) {
> > -               unsigned long extra;
> > +               range = mr[i].end - mr[i].start;
> > +               puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
> >
> > -               extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
> > -               pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
> > -       } else
> > -               pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
> > -
> > -       tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
> > +               if (mr[i].page_size_mask & (1 << PG_LEVEL_1G)) {
> > +                       extra = range - ((range >> PUD_SHIFT) << PUD_SHIFT);
> > +                       pmds += (extra + PMD_SIZE - 1) >> PMD_SHIFT;
> > +               } else {
> > +                       pmds += (range + PMD_SIZE - 1) >> PMD_SHIFT;
> > +               }
> >
> > -       if (use_pse) {
> > -               unsigned long extra;
> > -
> > -               extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
> > +               if (mr[i].page_size_mask & (1 << PG_LEVEL_2M)) {
> > +                       extra = range - ((range >> PMD_SHIFT) << PMD_SHIFT);
> >  #ifdef CONFIG_X86_32
> > -               extra += PMD_SIZE;
> > +                       extra += PMD_SIZE;
> >  #endif
> > -               ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > -       } else
> > -               ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > +                       /* The first 2/4M doesn't use large pages. */
> > +                       if (mr[i].start < PMD_SIZE)
> > +                               extra += range;
> 
> those three lines should be added back.
> 
> it just get reverted in 7b16bbf9

Could you please send a delta patch against tip:x86/urgent?

Thanks,

	Ingo
