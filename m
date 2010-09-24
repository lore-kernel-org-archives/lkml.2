Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0IXDTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 23:19:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab0IXDTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 23:19:06 -0400
Date: Thu, 23 Sep 2010 23:18:34 -0400
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
Message-ID: <20100924031834.GP26290@redhat.com>
References: <20100910144634.GA1060@elte.hu>
 <20100910155659.GD13563@erda.amd.com>
 <20100911094157.GA11521@elte.hu>
 <20100911114404.GE13563@erda.amd.com>
 <20100911124537.GA22850@elte.hu>
 <20100912095202.GF13563@erda.amd.com>
 <20100913143713.GK13563@erda.amd.com>
 <20100914174132.GN13563@erda.amd.com>
 <20100915162034.GO13563@erda.amd.com>
 <20100924000234.GO26290@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924000234.GO26290@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 08:02:34PM -0400, Don Zickus wrote:
> On Wed, Sep 15, 2010 at 06:20:34PM +0200, Robert Richter wrote:
> > On 14.09.10 19:41:32, Robert Richter wrote:
> > > I found the reason why we get the unknown nmi. For some reason
> > > cpuc->active_mask in x86_pmu_handle_irq() is zero. Thus, no counters
> > > are handled when we get an nmi. It seems there is somewhere a race
> > > accessing the active_mask. So far I don't have a fix available.
> > > Changing x86_pmu_stop() did not help:
> > 
> > The patch below for tip/perf/urgent fixes this.
> > 
> > -Robert
> 
> I was able to duplicate the problem and can confirm this patch fixes the
> issue for me.  I tried poking around (similar to things Robert probably
> did) and had no luck.  Something just doesn't make sense, but I guess for
> now this patch is good enough for me. :-)

Ah ha!  I figured out what the problem was, need to disable the pmu while
processing the nmi. :-)   Finally something simple in this crazy unknown
NMI spree.

Oh yeah and trace_printk is now my new favorite tool!

From: Don Zickus <dzickus@redhat.com>
Date: Thu, 23 Sep 2010 22:52:09 -0400
Subject: [PATCH] x86, perf: disable pmu from counting when processing irq

On certain AMD and Intel machines, the pmu was left enabled
while the counters were reset during handling of the NMI.
After the counters are reset, code continues to process an
overflow.  During this time another counter overflow interrupt
could happen because the counter is still ticking.  This leads to
an unknown NMI.

static int x86_pmu_handle_irq(struct pt_regs *regs)
{

<snip..>

        for (idx = 0; idx < x86_pmu.num_counters; idx++) {
                if (!test_bit(idx, cpuc->active_mask))
                        continue;

<snip..>

counter reset--> if (!x86_perf_event_set_period(event))
                        continue;

still ticking--> if (perf_event_overflow(event, 1, &data, regs))
<boom overflow>
stopped here -->        x86_pmu_stop(event);

The way to solve this is to disable the pmu while processing the
overflows and re-enable when done.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 48c6d8d..d4fe95d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1158,6 +1158,8 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
+	x86_pmu_disable_all();
+
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
@@ -1182,6 +1184,8 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 			x86_pmu_stop(event, 0);
 	}
 
+	x86_pmu_enable_all(0);
+
 	if (handled)
 		inc_irq_stat(apic_perf_irqs);
 
-- 
1.7.2.3

