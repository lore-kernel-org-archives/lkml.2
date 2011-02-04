Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab1BDNGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 08:06:04 -0500
Received: from smtp-out.google.com ([74.125.121.67]:20971 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab1BDNF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:05:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=Trywbm8FDxaXGauE7Bd3bWdrBmhUgfGDxPIzOXVrZPAtAUmOp0Lk1oPoEq3UKD1gjr
         /I2eeaxuU45OenZVFhxw==
Message-ID: <4d4bf9b1.1252d80a.175c.20b7@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Fri, 4 Feb 2011 14:00:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        gorcunov@gmail.com, ming.m.lin@intel.com
Subject: [PATCH 1/2] perf_events: improve X86 constraint management for fixed counters
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    This patch adds a flags field to struct event_constraint. It is used
    to mark constraint which need extra work on initialization.
    
    The patch defines the X86_EVENT_CONSTRAINT_FL_ADD_GEN flag which indicates
    that the constraint mask must be dynamically adjusted for generic counters.
    In other words, the constraint is extended to include generic counters once
    their number is known. This applies to Intel x86 processors supporting the
    architectural perfmon PMU and fixed counters. Some events may support
    either a fixed counter or a generic counter. Some events only work in fixed
    counters, e.g., unhalted_reference_cycles.
    
Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4d98789..a06261a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -84,7 +84,9 @@ struct event_constraint {
 	u64	code;
 	u64	cmask;
 	int	weight;
+	int	flags;
 };
+#define X86_EVENT_CONSTRAINT_FL_ADD_GEN 0x1 /* add generic cntrs on the fly */
 
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
@@ -133,21 +135,22 @@ struct cpu_hw_events {
 	struct amd_nb		*amd_nb;
 };
 
-#define __EVENT_CONSTRAINT(c, n, m, w) {\
+#define __EVENT_CONSTRAINT(c, n, m, w, f) {\
 	{ .idxmsk64 = (n) },		\
 	.code = (c),			\
 	.cmask = (m),			\
 	.weight = (w),			\
+	.flags = (f),			\
 }
 
-#define EVENT_CONSTRAINT(c, n, m)	\
-	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n))
+#define EVENT_CONSTRAINT(c, n, m, f)	\
+	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), f)
 
 /*
  * Constraint on the Event code.
  */
 #define INTEL_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
+	EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT, 0)
 
 /*
  * Constraint on the Event code + UMask + fixed-mask
@@ -161,16 +164,18 @@ struct cpu_hw_events {
  *  The any-thread option is supported starting with v3.
  */
 #define FIXED_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, (1ULL << (32+n)), X86_RAW_EVENT_MASK)
+	EVENT_CONSTRAINT(c, (1ULL << (32+n)),	\
+			 X86_RAW_EVENT_MASK,	\
+			 X86_EVENT_CONSTRAINT_FL_ADD_GEN)
 
 /*
  * Constraint on the Event code + UMask
  */
 #define PEBS_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
+	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, 0)
 
 #define EVENT_CONSTRAINT_END		\
-	EVENT_CONSTRAINT(0, 0, 0)
+	EVENT_CONSTRAINT(0, 0, 0, 0)
 
 #define for_each_event_constraint(e, c)	\
 	for ((e) = (c); (e)->weight; (e)++)
@@ -1443,11 +1448,11 @@ static int __init init_hw_perf_events(void)
 
 	unconstrained = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
-				   0, x86_pmu.num_counters);
+				   0, x86_pmu.num_counters, 0);
 
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if (c->cmask != X86_RAW_EVENT_MASK)
+			if (!(c->flags & X86_EVENT_CONSTRAINT_FL_ADD_GEN))
 				continue;
 
 			c->idxmsk64 |= (1ULL << x86_pmu.num_counters) - 1;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index b7dcd9f..68530a4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -261,7 +261,7 @@ static void reserve_ds_buffers(void)
  */
 
 static struct event_constraint bts_constraint =
-	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_FIXED_BTS, 0);
+	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_FIXED_BTS, 0, 0);
 
 static void intel_pmu_enable_bts(u64 config)
 {
