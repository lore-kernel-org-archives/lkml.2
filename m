Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab0HXH67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:58:59 -0400
Received: from mail.karo-electronics.de ([213.146.116.110]:47925 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab0HXH66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:58:58 -0400
Message-ID: <19571.31677.407213.580581@ipc1.ka-ro>
Date: Tue, 24 Aug 2010 09:58:53 +0200
From: =?iso-8859-15?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.ml.walleij@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 3/3 v2] dmaengine: Add Freescale i.MX SDMA support
In-Reply-To: <20100823125704.GU27749@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de>
	<1281956870-12463-4-git-send-email-s.hauer@pengutronix.de>
	<20100823125704.GU27749@pengutronix.de>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> This patch adds support for the Freescale i.MX SDMA engine.
> 
> The SDMA engine is a scatter/gather DMA engine which is implemented
> as a seperate coprocessor. SDMA needs its own firmware which is
> requested using the standard request_firmware mechanism. The firmware
> has different entry points for each peripheral type, so drivers
> have to pass the peripheral type to the DMA engine which in turn
> picks the correct firmware entry point from a table contained in
> the firmware image itself.
> The original Freescale code also supports support for transfering
> data to the internal SRAM which needs different entry points to
> the firmware. Support for this is currently not implemented. Also,
> support for the ASRC (asymmetric sample rate converter) is skipped.
> 
> I took a very simple approach to implement dmaengine support. Only
> a single descriptor is statically assigned to a each channel. This
> means that transfers can't be queued up but only a single transfer
> is in progress. This simplifies implementation a lot and is sufficient
> for the usual device/memory transfers.
> 
> Changes since v1:
> 
[...]
> +static int __devinit sdma_probe(struct platform_device *pdev)
>
__devinit/__devexit is for hot-pluggable devices. I don't think the
SDMA controller is hot-pluggable, so __init/__exit could be used here.

> +{
> +	int ret;
> +	const struct firmware *fw;
> +	const struct sdma_firmware_header *header;
> +	const struct sdma_script_start_addrs *addr;
> +	int irq;
> +	unsigned short *ram_code;
> +	struct resource *iores;
> +	struct sdma_platform_data *pdata = pdev->dev.platform_data;
> +	char *fwname;
> +	int i;
> +	dma_cap_mask_t mask;
> +	struct sdma_engine *sdma;
> +
> +	sdma = kzalloc(sizeof(*sdma), GFP_KERNEL);
> +	if (!sdma)
> +		return -ENOMEM;
> +
> +	sdma->dev = &pdev->dev;
> +
> +	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	irq = platform_get_irq(pdev, 0);
> +	if (!iores || irq < 0 || !pdata) {
> +		ret = -EINVAL;
> +		goto err_irq;
> +	}
> +
> +	sdma->clk = clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(sdma->clk)) {
> +		ret = PTR_ERR(sdma->clk);
> +		goto err_clk;
> +	}
> +
request_mem_region()?
> +	sdma->regs = ioremap(iores->start, resource_size(iores));
> +	if (!sdma->regs) {
> +		ret = -ENOMEM;
> +		goto err_ioremap;
> +	}
> +
> +

> +static int __devexit sdma_remove(struct platform_device *pdev)
>
see above.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
