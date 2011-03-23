Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1CWJ5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:57:41 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:49831 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab1CWJ5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:57:40 -0400
Message-ID: <4D89C40B.4020809@linux.vnet.ibm.com>
Date: Wed, 23 Mar 2011 15:27:31 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 4/5] cpuidle: driver for xen
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com> <20110322123324.28725.3131.stgit@tringupt.in.ibm.com> <20110322145054.GB26952@dumpdata.com>
In-Reply-To: <20110322145054.GB26952@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/22/2011 08:20 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Mar 22, 2011 at 06:03:28PM +0530, Trinabh Gupta wrote:
>> This patch implements a default cpuidle driver for xen.
>> Earlier pm_idle was flipped to default_idle. Maybe there
>> is a better way to ensure default_idle is called
>> without using this cpuidle driver.
>

Hi Konrad,

> Please also CC the Xen devel mailing list (I did this for you)

Yes, I will. Thanks

>
> I couldn't find it in the description, but I was wondering
> what is that you are trying to fix? What is the problem description?

We are trying to remove the exported function pointer pm_idle which
is set to the desired idle routine to be used. For example, xen
sets it to default_idle. Having exported function pointer is
not very secure.

The first problem is that this exported pointer can be modified/flipped
by any subsystem. There is no tracking or notification mechanism.
Secondly and more importantly, various subsystems save the value of
this pointer, flip it and later restore to the saved value. There is
no guarantee that the saved value is still valid (see
http://lkml.org/lkml/2009/8/28/43 and http://lkml.org/lkml/2009/8/28/50)

The first patch of the series removed pm_idle and now we directly
call into CPUIdle subsystem. As a result for all the subsystems
using pm_idle, we have to implement a driver that can be registered
to cpuidle.

>
> Two, you mention in your description that it was tested on x86 systems. did
> you test this with Xen? If so, what version.

The patches are still in RFC stage and haven't been tested with Xen.
Once we are clear on a particular solution, we will carefully
test the patches.

Thanks for the code review. Yes, I have missed a couple of things.
I will look at how to maintain per cpu dev pointers and free the
memory.

Thanks,
-Trinabh

>
>>
>> Signed-off-by: Trinabh Gupta<trinabh@linux.vnet.ibm.com>
>> ---
>>
>>   arch/x86/xen/setup.c |   42 +++++++++++++++++++++++++++++++++++++++++-
>>   1 files changed, 41 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
>> index a8a66a5..4fce4cd 100644
>> --- a/arch/x86/xen/setup.c
>> +++ b/arch/x86/xen/setup.c
>> @@ -9,6 +9,8 @@
>>   #include<linux/mm.h>
>>   #include<linux/pm.h>
>>   #include<linux/memblock.h>
>> +#include<linux/cpuidle.h>
>> +#include<linux/slab.h>
>>
>>   #include<asm/elf.h>
>>   #include<asm/vdso.h>
>> @@ -321,6 +323,44 @@ void __cpuinit xen_enable_syscall(void)
>>   #endif /* CONFIG_X86_64 */
>>   }
>>
>> +static struct cpuidle_driver xen_idle_driver = {
>> +	.name = "xen_idle",
>> +	.owner = THIS_MODULE,
>> +	.priority = 1,
>> +};
>> +
>> +extern struct cpuidle_state state_default_state;
>> +
>> +static int setup_cpuidle(int cpu)
>> +{
>> +	struct cpuidle_device *dev = kzalloc(sizeof(struct cpuidle_device),
>> +					GFP_KERNEL);
>
> No checking to see if dev == NULL?
>> +	int count = CPUIDLE_DRIVER_STATE_START;
>> +	dev->cpu = cpu;
>> +	dev->drv =&xen_idle_driver;
>> +
>> +	dev->states[count] = state_default_idle;
>> +	count++;
>> +
>> +	dev->state_count = count;
>> +
>> +	if (cpuidle_register_device(dev))
>> +		return -EIO;
> No cleanup of the 'dev' so that we don't leak memory?
>
>> +	return 0;
>> +}
>> +
>> +static int xen_idle_init(void)
>> +{
>> +	int retval, i;
>> +	retval = cpuidle_register_driver(&xen_idle_driver);
>> +
>> +	for_each_online_cpu(i) {
>> +		setup_cpuidle(i);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   void __init xen_arch_setup(void)
>>   {
>>   	xen_panic_handler_init();
>> @@ -354,7 +394,7 @@ void __init xen_arch_setup(void)
>>   #ifdef CONFIG_X86_32
>>   	boot_cpu_data.hlt_works_ok = 1;
>>   #endif
>> -	pm_idle = default_idle;
>> +	xen_idle_init();
>>   	boot_option_idle_override = IDLE_HALT;
>>
>>   	fiddle_vdso();
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
