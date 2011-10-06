Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965015Ab1JFOuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 10:50:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34021 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964946Ab1JFOuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 10:50:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=vYIZwW8ApCsJbFcyofJNU3CEO19cmVQbNnK95NSY6huE+VvHEiiL5GClAZ1gfVgmH
	lr8Ih+8XnBPWI/y3k5Mfg==
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ming.m.lin@intel.com,
        andi@firstfloor.org, robert.richter@amd.com, ravitillo@lbl.gov
Subject: [PATCH 08/12] perf_events: disable PERF_SAMPLE_BRANCH_* when not supported
Date: Thu,  6 Oct 2011 16:49:11 +0200
Message-Id: <1317912555-9559-9-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1317912555-9559-1-git-send-email-eranian@google.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
X-System-Of-Record: true
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
 arch/mips/kernel/perf_event.c        |    4 ++++
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
index 53c9c26..bcb0dd1 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -544,6 +544,10 @@ static int armpmu_event_init(struct perf_event *event)
 {
 	int err = 0;
 
+	/* does not support taken branch sampling */
+	if (has_branch_smpl(event))
+		return -EOPNOTSUPP;
+
 	switch (event->attr.type) {
 	case PERF_TYPE_RAW:
 	case PERF_TYPE_HARDWARE:
diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
index 0aee944..425c35a 100644
--- a/arch/mips/kernel/perf_event.c
+++ b/arch/mips/kernel/perf_event.c
@@ -370,6 +370,10 @@ static int mipspmu_event_init(struct perf_event *event)
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
index 10a140f..5701051 100644
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
index 2ee21a4..7cc9066 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -309,6 +309,10 @@ static int sh_pmu_event_init(struct perf_event *event)
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
index 941caa2..81a9b5a 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -132,6 +132,9 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	if (ret)
 		return ret;
 
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
 	if (event->attr.type != PERF_TYPE_RAW)
 		return 0;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 70a8975..e5caab5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5104,6 +5104,12 @@ static int perf_swevent_init(struct perf_event *event)
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
@@ -5207,6 +5213,12 @@ static int perf_tp_event_init(struct perf_event *event)
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
@@ -5430,6 +5442,12 @@ static int cpu_clock_event_init(struct perf_event *event)
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
@@ -5502,6 +5520,12 @@ static int task_clock_event_init(struct perf_event *event)
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
index b7971d6..e7fb781 100644
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

