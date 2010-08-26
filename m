Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab0HZVOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 17:14:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720Ab0HZVOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 17:14:45 -0400
Date: Thu, 26 Aug 2010 17:14:24 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100826211424.GQ4879@redhat.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100823085339.GA26713@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100823085339.GA26713@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 10:53:39AM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Don Zickus <dzickus@redhat.com> wrote:
> > 
> > > I'll test tip later today to see if I can reproduce it.
> > > 
> > > Cheers,
> > > Don
> > > 
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > >
> > > >it's not working so well, i'm getting:
> > > >
> > > > Uhhuh. NMI received for unknown reason 00 on CPU 9.
> > > > Do you have a strange power saving mode enabled?
> > > > Dazed and confused, but trying to continue
> > > >
> > > >on a nehalem box, after a perf top and perf stat run.
> > 
> > FYI, it does not trigger on an AMD box.
> 
> Ok, to not hold up the perf/urgent flow i zapped these two commits for 
> the time being:
> 
>  4a31beb: perf, x86: Fix handle_irq return values
>  8e3e42b: perf, x86: Try to handle unknown nmis with an enabled PMU
> 
> We can apply them if they take a form that dont introduce a different 
> kind of (and more visible) regression.

So this patch fixes it, though I haven't convince myself why (perhaps
babysitting my 4 month old isn't helping :-))

The code now enters the loop and reprocesses the new status which properly
increments handled to 2 and thus the new logic takes care of it.

Cheers,
Don


diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 4539b4b..d16ebd8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -738,6 +738,7 @@ again:
 
 	inc_irq_stat(apic_perf_irqs);
 	ack = status;
+	intel_pmu_ack_status(ack);
 
 	intel_pmu_lbr_read();
 
@@ -766,8 +767,6 @@ again:
 			x86_pmu_stop(event);
 	}
 
-	intel_pmu_ack_status(ack);
-
 	/*
 	 * Repeat if there is more work to be done:
 	 */
