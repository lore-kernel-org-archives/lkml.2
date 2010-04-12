Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab0DLX2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 19:28:15 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58918 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab0DLX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 19:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AYrzDwOpOQ4esnIEE6HHTcBJaylXVNTOLuG41jR/+Sgp8/lK9YFg7VbNFtQqTy3qpL
         LHhymvH9rG+z6iDr0PPA04UvqIwYynjQiezJOH0xYAFZZC7/9MP6YkxmhDU5bBc7c/D3
         jG28twEYaFgpquScDTj+Dg1JPIpou43CeCkKE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Will Deacon <will.deacon@arm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [RFC PATCH 1/2] hw-breakpoints: Separate constraint space for data and instruction breakpoints
Date: Tue, 13 Apr 2010 01:01:19 +0200
Message-Id: <1271113280-10521-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1271113280-10521-1-git-send-regression-fweisbec@gmail.com>
References: <1271113280-10521-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two outstanding fashions for archs to implement hardware
breakpoints.

The first is to separate breakpoint address pattern definition
space between data and instruction breakpoints. We then have
typically distinct instruction address breakpoint registers
and data address breakpoint registers, delivered with
separate control registers for data and instruction breakpoints
as well. This is the case of PowerPc and ARM for example.

The second consists in having merged breakpoint address space
definition between data and instruction breakpoint. Address
registers can host either instruction or data address and
the access mode for the breakpoint is defined in a control
register. This is the case of x86.

This patch adds a new CONFIG_HAVE_MIXED_BREAKPOINTS_REGS config
that archs can select if they belong to the second case. Those
will have their slot allocation merged for instructions and
data breakpoints.

The others will have a separate slot tracking between data and
instruction breakpoints.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: K. Prasad <prasad@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/Kconfig                  |   11 +++++
 arch/x86/Kconfig              |    1 +
 include/linux/hw_breakpoint.h |    9 +++-
 kernel/hw_breakpoint.c        |   86 ++++++++++++++++++++++++++++-------------
 4 files changed, 77 insertions(+), 30 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index f06010f..acda512 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -137,6 +137,17 @@ config HAVE_HW_BREAKPOINT
 	bool
 	depends on PERF_EVENTS
 
+config HAVE_MIXED_BREAKPOINTS_REGS
+	bool
+	depends on HAVE_HW_BREAKPOINT
+	help
+	  Depending on the arch implementation of hardware breakpoints,
+	  some of them have separate registers for data and instruction
+	  breakpoints addresses, others have mixed registers to store
+	  them but define the access type in a control register.
+	  Select this option if your arch implements breakpoints under the
+	  latter fashion.
+
 config HAVE_USER_RETURN_NOTIFIER
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7191b6e..7f40c72 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -53,6 +53,7 @@ config X86
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
+	select HAVE_MIXED_BREAKPOINTS_REGS
 	select PERF_EVENTS
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index c70d27a..42ed2b4 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -9,9 +9,12 @@ enum {
 };
 
 enum {
-	HW_BREAKPOINT_R = 1,
-	HW_BREAKPOINT_W = 2,
-	HW_BREAKPOINT_X = 4,
+	HW_BREAKPOINT_EMPTY	= 0,
+	HW_BREAKPOINT_R		= 1,
+	HW_BREAKPOINT_W		= 2,
+	HW_BREAKPOINT_RW	= HW_BREAKPOINT_R | HW_BREAKPOINT_W,
+	HW_BREAKPOINT_X		= 4,
+	HW_BREAKPOINT_INVALID   = HW_BREAKPOINT_RW | HW_BREAKPOINT_X,
 };
 
 #ifdef __KERNEL__
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 03808ed..cb8c013 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -45,18 +45,28 @@
 
 #include <linux/hw_breakpoint.h>
 
