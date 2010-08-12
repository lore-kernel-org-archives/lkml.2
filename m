Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879Ab0HLUQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:16:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41104 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab0HLUQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:16:04 -0400
Date: Thu, 12 Aug 2010 22:16:01 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.ml.walleij@gmail.com>
Subject: Re: dmaengine questions
Message-ID: <20100812201601.GC27749@pengutronix.de>
References: <20100812150030.GB27749@pengutronix.de> <AANLkTikSExz3ELLEZ90LgitTsxwkE1dxu1BM1VhfCOmy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikSExz3ELLEZ90LgitTsxwkE1dxu1BM1VhfCOmy@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:58:33 up 40 days, 11:09, 24 users,  load average: 0.00, 0.18,
	0.51
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 12:14:20PM -0700, Dan Williams wrote:
> On Thu, Aug 12, 2010 at 8:00 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > Hi,
> >
> > I am currently looking into implementing the Freescale i.MX SDMA engine
> > into the dmaengine API. The SDMA engine can handle sg transfers from/to
> > devices. During implementation some questions came up.
> >
> > On the i.MX we already have a DMA engine which can do slave dma
> > transfers, the IPU (drivers/dma/ipu/), which is exclusively used for
> > image operations. My problem is that I found no way for the clients
> > to select which DMA engine to use as both have the same capabilities
> > (DMA_SLAVE).
> 
> Yes, if you need finer grained matching of channels, beyond simple
> capability matching, this is the intended purpose of the
> 'dma_filter_fn' and 'filter_param' arguments to dma_request_channel.
> Dmaengine will pass all available channels that match the base
> capability to the filter function for further, usually architecture
> specific, discrimination.

Ok, so I could do a strcmp(dev_name(chan->device->dev), "imx-sdma") in
the filter function.

> 
> > For the SDMA engine the clients have to pass some platform specific data
> > to the SDMA engine (dma request line, word width and the like). The
> > current mechanism is to pass this data through the dma_chan->private
> > field, which seems more like tunneling instead of passing the data as we
> > lose type safety. Are there any ideas to improve this?
> 
> Hopefully dma_chan->private can eventually be phased out in favor of
> Linus' dma_slave_config scheme [1].

This looks promising. Two things are missing here for the SDMA engine.
First is the DMA request line which is probably needed for other dma
engines aswell, so this could be added to dma_slave_config. The other
one is really specific to the SDMA engine, it's the following enum. The
SDMA engine is a programmable controller in the i.MX and each peripheral
has its own copy function in this controller. This enum is used to
determine their start addresses.

typedef enum {
        IMX_DMATYPE_SSI,        /* MCU domain SSI */
        IMX_DMATYPE_SSI_SP,     /* Shared SSI */
        IMX_DMATYPE_MMC,        /* MMC */
        IMX_DMATYPE_SDHC,       /* SDHC */
        IMX_DMATYPE_UART,       /* MCU domain UART */
        IMX_DMATYPE_UART_SP,    /* Shared UART */
        IMX_DMATYPE_FIRI,       /* FIRI */
        IMX_DMATYPE_CSPI,       /* MCU domain CSPI */
        IMX_DMATYPE_CSPI_SP,    /* Shared CSPI */
        IMX_DMATYPE_SIM,        /* SIM */
        IMX_DMATYPE_ATA,        /* ATA */
        IMX_DMATYPE_CCM,        /* CCM */
        IMX_DMATYPE_EXT,        /* External peripheral */
        IMX_DMATYPE_MSHC,       /* Memory Stick Host Controller */
        IMX_DMATYPE_MSHC_SP,    /* Shared Memory Stick Host Controller */
        IMX_DMATYPE_DSP,        /* DSP */
        IMX_DMATYPE_MEMORY,     /* Memory */
        IMX_DMATYPE_FIFO_MEMORY,/* FIFO type Memory */
        IMX_DMATYPE_SPDIF,      /* SPDIF */
        IMX_DMATYPE_IPU_MEMORY, /* IPU Memory */
        IMX_DMATYPE_ASRC,       /* ASRC */
        IMX_DMATYPE_ESAI,       /* ESAI */
} sdma_peripheral_type;

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
