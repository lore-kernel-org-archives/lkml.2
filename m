Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab1JCQwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:52:39 -0400
Received: from mxout1.idt.com ([157.165.5.25]:40293 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab1JCQwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:52:36 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Subject: RE: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data transfers
Date: Mon, 3 Oct 2011 09:52:15 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55202291E40@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1317492077.1573.1839.camel@vkoul-udesk3>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data transfers
Thread-Index: AcyAZQZFMl4UchpkRL+fFVbGikO1vgBe2Www
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com> <1317492077.1573.1839.camel@vkoul-udesk3>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan <dan.j.williams@intel.com>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p93Gql3u017200

Vinod Koul wrote:
> 
> On Fri, 2011-09-30 at 17:38 -0400, Alexandre Bounine wrote:
> Please CC *maintainers* on your patches, get_maintainers.pl will tell
> you who. Adding Dan here

Based on https://lkml.org/lkml/2011/2/14/67 and use of DMA_SLAVE in this
patch I decided that you are the best match among two and there is no reason
to disturb Dan ;) 

> > Adds DMA Engine framework support into RapidIO subsystem.
> > Uses DMA Engine DMA_SLAVE interface to generate data transfers to/from remote
> > RapidIO target devices. Uses scatterlist to describe local data buffer and
> > dma_chan.private member to pass target specific information. Supports flat
> > data buffer only for a remote side.
> The way dmaengine works today is that it doesn't know anything about
> client subsystem. But this brings in a subsystem details to dmaengine
> which I don't agree with yet.
> Why can't we abstract this out??

The only thing that brings subsystem knowledge into dmaengine is DMA_RAPIDIO flag.
I am actually on the fence about this. From RapidIO side point of view I do not
need that flag at all.
RapidIO uses a filter routine that is sufficient to identify dmaengine channels
associated with specific RapidIO mport. Use of DMA_SLAVE flag is safe here.
Use of private member of dma_chan is "private" business of RapidIO and does
not break anything. 

My concern here is that other subsystems may use/request DMA_SLAVE channel(s) as well
and wrongfully acquire one that belongs to RapidIO. In this case separation with another
flag may have a sense - it is possible to have a system that uses RapidIO
and other "traditional" DMA slave channel.

This is why I put that proposed interface for discussion instead of keeping everything
inside of RapidIO.
If you think that situation above will not happen I will be happy to remove
that subsystem knowledge from dmaengine files.

My most recent test implementation runs without DMA_RAPIDIO flag though.

> 
> After going thru the patch, I do not believe that this this is case of
> SLAVE transfers, Dan can you please take a look at this patch

I agree, this is not a case of "pure" slave transfers but existing DMA_SLAVE
interface fits well into the RapidIO operations.

First, we have only one memory mapped location on the host side. We transfer
data to/from location that is not mapped into memory on the same side.  

Second, having ability to pass private target information allows me to pass
information about remote target device on per-transfer basis.

> 
> 
> > Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Kumar Gala <galak@kernel.crashing.org>
> > Cc: Matt Porter <mporter@kernel.crashing.org>
> > Cc: Li Yang <leoli@freescale.com>
> > ---
> >  drivers/dma/dmaengine.c   |    4 ++
... skip ...
> > +#ifdef CONFIG_RAPIDIO_DMA_ENGINE
> > +
> > +#include <linux/dmaengine.h>
> > +
... skip ...
> > + */
> > +struct dma_async_tx_descriptor *rio_dma_prep_slave_sg(struct rio_dev *rdev,
> > +	struct dma_chan *dchan, struct rio_dma_data *data,
> > +	enum dma_data_direction direction, unsigned long flags)
> > +{
> > +	struct dma_async_tx_descriptor *txd = NULL;
> > +	struct rio_dma_ext rio_ext;
> > +
> > +	rio_ext.destid = rdev->destid;
> > +	rio_ext.rio_addr_u = data->rio_addr_u;
> > +	rio_ext.rio_addr = data->rio_addr;
> > +	rio_ext.wr_type = data->wr_type;
> > +	dchan->private = &rio_ext;
> > +
> > +	txd = dchan->device->device_prep_slave_sg(dchan, data->sg, data-
> >sg_len,
> > +						  direction, flags);
> > +
> > +	return txd;
> > +}
> > +EXPORT_SYMBOL_GPL(rio_dma_prep_slave_sg);
> You should move the rdev and data to dma_slave_config, that way you
> should be able to use the existing _prep_slave_sg function.
 
RapidIO network usually has more than one device attached to it and
single DMA channel may service data transfers to/from several devices.
In this case device information should be passed on per-transfer basis.

> > +
> > +#endif /* CONFIG_RAPIDIO_DMA_ENGINE */
> > +
... skip ...
> > + *
> > + * Note: RapidIO specification defines write (NWRITE) and
> > + * write-with-response (NWRITE_R) data transfer operations.
> > + * Existing DMA controllers that service RapidIO may use one of these operations
> > + * for entire data transfer or their combination with only the last data packet
> > + * requires response.
> > + */
> > +enum rio_write_type {
> > +	RDW_DEFAULT,		/* default method used by DMA driver */
> > +	RDW_ALL_NWRITE,		/* all packets use NWRITE */
> > +	RDW_ALL_NWRITE_R,	/* all packets use NWRITE_R */
> > +	RDW_LAST_NWRITE_R,	/* last packet uses NWRITE_R, all other - NWRITE */
> > +};
> Why not use the current mechanism of specifying callback or ACK flags
> if you want a response or not.

That response is handled by RapidIO hardware and ensures reliable
packet delivery when response is used. User may not need callback or ACK
for his operation (in terms of dmaengine) but error handling will be initiated
if there is no response from the target device. 
 
> 
> > +
> > +struct rio_dma_ext {
> > +	u16 destid;
> > +	u64 rio_addr;	/* low 64-bits of 66-bit RapidIO address */
> > +	u8  rio_addr_u;  /* upper 2-bits of 66-bit RapidIO address */
> > +	enum rio_write_type wr_type; /* preferred RIO write operation type */
> > +};
> will this address translated to a dma_addr_t or not?

No. This is a RapidIO specific address on the remote device.

> > +
> > +struct rio_dma_data {
> > +	/* Local data (as scatterlist) */
> > +	struct scatterlist	*sg;	/* I/O scatter list */
> > +	unsigned int		sg_len;	/* size of scatter list */
> > +	/* Remote device address (flat buffer) */
.... skip ...
> >   * rio_name - Get the unique RIO device identifier
> >   * @rdev: RIO device
> 
> 
> --
> ~Vinod

Regards,

Alex.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
