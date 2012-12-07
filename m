Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030682Ab2LGOLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 09:11:12 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43768 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030667Ab2LGOLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 09:11:11 -0500
Date: Fri, 7 Dec 2012 09:11:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Dongxiao Xu <dongxiao.xu@intel.com>, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen/swiotlb: Exchange to contiguous memory
 for map_sg hook
Message-ID: <20121207141100.GD3140@phenom.dumpdata.com>
References: <1354799322-6000-1-git-send-email-dongxiao.xu@intel.com>
 <50C0ADB502000078000AE9DA@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C0ADB502000078000AE9DA@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 01:37:41PM +0000, Jan Beulich wrote:
> >>> On 06.12.12 at 14:08, Dongxiao Xu <dongxiao.xu@intel.com> wrote:
> > While mapping sg buffers, checking to cross page DMA buffer is
> > also needed. If the guest DMA buffer crosses page boundary, Xen
> > should exchange contiguous memory for it.
> > 
> > Besides, it is needed to backup the original page contents
> > and copy it back after memory exchange is done.
> > 
> > This fixes issues if device DMA into software static buffers,
> > and in case the static buffer cross page boundary which pages are
> > not contiguous in real hardware.
> > 
> > Signed-off-by: Dongxiao Xu <dongxiao.xu@intel.com>
> > Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
> > ---
> >  drivers/xen/swiotlb-xen.c |   47 
> > ++++++++++++++++++++++++++++++++++++++++++++-
> >  1 files changed, 46 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> > index 58db6df..e8f0cfb 100644
> > --- a/drivers/xen/swiotlb-xen.c
> > +++ b/drivers/xen/swiotlb-xen.c
> > @@ -461,6 +461,22 @@ xen_swiotlb_sync_single_for_device(struct device *hwdev, 
> > dma_addr_t dev_addr,
> >  }
> >  EXPORT_SYMBOL_GPL(xen_swiotlb_sync_single_for_device);
> >  
> > +static bool
> > +check_continguous_region(unsigned long vstart, unsigned long order)
> 
> check_continguous_region(unsigned long vstart, unsigned int order)
> 
> But - why do you need to do this check order based in the first
> place? Checking the actual length of the buffer should suffice.
> 
> > +{
> > +	unsigned long prev_ma = xen_virt_to_bus((void *)vstart);
> > +	unsigned long next_ma;
> 
> phys_addr_t or some such for both of them.
> 
> > +	int i;
> 
> unsigned long
> 
> > +
> > +	for (i = 1; i < (1 << order); i++) {
> 
> 1UL
> 
> > +		next_ma = xen_virt_to_bus((void *)(vstart + i * PAGE_SIZE));
> > +		if (next_ma != prev_ma + PAGE_SIZE)
> > +			return false;
> > +		prev_ma = next_ma;
> > +	}
> > +	return true;
> > +}
> > +
> >  /*
> >   * Map a set of buffers described by scatterlist in streaming mode for DMA.
> >   * This is the scatter-gather version of the above xen_swiotlb_map_page
> > @@ -489,7 +505,36 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct 
> > scatterlist *sgl,
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
> 
> How about swiotlb_map_page() (for the compound page case)?

Heh. Thanks - I just got to your reply now and had the same question.

Interestingly enough - this looks like a problem that has been forever
and nobody ever hit this.

Worst, the problem is even present if a driver uses the pci_alloc_coherent
and asks for a 3MB region or such - as we can at most give out only
2MB swaths.

> 
> Jan
> 
