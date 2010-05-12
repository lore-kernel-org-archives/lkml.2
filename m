Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab0ELRU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:20:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52575 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab0ELRUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:20:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fGpKfVnNPNA0WA9uzH8Afzc7J/8QjhLOnV4yHphWm2JnT61W4enp4X0MS4t6HQc4wO
         y1S3SFE36MtMlv4Y0cpRcc0px3P+4DpnKeCES+J3vp+HjcxjKKFehmrupXjB5pmUw1D5
         QFzxx70zIB/WqKgVTjm+tnFX6jlWP8bkJ67dE=
MIME-Version: 1.0
In-Reply-To: <1273522021-14436-4-git-send-email-ulli.kroll@googlemail.com>
References: <1273522021-14436-1-git-send-email-ulli.kroll@googlemail.com>
	 <1273522021-14436-4-git-send-email-ulli.kroll@googlemail.com>
Date: Wed, 12 May 2010 19:20:52 +0200
Message-ID: <AANLkTinN72g2fdISEyYevS2QDeXtmK_8sGE9R1H2U245@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: Gemini: add support for Raidsonic IB4220
From: Janos Laube <janos.dev@gmail.com>
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Cc: paulius.zaleckas@gmail.com, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Janos Laube <janos.dev@gmail.com>

On Mon, May 10, 2010 at 10:07 PM, Hans Ulli Kroll
<ulli.kroll@googlemail.com> wrote:
> From: Janos Laube <janos.dev@gmail.com>
>
> Add support for Nasbox IB4220 from Raidsonic.
>
> Signed-off-by: Janos Laube <janos.dev@gmail.com>
> Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
> ---
>  arch/arm/mach-gemini/Kconfig          |    7 ++
>  arch/arm/mach-gemini/Makefile         |    1 +
>  arch/arm/mach-gemini/board-nas4220b.c |  111 +++++++++++++++++++++++++++++++++
>  3 files changed, 119 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-gemini/board-nas4220b.c
>
> diff --git a/arch/arm/mach-gemini/Kconfig b/arch/arm/mach-gemini/Kconfig
> index 7997500..6f066ee 100644
> --- a/arch/arm/mach-gemini/Kconfig
> +++ b/arch/arm/mach-gemini/Kconfig
> @@ -2,6 +2,13 @@ if ARCH_GEMINI
>
>  menu "Cortina Systems Gemini Implementations"
>
> +config MACH_NAS4220B
> +       bool "Raidsonic NAS-4220-B"
> +       select GEMINI_MEM_SWAP
> +       help
> +         Say Y here if you intend to run this kernel on a
> +         Raidsonic NAS-4220-B.
> +
>  config MACH_RUT100
>        bool "Teltonika RUT100"
>        select GEMINI_MEM_SWAP
> diff --git a/arch/arm/mach-gemini/Makefile b/arch/arm/mach-gemini/Makefile
> index 8e02c47..c5b24b9 100644
> --- a/arch/arm/mach-gemini/Makefile
> +++ b/arch/arm/mach-gemini/Makefile
> @@ -7,6 +7,7 @@
>  obj-y                  := irq.o mm.o time.o devices.o gpio.o
>
>  # Board-specific support
> +obj-$(CONFIG_MACH_NAS4220B)    += board-nas4220b.o
>  obj-$(CONFIG_MACH_RUT100)      += board-rut1xx.o
>  obj-$(CONFIG_MACH_WBD111)      += board-wbd111.o
>  obj-$(CONFIG_MACH_WBD222)      += board-wbd222.o
> diff --git a/arch/arm/mach-gemini/board-nas4220b.c b/arch/arm/mach-gemini/board-nas4220b.c
> new file mode 100644
> index 0000000..01f1d6d
> --- /dev/null
> +++ b/arch/arm/mach-gemini/board-nas4220b.c
> @@ -0,0 +1,111 @@
> +/*
> + *  Support for Raidsonic NAS-4220-B
> + *
> + *  Copyright (C) 2009 Janos Laube <janos.dev@gmail.com>
> + *
> + * based on rut1xx.c
> + *  Copyright (C) 2008 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/leds.h>
> +#include <linux/input.h>
> +#include <linux/gpio_keys.h>
> +#include <linux/mdio-gpio.h>
> +#include <linux/io.h>
> +
> +#include <asm/setup.h>
> +#include <asm/mach-types.h>
> +#include <asm/mach/arch.h>
> +#include <asm/mach/time.h>
> +
> +#include <mach/hardware.h>
> +#include <mach/global_reg.h>
> +
> +#include "common.h"
> +
> +static struct sys_timer ib4220b_timer = {
> +       .init   = gemini_timer_init,
> +};
> +
> +static struct gpio_led ib4220b_leds[] = {
> +       {
> +               .name                   = "nas4220b:orange:hdd",
> +               .default_trigger        = "none",
> +               .gpio                   = 60,
> +       },
> +       {
> +               .name                   = "nas4220b:green:os",
> +               .default_trigger        = "heartbeat",
> +               .gpio                   = 62,
> +       },
> +};
> +
> +static struct gpio_led_platform_data ib4220b_leds_data = {
> +       .num_leds       = ARRAY_SIZE(ib4220b_leds),
> +       .leds           = ib4220b_leds,
> +};
> +
> +static struct platform_device ib4220b_led_device = {
> +       .name   = "leds-gpio",
> +       .id     = -1,
> +       .dev    = {
> +               .platform_data = &ib4220b_leds_data,
> +       },
> +};
> +
> +static struct gpio_keys_button ib4220b_keys[] = {
> +       {
> +               .code           = KEY_SETUP,
> +               .gpio           = 61,
> +               .active_low     = 1,
> +               .desc           = "Backup Button",
> +               .type           = EV_KEY,
> +       },
> +       {
> +               .code           = KEY_RESTART,
> +               .gpio           = 63,
> +               .active_low     = 1,
> +               .desc           = "Softreset Button",
> +               .type           = EV_KEY,
> +       },
> +};
> +
> +static struct gpio_keys_platform_data ib4220b_keys_data = {
> +       .buttons        = ib4220b_keys,
> +       .nbuttons       = ARRAY_SIZE(ib4220b_keys),
> +};
> +
> +static struct platform_device ib4220b_key_device = {
> +       .name   = "gpio-keys",
> +       .id     = -1,
> +       .dev    = {
> +               .platform_data = &ib4220b_keys_data,
> +       },
> +};
> +
> +static void __init ib4220b_init(void)
> +{
> +       gemini_gpio_init();
> +       platform_register_uart();
> +       platform_register_pflash(SZ_16M, NULL, 0);
> +       platform_device_register(&ib4220b_led_device);
> +       platform_device_register(&ib4220b_key_device);
> +}
> +
> +MACHINE_START(NAS4220B, "Raidsonic NAS IB-4220-B")
> +       .phys_io        = 0x7fffc000,
> +       .io_pg_offst    = ((0xffffc000) >> 18) & 0xfffc,
> +       .boot_params    = 0x100,
> +       .map_io         = gemini_map_io,
> +       .init_irq       = gemini_init_irq,
> +       .timer          = &ib4220b_timer,
> +       .init_machine   = ib4220b_init,
> +MACHINE_END
> --
> 1.7.0.3
>
>
