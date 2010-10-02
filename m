Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab0JBP1G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 11:27:06 -0400
Received: from smtp-out.google.com ([74.125.121.35]:16196 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab0JBP1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 11:27:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UXq/n9ZBXhPd68l0r+9EQEpmW/2Z1FbOiWWImEP5FyTNyRSHOUi3sI0zMOXaCA8pxi
         d9q9vNIypj205BZsQbZA==
MIME-Version: 1.0
In-Reply-To: <1286016835.2144.86.camel@laptop>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	<1285788096-29471-4-git-send-email-venki@google.com>
	<1285844768.2144.11.camel@laptop>
	<AANLkTi=r5DX52+735OtGHmJCS38n1P_WxEkKzLVf1E_m@mail.gmail.com>
	<AANLkTikHfyjjZfDcoO-yDW+JTnpDb42VxRMckk55Xp+O@mail.gmail.com>
	<1285933569.2144.57.camel@laptop>
	<AANLkTinmgCmozNMQyesaTxrAfzgJ7bKEAeyNRWh7ceZ5@mail.gmail.com>
	<AANLkTi=b2NaXOS05tT69hdmddxPPc5OxxnZ0qG0ZZZYe@mail.gmail.com>
	<1285974873.2144.65.camel@laptop>
	<AANLkTikcPX6m01F1rg--AKkSj_69kJJVsTrqB_FF6sJf@mail.gmail.com>
	<1286016835.2144.86.camel@laptop>
Date: Sat, 2 Oct 2010 08:26:59 -0700
Message-ID: <AANLkTim4w6i0ASSbs_3PJvTQXxpDUcdRZz7c4A7_A6qv@mail.gmail.com>
Subject: Re: [PATCH 3/7] Add IRQ_TIME_ACCOUNTING, finer accounting of irq time -v3
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 2, 2010 at 3:53 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-10-01 at 16:32 -0700, Venkatesh Pallipadi wrote:
>> On Fri, Oct 1, 2010 at 4:14 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Fri, 2010-10-01 at 10:29 -0700, Venkatesh Pallipadi wrote:
>> >> So, on x86, sched_clock_stable is not set on all other kind of CPUs
>> >> and my test system happens to be one of them. So, sched_clock_cpu()
>> >> falls back to tick based even when TSC is not marked unstable and
>> >> clocksource is using TSC for timing.
>> >
>> > It is never tick based!! It's tick augmented! Because TSC is such a
>> > piece of crap we use external (slow) means of determining a window in
>> > which the TSC should live and then use the TSC to generate high
>> > resolution offsets inside that.
>> >
>> > So even if your usage is in the hardirq context that moves that window
>> > it should all work out.
>> >
>>
>> You mean there should not be any "jumps" noticed with
>> sched_clock_cpu() when we are idle and get a interrupt?
>> Atleast thats what I am seeing. May be there is some other bug
>> somewhere causing that.
>>
>> Loooking at one snapshot from my earlier log
>>
>> <idle>-0     []  1697.915040: : START 1700899887146
>> // We were idle and got an interrupt and recorded sched_clock_cpu() as
>> 1700899887146
>> <idle>-0     []  1697.915047: : HARD STOP 1700902008678, delta 2121532
>> // We finished handling the interrupt and recorded sched_clock_cpu()
>> as 1700902008678
>> // So, delta we see is > 2ms
>> // This is trace_printk based on local clock, which is using sched_clock()
>> // So, the trace timing shows delta of 7 us, which is kind of expected time here
>
> Egads, yes that would be a kernel/sched_clock.c buglet..
>
> So we're in NOHZ and an IRQ/NMI happens that ends up calling
> sched_clock_cpu() and friends without us leaving NOHZ.
>
> drivers/acpi/processor_idle.c:acpi_idle_enter_simple() calls
> sched_clock_idle_{sleep,wakeup}_event() around the idle loop -- are
> there idle methods missing this, and or do we handle the interrupt
> before the wakeup event?
>

Yes. My test machine is using basic mwait_idle from x86 process.c and
that code path does not have these sleep wakeup events. Also, these
basic idle (both halt and mwait) go into idle after enabling
interrupts and so on the way out handle interrupt before doing
anything else.

> Also, in irq_enter() we call __irq_enter() which does
> account_system_vtime() before tick_check_idle() which restarts various
> timers and resets jiffies and in fact already calls
> sched_clock_idle_wakeup_event().
>

Ah. The reason for this jump is account_system_vtime being called
before wakeup_event.

> Gah what a mess.. we could try a code shuffle to restart timer/clock
> bits before calling into account_system_vtime(), although I bet that'll
> be interesting. But I see no way to fix the NMI during NOHZ problem, its
> not like we can actually do GTOD from NMI context :/
>
> The thing is, I really do _NOT_ trust TSC to be sane enough to use like
> you want to do, its really proven itself to be reliably crap.
>

I agree with reliably crap part :). Though TSC usage in this case is
somewhat limited as we always compare timings only from same CPU.
May be above code shuffle + somehow skipping the time accounting in
account_system_vtime is a good way to proceed? I will look at this
change next. Is it OK to use sched_clock() here until that time? I
really want to get some wider testing feedback on this before spending
more time.

Thanks,
Venki
