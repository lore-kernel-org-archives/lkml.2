Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab1BKP0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:26:38 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48956 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711Ab1BKP0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:26:37 -0500
Message-ID: <4D555523.7040507@criticallink.com>
Date: Fri, 11 Feb 2011 10:26:27 -0500
From: Michael Williamson <michael.williamson@criticallink.com>
Organization: Critical Link, LLC
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: davinci-linux-open-source@linux.davincidsp.com, sachi@mistralsolutions.com,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 11/13] da850: pruss SUART board specific additions.
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-12-git-send-email-subhasish@mistralsolutions.com>
In-Reply-To: <1297435892-28278-12-git-send-email-subhasish@mistralsolutions.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Subhasish,

On 2/11/2011 9:51 AM, Subhasish Ghosh wrote:

> This patch adds the pruss SUART pin mux and registers the device
> with the pruss mfd driver.
> 
> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> ---
>  arch/arm/mach-davinci/board-da850-evm.c |   36 +++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index f9c38f8..3858516 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -1060,6 +1060,25 @@ const short da850_evm_pruss_can_pins[] = {
>  	-1
>  };
>  
> +const short da850_evm_pruss_suart_pins[] = {
> +	DA850_AHCLKX, DA850_ACLKX, DA850_AFSX,
> +	DA850_AHCLKR, DA850_ACLKR, DA850_AFSR,
> +	DA850_AXR_13, DA850_AXR_9, DA850_AXR_7,
> +	DA850_AXR_14, DA850_AXR_10, DA850_AXR_8,
> +	-1
> +};
> +


Shouldn't this pins select PRU[0,1]_XXX type functions and not McASP functions?
E.G.: PRU0_R31[17] instead of AHCLKX, PRU0_R31[18] instead of AHCLKR, etc.

> +static int __init da850_evm_setup_pruss_suart(void)
> +{
> +	int ret;
> +
> +	ret = davinci_cfg_reg_list(da850_evm_pruss_suart_pins);
> +	if (ret)
> +		pr_warning("%s: da850_evm_pruss_suart_pins "
> +			"mux setup failed: %d\n", __func__, ret);
> +	return ret;
> +}
> +
>  static int __init da850_evm_setup_pruss_can(void)
>  {
>  	int ret, val = 0;
> @@ -1085,6 +1104,17 @@ static int __init da850_evm_setup_pruss_can(void)
>  	return ret;
>  }
>  
> +static struct da850_evm_pruss_suart_data suart_data = {
> +	.version	= 1,
> +	.resource	= {
> +			.name	= "da8xx_mcasp0_iomem",
> +			.start	= DAVINCI_DA8XX_MCASP0_REG_BASE,
> +			.end	= DAVINCI_DA8XX_MCASP0_REG_BASE +
> +					(SZ_1K * 12) - 1,
> +			.flags	= IORESOURCE_MEM,
> +		},
> +};
> +
>  static struct da8xx_pruss_can_data can_data = {
>  	.version	= 1,
>  };
> @@ -1094,6 +1124,12 @@ static struct da8xx_pruss_devices pruss_devices[] = {
>  		.dev_name	= "da8xx_pruss_can",
>  		.pdata		= &can_data,
>  		.pdata_size	= sizeof(can_data),
> +		.setup		= da850_evm_setup_pruss_suart,


Should this be da850_evm_setup_pruss_can instead?

> +	},
> +	{
> +		.dev_name	= "da8xx_pruss_uart",
> +		.pdata		= &suart_data,
> +		.pdata_size	= sizeof(suart_data),
>  		.setup		= da850_evm_setup_pruss_can,


Should this be da850_evm_setup_pruss_suart instead?

>  	},
>  	{


-Mike

