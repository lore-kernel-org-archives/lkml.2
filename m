Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2GJVgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 17:36:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab2GJVgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 17:36:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 04/23] ARM: LPC32xx: Add DMA configuration to platform data
Date: Tue, 10 Jul 2012 21:36:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
References: <1339692673-7848-1-git-send-email-stigge@antcom.de> <1339692673-7848-5-git-send-email-stigge@antcom.de>
In-Reply-To: <1339692673-7848-5-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207102136.35944.arnd@arndb.de>
X-Provags-ID: V02:K0:TD4u0n0oWoJBFoVbL5VbsVwMHXt5ghZeEH9VftKQKpL
 mZwUZ7R4UsCD4uA86okYOfgq5XMVpptWnECQckxXFfBcpmHvu/
 wSp2SJZEl5zgL8SAv42aHpvaFn2YfrNEhN9ijVxDECdeuyvIU9
 xca2q+3mYus1vQGQNglC85qiN+cMBK61z0cnPqUngB6eL2eq3w
 1m2d14loEJVI/jRSZre5BKyHfdipL0PAIIRUJm6d8A790ZVZmY
 0goQgAmVE5Qi22aFyOMc6niax8hK8MFBLMgIxG1DQ0oDUj980B
 vAYqXEouoCNhsQ+WRHNJstz/qD0fxU0Jiv63E00+o/ENWU9eoQ
 WGG1hxa0b++if011Kz+4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2012, Roland Stigge wrote:
> --- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
> +++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
> @@ -226,7 +226,38 @@ static int __init phy3250_spi_board_regi
>  }
>  arch_initcall(phy3250_spi_board_register);
>  
> +static struct pl08x_channel_data pl08x_slave_channels[] = {
> +	{
> +		.bus_id = "nand-slc",
> +		.min_signal = 1, /* SLC NAND Flash */
> +		.max_signal = 1,
> +		.periph_buses = PL08X_AHB1,
> +	},
> +	{
> +		.bus_id = "nand-mlc",
> +		.min_signal = 12, /* MLC NAND Flash */
> +		.max_signal = 12,
> +		.periph_buses = PL08X_AHB1,
> +	},
> +};
> +
> +/* NOTE: These will change, according to RMK */
> +static int pl08x_get_signal(struct pl08x_dma_chan *ch)
> +{
> +	return ch->cd->min_signal;
> +}
> +

This has changed now, rendering linux-next broken for lpc32xx_defconfig:

/home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:190:36: warning: 'struct pl08x_dma_chan' declared inside parameter list [enabled by default]
/home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:190:36: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
/home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c: In function 'pl08x_get_signal':
/home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:192:11: error: dereferencing pointer to incomplete type
/home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c: At top level:
/home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:195:37: warning: 'struct pl08x_dma_chan' declared inside parameter list [enabled by default]
/home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:202:2: warning: initialization from incompatible pointer type [enabled by default]
/home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:202:2: warning: (near initialization for 'pl08x_pd.get_signal') [enabled by default]
/home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:203:2: warning: initialization from incompatible pointer type [enabled by default]
/home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:203:2: warning: (near initialization for 'pl08x_pd.put_signal') [enabled by default]
/home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c: In function 'pl08x_get_signal':
/home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:193:1: warning: control reaches end of non-void function [-Wreturn-type]
/home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_slc.c: In function 'lpc32xx_dma_filter':
/home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_slc.c:720:48: error: dereferencing pointer to incomplete type
/home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_slc.c:720:67: warning: initialization from incompatible pointer type [enabled by default]
/home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_slc.c:720:67: warning: (near initialization for 'ch') [enabled by default]
/home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_slc.c:720:145: error: invalid use of undefined type 'struct pl08x_dma_chan'
/home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_slc.c:723:8: error: dereferencing pointer to incomplete type
make[4]: *** [drivers/mtd/nand/lpc32xx_slc.o] Error 1
/home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_mlc.c: In function 'lpc32xx_dma_filter':
/home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_mlc.c:582:48: error: dereferencing pointer to incomplete type
/home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_mlc.c:582:67: warning: initialization from incompatible pointer type [enabled by default]
/home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_mlc.c:582:67: warning: (near initialization for 'ch') [enabled by default]
/home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_mlc.c:582:145: error: invalid use of undefined type 'struct pl08x_dma_chan'
/home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_mlc.c:585:8: error: dereferencing pointer to incomplete type
make[4]: *** [drivers/mtd/nand/lpc32xx_mlc.o] Error 1

As far as I can tell, each branch touching these files is ok individually,
but they don't go together.

There is also this bit of suspicious code in lpc32xx_slc:

static bool lpc32xx_dma_filter(struct dma_chan *chan, void *param)
{
        struct pl08x_dma_chan *ch =
                container_of(chan, struct pl08x_dma_chan, chan);

        /* In LPC32xx's PL080 DMA wiring, the SLC NAND DMA signal is #1 */
        if (ch->cd->min_signal == 1)
                return true;
        return false;
}

I dont't think that actually valid -- you cannot make any assumption about
the structure outside of dma_chan here, only about the parameter you pass
in.

	Arnd
