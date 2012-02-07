Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab2BGJRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 04:17:16 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40359 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab2BGJRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 04:17:13 -0500
MIME-Version: 1.0
In-Reply-To: <1328603689.2476.15.camel@edumazet-laptop>
References: <20120206205354.GA31186@quad>
	<1328603689.2476.15.camel@edumazet-laptop>
Date: Tue, 7 Feb 2012 10:17:12 +0100
Message-ID: <CABPqkBQUw_mcJM0T2KNQnOxJBvLBK-kcsq87Zc_k0YVfcUug0A@mail.gmail.com>
Subject: Re: [PATCH] perf: fix assertion failure in x86_pmu_start()
From: Stephane Eranian <eranian@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        markus@trippelsdorf.de, paulus@samba.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 9:34 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le lundi 06 février 2012 à 21:53 +0100, Stephane Eranian a écrit :
>> The following patch fixes an issue introduced by the following
>> commit:
>>         e050e3f0a71b ("perf: Fix broken interrupt rate throttling")
>>
>> The patch caused the following warning to pop up depending on
>> the sampling frequency adjustments:
>>
>> [89214.962603] ------------[ cut here ]------------
>> [89214.967441] WARNING: at arch/x86/kernel/cpu/perf_event.c:995 x86_pmu_start+0x79/0xd4()
>> [89214.975825] Hardware name: X8DTN
>> [89214.979268] Modules linked in:
>> [89214.982560] Pid: 0, comm: swapper/6 Not tainted 3.3.0-rc2-tip+ #1
>> [89214.988865] Call Trace:
>> [89214.991533]  <IRQ>  [<ffffffff81065cc7>] warn_slowpath_common+0x7e/0x97
>> [89214.998379]  [<ffffffff81065cf5>] warn_slowpath_null+0x15/0x17
>> [89215.004428]  [<ffffffff8103f626>] x86_pmu_start+0x79/0xd4
>> [89215.010042]  [<ffffffff810e30d1>] perf_adjust_freq_unthr_context.part.63+0xef/0x123
>> [89215.018123]  [<ffffffff810e318c>] perf_event_task_tick+0x87/0x1c1
>> [89215.024463]  [<ffffffff810a2370>] ? tick_nohz_handler+0xda/0xda
>> [89215.030595]  [<ffffffff8108b819>] scheduler_tick+0xd1/0xf3
>> [89215.036296]  [<ffffffff810720b0>] update_process_times+0x5e/0x6f
>> [89215.042512]  [<ffffffff810a23e0>] tick_sched_timer+0x70/0x99
>> [89215.048387]  [<ffffffff810823f9>] __run_hrtimer+0x8c/0x148
>> [89215.054087]  [<ffffffff81082add>] hrtimer_interrupt+0xc1/0x18c
>>
>> It was caused by the following call sequence:
>>
>> perf_adjust_freq_unthr_context.part() {
>>      stop()
>>      if (delta > 0) {
>>           perf_adjust_period() {
>>               if (period > 8*...) {
>>                   stop()
>>                   ...
>>                   start()
>>               }
>>           }
>>       }
>>       start()
>> }
>>
>> Which caused a double start and a double stop, thus triggering the assert
>> in x86_pmu_start().
>>
>> The patch fixes the problem by avoiding the double calls. We pass a new
>> argument to perf_adjust_period() to indicate whether or not the event
>> is already stopped. We can't just remove the start/stop from that function
>> because it's called from __perf_event_overflow where the event needs to
>> be reloaded via a stop/start back-toback call.
>>
>> The patch reintroduces the assertion in x86_pmu_start() which was removed
>> by commit:
>>       84f2b9b perf: Remove deprecated WARN_ON_ONCE()
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>
> This indeed fix the WARNING for me
>
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
>
> But I still have these messages when doing a perf session.
>
> Machine seems to recover properly.
>
> Previous kernels were working without notice.
>
Doing what on what machine?

> [  300.553017] Uhhuh. NMI received for unknown reason 31 on CPU 2.
> [  300.553071] Do you have a strange power saving mode enabled?
> [  300.553115] Dazed and confused, but trying to continue
> [  300.775014] Uhhuh. NMI received for unknown reason 31 on CPU 1.
> [  300.775064] Do you have a strange power saving mode enabled?
> [  300.775107] Dazed and confused, but trying to continue
> [  303.250012] Uhhuh. NMI received for unknown reason 31 on CPU 0.
> [  303.250067] Do you have a strange power saving mode enabled?
> [  303.250110] Dazed and confused, but trying to continue
> [  303.278012] Uhhuh. NMI received for unknown reason 31 on CPU 7.
> [  303.278063] Do you have a strange power saving mode enabled?
> [  303.278106] Dazed and confused, but trying to continue
> [  305.839016] Uhhuh. NMI received for unknown reason 21 on CPU 5.
> [  305.839068] Do you have a strange power saving mode enabled?
> [  305.839112] Dazed and confused, but trying to continue
> [  305.907013] Uhhuh. NMI received for unknown reason 31 on CPU 4.
> [  305.907066] Do you have a strange power saving mode enabled?
> [  305.907109] Dazed and confused, but trying to continue
> [  306.953017] Uhhuh. NMI received for unknown reason 31 on CPU 1.
> [  306.953069] Do you have a strange power saving mode enabled?
> [  306.953111] Dazed and confused, but trying to continue
> [  308.585014] Uhhuh. NMI received for unknown reason 31 on CPU 6.
> [  308.585064] Do you have a strange power saving mode enabled?
> [  308.585108] Dazed and confused, but trying to continue
> [  309.239012] Uhhuh. NMI received for unknown reason 31 on CPU 0.
> [  309.239079] Do you have a strange power saving mode enabled?
> [  309.239137] Dazed and confused, but trying to continue
> [  309.426009] Uhhuh. NMI received for unknown reason 21 on CPU 7.
> [  309.426075] Do you have a strange power saving mode enabled?
> [  309.426132] Dazed and confused, but trying to continue
> [  309.592010] Uhhuh. NMI received for unknown reason 21 on CPU 2.
> [  309.592076] Do you have a strange power saving mode enabled?
> [  309.592133] Dazed and confused, but trying to continue
>
>
