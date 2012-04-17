Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab2DQWwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 18:52:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2DQWwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 18:52:43 -0400
Date: Tue, 17 Apr 2012 15:52:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, arnd.bergmann@linaro.org,
        nicolas.pitre@linaro.org, tim.gardner@canonical.com
Subject: Re: [PATCH 01/18] led-triggers: create a trigger for CPU activity
Message-Id: <20120417155241.0f619a9a.akpm@linux-foundation.org>
In-Reply-To: <1334660025-20442-2-git-send-email-bryan.wu@canonical.com>
References: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
	<1334660025-20442-2-git-send-email-bryan.wu@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012 18:53:28 +0800
Bryan Wu <bryan.wu@canonical.com> wrote:

> Attempting to consolidate the ARM LED code, this removes the
> custom RealView LED trigger code to turn LEDs on and off in
> response to CPU activity and replace it with a standard trigger.
> 
> (bryan.wu@canonical.com:
> It moves arch/arm/kernel/leds.c syscore stubs into this trigger.

No, the patch doesn't alter arch/arm/kernel/leds.c at all.  This text
is either misleadingly phrased, or stale or something.

> It also provides ledtrig_cpu trigger event stub in <linux/leds.h>.
> Although it was inspired by ARM work, it can be used in other arch.)
> 
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> 

A spurious newline.

> Reviewed-by: Jamie Iles <jamie@jamieiles.com>
> Tested-by: Jochen Friedrich <jochen@scram.de>
>
> ...
>
> +config LEDS_TRIGGER_CPU
> +	tristate "LED CPU Trigger"
> +	depends on LEDS_TRIGGERS
> +	help
> +	  This allows LEDs to be controlled by active CPUs. This shows
> +	  the active CPUs across an array of LEDs so you can see what

s/what/which/   (I think ;))

> +	  CPUs are active on the system at any given moment.
> +
> +	  If unsure, say N.
> +
>
> ...
>
> +static int __init ledtrig_cpu_init(void)
> +{
> +	int cpu;
> +
> +	/* Supports up to 9999 cpu cores */
> +	BUILD_BUG_ON(CONFIG_NR_CPUS > 9999);

hm, I wonder if this can be prevented in Kconfig logic.  I guess
"depends on NR_CPUS <= 9999" isn't available.

> +	/*
> +	 * Registering CPU led trigger for each CPU cores here

s/cores/core/

> +	 * ignores CPU hotplug, but after this CPU hotplug works
> +	 * fine with this trigger.
> +	 */
> +	for_each_possible_cpu(cpu) {
> +		struct led_trigger *trig;
> +		char *name = per_cpu(trig_name, cpu);
> +		struct rw_semaphore *lock = &per_cpu(trig_lock, cpu);
> +
> +		init_rwsem(lock);
> +
> +		snprintf(name, MAX_NAME_LEN, "cpu%d", cpu);
> +
> +		down_write(lock);
> +		led_trigger_register_simple(name, &trig);

OK, problem.

led_trigger_register_simple() calls kzalloc() and
led_trigger_register(), both of which can fail. 
led_trigger_register_simple() just returns void, failing to propagate
the error back.  This is bad, and we (ie you ;)) should fix
led_trigger_register_simple() before proceeding to use it.  If at all
possible.  Please.  Let us not propagate the badness further.  Sorry.

> +		per_cpu(cpu_trig, cpu) = trig;
> +		up_write(lock);
> +	}
> +
> +	register_syscore_ops(&ledtrig_cpu_syscore_ops);
> +
> +	pr_info("ledtrig-cpu: registered to indicate activity on CPUs\n");
> +
> +	return 0;
> +}
> +module_init(ledtrig_cpu_init);
> +
> +static void __exit ledtrig_cpu_exit(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct led_trigger *trig = per_cpu(cpu_trig, cpu);

grr.  drivers/leds/led-triggers.c sometimes does

	struct led_trigger trigger;

and sometimes

	struct led_trigger trig;

which makes the code needlessly more difficult to follow.  So if you're
fiddling with drivers/leds/led-triggers.c, please fix that up - use
"trig" everywhere?

> +		char *name = per_cpu(trig_name, cpu);
> +
> +		led_trigger_unregister_simple(trig);

And what happens if led_trigger_register_simple() had silently failed
to register this trigger?  afacit, nothing: your code handles the
trig==NULL case OK.  Still, we should be checking for those failures!

> +		per_cpu(cpu_trig, cpu) = NULL;
> +		memset(name, 0, MAX_NAME_LEN);
> +	}
> +
> +	unregister_syscore_ops(&ledtrig_cpu_syscore_ops);
> +}
> +module_exit(ledtrig_cpu_exit);
> +
> +MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
> +MODULE_AUTHOR("Bryan Wu <bryan.wu@canonical.com>");
> +MODULE_DESCRIPTION("CPU LED trigger");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 5884def..1215b94 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -210,4 +210,27 @@ struct gpio_led_platform_data {
>  struct platform_device *gpio_led_register_device(
>  		int id, const struct gpio_led_platform_data *pdata);
>  
> +enum cpu_led_event {
> +	CPU_LED_IDLE_START,	/* CPU enters idle */
> +	CPU_LED_IDLE_END,	/* CPU idle ends */
> +	CPU_LED_START,		/* Machine starts, especially resume */
> +	CPU_LED_STOP,		/* Machine stops, especially suspend */
> +	CPU_LED_HALTED,		/* Machine shutdown */
> +};
> +#if defined(CONFIG_LEDS_TRIGGER_CPU) || defined(CONFIG_LEDS_TRIGGER_CPU_MODULE)

See lkml subject "RFC: strip 15,000 lines from a typical autoconf.h". 
We might be able to simplify this.  But the above is OK for now.

> +/**
> + * ledtrig_cpu - emit a CPU event as a trigger
> + * @evt: CPU event to be emitted
> + *
> + * Emit a CPU event on a CPU core, which will trigger a
> + * binded LED to turn on or turn off.
> + */

It's conventional to add kerneldoc at the function definition site, not
at the declaration.  Nobody thinks to look in the .h file for
documentation.

> +extern void ledtrig_cpu(enum cpu_led_event evt);
> +#else
> +static inline void ledtrig_cpu(enum cpu_led_event evt)
> +{
> +	return;
> +}
> +#endif
> +

