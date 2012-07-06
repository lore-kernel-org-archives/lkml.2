Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab2GFNuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:50:19 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:20775 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752950Ab2GFNuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:50:15 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: hAnklAAVM1mExjgbQAikmFYBsiKWdU.piv9smOP1FbbdrwU
 ygFSs1odLBeolAyKK0VD9sU2VyTno1ajyY1unXeM0N4aPz5YfWx7ickDDL7l
 699TQXtXuhPeicA7TC8kQ7SZpQoca_7EEjxPM1nH6XSX6VZ124nW6u1dSj8q
 BIhzvVj72BWTieZg9a1ebSUw4U4C7iAlUc0rdWEGvdYhO90FPkwlyP4DsyQM
 nUxPcMmzp3zwlR6pDrmDmvLucpRHqufp3ScFhU3qDt1XyGdI2oOC6DanWbqb
 h0E1i2nis1Zvq93KnOenRorND1KC.BZVti43buvXehY6C0JDkQNR5e2dL_4T
 1Ez7q_HQhQs2D4Y.lq9xDfNLQGTG2xJ4gbdMQ2EJhOciFggP120jt4dwZLZk
 2
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 6 Jul 2012 08:50:09 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jiang Liu <jiang.liu@huawei.com>
cc: Jiang Liu <liuj97@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>, Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] mm: introduce a safer interface to check whether
 a page is managed by SLxB
In-Reply-To: <4FF693F6.8070505@huawei.com>
Message-ID: <alpine.DEB.2.00.1207060841001.26441@router.home>
References: <1341287837-7904-1-git-send-email-jiang.liu@huawei.com> <alpine.DEB.2.00.1207050942540.4984@router.home> <4FF5B909.30409@gmail.com> <alpine.DEB.2.00.1207051229490.8670@router.home> <4FF693F6.8070505@huawei.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2012, Jiang Liu wrote:

> 	Originally the patch is aimed to fix an issue encountered when
> hot-removing a hot-added memory device. Currently memory hotplug is only
> supported with SPARSE memory model. After offlining all pages of a memory
> section, we need to free resources used by "struct mem_section" itself.
> That is to free section_mem_map and pageblock_flags. For memory section
> created at boot time, section_mem_map and pageblock_flags are allocated
> from bootmem. For memory section created at runtime, section_mem_map
> and pageblock_flags are allocated from slab. So when freeing these
> resources, we use PageSlab() to tell whether there are allocated from slab.
> So free_section_usemap() has following code snippet.
> {
>         usemap_page = virt_to_page(usemap);
>         /*
>          * Check to see if allocation came from hot-plug-add
>          */
>         if (PageSlab(usemap_page)) {

Change this to PageSlab(usemap_page) || PageCompound(usemap_page) and then
the code segment will work. Fallback to the page allocator always implied
the use of compound pages. It would be cleaner if memory hotplug had an
indicator which allocation mechanism was used and would use the
corresponding free action. Slab allocators could put multiple objects into
the slab page (if the structures are sufficiently small). So this is not
that good of a solution.


> 	And when fixing this issue, we found some other usages of PageSlab() may
> have the same issue. For example:
> 	1) /proc/kpageflags and /proc/kpagecount may return incorrect result for
> pages allocated by slab.

Ok then the compound page handling is broken in those.

> 	2) DRBD has following comments. At first glance, it seems that it's
> 	dangerous if PageSlab() to return false for pages allocated by slab.

Again the pages that do not have PageSlab set were not allocated using a
slab allocator. They were allocated by calls to the page allocator.

> 	(With more thinking, the comments is a little out of date because now
> 	put_page/get_page already correctly handle compound pages, so it should
> 	be OK to send pages allocated from slab.)

AFAICT they always handled compound pages correctly.

> 	3) show_mem() on ARM and unicore32 reports much less pages used by slab
> 	if SLUB/SLOB is used instead of SLAB because SLUB/SLOB doesn't mark big
> 	compound pages with PG_slab flag.

Right. That is because SLUB/SLOB lets the page allocator directly
allocator large structures where it would not make sense to use the slab
allocators. The main purpose of the slab allocators is to allocate
objects in fractions of pages. This does not seem to be a use case for
slab objects. Maybe it would be better to directly call the page allocator
for your large structures?

> 	For example, if the memory backing a "struct resource" structure is
> allocated from bootmem, __release_region() shouldn't free the memory into
> slab allocator, otherwise it will trigger panic as below. This issue is
> reproducible when hot-removing a memory device present at boot time on x86
> platforms. On x86 platforms, e820_reserve_resources() allocates bootmem for
> all physical memory resources present at boot time. Later when those memory
> devices are hot-removed, __release_region() will try to free  memory from
> bootmem into slab, so trigger the panic. And a proposed fix is:

Working out how a certain memory structure was allocated could be most
easily done by setting a flag somewhere instead of checking the page flags
of a page that may potentially include multiple slab objects.
