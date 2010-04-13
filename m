Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab0DMU1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:27:48 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:27484 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab0DMU04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:26:56 -0400
X-SpamScore: 5
X-BigFish: VPS5(zba6lzab9bhzz1202hzzz32i6bh2a8h87h467h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0U0SC-02-H0A-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 02/12] perf, x86: moving x86_setup_perfctr()
Date: Tue, 13 Apr 2010 22:23:11 +0200
Message-ID: <1271190201-25705-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 13 Apr 2010 20:26:35.0574 (UTC) FILETIME=[9CF1E560:01CADB47]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving x86_setup_perfctr(), no other changes made.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |  120 +++++++++++++++++++-------------------
 1 files changed, 59 insertions(+), 61 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index d275277..84b6107 100644
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
-- 
1.7.0.3


