Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744Ab1CaVRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:17:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36958 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab1CaVRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:17:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=L/+zKro/G0A29I4b0DZcuXXVhUyacePvhg7pgw0BTPZs9HCFf7yzF/bEsp4vNJPsTv
         KFoKA/Bq0wF7VCDpLY+W7E9+42Q0UEm0BCqbVXE9zzeoxXqUJeY4iBTNBUgwi3V6WIdA
         UU0KJ+vStq0ibZro16Ntu8w8eM6oi+Kz7Msw8=
Message-ID: <4D94EF4B.6070905@gmail.com>
Date: Fri, 01 Apr 2011 01:16:59 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC] [PATCH] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of Netburst HW restriction we can't move events arbitrary
between counters and this makes 'perf top' unable to run if nmi-watchdog
is running (since both uses PERF_COUNT_HW_CPU_CYCLES but such event is
bound to run on a few counters only). So as a workaround we could count that named
non-sleeping ticks (as oprofile does) and both perf top and nmi-watchdog would co-exsist
without conflicts but kernel needs to know about such specifics -- so PERF_COUNT_HW_NMI_WATCHDOG
event is introduced. This event is an alias of PERF_COUNT_HW_CPU_CYCLES for non-P4 x86
architecture so nothing much changed I think.

Please review, I might be missing something. Also comments on idea is quite welcome since
it touches ABI part.

---
>From b86ba38cb258bd309d96aee5b7b25c69945a2b60 Mon Sep 17 00:00:00 2001
From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Sun, 27 Mar 2011 19:58:30 +0400
Subject: [PATCH] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event

Due to restriction and specifics of Netburst PMU we need
a separated event for NMI watchdog. Note that on all other
than P4 PMU cpus this event is a simple alias for PERF_COUNT_HW_CPU_CYCLES.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Lin Ming <ming.m.lin@intel.com>
Acked-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_amd.c   |    1 +
 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 arch/x86/kernel/cpu/perf_event_p4.c    |   15 +++++++++++++++
 arch/x86/kernel/cpu/perf_event_p6.c    |    1 +
 include/linux/perf_event.h             |    1 +
 kernel/watchdog.c                      |    2 +-
 6 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 461f62b..248d8d7 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -102,6 +102,7 @@ static const u64 amd_perfmon_event_map[] =
   [PERF_COUNT_HW_CACHE_MISSES]		= 0x0081,
   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c2,
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c3,
+  [PERF_COUNT_HW_NMI_WATCHDOG]		= 0x0076,
 };

 static u64 amd_pmu_event_map(int hw_event)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 8fc2b2c..53b4790 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -34,6 +34,7 @@ static const u64 intel_perfmon_event_map[] =
   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
+  [PERF_COUNT_HW_NMI_WATCHDOG]		= 0x003c,
 };

 static struct event_constraint intel_core_event_constraints[] =
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 8ff882f..ef65c94 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -557,6 +557,7 @@ static __initconst const u64 p4_hw_cache_event_ids
 };

 static u64 p4_general_events[PERF_COUNT_HW_MAX] = {
+
   /* non-halted CPU clocks */
   [PERF_COUNT_HW_CPU_CYCLES] =
 	p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_GLOBAL_POWER_EVENTS)		|
@@ -607,6 +608,20 @@ static u64 p4_general_events[PERF_COUNT_HW_MAX] = {
 		P4_ESCR_EMASK_BIT(P4_EVENT_FSB_DATA_ACTIVITY, DRDY_DRV)		|
 		P4_ESCR_EMASK_BIT(P4_EVENT_FSB_DATA_ACTIVITY, DRDY_OWN))	|
 	p4_config_pack_cccr(P4_CCCR_EDGE | P4_CCCR_COMPARE),
+
+  /* we use that named non-sleeping calls */
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
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index 20c097e..3daeb18 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -12,6 +12,7 @@ static const u64 p6_perfmon_event_map[] =
   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x0062,
+  [PERF_COUNT_HW_NMI_WATCHDOG]		= 0x0079,
 };

 static u64 p6_pmu_event_map(int hw_event)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 04d75a8..78da67d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -52,6 +52,7 @@ enum perf_hw_id {
 	PERF_COUNT_HW_BRANCH_INSTRUCTIONS	= 4,
 	PERF_COUNT_HW_BRANCH_MISSES		= 5,
 	PERF_COUNT_HW_BUS_CYCLES		= 6,
+	PERF_COUNT_HW_NMI_WATCHDOG		= 7,

 	PERF_COUNT_HW_MAX,			/* non-ABI */
 };
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 140dce7..46a849a 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -191,7 +191,7 @@ static int is_softlockup(unsigned long touch_ts)
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static struct perf_event_attr wd_hw_attr = {
 	.type		= PERF_TYPE_HARDWARE,
-	.config		= PERF_COUNT_HW_CPU_CYCLES,
+	.config		= PERF_COUNT_HW_NMI_WATCHDOG,
 	.size		= sizeof(struct perf_event_attr),
 	.pinned		= 1,
 	.disabled	= 1,
-- 
1.7.3.3

