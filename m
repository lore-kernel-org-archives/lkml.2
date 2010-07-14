Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab0GNIOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 04:14:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:21505 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab0GNIN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 04:13:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,200,1278313200"; 
   d="scan'208";a="299987989"
Subject: Re: perf failed with kernel 2.6.35-rc
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <1279068592.2096.924.camel@ymzhang.sh.intel.com>
References: <1279008849.2096.913.camel@ymzhang.sh.intel.com>
	 <20100713085019.GB7984@elte.hu>
	 <1279068592.2096.924.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 14 Jul 2010 16:15:02 +0800
Message-Id: <1279095302.2096.1251.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 08:49 +0800, Zhang, Yanmin wrote:
> On Tue, 2010-07-13 at 10:50 +0200, Ingo Molnar wrote:
> > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > 
> > > Peter,
> > > 
> > > perf doesn't work on my Nehalem EX machine.
> > > 1) The 1st start of 'perf top' is ok;
> > > 2) Kill the 1st perf and restart it. It doesn't work. No data is showed.
> > > 
> > > I located below commit:
> > > commit 1ac62cfff252fb668405ef3398a1fa7f4a0d6d15
> > > Author: Peter Zijlstra <peterz@infradead.org>
> > > Date:   Fri Mar 26 14:08:44 2010 +0100
> > > 
> > >     perf, x86: Add Nehelem PMU programming errata workaround
> > >     
> > >     workaround From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > >     Date: Fri Mar 26 13:59:41 CET 2010
> > >     
> > >     Implement the workaround for Intel Errata AAK100 and AAP53.
> > >     
> > >     Also, remove the Core-i7 name for Nehalem events since there are
> > >     also Westmere based i7 chips.
> > > 
> > > 
> > > If I comment out the workaround in function intel_pmu_nhm_enable_all,
> > > perf could work.
> > > 
> > > A quick glance shows:
> > > wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
> > > should be:
> > > wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
> > 
> > > I triggered sysrq to dump PMU registers and found the last bit of
> > > global status register is 1. I added a status reset operation like below patch:
> > > 
> > > --- linux-2.6.35-rc5/arch/x86/kernel/cpu/perf_event_intel.c	2010-07-14 09:38:11.000000000 +0800
> > > +++ linux-2.6.35-rc5_fork/arch/x86/kernel/cpu/perf_event_intel.c	2010-07-14 14:41:42.000000000 +0800
> > > @@ -505,8 +505,13 @@ static void intel_pmu_nhm_enable_all(int
> > >  		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 1, 0x4300B1);
> > >  		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 2, 0x4300B5);
> > >  
> > > -		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
> > > +		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
> > >  		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
> > > +		/*
> > > +		 * Reset the last 3 bits of global status register in case
> > > +		 * previous enabling causes overflows.
> > > +		 */
> > > +		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, 0x7);
> > >  
> > >  		for (i = 0; i < 3; i++) {
> > >  			struct perf_event *event = cpuc->events[i];
> > >
> > > 
> > > However, it still doesn't work. Current right way is to comment out
> > > the workaround.
> > 
> > Well, how about doing it like this:
> > 
> > 		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
> > 		/*
> > 		 * Reset the last 3 bits of global status register in case
> > 		 * previous enabling causes overflows.
> > 		 */
> > 		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, 0x7);
> >   
> >  		for (i = 0; i < 3; i++) {
> >   			struct perf_event *event = cpuc->events[i];
> > 			...
> > 		}
> > 
> >   		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
> > 
> 
> > I.e. global-mask, overflow-clear, explicit-enable, then global-enable?
> Ingo,
> 
> wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7) is global enable. So it's
> global-enable, overflow-clear, explicit-enable, then global-disable?
It doesn't work.

I copied the PMU dumping of logical processor 0.

Besides status register's bit0 is equal to 0, PMC0 count is small. So it takes
a long time to overflow.


CPU#0: ctrl:       000000070000000f
CPU#0: status:     0000000000000001
CPU#0: overflow:   0000000000000000
CPU#0: fixed:      0000000000000000
CPU#0: pebs:       0000000000000000
CPU#0: active:     0000000000000001
CPU#0:   gen-PMC0 ctrl:  000000000053003c
CPU#0:   gen-PMC0 count: 00000000549bffd9
CPU#0:   gen-PMC0 left:  0000000000000002
CPU#0:   gen-PMC1 ctrl:  00000000004300b1
CPU#0:   gen-PMC1 count: 0000000000000000
CPU#0:   gen-PMC1 left:  0000000000000000
CPU#0:   gen-PMC2 ctrl:  00000000004300b5
CPU#0:   gen-PMC2 count: 0000000000000000
CPU#0:   gen-PMC2 left:  0000000000000000
CPU#0:   gen-PMC3 ctrl:  0000000000000000
CPU#0:   gen-PMC3 count: 0000000000000000
CPU#0:   gen-PMC3 left:  0000000000000000
CPU#0: fixed-PMC0 count: 0000000000000000
CPU#0: fixed-PMC1 count: 0000000000000000
CPU#0: fixed-PMC2 count: 0000000000000000
SysRq : Show Regs


I instrumented function intel_pmu_nhm_enable_all to check
PMC0 count register before the workaround and after disabling
the 3 bits of MSR_CORE_PERF_GLOBAL_CTRL. It's changed unexpectedly.
below is a debug output about processor 0.

PMU register counter is changed. before[281474976710654] after[1]

So I think the event 0x4300D2 overflows. We need do a save and restore.
Below patch fixes it.

Yanmin

---

--- linux-2.6.35-rc5/arch/x86/kernel/cpu/perf_event_intel.c	2005-01-01 13:19:50.800000253 +0800
+++ linux-2.6.35-rc5_perf/arch/x86/kernel/cpu/perf_event_intel.c	2005-01-01 16:01:35.324000300 +0800
@@ -499,21 +499,34 @@ static void intel_pmu_nhm_enable_all(int
 {
 	if (added) {
 		struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+		struct perf_event *event;
 		int i;
 
+		for (i = 0; i < 3; i++) {
+			event = cpuc->events[i];
+			if (!event)
+				continue;
+			x86_perf_event_update(event);
+		}
 		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 0, 0x4300D2);
 		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 1, 0x4300B1);
 		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 2, 0x4300B5);
 
-		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
+		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
 		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
+		/*
+		 * Reset the last 3 bits of global status register in case
+		 * previous enabling causes overflows.
+		 */
+		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, 0x7);
 
 		for (i = 0; i < 3; i++) {
-			struct perf_event *event = cpuc->events[i];
+			event = cpuc->events[i];
 
 			if (!event)
 				continue;
 
+			x86_perf_event_set_period(event);
 			__x86_pmu_enable_event(&event->hw,
 					       ARCH_PERFMON_EVENTSEL_ENABLE);
 		}


