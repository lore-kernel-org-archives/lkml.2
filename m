Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab1BDNGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 08:06:16 -0500
Received: from smtp-out.google.com ([216.239.44.51]:14102 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab1BDNGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:06:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=V9BAX5+2ESpBc8vh5GuOCl7wpRC18IhOSJq0ZaGVpMBZGm/nq/f47eTUG01SfceD9t
         8yIjo46Cb2qqgzZbAvxA==
Message-ID: <4d4bf9b6.c89cd80a.3eab.20e0@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Fri, 4 Feb 2011 14:00:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        gorcunov@gmail.com, ming.m.lin@intel.com
Subject: [PATCH 1/2] perf_events: add support for Intel fixed counter 2
    This patch adds support for the unhalted_reference_cycles
    event which measures reference cycles, i.e., elapsed cycles
    at the nominal clock speed of the CPU. This event can only
    be measured by fixed counter 2.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Unhalted_reference_cycles is a useful event because it is not
    impacted by Turbo Mode or frequency scaling. It maintains a
    constant correlation to time and thus TSC. Furthermore, when
    the NMI watchdog is active, the kernel commandeers one counter
    to measure unhalted_core_cycles. With the patch, users get
    a cycle-capable counter back.

    The issue is that this architected event has an encoding
    of 0x013c which is identical to that of cpu_clk_unhalted:ref_p
    (or bus) yet the two events count cycles at a different rate.

    Consequently, the event code 0x013c in itself is not enough to
    disambiguate the two events. Up until now, perf_events would only
    put this event code on a generic counter and thus measure bus cycles.

    This patch introduces a custom encoding to disambiguate the two events.
    When a user passes the event code 0xff3c, the kernel interprets it as
    unhalted_reference_cycles and programs it ONLY on fixed counter 2.

    This problem is found on all Intel processors implementing fixed counters.

    The example below shows the difference between unhalted_reference_cycles
    and cpu_clk_unhalted:bus:

    $ task -e unhalted_reference_cycles,cpu_clk_unhalted:bus noploop 1
    PERF[type=4 val=0x53ff3c e_u=0 e_k=0 e_hv=1 precise=0] UNHALTED_REFERENCE_CYCLES
    PERF[type=4 val=0x53013c e_u=0 e_k=0 e_hv=1 precise=0] CPU_CLK_UNHALTED:BUS
    noploop for 1 seconds

    2,393,293,680 unhalted_reference_cycles (0.00% scaling)
      265,921,520 cpu_clk_unhalted:bus (0.00% scaling)

    This is on a 2.4GHz Intel Core machine. Bus speed is clearly 266Mhz.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index a06261a..d4e78c7 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -169,6 +169,12 @@ struct cpu_hw_events {
 			 X86_EVENT_CONSTRAINT_FL_ADD_GEN)
 
 /*
+ * only one specific fixed counter
+ */
+#define FIXED_ONLY_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, (1ULL << (32+n)), X86_RAW_EVENT_MASK, 0)
+
+/*
  * Constraint on the Event code + UMask
  */
 #define PEBS_EVENT_CONSTRAINT(c, n)	\
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 008835c..82f3962 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -30,11 +30,24 @@ static struct event_constraint intel_core2_event_constraints[] =
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
 	/*
-	 * Core2 has Fixed Counter 2 listed as CPU_CLK_UNHALTED.REF and event
-	 * 0x013c as CPU_CLK_UNHALTED.BUS and specifies there is a fixed
-	 * ratio between these counters.
+	 * Fixed Counter 2 counts UNHALTED_REFERENCE_CYCLES at the
+	 * CPU nominal frequency. The encoding for this architected
+	 * event is 0x013c. However, when measured on a generic counter
+	 * it counts cycles at a different fixed clock rate. It is then
+	 * called CPU_CLK_UNHALTED.BUS.
+	 *
+	 * To disambiguate between the two events, we use a custom
+	 * encoding:
+	 * 0x013c (official): CPU_CLK_UNHALTED.BUS, any generic counters
+	 * 0xff3c (pseudo)  : UNHALTED_REFERENCE_CYCLES, fixed counter 2 only
+	 *
+	 * 0xff3c is a pseudo event encoding. There is no risks of measuring
+	 * bogus events because this encoding is restricted to fixed counter 2
+	 * which, by construction, does not programming an event code.
+	 * It is unlikely this encoding will ever be used for another generic
+	 * event. 0x3c will remain a cycle event code because it's architected.
 	 */
-	/* FIXED_EVENT_CONSTRAINT(0x013c, 2),  CPU_CLK_UNHALTED.REF */
+	FIXED_ONLY_CONSTRAINT(0xff3c, 2),  /* UNHALTED_REFERENCE_CYCLES */
 	INTEL_EVENT_CONSTRAINT(0x10, 0x1), /* FP_COMP_OPS_EXE */
 	INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
 	INTEL_EVENT_CONSTRAINT(0x12, 0x2), /* MUL */
@@ -52,7 +65,11 @@ static struct event_constraint intel_nehalem_event_constraints[] =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
-	/* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
+	/*
+	 * See comment above in intel_core2_event_constraint[] for
+	 * an explanation of UNHALTED_REFERENCE_CYCLES
+	 */
+	FIXED_ONLY_CONSTRAINT(0xff3c, 2),  /* UNHALTED_REFERENCE_CYCLES */
 	INTEL_EVENT_CONSTRAINT(0x40, 0x3), /* L1D_CACHE_LD */
 	INTEL_EVENT_CONSTRAINT(0x41, 0x3), /* L1D_CACHE_ST */
 	INTEL_EVENT_CONSTRAINT(0x42, 0x3), /* L1D_CACHE_LOCK */
@@ -68,7 +85,11 @@ static struct event_constraint intel_westmere_event_constraints[] =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
-	/* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
+	/*
+	 * See comment above in intel_core2_event_constraint[] for
+	 * an explanation of UNHALTED_REFERENCE_CYCLES
+	 */
+	FIXED_ONLY_CONSTRAINT(0xff3c, 2),  /* UNHALTED_REFERENCE_CYCLES */
 	INTEL_EVENT_CONSTRAINT(0x51, 0x3), /* L1D */
 	INTEL_EVENT_CONSTRAINT(0x60, 0x1), /* OFFCORE_REQUESTS_OUTSTANDING */
 	INTEL_EVENT_CONSTRAINT(0x63, 0x3), /* CACHE_LOCK_CYCLES */
@@ -80,7 +101,11 @@ static struct event_constraint intel_gen_event_constraints[] =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
-	/* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
+	/*
+	 * See comment above in intel_core2_event_constraint[] for
+	 * an explanation of UNHALTED_REFERENCE_CYCLES
+	 */
+	FIXED_ONLY_CONSTRAINT(0xff3c, 2),  /* UNHALTED_REFERENCE_CYCLES */
 	EVENT_CONSTRAINT_END
 };
 
