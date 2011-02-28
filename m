Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab1B1OVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:21:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:2176 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab1B1OVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:21:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,239,1297065600"; 
   d="scan'208";a="714130098"
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1298884559.2428.10083.camel@twins>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
	 <1298884559.2428.10083.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 22:21:27 +0800
Message-Id: <1298902887.2169.48.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 17:15 +0800, Peter Zijlstra wrote:
> On Mon, 2011-02-28 at 15:22 +0800, Lin Ming wrote:
> > This patch adds basic SandyBridge support, including hardware cache
> > events and PEBS events support.
> > 
> > LLC-* hareware cache events don't work for now, it depends on the
> > offcore patches.
> 
> What's the status of those, Stephane reported some problems last I
> remember?

There is an event scheduling issue.
http://marc.info/?l=linux-kernel&m=129842356323752&w=2

I'll look at it.

> 
> 
> >  #define INTEL_EVENT_CONSTRAINT(c, n)	\
> >  	EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
> > +#define INTEL_EVENT_CONSTRAINT2(c, n)	\
> > +	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
> 
> That's a particularly bad name, how about something like
> 
> INTEL_UEVENT_CONSTRAINT or somesuch.

OK.

But any case it's duplicated with PEBS_EVENT_CONSTRAINT.

#define PEBS_EVENT_CONSTRAINT(c, n)     \
        EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)

> 
> > @@ -702,7 +738,13 @@ static void intel_ds_init(void)
> >  			printk(KERN_CONT "PEBS fmt1%c, ", pebs_type);
> >  			x86_pmu.pebs_record_size = sizeof(struct pebs_record_nhm);
> >  			x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
> > -			x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
> > +			switch (boot_cpu_data.x86_model) {
> > +			case 42: /* SandyBridge */
> > +				x86_pmu.pebs_constraints = intel_snb_pebs_events;
> > +				break;
> > +			default:
> > +				x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
> > +			}
> >  			break;
> >  
> >  		default:
> 
> We already have this massive model switch right after this function,
> might as well move the pebs constraint assignment there.


