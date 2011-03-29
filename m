Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab1C2J7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:59:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42354 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1C2J7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:59:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=peRFKYkA26WcZS76moYSG76CYqm0rOpN5MaOG3HOHWGzv5DwYtZjY/eJkPqpRQHnOb
         IkPvjMKAJT7JpIwX+ebl1meHcniIPTo5UjU7PRdRYpFc+6OL+oXsG7xGiIPbq99pi8km
         sa7ZCAFGC2EwPPXnnWLjuSRDbz9wC73csEhCA=
MIME-Version: 1.0
In-Reply-To: <1301392380-9022-1-git-send-email-marek.belisko@open-nandra.com>
References: <AANLkTi=RW0o=+hXcO0Y04nq10QEd=hWY0Nzc0enJ=Tr7@mail.gmail.com>
	<1301392380-9022-1-git-send-email-marek.belisko@open-nandra.com>
Date: Tue, 29 Mar 2011 11:59:15 +0200
Message-ID: <AANLkTikE6pnKmpp8JVMwjKuQbhery6DGR23YjaC6KsZ8@mail.gmail.com>
Subject: Re: [PATCH] s3c2440: mini2440: Use leds-gpio driver for board leds handling.
From: Belisko Marek <marek.belisko@gmail.com>
To: ben-linux@fluff.org, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2T9xPud013245

This should be in-reply-to https://lkml.org/lkml/2011/3/29/79 comments

