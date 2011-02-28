Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab1B1O4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:56:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:61997 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472Ab1B1O4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:56:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,240,1297065600"; 
   d="scan'208";a="395075930"
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1298884559.2428.10083.camel@twins>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
	 <1298884559.2428.10083.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 22:56:34 +0800
Message-Id: <1298904994.2169.60.camel@localhost>
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

How about below?
Leave the default pebs constraint assignment in intel_ds_init, and
overwrite it for snb in intel_pmu_init.

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 66712dd..d6edc8a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1182,6 +1182,7 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
+		x86_pmu.pebs_constraints = intel_snb_pebs_events;
 		pr_cont("SandyBridge events, ");
 		break;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 2128755..3e5530b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -740,13 +740,6 @@ static void intel_ds_init(void)
 			printk(KERN_CONT "PEBS fmt1%c, ", pebs_type);
 			x86_pmu.pebs_record_size = sizeof(struct pebs_record_nhm);
 			x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
-			switch (boot_cpu_data.x86_model) {
-			case 42: /* SandyBridge */
-				x86_pmu.pebs_constraints = intel_snb_pebs_events;
-				break;
-			default:
-				x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
-			}
 			break;
 
 		default:



