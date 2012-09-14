Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab2INQBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:01:24 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:38208 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab2INQBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:01:23 -0400
X-IronPort-AV: E=Sophos;i="4.80,423,1344211200"; 
   d="scan'208";a="14551368"
Date: Fri, 14 Sep 2012 17:00:39 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH 05/10] xen/swiotlb: Move the error strings to its own
 function.
In-Reply-To: <1347306367-28669-6-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1209141700320.29232@kaball.uk.xensource.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com> <1347306367-28669-6-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012, Konrad Rzeszutek Wilk wrote:
> That way we can more easily reuse those errors when using the
> late SWIOTLB init.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>


Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  drivers/xen/swiotlb-xen.c |   35 +++++++++++++++++++++++++++--------
>  1 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index a2aad6e..701b103 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -154,11 +154,33 @@ static unsigned long xen_set_nslabs(unsigned long nr_tbl)
>  
>  	return xen_io_tlb_nslabs << IO_TLB_SHIFT;
>  }
> +
> +enum xen_swiotlb_err {
> +	XEN_SWIOTLB_UNKNOWN = 0,
> +	XEN_SWIOTLB_ENOMEM,
> +	XEN_SWIOTLB_EFIXUP
> +};
> +
> +static const char *xen_swiotlb_error(enum xen_swiotlb_err err)
> +{
> +	switch (err) {
> +	case XEN_SWIOTLB_ENOMEM:
> +		return "Cannot allocate Xen-SWIOTLB buffer\n";
> +	case XEN_SWIOTLB_EFIXUP:
> +		return "Failed to get contiguous memory for DMA from Xen!\n"\
> +		    "You either: don't have the permissions, do not have"\
> +		    " enough free memory under 4GB, or the hypervisor memory"\
> +		    " is too fragmented!";
> +	default:
> +		break;
> +	}
> +	return "";
> +}
>  void __init xen_swiotlb_init(int verbose)
>  {
>  	unsigned long bytes;
>  	int rc = -ENOMEM;
> -	char *m = NULL;
> +	enum xen_swiotlb_err m_ret = XEN_SWIOTLB_UNKNOWN;
>  	unsigned int repeat = 3;
>  
>  	xen_io_tlb_nslabs = swiotlb_nr_tbl();
> @@ -169,7 +191,7 @@ retry:
>  	 */
>  	xen_io_tlb_start = alloc_bootmem_pages(PAGE_ALIGN(bytes));
>  	if (!xen_io_tlb_start) {
> -		m = "Cannot allocate Xen-SWIOTLB buffer!\n";
> +		m_ret = XEN_SWIOTLB_ENOMEM;
>  		goto error;
>  	}
>  	xen_io_tlb_end = xen_io_tlb_start + bytes;
> @@ -181,10 +203,7 @@ retry:
>  			       xen_io_tlb_nslabs);
>  	if (rc) {
>  		free_bootmem(__pa(xen_io_tlb_start), PAGE_ALIGN(bytes));
> -		m = "Failed to get contiguous memory for DMA from Xen!\n"\
> -		    "You either: don't have the permissions, do not have"\
> -		    " enough free memory under 4GB, or the hypervisor memory"\
> -		    "is too fragmented!";
> +		m_ret = XEN_SWIOTLB_EFIXUP;
>  		goto error;
>  	}
>  	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
> @@ -199,8 +218,8 @@ error:
>  		      (xen_io_tlb_nslabs << IO_TLB_SHIFT) >> 20);
>  		goto retry;
>  	}
> -	xen_raw_printk("%s (rc:%d)", m, rc);
> -	panic("%s (rc:%d)", m, rc);
> +	xen_raw_printk("%s (rc:%d)", xen_swiotlb_error(m_ret), rc);
> +	panic("%s (rc:%d)", xen_swiotlb_error(m_ret), rc);
>  }
>  
>  void *
> -- 
> 1.7.7.6
> 
