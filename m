Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab0DWFOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:14:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34681 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab0DWFN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:13:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=WSxTb7SKEhWxNPdDlQlBeLE4Ll5NtWTyhTomySDrh1gyE/UPx+WdJROKPhHeqA7B3G
         4IbBfUtIfMVgPS18P4PCWRLNBYPdjjEciAtJCW9gdt/7/OAFV0eNrmj+2DMePwZpMhtJ
         9+Z2G9MVGvAbmWPyTZU+ahUlO3Dgj9hWU0x7U=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Will Deacon <will.deacon@arm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 5/6] hw-breakpoints: Handle breakpoint weight in allocation constraints
Date: Fri, 23 Apr 2010 07:13:58 +0200
Message-Id: <1271999639-23605-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1271999639-23605-1-git-send-regression-fweisbec@gmail.com>
References: <1271999639-23605-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on their nature and on what an arch supports, breakpoints
may consume more than one address register. For example a simple
absolute address match usually only requires one address register.
But an address range match may consume two registers.

Currently our slot allocation constraints, that tend to reflect the
limited arch's resources, always consider that a breakpoint consumes
one slot.

Then provide a way for archs to tell us the weight of a breakpoint
through a new hw_breakpoint_weight() helper. This weight will be
computed against the generic allocation constraints instead of
a constant value.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: K. Prasad <prasad@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/hw_breakpoint.c |   63 ++++++++++++++++++++++++++++++++++-------------
 1 files changed, 45 insertions(+), 18 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 8ead134..974498b 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -77,6 +77,11 @@ struct bp_busy_slots {
 /* Serialize accesses to the above constraints */
 static DEFINE_MUTEX(nr_bp_mutex);
 
+__weak int hw_breakpoint_weight(struct perf_event *bp)
+{
+	return 1;
+}
+
 static inline enum bp_type_idx find_slot_idx(struct perf_event *bp)
 {
 	if (bp->attr.bp_type & HW_BREAKPOINT_RW)
@@ -124,7 +129,7 @@ static int task_bp_pinned(struct task_struct *tsk, enum bp_type_idx type)
 	list_for_each_entry(bp, list, event_entry) {
 		if (bp->attr.type == PERF_TYPE_BREAKPOINT)
 			if (find_slot_idx(bp) == type)
-				count++;
+				count += hw_breakpoint_weight(bp);
 	}
 
 	raw_spin_unlock_irqrestore(&ctx->lock, flags);
@@ -174,25 +179,40 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 }
 
 /*
+ * For now, continue to consider flexible as pinned, until we can
+ * ensure no flexible event can ever be scheduled before a pinned event
+ * in a same cpu.
+ */
+static void
+fetch_this_slot(struct bp_busy_slots *slots, int weight)
+{
+	slots->pinned += weight;
+}
+
+/*
  * Add a pinned breakpoint for the given task in our constraint table
  */
 static void toggle_bp_task_slot(struct task_struct *tsk, int cpu, bool enable,
-				enum bp_type_idx type)
+				enum bp_type_idx type, int weight)
 {
 	unsigned int *tsk_pinned;
-	int count = 0;
+	int old_count = 0;
+	int old_idx = 0;
+	int idx = 0;
 
-	count = task_bp_pinned(tsk, type);
+	old_count = task_bp_pinned(tsk, type);
+	old_idx = old_count - 1;
+	idx = old_idx + weight;
 
 	tsk_pinned = per_cpu(nr_task_bp_pinned[type], cpu);
 	if (enable) {
-		tsk_pinned[count]++;
-		if (count > 0)
-			tsk_pinned[count-1]--;
+		tsk_pinned[idx]++;
+		if (old_count > 0)
+			tsk_pinned[old_idx]--;
 	} else {
-		tsk_pinned[count]--;
-		if (count > 0)
-			tsk_pinned[count-1]++;
+		tsk_pinned[idx]--;
+		if (old_count > 0)
+			tsk_pinned[old_idx]++;
 	}
 }
 
@@ -200,7 +220,8 @@ static void toggle_bp_task_slot(struct task_struct *tsk, int cpu, bool enable,
  * Add/remove the given breakpoint in our constraint table
  */
 static void
-toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type)
+toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
+	       int weight)
 {
 	int cpu = bp->cpu;
 	struct task_struct *tsk = bp->ctx->task;
@@ -208,20 +229,20 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type)
 	/* Pinned counter task profiling */
 	if (tsk) {
 		if (cpu >= 0) {
-			toggle_bp_task_slot(tsk, cpu, enable, type);
+			toggle_bp_task_slot(tsk, cpu, enable, type, weight);
 			return;
 		}
 
 		for_each_online_cpu(cpu)
-			toggle_bp_task_slot(tsk, cpu, enable, type);
+			toggle_bp_task_slot(tsk, cpu, enable, type, weight);
 		return;
 	}
 
 	/* Pinned counter cpu profiling */
 	if (enable)
-		per_cpu(nr_cpu_bp_pinned[type], bp->cpu)++;
+		per_cpu(nr_cpu_bp_pinned[type], bp->cpu) += weight;
 	else
-		per_cpu(nr_cpu_bp_pinned[type], bp->cpu)--;
+		per_cpu(nr_cpu_bp_pinned[type], bp->cpu) -= weight;
 }
 
 /*
@@ -269,6 +290,7 @@ static int __reserve_bp_slot(struct perf_event *bp)
 {
 	struct bp_busy_slots slots = {0};
 	enum bp_type_idx type;
+	int weight;
 
 	/* Basic checks */
 	if (bp->attr.bp_type == HW_BREAKPOINT_EMPTY ||
@@ -276,13 +298,16 @@ static int __reserve_bp_slot(struct perf_event *bp)
 		return -EINVAL;
 
 	type = find_slot_idx(bp);
+	weight = hw_breakpoint_weight(bp);
+
 	fetch_bp_busy_slots(&slots, bp, type);
+	fetch_this_slot(&slots, weight);
 
 	/* Flexible counters need to keep at least one slot */
-	if (slots.pinned + (!!slots.flexible) == HBP_NUM)
+	if (slots.pinned + (!!slots.flexible) > HBP_NUM)
 		return -ENOSPC;
 
-	toggle_bp_slot(bp, true, type);
+	toggle_bp_slot(bp, true, type, weight);
 
 	return 0;
 }
@@ -303,9 +328,11 @@ int reserve_bp_slot(struct perf_event *bp)
 static void __release_bp_slot(struct perf_event *bp)
 {
 	enum bp_type_idx type;
+	int weight;
 
 	type = find_slot_idx(bp);
-	toggle_bp_slot(bp, false, type);
+	weight = hw_breakpoint_weight(bp);
+	toggle_bp_slot(bp, false, type, weight);
 }
 
 void release_bp_slot(struct perf_event *bp)
-- 
1.6.2.3