On Tue, Mar 29, 2011 at 11:53 AM, Marek Belisko
<marek.belisko@open-nandra.com> wrote:
> Intention of this patch is convert existing usage of leds-s3c24xx driver
> to use generic gpio-leds driver. Leds are separated to 2 devices.
> First device handle 4 available leds. Second device is used to drive
> LCD backlight. Backlight can be controlled via parameter b so we need
> separate device which is registered or not depending on parameter.
>
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> ---
>  arch/arm/mach-s3c2440/mach-mini2440.c |  121 +++++++++++++++------------------
>  1 files changed, 54 insertions(+), 67 deletions(-)
>
> diff --git a/arch/arm/mach-s3c2440/mach-mini2440.c b/arch/arm/mach-s3c2440/mach-mini2440.c
> index 163d318..28ef6eb 100644
> --- a/arch/arm/mach-s3c2440/mach-mini2440.c
> +++ b/arch/arm/mach-s3c2440/mach-mini2440.c
> @@ -419,81 +419,71 @@ static struct platform_device mini2440_button_device = {
>  };
>
>  /* LEDS */
> -
> -static struct s3c24xx_led_platdata mini2440_led1_pdata = {
> -       .name           = "led1",
> -       .gpio           = S3C2410_GPB(5),
> -       .flags          = S3C24XX_LEDF_ACTLOW | S3C24XX_LEDF_TRISTATE,
> -       .def_trigger    = "heartbeat",
> -};
> -
> -static struct s3c24xx_led_platdata mini2440_led2_pdata = {
> -       .name           = "led2",
> -       .gpio           = S3C2410_GPB(6),
> -       .flags          = S3C24XX_LEDF_ACTLOW | S3C24XX_LEDF_TRISTATE,
> -       .def_trigger    = "nand-disk",
> -};
> -
> -static struct s3c24xx_led_platdata mini2440_led3_pdata = {
> -       .name           = "led3",
> -       .gpio           = S3C2410_GPB(7),
> -       .flags          = S3C24XX_LEDF_ACTLOW | S3C24XX_LEDF_TRISTATE,
> -       .def_trigger    = "mmc0",
> -};
> -
> -static struct s3c24xx_led_platdata mini2440_led4_pdata = {
> -       .name           = "led4",
> -       .gpio           = S3C2410_GPB(8),
> -       .flags          = S3C24XX_LEDF_ACTLOW | S3C24XX_LEDF_TRISTATE,
> -       .def_trigger    = "",
> -};
> -
> -static struct s3c24xx_led_platdata mini2440_led_backlight_pdata = {
> -       .name           = "backlight",
> -       .gpio           = S3C2410_GPG(4),
> -       .def_trigger    = "backlight",
> +static struct gpio_led gpio_leds[] = {
> +       {
> +               .name                   = "led1",
> +               .gpio                   = S3C2410_GPB(5),
> +               .active_low             = 1,
> +               .default_trigger        = "heartbeat",
> +       },
> +       {
> +               .name                   = "led2",
> +               .gpio                   = S3C2410_GPB(6),
> +               .active_low             = 1,
> +               .default_trigger        = "nand-disk",
> +               .default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +       },
> +       {
> +               .name                   = "led3",
> +               .gpio                   = S3C2410_GPB(7),
> +               .active_low             = 1,
> +               .default_trigger        = "mmc0",
> +               .default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +       },
> +       {
> +               .name                   = "led4",
> +               .gpio                   = S3C2410_GPB(8),
> +               .active_low             = 1,
> +               .default_trigger        = "none",
> +               .default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +       }
>  };
>
> -static struct platform_device mini2440_led1 = {
> -       .name           = "s3c24xx_led",
> -       .id             = 1,
> -       .dev            = {
> -               .platform_data  = &mini2440_led1_pdata,
> -       },
> +static struct gpio_led backlight_led[] = {
> +       {
> +               .name                   = "backlight",
> +               .gpio                   = S3C2410_GPG(4),
> +               .active_low             = 0,
> +               .default_trigger        = "backlight",
> +               .default_state          = LEDS_GPIO_DEFSTATE_ON,
> +       }
>  };
>
> -static struct platform_device mini2440_led2 = {
> -       .name           = "s3c24xx_led",
> -       .id             = 2,
> -       .dev            = {
> -               .platform_data  = &mini2440_led2_pdata,
> -       },
> +static struct gpio_led_platform_data gpio_led_info = {
> +       .leds           = gpio_leds,
> +       .num_leds       = ARRAY_SIZE(gpio_leds),
>  };
>
> -static struct platform_device mini2440_led3 = {
> -       .name           = "s3c24xx_led",
> -       .id             = 3,
> -       .dev            = {
> -               .platform_data  = &mini2440_led3_pdata,
> -       },
> +static struct gpio_led_platform_data backlight_info = {
> +       .leds           = backlight_led,
> +       .num_leds       = ARRAY_SIZE(backlight_led),
>  };
>
> -static struct platform_device mini2440_led4 = {
> -       .name           = "s3c24xx_led",
> -       .id             = 4,
> -       .dev            = {
> -               .platform_data  = &mini2440_led4_pdata,
> -       },
> +static struct platform_device mini2440_leds = {
> +       .name   = "leds-gpio",
> +       .id     = 0,
> +       .dev    = {
> +               .platform_data  = &gpio_led_info,
> +       }
>  };
>
>  static struct platform_device mini2440_led_backlight = {
> -       .name           = "s3c24xx_led",
> -       .id             = 5,
> -       .dev            = {
> -               .platform_data  = &mini2440_led_backlight_pdata,
> -       },
> +       .name   = "leds-gpio",
> +       .id     = 1,
> +       .dev    = {
> +               .platform_data  = &backlight_info,
> +       }
>  };
> -
>  /* AUDIO */
>
>  static struct s3c24xx_uda134x_platform_data mini2440_audio_pins = {
> @@ -543,10 +533,7 @@ static struct platform_device *mini2440_devices[] __initdata = {
>        &s3c_device_rtc,
>        &s3c_device_usbgadget,
>        &mini2440_device_eth,
> -       &mini2440_led1,
> -       &mini2440_led2,
> -       &mini2440_led3,
> -       &mini2440_led4,
> +       &mini2440_leds,
>        &mini2440_button_device,
>        &s3c_device_nand,
>        &s3c_device_sdi,
> --
> 1.7.1
>
>

regards,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
