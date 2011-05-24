Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1EXJf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:35:59 -0400
Received: from smtp4.mail.ru ([94.100.176.44]:34063 "EHLO smtp4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab1EXJf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:35:57 -0400
Date: Tue, 24 May 2011 13:35:52 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH v3 3/3] pxa/hx4700: add platform device and
 I2C info for AK4641 codec
Message-ID: <20110524093552.GA27496@rainbow>
References: <1305732311-17639-1-git-send-email-mad_soft@inbox.ru>
 <1305732311-17639-4-git-send-email-mad_soft@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305732311-17639-4-git-send-email-mad_soft@inbox.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Eric!

What about this patch? Can you merge it through PXA tree or give an ack
to Mark for merging through ASoC tree? Patches 1 and 2 already hit Linus'
tree, so the only piece is missing is this tiny platform device glue. It
would be nice to have working audio on hx4700 in 2.6.40 (or 3.0 - whatever
Linus will call it).

On 19:25 Wed 18 May     , Dmitry Artamonow wrote:
> Also rename AK4641 power GPIOs to document the codec chip.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> ---
>  arch/arm/mach-pxa/hx4700.c              |   25 +++++++++++++++++++++++++
>  arch/arm/mach-pxa/include/mach/hx4700.h |    4 ++--
>  2 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/hx4700.c b/arch/arm/mach-pxa/hx4700.c
> index 6de0ad0..4a569f7 100644
> --- a/arch/arm/mach-pxa/hx4700.c
> +++ b/arch/arm/mach-pxa/hx4700.c
> @@ -45,6 +45,7 @@
>  #include <mach/hx4700.h>
>  #include <mach/irda.h>
>  
> +#include <sound/ak4641.h>
>  #include <video/platform_lcd.h>
>  #include <video/w100fb.h>
>  
> @@ -801,6 +802,28 @@ static struct i2c_board_info __initdata pi2c_board_info[] = {
>  };
>  
>  /*
> + * Asahi Kasei AK4641 on I2C
> + */
> +
> +static struct ak4641_platform_data ak4641_info = {
> +	.gpio_power = GPIO27_HX4700_AK4641_POWER,
> +	.gpio_npdn  = GPIO109_HX4700_AK4641_nPDN,
> +};
> +
> +static struct i2c_board_info i2c_board_info[] __initdata = {
> +	{
> +		I2C_BOARD_INFO("ak4641", 0x12),
> +		.platform_data = &ak4641_info,
> +	},
> +};
> +
> +static struct platform_device audio = {
> +	.name	= "hx4700-audio",
> +	.id	= -1,
> +};
> +
> +
> +/*
>   * PCMCIA
>   */
>  
> @@ -826,6 +849,7 @@ static struct platform_device *devices[] __initdata = {
>  	&gpio_vbus,
>  	&power_supply,
>  	&strataflash,
> +	&audio,
>  	&pcmcia,
>  };
>  
> @@ -859,6 +883,7 @@ static void __init hx4700_init(void)
>  	pxa_set_ficp_info(&ficp_info);
>  	pxa27x_set_i2c_power_info(NULL);
>  	pxa_set_i2c_info(NULL);
> +	i2c_register_board_info(0, ARRAY_AND_SIZE(i2c_board_info));
>  	i2c_register_board_info(1, ARRAY_AND_SIZE(pi2c_board_info));
>  	pxa2xx_set_spi_info(2, &pxa_ssp2_master_info);
>  	spi_register_board_info(ARRAY_AND_SIZE(tsc2046_board_info));
> diff --git a/arch/arm/mach-pxa/include/mach/hx4700.h b/arch/arm/mach-pxa/include/mach/hx4700.h
> index 3740844..73cd586 100644
> --- a/arch/arm/mach-pxa/include/mach/hx4700.h
> +++ b/arch/arm/mach-pxa/include/mach/hx4700.h
> @@ -29,7 +29,7 @@
>  #define GPIO14_HX4700_nWLAN_IRQ			14
>  #define GPIO18_HX4700_RDY			18
>  #define GPIO22_HX4700_LCD_RL			22
> -#define GPIO27_HX4700_CODEC_ON			27
> +#define GPIO27_HX4700_AK4641_POWER		27
>  #define GPIO32_HX4700_RS232_ON			32
>  #define GPIO52_HX4700_CPU_nBATT_FAULT		52
>  #define GPIO58_HX4700_TSC2046_nPENIRQ		58
> @@ -67,7 +67,7 @@
>  #define GPIO105_HX4700_nIR_ON			105
>  #define GPIO106_HX4700_CPU_BT_nRESET		106
>  #define GPIO107_HX4700_SPK_nSD			107
> -#define GPIO109_HX4700_CODEC_nPDN		109
> +#define GPIO109_HX4700_AK4641_nPDN		109
>  #define GPIO110_HX4700_LCD_LVDD_3V3_ON		110
>  #define GPIO111_HX4700_LCD_AVDD_3V3_ON		111
>  #define GPIO112_HX4700_LCD_N2V7_7V3_ON		112
> -- 
> 1.7.4.rc3
> 
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel

-- 
Best regards,
Dmitry "MAD" Artamonow

