Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab2JEKsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 06:48:14 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:15704 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab2JEKsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 06:48:13 -0400
X-IronPort-AV: E=Sophos;i="4.80,541,1344211200"; 
   d="scan'208";a="14959953"
Date: Fri, 5 Oct 2012 11:47:10 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
In-Reply-To: <CAE9FiQUMMRPb2u13R2b7hHSOTgb4jKcnbAace7T22_GCm=-HxQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1210051131420.29232@kaball.uk.xensource.com>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org> <1348991844-12285-5-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com> <CAE9FiQUMMRPb2u13R2b7hHSOTgb4jKcnbAace7T22_GCm=-HxQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2012, Yinghai Lu wrote:
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

Yes, but as Konrad explained, the mapping should be RO or RW on Xen
depending on whether the pagetable pages are already hooked into the
pagetable or not. ioremap could be called on not-yet-hooked pagetable
pages (or non-pagetable-pages) and already-hooked pagetable pages and
they need to be marked differently. Finally when you are going to map
the region in memory that contains the pagetable pages, the entire range
needs to be marked RO.

These issues could be avoided if the pagetable pages were allocated from
a memory region that is already mapped and we had a proper pvop to warn
the Xen subsystem that the pagetable pages are about to be hooked into
the live pagetable.


> > Last time I spoke with HPA and Thomas about this, they seem to agree
> > that it isn't a very good idea.
> > Also, it is proven to cause a certain amount of headaches on Xen,
> > see commit d8aa5ec3382e6a545b8f25178d1e0992d4927f19.
> 
> this patchset will allocate page table buf one time only.
> So could use ram under 1M to map that page table at first.

I don't have anything agaist the goal of this series, the problem is
just where these pagetable pages come from.


> so that will make it xen happy ?

It would greatly simplify our life if the pagetable pages were
allocated from memory already mapped.
