Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab0IUMJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 08:09:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32521 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab0IUMJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 08:09:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=kHPwCBbqGeSsScOxMwVMkL1VOchFDmxRHcIihXzZSUPeZ75XYjzQagYlr/dynIYKC
	Kd9cqDkDwyfm/2k8J1A8w==
Message-ID: <4c98a066.1707e30a.430b.709c@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 21 Sep 2010 14:06:02 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com
Subject: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation (v3)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[repost to get patch formatting correct]

The DS, BTS, and PEBS memory regions were allocated using kzalloc(), i.e.,
requesting contiguous physical memory. There is no such restriction on
DS, PEBS and BTS buffers.

Using kzalloc() could lead to error in case no contiguous physical memory
is available. BTS is requesting 64KB, thus it can cause issues. PEBS is
currently only requesting one page. Both PEBS and BTS are static buffers
allocated for each CPU at the first user. When the last user exists,
the buffers are released.

All buffers are only accessed on the CPU they are attached to.
kzalloc() does not take into account NUMA, thus all allocations
are taking place on the NUMA node where the first perf_event_open()
is made.

This second version of the patch switches the allocation
to kmalloc_node() to fix the NUMA imbalance. Because of current
limitations on vmalloc(), we cannot use it to avoid allocating
contiguous physical memory.

