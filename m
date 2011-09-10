Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056Ab1IJECP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 00:02:15 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:38754 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698Ab1IJECO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 00:02:14 -0400
Message-ID: <4E6AE13E.2070809@ti.com>
Date: Sat, 10 Sep 2011 09:32:06 +0530
From: Santosh <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, ccross@android.com, rjw@sisk.pl,
        khilman@ti.com
Subject: Re: [PATCH v2 1/5] cpu_pm: Add cpu power management notifiers
References: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>	<1315060755-4613-2-git-send-email-santosh.shilimkar@ti.com> <20110909155632.661f5696.akpm@linux-foundation.org>
In-Reply-To: <20110909155632.661f5696.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 September 2011 04:26 AM, Andrew Morton wrote:
> On Sat, 3 Sep 2011 20:09:11 +0530
> Santosh Shilimkar<santosh.shilimkar@ti.com>  wrote:
>
>> From: Colin Cross<ccross@android.com>
>>
>> During some CPU power modes entered during idle, hotplug and
>> suspend, peripherals located in the CPU power domain, such as
>> the GIC, localtimers, and VFP, may be powered down.  Add a
>> notifier chain that allows drivers for those peripherals to
>> be notified before and after they may be reset.
>
> Have you identified which indivudual you hope/expect to merge this into
> mainline?
>
> The code is presumably and hopefully applicable to architectures other
> than ARM, yes?  Can you suggest likely candidate architectures so we
> can go off and bug the relevant maintainers to review it?
>
I was planning to send the pull request to Russell.

>>
>> ...
>>
>> +/*
>> + * When a CPU goes to a low power state that turns off power to the CPU's
>> + * power domain, the contents of some blocks (floating point coprocessors,
>> + * interrutp controllers, caches, timers) in the same power domain can
>
> s/interrutp/interrupt/
ok.
>
>> + * be lost.  The cpm_pm notifiers provide a method for platform idle, suspend,
>> + * and hotplug implementations to notify the drivers for these blocks that
>> + * they may be reset.
>> + *
>> + * All cpu_pm notifications must be called with interrupts disabled.
>> + *
>> + * The notifications are split into two classes, CPU notifications and CPU
>
> s/,/:/
ok
>
>> + * cluster notifications.
>> + *
>> + * CPU notifications apply to a single CPU, and must be called on the affected
>
> s/,// ;)
>
ok
>> + * CPU.  They are used to save per-cpu context for affected blocks.
>> + *
>> + * CPU cluster notifications apply to all CPUs in a single power domain. They
>> + * are used to save any global context for affected blocks, and must be called
>> + * after all the CPUs in the power domain have been notified of the low power
>> + * state.
>> + *
>
> Remove this line.
>
ok.

>> + */
>> +
>>
>> ...
>>
>> +/*
>> + * cpm_pm_enter
>> + *
>> + * Notifies listeners that a single cpu is entering a low power state that may
>> + * cause some blocks in the same power domain as the cpu to reset.
>> + *
>> + * Must be called on the affected cpu with interrupts disabled.  Platform is
>> + * responsible for ensuring that cpu_pm_enter is not called twice on the same
>> + * cpu before cpu_pm_exit is called.
>> + */
>
> It's unconventional to put the documentation over the declarations in the
> .h file.  It's not a *bad* idea per-se, but we generally don't do it.
> People will look at the definition in .c for the documentation and it
> if isn't there, some will assume that documentation doesn't exist.
>
> Plus: I don't know about others, but I don't configure ctags to lead me
> to declarations.  So finding the documentation for cpm_pm_enter() is a
> single keystroke if it's in the .c file, and a big PITA if it is in the
> .h file.
>
Will move that to C file.

> Also, this documentation could trivially be converted into kerneldoc
> format - you may as well do this?
>
ok

>> +int cpu_pm_enter(void);
>
> An actual design question: the interface assumes that CPU PM is a
> boolean state: on or off.  "a CPU goes to a low power state that turns
> off power to the CPU's power domain".
>
> Will that always be true for all CPUs?  Or should the interface have
> the capability of notifying clients of multi-level power state
> transitions?
>
Yes. Those are CPU cluster events. We already use them for
interrupt controller which looses power only when CPU cluster
looses power.

>> +
>> +/*
>> + * cpm_pm_exit
>> + *
>> + * Notifies listeners that a single cpu is exiting a low power state that may
>> + * have caused some blocks in the same power domain as the cpu to reset.
>> + *
>> + * Must be called on the affected cpu with interrupts disabled.
>
> It's unobvious (to little old me) why all these things need to be
> called under local_irq_disable().  I suggest the addition of a code
> comment and changelog update so that others are not similarly
> mystified.
>
These notifiers are used in CPUIDLE and suspend code. We were
aslo disabling the interrupt controller. Will add more description
to it.

>> + */
>> +int cpu_pm_exit(void);
>>
>> ...
>>
>> +int cpu_cluster_pm_enter(void)
>> +{
>> +	int nr_calls;
>> +	int ret = 0;
>> +
>> +	read_lock(&cpu_pm_notifier_lock);
>> +	ret = cpu_pm_notify(CPU_CLUSTER_PM_ENTER, -1,&nr_calls);
>> +	if (ret)
>> +		cpu_pm_notify(CPU_CLUSTER_PM_ENTER_FAILED, nr_calls - 1, NULL);
>
> What's going on with nr_calls?  Avoiding calling the most recently
> registered callback?  It is unclear why.  Some explanation here would
> be good.
>
ok.

>> +	read_unlock(&cpu_pm_notifier_lock);
>> +
>> +	return ret;
>> +}
>>
>> ...
>>
>> --- a/kernel/power/Kconfig
>> +++ b/kernel/power/Kconfig
>> @@ -235,3 +235,7 @@ config PM_GENERIC_DOMAINS
>>   config PM_GENERIC_DOMAINS_RUNTIME
>>   	def_bool y
>>   	depends on PM_RUNTIME&&  PM_GENERIC_DOMAINS
>> +
>> +config CPU_PM
>> +	def_bool y
>> +	depends on SUSPEND || CPU_IDLE
>
> This will unconditionally include kernel/cpu_pm.o in x86 kernels, and
> it's all dead code.  Fix, please!
The idea was to make it not depend on any arch. I can make this default
n and then enabled it on ARCH_ARM. Same things needs to be done on other
arch's whoever wants to use it.

Regards
Santsoh
