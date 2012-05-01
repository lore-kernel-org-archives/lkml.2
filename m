Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab2EAQGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:06:12 -0400
Received: from mail.tpi.com ([70.99.223.143]:3443 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757704Ab2EAQGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:06:10 -0400
Message-ID: <4FA009B8.9030601@canonical.com>
Date: Tue, 01 May 2012 10:05:12 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Bryan Wu <bryan.wu@canonical.com>
CC: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org
Subject: Re: [PATCH 02/19] led-triggers: create a trigger for CPU activity
References: <1335884506-15370-1-git-send-email-bryan.wu@canonical.com> <1335884506-15370-3-git-send-email-bryan.wu@canonical.com>
In-Reply-To: <1335884506-15370-3-git-send-email-bryan.wu@canonical.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 09:01 AM, Bryan Wu wrote:
> Attempting to consolidate the ARM LED code, this removes the
> custom RealView LED trigger code to turn LEDs on and off in
> response to CPU activity and replace it with a standard trigger.
> 
> (bryan.wu@canonical.com:
> It introduces several syscore stubs into this trigger.
> It also provides ledtrig_cpu trigger event stub in <linux/leds.h>.
> Although it was inspired by ARM work, it can be used in other arch.)
> 
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> Reviewed-by: Jamie Iles <jamie@jamieiles.com>
> Tested-by: Jochen Friedrich <jochen@scram.de>
> ---
>  drivers/leds/Kconfig       |   10 +++
>  drivers/leds/Makefile      |    1 +
>  drivers/leds/ledtrig-cpu.c |  163 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/leds.h       |   16 +++++
>  4 files changed, 190 insertions(+)
>  create mode 100644 drivers/leds/ledtrig-cpu.c
> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 5f12659..dbf8a4c 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -465,6 +465,16 @@ config LEDS_TRIGGER_BACKLIGHT
>  
>  	  If unsure, say N.
>  
> +config LEDS_TRIGGER_CPU
> +	tristate "LED CPU Trigger"
> +	depends on LEDS_TRIGGERS
> +	help
> +	  This allows LEDs to be controlled by active CPUs. This shows
> +	  the active CPUs across an array of LEDs so you can see which
> +	  CPUs are active on the system at any given moment.
> +
> +	  If unsure, say N.
> +
>  config LEDS_TRIGGER_GPIO
>  	tristate "LED GPIO Trigger"
>  	depends on LEDS_TRIGGERS
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 9475bbb..ea1efb2 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -56,4 +56,5 @@ obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
>  obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
>  obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
>  obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
> +obj-$(CONFIG_LEDS_TRIGGER_CPU)		+= ledtrig-cpu.o
>  obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
> diff --git a/drivers/leds/ledtrig-cpu.c b/drivers/leds/ledtrig-cpu.c
> new file mode 100644
> index 0000000..b312056
> --- /dev/null
> +++ b/drivers/leds/ledtrig-cpu.c
> @@ -0,0 +1,163 @@
> +/*
> + * ledtrig-cpu.c - LED trigger based on CPU activity
> + *
> + * This LED trigger will be registered for each possible CPU and named as
> + * cpu0, cpu1, cpu2, cpu3, etc.
> + *
> + * It can be bound to any LED just like other triggers using either a
> + * board file or via sysfs interface.
> + *
> + * An API named ledtrig_cpu is exported for any user, who want to add CPU
> + * activity indication in their code
> + *
> + * Copyright 2011 Linus Walleij <linus.walleij@linaro.org>
> + * Copyright 2011 - 2012 Bryan Wu <bryan.wu@canonical.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/percpu.h>
> +#include <linux/syscore_ops.h>
> +#include <linux/rwsem.h>
> +#include "leds.h"
> +
> +#define MAX_NAME_LEN	8
> +
> +struct led_trigger_cpu {
> +	char name[MAX_NAME_LEN];
> +	struct led_trigger *_trig;
> +	struct mutex lock;
> +	int lock_is_inited;
> +};
> +
> +static DEFINE_PER_CPU(struct led_trigger_cpu, cpu_trig);
> +
> +/**
> + * ledtrig_cpu - emit a CPU event as a trigger
> + * @evt: CPU event to be emitted
> + *
> + * Emit a CPU event on a CPU core, which will trigger a
> + * binded LED to turn on or turn off.
> + */
> +void ledtrig_cpu(enum cpu_led_event ledevt)
> +{
> +	struct led_trigger_cpu *trig = &__get_cpu_var(cpu_trig);
> +
> +	/* mutex lock should be initialized before calling mutex_call() */
> +	if (!trig->lock_is_inited)
> +		return;

I still think lock_is_inited is superfluous, but whatever, it ought to work.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
