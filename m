Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2KUMvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:51:37 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35056 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2KUMve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:51:34 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v3 03/19] perf/x86: add flags to event constraints
Date: Wed, 21 Nov 2012 13:49:29 +0100
Message-Id: <1353502185-26521-4-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353502185-26521-1-git-send-email-eranian@google.com>
References: <1353502185-26521-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a flags field to each event constraint.
It can be used to store event specific features which can
then later be used by scheduling code or low-level x86 code.

The flags are propagated into event->hw.flags during the
get_event_constraint() call. They are cleared during the
put_event_constraint() call.

This mechanism is going to be used by the PEBS-LL patches.
It avoids defining yet another table to hold event specific
information.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c              |    2 +-
 arch/x86/kernel/cpu/perf_event.h              |    8 +++++---
 arch/x86/kernel/cpu/perf_event_intel.c        |    5 ++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c     |    4 +++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    2 +-
 include/linux/perf_event.h                    |    1 +
 6 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 198d74f..1dbd9b1 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1493,7 +1493,7 @@ static int __init init_hw_perf_events(void)
 
 	unconstrained = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
-				   0, x86_pmu.num_counters, 0);
+				   0, x86_pmu.num_counters, 0, 0);
 
 	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
 	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3f4380c..3f10cfe 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -59,6 +59,7 @@ struct event_constraint {
 	u64	cmask;
 	int	weight;
 	int	overlap;
+	int	flags;
 };
 
 struct amd_nb {
@@ -170,16 +171,17 @@ struct cpu_hw_events {
 	void				*kfree_on_online;
 };
 
-#define __EVENT_CONSTRAINT(c, n, m, w, o) {\
+#define __EVENT_CONSTRAINT(c, n, m, w, o, f) {\
 	{ .idxmsk64 = (n) },		\
 	.code = (c),			\
 	.cmask = (m),			\
 	.weight = (w),			\
 	.overlap = (o),			\
+	.flags = f,			\
 }
 
 #define EVENT_CONSTRAINT(c, n, m)	\
-	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 0)
+	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 0, 0)
 
 /*
  * The overlap flag marks event constraints with overlapping counter
@@ -203,7 +205,7 @@ struct cpu_hw_events {
  * and its counter masks must be kept at a minimum.
  */
 #define EVENT_CONSTRAINT_OVERLAP(c, n, m)	\
-	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 1)
+	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 1, 0)
 
 /*
  * Constraint on the Event code.
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 93b9e11..57d6527 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1367,8 +1367,10 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if ((event->hw.config & c->cmask) == c->code)
+			if ((event->hw.config & c->cmask) == c->code) {
+				event->hw.flags |= c->flags;
 				return c;
+			}
 		}
 	}
 
@@ -1413,6 +1415,7 @@ intel_put_shared_regs_event_constraints(struct cpu_hw_events *cpuc,
 static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
 					struct perf_event *event)
 {
+	event->hw.flags = 0;
 	intel_put_shared_regs_event_constraints(cpuc, event);
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 826054a..f30d85b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -430,8 +430,10 @@ struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 
 	if (x86_pmu.pebs_constraints) {
 		for_each_event_constraint(c, x86_pmu.pebs_constraints) {
-			if ((event->hw.config & c->cmask) == c->code)
+			if ((event->hw.config & c->cmask) == c->code) {
+				event->hw.flags |= c->flags;
 				return c;
+			}
 		}
 	}
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 3cf3d97..cc39e64 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2438,7 +2438,7 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
 
 	type->unconstrainted = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, (1ULL << type->num_counters) - 1,
-				0, type->num_counters, 0);
+				0, type->num_counters, 0, 0);
 
 	for (i = 0; i < type->num_boxes; i++) {
 		pmus[i].func_id = -1;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6bfb2faa..484cfbc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -128,6 +128,7 @@ struct hw_perf_event {
 			int		event_base_rdpmc;
 			int		idx;
 			int		last_cpu;
+			int		flags;
 
 			struct hw_perf_event_extra extra_reg;
 			struct hw_perf_event_extra branch_reg;
-- 
1.7.9.5

