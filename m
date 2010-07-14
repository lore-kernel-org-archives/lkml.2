Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0GNCBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 22:01:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:34866 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab0GNCBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 22:01:09 -0400
Date: Wed, 14 Jul 2010 10:59:43 +0900
To: linux@arm.linux.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, alan@lxorguk.ukuu.org.uk,
        randy.dunlap@oracle.com, dwalker@codeaurora.org, mel@csn.ul.ie,
        linux-arm-msm@vger.kernel.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, andi@firstfloor.org,
        zpfeffer@codeaurora.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100713090223.GB20590@n2100.arm.linux.org.uk>
References: <20100713094244.7eb84f1b@lxorguk.ukuu.org.uk>
	<20100713174519D.fujita.tomonori@lab.ntt.co.jp>
	<20100713090223.GB20590@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100714105922D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 14 Jul 2010 10:59:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010 10:02:23 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Tue, Jul 13, 2010 at 05:45:39PM +0900, FUJITA Tomonori wrote:
> > Drivers can tell the USB layer that these are vmapped buffers? Adding
> > something to struct urb? I might be totally wrong since I don't know
> > anything about the USB layer.
> 
> With non-DMA coherent aliasing caches, you need to know where the page
> is mapped into the virtual address space, so you can deal with aliases.
> 
> You'd need to tell the USB layer about the other mappings of the page
> which you'd like to be coherent (such as the vmalloc area - and there's
> also the possible userspace mapping to think about too, but that's
> a separate issue.)
> 
> I wonder if we should have had:
> 
> 	vmalloc_prepare_dma(void *, size_t, enum dma_direction)
> 	vmalloc_finish_dma(void *, size_t, enum dma_direction)
> 
> rather than flush_kernel_vmap_range and invalidate_kernel_vmap_range,
> which'd make their use entirely obvious.
> 
> However, this brings up a question - how does the driver (eg, v4l, xfs)
> which is preparing the buffer for another driver (eg, usb host, block
> dev) know that DMA will be performed on the buffer rather than PIO?
> 
> That's a very relevant question, because for speculatively prefetching
> CPUs, we need to invalidate caches after a DMA-from-device operation -
> but if PIO-from-device happened, this would destroy data read from the
> device.
> 
> That problem goes away if we decide that PIO drivers must have the same
> apparant semantics as DMA drivers - in that data must end up beyond the
> point of DMA coherency (eg, physical page) - but that's been proven to
> be very hard to achieve, especially with block device drivers.

Yeah, the last thing we want to do is converting all the PIO drivers.

Seems that we are far from the original discussion (the most of the
above topics have been discussed in the past and we kinda agree that
we have to do something some time, I guess).


Zach Pfeffer said this new VCM infrastructure can be useful for
video4linux. However, I don't think we need 3,000-lines another
abstraction layer to solve video4linux's issue nicely.

I can't find any reasonable reasons that we need to merge VCM; seems
that the combination of the current APIs (or with some small
extensions) can work for the issues that VCM tries to solve.
