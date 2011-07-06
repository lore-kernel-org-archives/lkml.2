Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1GFQcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:32:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1GFQcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:32:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 6/8] drivers: add Contiguous Memory Allocator
Date: Wed, 6 Jul 2011 18:31:59 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>, "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <201107061651.49824.arnd@arndb.de> <20110706154857.GG8286@n2100.arm.linux.org.uk>
In-Reply-To: <20110706154857.GG8286@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107061831.59739.arnd@arndb.de>
X-Provags-ID: V02:K0:kNezjE7JRvm57eNGnk9C9tmh35ukxGEOYU8/nGvLyYl
 GcUl8V8xEbhWjOa7QENr5DT6tlp5b+C8JAJCshbmWDF6iaJJCm
 H1lYbeUcXYdi1xxOgvxQ/2ItBxgUhJgHC5X1Lhr4DRWWyiXFfV
 jWd/Od47gxZrihuzu3+z4RnriRhYtX8YZDc2LEl8ms5u87wKh5
 86fc5U65sHCerpnEqdMGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 July 2011, Russell King - ARM Linux wrote:
> On Wed, Jul 06, 2011 at 04:51:49PM +0200, Arnd Bergmann wrote:
> > On Wednesday 06 July 2011, Russell King - ARM Linux wrote:
> > 
> > I don't see how. The pages get allocated from an unmapped area
> > or memory, mapped into the kernel address space as uncached or wc
> > and then cleared. This should be the same for lowmem or highmem
> > pages.
> 
> You don't want to clear them via their uncached or WC mapping, but via
> their cached mapping _before_ they get their alternative mapping, and
> flush any cached out of that mapping - both L1 and L2 caches.

But there can't be any other mapping, which is the whole point of
the exercise to use highmem.
Quoting from the new dma_alloc_area() function:

        c = arm_vmregion_alloc(&area->vm, align, size,
                            gfp & ~(__GFP_DMA | __GFP_HIGHMEM));
        if (!c)
                return NULL;
        memset((void *)c->vm_start, 0, size);

area->vm here points to an uncached location, which means that
we already zero the data through the uncached mapping. I don't
see how it's getting worse than it is already.

> > > Another issue is that when a platform has restricted DMA regions,
> > > they typically don't fall into the highmem zone.  As the dmabounce
> > > code allocates from the DMA coherent allocator to provide it with
> > > guaranteed DMA-able memory, that would be rather inconvenient.
> > 
> > True. The dmabounce code would consequently have to allocate
> > the memory through an internal function that avoids the
> > contiguous allocation area and goes straight to ZONE_DMA memory
> > as it does today.
> 
> CMA's whole purpose for existing is to provide _dma-able_ contiguous
> memory for things like cameras and such like found on crippled non-
> scatter-gather hardware.  If that memory is not DMA-able what's the
> point?

I mean not any ZONE_DMA memory, but the memory backing coherent_areas[],
which is by definition DMA-able from any device and is what is currently
being used for the purpose.

	Arnd
