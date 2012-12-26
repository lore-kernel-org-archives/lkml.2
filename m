Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab2LZW5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 17:57:45 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50622 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2LZW5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 17:57:42 -0500
Message-ID: <50DB7A83.3010508@gmail.com>
Date: Wed, 26 Dec 2012 23:30:27 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, kgene.kim@samsung.com, thomas.abraham@linaro.org,
        t.figa@samsung.com, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com, l.majewski@samsung.com,
        kyungmin.park@samsung.com, grant.likely@secretlab.ca, heiko@sntech.de,
        dianders@chromium.org, p.paneri@samsung.com
Subject: Re: [PATCH v4] usb: phy: samsung: Add support to set pmu isolation
References: <1356524912-4736-1-git-send-email-gautam.vivek@samsung.com> <1356524912-4736-2-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1356524912-4736-2-git-send-email-gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2012 01:28 PM, Vivek Gautam wrote:
> Adding support to parse device node data in order to get
> required properties to set pmu isolation for usb-phy.
>
> Signed-off-by: Vivek Gautam<gautam.vivek@samsung.com>
> ---
>   .../devicetree/bindings/usb/samsung-usbphy.txt     |   31 ++++
>   drivers/usb/phy/samsung-usbphy.c                   |  145 +++++++++++++++++---
>   2 files changed, 155 insertions(+), 21 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> index 7b26e2d..6b873fd 100644
> --- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> +++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> @@ -9,3 +9,34 @@ Required properties:
>   - compatible : should be "samsung,exynos4210-usbphy"
>   - reg : base physical address of the phy registers and length of memory mapped
>   	region.
> +
> +Optional properties:
> +- #address-cells: should be '1' when usbphy node has a child node with 'reg'
> +		  property.
> +- #size-cells: should be '1' when usbphy node has a child node with 'reg'
> +	       property.
> +
> +- The child node 'usbphy-pmu' to the node usbphy should provide the following
> +  information required by usb-phy controller to enable/disable the phy.
> +   - reg : base physical address of PHY control register in PMU which
> +           enables/disables the phy controller.
> +           The size of this register is the total sum of size of all phy-control
> +           registers that the SoC has. For example, the size will be
> +           '0x4' in case we have only one phy-control register (like in S3C64XX) or
> +           '0x8' in case we have two phy-control registers (like in Exynos4210)
> +           and so on.
> +
> +Example:
> + - Exysno4210

s/Exysno/Exynos

