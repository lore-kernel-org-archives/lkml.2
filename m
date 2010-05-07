Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843Ab0EGSoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:44:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:46594 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757837Ab0EGSoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:44:39 -0400
Date: Fri, 7 May 2010 18:44:15 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       eranian@google.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Improve the PEBS ABI
Message-ID: <tip-ab608344bcbde4f55ec4cd911b686b0ce3eae076@git.kernel.org>
Git-Commit-ID: ab608344bcbde4f55ec4cd911b686b0ce3eae076
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:44:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab608344bcbde4f55ec4cd911b686b0ce3eae076
Gitweb:     http://git.kernel.org/tip/ab608344bcbde4f55ec4cd911b686b0ce3eae076
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 8 Apr 2010 23:03:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 May 2010 11:31:02 +0200

perf, x86: Improve the PEBS ABI

Rename perf_event_attr::precise to perf_event_attr::precise_ip and
widen it to 2 bits. This new field describes the required precision of
the PERF_SAMPLE_IP field:

  0 - SAMPLE_IP can have arbitrary skid
  1 - SAMPLE_IP must have constant skid
  2 - SAMPLE_IP requested to have 0 skid
  3 - SAMPLE_IP must have 0 skid

And modify the Intel PEBS code accordingly. The PEBS implementation
now supports up to precise_ip == 2, where we perform the IP fixup.

Also s/PERF_RECORD_MISC_EXACT/&_IP/ to clarify its meaning, this bit
should be set for each PERF_SAMPLE_IP field known to match the actual
instruction triggering the event.

