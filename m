Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab0KYVcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 16:32:25 -0500
Received: from smtp-out.google.com ([216.239.44.51]:7966 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab0KYVcY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 16:32:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ayR//mhaXvy/AqtbDdP0RQ9jbB3+97rIQ0ljFAejGJ/f3VqxxDHqlO+svbfJQAevY5
         UuSJuuYKbk9mp3NQ+zzQ==
MIME-Version: 1.0
In-Reply-To: <1290697344.2145.56.camel@laptop>
References: <4ce510d4.0fedd80a.742c.10b9@mx.google.com>
	<1290684033.2145.25.camel@laptop>
	<AANLkTi=J8eRKjb8BBsDjaxnsvvuSLbZw2CN4k3YFGM+Y@mail.gmail.com>
	<1290697344.2145.56.camel@laptop>
Date: Thu, 25 Nov 2010 22:32:18 +0100
Message-ID: <AANLkTi==RfJijfLcHn08KBbh8V-3_uPWK9QQoU9sKyz1@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v5)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 4:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-11-25 at 15:51 +0100, Stephane Eranian wrote:
>>
>>
>> On Thu, Nov 25, 2010 at 12:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>         On Thu, 2010-11-18 at 12:40 +0200, Stephane Eranian wrote:
>>         > @@ -919,6 +945,10 @@ static inline void perf_event_task_sched_in(struct task_struct *task)
>>         >  static inline
>>         >  void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
>>         >  {
>>         > +#ifdef CONFIG_CGROUPS
>>         > +       atomic_t *cgroup_events = &__get_cpu_var(perf_cgroup_events);
>>         > +       COND_STMT(cgroup_events, perf_cgroup_switch(task, next));
>>         > +#endif
>>         >         COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
>>         >  }
>>
>>
>>         I don't think that'll actually work, the jump label stuff needs a static
>>         address.
>>
>> I did not know that.
>
> Yeah, its unfortunate the fallback code doesn't mandate this :/
>
>
>>         Why not simply: s/perf_task_events/perf_sched_events/ and
>>         increment it
>>         for cgroup events as well?
>>
>> But you would need to demultiplex. that's not because perf_sched_events is
>> set that you want BOTH perf_cgroup_switch() AND perf_event_task_sched_out().
>
> The main purpose of the jump-label stuff is to optimize the function
> call and conditional into the perf code away, the moment we a function
> call we might as well do everything, at that point its only a single
> conditional.
>
> Jump labels are supposed to work like (they don't actually work like
> this yet):
>
> my_func:
>    asm-foo
> addr_of_nop:
>    nop5
> after_nop:
>    more-asm-foo
>    iret
>
> out_of_line:
>    do-special-foo
>    jmp after_nop
>
>
> We then keep a section of tuples:
>
> __jump_labels:
>
>  &perf_task_events,addr_of_nop
>
> Then when we flip perf_task_events from 0 -> !0 we rewrite the nop5 at
> addr_of_nop to "jmp out_of_line" (5 bytes on x86, hence nop5), or the
> reverse on !0 -> 0.
>
>
> So 1) we need the 'key' (&perf_task_events) to be a static address
> because the compiler needs to place the address in the special section
> -- otherwise we can never find the nop location again, this also means
> per-cpu variables don't make sense, there's only 1 copy of the text.
>
> and 2) the moment we take the out-of-line branch we incur the icache hit
> and already set up a call, so optimizing away another conditional at the
> cost of an extra function call doesn't really make sense.
>
>
Ok, I understand. Thanks for the explanation.

So perf_sched_events would indicate that there may be some perf
ctxsw work to do. It would set as soon as there is at least one
event defined and not just a per-thread event.

BTW, I suspect, isn't  there a bug with
PERF_COUNT_SW_CONTEXT_SWITCHES not being updated
if you don't have at least one per-thread event. You need to
hoist that perf_sw_event() into the header file before the COND().

Then, __perf_event_task_sched_out() would be modified
to do some more checks.

__perf_event_task_sched_out(task, next)
{
        int ctxn;

        perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);

        for_each_task_context_nr(ctxn)
                perf_event_context_sched_out(task, ctxn, next);
}


void __perf_event_task_sched_out(struct task_struct *task,
                                 struct task_struct *next)
{
        int ctxn;
        int cgroup_events;

        perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);

        croup_events = &__get_cpu_var(perf_cgroup_events);
        if (cgroup_events)
                perf_cgroup_switch(task, next);

        if (perf_task_events)
             for_each_task_context_nr(ctxn)
                    perf_event_context_sched_out(task, ctxn, next);
}

That implies you need to maintain:
   - perf_sched_events: number of active events system-wide
   - perf_task_events: number of per-thread events system-wide
   - cgroup_events: per-cpu variable representing the number of cgroup
events on a CPU

Is that what you are thinking?
