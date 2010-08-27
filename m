Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab0H0Nop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:44:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab0H0Noo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:44:44 -0400
Date: Fri, 27 Aug 2010 09:44:29 -0400
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
Message-ID: <20100827134429.GS4879@redhat.com>
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
> On 26.08.10 17:14:24, Don Zickus wrote:
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> > index 4539b4b..d16ebd8 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> > @@ -738,6 +738,7 @@ again:
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

Yeah, I can do that.  The other patch was just a proof of concept to see
what others thought.

What is funny is that this problem was masked by the
perf_event_nmi_handler swallowing all the nmis.  I wonder if we were
losing events as a result of this bug too because if you think about it,
we processed the first event, a second event came in and we accidentally
ack'd it, thus dropping it on the floor.  Now I wonder how the event was
ever reloaded, unless it was by accident because of how the scheduler
deals with perf counters (perf_start/stop all the time).

Cheers,
Don
