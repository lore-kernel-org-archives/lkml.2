Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2HCOXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:23:53 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:41290 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753730Ab2HCOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:23:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120803132046.GA8269@arwen.pp.htv.fi>
References: <1342593039-7728-1-git-send-email-kishon@ti.com>
	<1342593039-7728-2-git-send-email-kishon@ti.com>
	<20120803132046.GA8269@arwen.pp.htv.fi>
Date: Fri, 3 Aug 2012 19:53:41 +0530
Message-ID: <CAAe_U6Kk=YxwzcueZzriECiLCciaY3UAW+xfhhc-zyz5YWwXEA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] drivers: bus: add a new driver for omap-ocp2scp
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: balbi@ti.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, b-cousson@ti.com, rnayak@ti.com,
        tony@atomide.com, gregkh@linuxfoundation.org, ohad@wizery.com,
        linus.walleij@linaro.org, myungjoo.ham@samsung.com,
        rusty@rustcorp.com.au, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 3, 2012 at 6:50 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, Jul 18, 2012 at 12:00:38PM +0530, Kishon Vijay Abraham I wrote:
>> Adds a new driver *omap-ocp2scp*. This driver takes the responsibility of
>> creating all the devices that is connected to OCP2SCP. In the case of OMAP4,
>> USB2PHY is connected to ocp2scp.
>>
>> This also includes device tree support for ocp2scp driver and
>> the documentation with device tree binding information is updated.
>>
>> Cc: Felipe Balbi <balbi@ti.com>
>
> If you fix (or change my mind) on the comment below, you can add:
>
> Acked-by: Felipe Balbi <balbi@ti.com>
>
>
> Also, I wonder who should be the one to take this. Who will be queueing
> patches on this directory to mainline ?
>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  .../devicetree/bindings/bus/omap-ocp2scp.txt       |   10 ++
>>  drivers/Kconfig                                    |    2 +
>>  drivers/Makefile                                   |    2 +
>>  drivers/bus/Kconfig                                |   15 +++
>>  drivers/bus/Makefile                               |    5 +
>>  drivers/bus/omap-ocp2scp.c                         |   98 ++++++++++++++++++++
>>  6 files changed, 132 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
>>  create mode 100644 drivers/bus/Kconfig
>>  create mode 100644 drivers/bus/Makefile
>>  create mode 100644 drivers/bus/omap-ocp2scp.c
>>
>> diff --git a/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt b/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
>> new file mode 100644
>> index 0000000..d2fe064
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
>> @@ -0,0 +1,10 @@
>> +* OMAP OCP2SCP - ocp interface to scp interface
>> +
>> +properties:
>> +- compatible : Should be "ti,omap-ocp2scp"
>> +- #address-cells, #size-cells : Must be present if the device has sub-nodes
>> +- ranges : the child address space are mapped 1:1 onto the parent address space
>> +- ti,hwmods : must be "ocp2scp_usb_phy"
>> +
>> +Sub-nodes:
>> +All the devices connected to ocp2scp are described using sub-node to ocp2scp
>> diff --git a/drivers/Kconfig b/drivers/Kconfig
>> index bfc9186..4fe1e4c 100644
>> --- a/drivers/Kconfig
>> +++ b/drivers/Kconfig
>> @@ -2,6 +2,8 @@ menu "Device Drivers"
>>
>>  source "drivers/base/Kconfig"
>>
>> +source "drivers/bus/Kconfig"
>> +
>>  source "drivers/connector/Kconfig"
>>
>>  source "drivers/mtd/Kconfig"
>> diff --git a/drivers/Makefile b/drivers/Makefile
>> index 2ba29ff..cac3819 100644
>> --- a/drivers/Makefile
>> +++ b/drivers/Makefile
>> @@ -5,6 +5,8 @@
>>  # Rewritten to use lists instead of if-statements.
>>  #
>>
>> +obj-y                                += bus/
>> +
>>  # GPIO must come after pinctrl as gpios may need to mux pins etc
>>  obj-y                                += pinctrl/
>>  obj-y                                += gpio/
>> diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
>> new file mode 100644
>> index 0000000..6270415
>> --- /dev/null
>> +++ b/drivers/bus/Kconfig
>> @@ -0,0 +1,15 @@
>> +#
>> +# Bus Devices
>> +#
>> +
>> +menu "Bus devices"
>> +
>> +config OMAP_OCP2SCP
>> +     tristate "OMAP OCP2SCP DRIVER"
>> +     help
>> +       Driver to enable ocp2scp module which transforms ocp interface
>> +       protocol to scp protocol. In OMAP4, USB PHY is connected via
>> +       OCP2SCP and in OMAP5, both USB PHY and SATA PHY is connected via
>> +       OCP2SCP.
>> +
>> +endmenu
>> diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
>> new file mode 100644
>> index 0000000..0ec50bc
>> --- /dev/null
>> +++ b/drivers/bus/Makefile
>> @@ -0,0 +1,5 @@
>> +#
>> +# Makefile for the bus drivers.
>> +#
>> +
>> +obj-$(CONFIG_OMAP_OCP2SCP)   += omap-ocp2scp.o
>> diff --git a/drivers/bus/omap-ocp2scp.c b/drivers/bus/omap-ocp2scp.c
>> new file mode 100644
>> index 0000000..8c3db3a
>> --- /dev/null
>> +++ b/drivers/bus/omap-ocp2scp.c
>> @@ -0,0 +1,98 @@
>> +/*
>> + * omap-ocp2scp.c - transform ocp interface protocol to scp protocol
>> + *
>> + * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/err.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/of.h>
>> +#include <linux/of_platform.h>
>> +
>> +static int ocp2scp_remove_devices(struct device *dev, void *c)
>> +{
>> +     struct platform_device *pdev = to_platform_device(dev);
>> +
>> +     platform_device_unregister(pdev);
>> +
>> +     return 0;
>> +}
>> +
>> +static int __devinit omap_ocp2scp_probe(struct platform_device *pdev)
>> +{
>> +     int                     ret;
>> +     struct device_node      *np = pdev->dev.of_node;
>> +
>> +     if (np) {
>> +             ret = of_platform_populate(np, NULL, NULL, &pdev->dev);
>> +             if (ret) {
>> +                     dev_err(&pdev->dev, "failed to add resources for ocp2scp child\n");
>> +                     goto err0;
>> +             }
>> +     }
>> +     pm_runtime_enable(&pdev->dev);
>> +
>> +     return 0;
>> +
>> +err0:
>> +     device_for_each_child(&pdev->dev, NULL, ocp2scp_remove_devices);
>> +
>> +     return ret;
>> +}
>> +
>> +static int __devexit omap_ocp2scp_remove(struct platform_device *pdev)
>> +{
>> +     pm_runtime_disable(&pdev->dev);
>> +     device_for_each_child(&pdev->dev, NULL, ocp2scp_remove_devices);
>> +
>> +     return 0;
>> +}
>> +
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id omap_ocp2scp_id_table[] = {
>> +     { .compatible = "ti,omap-ocp2scp" },
>> +     {}
>> +};
>> +MODULE_DEVICE_TABLE(of, omap_usb2_id_table);
>> +#endif
>> +
>> +static struct platform_driver omap_ocp2scp_driver = {
>> +     .probe          = omap_ocp2scp_probe,
>> +     .remove         = __devexit_p(omap_ocp2scp_remove),
>> +     .driver         = {
>> +             .name   = "omap-ocp2scp",
>> +             .owner  = THIS_MODULE,
>> +             .of_match_table = of_match_ptr(omap_ocp2scp_id_table),
>> +     },
>> +};
>> +
>> +static int __init omap_ocp2scp_init(void)
>> +{
>> +     return platform_driver_register(&omap_ocp2scp_driver);
>> +}
>> +arch_initcall(omap_ocp2scp_init);
>
> I really think we should avoid this trickery and make dependent drivers
> return -EPROBE_DEFER case this isn't ready yet.

Ok. Will do it that way in my next series.

Thanks
Kishon
