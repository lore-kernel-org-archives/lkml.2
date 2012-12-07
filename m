Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511Ab2LGKf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 05:35:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:43941 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932509Ab2LGKfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 05:35:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,236,1355126400"; 
   d="scan'208";a="260413395"
From: markus.t.metzger@intel.com
To: mingo@redhat.com, mingo@elte.hu
Cc: markus.t.metzger@intel.com, linux-kernel@vger.kernel.org,
        Mark Kettenis <kettenis@gnu.org>, Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, gdb-patches@sourceware.org
Subject: [PATCH] x86, perf, bts: disable BTS from Nehalem to Ivy Bridge
Date: Fri,  7 Dec 2012 11:35:11 +0100
Message-Id: <1354876511-25294-1-git-send-email-markus.t.metzger@intel.com>
X-Mailer: git-send-email 1.7.0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Metzger <markus.t.metzger@intel.com>

Starting with Nehalem, the BTS "from" information may in some cases be
incorrect (AAJ122).

This has been detected while adding branch tracing support to gdb, where it
results in sporadic test fails.

Disable BTS support on Nehalem, Westmere, Sandy Bridge, and Ivy Bridge.

CC: Mark Kettenis <kettenis@gnu.org>
CC: Pedro Alves <palves@redhat.com>
CC: Jan Kratochvil <jan.kratochvil@redhat.com>
CC: gdb-patches@sourceware.org
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 6bca492..e72aac9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1893,6 +1893,16 @@ static __init void intel_nehalem_quirk(void)
 	}
 }
 
+static __init void intel_disable_bts(void)
+{
+	/*
+	 * Erratum AAJ122: LBR, BTM, or BTS records may have incorrect branch
+	 * "from" information afer an EIST transition, T-states, C1E, or
+	 * Adaptive Thermal Throttling.
+	 */
+	x86_pmu.bts = 0;
+}
+
 __init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
@@ -2003,6 +2013,7 @@ __init int intel_pmu_init(void)
 			X86_CONFIG(.event=0xb1, .umask=0x3f, .inv=1, .cmask=1);
 
 		x86_add_quirk(intel_nehalem_quirk);
+		intel_disable_bts();
 
 		pr_cont("Nehalem events, ");
 		break;
@@ -2042,6 +2053,7 @@ __init int intel_pmu_init(void)
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
 			X86_CONFIG(.event=0xb1, .umask=0x3f, .inv=1, .cmask=1);
 
+		intel_disable_bts();
 		pr_cont("Westmere events, ");
 		break;
 
@@ -2070,6 +2082,7 @@ __init int intel_pmu_init(void)
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
 			X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);
 
+		intel_disable_bts();
 		pr_cont("SandyBridge events, ");
 		break;
 	case 58: /* IvyBridge */
@@ -2092,6 +2105,7 @@ __init int intel_pmu_init(void)
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
 			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
 
+		intel_disable_bts();
 		pr_cont("IvyBridge events, ");
 		break;
 
-- 
1.7.1

