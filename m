Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0IORBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 13:01:38 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:50508 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab0IORBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 13:01:36 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zzbb2cK1432N98dN9371Pzz1202hzz8275bhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8SSLK-01-2MW-02
X-M-MSG: 
Date: Wed, 15 Sep 2010 19:00:57 +0200
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
Message-ID: <20100915170057.GQ13563@erda.amd.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTimWoE5XiYSr8jx=RFS5Nb9d4_wWe=c-W3oMj8dH@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.09.10 12:36:27, Stephane Eranian wrote:
> On Wed, Sep 15, 2010 at 6:20 PM, Robert Richter <robert.richter@amd.com> wrote:
> > On 14.09.10 19:41:32, Robert Richter wrote:
> >> I found the reason why we get the unknown nmi. For some reason
> >> cpuc->active_mask in x86_pmu_handle_irq() is zero. Thus, no counters
> >> are handled when we get an nmi. It seems there is somewhere a race
> >> accessing the active_mask. So far I don't have a fix available.
> >> Changing x86_pmu_stop() did not help:
> >
> > The patch below for tip/perf/urgent fixes this.
> >
> > -Robert
> >
> > From 4206a086f5b37efc1b4d94f1d90b55802b299ca0 Mon Sep 17 00:00:00 2001
> > From: Robert Richter <robert.richter@amd.com>
> > Date: Wed, 15 Sep 2010 16:12:59 +0200
> > Subject: [PATCH] perf, x86: catch spurious interrupts after disabling counters
> >
> > Some cpus still deliver spurious interrupts after disabling a counter.
> 
> Most likely the interrupt was in flight at the time you disabled it.

I tried to clear the bit in the active_mask after disabling the
counter (writing to the msr), which did not solve it. Shouldn't the
counter be disabled immediatly? Maybe clearing the INT bit would have
been worked too, but I was not sure about side effects.

> Does the counter value reflect this?

Yes, the disabled bit was cleared after reading the evntsel msr and
the ctr value have had about 400 cycles (it could have been
overflowed, though we actually can't say since the counter was
disabled).

> Were you also getting this if you were only measuring at the user level?

I tried only

 perf record ./hackbench 10

which triggered it on my system.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

