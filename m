Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab1JNMjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:39:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26713 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916Ab1JNMiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:38:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=atJVww2f1ZNkBffy16SWUVuS30jVhVL18Z6Vs1YqesOt6fw1d0aR2IWSXAgI6o7y6
	A0hZxox3JxOoFZJ61SNpQ==
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ming.m.lin@intel.com,
        andi@firstfloor.org, robert.richter@amd.com, ravitillo@lbl.gov,
        will.deacon@arm.com, paulus@samba.org, benh@kernel.crashing.org,
        rth@twiddle.net, ralf@linux-mips.org, davem@davemloft.net,
        lethal@linux-sh.org
Subject: [PATCH 08/12] perf_events: disable PERF_SAMPLE_BRANCH_* when not supported (v2)
Date: Fri, 14 Oct 2011 14:37:09 +0200
Message-Id: <1318595833-29984-9-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1318595833-29984-1-git-send-email-eranian@google.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
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
index aeefd45..9ef5749 100644
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
index a4c3826..6d30498 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5105,6 +5105,12 @@ static int perf_swevent_init(struct perf_event *event)
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
@@ -5208,6 +5214,12 @@ static int perf_tp_event_init(struct perf_event *event)
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
@@ -5431,6 +5443,12 @@ static int cpu_clock_event_init(struct perf_event *event)
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
@@ -5503,6 +5521,12 @@ static int task_clock_event_init(struct perf_event *event)
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
1.7.1

