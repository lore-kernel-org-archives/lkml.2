Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569Ab1CDLx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:53:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:41965 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab1CDLx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:53:26 -0500
Date: Fri, 4 Mar 2011 11:52:57 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4d6e6b02.815bdf0a.637b.07a7@mx.google.com>
References: <4d6e6b02.815bdf0a.637b.07a7@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Update PEBS event constraints
Message-ID: <tip-17e3162972cbb9796035fff1e2fd30669b0eef65@git.kernel.org>
Git-Commit-ID: 17e3162972cbb9796035fff1e2fd30669b0eef65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Mar 2011 11:52:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  17e3162972cbb9796035fff1e2fd30669b0eef65
Gitweb:     http://git.kernel.org/tip/17e3162972cbb9796035fff1e2fd30669b0eef65
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 2 Mar 2011 17:05:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Mar 2011 11:32:52 +0100

perf_events: Update PEBS event constraints

This patch updates PEBS event constraints for Intel Atom, Nehalem, Westmere.

This patch also reorganizes the PEBS format/constraint detection code. It is
now based on processor model and not PEBS format. Two processors may use the
same PEBS format without have the same list of PEBS events.

In this second version, we simplified the initialization of the PEBS
constraints by leveraging the existing switch() statement in perf_event_intel.c.
We also renamed the constraint tables to be more consistent with regular
constraints.

In this 3rd version, we drop BR_INST_RETIRED.MISPRED from Intel Atom as it does
not seem to work. Use MISPREDICTED_BRANCH_RETIRED instead. Also add FP_ASSIST.*
o both Intel Nehalem and Westmere. I misssed those in the earlier patches.
Events were tested using libpfm4 perf_examples.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4d6e6b02.815bdf0a.637b.07a7@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c    |    4 ++
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   59 ++++++++++++++++++----------
 2 files changed, 42 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index ba8aad1..c3ce053 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1137,6 +1137,7 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_core();
 
 		x86_pmu.event_constraints = intel_core2_event_constraints;
+		x86_pmu.pebs_constraints = intel_core2_pebs_event_constraints;
 		pr_cont("Core2 events, ");
 		break;
 
@@ -1149,6 +1150,7 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_nehalem_event_constraints;
+		x86_pmu.pebs_constraints = intel_nehalem_pebs_event_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		pr_cont("Nehalem events, ");
 		break;
@@ -1160,6 +1162,7 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_atom();
 
 		x86_pmu.event_constraints = intel_gen_event_constraints;
+		x86_pmu.pebs_constraints = intel_atom_pebs_event_constraints;
 		pr_cont("Atom events, ");
 		break;
 
@@ -1172,6 +1175,7 @@ static __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_westmere_event_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
+		x86_pmu.pebs_constraints = intel_westmere_pebs_event_constraints;
 		pr_cont("Westmere events, ");
 		break;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 8251998..b95c66a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -361,30 +361,50 @@ static int intel_pmu_drain_bts_buffer(void)
 /*
  * PEBS
  */
