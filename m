Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab0ERRo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:44:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:3004 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562Ab0ERRo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:44:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,256,1272870000"; 
   d="scan'208";a="568316003"
Subject: [RFC][PATCH v2 01/11] perf: un-const struct pmu *
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 01:44:23 +0000
Message-Id: <1274233463.3036.79.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pmu will be linked to a list, so it's not const any more.
    
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c |   14 +++++++-------
 include/linux/perf_event.h       |   10 +++++-----
 kernel/perf_event.c              |   24 ++++++++++++------------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index fd4db0d..5c6a0d9 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -616,7 +616,7 @@ static void x86_pmu_enable_all(int added)
 	}
 }
 
-static const struct pmu pmu;
+static struct pmu pmu;
 
 static inline int is_x86_event(struct perf_event *event)
 {
@@ -1374,7 +1374,7 @@ static inline void x86_pmu_read(struct perf_event *event)
  * Set the flag to make pmu::enable() not perform the
  * schedulability test, it will be performed at commit time
  */
-static void x86_pmu_start_txn(const struct pmu *pmu)
+static void x86_pmu_start_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -1386,7 +1386,7 @@ static void x86_pmu_start_txn(const struct pmu *pmu)
  * Clear the flag and pmu::enable() will perform the
  * schedulability test.
  */
-static void x86_pmu_cancel_txn(const struct pmu *pmu)
+static void x86_pmu_cancel_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -1398,7 +1398,7 @@ static void x86_pmu_cancel_txn(const struct pmu *pmu)
  * Perform the group schedulability test as a whole
  * Return 0 if success
  */
-static int x86_pmu_commit_txn(const struct pmu *pmu)
+static int x86_pmu_commit_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int assign[X86_PMC_IDX_MAX];
@@ -1422,7 +1422,7 @@ static int x86_pmu_commit_txn(const struct pmu *pmu)
 	return 0;
 }
 
