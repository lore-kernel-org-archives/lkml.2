Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0ETN6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 09:58:32 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:51109 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab0ETN6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 09:58:30 -0400
X-SpamScore: -28
X-BigFish: VPS-28(zz1432P98dN936eMaceO62a3La84eizz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L2Q1H5-01-3DI-02
X-M-MSG: 
Date: Thu, 20 May 2010 15:58:19 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>, Will Deacon <will.deacon@arm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the
 type of a raw sample
Message-ID: <20100520135819.GP21799@erda.amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
 <AANLkTiniEWKJIrbTSZQ0jBXps75WVQbvGSXVyUVttJ7P@mail.gmail.com>
 <1274347413.5605.13636.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1274347413.5605.13636.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.05.10 05:23:33, Peter Zijlstra wrote:
> On Thu, 2010-05-20 at 10:10 +0200, Stephane Eranian wrote:
> > I still don't understand why you need all of this to encode IBS.
> > I still believe that with attr.config there is plenty of bits to choose
> > from. I do understand the need for PERF_SAMPLE_RAW. I think
> > there is no other way.
> > 
> > You simply need to pick an encoding to mark the config as IBS. You
> > need two bits for this: 00 regular counters, 01 IBS Fetch, 10 IBS op.
> > Regular counters use 43 bits, IBS fetch uses 58, IBS op uses 52.
> > So you could use bits 62-63 for instance. You don't need to encode
> > the sampling period in attr.config for either IBS. You can use
> > attr.sample_period, so you free up 16 bits.
> > 
> > I understand that IBS may evolve and thus may use more bits. But
> > you still have at least 16 bits of margin.

We have some bits in the msrs that are reserved now, for perfctr and
also for ibs. We could start reusing it to mark a special sample type
and so on. So far, ok. Somewhen in the future there is a hw extensions
and these bits are not reserved anymore, what now?

In case the register layout changes, you start workaround this
shifting and masking bits back and forth. This will end in a mess. We
don't know what will change and when, but *reserved* means it could be
subject to change. So, actually you have to assume arbitrary 64 bit
config values for perfctrs and ibs. Thus, you cannot use reserved bits
for encoding, doing this would be a hack.

The approach is also not extendable for new pmu features. The question
will rise again then how to encode it.

So encoding this information in some other attribute like raw_type or
any other field is a much cleaner and a more stable solution, easier
to program and to maintain. And there is enough space in the attribute
structure.

> > Users and tools would rely on an library to provide the event encoding.
> > No need to come up with some raw hex number on the cmdline. 

We can pack everything in tools and libraries and hide direct access
to the user. Now, one reads the IBS spec and wants to start using
it. He will have to learn (by reading the source or documentation)
now, how to pass parameters using the tool or library to set certain
bits in the registers. This adds an additional i/f layer what needs to
be defined, documented, implemented and maintained. Why not keep
things simple and let the user pass a register value to the pmu? Only
the config has to be validated in the kernel and that's it. The hw
spec is then the reference for using the interface. We have already
raw config values for counters and there was a reason for it.

> For Instruction-Fetch:
> 
>   0:15 sample-period (r/w)
>     57 randomized    (r/w)

> For Instruction-Execution:
> 
>   0:15 sample-period (r/w)

>   0x87 Instruction Fetch Stall -- Ins-Fetch 
>   0xC0 Retired Instructions    -- Ins-Exec

I agree, where possible we should reuse attributes or existing events
for configuration. But since the pmu behavior differs, there is the
risk of mixing different things together. "precise" would be different
on Intel and AMD. This will be hidden to the user leading to wrong
assumptions and results. And, what about new options that don't have
equivalent attribute flags?

But it's not the question how to pass the config, the question is how
to mark the event configuration as a certain IBS event.

> Furthermore, these counters will have to deal with sample-period > 2^16
> by 'ignoring' interrupts until we get ->period_left down to 0.

No question here, ibs counters should be extended to 64 bit counters,
but this is not addressed with this patch set, I have kept this for
later work.

> The extra data could possibly be exposed through attaching non-sampling
> group events and using SAMPLE_READ, like L1-misses, although
> reconstructing the count from just one bit seems 'interesting'. 
> 
> The IbsFetchLinAd/IbsOpRip would go straight into PERF_SAMPLE_IP by
> replacing pt_regs->ip I guess.
> 
> IbsDcLinAd goes into PERF_SAMPLE_ADDR

It's the same for sampling data as with config data. We can spread it
all over its data structures, but a user will then recollect all of it
again needing to know where the information can be found. And, it will
never be the same kind of information if the pmus are different.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

