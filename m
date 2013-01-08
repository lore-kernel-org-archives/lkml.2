Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3AHB6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:58:15 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:34287 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3AHB6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:58:14 -0500
MIME-Version: 1.0
In-Reply-To: <1357374665.716.32.camel@ThinkPad-T5421.cn.ibm.com>
References: <CANFwon03L14jDhLAE66F936WytwtN=+43QetETOG5ndUGptnow@mail.gmail.com>
 <1357374665.716.32.camel@ThinkPad-T5421.cn.ibm.com>
From: Hui Zhu <teawater@gmail.com>
Date: Tue, 8 Jan 2013 09:57:32 +0800
Message-ID: <CANFwon2P8zumYjCpEZVJJbZsaKRc7C+f0hqOusC7OvcDNeApXw@mail.gmail.com>
Subject: Re: [PATCH] Remove WARN_ON_ONCE in __smp_call_function_single and smp_call_function_single
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Zhu Yanhai <gaoyang.zyh@taobao.com>,
        yan@linux.vnet.ibm.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 5, 2013 at 4:31 PM, Li Zhong <zhong@linux.vnet.ibm.com> wrote:
> On Sat, 2013-01-05 at 12:26 +0800, Hui Zhu wrote:
>> The comments of these WARN_ON_ONCE said "Can deadlock when called with
>> interrupts disabled".
>> But I didn't find anything that will block this function.
>
> It seems that if two cpus try to IPI each other with wait equals true,
> they will deadlock if interrupts are disabled, because neither of them
> can take the interrupt.
>
> If wait equals false, it seems deadlock is still possible, for example,
> if smp_call_function_single() is called from interrupt context, then one
> cpu might
>         -->call smp_call_function_single()
>         -->csd_lock()
>         -->be interrupted before sending the ipi out
>         -->in interrupt context, call smp_call_function_single() again
>         -->csd_lock_wait() forever in csd_lock()

Thanks for your mail.  It make me more clear about these functions.

Best,
Hui

>
> I'm not sure whether it is possible that irqs be enabled in interrupt
> context? If so, maybe we also need check that if wait equals false?
>
> Thanks, Zhong
>
>> So I think maybe this WARN_ON_ONCE is not need now.  So I post a patch for that.
>>
>> Signed-off-by: Hui Zhu <teawater@gmail.com>
>> Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>
>>
>> --- a/kernel/smp.c
>> +++ b/kernel/smp.c
>> @@ -303,25 +303,13 @@ int smp_call_function_single(int cpu, sm
>>               .flags = 0,
>>       };
>>       unsigned long flags;
>> -     int this_cpu;
>>       int err = 0;
>>
>>       /*
>>        * prevent preemption and reschedule on another processor,
>>        * as well as CPU removal
>>        */
>> -     this_cpu = get_cpu();
>> -
>> -     /*
>> -      * Can deadlock when called with interrupts disabled.
>> -      * We allow cpu's that are not yet online though, as no one else can
>> -      * send smp call function interrupt to this cpu and as such deadlocks
>> -      * can't happen.
>> -      */
>> -     WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
>> -                  && !oops_in_progress);
>> -
>> -     if (cpu == this_cpu) {
>> +     if (cpu == get_cpu()) {
>>               local_irq_save(flags);
>>               func(info);
>>               local_irq_restore(flags);
>> @@ -409,17 +397,7 @@ void __smp_call_function_single(int cpu,
>>       unsigned int this_cpu;
>>       unsigned long flags;
>>
>> -     this_cpu = get_cpu();
>> -     /*
>> -      * Can deadlock when called with interrupts disabled.
>> -      * We allow cpu's that are not yet online though, as no one else can
>> -      * send smp call function interrupt to this cpu and as such deadlocks
>> -      * can't happen.
>> -      */
>> -     WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait && irqs_disabled()
>> -                  && !oops_in_progress);
>> -
>> -     if (cpu == this_cpu) {
>> +     if (cpu == get_cpu()) {
>>               local_irq_save(flags);
>>               data->func(data->info);
>>               local_irq_restore(flags);
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>
