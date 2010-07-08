Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab0GHTyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 15:54:14 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:56070 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267Ab0GHTyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 15:54:12 -0400
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2010 15:54:12 EDT
Date: Thu, 8 Jul 2010 21:45:53 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: GSoC 2010 - Migration from memory ballooning to memory hotplug in Xen
Message-ID: <20100708194553.GA30124@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

My name is Daniel Kiper and I am a PhD student
at Warsaw University of Technology, Faculty of Electronics
and Information Technology (I am working on business continuity
and disaster recovery services with emphasis on Air Traffic Management).

This year I put an proposal regarding migration from memory ballooning
to memory hotplug in Xen to Google Summer of Code 2010 (it was one of
my two proposals). It was accepted and now I happy GSoC 2010 student.
My mentor is Jeremy Fitzhardinge. I would like to thank him
for his patience and supporting hand.

OK, let's go to details. When I was playing with Xen I saw that
ballooning does not give possibility to extend memory over boundary
declared at the start of system. Yes, I know that is by desing however
I thought that it is a limitation which could by very annoing in some
enviroments (I think especially about servers). That is why I decided to
develop some code which remove that one. At the beggining I thought
that it should be replaced by memory hotplyg however after some test
and discussion with Jeremy we decided to link balooning (for memory
removal) with memory hotplug (for extending memory above boundary
declared at the startup of system). Additionaly, we decided to implement
this solution for Linux Xen gustes in all forms (PV/i386,x86_64 and
HVM/i386,x86_64).

Now, I have done most of the planned tests and wrote a PoC.

Short description of current algorithm (it was prepared
for PoC and it will be changed to implement convenient
mechanism for user):
  - find free (not claimed by another memory region or device)
    memory region of PAGES_PER_SECTION << PAGE_SHIFT
    size in iomem_resource,
  - find all PFNs for choosen memory region
    (addr >> PAGE_SHIFT),
  - allocate memory from hypervisor by
    HYPERVISOR_memory_op(XENMEM_populate_physmap, &memory_region),
  - inform system about new memory region and reserve it by
    mm/memory_hotplug.c:add_memory(memory_add_physaddr_to_nid(start_addr),
                                   start_addr, PAGES_PER_SECTION << PAGE_SHIFT),
  - online memory region by
    mm/memory_hotplug.c:online_pages(start_addr >> PAGE_SHIFT,
                                     PAGES_PER_SECTION << PAGE_SHIFT).

Currently, memory is added and onlined in 128MiB blocks (section size
for x86), however I am going to do that in smaller chunks.
Additionally, some things are done manually however
it will be changed in final implementation.
I would like to mention that this solution
does not require any change in Xen hypervisor.

I am going to send you first version of patch
(fully working) next week.

If you have any questions please drop me a line.

Daniel
