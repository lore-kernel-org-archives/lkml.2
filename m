Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab2ILOd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:33:28 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36679 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638Ab2ILOd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:33:26 -0400
MIME-Version: 1.0
In-Reply-To: <1347459984.15764.34.camel@twins>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
	<1347459195-5491-2-git-send-email-eranian@google.com>
	<1347459984.15764.34.camel@twins>
Date: Wed, 12 Sep 2012 16:33:25 +0200
Message-ID: <CABPqkBSnhjgAhn5+gOuBWWPrxKojKW1hKPJEn7zvvYhiw-LPLg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] hrtimer: add hrtimer_init_cpu()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 4:26 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> I'm rather sure Thomas would want to know about this..
>
>
> On Wed, 2012-09-12 at 16:13 +0200, Stephane Eranian wrote:
>> hrtimer_init() assumes it is called for the current CPU
>> as it accesses per-cpu variables (hrtimer_bases).
>>
>> However, there can be cases where a hrtimer is initialized
>> from a different CPU, so add an entry point to make this
>> more explicit.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>>  include/linux/hrtimer.h |    3 +++
>>  kernel/hrtimer.c        |   17 ++++++++++++-----
>>  2 files changed, 15 insertions(+), 5 deletions(-)
>>
>
>> +static void __hrtimer_init(int cpu, struct hrtimer *timer, clockid_t clock_id,
>>                          enum hrtimer_mode mode)
>>  {
>>       struct hrtimer_cpu_base *cpu_base;
>> @@ -1154,7 +1154,7 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
>>
>>       memset(timer, 0, sizeof(struct hrtimer));
>>
>> -     cpu_base = &__raw_get_cpu_var(hrtimer_bases);
>> +     cpu_base = &per_cpu(hrtimer_bases, cpu);
>>
>>       if (clock_id == CLOCK_REALTIME && mode != HRTIMER_MODE_ABS)
>>               clock_id = CLOCK_MONOTONIC;
>
>
> I don't see the point, one of the first things
> __hrtimer_start_range_ns() does is switch_hrtimer_base() to swizzle it
> to the calling CPUs base.
>
> And since all the perf event rotation muck is strictly per cpu that all
> should work out just fine, no?


If I do:
  for_each_possible_cpu(cpu) {
       cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
       hr = &cpuctx->hrtimer;
       hrtimer_init(hr)
}
I don't understand why I would have to refer to per-cpu data
(hrtimer_bases) from
a CPU that is not equal to "cpu" here. Unless you're telling me it's
read-only data.
But still if it's per-cpu why not initialize with the correct CPU from
the start?
