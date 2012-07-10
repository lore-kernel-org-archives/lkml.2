Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab2GJH7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 03:59:10 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:46555 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab2GJH7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 03:59:08 -0400
Message-ID: <4FFBE06A.4090800@linux.vnet.ibm.com>
Date: Tue, 10 Jul 2012 13:27:30 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: Toshi Kani <toshi.kani@hp.com>, linux-acpi@vger.kernel.org,
        lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] acpi : cpu hot-remove returns error number when cpu_down()
 fails
References: <4FF65898.3000301@jp.fujitsu.com> <4FF6B537.1030703@linux.vnet.ibm.com> <4FFA4269.5050808@jp.fujitsu.com> <4FFABFAC.3000708@linux.vnet.ibm.com> <1341868544.16730.780.camel@misato.fc.hp.com> <4FFBB62E.9010707@jp.fujitsu.com>
In-Reply-To: <4FFBB62E.9010707@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12070921-6102-0000-0000-000001DA8168
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 10:27 AM, Yasuaki Ishimatsu wrote:
> Hi Toshi,
> 
> 2012/07/10 6:15, Toshi Kani wrote:
>> On Mon, 2012-07-09 at 16:55 +0530, Srivatsa S. Bhat wrote:
>>> On 07/09/2012 08:01 AM, Yasuaki Ishimatsu wrote:
>>>> Hi Srivatsa,
>>>>
>>>> Thank you for your reviewing.
>>>>
>>>> 2012/07/06 18:51, Srivatsa S. Bhat wrote:
>>>>> On 07/06/2012 08:46 AM, Yasuaki Ishimatsu wrote:
>>>>>> Even if cpu_down() fails, acpi_processor_remove() continues to
>>>>>> remove the cpu.
>>>>>
>>>>> Ouch!
>>>>>
>>>>>> But in this case, it should return error number since some process
>>>>>> may run on
>>>>>> the cpu. If the cpu has a running process and the cpu is turned
>>>>>> the power off,
>>>>>> the system cannot work well.
>>>>>>
>>>>>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>>>>>
>>>>>> ---
>>>>>>    drivers/acpi/processor_driver.c |   18 ++++++++++++------
>>>>>>    1 file changed, 12 insertions(+), 6 deletions(-)
>>>>>>
>>>>>> Index: linux-3.5-rc4/drivers/acpi/processor_driver.c
>>>>>> ===================================================================
>>>>>> --- linux-3.5-rc4.orig/drivers/acpi/processor_driver.c   
>>>>>> 2012-06-25 04:53:04.000000000 +0900
>>>>>> +++ linux-3.5-rc4/drivers/acpi/processor_driver.c    2012-07-05
>>>>>> 21:02:58.711285382 +0900
>>>>>> @@ -610,7 +610,7 @@ err_free_pr:
>>>>>>    static int acpi_processor_remove(struct acpi_device *device,
>>>>>> int type)
>>>>>>    {
>>>>>>        struct acpi_processor *pr = NULL;
>>>>>> -
>>>>>> +    int ret;
>>>>>>
>>>>>>        if (!device || !acpi_driver_data(device))
>>>>>>            return -EINVAL;
>>>>>> @@ -621,8 +621,9 @@ static int acpi_processor_remove(struct
>>>>>>            goto free;
>>>>>>
>>>>>>        if (type == ACPI_BUS_REMOVAL_EJECT) {
>>>>>> -        if (acpi_processor_handle_eject(pr))
>>>>>> -            return -EINVAL;
>>>>>> +        ret = acpi_processor_handle_eject(pr);
>>>>>> +        if (ret)
>>>>>> +            return ret;
>>>>>>        }
>>>>>>
>>>>>>        acpi_processor_power_exit(pr, device);
>>>>>> @@ -841,12 +842,17 @@ static acpi_status acpi_processor_hotadd
>>>>>>
>>>>>>    static int acpi_processor_handle_eject(struct acpi_processor *pr)
>>>>>>    {
>>>>>> -    if (cpu_online(pr->id))
>>>>>> -        cpu_down(pr->id);
>>>>>> +    int ret;
>>>>>> +
>>>>>> +    if (cpu_online(pr->id)) {
>>>>>> +        ret = cpu_down(pr->id);
>>>>>> +        if (ret)
>>>>>> +            return ret;
>>>>>> +    }
>>>>>>
>>>>>
>>>>> Strictly speaking, this is not thorough enough. What prevents someone
>>>>> from onlining that same cpu again, at this point?
>>>>> So, IMHO, you need to wrap the contents of this function inside a
>>>>> get_online_cpus()/put_online_cpus() block, to prevent anyone else
>>>>> from messing with CPU hotplug at the same time.
>>>>
>>>> If I understand your comment by mistake, please let me know.
>>>> If the contents is wrapped a inside
>>>> get_online_cpus()/put_online_cpus() block
>>>> as below, cpu_down() will stop since cpu_down() calls
>>>> cpu_hotplug_begin() and
>>>> cpu_hotplug_begin() waits for cpu_hotplug.refcount to become 0.
>>>>
>>>
>>> You are right. Sorry, I overlooked that.
>>>
>>>> +    get_online_cpus()
>>>> +    if (cpu_online(pr->id)) {
>>>> +        ret = cpu_down(pr->id);
>>>> +        if (ret)
>>>> +            return ret;
>>>> +    }
>>>> +    put_online_cpus()
>>>>
>>>> I think following patch can prevent it correctly. How about the patch?
>>>>
>>>> ---
>>>>   drivers/acpi/processor_driver.c |   12 ++++++++++++
>>>>   kernel/cpu.c                    |    8 +++++---
>>>>   2 files changed, 17 insertions(+), 3 deletions(-)
>>>>
>>>> Index: linux-3.5-rc4/drivers/acpi/processor_driver.c
>>>> ===================================================================
>>>> --- linux-3.5-rc4.orig/drivers/acpi/processor_driver.c    2012-07-09
>>>> 09:59:01.280211202 +0900
>>>> +++ linux-3.5-rc4/drivers/acpi/processor_driver.c    2012-07-09
>>>> 11:05:34.559859236 +0900
>>>> @@ -844,14 +844,26 @@ static int acpi_processor_handle_eject(s
>>>>   {
>>>>       int ret;
>>>>
>>>> +retry:
>>>>       if (cpu_online(pr->id)) {
>>>>           ret = cpu_down(pr->id);
>>>>           if (ret)
>>>>               return ret;
>>>>       }
>>>>
>>>> +    get_online_cpus();
>>>> +    /*
>>>> +     * Someone might online the cpu again at this point. So we
>>>> check that
>>>> +     * cpu has been onlined or not. If cpu is online, we try to
>>>> offline
>>>> +     * the cpu again.
>>>> +     */
>>>> +    if (cpu_online(pr->id)) {
>>>
>>> How about this:
>>>     if (unlikely(cpu_online(pr->id)) {
>>> since the probability of this happening is quite small...
>>>
>>>> +        put_online_cpus();
>>>> +        goto retry;
>>>> +    }
>>>>       arch_unregister_cpu(pr->id);
>>>>       acpi_unmap_lsapic(pr->id);
>>>> +    put_online_cpus();
>>>>       return ret;
>>>>   }
>>>
>>> This retry logic doesn't look elegant, but I don't see any better
>>> method :-(
>>
>> Another possible option is to fail the request instead of retrying it.
> 
> Good idea!! I'll update it.
> 
>>
>> It would be quite challenging to allow on-lining and off-lining
>> operations to run concurrently.  In fact, even if we close this window,
>> there is yet another window right after the new put_online_cpus() call.
> 
> I think if we close the window, another window does not open.
> acpi_unmap_lsapic() sets cpu_present mask to false before new
> put_online_cpus()
> is called. So even if _cpu_up() is called, the function returns -EINAVL by
> following added code.
> 
> @@ -343,11 +343,13 @@ static int __cpuinit _cpu_up(unsigned in
>      unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
>      struct task_struct *idle;
> 
> -    if (cpu_online(cpu) || !cpu_present(cpu))
> -        return -EINVAL;
> -
>      cpu_hotplug_begin();
> 
> +    if (cpu_online(cpu) || !cpu_present(cpu)) {
> +        ret = -EINVAL;
> +        goto out;
> +    }
> +
> 

Right. Yasuaki's patch will ensure that there are no more race conditions
because it does the cpu_present() check after taking the cpu_hotplug.lock.
So I think it is safe and still doable from the kernel's perspective.

But the question is, "should we do it?" I think Toshi's suggestion of failing
the hot-remove request (if we find that the cpu has been onlined again by some
other task) sounds like a good idea for another reason: cpu hotplug is not
initiated by the OS by itself; its requested by the user; so if something is
onlining the cpu back again, the user better take a second look and decide
what exactly he wants to do with that cpu - whether keep it online or
hot-remove it out.

Trying to online as well as hot-remove the same cpu simultaneously sounds like
a crazy thing to do, and returning -EBUSY or -EAGAIN in the hot-remove case
(ie., failing that request) would give a warning to the user and a chance to
reflect upon what exactly he wants to do with the cpu.

So, IMHO, we should protect against the race condition (between cpu_up and
hot-remove) but choose to fail the hot-remove request, and add a comment saying
why we chose to fail the request, even though we could have gone ahead and
completed it.

Regards,
Srivatsa S. Bhat

