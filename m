Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab2DXKB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 06:01:59 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56112 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab2DXKBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 06:01:31 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1335261068-18640-1-git-send-email-stigge@antcom.de>
References: <1335261068-18640-1-git-send-email-stigge@antcom.de>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 24 Apr 2012 18:01:10 +0800
Message-ID: <CAF+7xWmHGfGpFo6Wg=ad1Fc_6N56HWfp+YBw_6BeJziF52dCjw@mail.gmail.com>
Subject: Re: [PATCH 1/2] input: keyboard: Add keys driver for the LPC32xx SoC
To: Roland Stigge <stigge@antcom.de>
Cc: dmitry.torokhov@gmail.com, riyer@nvidia.com, michael.hennerich@analog.com,
        grant.likely@secretlab.ca, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef CONFIG_OF
> +static struct lpc32XX_kscan_cfg *lpc32XX_parse_dt(struct device *dev)
> +{
> +       struct lpc32XX_kscan_cfg *pdata;
> +       struct device_node *np = dev->of_node;
> +       struct device_node *key_np;
> +       int key_count;
> +       int i;
> +
> +       pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +       if (!pdata) {
> +               dev_err(dev, "could not allocate memory for platform data\n");
> +               return NULL;
> +       }
> +
> +       of_property_read_u32(np, "nxp,matrix-size", &pdata->matrix_sz);
> +       of_property_read_u32(np, "nxp,debounce-delay-ms", &pdata->deb_clks);
> +       of_property_read_u32(np, "nxp,scan-delay-ms", &pdata->scan_delay);
> +
> +       if (!pdata->matrix_sz || !pdata->deb_clks || !pdata->scan_delay) {
> +               dev_err(dev,
> +                       "matrix size, debounce or scan delay not specified\n");
> +               goto out1;
> +       }
> +
> +       key_count = pdata->matrix_sz * pdata->matrix_sz;
> +       pdata->keymap = devm_kzalloc(dev, sizeof(int) * key_count, GFP_KERNEL);
> +       if (!pdata->keymap) {
> +               dev_err(dev, "could not allocate memory for keymap\n");
> +               goto out1;
> +       }
> +
> +       i = 0;
> +       for_each_child_of_node(np, key_np) {
> +               u32 key_code;
> +               of_property_read_u32(key_np, "linux,code", &key_code);
> +               pdata->keymap[i++] = key_code;
> +       }
> +
> +       return pdata;
> +out1:
> +       devm_kfree(dev, pdata);

Since you are using devm_kzalloc, you don't need to call devm_kfree here.
> +       return NULL;
> +}
> +
> +static
> +void lpc32XX_free_dt(struct device *dev, struct lpc32XX_kscan_cfg *pdata)
> +{
> +       devm_kfree(dev, pdata->keymap);
> +       devm_kfree(dev, pdata);
> +}
The same, you don't need the devm_kfree calls, so you can just kill
lpc32XX_free_dt function.
> +
> +#else
> +static struct lpc32XX_kscan_cfg *lpc32XX_parse_dt(struct device *dev)
> +{
> +       return NULL;
> +}
> +
> +static
> +void lpc32XX_free_dt(struct device *dev, struct lpc32XX_kscan_cfg *pdata)
> +{
> +}
> +#endif
> +
> +static int __devinit lpc32xx_kscan_probe(struct platform_device *pdev)
> +{
> +       struct lpc32xx_kscan_drv *kscandat;
> +       struct resource *res;
> +       int retval, i, keynum;
> +
> +       kscandat = kzalloc(sizeof(struct lpc32xx_kscan_drv), GFP_KERNEL);
> +       if (unlikely(!kscandat)) {
> +               dev_err(&pdev->dev, "failed to allocate memory\n");
> +               return -ENOMEM;
> +       }
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (res == NULL) {
> +               dev_err(&pdev->dev, "failed to get platform I/O memory\n");
> +               retval = -EBUSY;
> +               goto err_nores;
> +       }
> +
> +       kscandat->kscan_base = devm_request_and_ioremap(&pdev->dev, res);
> +       if (kscandat->kscan_base == NULL) {
> +               dev_err(&pdev->dev, "failed to request and remap I/O memory\n");
> +               retval = -EBUSY;
> +               goto err_noremap;
> +       }
> +
> +       /* Get the key scanner clock */
> +       kscandat->clk = clk_get(&pdev->dev, NULL);
> +       if (IS_ERR(kscandat->clk)) {
> +               dev_err(&pdev->dev, "failed to get clock\n");
> +               retval = -ENODEV;
> +               goto err_noclk;
> +       }
> +       clk_enable(kscandat->clk);
> +
> +       kscandat->irq = platform_get_irq(pdev, 0);
> +       if ((kscandat->irq < 0) || (kscandat->irq >= NR_IRQS)) {
> +               dev_err(&pdev->dev, "failed to get platform irq\n");
> +               retval = -EINVAL;
> +               goto err_noirq;
> +       }
> +       retval = request_irq(kscandat->irq, lpc32xx_kscan_irq,
> +                            0, pdev->name, kscandat);
> +       if (retval) {
> +               dev_err(&pdev->dev, "failed to request irq\n");
> +               goto err_noirq;
> +       }
> +
> +       kscandat->input = input_allocate_device();
> +       if (kscandat->input == NULL) {
> +               dev_err(&pdev->dev, "failed to allocate device\n");
> +               retval = -ENOMEM;
> +               goto err_noalloc;
> +       }
> +
> +       if (pdev->dev.of_node)
> +               kscandat->kscancfg = lpc32XX_parse_dt(&pdev->dev);
> +       else
> +               kscandat->kscancfg =
> +                       (struct lpc32XX_kscan_cfg *)pdev->dev.platform_data;
> +       if (!kscandat->kscancfg) {
> +               dev_err(&pdev->dev, "failed to get platform data\n");
> +               retval = -EINVAL;
> +               goto err_nopdata;
> +       }
> +
> +       platform_set_drvdata(pdev, kscandat);
> +
> +       /* Setup key input */
> +       kscandat->input->evbit[0]       = BIT_MASK(EV_KEY);
> +       kscandat->input->name           = pdev->name;
> +       kscandat->input->phys           = "matrix-keys/input0";
> +       kscandat->input->dev.parent     =  &pdev->dev;
> +       kscandat->input->id.vendor      = 0x0001;
> +       kscandat->input->id.product     = 0x0001;
> +       kscandat->input->id.version     = 0x0100;
> +       keynum = kscandat->kscancfg->matrix_sz * kscandat->kscancfg->matrix_sz;
> +       for (i = 0; i < keynum; i++)
> +               __set_bit(kscandat->kscancfg->keymap[i],
> +                       kscandat->input->keybit);
> +
> +       input_set_capability(kscandat->input, EV_MSC, MSC_SCAN);
> +
> +       retval = input_register_device(kscandat->input);
> +       if (retval) {
> +               dev_err(&pdev->dev, "failed to register input device\n");
> +               goto err_notregistered;
> +       }
> +
> +       /* Configure the key scanner */
> +       __raw_writel(kscandat->kscancfg->deb_clks,
> +               LPC32XX_KS_DEB(kscandat->kscan_base));
> +       __raw_writel(kscandat->kscancfg->scan_delay,
> +               LPC32XX_KS_SCAN_CTL(kscandat->kscan_base));
> +       __raw_writel(LPC32XX_KSCAN_FTST_USE32K_CLK,
> +               LPC32XX_KS_FAST_TST(kscandat->kscan_base));
> +       __raw_writel(kscandat->kscancfg->matrix_sz,
> +               LPC32XX_KS_MATRIX_DIM(kscandat->kscan_base));
> +       __raw_writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
> +
> +       return 0;
> +
> +err_notregistered:
> +       lpc32XX_free_dt(&pdev->dev, kscandat->kscancfg);
> +err_nopdata:
> +       input_free_device(kscandat->input);
> +err_noalloc:
> +       free_irq(kscandat->irq, pdev);
> +err_noirq:
> +       clk_put(kscandat->clk);
> +err_noclk:
> +       iounmap(kscandat->kscan_base);
> +err_noremap:
> +       release_mem_region(res->start, resource_size(res));
You are using devm_request_and_ioremap, so the iounmap and
release_mem_region calls
are not necessary.
> +err_nores:
> +       kfree(kscandat);
> +
> +       return retval;
> +}
> +
> +static int __devexit lpc32xx_kscan_remove(struct platform_device *pdev)
> +{
> +       struct resource *res;
> +       struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
> +
> +       free_irq(kscandat->irq, pdev);
> +       input_unregister_device(kscandat->input);
> +       clk_put(kscandat->clk);
> +       iounmap(kscandat->kscan_base);
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       release_mem_region(res->start, resource_size(res));

The same, iounmap and release_mem_region can be removed.
> +
> +       kfree(kscandat);
> +
> +       return 0;
> +}
> +
