Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab1FUEgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 00:36:32 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:35742 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab1FUEgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 00:36:31 -0400
Message-ID: <4E001FC2.1000006@linux.vnet.ibm.com>
Date: Tue, 21 Jun 2011 10:06:18 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-pm@lists.linux-foundation.org, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V1 1/7] cpuidle: create bootparam "cpuidle.off=1"
References: <20110607162847.6848.44707.stgit@tringupt.in.ibm.com> <20110607162922.6848.71783.stgit@tringupt.in.ibm.com> <1308284948.32158.6.camel@pasglop>
In-Reply-To: <1308284948.32158.6.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/17/2011 09:59 AM, Benjamin Herrenschmidt wrote:
> On Tue, 2011-06-07 at 21:59 +0530, Trinabh Gupta wrote:
>> From: Len Brown<len.brown@intel.com>
>>
>> useful for disabling cpuidle to fall back
>> to architecture-default idle loop
>>
>> cpuidle drivers and governors will fail to register.
>> on x86 they'll say so:
>>
>> intel_idle: intel_idle yielding to (null)
>> ACPI: acpi_idle yielding to (null)
>>
>> Signed-off-by: Len Brown<len.brown@intel.com>
>> ---

Hi Ben,

Thanks for the review.
>
> When you carry over somebody's patch like this you need to also add your
> own signed-off-by.

Ok, thanks
>
> Have those generic changes been reviewed by whoever is in charge of that
> cpuidle framework ?

These patches were posted by Len Brown himself who is ACPI, Intel Idle
cpuidle driver maintainer. He pulled in most of the patches that were
part of that series (https://lkml.org/lkml/2011/4/2/8)
in 3.0-rc1, but these few patches are still out there. These changes
(removal of pm_idle) have already been agreed upon as they were
initially reported by Peter Zijlstra himself
(http://lkml.org/lkml/2009/8/28/43).

Thanks
-Trinabh
>
> Cheers,
> Ben.
>
>>   Documentation/kernel-parameters.txt |    3 +++
>>   drivers/cpuidle/cpuidle.c           |   10 ++++++++++
>>   drivers/cpuidle/cpuidle.h           |    1 +
>>   drivers/cpuidle/driver.c            |    3 +++
>>   drivers/cpuidle/governor.c          |    3 +++
>>   5 files changed, 20 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index d9a203b..5697faf 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -546,6 +546,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>   			/proc/<pid>/coredump_filter.
>>   			See also Documentation/filesystems/proc.txt.
>>
>> +	cpuidle.off=1	[CPU_IDLE]
>> +			disable the cpuidle sub-system
>> +
>>   	cpcihp_generic=	[HW,PCI] Generic port I/O CompactPCI driver
>>   			Format:
>>   			<first_slot>,<last_slot>,<port>,<enum_bit>[,<debug>]
>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>> index 406be83..a171b9e 100644
>> --- a/drivers/cpuidle/cpuidle.c
>> +++ b/drivers/cpuidle/cpuidle.c
>> @@ -28,6 +28,12 @@ LIST_HEAD(cpuidle_detected_devices);
>>   static void (*pm_idle_old)(void);
>>
>>   static int enabled_devices;
>> +static int off __read_mostly;
>> +
>> +int cpuidle_disabled(void)
>> +{
>> +	return off;
>> +}
>>
>>   #if defined(CONFIG_ARCH_HAS_CPU_IDLE_WAIT)
>>   static void cpuidle_kick_cpus(void)
>> @@ -397,6 +403,9 @@ static int __init cpuidle_init(void)
>>   {
>>   	int ret;
>>
>> +	if (cpuidle_disabled())
>> +		return -ENODEV;
>> +
>>   	pm_idle_old = pm_idle;
>>
>>   	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
>> @@ -408,4 +417,5 @@ static int __init cpuidle_init(void)
>>   	return 0;
>>   }
>>
>> +module_param(off, int, 0444);
>>   core_initcall(cpuidle_init);
>> diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
>> index 33e50d5..38c3fd8 100644
>> --- a/drivers/cpuidle/cpuidle.h
>> +++ b/drivers/cpuidle/cpuidle.h
>> @@ -13,6 +13,7 @@ extern struct list_head cpuidle_governors;
>>   extern struct list_head cpuidle_detected_devices;
>>   extern struct mutex cpuidle_lock;
>>   extern spinlock_t cpuidle_driver_lock;
>> +extern int cpuidle_disabled(void);
>>
>>   /* idle loop */
>>   extern void cpuidle_install_idle_handler(void);
>> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
>> index 33e3189..284d7af 100644
>> --- a/drivers/cpuidle/driver.c
>> +++ b/drivers/cpuidle/driver.c
>> @@ -50,6 +50,9 @@ int cpuidle_register_driver(struct cpuidle_driver *drv)
>>   	if (!drv)
>>   		return -EINVAL;
>>
>> +	if (cpuidle_disabled())
>> +		return -ENODEV;
>> +
>>   	spin_lock(&cpuidle_driver_lock);
>>   	if (cpuidle_curr_driver) {
>>   		spin_unlock(&cpuidle_driver_lock);
>> diff --git a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
>> index 724c164..ea2f8e7 100644
>> --- a/drivers/cpuidle/governor.c
>> +++ b/drivers/cpuidle/governor.c
>> @@ -81,6 +81,9 @@ int cpuidle_register_governor(struct cpuidle_governor *gov)
>>   	if (!gov || !gov->select)
>>   		return -EINVAL;
>>
>> +	if (cpuidle_disabled())
>> +		return -ENODEV;
>> +
>>   	mutex_lock(&cpuidle_lock);
>>   	if (__cpuidle_find_governor(gov->name) == NULL) {
>>   		ret = 0;
>>
>> _______________________________________________
>> Linuxppc-dev mailing list
>> Linuxppc-dev@lists.ozlabs.org
>> https://lists.ozlabs.org/listinfo/linuxppc-dev
>
>
