Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1LULs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:48:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34072 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1LULs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:48:26 -0500
Date: Wed, 21 Dec 2011 03:47:21 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-dfydxodki16lylkt3gl2j7cw@git.kernel.org>
Cc: eranian@google.com, mingo@redhat.com, dengcheng.zhu@gmail.com,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        asharma@fb.com, hpa@zytor.com, anton@samba.org,
        linux-kernel@vger.kernel.org, will.deacon@arm.com, lethal@linux-sh.org,
        emunson@mgebm.net, davem@davemloft.net, mingo@elte.hu,
        mcree@orcon.net.nz, rkuo@codeaurora.org
Reply-To: mingo@redhat.com, eranian@google.com, dengcheng.zhu@gmail.com,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        asharma@fb.com, hpa@zytor.com, anton@samba.org,
        linux-kernel@vger.kernel.org, will.deacon@arm.com, lethal@linux-sh.org,
        emunson@mgebm.net, davem@davemloft.net, rkuo@codeaurora.org,
        mingo@elte.hu, mcree@orcon.net.nz
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/fast] perf, arch: Rework perf_event_index()
Git-Commit-ID: 35edc2a5095efb189e60dc32bbb9d2663aec6d24
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 03:47:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35edc2a5095efb189e60dc32bbb9d2663aec6d24
Gitweb:     http://git.kernel.org/tip/35edc2a5095efb189e60dc32bbb9d2663aec6d24
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sun, 20 Nov 2011 20:36:02 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 11:01:07 +0100

perf, arch: Rework perf_event_index()

Put the logic to compute the event index into a per pmu method. This
is required because the x86 rules are weird and wonderful and don't
match the capabilities of the current scheme.

AFAIK only powerpc actually has a usable userspace read of the PMCs
but I'm not at all sure anybody actually used that.

ARM is restored to the default since it currently does not support
userspace access at all. And all software events are provided with a
method that reports their index as 0 (disabled).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
Link: http://lkml.kernel.org/n/tip-dfydxodki16lylkt3gl2j7cw@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/include/asm/perf_event.h            |    4 ---
 arch/frv/include/asm/perf_event.h            |    2 -
 arch/hexagon/include/asm/perf_event.h        |    2 -
 arch/powerpc/include/asm/perf_event_server.h |    2 -
 arch/powerpc/kernel/perf_event.c             |    6 +++++
 arch/s390/include/asm/perf_event.h           |    1 -
 arch/x86/include/asm/perf_event.h            |    2 -
 include/linux/perf_event.h                   |    6 +++++
 kernel/events/core.c                         |   27 +++++++++++++++++++++----
 kernel/events/hw_breakpoint.c                |    7 ++++++
 10 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
index 0f8e382..08f94d8 100644
--- a/arch/arm/include/asm/perf_event.h
+++ b/arch/arm/include/asm/perf_event.h
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
diff --git a/arch/frv/include/asm/perf_event.h b/arch/frv/include/asm/perf_event.h
index a69e015..c52ea55 100644
--- a/arch/frv/include/asm/perf_event.h
+++ b/arch/frv/include/asm/perf_event.h
@@ -12,6 +12,4 @@
 #ifndef _ASM_PERF_EVENT_H
 #define _ASM_PERF_EVENT_H
 
-#define PERF_EVENT_INDEX_OFFSET	0
-
 #endif /* _ASM_PERF_EVENT_H */
diff --git a/arch/hexagon/include/asm/perf_event.h b/arch/hexagon/include/asm/perf_event.h
index 6c2910f..8b8526b 100644
--- a/arch/hexagon/include/asm/perf_event.h
+++ b/arch/hexagon/include/asm/perf_event.h
@@ -19,6 +19,4 @@
 #ifndef _ASM_PERF_EVENT_H
 #define _ASM_PERF_EVENT_H
 
-#define PERF_EVENT_INDEX_OFFSET	0
-
 #endif /* _ASM_PERF_EVENT_H */
diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index 8f1df12..1a8093f 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -61,8 +61,6 @@ struct pt_regs;
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
 extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
 
-#define PERF_EVENT_INDEX_OFFSET	1
-
 /*
  * Only override the default definitions in include/linux/perf_event.h
  * if we have hardware PMU support.
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 10a140f..d614ab5 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1187,6 +1187,11 @@ static int power_pmu_event_init(struct perf_event *event)
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
diff --git a/arch/s390/include/asm/perf_event.h b/arch/s390/include/asm/perf_event.h
index a75f168..4eb444e 100644
--- a/arch/s390/include/asm/perf_event.h
+++ b/arch/s390/include/asm/perf_event.h
@@ -6,4 +6,3 @@
 
 /* Empty, just to avoid compiling error */
 
