Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab2IUNJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:09:42 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:45476 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754587Ab2IUNJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:09:40 -0400
MIME-Version: 1.0
In-Reply-To: <1348230054-7402-1-git-send-email-vbyravarasu@nvidia.com>
References: <1348230054-7402-1-git-send-email-vbyravarasu@nvidia.com>
Date: Fri, 21 Sep 2012 18:39:37 +0530
Message-ID: <CAAe_U6K2hANpRqzyoiiP2mR97=M2Mb35+FVor11DaaZi7W9Pnw@mail.gmail.com>
Subject: Re: [PATCH v3] USB: PHY: Re-organize Tegra USB PHY driver
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 21, 2012 at 5:50 PM, Venu Byravarasu <vbyravarasu@nvidia.com> wrote:
> NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
> In order to support USB PHY drivers on these SoCs, existing
> PHY driver is split into SoC agnostic common USB PHY driver
> and Tegra20-specific USB phy driver. This will facilitate
> easy addition and deletion of phy drivers for Tegra SoCs.
>
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
> delta from v2:
>
> Added an if condition to check for device_node to be not NULL,
> before dereferencing it.
>
>  drivers/usb/host/ehci-tegra.c                      |   26 +-
>  drivers/usb/phy/Makefile                           |    1 +
>  .../usb/phy/{tegra_usb_phy.c => tegra2_usb_phy.c}  |  421 +++----------
>  drivers/usb/phy/tegra2_usb_phy.h                   |  140 ++++
>  drivers/usb/phy/tegra_usb_phy.c                    |  688 +-------------------
>  include/linux/usb/tegra_usb_phy.h                  |   34 +-
>  6 files changed, 298 insertions(+), 1012 deletions(-)
>  copy drivers/usb/phy/{tegra_usb_phy.c => tegra2_usb_phy.c} (53%)
>  create mode 100644 drivers/usb/phy/tegra2_usb_phy.h
>
> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index 6223d17..8199a6e 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -618,6 +618,9 @@ static int tegra_ehci_probe(struct platform_device *pdev)
>         int err = 0;
>         int irq;
>         int instance = pdev->id;
> +       struct device_node *np = pdev->dev.of_node;
> +       struct phy_params params;
> +       int phy_type;
>
>         pdata = pdev->dev.platform_data;
>         if (!pdata) {
> @@ -701,14 +704,29 @@ static int tegra_ehci_probe(struct platform_device *pdev)
>                         break;
>                 default:
>                         err = -ENODEV;
> -                       dev_err(&pdev->dev, "unknown usb instance\n");
> +                       dev_err(&pdev->dev, "unknown usb inst:%d\n", instance);
>                         goto fail_io;
>                 }
>         }
>
> +       if (np) {
> +               phy_type = of_property_match_string(np, "phy_type", "utmi");
> +               if (phy_type >= 0)
> +                       params.type = TEGRA_USB_PHY_TYPE_UTMI;
> +               else {
> +                       phy_type = of_property_match_string(np, "phy_type", "ulpi");
> +                       if (phy_type >= 0)
> +                               params.type = TEGRA_USB_PHY_TYPE_ULPI;
> +                       else
> +                               params.type = TEGRA_USB_PHY_TYPE_INVALID;
> +               }
> +       }
> +
> +       params.mode = TEGRA_USB_PHY_MODE_HOST;
> +       params.config = pdata->phy_config;

I fail to understand how pdata is not NULL in dt boot. I know i've
already given this comment and you replied that you dint see any
crash. But I'd like to know where and how pdata gets populated.

Thanks
Kishon
