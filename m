Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab2INQJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:09:36 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:52657 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2INQJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:09:35 -0400
X-IronPort-AV: E=Sophos;i="4.80,423,1344211200"; 
   d="scan'208";a="14551548"
Date: Fri, 14 Sep 2012 17:08:35 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH 04/10] xen/swiotlb: Move the nr_tbl determination in its
 own function.
In-Reply-To: <1347306367-28669-5-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1209141708300.29232@kaball.uk.xensource.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com> <1347306367-28669-5-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012, Konrad Rzeszutek Wilk wrote:
> Moving the function out of the way to prepare for the late
> SWIOTLB init.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>


Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

>  drivers/xen/swiotlb-xen.c |   21 +++++++++++----------
>  1 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 1afb4fb..a2aad6e 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -144,25 +144,26 @@ xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
>  	} while (i < nslabs);
>  	return 0;
>  }
> +static unsigned long xen_set_nslabs(unsigned long nr_tbl)
> +{
> +	if (!nr_tbl) {
> +		xen_io_tlb_nslabs = (64 * 1024 * 1024 >> IO_TLB_SHIFT);
> +		xen_io_tlb_nslabs = ALIGN(xen_io_tlb_nslabs, IO_TLB_SEGSIZE);
> +	} else
> +		xen_io_tlb_nslabs = nr_tbl;
>  
> +	return xen_io_tlb_nslabs << IO_TLB_SHIFT;
> +}
>  void __init xen_swiotlb_init(int verbose)
>  {
>  	unsigned long bytes;
>  	int rc = -ENOMEM;
> -	unsigned long nr_tbl;
>  	char *m = NULL;
>  	unsigned int repeat = 3;
>  
> -	nr_tbl = swiotlb_nr_tbl();
> -	if (nr_tbl)
> -		xen_io_tlb_nslabs = nr_tbl;
> -	else {
> -		xen_io_tlb_nslabs = (64 * 1024 * 1024 >> IO_TLB_SHIFT);
> -		xen_io_tlb_nslabs = ALIGN(xen_io_tlb_nslabs, IO_TLB_SEGSIZE);
> -	}
> +	xen_io_tlb_nslabs = swiotlb_nr_tbl();
>  retry:
> -	bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
> -
> +	bytes = xen_set_nslabs(xen_io_tlb_nslabs);
>  	/*
>  	 * Get IO TLB memory from any location.
>  	 */
> -- 
> 1.7.7.6
> 
