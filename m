Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab2DYKu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:50:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49019 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654Ab2DYKu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:50:56 -0400
Date: Wed, 25 Apr 2012 11:50:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: dmitry.torokhov@gmail.com, axel.lin@gmail.com, riyer@nvidia.com,
        michael.hennerich@analog.com, grant.likely@secretlab.ca,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v2 1/2] input: keyboard: Add keys driver for the
	LPC32xx SoC
Message-ID: <20120425105024.GU24211@n2100.arm.linux.org.uk>
References: <1335344386-7809-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335344386-7809-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:59:45AM +0200, Roland Stigge wrote:
> +/*
> + * Key scanner platform configuration structure
> + */
> +struct lpc32XX_kscan_cfg {

Why the upper case names?

> +	u32	matrix_sz;	/* Size of matrix in XxY, ie. 3 = 3x3 */
> +	int	*keymap;	/* Pointer to key map for the scan matrix */
> +	u32	deb_clks;	/* Debounce clocks (based on 32KHz clock) */
> +	u32	scan_delay;	/* Scan delay (based on 32KHz clock) */
> +};
> +
> +struct lpc32xx_kscan_drv {
> +	struct input_dev *input;
> +	struct lpc32XX_kscan_cfg *kscancfg;
> +	struct clk *clk;
> +	void __iomem *kscan_base;
> +	int irq;
> +	u8 lastkeystates[8];
> +};
> +
> +static void lpc32xx_mod_states(struct lpc32xx_kscan_drv *kscandat, int off)
> +{
> +	u8 st, key;
> +	int j, scancode, keycode;
> +
> +	key = (u8)readl(LPC32XX_KS_DATA(kscandat->kscan_base, off));

You don't need a narrowing cast for assignment - it happens automatically.

> +	if (key != kscandat->lastkeystates[off]) {
> +		for (j = 0; j < kscandat->kscancfg->matrix_sz; j++) {
> +			st = key & (1 << j);
> +			if (st != (kscandat->lastkeystates[off] & (1 << j))) {
> +				/* Key state changed, signal an event */
> +				scancode = (int)
> +				    (j * kscandat->kscancfg->matrix_sz) + off;

Why this cast?  j is an int, matrix_sz is a u32 (so unsigned int), and off
is an int too.

What about:
	changed = key ^ kscandat->lastkeystates[off];
	if (changed) {
		for (j = 0; j < kscandat->kscancfg->matrix_sz; j++) {
			if (changed & (1 << j)) {
				scancode = j * kscandat->kscancfg->matrix_sz + off;

I'd also suggest that you treat collections of bits as unsigned integers
rather than signed.  You can use a plain 'unsigned' to declare them
rather than 'unsigned int' if you're worred about too much typing ;)
It makes sense for key, changed, lastkeystates, and scancode to all
be unsigned.

> +				keycode = kscandat->kscancfg->keymap[scancode];
> +				input_report_key(kscandat->input, keycode,
> +						 (st != 0));
> +			}
> +		}
> +
> +		kscandat->lastkeystates[off] = key;
> +	}
> +}
> +
> +static irqreturn_t lpc32xx_kscan_irq(int irq, void *dev_id)
> +{
> +	int i;
> +	struct lpc32xx_kscan_drv *kscandat = (struct lpc32xx_kscan_drv *)dev_id;

No need to cast from void *.  The compiler won't complain.

> +
> +	for (i = 0; i < kscandat->kscancfg->matrix_sz; i++)
> +		lpc32xx_mod_states(kscandat, i);
> +
> +	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
> +
> +	input_sync(kscandat->input);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +#ifdef CONFIG_OF
> +static struct lpc32XX_kscan_cfg *lpc32XX_parse_dt(struct device *dev)
> +{
> +	struct lpc32XX_kscan_cfg *pdata;
> +	struct device_node *np = dev->of_node;
> +	struct device_node *key_np;
> +	int key_count;
> +	int i;
> +
> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata) {
> +		dev_err(dev, "could not allocate memory for platform data\n");
> +		return NULL;
> +	}
> +
> +	of_property_read_u32(np, "nxp,matrix-size", &pdata->matrix_sz);
> +	of_property_read_u32(np, "nxp,debounce-delay-ms", &pdata->deb_clks);
> +	of_property_read_u32(np, "nxp,scan-delay-ms", &pdata->scan_delay);
> +
> +	if (!pdata->matrix_sz || !pdata->deb_clks || !pdata->scan_delay) {
> +		dev_err(dev,
> +			"matrix size, debounce or scan delay not specified\n");
> +		return NULL;
> +	}
> +
> +	key_count = pdata->matrix_sz * pdata->matrix_sz;
> +	pdata->keymap = devm_kzalloc(dev, sizeof(int) * key_count, GFP_KERNEL);
> +	if (!pdata->keymap) {
> +		dev_err(dev, "could not allocate memory for keymap\n");
> +		return NULL;
> +	}
> +
> +	i = 0;
> +	for_each_child_of_node(np, key_np) {
> +		u32 key_code;
> +		of_property_read_u32(key_np, "linux,code", &key_code);
> +		pdata->keymap[i++] = key_code;
> +	}
> +
> +	return pdata;
> +}
> +#else
> +static struct lpc32XX_kscan_cfg *lpc32XX_parse_dt(struct device *dev)
> +{
> +	return NULL;
> +}
> +#endif
> +
> +static int __devinit lpc32xx_kscan_probe(struct platform_device *pdev)
> +{
> +	struct lpc32xx_kscan_drv *kscandat;
> +	struct resource *res;
> +	int retval, i, keynum;
> +
> +	kscandat = kzalloc(sizeof(struct lpc32xx_kscan_drv), GFP_KERNEL);
> +	if (unlikely(!kscandat)) {

No need to use unlikely() here, this isn't a fast path, so it's better
to let the compiler make the decisions.

> +		dev_err(&pdev->dev, "failed to allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (res == NULL) {

	if (!res) { will do here.

> +		dev_err(&pdev->dev, "failed to get platform I/O memory\n");
> +		retval = -EBUSY;
> +		goto out1;
> +	}
> +
> +	kscandat->kscan_base = devm_request_and_ioremap(&pdev->dev, res);
> +	if (kscandat->kscan_base == NULL) {
> +		dev_err(&pdev->dev, "failed to request and remap I/O memory\n");
> +		retval = -EBUSY;
> +		goto out1;
> +	}
> +
> +	/* Get the key scanner clock */
> +	kscandat->clk = clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(kscandat->clk)) {
> +		dev_err(&pdev->dev, "failed to get clock\n");
> +		retval = -ENODEV;
> +		goto out1;
> +	}
> +	clk_enable(kscandat->clk);

clk_prepare_enable() ?  What about doing this in the open/release
callbacks from the input device, so when this input device isn't
actually being used, it's not consuming power?

Don't forget that these functions can also fail.

> +
> +	kscandat->irq = platform_get_irq(pdev, 0);
> +	if ((kscandat->irq < 0) || (kscandat->irq >= NR_IRQS)) {
> +		dev_err(&pdev->dev, "failed to get platform irq\n");
> +		retval = -EINVAL;
> +		goto out2;
> +	}
> +	retval = request_irq(kscandat->irq, lpc32xx_kscan_irq,
> +			     0, pdev->name, kscandat);
> +	if (retval) {
> +		dev_err(&pdev->dev, "failed to request irq\n");
> +		goto out2;
> +	}
> +
> +	kscandat->input = input_allocate_device();
> +	if (kscandat->input == NULL) {
> +		dev_err(&pdev->dev, "failed to allocate device\n");
> +		retval = -ENOMEM;
> +		goto out3;
> +	}
> +
> +	if (pdev->dev.of_node)
> +		kscandat->kscancfg = lpc32XX_parse_dt(&pdev->dev);
> +	else
> +		kscandat->kscancfg =
> +			(struct lpc32XX_kscan_cfg *)pdev->dev.platform_data;

Cast not required.

> +	if (!kscandat->kscancfg) {
> +		dev_err(&pdev->dev, "failed to get platform data\n");
> +		retval = -EINVAL;
> +		goto out4;
> +	}
> +
> +	platform_set_drvdata(pdev, kscandat);
> +
> +	/* Setup key input */
> +	kscandat->input->evbit[0]	= BIT_MASK(EV_KEY);
> +	kscandat->input->name		= pdev->name;
> +	kscandat->input->phys		= "matrix-keys/input0";
> +	kscandat->input->dev.parent	=  &pdev->dev;
> +	kscandat->input->id.vendor	= 0x0001;
> +	kscandat->input->id.product	= 0x0001;
> +	kscandat->input->id.version	= 0x0100;
> +	keynum = kscandat->kscancfg->matrix_sz * kscandat->kscancfg->matrix_sz;
> +	for (i = 0; i < keynum; i++)
> +		__set_bit(kscandat->kscancfg->keymap[i],
> +			kscandat->input->keybit);
> +
> +	input_set_capability(kscandat->input, EV_MSC, MSC_SCAN);
> +
> +	retval = input_register_device(kscandat->input);
> +	if (retval) {
> +		dev_err(&pdev->dev, "failed to register input device\n");
> +		goto out4;
> +	}
> +
> +	/* Configure the key scanner */
> +	writel(kscandat->kscancfg->deb_clks,
> +		LPC32XX_KS_DEB(kscandat->kscan_base));
> +	writel(kscandat->kscancfg->scan_delay,
> +		LPC32XX_KS_SCAN_CTL(kscandat->kscan_base));
> +	writel(LPC32XX_KSCAN_FTST_USE32K_CLK,
> +		LPC32XX_KS_FAST_TST(kscandat->kscan_base));
> +	writel(kscandat->kscancfg->matrix_sz,
> +		LPC32XX_KS_MATRIX_DIM(kscandat->kscan_base));
> +	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
> +
> +	return 0;
> +
> +out4:
> +	input_free_device(kscandat->input);
> +out3:
> +	free_irq(kscandat->irq, pdev);
> +out2:

No balancing of the clock enable.

> +	clk_put(kscandat->clk);
> +out1:
> +	kfree(kscandat);
> +
> +	return retval;
> +}
> +
> +static int __devexit lpc32xx_kscan_remove(struct platform_device *pdev)
> +{
> +	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
> +
> +	free_irq(kscandat->irq, pdev);
> +	input_unregister_device(kscandat->input);

No balancing of clk_enable() ?

> +	clk_put(kscandat->clk);
> +	kfree(kscandat);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int lpc32xx_kscan_suspend(struct platform_device *pdev,
> +	pm_message_t state)
> +{
> +	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
> +
> +	/* Clear IRQ and disable clock */
> +	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
> +	clk_disable(kscandat->clk);
> +
> +	return 0;
> +}
> +
> +static int lpc32xx_kscan_resume(struct platform_device *pdev)
> +{
> +	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
> +
> +	/* Enable clock and clear IRQ */
> +	clk_enable(kscandat->clk);
> +	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
> +
> +	return 0;
> +}
> +#else
> +#define lpc32xx_kscan_suspend	NULL
> +#define lpc32xx_kscan_resume	NULL
> +#endif
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id lpc32xx_kscan_match[] = {
> +	{ .compatible = "nxp,lpc3220-key" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, lpc32xx_kscan_match);
> +#endif
> +
> +static struct platform_driver lpc32xx_kscan_driver = {
> +	.probe		= lpc32xx_kscan_probe,
> +	.remove		= __devexit_p(lpc32xx_kscan_remove),
> +	.suspend	= lpc32xx_kscan_suspend,
> +	.resume		= lpc32xx_kscan_resume,
> +	.driver		= {
> +		.name	= "lpc32xx_keys",
> +		.of_match_table = of_match_ptr(lpc32xx_kscan_match),
> +	}
> +};
> +
> +module_platform_driver(lpc32xx_kscan_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Kevin Wells <kevin.wells@nxp.com>");
> +MODULE_AUTHOR("Roland Stigge <stigge@antcom.de>");
> +MODULE_DESCRIPTION("Key scanner driver for LPC32XX devices");
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