This new scheme allows for a PEBS mode that uses the buffer for more
than a single event.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c          |   17 ++++++++++++++++-
 arch/x86/kernel/cpu/perf_event_intel.c    |    4 ++--
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   12 ++++++------
 include/linux/perf_event.h                |   23 +++++++++++++++++++----
 tools/perf/builtin-top.c                  |    2 +-
 tools/perf/util/parse-events.c            |   25 ++++++++++++++++---------
 6 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4a3f1f2..27fa9ee 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -488,6 +488,21 @@ static int x86_setup_perfctr(struct perf_event *event)
 
 static int x86_pmu_hw_config(struct perf_event *event)
 {
+	if (event->attr.precise_ip) {
+		int precise = 0;
+
+		/* Support for constant skid */
+		if (x86_pmu.pebs)
+			precise++;
+
+		/* Support for IP fixup */
+		if (x86_pmu.lbr_nr)
+			precise++;
+
+		if (event->attr.precise_ip > precise)
+			return -EOPNOTSUPP;
+	}
+
 	/*
 	 * Generate PMC IRQs:
 	 * (keep 'enabled' bit clear for now)
@@ -1780,7 +1795,7 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
 	}
 
 	if (regs->flags & PERF_EFLAGS_EXACT)
-		misc |= PERF_RECORD_MISC_EXACT;
+		misc |= PERF_RECORD_MISC_EXACT_IP;
 
 	return misc;
 }
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a4b56ac..fdbc652 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -563,7 +563,7 @@ static void intel_pmu_disable_event(struct perf_event *event)
 
 	x86_pmu_disable_event(event);
 
-	if (unlikely(event->attr.precise))
+	if (unlikely(event->attr.precise_ip))
 		intel_pmu_pebs_disable(event);
 }
 
@@ -615,7 +615,7 @@ static void intel_pmu_enable_event(struct perf_event *event)
 		return;
 	}
 
-	if (unlikely(event->attr.precise))
+	if (unlikely(event->attr.precise_ip))
 		intel_pmu_pebs_enable(event);
 
 	__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 35056f7..18018d1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -307,7 +307,7 @@ intel_pebs_constraints(struct perf_event *event)
 {
 	struct event_constraint *c;
 
-	if (!event->attr.precise)
+	if (!event->attr.precise_ip)
 		return NULL;
 
 	if (x86_pmu.pebs_constraints) {
@@ -330,7 +330,7 @@ static void intel_pmu_pebs_enable(struct perf_event *event)
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
 	WARN_ON_ONCE(cpuc->enabled);
 
-	if (x86_pmu.intel_cap.pebs_trap)
+	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
 		intel_pmu_lbr_enable(event);
 }
 
@@ -345,7 +345,7 @@ static void intel_pmu_pebs_disable(struct perf_event *event)
 
 	hwc->config |= ARCH_PERFMON_EVENTSEL_INT;
 
-	if (x86_pmu.intel_cap.pebs_trap)
+	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
 		intel_pmu_lbr_disable(event);
 }
 
@@ -485,7 +485,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	regs.bp = pebs->bp;
 	regs.sp = pebs->sp;
 
-	if (intel_pmu_pebs_fixup_ip(regs))
+	if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
 		regs.flags |= PERF_EFLAGS_EXACT;
 	else
 		regs.flags &= ~PERF_EFLAGS_EXACT;
@@ -518,7 +518,7 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 
 	WARN_ON_ONCE(!event);
 
-	if (!event->attr.precise)
+	if (!event->attr.precise_ip)
 		return;
 
 	n = top - at;
@@ -570,7 +570,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 
 			WARN_ON_ONCE(!event);
 
-			if (!event->attr.precise)
+			if (!event->attr.precise_ip)
 				continue;
 
 			if (__test_and_set_bit(bit, (unsigned long *)&status))
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6be4a0f..23cd005 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -203,9 +203,19 @@ struct perf_event_attr {
 				enable_on_exec :  1, /* next exec enables     */
 				task           :  1, /* trace fork/exit       */
 				watermark      :  1, /* wakeup_watermark      */
-				precise        :  1, /* OoO invariant counter */
-
-				__reserved_1   : 48;
+				/*
+				 * precise_ip:
+				 *
+				 *  0 - SAMPLE_IP can have arbitrary skid
+				 *  1 - SAMPLE_IP must have constant skid
+				 *  2 - SAMPLE_IP requested to have 0 skid
+				 *  3 - SAMPLE_IP must have 0 skid
+				 *
+				 *  See also PERF_RECORD_MISC_EXACT_IP
+				 */
+				precise_ip     :  2, /* skid constraint       */
+
+				__reserved_1   : 47;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -296,7 +306,12 @@ struct perf_event_mmap_page {
 #define PERF_RECORD_MISC_GUEST_KERNEL		(4 << 0)
 #define PERF_RECORD_MISC_GUEST_USER		(5 << 0)
 
-#define PERF_RECORD_MISC_EXACT			(1 << 14)
+/*
+ * Indicates that the content of PERF_SAMPLE_IP points to
+ * the actual instruction that triggered the event. See also
+ * perf_event_attr::precise_ip.
+ */
+#define PERF_RECORD_MISC_EXACT_IP		(1 << 14)
 /*
  * Reserve the last bit to indicate some extended misc field
  */
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 3de3977..ed9b5b6 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1021,7 +1021,7 @@ static void event__process_sample(const event_t *self,
 		return;
 	}
 
-	if (self->header.misc & PERF_RECORD_MISC_EXACT)
+	if (self->header.misc & PERF_RECORD_MISC_EXACT_IP)
 		exact_samples++;
 
 	if (event__preprocess_sample(self, session, &al, symbol_filter) < 0 ||
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index bc8b7e6..ae7f591 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -654,10 +654,6 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
 		return EVT_FAILED;
 	n = hex2u64(str + 1, &config);
 	if (n > 0) {
-		if (str[n+1] == 'p') {
-			attr->precise = 1;
-			n++;
-		}
 		*strp = str + n + 1;
 		attr->type = PERF_TYPE_RAW;
 		attr->config = config;
@@ -692,19 +688,29 @@ static enum event_result
 parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
-	int eu = 1, ek = 1, eh = 1;
+	int exclude = 0;
+	int eu = 0, ek = 0, eh = 0, precise = 0;
 
 	if (*str++ != ':')
 		return 0;
 	while (*str) {
-		if (*str == 'u')
+		if (*str == 'u') {
+			if (!exclude)
+				exclude = eu = ek = eh = 1;
 			eu = 0;
-		else if (*str == 'k')
+		} else if (*str == 'k') {
+			if (!exclude)
+				exclude = eu = ek = eh = 1;
 			ek = 0;
-		else if (*str == 'h')
+		} else if (*str == 'h') {
+			if (!exclude)
+				exclude = eu = ek = eh = 1;
 			eh = 0;
-		else
+		} else if (*str == 'p') {
+			precise++;
+		} else
 			break;
+
 		++str;
 	}
 	if (str >= *strp + 2) {
@@ -712,6 +718,7 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 		attr->exclude_user   = eu;
 		attr->exclude_kernel = ek;
 		attr->exclude_hv     = eh;
+		attr->precise_ip     = precise;
 		return 1;
 	}
 	return 0;
