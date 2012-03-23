Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab2CWLfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 07:35:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46901 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab2CWLfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 07:35:41 -0400
Date: Fri, 23 Mar 2012 04:34:34 -0700
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-c7206205d00ab375839bd6c7ddb247d600693c09@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, peterz@infradead.org,
        jolsa@redhat.com, acme@infradead.org, tglx@linutronix.de,
        vweaver1@eecs.utk.edu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, jolsa@redhat.com, acme@infradead.org,
        tglx@linutronix.de, vweaver1@eecs.utk.edu
In-Reply-To: <1332433596.2487.33.camel@twins>
References: <1332433596.2487.33.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix mmap_page capabilities and docs
Git-Commit-ID: c7206205d00ab375839bd6c7ddb247d600693c09
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Mar 2012 04:34:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7206205d00ab375839bd6c7ddb247d600693c09
Gitweb:     http://git.kernel.org/tip/c7206205d00ab375839bd6c7ddb247d600693c09
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 22 Mar 2012 17:26:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 23 Mar 2012 09:52:16 +0100

perf: Fix mmap_page capabilities and docs

Complete the syscall-less self-profiling feature and address
all complaints, namely:

 - capabilities, so we can detect what is actually available at runtime

     Add a capabilities field to perf_event_mmap_page to indicate
     what is actually available for use.

 - on x86: RDPMC weirdness due to being 40/48 bits and not sign-extending
   properly.

 - ABI documentation as to how all this stuff works.

