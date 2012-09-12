Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383Ab2ILOnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:43:41 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44738 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157Ab2ILOnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:43:39 -0400
MIME-Version: 1.0
In-Reply-To: <1347459764.15764.32.camel@twins>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
	<1347459195-5491-3-git-send-email-eranian@google.com>
	<1347459764.15764.32.camel@twins>
Date: Wed, 12 Sep 2012 16:43:38 +0200
Message-ID: <CABPqkBREFbnJb4C3CqXc0RkKZDXZeCG8S75p3h=fUFNz1TWH-Q@mail.gmail.com>
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

On Wed, Sep 12, 2012 at 4:22 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-09-12 at 16:13 +0200, Stephane Eranian wrote:
>> +static DEFINE_PER_CPU(struct list_head, rotation_list);
>
> Why do you keep the rotation list? The only use seems to be:
>
>
>> +void perf_cpu_hrtimer_cancel(int cpu)
>> +{
>> +       struct list_head *head = &__get_cpu_var(rotation_list);
>> +       struct perf_cpu_context *cpuctx, *tmp;
>> +       unsigned long flags;
>> +
>> +       if (WARN_ON(cpu != smp_processor_id()))
>> +               return;
>> +
>> +       local_irq_save(flags);
>> +
>> +       list_for_each_entry_safe(cpuctx, tmp, head, rotation_list) {
>> +               if (cpuctx->hrtimer_active) {
>> +                       hrtimer_cancel(&cpuctx->hrtimer);
>> +                       cpuctx->hrtimer_active = 0;
>> +               }
>> +       }
>> +
>> +       local_irq_restore(flags);
>> +}
>
> Which is weird, why not use the existing for-each-pmu loop in
> perf_event_exit_cpu_context() ? Or something similar to iterate all
> extant PMUs and thus their cpuctxs?
>
True. That would probably work too.

> Also, you can do away with hrtimer_active, you can hrtimer_cancel() on
> an inactive hrtimer just fine, it will DTRT.

The hrtimer_active is used to prevent activating the timer multiple times
in a row.
