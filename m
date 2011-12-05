Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab1LEXSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:18:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41675 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932508Ab1LEXSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:18:20 -0500
Message-ID: <4EDD50F5.30300@fb.com>
Date: Mon, 5 Dec 2011 15:17:09 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, <mingo@elte.hu>,
        William Cohen <wcohen@redhat.com>, Vince Weaver <vince@deater.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
References: <20111121145114.049265181@chello.nl> <4ED9267F.10106@fb.com> <CABPqkBRpYA-StOTDFwyFhFtBPynbn-FLUzqZvaQn3oM3SJpCWg@mail.gmail.com> <4EDD26B9.8070007@fb.com>
In-Reply-To: <4EDD26B9.8070007@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-05_04:2011-12-05,2011-12-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/5/11 12:16 PM, Arun Sharma wrote:
> On 12/2/11 2:22 PM, Stephane Eranian wrote:
>> Have you tried with inheritance disabled?
>> I don't remember if perf stat has it enabled buy default.
>
> Disabling inheritance using the -i switch as in:
>
> (for i in `seq 1 10`; do numactl --cpunodebind 1 perf stat -i -e
> instructions ./lat_ctx -P1 -s32k 4; done)
>
> shows numbers closer to baseline, since the threads used for
> benchmarking are not counting events.

I spent some more time looking into this. Running:

perf stat -e instructions  ./lat_ctx -P1 -s32k 4 -N 1000000 &
perf record -ag -- sleep 3

didn't show high cycles counts on any perf_events related functions in 
the context switch path. The only PMU related stuff that showed up had 
to do with x86_pmu_enable called from an IPI.

So just as an experiment I disabled perf_rotate_context() via:

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4252,8 +4252,6 @@ void scheduler_tick(void)
         curr->sched_class->task_tick(rq, curr, 0);
         raw_spin_unlock(&rq->lock);

-       perf_event_task_tick();
-

That seems to bring the lat_ctx numbers very close to baseline.

I suspect that some optimizations are possible in perf_rotate_context 
that don't involve enabling/disabling the PMU via an IPI for simple 
cases that involve one or two hardware events (eg: fixed counters).

  -Arun

Sample stack trace:

lat_ctx 29874 [012] 350729.824173: cycles:
         ffffffff8101149c intel_pmu_enable_all ([kernel.kallsyms])
         ffffffff810115f7 intel_pmu_nhm_enable_all ([kernel.kallsyms])
         ffffffff8100e877 x86_pmu_enable ([kernel.kallsyms])
         ffffffff810a99de perf_pmu_enable ([kernel.kallsyms])
         ffffffff8100d682 x86_pmu_commit_txn ([kernel.kallsyms])
         ffffffff810aa4f9 group_sched_in ([kernel.kallsyms])
         ffffffff810ab06d __perf_event_enable ([kernel.kallsyms])
         ffffffff810a8c93 remote_function ([kernel.kallsyms])
         ffffffff81065eec generic_smp_call_function_single_interrupt 
([kernel.kallsyms])
         ffffffff81018064 smp_call_function_single_interrupt 
([kernel.kallsyms])
         ffffffff81461fcb call_function_single_interrupt ([kernel.kallsyms])
                   401ec4 bread (/root/lat_ctx)

