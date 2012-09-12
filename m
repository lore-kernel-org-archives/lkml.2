Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab2ILPtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:49:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40313 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab2ILPtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:49:43 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBQw=Y-V9+QsBxG_=sRwt=eO3wZ+p+KvC6PbA+S-AJpG-A@mail.gmail.com>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
	<1347459195-5491-3-git-send-email-eranian@google.com>
	<1347459764.15764.32.camel@twins>
	<CABPqkBREFbnJb4C3CqXc0RkKZDXZeCG8S75p3h=fUFNz1TWH-Q@mail.gmail.com>
	<CABPqkBQw=Y-V9+QsBxG_=sRwt=eO3wZ+p+KvC6PbA+S-AJpG-A@mail.gmail.com>
Date: Wed, 12 Sep 2012 17:49:41 +0200
Message-ID: <CABPqkBTAU2uHVUpsBqHE46aw8OhVRDPVr3vjdksUbhwTZdT37g@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] perf: use hrtimer for event multiplexing
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 5:37 PM, Stephane Eranian <eranian@google.com> wrote:
> On Wed, Sep 12, 2012 at 4:43 PM, Stephane Eranian <eranian@google.com> wrote:
>> On Wed, Sep 12, 2012 at 4:22 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> On Wed, 2012-09-12 at 16:13 +0200, Stephane Eranian wrote:
>>>> +static DEFINE_PER_CPU(struct list_head, rotation_list);
>>>
>>> Why do you keep the rotation list? The only use seems to be:
>>>
>>>
>>>> +void perf_cpu_hrtimer_cancel(int cpu)
>>>> +{
>>>> +       struct list_head *head = &__get_cpu_var(rotation_list);
>>>> +       struct perf_cpu_context *cpuctx, *tmp;
>>>> +       unsigned long flags;
>>>> +
>>>> +       if (WARN_ON(cpu != smp_processor_id()))
>>>> +               return;
>>>> +
>>>> +       local_irq_save(flags);
>>>> +
>>>> +       list_for_each_entry_safe(cpuctx, tmp, head, rotation_list) {
>>>> +               if (cpuctx->hrtimer_active) {
>>>> +                       hrtimer_cancel(&cpuctx->hrtimer);
>>>> +                       cpuctx->hrtimer_active = 0;
>>>> +               }
>>>> +       }
>>>> +
>>>> +       local_irq_restore(flags);
>>>> +}
>>>
>>> Which is weird, why not use the existing for-each-pmu loop in
>>> perf_event_exit_cpu_context() ? Or something similar to iterate all
>>> extant PMUs and thus their cpuctxs?
>>>
>> True. That would probably work too.
>>
> Note however that the rotation_list is still used in perf_event_task_tick()
> to iterate over the ctx which needs unthrottling. We would have to switch
> that loop over to a for-each-pmu() which would necessary incur more
> iterations as it would include all the SW PMUs.

That reminds me that dropping sw context from rotation_list causes an
issue in perf_event_task_tick() because that means the sw PMU are
not considered anymore for interrupt unthrottling but they should. So
I think switching to for-each-pmu() in perf_event_task_tick() will solve
that problem too.
