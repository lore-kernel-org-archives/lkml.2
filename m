Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab2ARSwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 13:52:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59988 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758114Ab2ARSwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 13:52:31 -0500
MIME-Version: 1.0
In-Reply-To: <4F165EB4.9090309@gmail.com>
References: <1326852454-26117-1-git-send-email-venki@google.com>
	<4F165EB4.9090309@gmail.com>
Date: Wed, 18 Jan 2012 10:52:30 -0800
Message-ID: <CABeCy1Y+02K3wiKra+w6UWy9ZVJh3-EajsFB6BwKgZwW3ma9BQ@mail.gmail.com>
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
From: Venki Pallipadi <venki@google.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 9:55 PM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> (1/17/12 9:07 PM), Venkatesh Pallipadi wrote:
>> Kernel's notion of possible cpus (from include/linux/cpumask.h)
>>   *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable
>>
>>   *  The cpu_possible_mask is fixed at boot time, as the set of CPU id's
>>   *  that it is possible might ever be plugged in at anytime during the
>>   *  life of that system boot.
>>
>>   #define num_possible_cpus()     cpumask_weight(cpu_possible_mask)
>>
>> and on x86 cpumask_weight() calls hweight64 and hweight64 (on older kernels
>> and systems with !X86_FEATURE_POPCNT) or a popcnt based alternative.
>>
>> i.e, We needlessly go through this mask based calculation everytime
>> num_possible_cpus() is called.
>>
>> The problem is there with cpu_online_mask() as well, which is fixed value at
>> boot time in !CONFIG_HOTPLUG_CPU case and should not change that often even
>> in HOTPLUG case.
>>
>> Though most of the callers of these two routines are init time (with few
>> exceptions of runtime calls), it is cleaner to use variables
>> and not go through this repeated mask based calculation.
>>
>> Signed-off-by: Venkatesh Pallipadi<venki@google.com>
>> ---
>>   include/linux/cpumask.h |    8 ++++++--
>>   kernel/cpu.c            |    9 +++++++++
>>   2 files changed, 15 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
>> index 4f7a632..2eb04dd 100644
>> --- a/include/linux/cpumask.h
>> +++ b/include/linux/cpumask.h
>> @@ -80,9 +80,13 @@ extern const struct cpumask *const cpu_online_mask;
>>   extern const struct cpumask *const cpu_present_mask;
>>   extern const struct cpumask *const cpu_active_mask;
>>
>> +extern int nr_online_cpus;
>> +
>>   #if NR_CPUS>  1
>> -#define num_online_cpus()    cpumask_weight(cpu_online_mask)
>> -#define num_possible_cpus()  cpumask_weight(cpu_possible_mask)
>> +
>> +#define num_online_cpus()    (nr_online_cpus)
>> +#define num_possible_cpus()  (nr_cpu_ids)
>
> nr_cpu_ids mean maximum cpu id of cpus. if cpu id are sparse, maximum id
> doesn't match number of cpus.
>

Yes. But will it be sparse in any arch? I saw some of the users of
num_possible_cpus() doing things like allocating a buffer for that
size and then indexing it using get_cpu(). So, I thought it would be
better to use the existing nr_cpu_ids instead of inventing another
variable. If indeed any arch is depending on this being sparse, we can
have a new variable similar to num_possible_cpus and also audit all
users of num_possible_cpus to see whether they should be using
nr_cpu_ids instead.

>
>
>> +
>>   #define num_present_cpus()  cpumask_weight(cpu_present_mask)
>>   #define num_active_cpus()   cpumask_weight(cpu_active_mask)
>>   #define cpu_online(cpu)             cpumask_test_cpu((cpu), cpu_online_mask)
>> diff --git a/kernel/cpu.c b/kernel/cpu.c
>> index 2060c6e..eed2169 100644
>> --- a/kernel/cpu.c
>> +++ b/kernel/cpu.c
>> @@ -622,6 +622,13 @@ static DECLARE_BITMAP(cpu_active_bits, CONFIG_NR_CPUS) __read_mostly;
>>   const struct cpumask *const cpu_active_mask = to_cpumask(cpu_active_bits);
>>   EXPORT_SYMBOL(cpu_active_mask);
>>
>> +#ifdef CONFIG_HOTPLUG_CPU
>> +int nr_online_cpus;
>> +#else
>> +int nr_online_cpus __read_mostly;
>> +#endif
>> +EXPORT_SYMBOL(nr_online_cpus);
>
> You can always mark this to __read_mostly. other cpu hotplug stuff do so.
> Because of, I guess, cpu hotplug developers don't think hotplugging is
> frequently event.
>

OK. Agree.

>
>>   void set_cpu_possible(unsigned int cpu, bool possible)
>>   {
>>       if (possible)
>> @@ -644,6 +651,8 @@ void set_cpu_online(unsigned int cpu, bool online)
>>               cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
>>       else
>>               cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
>> +
>> +     nr_online_cpus = cpumask_weight(cpu_online_mask);
>>   }
>
> I like this change. :)
>
>

Thanks,
Venki
