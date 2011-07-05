Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1GERqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:46:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47346 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab1GERqJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:46:09 -0400
MIME-Version: 1.0
In-Reply-To: <1309879166-25788-4-git-send-email-shawn.guo@linaro.org>
References: <1309879166-25788-1-git-send-email-shawn.guo@linaro.org> <1309879166-25788-4-git-send-email-shawn.guo@linaro.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 5 Jul 2011 11:45:49 -0600
X-Google-Sender-Auth: _62nqLz4awSm7n6hMA29UnxkCFI
Message-ID: <CACxGe6tRuyW0NjyiB2T+uAZ-NvJxwBVJOB0R3u_k-_DOkqmtdg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] gpio/mxc: add device tree probe support
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        patches@linaro.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 9:19 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> The patch adds device tree probe support for gpio-mxc driver.
>
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Looks right to me.

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  .../devicetree/bindings/gpio/fsl-imx-gpio.txt      |   22 ++++++++++++++++++++
>  drivers/gpio/gpio-mxc.c                            |   18 +++++++++++++++-
>  2 files changed, 39 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/gpio/fsl-imx-gpio.txt
>
> diff --git a/Documentation/devicetree/bindings/gpio/fsl-imx-gpio.txt b/Documentation/devicetree/bindings/gpio/fsl-imx-gpio.txt
> new file mode 100644
> index 0000000..4363ae4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/fsl-imx-gpio.txt
> @@ -0,0 +1,22 @@
> +* Freescale i.MX/MXC GPIO controller
> +
> +Required properties:
> +- compatible : Should be "fsl,<soc>-gpio"
> +- reg : Address and length of the register set for the device
> +- interrupts : Should be the port interrupt shared by all 32 pins, if
> +  one number.  If two numbers, the first one is the interrupt shared
> +  by low 16 pins and the second one is for high 16 pins.
> +- gpio-controller : Marks the device node as a gpio controller.
> +- #gpio-cells : Should be two.  The first cell is the pin number and
> +  the second cell is used to specify optional parameters (currently
> +  unused).
> +
> +Example:
> +
> +gpio0: gpio@73f84000 {
> +       compatible = "fsl,imx51-gpio", "fsl,imx31-gpio";
> +       reg = <0x73f84000 0x4000>;
> +       interrupts = <50 51>;
> +       gpio-controller;
> +       #gpio-cells = <2>;
> +};
> diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
> index 4875690..059d44a 100644
> --- a/drivers/gpio/gpio-mxc.c
> +++ b/drivers/gpio/gpio-mxc.c
> @@ -27,6 +27,8 @@
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
>  #include <linux/basic_mmio_gpio.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <asm-generic/bug.h>
>
>  enum mxc_gpio_hwtype {
> @@ -126,6 +128,13 @@ static struct platform_device_id mxc_gpio_devtype[] = {
>        }
>  };
>
> +static const struct of_device_id mxc_gpio_dt_ids[] = {
> +       { .compatible = "fsl,imx1-gpio", .data = &mxc_gpio_devtype[IMX1_GPIO], },
> +       { .compatible = "fsl,imx21-gpio", .data = &mxc_gpio_devtype[IMX2_GPIO], },
> +       { .compatible = "fsl,imx31-gpio", .data = &mxc_gpio_devtype[IMX_GPIO], },
> +       { /* sentinel */ }
> +};
> +
>  /*
>  * MX2 has one interrupt *for all* gpio ports. The list is used
>  * to save the references to all ports, so that mx2_gpio_irq_handler
> @@ -308,7 +317,13 @@ static void __init mxc_gpio_init_gc(struct mxc_gpio_port *port)
>
>  static void __devinit mxc_gpio_get_hw(struct platform_device *pdev)
>  {
> -       enum mxc_gpio_hwtype hwtype = pdev->id_entry->driver_data;
> +       const struct of_device_id *of_id =
> +                       of_match_device(mxc_gpio_dt_ids, &pdev->dev);
> +       enum mxc_gpio_hwtype hwtype;
> +
> +       if (of_id)
> +               pdev->id_entry = of_id->data;
> +       hwtype = pdev->id_entry->driver_data;
>
>        if (mxc_gpio_hwtype) {
>                /*
> @@ -426,6 +441,7 @@ static struct platform_driver mxc_gpio_driver = {
>        .driver         = {
>                .name   = "gpio-mxc",
>                .owner  = THIS_MODULE,
> +               .of_match_table = mxc_gpio_dt_ids,
>        },
>        .probe          = mxc_gpio_probe,
>        .id_table       = mxc_gpio_devtype,
> --
> 1.7.4.1
>
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
