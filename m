Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0ETOOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:14:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:44931 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0ETOOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:14:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=xEPIMRinN9hf+PfzIkosu5egTJPEu6Yfehrm0pFn/fxKeuHM/rvWSXINT1cXeKdp9
	NXr0bx6oDRptL+Rc7TZJg==
MIME-Version: 1.0
In-Reply-To: <20100520135819.GP21799@erda.amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
	 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
	 <AANLkTiniEWKJIrbTSZQ0jBXps75WVQbvGSXVyUVttJ7P@mail.gmail.com>
	 <1274347413.5605.13636.camel@twins>
	 <20100520135819.GP21799@erda.amd.com>
Date: Thu, 20 May 2010 16:14:46 +0200
Message-ID: <AANLkTilSrJLHOpC0IkoMbiWxnCXHSgQhBUsSkm3fs6HG@mail.gmail.com>
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the 
	type of a raw sample
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>, Will Deacon <will.deacon@arm.com>,
       Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 3:58 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 20.05.10 05:23:33, Peter Zijlstra wrote:
>> On Thu, 2010-05-20 at 10:10 +0200, Stephane Eranian wrote:
>> > I still don't understand why you need all of this to encode IBS.
>> > I still believe that with attr.config there is plenty of bits to choose
>> > from. I do understand the need for PERF_SAMPLE_RAW. I think
>> > there is no other way.
>> >
>> > You simply need to pick an encoding to mark the config as IBS. You
>> > need two bits for this: 00 regular counters, 01 IBS Fetch, 10 IBS op.
>> > Regular counters use 43 bits, IBS fetch uses 58, IBS op uses 52.
>> > So you could use bits 62-63 for instance. You don't need to encode
>> > the sampling period in attr.config for either IBS. You can use
>> > attr.sample_period, so you free up 16 bits.
>> >
>> > I understand that IBS may evolve and thus may use more bits. But
>> > you still have at least 16 bits of margin.
>
> We have some bits in the msrs that are reserved now, for perfctr and
> also for ibs. We could start reusing it to mark a special sample type
> and so on. So far, ok. Somewhen in the future there is a hw extensions
> and these bits are not reserved anymore, what now?
>
You will always have the sampling period bits. Those will always be
handled by attr->sample_period. And they correspond to the lower
bits which are also used to encode the event select on regular counters.
So you could identify IBS with special event selects in the lower 8 bits
for instance.

IBS is a very model specific feature, as such the method you use to
encode it may change.



> In case the register layout changes, you start workaround this
> shifting and masking bits back and forth. This will end in a mess. We
> don't know what will change and when, but *reserved* means it could be
> subject to change. So, actually you have to assume arbitrary 64 bit
> config values for perfctrs and ibs. Thus, you cannot use reserved bits
> for encoding, doing this would be a hack.
>
In my new proposal, I am not using reserved bits, I am using bits which
are stored elsewhere in the attr structure.

> The approach is also not extendable for new pmu features. The question
> will rise again then how to encode it.
>
There is no guarantee your scheme will help there either. Nobody knows
the interface to those new features. It may be that you will need more than
64 bits.

> So encoding this information in some other attribute like raw_type or
> any other field is a much cleaner and a more stable solution, easier
> to program and to maintain. And there is enough space in the attribute
> structure.
>
What I am missing with raw_type is how it plays out with attr->type which
already has RAW? Seems like you have a second level of raw.

>> > Users and tools would rely on an library to provide the event encoding.
>> > No need to come up with some raw hex number on the cmdline.
>
> We can pack everything in tools and libraries and hide direct access
> to the user. Now, one reads the IBS spec and wants to start using
> it. He will have to learn (by reading the source or documentation)
> now, how to pass parameters using the tool or library to set certain
> bits in the registers. This adds an additional i/f layer what needs to
> be defined, documented, implemented and maintained. Why not keep
> things simple and let the user pass a register value to the pmu? Only
> the config has to be validated in the kernel and that's it. The hw
> spec is then the reference for using the interface. We have already
> raw config values for counters and there was a reason for it.
>
>> For Instruction-Fetch:
>>
>>   0:15 sample-period (r/w)
>>     57 randomized    (r/w)
>
>> For Instruction-Execution:
>>
>>   0:15 sample-period (r/w)
>
>>   0x87 Instruction Fetch Stall -- Ins-Fetch
>>   0xC0 Retired Instructions    -- Ins-Exec
>
> I agree, where possible we should reuse attributes or existing events
> for configuration. But since the pmu behavior differs, there is the
> risk of mixing different things together. "precise" would be different
> on Intel and AMD. This will be hidden to the user leading to wrong
> assumptions and results. And, what about new options that don't have
> equivalent attribute flags?
>
I agree.

> But it's not the question how to pass the config, the question is how
> to mark the event configuration as a certain IBS event.
>
Yes, we agree on that.

>> Furthermore, these counters will have to deal with sample-period > 2^16
>> by 'ignoring' interrupts until we get ->period_left down to 0.
>
> No question here, ibs counters should be extended to 64 bit counters,
> but this is not addressed with this patch set, I have kept this for
> later work.
>
That's fine with me.

>> The extra data could possibly be exposed through attaching non-sampling
>> group events and using SAMPLE_READ, like L1-misses, although
>> reconstructing the count from just one bit seems 'interesting'.
>>
>> The IbsFetchLinAd/IbsOpRip would go straight into PERF_SAMPLE_IP by
>> replacing pt_regs->ip I guess.
>>
>> IbsDcLinAd goes into PERF_SAMPLE_ADDR
>
> It's the same for sampling data as with config data. We can spread it
> all over its data structures, but a user will then recollect all of it
> again needing to know where the information can be found. And, it will
> never be the same kind of information if the pmus are different.
>
Well, I don't think you want to define an attribute for each and every
bit of info returned by IBS. I think you need to return the IBSDATA regs
as is and let the user pick and choose. Of course, the information can
change, but IBS is model specific, it returns something richer than just
a count.
