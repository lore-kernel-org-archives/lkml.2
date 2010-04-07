Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab0DGMvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:51:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:59809 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab0DGMvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:51:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=Y+cNT0DzfPdUnB/SY7bRFtL+OpzQYtOHsrUjiM41J4ZvDlaaFfRVpGm4y++Sbyb27
	Z4sVVGDYcCoWc+kyaMENA==
Message-ID: <4bbc7fcf.100db80a.6b9f.fffffb14@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 7 Apr 2010 14:45:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf_events: add PERF_SAMPLE_BRANCH_STACK
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This patch exposes the branch trace buffer to users for sampling.
	There are measurements where it is very useful to couple the
	instruction address with some path information, e.g, basic
	block profiling.

	On recent Intel processors, the branch stack is implemented using
	the LBR registers. LBR was already used to fixup PEBS. This
	patch still allows PEBS fixups with LBR and also exposes LBR
	to applications.

	There is a new PERF_SAMPLE_BRANCH_STACK sample type. It creates
	a sample in the buffer which has the following layout:

	   { u64 nr;
	      { u64 from, to, flags } lbr[nr]; } && PERF_SAMPLE_BRANCH_STACK
 	   };

	Refer to include/linux/perf_event.h to figure out the layout ordering
	information.

	LBR is configured by default to record ALL taken branches.  On some
	processors, it is possible to filter the type of branches. This will
	be supported in a subsequent patch.

	On other processors, the sample type is allowed but will generate a
	sample where nr=0 as is the case with other sampling types.

	Signed-off-by: Stephane Eranian <eranian@google.com>

--
 arch/x86/kernel/cpu/perf_event_intel.c    |   13 +++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    5 +++++
 include/linux/perf_event.h                |    8 +++++++-
 kernel/perf_event.c                       |   25 +++++++++++++++++++++++++
 4 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f168b40..6b8aa7d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -562,8 +562,13 @@ static void intel_pmu_disable_event(struct perf_event *event)
 
 	x86_pmu_disable_event(event);
 
+	/*
+	 * PEBS implies LBR
+	 */
 	if (unlikely(event->attr.precise))
 		intel_pmu_pebs_disable(event);
+	else if (unlikely(event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK))
+		intel_pmu_lbr_disable(event);
 }
 
 static void intel_pmu_enable_fixed(struct hw_perf_event *hwc)
@@ -614,8 +619,13 @@ static void intel_pmu_enable_event(struct perf_event *event)
 		return;
 	}
 
+	/*
+	 * PEBS implies LBR
+	 */
 	if (unlikely(event->attr.precise))
 		intel_pmu_pebs_enable(event);
+	else if (unlikely(event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK))
+		intel_pmu_lbr_enable(event);
 
 	__x86_pmu_enable_event(hwc);
 }
@@ -710,6 +720,9 @@ again:
 
 		data.period = event->hw.last_period;
 
+		if (event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK)
+			data.br_stack = &cpuc->lbr_stack;
+
 		if (perf_event_overflow(event, 1, &data, regs))
 			x86_pmu_stop(event);
 	}
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 2fea362..ed62d35 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -505,6 +505,8 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 		data.raw = &raw;
 	}
 
+	if (event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK)
+		data.br_stack = &cpuc->lbr_stack;
 	/*
 	 * We use the interrupt regs as a base because the PEBS record
 	 * does not contain a full regs set, specifically it seems to
@@ -591,6 +593,9 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 			data.raw = &raw;
 		}
 
+		if (event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK)
+			data.br_stack = &cpuc->lbr_stack;
+
 		/*
 		 * See the comment in intel_pmu_drain_pebs_core()
 		 */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6e96cc8..3a8288f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -125,8 +125,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_PERIOD			= 1U << 8,
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
 	PERF_SAMPLE_RAW				= 1U << 10,
+	PERF_SAMPLE_BRANCH_STACK		= 1U << 11,
 
-	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 12,		/* non-ABI */
 };
 
 /*
@@ -415,6 +416,9 @@ enum perf_event_type {
 	 *
 	 *	{ u32			size;
 	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
+	 *
+	 *	{ u64 nr;
+	 *	  { u64 from, to, flags } lbr[nr]; } && PERF_SAMPLE_BRANCH_STACK
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
@@ -819,6 +823,7 @@ struct perf_sample_data {
 	u64				period;
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
+	struct perf_branch_stack	*br_stack;
 };
 
 static inline
@@ -826,6 +831,7 @@ void perf_sample_data_init(struct perf_sample_data *data, u64 addr)
 {
 	data->addr = addr;
 	data->raw  = NULL;
+	data->br_stack = NULL;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 63fbce1..8143e77 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3211,6 +3211,22 @@ void perf_output_sample(struct perf_output_handle *handle,
 			perf_output_put(handle, raw);
 		}
 	}
+
+	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
+		if (data->br_stack) {
+			size_t size;
+
+			size = data->br_stack->nr
+			     * sizeof(struct perf_branch_entry);
+
+			perf_output_put(handle, data->br_stack->nr);
+			perf_output_copy(handle, data->br_stack->entries, size);
+		} else {
+			u64 nr = 0;
+			perf_output_put(handle, nr);
+		}
+	}
+
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
@@ -3298,6 +3314,15 @@ void perf_prepare_sample(struct perf_event_header *header,
 		WARN_ON_ONCE(size & (sizeof(u64)-1));
 		header->size += size;
 	}
+
+	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
+		int size = sizeof(u64);
+		if (data->br_stack) {
+			size += data->br_stack->nr
+			      * sizeof(struct perf_branch_entry);
+		}
+		header->size += size;
+	}
 }
 
 static void perf_event_output(struct perf_event *event, int nmi,
