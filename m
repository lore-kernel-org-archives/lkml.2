Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934697Ab0EUTCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 15:02:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934762Ab0EUTCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 15:02:11 -0400
Date: Fri, 21 May 2010 12:01:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anders Larsen <al@alarsen.net>
Cc: Iwo Mergler <iwo@call-direct.com.au>, linux-mtd@lists.infradead.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Ian McDonnell <ian@brightstareng.com>, Nicolas Pitre <nico@fluxnic.net>,
       linux-kernel@vger.kernel.org, Matthias Kaehlcke <matthias@kaehlcke.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] Fix Oops with Atmel SPI
Message-Id: <20100521120106.d955c78b.akpm@linux-foundation.org>
In-Reply-To: <1274267100l.1747l.1l@i-dmzi_al.realan.de>
References: <1271231840l.5270l.0l@i-dmzi_al.realan.de>
	<20100421152410.0fea5e12.akpm@linux-foundation.org>
	<1274267100l.1747l.1l@i-dmzi_al.realan.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 13:05:00 +0200
Anders Larsen <al@alarsen.net> wrote:

> On 2010-04-22 00:24:10, Andrew Morton wrote:
> > Finally..  Wouldn't it be better to just fix the atmel SPI driver so
> > that it doesn't barf when handed vmalloc'ed memory?  Who do we ridicule
> > about that?  <checks, adds cc>
> 
> You mean something like this instead?

That looks simple enough.  How do we get it tested, changelogged and
merged up?  Haavard, can you please take a look?


> diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
> index c4e0442..a9ad5e8 100644
> --- a/drivers/spi/atmel_spi.c
> +++ b/drivers/spi/atmel_spi.c
> @@ -352,16 +352,30 @@ atmel_spi_dma_map_xfer(struct atmel_spi *as, struct spi_transfer *xfer)
>  
>  	xfer->tx_dma = xfer->rx_dma = INVALID_DMA_ADDRESS;
>  	if (xfer->tx_buf) {
> -		xfer->tx_dma = dma_map_single(dev,
> -				(void *) xfer->tx_buf, xfer->len,
> -				DMA_TO_DEVICE);
> +		if (is_vmalloc_addr(xfer->tx_buf))
> +			xfer->tx_dma = dma_map_page(dev,
> +					vmalloc_to_page(xfer->tx_buf),
> +					(unsigned long)xfer->tx_buf & (PAGE_SIZE-1),
> +					xfer->len,
> +					DMA_TO_DEVICE);
> +		else
> +			xfer->tx_dma = dma_map_single(dev,
> +					(void *) xfer->tx_buf, xfer->len,
> +					DMA_TO_DEVICE);
>  		if (dma_mapping_error(dev, xfer->tx_dma))
>  			return -ENOMEM;
>  	}
>  	if (xfer->rx_buf) {
> -		xfer->rx_dma = dma_map_single(dev,
> -				xfer->rx_buf, xfer->len,
> -				DMA_FROM_DEVICE);
> +		if (is_vmalloc_addr(xfer->rx_buf))
> +			xfer->rx_dma = dma_map_page(dev,
> +					vmalloc_to_page(xfer->rx_buf),
> +					(unsigned long)xfer->rx_buf & (PAGE_SIZE-1),
> +					xfer->len,
> +					DMA_FROM_DEVICE);
> +		else
> +			xfer->rx_dma = dma_map_single(dev,
> +					xfer->rx_buf, xfer->len,
> +					DMA_FROM_DEVICE);
>  		if (dma_mapping_error(dev, xfer->rx_dma)) {
>  			if (xfer->tx_buf)
>  				dma_unmap_single(dev,
> 