This patch also avoids failure perf_event_open() in case DS,
PEBS, or BTS buffer cannot be allocated AND the event does not
need those HW features.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0fb1705..c289c2c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -237,6 +237,7 @@ struct x86_pmu {
 	 * Intel DebugStore bits
 	 */
 	int		bts, pebs;
+	int		bts_activated, pebs_activated;
 	int		pebs_record_size;
 	void		(*drain_pebs)(struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
@@ -380,7 +381,7 @@ static void release_pmc_hardware(void) {}
 
 #endif
 
-static int reserve_ds_buffers(void);
+static void reserve_ds_buffers(void);
 static void release_ds_buffers(void);
 
 static void hw_perf_event_destroy(struct perf_event *event)
@@ -477,7 +478,7 @@ static int x86_setup_perfctr(struct perf_event *event)
 	if ((attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
 	    (hwc->sample_period == 1)) {
 		/* BTS is not supported by this architecture. */
-		if (!x86_pmu.bts)
+		if (!x86_pmu.bts_activated)
 			return -EOPNOTSUPP;
 
 		/* BTS is currently only allowed for user-mode. */
@@ -492,18 +493,19 @@ static int x86_setup_perfctr(struct perf_event *event)
 
 static int x86_pmu_hw_config(struct perf_event *event)
 {
-	if (event->attr.precise_ip) {
-		int precise = 0;
+	int p = event->attr.precise_ip;
 
+	if (p) {
 		/* Support for constant skid */
-		if (x86_pmu.pebs)
-			precise++;
+		if (p < 3 && !x86_pmu.pebs_activated)
+			return -EOPNOTSUPP;
 
 		/* Support for IP fixup */
-		if (x86_pmu.lbr_nr)
-			precise++;
+		if (p == 2 && !x86_pmu.lbr_nr)
+			return -EOPNOTSUPP;
 
-		if (event->attr.precise_ip > precise)
+		/* Support for zero skid */
+		if (p > 2)
 			return -EOPNOTSUPP;
 	}
 
@@ -543,11 +545,8 @@ static int __x86_pmu_event_init(struct perf_event *event)
 		if (atomic_read(&active_events) == 0) {
 			if (!reserve_pmc_hardware())
 				err = -EBUSY;
-			else {
-				err = reserve_ds_buffers();
-				if (err)
-					release_pmc_hardware();
-			}
+			else
+				reserve_ds_buffers();
 		}
 		if (!err)
 			atomic_inc(&active_events);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 4977f9c..ff9136c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -74,6 +74,50 @@ static void fini_debug_store_on_cpu(int cpu)
 	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA, 0, 0);
 }
 
+static void release_pebs_buffers(void)
+{
+	int cpu;
+
+	if (!x86_pmu.pebs)
+		return;
+
+	get_online_cpus();
+
+	for_each_possible_cpu(cpu) {
+		struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+
+		if (!ds)
+			continue;
+
+		kfree((void *)(unsigned long)ds->pebs_buffer_base);
+		ds->pebs_buffer_base = 0;
+	}
+
+	put_online_cpus();
+}
+
+static void release_bts_buffers(void)
+{
+	int cpu;
+
+	if (!x86_pmu.bts)
+		return;
+
+	get_online_cpus();
+
+	for_each_possible_cpu(cpu) {
+		struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+
+		if (!ds)
+			continue;
+
+		kfree((void *)(unsigned long)ds->bts_buffer_base);
+		ds->bts_buffer_base = 0;
+	}
+
+	put_online_cpus();
+}
+
 static void release_ds_buffers(void)
 {
 	int cpu;
@@ -102,73 +146,130 @@ static void release_ds_buffers(void)
 	put_online_cpus();
 }
 
-static int reserve_ds_buffers(void)
+static void reserve_ds_buffers(void)
 {
-	int cpu, err = 0;
+	struct debug_store *ds = NULL;
+	u64 base, abs_max;
+	int cpu, node;
+	int  pebs_err = 0, bts_err = 0;
+
+	/*
+	 * speculate we fail
+	 */
+	x86_pmu.bts_activated = 0;
+	x86_pmu.pebs_activated = 0;
 
 	if (!x86_pmu.bts && !x86_pmu.pebs)
-		return 0;
+		return;
+
+	/* PEBS not present */
+	if (!x86_pmu.pebs)
+		pebs_err = 1;
+
+	/* BTS not present */
+	if (!x86_pmu.bts)
+		bts_err = 1;
 
 	get_online_cpus();
 
+	/*
+	 *
+	 * try to allocate DS, BTS, PEBS
+	 *
+	 * if DS fails, then disable both BTS and PEBS
+	 * if PEBS fails, then just disable PEBS
+	 * if BTS fails, then just disable BTS
+	 */
 	for_each_possible_cpu(cpu) {
-		struct debug_store *ds;
 		void *buffer;
 		int max, thresh;
 
-		err = -ENOMEM;
-		ds = kzalloc(sizeof(*ds), GFP_KERNEL);
+		node = cpu_to_node(cpu);
+
+		ds = kmalloc_node(sizeof(*ds), GFP_KERNEL | __GFP_ZERO, node);
 		if (unlikely(!ds))
 			break;
+
 		per_cpu(cpu_hw_events, cpu).ds = ds;
 
-		if (x86_pmu.bts) {
-			buffer = kzalloc(BTS_BUFFER_SIZE, GFP_KERNEL);
-			if (unlikely(!buffer))
-				break;
+		if (!bts_err && x86_pmu.bts) {
+			bts_err = 1;
+			buffer = kmalloc_node(BTS_BUFFER_SIZE,
+					      GFP_KERNEL | __GFP_ZERO, node);
+			if (likely(buffer)) {
+				max = BTS_BUFFER_SIZE / BTS_RECORD_SIZE;
+				thresh = max / 16;
 
-			max = BTS_BUFFER_SIZE / BTS_RECORD_SIZE;
-			thresh = max / 16;
+				base = (u64)(unsigned long)buffer;
 
-			ds->bts_buffer_base = (u64)(unsigned long)buffer;
-			ds->bts_index = ds->bts_buffer_base;
-			ds->bts_absolute_maximum = ds->bts_buffer_base +
-				max * BTS_RECORD_SIZE;
-			ds->bts_interrupt_threshold = ds->bts_absolute_maximum -
-				thresh * BTS_RECORD_SIZE;
-		}
+				ds->bts_buffer_base = base;
+				ds->bts_index = base;
+				ds->bts_absolute_maximum = base +
+					max * BTS_RECORD_SIZE;
 
-		if (x86_pmu.pebs) {
-			buffer = kzalloc(PEBS_BUFFER_SIZE, GFP_KERNEL);
-			if (unlikely(!buffer))
-				break;
-
-			max = PEBS_BUFFER_SIZE / x86_pmu.pebs_record_size;
-
-			ds->pebs_buffer_base = (u64)(unsigned long)buffer;
-			ds->pebs_index = ds->pebs_buffer_base;
-			ds->pebs_absolute_maximum = ds->pebs_buffer_base +
-				max * x86_pmu.pebs_record_size;
-			/*
-			 * Always use single record PEBS
-			 */
-			ds->pebs_interrupt_threshold = ds->pebs_buffer_base +
-				x86_pmu.pebs_record_size;
+				abs_max = ds->bts_absolute_maximum;
+				ds->bts_interrupt_threshold = abs_max -
+					thresh * BTS_RECORD_SIZE;
+
+				bts_err = 0;
+			}
 		}
 
-		err = 0;
+		if (!pebs_err && x86_pmu.pebs) {
+			pebs_err = 1;
+			buffer = kmalloc_node(PEBS_BUFFER_SIZE,
+					      GFP_KERNEL | __GFP_ZERO, node);
+			if (likely(buffer)) {
+				max = PEBS_BUFFER_SIZE
+				    / x86_pmu.pebs_record_size;
+
+				base = (u64)(unsigned long)buffer;
+
+				ds->pebs_buffer_base = base;
+				ds->pebs_index = base;
+				ds->pebs_absolute_maximum = base +
+					max * x86_pmu.pebs_record_size;
+				/*
+				 * Always use single record PEBS
+				 */
+				ds->pebs_interrupt_threshold = base +
+					x86_pmu.pebs_record_size;
+
+				pebs_err = 0;
+			}
+		}
+		/*
+		 * if both PEBS and BTS failed, then bail out completely
+		 */
+		if (pebs_err && bts_err) {
+			ds = NULL;
+			break;
+		}
 	}
 
-	if (err)
+	if (!ds) {
 		release_ds_buffers();
-	else {
+		printk(KERN_WARNING"perf_events: DS allocation failed, "
+				"disabling for now\n");
+	} else {
+		if (pebs_err) {
+			release_pebs_buffers();
+			printk(KERN_WARNING"perf_events: PEBS allocation "
+				"failed, disabling for now\n");
+		} else if (bts_err) {
+			release_bts_buffers();
+			printk(KERN_WARNING"perf_events: BTS allocation "
+				"failed, disabling for now\n");
+		}
+		if (x86_pmu.pebs && !pebs_err)
+			x86_pmu.pebs_activated = 1;
+		if (x86_pmu.bts && !bts_err)
+			x86_pmu.bts_activated = 1;
+
 		for_each_online_cpu(cpu)
 			init_debug_store_on_cpu(cpu);
 	}
-
 	put_online_cpus();
-
-	return err;
 }
 
 /*
@@ -233,7 +334,7 @@ static int intel_pmu_drain_bts_buffer(void)
 	if (!event)
 		return 0;
 
-	if (!ds)
+	if (!x86_pmu.bts_activated)
 		return 0;
 
 	at  = (struct bts_record *)(unsigned long)ds->bts_buffer_base;
@@ -503,7 +604,7 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	struct pebs_record_core *at, *top;
 	int n;
 
-	if (!ds || !x86_pmu.pebs)
+	if (!x86_pmu.pebs_activated)
 		return;
 
 	at  = (struct pebs_record_core *)(unsigned long)ds->pebs_buffer_base;
@@ -545,7 +646,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	u64 status = 0;
 	int bit, n;
 
-	if (!ds || !x86_pmu.pebs)
+	if (!x86_pmu.pebs_activated)
 		return;
 
 	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
