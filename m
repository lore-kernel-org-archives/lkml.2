Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab2HLPXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 11:23:43 -0400
Received: from londo.lunn.ch ([80.238.139.98]:55600 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2HLPXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 11:23:42 -0400
Date: Sun, 12 Aug 2012 17:22:07 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rabeeh Khoury <rabeeh@solid-run.com>,
        Ian Molton <ian.molton@codethink.co.uk>, Arnd Bergmann <arnd@arndb.de>,
        Maen Suleiman <maen@marvell.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2 2/6] ARM: dove: add clock gating control
Message-ID: <20120812152207.GA6340@lunn.ch>
References: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1344681326-17946-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1344681326-17946-3-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344681326-17946-3-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 12:35:22PM +0200, Sebastian Hesselbarth wrote:
> This patch adds clock gates from the clock gating control register
> available on dove. All clock gates are hooked up to tclk, except for
> gigabit ethernet controller (ge) which is a child of gephy to allow
> both enabled/disabled at the same time.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Rabeeh Khoury <rabeeh@solid-run.com>
> Cc: Ian Molton <ian.molton@codethink.co.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Maen Suleiman <maen@marvell.com>
> Cc: Olof Johansson <olof@lixom.net>
> 
> v2: adapted to removed clk_prepare_enable from patch 1
> ---
>  arch/arm/mach-dove/common.c          |   59 +++++++++++++++++++++++++++++++++-
>  arch/arm/mach-dove/include/mach/pm.h |   54 ++++++++++++++++++++-----------
>  2 files changed, 94 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
> index b6f092c..7281591 100644
> --- a/arch/arm/mach-dove/common.c
> +++ b/arch/arm/mach-dove/common.c
> @@ -16,6 +16,7 @@
>  #include <linux/clk-provider.h>
>  #include <linux/ata_platform.h>
>  #include <linux/gpio.h>
> +#include <linux/mv643xx_i2c.h>
>  #include <asm/page.h>
>  #include <asm/setup.h>
>  #include <asm/timex.h>
> @@ -24,6 +25,7 @@
>  #include <asm/mach/time.h>
>  #include <asm/mach/pci.h>
>  #include <mach/dove.h>
> +#include <mach/pm.h>
>  #include <mach/bridge-regs.h>
>  #include <asm/mach/arch.h>
>  #include <linux/irq.h>
> @@ -31,6 +33,7 @@
>  #include <plat/ehci-orion.h>
>  #include <plat/common.h>
>  #include <plat/addr-map.h>
> +#include <plat/mv_xor.h>
>  #include "common.h"
>  
>  /*****************************************************************************
> @@ -69,14 +72,68 @@ void __init dove_map_io(void)
>   * CLK tree
>   ****************************************************************************/
>  static int dove_tclk;
> +
> +static DEFINE_SPINLOCK(gating_lock);
>  static struct clk *tclk;
>  
> +static struct clk __init *dove_register_gate(const char *name,
> +					     const char *parent, u8 bit_idx)
> +{
> +	return clk_register_gate(NULL, name, parent, 0,
> +				 (void __iomem *)CLOCK_GATING_CONTROL,
> +				 bit_idx, 0, &gating_lock);
> +}
> +
>  static void __init dove_clk_init(void)
>  {
> +	struct clk *usb0, *usb1, *sata, *pex0, *pex1, *sdio0, *sdio1;
> +	struct clk *nand, *camera, *i2s0, *i2s1, *crypto, *ac97, *pdma;
> +	struct clk *xor0, *xor1, *ge, *gephy;
> +
>  	tclk = clk_register_fixed_rate(NULL, "tclk", NULL, CLK_IS_ROOT,
>  				       dove_tclk);
>  
> -	orion_clkdev_init(tclk);
> +	usb0 = dove_register_gate("usb0", "tclk", CLOCK_GATING_BIT_USB0);
> +	usb1 = dove_register_gate("usb1", "tclk", CLOCK_GATING_BIT_USB1);
> +	sata = dove_register_gate("sata", "tclk", CLOCK_GATING_BIT_SATA);
> +	pex0 = dove_register_gate("pex1", "tclk", CLOCK_GATING_BIT_PCIE0);
> +	pex1 = dove_register_gate("pex1", "tclk", CLOCK_GATING_BIT_PCIE1);
> +	sdio0 = dove_register_gate("sdio0", "tclk", CLOCK_GATING_BIT_SDIO0);
> +	sdio1 = dove_register_gate("sdio1", "tclk", CLOCK_GATING_BIT_SDIO1);
> +	nand = dove_register_gate("nand", "tclk", CLOCK_GATING_BIT_NAND);
> +	camera = dove_register_gate("camera", "tclk", CLOCK_GATING_BIT_CAMERA);
> +	i2s0 = dove_register_gate("i2s0", "tclk", CLOCK_GATING_BIT_I2S0);
> +	i2s1 = dove_register_gate("i2s1", "tclk", CLOCK_GATING_BIT_I2S1);
> +	crypto = dove_register_gate("crypto", "tclk", CLOCK_GATING_BIT_CRYPTO);
> +	ac97 = dove_register_gate("ac97", "tclk", CLOCK_GATING_BIT_AC97);
> +	pdma = dove_register_gate("pdma", "tclk", CLOCK_GATING_BIT_PDMA);
> +	xor0 = dove_register_gate("xor0", "tclk", CLOCK_GATING_BIT_XOR0);
> +	xor1 = dove_register_gate("xor1", "tclk", CLOCK_GATING_BIT_XOR1);
> +	gephy = dove_register_gate("gephy", "tclk", CLOCK_GATING_BIT_GIGA_PHY);
> +	ge = dove_register_gate("ge", "gephy", CLOCK_GATING_BIT_GBE);
> +
> +	orion_clkdev_add(NULL, "orion_spi.0", tclk);
> +	orion_clkdev_add(NULL, "orion_spi.1", tclk);
> +	orion_clkdev_add(NULL, "orion_wdt", tclk);
> +	orion_clkdev_add(NULL, MV64XXX_I2C_CTLR_NAME ".0", tclk);
> +
> +	orion_clkdev_add(NULL, "orion-ehci.0", usb0);
> +	orion_clkdev_add(NULL, "orion-ehci.1", usb1);
> +	orion_clkdev_add(NULL, MV643XX_ETH_NAME ".0", ge);

Hi Sebastian

Take a look at the patch [PATCH v3 7/7] NET: mv643xx: remove device
name macro, from Ian Molten, and the discussion around the macro
MV643XX_ETH_NAME and its friend.

It is probably best to not use the I2C and XOR macro as well.

		 Andrew
