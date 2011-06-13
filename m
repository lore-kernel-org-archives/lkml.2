Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab1FMWSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 18:18:07 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:57805 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666Ab1FMWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 18:18:03 -0400
From: Kevin Hilman <khilman@ti.com>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Leif Lindholm <leif.lindholm@arm.com>
Subject: Re: [PATCH 1/3] ARM: Add cpu power management notifiers
Organization: Texas Instruments, Inc.
References: <1307925825-28566-1-git-send-email-ccross@android.com>
	<1307925825-28566-2-git-send-email-ccross@android.com>
Date: Mon, 13 Jun 2011 15:17:57 -0700
In-Reply-To: <1307925825-28566-2-git-send-email-ccross@android.com> (Colin
	Cross's message of "Sun, 12 Jun 2011 17:43:43 -0700")
Message-ID: <87ips9fka2.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin Cross <ccross@android.com> writes:

> During some CPU power modes entered during idle, hotplug and
> suspend, peripherals located in the CPU power domain, such as
> the GIC and VFP, may be powered down.  Add a notifier chain
> that allows drivers for those peripherals to be notified
> before and after they may be reset.
>
> Signed-off-by: Colin Cross <ccross@android.com>

This is great, thanks!

I had hacked up something OMAP-specific a while back to do something
similar, and have been meaning to make it more generic, so this is
perfect.  Also, if it is moved outside ARM, note that x86_64 has a
idle_notifier infrastructure that is somewhat similar, and if you're
motivated, it should probably be converted to this as well.  See
arch/x86/kernel/process_64.c.

Also, for the sake of the comments/changelog, the usefulness of these
notifiers is not limited to low-power states where power is off and IP
blocks may be reset.  It could be considered as simply a generic
notification mechanism for any CPU PM transitions.

On OMAP we have other peripherals (not in the CPU power domain) where we
need to control their PM transitions in relation to the CPU PM
transitions so the notifiers are useful for any low-power state
transition of the CPU(s).  The drivers for these peripherals use runtime
PM in their CPU PM notifiers to trigger the device PM transitions. (The
drivers must use the synchronous versions of the runtime PM get/put
calls with device in pm_runtime_irq_safe() mode.)

In this series, I don't see any calls to cpu_[complex_]pm_[enter|exit]().  
Based on that, I assume you prefer to leave it up to platform-specific
idle/PM code to place these calls.  Or, do you plan to have this
triggered by generic CPUidle, suspend/resume and/or hotplug code?  At
least on OMAP, I prefer having the calls in platform-specific code.

I have a minor enhancement request.  The notifier callbacks provide for
passing a void * through the notifier chain.  Could you add a way for a
void * to be registered at cpu_pm_register_notifier() time and that
would be passed through the notifier call chain?  This would allow using
the same struct notifier_block and callback for multiple instances of
the same IP, and the instances could be differentiated in the callback
using the void *.

Also, FWIW I tested this on OMAP3 (Cortex-A8 UP) using
cpu_pm_enter/exit() in the code path shared between idle and suspend.  I
successfully triggered PM transitions in non-CPU power-domain
peripherals, and it worked great. 

Some other minor comments below...

[...]

> diff --git a/arch/arm/kernel/cpu_pm.c b/arch/arm/kernel/cpu_pm.c
> new file mode 100644
> index 0000000..48a5b53
> --- /dev/null
> +++ b/arch/arm/kernel/cpu_pm.c
> @@ -0,0 +1,181 @@
> +/*
> + * Copyright (C) 2011 Google, Inc.
> + *
> + * Author:
> + *	Colin Cross <ccross@android.com>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/notifier.h>
> +#include <linux/spinlock.h>
> +
> +#include <asm/cpu_pm.h>
> +
> +/*
> + * When a CPU goes to a low power state that turns off power to the CPU's
> + * power domain, the contents of some blocks (floating point coprocessors,
> + * interrutp controllers, caches, timers) in the same power domain can

typo: interrutp

> + * be lost.  The cpm_pm notifiers provide a method for platform idle, suspend,
> + * and hotplug implementations to notify the drivers for these blocks that
> + * they may be reset.
> + *
> + * All cpu_pm notifications must be called with interrupts disabled.
> + *
> + * The notifications are split into two classes, CPU notifications and CPU
> + * complex notifications.
> + *
> + * CPU notifications apply to a single CPU, and must be called on the affected
> + * CPU.  They are used to save per-cpu context for affected blocks.
> + *
> + * CPU complex notifications apply to all CPUs in a single power domain. They
> + * are used to save any global context for affected blocks, and must be called
> + * after all the CPUs in the power domain have been notified of the low power
> + * state.
> + *
> + */

Not directly related to this series, but I'm a bit confused on terminology.

I've seen both 'CPU complex' and 'CPU cluster' used in ARM SMP land, but
haven't seen precise definitions of either.  Does one imply all CPUs,
and the other imply all CPUs in the same power domain?

Kevin
