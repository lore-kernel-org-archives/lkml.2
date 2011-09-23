Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab1IWKxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 06:53:37 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:50481 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1IWKxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 06:53:33 -0400
X-IronPort-AV: E=Sophos;i="4.68,428,1312156800"; 
   d="scan'208";a="8026626"
Date: Fri, 23 Sep 2011 11:53:35 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH 0/6] xen: don't call vmalloc_sync_all()
 when mapping foreign pages
In-Reply-To: <4E7BA677.9090907@goop.org>
Message-ID: <alpine.DEB.2.00.1109231146510.8700@kaball-desktop>
References: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com> <4E727017.4030001@goop.org> <alpine.DEB.2.00.1109211124050.8700@kaball-desktop> <4E7A3394.3090806@goop.org> <alpine.DEB.2.00.1109221131390.8700@kaball-desktop>
 <4E7BA677.9090907@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Sep 2011, Jeremy Fitzhardinge wrote:
> On 09/22/2011 04:06 AM, Stefano Stabellini wrote:
> > On Wed, 21 Sep 2011, Jeremy Fitzhardinge wrote:
> >> On 09/21/2011 03:42 AM, Stefano Stabellini wrote:
> >>> On Thu, 15 Sep 2011, Jeremy Fitzhardinge wrote:
> >>>> This series is relying on regular ram mappings are already synced to all
> >>>> tasks, but I'm not sure that's necessarily guaranteed (for example, if
> >>>> you hotplug new memory into the domain, the new pages won't be mapped
> >>>> into every mm unless they're synced).
> >>> the series is using GFP_KERNEL, so this problem shouldn't occur, right?
> >> What properties do you think GFP_KERNEL guarantees?
> > That the memory is below 4G and always mapped in the kernel 1:1 region.
> 
> Hm, but that's not quite the same thing as "mapped into every
> pagetable".  Lowmem pages always have a kernel virtual address, and its
> always OK to touch them at any point in kernel code[*] because one can
> rely on the fault handler to create mappings as needed - but that
> doesn't mean they're necessarily mapped by present ptes in the current
> pagetable.
> 
> [*] - except NMI handlers

Is that really true?
I quickly went through the fault handler and I couldn't see anything
related to the kernel 1:1 region.


> > Regarding memory hotplug it looks like that x86_32 is mapping new memory
> > ZONE_HIGHMEM, therefore avoiding any problems with GFP_KERNEL allocations.
> > On the other hand x86_64 is mapping the memory ZONE_NORMAL and calling
> > init_memory_mapping on the new range right away. AFAICT changes to
> > the 1:1 mapping in init_mm are automatically synced across all mm's
> > because the pgd is shared?
> 
> TBH I'm not sure.  vmalloc_sync_one/all does seem to do *something* on
> 64-bit, but I was never completely sure what regions of the address
> space were already shared.  I *think* it might be that the pgd and pud
> are not shared, but the pmd down is, so if you add a new pmd you need to
> sync it into all the puds (and puds into pgds if you add a new one of
> those).
> 
> But I'd be happier pretending that vmalloc_sync_* just doesn't exist,
> and deal with it at the hypercall level - in the short term, by just
> making sure that the callers touch all those pages before passing them
> into the hypercall.

That would certainly be an improvement over what we have now.

However I am worried about the gntdev stuff: if I am right and the 1:1
mapping is guaranteed to be sync'ed, then it is OK and we can use
alloc_xenballooned_pages everywhere, otherwise we should fix or remove
alloc_xenballooned_pages from gntdev too.
