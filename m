Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab0GIRLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:11:51 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:58794 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab0GIRLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:11:49 -0400
Date: Fri, 9 Jul 2010 19:11:39 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Daniel Kiper <dkiper@net-space.pl>, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] GSoC 2010 - Migration from memory ballooning to memory hotplug in Xen
Message-ID: <20100709171139.GB8696@router-fw-old.local.net-space.pl>
References: <20100708194553.GA30124@router-fw-old.local.net-space.pl> <4C365C30.2090001@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C365C30.2090001@goop.org>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 04:16:00PM -0700, Jeremy Fitzhardinge wrote:
> On 07/08/2010 12:45 PM, Daniel Kiper wrote:
> >   - find free (not claimed by another memory region or device)
> >     memory region of PAGES_PER_SECTION << PAGE_SHIFT
> >     size in iomem_resource,
>
> Presumably in the common case this will be at the end of the memory
> map?  Since a typical PV domain has all its initial memory allocated low
> and doesn't have any holes.

Yes, I know about that however I think it is much better
to write more generic algorithm which also looks for
the holes (not claimed regions) in memory (maybe in the
future something changes). Additionally, this list mostly
is very short and cost of scan is considerably low.

> >   - find all PFNs for choosen memory region
> >     (addr >> PAGE_SHIFT),
> >   - allocate memory from hypervisor by
> >     HYPERVISOR_memory_op(XENMEM_populate_physmap, &memory_region),
>
> Is it actually necessary to allocate the memory at this point?

Yes, it is because mm/memory_hotplug.c:add_memory
(not exactly this one) updates memory map.

> >   - inform system about new memory region and reserve it by
> >     mm/memory_hotplug.c:add_memory(memory_add_physaddr_to_nid(start_addr),
> >                                    start_addr, PAGES_PER_SECTION << PAGE_SHIFT),
> >   - online memory region by
> >     mm/memory_hotplug.c:online_pages(start_addr >> PAGE_SHIFT,
> >                                      PAGES_PER_SECTION << PAGE_SHIFT).
>
> It seems to me you could add the memory (to get the new struct pages)
> and "online" it, but immediately take a reference to the page and give
> it over to the balloon driver to manage as a ballooned-out page.  Then,
> when you actually need the memory, the balloon driver can provide it in
> the normal way.

I am going to do that in similar way.

> > I am going to send you first version of patch
> > (fully working) next week.
>
> Looking forward to it.  What kernel is it based on?

Ver. 2.6.32.10 however I suppose it will be no problem
to move it to current version.

Daniel
