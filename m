Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab0IOSpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 14:45:08 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:3634 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab0IOSpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:45:06 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h)
X-WSS-ID: 0L8SXDX-02-1M2-02
X-M-MSG: 
Date: Wed, 15 Sep 2010 20:44:24 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Don Zickus <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling
 counters
Message-ID: <20100915184424.GS13563@erda.amd.com>
References: <20100911094157.GA11521@elte.hu>
 <20100911114404.GE13563@erda.amd.com>
 <20100911124537.GA22850@elte.hu>
 <20100912095202.GF13563@erda.amd.com>
 <20100913143713.GK13563@erda.amd.com>
 <20100914174132.GN13563@erda.amd.com>
 <20100915162034.GO13563@erda.amd.com>
 <AANLkTimWoE5XiYSr8jx=RFS5Nb9d4_wWe=c-W3oMj8dH@mail.gmail.com>
 <20100915170057.GQ13563@erda.amd.com>
 <AANLkTi=yvDF34e5rYqJt=Av7dhSwBLjXp=r_EfEAMLJY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <AANLkTi=yvDF34e5rYqJt=Av7dhSwBLjXp=r_EfEAMLJY@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.09.10 13:32:49, Stephane Eranian wrote:
> > I tried to clear the bit in the active_mask after disabling the
> > counter (writing to the msr), which did not solve it. Shouldn't the
> > counter be disabled immediatly? Maybe clearing the INT bit would have
> > been worked too, but I was not sure about side effects.
> >
> 0 instr1
> 1 instr2
> 2 instr3
> 3 wrmsrl(eventsel0, 0);
> 
> There is skid between the instruction you overflow the counter and
> where the interrupt
> is posted.  If you overflow on instr1, suppose you post the interrupt
> on instr3 which
> is immediately followed by disable. There may a chance you get the
> interrupt even
> though the counter was disabled. I also don't know when the INT bit is
> looked at.

Yes, this could be possible. So, we should assume interrupts may be
delivered after a counter is disabled, which the patch addresses.

> 
> It may be worthwhile trying with:
> 
> static inline void x86_pmu_disable_event(struct perf_event *event)
> {
>         struct hw_perf_event *hwc = &event->hw;
>         (void)checking_wrmsrl(hwc->config_base + hwc->idx, 0);
> }
> 
> to see if it makes a difference.
> 
> 
> >> Does the counter value reflect this?
> >
> > Yes, the disabled bit was cleared after reading the evntsel msr and
> > the ctr value have had about 400 cycles (it could have been
> > overflowed, though we actually can't say since the counter was
> > disabled).
> >
> >> Were you also getting this if you were only measuring at the user level?
> >
> > I tried only
> >
> >  perf record ./hackbench 10
> >
> > which triggered it on my system.
> >
> I suspect that if you do:
> 
> perf record -e cycles:u ./hackbench 10
> 
> It does not happen.

Do you know at which period the counters running for the following?

 perf record ./hackbench 10
 perf record -e cycles -e instructions -e cache-references \
     -e cache-misses -e branch-misses -a -- <cmd>

I couldn't find something about this in the man page.

I will do some further investigations here, esp. with:

* compile order,
* checking_wrmsrl(),
* -e cycles:u

But I can not start with it before next week.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