-static const struct pmu pmu = {
+static struct pmu pmu = {
 	.enable		= x86_pmu_enable,
 	.disable	= x86_pmu_disable,
 	.start		= x86_pmu_start,
@@ -1508,9 +1508,9 @@ out:
 	return ret;
 }
 
-const struct pmu *hw_perf_event_init(struct perf_event *event)
+struct pmu *hw_perf_event_init(struct perf_event *event)
 {
-	const struct pmu *tmp;
+	struct pmu *tmp;
 	int err;
 
 	err = __hw_perf_event_init(event);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3fd5c82..6c01c5f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -566,9 +566,9 @@ struct pmu {
 	 * If test fails, roll back the whole group
 	 */
 
-	void (*start_txn)	(const struct pmu *pmu);
-	void (*cancel_txn)	(const struct pmu *pmu);
-	int  (*commit_txn)	(const struct pmu *pmu);
+	void (*start_txn)	(struct pmu *pmu);
+	void (*cancel_txn)	(struct pmu *pmu);
+	int  (*commit_txn)	(struct pmu *pmu);
 };
 
 /**
@@ -645,7 +645,7 @@ struct perf_event {
 	int				group_flags;
 	struct perf_event		*group_leader;
 	struct perf_event		*output;
-	const struct pmu		*pmu;
+	struct pmu			*pmu;
 
 	enum perf_event_active_state	state;
 	atomic64_t			count;
@@ -817,7 +817,7 @@ struct perf_output_handle {
  */
 extern int perf_max_events;
 
-extern const struct pmu *hw_perf_event_init(struct perf_event *event);
+extern struct pmu *hw_perf_event_init(struct perf_event *event);
 
 extern void perf_event_task_sched_in(struct task_struct *task);
 extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a4fa381..ba7a37a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -75,7 +75,7 @@ static DEFINE_SPINLOCK(perf_resource_lock);
 /*
  * Architecture provided APIs - weak aliases:
  */
-extern __weak const struct pmu *hw_perf_event_init(struct perf_event *event)
+extern __weak struct pmu *hw_perf_event_init(struct perf_event *event)
 {
 	return NULL;
 }
@@ -638,7 +638,7 @@ group_sched_in(struct perf_event *group_event,
 	       struct perf_event_context *ctx)
 {
 	struct perf_event *event, *partial_group = NULL;
-	const struct pmu *pmu = group_event->pmu;
+	struct pmu *pmu = group_event->pmu;
 	bool txn = false;
 	int ret;
 
@@ -4192,7 +4192,7 @@ static void perf_swevent_disable(struct perf_event *event)
 	hlist_del_rcu(&event->hlist_entry);
 }
 
-static const struct pmu perf_ops_generic = {
+static struct pmu perf_ops_generic = {
 	.enable		= perf_swevent_enable,
 	.disable	= perf_swevent_disable,
 	.read		= perf_swevent_read,
@@ -4303,7 +4303,7 @@ static void cpu_clock_perf_event_read(struct perf_event *event)
 	cpu_clock_perf_event_update(event);
 }
 
-static const struct pmu perf_ops_cpu_clock = {
+static struct pmu perf_ops_cpu_clock = {
 	.enable		= cpu_clock_perf_event_enable,
 	.disable	= cpu_clock_perf_event_disable,
 	.read		= cpu_clock_perf_event_read,
@@ -4360,7 +4360,7 @@ static void task_clock_perf_event_read(struct perf_event *event)
 	task_clock_perf_event_update(event, time);
 }
 
-static const struct pmu perf_ops_task_clock = {
+static struct pmu perf_ops_task_clock = {
 	.enable		= task_clock_perf_event_enable,
 	.disable	= task_clock_perf_event_disable,
 	.read		= task_clock_perf_event_read,
@@ -4501,7 +4501,7 @@ static void tp_perf_event_destroy(struct perf_event *event)
 	swevent_hlist_put(event);
 }
 
-static const struct pmu *tp_perf_event_init(struct perf_event *event)
+static struct pmu *tp_perf_event_init(struct perf_event *event)
 {
 	int err;
 
@@ -4558,7 +4558,7 @@ static int perf_tp_event_match(struct perf_event *event,
 	return 1;
 }
 
-static const struct pmu *tp_perf_event_init(struct perf_event *event)
+static struct pmu *tp_perf_event_init(struct perf_event *event)
 {
 	return NULL;
 }
@@ -4580,7 +4580,7 @@ static void bp_perf_event_destroy(struct perf_event *event)
 	release_bp_slot(event);
 }
 
-static const struct pmu *bp_perf_event_init(struct perf_event *bp)
+static struct pmu *bp_perf_event_init(struct perf_event *bp)
 {
 	int err;
 
@@ -4604,7 +4604,7 @@ void perf_bp_event(struct perf_event *bp, void *data)
 		perf_swevent_add(bp, 1, 1, &sample, regs);
 }
 #else
-static const struct pmu *bp_perf_event_init(struct perf_event *bp)
+static struct pmu *bp_perf_event_init(struct perf_event *bp)
 {
 	return NULL;
 }
@@ -4626,9 +4626,9 @@ static void sw_perf_event_destroy(struct perf_event *event)
 	swevent_hlist_put(event);
 }
 
-static const struct pmu *sw_perf_event_init(struct perf_event *event)
+static struct pmu *sw_perf_event_init(struct perf_event *event)
 {
-	const struct pmu *pmu = NULL;
+	struct pmu *pmu = NULL;
 	u64 event_id = event->attr.config;
 
 	/*
@@ -4690,7 +4690,7 @@ perf_event_alloc(struct perf_event_attr *attr,
 		   perf_overflow_handler_t overflow_handler,
 		   gfp_t gfpflags)
 {
-	const struct pmu *pmu;
+	struct pmu *pmu;
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
 	long err;




