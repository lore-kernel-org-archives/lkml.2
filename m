Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151Ab0EACyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 22:54:45 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58932 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760000Ab0EACyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 22:54:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=tsLrA7HWWKmBewM1gmMqg/a11fWhZ6r8Vakly/73c9tdWGgW0OTK9PHv/CF5gN7iqe
         EvYofVEZthz2r7gXXaMVBLQOo6fsiKM/xwEJkylsnfJIaEhhbZbOeOiruSPjojn5Cti5
         2IE7qFLUOwsr+usqkk6rZVJN6JuDXwg+o4O2I=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 8/8] hw-breakpoints: Get the number of available registers on boot dynamically
Date: Sat,  1 May 2010 04:53:55 +0200
Message-Id: <1272682436-10682-9-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com>
References: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The breakpoint generic layer assumes that archs always know in advance
the static number of address registers available to host breakpoints
through the HBP_NUM macro.

However this is not true for every archs. For example Arm needs to get
this information dynamically to handle the compatiblity between
different versions.

To solve this, this patch proposes to drop the static HBP_NUM macro
and let the arch provide the number of available slots through a
new hw_breakpoint_slots() function. For archs that have
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS selected, it will be called once
as the number of registers fits for instruction and data breakpoints
together.
For the others it will be called first to get the number of
instruction breakpoint registers and another time to get the
data breakpoint registers, the targeted type is given as a
parameter of hw_breakpoint_slots().

Reported-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: K. Prasad <prasad@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/sh/include/asm/hw_breakpoint.h  |    5 +++
 arch/x86/include/asm/hw_breakpoint.h |    5 +++
 include/linux/hw_breakpoint.h        |   10 ++++++
 kernel/hw_breakpoint.c               |   53 ++++++++++++++++++++++++++-------
 kernel/trace/trace_ksym.c            |   26 ++++------------
 5 files changed, 68 insertions(+), 31 deletions(-)

diff --git a/arch/sh/include/asm/hw_breakpoint.h b/arch/sh/include/asm/hw_breakpoint.h
index 382bad9..e14cad9 100644
--- a/arch/sh/include/asm/hw_breakpoint.h
+++ b/arch/sh/include/asm/hw_breakpoint.h
@@ -46,6 +46,11 @@ struct pmu;
 /* Maximum number of UBC channels */
 #define HBP_NUM		2
 
+static inline int hw_breakpoint_slots(int type)
+{
+	return HBP_NUM;
+}
+
 /* arch/sh/kernel/hw_breakpoint.c */
 extern int arch_check_bp_in_kernelspace(struct perf_event *bp);
 extern int arch_validate_hwbkpt_settings(struct perf_event *bp);
diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index c77a5a6..9422553 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -41,6 +41,11 @@ struct arch_hw_breakpoint {
 /* Total number of available HW breakpoint registers */
 #define HBP_NUM 4
 
+static inline int hw_breakpoint_slots(int type)
+{
+	return HBP_NUM;
+}
+
 struct perf_event;
 struct pmu;
 
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 7e88990..a2d6ea4 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -17,6 +17,16 @@ enum {
 	HW_BREAKPOINT_INVALID   = HW_BREAKPOINT_RW | HW_BREAKPOINT_X,
 };
 
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
 #ifdef __KERNEL__
 
 #include <linux/perf_event.h>
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 974498b..684b710 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -40,20 +40,12 @@
 #include <linux/percpu.h>
 #include <linux/sched.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
 
 #include <linux/hw_breakpoint.h>
 
-enum bp_type_idx {
-	TYPE_INST 	= 0,
-#ifdef CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
-	TYPE_DATA	= 0,
-#else
-	TYPE_DATA	= 1,
-#endif
-	TYPE_MAX
-};
 
 /*
  * Constraints data
@@ -63,11 +55,15 @@ enum bp_type_idx {
 static DEFINE_PER_CPU(unsigned int, nr_cpu_bp_pinned[TYPE_MAX]);
 
 /* Number of pinned task breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int, nr_task_bp_pinned[TYPE_MAX][HBP_NUM]);
+static DEFINE_PER_CPU(unsigned int, *nr_task_bp_pinned[TYPE_MAX]);
 
 /* Number of non-pinned cpu/task breakpoints in a cpu */
 static DEFINE_PER_CPU(unsigned int, nr_bp_flexible[TYPE_MAX]);
 
+static int nr_slots[TYPE_MAX];
+
+static int constraints_initialized;
+
 /* Gather the number of total pinned and un-pinned bp in a cpuset */
 struct bp_busy_slots {
 	unsigned int pinned;
@@ -99,7 +95,7 @@ static unsigned int max_task_bp_pinned(int cpu, enum bp_type_idx type)
 	int i;
 	unsigned int *tsk_pinned = per_cpu(nr_task_bp_pinned[type], cpu);
 
-	for (i = HBP_NUM -1; i >= 0; i--) {
+	for (i = nr_slots[type] - 1; i >= 0; i--) {
 		if (tsk_pinned[i] > 0)
 			return i + 1;
 	}
@@ -292,6 +288,10 @@ static int __reserve_bp_slot(struct perf_event *bp)
 	enum bp_type_idx type;
 	int weight;
 
+	/* We couldn't initialize breakpoint constraints on boot */
+	if (!constraints_initialized)
+		return -ENOMEM;
+
 	/* Basic checks */
 	if (bp->attr.bp_type == HW_BREAKPOINT_EMPTY ||
 	    bp->attr.bp_type == HW_BREAKPOINT_INVALID)
@@ -304,7 +304,7 @@ static int __reserve_bp_slot(struct perf_event *bp)
 	fetch_this_slot(&slots, weight);
 
 	/* Flexible counters need to keep at least one slot */
-	if (slots.pinned + (!!slots.flexible) > HBP_NUM)
+	if (slots.pinned + (!!slots.flexible) > nr_slots[type])
 		return -ENOSPC;
 
 	toggle_bp_slot(bp, true, type, weight);
@@ -551,7 +551,36 @@ static struct notifier_block hw_breakpoint_exceptions_nb = {
 
 static int __init init_hw_breakpoint(void)
 {
+	unsigned int **task_bp_pinned;
+	int cpu, err_cpu;
+	int i;
+
+	for (i = 0; i < TYPE_MAX; i++)
+		nr_slots[i] = hw_breakpoint_slots(i);
+
+	for_each_possible_cpu(cpu) {
+		for (i = 0; i < TYPE_MAX; i++) {
+			task_bp_pinned = &per_cpu(nr_task_bp_pinned[i], cpu);
+			*task_bp_pinned = kzalloc(sizeof(int) * nr_slots[i],
+						  GFP_KERNEL);
+			if (!*task_bp_pinned)
+				goto err_alloc;
+		}
+	}
+
+	constraints_initialized = 1;
+
 	return register_die_notifier(&hw_breakpoint_exceptions_nb);
+
+ err_alloc:
+	for_each_possible_cpu(err_cpu) {
+		if (err_cpu == cpu)
+			break;
+		for (i = 0; i < TYPE_MAX; i++)
+			kfree(per_cpu(nr_task_bp_pinned[i], cpu));
+	}
+
+	return -ENOMEM;
 }
 core_initcall(init_hw_breakpoint);
 
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index d59cd68..8eaf007 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -34,12 +34,6 @@
 
 #include <asm/atomic.h>
 
-/*
- * For now, let us restrict the no. of symbols traced simultaneously to number
- * of available hardware breakpoint registers.
- */
-#define KSYM_TRACER_MAX HBP_NUM
-
 #define KSYM_TRACER_OP_LEN 3 /* rw- */
 
 struct trace_ksym {
@@ -53,7 +47,6 @@ struct trace_ksym {
 
 static struct trace_array *ksym_trace_array;
 
-static unsigned int ksym_filter_entry_count;
 static unsigned int ksym_tracing_enabled;
 
 static HLIST_HEAD(ksym_filter_head);
@@ -181,13 +174,6 @@ int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
 	struct trace_ksym *entry;
 	int ret = -ENOMEM;
 
-	if (ksym_filter_entry_count >= KSYM_TRACER_MAX) {
-		printk(KERN_ERR "ksym_tracer: Maximum limit:(%d) reached. No"
-		" new requests for tracing can be accepted now.\n",
-			KSYM_TRACER_MAX);
-		return -ENOSPC;
-	}
-
 	entry = kzalloc(sizeof(struct trace_ksym), GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
@@ -203,13 +189,17 @@ int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
 
 	if (IS_ERR(entry->ksym_hbp)) {
 		ret = PTR_ERR(entry->ksym_hbp);
-		printk(KERN_INFO "ksym_tracer request failed. Try again"
-					" later!!\n");
+		if (ret == -ENOSPC) {
+			printk(KERN_ERR "ksym_tracer: Maximum limit reached."
+			" No new requests for tracing can be accepted now.\n");
+		} else {
+			printk(KERN_INFO "ksym_tracer request failed. Try again"
+					 " later!!\n");
+		}
 		goto err;
 	}
 
 	hlist_add_head_rcu(&(entry->ksym_hlist), &ksym_filter_head);
-	ksym_filter_entry_count++;
 
 	return 0;
 
@@ -265,7 +255,6 @@ static void __ksym_trace_reset(void)
 	hlist_for_each_entry_safe(entry, node, node1, &ksym_filter_head,
 								ksym_hlist) {
 		unregister_wide_hw_breakpoint(entry->ksym_hbp);
-		ksym_filter_entry_count--;
 		hlist_del_rcu(&(entry->ksym_hlist));
 		synchronize_rcu();
 		kfree(entry);
@@ -338,7 +327,6 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 				goto out_unlock;
 		}
 		/* Error or "symbol:---" case: drop it */
-		ksym_filter_entry_count--;
 		hlist_del_rcu(&(entry->ksym_hlist));
 		synchronize_rcu();
 		kfree(entry);
-- 
1.6.2.3

