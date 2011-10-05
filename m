Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab1JEBiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 21:38:21 -0400
Received: from mxout1.idt.com ([157.165.5.25]:42037 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445Ab1JEBiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 21:38:20 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC PATCH 2/2 -mm] RapidIO: TSI721 Add DMA Engine support
Date: Tue, 4 Oct 2011 18:38:09 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552022D6319@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20111004144353.18087914.akpm00@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC PATCH 2/2 -mm] RapidIO: TSI721 Add DMA Engine support
Thread-Index: AcyC3sXBDSwB2okGQ/uzbj+AbqY56gAHwyNQ
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com><1317418715-9666-2-git-send-email-alexandre.bounine@idt.com><20110930151544.31875132.akpm00@gmail.com><0CE8B6BE3C4AD74AB97D9D29BD24E55202291E8D@CORPEXCH1.na.ads.idt.com> <20111004144353.18087914.akpm00@gmail.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Andrew Morton <akpm00@gmail.com>
CC: Vinod Koul <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> On Mon, 3 Oct 2011 10:53:45 -0700
> "Bounine, Alexandre" <Alexandre.Bounine@idt.com> wrote:
> 
> > > > +	memset(bd_ptr, 0, bd_num * sizeof(struct
tsi721_dma_desc));
> > > > +
> > > > +	dev_dbg(dev, "DMA descriptors @ %p (phys = %llx)\n",
> > > > +		bd_ptr, (unsigned long long)bd_phys);
> > > > +
> > > > +	/* Allocate space for descriptor status FIFO */
> > > > +	sts_size = (bd_num >= TSI721_DMA_MINSTSSZ) ?
> > > > +					bd_num :
TSI721_DMA_MINSTSSZ;
> > > > +	sts_size = roundup_pow_of_two(sts_size);
> > > > +	sts_ptr = dma_alloc_coherent(dev,
> > > > +				     sts_size * sizeof(struct
> > tsi721_dma_sts),
> > > > +				     &sts_phys, GFP_KERNEL);
> > > > +	if (!sts_ptr) {
> > > > +		/* Free space allocated for DMA descriptors */
> > > > +		dma_free_coherent(dev,
> > > > +				  bd_num * sizeof(struct
> > tsi721_dma_desc),
> > > > +				  bd_ptr, bd_phys);
> > > > +		chan->bd_base = NULL;
> > > > +		return -ENOMEM;
> > > > +	}
> > > > +
> > > > +	chan->sts_phys = sts_phys;
> > > > +	chan->sts_base = sts_ptr;
> > > > +	chan->sts_size = sts_size;
> > > > +
> > > > +	memset(sts_ptr, 0, sts_size);
> > >
> > > You meant
> >
> > I really need it here. That status block tracks progress by keeping
> > non-zero addresses of processed descriptors.
> 
> Confused.  Are you saying that the use of "sts_size" there was
> intentional?

Sorry, somehow I mistakenly linked this comment to dma_zalloc_coherent()
because of use of memset.
Yes, it should be "sts_size * sizeof(struct tsi721_dma_sts)" as
allocated.

> > >
> > > --- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-dma-
> engine-
> > > support-fix
> > > +++ a/drivers/rapidio/devices/tsi721.c
> > > @@ -1006,7 +1006,7 @@ static int tsi721_bdma_maint_init(struct
> > >  	priv->mdma.sts_base = sts_ptr;
> > >  	priv->mdma.sts_size = sts_size;
> > >
> > > -	memset(sts_ptr, 0, sts_size);
> > > +	memset(sts_ptr, 0, sts_size * sizeof(struct tsi721_dma_sts));
> > >
> > >  	dev_dbg(&priv->pdev->dev,
> > >  		"desc status FIFO @ %p (phys = %llx) size=0x%x\n",
> > >
> > > However that's at least two instances where you wanted a
> > > dma_zalloc_coherent().  How's about we give ourselves one?
> >
> > Does this mean that I am on hook for it as a "most frequent user"?
> 
> No, it can be used all over the place: drivers/net/irda/w83977af_ir.c,
> drivers/scsi/bnx2fc/bnx2fc_tgt.c,
> drivers/net/wireless/rt2x00/rt2x00pci.c,
> drivers/crypto/amcc/crypto4xx_core.c and many nmore.

In this case I will happily use dma_zalloc_coherent() as soon as
it is available

