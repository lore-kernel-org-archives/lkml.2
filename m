Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2LDNOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:14:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37832 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab2LDNOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:14:34 -0500
Message-ID: <50BDF72C.2000906@ti.com>
Date: Tue, 4 Dec 2012 18:44:20 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v5 1/2] ARM: davinci: dm365: add support for v4l2 video
 display
References: <1354522904-22501-1-git-send-email-prabhakar.lad@ti.com> <1354522904-22501-2-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1354522904-22501-2-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/3/2012 1:51 PM, Prabhakar Lad wrote:
> From: Manjunath Hadli <manjunath.hadli@ti.com>
> 
> Create platform devices for various video modules like venc,osd,
> vpbe and v4l2 driver for dm365.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> ---
>  arch/arm/mach-davinci/board-dm365-evm.c |    4 +-
>  arch/arm/mach-davinci/davinci.h         |    2 +-
>  arch/arm/mach-davinci/dm365.c           |  203 +++++++++++++++++++++++++++++--
>  3 files changed, 195 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
> index 1b4a8ad..0c3dae6 100644
> --- a/arch/arm/mach-davinci/board-dm365-evm.c
> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
> @@ -564,8 +564,6 @@ static struct davinci_uart_config uart_config __initdata = {
>  
>  static void __init dm365_evm_map_io(void)
>  {
> -	/* setup input configuration for VPFE input devices */
> -	dm365_set_vpfe_config(&vpfe_cfg);
>  	dm365_init();
>  }
>  
> @@ -597,6 +595,8 @@ static __init void dm365_evm_init(void)
>  
>  	davinci_setup_mmc(0, &dm365evm_mmc_config);
>  
> +	dm365_init_video(&vpfe_cfg, NULL);
> +
>  	/* maybe setup mmc1/etc ... _after_ mmc0 */
>  	evm_init_cpld();
>  
> diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
> index 12d544b..1c2670f 100644
> --- a/arch/arm/mach-davinci/davinci.h
> +++ b/arch/arm/mach-davinci/davinci.h
> @@ -84,7 +84,7 @@ void __init dm365_init_ks(struct davinci_ks_platform_data *pdata);
>  void __init dm365_init_rtc(void);
>  void dm365_init_spi0(unsigned chipselect_mask,
>  			const struct spi_board_info *info, unsigned len);
> -void dm365_set_vpfe_config(struct vpfe_config *cfg);
> +int __init dm365_init_video(struct vpfe_config *, struct vpbe_config *);
>  
>  /* DM644x function declarations */
>  void __init dm644x_init(void);
> diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
> index b680c83..cada153 100644
> --- a/arch/arm/mach-davinci/dm365.c
> +++ b/arch/arm/mach-davinci/dm365.c
> @@ -40,10 +40,16 @@
>  
>  #define DM365_REF_FREQ		24000000	/* 24 MHz on the DM365 EVM */
>  
> +#define DM3XX_VDAC_CONFIG		0x01c4002c
> +
> +#define DM365_RTC_BASE			0x01c69000
> +
>  /* Base of key scan register bank */
>  #define DM365_KEYSCAN_BASE		0x01c69400
>  
> -#define DM365_RTC_BASE			0x01c69000
> +#define DM365_OSD_REG_BASE		0x01c71c00

Nit: Can you call it DM365_OSD_BASE. If we were to include REG in the
name, then it should be done consistently. So we would instead have
DM365_KEYSCAN_REG_BASE.

> +
> +#define DM365_VENC_REG_BASE		0x01c71e00
>  
>  #define DAVINCI_DM365_VC_BASE		0x01d0c000
>  #define DAVINCI_DMA_VC_TX		2
> @@ -56,6 +62,11 @@
>  #define DM365_EMAC_CNTRL_RAM_OFFSET	0x1000
>  #define DM365_EMAC_CNTRL_RAM_SIZE	0x2000
>  
> +#define DM365_VPSS_CLK_CTRL_ADDR		0x44
> +#define DM365_VPSS_VENCCLKEN_ENABLE		BIT(3)
> +#define DM365_VPSS_DACCLKEN_ENABLE		BIT(4)
> +#define DM365_VPSS_PLLC2SYSCLK5_ENABLE		(BIT(5) & ~BIT(6))

This expression does not make much sense. It is same as BIT(5). You
needed a mask and an enable?

> +
>  static struct pll_data pll1_data = {
>  	.num		= 1,
>  	.phys_base	= DAVINCI_PLL1_BASE,
> @@ -1232,6 +1243,186 @@ static struct platform_device dm365_isif_dev = {
>  	},
>  };
>  
> +static struct resource dm365_osd_resources[] = {
> +	{
> +		.start = DM365_OSD_REG_BASE,
> +		.end   = DM365_OSD_REG_BASE + 0x100,

	.end   = DM365_OSD_REG_BASE + 0xff,

A similar fix is needed multiple places below. Sorry, I did not notice
this last time around.

Thanks,
Sekhar
