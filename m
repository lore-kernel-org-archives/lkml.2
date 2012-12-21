Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab2LURFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 12:05:35 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:44227 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2LURFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 12:05:30 -0500
MIME-Version: 1.0
In-Reply-To: <1356077779-5759-2-git-send-email-gautam.vivek@samsung.com>
References: <1356077779-5759-1-git-send-email-gautam.vivek@samsung.com>
	<1356077779-5759-2-git-send-email-gautam.vivek@samsung.com>
Date: Fri, 21 Dec 2012 09:05:24 -0800
Message-ID: <CAD=FV=VQ0PgwaF-hX1jht9Lub0_WbH-_+WhWzOzPyZ2jK9HaHw@mail.gmail.com>
Subject: Re: [PATCH v3] usb: phy: samsung: Add support to set pmu isolation
From: Doug Anderson <dianders@chromium.org>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Thomas Abraham <thomas.abraham@linaro.org>, t.figa@samsung.com,
        Ben Dooks <ben-linux@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        l.majewski@samsung.com, kyungmin.park@samsung.com,
        Grant Likely <grant.likely@secretlab.ca>, heiko@sntech.de,
        Praveen Paneri <p.paneri@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek,

Nothing really serious below and things look good to me, but figured
I'd put a few nits in (sorry!).


On Fri, Dec 21, 2012 at 12:16 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> index 7b26e2d..09f06f8 100644
> --- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> +++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> @@ -9,3 +9,31 @@ Required properties:
>  - compatible : should be "samsung,exynos4210-usbphy"
>  - reg : base physical address of the phy registers and length of memory mapped
>         region.
> +- #address-cells: should be 1.
> +- #size-cells: should be 0.

Doesn't match your example.  Probably should be 1.

> diff --git a/drivers/usb/phy/samsung-usbphy.c b/drivers/usb/phy/samsung-usbphy.c
> index 5c5e1bb5..2260029 100644
> --- a/drivers/usb/phy/samsung-usbphy.c
> +++ b/drivers/usb/phy/samsung-usbphy.c
>  /*
> + * struct samsung_usbphy_drvdata - driver data for various SoC variants
> + * @cpu_type: machine identifier
> + * @devphy_en_mask: device phy enable mask for PHY CONTROL register
> + * @hostphy_en_mask: host phy enable mask for PHY CONTROL register
> + *
> + *     having different mask for host and device type phy
> + *     helps in setting independent masks in case of SoCs like
> + *     S5PV210 in which PHY0 and PHY1 enable bits belong to same
> + *     register placed at [0] and [1] respectively.
> + *     Although for newer SoCs like exynos these bits belong to
> + *     different registers altogether placed at [0].
> + */
> +struct samsung_usbphy_drvdata {
> +       int cpu_type;
> +       int devphy_en_mask;

This is really a "devphy_dis_mask", isn't it?  AKA: setting to 1
disables the phy and setting to 0 enables the phy.

> +       int hostphy_en_mask;

Code below always uses devphy and only ever inits devphy.  I assume
future code will init / use hostphy?  Worth moving the hostphy part in
that patch?

>  struct samsung_usbphy {
>         struct usb_phy  phy;
> @@ -81,12 +104,66 @@ struct samsung_usbphy {
>         struct device   *dev;
>         struct clk      *clk;
>         void __iomem    *regs;
> +       void __iomem    *phyctrl_pmureg;
>         int             ref_clk_freq;
> -       int             cpu_type;
> +       struct samsung_usbphy_drvdata *drv_data;

nit: const

> +static int samsung_usbphy_parse_dt_param(struct samsung_usbphy *sphy)
> +{
> +       struct device_node *usbphy_pmu;
> +       u32 reg[2];
> +       int ret;
> +
> +       if (!sphy->dev->of_node) {
> +               dev_err(sphy->dev, "Can't get usb-phy node\n");
> +               return -ENODEV;
> +       }
> +
> +       usbphy_pmu = of_get_child_by_name(sphy->dev->of_node, "usbphy-pmu");
> +       if (!usbphy_pmu)
> +               dev_warn(sphy->dev, "Can't get usb-phy pmu control node\n");
> +
> +       ret = of_property_read_u32_array(usbphy_pmu, "reg", reg, 2);

nit: use ARRAY_SIZE(reg)

> +       if (!ret)
> +               sphy->phyctrl_pmureg = ioremap(reg[0], reg[1]);
> +
> +       of_node_put(usbphy_pmu);
> +
> +       if (IS_ERR_OR_NULL(sphy->phyctrl_pmureg)) {
> +               dev_err(sphy->dev, "Can't get usb-phy pmu control register\n");

I don't think there's any cases where it matters (you'll error out of
the driver if you return an error here), but seems like it might be
nice to set sphy->phyctrl_pmureg to NULL here since other places test
this member against NULL only.

> +static inline struct samsung_usbphy_drvdata
> +*samsung_usbphy_get_driver_data(struct platform_device *pdev)
>  {
>         if (pdev->dev.of_node) {
>                 const struct of_device_id *match;
>                 match = of_match_node(samsung_usbphy_dt_match,
>                                                         pdev->dev.of_node);
> -               return (int) match->data;
> +               return (struct samsung_usbphy_drvdata *) match->data;

nit: no need for a cast here, I believe.

>         }
>
> -       return platform_get_device_id(pdev)->driver_data;
> +       return ((struct samsung_usbphy_drvdata *)
> +                               platform_get_device_id(pdev)->driver_data);

nit: no need for a cast here, I believe.

> +static struct samsung_usbphy_drvdata usbphy_s3c64xx = {
> +       .cpu_type               = TYPE_S3C64XX,
> +       .devphy_en_mask         = S3C64XX_USBPHY_ENABLE,
> +};
> +
> +static struct samsung_usbphy_drvdata usbphy_exynos4 = {
> +       .cpu_type               = TYPE_EXYNOS4210,
> +       .devphy_en_mask         = EXYNOS_USBPHY_ENABLE,
> +};
> +

nit: static const for these structs?



-Doug
