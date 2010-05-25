Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab0EYPCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:02:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2706 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab0EYPCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:02:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=UglcuJM5J3UaCYy5wcbW90LR/WWYx0L+QYe+falA7j2vT7f3Mb42pcfI28OZFcaaa
	IM8MDQgmFVmDCh7anm91g==
MIME-Version: 1.0
In-Reply-To: <AANLkTinTfqLdRbgqRfn4Avl6bedB6xyLbRybwencYRiF@mail.gmail.com>
References: <4bfbceef.e495e30a.5dae.61b6@mx.google.com>
	<1274794518.5882.1280.camel@twins>
	<AANLkTilEnIrY2HDdxDMdDIfkz8j1ueTbOf0CmD1y14ra@mail.gmail.com>
	<1274796225.5882.1389.camel@twins>
	<AANLkTinTfqLdRbgqRfn4Avl6bedB6xyLbRybwencYRiF@mail.gmail.com>
Date: Tue, 25 May 2010 17:02:17 +0200
Message-ID: <AANLkTimWx4fnqA5hviwv8gOTH1eydC0SMllcmsQp8jSB@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix event scheduling issues introduced by 
	transactional API (take 2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       acme@infradead.org, ming.m.lin@intel.com, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, the patch look good expect it needs:

static int x86_pmu_commit_txn(const struct pmu *pmu)
{
        ......
        /*
         * copy new assignment, now we know it is possible
         * will be used by hw_perf_enable()
         */
        memcpy(cpuc->assign, assign, n*sizeof(int));

        cpuc->n_txn = 0;

        return 0;
}

Because you always call cancel_txn() even when commit()
succeeds. I don't really understand why. I think it could be
avoided by clearing the group_flag in commit_txn() if it
succeeds. It would also make the logical flow more natural. Why
cancel something that has succeeded. You cancel when you fail/abort.


On Tue, May 25, 2010 at 4:19 PM, Stephane Eranian <eranian@google.com> wrote:
> Ok, let me check. I think it is almost right.
>
> On Tue, May 25, 2010 at 4:03 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, 2010-05-25 at 15:39 +0200, stephane eranian wrote:
>>> On Tue, May 25, 2010 at 3:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> > On Tue, 2010-05-25 at 15:20 +0200, Stephane Eranian wrote:
>>> >
>>> >> With this patch, you can now overcommit the PMU even with pinned
>>> >> system-wide events present and still get valid counts.
>>> >
>>> > Does this patch differ from the one you send earlier?
>>> >
>>> Yes, it does. It changes the way n_added is updated.
>>>
>>> The first version was buggy (perf top would crash the machine).
>>> You cannot delay updating n_added until commit, because there
>>> are paths where you don't go through transactions. This version
>>> instead keeps the number of events last added and speculatively
>>> updates n_added (assuming success). If the transaction succeeds,
>>> then no correction is done (subtracting 0), if it fails, then the number
>>> of events just added to n_added is subtracted.
>>
>>
>> OK, just to see if I got it right, I wrote a similar patch from just the
>> changelog.
>>
>> Does the below look good?
>>
>> ---
>>  arch/x86/kernel/cpu/perf_event.c |   13 +++++++++++++
>>  kernel/perf_event.c              |   11 +++++++----
>>  2 files changed, 20 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
>> index 856aeeb..be84944 100644
>> --- a/arch/x86/kernel/cpu/perf_event.c
>> +++ b/arch/x86/kernel/cpu/perf_event.c
>> @@ -106,6 +106,7 @@ struct cpu_hw_events {
>>
>>        int                     n_events;
>>        int                     n_added;
>> +       int                     n_txn;
>>        int                     assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
>>        u64                     tags[X86_PMC_IDX_MAX];
>>        struct perf_event       *event_list[X86_PMC_IDX_MAX]; /* in enabled order */
>> @@ -983,6 +984,7 @@ static int x86_pmu_enable(struct perf_event *event)
>>  out:
>>        cpuc->n_events = n;
>>        cpuc->n_added += n - n0;
>> +       cpuc->n_txn += n - n0;
>>
>>        return 0;
>>  }
>> @@ -1089,6 +1091,14 @@ static void x86_pmu_disable(struct perf_event *event)
>>        struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>>        int i;
>>
>> +       /*
>> +        * If we're called during a txn, we don't need to do anything.
>> +        * The events never got scheduled and ->cancel_txn will truncate
>> +        * the event_list.
>> +        */
>> +       if (cpuc->group_flags & PERF_EVENT_TXN_STARTED)
>> +               return;
>> +
>>        x86_pmu_stop(event);
>>
>>        for (i = 0; i < cpuc->n_events; i++) {
>> @@ -1379,6 +1389,7 @@ static void x86_pmu_start_txn(const struct pmu *pmu)
>>        struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>>
>>        cpuc->group_flag |= PERF_EVENT_TXN_STARTED;
>> +       cpuc->n_txn = 0;
>>  }
>>
>>  /*
>> @@ -1391,6 +1402,8 @@ static void x86_pmu_cancel_txn(const struct pmu *pmu)
>>        struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>>
>>        cpuc->group_flag &= ~PERF_EVENT_TXN_STARTED;
>> +       cpuc->n_added -= cpuc->n_txn;
>> +       cpuc->n_events -= cpuc->n_txn;
>>  }
>>
>>  /*
>> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
>> index e099650..ca79f2a 100644
>> --- a/kernel/perf_event.c
>> +++ b/kernel/perf_event.c
>> @@ -652,8 +652,11 @@ group_sched_in(struct perf_event *group_event,
>>        if (txn)
>>                pmu->start_txn(pmu);
>>
>> -       if (event_sched_in(group_event, cpuctx, ctx))
>> +       if (event_sched_in(group_event, cpuctx, ctx)) {
>> +               if (txn)
>> +                       pmu->cancel_txn(pmu);
>>                return -EAGAIN;
>> +       }
>>
>>        /*
>>         * Schedule in siblings as one group (if any):
>> @@ -675,9 +678,6 @@ group_sched_in(struct perf_event *group_event,
>>        }
>>
>>  group_error:
>> -       if (txn)
>> -               pmu->cancel_txn(pmu);
>> -
>>        /*
>>         * Groups can be scheduled in as one unit only, so undo any
>>         * partial group before returning:
>> @@ -689,6 +689,9 @@ group_error:
>>        }
>>        event_sched_out(group_event, cpuctx, ctx);
>>
>> +       if (txn)
>> +               pmu->cancel_txn(pmu);
>> +
>>        return -EAGAIN;
>>  }
>>
>>
>>
>
>
>
> --
> Stephane Eranian  | EMEA Software Engineering
> Google France | 38 avenue de l'Opéra | 75002 Paris
> Tel : +33 (0) 1 42 68 53 00
> This email may be confidential or privileged. If you received this
> communication by mistake, please
> don't forward it to anyone else, please erase all copies and
> attachments, and please let me know that
> it went to the wrong person. Thanks
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
