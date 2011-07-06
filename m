Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab1GFTKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:10:13 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37098 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab1GFTKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:10:11 -0400
Date: Wed, 6 Jul 2011 15:10:07 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Arnd Bergmann <arnd@arndb.de>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>, "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8] drivers: add Contiguous Memory Allocator
In-Reply-To: <201107061831.59739.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1107061459520.14596@xanadu.home>
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <201107061651.49824.arnd@arndb.de> <20110706154857.GG8286@n2100.arm.linux.org.uk> <201107061831.59739.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011, Arnd Bergmann wrote:

> On Wednesday 06 July 2011, Russell King - ARM Linux wrote:
> > On Wed, Jul 06, 2011 at 04:51:49PM +0200, Arnd Bergmann wrote:
> > > On Wednesday 06 July 2011, Russell King - ARM Linux wrote:
> > > 
> > > I don't see how. The pages get allocated from an unmapped area
> > > or memory, mapped into the kernel address space as uncached or wc
> > > and then cleared. This should be the same for lowmem or highmem
> > > pages.
> > 
> > You don't want to clear them via their uncached or WC mapping, but via
> > their cached mapping _before_ they get their alternative mapping, and
> > flush any cached out of that mapping - both L1 and L2 caches.
> 
> But there can't be any other mapping, which is the whole point of
> the exercise to use highmem.
> Quoting from the new dma_alloc_area() function:
> 
>         c = arm_vmregion_alloc(&area->vm, align, size,
>                             gfp & ~(__GFP_DMA | __GFP_HIGHMEM));
>         if (!c)
>                 return NULL;
>         memset((void *)c->vm_start, 0, size);
> 
> area->vm here points to an uncached location, which means that
> we already zero the data through the uncached mapping. I don't
> see how it's getting worse than it is already.

If you get a highmem page, because the cache is VIPT, that page might 
still be cached even if it wasn't mapped.  With a VIVT cache we must 
flush the cache whenever a highmem page is unmapped.  There is no such 
restriction with VIPT i.e. ARMv6 and above.  Therefore to make sure the 
highmem page you get doesn't have cache lines associated to it, you must 
first map it cacheable, then perform cache invalidation on it, and 
eventually remap it as non-cacheable.  This is necessary because there 
is no way to perform cache maintenance on L1 cache using physical 
addresses unfortunately.  See commit 7e5a69e83b for an example of what 
this entails (fortunately commit 3e4d3af501 made things much easier and 
therefore commit 39af22a79 greatly simplified things).



Nicolas
