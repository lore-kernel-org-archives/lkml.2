Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2LSXbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:31:14 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:45082 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab2LSXbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:31:03 -0500
X-Greylist: delayed 6138 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 18:31:03 EST
MIME-Version: 1.0
In-Reply-To: <1355841786-13307-4-git-send-email-gautam.vivek@samsung.com>
References: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
	<1355841786-13307-4-git-send-email-gautam.vivek@samsung.com>
Date: Wed, 19 Dec 2012 15:30:58 -0800
Message-ID: <CAD=FV=WLVpwBo1g41BYwMUdedN3MJcmfaWwYow=RfsLC5bX1jg@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] USB: ehci-s5p: Add phy driver support
From: Doug Anderson <dianders@chromium.org>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, yulgon.kim@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Praveen Paneri <p.paneri@samsung.com>, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, jg1.han@samsung.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        balbi@ti.com, kishon@ti.com, Kukjin Kim <kgene.kim@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Rob Herring <rob.herring@calxeda.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek,

Again, not a high-level review, but...


On Tue, Dec 18, 2012 at 6:43 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Adding the phy driver to ehci-s5p. Keeping the platform data
> for continuing the smooth operation for boards which still uses it
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/usb/host/ehci-s5p.c |   70 ++++++++++++++++++++++++++++++-------------
>  1 files changed, 49 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
> index 46ca5ef..50c93af 100644
> --- a/drivers/usb/host/ehci-s5p.c
> +++ b/drivers/usb/host/ehci-s5p.c
> @@ -17,6 +17,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/of_gpio.h>
>  #include <linux/platform_data/usb-ehci-s5p.h>
> +#include <linux/usb/phy.h>
>  #include <linux/usb/samsung_usb_phy.h>
>  #include <plat/usb-phy.h>
>
> @@ -33,6 +34,8 @@ struct s5p_ehci_hcd {
>         struct device *dev;
>         struct usb_hcd *hcd;
>         struct clk *clk;
> +       struct usb_phy *phy;
> +       struct s5p_ehci_platdata *pdata;
>  };
>
>  static const struct hc_driver s5p_ehci_hc_driver = {
> @@ -66,6 +69,30 @@ static const struct hc_driver s5p_ehci_hc_driver = {
>         .clear_tt_buffer_complete       = ehci_clear_tt_buffer_complete,
>  };
>
> +static void s5p_ehci_phy_enable(struct s5p_ehci_hcd *s5p_ehci)
> +{
> +       struct platform_device *pdev = to_platform_device(s5p_ehci->dev);
> +
> +       if (s5p_ehci->phy) {
> +               samsung_usbphy_set_type(s5p_ehci->phy, USB_PHY_TYPE_HOST);

This confuses me.  Why are you setting the type to host here?

> +               usb_phy_init(s5p_ehci->phy);
> +       } else if (s5p_ehci->pdata->phy_init) {
> +               s5p_ehci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
> +       }
> +}
> +
> +static void s5p_ehci_phy_disable(struct s5p_ehci_hcd *s5p_ehci)
> +{
> +       struct platform_device *pdev = to_platform_device(s5p_ehci->dev);
> +
> +       if (s5p_ehci->phy) {
> +               samsung_usbphy_set_type(s5p_ehci->phy, USB_PHY_TYPE_HOST);

...and why set it to host here?

> +               usb_phy_shutdown(s5p_ehci->phy);
> +       } else if (s5p_ehci->pdata->phy_exit) {
> +               s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
> +       }
> +}
> +
>  static void s5p_setup_vbus_gpio(struct platform_device *pdev)
>  {
>         int err;
> @@ -88,20 +115,15 @@ static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
>
>  static int s5p_ehci_probe(struct platform_device *pdev)
>  {
> -       struct s5p_ehci_platdata *pdata;
> +       struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
>         struct s5p_ehci_hcd *s5p_ehci;
>         struct usb_hcd *hcd;
>         struct ehci_hcd *ehci;
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
> @@ -119,6 +141,19 @@ static int s5p_ehci_probe(struct platform_device *pdev)
>         if (!s5p_ehci)
>                 return -ENOMEM;
>
> +       phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
> +       if (IS_ERR_OR_NULL(phy)) {
> +               /* Fallback to pdata */
> +               if (!pdata) {
> +                       dev_err(&pdev->dev, "no platform data or transceiver defined\n");
> +                       return -EPROBE_DEFER;

Shouldn't you return -EINVAL like the old code did?

> +               } else {
> +                       s5p_ehci->pdata = pdata;
> +               }
> +       } else {
> +               s5p_ehci->phy = phy;
> +       }
> +
>         s5p_ehci->dev = &pdev->dev;
>
>         hcd = usb_create_hcd(&s5p_ehci_hc_driver, &pdev->dev,
> @@ -164,8 +199,7 @@ static int s5p_ehci_probe(struct platform_device *pdev)
>                 goto fail_io;
>         }
>
> -       if (pdata->phy_init)
> -               pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
> +       s5p_ehci_phy_enable(s5p_ehci);
>
>         ehci = hcd_to_ehci(hcd);
>         ehci->caps = hcd->regs;
> @@ -176,13 +210,15 @@ static int s5p_ehci_probe(struct platform_device *pdev)
>         err = usb_add_hcd(hcd, irq, IRQF_SHARED);
>         if (err) {
>                 dev_err(&pdev->dev, "Failed to add USB HCD\n");
> -               goto fail_io;
> +               goto fail_add_hcd;
>         }
>
>         platform_set_drvdata(pdev, s5p_ehci);
>
>         return 0;
>
> +fail_add_hcd:
> +       s5p_ehci_phy_disable(s5p_ehci);
>  fail_io:
>         clk_disable_unprepare(s5p_ehci->clk);
>  fail_clk:
> @@ -192,14 +228,12 @@ fail_clk:
>
>  static int s5p_ehci_remove(struct platform_device *pdev)
>  {
> -       struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
>         struct s5p_ehci_hcd *s5p_ehci = platform_get_drvdata(pdev);
>         struct usb_hcd *hcd = s5p_ehci->hcd;
>
>         usb_remove_hcd(hcd);
>
> -       if (pdata && pdata->phy_exit)
> -               pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
> +       s5p_ehci_phy_disable(s5p_ehci);
>
>         clk_disable_unprepare(s5p_ehci->clk);
>
> @@ -223,14 +257,11 @@ static int s5p_ehci_suspend(struct device *dev)
>         struct s5p_ehci_hcd *s5p_ehci = dev_get_drvdata(dev);
>         struct usb_hcd *hcd = s5p_ehci->hcd;
>         bool do_wakeup = device_may_wakeup(dev);
> -       struct platform_device *pdev = to_platform_device(dev);
> -       struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
>         int rc;
>
>         rc = ehci_suspend(hcd, do_wakeup);
>
> -       if (pdata && pdata->phy_exit)
> -               pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
> +       s5p_ehci_phy_disable(s5p_ehci);
>
>         clk_disable_unprepare(s5p_ehci->clk);
>
> @@ -241,13 +272,10 @@ static int s5p_ehci_resume(struct device *dev)
>  {
>         struct s5p_ehci_hcd *s5p_ehci = dev_get_drvdata(dev);
>         struct usb_hcd *hcd = s5p_ehci->hcd;
> -       struct platform_device *pdev = to_platform_device(dev);
> -       struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
>
>         clk_prepare_enable(s5p_ehci->clk);
>
> -       if (pdata && pdata->phy_init)
> -               pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
> +       s5p_ehci_phy_enable(s5p_ehci);
>
>         /* DMA burst Enable */
>         writel(EHCI_INSNREG00_ENABLE_DMA_BURST, EHCI_INSNREG00(hcd->regs));
> --
> 1.7.6.5
>
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
