Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2GJFrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 01:47:10 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:48962 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183Ab2GJFrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 01:47:07 -0400
Message-ID: <4FFBC1D0.5030506@ti.com>
Date: Tue, 10 Jul 2012 11:16:56 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org, hvaibhav@ti.com
Subject: Re: [PATCH v1 01/11] drivers: usb: otg: add a new driver for omap
 usb2 phy
References: <1340884267-28908-1-git-send-email-kishon@ti.com> <1340884267-28908-2-git-send-email-kishon@ti.com>
In-Reply-To: <1340884267-28908-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
> new file mode 100644
> index 0000000..80a28c9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
> @@ -0,0 +1,16 @@
> +OMAP USB PHY
> +
> +OMAP USB2 PHY
> +
> +Required properties:
> + - compatible: Should be "ti,omap-usb2"
> + - reg : Address and length of the register set for the device. Also
> +add the address of control module dev conf register until a driver for
> +control module is added
> +
> +This is usually a subnode of ocp2scp to which it is connected.
> +
> +usb2phy@0x4a0ad080 {
> +	compatible = "ti,omap-usb2";
> +	reg =<0x4a0ad080 0x58>;

Don;t you need a 'ti,hwmods' entry for this one?

> --- /dev/null
> +++ b/drivers/usb/otg/omap-usb2.c
> @@ -0,0 +1,273 @@
> +/*
> + * omap-usb2.c - USB PHY, talking to musb controller in OMAP.
> + *
> + * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com

Copyright (C) 2012? Same for the couple of headers below.

> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * Author: Kishon Vijay Abraham I<kishon@ti.com>
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +

> +
> +static int __devinit omap_usb2_probe(struct platform_device *pdev)
> +{
> +	struct omap_usb			*phy;
> +	struct usb_otg			*otg;
> +	struct resource			*res;
> +
> +	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
> +	if (!phy) {
> +		dev_err(&pdev->dev, "unable to allocate memory for USB2 PHY\n");
> +		return -ENOMEM;
> +	}
> +
> +	otg = devm_kzalloc(&pdev->dev, sizeof(*otg), GFP_KERNEL);
> +	if (!otg) {
> +		dev_err(&pdev->dev, "unable to allocate memory for USB OTG\n");
> +		return -ENOMEM;
> +	}
> +
> +	phy->dev		=&pdev->dev;
> +
> +	phy->phy.dev		= phy->dev;
> +	phy->phy.label		= "omap-usb2";
> +	phy->phy.set_suspend	= omap_usb2_suspend;
> +	phy->phy.otg		= otg;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +
> +	phy->control_dev_conf = devm_request_and_ioremap(&pdev->dev, res);
> +	if (phy->control_dev_conf == NULL) {
> +		dev_err(&pdev->dev, "Failed to obtain io memory\n");
> +		return -ENXIO;
> +	}
> +
> +	phy->is_suspended	= 1;
> +	omap_usb_phy_power(phy, 0);
> +
> +	otg->set_host		= omap_usb_set_host;
> +	otg->set_peripheral	= omap_usb_set_peripheral;
> +	otg->set_vbus		= omap_usb_set_vbus;
> +	otg->start_srp		= omap_usb_start_srp;
> +	otg->phy		=&phy->phy;
> +
> +	phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");

Why not just use clk_get()? What does devm_clk_get() do?

> +	if (IS_ERR(phy->wkupclk)) {
> +		dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
> +		return PTR_ERR(phy->wkupclk);
> +	}
> +	clk_prepare(phy->wkupclk);

Ideally clk_prepare() is an extension of clk_enable() and is expected
to be used that way. Not to be clubbed with clk_get(). Same with
clk_unprepare(). Do you do a clk_enable()/_disable() in interrupt/
atomic context?

> +
> +	usb_add_phy(&phy->phy, USB_PHY_TYPE_USB2);
> +
> +	platform_set_drvdata(pdev, phy);
> +
> +	pm_runtime_enable(phy->dev);
> +
> +	return 0;
> +}
> +
> +static int __devexit omap_usb2_remove(struct platform_device *pdev)
> +{
> +	struct omap_usb	*phy = platform_get_drvdata(pdev);
> +
> +	clk_unprepare(phy->wkupclk);
> +	usb_remove_phy(&phy->phy);
> +	platform_set_drvdata(pdev, NULL);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +
> +static int omap_usb2_runtime_suspend(struct device *dev)
> +{
> +	struct platform_device	*pdev = to_platform_device(dev);
> +	struct omap_usb	*phy = platform_get_drvdata(pdev);
> +
> +	clk_disable(phy->wkupclk);
> +
> +	return 0;
> +}
> +
> +static int omap_usb2_runtime_resume(struct device *dev)
> +{
> +	struct platform_device	*pdev = to_platform_device(dev);
> +	struct omap_usb	*phy = platform_get_drvdata(pdev);
> +
> +	clk_enable(phy->wkupclk);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops omap_usb2_pm_ops = {
> +	SET_RUNTIME_PM_OPS(omap_usb2_runtime_suspend, omap_usb2_runtime_resume,
> +		NULL)
> +};
> +
> +#define DEV_PM_OPS     (&omap_usb2_pm_ops)
> +#else
> +#define DEV_PM_OPS     NULL
> +#endif
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id omap_usb2_id_table[] = {
> +	{ .compatible = "ti,omap-usb2" },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, omap_usb2_id_table);
> +#else
> +#define omap_usb2_id_table NULL;
> +#endif
> +
> +static struct platform_driver omap_usb2_driver = {
> +	.probe		= omap_usb2_probe,
> +	.remove		= __devexit_p(omap_usb2_remove),
> +	.driver		= {
> +		.name	= "omap-usb2",
> +		.owner	= THIS_MODULE,
> +		.pm	= DEV_PM_OPS,
> +		.of_match_table = omap_usb2_id_table,

Use of_match_ptr() instead.

regards,
Rajendra

> +	},
> +};
> +
> +static int __init usb2_omap_init(void)
> +{
> +	return platform_driver_register(&omap_usb2_driver);
> +}
> +arch_initcall(usb2_omap_init);
> +
> +static void __exit usb2_omap_exit(void)
> +{
> +	platform_driver_unregister(&omap_usb2_driver);
> +}
> +module_exit(usb2_omap_exit);
> +
> +MODULE_ALIAS("platform: omap_usb2");
> +MODULE_AUTHOR("Texas Instruments Inc.");
> +MODULE_DESCRIPTION("OMAP USB2 PHY DRIVER");
> +MODULE_LICENSE("GPLv2");
> diff --git a/include/linux/usb/omap_usb.h b/include/linux/usb/omap_usb.h
> new file mode 100644
> index 0000000..ebcbca6
> --- /dev/null
> +++ b/include/linux/usb/omap_usb.h
> @@ -0,0 +1,45 @@
> +/*
> + * omap_usb.h -- omap usb2 phy header file
> + *
> + * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * Author: Kishon Vijay Abraham I<kishon@ti.com>
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __DRIVERS_OMAP_USB2_H
> +#define __DRIVERS_OMAP_USB2_H
> +
> +#include<linux/usb/otg.h>
> +
> +struct omap_usb {
> +	struct usb_phy		phy;
> +	struct phy_companion	*comparator;
> +	struct device		*dev;
> +	u32 __iomem		*control_dev_conf;
> +	struct clk		*wkupclk;
> +	u8			is_suspended:1;
> +};
> +
> +#define	PHY_PD	0x1
> +
> +#define	phy_to_omapusb(x)	container_of((x), struct omap_usb, phy)
> +
> +#if defined(CONFIG_OMAP_USB2) || defined(CONFIG_OMAP_USB2_MODULE)
> +void omap_usb2_set_comparator(struct phy_companion *comparator);
> +#else
> +static inline void omap_usb2_set_comparator(struct phy_companion *comparator)
> +{
> +}
> +#endif
> +
> +#endif /* __DRIVERS_OMAP_USB_H */
> diff --git a/include/linux/usb/phy_companion.h b/include/linux/usb/phy_companion.h
> new file mode 100644
> index 0000000..321290f
> --- /dev/null
> +++ b/include/linux/usb/phy_companion.h
> @@ -0,0 +1,34 @@
> +/*
> + * phy-companion.h -- phy companion to indicate the comparator part of PHY
> + *
> + * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * Author: Kishon Vijay Abraham I<kishon@ti.com>
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __DRIVERS_PHY_COMPANION_H
> +#define __DRIVERS_PHY_COMPANION_H
> +
> +#include<linux/usb/otg.h>
> +
> +/* phy_companion to take care of VBUS, ID and srp capabilities */
> +struct phy_companion {
> +
> +	/* effective for A-peripheral, ignored for B devices */
> +	int	(*set_vbus)(struct phy_companion *x, bool enabled);
> +
> +	/* for B devices only:  start session with A-Host */
> +	int	(*start_srp)(struct phy_companion *x);
> +};
> +
> +#endif /* __DRIVERS_PHY_COMPANION_H */

