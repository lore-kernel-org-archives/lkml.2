Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2BFONi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 09:13:38 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37948 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764Ab2BFONh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 09:13:37 -0500
MIME-Version: 1.0
In-Reply-To: <1328526691.2220.16.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20120202211709.GA1642@x4>
	<20120202213220.GB1642@x4>
	<CABPqkBTutb5TuNVXZ4o+MzXczVSwk3NtsJh73KZS58xmrd=tbg@mail.gmail.com>
	<20120204135110.GA6437@elte.hu>
	<CABPqkBTvoNBBdzvS-njoFk+SrTf-BKQSvP54C05un+m7RA+nBg@mail.gmail.com>
	<CABPqkBQdRwKKAvgK339Po0-WBW-MJkgcmpWqS=OOgepn3_XiRw@mail.gmail.com>
	<1328523130.2220.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CABPqkBQLn+5fYtOjhpKjXSzvKesuo+YRXxaawyTGUTQuZ6AjYw@mail.gmail.com>
	<1328526691.2220.16.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Date: Mon, 6 Feb 2012 15:13:34 +0100
Message-ID: <CABPqkBQnDToQczbgW4dCXiu3x2ZTXjAuKS_q_hJ=28Pu_2HexQ@mail.gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/cpu/perf_event.c:989
From: Stephane Eranian <eranian@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I found the problem!

it comes from perf_adjust_freq_unthr_context() vs perf_adjust_period().
The latter can under certain condition stop and restart the event. So we
had:

      stop()
      if (delta > 0) {
           perf_adjust_period() {
               if (period > 8*...) {
                   stop()
                   ...
                   start()
               }
           }
       }
       start()

Could have a double stop() and double start(), thus triggering the warning in
x86_pmu_start().

Will post a patch shortly to fix this.



