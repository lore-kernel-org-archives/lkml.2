Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0IORcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 13:32:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52473 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab0IORcy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 13:32:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hTsAEynBwjTEMuFtTpNwkmKJwT2bTAhAm1q2bntlrHMhmTgnfoPK5R2x73iuuDNWRo
         Bq/6mbdvmaxAUEkEMRcg==
MIME-Version: 1.0
In-Reply-To: <20100915170057.GQ13563@erda.amd.com>
References: <20100910144634.GA1060@elte.hu>
	<20100910155659.GD13563@erda.amd.com>
	<20100911094157.GA11521@elte.hu>
	<20100911114404.GE13563@erda.amd.com>
	<20100911124537.GA22850@elte.hu>
	<20100912095202.GF13563@erda.amd.com>
	<20100913143713.GK13563@erda.amd.com>
	<20100914174132.GN13563@erda.amd.com>
	<20100915162034.GO13563@erda.amd.com>
	<AANLkTimWoE5XiYSr8jx=RFS5Nb9d4_wWe=c-W3oMj8dH@mail.gmail.com>
	<20100915170057.GQ13563@erda.amd.com>
Date: Wed, 15 Sep 2010 19:32:49 +0200
Message-ID: <AANLkTi=yvDF34e5rYqJt=Av7dhSwBLjXp=r_EfEAMLJY@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling counters
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Don Zickus <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 7:00 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 15.09.10 12:36:27, Stephane Eranian wrote:
>> On Wed, Sep 15, 2010 at 6:20 PM, Robert Richter <robert.richter@amd.com> wrote:
>> > On 14.09.10 19:41:32, Robert Richter wrote:
>> >> I found the reason why we get the unknown nmi. For some reason
>> >> cpuc->active_mask in x86_pmu_handle_irq() is zero. Thus, no counters
>> >> are handled when we get an nmi. It seems there is somewhere a race
>> >> accessing the active_mask. So far I don't have a fix available.
>> >> Changing x86_pmu_stop() did not help:
>> >
>> > The patch below for tip/perf/urgent fixes this.
>> >
>> > -Robert
>> >
>> > From 4206a086f5b37efc1b4d94f1d90b55802b299ca0 Mon Sep 17 00:00:00 2001
>> > From: Robert Richter <robert.richter@amd.com>
>> > Date: Wed, 15 Sep 2010 16:12:59 +0200
>> > Subject: [PATCH] perf, x86: catch spurious interrupts after disabling counters
>> >
>> > Some cpus still deliver spurious interrupts after disabling a counter.
>>
>> Most likely the interrupt was in flight at the time you disabled it.
>
> I tried to clear the bit in the active_mask after disabling the
> counter (writing to the msr), which did not solve it. Shouldn't the
> counter be disabled immediatly? Maybe clearing the INT bit would have
> been worked too, but I was not sure about side effects.
>
0 instr1
1 instr2
2 instr3
3 wrmsrl(eventsel0, 0);

There is skid between the instruction you overflow the counter and
where the interrupt
is posted.  If you overflow on instr1, suppose you post the interrupt
on instr3 which
is immediately followed by disable. There may a chance you get the
interrupt even
though the counter was disabled. I also don't know when the INT bit is
looked at.

It may be worthwhile trying with:

static inline void x86_pmu_disable_event(struct perf_event *event)
{
        struct hw_perf_event *hwc = &event->hw;
        (void)checking_wrmsrl(hwc->config_base + hwc->idx, 0);
}

to see if it makes a difference.


>> Does the counter value reflect this?
>
> Yes, the disabled bit was cleared after reading the evntsel msr and
> the ctr value have had about 400 cycles (it could have been
> overflowed, though we actually can't say since the counter was
> disabled).
>
>> Were you also getting this if you were only measuring at the user level?
>
> I tried only
>
>  perf record ./hackbench 10
>
> which triggered it on my system.
>
I suspect that if you do:

perf record -e cycles:u ./hackbench 10

It does not happen.
