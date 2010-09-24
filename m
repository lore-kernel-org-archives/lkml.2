Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab0IXSM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:12:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250Ab0IXSMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:12:25 -0400
Date: Fri, 24 Sep 2010 14:11:43 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling
 counters
Message-ID: <20100924181143.GQ26290@redhat.com>
References: <20100911094157.GA11521@elte.hu>
 <20100911114404.GE13563@erda.amd.com>
 <20100911124537.GA22850@elte.hu>
 <20100912095202.GF13563@erda.amd.com>
 <20100913143713.GK13563@erda.amd.com>
 <20100914174132.GN13563@erda.amd.com>
 <20100915162034.GO13563@erda.amd.com>
 <20100924000234.GO26290@redhat.com>
 <20100924031834.GP26290@redhat.com>
 <20100924100345.GE13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924100345.GE13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 12:03:45PM +0200, Robert Richter wrote:
> On 23.09.10 23:18:34, Don Zickus wrote:
> 
> > > I was able to duplicate the problem and can confirm this patch fixes the
> > > issue for me.  I tried poking around (similar to things Robert probably
> > > did) and had no luck.  Something just doesn't make sense, but I guess for
> > > now this patch is good enough for me. :-)
> > 
> > Ah ha!  I figured out what the problem was, need to disable the pmu while
> > processing the nmi. :-)   Finally something simple in this crazy unknown
> > NMI spree.
> > 
> > Oh yeah and trace_printk is now my new favorite tool!
> > 
> > From: Don Zickus <dzickus@redhat.com>
> > Date: Thu, 23 Sep 2010 22:52:09 -0400
> > Subject: [PATCH] x86, perf: disable pmu from counting when processing irq
> > 
> > On certain AMD and Intel machines, the pmu was left enabled
> > while the counters were reset during handling of the NMI.
> > After the counters are reset, code continues to process an
> > overflow.  During this time another counter overflow interrupt
> > could happen because the counter is still ticking.  This leads to
> > an unknown NMI.
> 
> I don't like the approach of disabling all counters in the nmi
> handler. First, it stops counting and thus may falsify
> measurement. Second, it introduces much overhead doing a rd-/wrmsrl()
> for each counter.

Ok. good points.  Though we may have to re-visit the perf_event_intel.c
code as my patch was based on 'well they did it there, we can do it here'
approach.

> 
> Does your patch below solve something that my patch doesn't?

Well, two things I was trying to solve with your approach is the extra NMI
that is generated, and the fact that you may falsely eat an unknown NMI
(because you don't clear cpuc->running except in the special case).

Yeah, I know the heurestics from your patch a couple of weeks ago will
make the case of falsely eating an unknown NMI next to impossible.  But I
was trying to limit the number seen.

For example, the back-to-back nmi problem we dealt with a couple of weeks
ago, only had a 'special case' that had to be dealt with every once in a
while (depending on the level of perf activity).  Now I can see unknown
NMIs every time there is a pmu_stop() issued.  I was trying to figure out
a way to cut down on that noise.

I came up with a couple of approaches but both involve another rdmsrl in
the handle_irq path.  I thought I would toss these ideas out for
conversation.

the first approach gets rid of the extra nmi by waiting until the end to
re-write the counter, but adds a second rdmsrl to resync the period in the
case where pmu_stop is not called.


diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 48c6d8d..1642f48 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1175,11 +1175,22 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 		handled++;
 		data.period	= event->hw.last_period;
 
-		if (!x86_perf_event_set_period(event))
-			continue;
+		/*
+		 * if period is over, process the overflow
+		 * before reseting the counter, otherwise
+		 * a new overflow could occur before the 
+		 * event is stopped
+		 */
+		if (local64_read(&hwc->period_left) <= 0) {
+			if (perf_event_overflow(event, 1, &data, regs)) {
+				x86_pmu_stop(event, 0);
+				continue;
+			}
+			/* if the overflow doesn't stop the event, resync */
+			x86_perf_event_update(event);
+		}
 
-		if (perf_event_overflow(event, 1, &data, regs))
-			x86_pmu_stop(event, 0);
+		x86_perf_event_set_period(event);
 	}
 
 	if (handled)

and the second approach, accepts the fact that we will get another unknown
NMI but check for it first (after stopping) and clear the cpuc->running
bit if we didn't overflow yet.

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 18c8856..bfb05da 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1189,8 +1189,12 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 		if (!x86_perf_event_set_period(event))
 			continue;
 
-		if (perf_event_overflow(event, 1, &data, regs))
+		if (perf_event_overflow(event, 1, &data, regs)) {
 			x86_pmu_stop(event, 0);
+			rdmsrl(hwc->event_base + idx, val);
+			if (val & (1ULL << (x86_pmu.cntval_bits - 1)))
+				__clear_bit(idx, cpuc->running);
+		}
 	}
 
 	if (handled)


After dealing with the Intel folks on another thread about how they are
finding more ways to detect and report hardware errors with NMIs, that I was
getting nervous about generating so many false NMIs and accidentally
eating a real one.

Cheers,
Don

