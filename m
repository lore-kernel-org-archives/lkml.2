Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab2J3L1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 07:27:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35885 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771Ab2J3L1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 07:27:49 -0400
Message-ID: <508FB9B1.5060404@monstr.eu>
Date: Tue, 30 Oct 2012 12:27:45 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Nick Bowler <nbowler@elliptictech.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH v2] ARM: zynq: Allow UART1 to be used as DEBUG_LL console.
References: <1351534769-22155-1-git-send-email-nbowler@elliptictech.com>
In-Reply-To: <1351534769-22155-1-git-send-email-nbowler@elliptictech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 07:19 PM, Nick Bowler wrote:
> The main UART on the Xilinx ZC702 board is UART1, located at address
> e0001000.  Add a Kconfig option to select this device as the low-level
> debugging port.  This allows the really early boot printouts to reach
> the USB serial adaptor on this board.
>
> For consistency's sake, add a choice entry for UART0 even though it is
> the the default if UART1 is not selected.
>
> Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
> Tested-by: Josh Cartwright <josh.cartwright@ni.com>
> ---
> v2: rebase on newest patch series, signoff.
>
> This should apply cleanly on top of Josh Cartwright's v5 "zynq subarch
> cleanups" series.
>
>   arch/arm/Kconfig.debug                     |   17 +++++++++++++++++
>   arch/arm/mach-zynq/common.c                |    6 +++---
>   arch/arm/mach-zynq/include/mach/zynq_soc.h |   16 +++++++++++-----
>   3 files changed, 31 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index b0f3857b3a4c..7754d51f2b19 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -132,6 +132,23 @@ choice
>   		  their output to UART1 serial port on DaVinci TNETV107X
>   		  devices.
>
> +	config DEBUG_ZYNQ_UART0
> +		bool "Kernel low-level debugging on Xilinx Zynq using UART0"
> +		depends on ARCH_ZYNQ
> +		help
> +		  Say Y here if you want the debug print routines to direct
> +		  their output to UART0 on the Zynq platform.
> +
> +	config DEBUG_ZYNQ_UART1
> +		bool "Kernel low-level debugging on Xilinx Zynq using UART1"
> +		depends on ARCH_ZYNQ
> +		help
> +		  Say Y here if you want the debug print routines to direct
> +		  their output to UART1 on the Zynq platform.
> +
> +		  If you have a ZC702 board and want early boot messages to
> +		  appear on the USB serial adaptor, select this option.
> +
>   	config DEBUG_DC21285_PORT
>   		bool "Kernel low-level debugging messages via footbridge serial port"
>   		depends on FOOTBRIDGE
> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> index ba8d14f78d4d..93b91059faab 100644
> --- a/arch/arm/mach-zynq/common.c
> +++ b/arch/arm/mach-zynq/common.c
> @@ -84,9 +84,9 @@ static struct map_desc io_desc[] __initdata = {
>
>   #ifdef CONFIG_DEBUG_LL
>   	{
> -		.virtual	= UART0_VIRT,
> -		.pfn		= __phys_to_pfn(UART0_PHYS),
> -		.length		= UART0_SIZE,
> +		.virtual	= LL_UART_VADDR,
> +		.pfn		= __phys_to_pfn(LL_UART_PADDR),
> +		.length		= UART_SIZE,
>   		.type		= MT_DEVICE,
>   	},
>   #endif
> diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zynq/include/mach/zynq_soc.h
> index 1b8bf0ecbcb0..7f4f38bcada9 100644
> --- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
> +++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
> @@ -25,8 +25,9 @@
>    * address that is known to work.
>    */
>   #define UART0_PHYS		0xE0000000
> -#define UART0_SIZE		SZ_4K
> -#define UART0_VIRT		0xF0001000
> +#define UART1_PHYS		0xE0001000
> +#define UART_SIZE		SZ_4K
> +#define UART_VIRT		0xF0001000
>
>   #define TTC0_PHYS		0xF8001000
>   #define TTC0_SIZE		SZ_4K
> @@ -36,12 +37,17 @@
>   #define SCU_PERIPH_SIZE		SZ_8K
>   #define SCU_PERIPH_VIRT		(TTC0_VIRT - SCU_PERIPH_SIZE)
>
> +#if IS_ENABLED(CONFIG_DEBUG_ZYNQ_UART1)
> +#	define LL_UART_PADDR	UART1_PHYS
> +#	define LL_UART_VADDR	UART_VIRT
> +#else
> +#	define LL_UART_PADDR	UART0_PHYS
> +#	define LL_UART_VADDR	UART_VIRT
> +#endif

Probably no reason to setup LL_UART_VADDR on two lines.
It is enough to set it up once.

MINOR: It is just my personal preference to use different coding style.

#if IS_ENABLED(CONFIG_DEBUG_ZYNQ_UART1)
# define LL_UART_PADDR	UART1_PHYS
#else
# define LL_UART_PADDR	UART0_PHYS
#endif

#define LL_UART_VADDR	UART_VIRT

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
