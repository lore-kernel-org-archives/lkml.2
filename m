Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab0GHXQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:16:12 -0400
Received: from claw.goop.org ([74.207.240.146]:43305 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758782Ab0GHXQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:16:06 -0400
Message-ID: <4C365C30.2090001@goop.org>
Date: Thu, 08 Jul 2010 16:16:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Daniel Kiper <dkiper@net-space.pl>
CC: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] GSoC 2010 - Migration from memory ballooning to memory
 hotplug in Xen
References: <20100708194553.GA30124@router-fw-old.local.net-space.pl>
In-Reply-To: <20100708194553.GA30124@router-fw-old.local.net-space.pl>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2010 12:45 PM, Daniel Kiper wrote:
> Hello,
>
> My name is Daniel Kiper and I am a PhD student
> at Warsaw University of Technology, Faculty of Electronics
> and Information Technology (I am working on business continuity
> and disaster recovery services with emphasis on Air Traffic Management).
>
> This year I put an proposal regarding migration from memory ballooning
> to memory hotplug in Xen to Google Summer of Code 2010 (it was one of
> my two proposals). It was accepted and now I happy GSoC 2010 student.
> My mentor is Jeremy Fitzhardinge. I would like to thank him
> for his patience and supporting hand.
>
> OK, let's go to details. When I was playing with Xen I saw that
> ballooning does not give possibility to extend memory over boundary
> declared at the start of system. Yes, I know that is by desing however
> I thought that it is a limitation which could by very annoing in some
> enviroments (I think especially about servers). That is why I decided to
> develop some code which remove that one. At the beggining I thought
> that it should be replaced by memory hotplyg however after some test
> and discussion with Jeremy we decided to link balooning (for memory
> removal) with memory hotplug (for extending memory above boundary
> declared at the startup of system). Additionaly, we decided to implement
> this solution for Linux Xen gustes in all forms (PV/i386,x86_64 and
> HVM/i386,x86_64).
>
> Now, I have done most of the planned tests and wrote a PoC.
>
> Short description of current algorithm (it was prepared
> for PoC and it will be changed to implement convenient
> mechanism for user):
>   - find free (not claimed by another memory region or device)
>     memory region of PAGES_PER_SECTION << PAGE_SHIFT
>     size in iomem_resource,
>   

Presumably in the common case this will be at the end of the memory
map?  Since a typical PV domain has all its initial memory allocated low
and doesn't have any holes.

>   - find all PFNs for choosen memory region
>     (addr >> PAGE_SHIFT),
>   - allocate memory from hypervisor by
>     HYPERVISOR_memory_op(XENMEM_populate_physmap, &memory_region),
>   

Is it actually necessary to allocate the memory at this point?

>   - inform system about new memory region and reserve it by
>     mm/memory_hotplug.c:add_memory(memory_add_physaddr_to_nid(start_addr),
>                                    start_addr, PAGES_PER_SECTION << PAGE_SHIFT),
>   - online memory region by
>     mm/memory_hotplug.c:online_pages(start_addr >> PAGE_SHIFT,
>                                      PAGES_PER_SECTION << PAGE_SHIFT).
>   

It seems to me you could add the memory (to get the new struct pages)
and "online" it, but immediately take a reference to the page and give
it over to the balloon driver to manage as a ballooned-out page.  Then,
when you actually need the memory, the balloon driver can provide it in
the normal way.

(I'm not sure where it allocates the new page structures from, but if
its out of the newly added memory you'll need to allocate that up-front,
at least.)

> Currently, memory is added and onlined in 128MiB blocks (section size
> for x86), however I am going to do that in smaller chunks.
>   

If you can avoid actually allocating the pages, then 128MiB isn't too
bad.  I think that's only ~2MiB of page structures.

> Additionally, some things are done manually however
> it will be changed in final implementation.
> I would like to mention that this solution
> does not require any change in Xen hypervisor.
>
> I am going to send you first version of patch
> (fully working) next week.
>   

Looking forward to it.  What kernel is it based on?

Thanks,
    J
