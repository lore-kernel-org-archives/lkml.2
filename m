Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab0HPMcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:32:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58862 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab0HPMci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:32:38 -0400
Date: Mon, 16 Aug 2010 14:32:37 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.ml.walleij@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] dmaengine: add possibility for cyclic transfers
Message-ID: <20100816123237.GP27749@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de> <1281956870-12463-2-git-send-email-s.hauer@pengutronix.de> <19561.10098.732048.877464@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19561.10098.732048.877464@ipc1.ka-ro>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:14:58 up 44 days,  3:25, 36 users,  load average: 0.07, 0.18,
	0.26
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 01:56:34PM +0200, Lothar Waßmann wrote:
> Hi,
> 
> Sascha Hauer writes:
> > Cyclic transfers are useful for audio where a single buffer divided
> > in periods has to be transfered endlessly until stopped. After being
> > prepared the transfer is started using the dma_async_descriptor->tx_submit
> > function. dma_async_descriptor->callback is called after each period.
> > The transfer is stopped using the DMA_TERMINATE_ALL callback.
> > While being used for cyclic transfers the channel cannot be used
> > for other transfer types.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> > ---
> >  drivers/dma/dmaengine.c   |    2 ++
> >  include/linux/dmaengine.h |    6 +++++-
> >  2 files changed, 7 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> > index 9d31d5e..e5e79ce 100644
> > --- a/drivers/dma/dmaengine.c
> > +++ b/drivers/dma/dmaengine.c
> > @@ -692,6 +692,8 @@ int dma_async_device_register(struct dma_device *device)
> >  		!device->device_prep_dma_interrupt);
> >  	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
> >  		!device->device_prep_slave_sg);
> > +	BUG_ON(dma_has_cap(DMA_CYCLIC, device->cap_mask) &&
> > +		!device->device_prep_dma_cyclic);
> >  	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
> >  		!device->device_control);
> >  
> > diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> > index c61d4ca..0df7864 100644
> > --- a/include/linux/dmaengine.h
> > +++ b/include/linux/dmaengine.h
> > @@ -67,10 +67,11 @@ enum dma_transaction_type {
> >  	DMA_PRIVATE,
> >  	DMA_ASYNC_TX,
> >  	DMA_SLAVE,
> > +	DMA_CYCLIC,
> >  };
> >  
> >  /* last transaction type for creation of the capabilities mask */
> > -#define DMA_TX_TYPE_END (DMA_SLAVE + 1)
> > +#define DMA_TX_TYPE_END (DMA_CYCLIC + 1)
> >  
> >  
> >  /**
> > @@ -478,6 +479,9 @@ struct dma_device {
> >  		struct dma_chan *chan, struct scatterlist *sgl,
> >  		unsigned int sg_len, enum dma_data_direction direction,
> >  		unsigned long flags);
> > +	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
> > +		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> > +		size_t period_len, enum dma_data_direction direction);
> >  	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> >  		unsigned long arg);
> >  
> > -- 
> > 1.7.1
> > 
> Why not implement this feature using cyclic SG lists (created with
> sg_chain())? This would give you endless DMA transfers without any
> special DMA API extensions.

Been there, done that. In the end it just seemed like adding additional
overhead to create the sg list and using the sg for something for which
it is not really designed. Still you need extensions to the DMA API to
signal that you want to have a callback for every sg entry. Normally you
only need a callback on the end of the list.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
