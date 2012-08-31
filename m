Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2HaMrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 08:47:25 -0400
Received: from smtp.citrix.com ([66.165.176.89]:7319 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab2HaMrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 08:47:23 -0400
X-IronPort-AV: E=Sophos;i="4.80,347,1344211200"; 
   d="scan'208";a="36424456"
Message-ID: <5040B249.4000306@citrix.com>
Date: Fri, 31 Aug 2012 13:47:05 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Stefano Panella <stefano.panella@citrix.com>
CC: <linux-kernel@vger.kernel.org>, <konrad.wilk@oracle.com>,
        <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/1] XEN: Use correct masking in	xen_swiotlb_alloc_coherent.
References: <1346407072-6405-1-git-send-email-stefano.panella@citrix.com>
In-Reply-To: <1346407072-6405-1-git-send-email-stefano.panella@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/08/12 10:57, Stefano Panella wrote:
> When running 32-bit pvops-dom0 and a driver tries to allocate a coherent
> DMA-memory the xen swiotlb-implementation returned memory beyond 4GB.
> 
> This caused for example not working sound on a system with 4 GB and a 64-bit
> compatible sound-card with sets the DMA-mask to 64bit.
> 
> On bare-metal and the forward-ported xen-dom0 patches from OpenSuse a coherent
> DMA-memory is always allocated inside the 32-bit address-range by calling
> dma_alloc_coherent_mask.

We should have the same behaviour under Xen as bare metal so:

Acked-By: David Vrabel <david.vrabel@citrix.com>

This does limit the DMA mask to 32-bits by passing it through an
unsigned long, which seems a bit sneaky...

Presumably the sound card is capable of handling 64 bit physical
addresses (or it would break under 64-bit kernels) so it's not clear why
this sound driver requires this restriction.

Is there a bug in the sound driver or sound subsystem where it's
truncating a dma_addr_t by assigning it to an unsigned long or similar?

> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -232,7 +232,7 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  		return ret;
>  
>  	if (hwdev && hwdev->coherent_dma_mask)
> -		dma_mask = hwdev->coherent_dma_mask;
> +		dma_mask = dma_alloc_coherent_mask(hwdev, flags);

Suggest

    if (hwdev)
        dma_mask = dma_alloc_coherent_mask(hwdev, flags)

>  	phys = virt_to_phys(ret);
>  	dev_addr = xen_phys_to_bus(phys);

David