> +
> +	usbphy@125B0000 {
> +		#address-cells =<1>;
> +		#size-cells =<1>;
> +		compatible = "samsung,exynos4210-usbphy";
> +		reg =<0x125B0000 0x100>;
> +
> +		usbphy-pmu {
> +			/* USB device and host PHY_CONTROL registers */
> +			reg =<0x10020704 0x8>;
> +		};
> +	};
> diff --git a/drivers/usb/phy/samsung-usbphy.c b/drivers/usb/phy/samsung-usbphy.c
> index 5c5e1bb5..b9f4f42 100644
> --- a/drivers/usb/phy/samsung-usbphy.c
> +++ b/drivers/usb/phy/samsung-usbphy.c
> @@ -60,20 +60,42 @@
>   #define MHZ (1000*1000)
>   #endif
>
> +#define S3C64XX_USBPHY_ENABLE			(0x1<<  16)
> +#define EXYNOS_USBPHY_ENABLE			(0x1<<  0)
> +
>   enum samsung_cpu_type {
>   	TYPE_S3C64XX,
>   	TYPE_EXYNOS4210,
>   };
>
>   /*
> + * struct samsung_usbphy_drvdata - driver data for various SoC variants
> + * @cpu_type: machine identifier
> + * @devphy_en_mask: device phy enable mask for PHY CONTROL register
> + *
> + *	Here we have a separate mask for device type phy.
> + *	Having different masks for host and device type phy helps
> + *	in setting independent masks in case of SoCs like S5PV210,
> + *	in which PHY0 and PHY1 enable bits belong to same register
> + *	placed at [0] and [1] respectively.

"and are placed at positions 0 and 1 respectively" ?

> + *	Although for newer SoCs like exynos these bits belong to
> + *	different registers altogether placed at [0].
> + */
> +struct samsung_usbphy_drvdata {
> +	int cpu_type;
> +	int devphy_en_mask;
> +};
> +
> +/*
>    * struct samsung_usbphy - transceiver driver state
>    * @phy: transceiver structure
>    * @plat: platform data
>    * @dev: The parent device supplied to the probe function
>    * @clk: usb phy clock
>    * @regs: usb phy register memory base
> + * @phyctrl_pmureg: usb device phy-control pmu register memory base

nit: Perhaps we could just call it "pmureg' ?

>    * @ref_clk_freq: reference clock frequency selection
> - * @cpu_type: machine identifier
> + * @drv_data: driver data available for different cpu types

Actually it's for different SoCs, not CPUs, right ?

>    */
>   struct samsung_usbphy {
>   	struct usb_phy	phy;
> @@ -81,12 +103,67 @@ struct samsung_usbphy {
>   	struct device	*dev;
>   	struct clk	*clk;
>   	void __iomem	*regs;
> +	void __iomem	*phyctrl_pmureg;
>   	int		ref_clk_freq;
> -	int		cpu_type;
> +	const struct samsung_usbphy_drvdata *drv_data;
>   };
>
>   #define phy_to_sphy(x)		container_of((x), struct samsung_usbphy, phy)
>
> +static int samsung_usbphy_parse_dt_param(struct samsung_usbphy *sphy)

nit: s/samsung_usbphy_parse_dt_param/samsung_usbphy_parse_dt ?

> +{
> +	struct device_node *usbphy_pmu;
> +	u32 reg[2];
> +	int ret;
> +
> +	if (!sphy->dev->of_node) {
> +		dev_err(sphy->dev, "Can't get usb-phy node\n");
> +		return -ENODEV;

The function is called only when dev->of_node is not NULL, so this path
is never executed, AFAICS. I would just drop this redundant check.

> +	}
> +
> +	usbphy_pmu = of_get_child_by_name(sphy->dev->of_node, "usbphy-pmu");
> +	if (!usbphy_pmu)
> +		dev_warn(sphy->dev, "Can't get usb-phy pmu control node\n");

> +	ret = of_property_read_u32_array(usbphy_pmu, "reg", reg,
> +						ARRAY_SIZE(reg));
> +	if (!ret)
> +		sphy->phyctrl_pmureg = ioremap(reg[0], reg[1]);

I don't think this is correct. reg is not really an array of u32 type,
it's an array of address/size tuples. I thought you would use of_iomap()
here. Any reason why you didn't do so ? It would also make it easier to
handle multiple address/size pairs if required.

> +
> +	of_node_put(usbphy_pmu);
> +
> +	if (IS_ERR_OR_NULL(sphy->phyctrl_pmureg)) {

When is sphy->phyctrl_pmureg assigned a ERR_PTR() value ? Wouldn't it
be enough to simply check for NULL ?

> +		dev_err(sphy->dev, "Can't get usb-phy pmu control register\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Set isolation here for phy.
> + * SOCs control this by controlling corresponding PMU registers
> + */
> +static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, int on)
> +{
> +	u32 reg;
> +	int en_mask;
> +
> +	if (!sphy->phyctrl_pmureg) {
> +		dev_warn(sphy->dev, "Can't set pmu isolation\n");
> +		return;
> +	}
> +
> +	reg = readl(sphy->phyctrl_pmureg);

To make it more generic maybe it's worth to store an offset to the actual
register somewhere, e.g. in the driver_data struct ? This function is
supposed to handle both device and host PHYs, isn't it ?

> +	en_mask = sphy->drv_data->devphy_en_mask;
> +
> +	if (on)
> +		writel(reg&  ~en_mask, sphy->phyctrl_pmureg);
> +	else
> +		writel(reg | en_mask, sphy->phyctrl_pmureg);

nit: This could be also written as:

	reg = on ? reg & ~mask : reg | mask;
	writel(reg, sphy->phyctrl_pmureg);
> +}
> +
>   /*
>    * Returns reference clock frequency selection value
>    */
> @@ -112,7 +189,7 @@ static int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy)
>   		refclk_freq = PHYCLK_CLKSEL_48M;
>   		break;
>   	default:
> -		if (sphy->cpu_type == TYPE_S3C64XX)
> +		if (sphy->drv_data->cpu_type == TYPE_S3C64XX)
>   			refclk_freq = PHYCLK_CLKSEL_48M;
>   		else
>   			refclk_freq = PHYCLK_CLKSEL_24M;
> @@ -135,7 +212,7 @@ static void samsung_usbphy_enable(struct samsung_usbphy *sphy)
>   	phypwr = readl(regs + SAMSUNG_PHYPWR);
>   	rstcon = readl(regs + SAMSUNG_RSTCON);
>
> -	switch (sphy->cpu_type) {
> +	switch (sphy->drv_data->cpu_type) {
>   	case TYPE_S3C64XX:
>   		phyclk&= ~PHYCLK_COMMON_ON_N;
>   		phypwr&= ~PHYPWR_NORMAL_MASK;
> @@ -165,7 +242,7 @@ static void samsung_usbphy_disable(struct samsung_usbphy *sphy)
>
>   	phypwr = readl(regs + SAMSUNG_PHYPWR);
>
> -	switch (sphy->cpu_type) {
> +	switch (sphy->drv_data->cpu_type) {
>   	case TYPE_S3C64XX:
>   		phypwr |= PHYPWR_NORMAL_MASK;
>   		break;
> @@ -199,6 +276,8 @@ static int samsung_usbphy_init(struct usb_phy *phy)
>   	/* Disable phy isolation */
>   	if (sphy->plat&&  sphy->plat->pmu_isolation)
>   		sphy->plat->pmu_isolation(false);
> +	else
> +		samsung_usbphy_set_isolation(sphy, false);
>
>   	/* Initialize usb phy registers */
>   	samsung_usbphy_enable(sphy);
> @@ -228,38 +307,37 @@ static void samsung_usbphy_shutdown(struct usb_phy *phy)
>   	/* Enable phy isolation */
>   	if (sphy->plat&&  sphy->plat->pmu_isolation)
>   		sphy->plat->pmu_isolation(true);
> +	else
> +		samsung_usbphy_set_isolation(sphy, true);
>
>   	clk_disable_unprepare(sphy->clk);
>   }
>
>   static const struct of_device_id samsung_usbphy_dt_match[];
>
> -static inline int samsung_usbphy_get_driver_data(struct platform_device *pdev)
> +static inline struct samsung_usbphy_drvdata
> +*samsung_usbphy_get_driver_data(struct platform_device *pdev)
>   {
>   	if (pdev->dev.of_node) {
>   		const struct of_device_id *match;
>   		match = of_match_node(samsung_usbphy_dt_match,
>   							pdev->dev.of_node);
> -		return (int) match->data;
> +		return (struct samsung_usbphy_drvdata *) match->data;
>   	}
>
> -	return platform_get_device_id(pdev)->driver_data;
> +	return (struct samsung_usbphy_drvdata *)
> +				platform_get_device_id(pdev)->driver_data;
>   }
>
>   static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
>   {
>   	struct samsung_usbphy *sphy;
> -	struct samsung_usbphy_data *pdata;
> +	struct samsung_usbphy_data *pdata = pdev->dev.platform_data;
>   	struct device *dev =&pdev->dev;
>   	struct resource *phy_mem;
>   	void __iomem	*phy_base;
>   	struct clk *clk;
> -
> -	pdata = pdev->dev.platform_data;
> -	if (!pdata) {
> -		dev_err(&pdev->dev, "%s: no platform data defined\n", __func__);
> -		return -EINVAL;
> -	}
> +	int ret;
>
>   	phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>   	if (!phy_mem) {
> @@ -283,7 +361,19 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
>   		return PTR_ERR(clk);
>   	}
>
> -	sphy->dev		=&pdev->dev;
> +	sphy->dev = dev;
> +
> +	if (dev->of_node) {
> +		ret = samsung_usbphy_parse_dt_param(sphy);
> +		if (ret<  0)
> +			return ret;
> +	} else {
> +		if (!pdata) {
> +			dev_err(dev, "no platform data specified\n");
> +			return -EINVAL;
> +		}
> +	}
> +
>   	sphy->plat		= pdata;
>   	sphy->regs		= phy_base;
>   	sphy->clk		= clk;

--

Thanks,
Sylwester
