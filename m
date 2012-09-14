Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab2INRUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:20:23 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17560 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351Ab2INRUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:20:21 -0400
Date: Fri, 14 Sep 2012 13:09:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 10/10] xen/swiotlb: Depending on after_bootmem is not
 correct.
Message-ID: <20120914170935.GD1481@phenom.dumpdata.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
 <1347306367-28669-11-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1209141709580.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1209141709580.29232@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 05:10:48PM +0100, Stefano Stabellini wrote:
> On Mon, 10 Sep 2012, Konrad Rzeszutek Wilk wrote:
> > When PCI IOMMUs are initialized it is after after_bootmem but
> > before a lot of "other" subsystems are initialized. As such
> > the check for after_bootmem is incorrect and we should
> > just use a parameter to define whether we are early or late.
> > 
> > This solves this bootup problem:
> > 
> > __ex_table already sorted, skipping sortM
> > Initializing CPU#0
> > Warning: only able to allocate 1 MB for software IO TLB
> > Xen-SWIOTLB: Lowering to 2MB
> > Warning: only able to allocate 1 MB for software IO TLB
> > Xen-SWIOTLB: Lowering to 2MB
> > Warning: only able to allocate 1 MB for software IO TLB
> > Xen-SWIOTLB: Lowering to 2MB
> > Warning: only able to allocate 1 MB for software IO TLB
> > Cannot allocate Xen-SWIOTLB buffer (rc:-12)
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/pci-swiotlb-xen.c |    4 ++--
> >  drivers/xen/swiotlb-xen.c      |   11 ++++++-----
> >  include/xen/swiotlb-xen.h      |    2 +-
> >  3 files changed, 9 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
> > index fc0c78f..1608244 100644
> > --- a/arch/x86/xen/pci-swiotlb-xen.c
> > +++ b/arch/x86/xen/pci-swiotlb-xen.c
> > @@ -69,7 +69,7 @@ int __init pci_xen_swiotlb_detect(void)
> >  void __init pci_xen_swiotlb_init(void)
> >  {
> >  	if (xen_swiotlb) {
> > -		xen_swiotlb_init(1);
> > +		xen_swiotlb_init(1, true /* early */);
> >  		dma_ops = &xen_swiotlb_dma_ops;
> >  
> >  		/* Make sure ACS will be enabled */
> > @@ -84,7 +84,7 @@ int pci_xen_swiotlb_init_late(void)
> >  	if (xen_swiotlb)
> >  		return 0;
> >  
> > -	rc = xen_swiotlb_init(1);
> > +	rc = xen_swiotlb_init(1, false /* late */);
> >  	if (rc)
> >  		return rc;
> >  
> > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> > index 6f81994..7443e19 100644
> > --- a/drivers/xen/swiotlb-xen.c
> > +++ b/drivers/xen/swiotlb-xen.c
> > @@ -176,7 +176,7 @@ static const char *xen_swiotlb_error(enum xen_swiotlb_err err)
> >  	}
> >  	return "";
> >  }
> > -int __ref xen_swiotlb_init(int verbose)
> > +int __ref xen_swiotlb_init(int verbose, bool early)
> >  {
> >  	unsigned long bytes, order;
> >  	int rc = -ENOMEM;
> > @@ -190,7 +190,7 @@ retry:
> >  	/*
> >  	 * Get IO TLB memory from any location.
> >  	 */
> > -	if (!after_bootmem)
> > +	if (early)
> >  		xen_io_tlb_start = alloc_bootmem_pages(PAGE_ALIGN(bytes));
> >  	else {
> >  #define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
> > @@ -220,7 +220,7 @@ retry:
> >  			       bytes,
> >  			       xen_io_tlb_nslabs);
> >  	if (rc) {
> > -		if (!after_bootmem)
> > +		if (early)
> >  			free_bootmem(__pa(xen_io_tlb_start), PAGE_ALIGN(bytes));
> >  		else {
> >  			free_pages((unsigned long)xen_io_tlb_start, order);
> > @@ -230,7 +230,8 @@ retry:
> >  		goto error;
> >  	}
> >  	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
> > -	if (!after_bootmem)
> > +	rc = 0;
>      ^
> why does this change belong to this patch?

Good eyes. I was being sneaky and rolled it in. But I can't recall why I needed
this. <sigh>

> 
> 
> > +	if (early)
> >  		swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, verbose);
> >  	else
> >  		rc = swiotlb_late_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs);
> > @@ -244,7 +245,7 @@ error:
> >  		goto retry;
> >  	}
> >  	pr_err("%s (rc:%d)", xen_swiotlb_error(m_ret), rc);
> > -	if (!after_bootmem)
> > +	if (early)
> >  		panic("%s (rc:%d)", xen_swiotlb_error(m_ret), rc);
> >  	else
> >  		free_pages((unsigned long)xen_io_tlb_start, order);
> > diff --git a/include/xen/swiotlb-xen.h b/include/xen/swiotlb-xen.h
> > index a0db2b7..de8bcc6 100644
> > --- a/include/xen/swiotlb-xen.h
> > +++ b/include/xen/swiotlb-xen.h
> > @@ -3,7 +3,7 @@
> >  
> >  #include <linux/swiotlb.h>
> >  
> > -extern int xen_swiotlb_init(int verbose);
> > +extern int xen_swiotlb_init(int verbose, bool early);
> >  
> >  extern void
> >  *xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
> > -- 
> > 1.7.7.6
> > 
