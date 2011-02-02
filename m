Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab1BBWo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:44:26 -0500
Received: from smtp-out.google.com ([216.239.44.51]:42766 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1BBWoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:44:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WhUuhzaIxBh7ypiu6SZ3m9n9/N7q3EgwYNyRW3UI0i65MimgdpLmA+ad7SGdQkcEq0
         8N7ek82/c3gIOY5NWB6g==
MIME-Version: 1.0
In-Reply-To: <1296667777.26581.349.camel@laptop>
References: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
	<1296664860-10886-6-git-send-email-robert.richter@amd.com>
	<1296666198.26581.343.camel@laptop>
	<20110202172419.GB5874@erda.amd.com>
	<1296667777.26581.349.camel@laptop>
Date: Wed, 2 Feb 2011 23:44:22 +0100
Message-ID: <AANLkTikdLUkv3y6-g=OegtJD5bXS0vPPjLMR1jmQjCZz@mail.gmail.com>
Subject: Re: [PATCH 5/5] perf, x86: Add support for AMD family 15h core counters
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 6:29 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-02-02 at 18:24 +0100, Robert Richter wrote:
>> On 02.02.11 12:03:18, Peter Zijlstra wrote:
>> > On Wed, 2011-02-02 at 17:41 +0100, Robert Richter wrote:
>> > > +       unsigned int    eventsel;
>> > > +       unsigned int    perfctr;
>> > > +       unsigned int    *eventsel_map;
>> > > +       unsigned int    *perfctr_map;
>> > >         u64             (*event_map)(int);
>> > >         int             max_events;
>> > >         int             num_counters;
>> > > @@ -323,11 +325,17 @@ again:
>> > >
>> > >  static inline unsigned int x86_pmu_config_addr(int index)
>> > >  {
>> > > +       if (x86_pmu.eventsel_map)
>> > > +               return x86_pmu.eventsel_map[index];
>> > > +
>> > >         return x86_pmu.eventsel + index;
>> > >  }
>> > >
>> > >  static inline unsigned int x86_pmu_event_addr(int index)
>> > >  {
>> > > +       if (x86_pmu.perfctr_map)
>> > > +               return x86_pmu.perfctr_map[index];
>> > > +
>> > >         return x86_pmu.perfctr + index;
>> > >  }
>> >
>> > Why this and not something like x86_pmu.perfctr + (index << 1)?
>> > You could even use alternatives.
>>
>> I was thinking about this. The main reason is the implementation of
>> northbridge counters, the range is in MSRC001_02[47:40]. This would
>> add more complexity then. Using a table would be something like
>>
>> unsigned int eventsel_f15h[] = {
>>       MSR_F15H_PERF_CTL,
>>       MSR_F15H_PERF_CTL + 2,
>>       MSR_F15H_PERF_CTL + 4,
>>       MSR_F15H_PERF_CTL + 6,
>>       MSR_F15H_PERF_CTL + 8,
>>       MSR_F15H_PERF_CTL + 10,
>>       MSR_F15H_NB_PERF_CTL,
>>       MSR_F15H_NB_PERF_CTL + 2,
>>       MSR_F15H_NB_PERF_CTL + 6,
>>       MSR_F15H_NB_PERF_CTL + 8,
>> };
>>
>> We don't need to change the address generation for this. Otherwise we
>> need to introduce more logic for the calculation.
>>
>> Also, were could be potential easier implementations for fixed
>> counters, BTS, P4, IBS, etc. But didn't look that close at it.
>>
>> (Btw, I am not yet sure if NB counters shouldn't better start at index
>> 16 or so to reserve space for perf counter expansion.)
>
> Now that the NB PMU is completely separate from the core PMU, wouldn't
> it make more sense to implement that as a separate entity just like the
> intel uncore bits?

I agree on this.
>
>
