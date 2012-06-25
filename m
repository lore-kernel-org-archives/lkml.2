Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab2FYHGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 03:06:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63681 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2FYHGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 03:06:22 -0400
Date: Mon, 25 Jun 2012 00:06:14 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: axel.lin@gmail.com, riyer@nvidia.com, michael.hennerich@analog.com,
        grant.likely@secretlab.ca, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        aletes.xgr@gmail.com
Subject: Re: [PATCH v6] input: keyboard: Add keys driver for the LPC32xx SoC
Message-ID: <20120625070614.GA13876@core.coreip.homeip.net>
References: <1340549078-8973-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340549078-8973-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Roland,

On Sun, Jun 24, 2012 at 04:44:38PM +0200, Roland Stigge wrote:
> This patch adds a driver for the key scan interface of the LPC32xx SoC
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 

This looks _very_ good, I just have a couple more comments:

> +
> +static int lpc32xx_kscan_open(struct input_dev *dev)
> +{
> +	struct lpc32xx_kscan_drv *kscandat = input_get_drvdata(dev);
> +
> +	return clk_prepare_enable(kscandat->clk);

Don't you need to clear IRQ here, the same way you do it in resume?

> +}
> +
> +static void lpc32xx_kscan_close(struct input_dev *dev)
> +{
> +	struct lpc32xx_kscan_drv *kscandat = input_get_drvdata(dev);
> +
> +	clk_disable_unprepare(kscandat->clk);

And same here.

> +}
> +
> +int lpc32xx_parse_dt(struct platform_device *pdev)

