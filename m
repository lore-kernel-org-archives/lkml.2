Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab2GJGh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:37:56 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:51028 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212Ab2GJGhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:37:54 -0400
MIME-Version: 1.0
In-Reply-To: <4FFBC1D0.5030506@ti.com>
References: <1340884267-28908-1-git-send-email-kishon@ti.com>
	<1340884267-28908-2-git-send-email-kishon@ti.com>
	<4FFBC1D0.5030506@ti.com>
Date: Tue, 10 Jul 2012 12:07:52 +0530
Message-ID: <CAAe_U6L9qiBMXWeS2POeBod8uASCtmqDc4DigwBx1bJ-hhaNRQ@mail.gmail.com>
Subject: Re: [PATCH v1 01/11] drivers: usb: otg: add a new driver for omap
 usb2 phy
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org, hvaibhav@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 10, 2012 at 11:16 AM, Rajendra Nayak <rnayak@ti.com> wrote:
>> diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt
>> b/Documentation/devicetree/bindings/usb/omap-usb.txt
>> new file mode 100644
>> index 0000000..80a28c9
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
>> @@ -0,0 +1,16 @@
>> +OMAP USB PHY
>> +
>> +OMAP USB2 PHY
>> +
>> +Required properties:
>> + - compatible: Should be "ti,omap-usb2"
>> + - reg : Address and length of the register set for the device. Also
>> +add the address of control module dev conf register until a driver for
>> +control module is added
>> +
>> +This is usually a subnode of ocp2scp to which it is connected.
>> +
>> +usb2phy@0x4a0ad080 {
>> +       compatible = "ti,omap-usb2";
>> +       reg =<0x4a0ad080 0x58>;
>
>
> Don;t you need a 'ti,hwmods' entry for this one?

I don't think it needs one as it has nothing more than this one
address space. (it doesn't have sysconfig, doesn't have any prcm
register..).
>
>
>> --- /dev/null
>> +++ b/drivers/usb/otg/omap-usb2.c
>> @@ -0,0 +1,273 @@
>> +/*
>> + * omap-usb2.c - USB PHY, talking to musb controller in OMAP.
>> + *
>> + * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com
>
>
> Copyright (C) 2012? Same for the couple of headers below.
Will fix it.
>
>
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * Author: Kishon Vijay Abraham I<kishon@ti.com>
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>
>
>> +
>> +static int __devinit omap_usb2_probe(struct platform_device *pdev)
>> +{
>> +       struct omap_usb                 *phy;
>> +       struct usb_otg                  *otg;
>> +       struct resource                 *res;
>> +
>> +       phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
>> +       if (!phy) {
>> +               dev_err(&pdev->dev, "unable to allocate memory for USB2
>> PHY\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       otg = devm_kzalloc(&pdev->dev, sizeof(*otg), GFP_KERNEL);
>> +       if (!otg) {
>> +               dev_err(&pdev->dev, "unable to allocate memory for USB
>> OTG\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       phy->dev                =&pdev->dev;
>>
>> +
>> +       phy->phy.dev            = phy->dev;
>> +       phy->phy.label          = "omap-usb2";
>> +       phy->phy.set_suspend    = omap_usb2_suspend;
>> +       phy->phy.otg            = otg;
>> +
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>> +
>> +       phy->control_dev_conf = devm_request_and_ioremap(&pdev->dev, res);
>> +       if (phy->control_dev_conf == NULL) {
>> +               dev_err(&pdev->dev, "Failed to obtain io memory\n");
>> +               return -ENXIO;
>> +       }
>> +
>> +       phy->is_suspended       = 1;
>> +       omap_usb_phy_power(phy, 0);
>> +
>> +       otg->set_host           = omap_usb_set_host;
>> +       otg->set_peripheral     = omap_usb_set_peripheral;
>> +       otg->set_vbus           = omap_usb_set_vbus;
>> +       otg->start_srp          = omap_usb_start_srp;
>> +       otg->phy                =&phy->phy;
>>
>> +
>> +       phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");
>
>
> Why not just use clk_get()? What does devm_clk_get() do?
It just associates the clk with the device. So whenever the the driver
gets detached, the devres will take care to do a clk_put() of the
clock.
>
>
>> +       if (IS_ERR(phy->wkupclk)) {
>> +               dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
>> +               return PTR_ERR(phy->wkupclk);
>> +       }
>> +       clk_prepare(phy->wkupclk);
>
>
> Ideally clk_prepare() is an extension of clk_enable() and is expected
> to be used that way. Not to be clubbed with clk_get(). Same with
> clk_unprepare(). Do you do a clk_enable()/_disable() in interrupt/
> atomic context?

Currently it is called from a work queue. But Felipe wanted to remove
those work_queue from omap2430 glue. Then this would be called from
atomic context.
A query for you here. If pm_runtime_get_sync() is called in interrupt
context, will runtime resume of that device will also be called in the
same context?

>
>
>> +
>> +       usb_add_phy(&phy->phy, USB_PHY_TYPE_USB2);
>> +
>> +       platform_set_drvdata(pdev, phy);
>> +
>> +       pm_runtime_enable(phy->dev);
>> +
>> +       return 0;
>> +}
>> +
>> +static int __devexit omap_usb2_remove(struct platform_device *pdev)
>> +{
>> +       struct omap_usb *phy = platform_get_drvdata(pdev);
>> +
>> +       clk_unprepare(phy->wkupclk);
>> +       usb_remove_phy(&phy->phy);
>> +       platform_set_drvdata(pdev, NULL);
>> +
>> +       return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +
>> +static int omap_usb2_runtime_suspend(struct device *dev)
>> +{
>> +       struct platform_device  *pdev = to_platform_device(dev);
>> +       struct omap_usb *phy = platform_get_drvdata(pdev);
>> +
>> +       clk_disable(phy->wkupclk);
>> +
>> +       return 0;
>> +}
>> +
>> +static int omap_usb2_runtime_resume(struct device *dev)
>> +{
>> +       struct platform_device  *pdev = to_platform_device(dev);
>> +       struct omap_usb *phy = platform_get_drvdata(pdev);
>> +
>> +       clk_enable(phy->wkupclk);
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct dev_pm_ops omap_usb2_pm_ops = {
>> +       SET_RUNTIME_PM_OPS(omap_usb2_runtime_suspend,
>> omap_usb2_runtime_resume,
>> +               NULL)
>> +};
>> +
>> +#define DEV_PM_OPS     (&omap_usb2_pm_ops)
>> +#else
>> +#define DEV_PM_OPS     NULL
>> +#endif
>> +
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id omap_usb2_id_table[] = {
>> +       { .compatible = "ti,omap-usb2" },
>> +       {}
>> +};
>> +MODULE_DEVICE_TABLE(of, omap_usb2_id_table);
>> +#else
>> +#define omap_usb2_id_table NULL;
>> +#endif
>> +
>> +static struct platform_driver omap_usb2_driver = {
>> +       .probe          = omap_usb2_probe,
>> +       .remove         = __devexit_p(omap_usb2_remove),
>> +       .driver         = {
>> +               .name   = "omap-usb2",
>> +               .owner  = THIS_MODULE,
>> +               .pm     = DEV_PM_OPS,
>> +               .of_match_table = omap_usb2_id_table,
>
>
> Use of_match_ptr() instead.

Ok. And I'll remove #define omap_usb2_id_table NULL;.

Thanks
Kishon
