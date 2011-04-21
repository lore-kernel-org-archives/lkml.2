Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab1DUUEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:04:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668Ab1DUUEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:04:50 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 4/4] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event
Date: Thu, 21 Apr 2011 11:03:23 -0400
Message-Id: <1303398203-2918-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

Due to restriction and specifics of Netburst PMU we need
a separated event for NMI watchdog. Note that on all other
than P4 PMU cpus this event is a simple alias for PERF_COUNT_HW_CPU_CYCLES.

This event is only used by x86 for now so no other archs involved.

Tested-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Don Zickus <dzickus@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Don Zickus <dzickus@redhat.com>
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
index d2326e1..92351ec 100644
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
index 2d0ac91..9e13864 100644
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
index 311b4dc..b67564d 100644
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
index 14733d4..3b6e0af 100644
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
1.7.4.2

