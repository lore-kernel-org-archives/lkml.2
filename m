Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab0JAR3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 13:29:11 -0400
Received: from smtp-out.google.com ([74.125.121.35]:1988 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0JAR3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 13:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VryzMyZ1bGbO9SxChWfjaLShUnZmkVj9CGwfwwqcLoDWzbFWwXHoNKdh+5yU5/bxGP
         5s7cpsdrlyCsiAmfM15A==
MIME-Version: 1.0
In-Reply-To: <AANLkTinmgCmozNMQyesaTxrAfzgJ7bKEAeyNRWh7ceZ5@mail.gmail.com>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	<1285788096-29471-4-git-send-email-venki@google.com>
	<1285844768.2144.11.camel@laptop>
	<AANLkTi=r5DX52+735OtGHmJCS38n1P_WxEkKzLVf1E_m@mail.gmail.com>
	<AANLkTikHfyjjZfDcoO-yDW+JTnpDb42VxRMckk55Xp+O@mail.gmail.com>
	<1285933569.2144.57.camel@laptop>
	<AANLkTinmgCmozNMQyesaTxrAfzgJ7bKEAeyNRWh7ceZ5@mail.gmail.com>
Date: Fri, 1 Oct 2010 10:29:06 -0700
Message-ID: <AANLkTi=b2NaXOS05tT69hdmddxPPc5OxxnZ0qG0ZZZYe@mail.gmail.com>
Subject: Re: [PATCH 3/7] Add IRQ_TIME_ACCOUNTING, finer accounting of irq time -v3
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 9:51 AM, Venkatesh Pallipadi <venki@google.com> wrote:
> On Fri, Oct 1, 2010 at 4:46 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Thu, 2010-09-30 at 13:38 -0700, Venkatesh Pallipadi wrote:
>>> On Thu, Sep 30, 2010 at 9:29 AM, Venkatesh Pallipadi <venki@google.com> wrote:
>>> > On Thu, Sep 30, 2010 at 4:06 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> >> On Wed, 2010-09-29 at 12:21 -0700, Venkatesh Pallipadi wrote:
>>> >>> +void account_system_vtime(struct task_struct *curr)
>>> >>> +{
>>> >>> +       unsigned long flags;
>>> >>> +       int cpu;
>>> >>> +       u64 now, delta;
>>> >>> +
>>> >>> +       if (!sched_clock_irqtime)
>>> >>> +               return;
>>> >>> +
>>> >>> +       local_irq_save(flags);
>>> >>> +
>>> >>> +       now = sched_clock();
>>> >>> +       cpu = smp_processor_id();
>>> >>
>>> >> Like said before, that really wants to read like:
>>> >>
>>> >>        cpu = smp_processor_id();
>>> >>        now = sched_clock_cpu(cpu);
>>> >>
>>> >> sched_clock() is raw tsc + ns conversion and can go all over the place.
>>> >
>>> > sched_clock_cpu() won't really work for here, due to what looks like
>>> > idle and timer tick dependencies. Using sched_clock_cpu(), I end up
>>> > accounting CPU idle time to hardirq due to time captured before the
>>> > handler and after the handler.
>>> >
>>>
>>> Specifically, here is the now and delta log from my test setup with
>>> using sched_clock_cpu() above (data below from a particular CPU)
>>>
>>>           <idle>-0     [001]  1697.910060: account_system_vtime:
>>> SOFTIRQ STOP 1700897011613, delta 3555
>>>           <idle>-0     [001]  1697.911047: account_system_vtime: IRQ
>>> START 1700897999028
>>
>> Dude, linewrap hell! And what are you trying to illustrate?
>>
> Sorry. Retrying with shorted lines
>
> This is the log of start, hardirq stop, softirq stop and deltas at
> stop, taken in account_system_vtime on CPU 1 with sched_clock_cpu.
>
> ~5000 delta for a hardirq seems reasonable. But, as you see there are
> frequent ms deltas on hardirq, specifically when in idle.
>
> <idle>-0     []  1697.911047: START 1700897999028
> <idle>-0     []  1697.911051: HARD STOP 1700898005071, delta 6043
> <idle>-0     []  1697.911052: START 1700898006003
> <idle>-0     []  1697.911057: SOFT STOP 1700898010685, delta 4682
> <idle>-0     []  1697.911931: START 1700898884039
> <idle>-0     []  1697.911935: HARD STOP 1700898890304, delta 6265
> <idle>-0     []  1697.915040: START 1700899887146
> <idle>-0     []  1697.915047: HARD STOP 1700902008678, delta 2121532
> <idle>-0     []  1697.915048: START 1700902009617
> <idle>-0     []  1697.915055: SOFT STOP 1700902015924, delta 6307
> <idle>-0     []  1697.918958: START 1700903006980
> <idle>-0     []  1697.918963: HARD STOP 1700905931367, delta 2924387
> <idle>-0     []  1697.919553: START 1700906521486
> <idle>-0     []  1697.919557: HARD STOP 1700906527006, delta 5520
> <idle>-0     []  1697.933420: START 1700907524219
> <idle>-0     []  1697.933428: HARD STOP 1700920424020, delta 12899801
> <idle>-0     []  1697.936512: START 1700921418037
> <idle>-0     []  1697.936523: HARD STOP 1700923524497, delta 2106460
>
>
> This is probably because this test system is of the crazy TSC ones.
> But, it does have TSC as its closcksource and there is no trace of
> mark_tsc_unstable in dmesg.
>

Digging a bit deeper into sched_clock stuff, I see sched_clock_stable
is only set in
arch/x86/kernel/cpu/intel.c when
    if (c->x86_power & (1 << 8)) {

So, on x86, sched_clock_stable is not set on all other kind of CPUs
and my test system happens to be one of them. So, sched_clock_cpu()
falls back to tick based even when TSC is not marked unstable and
clocksource is using TSC for timing.
First, is this limited use of sched_clock_stable by design? Shouldn't
it be rather based on tsc_unstable value in tsc.c?
If this is by design, I will have to limit the irq accounting to this
limited set of CPUs as well. As, for irq accounting, I cannot use tick
based sched_clock_cpu() as it will have jumps while handling interrupt
when the clock gets readjusted.

Thanks,
Venki
