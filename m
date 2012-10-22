Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab2JVGMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 02:12:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:62982 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932Ab2JVGL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 02:11:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,628,1344236400"; 
   d="scan'208";a="236689689"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Cc: eranian@google.com, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 2/6] perf, x86: Introduce x86 special perf event context
Date: Mon, 22 Oct 2012 14:11:15 +0800
Message-Id: <1350886279-6141-3-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1350886279-6141-1-git-send-email-zheng.z.yan@intel.com>
References: <1350886279-6141-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

The x86 special perf event context is named x86_perf_event_context,
We can enlarge it later to store PMU special data.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c | 12 ++++++++++++
 arch/x86/kernel/cpu/perf_event.h |  4 ++++
 include/linux/perf_event.h       |  5 +++++
 kernel/events/core.c             | 28 ++++++++++++++++++----------
 4 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 08e61a6..3361114 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1606,6 +1606,17 @@ static int x86_pmu_event_idx(struct perf_event *event)
 	return idx + 1;
 }
 
+static void *x86_pmu_event_context_alloc(struct perf_event_context *parent_ctx)
+{
+	struct perf_event_context *ctx;
+
+	ctx = kzalloc(sizeof(struct x86_perf_event_context), GFP_KERNEL);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	return ctx;
+}
+
 static ssize_t get_attr_rdpmc(struct device *cdev,
 			      struct device_attribute *attr,
 			      char *buf)
@@ -1695,6 +1706,7 @@ static struct pmu pmu = {
 
 	.event_idx		= x86_pmu_event_idx,
 	.flush_branch_stack	= x86_pmu_flush_branch_stack,
+	.event_context_alloc	= x86_pmu_event_context_alloc,
 };
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 370df32..97fc4b0 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -412,6 +412,10 @@ struct x86_pmu {
 	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
 };
 
+struct x86_perf_event_context {
+	struct perf_event_context ctx;
+};
+
 #define x86_add_quirk(func_)						\
 do {									\
 	static struct x86_pmu_quirk __quirk __initdata = {		\
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7e6a4b6..2868fcf 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -264,6 +264,11 @@ struct pmu {
 	 * flush branch stack on context-switches (needed in cpu-wide mode)
 	 */
 	void (*flush_branch_stack)	(void);
+
+	/*
+	 * Allocate PMU special perf event context
+	 */
+	void *(*event_context_alloc)	(struct perf_event_context *parent_ctx);
 };
 
 /**
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 534810d..c886018 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2721,13 +2721,20 @@ static void __perf_event_init_context(struct perf_event_context *ctx)
 }
 
 static struct perf_event_context *
-alloc_perf_context(struct pmu *pmu, struct task_struct *task)
+alloc_perf_context(struct pmu *pmu, struct task_struct *task,
+		   struct perf_event_context *parent_ctx)
 {
 	struct perf_event_context *ctx;
 
-	ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
-	if (!ctx)
-		return NULL;
+	if (pmu->event_context_alloc) {
+		ctx = pmu->event_context_alloc(parent_ctx);
+		if (IS_ERR(ctx))
+			return ctx;
+	} else {
+		ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
+		if (!ctx)
+			return ERR_PTR(-ENOMEM);
+	}
 
 	__perf_event_init_context(ctx);
 	if (task) {
@@ -2813,10 +2820,11 @@ retry:
 		++ctx->pin_count;
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	} else {
-		ctx = alloc_perf_context(pmu, task);
-		err = -ENOMEM;
-		if (!ctx)
+		ctx = alloc_perf_context(pmu, task, NULL);
+		if (IS_ERR(ctx)) {
+			err = PTR_ERR(ctx);
 			goto errout;
+		}
 
 		err = 0;
 		mutex_lock(&task->perf_event_mutex);
@@ -7132,9 +7140,9 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 		 * child.
 		 */
 
-		child_ctx = alloc_perf_context(event->pmu, child);
-		if (!child_ctx)
-			return -ENOMEM;
+		child_ctx = alloc_perf_context(event->pmu, child, parent_ctx);
+		if (IS_ERR(child_ctx))
+			return PTR_ERR(child_ctx);
 
 		child->perf_event_ctxp[ctxn] = child_ctx;
 	}
-- 
1.7.11.7

