Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab0EXPl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 11:41:27 -0400
Received: from outgoing.brightstareng.com ([206.173.66.57]:1931 "EHLO
	zebra.brightstareng.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753696Ab0EXPlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 11:41:25 -0400
X-Greylist: delayed 1924 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 May 2010 11:41:25 EDT
From: Ian McDonnell <ian@brightstareng.com>
To: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH] Fix Oops with Atmel SPI
Date: Mon, 24 May 2010 11:09:20 -0400
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Iwo Mergler <iwo@call-direct.com.au>, linux-mtd@lists.infradead.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
       Matthias Kaehlcke <matthias@kaehlcke.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <1271231840l.5270l.0l@i-dmzi_al.realan.de> <1274267100l.1747l.1l@i-dmzi_al.realan.de> <20100521120106.d955c78b.akpm@linux-foundation.org>
In-Reply-To: <20100521120106.d955c78b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005241109.20290.ian@brightstareng.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders,

I just tested one path, the "if (xfer->rx_buf)...", on
2.6.33 plus the at91 patch
http://maxim.org.za/AT91RM9200/2.6/2.6.33-at91.patch.gz
running on AT91SAM9260.

The test case involved doing i/o via the /dev/mtdblock
interface -- but this only exercises the rx_buf/vmalloc path --
MTD reads a block into the cache-buf to merge the write data. Not 
sure that we have any use cases for the tx_buf path using MTD.

-Ian

On Friday 21 May 2010, Andrew Morton wrote:
> On Wed, 19 May 2010 13:05:00 +0200
>
> Anders Larsen <al@alarsen.net> wrote:
> > On 2010-04-22 00:24:10, Andrew Morton wrote:
> > > Finally..  Wouldn't it be better to just fix the atmel SPI
> > > driver so that it doesn't barf when handed vmalloc'ed
> > > memory?  Who do we ridicule about that?  <checks, adds cc>
> >
> > You mean something like this instead?
>
> That looks simple enough.  How do we get it tested,
> changelogged and merged up?  Haavard, can you please take a
> look?
>
> > diff --git a/drivers/spi/atmel_spi.c
> > b/drivers/spi/atmel_spi.c index c4e0442..a9ad5e8 100644
> > --- a/drivers/spi/atmel_spi.c
> > +++ b/drivers/spi/atmel_spi.c
> > @@ -352,16 +352,30 @@ atmel_spi_dma_map_xfer(struct
> > atmel_spi *as, struct spi_transfer *xfer)
> >
> >  	xfer->tx_dma = xfer->rx_dma = INVALID_DMA_ADDRESS;
> >  	if (xfer->tx_buf) {
> > -		xfer->tx_dma = dma_map_single(dev,
> > -				(void *) xfer->tx_buf, xfer->len,
> > -				DMA_TO_DEVICE);
> > +		if (is_vmalloc_addr(xfer->tx_buf))
> > +			xfer->tx_dma = dma_map_page(dev,
> > +					vmalloc_to_page(xfer->tx_buf),
> > +					(unsigned long)xfer->tx_buf & (PAGE_SIZE-1),
> > +					xfer->len,
> > +					DMA_TO_DEVICE);
> > +		else
> > +			xfer->tx_dma = dma_map_single(dev,
> > +					(void *) xfer->tx_buf, xfer->len,
> > +					DMA_TO_DEVICE);
> >  		if (dma_mapping_error(dev, xfer->tx_dma))
> >  			return -ENOMEM;
> >  	}
> >  	if (xfer->rx_buf) {
> > -		xfer->rx_dma = dma_map_single(dev,
> > -				xfer->rx_buf, xfer->len,
> > -				DMA_FROM_DEVICE);
> > +		if (is_vmalloc_addr(xfer->rx_buf))
> > +			xfer->rx_dma = dma_map_page(dev,
> > +					vmalloc_to_page(xfer->rx_buf),
> > +					(unsigned long)xfer->rx_buf & (PAGE_SIZE-1),
> > +					xfer->len,
> > +					DMA_FROM_DEVICE);
> > +		else
> > +			xfer->rx_dma = dma_map_single(dev,
> > +					xfer->rx_buf, xfer->len,
> > +					DMA_FROM_DEVICE);
> >  		if (dma_mapping_error(dev, xfer->rx_dma)) {
> >  			if (xfer->tx_buf)
> >  				dma_unmap_single(dev,


