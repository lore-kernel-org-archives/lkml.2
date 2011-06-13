Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab1FMB5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 21:57:52 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53297 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1FMB5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 21:57:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JCnviYIwMnpznfq7Y/nc5SZw7mpfCmS3XZ8r26aYmSyzL8A87OdY3DFZvoH66jJWof
         TnO1IXkxDMAW7/rhHaBfvWof3dW71tbPQ/MANI9o0YAgZy2f80u/DXRdnMGFrCaUhXhe
         suTY7pZPZSiNSrhIS2w0D64w6Ao4fkZNXRAls=
Message-ID: <4DF56E97.1020907@gmail.com>
Date: Sun, 12 Jun 2011 20:57:43 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Leif Lindholm <leif.lindholm@arm.com>
Subject: Re: [PATCH 1/3] ARM: Add cpu power management notifiers
References: <1307925825-28566-1-git-send-email-ccross@android.com> <1307925825-28566-2-git-send-email-ccross@android.com>
In-Reply-To: <1307925825-28566-2-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2011 07:43 PM, Colin Cross wrote:
> During some CPU power modes entered during idle, hotplug and
> suspend, peripherals located in the CPU power domain, such as
> the GIC and VFP, may be powered down.  Add a notifier chain
> that allows drivers for those peripherals to be notified
> before and after they may be reset.
>
> Signed-off-by: Colin Cross<ccross@android.com>
> ---
>   arch/arm/Kconfig              |    7 ++
>   arch/arm/include/asm/cpu_pm.h |   54 ++++++++++++
>   arch/arm/kernel/Makefile      |    1 +
>   arch/arm/kernel/cpu_pm.c      |  181 +++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 243 insertions(+), 0 deletions(-)
>   create mode 100644 arch/arm/include/asm/cpu_pm.h
>   create mode 100644 arch/arm/kernel/cpu_pm.c
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 9adc278..356f266 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -183,6 +183,13 @@ config FIQ
>   config ARCH_MTD_XIP
>   	bool
>
> +config ARCH_USES_CPU_PM
> +       bool
> +
> +config CPU_PM
> +       def_bool y
> +       depends on ARCH_USES_CPU_PM&&  (PM || CPU_IDLE)
> +
>   config VECTORS_BASE
>   	hex
>   	default 0xffff0000 if MMU || CPU_HIGH_VECTOR
> diff --git a/arch/arm/include/asm/cpu_pm.h b/arch/arm/include/asm/cpu_pm.h
> new file mode 100644
> index 0000000..b4bb715
> --- /dev/null
> +++ b/arch/arm/include/asm/cpu_pm.h
> @@ -0,0 +1,54 @@
> +/*
> + * Copyright (C) 2011 Google, Inc.
> + *
> + * Author:
> + *	Colin Cross<ccross@android.com>
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
> +#ifndef _ASMARM_CPU_PM_H
> +#define _ASMARM_CPU_PM_H
> +
> +#include<linux/kernel.h>
> +#include<linux/notifier.h>
> +
> +/* Event codes passed as unsigned long val to notifier calls */
> +enum cpu_pm_event {
> +	/* A single cpu is entering a low power state */
> +	CPU_PM_ENTER,
> +
> +	/* A single cpu failed to enter a low power state */
> +	CPU_PM_ENTER_FAILED,
> +
> +	/* A single cpu is exiting a low power state */
> +	CPU_PM_EXIT,
> +
> +	/* A cpu power domain is entering a low power state */
> +	CPU_COMPLEX_PM_ENTER,
> +
> +	/* A cpu power domain failed to enter a low power state */
> +	CPU_COMPLEX_PM_ENTER_FAILED,
> +
> +	/* A cpu power domain is exiting a low power state */
> +	CPU_COMPLEX_PM_EXIT,
> +};
> +
> +int cpu_pm_register_notifier(struct notifier_block *nb);
> +int cpu_pm_unregister_notifier(struct notifier_block *nb);
> +
> +int cpu_pm_enter(void);
> +int cpu_pm_exit(void);
> +
> +int cpu_complex_pm_enter(void);
> +int cpu_complex_pm_exit(void);
> +
> +#endif
> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
> index a5b31af..8b42d58 100644
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -60,6 +60,7 @@ obj-$(CONFIG_CPU_PJ4)		+= pj4-cp0.o
>   obj-$(CONFIG_IWMMXT)		+= iwmmxt.o
>   obj-$(CONFIG_CPU_HAS_PMU)	+= pmu.o
>   obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
> +obj-$(CONFIG_CPU_PM)		+= cpu_pm.o
>   AFLAGS_iwmmxt.o			:= -Wa,-mcpu=iwmmxt
>
>   ifneq ($(CONFIG_ARCH_EBSA110),y)
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
> + *	Colin Cross<ccross@android.com>
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
> +#include<linux/kernel.h>
> +#include<linux/module.h>
> +#include<linux/notifier.h>
> +#include<linux/spinlock.h>
> +
> +#include<asm/cpu_pm.h>
> +
> +/*
> + * When a CPU goes to a low power state that turns off power to the CPU's
> + * power domain, the contents of some blocks (floating point coprocessors,
> + * interrutp controllers, caches, timers) in the same power domain can
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
> +
> +static DEFINE_RWLOCK(cpu_pm_notifier_lock);
> +static RAW_NOTIFIER_HEAD(cpu_pm_notifier_chain);
> +
> +int cpu_pm_register_notifier(struct notifier_block *nb)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	write_lock_irqsave(&cpu_pm_notifier_lock, flags);
> +	ret = raw_notifier_chain_register(&cpu_pm_notifier_chain, nb);
> +	write_unlock_irqrestore(&cpu_pm_notifier_lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(cpu_pm_register_notifier);
> +
> +int cpu_pm_unregister_notifier(struct notifier_block *nb)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	write_lock_irqsave(&cpu_pm_notifier_lock, flags);
> +	ret = raw_notifier_chain_unregister(&cpu_pm_notifier_chain, nb);
> +	write_unlock_irqrestore(&cpu_pm_notifier_lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(cpu_pm_unregister_notifier);
> +
> +static int cpu_pm_notify(enum cpu_pm_event event, int nr_to_call, int *nr_calls)
> +{
> +	int ret;
> +
> +	ret = __raw_notifier_call_chain(&cpu_pm_notifier_chain, event, NULL,
> +		nr_to_call, nr_calls);
> +
> +	return notifier_to_errno(ret);
> +}
> +
> +/**
> + * cpm_pm_enter
> + *
> + * Notifies listeners that a single cpu is entering a low power state that may
> + * cause some blocks in the same power domain as the cpu to reset.
> + *
> + * Must be called on the affected cpu with interrupts disabled.  Platform is
> + * responsible for ensuring that cpu_pm_enter is not called twice on the same
> + * cpu before cpu_pm_exit is called.
> + */
> +int cpu_pm_enter(void)
> +{
> +	int nr_calls;
> +	int ret = 0;
> +
> +	read_lock(&cpu_pm_notifier_lock);
> +	ret = cpu_pm_notify(CPU_PM_ENTER, -1,&nr_calls);
> +	if (ret)
> +		cpu_pm_notify(CPU_PM_ENTER_FAILED, nr_calls - 1, NULL);
> +	read_unlock(&cpu_pm_notifier_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(cpu_pm_enter);
> +
> +/**
> + * cpm_pm_exit
> + *
> + * Notifies listeners that a single cpu is exiting a low power state that may
> + * have caused some blocks in the same power domain as the cpu to reset.
> + *
> + * Must be called on the affected cpu with interrupts disabled.
> + */
> +int cpu_pm_exit(void)
> +{
> +	int ret;
> +
> +	read_lock(&cpu_pm_notifier_lock);
> +	ret = cpu_pm_notify(CPU_PM_EXIT, -1, NULL);
> +	read_unlock(&cpu_pm_notifier_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(cpu_pm_exit);
> +
> +/**
> + * cpm_complex_pm_enter
> + *
> + * Notifies listeners that all cpus in a power domain are entering a low power
> + * state that may cause some blocks in the same power domain to reset.
> + *
> + * Must be called after cpu_pm_enter has been called on all cpus in the power
> + * domain, and before cpu_pm_exit has been called on any cpu in the power
> + * domain.
> + *
> + * Must be called with interrupts disabled.
> + */
> +int cpu_complex_pm_enter(void)
> +{
> +	int nr_calls;
> +	int ret = 0;
> +
> +	read_lock(&cpu_pm_notifier_lock);
> +	ret = cpu_pm_notify(CPU_COMPLEX_PM_ENTER, -1,&nr_calls);
> +	if (ret)
> +		cpu_pm_notify(CPU_COMPLEX_PM_ENTER_FAILED, nr_calls - 1, NULL);
> +	read_unlock(&cpu_pm_notifier_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(cpu_complex_pm_enter);
> +
> +/**
> + * cpm_pm_enter
> + *
> + * Notifies listeners that a single cpu is entering a low power state that may
> + * cause some blocks in the same power domain as the cpu to reset.
> + *
> + * Must be called after cpu_pm_enter has been called on all cpus in the power
> + * domain, and before cpu_pm_exit has been called on any cpu in the power
> + * domain.
> + *
> + * Must be called with interrupts disabled.
> + */
> +int cpu_complex_pm_exit(void)
> +{
> +	int ret;
> +
> +	read_lock(&cpu_pm_notifier_lock);
> +	ret = cpu_pm_notify(CPU_COMPLEX_PM_EXIT, -1, NULL);
> +	read_unlock(&cpu_pm_notifier_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(cpu_complex_pm_exit);

Nothing really ARM specific here, so why not make this generic for all 
architectures?

Rob
