Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab2BEPqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 10:46:44 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43315 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab2BEPqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 10:46:43 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <4F2EA206.3000707@linux.vnet.ibm.com>
References: <1328448800-15794-1-git-send-email-gilad@benyossef.com>
	<1328449722-15959-3-git-send-email-gilad@benyossef.com>
	<4F2EA206.3000707@linux.vnet.ibm.com>
Date: Sun, 5 Feb 2012 17:46:41 +0200
Message-ID: <CAOtvUMdqpwOedhZHq6QpUnDyg1FzfK_K3=9HQujjoN9yU3XWnA@mail.gmail.com>
Subject: Re: [PATCH v8 4/8] smp: add func to IPI cpus based on parameter func
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 5:36 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 02/05/2012 07:18 PM, Gilad Ben-Yossef wrote:
>
>> Add the on_each_cpu_cond() function that wraps on_each_cpu_mask()
>> and calculates the cpumask of cpus to IPI by calling a function supplied
>> as a parameter in order to determine whether to IPI each specific cpu.
>>
>> The function works around allocation failure of cpumask variable in
>> CONFIG_CPUMASK_OFFSTACK=y by itereating over cpus sending an IPI a
>> time via smp_call_function_single().
>>
>> The function is useful since it allows to seperate the specific
>> code that decided in each case whether to IPI a specific cpu for
>> a specific request from the common boilerplate code of handling
>> creating the mask, handling failures etc.
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ...
>> diff --git a/include/linux/smp.h b/include/linux/smp.h
>> index d0adb78..da4d034 100644
>> --- a/include/linux/smp.h
>> +++ b/include/linux/smp.h
>> @@ -109,6 +109,15 @@ void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
>>               void *info, bool wait);
>>
>>  /*
>> + * Call a function on each processor for which the supplied function
>> + * cond_func returns a positive value. This may include the local
>> + * processor.
>> + */
>> +void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
>> +             smp_call_func_t func, void *info, bool wait,
>> +             gfp_t gfp_flags);
>> +
>> +/*
>>   * Mark the boot cpu "online" so that it can call console drivers in
>>   * printk() and can access its per-cpu storage.
>>   */
>> @@ -153,6 +162,21 @@ static inline int up_smp_call_function(smp_call_func_t func, void *info)
>>                       local_irq_enable();             \
>>               }                                       \
>>       } while (0)
>> +/*
>> + * Preemption is disabled here to make sure the
>> + * cond_func is called under the same condtions in UP
>> + * and SMP.
>> + */
>> +#define on_each_cpu_cond(cond_func, func, info, wait, gfp_flags) \
>> +     do {                                            \
>> +             preempt_disable();                      \
>> +             if (cond_func(0, info)) {               \
>> +                     local_irq_disable();            \
>> +                     (func)(info);                   \
>> +                     local_irq_enable();             \
>> +             }                                       \
>> +             preempt_enable();                       \
>> +     } while (0)
>>
>>  static inline void smp_send_reschedule(int cpu) { }
>>  #define num_booting_cpus()                   1
>> diff --git a/kernel/smp.c b/kernel/smp.c
>> index a081e6c..28cbcc5 100644
>> --- a/kernel/smp.c
>> +++ b/kernel/smp.c
>> @@ -730,3 +730,63 @@ void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
>>       put_cpu();
>>  }
>>  EXPORT_SYMBOL(on_each_cpu_mask);
>> +
>> +/*
>> + * on_each_cpu_cond(): Call a function on each processor for which
>> + * the supplied function cond_func returns true, optionally waiting
>> + * for all the required CPUs to finish. This may include the local
>> + * processor.
>> + * @cond_func:       A callback function that is passed a cpu id and
>> + *           the the info parameter. The function is called
>> + *           with preemption disabled. The function should
>> + *           return a blooean value indicating whether to IPI
>> + *           the specified CPU.
>> + * @func:    The function to run on all applicable CPUs.
>> + *           This must be fast and non-blocking.
>> + * @info:    An arbitrary pointer to pass to both functions.
>> + * @wait:    If true, wait (atomically) until function has
>> + *           completed on other CPUs.
>> + * @gfp_flags:       GFP flags to use when allocating the cpumask
>> + *           used internally by the function.
>> + *
>> + * The function might sleep if the GFP flags indicates a non
>> + * atomic allocation is allowed.
>> + *
>> + * Preemption is disabled to protect against a hotplug event.
>
>
> Well, disabling preemption protects us only against CPU offline right?
> (because we use the stop_machine thing during cpu offline).
>
> What about CPU online?
>
> Just to cross-check my understanding of the code with the existing
> documentation on CPU hotplug, I looked up Documentation/cpu-hotplug.txt
> and this is what I found:
>
> "If you merely need to avoid cpus going away, you could also use
> preempt_disable() and preempt_enable() for those sections....
> ...The preempt_disable() will work as long as stop_machine_run() is used
> to take a cpu down."
>
> So even this only talks about using preempt_disable() to prevent CPU offline,
> not CPU online. Or, am I missing something?

You are not missing anything, this is simply a bad choice of words on my part.
Thank you for pointing this out.

I should write:

" Preemption is disabled to protect against CPU going offline but not online.
  CPUs going online during the call will not be seen or sent an IPI."

Protecting against CPU going online during the function is useless
since they might
as well go online right after the call is finished, so the caller has
to take care of it, if they
cares.

Thanks,
Gilad

>
>> + *
>> + * You must not call this function with disabled interrupts or
>> + * from a hardware interrupt handler or from a bottom half handler.
>> + */
>> +void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
>> +                     smp_call_func_t func, void *info, bool wait,
>> +                     gfp_t gfp_flags)
>> +{
>> +     cpumask_var_t cpus;
>> +     int cpu, ret;
>> +
>> +     might_sleep_if(gfp_flags & __GFP_WAIT);
>> +
>> +     if (likely(zalloc_cpumask_var(&cpus, (gfp_flags|__GFP_NOWARN)))) {
>> +             preempt_disable();
>> +             for_each_online_cpu(cpu)
>> +                     if (cond_func(cpu, info))
>> +                             cpumask_set_cpu(cpu, cpus);
>
>
> IOW, what prevents a new CPU from becoming online at this point?
>
>> +             on_each_cpu_mask(cpus, func, info, wait);
>> +             preempt_enable();
>> +             free_cpumask_var(cpus);
>> +     } else {
>> +             /*
>> +              * No free cpumask, bother. No matter, we'll
>> +              * just have to IPI them one by one.
>> +              */
>> +             preempt_disable();
>> +             for_each_online_cpu(cpu)
>> +                     if (cond_func(cpu, info)) {
>> +                             ret = smp_call_function_single(cpu, func,
>> +                                                             info, wait);
>> +                             WARN_ON_ONCE(!ret);
>> +                     }
>> +             preempt_enable();
>> +     }
>> +}
>> +EXPORT_SYMBOL(on_each_cpu_cond);
>
>
>
> Regards,
> Srivatsa S. Bhat
>



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
