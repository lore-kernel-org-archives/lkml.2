Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab2JDQ5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:57:47 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20598 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821Ab2JDQ5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:57:46 -0400
Date: Thu, 4 Oct 2012 12:45:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
Message-ID: <20121004164551.GA2244@phenom.dumpdata.com>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
 <1348991844-12285-5-git-send-email-yinghai@kernel.org>
 <alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com>
 <CAE9FiQUMMRPb2u13R2b7hHSOTgb4jKcnbAace7T22_GCm=-HxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUMMRPb2u13R2b7hHSOTgb4jKcnbAace7T22_GCm=-HxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 08:57:55AM -0700, Yinghai Lu wrote:
> On Mon, Oct 1, 2012 at 4:00 AM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
> > On Sun, 30 Sep 2012, Yinghai Lu wrote:
> >> After
> >>
> >> | commit 8548c84da2f47e71bbbe300f55edb768492575f7
> >> | Author: Takashi Iwai <tiwai@suse.de>
> >> | Date:   Sun Oct 23 23:19:12 2011 +0200
> >> |
> >> |    x86: Fix S4 regression
> >> |
> >> |    Commit 4b239f458 ("x86-64, mm: Put early page table high") causes a S4
> >> |    regression since 2.6.39, namely the machine reboots occasionally at S4
> >> |    resume.  It doesn't happen always, overall rate is about 1/20.  But,
> >> |    like other bugs, once when this happens, it continues to happen.
> >> |
> >> |    This patch fixes the problem by essentially reverting the memory
> >> |    assignment in the older way.
> >>
> >> Have some page table around 512M again, that will prevent kdump to find 512M
> >> under 768M.
> >>
> >> We need revert that reverting, so we could put page table high again for 64bit.
> >>
> >> Takashi agreed that S4 regression could be something else.
> >>
> >>       https://lkml.org/lkml/2012/6/15/182
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> ---
> >>  arch/x86/mm/init.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> >> index 9f69180..aadb154 100644
> >> --- a/arch/x86/mm/init.c
> >> +++ b/arch/x86/mm/init.c
> >> @@ -76,8 +76,8 @@ static void __init find_early_table_space(struct map_range *mr,
> >>  #ifdef CONFIG_X86_32
> >>       /* for fixmap */
> >>       tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
> >> -#endif
> >>       good_end = max_pfn_mapped << PAGE_SHIFT;
> >> +#endif
> >>
> >>       base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
> >>       if (!base)
> >
> > Isn't this going to cause init_memory_mapping to allocate pagetable
> > pages from memory not yet mapped?
> 
> but 64bit is using ioremap to access those page table buf.
> 
> > Last time I spoke with HPA and Thomas about this, they seem to agree
> > that it isn't a very good idea.
> > Also, it is proven to cause a certain amount of headaches on Xen,
> > see commit d8aa5ec3382e6a545b8f25178d1e0992d4927f19.
> 
> this patchset will allocate page table buf one time only.

As in, if your machine has 8GB, it will allocate pagetables that
span 0->8GB at once?

> So could use ram under 1M to map that page table at first.

Could or does this patch do it? And why 1MB?
> 
> so that will make it xen happy ?

The issues that Xen faces are purely due to the fact that they
must be RO when they are in use. I believe (and without actually
checking it just to make sure) that it does not matter where
the page-tables are located. But with the current generic code
the location is quite linear: it starts with pgt_buf_start and
goes up to pgt_buf_top. So how would this patch move the location
of the page-table to be under 1MB?

Perhaps we are talking about seperate topics?

My recollection of memblock_find_in_range is that it will try
the end of the range to find a suitable "chunk" that satisfies
the 'size' and 'aligment' parameters?
