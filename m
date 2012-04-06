Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab2DFWPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 18:15:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab2DFWPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 18:15:07 -0400
Date: Fri, 6 Apr 2012 15:15:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: tony@atomide.com, linux@arm.linux.org.uk, rpurdie@rpsys.net,
        manuel.lauss@gmail.com, cjb@laptop.org, cbou@mail.ru,
        dwmw2@infradead.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org
Subject: Re: [PATCH 01/18] led-triggers: create a trigger for CPU activity
Message-Id: <20120406151505.4eeb01ba.akpm@linux-foundation.org>
In-Reply-To: <1333108713-12707-2-git-send-email-bryan.wu@canonical.com>
References: <1333108713-12707-1-git-send-email-bryan.wu@canonical.com>
	<1333108713-12707-2-git-send-email-bryan.wu@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 19:58:16 +0800
Bryan Wu <bryan.wu@canonical.com> wrote:

> Attempting to consolidate the ARM LED code, this removes the
> custom RealView LED trigger code to turn LEDs on and off in
> response to CPU activity and replace it with a standard trigger.
> 
> (bryan.wu@canonical.com:
> It moves arch/arm/kernel/leds.c syscore stubs into this trigger.
> It also provides ledtrig_cpu trigger event stub in <linux/leds.h>.
> Although it was inspired by ARM work, it can be used in other arch.)
> 
>
> ...
>
> +#include <linux/percpu.h>
> +#include <linux/syscore_ops.h>
> +#include "leds.h"
> +
> +#define MAX_NAME_LEN	8

The kernel already has at least eight different definitions of
MAX_NAME_LEN.  I guess a ninth won't hurt ;)

>
> ...
>
> +static void __init ledtrig_cpu_register(void)
> +{
> +	int cpuid = smp_processor_id();
> +	struct led_trigger *trig;
> +	char *name = __get_cpu_var(trig_name);
> +
> +	snprintf(name, MAX_NAME_LEN, "cpu%d", cpuid);
> +	led_trigger_register_simple(name, &trig);
> +
> +	pr_info("LED trigger %s indicate activity on CPU %d\n",
> +		trig->name, cpuid);
> +
> +	__get_cpu_var(cpu_trig) = trig;
> +}
> +
> +static void __exit ledtrig_cpu_unregister(void)
> +{
> +	struct led_trigger *trig = __get_cpu_var(cpu_trig);
> +	char *name = __get_cpu_var(trig_name);
> +
> +	led_trigger_unregister_simple(trig);
> +	__get_cpu_var(cpu_trig) = NULL;
> +	memset(name, 0, MAX_NAME_LEN);
> +}
> +
> +static int __init ledtrig_cpu_init(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		ledtrig_cpu_register();
> +
> +	register_syscore_ops(&ledtrig_cpu_syscore_ops);
> +
> +	return 0;
> +}
> +module_init(ledtrig_cpu_init);

This all looks horridly broken.  We call ledtrig_cpu_register() once
for each CPU, but we call it on the same CPU each time, and it uses
smp_processor_id() which a) is wrong and b) will emit a runtime
preemption-is-enabled warning.

I'm assuming this wasn't tested on SMP.  It needs to be, please.

Also, the code uses for_each_possible_cpu, ignoring CPU hotplug. 
That's probably justifiable for this small storage size and not-hotpath
code, but the decision should be given prominence and justified in the
changelog or, better, in code comments please.

>
> ...
>

The patchset is basically an ARM thing.  Is there some ARM tree via
which we can get it merged?
