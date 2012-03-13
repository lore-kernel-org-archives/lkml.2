Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585Ab2CMXLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:11:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760201Ab2CMXLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:11:46 -0400
Date: Tue, 13 Mar 2012 16:11:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: rpurdie@rpsys.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        linux@arm.linux.org.uk
Subject: Re: [PATCH 3/3] led-triggers: create a trigger for CPU activity
Message-Id: <20120313161138.cbeb594d.akpm@linux-foundation.org>
In-Reply-To: <1331197863-25564-3-git-send-email-bryan.wu@canonical.com>
References: <1331197863-25564-1-git-send-email-bryan.wu@canonical.com>
	<1331197863-25564-3-git-send-email-bryan.wu@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Mar 2012 17:11:03 +0800
Bryan Wu <bryan.wu@canonical.com> wrote:

> Attempting to consolidate the ARM LED code, this removes the
> custom RealView LED trigger code to turn LEDs on and off in
> response to CPU activity and replace it with a standard trigger.
> 
> (bryan.wu@canonical.com:
> It moves arch/arm/kernel/leds.c syscore stubs into this trigger.
> It also provides ledtrig_cpu trigger event stub in <linux/leds.h>.
> Although it was inspired by ARM work, it can be used in other arch.)

The patch doesn't "remove" or "move" anything.  It wholly consists of
additions.  Confused.

> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> 
> Reviewed-by: Jamie Iles <jamie@jamieiles.com>
> Tested-by: Jochen Friedrich <jochen@scram.de>

The authorship is a bit unclear.  You're the primary author, yes?

> --- /dev/null
> +++ b/drivers/leds/ledtrig-cpu.c
> @@ -0,0 +1,119 @@
> +/*
> + * ledtrig-cpu.c - LED trigger based on CPU activity
> + *
> + * Copyright 2011 Linus Walleij <linus.walleij@linaro.org>
> + * Copyright 2011 Bryan Wu <bryan.wu@canonical.com>
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
> +#include "leds.h"
> +
> +static DEFINE_PER_CPU(struct led_trigger *, cpu_trig);
> +static DEFINE_PER_CPU(char [8], trig_name);
> +
> +void ledtrig_cpu(enum cpu_led_event ledevt)
> +{
> +	struct led_trigger *trig = __get_cpu_var(cpu_trig);
> +
> +	if (!trig)
> +		return;
> +
> +	/* Locate the correct CPU LED */
> +	switch (ledevt) {
> +	case CPU_LED_IDLE_END:
> +	case CPU_LED_START:
> +		/* Will turn the LED on, max brightness */
> +		led_trigger_event(trig, LED_FULL);
> +		break;
> +
> +	case CPU_LED_IDLE_START:
> +	case CPU_LED_STOP:
> +	case CPU_LED_HALTED:
> +		/* Will turn the LED off */
> +		led_trigger_event(trig, LED_OFF);
> +		break;
> +
> +	default:
> +		/* Will leave the LED as it is */
> +		break;
> +	}
> +}
> +EXPORT_SYMBOL(ledtrig_cpu);

This is a global, exported-to-modules API function.  It should be
documented.

It should especially be documented if it has tricky unobvious calling
conditions, as this function does.  AFAICT it must be called by code
which is running on the target CPU and which is pinned to that CPU via
either preempt_disable() or set_cpus_allowed().

Or something else - I don't have a clue, and the author didn't tell me :(

> +static int ledtrig_cpu_syscore_suspend(void)
> +{
> +	ledtrig_cpu(CPU_LED_STOP);
> +	return 0;
> +}
> +
> +static void ledtrig_cpu_syscore_resume(void)
> +{
> +	ledtrig_cpu(CPU_LED_START);
> +}
> +
> +static void ledtrig_cpu_syscore_shutdown(void)
> +{
> +	ledtrig_cpu(CPU_LED_HALTED);
> +}
> +
> +static struct syscore_ops ledtrig_cpu_syscore_ops = {
> +	.shutdown	= ledtrig_cpu_syscore_shutdown,
> +	.suspend	= ledtrig_cpu_syscore_suspend,
> +	.resume		= ledtrig_cpu_syscore_resume,
> +};
> +
> +static void __init ledtrig_cpu_register(void *info)
> +{
> +	int cpuid = smp_processor_id();
> +	struct led_trigger *trig;
> +	char *name = __get_cpu_var(trig_name);
> +
> +	snprintf(name, 8, "cpu%d", cpuid);

This explodes at 10,000 CPUS ;)

> +	led_trigger_register_simple(name, &trig);
> +
> +	pr_info("LED trigger %s indicate activity on CPU %d\n",
> +		trig->name, cpuid);
> +
> +	__get_cpu_var(cpu_trig) = trig;
> +}
> +
> +static void __exit ledtrig_cpu_unregister(void *info)
> +{
> +	struct led_trigger *trig = __get_cpu_var(cpu_trig);
> +	char *name = __get_cpu_var(trig_name);
> +
> +	led_trigger_unregister_simple(trig);
> +	__get_cpu_var(cpu_trig) = NULL;
> +	memset(name, 0, 8);
> +}
> +
> +static int __init ledtrig_cpu_init(void)
> +{
> +	on_each_cpu(ledtrig_cpu_register, NULL, 1);

on_each_cpu() only calls the function on presently-onlined CPUs.  How
does this code interact with CPU hotplug?

And as you've already noted, led_trigger_register_simple() is totally
not callable from interrupt context.  And we're not just talking about
under local_irq_disable() here: on_each_cpu() will raise cross-cpu hard
interrupts to call the function on remote CPUs.  We end up trying to do
down_write() and who knows what else from within a hard interrupt
handler.

> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -210,4 +210,19 @@ struct gpio_led_platform_data {
>  struct platform_device *gpio_led_register_device(
>  		int id, const struct gpio_led_platform_data *pdata);
>  
> +#if defined(CONFIG_LEDS_TRIGGER_CPU) || defined(CONFIG_LEDS_TRIGGER_CPU_MODULE)
> +enum cpu_led_event {
> +	CPU_LED_IDLE_START,	/* CPU enters idle */
> +	CPU_LED_IDLE_END,	/* CPU idle ends */
> +	CPU_LED_START,		/* Machine starts, especially resume */
> +	CPU_LED_STOP,		/* Machine stops, especially suspend */
> +	CPU_LED_HALTED,		/* Machine shutdown */
> +};
> +
> +/* Use this routine to handle LEDs */
> +extern void ledtrig_cpu(enum cpu_led_event evt);
> +#else
> +#define ledtrig_cpu(evt) do {} while (0)
> +#endif

a) the stub function should be written in C, not CPP please

b) it makes no sense to provide the stub function when the
   definition of its argument type (enum cpu_led_event) is not
   also available.

