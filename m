Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab0EGSnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:43:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:46510 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757774Ab0EGSn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:43:29 -0400
Date: Fri, 7 May 2010 18:42:28 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1271190201-25705-3-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Move x86_setup_perfctr()
Message-ID: <tip-c1726f343b3bfc2ee037e191907c632a31903021@git.kernel.org>
Git-Commit-ID: c1726f343b3bfc2ee037e191907c632a31903021
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:42:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1726f343b3bfc2ee037e191907c632a31903021
Gitweb:     http://git.kernel.org/tip/c1726f343b3bfc2ee037e191907c632a31903021
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 13 Apr 2010 22:23:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 May 2010 11:31:00 +0200

perf, x86: Move x86_setup_perfctr()

Move x86_setup_perfctr(), no other changes made.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1271190201-25705-3-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |  120 +++++++++++++++++++-------------------
 1 files changed, 59 insertions(+), 61 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 801441a..3d3bceb 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -426,7 +426,65 @@ set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event_attr *attr)
 	return 0;
 }
 
-static int x86_setup_perfctr(struct perf_event *event);
+static int x86_setup_perfctr(struct perf_event *event)
+{
+	struct perf_event_attr *attr = &event->attr;
+	struct hw_perf_event *hwc = &event->hw;
+	u64 config;
+
+	if (!hwc->sample_period) {
+		hwc->sample_period = x86_pmu.max_period;
+		hwc->last_period = hwc->sample_period;
+		atomic64_set(&hwc->period_left, hwc->sample_period);
+	} else {
+		/*
+		 * If we have a PMU initialized but no APIC
+		 * interrupts, we cannot sample hardware
+		 * events (user-space has to fall back and
+		 * sample via a hrtimer based software event):
+		 */
+		if (!x86_pmu.apic)
+			return -EOPNOTSUPP;
+	}
+
+	if (attr->type == PERF_TYPE_RAW)
+		return 0;
+
+	if (attr->type == PERF_TYPE_HW_CACHE)
+		return set_ext_hw_attr(hwc, attr);
+
+	if (attr->config >= x86_pmu.max_events)
+		return -EINVAL;
+
+	/*
+	 * The generic map:
+	 */
+	config = x86_pmu.event_map(attr->config);
+
+	if (config == 0)
+		return -ENOENT;
+
+	if (config == -1LL)
+		return -EINVAL;
+
+	/*
+	 * Branch tracing:
+	 */
+	if ((attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
+	    (hwc->sample_period == 1)) {
+		/* BTS is not supported by this architecture. */
+		if (!x86_pmu.bts)
+			return -EOPNOTSUPP;
+
+		/* BTS is currently only allowed for user-mode. */
+		if (!attr->exclude_kernel)
+			return -EOPNOTSUPP;
+	}
+
+	hwc->config |= config;
+
+	return 0;
+}
 
 static int x86_pmu_hw_config(struct perf_event *event)
 {
@@ -493,66 +551,6 @@ static int __hw_perf_event_init(struct perf_event *event)
 	return x86_setup_perfctr(event);
 }
 
-static int x86_setup_perfctr(struct perf_event *event)
-{
-	struct perf_event_attr *attr = &event->attr;
-	struct hw_perf_event *hwc = &event->hw;
-	u64 config;
-
-	if (!hwc->sample_period) {
-		hwc->sample_period = x86_pmu.max_period;
-		hwc->last_period = hwc->sample_period;
-		atomic64_set(&hwc->period_left, hwc->sample_period);
-	} else {
-		/*
-		 * If we have a PMU initialized but no APIC
-		 * interrupts, we cannot sample hardware
-		 * events (user-space has to fall back and
-		 * sample via a hrtimer based software event):
-		 */
-		if (!x86_pmu.apic)
-			return -EOPNOTSUPP;
-	}
-
-	if (attr->type == PERF_TYPE_RAW)
-		return 0;
-
-	if (attr->type == PERF_TYPE_HW_CACHE)
-		return set_ext_hw_attr(hwc, attr);
-
-	if (attr->config >= x86_pmu.max_events)
-		return -EINVAL;
-
-	/*
-	 * The generic map:
-	 */
-	config = x86_pmu.event_map(attr->config);
-
-	if (config == 0)
-		return -ENOENT;
-
-	if (config == -1LL)
-		return -EINVAL;
-
-	/*
-	 * Branch tracing:
-	 */
-	if ((attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
-	    (hwc->sample_period == 1)) {
-		/* BTS is not supported by this architecture. */
-		if (!x86_pmu.bts)
-			return -EOPNOTSUPP;
-
-		/* BTS is currently only allowed for user-mode. */
-		if (!attr->exclude_kernel)
-			return -EOPNOTSUPP;
-	}
-
-	hwc->config |= config;
-
-	return 0;
-}
-
 static void x86_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
