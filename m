Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab2HaQkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:40:24 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26490 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab2HaQkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:40:22 -0400
Date: Fri, 31 Aug 2012 12:40:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Stefano Panella <stefano.panella@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH 1/1] XEN: Use correct masking in
 xen_swiotlb_alloc_coherent.
Message-ID: <20120831164010.GA18929@localhost.localdomain>
References: <1346407072-6405-1-git-send-email-stefano.panella@citrix.com>
 <5040B249.4000306@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5040B249.4000306@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 01:47:05PM +0100, David Vrabel wrote:
> On 31/08/12 10:57, Stefano Panella wrote:
> > When running 32-bit pvops-dom0 and a driver tries to allocate a coherent
> > DMA-memory the xen swiotlb-implementation returned memory beyond 4GB.
> > 
> > This caused for example not working sound on a system with 4 GB and a 64-bit
> > compatible sound-card with sets the DMA-mask to 64bit.
> > 
> > On bare-metal and the forward-ported xen-dom0 patches from OpenSuse a coherent
> > DMA-memory is always allocated inside the 32-bit address-range by calling
> > dma_alloc_coherent_mask.
> 
> We should have the same behaviour under Xen as bare metal so:
> 
> Acked-By: David Vrabel <david.vrabel@citrix.com>
> 
> This does limit the DMA mask to 32-bits by passing it through an
> unsigned long, which seems a bit sneaky...

so is the issue that we are not casting it from 'u64' to 'u32'
(unsigned long) on 32-bit?

> 
> Presumably the sound card is capable of handling 64 bit physical
> addresses (or it would break under 64-bit kernels) so it's not clear why
> this sound driver requires this restriction.
> 
> Is there a bug in the sound driver or sound subsystem where it's
> truncating a dma_addr_t by assigning it to an unsigned long or similar?
> 
> > --- a/drivers/xen/swiotlb-xen.c
> > +++ b/drivers/xen/swiotlb-xen.c
> > @@ -232,7 +232,7 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
> >  		return ret;
> >  
> >  	if (hwdev && hwdev->coherent_dma_mask)
> > -		dma_mask = hwdev->coherent_dma_mask;
> > +		dma_mask = dma_alloc_coherent_mask(hwdev, flags);
> 
> Suggest
> 
>     if (hwdev)
>         dma_mask = dma_alloc_coherent_mask(hwdev, flags)

Isn't that code just doing this:
atic inline unsigned long dma_alloc_coherent_mask(struct device *dev,
                                                    gfp_t gfp)
{
        unsigned long dma_mask = 0;

        dma_mask = dev->coherent_dma_mask;
        if (!dma_mask)
                dma_mask = (gfp & GFP_DMA) ? DMA_BIT_MASK(24) :
DMA_BIT_MASK(32);

        return dma_mask;
}

and in our code, the dma_mask by default is DMA_BIT_MASK(32):

u64 dma_mask = DMA_BIT_MASK(32);

So what I am missing?
