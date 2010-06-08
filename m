Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0FHUXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:23:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:55930 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab0FHUXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:23:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VDzwEMONeNED+xdWAic29gDbDu1s8OF7R6z2KcUUC2VP5okX7CsoH3tnj8qxi8zkDy
         vG1JcilVl6g/QAOe/aDaynIJMfjuaRY6GFJB6NANQmkIsgti67sTkikFKUaMPKitQwon
         Y28R1+S/m2IhvaFF9lvWlw9k+Xf/nVMUYkIYk=
Date: Wed, 9 Jun 2010 00:23:35 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Stephane Eranian <eranian@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] perf, x86: P4 PMU -- redesign cache events
Message-ID: <20100608202335.GB5263@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support cache events we have reserved low 6 bits in
hw_perf_event::config (which is a part of CCCR register
configuration actually).

This bits represent Replay Event mertic enumerated in
enum P4_PEBS_METRIC. The caller should not care about
which exactly bits should be set and how -- the caller
just choose one P4_PEBS_METRIC entity and put it into
config. The kernel will track it and set appropriate
additional MSR registers (metrics) when needed.

The reason for redesign was the PEBS enable bit, which should
not be set until DS (and PEBS sampling) support will be properly
implemented.

Also we have to reset PEBS MSRs when all events disabled.

TODO:
 - PEBS sampling
 - tracking of PEBS registers state, a user might need to turn
   PEBS off completely (ie no PEBS enable, no UOP_tag) but some
   other event may need it, such events clashes and should not
   run simultaneously, at moment we just don't support such events
 - we clear PEBS MSRs at moment but actually what we _need_ is the
   tracking of ReplayEvent event and do not clear the MSRs if
   ReplayEvent was never touched
 - eventually export user space bits in separate header which will
   allow user apps to configure raw events more conveniently.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
---

Ming, I've removed your tested-by tag since it's was a bit ago
when you were testing it. If you give it a chance I will be glad :)

 arch/x86/include/asm/perf_event_p4.h |   97 +++++++++++++-------------
 arch/x86/kernel/cpu/perf_event_p4.c  |  130 +++++++++++++++++++++++++----------
 2 files changed, 145 insertions(+), 82 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
+++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
@@ -19,7 +19,6 @@
 #define ARCH_P4_RESERVED_ESCR	(2) /* IQ_ESCR(0,1) not always present */
 #define ARCH_P4_MAX_ESCR	(ARCH_P4_TOTAL_ESCR - ARCH_P4_RESERVED_ESCR)
 #define ARCH_P4_MAX_CCCR	(18)
-#define ARCH_P4_MAX_COUNTER	(ARCH_P4_MAX_CCCR / 2)
 
 #define P4_ESCR_EVENT_MASK	0x7e000000U
 #define P4_ESCR_EVENT_SHIFT	25
@@ -71,10 +70,6 @@
 #define P4_CCCR_THRESHOLD(v)		((v) << P4_CCCR_THRESHOLD_SHIFT)
 #define P4_CCCR_ESEL(v)			((v) << P4_CCCR_ESCR_SELECT_SHIFT)
 
-/* Custom bits in reerved CCCR area */
-#define P4_CCCR_CACHE_OPS_MASK		0x0000003fU
-
-
 /* Non HT mask */
 #define P4_CCCR_MASK				\
 	(P4_CCCR_OVF			|	\
@@ -106,8 +101,7 @@
  * ESCR and CCCR but rather an only packed value should
  * be unpacked and written to a proper addresses
  *
- * the base idea is to pack as much info as
- * possible
+ * the base idea is to pack as much info as possible
  */
 #define p4_config_pack_escr(v)		(((u64)(v)) << 32)
 #define p4_config_pack_cccr(v)		(((u64)(v)) & 0xffffffffULL)
@@ -130,8 +124,6 @@
 		t;					\
 	})
 
-#define p4_config_unpack_cache_event(v)	(((u64)(v)) & P4_CCCR_CACHE_OPS_MASK)
-
 #define P4_CONFIG_HT_SHIFT		63
 #define P4_CONFIG_HT			(1ULL << P4_CONFIG_HT_SHIFT)
 
@@ -214,6 +206,12 @@ static inline u32 p4_default_escr_conf(i
 	return escr;
 }
 
