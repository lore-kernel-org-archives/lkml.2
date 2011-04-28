Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab1D1Phh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:37:37 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46149 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab1D1Phf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:37:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=TAU0rtXWWorensXLqLQiFobrjtCO7ZWK9bm36JBph4bixvNaoNXkzF3fmRSdfQNN9C
         19fMGsTH0V8dQNwTg8qVoJM71UJNR8/ooqJ6VhFc1QYzMgGMpnWD+Sj2Tjn9SOPgkbvj
         fxpsXVIx6BsS/e1zRtMd4i3meFh5dJTm2sEBQ=
Message-ID: <4DB989B5.1030703@openvz.org>
Date: Thu, 28 Apr 2011 19:37:25 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to restriction and specifics of Netburst PMU we need a separated
event for NMI watchdog. In particular every Netburst event consume not
just a counter and config register, but also an additional ESCR register.
Since ESCR registers are grouped upon counters (i.e. if ESCR is occupied
for some event there is no room for another event to enter the room until
it's released) we need to pick up "least" used ESCR (or most available)
for nmi-watchdog purpose -- MSR_P4_CRU_ESCR2/3 was chosen.

Note that on all other PMUs which support relocation of events between
counters this event is a simple alias for PERF_COUNT_HW_CPU_CYCLES.

v2: Add a comment about non-sleeping clockticks.

N.B: An attempts to make an alternate encodings for events didn't make
situation better because we would need to track how exactly we substitute
the particular event -- hw::config knows nothing from where the event came,
from user-space as a raw event or as pre-configured general event. If it
comes as raw event we have to track every single bit of ESCR mask and find
out if new event would count exactly the same thing as the former event
was supposed to. So I found such way inconvenient for users and adding a
single code snippet seems to be a way more clean approach.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>
---

To PeterZ: Peter, I've tried various ways to implement an alternate encoding
(Don even tried one which didn't work because of ESCR conflict ;) but all them
introduced much code which makes the whole picture more complex I think and
there is no 1:1 map between even single event (initially I thought we have
something but eventually found they are not). So even new NMI-WATCHDOG event
is *not* the same as "power events" were before but they are not supposed to
be "exactly" precise in compare with cpu-clocks we use for perf top. So I think
it's acceptable trade off -- less precise events for nmi-watchdog and more
precise for perf top and friends.

Don, I put your Ack here because the only thing I've changed (in compare with
previous tested verion) is PERF_COUNT_HW_NMI_WATCHDOG = 8 (was 7 before), please
re-test it again, I've tested it already but still.

Comments are welcome as usuall ;)

 arch/x86/kernel/cpu/perf_event_amd.c   |    1 +
 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 arch/x86/kernel/cpu/perf_event_p4.c    |   18 ++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_p6.c    |    1 +
 include/linux/perf_event.h             |    1 +
 kernel/watchdog.c                      |    2 +-
 6 files changed, 23 insertions(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_amd.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_amd.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_amd.c
@@ -102,6 +102,7 @@ static const u64 amd_perfmon_event_map[]
   [PERF_COUNT_HW_CACHE_MISSES]		= 0x0081,
   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c2,
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c3,
+  [PERF_COUNT_HW_NMI_WATCHDOG]		= 0x0076,
 };

 static u64 amd_pmu_event_map(int hw_event)
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_intel.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_intel.c
@@ -34,6 +34,7 @@ static u64 intel_perfmon_event_map[PERF_
   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
+  [PERF_COUNT_HW_NMI_WATCHDOG]		= 0x003c,
 };

 static struct event_constraint intel_core_event_constraints[] __read_mostly =
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -607,6 +607,24 @@ static u64 p4_general_events[PERF_COUNT_
 		P4_ESCR_EMASK_BIT(P4_EVENT_FSB_DATA_ACTIVITY, DRDY_DRV)		|
 		P4_ESCR_EMASK_BIT(P4_EVENT_FSB_DATA_ACTIVITY, DRDY_OWN))	|
 	p4_config_pack_cccr(P4_CCCR_EDGE | P4_CCCR_COMPARE),
+
+  /*
+   * This is a specific way to count non-halted clockticks as SDM Vol.3B
+   * "30.11.2 Non-Sleep Clockticks" suggest. We set threshold and complement
+   * flag as result every tick is accounted and delivered to the counter.
+   */
+  [PERF_COUNT_HW_NMI_WATCHDOG] =
+	p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)		|
+		P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS0)		|
+		P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS1)		|
+		P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS2)		|
+		P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS3)		|
+		P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS0)		|
+		P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS1)		|
+		P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS2)		|
+		P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS3))		|
+	p4_config_pack_cccr(P4_CCCR_THRESHOLD(15) | P4_CCCR_COMPLEMENT		|
+		P4_CCCR_COMPARE),
 };

 static struct p4_event_bind *p4_config_get_bind(u64 config)
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p6.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p6.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p6.c
@@ -12,6 +12,7 @@ static const u64 p6_perfmon_event_map[]
   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x0062,
+  [PERF_COUNT_HW_NMI_WATCHDOG]		= 0x0079,
 };

 static u64 p6_pmu_event_map(int hw_event)
Index: linux-2.6.git/include/linux/perf_event.h
=====================================================================
--- linux-2.6.git.orig/include/linux/perf_event.h
+++ linux-2.6.git/include/linux/perf_event.h
@@ -53,6 +53,7 @@ enum perf_hw_id {
 	PERF_COUNT_HW_BRANCH_MISSES		= 5,
 	PERF_COUNT_HW_BUS_CYCLES		= 6,
 	PERF_COUNT_HW_STALLED_CYCLES		= 7,
+	PERF_COUNT_HW_NMI_WATCHDOG		= 8,

 	PERF_COUNT_HW_MAX,			/* non-ABI */
 };
Index: linux-2.6.git/kernel/watchdog.c
=====================================================================
--- linux-2.6.git.orig/kernel/watchdog.c
+++ linux-2.6.git/kernel/watchdog.c
@@ -191,7 +191,7 @@ static int is_softlockup(unsigned long t
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static struct perf_event_attr wd_hw_attr = {
 	.type		= PERF_TYPE_HARDWARE,
-	.config		= PERF_COUNT_HW_CPU_CYCLES,
+	.config		= PERF_COUNT_HW_NMI_WATCHDOG,
 	.size		= sizeof(struct perf_event_attr),
 	.pinned		= 1,
 	.disabled	= 1,

-- 
    Cyrill
