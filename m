Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab1FUGAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 02:00:51 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:36563 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1FUGAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 02:00:50 -0400
Message-ID: <4E003369.3000006@linux.vnet.ibm.com>
Date: Tue, 21 Jun 2011 11:30:09 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-pm@lists.linux-foundation.org, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V1 4/7] cpuidle: (powerpc) Add cpu_idle_wait() to
 allow switching idle routines
References: <20110607162847.6848.44707.stgit@tringupt.in.ibm.com> <20110607162959.6848.26918.stgit@tringupt.in.ibm.com> <1308285128.32158.8.camel@pasglop>
In-Reply-To: <1308285128.32158.8.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/17/2011 10:02 AM, Benjamin Herrenschmidt wrote:
> On Tue, 2011-06-07 at 22:00 +0530, Trinabh Gupta wrote:
>
>> diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
>> index 39a2baa..932392b 100644
>> --- a/arch/powerpc/kernel/idle.c
>> +++ b/arch/powerpc/kernel/idle.c
>> @@ -102,6 +102,24 @@ void cpu_idle(void)
>>   	}
>>   }
>>
>> +static void do_nothing(void *unused)
>> +{
>> +}
>> +
>> +/*
>> + * cpu_idle_wait - Used to ensure that all the CPUs come out of the old
>> + * idle loop and start using the new idle loop.
>> + * Required while changing idle handler on SMP systems.
>> + * Caller must have changed idle handler to the new value before the call.
>> + */
>> +void cpu_idle_wait(void)
>> +{
>> +	smp_mb();
>> +	/* kick all the CPUs so that they exit out of old idle routine */
>> +	smp_call_function(do_nothing, NULL, 1);
>> +}
>> +EXPORT_SYMBOL_GPL(cpu_idle_wait);
>> +
>>   int powersave_nap;
>>
>>   #ifdef CONFIG_SYSCTL
>
> This is gross :-)

Well this is what exists today for x86; so didn't think too
much into this. Maybe there is cleaner way. The requirement
is to completely exit the idle loop and call cpuidle_idle_call()
again. I think sending reschedule may be enough.

With respect to current implementation the arch-independent cpuidle
code needs a cpu_idle_wait() function for any architecture where
CONFIG_SMP is defined. This cpu_idle_wait function is called
whenever we have to pause usage of cpuidle; to switch driver
or governor etc. So maybe there is a cleaner implementation of
cpu_idle_wait instead of smp_call_function(do_nothing...); sending
reschedule may work.

Thanks
-Trinabh

>
> Do you need to absolutely ensure the idle task has changed or just
> kicking it with a send reschedule is enough ?


>
> Cheers,
> Ben.
>
>
