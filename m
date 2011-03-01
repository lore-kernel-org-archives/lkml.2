Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab1CAOu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:50:28 -0500
Received: from smtp-out.google.com ([74.125.121.67]:28298 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507Ab1CAOuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:50:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=uVg+h51WG8Y/gWZoM7w+xu+fxRC1PUMAJxSBfQwK3FfV3u2n/7iZ3UoDsT6d8ZNU6C
         kFVOe0tGcdkX2GBEdHjg==
Message-ID: <4d6d079f.9104df0a.5a71.ffffda78@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 1 Mar 2011 15:50:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, ming.m.lin@intel.com,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, eranian@google.com,
        robert.richter@amd.com, acme@redhat.com
Subject: [PATCH] perf_events: update PEBS event constraints
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates PEBS event constraints for Intel Atom, Nehalem, Westmere.

This patch also reorganizes the PEBS format/constraint detection code. It is
now based on processor model and not PEBS format. Two processors may use the
same PEBS format without have the same list of PEBS events.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index b7dcd9f..9b7ca73 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -361,30 +361,49 @@ static int intel_pmu_drain_bts_buffer(void)
 /*
  * PEBS
  */
-
 static struct event_constraint intel_core_pebs_events[] = {
 	PEBS_EVENT_CONSTRAINT(0x00c0, 0x1), /* INSTR_RETIRED.ANY */
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
+static struct event_constraint intel_atom_pebs_events[] = {
+	PEBS_EVENT_CONSTRAINT(0x00c0, 0x1), /* INSTR_RETIRED.ANY */
+	PEBS_EVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
+	PEBS_EVENT_CONSTRAINT(0x0ac4, 0x1), /* BR_INST_RETIRED.MISPRED */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),  /* MEM_LOAD_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
 static struct event_constraint intel_nehalem_pebs_events[] = {
-	PEBS_EVENT_CONSTRAINT(0x00c0, 0xf), /* INSTR_RETIRED.ANY */
-	PEBS_EVENT_CONSTRAINT(0xfec1, 0xf), /* X87_OPS_RETIRED.ANY */
-	PEBS_EVENT_CONSTRAINT(0x00c5, 0xf), /* BR_INST_RETIRED.MISPRED */
-	PEBS_EVENT_CONSTRAINT(0x1fc7, 0xf), /* SIMD_INST_RETURED.ANY */
-	PEBS_EVENT_CONSTRAINT(0x01cb, 0xf), /* MEM_LOAD_RETIRED.L1D_MISS */
-	PEBS_EVENT_CONSTRAINT(0x02cb, 0xf), /* MEM_LOAD_RETIRED.L1D_LINE_MISS */
-	PEBS_EVENT_CONSTRAINT(0x04cb, 0xf), /* MEM_LOAD_RETIRED.L2_MISS */
-	PEBS_EVENT_CONSTRAINT(0x08cb, 0xf), /* MEM_LOAD_RETIRED.L2_LINE_MISS */
-	PEBS_EVENT_CONSTRAINT(0x10cb, 0xf), /* MEM_LOAD_RETIRED.DTLB_MISS */
+	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),  /* MEM_INST_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),  /* MEM_UNCORE_RETIRED.* */
+	PEBS_EVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
+	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),  /* INST_RETIRED.ANY */
+	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),  /* UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0x00c4, 0xf),/* BR_INST_RETIRED.* */
+	PEBS_EVENT_CONSTRAINT(0x02c5, 0xf), /* BR_MISP_RETIRED.NEAR_CALL */
+	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),  /* SSEX_UOPS_RETIRED.* */
+	PEBS_EVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),  /* MEM_LOAD_RETIRED.* */
+	EVENT_CONSTRAINT_END
+};
+
+static struct event_constraint intel_westmere_pebs_events[] = {
+	INTEL_EVENT_CONSTRAINT(0x0b, 0xf), /* MEM_INST_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0x0f, 0xf), /* MEM_UNCORE_RETIRED.* */
+	PEBS_EVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
+	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),  /* INSTR_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),  /* UOPS_RETIRED.* */
+
+	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),  /* BR_INST_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),  /* BR_MISP_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),  /* SSEX_UOPS_RETIRED.* */
+	PEBS_EVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),  /* MEM_LOAD_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
@@ -676,6 +695,55 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
  * BTS, PEBS probe and setup
  */
 
+static void intel_ds_init_pebs_constraints(void)
+{
+	/*
+	 * we only know hwo to deal with Family 6
+	 */
+	if (boot_cpu_data.x86 != 6) {
+		x86_pmu.pebs = 0;
+		return;
+	}
+
+	switch (boot_cpu_data.x86_model) {
+	case 14: /* 65 nm core solo/duo, "Yonah" */
+		/* do not have PEBS */
+		x86_pmu.pebs = 0;
+		break;
+
+	case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
+	case 22: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
+	case 23: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
+	case 29: /* six-core 45 nm xeon "Dunnington" */
+		x86_pmu.pebs_constraints = intel_core_pebs_events;
+		pr_cont("(Core2), ");
+		break;
+
+	case 26: /* 45 nm nehalem, "Bloomfield" */
+	case 30: /* 45 nm nehalem, "Lynnfield" */
+	case 46: /* 45 nm nehalem-ex, "Beckton" */
+		x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
+		pr_cont("(Nehalem), ");
+		break;
+
+	case 28: /* Atom */
+		x86_pmu.pebs_constraints = intel_atom_pebs_events;
+		pr_cont("(Atom), ");
+		break;
+
+	case 37: /* 32 nm nehalem, "Clarkdale" */
+	case 44: /* 32 nm nehalem, "Gulftown" */
+		x86_pmu.pebs_constraints = intel_westmere_pebs_events;
+		pr_cont("(Westmere), ");
+		break;
+
+	default:
+		printk(KERN_CONT "PEBS not yet supported for model %d,",
+		       boot_cpu_data.x86_model);
+		x86_pmu.pebs = 0;
+	}
+}
+
 static void intel_ds_init(void)
 {
 	/*
@@ -692,24 +760,24 @@ static void intel_ds_init(void)
 
 		switch (format) {
 		case 0:
-			printk(KERN_CONT "PEBS fmt0%c, ", pebs_type);
+			printk(KERN_CONT "PEBS fmt0%c ", pebs_type);
 			x86_pmu.pebs_record_size = sizeof(struct pebs_record_core);
 			x86_pmu.drain_pebs = intel_pmu_drain_pebs_core;
-			x86_pmu.pebs_constraints = intel_core_pebs_events;
 			break;
 
 		case 1:
-			printk(KERN_CONT "PEBS fmt1%c, ", pebs_type);
+			printk(KERN_CONT "PEBS fmt1%c ", pebs_type);
 			x86_pmu.pebs_record_size = sizeof(struct pebs_record_nhm);
 			x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
-			x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
 			break;
 
 		default:
-			printk(KERN_CONT "no PEBS fmt%d%c, ", format, pebs_type);
+			printk(KERN_CONT "no PEBS fmt%d%c\n",
+			       format, pebs_type);
 			x86_pmu.pebs = 0;
-			break;
+			return;
 		}
+		intel_ds_init_pebs_constraints();
 	}
 }
 
