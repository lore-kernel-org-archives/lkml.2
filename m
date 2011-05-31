Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab1EaQCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:02:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65412 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab1EaQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:02:42 -0400
Date: Tue, 31 May 2011 12:02:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Haid <d.haid@gogi.tv>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about iommu on x86_64 and radeon driver.
Message-ID: <20110531160221.GA31659@dumpdata.com>
References: <20110523220536.GB11961@dumpdata.com>
 <756073831c36e0404199a4e8239bcb70@admin.gogi.tv>
 <m2wrhf4sw5.fsf@firstfloor.org>
 <08370791664f069624d25c757ed101c0@admin.gogi.tv>
 <20110525125752.GB3467@dumpdata.com>
 <dfd8bfd19ba1fb77d6448bff97123e13@admin.gogi.tv>
 <20110527155507.GB11273@dumpdata.com>
 <9e26ea71798d10a3f900c777b71ff485@admin.gogi.tv>
 <20110531134519.GC14641@dumpdata.com>
 <59be1730ec1660abeb7b4dc584510d34@admin.gogi.tv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59be1730ec1660abeb7b4dc584510d34@admin.gogi.tv>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DE51119.0125:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 04:34:33PM +0100, Daniel Haid wrote:
> >Noo.. It does, but the normal assumption of 'phys_to_virt' ==
> >'phys_to_bus' is
> >not valid anymore. Think of a buffer (swiotlb) which has a pool
> >of pages and when a PCI device wants a page, it hands one out. It
> >also has
> >other functionality such as 'mapping' of an already allocated
> >page. If the
> >PCI device asks the IOMMU (swiotlb) to map a page (and if you have
> >'swiotlb=force'
> >the page provided has been allocated above 4GB and the device can
> >only handle
> >up to 32-bit),
> 
> Does the radeon driver allocate without DMA32, possibly above 4GB, ...

On some pages, yes.
> 
> >then swiotlb gives out a page from its own pool. You now have
> >two addresses: the one from the PCI pool (swiotlb) and the one you
> >already
> >allocated.
> 
> ... or does it allocate under 4GB but nevertheless get a page from
> the swiotlb pool?

Only if the swiotlb is turned on and if the dma_mask is 32-bit.
Or if the swiotlb=force is set, then _every_ DMA operation goes
throught the swiotlb page pool.

> 
> >You are suppose to program your PCI card to read/write data to the
> >page provided from the IOMMU (so the swiotlb), which means that it
> >won't
> >write to the page you had allocated. Hence there are a calls, such as
> >'sync_page'..
> >which will copy the contents from the swiotlb page to the one you had
> >allocated
> >(or vice-versa). This is called 'bounce buffer'.
> >
> >The radeon (and nouveau) don't have the code to call the
> >'sync_page', and
> >you wouldn't really want to do so - as it slows down the
> >performance of the
> >machine. There exists another mechanism which is to allocate the
> >pages
> >at the start, and not do mapping later one.
> 
> Why can the radeon not simply allocate addresses under 4GB and not
> request
> adresses from the iommu at all?

It does on some. But not on all. It needs to go through
the PCI API to work with the graphic card and you need to map the
pages to the IOMMU.

> 
> I assume that if you request a page from the IOMMU, you are required
> to do
> these sync_page calls (and that they get optimized away with a
> hardware IOMMU?).

Sure.. but not all drivers do it.
> 
> So if the radeon uses the IOMMU but does not call sync_page even if
> required to
> the code seems to be broken. If this is indeed the case would it not
> be possible to
> simply add the sync_page calls for now (and thus fix the code), if
> it is not
> difficult, and implement the method with more performance later?

Why not fix it right the first time?