-
-static struct event_constraint intel_core_pebs_events[] = {
-	PEBS_EVENT_CONSTRAINT(0x00c0, 0x1), /* INSTR_RETIRED.ANY */
+static struct event_constraint intel_core2_pebs_event_constraints[] = {
+	PEBS_EVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
 	PEBS_EVENT_CONSTRAINT(0xfec1, 0x1), /* X87_OPS_RETIRED.ANY */
 	PEBS_EVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
 	PEBS_EVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
-	PEBS_EVENT_CONSTRAINT(0x01cb, 0x1), /* MEM_LOAD_RETIRED.L1D_MISS */
-	PEBS_EVENT_CONSTRAINT(0x02cb, 0x1), /* MEM_LOAD_RETIRED.L1D_LINE_MISS */
-	PEBS_EVENT_CONSTRAINT(0x04cb, 0x1), /* MEM_LOAD_RETIRED.L2_MISS */
-	PEBS_EVENT_CONSTRAINT(0x08cb, 0x1), /* MEM_LOAD_RETIRED.L2_LINE_MISS */
-	PEBS_EVENT_CONSTRAINT(0x10cb, 0x1), /* MEM_LOAD_RETIRED.DTLB_MISS */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),  /* MEM_LOAD_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_nehalem_pebs_events[] = {
-	PEBS_EVENT_CONSTRAINT(0x00c0, 0xf), /* INSTR_RETIRED.ANY */
-	PEBS_EVENT_CONSTRAINT(0xfec1, 0xf), /* X87_OPS_RETIRED.ANY */
-	PEBS_EVENT_CONSTRAINT(0x00c5, 0xf), /* BR_INST_RETIRED.MISPRED */
-	PEBS_EVENT_CONSTRAINT(0x1fc7, 0xf), /* SIMD_INST_RETURED.ANY */
-	PEBS_EVENT_CONSTRAINT(0x01cb, 0xf), /* MEM_LOAD_RETIRED.L1D_MISS */
-	PEBS_EVENT_CONSTRAINT(0x02cb, 0xf), /* MEM_LOAD_RETIRED.L1D_LINE_MISS */
-	PEBS_EVENT_CONSTRAINT(0x04cb, 0xf), /* MEM_LOAD_RETIRED.L2_MISS */
-	PEBS_EVENT_CONSTRAINT(0x08cb, 0xf), /* MEM_LOAD_RETIRED.L2_LINE_MISS */
-	PEBS_EVENT_CONSTRAINT(0x10cb, 0xf), /* MEM_LOAD_RETIRED.DTLB_MISS */
+static struct event_constraint intel_atom_pebs_event_constraints[] = {
+	PEBS_EVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
+	PEBS_EVENT_CONSTRAINT(0x00c5, 0x1), /* MISPREDICTED_BRANCH_RETIRED */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),  /* MEM_LOAD_RETIRED.* */
+	EVENT_CONSTRAINT_END
+};
+
+static struct event_constraint intel_nehalem_pebs_event_constraints[] = {
+	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),  /* MEM_INST_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),  /* MEM_UNCORE_RETIRED.* */
+	PEBS_EVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
+	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),  /* INST_RETIRED.ANY */
+	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),  /* UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),  /* BR_INST_RETIRED.* */
+	PEBS_EVENT_CONSTRAINT(0x02c5, 0xf), /* BR_MISP_RETIRED.NEAR_CALL */
+	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),  /* SSEX_UOPS_RETIRED.* */
+	PEBS_EVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),  /* MEM_LOAD_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),  /* FP_ASSIST.* */
+	EVENT_CONSTRAINT_END
+};
+
+static struct event_constraint intel_westmere_pebs_event_constraints[] = {
+	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),  /* MEM_INST_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),  /* MEM_UNCORE_RETIRED.* */
+	PEBS_EVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
+	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),  /* INSTR_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),  /* UOPS_RETIRED.* */
+
+	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),  /* BR_INST_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),  /* BR_MISP_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),  /* SSEX_UOPS_RETIRED.* */
+	PEBS_EVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),  /* MEM_LOAD_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),  /* FP_ASSIST.* */
 	EVENT_CONSTRAINT_END
 };
 
@@ -733,20 +753,17 @@ static void intel_ds_init(void)
 			printk(KERN_CONT "PEBS fmt0%c, ", pebs_type);
 			x86_pmu.pebs_record_size = sizeof(struct pebs_record_core);
 			x86_pmu.drain_pebs = intel_pmu_drain_pebs_core;
-			x86_pmu.pebs_constraints = intel_core_pebs_events;
 			break;
 
 		case 1:
 			printk(KERN_CONT "PEBS fmt1%c, ", pebs_type);
 			x86_pmu.pebs_record_size = sizeof(struct pebs_record_nhm);
 			x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
-			x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
 			break;
 
 		default:
 			printk(KERN_CONT "no PEBS fmt%d%c, ", format, pebs_type);
 			x86_pmu.pebs = 0;
-			break;
 		}
 	}
 }
