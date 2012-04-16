Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2DPJv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:51:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60207 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2DPJv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:51:58 -0400
MIME-Version: 1.0
In-Reply-To: <4F883E92.60001@canonical.com>
References: <1334316377-23915-1-git-send-email-bryan.wu@canonical.com>
 <1334316377-23915-2-git-send-email-bryan.wu@canonical.com> <4F883E92.60001@canonical.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 16 Apr 2012 17:51:37 +0800
X-Google-Sender-Auth: wVuLy3-ZIUVhrQLDjGtVrWvKNbk
Message-ID: <CAK5ve-K=KUO+uNK7bJw_RFJ55oid=q36tFHmqLJmeGdRxkt=wg@mail.gmail.com>
Subject: Re: [PATCH 01/18] led-triggers: create a trigger for CPU activity
To: tim.gardner@canonical.com
Cc: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 10:56 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> On 04/13/2012 05:26 AM, Bryan Wu wrote:
>> Attempting to consolidate the ARM LED code, this removes the
>> custom RealView LED trigger code to turn LEDs on and off in
>> response to CPU activity and replace it with a standard trigger.
>>
>> (bryan.wu@canonical.com:
>> It moves arch/arm/kernel/leds.c syscore stubs into this trigger.
>> It also provides ledtrig_cpu trigger event stub in <linux/leds.h>.
>> Although it was inspired by ARM work, it can be used in other arch.)
>>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
>>
>> Reviewed-by: Jamie Iles <jamie@jamieiles.com>
>> Tested-by: Jochen Friedrich <jochen@scram.de>
>> ---
>>  drivers/leds/Kconfig       |   10 ++++
>>  drivers/leds/Makefile      |    1 +
>>  drivers/leds/ledtrig-cpu.c |  133 ++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/leds.h       |   23 ++++++++
>>  4 files changed, 167 insertions(+)
>>  create mode 100644 drivers/leds/ledtrig-cpu.c
>>
>> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
>> index 9f2b8dd..6e445a0 100644
>> --- a/drivers/leds/Kconfig
>> +++ b/drivers/leds/Kconfig
>> @@ -457,6 +457,16 @@ config LEDS_TRIGGER_BACKLIGHT
>>
>>         If unsure, say N.
>>
>> +config LEDS_TRIGGER_CPU
>> +     tristate "LED CPU Trigger"
>> +     depends on LEDS_TRIGGERS
>> +     help
>> +       This allows LEDs to be controlled by active CPUs. This shows
>> +       the active CPUs across an array of LEDs so you can see what
>> +       CPUs are active on the system at any given moment.
>> +
>> +       If unsure, say N.
>> +
>>  config LEDS_TRIGGER_GPIO
>>       tristate "LED GPIO Trigger"
>>       depends on LEDS_TRIGGERS
>> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
>> index 14481cf..8bb20e6 100644
>> --- a/drivers/leds/Makefile
>> +++ b/drivers/leds/Makefile
>> @@ -55,4 +55,5 @@ obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK) += ledtrig-ide-disk.o
>>  obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT) += ledtrig-heartbeat.o
>>  obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT) += ledtrig-backlight.o
>>  obj-$(CONFIG_LEDS_TRIGGER_GPIO)              += ledtrig-gpio.o
>> +obj-$(CONFIG_LEDS_TRIGGER_CPU)               += ledtrig-cpu.o
>>  obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)        += ledtrig-default-on.o
>> diff --git a/drivers/leds/ledtrig-cpu.c b/drivers/leds/ledtrig-cpu.c
>> new file mode 100644
>> index 0000000..52ef19c
>> --- /dev/null
>> +++ b/drivers/leds/ledtrig-cpu.c
>> @@ -0,0 +1,133 @@
>> +/*
>> + * ledtrig-cpu.c - LED trigger based on CPU activity
>> + *
>> + * This LED trigger will be registered for each possible CPU and named as
>> + * cpu0, cpu1, cpu2, cpu3, etc.
>> + *
>> + * It can be binded with any LEDs as other triggers does, either in board
>> + * file or via sysfs interface.
>> + *
>
> "It can be bound to any LED just like other triggers using either a
> board file or via sysfs interface."
>

My poor English, I will update it.

>> + * An API named ledtrig_cpu is exported for any user, who want to add CPU
>> + * activity indication in their code
>> + *
>> + * Copyright 2011 Linus Walleij <linus.walleij@linaro.org>
>> + * Copyright 2011 - 2012 Bryan Wu <bryan.wu@canonical.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/kernel.h>
>> +#include <linux/init.h>
>> +#include <linux/slab.h>
>> +#include <linux/percpu.h>
>> +#include <linux/syscore_ops.h>
>> +#include "leds.h"
>> +
>> +#define MAX_NAME_LEN 8
>> +
>
> This length accommodates up to 10000 CPUs. How long will that suffice ?
>

How about this:
#define MAX_NAME_LEN    (4 + DIV_ROUND_UP(NR_CPUS, 255))


>> +static DEFINE_PER_CPU(struct led_trigger *, cpu_trig);
>> +static DEFINE_PER_CPU(char [MAX_NAME_LEN], trig_name);
>> +
>> +void ledtrig_cpu(enum cpu_led_event ledevt)
>> +{
>> +     struct led_trigger *trig = __get_cpu_var(cpu_trig);
>> +
>> +     if (!trig)
>> +             return;
>
> I don't think __get_cpu_var(cpu_trig) _should_ ever return NULL. See
> discussion about exclusion below in ledtrig_cpu_init().
>
>> +
>> +     /* Locate the correct CPU LED */
>> +     switch (ledevt) {
>> +     case CPU_LED_IDLE_END:
>> +     case CPU_LED_START:
>> +             /* Will turn the LED on, max brightness */
>> +             led_trigger_event(trig, LED_FULL);
>> +             break;
>> +
>> +     case CPU_LED_IDLE_START:
>> +     case CPU_LED_STOP:
>> +     case CPU_LED_HALTED:
>> +             /* Will turn the LED off */
>> +             led_trigger_event(trig, LED_OFF);
>> +             break;
>> +
>> +     default:
>> +             /* Will leave the LED as it is */
>> +             break;
>> +     }
>> +}
>> +EXPORT_SYMBOL(ledtrig_cpu);
>> +
>> +static int ledtrig_cpu_syscore_suspend(void)
>> +{
>> +     ledtrig_cpu(CPU_LED_STOP);
>> +     return 0;
>> +}
>> +
>> +static void ledtrig_cpu_syscore_resume(void)
>> +{
>> +     ledtrig_cpu(CPU_LED_START);
>> +}
>> +
>> +static void ledtrig_cpu_syscore_shutdown(void)
>> +{
>> +     ledtrig_cpu(CPU_LED_HALTED);
>> +}
>> +
>> +static struct syscore_ops ledtrig_cpu_syscore_ops = {
>> +     .shutdown       = ledtrig_cpu_syscore_shutdown,
>> +     .suspend        = ledtrig_cpu_syscore_suspend,
>> +     .resume         = ledtrig_cpu_syscore_resume,
>> +};
>> +
>> +static int __init ledtrig_cpu_init(void)
>> +{
>> +     int cpu;
>> +
>> +     /*
>> +      * Registering CPU led trigger for each CPU cores here
>> +      * ignores CPU hotplug, but after this CPU hotplug works
>> +      * fine with this trigger.
>> +      */
>> +     for_each_possible_cpu(cpu) {
>> +             struct led_trigger *trig;
>> +             char *name = per_cpu(trig_name, cpu);
>> +
>> +             snprintf(name, MAX_NAME_LEN, "cpu%d", cpu);
>> +             led_trigger_register_simple(name, &trig);
>
> Check for trig == NULL. led_trigger_register_simple() does a
> kzalloc(GFP_KERNEL). You'll also have to unwind any successful
> registrations. Perhaps carve the guts out of ledtrig_cpu_exit() into a
> function that can be called from either place.
>

Actually, led_trigger_register_simple() will take care of kzalloc()
failure. And if so trig will be NULL. I think it's unnecessary to
check trig == NULL here and unwind any passed registrations, since
those registration failure on for one CPU has no relationship with
other successful registrations.

So it is necessary for us to check trig==NULL in ledtrig_cpu().

> Furthermore, I think there is a race here. As soon as
> led_trigger_register_simple() has completed, then the trigger is
> available for use. Won't you need some kind of exclusion to block
> consumers before trig is assigned ?

Hmmm, looks like I need setup an lock to make sure
led_trigger_register_simple() and trig assignment will not completed
before any usage.

> There is a similar problem in ledtrig_cpu().

ledtrig_cpu() will check trig==NULL, I don't think there is this
issue, isn't it?

>
>> +             per_cpu(cpu_trig, cpu) = trig;
>> +
>> +             pr_info("LED trigger %s indicate activity on CPU %d\n",
>> +                     trig->name, cpu);
>
> This seems like an unnecessary log filler, especially as the number of
> CPUs becomes large. How about just a single line after the loop completes ?
>

OK, I will move it out as one line kernel message.

Thanks for reviewing,
-Bryan