+enum bp_type_idx {
+	TYPE_INST 	= 0,
+#ifdef CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
+	TYPE_DATA	= 0,
+#else
+	TYPE_DATA	= 1,
+#endif
+	TYPE_MAX
+};
+
 /*
  * Constraints data
  */
 
 /* Number of pinned cpu breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int, nr_cpu_bp_pinned);
+static DEFINE_PER_CPU(unsigned int, nr_cpu_bp_pinned[TYPE_MAX]);
 
 /* Number of pinned task breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int, nr_task_bp_pinned[HBP_NUM]);
+static DEFINE_PER_CPU(unsigned int, nr_task_bp_pinned[TYPE_MAX][HBP_NUM]);
 
 /* Number of non-pinned cpu/task breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int, nr_bp_flexible);
+static DEFINE_PER_CPU(unsigned int, nr_bp_flexible[TYPE_MAX]);
 
 /* Gather the number of total pinned and un-pinned bp in a cpuset */
 struct bp_busy_slots {
@@ -67,14 +77,22 @@ struct bp_busy_slots {
 /* Serialize accesses to the above constraints */
 static DEFINE_MUTEX(nr_bp_mutex);
 
+static inline enum bp_type_idx find_slot_idx(struct perf_event *bp)
+{
+	if (bp->attr.bp_type & HW_BREAKPOINT_RW)
+		return TYPE_DATA;
+
+	return TYPE_INST;
+}
+
 /*
  * Report the maximum number of pinned breakpoints a task
  * have in this cpu
  */
-static unsigned int max_task_bp_pinned(int cpu)
+static unsigned int max_task_bp_pinned(int cpu, enum bp_type_idx type)
 {
 	int i;
-	unsigned int *tsk_pinned = per_cpu(nr_task_bp_pinned, cpu);
+	unsigned int *tsk_pinned = per_cpu(nr_task_bp_pinned[type], cpu);
 
 	for (i = HBP_NUM -1; i >= 0; i--) {
 		if (tsk_pinned[i] > 0)
@@ -84,7 +102,7 @@ static unsigned int max_task_bp_pinned(int cpu)
 	return 0;
 }
 
-static int task_bp_pinned(struct task_struct *tsk)
+static int task_bp_pinned(struct task_struct *tsk, enum bp_type_idx type)
 {
 	struct perf_event_context *ctx = tsk->perf_event_ctxp;
 	struct list_head *list;
@@ -105,7 +123,8 @@ static int task_bp_pinned(struct task_struct *tsk)
 	 */
 	list_for_each_entry(bp, list, event_entry) {
 		if (bp->attr.type == PERF_TYPE_BREAKPOINT)
-			count++;
+			if (find_slot_idx(bp) == type)
+				count++;
 	}
 
 	raw_spin_unlock_irqrestore(&ctx->lock, flags);
@@ -118,18 +137,19 @@ static int task_bp_pinned(struct task_struct *tsk)
  * a given cpu (cpu > -1) or in all of them (cpu = -1).
  */
 static void
-fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp)
+fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
+		    enum bp_type_idx type)
 {
 	int cpu = bp->cpu;
 	struct task_struct *tsk = bp->ctx->task;
 
 	if (cpu >= 0) {
-		slots->pinned = per_cpu(nr_cpu_bp_pinned, cpu);
+		slots->pinned = per_cpu(nr_cpu_bp_pinned[type], cpu);
 		if (!tsk)
-			slots->pinned += max_task_bp_pinned(cpu);
+			slots->pinned += max_task_bp_pinned(cpu, type);
 		else
-			slots->pinned += task_bp_pinned(tsk);
-		slots->flexible = per_cpu(nr_bp_flexible, cpu);
+			slots->pinned += task_bp_pinned(tsk, type);
+		slots->flexible = per_cpu(nr_bp_flexible[type], cpu);
 
 		return;
 	}
@@ -137,16 +157,16 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp)
 	for_each_online_cpu(cpu) {
 		unsigned int nr;
 
-		nr = per_cpu(nr_cpu_bp_pinned, cpu);
+		nr = per_cpu(nr_cpu_bp_pinned[type], cpu);
 		if (!tsk)
-			nr += max_task_bp_pinned(cpu);
+			nr += max_task_bp_pinned(cpu, type);
 		else
-			nr += task_bp_pinned(tsk);
+			nr += task_bp_pinned(tsk, type);
 
 		if (nr > slots->pinned)
 			slots->pinned = nr;
 
-		nr = per_cpu(nr_bp_flexible, cpu);
+		nr = per_cpu(nr_bp_flexible[type], cpu);
 
 		if (nr > slots->flexible)
 			slots->flexible = nr;
@@ -156,14 +176,15 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp)
 /*
  * Add a pinned breakpoint for the given task in our constraint table
  */
-static void toggle_bp_task_slot(struct task_struct *tsk, int cpu, bool enable)
+static void toggle_bp_task_slot(struct task_struct *tsk, int cpu, bool enable,
+				enum bp_type_idx type)
 {
 	unsigned int *tsk_pinned;
 	int count = 0;
 
-	count = task_bp_pinned(tsk);
+	count = task_bp_pinned(tsk, type);
 
-	tsk_pinned = per_cpu(nr_task_bp_pinned, cpu);
+	tsk_pinned = per_cpu(nr_task_bp_pinned[type], cpu);
 	if (enable) {
 		tsk_pinned[count]++;
 		if (count > 0)
@@ -178,7 +199,8 @@ static void toggle_bp_task_slot(struct task_struct *tsk, int cpu, bool enable)
 /*
  * Add/remove the given breakpoint in our constraint table
  */
-static void toggle_bp_slot(struct perf_event *bp, bool enable)
+static void
+toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type)
 {
 	int cpu = bp->cpu;
 	struct task_struct *tsk = bp->ctx->task;
@@ -186,20 +208,20 @@ static void toggle_bp_slot(struct perf_event *bp, bool enable)
 	/* Pinned counter task profiling */
 	if (tsk) {
 		if (cpu >= 0) {
-			toggle_bp_task_slot(tsk, cpu, enable);
+			toggle_bp_task_slot(tsk, cpu, enable, type);
 			return;
 		}
 
 		for_each_online_cpu(cpu)
-			toggle_bp_task_slot(tsk, cpu, enable);
+			toggle_bp_task_slot(tsk, cpu, enable, type);
 		return;
 	}
 
 	/* Pinned counter cpu profiling */
 	if (enable)
-		per_cpu(nr_cpu_bp_pinned, bp->cpu)++;
+		per_cpu(nr_cpu_bp_pinned[type], bp->cpu)++;
 	else
-		per_cpu(nr_cpu_bp_pinned, bp->cpu)--;
+		per_cpu(nr_cpu_bp_pinned[type], bp->cpu)--;
 }
 
 /*
@@ -246,14 +268,21 @@ static void toggle_bp_slot(struct perf_event *bp, bool enable)
 static int __reserve_bp_slot(struct perf_event *bp)
 {
 	struct bp_busy_slots slots = {0};
+	enum bp_type_idx type;
 
-	fetch_bp_busy_slots(&slots, bp);
+	/* Basic checks */
+	if (bp->attr.bp_type == HW_BREAKPOINT_EMPTY ||
+	    bp->attr.bp_type == HW_BREAKPOINT_INVALID)
+		return -EINVAL;
+
+	type = find_slot_idx(bp);
+	fetch_bp_busy_slots(&slots, bp, type);
 
 	/* Flexible counters need to keep at least one slot */
 	if (slots.pinned + (!!slots.flexible) == HBP_NUM)
 		return -ENOSPC;
 
-	toggle_bp_slot(bp, true);
+	toggle_bp_slot(bp, true, type);
 
 	return 0;
 }
@@ -273,7 +302,10 @@ int reserve_bp_slot(struct perf_event *bp)
 
 static void __release_bp_slot(struct perf_event *bp)
 {
-	toggle_bp_slot(bp, false);
+	enum bp_type_idx type;
+
+	type = find_slot_idx(bp);
+	toggle_bp_slot(bp, false, type);
 }
 
 void release_bp_slot(struct perf_event *bp)
-- 
1.6.2.3

