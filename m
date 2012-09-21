Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab2IUGIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:08:25 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:42812 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808Ab2IUGIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:08:23 -0400
MIME-Version: 1.0
In-Reply-To: <5059D994.6050606@pengutronix.de>
References: <1348054229-27362-1-git-send-email-kishon@ti.com>
	<1348054229-27362-2-git-send-email-kishon@ti.com>
	<5059D994.6050606@pengutronix.de>
Date: Fri, 21 Sep 2012 11:38:21 +0530
Message-ID: <CAAe_U6Kxxs0i_bSKYTBHbdGzGzJSw27qfvyUX0CEbDxX18GYZw@mail.gmail.com>
Subject: Re: [PATCH 1/4] usb: phy: add a new driver for usb3 phy
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Moiz Sonasath <m-sonasath@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 19, 2012 at 8:11 PM, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 09/19/2012 01:30 PM, Kishon Vijay Abraham I wrote:
>> Added a driver for usb3 phy that handles the interaction between usb phy
>> device and dwc3 controller.
>>
>> This also includes device tree support for usb3 phy driver and
>> the documentation with device tree binding information is updated.
>>
>> Currently writing to control module register is taken care in this
>> driver which will be removed once the control module driver is in place.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> Signed-off-by: Felipe Balbi <balbi@ti.com>
>> Signed-off-by: Moiz Sonasath <m-sonasath@ti.com>
>> ---
>>  Documentation/devicetree/bindings/usb/usb-phy.txt |   18 +
>>  drivers/usb/phy/Kconfig                           |    9 +
>>  drivers/usb/phy/Makefile                          |    1 +
>>  drivers/usb/phy/omap-usb3.c                       |  369 +++++++++++++++++++++
>>  include/linux/usb/omap_usb.h                      |   72 ++++
>>  5 files changed, 469 insertions(+)
>>  create mode 100644 drivers/usb/phy/omap-usb3.c
>>
>> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
>> index 80d4148..7c5fd89 100644
>> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
>> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
>> @@ -15,3 +15,21 @@ usb2phy@4a0ad080 {
>>       reg = <0x4a0ad080 0x58>,
>>             <0x4a002300 0x4>;
>>  };
>> +
>> +OMAP USB3 PHY
>> +
>> +Required properties:
>> + - compatible: Should be "ti,omap-usb3"
>> + - reg : Address and length of the register set for the device. Also
>> +add the address of control module phy power register until a driver for
>> +control module is added
>> +
>> +This is usually a subnode of ocp2scp to which it is connected.
>> +
>> +usb3phy@4a084400 {
>> +     compatible = "ti,omap-usb3";
>> +     reg = <0x0x4a084400 0x80>,
>> +           <0x4a084800 0x64>,
>> +           <0x4a084c00 0x40>,
>> +           <0x4a002370 0x4>;
>> +};
>> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
>> index 63c339b..353dc0c 100644
>> --- a/drivers/usb/phy/Kconfig
>> +++ b/drivers/usb/phy/Kconfig
>> @@ -13,6 +13,15 @@ config OMAP_USB2
>>         The USB OTG controller communicates with the comparator using this
>>         driver.
>>
>> +config OMAP_USB3
>> +     tristate "OMAP USB3 PHY Driver"
>> +     select USB_OTG_UTILS
>> +     help
>> +       Enable this to support the USB3 PHY that is part of SOC. This
>> +       driver takes care of all the PHY functionality apart from comparator.
>> +       The USB OTG controller communicates with the comparator using this
>> +       driver.
>> +
>>  config USB_ISP1301
>>       tristate "NXP ISP1301 USB transceiver support"
>>       depends on USB || USB_GADGET
>> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
>> index b069f29..973b1e6 100644
>> --- a/drivers/usb/phy/Makefile
>> +++ b/drivers/usb/phy/Makefile
>> @@ -5,6 +5,7 @@
>>  ccflags-$(CONFIG_USB_DEBUG) := -DDEBUG
>>
>>  obj-$(CONFIG_OMAP_USB2)                      += omap-usb2.o
>> +obj-$(CONFIG_OMAP_USB3)                      += omap-usb3.o
>>  obj-$(CONFIG_USB_ISP1301)            += isp1301.o
>>  obj-$(CONFIG_MV_U3D_PHY)             += mv_u3d_phy.o
>>  obj-$(CONFIG_USB_EHCI_TEGRA) += tegra_usb_phy.o
>> diff --git a/drivers/usb/phy/omap-usb3.c b/drivers/usb/phy/omap-usb3.c
>> new file mode 100644
>> index 0000000..4dc84ca
>> --- /dev/null
>> +++ b/drivers/usb/phy/omap-usb3.c
>> @@ -0,0 +1,369 @@
>> +/*
>> + * omap-usb3 - USB PHY, talking to dwc3 controller in OMAP.
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
>> +#include <linux/slab.h>
>> +#include <linux/usb/omap_usb.h>
>> +#include <linux/of.h>
>> +#include <linux/clk.h>
>> +#include <linux/err.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/delay.h>
>> +
>> +static struct usb_dpll_params omap_usb3_dpll_params[NUM_SYS_CLKS] = {
>> +     {1250, 5, 4, 20, 0},            /* 12 MHz */
>> +     {3125, 20, 4, 20, 0},           /* 16.8 MHz */
>> +     {1172, 8, 4, 20, 65537},        /* 19.2 MHz */
>> +     {1250, 12, 4, 20, 0},           /* 26 MHz */
>> +     {3125, 47, 4, 20, 92843},       /* 38.4 MHz */
>> +};
>> +
>> +/**
>> + * omap5_usb_phy_power - power on/off the serializer using control module
>> + * @phy: struct omap_usb *
>> + * @on: 0 to off and 1 to on based on powering on or off the PHY
>> + *
>> + * omap_usb3 can call this API to power on or off the PHY.
>> + */
>> +static int omap5_usb_phy_power(struct omap_usb *phy, bool on)
>> +{
>> +     u32 val;
>> +     unsigned long rate;
>> +     struct clk *sys_clk;
>> +
>> +     sys_clk = clk_get(NULL, "sys_clkin");
>
> Where's the corresponding clk_put()?

I have missed it. Will fix it in my next version.
>
>> +     if (IS_ERR(sys_clk)) {
>> +             pr_err("%s: unable to get sys_clkin\n", __func__);
>> +             return -EINVAL;
>> +     }
>> +
>> +     rate = clk_get_rate(sys_clk);
>> +     rate = rate/1000000;
>> +
>> +     val = readl(phy->control_dev);
>> +
>> +     if (on) {
>> +             val &= ~(USB_PWRCTL_CLK_CMD_MASK | USB_PWRCTL_CLK_FREQ_MASK);
>> +             val |= USB3_PHY_TX_RX_POWERON << USB_PWRCTL_CLK_CMD_SHIFT;
>> +             val |= rate << USB_PWRCTL_CLK_FREQ_SHIFT;
>> +     } else {
>> +             val &= ~USB_PWRCTL_CLK_CMD_MASK;
>> +             val |= USB3_PHY_TX_RX_POWEROFF << USB_PWRCTL_CLK_CMD_SHIFT;
>> +     }
>> +
>> +     writel(val, phy->control_dev);
>> +
>> +     return 0;
>> +}
>> +
>> +static int omap_usb3_suspend(struct usb_phy *x, int suspend)
>> +{
>> +     struct omap_usb *phy = phy_to_omapusb(x);
>> +     int     val, ret;
>> +     int timeout = PLL_IDLE_TIME;
>> +
>> +     if (suspend && !phy->is_suspended) {
>> +             val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
>> +             val |= PLL_IDLE;
>> +             omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
>> +
>> +             do {
>> +                     val = omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
>> +                     if (val & PLL_TICOPWDN)
>> +                             break;
>> +                     udelay(1);
>> +             } while (--timeout);
>> +
>> +             omap5_usb_phy_power(phy, 0);
>> +             pm_runtime_put_sync(phy->dev);
>> +
>> +             phy->is_suspended       = 1;
>> +     } else if (!suspend && phy->is_suspended) {
>> +             phy->is_suspended       = 0;
>> +             ret = pm_runtime_get_sync(phy->dev);
>> +             if (ret < 0) {
>> +                     dev_err(phy->dev, "get_sync failed with err %d\n",
>> +                                                                     ret);
>> +                     return ret;
>> +             }
>> +
>> +             val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
>> +             val &= ~PLL_IDLE;
>> +             omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
>> +
>> +             do {
>> +                     val = omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
>> +                     if (!(val & PLL_TICOPWDN))
>> +                             break;
>> +                     udelay(1);
>> +             } while (--timeout);
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static inline enum sys_clk_rate __get_sys_clk_index(unsigned long rate)
>> +{
>> +     switch (rate) {
>> +     case 12000000:
>> +             return CLK_RATE_12MHZ;
>> +     case 16800000:
>> +             return CLK_RATE_16MHZ;
>> +     case 19200000:
>> +             return CLK_RATE_19MHZ;
>> +     case 26000000:
>> +             return CLK_RATE_26MHZ;
>> +     case 38400000:
>> +             return CLK_RATE_38MHZ;
>> +     default:
>> +             return CLK_RATE_UNDEFINED;
>> +     }
>> +}
>> +
>> +static void omap_usb_dpll_relock(struct omap_usb *phy)
>> +{
>> +     u32             val;
>> +     unsigned long   timeout;
>> +
>> +     omap_usb_writel(phy->pll_ctrl_base, PLL_GO, SET_PLL_GO);
>> +
>> +     timeout = jiffies + msecs_to_jiffies(20);
>> +     do {
>> +             val = omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
>> +             if (val & PLL_LOCK)
>> +                     break;
>> +     } while (!WARN_ON(time_after(jiffies, timeout)));
>> +}
>> +
>> +static int omap_usb_dpll_lock(struct omap_usb *phy)
>> +{
>> +     u32                     val;
>> +     struct clk              *sys_clk;
>> +     unsigned long           rate;
>> +     enum sys_clk_rate       clk_index;
>> +
>> +     sys_clk = clk_get(NULL, "sys_clkin");
>
> Where's the corresponding clk_put()?
>
>> +     if (IS_ERR(sys_clk)) {
>> +             pr_err("unable to get sys_clkin\n");
>> +             return PTR_ERR(sys_clk);
>> +     }
>> +
>> +     rate            = clk_get_rate(sys_clk);
>> +     clk_index       = __get_sys_clk_index(rate);
>> +
>> +     if (clk_index == CLK_RATE_UNDEFINED) {
>> +             pr_err("dpll cannot be locked for sys clk freq:%luHz\n", rate);
>> +             return -EINVAL;
>> +     }
>> +
>> +     val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
>> +     val &= ~PLL_REGN_MASK;
>> +     val |= omap_usb3_dpll_params[clk_index].n << PLL_REGN_SHIFT;
>> +     omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
>> +
>> +     val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
>> +     val &= ~PLL_SELFREQDCO_MASK;
>> +     val |= omap_usb3_dpll_params[clk_index].freq << PLL_SELFREQDCO_SHIFT;
>> +     omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
>> +
>> +     val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
>> +     val &= ~PLL_REGM_MASK;
>> +     val |= omap_usb3_dpll_params[clk_index].m << PLL_REGM_SHIFT;
>> +     omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
>> +
>> +     val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION4);
>> +     val &= ~PLL_REGM_F_MASK;
>> +     val |= omap_usb3_dpll_params[clk_index].mf << PLL_REGM_F_SHIFT;
>> +     omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION4, val);
>> +
>> +     val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION3);
>> +     val &= ~PLL_SD_MASK;
>> +     val |= omap_usb3_dpll_params[clk_index].sd << PLL_SD_SHIFT;
>> +     omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION3, val);
>> +
>> +     omap_usb_dpll_relock(phy);
>> +
>> +     return 0;
>> +}
>> +
>> +static int omap_usb3_init(struct usb_phy *x)
>> +{
>> +     struct omap_usb *phy = phy_to_omapusb(x);
>> +
>> +     omap_usb_dpll_lock(phy);
>> +     omap5_usb_phy_power(phy, 1);
>> +
>> +     return 0;
>> +}
>> +
>> +static int __devinit omap_usb3_probe(struct platform_device *pdev)
>> +{
>> +     struct omap_usb                 *phy;
>> +     struct resource                 *res;
>> +
>> +     phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
>> +     if (!phy) {
>> +             dev_err(&pdev->dev, "unable to alloc mem for OMAP USB3 PHY\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
>> +     if (!res) {
>> +             dev_err(&pdev->dev, "unable to get base address of pll_ctrl\n");
>> +             return -ENODEV;
>> +     }
>> +
>> +     phy->pll_ctrl_base = devm_request_and_ioremap(&pdev->dev, res);
>> +     if (!phy->pll_ctrl_base) {
>> +             dev_err(&pdev->dev, "ioremap of pll_ctrl failed\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 3);
>> +     if (!res) {
>> +             dev_err(&pdev->dev,
>> +                     "unable to get address of control phy power\n");
>> +             return -ENODEV;
>> +     }
>> +
>> +     phy->control_dev = devm_request_and_ioremap(&pdev->dev, res);
>> +     if (!phy->control_dev) {
>> +             dev_err(&pdev->dev, "ioremap of control_dev failed\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     phy->dev                = &pdev->dev;
>> +
>> +     phy->phy.dev            = phy->dev;
>> +     phy->phy.label          = "omap-usb3";
>> +     phy->phy.init           = omap_usb3_init;
>> +     phy->phy.set_suspend    = omap_usb3_suspend;
>> +
>> +     phy->is_suspended       = 1;
>> +     omap5_usb_phy_power(phy, 0);
>> +
>> +     phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");
>> +     if (IS_ERR(phy->wkupclk)) {
>> +             dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
>> +             return PTR_ERR(phy->wkupclk);
>> +     }
>> +     clk_prepare(phy->wkupclk);
>> +
>> +     phy->optclk = devm_clk_get(phy->dev, "usb_otg_ss_refclk960m");
>> +     if (IS_ERR(phy->optclk)) {
>> +             dev_err(&pdev->dev, "unable to get usb_otg_ss_refclk960m\n");
>> +             return PTR_ERR(phy->optclk);
>> +     }
>> +     clk_prepare(phy->optclk);
>
> Are these clocks only needed on the PM usecase?
clk32k is a wakeup/debounce clock and 960m is a functional reference
clock to usb2 phy.

Thanks
Kishon
