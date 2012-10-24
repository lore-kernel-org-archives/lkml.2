Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934724Ab2JXN3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:29:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57744 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab2JXN3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:29:21 -0400
Message-ID: <5087ED26.7080605@ti.com>
Date: Wed, 24 Oct 2012 18:59:10 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.lad@ti.com>
CC: LAK <linux-arm-kernel@lists.infradead.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: [PATCH v4 1/2] ARM: davinci: dm365: add support for v4l2 video
 display
References: <1344430259-23968-1-git-send-email-prabhakar.lad@ti.com> <1344430259-23968-2-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1344430259-23968-2-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Sorry about the late feedback on this patch.

On 8/8/2012 6:20 PM, Prabhakar Lad wrote:
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
>  3 files changed, 196 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
> index 688a9c5..ac1f20d 100644
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
> index 8db0fc6..94d867f 100644
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
> index a50d49d..7c0cc66 100644
> --- a/arch/arm/mach-davinci/dm365.c
> +++ b/arch/arm/mach-davinci/dm365.c
> @@ -1232,6 +1232,199 @@ static struct platform_device dm365_isif_dev = {
>  	},
>  };
>  
> +#define DM365_OSD_REG_BASE		0x01C71C00

In this file all base addresses are defined at the beginning of the
file. Please move it there. Keep the list sorted by address.

> +
> +static struct resource dm365_osd_resources[] = {
> +	{
> +	.start	= DM365_OSD_REG_BASE,
> +	.end	= DM365_OSD_REG_BASE + 0x100,
> +	.flags	= IORESOURCE_MEM,
> +	},
> +};
> +
> +static u64 dm365_video_dma_mask = DMA_BIT_MASK(32);
> +
> +static struct osd_platform_data dm365_osd_data = {
> +	.vpbe_type	= VPBE_VERSION_2,
> +};

The better way to handle multiple versions of IP is to define different
platform names for each variant and then pass the right name from
platform code. Have a look at 'fec_devtype' in
"drivers/net/ethernet/freescale/fec.c" to see how this is done to handle
different variants of Ethernet IP in freescale Ethernet driver.

I understand this is how the driver has defined it, but I suggest fixing
this now. Taking the above approach will also make the DT transition easier.

> +
> +static struct platform_device dm365_osd_dev = {
> +	.name		= VPBE_OSD_SUBDEV_NAME,
> +	.id		= -1,
> +	.num_resources	= ARRAY_SIZE(dm365_osd_resources),
> +	.resource	= dm365_osd_resources,
> +	.dev		= {
> +		.dma_mask		= &dm365_video_dma_mask,
> +		.coherent_dma_mask	= DMA_BIT_MASK(32),
> +		.platform_data		= &dm365_osd_data,
> +	},
> +};
> +
> +#define DM365_VENC_REG_BASE		0x01C71E00
> +#define DM3XX_VDAC_CONFIG		0x01C4002C

Similar to above comment, please move this to top of the file.

