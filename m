Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab0ETJmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:42:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16979 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab0ETJmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:42:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=cBu7Iq4KX3HbDm3TZWnCwhEmMmgqyrKdPnwmIeYyrpf9bwDY5YQArZBpNffrG1DeT
	qxFCGsuHhyJ7c2d+5NtgA==
MIME-Version: 1.0
In-Reply-To: <1274347413.5605.13636.camel@twins>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
	 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
	 <AANLkTiniEWKJIrbTSZQ0jBXps75WVQbvGSXVyUVttJ7P@mail.gmail.com>
	 <1274347413.5605.13636.camel@twins>
Date: Thu, 20 May 2010 11:42:35 +0200
Message-ID: <AANLkTikWSOPpHsvJGht7c7QnwcOk-nMyBNhY-g6QpNzg@mail.gmail.com>
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the 
	type of a raw sample
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>, Will Deacon <will.deacon@arm.com>,
       Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 11:23 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-05-20 at 10:10 +0200, Stephane Eranian wrote:
>> I still don't understand why you need all of this to encode IBS.
>> I still believe that with attr.config there is plenty of bits to choose
>> from. I do understand the need for PERF_SAMPLE_RAW. I think
>> there is no other way.
>>
>> You simply need to pick an encoding to mark the config as IBS. You
>> need two bits for this: 00 regular counters, 01 IBS Fetch, 10 IBS op.
>> Regular counters use 43 bits, IBS fetch uses 58, IBS op uses 52.
>> So you could use bits 62-63 for instance. You don't need to encode
>> the sampling period in attr.config for either IBS. You can use
>> attr.sample_period, so you free up 16 bits.
>>
>> I understand that IBS may evolve and thus may use more bits. But
>> you still have at least 16 bits of margin.
>>
>> Users and tools would rely on an library to provide the event encoding.
>> No need to come up with some raw hex number on the cmdline.
>
> No need for any of that afaict, how about:
>
> For Instruction-Fetch:
>
>  0:15 sample-period (r/w)
>  16:31 cnt           (r/w)
>  32:47 latency       (r/w)
>    48 enable        (r/w)
>    49 valid         (r/w)
>  50:56               (ro)
>    57 randomized    (r/w)
>
Your are mixing output and input parameters.

The only input parameters you have are:
- sample-period, enable, random
The rest is output only.

So I would say: you don't need to encode anything
sample-period -> attr.sample_period
random           -> attr.random_width (once we add that)

>
> For Instruction-Execution:
>
>  0:15 sample-period (r/w)
>    17 enable        (r/w)
>    18 valid         (r/w)
>
Same thing here, sample-period is the only input parameter.
so sample-period -> attr.sample_period

Both IBFETCHCTL, IBSOP would also be included in
the PERF_SAMPLE_RAW. Because they have the valid
bits and latency.


> So if we add perf_event_attr::latency (can also be used for
> PEBS-load-latency, can Sparc/PowerPC/ARM/SH use this too?), we can

I suspect you can encode the latency with the event code used for PEBS
load-latency (PEBS-LL). It can only be used with one event.

> encode these IBS things as:
>
>  0x87 Instruction Fetch Stall -- Ins-Fetch
>  0xC0 Retired Instructions    -- Ins-Exec
>
I think those events do not map to the behavior of IBS. We have
add that discussion before.

> When we set perf_event_attr::precise > 0
>
Well, then you'd have to document that when you do that you use IBS and
that the event do not count the same things.

> The Ins-Exec will have to re-construct the actual event->count by adding
> sample-period on each interrupt, as it seems we lack an actual counter
> in hardware.
>
For what? counting mode?

> Furthermore, these counters will have to deal with sample-period > 2^16
> by 'ignoring' interrupts until we get ->period_left down to 0.
>
Well, it's not 2^16, it's 2^20 but bottom 4 bits must be zero.
What about simply failing perf_event_open() is sample_period does not fit the
constraint?

> The extra data could possibly be exposed through attaching non-sampling
> group events and using SAMPLE_READ, like L1-misses, although
> reconstructing the count from just one bit seems 'interesting'.
>
> The IbsFetchLinAd/IbsOpRip would go straight into PERF_SAMPLE_IP by
> replacing pt_regs->ip I guess.
>
> IbsDcLinAd goes into PERF_SAMPLE_ADDR
>
What about the rest, the TLB, alignment, data sources?
