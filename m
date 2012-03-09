Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab2CIN0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:26:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58710 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab2CIN0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:26:40 -0500
Date: Fri, 9 Mar 2012 05:26:00 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-2481c5fa6db0237e4f0168f88913178b2b495b7c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1328826068-11713-10-git-send-email-eranian@google.com>
References: <1328826068-11713-10-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/hw-branch-sampling] perf:
  Disable PERF_SAMPLE_BRANCH_* when not supported
Git-Commit-ID: 2481c5fa6db0237e4f0168f88913178b2b495b7c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 05:26:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2481c5fa6db0237e4f0168f88913178b2b495b7c
Gitweb:     http://git.kernel.org/tip/2481c5fa6db0237e4f0168f88913178b2b495b7c
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 9 Feb 2012 23:20:59 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Mar 2012 14:55:42 +0100

perf: Disable PERF_SAMPLE_BRANCH_* when not supported

PERF_SAMPLE_BRANCH_* is disabled for:

 - SW events (sw counters, tracepoints)
 - HW breakpoints
 - ALL but Intel x86 architecture
 - AMD64 processors

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328826068-11713-10-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index 5bb91bf..a23c42a 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -539,6 +539,10 @@ static int armpmu_event_init(struct perf_event *event)
 	int err = 0;
 	atomic_t *active_events = &armpmu->active_events;
 
+	/* does not support taken branch sampling */
+	if (has_branch_stack(event))
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
index f04c230..c2e27ed 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1084,6 +1084,10 @@ static int power_pmu_event_init(struct perf_event *event)
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
index 67250a5..dd002fa 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -139,6 +139,9 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	if (ret)
 		return ret;
 
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
 	if (event->attr.exclude_host && event->attr.exclude_guest)
 		/*
 		 * When HO == GO == 1 the hardware treats that as GO == HO == 0
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5820efd..242bb51 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5044,6 +5044,12 @@ static int perf_swevent_init(struct perf_event *event)
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
@@ -5154,6 +5160,12 @@ static int perf_tp_event_init(struct perf_event *event)
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
@@ -5379,6 +5391,12 @@ static int cpu_clock_event_init(struct perf_event *event)
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
@@ -5453,6 +5471,12 @@ static int task_clock_event_init(struct perf_event *event)
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
index 3330022..bb38c4d 100644
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
