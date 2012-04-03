Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab2DCLva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:51:30 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:56389 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab2DCLv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:51:28 -0400
Message-ID: <4F7AE42F.9080800@linux.vnet.ibm.com>
Date: Tue, 03 Apr 2012 17:21:11 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: lenb@kernel.org, khilman@ti.com, deepthi@linux.vnet.ibm.com,
        g.trinabh@gmail.com, arjan@infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, amit.kucheria@linaro.org
Subject: Re: [PATCH] cpuidle: Avoid possible NULL pointer dereference in __cpuidle_register_device()
References: <20120402144422.11574.83174.stgit@srivatsabhat.in.ibm.com> <4F79FE8F.1040708@linaro.org>
In-Reply-To: <4F79FE8F.1040708@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12040301-6102-0000-0000-000001299F60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 01:01 AM, Daniel Lezcano wrote:

> On 04/02/2012 04:44 PM, Srivatsa S. Bhat wrote:
>> In __cpuidle_register_device(), "dev->cpu" is used before checking if
>> dev is
>> non-NULL. Fix it.
>>
>> Signed-off-by: Srivatsa S. Bhat<srivatsa.bhat@linux.vnet.ibm.com>
>> ---
> 
> That should be fixed at the caller level. Usually, static function does
> not check the function parameters, it is up to the exported function to
> do that. It is supposed the static functions are called with valid
> parameters.
> 


Ok, good point! I hadn't thought about that.. I just happened to notice
that in __cpuidle_register_device(), the dev == NULL check is performed
_after_ dereferencing it, which made the check useless. So I tried to
fix that within that function. But thanks for pointing out the semantics..

> There are two callers for __cpuidle_register_device:
>  * cpuidle_register_device
>  * cpuidle_enable_device
> 
> Both of them do not check 'dev' is a valid parameter. They should as
> they are exported and could be used by an external module. IMHO, BUG_ON
> could be used here if dev == NULL.
>


BUG_ON? That would crash the system.. which might be unnecessary..

How about checking if dev == NULL in the 2 callers like you suggested 
and returning -EINVAL if dev is indeed NULL?

(And of course no checks for dev == NULL in __cpuidle_register_device).

 
> 
>>   drivers/cpuidle/cpuidle.c |    3 ++-
>>   1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>> index 87411ce..75b381e 100644
>> --- a/drivers/cpuidle/cpuidle.c
>> +++ b/drivers/cpuidle/cpuidle.c
>> @@ -372,7 +372,7 @@ EXPORT_SYMBOL_GPL(cpuidle_disable_device);
>>   static int __cpuidle_register_device(struct cpuidle_device *dev)
>>   {
>>       int ret;
>> -    struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
>> +    struct device *cpu_dev;
>>       struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
>>
>>       if (!dev)
>> @@ -380,6 +380,7 @@ static int __cpuidle_register_device(struct
>> cpuidle_device *dev)
>>       if (!try_module_get(cpuidle_driver->owner))
>>           return -EINVAL;
>>
>> +    cpu_dev = get_cpu_device((unsigned long)dev->cpu);
>>       init_completion(&dev->kobj_unregister);
>>
>>       per_cpu(cpuidle_devices, dev->cpu) = dev;
>>
> 
> 


Thank you for the review!

Regards,
Srivatsa S. Bhat

