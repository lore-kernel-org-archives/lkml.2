Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab2LKGjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 01:39:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:32334 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab2LKGjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 01:39:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,256,1355126400"; 
   d="scan'208";a="255605880"
From: "Xu, Dongxiao" <dongxiao.xu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] xen/swiotlb: Exchange to contiguous memory for map_sg
 hook
Thread-Topic: [PATCH] xen/swiotlb: Exchange to contiguous memory for map_sg
 hook
Thread-Index: AQHN1IR0DIODKC0DeEab0mvv5Cx6jJgTKUew
Date: Tue, 11 Dec 2012 06:39:35 +0000
Message-ID: <40776A41FC278F40B59438AD47D147A90FEBE741@SHSMSX102.ccr.corp.intel.com>
References: <1354799322-6000-1-git-send-email-dongxiao.xu@intel.com>
 <20121207140852.GC3140@phenom.dumpdata.com>
In-Reply-To: <20121207140852.GC3140@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> Sent: Friday, December 07, 2012 10:09 PM
> To: Xu, Dongxiao
> Cc: xen-devel@lists.xen.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] xen/swiotlb: Exchange to contiguous memory for map_sg
> hook
> 
> On Thu, Dec 06, 2012 at 09:08:42PM +0800, Dongxiao Xu wrote:
> > While mapping sg buffers, checking to cross page DMA buffer is also
> > needed. If the guest DMA buffer crosses page boundary, Xen should
> > exchange contiguous memory for it.
> 
> So this is when we cross those 2MB contingous swatch of buffers.
> Wouldn't we get the same problem with the 'map_page' call? If the driver tried
> to map say a 4MB DMA region?

Yes, it also needs such check, as I just replied to Jan's mail.

> 
> What if this check was done in the routines that provide the software static
> buffers and there try to provide a nice DMA contingous swatch of pages?

Yes, this approach also came to our mind, which needs to modify the driver itself.
If so, it requires driver not using such static buffers (e.g., from kmalloc) to do DMA even if the buffer is continuous in native.
Is this acceptable by kernel/driver upstream?

Thanks,
Dongxiao

> 
> >
> > Besides, it is needed to backup the original page contents and copy it
> > back after memory exchange is done.
> >
> > This fixes issues if device DMA into software static buffers, and in
> > case the static buffer cross page boundary which pages are not
> > contiguous in real hardware.
> >
> > Signed-off-by: Dongxiao Xu <dongxiao.xu@intel.com>
> > Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
> > ---
> >  drivers/xen/swiotlb-xen.c |   47
> ++++++++++++++++++++++++++++++++++++++++++++-
> >  1 files changed, 46 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> > index 58db6df..e8f0cfb 100644
> > --- a/drivers/xen/swiotlb-xen.c
> > +++ b/drivers/xen/swiotlb-xen.c
> > @@ -461,6 +461,22 @@ xen_swiotlb_sync_single_for_device(struct device
> > *hwdev, dma_addr_t dev_addr,  }
> > EXPORT_SYMBOL_GPL(xen_swiotlb_sync_single_for_device);
> >
> > +static bool
> > +check_continguous_region(unsigned long vstart, unsigned long order) {
> > +	unsigned long prev_ma = xen_virt_to_bus((void *)vstart);
> > +	unsigned long next_ma;
> > +	int i;
> > +
> > +	for (i = 1; i < (1 << order); i++) {
> > +		next_ma = xen_virt_to_bus((void *)(vstart + i * PAGE_SIZE));
> > +		if (next_ma != prev_ma + PAGE_SIZE)
> > +			return false;
> > +		prev_ma = next_ma;
> > +	}
> > +	return true;
> > +}
> > +
> >  /*
> >   * Map a set of buffers described by scatterlist in streaming mode for
> DMA.
> >   * This is the scatter-gather version of the above
> > xen_swiotlb_map_page @@ -489,7 +505,36 @@
> > xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist
> > *sgl,
> >
> >  	for_each_sg(sgl, sg, nelems, i) {
> >  		phys_addr_t paddr = sg_phys(sg);
> > -		dma_addr_t dev_addr = xen_phys_to_bus(paddr);
> > +		unsigned long vstart, order;
> > +		dma_addr_t dev_addr;
> > +
> > +		/*
> > +		 * While mapping sg buffers, checking to cross page DMA buffer
> > +		 * is also needed. If the guest DMA buffer crosses page
> > +		 * boundary, Xen should exchange contiguous memory for it.
> > +		 * Besides, it is needed to backup the original page contents
> > +		 * and copy it back after memory exchange is done.
> > +		 */
> > +		if (range_straddles_page_boundary(paddr, sg->length)) {
> > +			vstart = (unsigned long)__va(paddr & PAGE_MASK);
> > +			order = get_order(sg->length + (paddr & ~PAGE_MASK));
> > +			if (!check_continguous_region(vstart, order)) {
> > +				unsigned long buf;
> > +				buf = __get_free_pages(GFP_KERNEL, order);
> > +				memcpy((void *)buf, (void *)vstart,
> > +					PAGE_SIZE * (1 << order));
> > +				if (xen_create_contiguous_region(vstart, order,
> > +						fls64(paddr))) {
> > +					free_pages(buf, order);
> > +					return 0;
> > +				}
> > +				memcpy((void *)vstart, (void *)buf,
> > +					PAGE_SIZE * (1 << order));
> > +				free_pages(buf, order);
> > +			}
> > +		}
> > +
> > +		dev_addr = xen_phys_to_bus(paddr);
> >
> >  		if (swiotlb_force ||
> >  		    !dma_capable(hwdev, dev_addr, sg->length) ||
> > --
> > 1.7.1
> >
