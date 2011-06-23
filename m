Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab1FWGsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 02:48:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51291 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1FWGsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 02:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VEqhAKBCJb/FY/Pt+xeYZM8Sqs2OvOJl8K5u5oLtDHLuaFvlSsNsVTRV/HkHA/kuP0
         vHVpovP7jCJBh1ljWPNYdPDQETLV9YFDaJA9hbp7nhveCc4tqEsStCY6GOQ/OHHXzqC0
         5OY7GkNb1mHXE5VtXc7MGYSCS+uR1xg65cyb0=
Date: Thu, 23 Jun 2011 10:48:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
Message-ID: <20110623064835.GB10238@sun>
References: <BANLkTikxWV8tjXrZnOrNnsw+nmsjGaxWbw@mail.gmail.com>
 <20110621164820.GC21641@sun>
 <BANLkTink5nOTqvqQYr4kx0fnBoOpoq7CiQ@mail.gmail.com>
 <20110621172319.GE21641@sun>
 <BANLkTikBsfcFfnmgdVQem15P9f2ooQBzeA@mail.gmail.com>
 <20110621175421.GF21641@sun>
 <BANLkTim8OdhTdaayHZAKSXWhmN0anEhieQ@mail.gmail.com>
 <20110621183227.GG21641@sun>
 <20110622082756.GK21641@sun>
 <20110622092134.GO21641@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622092134.GO21641@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 01:21:34PM +0400, Cyrill Gorcunov wrote:
...
> Note that I've not tested it but rather need approval/rejecting
> on idea in general.

The final version is below. Stephane, note that it's almost the
same idea as you proposed except it uses explicit namings to
mark out that watchdog cycles are special.

	Cyrill
---
perf, x86: Add PERF_COUNT_HW_WATCHDOG_CYCLES event in a sake of nmi-watchdog v3

Due to restriction and specifics of Netburst PMU we need a separated
event for NMI watchdog. In particular every Netburst event consume not
just a counter and config register, but also an additional ESCR register.
Since ESCR registers are grouped upon counters (i.e. if ESCR is occupied
for some event there is no room for another event to enter until it's
released) we need to pick up "least" used ESCR (or most available)
for nmi-watchdog purpose -- MSR_P4_CRU_ESCR2/3 was chosen.

v2: Add a comment about non-sleeping clockticks spotted by Ingo Molnar.
v3: Peter Zijlstra and Stephane Eranian pointed out that making new
    event global visible (up to userspace) will bring problems supporting
    this ABI in future. So now this event is x86 specific and hidden
    from userspace.

