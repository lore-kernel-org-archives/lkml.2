Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760932Ab2ILSgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:36:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50432 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab2ILSgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:36:21 -0400
Message-ID: <5050D622.7080704@wwwdotorg.org>
Date: Wed, 12 Sep 2012 12:36:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: balbi@ti.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] USB: phy: re-organize tegra phy driver
References: <1347447481-25574-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1347447481-25574-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 04:58 AM, Venu Byravarasu wrote:
> Nvidia produces several Tegra SOCs viz Tegra2, Tegra3 etc.
> In order to support USB phy drivers on these SOCs, existing
> phy driver is split into SOC agnostic common USB phy driver and
> tegra2 specific USB phy driver.
> This will facilitate easy addition & deletion of phy drivers for
> Tegra SOCs.

For capitalization/related reasons, I would re-write the commit
description as:

NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
In order to support USB PHY drivers on these SoCs, existing
PHY driver is split into SoC agnostic common USB PHY driver and
Tegra20-specific USB phy driver. This will facilitate easy addition
and deletion of phy drivers for Tegra SoCs.

... and s/tegra/Tegra/ in the patch subject.

Tested-by: Stephen Warren <swarren@wwwdotorg.org>

(On Harmony, both the USB Ethernet on USB3/UTMI and USB2's ULPI to a
breakout board)

> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c

> @@ -706,9 +709,22 @@ static int tegra_ehci_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	phy_type = of_property_match_string(np, "phy_type", "utmi");
> +	if (phy_type >= 0)
> +		params.type = TEGRA_USB_PHY_TYPE_UTMI;
> +	else {
> +		phy_type = of_property_match_string(np, "phy_type", "ulpi");
> +		if (phy_type >= 0)
> +			params.type = TEGRA_USB_PHY_TYPE_ULPI;
> +		else
> +			params.type = TEGRA_USB_PHY_TYPE_INVALID;
> +	}
> +
> +	params.mode = TEGRA_USB_PHY_MODE_HOST;

Do we not support device mode yet? There's a dr_mode property in the DT
that's supposed to indicate host/device/otg.

> diff --git a/drivers/usb/phy/tegra2_usb_phy.c b/drivers/usb/phy/tegra2_usb_phy.c

> +#include <mach/gpio-tegra.h>

Please remove that #include statement; the heaer is not needed, and will
be deleted in the kernel 3.7 merge window.

> +static int tegra2_utmip_pad_open(struct tegra_usb_phy *phy)
> +{
> +	phy->pad_clk = clk_get_sys("utmip-pad", NULL);
> +	if (IS_ERR(phy->pad_clk)) {
> +		pr_err("%s: can't get utmip pad clock\n", __func__);
> +		return PTR_ERR(phy->pad_clk);
> +	}
> +
> +	if (phy->instance == 0) {
> +		phy->pad_regs = phy->regs;
> +	} else {

Can we use something other than phy->instance here? I see lots of usage
of this field, but we should really be deleting the following code from
ehci-tegra.c, rather the propagating the use of that field.

        /* This is pretty ugly and needs to be fixed when we do only
         * device-tree probing. Old code relies on the platform_device
         * numbering that we lack for device-tree-instantiated devices.
         */
        if (instance < 0) {
                switch (res->start) {
                case TEGRA_USB_BASE:
                        instance = 0;
                        break;
                case TEGRA_USB2_BASE:
                        instance = 1;
                        break;
                case TEGRA_USB3_BASE:
                        instance = 2;
                        break;
                default:
                        err = -ENODEV;
                        dev_err(&pdev->dev, "unknown usb instance\n");
                        goto fail_io;
                }
        }

Still, I suppose the cleanup not to use the instance value could be a
later patch as long as you're aware of the issue and planning to solve it.

> +		phy->pad_regs = ioremap(TEGRA_USB_BASE, TEGRA_USB_SIZE);

Hmmm. Why do we need to remap the registers again? Didn't the EHCI
controller already map them? I'm a little confused what in HW causes the
need for this whole if statement.

> +		if (!phy->pad_regs) {
> +			pr_err("%s: can't remap usb registers\n", __func__);
> +			clk_put(phy->pad_clk);
> +			return -ENOMEM;
> +		}
> +	}

> +static void tegra2_utmi_phy_clk_disable(struct tegra_usb_phy *phy)
> +{
> +	unsigned long val;
> +	void __iomem *base = phy->regs;
> +
> +	if (phy->instance == 0) {

Hmmm. There sure are a lot of places where the code is conditional based
on instance. This seems to be crying out to be split into more ops
functions that get set up once at probe() time and then just used.

> +static int tegra2_utmi_phy_power_off(struct tegra_usb_phy *phy)
> +{
> +	unsigned long val;
> +	void __iomem *base = phy->regs;
> +
> +	tegra2_utmi_phy_clk_disable(phy);
> +
> +	if (phy->mode == TEGRA_USB_PHY_MODE_DEVICE) {

Hmm. Yet here, we have some support for device-mode.

> +static int	tegra2_usb_phy_open(struct tegra_usb_phy *phy)
> +{
> +	struct tegra_ulpi_config *ulpi_config;
> +	int err;
> +
> +	if (phy_is_ulpi(phy)) {

Similarly, this seems like it'd be better as two separate functions,
since there's already an op defined for open.

> +		ulpi_config = phy->config;
> +		phy->clk = clk_get_sys(NULL, ulpi_config->clk);
> +		if (IS_ERR(phy->clk)) {
> +			pr_err("%s: can't get ulpi clock\n", __func__);
> +			err = -ENXIO;
> +			goto err1;
> +		}
> +		if (!gpio_is_valid(ulpi_config->reset_gpio))
> +			ulpi_config->reset_gpio =
> +				of_get_named_gpio(phy->dev->of_node,
> +						  "nvidia,phy-reset-gpio", 0);
> +		if (!gpio_is_valid(ulpi_config->reset_gpio)) {
> +			pr_err("%s: invalid reset gpio: %d\n", __func__,
> +			       ulpi_config->reset_gpio);
> +			err = -EINVAL;
> +			goto err1;
> +		}
> +		gpio_request(ulpi_config->reset_gpio, "ulpi_phy_reset_b");
> +		gpio_direction_output(ulpi_config->reset_gpio, 0);
> +		phy->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, 0);
> +		phy->ulpi->io_priv = phy->regs + ULPI_VIEWPORT;
> +	} else {
> +		err = tegra2_utmip_pad_open(phy);
> +		if (err < 0)
> +			goto err1;
> +	}
> +	return 0;
> +err1:
> +	clk_disable_unprepare(phy->pll_u);
> +	clk_put(phy->pll_u);

In the else clause above, phy->pll_u was never assigned, yet failure
jumps here...

> +	return err;
> +}

> diff --git a/drivers/usb/phy/tegra2_usb_phy.h b/drivers/usb/phy/tegra2_usb_phy.h

> +static const struct tegra_xtal_freq tegra_freq_table[] = {
> +	{
> +		.freq = 12000000,
> +		.enable_delay = 0x02,
...

It doesn't seem like a good idea to put data into a header file.

> diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h

> +struct usb_phy_ops {

Shouldn't that be tegra_usb_phy_ops to avoid namespace collisions?