+/*
+ * This are the events which should be used in "Event Select"
+ * field of ESCR register, they are like unique keys which allow
+ * the kernel to determinate which CCCR and COUNTER should be
+ * used to track an event
+ */
 enum P4_EVENTS {
 	P4_EVENT_TC_DELIVER_MODE,
 	P4_EVENT_BPU_FETCH_REQUEST,
@@ -561,7 +559,7 @@ enum P4_EVENT_OPCODES {
  * a caller should use P4_ESCR_EMASK_NAME helper to
  * pick the EventMask needed, for example
  *
- *	P4_ESCR_EMASK_NAME(P4_EVENT_TC_DELIVER_MODE, DD)
+ *	P4_ESCR_EMASK_BIT(P4_EVENT_TC_DELIVER_MODE, DD)
  */
 enum P4_ESCR_EMASKS {
 	P4_GEN_ESCR_EMASK(P4_EVENT_TC_DELIVER_MODE, DD, 0),
@@ -753,43 +751,50 @@ enum P4_ESCR_EMASKS {
 	P4_GEN_ESCR_EMASK(P4_EVENT_INSTR_COMPLETED, BOGUS, 1),
 };
 
-/* P4 PEBS: stale for a while */
-#define P4_PEBS_METRIC_MASK	0x00001fffU
-#define P4_PEBS_UOB_TAG		0x01000000U
-#define P4_PEBS_ENABLE		0x02000000U
-
-/* Replay metrics for MSR_IA32_PEBS_ENABLE and MSR_P4_PEBS_MATRIX_VERT */
-#define P4_PEBS__1stl_cache_load_miss_retired	0x3000001
-#define P4_PEBS__2ndl_cache_load_miss_retired	0x3000002
-#define P4_PEBS__dtlb_load_miss_retired		0x3000004
-#define P4_PEBS__dtlb_store_miss_retired	0x3000004
-#define P4_PEBS__dtlb_all_miss_retired		0x3000004
-#define P4_PEBS__tagged_mispred_branch		0x3018000
-#define P4_PEBS__mob_load_replay_retired	0x3000200
-#define P4_PEBS__split_load_retired		0x3000400
-#define P4_PEBS__split_store_retired		0x3000400
-
-#define P4_VERT__1stl_cache_load_miss_retired	0x0000001
-#define P4_VERT__2ndl_cache_load_miss_retired	0x0000001
-#define P4_VERT__dtlb_load_miss_retired		0x0000001
-#define P4_VERT__dtlb_store_miss_retired	0x0000002
-#define P4_VERT__dtlb_all_miss_retired		0x0000003
-#define P4_VERT__tagged_mispred_branch		0x0000010
-#define P4_VERT__mob_load_replay_retired	0x0000001
-#define P4_VERT__split_load_retired		0x0000001
-#define P4_VERT__split_store_retired		0x0000002
-
-enum P4_CACHE_EVENTS {
-	P4_CACHE__NONE,
-
-	P4_CACHE__1stl_cache_load_miss_retired,
-	P4_CACHE__2ndl_cache_load_miss_retired,
-	P4_CACHE__dtlb_load_miss_retired,
-	P4_CACHE__dtlb_store_miss_retired,
-	P4_CACHE__itlb_reference_hit,
-	P4_CACHE__itlb_reference_miss,
+/*
+ * P4 PEBS specifics (Replay Event only)
+ *
+ * Format (bits):
+ *   0-6: metric from P4_PEBS_METRIC enum
+ *    7 : reserved
+ *    8 : reserved
+ * 9-11 : reserved
+ *
+ * Note we have UOP and PEBS bits reserved for now
+ * just in case if we will need them once
+ */
+#define P4_PEBS_CONFIG_ENABLE		(1 << 7)
+#define P4_PEBS_CONFIG_UOP_TAG		(1 << 8)
+#define P4_PEBS_CONFIG_METRIC_MASK	0x3f
+#define P4_PEBS_CONFIG_MASK		0xff
+
+/*
+ * mem: Only counters MSR_IQ_COUNTER4 (16) and
+ * MSR_IQ_COUNTER5 (17) are allowed for PEBS sampling
+ */
+#define P4_PEBS_ENABLE			0x02000000U
+#define P4_PEBS_ENABLE_UOP_TAG		0x01000000U
+
+#define p4_config_unpack_metric(v)	(((u64)(v)) & P4_PEBS_CONFIG_METRIC_MASK)
+#define p4_config_unpack_pebs(v)	(((u64)(v)) & P4_PEBS_CONFIG_MASK)
+
+#define p4_config_pebs_has(v, mask)	(p4_config_unpack_pebs(v) & (mask))
 
-	P4_CACHE__MAX
+enum P4_PEBS_METRIC {
+	P4_PEBS_METRIC__none,
+
+	P4_PEBS_METRIC__1stl_cache_load_miss_retired,
+	P4_PEBS_METRIC__2ndl_cache_load_miss_retired,
+	P4_PEBS_METRIC__dtlb_load_miss_retired,
+	P4_PEBS_METRIC__dtlb_store_miss_retired,
+	P4_PEBS_METRIC__dtlb_all_miss_retired,
+	P4_PEBS_METRIC__tagged_mispred_branch,
+	P4_PEBS_METRIC__mob_load_replay_retired,
+	P4_PEBS_METRIC__split_load_retired,
+	P4_PEBS_METRIC__split_store_retired,
+
+	P4_PEBS_METRIC__max
 };
 
 #endif /* PERF_EVENT_P4_H */
+
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -21,22 +21,36 @@ struct p4_event_bind {
 	char cntr[2][P4_CNTR_LIMIT];		/* counter index (offset), -1 on abscence */
 };
 
-struct p4_cache_event_bind {
+struct p4_pebs_bind {
 	unsigned int metric_pebs;
 	unsigned int metric_vert;
 };
 
-#define P4_GEN_CACHE_EVENT_BIND(name)		\
-	[P4_CACHE__##name] = {			\
-		.metric_pebs = P4_PEBS__##name,	\
-		.metric_vert = P4_VERT__##name,	\
+/* it sets P4_PEBS_ENABLE_UOP_TAG as well */
+#define P4_GEN_PEBS_BIND(name, pebs, vert)			\
+	[P4_PEBS_METRIC__##name] = {				\
+		.metric_pebs = pebs | P4_PEBS_ENABLE_UOP_TAG,	\
+		.metric_vert = vert,				\
 	}
 
-static struct p4_cache_event_bind p4_cache_event_bind_map[] = {
-	P4_GEN_CACHE_EVENT_BIND(1stl_cache_load_miss_retired),
-	P4_GEN_CACHE_EVENT_BIND(2ndl_cache_load_miss_retired),
-	P4_GEN_CACHE_EVENT_BIND(dtlb_load_miss_retired),
-	P4_GEN_CACHE_EVENT_BIND(dtlb_store_miss_retired),
+/*
+ * note we have P4_PEBS_ENABLE_UOP_TAG always set here
+ *
+ * it's needed for mapping P4_PEBS_CONFIG_METRIC_MASK bits of
+ * event configuration to find out which values are to be
+ * written into MSR_IA32_PEBS_ENABLE and MSR_P4_PEBS_MATRIX_VERT
+ * resgisters
+ */
+static struct p4_pebs_bind p4_pebs_bind_map[] = {
+	P4_GEN_PEBS_BIND(1stl_cache_load_miss_retired,	0x0000001, 0x0000001),
+	P4_GEN_PEBS_BIND(2ndl_cache_load_miss_retired,	0x0000002, 0x0000001),
+	P4_GEN_PEBS_BIND(dtlb_load_miss_retired,	0x0000004, 0x0000001),
+	P4_GEN_PEBS_BIND(dtlb_store_miss_retired,	0x0000004, 0x0000002),
+	P4_GEN_PEBS_BIND(dtlb_all_miss_retired,		0x0000004, 0x0000003),
+	P4_GEN_PEBS_BIND(tagged_mispred_branch,		0x0018000, 0x0000010),
+	P4_GEN_PEBS_BIND(mob_load_replay_retired,	0x0000200, 0x0000001),
+	P4_GEN_PEBS_BIND(split_load_retired,		0x0000400, 0x0000001),
+	P4_GEN_PEBS_BIND(split_store_retired,		0x0000400, 0x0000002),
 };
 
 /*
@@ -281,10 +295,10 @@ static struct p4_event_bind p4_event_bin
 	},
 };
 
-#define P4_GEN_CACHE_EVENT(event, bit, cache_event)			  \
+#define P4_GEN_CACHE_EVENT(event, bit, metric)				  \
 	p4_config_pack_escr(P4_ESCR_EVENT(event)			| \
 			    P4_ESCR_EMASK_BIT(event, bit))		| \
-	p4_config_pack_cccr(cache_event					| \
+	p4_config_pack_cccr(metric					| \
 			    P4_CCCR_ESEL(P4_OPCODE_ESEL(P4_OPCODE(event))))
 
 static __initconst const u64 p4_hw_cache_event_ids
@@ -296,34 +310,34 @@ static __initconst const u64 p4_hw_cache
 	[ C(OP_READ) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0,
 		[ C(RESULT_MISS)   ] = P4_GEN_CACHE_EVENT(P4_EVENT_REPLAY_EVENT, NBOGUS,
-						P4_CACHE__1stl_cache_load_miss_retired),
+						P4_PEBS_METRIC__1stl_cache_load_miss_retired),
 	},
  },
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0,
 		[ C(RESULT_MISS)   ] = P4_GEN_CACHE_EVENT(P4_EVENT_REPLAY_EVENT, NBOGUS,
-						P4_CACHE__2ndl_cache_load_miss_retired),
+						P4_PEBS_METRIC__2ndl_cache_load_miss_retired),
 	},
 },
  [ C(DTLB) ] = {
 	[ C(OP_READ) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0,
 		[ C(RESULT_MISS)   ] = P4_GEN_CACHE_EVENT(P4_EVENT_REPLAY_EVENT, NBOGUS,
-						P4_CACHE__dtlb_load_miss_retired),
+						P4_PEBS_METRIC__dtlb_load_miss_retired),
 	},
 	[ C(OP_WRITE) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0,
 		[ C(RESULT_MISS)   ] = P4_GEN_CACHE_EVENT(P4_EVENT_REPLAY_EVENT, NBOGUS,
-						P4_CACHE__dtlb_store_miss_retired),
+						P4_PEBS_METRIC__dtlb_store_miss_retired),
 	},
  },
  [ C(ITLB) ] = {
 	[ C(OP_READ) ] = {
 		[ C(RESULT_ACCESS) ] = P4_GEN_CACHE_EVENT(P4_EVENT_ITLB_REFERENCE, HIT,
-						P4_CACHE__itlb_reference_hit),
+						P4_PEBS_METRIC__none),
 		[ C(RESULT_MISS)   ] = P4_GEN_CACHE_EVENT(P4_EVENT_ITLB_REFERENCE, MISS,
-						P4_CACHE__itlb_reference_miss),
+						P4_PEBS_METRIC__none),
 	},
 	[ C(OP_WRITE) ] = {
 		[ C(RESULT_ACCESS) ] = -1,
@@ -414,11 +428,37 @@ static u64 p4_pmu_event_map(int hw_event
 	return config;
 }
 
+static int p4_validate_raw_event(struct perf_event *event)
+{
+	unsigned int v;
+
+	/* user data may have out-of-bound event index */
+	v = p4_config_unpack_event(event->attr.config);
+	if (v >= ARRAY_SIZE(p4_event_bind_map)) {
+		pr_warning("P4 PMU: Unknown event code: %d\n", v);
+		return -EINVAL;
+	}
+
+	/*
+	 * it may have some screwed PEBS bits
+	 */
+	if (p4_config_pebs_has(event->attr.config, P4_PEBS_CONFIG_ENABLE)) {
+		pr_warning("P4 PMU: PEBS are not supported yet\n");
+		return -EINVAL;
+	}
+	v = p4_config_unpack_metric(event->attr.config);
+	if (v >= ARRAY_SIZE(p4_pebs_bind_map)) {
+		pr_warning("P4 PMU: Unknown metric code: %d\n", v);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int p4_hw_config(struct perf_event *event)
 {
 	int cpu = get_cpu();
 	int rc = 0;
-	unsigned int evnt;
 	u32 escr, cccr;
 
 	/*
@@ -438,12 +478,9 @@ static int p4_hw_config(struct perf_even
 
 	if (event->attr.type == PERF_TYPE_RAW) {
 
-		/* user data may have out-of-bound event index */
-		evnt = p4_config_unpack_event(event->attr.config);
-		if (evnt >= ARRAY_SIZE(p4_event_bind_map)) {
-			rc = -EINVAL;
+		rc = p4_validate_raw_event(event);
+		if (rc)
 			goto out;
-		}
 
 		/*
 		 * We don't control raw events so it's up to the caller
@@ -451,12 +488,15 @@ static int p4_hw_config(struct perf_even
 		 * on HT machine but allow HT-compatible specifics to be
 		 * passed on)
 		 *
+		 * Note that for RAW events we allow user to use P4_CCCR_RESERVED
+		 * bits since we keep additional info here (for cache events and etc)
+		 *
 		 * XXX: HT wide things should check perf_paranoid_cpu() &&
 		 *      CAP_SYS_ADMIN
 		 */
 		event->hw.config |= event->attr.config &
 			(p4_config_pack_escr(P4_ESCR_MASK_HT) |
-			 p4_config_pack_cccr(P4_CCCR_MASK_HT));
+			 p4_config_pack_cccr(P4_CCCR_MASK_HT | P4_CCCR_RESERVED));
 	}
 
 	rc = x86_setup_perfctr(event);
@@ -482,6 +522,12 @@ static inline int p4_pmu_clear_cccr_ovf(
 	return overflow;
 }
 
+static void p4_pmu_disable_pebs(void)
+{
+	(void)checking_wrmsrl(MSR_IA32_PEBS_ENABLE,	(u64)0);
+	(void)checking_wrmsrl(MSR_P4_PEBS_MATRIX_VERT,	(u64)0);
+}
+
 static inline void p4_pmu_disable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -507,6 +553,26 @@ static void p4_pmu_disable_all(void)
 			continue;
 		p4_pmu_disable_event(event);
 	}
+
+	p4_pmu_disable_pebs();
+}
+
+/* configuration must be valid */
+static void p4_pmu_enable_pebs(u64 config)
+{
+	struct p4_pebs_bind *bind;
+	unsigned int idx;
+
+	BUILD_BUG_ON(P4_PEBS_METRIC__max > P4_PEBS_CONFIG_METRIC_MASK);
+
+	idx = p4_config_unpack_metric(config);
+	if (idx == P4_PEBS_METRIC__none)
+		return;
+
+	bind = &p4_pebs_bind_map[idx];
+
+	(void)checking_wrmsrl(MSR_IA32_PEBS_ENABLE,	(u64)bind->metric_pebs);
+	(void)checking_wrmsrl(MSR_P4_PEBS_MATRIX_VERT,	(u64)bind->metric_vert);
 }
 
 static void p4_pmu_enable_event(struct perf_event *event)
@@ -515,9 +581,7 @@ static void p4_pmu_enable_event(struct p
 	int thread = p4_ht_config_thread(hwc->config);
 	u64 escr_conf = p4_config_unpack_escr(p4_clear_ht_bit(hwc->config));
 	unsigned int idx = p4_config_unpack_event(hwc->config);
-	unsigned int idx_cache = p4_config_unpack_cache_event(hwc->config);
 	struct p4_event_bind *bind;
-	struct p4_cache_event_bind *bind_cache;
 	u64 escr_addr, cccr;
 
 	bind = &p4_event_bind_map[idx];
@@ -537,16 +601,10 @@ static void p4_pmu_enable_event(struct p
 	cccr = p4_config_unpack_cccr(hwc->config);
 
 	/*
-	 * it could be Cache event so that we need to
-	 * set metrics into additional MSRs
+	 * it could be Cache event so we need to write metrics
+	 * into additional MSRs
 	 */
-	BUILD_BUG_ON(P4_CACHE__MAX > P4_CCCR_CACHE_OPS_MASK);
-	if (idx_cache > P4_CACHE__NONE &&
-		idx_cache < ARRAY_SIZE(p4_cache_event_bind_map)) {
-		bind_cache = &p4_cache_event_bind_map[idx_cache];
-		(void)checking_wrmsrl(MSR_IA32_PEBS_ENABLE, (u64)bind_cache->metric_pebs);
-		(void)checking_wrmsrl(MSR_P4_PEBS_MATRIX_VERT, (u64)bind_cache->metric_vert);
-	}
+	p4_pmu_enable_pebs(hwc->config);
 
 	(void)checking_wrmsrl(escr_addr, escr_conf);
 	(void)checking_wrmsrl(hwc->config_base + hwc->idx,
