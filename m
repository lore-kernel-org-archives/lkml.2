Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab2EALqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 07:46:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59336 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2EALqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 07:46:18 -0400
MIME-Version: 1.0
In-Reply-To: <4F9E8D8C.9090704@canonical.com>
References: <1335771444-26361-1-git-send-email-bryan.wu@canonical.com>
 <1335771444-26361-3-git-send-email-bryan.wu@canonical.com> <4F9E8D8C.9090704@canonical.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 1 May 2012 19:45:57 +0800
X-Google-Sender-Auth: Wpo3X4tsjPkCj-IyXrMaLN6rVvQ
Message-ID: <CAK5ve-KEBY2kcMjcGAeFxWykxY7DnudJtK8WrpfwJYjOX+zSJw@mail.gmail.com>
Subject: Re: [PATCH 02/19] led-triggers: create a trigger for CPU activity
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 9:03 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> On 04/30/2012 01:37 AM, Bryan Wu wrote:
>> Attempting to consolidate the ARM LED code, this removes the
>> custom RealView LED trigger code to turn LEDs on and off in
>> response to CPU activity and replace it with a standard trigger.
>>
>> (bryan.wu@canonical.com:
>> It introduces several syscore stubs into this trigger.
>> It also provides ledtrig_cpu trigger event stub in <linux/leds.h>.
>> Although it was inspired by ARM work, it can be used in other arch.)
>>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
>> Reviewed-by: Jamie Iles <jamie@jamieiles.com>
>> Tested-by: Jochen Friedrich <jochen@scram.de>
>> ---
>>  drivers/leds/Kconfig       |   10 +++
>>  drivers/leds/Makefile      |    1 +
>>  drivers/leds/ledtrig-cpu.c |  150 ++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/leds.h       |   16 +++++
>>  4 files changed, 177 insertions(+)
>>  create mode 100644 drivers/leds/ledtrig-cpu.c
>>
>> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
>> index 5f12659..dbf8a4c 100644
>> --- a/drivers/leds/Kconfig
>> +++ b/drivers/leds/Kconfig
>> @@ -465,6 +465,16 @@ config LEDS_TRIGGER_BACKLIGHT
>>
>>         If unsure, say N.
>>
>> +config LEDS_TRIGGER_CPU
>> +     tristate "LED CPU Trigger"
>> +     depends on LEDS_TRIGGERS
>> +     help
>> +       This allows LEDs to be controlled by active CPUs. This shows
>> +       the active CPUs across an array of LEDs so you can see which
>> +       CPUs are active on the system at any given moment.
>> +
>> +       If unsure, say N.
>> +
>>  config LEDS_TRIGGER_GPIO
>>       tristate "LED GPIO Trigger"
>>       depends on LEDS_TRIGGERS
>> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
>> index 9475bbb..ea1efb2 100644
>> --- a/drivers/leds/Makefile
>> +++ b/drivers/leds/Makefile
>> @@ -56,4 +56,5 @@ obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK) += ledtrig-ide-disk.o
>>  obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT) += ledtrig-heartbeat.o
>>  obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT) += ledtrig-backlight.o
>>  obj-$(CONFIG_LEDS_TRIGGER_GPIO)              += ledtrig-gpio.o
>> +obj-$(CONFIG_LEDS_TRIGGER_CPU)               += ledtrig-cpu.o
>>  obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)        += ledtrig-default-on.o
>> diff --git a/drivers/leds/ledtrig-cpu.c b/drivers/leds/ledtrig-cpu.c
>> new file mode 100644
>> index 0000000..1f752e1
>> --- /dev/null
>> +++ b/drivers/leds/ledtrig-cpu.c
>> @@ -0,0 +1,150 @@
>> +/*
>> + * ledtrig-cpu.c - LED trigger based on CPU activity
>> + *
>> + * This LED trigger will be registered for each possible CPU and named as
>> + * cpu0, cpu1, cpu2, cpu3, etc.
>> + *
>> + * It can be bound to any LED just like other triggers using either a
>> + * board file or via sysfs interface.
>> + *
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
>> +#include <linux/rwsem.h>
>> +#include "leds.h"
>> +
>> +#define MAX_NAME_LEN 8
>> +
>> +static DEFINE_PER_CPU(struct led_trigger *, cpu_trig);
>> +static DEFINE_PER_CPU(char [MAX_NAME_LEN], trig_name);
>> +static DEFINE_PER_CPU(struct rw_semaphore, trig_lock);
>
> Semaphores are overkill for this. I think a simple 'struct mutex' is
> sufficient. Especially since there is unlikely to be much contention on
> any one of the locks. mutext_init(), mutext_lock(), mutex_unlock(), etc.
>

Indeed, I will change to mutex.

>> +
>> +/**
>> + * ledtrig_cpu - emit a CPU event as a trigger
>> + * @evt: CPU event to be emitted
>> + *
>> + * Emit a CPU event on a CPU core, which will trigger a
>> + * binded LED to turn on or turn off.
>> + */
>> +void ledtrig_cpu(enum cpu_led_event ledevt)
>> +{
>
> I think you still need to acquire trig_lock _before_ reading
> __get_cpu_var(cpu_trig). Otherwise, acquiring the lock in
> ledtrig_cpu_init() is useless.
>

I agree you are right, but call mutex_lock() here will prohibit
system booting, because mutex_lock() should be called after
mutex_init().
mutex_init() is called in module_init function, which is behind some
core functions calling ledtrig_cpu() API.

I plan to introduce a flag variable for checking before calling mutex_lock here.

>> +     struct led_trigger *trig = __get_cpu_var(cpu_trig);
>> +
>> +     if (!trig)
>> +             return;
>
> Unnecessary since led_trigger_event() also checks for (!trig).
>
> I've attached the changes I think you should make.
>

Thanks a lot, I will update my patch and post it again.

Best Regards,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
