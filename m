Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab2H1DWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 23:22:55 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:50197
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133Ab2H1DWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 23:22:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zcb8kz98dI154dM1432Izz1202hzz8275dhz2dh2a8h668h839h944hd25hf0ah107ah1155h)
Date: Tue, 28 Aug 2012 11:23:10 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Dong Aisheng <b29396@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linus.walleij@stericsson.com>, <s.hauer@pengutronix.de>,
        <shawn.guo@linaro.org>, <kernel@pengutronix.de>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>,
        <devicetree-discuss@lists.ozlabs.org>, <swarren@wwwdotorg.org>
Subject: Re: [PATCH v2 5/7] ARM: imx6q: convert to use syscon to access
 anatop registers
Message-ID: <20120828032309.GW4011@b20223-02.ap.freescale.net>
References: <1346052285-4344-1-git-send-email-b29396@freescale.com>
 <1346052285-4344-6-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1346052285-4344-6-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 03:24:43PM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Using syscon to access anatop registers.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
> ChangeLog v1->v2:
>  * update to use generic regmap api
> ---
>  arch/arm/mach-imx/Kconfig      |    2 +-
>  arch/arm/mach-imx/mach-imx6q.c |   43 ++++++++++++++++-----------------------
>  2 files changed, 19 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index afd542a..7bba253 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -839,7 +839,7 @@ config SOC_IMX6Q
>  	select HAVE_IMX_MMDC
>  	select HAVE_IMX_SRC
>  	select HAVE_SMP
> -	select MFD_ANATOP
> +	select MFD_SYSCON
>  	select PINCTRL
>  	select PINCTRL_IMX6Q
>  
> diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
> index 045b3f6..5de869a 100644
> --- a/arch/arm/mach-imx/mach-imx6q.c
> +++ b/arch/arm/mach-imx/mach-imx6q.c
> @@ -24,8 +24,9 @@
>  #include <linux/of_platform.h>
>  #include <linux/pinctrl/machine.h>
>  #include <linux/phy.h>
> +#include <linux/regmap.h>
>  #include <linux/micrel_phy.h>
> -#include <linux/mfd/anatop.h>
> +#include <linux/mfd/syscon.h>
>  #include <asm/cpuidle.h>
>  #include <asm/smp_twd.h>
>  #include <asm/hardware/cache-l2x0.h>
> @@ -121,38 +122,30 @@ static void __init imx6q_sabrelite_init(void)
>  static void __init imx6q_usb_init(void)
>  {
>  	struct device_node *np;
> -	struct platform_device *pdev = NULL;
> -	struct anatop *adata = NULL;
> +	struct regmap *anatop;
>  
>  	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-anatop");
np unused.
> -	if (np)
> -		pdev = of_find_device_by_node(np);
> -	if (pdev)
> -		adata = platform_get_drvdata(pdev);
> -	if (!adata) {
> -		if (np)
> -			of_node_put(np);
> -		return;
> -	}
> -
>  #define HW_ANADIG_USB1_CHRG_DETECT		0x000001b0
>  #define HW_ANADIG_USB2_CHRG_DETECT		0x00000210
>  
>  #define BM_ANADIG_USB_CHRG_DETECT_EN_B		0x00100000
>  #define BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B	0x00080000
>  
> -	/*
> -	 * The external charger detector needs to be disabled,
> -	 * or the signal at DP will be poor
> -	 */
> -	anatop_write_reg(adata, HW_ANADIG_USB1_CHRG_DETECT,
> -			BM_ANADIG_USB_CHRG_DETECT_EN_B
> -			| BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B,
> -			~0);
> -	anatop_write_reg(adata, HW_ANADIG_USB2_CHRG_DETECT,
> -			BM_ANADIG_USB_CHRG_DETECT_EN_B |
> -			BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B,
> -			~0);
> +	anatop = syscon_regmap_lookup_by_compatible("fsl,imx6q-anatop");
> +	if (!IS_ERR(anatop)) {
> +		/*
> +		 * The external charger detector needs to be disabled,
> +		 * or the signal at DP will be poor
> +		 */
> +		regmap_write(anatop, HW_ANADIG_USB1_CHRG_DETECT,
> +				BM_ANADIG_USB_CHRG_DETECT_EN_B
> +				| BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B);
> +		regmap_write(anatop, HW_ANADIG_USB2_CHRG_DETECT,
> +				BM_ANADIG_USB_CHRG_DETECT_EN_B |
> +				BM_ANADIG_USB_CHRG_DETECT_CHK_CHRG_B);
> +	} else {
> +		pr_warn("failed to find fsl,imx6q-anatop regmap\n");
> +	}
>  
>  	of_node_put(np);
unneeded.

Thanks
Richard
>  }
> -- 
> 1.7.0.4
> 