> +
> +static struct resource dm365_venc_resources[] = {
> +	{
> +		.start	= IRQ_VENCINT,
> +		.end	= IRQ_VENCINT,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	/* venc registers io space */
> +	{
> +		.start	= DM365_VENC_REG_BASE,
> +		.end	= DM365_VENC_REG_BASE + 0x180,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	/* vdaccfg registers io space */
> +	{
> +		.start	= DM3XX_VDAC_CONFIG,
> +		.end	= DM3XX_VDAC_CONFIG + 4,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +};
> +
> +static struct resource dm365_v4l2_disp_resources[] = {
> +	{
> +		.start	= IRQ_VENCINT,
> +		.end	= IRQ_VENCINT,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	/* venc registers io space */
> +	{
> +		.start	= DM365_VENC_REG_BASE,
> +		.end	= DM365_VENC_REG_BASE + 0x180,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +};
> +
> +static int dm365_vpbe_setup_pinmux(enum v4l2_mbus_pixelcode if_type,
> +			    int field)
> +{
> +	int ret = 0;
> +
> +	switch (if_type) {
> +	case V4L2_MBUS_FMT_SGRBG8_1X8:
> +		davinci_cfg_reg(DM365_VOUT_FIELD_G81);
> +		davinci_cfg_reg(DM365_VOUT_COUTL_EN);
> +		davinci_cfg_reg(DM365_VOUT_COUTH_EN);
> +		break;
> +	case V4L2_MBUS_FMT_YUYV10_1X20:
> +		if (field)
> +			davinci_cfg_reg(DM365_VOUT_FIELD);
> +		else
> +			davinci_cfg_reg(DM365_VOUT_FIELD_G81);
> +		davinci_cfg_reg(DM365_VOUT_COUTL_EN);
> +		davinci_cfg_reg(DM365_VOUT_COUTH_EN);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +#define DM365_VPSS_VENCCLKEN_ENABLE		0x8
> +#define DM365_VPSS_DACCLKEN_ENABLE		0x10
> +#define DM365_VPSS_PLLC2SYSCLK5			0x20

These are bit definitions? Please use BIT() instead. I feel it is more
logical to add bit definitions after the actual register definition.

> +#define DM365_VPSS_CLK_CTRL_ADDR		0x44
> +
> +static int dm365_venc_setup_clock(enum vpbe_enc_timings_type type,
> +				  unsigned int pclock)
> +{
> +	void __iomem *vpss_clkctl_reg;
> +	int ret = 0;
> +
> +	vpss_clkctl_reg = DAVINCI_SYSMOD_VIRT(DM365_VPSS_CLK_CTRL_ADDR);
> +
> +	switch (type) {
> +	case VPBE_ENC_STD:
> +		vpss_enable_clock(VPSS_VENC_CLOCK_SEL, 1);
> +		vpss_enable_clock(VPSS_VPBE_CLOCK, 1);
> +		__raw_writel(DM365_VPSS_VENCCLKEN_ENABLE +
> +			DM365_VPSS_DACCLKEN_ENABLE, vpss_clkctl_reg);

Please use readl()/writel() instead. Here and down below as well. Also,
please use logical OR for bit masks, although in this case using '+'
works as well.

> +		break;
> +	case VPBE_ENC_CUSTOM_TIMINGS:
> +		if (pclock <= 27000000) {
> +			vpss_enable_clock(VPSS_VENC_CLOCK_SEL, 1);
> +			vpss_enable_clock(VPSS_VPBE_CLOCK, 1);
> +			__raw_writel(DM365_VPSS_VENCCLKEN_ENABLE +
> +				DM365_VPSS_DACCLKEN_ENABLE, vpss_clkctl_reg);
> +		} else {
> +			/* set sysclk4 to output 74.25 MHz from pll1 */
> +			__raw_writel(DM365_VPSS_PLLC2SYSCLK5 +
> +				DM365_VPSS_DACCLKEN_ENABLE +
> +				DM365_VPSS_VENCCLKEN_ENABLE, vpss_clkctl_reg);
> +		}
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}

Since you write to vpss_clkctl_reg anyway, it will be neater to actually
use a variable to store the value to be written and write the register
only once, in the end.

> +	return ret;
> +}
> +
> +static struct platform_device dm365_vpbe_display = {
> +	.name		= "vpbe-v4l2",
> +	.id		= -1,
> +	.num_resources  = ARRAY_SIZE(dm365_v4l2_disp_resources),
> +	.resource	= dm365_v4l2_disp_resources,
> +	.dev		= {
> +		.dma_mask		= &dm365_video_dma_mask,
> +		.coherent_dma_mask	= DMA_BIT_MASK(32),
> +	},
> +};
> +
> +struct venc_platform_data dm365_venc_pdata = {
> +	.venc_type	= VPBE_VERSION_2,

As mentioned above, such IP version passing from platform data is better
avoided.

> +	.setup_pinmux	= dm365_vpbe_setup_pinmux,
> +	.setup_clock	= dm365_venc_setup_clock,
> +};
> +
> +static struct platform_device dm365_venc_dev = {
> +	.name		= VPBE_VENC_SUBDEV_NAME,
> +	.id		= -1,
> +	.num_resources	= ARRAY_SIZE(dm365_venc_resources),
> +	.resource	= dm365_venc_resources,
> +	.dev		= {
> +		.dma_mask		= &dm365_video_dma_mask,
> +		.coherent_dma_mask	= DMA_BIT_MASK(32),
> +		.platform_data		= (void *)&dm365_venc_pdata,
> +	},
> +};
> +
> +static struct platform_device dm365_vpbe_dev = {
> +	.name		= "vpbe_controller",
> +	.id		= -1,
> +	.dev		= {
> +		.dma_mask		= &dm365_video_dma_mask,
> +		.coherent_dma_mask	= DMA_BIT_MASK(32),
> +	},
> +};
> +
> +int __init dm365_init_video(struct vpfe_config *vpfe_cfg,
> +				struct vpbe_config *vpbe_cfg)
> +{
> +	if (vpfe_cfg || vpbe_cfg)
> +		platform_device_register(&dm365_vpss_device);
> +
> +	if (vpfe_cfg) {
> +		vpfe_capture_dev.dev.platform_data = vpfe_cfg;
> +		platform_device_register(&dm365_isif_dev);
> +		platform_device_register(&vpfe_capture_dev);
> +		/* Add isif clock alias */
> +		clk_add_alias("master", dm365_isif_dev.name, "vpss_master",
> +					NULL);

Why add clock aliases? Why not just fix the clk_get() call to use the
right con_id (or fix the clock look-up in platform code)?

Thanks,
Sekhar
