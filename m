Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab0JVNDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:03:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:40354 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab0JVNDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:03:23 -0400
Date: Fri, 22 Oct 2010 13:02:55 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101019134808.253453452@chello.nl>
References: <20101019134808.253453452@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Extract PEBS/BTS allocation functions
Message-ID: <tip-5ee25c87318fa3722026fd77089fa7ba0db8d447@git.kernel.org>
Git-Commit-ID: 5ee25c87318fa3722026fd77089fa7ba0db8d447
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 13:02:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ee25c87318fa3722026fd77089fa7ba0db8d447
Gitweb:     http://git.kernel.org/tip/5ee25c87318fa3722026fd77089fa7ba0db8d447
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 19 Oct 2010 14:15:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Oct 2010 14:18:25 +0200

perf, x86: Extract PEBS/BTS allocation functions

Mostly a cleanup.. it reduces code indentation and makes the code flow
of reserve_ds_buffers() clearer.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Stephane Eranian <eranian@google.com>
LKML-Reference: <20101019134808.253453452@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   92 ++++++++++++++++++-----------
 1 files changed, 57 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 1bc1351..14d98bd 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -74,6 +74,32 @@ static void fini_debug_store_on_cpu(int cpu)
 	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA, 0, 0);
 }
 
+static int alloc_pebs_buffer(int cpu)
+{
+	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+	int max, thresh = 1; /* always use a single PEBS record */
+	void *buffer;
+
+	if (!x86_pmu.pebs)
+		return 0;
+
+	buffer = kzalloc(PEBS_BUFFER_SIZE, GFP_KERNEL);
+	if (unlikely(!buffer))
+		return -ENOMEM;
+
+	max = PEBS_BUFFER_SIZE / x86_pmu.pebs_record_size;
+
+	ds->pebs_buffer_base = (u64)(unsigned long)buffer;
+	ds->pebs_index = ds->pebs_buffer_base;
+	ds->pebs_absolute_maximum = ds->pebs_buffer_base +
+		max * x86_pmu.pebs_record_size;
+
+	ds->pebs_interrupt_threshold = ds->pebs_buffer_base +
+		thresh * x86_pmu.pebs_record_size;
+
+	return 0;
+}
+
 static void release_pebs_buffer(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
@@ -85,6 +111,32 @@ static void release_pebs_buffer(int cpu)
 	ds->pebs_buffer_base = 0;
 }
 
+static int alloc_bts_buffer(int cpu)
+{
+	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+	int max, thresh;
+	void *buffer;
+
+	if (!x86_pmu.bts)
+		return 0;
+
+	buffer = kzalloc(BTS_BUFFER_SIZE, GFP_KERNEL);
+	if (unlikely(!buffer))
+		return -ENOMEM;
+
+	max = BTS_BUFFER_SIZE / BTS_RECORD_SIZE;
+	thresh = max / 16;
+
+	ds->bts_buffer_base = (u64)(unsigned long)buffer;
+	ds->bts_index = ds->bts_buffer_base;
+	ds->bts_absolute_maximum = ds->bts_buffer_base +
+		max * BTS_RECORD_SIZE;
+	ds->bts_interrupt_threshold = ds->bts_absolute_maximum -
+		thresh * BTS_RECORD_SIZE;
+
+	return 0;
+}
+
 static void release_bts_buffer(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
@@ -133,8 +185,6 @@ static int reserve_ds_buffers(void)
 
 	for_each_possible_cpu(cpu) {
 		struct debug_store *ds;
-		void *buffer;
-		int max, thresh;
 
 		err = -ENOMEM;
 		ds = kzalloc(sizeof(*ds), GFP_KERNEL);
@@ -142,39 +192,11 @@ static int reserve_ds_buffers(void)
 			break;
 		per_cpu(cpu_hw_events, cpu).ds = ds;
 
-		if (x86_pmu.bts) {
-			buffer = kzalloc(BTS_BUFFER_SIZE, GFP_KERNEL);
-			if (unlikely(!buffer))
-				break;
-
-			max = BTS_BUFFER_SIZE / BTS_RECORD_SIZE;
-			thresh = max / 16;
-
-			ds->bts_buffer_base = (u64)(unsigned long)buffer;
-			ds->bts_index = ds->bts_buffer_base;
-			ds->bts_absolute_maximum = ds->bts_buffer_base +
-				max * BTS_RECORD_SIZE;
-			ds->bts_interrupt_threshold = ds->bts_absolute_maximum -
-				thresh * BTS_RECORD_SIZE;
-		}
+		if (alloc_bts_buffer(cpu))
+			break;
 
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
-		}
+		if (alloc_pebs_buffer(cpu))
+			break;
 
 		err = 0;
 	}
