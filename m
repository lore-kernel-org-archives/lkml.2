Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab2EQKXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:23:20 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:50466 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab2EQKXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:23:14 -0400
Message-ID: <4FB4D14A.20903@linux.vnet.ibm.com>
Date: Thu, 17 May 2012 15:52:02 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH powerpc] fix a lockdep complaint in start_secondary
References: <1337227263.24471.23.camel@ThinkPad-T420> <1337228910.30558.46.camel@pasglop>
In-Reply-To: <1337228910.30558.46.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12051710-2674-0000-0000-00000480DF25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 09:58 AM, Benjamin Herrenschmidt wrote:

> On Thu, 2012-05-17 at 12:01 +0800, Li Zhong wrote:
>> This patch tries to fix following lockdep complaints:
> 
>  .../...
> 
>> pseries_notify_cpu_idle_add_cpu() actually does
>> cpuidle_disable_device(), and then cpuidle_enable_device(), which
>> releases and allocates the resources respectively. ( Also, all the data
>> are cleared and reinitialized after this cycle). The problem here is:
>> something like kzalloc(GFP_KERNEL), wait_for_completion() would have
>> problems running here where irqs are still disabled. 


This is true when the system is booting up.

> 
> So yes, it looks definitely fishy. I don't have time to study cpuidle
> today to check whether that's correct or not so I'm CCing Deepthi
> Dharwar who did all that cpuidle work for pseries.
> 
> Deepthi, can you check whether that patch is correct ?


pseries_notify_cpu_idle_add_cpu() is essential to be called for
hotplug event. So by removing this call completely wouldn't
support cpus registering under cpuidle on hotplug and default idle is
executed on those with do not give much powersavings. Ideal way it to
have a notifier in pseries backend driver for hotplug notification and
then remove this function from here.
I am currently working on this patch, will post it out soon.

> 
>> Actually, cpuidle_enable_device() is called for each possible cpu when
>> the driver is registered. So I don't think the resources needed to be
>> released and allocated each time cpu becomes online. Something like
>> cpuidle_reset_device() would be enough to clear and reinitialize the
>> data.
>>
>> However, after some studying of the data to be cleared, I think it's
>> also reasonable to keep the previous data. For example: 
>>
>> /sys/devices/system/cpu/cpu#/cpuidle/state#/usage 
>>         the number of times this idle state has been entered
>> /sys/devices/system/cpu/cpu#/cpuidle/state#/time
>>         the amount of time spent in this idle state
>>
>> So I think we could just remove the function call doing the
>> disable/enable cycle:
>>
>> Please correct me if I missed anything.


If removed, this would not handle cpu hotplug events for cpuidle.

 
>>
>> Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
>> Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> ---
>>  arch/powerpc/platforms/pseries/smp.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/powerpc/platforms/pseries/smp.c
>> b/arch/powerpc/platforms/pseries/smp.c
>> index e16bb8d..71706bc 100644
>> --- a/arch/powerpc/platforms/pseries/smp.c
>> +++ b/arch/powerpc/platforms/pseries/smp.c
>> @@ -147,7 +147,6 @@ static void __devinit smp_xics_setup_cpu(int cpu)
>>  	set_cpu_current_state(cpu, CPU_STATE_ONLINE);
>>  	set_default_offline_state(cpu);
>>  #endif
>> -	pseries_notify_cpuidle_add_cpu(cpu);
>>  }
>>  
>>  static int __devinit smp_pSeries_kick_cpu(int nr)
> 
> 
> 

Cheers,
Deepthi