On Mon, Feb 6, 2012 at 12:11 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le lundi 06 février 2012 à 11:40 +0100, Stephane Eranian a écrit :
>> On Mon, Feb 6, 2012 at 11:12 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> > Le lundi 06 février 2012 à 10:54 +0100, Stephane Eranian a écrit :
>> >> On Sat, Feb 4, 2012 at 7:09 PM, Stephane Eranian <eranian@google.com> wrote:
>> >> > I am working on it. It is hard to reproduce for me.
>> >> >
>> >> What did you run to trigger this warning? What system is this on?
>> >>
>> >> > On Sat, Feb 4, 2012 at 2:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >> >>
>> >> >> there's yet another one triggering at:
>> >> >>
>> >> >> [89214.962603] ------------[ cut here ]------------
>> >> >> [89214.967441] WARNING: at arch/x86/kernel/cpu/perf_event.c:995 x86_pmu_start+0x79/0xd4()
>> >> >> [89214.975825] Hardware name: X8DTN
>> >> >> [89214.979268] Modules linked in:
>> >> >> [89214.982560] Pid: 0, comm: swapper/6 Not tainted 3.3.0-rc2-tip+ #1
>> >> >> [89214.988865] Call Trace:
>> >> >> [89214.991533]  <IRQ>  [<ffffffff81065cc7>] warn_slowpath_common+0x7e/0x97
>> >> >> [89214.998379]  [<ffffffff81065cf5>] warn_slowpath_null+0x15/0x17
>> >> >> [89215.004428]  [<ffffffff8103f626>] x86_pmu_start+0x79/0xd4
>> >> >> [89215.010042]  [<ffffffff810e30d1>] perf_adjust_freq_unthr_context.part.63+0xef/0x123
>> >> >> [89215.018123]  [<ffffffff810e318c>] perf_event_task_tick+0x87/0x1c1
>> >> >> [89215.024463]  [<ffffffff810a2370>] ? tick_nohz_handler+0xda/0xda
>> >> >> [89215.030595]  [<ffffffff8108b819>] scheduler_tick+0xd1/0xf3
>> >> >> [89215.036296]  [<ffffffff810720b0>] update_process_times+0x5e/0x6f
>> >> >> [89215.042512]  [<ffffffff810a23e0>] tick_sched_timer+0x70/0x99
>> >> >> [89215.048387]  [<ffffffff810823f9>] __run_hrtimer+0x8c/0x148
>> >> >> [89215.054087]  [<ffffffff81082add>] hrtimer_interrupt+0xc1/0x18c
>> >> >>
>> >> >> Thanks,
>> >> >>
>> >> >>        Ingo
>> >
>> > Stephane, I trigger this as well very easily on my machine, 32bit
>> > kernel, using the following :
>> >
>> >
>> > perf record -a -g hackbench 10 thread 4000
>> >
>> I tried that on my Nehalem 64-bit running 3.3.0-rc2 where I reverted
>> that chunck of commit 84f2b9b:
>>
>> --- a/arch/x86/kernel/cpu/perf_event.c
>> +++ b/arch/x86/kernel/cpu/perf_event.c
>> @@ -986,9 +986,6 @@ static void x86_pmu_start(struct perf_event
>> *event, int flags)
>>         struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>>         int idx = event->hw.idx;
>>
>> -       if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
>> -               return;
>> -
>>         if (WARN_ON_ONCE(idx == -1))
>>                 return;
>>
>> I have an explanation for the other two WARN_ON_ONCE() but not for that
>> one. Friday, I was able to track this down to a situation where from unthr
>> we call pmu->stop() but because the event is already marked as not active
>> in cpuc->active_mask,  PERF_HES_STOPPED is not set, then
>> x86_pmu_start() complains. It happens during frequency adjustments and
>> not unthrottling.
>>
>> This is odd because the only place where cpuc->active_mask is cleared
>> (for the event) is x86_pmu_stop(). So looks like we get into a situation where
>> cpuc->active_mask[b] == 0 && event->state != HES_STOPPED. But I don't
>> know where this could happen.
>>
>>
>
> I forgot to say my other dev machine, Nehalem 64bit, doesnt trigger the
> WARN_ON_ONCE with exact same kernel version, unless I force threads on
> same socket...
>
> perf record -a -g taskset 5555 hackbench 10 thread 40000
>
> [95402.265521] ------------[ cut here ]------------
> [95402.265528] WARNING: at arch/x86/kernel/cpu/perf_event.c:989
> x86_pmu_start+0xdc/0x110()
> [95402.265530] Hardware name: ProLiant BL460c G6
> [95402.265531] Modules linked in: ipmi_devintf nfsd exportfs ipmi_si
> hpilo bnx2x crc32c libcrc32c mdio [last unloaded: scsi_wait_scan]
> [95402.265540] Pid: 0, comm: swapper/5 Not tainted 3.3.0-rc2+ #633
> [95402.265541] Call Trace:
> [95402.265543]  <IRQ>  [<ffffffff81037b9f>] warn_slowpath_common
> +0x7f/0xc0
> [95402.265549]  [<ffffffff81037bfa>] warn_slowpath_null+0x1a/0x20
> [95402.265551]  [<ffffffff810127fc>] x86_pmu_start+0xdc/0x110
> [95402.265559]  [<ffffffff810e78fa>]
> perf_adjust_freq_unthr_context.part.75+0xda/0x150
> [95402.265562]  [<ffffffff810e7b71>] perf_event_task_tick+0x201/0x2b0
> [95402.265566]  [<ffffffff8106bf49>] scheduler_tick+0xe9/0x160
> [95402.265571]  [<ffffffff8104964e>] update_process_times+0x6e/0x90
> [95402.265575]  [<ffffffff8108c084>] tick_sched_timer+0x64/0xc0
> [95402.265579]  [<ffffffff8105ffb4>] __run_hrtimer+0x84/0x1f0
> [95402.265581]  [<ffffffff8108c020>] ? tick_nohz_handler+0xf0/0xf0
> [95402.265584]  [<ffffffff810608e3>] hrtimer_interrupt+0xf3/0x220
> [95402.265588]  [<ffffffff8170c049>] smp_apic_timer_interrupt+0x69/0x99
> [95402.265593]  [<ffffffff8170af8b>] apic_timer_interrupt+0x6b/0x70
> [95402.265594]  <EOI>  [<ffffffff8100ab2e>] ? mwait_idle+0xae/0x280
> [95402.265601]  [<ffffffff810011df>] cpu_idle+0x8f/0xd0
> [95402.265605]  [<ffffffff816f3ccc>] start_secondary+0x1d6/0x1da
> [95402.265607] ---[ end trace 5e345a2582bb0ea3 ]---
>
>
