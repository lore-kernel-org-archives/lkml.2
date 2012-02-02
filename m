Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab2BBLEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 06:04:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49174 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab2BBLEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 06:04:06 -0500
Date: Thu, 2 Feb 2012 12:04:01 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu
Subject: [PATCH] perf: remove deprecated warn_on_once()
Message-ID: <20120202110401.GA30911@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With the new throttling/unthrottling code introduced with
commit e050e3f, we hit two warn_on_once() in:
  - intel_pmu_pebs_enable()
  - intel_pmu_lbr_enable()

The assertions are no longer problematic. There is a valid
path where they can trigger but it is harmless.

The assertion can be triggered with:
  $ perf record -e instructions:pp ....

Leading to paths:

  intel_pmu_pebs_enable
  intel_pmu_enable_event
  x86_perf_event_set_period
  x86_pmu_start
  perf_adjust_freq_unthr_context
  perf_event_task_tick
  scheduler_tick

And:

  intel_pmu_lbr_enable
  intel_pmu_enable_event
  x86_perf_event_set_period
  x86_pmu_start
  perf_adjust_freq_unthr_context.
  perf_event_task_tick
  scheduler_tick

cpuc->enabled is always on because when we get to
perf_adjust_freq_unthr_context() the PMU is not totally
disabled. Furthermore when we need to adjust a period,
we only stop the event we need to change and not the
entire PMU. Thus, when we re-enable, cpuc->enabled is
already set. Note that when we stop the event, both
pebs and lbr are stopped if necessary (and possible).

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 73da6b6..d6bd49f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -439,7 +439,6 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
 
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
-	WARN_ON_ONCE(cpuc->enabled);
 
 	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
 		intel_pmu_lbr_enable(event);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 3fab3de..47a7e63 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -72,8 +72,6 @@ void intel_pmu_lbr_enable(struct perf_event *event)
 	if (!x86_pmu.lbr_nr)
 		return;
 
-	WARN_ON_ONCE(cpuc->enabled);
-
 	/*
 	 * Reset the LBR stack if we changed task context to
 	 * avoid data leaks.
