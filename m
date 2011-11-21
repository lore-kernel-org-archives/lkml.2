Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab1KUO4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:56:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:45530 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab1KUO41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:56:27 -0500
Message-Id: <20111121145337.533322271@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 15:51:16 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org,
        Michael Cree <mcree@orcon.net.nz>, Will Deacon <will.deacon@arm.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Anton Blanchard <anton@samba.org>, Eric B Munson <emunson@mgebm.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Kuo <rkuo@codeaurora.org>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()
References: <20111121145114.049265181@chello.nl>
Content-Disposition: inline; filename=perf-rdpmc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put the logic to compute the event index into a per pmu method. This
is required because the x86 rules are weird and wonderful and don't
match the capabilities of the current scheme.

AFAIK only powerpc actually has a usable userspace read of the PMCs
but I'm not at all sure anybody actually used that.

ARM looks like it cared, but I really wouldn't know, Will?

For the rest we preserve the status quo with a default function.

We probably want to provide an explicit method for sw counters and the
like so they don't try and dereference event->hw.index which is a
random field in the middle of their hrtimer structure.

Cc: Michael Cree <mcree@orcon.net.nz>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Arun Sharma <asharma@fb.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/arm/include/asm/perf_event.h            |    4 ----
 arch/arm/kernel/perf_event.c                 |   10 ++++++++++
 arch/frv/include/asm/perf_event.h            |    2 --
 arch/hexagon/include/asm/perf_event.h        |    2 --
 arch/powerpc/include/asm/perf_event_server.h |    2 --
 arch/powerpc/kernel/perf_event.c             |    6 ++++++
 arch/s390/include/asm/perf_event.h           |    1 -
 arch/x86/include/asm/perf_event.h            |    2 --
 include/linux/perf_event.h                   |    6 ++++++
 kernel/events/core.c                         |   14 +++++++++-----
 10 files changed, 31 insertions(+), 18 deletions(-)
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -679,6 +679,12 @@ struct pmu {
 	 * for each successful ->add() during the transaction.
 	 */
 	void (*cancel_txn)		(struct pmu *pmu); /* optional */
+
+	/*
+	 * Will return the value for perf_event_mmap_page::index for this event,
+	 * if no implementation is provided it will default to: event->hw.idx + 1.
+	 */
+	int (*event_idx)		(struct perf_event *event); /*optional */
 };
 
 /**
Index: linux-2.6/kernel/events/core.c
===================================================================
--- linux-2.6.orig/kernel/events/core.c
+++ linux-2.6/kernel/events/core.c
@@ -3191,10 +3191,6 @@ int perf_event_task_disable(void)
 	return 0;
 }
 
-#ifndef PERF_EVENT_INDEX_OFFSET
-# define PERF_EVENT_INDEX_OFFSET 0
-#endif
-
 static int perf_event_index(struct perf_event *event)
 {
 	if (event->hw.state & PERF_HES_STOPPED)
@@ -3203,7 +3199,7 @@ static int perf_event_index(struct perf_
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
 		return 0;
 
-	return event->hw.idx + 1 - PERF_EVENT_INDEX_OFFSET;
+	return event->pmu->event_idx(event);
 }
 
 static void calc_timer_values(struct perf_event *event,
@@ -5334,6 +5330,11 @@ static void perf_pmu_cancel_txn(struct p
 	perf_pmu_enable(pmu);
 }
 
+static int perf_event_idx_default(struct perf_event *event)
+{
+	return event->hw.idx + 1;
+}
+
 /*
  * Ensures all contexts with the same task_ctx_nr have the same
  * pmu_cpu_context too.
@@ -5523,6 +5524,9 @@ int perf_pmu_register(struct pmu *pmu, c
 		pmu->pmu_disable = perf_pmu_nop_void;
 	}
 
+	if (!pmu->event_idx)
+		pmu->event_idx = perf_event_idx_default;
+
 	list_add_rcu(&pmu->entry, &pmus);
 	ret = 0;
 unlock:
Index: linux-2.6/arch/arm/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/perf_event.h
+++ linux-2.6/arch/arm/include/asm/perf_event.h
@@ -12,10 +12,6 @@
 #ifndef __ARM_PERF_EVENT_H__
 #define __ARM_PERF_EVENT_H__
 
-/* ARM performance counters start from 1 (in the cp15 accesses) so use the
- * same indexes here for consistency. */
-#define PERF_EVENT_INDEX_OFFSET 1
-
 /* ARM perf PMU IDs for use by internal perf clients. */
 enum arm_perf_pmu_ids {
 	ARM_PERF_PMU_ID_XSCALE1	= 0,
Index: linux-2.6/arch/arm/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/perf_event.c
+++ linux-2.6/arch/arm/kernel/perf_event.c
@@ -572,6 +572,15 @@ static void armpmu_disable(struct pmu *p
 	armpmu->stop();
 }
 
+/*
+ * ARM performance counters start from 1 (in the cp15 accesses) so use the
+ * same indexes here for consistency.
+ */
+static int armpmu_event_idx(struct perf_event *event)
+{
+	return event->hw.idx;
+}
+
 static void __init armpmu_init(struct arm_pmu *armpmu)
 {
 	atomic_set(&armpmu->active_events, 0);
@@ -586,6 +595,7 @@ static void __init armpmu_init(struct ar
 		.start		= armpmu_start,
 		.stop		= armpmu_stop,
 		.read		= armpmu_read,
+		.event_idx	= armpmu_event_idx,
 	};
 }
 
Index: linux-2.6/arch/frv/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/perf_event.h
+++ linux-2.6/arch/frv/include/asm/perf_event.h
@@ -12,6 +12,4 @@
 #ifndef _ASM_PERF_EVENT_H
 #define _ASM_PERF_EVENT_H
 
-#define PERF_EVENT_INDEX_OFFSET	0
-
 #endif /* _ASM_PERF_EVENT_H */
Index: linux-2.6/arch/hexagon/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/hexagon/include/asm/perf_event.h
+++ linux-2.6/arch/hexagon/include/asm/perf_event.h
@@ -19,6 +19,4 @@
 #ifndef _ASM_PERF_EVENT_H
 #define _ASM_PERF_EVENT_H
 
-#define PERF_EVENT_INDEX_OFFSET	0
-
 #endif /* _ASM_PERF_EVENT_H */
Index: linux-2.6/arch/powerpc/include/asm/perf_event_server.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/perf_event_server.h
+++ linux-2.6/arch/powerpc/include/asm/perf_event_server.h
@@ -61,8 +61,6 @@ struct pt_regs;
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
 extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
 
-#define PERF_EVENT_INDEX_OFFSET	1
-
 /*
  * Only override the default definitions in include/linux/perf_event.h
  * if we have hardware PMU support.
Index: linux-2.6/arch/powerpc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event.c
+++ linux-2.6/arch/powerpc/kernel/perf_event.c
@@ -1187,6 +1187,11 @@ static int power_pmu_event_init(struct p
 	return err;
 }
 
+static int power_pmu_event_idx(struct perf_event *event)
+{
+	return event->hw.idx;
+}
+
 struct pmu power_pmu = {
 	.pmu_enable	= power_pmu_enable,
 	.pmu_disable	= power_pmu_disable,
@@ -1199,6 +1204,7 @@ struct pmu power_pmu = {
 	.start_txn	= power_pmu_start_txn,
 	.cancel_txn	= power_pmu_cancel_txn,
 	.commit_txn	= power_pmu_commit_txn,
+	.event_idx	= power_pmu_event_idx,
 };
 
 /*
Index: linux-2.6/arch/s390/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/perf_event.h
+++ linux-2.6/arch/s390/include/asm/perf_event.h
@@ -6,4 +6,3 @@
 
 /* Empty, just to avoid compiling error */
 
-#define PERF_EVENT_INDEX_OFFSET 0
Index: linux-2.6/arch/x86/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/perf_event.h
+++ linux-2.6/arch/x86/include/asm/perf_event.h
@@ -187,8 +187,6 @@ extern u32 get_ibs_caps(void);
 #ifdef CONFIG_PERF_EVENTS
 extern void perf_events_lapic_init(void);
 
-#define PERF_EVENT_INDEX_OFFSET			0
-
 /*
  * Abuse bit 3 of the cpu eflags register to indicate proper PEBS IP fixups.
  * This flag is otherwise unused and ABI specified to be 0, so nobody should


