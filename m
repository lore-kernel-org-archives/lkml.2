Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1BYLs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 06:48:58 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55400 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1BYLs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 06:48:57 -0500
Message-ID: <4D6796D6.5050008@mvista.com>
Date: Fri, 25 Feb 2011 14:47:34 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Pratheesh Gangadhar <pratheesh@ti.com>
CC: davinci-linux-open-source@linux.davincidsp.com, hjk@hansjkoch.de,
        gregkh@suse.de, tglx@linutronix.de, arnd@arndb.de,
        amit.chatterjee@ti.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/2] Defines DA850/AM18xx/OMAPL1-38 SOC resources used
 by PRUSS UIO driver
References: <1298556402-26456-1-git-send-email-pratheesh@ti.com> <1298556402-26456-2-git-send-email-pratheesh@ti.com> <1298556402-26456-3-git-send-email-pratheesh@ti.com>
In-Reply-To: <1298556402-26456-3-git-send-email-pratheesh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24-02-2011 17:06, Pratheesh Gangadhar wrote:

> This patch defines PRUSS, ECAP clocks, memory and IRQ resources
> used by PRUSS UIO driver in DA850/AM18xx/OMAPL1-38 devices. UIO

    It's OMAP-L138.

> driver exports 64K I/O region of PRUSS, 128KB L3 RAM and 256KB
> DDR buffer to user space. PRUSS has 8 host event interrupt lines
> mapped to IRQ_DA8XX_EVTOUT0..7 of ARM9 INTC.These in conjunction
> with shared memory can be used to implement IPC between ARM9 and
> PRUSS.

> Signed-off-by: Pratheesh Gangadhar<pratheesh@ti.com>
[...]

> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index 11f986b..bd85aa3 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -1077,6 +1077,10 @@ static __init void da850_evm_init(void)
>   		pr_warning("da850_evm_init: i2c0 registration failed: %d\n",
>   				ret);
>
> +	ret = da8xx_register_pruss();
> +	if (ret)
> +		pr_warning("da850_evm_init: pruss registration failed: %d\n",
> +				ret);

    Use __func__ to print the function name.

>
>   	ret = da8xx_register_watchdog();
>   	if (ret)

    As I said, please put this into serpate patch.

> diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
> index 3443d97..0096d4f 100644
> --- a/arch/arm/mach-davinci/da850.c
> +++ b/arch/arm/mach-davinci/da850.c
> @@ -238,6 +238,13 @@ static struct clk tptc2_clk = {
>   	.flags		= ALWAYS_ENABLED,
>   };
>
> +static struct clk pruss_clk = {
> +	.name		= "pruss",
> +	.parent		= &pll0_sysclk2,
> +	.lpsc		= DA8XX_LPSC0_DMAX,
> +	.flags		= ALWAYS_ENABLED,
> +};
> +

    This conflicts with previously posted patch.

>   static struct clk uart0_clk = {
>   	.name		= "uart0",
>   	.parent		=&pll0_sysclk2,
> @@ -359,6 +366,30 @@ static struct clk usb20_clk = {
>   	.gpsc		= 1,
>   };
>
> +static struct clk ecap0_clk = {
> +	.name		= "ecap0",
> +	.parent		= &pll0_sysclk2,
> +	.lpsc		= DA8XX_LPSC1_ECAP,
> +	.flags		= DA850_CLK_ASYNC3,
> +	.gpsc		= 1,
> +};
> +
> +static struct clk ecap1_clk = {
> +	.name		= "ecap1",
> +	.parent		= &pll0_sysclk2,
> +	.lpsc		= DA8XX_LPSC1_ECAP,
> +	.flags		= DA850_CLK_ASYNC3,
> +	.gpsc		= 1,
> +};
> +
> +static struct clk ecap2_clk = {
> +	.name		= "ecap2",
> +	.parent		= &pll0_sysclk2,
> +	.lpsc		= DA8XX_LPSC1_ECAP,
> +	.flags		= DA850_CLK_ASYNC3,
> +	.gpsc		= 1,
> +};
> +

    This is worth separate patch too...

> diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
> index beda8a4..4ea3d1f 100644
> --- a/arch/arm/mach-davinci/devices-da8xx.c
> +++ b/arch/arm/mach-davinci/devices-da8xx.c
> @@ -725,3 +725,76 @@ int __init da8xx_register_cpuidle(void)
>
>   	return platform_device_register(&da8xx_cpuidle_device);
>   }
> +static struct resource pruss_resources[] = {
> +	[0] = {
> +		.start  = DA8XX_PRUSS_BASE,
> +		.end    = DA8XX_PRUSS_BASE + SZ_64K - 1,
> +		.flags  = IORESOURCE_MEM,
> +	},
> +	[1] = {
> +		.start  = DA8XX_L3RAM_BASE,
> +		.end    = DA8XX_L3RAM_BASE + SZ_128K - 1,
> +		.flags  = IORESOURCE_MEM,
> +	},
> +	[2] = {
> +		.start  = 0,
> +		.end    = SZ_256K - 1,

    Huh? I don't see where it's filled...

> +		.flags  = IORESOURCE_MEM,
> +	},
> +
[...]
> +int __init da8xx_register_pruss()
> +{
> +	return platform_device_register(&pruss_device);
> +}
> diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
> index cfcb223..3ed6ee0 100644
> --- a/arch/arm/mach-davinci/include/mach/da8xx.h
> +++ b/arch/arm/mach-davinci/include/mach/da8xx.h
> @@ -60,6 +60,7 @@ extern unsigned int da850_max_speed;
>   #define DA8XX_PLL0_BASE		0x01c11000
>   #define DA8XX_TIMER64P0_BASE	0x01c20000
>   #define DA8XX_TIMER64P1_BASE	0x01c21000
> +#define DA8XX_PRUSS_BASE	0x01c30000
>   #define DA8XX_GPIO_BASE		0x01e26000
>   #define DA8XX_PSC1_BASE		0x01e27000
>   #define DA8XX_LCD_CNTRL_BASE	0x01e13000
> @@ -68,6 +69,7 @@ extern unsigned int da850_max_speed;
>   #define DA8XX_AEMIF_CS2_BASE	0x60000000
>   #define DA8XX_AEMIF_CS3_BASE	0x62000000
>   #define DA8XX_AEMIF_CTL_BASE	0x68000000
> +#define DA8XX_L3RAM_BASE	0x80000000

    There were already patches defining macros for these base addresses...

WBR, Sergei
