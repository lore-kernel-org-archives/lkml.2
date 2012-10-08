Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab2JHKxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 06:53:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44034 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab2JHKxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 06:53:38 -0400
Message-ID: <5072B091.1040007@ti.com>
Date: Mon, 8 Oct 2012 16:23:05 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: Re: [PATCH v4 7/7] ARM: davinci: register pruss_uio device on DA850
 EVM
References: <1349456686-22736-1-git-send-email-mporter@ti.com> <1349456686-22736-8-git-send-email-mporter@ti.com>
In-Reply-To: <1349456686-22736-8-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/2012 10:34 PM, Matt Porter wrote:
> Configures the required pdata and registers the pruss_uio
> platform device on the DA850 EVM.
> 
> Tested on AM180x-EVM using the PRU_memAccessPRUDataRam and
> PRU_memAccessL3andDDR examples from the PRU userspace tools
> available from http://www.ti.com/tool/sprc940
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/mach-davinci/board-da850-evm.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index 7359375..6f9478b 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -31,6 +31,7 @@
>  #include <linux/platform_data/mtd-davinci.h>
>  #include <linux/platform_data/mtd-davinci-aemif.h>
>  #include <linux/platform_data/spi-davinci.h>
> +#include <linux/platform_data/uio_pruss.h>
>  #include <linux/regulator/machine.h>
>  #include <linux/regulator/tps6507x.h>
>  #include <linux/spi/spi.h>
> @@ -40,6 +41,7 @@
>  #include <mach/cp_intc.h>
>  #include <mach/da8xx.h>
>  #include <mach/mux.h>
> +#include <mach/sram.h>
>  
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
> @@ -1253,6 +1255,10 @@ static __init int da850_wl12xx_init(void)
>  
>  #endif /* CONFIG_DA850_WL12XX */
>  
> +struct uio_pruss_pdata da8xx_pruss_uio_pdata = {
> +	.pintc_base	= 0x4000,
> +};
> +
>  #define DA850EVM_SATA_REFCLKPN_RATE	(100 * 1000 * 1000)
>  
>  static __init void da850_evm_init(void)
> @@ -1339,6 +1345,12 @@ static __init void da850_evm_init(void)
>  		pr_warning("da850_evm_init: lcdcntl mux setup failed: %d\n",
>  				ret);
>  
> +	da8xx_pruss_uio_pdata.sram_pool = sram_get_gen_pool();
> +	ret = da8xx_register_pruss_uio(&da8xx_pruss_uio_pdata);
> +	if (ret)
> +		pr_warning("pruss_uio initialization failed: %d\n",
> +				ret);

I failed to mention this last time around, but is there any reason
platform data will change from board to board? Looks like the pintc_base
is SoC specific and that all platforms would use SRAM when using the
pruss driver. Looks like you can make da8xx_register_pruss_uio() take no
parameters at all.

Thanks,
Sekhar
