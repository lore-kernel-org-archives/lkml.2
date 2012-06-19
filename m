Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab2FSSLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:11:48 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:16405 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753302Ab2FSSLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:11:13 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M5VMII-01-1OJ-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 10/10] perf, amd: Check northbridge event config value
Date: Tue, 19 Jun 2012 20:10:48 +0200
Message-ID: <1340129448-8690-11-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The northbridge counter configuration registers do not support certain
bits as core performance counters do. Not supported bits are:

 * Host/Guest Only
 * Counter Mask
 * Invert Comparison
 * Edge Detect
 * Operating-System Mode
 * User Mode

Do not setup northbridge events with those bits set.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h    |    3 +
 arch/x86/kernel/cpu/perf_event_amd.c |   93 +++++++++++++++++++++++----------
 2 files changed, 68 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 637a72b7..dc7f5b1 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -48,6 +48,9 @@
 #define AMD64_RAW_EVENT_MASK		\
 	(X86_RAW_EVENT_MASK          |  \
 	 AMD64_EVENTSEL_EVENT)
+#define AMD64_NB_EVENT_MASK		\
+	(AMD64_EVENTSEL_EVENT        |  \
+	 ARCH_PERFMON_EVENTSEL_UMASK)
 #define AMD64_NUM_COUNTERS				4
 #define AMD64_NUM_COUNTERS_CORE				6
 #define AMD64_NUM_COUNTERS_NB				4
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 7a870d2..03cd13e 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -116,6 +116,65 @@ static __initconst const u64 amd_hw_cache_event_ids
 };
 
 /*
+ * AMD64 events are detected based on their event codes.
+ */
+static inline unsigned int amd_get_event_code(struct hw_perf_event *hwc)
+{
+	return ((hwc->config >> 24) & 0x0f00) | (hwc->config & 0x00ff);
+}
+
+static inline int amd_is_nb_event(struct hw_perf_event *hwc)
+{
+	return (hwc->config & 0xe0) == 0xe0;
+}
+
+static inline int amd_is_nb_perfctr_event(struct hw_perf_event *hwc)
+{
+	return amd_is_nb_event(hwc)
+		&& (x86_pmu.counters_mask64 & AMD64_COUNTERS_MASK_NB);
+}
+
+static inline int amd_has_nb(struct cpu_hw_events *cpuc)
+{
+	struct amd_nb *nb = cpuc->amd_nb;
+
+	return nb && nb->nb_id != -1;
+}
+
+/*
+ * AMD NB counters (MSRs 0xc0010240 etc.) do not support the following
+ * flags:
+ *
+ *  Host/Guest Only
+ *  Counter Mask
+ *  Invert Comparison
+ *  Edge Detect
+ *  Operating-System Mode
+ *  User Mode
+ *
+ * Try to fix the config for default settings, otherwise fail.
+ */
+static int amd_nb_event_config(struct perf_event *event)
+{
+	if (!amd_is_nb_perfctr_event(&event->hw))
+		return 0;
+
+	if (event->attr.exclude_host || event->attr.exclude_guest
+	    || event->attr.exclude_user || event->attr.exclude_kernel)
+		goto fail;
+
+	event->hw.config &= ~(ARCH_PERFMON_EVENTSEL_USR | ARCH_PERFMON_EVENTSEL_OS);
+
+	if (event->hw.config & ~(AMD64_NB_EVENT_MASK | ARCH_PERFMON_EVENTSEL_INT))
+		goto fail;
+
+	return 0;
+fail:
+	pr_debug("Invalid nb counter config value: %016Lx\n", event->hw.config);
+	return -EINVAL;
+}
+
+/*
  * AMD Performance Monitor K7 and later.
  */
 static const u64 amd_perfmon_event_map[] =
@@ -143,13 +202,13 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	if (event->attr.precise_ip && get_ibs_caps())
 		return -ENOENT;
 
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
 	ret = x86_pmu_hw_config(event);
 	if (ret)
 		return ret;
 
-	if (has_branch_stack(event))
-		return -EOPNOTSUPP;
-
 	if (event->attr.exclude_host && event->attr.exclude_guest)
 		/*
 		 * When HO == GO == 1 the hardware treats that as GO == HO == 0
@@ -163,32 +222,10 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	else if (event->attr.exclude_guest)
 		event->hw.config |= AMD_PERFMON_EVENTSEL_HOSTONLY;
 
-	if (event->attr.type != PERF_TYPE_RAW)
-		return 0;
-
-	event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
-
-	return 0;
-}
-
-/*
- * AMD64 events are detected based on their event codes.
- */
-static inline unsigned int amd_get_event_code(struct hw_perf_event *hwc)
-{
-	return ((hwc->config >> 24) & 0x0f00) | (hwc->config & 0x00ff);
-}
-
-static inline int amd_is_nb_event(struct hw_perf_event *hwc)
-{
-	return (hwc->config & 0xe0) == 0xe0;
-}
-
-static inline int amd_has_nb(struct cpu_hw_events *cpuc)
-{
-	struct amd_nb *nb = cpuc->amd_nb;
+	if (event->attr.type == PERF_TYPE_RAW)
+		event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
 
-	return nb && nb->nb_id != -1;
+	return amd_nb_event_config(event);
 }
 
 static void amd_put_nb_event_constraints(struct cpu_hw_events *cpuc,
-- 
1.7.8.4


