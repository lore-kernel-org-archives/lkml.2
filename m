Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab1FNGQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 02:16:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1234 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1FNGQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 02:16:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cZX5TYYbKq3iPGCNXThFOMKtZUGxWh4AXzMA+JvT7knxq4iF9gAJHCMiLIogmtINL3
         YA9T+MXVBbGsneVMkS8Q==
MIME-Version: 1.0
In-Reply-To: <87ips9fka2.fsf@ti.com>
References: <1307925825-28566-1-git-send-email-ccross@android.com>
	<1307925825-28566-2-git-send-email-ccross@android.com>
	<87ips9fka2.fsf@ti.com>
Date: Mon, 13 Jun 2011 23:15:58 -0700
X-Google-Sender-Auth: lwsRp07run7kv7YDcC2cKGQcgQ4
Message-ID: <BANLkTinnZtPFY1Aae=8uDbyt5sh9xAxiNw@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: Add cpu power management notifiers
From: Colin Cross <ccross@android.com>
To: Kevin Hilman <khilman@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Leif Lindholm <leif.lindholm@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 3:17 PM, Kevin Hilman <khilman@ti.com> wrote:
> Colin Cross <ccross@android.com> writes:
>
>> During some CPU power modes entered during idle, hotplug and
>> suspend, peripherals located in the CPU power domain, such as
>> the GIC and VFP, may be powered down.  Add a notifier chain
>> that allows drivers for those peripherals to be notified
>> before and after they may be reset.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>
> This is great, thanks!
>
> I had hacked up something OMAP-specific a while back to do something
> similar, and have been meaning to make it more generic, so this is
> perfect.  Also, if it is moved outside ARM, note that x86_64 has a
> idle_notifier infrastructure that is somewhat similar, and if you're
> motivated, it should probably be converted to this as well.  See
> arch/x86/kernel/process_64.c.

I'll take a look at x86

> Also, for the sake of the comments/changelog, the usefulness of these
> notifiers is not limited to low-power states where power is off and IP
> blocks may be reset.  It could be considered as simply a generic
> notification mechanism for any CPU PM transitions.
>
> On OMAP we have other peripherals (not in the CPU power domain) where we
> need to control their PM transitions in relation to the CPU PM
> transitions so the notifiers are useful for any low-power state
> transition of the CPU(s).  The drivers for these peripherals use runtime
> PM in their CPU PM notifiers to trigger the device PM transitions. (The
> drivers must use the synchronous versions of the runtime PM get/put
> calls with device in pm_runtime_irq_safe() mode.)

Can you give a concrete example of this so I can describe it correctly?

> In this series, I don't see any calls to cpu_[complex_]pm_[enter|exit]().
> Based on that, I assume you prefer to leave it up to platform-specific
> idle/PM code to place these calls.  Or, do you plan to have this
> triggered by generic CPUidle, suspend/resume and/or hotplug code?  At
> least on OMAP, I prefer having the calls in platform-specific code.

I will post the Tegra code that uses this soon.  I expect that the
decision on exactly when to call these functions will be unique to
each platform, so I think it should start in the platform-specific
code.

> I have a minor enhancement request.  The notifier callbacks provide for
> passing a void * through the notifier chain.  Could you add a way for a
> void * to be registered at cpu_pm_register_notifier() time and that
> would be passed through the notifier call chain?  This would allow using
> the same struct notifier_block and callback for multiple instances of
> the same IP, and the instances could be differentiated in the callback
> using the void *.

The void * passed to the notifier comes from the call to
notifier_call_chain(), not from the call to register_notifier().  You
can get the behavior you want by putting the notifier_block inside
your device struct and using container_of on the notifier_bock.

> Also, FWIW I tested this on OMAP3 (Cortex-A8 UP) using
> cpu_pm_enter/exit() in the code path shared between idle and suspend.  I
> successfully triggered PM transitions in non-CPU power-domain
> peripherals, and it worked great.

Great!  Can I get a tested-by?

> Some other minor comments below...
>
> [...]
>
>> diff --git a/arch/arm/kernel/cpu_pm.c b/arch/arm/kernel/cpu_pm.c
>> new file mode 100644
>> index 0000000..48a5b53
>> --- /dev/null
>> +++ b/arch/arm/kernel/cpu_pm.c
>> @@ -0,0 +1,181 @@
>> +/*
>> + * Copyright (C) 2011 Google, Inc.
>> + *
>> + * Author:
>> + *   Colin Cross <ccross@android.com>
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/notifier.h>
>> +#include <linux/spinlock.h>
>> +
>> +#include <asm/cpu_pm.h>
>> +
>> +/*
>> + * When a CPU goes to a low power state that turns off power to the CPU's
>> + * power domain, the contents of some blocks (floating point coprocessors,
>> + * interrutp controllers, caches, timers) in the same power domain can
>
> typo: interrutp

Will fix

>> + * be lost.  The cpm_pm notifiers provide a method for platform idle, suspend,
>> + * and hotplug implementations to notify the drivers for these blocks that
>> + * they may be reset.
>> + *
>> + * All cpu_pm notifications must be called with interrupts disabled.
>> + *
>> + * The notifications are split into two classes, CPU notifications and CPU
>> + * complex notifications.
>> + *
>> + * CPU notifications apply to a single CPU, and must be called on the affected
>> + * CPU.  They are used to save per-cpu context for affected blocks.
>> + *
>> + * CPU complex notifications apply to all CPUs in a single power domain. They
>> + * are used to save any global context for affected blocks, and must be called
>> + * after all the CPUs in the power domain have been notified of the low power
>> + * state.
>> + *
>> + */
>
> Not directly related to this series, but I'm a bit confused on terminology.
>
> I've seen both 'CPU complex' and 'CPU cluster' used in ARM SMP land, but
> haven't seen precise definitions of either.  Does one imply all CPUs,
> and the other imply all CPUs in the same power domain?

'CPU complex' is the terminology I cribbed from some of nVidia's Tegra
patches, but I think 'CPU cluster' is a better term for what I mean -
the group of CPUs that share some external state, like the L2 or GIC
distributor.  In practice, all existing platforms seem to have a
single cluster (as far as Linux is concerned).  The ARM ARM uses
'cluster', but doesn't directly define it, and doesn't use 'CPU
complex' at all.
