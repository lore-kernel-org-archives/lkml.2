Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416Ab2JDOIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:08:16 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47921 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139Ab2JDOIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:08:14 -0400
Date: Thu, 4 Oct 2012 09:56:48 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
Message-ID: <20121004135646.GE9158@phenom.dumpdata.com>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
 <1348991844-12285-5-git-send-email-yinghai@kernel.org>
 <alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com>
 <20121003165105.GA30214@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003165105.GA30214@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 11:51:06AM -0500, Jacob Shin wrote:
> On Mon, Oct 01, 2012 at 12:00:26PM +0100, Stefano Stabellini wrote:
> > On Sun, 30 Sep 2012, Yinghai Lu wrote:
> > > After
> > > 
> > > | commit 8548c84da2f47e71bbbe300f55edb768492575f7
> > > | Author: Takashi Iwai <tiwai@suse.de>
> > > | Date:   Sun Oct 23 23:19:12 2011 +0200
> > > |
> > > |    x86: Fix S4 regression
> > > |
> > > |    Commit 4b239f458 ("x86-64, mm: Put early page table high") causes a S4
> > > |    regression since 2.6.39, namely the machine reboots occasionally at S4
> > > |    resume.  It doesn't happen always, overall rate is about 1/20.  But,
> > > |    like other bugs, once when this happens, it continues to happen.
> > > |
> > > |    This patch fixes the problem by essentially reverting the memory
> > > |    assignment in the older way.
> > > 
> > > Have some page table around 512M again, that will prevent kdump to find 512M
> > > under 768M.
> > > 
> > > We need revert that reverting, so we could put page table high again for 64bit.
> > > 
> > > Takashi agreed that S4 regression could be something else.
> > > 
> > > 	https://lkml.org/lkml/2012/6/15/182
> > > 
> > > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > > ---
> > >  arch/x86/mm/init.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> > > index 9f69180..aadb154 100644
> > > --- a/arch/x86/mm/init.c
> > > +++ b/arch/x86/mm/init.c
> > > @@ -76,8 +76,8 @@ static void __init find_early_table_space(struct map_range *mr,
> > >  #ifdef CONFIG_X86_32
> > >  	/* for fixmap */
> > >  	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
> > > -#endif
> > >  	good_end = max_pfn_mapped << PAGE_SHIFT;
> > > +#endif
> > >  
> > >  	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
> > >  	if (!base)
> > 
> > Isn't this going to cause init_memory_mapping to allocate pagetable
> > pages from memory not yet mapped?
> > Last time I spoke with HPA and Thomas about this, they seem to agree
> > that it isn't a very good idea.
> > Also, it is proven to cause a certain amount of headaches on Xen,
> > see commit d8aa5ec3382e6a545b8f25178d1e0992d4927f19.
> > 
> 
> Any comments, thoughts? hpa? Yinghai?
> 
> So it seems that during init_memory_mapping Xen needs to modify page table 
> bits and the memory where the page tables live needs to be direct mapped at
> that time.

That is not exactly true. I am not sure if we are just using the wrong
words for it - so let me try to write up what the impediment is.

There is also this talk between Stefano and tglrx that can help in
getting ones' head around it: https://lkml.org/lkml/2012/8/24/335

The restriction that Xen places on Linux page-tables is that they MUST
be read-only when in usage. Meaning if you creating a PTE table (or PMD,
PUD, etc), you can write to it as long as you want - but the moment you
hook it up to a live page-table - it must be marked RO (so the PMD entry
cannot have _PAGE_RW on it). Easy enough.

This means that if we are re-using a pagetable during the
init_memory_mapping (so we iomap it), we need to iomap it with
!_PAGE_RW) - and that is where xen_set_pte_init has a check for
is_early_ioremap_ptep. To add to the fun, the pagetables are expanding -
so as one is ioremapping/iounmaping, you have to check the pgt_buf_end
to check whether the page table we are mapping is within the:
 pgt_buf_start -> pgt_buf_end <- pgt_buf_top

(and pgt_buf_end can increment up to pgt_buf_top).

Now the next part of this that is hard to wrap around is when you
want to create a PTE entries for the pgt_buf_start -> pgt_buf_end.
Its double fun, b/c your pgt_buf_end can increment as you are
trying to create those PTE entries - and you _MUST_ mark those
PTE entries as RO. This is b/c those pagetables (pgt_buf_start ->
pgt_buf_end) are live and only Xen can touch them.

This feels like operating on a live patient, while said patient
is running the marathon. Only duct-tape expert can apply for
this position.


What Peter had in mind is a nice system where we get rid of
this linear allocation of page-tables (so pgt_buf_start -> pgt_buf
_end are linearly allocated). His thinking (and Peter if I mess
up please correct me), is that we can stick the various pagetables
in different spots in memory. Mainly that as we look at mapping
a region (say 0GB->1GB), we look at in chunks (2MB?) and allocate
a page-table at the _end_ of the newly mapped chunk if we have
filled all entries in said pagetable.

For simplicity, lets say we are just dealing with PTE tables and
we are mapping the region 0GB->1GB with 4KB pages.

First we stick a page-table (or if there is a found one reuse it)
at the start of the region (so 0-2MB).

0MB.......................2MB
/-----\
|PTE_A|
\-----/

The PTE entries in it will cover 0->2MB (PTE table #A) and once it is
finished, it will stick a new pagetable at the end of the 2MB region:

0MB.......................2MB...........................4MB
/-----\                /-----\
|PTE_A|                |PTE_B|
\-----/                \-----/


The PTE_B page table will be used to map 2MB->4MB.

Once that is finished .. we repeat the cycle.

That should remove the utter duct-tape madness and make this a lot
easier.
