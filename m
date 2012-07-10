Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2GJAN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 20:13:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60179 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab2GJANy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 20:13:54 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFB73A8.4030102@jp.fujitsu.com>
Date: Tue, 10 Jul 2012 09:13:28 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: <linux-acpi@vger.kernel.org>, <lenb@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] acpi : cpu hot-remove returns error number when cpu_down()
 fails
References: <4FF65898.3000301@jp.fujitsu.com> <4FF6B537.1030703@linux.vnet.ibm.com> <4FFA4269.5050808@jp.fujitsu.com> <4FFABFAC.3000708@linux.vnet.ibm.com>
In-Reply-To: <4FFABFAC.3000708@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srivatsa,

2012/07/09 20:25, Srivatsa S. Bhat wrote:
> On 07/09/2012 08:01 AM, Yasuaki Ishimatsu wrote:
>> Hi Srivatsa,
>>
>> Thank you for your reviewing.
>>
>> 2012/07/06 18:51, Srivatsa S. Bhat wrote:
>>> On 07/06/2012 08:46 AM, Yasuaki Ishimatsu wrote:
>>>> Even if cpu_down() fails, acpi_processor_remove() continues to remove the cpu.
>>>
>>> Ouch!
>>>
>>>> But in this case, it should return error number since some process may run on
>>>> the cpu. If the cpu has a running process and the cpu is turned the power off,
>>>> the system cannot work well.
>>>>
>>>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>>>
>>>> ---
>>>>    drivers/acpi/processor_driver.c |   18 ++++++++++++------
>>>>    1 file changed, 12 insertions(+), 6 deletions(-)
>>>>
>>>> Index: linux-3.5-rc4/drivers/acpi/processor_driver.c
>>>> ===================================================================
>>>> --- linux-3.5-rc4.orig/drivers/acpi/processor_driver.c	2012-06-25 04:53:04.000000000 +0900
>>>> +++ linux-3.5-rc4/drivers/acpi/processor_driver.c	2012-07-05 21:02:58.711285382 +0900
>>>> @@ -610,7 +610,7 @@ err_free_pr:
>>>>    static int acpi_processor_remove(struct acpi_device *device, int type)
>>>>    {
>>>>    	struct acpi_processor *pr = NULL;
>>>> -
>>>> +	int ret;
>>>>
>>>>    	if (!device || !acpi_driver_data(device))
>>>>    		return -EINVAL;
>>>> @@ -621,8 +621,9 @@ static int acpi_processor_remove(struct
>>>>    		goto free;
>>>>
>>>>    	if (type == ACPI_BUS_REMOVAL_EJECT) {
>>>> -		if (acpi_processor_handle_eject(pr))
>>>> -			return -EINVAL;
>>>> +		ret = acpi_processor_handle_eject(pr);
>>>> +		if (ret)
>>>> +			return ret;
>>>>    	}
>>>>
>>>>    	acpi_processor_power_exit(pr, device);
>>>> @@ -841,12 +842,17 @@ static acpi_status acpi_processor_hotadd
>>>>
>>>>    static int acpi_processor_handle_eject(struct acpi_processor *pr)
>>>>    {
>>>> -	if (cpu_online(pr->id))
>>>> -		cpu_down(pr->id);
>>>> +	int ret;
>>>> +
>>>> +	if (cpu_online(pr->id)) {
>>>> +		ret = cpu_down(pr->id);
>>>> +		if (ret)
>>>> +			return ret;
>>>> +	}
>>>>
>>>
>>> Strictly speaking, this is not thorough enough. What prevents someone
>>> from onlining that same cpu again, at this point?
>>> So, IMHO, you need to wrap the contents of this function inside a
>>> get_online_cpus()/put_online_cpus() block, to prevent anyone else
>>> from messing with CPU hotplug at the same time.
>>
>> If I understand your comment by mistake, please let me know.
>> If the contents is wrapped a inside get_online_cpus()/put_online_cpus() block
>> as below, cpu_down() will stop since cpu_down() calls cpu_hotplug_begin() and
>> cpu_hotplug_begin() waits for cpu_hotplug.refcount to become 0.
>>
> 
> You are right. Sorry, I overlooked that.
> 
>> +	get_online_cpus()
>> +	if (cpu_online(pr->id)) {
>> +		ret = cpu_down(pr->id);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +	put_online_cpus()
>>
>> I think following patch can prevent it correctly. How about the patch?
>>
>> ---
>>   drivers/acpi/processor_driver.c |   12 ++++++++++++
>>   kernel/cpu.c                    |    8 +++++---
>>   2 files changed, 17 insertions(+), 3 deletions(-)
>>
>> Index: linux-3.5-rc4/drivers/acpi/processor_driver.c
>> ===================================================================
>> --- linux-3.5-rc4.orig/drivers/acpi/processor_driver.c	2012-07-09 09:59:01.280211202 +0900
>> +++ linux-3.5-rc4/drivers/acpi/processor_driver.c	2012-07-09 11:05:34.559859236 +0900
>> @@ -844,14 +844,26 @@ static int acpi_processor_handle_eject(s
>>   {
>>   	int ret;
>>
>> +retry:
>>   	if (cpu_online(pr->id)) {
>>   		ret = cpu_down(pr->id);
>>   		if (ret)
>>   			return ret;
>>   	}
>>
>> +	get_online_cpus();
>> +	/*
>> +	 * Someone might online the cpu again at this point. So we check that
>> +	 * cpu has been onlined or not. If cpu is online, we try to offline
>> +	 * the cpu again.
>> +	 */
>> +	if (cpu_online(pr->id)) {
> 
> How about this:
> 	if (unlikely(cpu_online(pr->id)) {
> since the probability of this happening is quite small...

Thanks. I'll update it.

>> +		put_online_cpus();
>> +		goto retry;
>> +	}
>>   	arch_unregister_cpu(pr->id);
>>   	acpi_unmap_lsapic(pr->id);
>> +	put_online_cpus();
>>   	return ret;
>>   }
> 
> This retry logic doesn't look elegant, but I don't see any better method :-(
> 
>>   #else
>> Index: linux-3.5-rc4/kernel/cpu.c
>> ===================================================================
>> --- linux-3.5-rc4.orig/kernel/cpu.c	2012-07-09 09:59:01.280211202 +0900
>> +++ linux-3.5-rc4/kernel/cpu.c	2012-07-09 09:59:02.903190965 +0900
>> @@ -343,11 +343,13 @@ static int __cpuinit _cpu_up(unsigned in
>>   	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
>>   	struct task_struct *idle;
>>
>> -	if (cpu_online(cpu) || !cpu_present(cpu))
>> -		return -EINVAL;
>> -
>>   	cpu_hotplug_begin();
>>
>> +	if (cpu_online(cpu) || !cpu_present(cpu)) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
> 
> Firstly, why is this change needed?

I cared the race of hot-remove cpu and _cpu_up(). If I do not change it,
there is the following race.

hot-remove cpu                         |  _cpu_up()
------------------------------------- ------------------------------------
call acpi_processor_handle_eject()     |
     call cpu_down()                   |
     call get_online_cpus()            |
                                       | call cpu_hotplug_begin() and stop here
     call arch_unregister_cpu()        |
     call acpi_unmap_lsapic()          |
     call put_online_cpus()            |
                                       | start and continue _cpu_up()
     return acpi_processor_remove()    |
continue hot-remove the cpu            |

So _cpu_up() can continue to itself. And hot-remove cpu can also continue
itself. If I change it, I think the race disappears as below:

hot-remove cpu                         | _cpu_up()
-----------------------------------------------------------------------
call acpi_processor_handle_eject()     |
     call cpu_down()                   |
     call get_online_cpus()            |
                                       | call cpu_hotplug_begin() and stop here
     call arch_unregister_cpu()        |
     call acpi_unmap_lsapic()          |
          cpu's cpu_present is set     |
	  to false by set_cpu_present()|
     call put_online_cpus()            |
                                       | start _cpu_up()
				       | check cpu_present() and return -EINVAL
     return acpi_processor_remove()    |
continue hot-remove the cpu            |

Thus I think the change is necessary.

Thanks,
Yasuaki Ishimatsu

> Secondly, if the change is indeed an improvement, then why is it
> in _this_ patch? IMHO, in that case it should be part of a separate patch.
> 
> Coming back to my first point, I don't see why this hunk is needed. We
> already take the cpu_add_remove_lock (cpu_maps_update_begin/end) before
> checking the status of the cpu (online or present). And all hotplug
> operations (cpu_up/cpu_down/disable|enable_nonboot_cpus) go through that
> lock. Isn't that enough? Or am I missing something?
> 
>>   	idle = idle_thread_get(cpu);
>>   	if (IS_ERR(idle)) {
>>   		ret = PTR_ERR(idle);
>>
>   
> Regards,
> Srivatsa S. Bhat
> 



