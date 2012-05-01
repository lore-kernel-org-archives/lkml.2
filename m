Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab2EAMrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 08:47:47 -0400
Received: from mail.tpi.com ([70.99.223.143]:1956 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757561Ab2EAMrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 08:47:45 -0400
Message-ID: <4F9FDB32.9020105@canonical.com>
Date: Tue, 01 May 2012 06:46:42 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Bryan Wu <bryan.wu@canonical.com>
CC: Tim Gardner <tim.gardner@canonical.com>, linux@arm.linux.org.uk,
        rpurdie@rpsys.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        akpm@linux-foundation.org, arnd.bergmann@linaro.org,
        nicolas.pitre@linaro.org
Subject: Re: [PATCH 02/19] led-triggers: create a trigger for CPU activity
References: <1335771444-26361-1-git-send-email-bryan.wu@canonical.com> <1335771444-26361-3-git-send-email-bryan.wu@canonical.com> <4F9E8D8C.9090704@canonical.com> <CAK5ve-KEBY2kcMjcGAeFxWykxY7DnudJtK8WrpfwJYjOX+zSJw@mail.gmail.com>
In-Reply-To: <CAK5ve-KEBY2kcMjcGAeFxWykxY7DnudJtK8WrpfwJYjOX+zSJw@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 05:45 AM, Bryan Wu wrote:
> On Mon, Apr 30, 2012 at 9:03 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
>> On 04/30/2012 01:37 AM, Bryan Wu wrote:
>>> Attempting to consolidate the ARM LED code, this removes the
>>> custom RealView LED trigger code to turn LEDs on and off in
>>> response to CPU activity and replace it with a standard trigger.
>>>
>>> (bryan.wu@canonical.com:
>>> It introduces several syscore stubs into this trigger.
>>> It also provides ledtrig_cpu trigger event stub in <linux/leds.h>.
>>> Although it was inspired by ARM work, it can be used in other arch.)
>>>
>>> Cc: Richard Purdie <rpurdie@rpsys.net>
>>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
>>> Reviewed-by: Jamie Iles <jamie@jamieiles.com>
>>> Tested-by: Jochen Friedrich <jochen@scram.de>
>>> ---
>>>  drivers/leds/Kconfig       |   10 +++
>>>  drivers/leds/Makefile      |    1 +
>>>  drivers/leds/ledtrig-cpu.c |  150 ++++++++++++++++++++++++++++++++++++++++++++
>>>  include/linux/leds.h       |   16 +++++
>>>  4 files changed, 177 insertions(+)
>>>  create mode 100644 drivers/leds/ledtrig-cpu.c
>>>
>>> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
>>> index 5f12659..dbf8a4c 100644
>>> --- a/drivers/leds/Kconfig
>>> +++ b/drivers/leds/Kconfig
>>> @@ -465,6 +465,16 @@ config LEDS_TRIGGER_BACKLIGHT
>>>
>>>         If unsure, say N.
>>>
>>> +config LEDS_TRIGGER_CPU
>>> +     tristate "LED CPU Trigger"
>>> +     depends on LEDS_TRIGGERS
>>> +     help
>>> +       This allows LEDs to be controlled by active CPUs. This shows
>>> +       the active CPUs across an array of LEDs so you can see which
>>> +       CPUs are active on the system at any given moment.
>>> +
>>> +       If unsure, say N.
>>> +
>>>  config LEDS_TRIGGER_GPIO
>>>       tristate "LED GPIO Trigger"
>>>       depends on LEDS_TRIGGERS
>>> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
>>> index 9475bbb..ea1efb2 100644
>>> --- a/drivers/leds/Makefile
>>> +++ b/drivers/leds/Makefile
>>> @@ -56,4 +56,5 @@ obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK) += ledtrig-ide-disk.o
>>>  obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT) += ledtrig-heartbeat.o
>>>  obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT) += ledtrig-backlight.o
>>>  obj-$(CONFIG_LEDS_TRIGGER_GPIO)              += ledtrig-gpio.o
>>> +obj-$(CONFIG_LEDS_TRIGGER_CPU)               += ledtrig-cpu.o
>>>  obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)        += ledtrig-default-on.o
>>> diff --git a/drivers/leds/ledtrig-cpu.c b/drivers/leds/ledtrig-cpu.c
>>> new file mode 100644
>>> index 0000000..1f752e1
>>> --- /dev/null
>>> +++ b/drivers/leds/ledtrig-cpu.c
>>> @@ -0,0 +1,150 @@
>>> +/*
>>> + * ledtrig-cpu.c - LED trigger based on CPU activity
>>> + *
>>> + * This LED trigger will be registered for each possible CPU and named as
>>> + * cpu0, cpu1, cpu2, cpu3, etc.
>>> + *
>>> + * It can be bound to any LED just like other triggers using either a
>>> + * board file or via sysfs interface.
>>> + *
>>> + * An API named ledtrig_cpu is exported for any user, who want to add CPU
>>> + * activity indication in their code
>>> + *
>>> + * Copyright 2011 Linus Walleij <linus.walleij@linaro.org>
>>> + * Copyright 2011 - 2012 Bryan Wu <bryan.wu@canonical.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + *
>>> + */
>>> +
>>> +#include <linux/module.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/init.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/percpu.h>
>>> +#include <linux/syscore_ops.h>
>>> +#include <linux/rwsem.h>
>>> +#include "leds.h"
>>> +
>>> +#define MAX_NAME_LEN 8
>>> +
>>> +static DEFINE_PER_CPU(struct led_trigger *, cpu_trig);
>>> +static DEFINE_PER_CPU(char [MAX_NAME_LEN], trig_name);
>>> +static DEFINE_PER_CPU(struct rw_semaphore, trig_lock);
>>
>> Semaphores are overkill for this. I think a simple 'struct mutex' is
>> sufficient. Especially since there is unlikely to be much contention on
>> any one of the locks. mutext_init(), mutext_lock(), mutex_unlock(), etc.
>>
> 
> Indeed, I will change to mutex.
> 
>>> +
>>> +/**
>>> + * ledtrig_cpu - emit a CPU event as a trigger
>>> + * @evt: CPU event to be emitted
>>> + *
>>> + * Emit a CPU event on a CPU core, which will trigger a
>>> + * binded LED to turn on or turn off.
>>> + */
>>> +void ledtrig_cpu(enum cpu_led_event ledevt)
>>> +{
>>
>> I think you still need to acquire trig_lock _before_ reading
>> __get_cpu_var(cpu_trig). Otherwise, acquiring the lock in
>> ledtrig_cpu_init() is useless.
>>
> 
> I agree you are right, but call mutex_lock() here will prohibit
> system booting, because mutex_lock() should be called after
> mutex_init().
> mutex_init() is called in module_init function, which is behind some
> core functions calling ledtrig_cpu() API.
> 

I think the mutex_lock is OK. If you follow the logic in
kernel/module.c:init_module(), the module init function must complete
_before_ consumers of external symbols (such as ledtrig_cpu) can
proceed. Really, that only makes sense. Otherwise module startup would
be impossibly racy.

Therefore, ledtrig_cpu() cannot be called before ledtrig_cpu_init()
completes.

rtg

-- 
Tim Gardner tim.gardner@canonical.com
