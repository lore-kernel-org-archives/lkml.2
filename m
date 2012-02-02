Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2BBM4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:56:00 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51147 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2BBMz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:55:58 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: [PATCH v5 09/18] perf: disable PERF_SAMPLE_BRANCH_* when not supported
Date: Thu,  2 Feb 2012 13:54:39 +0100
Message-Id: <1328187288-24395-10-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1328187288-24395-1-git-send-email-eranian@google.com>
References: <1328187288-24395-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PERF_SAMPLE_BRANCH_* is disabled for:
- SW events (sw counters, tracepoints)
- HW breakpoints
- ALL but Intel X86 architecture
- AMD64 processors

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/alpha/kernel/perf_event.c       |    4 ++++
 arch/arm/kernel/perf_event.c         |    4 ++++
 arch/mips/kernel/perf_event_mipsxx.c |    4 ++++
 arch/powerpc/kernel/perf_event.c     |    4 ++++
 arch/sh/kernel/perf_event.c          |    4 ++++
 arch/sparc/kernel/perf_event.c       |    4 ++++
 arch/x86/kernel/cpu/perf_event_amd.c |    3 +++
 kernel/events/core.c                 |   24 ++++++++++++++++++++++++
 kernel/events/hw_breakpoint.c        |    6 ++++++
 9 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/kernel/perf_event.c b/arch/alpha/kernel/perf_event.c
index 8143cd7..0dae252 100644
--- a/arch/alpha/kernel/perf_event.c
+++ b/arch/alpha/kernel/perf_event.c
@@ -685,6 +685,10 @@ static int alpha_pmu_event_init(struct perf_event *event)
 {
 	int err;
 
+	/* does not support taken branch sampling */
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
 	switch (event->attr.type) {
 	case PERF_TYPE_RAW:
 	case PERF_TYPE_HARDWARE:
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 5bb91bf..68bb0ce 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -539,6 +539,10 @@ static int armpmu_event_init(struct perf_event *event)
 	int err = 0;
 	atomic_t *active_events = &armpmu->active_events;
 
+	/* does not support taken branch sampling */
+	if (has_branch_smpl(event))
+		return -EOPNOTSUPP;
+
 	if (armpmu->map_event(event) == -ENOENT)
 		return -ENOENT;
 
diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index e3b897a..811084f 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -606,6 +606,10 @@ static int mipspmu_event_init(struct perf_event *event)
 {
 	int err = 0;
 
+	/* does not support taken branch sampling */
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
 	switch (event->attr.type) {
 	case PERF_TYPE_RAW:
 	case PERF_TYPE_HARDWARE:
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index d614ab5..4e0b265 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1078,6 +1078,10 @@ static int power_pmu_event_init(struct perf_event *event)
 	if (!ppmu)
 		return -ENOENT;
 
+	/* does not support taken branch sampling */
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
 	switch (event->attr.type) {
 	case PERF_TYPE_HARDWARE:
 		ev = event->attr.config;
diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 10b14e3..068b8a2 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -310,6 +310,10 @@ static int sh_pmu_event_init(struct perf_event *event)
 {
 	int err;
 
+	/* does not support taken branch sampling */
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
 	switch (event->attr.type) {
 	case PERF_TYPE_RAW:
 	case PERF_TYPE_HW_CACHE:
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 614da62..8e16a4a 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1105,6 +1105,10 @@ static int sparc_pmu_event_init(struct perf_event *event)
 	if (atomic_read(&nmi_active) < 0)
 		return -ENODEV;
 
+	/* does not support taken branch sampling */
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
 	switch (attr->type) {
 	case PERF_TYPE_HARDWARE:
 		if (attr->config >= sparc_pmu->max_events)
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 0397b23..0d8da03 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -138,6 +138,9 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	if (ret)
 		return ret;
 
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
 	if (event->attr.exclude_host && event->attr.exclude_guest)
 		/*
 		 * When HO == GO == 1 the hardware treats that as GO == HO == 0
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a268e45..5660ffa 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5035,6 +5035,12 @@ static int perf_swevent_init(struct perf_event *event)
 	if (event->attr.type != PERF_TYPE_SOFTWARE)
 		return -ENOENT;
 
+	/*
+	 * no branch sampling for software events
+	 */
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
 	switch (event_id) {
 	case PERF_COUNT_SW_CPU_CLOCK:
 	case PERF_COUNT_SW_TASK_CLOCK:
@@ -5145,6 +5151,12 @@ static int perf_tp_event_init(struct perf_event *event)
 	if (event->attr.type != PERF_TYPE_TRACEPOINT)
 		return -ENOENT;
 
+	/*
+	 * no branch sampling for tracepoint events
+	 */
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
 	err = perf_trace_init(event);
 	if (err)
 		return err;
@@ -5370,6 +5382,12 @@ static int cpu_clock_event_init(struct perf_event *event)
 	if (event->attr.config != PERF_COUNT_SW_CPU_CLOCK)
 		return -ENOENT;
 
+	/*
+	 * no branch sampling for software events
+	 */
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
 	perf_swevent_init_hrtimer(event);
 
 	return 0;
@@ -5444,6 +5462,12 @@ static int task_clock_event_init(struct perf_event *event)
 	if (event->attr.config != PERF_COUNT_SW_TASK_CLOCK)
 		return -ENOENT;
 
+	/*
+	 * no branch sampling for software events
+	 */
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
 	perf_swevent_init_hrtimer(event);
 
 	return 0;
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index b0309f7..cee5423 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -581,6 +581,12 @@ static int hw_breakpoint_event_init(struct perf_event *bp)
 	if (bp->attr.type != PERF_TYPE_BREAKPOINT)
 		return -ENOENT;
 
+	/*
+	 * no branch sampling for breakpoint events
+	 */
+	if (has_branch_stack(bp))
+		return -EOPNOTSUPP;
+
 	err = register_perf_hw_breakpoint(bp);
 	if (err)
 		return err;
-- 
1.7.4.1