Static? Also why don't you pass kscandat instead of platform device?
> +{
> +	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
> +	struct device_node *np = pdev->dev.of_node;
> +	u32 rows, columns;
> +
> +	of_property_read_u32(np, "keypad,num-rows", &rows);
> +	of_property_read_u32(np, "keypad,num-columns", &columns);
> +	if (!rows || rows != columns) {
> +		dev_err(&pdev->dev,
> +			"rows and columns must be specified and be equal!\n");
> +		return -EINVAL;
> +	}
> +
> +	kscandat->matrix_sz = rows;
> +	kscandat->row_shift = get_count_order(columns);
> +
> +	of_property_read_u32(np, "nxp,debounce-delay-ms", &kscandat->deb_clks);
> +	of_property_read_u32(np, "nxp,scan-delay-ms", &kscandat->scan_delay);
> +	if (!kscandat->deb_clks || !kscandat->scan_delay) {
> +		dev_err(&pdev->dev, "debounce or scan delay not specified\n");
> +		return -ENXIO;
> +	}
> +
> +	kscandat->keymap = kzalloc(sizeof(kscandat->keymap[0]) *
> +				(rows << kscandat->row_shift), GFP_KERNEL);
> +	if (!kscandat->keymap) {
> +		dev_err(&pdev->dev, "could not allocate memory for keymap\n");
> +		return -ENOMEM;
> +	}

I think this allocation belongs to the probe().

> +
> +	return 0;
> +}
> +
> +static int __devinit lpc32xx_kscan_probe(struct platform_device *pdev)
> +{
> +	struct lpc32xx_kscan_drv *kscandat;
> +	struct resource *res;
> +	int error;
> +	int irq;
> +
> +	kscandat = kzalloc(sizeof(struct lpc32xx_kscan_drv), GFP_KERNEL);
> +	if (!kscandat) {
> +		dev_err(&pdev->dev, "failed to allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "failed to get platform I/O memory\n");
> +		error = -EBUSY;
> +		goto out1;
> +	}
> +
> +	res = request_mem_region(res->start, resource_size(res), pdev->name);
> +	if (!res) {
> +		dev_err(&pdev->dev, "failed to request I/O memory\n");
> +		error = -EBUSY;
> +		goto out1;
> +	}
> +	kscandat->io_p_start = res->start;
> +	kscandat->io_p_size = resource_size(res);
> +
> +	kscandat->kscan_base = ioremap(res->start, resource_size(res));
> +	if (!kscandat->kscan_base) {
> +		dev_err(&pdev->dev, "failed to remap I/O memory\n");
> +		error = -EBUSY;
> +		goto out2;
> +	}
> +
> +	/* Get the key scanner clock */
> +	kscandat->clk = clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(kscandat->clk)) {
> +		dev_err(&pdev->dev, "failed to get clock\n");
> +		error = PTR_ERR(kscandat->clk);
> +		goto out3;
> +	}
> +	clk_enable(kscandat->clk);

Why not clk_prepare_enable()? Also I think you need to move it down, to
where you actually write to the device's registers.

> +
> +	irq = platform_get_irq(pdev, 0);
> +	if ((irq < 0) || (irq >= NR_IRQS)) {
> +		dev_err(&pdev->dev, "failed to get platform irq\n");
> +		error = -EINVAL;
> +		goto out4;
> +	}
> +	error = request_irq(irq, lpc32xx_kscan_irq, 0, pdev->name, kscandat);
> +	if (error) {
> +		dev_err(&pdev->dev, "failed to request irq\n");
> +		goto out4;
> +	}
> +
> +	kscandat->input = input_allocate_device();
> +	if (kscandat->input == NULL) {
> +		dev_err(&pdev->dev, "failed to allocate device\n");
> +		error = -ENOMEM;
> +		goto out5;
> +	}

This might be too late - IRQ is alreday registered and clock is enabled
- what is to stop interrupts to be delivered? I'd allocate the input
device together with kscandat structure.

> +
> +	platform_set_drvdata(pdev, kscandat);
> +
> +	error = lpc32xx_parse_dt(pdev);
> +	if (error) {
> +		dev_err(&pdev->dev, "failed to parse device tree\n");
> +		goto out6;
> +	}
> +
> +	/* Setup key input */
> +	kscandat->input->evbit[0]	= BIT_MASK(EV_KEY);
> +	kscandat->input->name		= pdev->name;
> +	kscandat->input->phys		= "matrix-keys/input0";
> +	kscandat->input->id.vendor	= 0x0001;
> +	kscandat->input->id.product	= 0x0001;
> +	kscandat->input->id.version	= 0x0100;
> +	kscandat->input->open		= lpc32xx_kscan_open;
> +	kscandat->input->close		= lpc32xx_kscan_close;
> +	kscandat->input->dev.parent	= &pdev->dev;
> +
> +	error = matrix_keypad_build_keymap(NULL, NULL, kscandat->matrix_sz,
> +					   kscandat->matrix_sz,
> +					   kscandat->keymap, kscandat->input);
> +	if (error) {
> +		dev_err(&pdev->dev, "failed to build keymap\n");
> +		goto out6;
> +	}
> +
> +	input_set_drvdata(kscandat->input, kscandat);
> +	input_set_capability(kscandat->input, EV_MSC, MSC_SCAN);
> +
> +	error = input_register_device(kscandat->input);
> +	if (error) {
> +		dev_err(&pdev->dev, "failed to register input device\n");
> +		goto out6;
> +	}
> +

I think this needs to be done before you register input device as as
soon as it is registered it may be used.

> +	/* Configure the key scanner */
> +	writel(kscandat->deb_clks, LPC32XX_KS_DEB(kscandat->kscan_base));
> +	writel(kscandat->scan_delay, LPC32XX_KS_SCAN_CTL(kscandat->kscan_base));
> +	writel(LPC32XX_KSCAN_FTST_USE32K_CLK,
> +	       LPC32XX_KS_FAST_TST(kscandat->kscan_base));
> +	writel(kscandat->matrix_sz,
> +	       LPC32XX_KS_MATRIX_DIM(kscandat->kscan_base));
> +	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
> +	clk_disable(kscandat->clk);

clk_disable_unprepare()?

> +	return 0;
> +
> +out6:
> +	input_free_device(kscandat->input);
> +out5:
> +	free_irq(irq, pdev);
> +out4:
> +	clk_disable(kscandat->clk);
> +	clk_put(kscandat->clk);
> +out3:
> +	iounmap(kscandat->kscan_base);
> +out2:
> +	release_mem_region(kscandat->io_p_start, kscandat->io_p_size);
> +out1:
> +	kfree(kscandat);
> +
> +	return error;
> +}
> +
> +static int __devexit lpc32xx_kscan_remove(struct platform_device *pdev)
> +{
> +	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
> +
> +	input_unregister_device(kscandat->input);

Are we certain it is safe to free input device before freeing IRQ? I see
we have close(), still I'd feel safer if you swapper unregister and
free_irq().

> +	free_irq(platform_get_irq(pdev, 0), pdev);
> +	clk_put(kscandat->clk);
> +	iounmap(kscandat->kscan_base);
> +	release_mem_region(kscandat->io_p_start, kscandat->io_p_size);
> +	kfree(kscandat);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int lpc32xx_kscan_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
> +
> +	/* Clear IRQ and disable clock */
> +	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
> +	clk_disable_unprepare(kscandat->clk);
> +

This may race with open()/close(). You need to take input_dev->mutex and
avoid touching the device if it sis not opened (users == 0).

> +	return 0;
> +}
> +
> +static int lpc32xx_kscan_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
> +
> +	/* Enable clock and clear IRQ */
> +	clk_prepare_enable(kscandat->clk);
> +	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
> +

Same here.

Thanks!

-- 
Dmitry
