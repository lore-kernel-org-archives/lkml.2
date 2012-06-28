Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab2F1IEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 04:04:10 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52513 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab2F1ID5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 04:03:57 -0400
Message-ID: <4FEC0FEC.5070304@linaro.org>
Date: Thu, 28 Jun 2012 10:03:56 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: srivatsa.bhat@linux.vnet.ibm.com, deepthi@linux.vnet.ibm.com,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-pm@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl, x86@kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: Re: [PATCH] acpi: intel_idle : break dependency between modules
References: <201206261301.25550.trenn@suse.de> <1340788068-16422-1-git-send-email-daniel.lezcano@linaro.org> <201206271506.29034.trenn@suse.de>
In-Reply-To: <201206271506.29034.trenn@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 03:06 PM, Thomas Renninger wrote:
> Hi,
> 
> I agree that such a dependency between 2 modules is not
> nice. But your patch will have bad side-effects (see comments
> embedded below).
> 
> On Wednesday, June 27, 2012 11:07:48 AM Daniel Lezcano wrote:
>> When the system is booted with some cpus offline, the idle
>> driver is not initialized. When a cpu is set online, the
>> acpi code call the intel idle init function. Unfortunately
>> this code introduce a dependency between intel_idle and acpi.
>>
>> This patch is intended to remove this dependency by using the
>> notifier of intel_idle. In order to make it work, the notifier
>> must be initialized in the right order, acpi then intel_idle.
>> This is done in the Makefile. This patch has the benefit of
>> encapsulating the intel_idle driver and remove some exported
>> functions.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> ---
>>  drivers/Makefile                |    3 ++-
>>  drivers/acpi/processor_driver.c |    7 -------
>>  drivers/idle/intel_idle.c       |   22 ++++++++++++++--------
>>  include/linux/cpuidle.h         |    7 -------
>>  4 files changed, 16 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/Makefile b/drivers/Makefile
>> index 2ba29ff..a2454b8 100644
>> --- a/drivers/Makefile
>> +++ b/drivers/Makefile
>> @@ -12,8 +12,9 @@ obj-$(CONFIG_PCI)		+= pci/
>>  obj-$(CONFIG_PARISC)		+= parisc/
>>  obj-$(CONFIG_RAPIDIO)		+= rapidio/
>>  obj-y				+= video/
>> -obj-y				+= idle/
>> +# acpi must come before idle for initialization
>>  obj-$(CONFIG_ACPI)		+= acpi/
>> +obj-y				+= idle/
> This breaks intel_idle.
> Loading order defines which one comes first and is used: intel_idle
> or ACPI processor cpuidle driver.
> With above, one would get acpi_idle cpuidle driver if both are
> compiled in, instead of the intel_idle one.
> 
> Why exactly is this necessary, couldn't it just work?

[...]

I just wanted to keep same order. If it is not necessary, I won't invert
the compilation order in the next patch.

>> -static int setup_broadcast_cpuhp_notify(struct notifier_block *n,
>> -		unsigned long action, void *hcpu)
>> +static int cpu_hotplug_notify(struct notifier_block *n,
>> +			      unsigned long action, void *hcpu)
>>  {
>>  	int hotcpu = (unsigned long)hcpu;
>> +	struct cpuidle_device *dev;
>>  
>>  	switch (action & 0xf) {
>>  	case CPU_ONLINE:
>>  		smp_call_function_single(hotcpu, __setup_broadcast_timer,
>>  			(void *)true, 1);
>> +
>> +		dev = per_cpu_ptr(intel_idle_cpuidle_devices, hotcpu);
>> +		if (!dev->registered)
>> +			intel_idle_cpu_init(hotcpu);
>> +
> A small comment why this can happen and needs to be done
> (real hotplugged cpu case) might help here later.

Yes, that makes sense.

[...]

>>  static void auto_demotion_disable(void *dummy)
>> @@ -407,7 +414,7 @@ static int intel_idle_probe(void)
>>  		lapic_timer_reliable_states = LAPIC_TIMER_ALWAYS_RELIABLE;
>>  	else {
>>  		on_each_cpu(__setup_broadcast_timer, (void *)true, 1);
>> -		register_cpu_notifier(&setup_broadcast_notifier);
>> +		register_cpu_notifier(&cpu_hotplug_notifier);
> 
> The notifier always has to be registered now, not only in:
> if (boot_cpu_has(X86_FEATURE_ARAT))     /* Always Reliable APIC Timer */
> case.

Oops, right.


>>  	pr_debug(PREFIX "v" INTEL_IDLE_VERSION
>> @@ -494,7 +501,7 @@ static int intel_idle_cpuidle_driver_init(void)
>>   * allocate, initialize, register cpuidle_devices
>>   * @cpu: cpu/core to initialize
>>   */
>> -int intel_idle_cpu_init(int cpu)
>> +static int intel_idle_cpu_init(int cpu)
>>  {
>>  	int cstate;
>>  	struct cpuidle_device *dev;
>> @@ -539,7 +546,6 @@ int intel_idle_cpu_init(int cpu)
>>  
>>  	return 0;
>>  }
>> -EXPORT_SYMBOL_GPL(intel_idle_cpu_init);
>>  
>>  static int __init intel_idle_init(void)
>>  {
>> @@ -583,7 +589,7 @@ static void __exit intel_idle_exit(void)
>>  
>>  	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE) {
>>  		on_each_cpu(__setup_broadcast_timer, (void *)false, 1);
>> -		unregister_cpu_notifier(&setup_broadcast_notifier);
>> +		unregister_cpu_notifier(&cpu_hotplug_notifier);
> Same.


Thanks for the review !

  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

