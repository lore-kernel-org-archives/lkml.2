Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab2IQOx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:53:59 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:22094 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab2IQOx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:53:57 -0400
X-IronPort-AV: E=Sophos;i="4.80,435,1344211200"; 
   d="scan'208";a="14584195"
Date: Mon, 17 Sep 2012 15:53:10 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Is: [PATCH 11/10] xen/swiotlb: For early initialization, return
 zero on success. Was: Re: [PATCH 10/10] xen/swiotlb: Depending on after_bootmem
 is not correct.
In-Reply-To: <20120917142502.GB12541@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1209171553030.29232@kaball.uk.xensource.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com> <1347306367-28669-11-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1209141709580.29232@kaball.uk.xensource.com> <20120917142315.GA12541@phenom.dumpdata.com>
 <20120917142502.GB12541@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012, Konrad Rzeszutek Wilk wrote:
> On Mon, Sep 17, 2012 at 10:23:15AM -0400, Konrad Rzeszutek Wilk wrote:
> > > >  	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
> > > > -	if (!after_bootmem)
> > > > +	rc = 0;
> > >      ^
> > > why does this change belong to this patch?
> > > 
> > > 
> > 
> > I took that out of the this patch, so it is now:
> > 
> 
> ..and spun out another patch to address the rc=0:
> 
> >From f85175ce01ba722cd4612230e7331dc0d4c8666f Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Mon, 17 Sep 2012 10:20:09 -0400
> Subject: [PATCH 2/2] xen/swiotlb: For early initialization, return zero on
>  success.
> 
> If everything is setup properly we would return -ENOMEM since
> rc by default is set to that value. Lets not do that and return
> a proper return code.
> 
> Note: The reason the early code needs this special treatment
> is that it SWIOTLB library call does not return anything (and
> had it failed it would call panic()) - but our function does.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>


Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

>  drivers/xen/swiotlb-xen.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 02a52f3..ab4c66c 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -230,9 +230,10 @@ retry:
>  		goto error;
>  	}
>  	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
> -	if (early)
> +	if (early) {
>  		swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, verbose);
> -	else
> +		rc = 0;
> +	} else
>  		rc = swiotlb_late_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs);
>  	return rc;
>  error:
> -- 
> 1.7.7.6
> 
