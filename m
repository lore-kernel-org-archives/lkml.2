Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab2IESpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:45:46 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53179 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083Ab2IESpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:45:45 -0400
MIME-Version: 1.0
In-Reply-To: <1346864762.2600.30.camel@twins>
References: <CABPqkBQGNx0od5-nkRDsrXkKa3+TAYW07j59ct5b17gPU-Oqeg@mail.gmail.com>
	<1346864762.2600.30.camel@twins>
Date: Wed, 5 Sep 2012 20:45:43 +0200
Message-ID: <CABPqkBRDMG6Wozsx4JeROQEdNT+WRejOcW15p5DVZws1gXdA-g@mail.gmail.com>
Subject: Re: [BUG] perf: perf_swevent PMU should not be on rotation_list
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 7:06 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-09-05 at 16:03 +0200, Stephane Eranian wrote:
>> Hi,
>>
>> I was looking at the rotation code and I found out that when
>> I monitor a SW event (in my case a probe), I end up having
>> two PMUs on the rotation list on Intel Core: cpu and software.
>>
>> I thought there was no multiplexing needed for SW events.
>
> Correct, since programming of swevents should always succeed.
>
>> So why is the SW PMU on the rotation list causing extra
>> iterations through the rotation code?
>
> Because... uhm.. someone (probably me) didn't think to exclude swevents.
>
>> Shouldn't we do something like:
>>
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -771,6 +780,9 @@ static void perf_pmu_rotate_start(struct pmu *pmu)
>>         struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
>>         struct list_head *head = &__get_cpu_var(rotation_list);
>>
>> +       if (pmu->type == PERF_TYPE_SOFTWARE)
>> +               return;
>> +
>>         WARN_ON(!irqs_disabled());
>>
>>         if (list_empty(&cpuctx->rotation_list))
>
>
> Yeah, I guess that'll do, although I guess something like:
>
>   pmu->task_ctx_nr == perf_sw_context
>
> would be even better, since that would also work for TYPE_TRACEPOINT and
> possibly any other swevent like things.

Yeah, that's better. Will post a patch to fix that then.

Thanks.
