Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1EZIf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:35:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:47310 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab1EZIfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:35:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,272,1304319600"; 
   d="scan'208";a="2115340"
Subject: [PATCH 1/3] export some perf interfaces
From: Zhang Rui <rui.zhang@intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, ming.m.lin@intel.com,
        acme@redhat.com, "Brown, Len" <lenb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 16:34:13 +0800
Message-ID: <1306398853.2207.155.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Export perf interfaces.

Needed by the next patch, which exports the
Package/Core/Uncore/DRAM energy consumption via perf tool.

Singed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 include/linux/perf_event.h |    3 +++
 kernel/events/core.c       |   11 ++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -1153,6 +1153,9 @@ extern void perf_swevent_put_recursion_c
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
+extern void perf_swevent_init_hrtimer(struct perf_event *event);
+extern void perf_swevent_start_hrtimer(struct perf_event *event);
+extern void perf_swevent_cancel_hrtimer(struct perf_event *event);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
Index: linux-2.6/kernel/events/core.c
===================================================================
--- linux-2.6.orig/kernel/events/core.c
+++ linux-2.6/kernel/events/core.c
@@ -5648,7 +5648,7 @@ static enum hrtimer_restart perf_swevent
 	return ret;
 }
 
-static void perf_swevent_start_hrtimer(struct perf_event *event)
+void perf_swevent_start_hrtimer(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	s64 period;
@@ -5669,8 +5669,9 @@ static void perf_swevent_start_hrtimer(s
 				ns_to_ktime(period), 0,
 				HRTIMER_MODE_REL_PINNED, 0);
 }
+EXPORT_SYMBOL_GPL(perf_swevent_start_hrtimer);
 
-static void perf_swevent_cancel_hrtimer(struct perf_event *event)
+void perf_swevent_cancel_hrtimer(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
@@ -5681,8 +5682,9 @@ static void perf_swevent_cancel_hrtimer(
 		hrtimer_cancel(&hwc->hrtimer);
 	}
 }
+EXPORT_SYMBOL_GPL(perf_swevent_cancel_hrtimer);
 
-static void perf_swevent_init_hrtimer(struct perf_event *event)
+void perf_swevent_init_hrtimer(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
@@ -5705,6 +5707,7 @@ static void perf_swevent_init_hrtimer(st
 		event->attr.freq = 0;
 	}
 }
+EXPORT_SYMBOL_GPL(perf_swevent_init_hrtimer);
 
 /*
  * Software event: cpu wall time clock
@@ -6077,6 +6080,7 @@ free_pdc:
 	free_percpu(pmu->pmu_disable_count);
 	goto unlock;
 }
+EXPORT_SYMBOL_GPL(perf_pmu_register);
 
 void perf_pmu_unregister(struct pmu *pmu)
 {
@@ -6098,6 +6102,7 @@ void perf_pmu_unregister(struct pmu *pmu
 	put_device(pmu->dev);
 	free_pmu_context(pmu);
 }
+EXPORT_SYMBOL_GPL(perf_pmu_unregister);
 
 struct pmu *perf_init_event(struct perf_event *event)
 {


