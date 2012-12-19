Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2LSFtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 00:49:53 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:51769 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2LSFte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 00:49:34 -0500
MIME-Version: 1.0
In-Reply-To: <1355841786-13307-5-git-send-email-gautam.vivek@samsung.com>
References: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
	<1355841786-13307-5-git-send-email-gautam.vivek@samsung.com>
Date: Wed, 19 Dec 2012 11:11:55 +0530
Message-ID: <CAFp+6iE9vEUvGtHjLyHR_kWgJMgo1xebbj5njUC6939pXcqkYQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] USB: ohci-exynos: Add phy driver support
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: linux-usb@vger.kernel.org
Cc: dianders@chromium.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, stern@rowland.harvard.edu,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        sylvester.nawrocki@gmail.com, jg1.han@samsung.com,
        yulgon.kim@samsung.com, kishon@ti.com, p.paneri@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Doug Anderson.


On Tue, Dec 18, 2012 at 8:13 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Adding the phy-driver to ohci-exynos. Keeping the platform data
> for continuing the smooth operation for boards which still uses it
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/usb/host/ohci-exynos.c |   70 ++++++++++++++++++++++++++++------------
>  1 files changed, 49 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> index 804fb62..c92ab7b 100644
> --- a/drivers/usb/host/ohci-exynos.c
> +++ b/drivers/usb/host/ohci-exynos.c
> @@ -15,6 +15,7 @@
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <linux/platform_data/usb-exynos.h>
> +#include <linux/usb/phy.h>
>  #include <linux/usb/samsung_usb_phy.h>
>  #include <plat/usb-phy.h>
>
> @@ -22,8 +23,34 @@ struct exynos_ohci_hcd {
>         struct device *dev;
>         struct usb_hcd *hcd;
>         struct clk *clk;
> +       struct usb_phy *phy;
> +       struct exynos4_ohci_platdata *pdata;
>  };
>
> +static void exynos_ohci_phy_enable(struct exynos_ohci_hcd *exynos_ohci)
> +{
> +       struct platform_device *pdev = to_platform_device(exynos_ohci->dev);
> +
> +       if (exynos_ohci->phy) {
> +               samsung_usbphy_set_type(exynos_ohci->phy, USB_PHY_TYPE_HOST);
> +               usb_phy_init(exynos_ohci->phy);
> +       } else if (exynos_ohci->pdata->phy_init) {
> +               exynos_ohci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
> +       }
> +}
> +
> +static void exynos_ohci_phy_disable(struct exynos_ohci_hcd *exynos_ohci)
> +{
> +       struct platform_device *pdev = to_platform_device(exynos_ohci->dev);
> +
> +       if (exynos_ohci->phy) {
> +               samsung_usbphy_set_type(exynos_ohci->phy, USB_PHY_TYPE_HOST);
> +               usb_phy_shutdown(exynos_ohci->phy);
> +       } else if (exynos_ohci->pdata->phy_exit) {
> +               exynos_ohci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
> +       }
> +}
> +
>  static int ohci_exynos_reset(struct usb_hcd *hcd)
>  {
>         return ohci_init(hcd_to_ohci(hcd));
> @@ -79,20 +106,15 @@ static u64 ohci_exynos_dma_mask = DMA_BIT_MASK(32);
>
>  static int exynos_ohci_probe(struct platform_device *pdev)
>  {
> -       struct exynos4_ohci_platdata *pdata;
> +       struct exynos4_ohci_platdata *pdata = pdev->dev.platform_data;
>         struct exynos_ohci_hcd *exynos_ohci;
>         struct usb_hcd *hcd;
>         struct ohci_hcd *ohci;
>         struct resource *res;
> +       struct usb_phy *phy;
>         int irq;
>         int err;
>
> -       pdata = pdev->dev.platform_data;
> -       if (!pdata) {
> -               dev_err(&pdev->dev, "No platform data defined\n");
> -               return -EINVAL;
> -       }
> -
>         /*
>          * Right now device-tree probed devices don't get dma_mask set.
>          * Since shared usb code relies on it, set it here for now.
> @@ -108,6 +130,19 @@ static int exynos_ohci_probe(struct platform_device *pdev)
>         if (!exynos_ohci)
>                 return -ENOMEM;
>
> +       phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
> +       if (IS_ERR_OR_NULL(phy)) {
> +               /* Fallback to pdata */
> +               if (!pdata) {
> +                       dev_err(&pdev->dev, "no platform data or transceiver defined\n");
> +                       return -EPROBE_DEFER;
> +               } else {
> +                       exynos_ohci->pdata = pdata;
> +               }
> +       } else {
> +               exynos_ohci->phy = phy;
> +       }
> +
>         exynos_ohci->dev = &pdev->dev;
>
>         hcd = usb_create_hcd(&exynos_ohci_hc_driver, &pdev->dev,
> @@ -153,8 +188,7 @@ static int exynos_ohci_probe(struct platform_device *pdev)
>                 goto fail_io;
>         }
>
> -       if (pdata->phy_init)
> -               pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
> +       exynos_ohci_phy_enable(exynos_ohci);
>
>         ohci = hcd_to_ohci(hcd);
>         ohci_hcd_init(ohci);
> @@ -162,13 +196,15 @@ static int exynos_ohci_probe(struct platform_device *pdev)
>         err = usb_add_hcd(hcd, irq, IRQF_SHARED);
>         if (err) {
>                 dev_err(&pdev->dev, "Failed to add USB HCD\n");
> -               goto fail_io;
> +               goto fail_add_hcd;
>         }
>
>         platform_set_drvdata(pdev, exynos_ohci);
>
>         return 0;
>
> +fail_add_hcd:
> +       exynos_ohci_phy_disable(exynos_ohci);
>  fail_io:
>         clk_disable_unprepare(exynos_ohci->clk);
>  fail_clk:
> @@ -178,14 +214,12 @@ fail_clk:
>
>  static int exynos_ohci_remove(struct platform_device *pdev)
>  {
> -       struct exynos4_ohci_platdata *pdata = pdev->dev.platform_data;
>         struct exynos_ohci_hcd *exynos_ohci = platform_get_drvdata(pdev);
>         struct usb_hcd *hcd = exynos_ohci->hcd;
>
>         usb_remove_hcd(hcd);
>
> -       if (pdata && pdata->phy_exit)
> -               pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
> +       exynos_ohci_phy_disable(exynos_ohci);
>
>         clk_disable_unprepare(exynos_ohci->clk);
>
> @@ -209,8 +243,6 @@ static int exynos_ohci_suspend(struct device *dev)
>         struct exynos_ohci_hcd *exynos_ohci = dev_get_drvdata(dev);
>         struct usb_hcd *hcd = exynos_ohci->hcd;
>         struct ohci_hcd *ohci = hcd_to_ohci(hcd);
> -       struct platform_device *pdev = to_platform_device(dev);
> -       struct exynos4_ohci_platdata *pdata = pdev->dev.platform_data;
>         unsigned long flags;
>         int rc = 0;
>
> @@ -229,8 +261,7 @@ static int exynos_ohci_suspend(struct device *dev)
>
>         clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
>
> -       if (pdata && pdata->phy_exit)
> -               pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
> +       exynos_ohci_phy_disable(exynos_ohci);
>
>         clk_disable_unprepare(exynos_ohci->clk);
>
> @@ -244,13 +275,10 @@ static int exynos_ohci_resume(struct device *dev)
>  {
>         struct exynos_ohci_hcd *exynos_ohci = dev_get_drvdata(dev);
>         struct usb_hcd *hcd = exynos_ohci->hcd;
> -       struct platform_device *pdev = to_platform_device(dev);
> -       struct exynos4_ohci_platdata *pdata = pdev->dev.platform_data;
>
>         clk_prepare_enable(exynos_ohci->clk);
>
> -       if (pdata && pdata->phy_init)
> -               pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
> +       exynos_ohci_phy_enable(exynos_ohci);
>
>         ohci_resume(hcd, false);
>
> --
> 1.7.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks & Regards
Vivek
