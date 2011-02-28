Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab1B1GQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:16:46 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:42850 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1B1GQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:16:45 -0500
Date: Mon, 28 Feb 2011 15:16:40 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 08/09] ARM: s3c2440: gta02: Request usb pullup pin before
 using it
In-reply-to: <1297043521-21903-8-git-send-email-lars@metafoo.de>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Ben Dooks'" <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-id: <000301cbd70f$12367070$36a35150$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcvGalvZ4dBwGVwzSGqZ/sPGiL2+/gQox6kQ
References: <1297043521-21903-1-git-send-email-lars@metafoo.de>
 <1297043521-21903-8-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter Clausen wrote:
> 
> Request the gpio pin used to control the usb pullup before using it to
avoid
> a
> runtime warning about an auto-requested gpio.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  arch/arm/mach-s3c2440/mach-gta02.c |   17 +++++++++++++++--
>  1 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c2440/mach-gta02.c
b/arch/arm/mach-s3c2440/mach-
> gta02.c
> index 1396639..94456fa 100644
> --- a/arch/arm/mach-s3c2440/mach-gta02.c
> +++ b/arch/arm/mach-s3c2440/mach-gta02.c
> @@ -451,11 +451,11 @@ static void gta02_udc_command(enum s3c2410_udc_cmd_e
> cmd)
>  	switch (cmd) {
>  	case S3C2410_UDC_P_ENABLE:
>  		pr_debug("%s S3C2410_UDC_P_ENABLE\n", __func__);
> -		gpio_direction_output(GTA02_GPIO_USB_PULLUP, 1);
> +		gpio_set_value(GTA02_GPIO_USB_PULLUP, 1);

How about following instead?
	gpio_request(GTA02_GPIO_USB_PULLUP, "USB_PULLUP");
	gpio_direction_output(GTA02_GPIO_USB_PULLUP, 1);
	gpio_free(GTA02_GPIO_USB_PULLUP);

>  		break;
>  	case S3C2410_UDC_P_DISABLE:
>  		pr_debug("%s S3C2410_UDC_P_DISABLE\n", __func__);
> -		gpio_direction_output(GTA02_GPIO_USB_PULLUP, 0);
> +		gpio_set_value(GTA02_GPIO_USB_PULLUP, 0);
>  		break;
>  	case S3C2410_UDC_P_RESET:
>  		pr_debug("%s S3C2410_UDC_P_RESET\n", __func__);
> @@ -572,11 +572,24 @@ static void gta02_poweroff(void)
>  	pcf50633_reg_set_bit_mask(gta02_pcf, PCF50633_REG_OOCSHDWN, 1, 1);
>  }
> 
> +static void gta02_request_gpios(void)
> +{
> +	int ret;
> +	ret = gpio_request_one(GTA02_GPIO_USB_PULLUP, GPIOF_OUT_INIT_LOW,
> +				"USB pullup");
> +	if (ret) {
> +		printk(KERN_ERR "Failed to request USB pullup gpio pin:
%d\n",
> +			ret);
> +	}
> +}
> +
>  static void __init gta02_machine_init(void)
>  {
>  	/* Set the panic callback to turn AUX LED on or off. */
>  	panic_blink = gta02_panic_blink;
> 
> +	gta02_request_gpios();
> +
>  	s3c_pm_init();
> 
>  #ifdef CONFIG_CHARGER_PCF50633
> --



Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