-#define PERF_EVENT_INDEX_OFFSET 0
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 096c975..9b922c1 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -188,8 +188,6 @@ extern u32 get_ibs_caps(void);
 #ifdef CONFIG_PERF_EVENTS
 extern void perf_events_lapic_init(void);
 
-#define PERF_EVENT_INDEX_OFFSET			0
-
 /*
  * Abuse bit 3 of the cpu eflags register to indicate proper PEBS IP fixups.
  * This flag is otherwise unused and ABI specified to be 0, so nobody should
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0885561..02545e6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -680,6 +680,12 @@ struct pmu {
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
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0ca1f64..3894309 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3208,10 +3208,6 @@ int perf_event_task_disable(void)
 	return 0;
 }
 
-#ifndef PERF_EVENT_INDEX_OFFSET
-# define PERF_EVENT_INDEX_OFFSET 0
-#endif
-
 static int perf_event_index(struct perf_event *event)
 {
 	if (event->hw.state & PERF_HES_STOPPED)
@@ -3220,7 +3216,7 @@ static int perf_event_index(struct perf_event *event)
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
 		return 0;
 
-	return event->hw.idx + 1 - PERF_EVENT_INDEX_OFFSET;
+	return event->pmu->event_idx(event);
 }
 
 static void calc_timer_values(struct perf_event *event,
@@ -4992,6 +4988,11 @@ static int perf_swevent_init(struct perf_event *event)
 	return 0;
 }
 
+static int perf_swevent_event_idx(struct perf_event *event)
+{
+	return 0;
+}
+
 static struct pmu perf_swevent = {
 	.task_ctx_nr	= perf_sw_context,
 
@@ -5001,6 +5002,8 @@ static struct pmu perf_swevent = {
 	.start		= perf_swevent_start,
 	.stop		= perf_swevent_stop,
 	.read		= perf_swevent_read,
+
+	.event_idx	= perf_swevent_event_idx,
 };
 
 #ifdef CONFIG_EVENT_TRACING
@@ -5087,6 +5090,8 @@ static struct pmu perf_tracepoint = {
 	.start		= perf_swevent_start,
 	.stop		= perf_swevent_stop,
 	.read		= perf_swevent_read,
+
+	.event_idx	= perf_swevent_event_idx,
 };
 
 static inline void perf_tp_register(void)
@@ -5306,6 +5311,8 @@ static struct pmu perf_cpu_clock = {
 	.start		= cpu_clock_event_start,
 	.stop		= cpu_clock_event_stop,
 	.read		= cpu_clock_event_read,
+
+	.event_idx	= perf_swevent_event_idx,
 };
 
 /*
@@ -5378,6 +5385,8 @@ static struct pmu perf_task_clock = {
 	.start		= task_clock_event_start,
 	.stop		= task_clock_event_stop,
 	.read		= task_clock_event_read,
+
+	.event_idx	= perf_swevent_event_idx,
 };
 
 static void perf_pmu_nop_void(struct pmu *pmu)
@@ -5405,6 +5414,11 @@ static void perf_pmu_cancel_txn(struct pmu *pmu)
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
@@ -5594,6 +5608,9 @@ got_cpu_context:
 		pmu->pmu_disable = perf_pmu_nop_void;
 	}
 
+	if (!pmu->event_idx)
+		pmu->event_idx = perf_event_idx_default;
+
 	list_add_rcu(&pmu->entry, &pmus);
 	ret = 0;
 unlock:
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index b7971d6..b0309f7 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -613,6 +613,11 @@ static void hw_breakpoint_stop(struct perf_event *bp, int flags)
 	bp->hw.state = PERF_HES_STOPPED;
 }
 
+static int hw_breakpoint_event_idx(struct perf_event *bp)
+{
+	return 0;
+}
+
 static struct pmu perf_breakpoint = {
 	.task_ctx_nr	= perf_sw_context, /* could eventually get its own */
 
@@ -622,6 +627,8 @@ static struct pmu perf_breakpoint = {
 	.start		= hw_breakpoint_start,
 	.stop		= hw_breakpoint_stop,
 	.read		= hw_breakpoint_pmu_read,
+
+	.event_idx	= hw_breakpoint_event_idx,
 };
 
 int __init init_hw_breakpoint(void)
