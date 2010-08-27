Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0H0S6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:58:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370Ab0H0S6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:58:08 -0400
Date: Fri, 27 Aug 2010 14:57:44 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100827185744.GV4879@redhat.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100823085339.GA26713@elte.hu>
 <20100826211424.GQ4879@redhat.com>
 <20100827081038.GF22783@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827081038.GF22783@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 10:10:38AM +0200, Robert Richter wrote:
> >  
> >  	inc_irq_stat(apic_perf_irqs);
> >  	ack = status;
> > +	intel_pmu_ack_status(ack);
> 
> I would slightly change the patch:
> 
> There is no need for the ack variable anymore, you could directly work
> with the status.
> 
> I would call intel_pmu_ack_status() as close as possible after the
> intel_pmu_get_status(), which is after 'again:'.
> 

Here is another version of the patch, which uses Robert's suggestion of
removing the ack variable

Cheers,
Don 

--

From: Don Zickus <dzickus@redhat.com>
Date: Fri, 27 Aug 2010 14:43:03 -0400
Subject: [PATCH] [x86] perf: fix accidentally ack'ing a second event on intel perf counter

During testing of a patch to stop having the perf subsytem swallow nmis,
it was uncovered that Nehalem boxes were randomly getting unknown nmis
when using the perf tool.

Moving the ack'ing of the PMI closer to when we get the status allows
the hardware to properly re-set the PMU bit signaling another PMI was
triggered during the processing of the first PMI.  This allows the new
logic for dealing with the shortcomings of multiple PMIs to handle the
extra NMI by 'eat'ing it later.

Now one can wonder why are we getting a second PMI when we disable all
the PMUs in the begining of the NMI handler to prevent such a case, for
that I do not know.  But I know the fix below helps deal with this quirk.

Tested on multiple Nehalems where the problem was occuring.  With the
patch, the code now loops a second time to handle the second PMI (whereas
before it was not).

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 4539b4b..ee05c90 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -712,7 +712,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	struct perf_sample_data data;
 	struct cpu_hw_events *cpuc;
 	int bit, loops;
-	u64 ack, status;
+	u64 status;
 	int handled = 0;
 
 	perf_sample_data_init(&data, 0);
@@ -729,6 +729,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 
 	loops = 0;
 again:
+	intel_pmu_ack_status(status);
 	if (++loops > 100) {
 		WARN_ONCE(1, "perfevents: irq loop stuck!\n");
 		perf_event_print_debug();
@@ -737,7 +738,6 @@ again:
 	}
 
 	inc_irq_stat(apic_perf_irqs);
-	ack = status;
 
 	intel_pmu_lbr_read();
 
@@ -766,8 +766,6 @@ again:
 			x86_pmu_stop(event);
 	}
 
-	intel_pmu_ack_status(ack);
-
 	/*
 	 * Repeat if there is more work to be done:
 	 */
-- 
1.7.2.1

