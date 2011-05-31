Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab1EaNpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:45:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45101 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1EaNpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:45:49 -0400
Date: Tue, 31 May 2011 09:45:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Haid <d.haid@gogi.tv>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about iommu on x86_64 and radeon driver.
Message-ID: <20110531134519.GC14641@dumpdata.com>
References: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv>
 <20110523220536.GB11961@dumpdata.com>
 <756073831c36e0404199a4e8239bcb70@admin.gogi.tv>
 <m2wrhf4sw5.fsf@firstfloor.org>
 <08370791664f069624d25c757ed101c0@admin.gogi.tv>
 <20110525125752.GB3467@dumpdata.com>
 <dfd8bfd19ba1fb77d6448bff97123e13@admin.gogi.tv>
 <20110527155507.GB11273@dumpdata.com>
 <9e26ea71798d10a3f900c777b71ff485@admin.gogi.tv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e26ea71798d10a3f900c777b71ff485@admin.gogi.tv>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090203.4DE4F0FE.015F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 11:20:09PM +0100, Daniel Haid wrote:
> >The DRM code is not used anymore. It was used by XFree86 but nowadays
> >the TTM code is used instead.
> 
> I see
> 
> >Ah, this would be a lengthy writeup.. so did you look at the
> >link I pointed you to?
> 
> Yes I have started, but do not understand everything yet.
> 
> What are MFNs? Is this something Xen-specific?
>

<nods>
> 
> An does your post imply that on bare metal with "swiotlb=force
> iommu=soft"
> alloc_page with GFP_DMA32 does also not allocate under 4GB?

Noo.. It does, but the normal assumption of 'phys_to_virt' == 'phys_to_bus' is
not valid anymore. Think of a buffer (swiotlb) which has a pool
of pages and when a PCI device wants a page, it hands one out. It also has
other functionality such as 'mapping' of an already allocated page. If the
PCI device asks the IOMMU (swiotlb) to map a page (and if you have 'swiotlb=force'
the page provided has been allocated above 4GB and the device can only handle
up to 32-bit), then swiotlb gives out a page from its own pool. You now have
two addresses: the one from the PCI pool (swiotlb) and the one you already
allocated. You are suppose to program your PCI card to read/write data to the
page provided from the IOMMU (so the swiotlb), which means that it won't
write to the page you had allocated. Hence there are a calls, such as 'sync_page'..
which will copy the contents from the swiotlb page to the one you had allocated
(or vice-versa). This is called 'bounce buffer'.

The radeon (and nouveau) don't have the code to call the 'sync_page', and
you wouldn't really want to do so - as it slows down the performance of the
machine. There exists another mechanism which is to allocate the pages
at the start, and not do mapping later one.

