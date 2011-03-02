Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1CBQHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:07:11 -0500
Received: from smtp-out.google.com ([74.125.121.67]:43572 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab1CBQHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:07:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=tJvdVA9yFnlMlvjvmqQCv8EQd+By+r9jc9za1IdY1e6yPtiwU9cw2OVqa4Ok3cBnvv
         rVZppNx6oOm+zwTtH+IQ==
Message-ID: <4d6e6b02.815bdf0a.637b.07a7@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 2 Mar 2011 17:05:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, ming.m.lin@intel.com,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, eranian@google.com,
        robert.richter@amd.com, acme@redhat.com
Subject: [PATCH] perf_events: update PEBS event constraints (v3)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 084b383..ddf6c4f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1024,6 +1024,7 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_core();
 
 		x86_pmu.event_constraints = intel_core2_event_constraints;
+		x86_pmu.pebs_constraints = intel_core2_pebs_event_constraints;
 		pr_cont("Core2 events, ");
 		break;
 
@@ -1036,6 +1037,7 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_nehalem_event_constraints;
+		x86_pmu.pebs_constraints = intel_nehalem_pebs_event_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		pr_cont("Nehalem events, ");
 		break;
@@ -1047,6 +1049,7 @@ static __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_atom();
 
 		x86_pmu.event_constraints = intel_gen_event_constraints;
+		x86_pmu.pebs_constraints = intel_atom_pebs_event_constraints;
 		pr_cont("Atom events, ");
 		break;
 
@@ -1059,6 +1062,8 @@ static __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_westmere_event_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
+		x86_pmu.pebs_constraints =
+				intel_westmere_pebs_event_constraints;
 		pr_cont("Westmere events, ");
 		break;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index b7dcd9f..287044d 100644
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
+	EVENT_CONSTRAINT_END
+};
+
+static struct event_constraint intel_atom_pebs_event_constraints[] = {
+	PEBS_EVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
+	PEBS_EVENT_CONSTRAINT(0x00c5, 0x1), /* MISPREDICTED_BRANCH_RETIRED */
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
 
@@ -695,20 +715,18 @@ static void intel_ds_init(void)
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
-			printk(KERN_CONT "no PEBS fmt%d%c, ", format, pebs_type);
+			printk(KERN_CONT "no PEBS fmt%d%c, ",
+			       format, pebs_type);
 			x86_pmu.pebs = 0;
-			break;
 		}
 	}
 }
