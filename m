Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab1GUDlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 23:41:10 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:53396 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab1GUDlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 23:41:08 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <1311218619-11174-1-git-send-email-achew@nvidia.com>
References: <1311218619-11174-1-git-send-email-achew@nvidia.com>
Date: Wed, 20 Jul 2011 20:41:05 -0700
Message-ID: <CAOesGMizAxjcNUBPCeeVgYEbLZB4P+0znua7TjhbqUNn91hgGw@mail.gmail.com>
Subject: Re: [PATCH 1/3 v3] usb: tegra20-ehci: Add devicetree support.
From: Olof Johansson <olof@lixom.net>
To: achew@nvidia.com
Cc: grant.likely@secretlab.ca, swarren@nvidia.com, dwillemsen@nvidia.com,
        rklein@nvidia.com, mogantyv@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 20, 2011 at 8:23 PM,  <achew@nvidia.com> wrote:

> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index 02b2bfd..67c16e5 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -21,10 +21,32 @@
>  #include <linux/platform_data/tegra_usb.h>
>  #include <linux/irq.h>
>  #include <linux/usb/otg.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_platform.h>
> +
>  #include <mach/usb_phy.h>
>
>  #define TEGRA_USB_DMA_ALIGN 32
>
> +static u64 tegra_ehci_dmamask = DMA_BIT_MASK(TEGRA_USB_DMA_ALIGN);
> +
> +static struct tegra_utmip_config utmi_default = {

__initdata, no need to keep this around after setup.

You're also going to get a warning if you build without CONFIG_OF due
to a local static variable that is not referenced, I think.

> +       .hssync_start_delay = 9,
> +       .idle_wait_delay = 17,
> +       .elastic_limit = 16,
> +       .term_range_adj = 6,
> +       .xcvr_setup = 9,
> +       .xcvr_lsfslew = 2,
> +       .xcvr_lsrslew = 2,
> +};
> +
> +static struct tegra_ulpi_config ulpi_default = {

Same here.

> +       .reset_gpio = 169,
> +       .clk = "cdev2",
> +};
> +
>  struct tegra_ehci_hcd {
>        struct ehci_hcd *ehci;
>        struct tegra_usb_phy *phy;
> @@ -574,9 +596,155 @@ static const struct hc_driver tegra_ehci_hc_driver = {
>        .port_handed_over       = ehci_port_handed_over,
>  };
>
> +#if defined(CONFIG_OF)
> +static int tegra_ehci_parse_dt_node_utmi(struct device_node *dn,
> +                                        struct platform_device *pdev,
> +                                        struct tegra_ehci_platform_data *pdata)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct tegra_utmip_config *phy_config;
> +       u32 val;
> +
> +       phy_config = devm_kzalloc(dev, sizeof(struct tegra_utmip_config),
> +                                 GFP_KERNEL);
> +       if (!phy_config)
> +               return -ENOMEM;
> +
> +       /* Copy default values. */
> +       memcpy(phy_config, &utmi_default, sizeof(struct tegra_utmip_config));

Nit: Doing *phy_config = utmi_default;   here would do type checking
for you. But it's not a big deal.



-Olof
