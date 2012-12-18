Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab2LRAgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 19:36:31 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:15197 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752253Ab2LRAga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 19:36:30 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/BJQzOCyb4ZFx9lhSU9QAAHgMLdTdlhTM=
Date: Mon, 17 Dec 2012 19:35:39 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: Dove: split legacy and DT setup
Message-ID: <20121218003539.GO21694@titan.lakedaemon.net>
References: <1355790269-10596-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355790269-10596-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Tue, Dec 18, 2012 at 01:24:27AM +0100, Sebastian Hesselbarth wrote:
> In the beginning of DT for Dove it was reasonable to have it close to
> non-DT code. With improved DT support, it became more and more difficult
> to not break non-DT while changing DT code.
> 
> This patch splits up DT board setup and introduces a DOVE_LEGACY config
> to allow to remove legacy code for DT-only kernels.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-dove/Kconfig    |    5 ++
>  arch/arm/mach-dove/Makefile   |    4 +-
>  arch/arm/mach-dove/board-dt.c |  102 +++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-dove/common.c   |   85 ----------------------------------

Could you please make this patch second in the series?  It'll prevent
dependency problems later if cleanup (patch #2) comes before board work.

thx,

Jason.

>  4 files changed, 110 insertions(+), 86 deletions(-)
>  create mode 100644 arch/arm/mach-dove/board-dt.c
> 
> diff --git a/arch/arm/mach-dove/Kconfig b/arch/arm/mach-dove/Kconfig
> index 603c5fd..aedd0ba 100644
> --- a/arch/arm/mach-dove/Kconfig
> +++ b/arch/arm/mach-dove/Kconfig
> @@ -2,8 +2,12 @@ if ARCH_DOVE
>  
>  menu "Marvell Dove Implementations"
>  
> +config DOVE_LEGACY
> +	bool
> +
>  config MACH_DOVE_DB
>  	bool "Marvell DB-MV88AP510 Development Board"
> +	select DOVE_LEGACY
>  	select I2C_BOARDINFO
>  	help
>  	  Say 'Y' here if you want your kernel to support the
> @@ -11,6 +15,7 @@ config MACH_DOVE_DB
>  
>  config MACH_CM_A510
>  	bool "CompuLab CM-A510 Board"
> +	select DOVE_LEGACY
>  	help
>  	  Say 'Y' here if you want your kernel to support the
>  	  CompuLab CM-A510 Board.
> diff --git a/arch/arm/mach-dove/Makefile b/arch/arm/mach-dove/Makefile
> index 5e683ba..3f0a858 100644
> --- a/arch/arm/mach-dove/Makefile
> +++ b/arch/arm/mach-dove/Makefile
> @@ -1,4 +1,6 @@
> -obj-y				+= common.o addr-map.o irq.o mpp.o
> +obj-y				+= common.o addr-map.o irq.o
> +obj-$(CONFIG_DOVE_LEGACY)	+= mpp.o
>  obj-$(CONFIG_PCI)		+= pcie.o
>  obj-$(CONFIG_MACH_DOVE_DB)	+= dove-db-setup.o
> +obj-$(CONFIG_MACH_DOVE_DT)	+= board-dt.o
>  obj-$(CONFIG_MACH_CM_A510)	+= cm-a510.o
> diff --git a/arch/arm/mach-dove/board-dt.c b/arch/arm/mach-dove/board-dt.c
> new file mode 100644
> index 0000000..2310f55
> --- /dev/null
> +++ b/arch/arm/mach-dove/board-dt.c
> @@ -0,0 +1,102 @@
> +/*
> + * arch/arm/mach-dove/board-dt.c
> + *
> + * Marvell Dove 88AP510 System On Chip FDT Board
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/clk-provider.h>
> +#include <linux/clk/mvebu.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_data/usb-ehci-orion.h>
> +#include <asm/hardware/cache-tauros2.h>
> +#include <asm/mach/arch.h>
> +#include <mach/pm.h>
> +#include <plat/common.h>
> +#include <plat/irq.h>
> +#include "common.h"
> +
> +/*
> + * There are still devices that doesn't even know about DT,
> + * get clock gates here and add a clock lookup.
> + */
> +static void __init dove_legacy_clk_init(void)
> +{
> +	struct device_node *np = of_find_compatible_node(NULL, NULL,
> +					 "marvell,dove-gating-clock");
> +	struct of_phandle_args clkspec;
> +
> +	clkspec.np = np;
> +	clkspec.args_count = 1;
> +
> +	clkspec.args[0] = CLOCK_GATING_BIT_USB0;
> +	orion_clkdev_add(NULL, "orion-ehci.0",
> +			 of_clk_get_from_provider(&clkspec));
> +
> +	clkspec.args[0] = CLOCK_GATING_BIT_USB1;
> +	orion_clkdev_add(NULL, "orion-ehci.1",
> +			 of_clk_get_from_provider(&clkspec));
> +
> +	clkspec.args[0] = CLOCK_GATING_BIT_GBE;
> +	orion_clkdev_add(NULL, "mv643xx_eth_port.0",
> +			 of_clk_get_from_provider(&clkspec));
> +
> +	clkspec.args[0] = CLOCK_GATING_BIT_PCIE0;
> +	orion_clkdev_add("0", "pcie",
> +			 of_clk_get_from_provider(&clkspec));
> +
> +	clkspec.args[0] = CLOCK_GATING_BIT_PCIE1;
> +	orion_clkdev_add("1", "pcie",
> +			 of_clk_get_from_provider(&clkspec));
> +}
> +
> +static void __init dove_of_clk_init(void)
> +{
> +	mvebu_clocks_init();
> +	dove_legacy_clk_init();
> +}
> +
> +static struct mv643xx_eth_platform_data dove_dt_ge00_data = {
> +	.phy_addr = MV643XX_ETH_PHY_ADDR_DEFAULT,
> +};
> +
> +static void __init dove_dt_init(void)
> +{
> +	pr_info("Dove 88AP510 SoC\n");
> +
> +#ifdef CONFIG_CACHE_TAUROS2
> +	tauros2_init(0);
> +#endif
> +	dove_setup_cpu_mbus();
> +
> +	/* Setup root of clk tree */
> +	dove_of_clk_init();
> +
> +	/* Internal devices not ported to DT yet */
> +	dove_ge00_init(&dove_dt_ge00_data);
> +	dove_ehci0_init();
> +	dove_ehci1_init();
> +	dove_pcie_init(1, 1);
> +
> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +}
> +
> +static const char * const dove_dt_board_compat[] = {
> +	"marvell,dove",
> +	NULL
> +};
> +
> +DT_MACHINE_START(DOVE_DT, "Marvell Dove (Flattened Device Tree)")
> +	.map_io		= dove_map_io,
> +	.init_early	= dove_init_early,
> +	.init_irq	= orion_dt_init_irq,
> +	.timer		= &dove_timer,
> +	.init_machine	= dove_dt_init,
> +	.restart	= dove_restart,
> +	.dt_compat	= dove_dt_board_compat,
> +MACHINE_END
> diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
> index 89f4f99..7dda832 100644
> --- a/arch/arm/mach-dove/common.c
> +++ b/arch/arm/mach-dove/common.c
> @@ -375,88 +375,3 @@ void dove_restart(char mode, const char *cmd)
>  	while (1)
>  		;
>  }
> -
> -#if defined(CONFIG_MACH_DOVE_DT)
> -/*
> - * There are still devices that doesn't even know about DT,
> - * get clock gates here and add a clock lookup.
> - */
> -static void __init dove_legacy_clk_init(void)
> -{
> -	struct device_node *np = of_find_compatible_node(NULL, NULL,
> -					 "marvell,dove-gating-clock");
> -	struct of_phandle_args clkspec;
> -
> -	clkspec.np = np;
> -	clkspec.args_count = 1;
> -
> -	clkspec.args[0] = CLOCK_GATING_BIT_USB0;
> -	orion_clkdev_add(NULL, "orion-ehci.0",
> -			 of_clk_get_from_provider(&clkspec));
> -
> -	clkspec.args[0] = CLOCK_GATING_BIT_USB1;
> -	orion_clkdev_add(NULL, "orion-ehci.1",
> -			 of_clk_get_from_provider(&clkspec));
> -
> -	clkspec.args[0] = CLOCK_GATING_BIT_GBE;
> -	orion_clkdev_add(NULL, "mv643xx_eth_port.0",
> -			 of_clk_get_from_provider(&clkspec));
> -
> -	clkspec.args[0] = CLOCK_GATING_BIT_PCIE0;
> -	orion_clkdev_add("0", "pcie",
> -			 of_clk_get_from_provider(&clkspec));
> -
> -	clkspec.args[0] = CLOCK_GATING_BIT_PCIE1;
> -	orion_clkdev_add("1", "pcie",
> -			 of_clk_get_from_provider(&clkspec));
> -}
> -
> -static void __init dove_of_clk_init(void)
> -{
> -	mvebu_clocks_init();
> -	dove_legacy_clk_init();
> -}
> -
> -static struct mv643xx_eth_platform_data dove_dt_ge00_data = {
> -	.phy_addr = MV643XX_ETH_PHY_ADDR_DEFAULT,
> -};
> -
> -static void __init dove_dt_init(void)
> -{
> -	pr_info("Dove 88AP510 SoC, TCLK = %d MHz.\n",
> -		(dove_tclk + 499999) / 1000000);
> -
> -#ifdef CONFIG_CACHE_TAUROS2
> -	tauros2_init(0);
> -#endif
> -	dove_setup_cpu_mbus();
> -
> -	/* Setup root of clk tree */
> -	dove_of_clk_init();
> -
> -	/* Internal devices not ported to DT yet */
> -	dove_rtc_init();
> -
> -	dove_ge00_init(&dove_dt_ge00_data);
> -	dove_ehci0_init();
> -	dove_ehci1_init();
> -	dove_pcie_init(1, 1);
> -
> -	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> -}
> -
> -static const char * const dove_dt_board_compat[] = {
> -	"marvell,dove",
> -	NULL
> -};
> -
> -DT_MACHINE_START(DOVE_DT, "Marvell Dove (Flattened Device Tree)")
> -	.map_io		= dove_map_io,
> -	.init_early	= dove_init_early,
> -	.init_irq	= orion_dt_init_irq,
> -	.timer		= &dove_timer,
> -	.init_machine	= dove_dt_init,
> -	.restart	= dove_restart,
> -	.dt_compat	= dove_dt_board_compat,
> -MACHINE_END
> -#endif
> -- 
> 1.7.10.4
> 
