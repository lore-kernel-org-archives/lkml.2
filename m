Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab1IUKmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:42:12 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:5940 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab1IUKmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:42:11 -0400
X-IronPort-AV: E=Sophos;i="4.68,416,1312156800"; 
   d="scan'208";a="7974710"
Date: Wed, 21 Sep 2011 11:42:01 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/6] xen: don't call vmalloc_sync_all() when mapping
 foreign pages
In-Reply-To: <4E727017.4030001@goop.org>
Message-ID: <alpine.DEB.2.00.1109211124050.8700@kaball-desktop>
References: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com> <4E727017.4030001@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011, Jeremy Fitzhardinge wrote:
> On 09/15/2011 05:40 AM, David Vrabel wrote:
> > This set of pages avoids the need to call vmalloc_sync_all() when
> > mapping foreign pages.  Two new functions are adding for mapping
> > foreign pages onto RAM pages instead of vmalloc space.
> >
> > This does waste a page of RAM for each mapped page.  In the future a
> > ballooned page could be used instead (once the API for getting a
> > ballooned page with the right GFP flags is available).
> 
> You can allocate a pfn, free ("balloon out") the underlying mfn, and
> replace it with a granted page; it doesn't need any particular new
> infrastructure.

David, give a look at drivers/xen/balloon.c:alloc_xenballooned_pages, in
particular after my changes to it:

http://marc.info/?l=linux-kernel&m=131552369305998&w=2

it allows the caller to allocate a lowmem page and balloon it out right
away.


> But that said, if you want to allocate virtual addresses for mapping
> granted pages, then alloc_vm_area() is the right thing to use.  You need
> to make sure you touch the pages from within the kernel before passing
> those addresses to a hypercall to make sure the mappings are established
> within the current task (possibly within a no-preempt region to
> guarantee that nothing odd happens).  Or alternatively, you could switch
> the current pagetable to init_mm for the hypercall (if it isn't already)
> - since that's the reference pagetable - assuming you're not passing
> usermode virtual addresses to the hypercall.

This problem is not very different from the one we are trying to solve
with alloc_xenballooned_pages: in case we want a page that is mapped in
kernel space we just use allocate a lowmem page, balloon it out, change
the p2m and add the page to the m2p_override.
Why should we solve that issue differently?


> This series is relying on regular ram mappings are already synced to all
> tasks, but I'm not sure that's necessarily guaranteed (for example, if
> you hotplug new memory into the domain, the new pages won't be mapped
> into every mm unless they're synced).

the series is using GFP_KERNEL, so this problem shouldn't occur, right?
