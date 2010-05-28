Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab0E1JjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 05:39:21 -0400
Received: from relay.atmel.no ([80.232.32.139]:54546 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793Ab0E1JjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 05:39:20 -0400
X-Greylist: delayed 688 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 May 2010 05:39:19 EDT
Date: Fri, 28 May 2010 11:27:44 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anders Larsen <al@alarsen.net>, Iwo Mergler <iwo@call-direct.com.au>,
       linux-mtd@lists.infradead.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Ian McDonnell <ian@brightstareng.com>, Nicolas Pitre <nico@fluxnic.net>,
       linux-kernel@vger.kernel.org, Matthias Kaehlcke <matthias@kaehlcke.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] Fix Oops with Atmel SPI
Message-ID: <20100528112744.579dc556@hskinnemoen-d830>
In-Reply-To: <20100521120106.d955c78b.akpm@linux-foundation.org>
References: <1271231840l.5270l.0l@i-dmzi_al.realan.de>
	<20100421152410.0fea5e12.akpm@linux-foundation.org>
	<1274267100l.1747l.1l@i-dmzi_al.realan.de>
	<20100521120106.d955c78b.akpm@linux-foundation.org>
Organization: Atmel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 19 May 2010 13:05:00 +0200
> Anders Larsen <al@alarsen.net> wrote:
> 
> > On 2010-04-22 00:24:10, Andrew Morton wrote:
> > > Finally..  Wouldn't it be better to just fix the atmel SPI driver so
> > > that it doesn't barf when handed vmalloc'ed memory?  Who do we ridicule
> > > about that?  <checks, adds cc>
> > 
> > You mean something like this instead?
> 
> That looks simple enough.  How do we get it tested, changelogged and
> merged up?  Haavard, can you please take a look?

Sure. Sorry for the late response; I've been traveling for the last two
weeks.

Did anyone check what other drivers do to handle this case? Surely this
isn't the only driver which supports DMA?

> > diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
> > index c4e0442..a9ad5e8 100644
> > --- a/drivers/spi/atmel_spi.c
> > +++ b/drivers/spi/atmel_spi.c
> > @@ -352,16 +352,30 @@ atmel_spi_dma_map_xfer(struct atmel_spi *as, struct spi_transfer *xfer)
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

Ok, this should be fine for small transfers, but what happens if the
transfer crosses a page boundary? Are there any guarantees that this
will never happen? What callers are passing vmalloc'ed memory in the
first place?

Ditto for the rx path.

Haavard
