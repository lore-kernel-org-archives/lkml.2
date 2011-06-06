Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab1FFN4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:56:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27055 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab1FFN4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:56:43 -0400
Date: Mon, 6 Jun 2011 09:56:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] swiotlb: Export io_tlb_nslabs as swiotlb_nslabs and use
 it.
Message-ID: <20110606135618.GA25007@dumpdata.com>
References: <1306946564-30481-1-git-send-email-konrad.wilk@oracle.com>
 <1306946564-30481-2-git-send-email-konrad.wilk@oracle.com>
 <20110605114548K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605114548K.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4DECDC94.0062:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 11:47:29AM +0900, FUJITA Tomonori wrote:
> On Wed,  1 Jun 2011 12:42:44 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > By default the io_tlb_nslabs is set to zero, and gets set to
> > whatever value is passed in via swiotlb_init_with_tbl function.
> > The default value passed in is 64MB. However, if the user provides
> > the 'swiotlb=<nslabs>' the default value is ignored and
> > the value provided by the user is used... Except when the SWIOTLB
> > is used under Xen - there the default value of 64MB is used and
> > the Xen-SWIOTLB has no mechanism to get the 'io_tlb_nslabs' filled
> > out by setup_io_tlb_npages functions. This patch exports the
> > value that is potentially set by setup_io_tlb_npages and renames
> > it to swiotlb_nslabs.
> > 
> > CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/xen/swiotlb-xen.c |    7 +++-
> >  include/linux/swiotlb.h   |    5 +++
> >  lib/swiotlb.c             |   78 ++++++++++++++++++++++----------------------
> >  3 files changed, 49 insertions(+), 41 deletions(-)
> 
> Hmm, exporting the internal valuable and all the renaming look
> overdoing?
> 
> Why can't we simply do like this?

We can do that too. Let me queue this up for 3.1.

> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 65ea21a..6e8c15a 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -147,9 +147,15 @@ void __init xen_swiotlb_init(int verbose)
>  {
>  	unsigned long bytes;
>  	int rc;
> -
> -	xen_io_tlb_nslabs = (64 * 1024 * 1024 >> IO_TLB_SHIFT);
> -	xen_io_tlb_nslabs = ALIGN(xen_io_tlb_nslabs, IO_TLB_SEGSIZE);
> +	unsigned long nr_tbl;
> +
> +	nr_tbl = swioltb_nr_tbl();
> +	if (nr_tbl)
> +		xen_io_tlb_nslabs = nr_tbl;
> +	else {
> +		xen_io_tlb_nslabs = (64 * 1024 * 1024 >> IO_TLB_SHIFT);
> +		xen_io_tlb_nslabs = ALIGN(xen_io_tlb_nslabs, IO_TLB_SEGSIZE);
> +	}
>  
>  	bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
>  
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index 8c0e349..445702c 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -24,6 +24,7 @@ extern int swiotlb_force;
>  
>  extern void swiotlb_init(int verbose);
>  extern void swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
> +extern unsigned long swioltb_nr_tbl(void);
>  
>  /*
>   * Enumeration for sync targets
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index 93ca08b..99093b3 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -110,6 +110,11 @@ setup_io_tlb_npages(char *str)
>  __setup("swiotlb=", setup_io_tlb_npages);
>  /* make io_tlb_overflow tunable too? */
>  
> +unsigned long swioltb_nr_tbl(void)
> +{
> +	return io_tlb_nslabs;
> +}
> +
>  /* Note that this doesn't work with highmem page */
>  static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
>  				      volatile void *address)
