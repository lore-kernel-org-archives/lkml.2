Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1CGP4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:56:13 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:12857 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab1CGPzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:55:54 -0500
X-IronPort-AV: E=Sophos;i="4.62,277,1297036800"; 
   d="scan'208";a="4654134"
Date: Mon, 7 Mar 2011 15:55:37 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: "x86-64, mm: Put early page table high" causes crash on Xen
In-Reply-To: <20110302170628.GA9268@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1103071317390.2968@kaball-desktop>
References: <alpine.DEB.2.00.1103011517280.2917@kaball-desktop> <4D6D6980.7060304@kernel.org> <alpine.DEB.2.00.1103021123140.2968@kaball-desktop> <20110302170628.GA9268@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, Konrad Rzeszutek Wilk wrote:
> On Wed, Mar 02, 2011 at 03:23:48PM +0000, Stefano Stabellini wrote:
> > On Tue, 1 Mar 2011, Yinghai Lu wrote:
> > > We do need map_low_page ( BTW, that name is totally misleading...)
> > > 
> > > the reason is we put page_table high and at that time is not under max_pfn_mapped. (aka not mapped).
> > > 
> > > So have to use 
> > > 	adr = early_memremap(phys & PAGE_MASK, PAGE_SIZE);
> > > to early map it and Read/Write to it.
> >  
> > I think I have figured out a way to update the logic of mask_rw_pte to
> > account for the new way of allocating kernel pagetables.
> > The appended patch fix the boot crash for me.
> > 
> > ---
> > 
> > xen: update mask_rw_pte after kernel page tables init changes
> > 
> > Already existing kernel page table pages can now be mapped using
> > early_ioremap too so we need to update mask_rw_pte to make sure these
> > pages are still mapped RO.
> > We do that by mapping RO all the pages mapped using early_ioremap apart
> > from the last one that has been allocated because it is not a page table
> > page yet (it has been hooked into the page tables yet).
>                   ^- has not?
> 
> ..this is b/c the initial_kernel_mapping and its family of calls update
> the pgt_buf_end (used to be called e820_table_end), _before__
> it calls the Xen MMU to set the PTE entries and then after it is done
> update the PMD?. Hence the simple check to see if the PFN is the _old_
> value of the pgt_buf_end and if so skip altering the mapping from RW to RO
> and leave them be?

yes and yes


> On subsequent passes we fall within the first conditional
> and update the PTE to RO?
> When is that pass done?

kernel_physical_mapping_init doesn't go through the same pagetable
pages twice so that is not the issue.
The problem is that kernel_physical_mapping_init is now re-mapping all
the initial pagetable pages using early_ioremap, so the usage of
early_ioremap is not enough anymore to distinguish between freshly
allocated page table pages and already hooked pagetable pages.
I am investigating the possibility that the introduction of map_low_page
is actually overkill for this reason.


> You also might want to mention the git commits that inspired this patch
> and include the nice description you provided in the first email of this
> thread.

sure
