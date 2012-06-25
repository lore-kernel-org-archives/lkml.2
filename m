Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab2FYMbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 08:31:24 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:34374 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab2FYMbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 08:31:22 -0400
Message-ID: <4FE85A0B.4000108@linux.vnet.ibm.com>
Date: Mon, 25 Jun 2012 18:01:07 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Fengguang Wu <wfg@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Preeti Murthy <preeti@linux.vnet.ibm.com>,
        Srivatsa S Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: boot hang on commit "PM / ACPI: Fix suspend/resume regression
 caused by cpuidle cleanup."
References: <20120622073513.GA15864@localhost> <4FE44163.4060509@linux.vnet.ibm.com> <20120622122453.GA17341@localhost> <201206250018.15384.rjw@sisk.pl>
In-Reply-To: <201206250018.15384.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12062502-0260-0000-0000-000001656B54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 03:48 AM, Rafael J. Wysocki wrote:

> On Friday, June 22, 2012, Fengguang Wu wrote:
>> Hi Deepthi,
>>
>> I can no longer reproduce this issue... Sorry for the noise!
> 
> But I do, 100% of the time on real hardware which is Acer Ferrari One.
> 
> The symptom is that the new WARN_ON() triggers pretty much on every
> cpuidle transition for me which makes the machine unuseable.
> 
> That may be a result of a different bug, but the box evidently works
> without the hunk in arch/x86/kernel/process.c, so I'd prefer to drop it
> for now.

If cpu is coming out of cpuidle with WARN_ON every-time, is suspend 
on this device working ?  Wanted to get some clarity about this hardware .
We can remove this check for now.

> Moreover, I have a couple of questions regarding the implementation.
> 
> First, why are we returning -EINVAL if acpi_idle_suspend is set?  Surely,
> something like -EBUSY or -EAGAIN would be better here, wouldn't it?
> 


Any negative return value will serve the purpose. We put it as -EINVAL
as cpu_idle operation during suspend was termed invalid. I will change it to 
-EBUSY for better readability. 

> Second, is the cpu_relax() before returning really necessary?


cpu_relax operation is mainly to lower CPU power consumption.
If the system is idle, we would want to at-least reduce 
power consumption. Better than busy looping in and out of idle when 
suspend is triggered. There is no harm having it. 

