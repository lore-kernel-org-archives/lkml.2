Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab2BGVjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 16:39:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61316 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab2BGVjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 16:39:47 -0500
MIME-Version: 1.0
In-Reply-To: <1328581451.29790.14.camel@sbsiddha-desk.sc.intel.com>
References: <1328560933-3037-1-git-send-email-venki@google.com>
	<1328581451.29790.14.camel@sbsiddha-desk.sc.intel.com>
Date: Tue, 7 Feb 2012 13:39:46 -0800
Message-ID: <CABeCy1YX7ps3sKAv_A0AtQfNc3WSdxrAPqLfdvSXTiea5JgPZA@mail.gmail.com>
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
From: Venki Pallipadi <venki@google.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Aaron Durbin <adurbin@google.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 6:24 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> On Mon, 2012-02-06 at 12:42 -0800, Venkatesh Pallipadi wrote:
>> * Lower overhead on Async IPI send path. Measurements on Westmere based
>>   systems show savings on "no wait" smp_call_function_single with idle
>>   target CPU (as measured on the sender side).
>>   local socket smp_call_func cost goes from ~1600 to ~1200 cycles
>>   remote socket smp_call_func cost goes from ~2000 to ~1800 cycles
>
> Interesting that savings in the remote socket is less compared to the
> local socket.

Yes. I was not sure whether it has something to do with mwait/IPI
wakeups work in hardware or it has something to do with C-state the
target CPU is woken out of.

>
>> +int smp_need_ipi(int cpu)
>> +{
>> +     int oldval;
>> +
>> +     if (!system_using_cpu_idle_sync || cpu == smp_processor_id())
>> +             return 1;
>> +
>> +     oldval = atomic_cmpxchg(&per_cpu(cpu_idle_sync, cpu),
>> +                             CPU_STATE_IDLE, CPU_STATE_WAKING);
>
> To avoid too many cache line bounces for the case when the cpu is in the
> running state, we should do a read to check if the state is in idle
> before going ahead with the locked operation?
>

Agree. Will add it on patch refresh.

>> +
>> +     if (oldval == CPU_STATE_RUNNING)
>> +             return 1;
>> +
>> +     if (oldval == CPU_STATE_IDLE) {
>> +             set_tsk_ipi_pending(idle_task(cpu));
>> +             atomic_set(&per_cpu(cpu_idle_sync, cpu), CPU_STATE_WOKENUP);
>> +     }
>> +
>> +     return 0;
>
> We should probably disable interrupts around this, otherwise any delay
> in transitioning to wokenup from waking will cause the idle cpu to be
> stuck for similar amount of time.
>

Makes sense. Will add that too.

Thanks,
Venki

> thanks,
> suresh
>
