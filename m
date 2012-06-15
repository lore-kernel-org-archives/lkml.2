Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab2FOMQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:16:51 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:55798 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab2FOMQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:16:48 -0400
Message-ID: <4FDB279F.7020801@linux.vnet.ibm.com>
Date: Fri, 15 Jun 2012 17:46:31 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Jean Pihet <j-pihet@ti.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kevin Hilman <khilman@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Ferenc Wagner <wferi@niif.hu>, "Tomas M." <tmezzadra@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        preeti@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ACPI, cpuidle: Fix suspend/resume regression caused by
 cpuidle cleanup.
References: <4FD87249.6010302@linux.vnet.ibm.com> <201206132201.26058.rjw@sisk.pl>
In-Reply-To: <201206132201.26058.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12061512-2674-0000-0000-000004E95A66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please include this in -stable tree, as this is a regression fix which
affects older kernels ( 3.1 onwards )
Link to the patch : 
http://permalink.gmane.org/gmane.linux.power-management.general/27614

Thanks !
Deepthi

On 06/14/2012 01:31 AM, Rafael J. Wysocki wrote:

> On Wednesday, June 13, 2012, Deepthi Dharwar wrote:
>>
>> From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
>>
>> Fix suspend/resume regression caused by cpuidle cleanup.
>>
>> Commit e978aa7d7d57d04eb5f88a7507c4fb98577def77 ( cpuidle: Move
>> dev->last_residency update to driver enter routine; remove dev->last_state)
>> was  breaking suspend on laptops, as reported in the below link
>> 	- https://lkml.org/lkml/2011/11/11/164
>>
>> This was fixed in commit 3439a8da16bcad6b0982ece938c9f8299bb53584
>> (ACPI / cpuidle: Remove acpi_idle_suspend (to fix suspend regression)
>> by removing acpi_idle_suspend flag.
>> 	- https://lkml.org/lkml/2011/11/14/74
>>
>> But this fix did not work on all systems
>> as Suspend/resume regression was reported on Lenovo S10-3
>> recently by Dave.
>> 	- https://lkml.org/lkml/2012/5/27/115
>> It looked like with commit e978aa7d broke suspend and
>> with commit 3439a8da resume was not working with acpi_idle driver.
>>
>> This patch fixes the regression that caused this issue
>> in the first place. acpi_idle_suspend flag is essential on
>> some x86 systems to prevent the cpus from going to deeper C-states
>> when suspend is triggered ( commit b04e7bdb984 )
>> So reverting the commit 3439a8da is essential.
>>
>> By default, irqs are disabled in cpu_idle arch specific call
>> and re-enabled in idle state return path . As the acpi_idle_suspend
>> flag was being set during suspend, which prevented the cpus
>> going to deeper idle states, it is essential to
>> enabling the irqs in its return path too.
>>
>> To address the suspend issue,
>> we were not re-enabling the interrupts while returning from
>> acpi_idle_enter_bm() routine if acpi_idle_suspend flag is set.
>> and this was causing suspend failure.
>>
>> In addition to the above fix, a sanity check has also been added
>> in x86 arch specific cpu_idle call to ensure that the idle call
>> always returns with IRQs enabled.
>>
>> This patch applies on 3.5-rc2
>> ---
>>
>> Reported-and-Tested-by: Dav Hansen <dave@linux.vnet.ibm.com>
>> Tested-by: Preeti Murthy <preeti@linux.vnet.ibm.com>
>> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
>> Reviewed-by: Srivatsa S Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
>> ---
>>  arch/x86/kernel/process.c     |    6 ++++++
>>  drivers/acpi/processor_idle.c |   28 ++++++++++++++++++++++++++++
>>  2 files changed, 34 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
>> index 735279e..8ab76ad 100644
>> --- a/arch/x86/kernel/process.c
>> +++ b/arch/x86/kernel/process.c
>> @@ -460,6 +460,12 @@ void cpu_idle(void)
>>  				pm_idle();
>>
>>  			rcu_idle_exit();
>> +
>> +			/*
>> +			 * Sanity check to ensure that idle call returns
>> +			 * with IRQs enabled
>> +			 */
>> +			WARN_ON(irqs_disabled());
>>  			start_critical_timings();
>>
>>  			/* In many cases the interrupt that ended idle
>> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
>> index f3decb3..c2ffd84 100644
>> --- a/drivers/acpi/processor_idle.c
>> +++ b/drivers/acpi/processor_idle.c
>> @@ -224,6 +224,7 @@ static void lapic_timer_state_broadcast(struct acpi_processor *pr,
>>  /*
>>   * Suspend / resume control
>>   */
>> +static int acpi_idle_suspend;
>>  static u32 saved_bm_rld;
>>
>>  static void acpi_idle_bm_rld_save(void)
>> @@ -242,13 +243,21 @@ static void acpi_idle_bm_rld_restore(void)
>>
>>  int acpi_processor_suspend(struct acpi_device * device, pm_message_t state)
>>  {
>> +	if (acpi_idle_suspend == 1)
>> +		return 0;
>> +
>>  	acpi_idle_bm_rld_save();
>> +	acpi_idle_suspend = 1;
>>  	return 0;
>>  }
>>
>>  int acpi_processor_resume(struct acpi_device * device)
>>  {
>> +	if (acpi_idle_suspend == 0)
>> +		return 0;
>> +
>>  	acpi_idle_bm_rld_restore();
>> +	acpi_idle_suspend = 0;
>>  	return 0;
>>  }
>>
>> @@ -754,6 +763,12 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
>>
>>  	local_irq_disable();
>>
>> +	if (acpi_idle_suspend) {
>> +		local_irq_enable();
>> +		cpu_relax();
>> +		return -EINVAL;
>> +	}
>> +
>>  	lapic_timer_state_broadcast(pr, cx, 1);
>>  	kt1 = ktime_get_real();
>>  	acpi_idle_do_entry(cx);
>> @@ -823,6 +838,12 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
>>
>>  	local_irq_disable();
>>
>> +	if (acpi_idle_suspend) {
>> +		local_irq_enable();
>> +		cpu_relax();
>> +		return -EINVAL;
>> +	}
>> +
>>  	if (cx->entry_method != ACPI_CSTATE_FFH) {
>>  		current_thread_info()->status &= ~TS_POLLING;
>>  		/*
>> @@ -901,6 +922,13 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
>>  	if (unlikely(!pr))
>>  		return -EINVAL;
>>
>> +	if (acpi_idle_suspend) {
>> +		if (irqs_disabled())
>> +			local_irq_enable();
>> +		cpu_relax();
>> +		return -EINVAL;
>> +	}
>> +
>>  	if (!cx->bm_sts_skip && acpi_idle_bm_check()) {
>>  		if (drv->safe_state_index >= 0) {
>>  			return drv->states[drv->safe_state_index].enter(dev,
>>
>> Regards,
>> Deepthi
>>
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


