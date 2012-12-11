Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab2LKG1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 01:27:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:61129 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab2LKG1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 01:27:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,256,1355126400"; 
   d="scan'208";a="255602228"
From: "Xu, Dongxiao" <dongxiao.xu@intel.com>
To: Jan Beulich <JBeulich@suse.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Xen-devel] [PATCH] xen/swiotlb: Exchange to contiguous memory
 for map_sg hook
Thread-Topic: [Xen-devel] [PATCH] xen/swiotlb: Exchange to contiguous memory
 for map_sg hook
Thread-Index: Ac3XaIzprqGxeKpdR6GzVMagEkgdpA==
Date: Tue, 11 Dec 2012 06:27:38 +0000
Message-ID: <40776A41FC278F40B59438AD47D147A90FEBE725@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBB6S5KW010691

> -----Original Message-----
> From: Jan Beulich [mailto:JBeulich@suse.com]
> Sent: Thursday, December 06, 2012 9:38 PM
> To: Xu, Dongxiao
> Cc: xen-devel@lists.xen.org; konrad.wilk@oracle.com;
> linux-kernel@vger.kernel.org
> Subject: Re: [Xen-devel] [PATCH] xen/swiotlb: Exchange to contiguous memory
> for map_sg hook
> 
> >>> On 06.12.12 at 14:08, Dongxiao Xu <dongxiao.xu@intel.com> wrote:
> > While mapping sg buffers, checking to cross page DMA buffer is also
> > needed. If the guest DMA buffer crosses page boundary, Xen should
> > exchange contiguous memory for it.
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
> > ++++++++++++++++++++++++++++++++++++++++++++-
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
> > +check_continguous_region(unsigned long vstart, unsigned long order)
> 
> check_continguous_region(unsigned long vstart, unsigned int order)
> 
> But - why do you need to do this check order based in the first place? Checking
> the actual length of the buffer should suffice.

Thanks, the word "continguous" is mistyped in the function, it should be "contiguous".
¡¡¡¡
check_contiguous_region() function is used to check whether pages are contiguous in hardware.
The length only indicates whether the buffer crosses page boundary. If buffer crosses pages and they are not contiguous in hardware, we do need to exchange memory in Xen.

> 
> > +{
> > +	unsigned long prev_ma = xen_virt_to_bus((void *)vstart);
> > +	unsigned long next_ma;
> 
> phys_addr_t or some such for both of them.

Thanks.
Should be dma_addr_t?

> 
> > +	int i;
> 
> unsigned long

Thanks.

> 
> > +
> > +	for (i = 1; i < (1 << order); i++) {
> 
> 1UL

Thanks.

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
> 
> How about swiotlb_map_page() (for the compound page case)?

Yes! This should also need similar handling.

One thing needs further consideration is that, the above approach introduces two memory copies, which has race condition that, when we are exchanging/copying pages, dom0 may visit other elements right in the pages.

One choice is to move the memory copy in hypervisor, which requires us to modify the XENMEM_exchange hypercall and add certain flags indicating whether the exchange needs memory copying.

Or another choice to solve this issue in driver side to avoid DMA into such static buffers? This is easy to modify one driver but may have difficulties to monitor so many device drivers.

Thanks,
Dongxiao

> 
> Jan

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
