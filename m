Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab2ABICQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 03:02:16 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:48410 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2ABICO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 03:02:14 -0500
MIME-Version: 1.0
In-Reply-To: <1325483675-21908-3-git-send-email-thomas.abraham@linaro.org>
References: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
	<1325483675-21908-2-git-send-email-thomas.abraham@linaro.org>
	<1325483675-21908-3-git-send-email-thomas.abraham@linaro.org>
Date: Mon, 2 Jan 2012 17:02:13 +0900
X-Google-Sender-Auth: YYddUckWoCRoYa6vpURgwZg0KfY
Message-ID: <CAH9JG2WjhSsqxPFj+DQrOKXzbHPhm1ddNYE2AeukS7u9c_LA-g@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/4] lcd: platform-lcd: Add support for Hydis
 hv070wsa lcd panel
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, cbou@mail.ru,
        kwangwoo.lee@gmail.com, augulis.darius@gmail.com, ben-linux@fluff.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's not clear to add the panel data at platform_lcd. It's board
specific and it's used the gpio only.
So no need to specific it like HYDIS_HV070WSA. just define
PLATFORM_LCD_GPIO or similar.

How do you think?

Thank you,
Kyungmin Park

On 1/2/12, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> Add Hydis hv070wsa lcd panel setup and control support in platform-lcd
> driver.
>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  drivers/video/backlight/Kconfig        |    6 ++++
>  drivers/video/backlight/platform_lcd.c |   49
> ++++++++++++++++++++++++++++++++
>  include/video/platform_lcd.h           |    6 ++++
>  3 files changed, 61 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/video/backlight/Kconfig
> b/drivers/video/backlight/Kconfig
> index 278aeaa..ef4e9a7 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -86,6 +86,12 @@ config LCD_PLATFORM
>  	  This driver provides a platform-device registered LCD power
>  	  control interface.
>
> +config LCD_HYDIS_HV070WSA
> +	tristate "Hydis HV070WSA LCD"
> +	depends on LCD_PLATFORM
> +	help
> +	  Enable support for Hydis HV070WSA lcd panel
> +
>  config LCD_TOSA
>  	tristate "Sharp SL-6000 LCD Driver"
>  	depends on SPI && MACH_TOSA
> diff --git a/drivers/video/backlight/platform_lcd.c
> b/drivers/video/backlight/platform_lcd.c
> index 707c81f..feb4fd0 100644
> --- a/drivers/video/backlight/platform_lcd.c
> +++ b/drivers/video/backlight/platform_lcd.c
> @@ -17,6 +17,7 @@
>  #include <linux/backlight.h>
>  #include <linux/lcd.h>
>  #include <linux/slab.h>
> +#include <linux/gpio.h>
>
>  #include <video/platform_lcd.h>
>
> @@ -160,10 +161,58 @@ static int platform_lcd_resume(struct platform_device
> *pdev)
>  #define platform_lcd_resume NULL
>  #endif
>
> +#ifdef CONFIG_LCD_HYDIS_HV070WSA
> +static int lcd_hv070wsa_init(struct platform_lcd *plcd)
> +{
> +	struct plat_lcd_hydis_hv070wsa_pdata *pdata = plcd->lcd_pdata;
> +	int err;
> +
> +	if (!pdata) {
> +		dev_err(plcd->us, "no platform data\n");
> +		return -EINVAL;
> +	}
> +
> +	err = gpio_request(pdata->gpio, "HV070WSA_GPIO");
> +	if (err) {
> +		dev_err(plcd->us, "gpio request failed for %d\n", pdata->gpio);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static void lcd_hv070wsa_deinit(struct platform_lcd *plcd)
> +{
> +	struct plat_lcd_hydis_hv070wsa_pdata *pdata = plcd->lcd_pdata;
> +
> +	gpio_free(pdata->gpio);
> +}
> +
> +static void lcd_hv070wsa_set_power(struct platform_lcd *plcd, unsigned int
> pwr)
> +{
> +	struct plat_lcd_hydis_hv070wsa_pdata *pdata = plcd->lcd_pdata;
> +
> +	gpio_direction_output(pdata->gpio, pwr);
> +}
> +
> +static struct plat_lcd_driver_data hv070wsa_driver_data = {
> +	.lcd_init	= lcd_hv070wsa_init,
> +	.lcd_deinit	= lcd_hv070wsa_deinit,
> +	.set_power	= lcd_hv070wsa_set_power,
> +};
> +#define HV070WSA_DRV_DATA ((kernel_ulong_t)&hv070wsa_driver_data)
> +#else
> +#define HV070WSA_DRV_DATA (kernel_ulong_t)NULL
> +#endif /* CONFIG_LCD_HYDIS_HV070WSA */
>
>  static struct platform_device_id platform_lcd_driver_ids[] = {
> +	{
> +		.name		= "hv070wsa",
> +		.driver_data	= HV070WSA_DRV_DATA,
> +	},
>  	{ },
>  };
> +MODULE_DEVICE_TABLE(platform, platform_lcd_driver_ids);
>
>  static struct platform_driver platform_lcd_driver = {
>  	.driver		= {
> diff --git a/include/video/platform_lcd.h b/include/video/platform_lcd.h
> index 8e6081a..d2fa188 100644
> --- a/include/video/platform_lcd.h
> +++ b/include/video/platform_lcd.h
> @@ -10,3 +10,9 @@
>   * published by the Free Software Foundation.
>   *
>  */
> +
> +#ifdef CONFIG_LCD_HYDIS_HV070WSA
> +struct plat_lcd_hydis_hv070wsa_pdata {
> +	unsigned int		gpio;
> +};
> +#endif
> --
> 1.6.6.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
