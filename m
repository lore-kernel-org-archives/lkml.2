Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab0EGSna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:43:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:46507 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757821Ab0EGSn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:43:27 -0400
Date: Fri, 7 May 2010 18:43:03 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1271190201-25705-6-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-6-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Pass enable bit mask to __x86_pmu_enable_event()
Message-ID: <tip-31fa58af57c41d2912debf62d47d5811062411f1@git.kernel.org>
Git-Commit-ID: 31fa58af57c41d2912debf62d47d5811062411f1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:43:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  31fa58af57c41d2912debf62d47d5811062411f1
Gitweb:     http://git.kernel.org/tip/31fa58af57c41d2912debf62d47d5811062411f1
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 13 Apr 2010 22:23:14 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 May 2010 11:31:00 +0200

perf, x86: Pass enable bit mask to __x86_pmu_enable_event()

To reuse this function for events with different enable bit masks,
this mask is part of the function's argument list now.

The function will be used later to control ibs events too.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1271190201-25705-6-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       |    9 +++++----
 arch/x86/kernel/cpu/perf_event_intel.c |    5 +++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c2c1e10..4e218d7 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -844,10 +844,10 @@ void hw_perf_enable(void)
 	x86_pmu.enable_all(added);
 }
 
-static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc)
+static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
+					  u64 enable_mask)
 {
-	wrmsrl(hwc->config_base + hwc->idx,
-			      hwc->config | ARCH_PERFMON_EVENTSEL_ENABLE);
+	wrmsrl(hwc->config_base + hwc->idx, hwc->config | enable_mask);
 }
 
 static inline void x86_pmu_disable_event(struct perf_event *event)
@@ -919,7 +919,8 @@ static void x86_pmu_enable_event(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	if (cpuc->enabled)
-		__x86_pmu_enable_event(&event->hw);
+		__x86_pmu_enable_event(&event->hw,
+				       ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a099df9..a4b56ac 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -513,7 +513,8 @@ static void intel_pmu_nhm_enable_all(int added)
 			if (!event)
 				continue;
 
-			__x86_pmu_enable_event(&event->hw);
+			__x86_pmu_enable_event(&event->hw,
+					       ARCH_PERFMON_EVENTSEL_ENABLE);
 		}
 	}
 	intel_pmu_enable_all(added);
@@ -617,7 +618,7 @@ static void intel_pmu_enable_event(struct perf_event *event)
 	if (unlikely(event->attr.precise))
 		intel_pmu_pebs_enable(event);
 
-	__x86_pmu_enable_event(hwc);
+	__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
 /*
