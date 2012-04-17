Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab2DQUXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:23:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40199 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2DQUXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:23:40 -0400
Message-ID: <4F8DD148.4000902@wwwdotorg.org>
Date: Tue, 17 Apr 2012 14:23:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        s.hauer@pengutronix.de, shawn.guo@freescale.com, kernel@pengutronix.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Subject: Re: [PATCH 3/3] ARM: imx6q: switch to use pinctrl driver
References: <1334333915-1174-1-git-send-email-b29396@freescale.com> <1334333915-1174-3-git-send-email-b29396@freescale.com>
In-Reply-To: <1334333915-1174-3-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2012 10:18 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> ---
> This patch is used for test the new pinctrl driver.

> diff --git a/arch/arm/boot/dts/imx6q-arm2.dts b/arch/arm/boot/dts/imx6q-arm2.dts

>                       usdhc@0219c000 { /* uSDHC4 */
>  				fsl,card-wired;
>  				vmmc-supply = <&reg_3p3v>;
>  				status = "okay";
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_usdhc4_1>;
>  			};
>  
>  			uart4: uart@021f0000 {
>  				status = "okay";
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_uart4_1>;
>  			};

That seems reasonable.

> diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi

> +				usdhc4 {
> +					pinctrl_usdhc4_1: usdhc4grp-1 {

I'm slightly confused about how this part of the binding is structured.

I'd expect the label "pinctrl_usdhc4_1:" to point at the node "usdhc4"
here. As written, there's no possibility of using a different pin
configuration values such as pull/drive-strength/... for some of the
pins, which I'm pretty sure will be an issue.

For example, see tegra-cardhu.dts - it has a pull up on the SDMMC data
and clock lines, but no pull on the SDMMC command line. I assume it's
this way because of some aspect of the SDMMC specification, rather than
something odd about Tegra.

I guess you've allowed a list of mux functions in the fsl,mux property.
Perhaps you can also allow a list in the other properties.

In that case though, what is the top-level usdhc4 node for? Perhaps it
groups multiple different available pin configurations for the USDHC4
controller together just as documentation? I don't think it's that
useful to do that; it doesn't actually convey any extra information, and
the fact the node is a configuration for the USDHC4 controller is
readily apparent from the node's label and name.

> +						fsl,pins =	"MX6Q_PAD_SD4_CMD",
> +								"MX6Q_PAD_SD4_CLK",
> +								"MX6Q_PAD_SD4_DAT0",
> +								"MX6Q_PAD_SD4_DAT1",
> +								"MX6Q_PAD_SD4_DAT2",
> +								"MX6Q_PAD_SD4_DAT3",
> +								"MX6Q_PAD_SD4_DAT4",
> +								"MX6Q_PAD_SD4_DAT5",
> +								"MX6Q_PAD_SD4_DAT6",
> +								"MX6Q_PAD_SD4_DAT7";
> +						fsl,mux = <0 0 1 1 1 1 1 1 1 1>;
> +						fsl,pull = <1>;
> +						fsl,pue = <1>;
> +						fsl,pke = <1>;
> +						fsl,speed = <1>;
> +						fsl,drive-strength = <3>;
> +						fsl,slew-rate = <1>;
> +						fsl,hysteresis = <1>;
> +					};

> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c

> @@ -467,6 +469,12 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
>  	clk_prepare_enable(clk);
>  	pltfm_host->clk = clk;
>  
> +	imx_data->p = pinctrl_get_select_default(&pdev->dev);

If you use devm_pinctrl_get_select_default() here (once it's checked in) ...

>  no_card_detect_pin:
>  no_board_data:
> +	pinctrl_put(imx_data->p);

... you don't need that ...

> @@ -586,6 +596,8 @@ static int __devexit sdhci_esdhc_imx_remove(struct platform_device *pdev)
>  		gpio_free(boarddata->cd_gpio);
>  	}
>  
> +	pinctrl_put(imx_data->p);

... or that.
