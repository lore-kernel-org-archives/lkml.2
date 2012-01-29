Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2A2ME2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 07:04:28 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57928 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2A2ME0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 07:04:26 -0500
MIME-Version: 1.0
X-Originating-IP: [79.181.26.205]
In-Reply-To: <20120127155725.86654035.akpm@linux-foundation.org>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
	<1327572121-13673-5-git-send-email-gilad@benyossef.com>
	<20120127155725.86654035.akpm@linux-foundation.org>
Date: Sun, 29 Jan 2012 14:04:25 +0200
Message-ID: <CAOtvUMfceR8zZf5resfcNQFWZyrKG5BdB00gqq3GZRpgFRD=yw@mail.gmail.com>
Subject: Re: [v7 4/8] smp: add func to IPI cpus based on parameter func
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 1:57 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 26 Jan 2012 12:01:57 +0200
> Gilad Ben-Yossef <gilad@benyossef.com> wrote:
...
>>
>> @@ -153,6 +162,16 @@ static inline int up_smp_call_function(smp_call_func_t func, void *info)
>>                       local_irq_enable();             \
>>               }                                       \
>>       } while (0)
>> +#define on_each_cpu_cond(cond_func, func, info, wait, gfpflags) \
>> +     do {                                            \
>> +             preempt_disable();                      \
>> +             if (cond_func(0, info)) {               \
>> +                     local_irq_disable();            \
>> +                     (func)(info);                   \
>> +                     local_irq_enable();             \
>
> Ordinarily, local_irq_enable() in such a low-level thing is dangerous,
> because it can cause horrid bugs when called from local_irq_disable()d
> code.
>
> However I think we're OK here because it is a bug to call on_each_cpu()
> and friends with local irqs disabled, yes?

Yes, that is my understanding and this way the function gets called in
the same conditions in UP and SMP.

> Do we have any warnings printks if someone calls the ipi-sending
> functions with local interrupts disabled?  I didn't see any, but didn't
> look very hard.

There is this check in smp_call_function_many():

        WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
                     && !oops_in_progress && !early_boot_irqs_disabled);

Only catches SMP offenders though.


> If my above claims are correct then why does on_each_cpu() use
> local_irq_save()?  hrm.

The comment in on_each_cpu() in kernel.smp.c says: "May be
used during early boot while early_boot_irqs_disabled is set.  Use
local_irq_save/restore() instead of local_irq_disable/enable()."


>
>> +             }                                       \
>> +             preempt_enable();                       \
>> +     } while (0)
>>
>>  static inline void smp_send_reschedule(int cpu) { }
>>  #define num_booting_cpus()                   1
>> diff --git a/kernel/smp.c b/kernel/smp.c
>> index a081e6c..fa0912a 100644
>> --- a/kernel/smp.c
>> +++ b/kernel/smp.c
>> @@ -730,3 +730,61 @@ void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
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
>> + * @gfpflags:        GFP flags to use when allocating the cpumask
>> + *           used internally by the function.
>> + *
>> + * The function might sleep if the GFP flags indicates a non
>> + * atomic allocation is allowed.
>> + *
>> + * You must not call this function with disabled interrupts or
>> + * from a hardware interrupt handler or from a bottom half handler.
>> + */
>> +void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
>> +                     smp_call_func_t func, void *info, bool wait,
>> +                     gfp_t gfpflags)
>
> bah.
>
> z:/usr/src/linux-3.3-rc1> grep -r gfpflags . | wc -l
> 78
> z:/usr/src/linux-3.3-rc1> grep -r gfp_flags . | wc -l
> 548
>

I have no specific preference. Should I switch?

>> +{
>> +     cpumask_var_t cpus;
>> +     int cpu, ret;
>> +
>> +     might_sleep_if(gfpflags & __GFP_WAIT);
>
> For the zalloc_cpumask_var(), it seems.  I expect there are
> might_sleep() elsewhere in the memory allocation paths, but putting one
> here will detect bugs even if CONFIG_CPUMASK_OFFSTACK=n.

Well, yes, although I didn't think about that :-)

>
>> +     if (likely(zalloc_cpumask_var(&cpus, (gfpflags|__GFP_NOWARN)))) {
>> +             preempt_disable();
>> +             for_each_online_cpu(cpu)
>> +                     if (cond_func(cpu, info))
>> +                             cpumask_set_cpu(cpu, cpus);
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
> I assume the preempt_disable()s here are to suspend CPU hotplug?

Yes.  Also, I figured that since the original code disabled
preemption for the entire on_each_cpu run time, including waiting for all
the CPUs to ack the IPI, and since we (hopefully) wait for less CPUs, the
overall runtime with  preemption disabled will be (usually) lower then the
original  code most of the time and we'll get a more robust interface.

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