Also improve the documentation for the new features.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1332433596.2487.33.camel@twins
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c |   10 ++++-
 include/linux/perf_event.h       |   83 +++++++++++++++++++++++++++++++++-----
 kernel/events/core.c             |    4 +-
 3 files changed, 84 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 453ac94..4ef8104 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1622,6 +1622,9 @@ static int x86_pmu_event_idx(struct perf_event *event)
 {
 	int idx = event->hw.idx;
 
+	if (!x86_pmu.attr_rdpmc)
+		return 0;
+
 	if (x86_pmu.num_counters_fixed && idx >= X86_PMC_IDX_FIXED) {
 		idx -= X86_PMC_IDX_FIXED;
 		idx |= 1 << 30;
@@ -1706,14 +1709,19 @@ static struct pmu pmu = {
 	.flush_branch_stack	= x86_pmu_flush_branch_stack,
 };
 
-void perf_update_user_clock(struct perf_event_mmap_page *userpg, u64 now)
+void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
+	userpg->cap_usr_time = 0;
+	userpg->cap_usr_rdpmc = x86_pmu.attr_rdpmc;
+	userpg->pmc_width = x86_pmu.cntval_bits;
+
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		return;
 
 	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
 		return;
 
+	userpg->cap_usr_time = 1;
 	userpg->time_mult = this_cpu_read(cyc2ns);
 	userpg->time_shift = CYC2NS_SCALE_FACTOR;
 	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 57ae485..ca9ed4e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -299,18 +299,31 @@ struct perf_event_mmap_page {
 	/*
 	 * Bits needed to read the hw events in user-space.
 	 *
-	 *   u32 seq;
-	 *   s64 count;
+	 *   u32 seq, time_mult, time_shift, idx, width;
+	 *   u64 count, enabled, running;
+	 *   u64 cyc, time_offset;
+	 *   s64 pmc = 0;
 	 *
 	 *   do {
 	 *     seq = pc->lock;
-	 *
 	 *     barrier()
-	 *     if (pc->index) {
-	 *       count = pmc_read(pc->index - 1);
-	 *       count += pc->offset;
-	 *     } else
-	 *       goto regular_read;
+	 *
+	 *     enabled = pc->time_enabled;
+	 *     running = pc->time_running;
+	 *
+	 *     if (pc->cap_usr_time && enabled != running) {
+	 *       cyc = rdtsc();
+	 *       time_offset = pc->time_offset;
+	 *       time_mult   = pc->time_mult;
+	 *       time_shift  = pc->time_shift;
+	 *     }
+	 *
+	 *     idx = pc->index;
+	 *     count = pc->offset;
+	 *     if (pc->cap_usr_rdpmc && idx) {
+	 *       width = pc->pmc_width;
+	 *       pmc = rdpmc(idx - 1);
+	 *     }
 	 *
 	 *     barrier();
 	 *   } while (pc->lock != seq);
@@ -323,14 +336,57 @@ struct perf_event_mmap_page {
 	__s64	offset;			/* add to hardware event value */
 	__u64	time_enabled;		/* time event active */
 	__u64	time_running;		/* time event on cpu */
-	__u32	time_mult, time_shift;
+	union {
+		__u64	capabilities;
+		__u64	cap_usr_time  : 1,
+			cap_usr_rdpmc : 1,
+			cap_____res   : 62;
+	};
+
+	/*
+	 * If cap_usr_rdpmc this field provides the bit-width of the value
+	 * read using the rdpmc() or equivalent instruction. This can be used
+	 * to sign extend the result like:
+	 *
+	 *   pmc <<= 64 - width;
+	 *   pmc >>= 64 - width; // signed shift right
+	 *   count += pmc;
+	 */
+	__u16	pmc_width;
+
+	/*
+	 * If cap_usr_time the below fields can be used to compute the time
+	 * delta since time_enabled (in ns) using rdtsc or similar.
+	 *
+	 *   u64 quot, rem;
+	 *   u64 delta;
+	 *
+	 *   quot = (cyc >> time_shift);
+	 *   rem = cyc & ((1 << time_shift) - 1);
+	 *   delta = time_offset + quot * time_mult +
+	 *              ((rem * time_mult) >> time_shift);
+	 *
+	 * Where time_offset,time_mult,time_shift and cyc are read in the
+	 * seqcount loop described above. This delta can then be added to
+	 * enabled and possible running (if idx), improving the scaling:
+	 *
+	 *   enabled += delta;
+	 *   if (idx)
+	 *     running += delta;
+	 *
+	 *   quot = count / running;
+	 *   rem  = count % running;
+	 *   count = quot * enabled + (rem * enabled) / running;
+	 */
+	__u16	time_shift;
+	__u32	time_mult;
 	__u64	time_offset;
 
 		/*
 		 * Hole for extension of the self monitor capabilities
 		 */
 
-	__u64	__reserved[121];	/* align to 1k */
+	__u64	__reserved[120];	/* align to 1k */
 
 	/*
 	 * Control data for the mmap() data buffer.
@@ -347,6 +403,13 @@ struct perf_event_mmap_page {
 	__u64	data_tail;		/* user-space written tail */
 };
 
+/*
+ * Build time assertion that we keep the data_head at the intended location.
+ * IOW, validation we got the __reserved[] size right.
+ */
+extern char __assert_mmap_data_head_offset
+	[1 - 2*!!(offsetof(struct perf_event_mmap_page, data_head) != 1024)];
+
 #define PERF_RECORD_MISC_CPUMODE_MASK		(7 << 0)
 #define PERF_RECORD_MISC_CPUMODE_UNKNOWN	(0 << 0)
 #define PERF_RECORD_MISC_KERNEL			(1 << 0)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c61234b..dc3b052 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3348,7 +3348,7 @@ static void calc_timer_values(struct perf_event *event,
 	*running = ctx_time - event->tstamp_running;
 }
 
-void __weak perf_update_user_clock(struct perf_event_mmap_page *userpg, u64 now)
+void __weak arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
 }
 
@@ -3398,7 +3398,7 @@ void perf_event_update_userpage(struct perf_event *event)
 	userpg->time_running = running +
 			atomic64_read(&event->child_total_time_running);
 
-	perf_update_user_clock(userpg, now);
+	arch_perf_update_userpage(userpg, now);
 
 	barrier();
 	++userpg->lock;
