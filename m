Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab1LFBiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:38:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63222 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab1LFBiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:38:04 -0500
MIME-Version: 1.0
In-Reply-To: <4EDD50F5.30300@fb.com>
References: <20111121145114.049265181@chello.nl>
	<4ED9267F.10106@fb.com>
	<CABPqkBRpYA-StOTDFwyFhFtBPynbn-FLUzqZvaQn3oM3SJpCWg@mail.gmail.com>
	<4EDD26B9.8070007@fb.com>
	<4EDD50F5.30300@fb.com>
Date: Mon, 5 Dec 2011 17:38:01 -0800
Message-ID: <CABPqkBQLq6dm1CabOKTycJVZ3aiVHfD-0J7sTGN1VDah1C40Gg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
From: Stephane Eranian <eranian@google.com>
To: Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
        William Cohen <wcohen@redhat.com>, Vince Weaver <vince@deater.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe the multiplexing rate is just unnecessary high too. I think
Peter added some code to
make it tunable but the user interface is not there yet AFAICT. There
is quite some work needed
to stop, reschedule and restart the counters.

On Mon, Dec 5, 2011 at 3:17 PM, Arun Sharma <asharma@fb.com> wrote:
> On 12/5/11 12:16 PM, Arun Sharma wrote:
>>
>> On 12/2/11 2:22 PM, Stephane Eranian wrote:
>>>
>>> Have you tried with inheritance disabled?
>>> I don't remember if perf stat has it enabled buy default.
>>
>>
>> Disabling inheritance using the -i switch as in:
>>
>> (for i in `seq 1 10`; do numactl --cpunodebind 1 perf stat -i -e
>> instructions ./lat_ctx -P1 -s32k 4; done)
>>
>> shows numbers closer to baseline, since the threads used for
>> benchmarking are not counting events.
>
>
> I spent some more time looking into this. Running:
>
> perf stat -e instructions  ./lat_ctx -P1 -s32k 4 -N 1000000 &
> perf record -ag -- sleep 3
>
> didn't show high cycles counts on any perf_events related functions in the
> context switch path. The only PMU related stuff that showed up had to do
> with x86_pmu_enable called from an IPI.
>
> So just as an experiment I disabled perf_rotate_context() via:
>
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4252,8 +4252,6 @@ void scheduler_tick(void)
>        curr->sched_class->task_tick(rq, curr, 0);
>        raw_spin_unlock(&rq->lock);
>
> -       perf_event_task_tick();
> -
>
> That seems to bring the lat_ctx numbers very close to baseline.
>
> I suspect that some optimizations are possible in perf_rotate_context that
> don't involve enabling/disabling the PMU via an IPI for simple cases that
> involve one or two hardware events (eg: fixed counters).
>
>  -Arun
>
> Sample stack trace:
>
> lat_ctx 29874 [012] 350729.824173: cycles:
>        ffffffff8101149c intel_pmu_enable_all ([kernel.kallsyms])
>        ffffffff810115f7 intel_pmu_nhm_enable_all ([kernel.kallsyms])
>        ffffffff8100e877 x86_pmu_enable ([kernel.kallsyms])
>        ffffffff810a99de perf_pmu_enable ([kernel.kallsyms])
>        ffffffff8100d682 x86_pmu_commit_txn ([kernel.kallsyms])
>        ffffffff810aa4f9 group_sched_in ([kernel.kallsyms])
>        ffffffff810ab06d __perf_event_enable ([kernel.kallsyms])
>        ffffffff810a8c93 remote_function ([kernel.kallsyms])
>        ffffffff81065eec generic_smp_call_function_single_interrupt
> ([kernel.kallsyms])
>        ffffffff81018064 smp_call_function_single_interrupt
> ([kernel.kallsyms])
>        ffffffff81461fcb call_function_single_interrupt ([kernel.kallsyms])
>                  401ec4 bread (/root/lat_ctx)
>
