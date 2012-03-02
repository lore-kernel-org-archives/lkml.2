Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab2CBBfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 20:35:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35426 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2CBBfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 20:35:37 -0500
MIME-Version: 1.0
In-Reply-To: <1330651732.30167.63.camel@sbsiddha-desk.sc.intel.com>
References: <1329957415-15239-1-git-send-email-venki@google.com>
	<20120223075027.GB15306@elte.hu>
	<CABeCy1YeGjTAGKRwwaryY9bx9UwMq9nhGAsVV-o2QEjPH=4ErA@mail.gmail.com>
	<1330651732.30167.63.camel@sbsiddha-desk.sc.intel.com>
Date: Thu, 1 Mar 2012 17:35:37 -0800
Message-ID: <CABeCy1btewB-oTgyL06qvebLLXTqareYNy-wdNZ3oiHR3KPwEw@mail.gmail.com>
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES interrupts
 to an idle CPU -v1
From: Venki Pallipadi <venki@google.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Aaron Durbin <adurbin@google.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 5:28 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> On Thu, 2012-03-01 at 16:33 -0800, Venki Pallipadi wrote:
>> >
>> > fork_idle() should also make sure it does not schedule the child
>> > thread: thus we'd also be able to further simplify smpboot.c and
>> > get rid of all that extremely ugly 'struct create_idle'
>> > gymnastics in smpboot.c.
>>
>> But not this. I am not sure where fork_idle results in resched of the child.
>> As I saw it, fork_idle calls init_idle and that sets the affinity of
>> idle_task to target CPU. So, reschedule should not be a problem. What
>> am I missing here?
>
> I think Ingo is referring to the fact that we can't use kthread_create()
> here and hence we were relying on fork_idle().
>
>> Also, I tried this silly test patch (Cut and paste... Sorry) and it
>> seemed to work fine both with and without CPU hotplug.
>>
>
> I don't think we can do this today, as we need to make sure we have the
> correct current context. With dynamic cpu hotplug, current context can
> be any process and hence we were depending on the schedule_work()
> context.
>

schedule_work() is only done at boot time. In case of dynamic cpu
hotplug, we skip the whole fork_idle as we already have the task
struct and just do init_idle().

> thanks,
> suresh
>
>> Thanks,
>> Venki
>>
>> ---
>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>> index 66d250c..36b80ef 100644
>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -686,7 +686,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
>>                 .done   = COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
>>         };
>>
>> -       INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
>> +       // INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
>>
>>         alternatives_smp_switch(1);
>>
>> @@ -703,12 +703,13 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
>>                 goto do_rest;
>>         }
>>
>> -       schedule_work(&c_idle.work);
>> -       wait_for_completion(&c_idle.done);
>> +       // schedule_work(&c_idle.work);
>> +       // wait_for_completion(&c_idle.done);
>> +       c_idle.idle = fork_idle(cpu);
>>
>>         if (IS_ERR(c_idle.idle)) {
>>                 printk("failed fork for CPU %d\n", cpu);
>> -               destroy_work_on_stack(&c_idle.work);
>> +               // destroy_work_on_stack(&c_idle.work);
>>                 return PTR_ERR(c_idle.idle);
>>         }
>>
>> @@ -831,7 +832,7 @@ do_rest:
>>                 smpboot_restore_warm_reset_vector();
>>         }
>>
>> -       destroy_work_on_stack(&c_idle.work);
>> +       // destroy_work_on_stack(&c_idle.work);
>>         return boot_error;
>>  }
>>
>> ---
>>
>> >
>> > Thanks,
>> >
>> >        Ingo
>
>
