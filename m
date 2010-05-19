Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab0ESLFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:05:21 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:56889 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab0ESLFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:05:16 -0400
Date: Wed, 19 May 2010 13:05:00 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH] Fix Oops with Atmel SPI
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Iwo Mergler <iwo@call-direct.com.au>, linux-mtd@lists.infradead.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Ian McDonnell <ian@brightstareng.com>, Nicolas Pitre <nico@fluxnic.net>,
       linux-kernel@vger.kernel.org, Matthias Kaehlcke <matthias@kaehlcke.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <1271231840l.5270l.0l@i-dmzi_al.realan.de>
	<20100421152410.0fea5e12.akpm@linux-foundation.org>
In-Reply-To: <20100421152410.0fea5e12.akpm@linux-foundation.org> (from
	akpm@linux-foundation.org on Thu Apr 22 00:24:10 2010)
X-Mailer: Balsa 2.3.14
Message-Id: <1274267100l.1747l.1l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-04-22 00:24:10, Andrew Morton wrote:
> Finally..  Wouldn't it be better to just fix the atmel SPI driver so
> that it doesn't barf when handed vmalloc'ed memory?  Who do we ridicule
> about that?  <checks, adds cc>

You mean something like this instead?

diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index c4e0442..a9ad5e8 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -352,16 +352,30 @@ atmel_spi_dma_map_xfer(struct atmel_spi *as, struct spi_transfer *xfer)
 
 	xfer->tx_dma = xfer->rx_dma = INVALID_DMA_ADDRESS;
 	if (xfer->tx_buf) {
-		xfer->tx_dma = dma_map_single(dev,
-				(void *) xfer->tx_buf, xfer->len,
-				DMA_TO_DEVICE);
+		if (is_vmalloc_addr(xfer->tx_buf))
+			xfer->tx_dma = dma_map_page(dev,
+					vmalloc_to_page(xfer->tx_buf),
+					(unsigned long)xfer->tx_buf & (PAGE_SIZE-1),
+					xfer->len,
+					DMA_TO_DEVICE);
+		else
+			xfer->tx_dma = dma_map_single(dev,
+					(void *) xfer->tx_buf, xfer->len,
+					DMA_TO_DEVICE);
 		if (dma_mapping_error(dev, xfer->tx_dma))
 			return -ENOMEM;
 	}
 	if (xfer->rx_buf) {
-		xfer->rx_dma = dma_map_single(dev,
-				xfer->rx_buf, xfer->len,
-				DMA_FROM_DEVICE);
+		if (is_vmalloc_addr(xfer->rx_buf))
+			xfer->rx_dma = dma_map_page(dev,
+					vmalloc_to_page(xfer->rx_buf),
+					(unsigned long)xfer->rx_buf & (PAGE_SIZE-1),
+					xfer->len,
+					DMA_FROM_DEVICE);
+		else
+			xfer->rx_dma = dma_map_single(dev,
+					xfer->rx_buf, xfer->len,
+					DMA_FROM_DEVICE);
 		if (dma_mapping_error(dev, xfer->rx_dma)) {
 			if (xfer->tx_buf)
 				dma_unmap_single(dev,