N.B: An attempts to make an alternate encodings for events didn't make
situation better because we would need to track how exactly we substitute
the particular event -- hw::config knows nothing from where the event came,
from user-space as a raw event or as pre-configured general event. If it
comes as raw event we have to track every single bit of ESCR mask and find
out if new event would count exactly the same thing as the former event
was supposed to. So I found such way pretty inconvenient.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   15 +++++++++++++++
 arch/x86/kernel/cpu/perf_event_amd.c   |    1 +
 arch/x86/kernel/cpu/perf_event_intel.c |    2 ++
 arch/x86/kernel/cpu/perf_event_p4.c    |   27 +++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_p6.c    |    1 +
 include/linux/perf_event.h             |    6 ++++++
 kernel/watchdog.c                      |    2 +-
 7 files changed, 53 insertions(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -233,6 +233,7 @@ struct x86_pmu {
 	void		(*enable_all)(int added);
 	void		(*enable)(struct perf_event *);
 	void		(*disable)(struct perf_event *);
+	void		(*hw_watchdog_config)(struct perf_event *event);
 	int		(*hw_config)(struct perf_event *event);
 	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
 	unsigned	eventsel;
@@ -413,6 +414,17 @@ static int x86_pmu_extra_regs(u64 config
 	return 0;
 }
 
+static void x86_pmu_hw_watchdog_config(struct perf_event *event)
+{
+	/*
+	 * On most x86 architectures watchdog cycles
+	 * are the same as cpu cycles.
+	 */
+	if (event->attr.type	== PERF_TYPE_HARDWARE &&
+	    event->attr.config	== PERF_COUNT_HW_WATCHDOG_CYCLES)
+		event->attr.config = PERF_COUNT_HW_CPU_CYCLES;
+}
+
 static atomic_t active_events;
 static DEFINE_MUTEX(pmc_reserve_mutex);
 
@@ -706,6 +718,9 @@ static int __x86_pmu_event_init(struct p
 	event->hw.last_cpu = -1;
 	event->hw.last_tag = ~0ULL;
 
+	if (x86_pmu.hw_watchdog_config)
+		x86_pmu.hw_watchdog_config(event);
+
 	return x86_pmu.hw_config(event);
 }
 
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_amd.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_amd.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_amd.c
@@ -372,6 +372,7 @@ static __initconst const struct x86_pmu 
 	.enable_all		= x86_pmu_enable_all,
 	.enable			= x86_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
+	.hw_watchdog_config	= x86_pmu_hw_watchdog_config,
 	.hw_config		= amd_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_K7_EVNTSEL0,
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1213,6 +1213,7 @@ static __initconst const struct x86_pmu 
 	.enable_all		= x86_pmu_enable_all,
 	.enable			= x86_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
+	.hw_watchdog_config	= x86_pmu_hw_watchdog_config,
 	.hw_config		= x86_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
@@ -1298,6 +1299,7 @@ static __initconst const struct x86_pmu 
 	.enable_all		= intel_pmu_enable_all,
 	.enable			= intel_pmu_enable_event,
 	.disable		= intel_pmu_disable_event,
+	.hw_watchdog_config	= x86_pmu_hw_watchdog_config,
 	.hw_config		= intel_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -705,6 +705,32 @@ static int p4_validate_raw_event(struct 
 	return 0;
 }
 
+static void p4_hw_watchdog_config(struct perf_event *event)
+{
+	/*
+	 * Watchdog ticks are special on Netburst, we use
+	 * that named "non-sleeping" ticks as recommended
+	 * by Intel SDM Vol3b.
+	 */
+	if (event->attr.type	!= PERF_TYPE_HARDWARE ||
+	    event->attr.config	!= PERF_COUNT_HW_WATCHDOG_CYCLES)
+		return;
+
+	event->attr.type	= PERF_TYPE_RAW;
+	event->attr.config	=
+		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS0)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS1)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS2)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS3)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS0)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS1)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS2)		|
+			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS3))		|
+		p4_config_pack_cccr(P4_CCCR_THRESHOLD(15) | P4_CCCR_COMPLEMENT		|
+			P4_CCCR_COMPARE);
+}
+
 static int p4_hw_config(struct perf_event *event)
 {
 	int cpu = get_cpu();
@@ -1179,6 +1205,7 @@ static __initconst const struct x86_pmu 
 	.cntval_bits		= ARCH_P4_CNTRVAL_BITS,
 	.cntval_mask		= ARCH_P4_CNTRVAL_MASK,
 	.max_period		= (1ULL << (ARCH_P4_CNTRVAL_BITS - 1)) - 1,
+	.hw_watchdog_config	= p4_hw_watchdog_config,
 	.hw_config		= p4_hw_config,
 	.schedule_events	= p4_pmu_schedule_events,
 	/*
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p6.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p6.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p6.c
@@ -91,6 +91,7 @@ static __initconst const struct x86_pmu 
 	.enable_all		= p6_pmu_enable_all,
 	.enable			= p6_pmu_enable_event,
 	.disable		= p6_pmu_disable_event,
+	.hw_watchdog_config	= x86_pmu_hw_watchdog_config,
 	.hw_config		= x86_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_P6_EVNTSEL0,
Index: linux-2.6.git/include/linux/perf_event.h
===================================================================
--- linux-2.6.git.orig/include/linux/perf_event.h
+++ linux-2.6.git/include/linux/perf_event.h
@@ -582,6 +582,12 @@ struct hw_perf_event {
 };
 
 /*
+ * Watchdog cycles are special on some architectures (such as Netburst)
+ * and because of that it must be unique among enum perf_hw_id.
+ */
+#define PERF_COUNT_HW_WATCHDOG_CYCLES	(PERF_COUNT_HW_MAX + 1)
+
+/*
  * hw_perf_event::state flags
  */
 #define PERF_HES_STOPPED	0x01 /* the counter is stopped */
Index: linux-2.6.git/kernel/watchdog.c
===================================================================
--- linux-2.6.git.orig/kernel/watchdog.c
+++ linux-2.6.git/kernel/watchdog.c
@@ -202,7 +202,7 @@ static int is_softlockup(unsigned long t
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static struct perf_event_attr wd_hw_attr = {
 	.type		= PERF_TYPE_HARDWARE,
-	.config		= PERF_COUNT_HW_CPU_CYCLES,
+	.config		= PERF_COUNT_HW_WATCHDOG_CYCLES,
 	.size		= sizeof(struct perf_event_attr),
 	.pinned		= 1,
 	.disabled	= 1,