> 
> Finally, the hunk in acpi_idle_enter_bm() still looks ugly.  I'd prefer
> something like this instead:
> 
> @@ -907,7 +928,10 @@ static int acpi_idle_enter_bm(struct cpu
>  						drv, drv->safe_state_index);
>  		} else {
>  			local_irq_disable();
> -			acpi_safe_halt();
> +
> +			if (!acpi_idle_suspend)
> +				acpi_safe_halt();
> +
>  			local_irq_enable();
>  			return -EINVAL;
>  		}
> @@ -915,6 +939,12 @@ static int acpi_idle_enter_bm(struct cpu
> 
>  	local_irq_disable();
> 
> +	if (acpi_idle_suspend) {
> +		local_irq_enable();
> +		cpu_relax();
> +		return -EBUSY;
> +	}
> +
>  	if (cx->entry_method != ACPI_CSTATE_FFH) {
>  		current_thread_info()->status &= ~TS_POLLING;
>  		/*
> 
> Hmm?


Yes, I'll will re-factor the code. 

 
> The patch has been dropped from the linux-pm tree (hopefully for now).
> 
> Thanks,
> Rafael
> 
> 
>> On Fri, Jun 22, 2012 at 03:26:51PM +0530, Deepthi Dharwar wrote:
>>> Hi,
>>>
>>> This is interesting .. suspend fix breaking boot on kvm.
>>>
>>> We complied and booted fine with mainline kernels including 3.5-rc2 with
>>> this fix  on servers and laptops.
>>> So wondering how different is  booting on machines Vs
>>> from kvm ?
>>>
>>> Also, are you seeing smooth boot on kvm by reverting only this patch ?
>>>
>>> Cheers
>>> Deepthi
>>>
>>> On 06/22/2012 01:05 PM, wfg@linux.intel.com wrote:
>>>
>>>> Hi Deepthi,
>>>>
>>>> It seems that commit de08622 triggers a boot hang in my kvm boot test.
>>>>
>>>> kvm -cpu kvm64 -enable-kvm \
>>>>                 -kernel ./gpxelinux.lkrn \
>>>>                 -initrd ./kvm.gpxe \
>>>>                 -m 384M \
>>>>                 -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=e1000  \
>>>>                 -net user,vlan=0,hostfwd=tcp::$port-:22 \
>>>>                 -boot order=nc \
>>>>                 -no-reboot \
>>>>                 -watchdog i6300esb \
>>>>                 $(qemu_drives) \
>>>>                 -pidfile $pidfile \
>>>>                 -serial file:$dmesg 
>>>>
>>>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next
>>>> head:   de08622731417ba429fc470ab8f2d7c260cb5c72
>>>> commit: de08622731417ba429fc470ab8f2d7c260cb5c72 [9/9] PM / ACPI: Fix suspend/resume regression caused by cpuidle cleanup.
>>>> config: x86_64-allyesdebian (attached as .config)
>>>>
>>>> x86_64-allyesdebian         bbbbbbbbbB
>>>> --
>>>> 8:	b 0eb8c06  2012-06-19 22:23:37 +0200 PM / Sleep: Separate printing suspend times from initcall_debug
>>>> 9:	B de08622  boot hang after [   81.370898] usbcore: registered new interface driver dw2102
>>>>
>>>> legend: [b] boot fine  [B] boot error
>>>>
>>>> commit de08622731417ba429fc470ab8f2d7c260cb5c72
>>>> Author: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
>>>> Date:   Wed Jun 13 16:28:17 2012 +0530
>>>>
>>>>     PM / ACPI: Fix suspend/resume regression caused by cpuidle cleanup.
>>>>     
>>>>     Commit e978aa7d7d57d04eb5f88a7507c4fb98577def77 ( cpuidle: Move
>>>>     dev->last_residency update to driver enter routine; remove dev->last_state)
>>>>     was  breaking suspend on laptops, as reported in the below link
>>>>     	- https://lkml.org/lkml/2011/11/11/164
>>>>     
>>>>     This was fixed in commit 3439a8da16bcad6b0982ece938c9f8299bb53584
>>>>     (ACPI / cpuidle: Remove acpi_idle_suspend (to fix suspend regression)
>>>>     by removing acpi_idle_suspend flag.
>>>>     	- https://lkml.org/lkml/2011/11/14/74
>>>>     
>>>>     But this fix did not work on all systems
>>>>     as Suspend/resume regression was reported on Lenovo S10-3
>>>>     recently by Dave.
>>>>     	- https://lkml.org/lkml/2012/5/27/115
>>>>     It looked like with commit e978aa7d broke suspend and
>>>>     with commit 3439a8da resume was not working with acpi_idle driver.
>>>>     
>>>>     This patch fixes the regression that caused this issue
>>>>     in the first place. acpi_idle_suspend flag is essential on
>>>>     some x86 systems to prevent the cpus from going to deeper C-states
>>>>     when suspend is triggered ( commit b04e7bdb984 )
>>>>     So reverting the commit 3439a8da is essential.
>>>>     
>>>>     By default, irqs are disabled in cpu_idle arch specific call
>>>>     and re-enabled in idle state return path . As the acpi_idle_suspend
>>>>     flag was being set during suspend, which prevented the cpus
>>>>     going to deeper idle states, it is essential to
>>>>     enabling the irqs in its return path too.
>>>>     
>>>>     To address the suspend issue,
>>>>     we were not re-enabling the interrupts while returning from
>>>>     acpi_idle_enter_bm() routine if acpi_idle_suspend flag is set.
>>>>     and this was causing suspend failure.
>>>>     
>>>>     In addition to the above fix, a sanity check has also been added
>>>>     in x86 arch specific cpu_idle call to ensure that the idle call
>>>>     always returns with IRQs enabled.
>>>>     
>>>>     Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
>>>>     Reported-and-Tested-by: Dav Hansen <dave@linux.vnet.ibm.com>
>>>>     Tested-by: Preeti Murthy <preeti@linux.vnet.ibm.com>
>>>>     Reviewed-by: Srivatsa S Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>>>>     Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>>>>
>>>> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
>>>> index 735279e..8ab76ad 100644
>>>> --- a/arch/x86/kernel/process.c
>>>> +++ b/arch/x86/kernel/process.c
>>>> @@ -460,6 +460,12 @@ void cpu_idle(void)
>>>>  				pm_idle();
>>>>
>>>>  			rcu_idle_exit();
>>>> +
>>>> +			/*
>>>> +			 * Sanity check to ensure that idle call returns
>>>> +			 * with IRQs enabled
>>>> +			 */
>>>> +			WARN_ON(irqs_disabled());
>>>>  			start_critical_timings();
>>>>
>>>>  			/* In many cases the interrupt that ended idle
>>>> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
>>>> index f3decb3..c2ffd84 100644
>>>> --- a/drivers/acpi/processor_idle.c
>>>> +++ b/drivers/acpi/processor_idle.c
>>>> @@ -224,6 +224,7 @@ static void lapic_timer_state_broadcast(struct acpi_processor *pr,
>>>>  /*
>>>>   * Suspend / resume control
>>>>   */
>>>> +static int acpi_idle_suspend;
>>>>  static u32 saved_bm_rld;
>>>>
>>>>  static void acpi_idle_bm_rld_save(void)
>>>> @@ -242,13 +243,21 @@ static void acpi_idle_bm_rld_restore(void)
>>>>
>>>>  int acpi_processor_suspend(struct acpi_device * device, pm_message_t state)
>>>>  {
>>>> +	if (acpi_idle_suspend == 1)
>>>> +		return 0;
>>>> +
>>>>  	acpi_idle_bm_rld_save();
>>>> +	acpi_idle_suspend = 1;
>>>>  	return 0;
>>>>  }
>>>>
>>>>  int acpi_processor_resume(struct acpi_device * device)
>>>>  {
>>>> +	if (acpi_idle_suspend == 0)
>>>> +		return 0;
>>>> +
>>>>  	acpi_idle_bm_rld_restore();
>>>> +	acpi_idle_suspend = 0;
>>>>  	return 0;
>>>>  }
>>>>
>>>> @@ -754,6 +763,12 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
>>>>
>>>>  	local_irq_disable();
>>>>
>>>> +	if (acpi_idle_suspend) {
>>>> +		local_irq_enable();
>>>> +		cpu_relax();
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>>  	lapic_timer_state_broadcast(pr, cx, 1);
>>>>  	kt1 = ktime_get_real();
>>>>  	acpi_idle_do_entry(cx);
>>>> @@ -823,6 +838,12 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
>>>>
>>>>  	local_irq_disable();
>>>>
>>>> +	if (acpi_idle_suspend) {
>>>> +		local_irq_enable();
>>>> +		cpu_relax();
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>>  	if (cx->entry_method != ACPI_CSTATE_FFH) {
>>>>  		current_thread_info()->status &= ~TS_POLLING;
>>>>  		/*
>>>> @@ -901,6 +922,13 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
>>>>  	if (unlikely(!pr))
>>>>  		return -EINVAL;
>>>>
>>>> +	if (acpi_idle_suspend) {
>>>> +		if (irqs_disabled())
>>>> +			local_irq_enable();
>>>> +		cpu_relax();
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>>  	if (!cx->bm_sts_skip && acpi_idle_bm_check()) {
>>>>  		if (drv->safe_state_index >= 0) {
>>>>  			return drv->states[drv->safe_state_index].enter(dev,
>>>
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


Cheers,
Deepthi

