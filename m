Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1H3Hwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 03:52:39 -0400
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:60765 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191Ab1H3Hwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 03:52:38 -0400
From: Marc Dietich <marvin24@gmx.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 1/2] sdhci/tegra: Add Device Tree probing support
Date: Tue, 30 Aug 2011 09:52:01 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc3+; KDE/4.6.5; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, Chris Ball <cjb@laptop.org>,
        Olof Johansson <olof@lixom.net>, Shawn Guo <shawn.guo@linaro.org>,
        linux-mmc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <1314123334-23133-1-git-send-email-swarren@nvidia.com>
In-Reply-To: <1314123334-23133-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108300952.02418.marvin24@gmx.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-Envelope-From: marvin24@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

just a small question,

> From: Grant Likely <grant.likely@secretlab.ca>

[...]

> diff --git a/Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt
> b/Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt new file mode
> 100644
> index 0000000..c87f667
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt
> @@ -0,0 +1,25 @@
> +* NVIDIA Tegra Secure Digital Host Controller
> +
> +This controller on Tegra family SoCs provides an interface for MMC, SD,
> +and SDIO types of memory cards.
> +
> +Required properties:
> +- compatible : Should be "nvidia,<chip>-sdhci"
> +- reg : Should contain eSDHC registers location and length
> +- interrupts : Should contain eSDHC interrupt
> +
> +Optional properties:
> +- cd-gpios : Specify GPIOs for card detection
> +- wp-gpios : Specify GPIOs for write protection
> +- power-gpios : Specify GPIOs for power control
> +
> +Example:
> +
> +sdhci@c8000200 {
> +	compatible = "nvidia,tegra20-sdhci";
> +	reg = <0xc8000200 0x200>;
> +	interrupts = <47>;
> +	cd-gpios = <&gpio 69 0>; /* gpio PI5 */
> +	wp-gpios = <&gpio 57 0>; /* gpio PH1 */
> +	power-gpios = <&gpio 155 0>; /* gpio PT3 */
> +};
> diff --git a/drivers/mmc/host/sdhci-tegra.c
> b/drivers/mmc/host/sdhci-tegra.c index a5a9a97..9ab18d6 100644
> --- a/drivers/mmc/host/sdhci-tegra.c
> +++ b/drivers/mmc/host/sdhci-tegra.c
> @@ -17,6 +17,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/clk.h>
>  #include <linux/io.h>
> +#include <linux/of_gpio.h>
>  #include <linux/gpio.h>
>  #include <linux/mmc/card.h>
>  #include <linux/mmc/host.h>
> @@ -74,10 +75,8 @@ static void tegra_sdhci_writel(struct sdhci_host *host,
> u32 val, int reg)
> 
>  static unsigned int tegra_sdhci_get_ro(struct sdhci_host *sdhci)
>  {
> -	struct platform_device *pdev = to_platform_device(mmc_dev(sdhci->mmc));
> -	struct tegra_sdhci_platform_data *plat;
> -
> -	plat = pdev->dev.platform_data;
> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(sdhci);
> +	struct tegra_sdhci_platform_data *plat = pltfm_host->priv;
> 
>  	if (!gpio_is_valid(plat->wp_gpio))
>  		return -1;
> @@ -95,12 +94,10 @@ static irqreturn_t carddetect_irq(int irq, void *data)
> 
>  static int tegra_sdhci_8bit(struct sdhci_host *host, int bus_width)
>  {
> -	struct platform_device *pdev = to_platform_device(mmc_dev(host->mmc));
> -	struct tegra_sdhci_platform_data *plat;
> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +	struct tegra_sdhci_platform_data *plat = pltfm_host->priv;
>  	u32 ctrl;
> 
> -	plat = pdev->dev.platform_data;
> -
>  	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
>  	if (plat->is_8bit && bus_width == MMC_BUS_WIDTH_8) {
>  		ctrl &= ~SDHCI_CTRL_4BITBUS;

what about 8 bit support? 

> @@ -132,6 +129,34 @@ static struct sdhci_pltfm_data sdhci_tegra_pdata = {
>  	.ops  = &tegra_sdhci_ops,
>  };
> 
> +static const struct of_device_id sdhci_tegra_dt_match[] __devinitdata = {
> +	{ .compatible = "nvidia,tegra20-sdhci", },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, sdhci_dt_ids);
> +
> +static struct tegra_sdhci_platform_data * __devinit
> sdhci_tegra_dt_parse_pdata( +						struct platform_device *pdev)
> +{
> +	struct tegra_sdhci_platform_data *plat;
> +	struct device_node *np = pdev->dev.of_node;
> +
> +	if (!np)
> +		return NULL;
> +
> +	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
> +	if (!plat) {
> +		dev_err(&pdev->dev, "Can't allocate platform data\n");
> +		return NULL;
> +	}
> +
> +	plat->cd_gpio = of_get_named_gpio(np, "cd-gpios", 0);
> +	plat->wp_gpio = of_get_named_gpio(np, "wp-gpios", 0);
> +	plat->power_gpio = of_get_named_gpio(np, "power-gpios", 0);
> +
> +	return plat;
> +}

[...]
