Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2BDNzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 08:55:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38358 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab2BDNzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 08:55:32 -0500
Date: Sat, 4 Feb 2012 05:55:07 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-84f2b9b2edc09595569c7397cc3c888764ffd78b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120202110401.GA30911@quad>
References: <20120202110401.GA30911@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Remove deprecated WARN_ON_ONCE()
Git-Commit-ID: 84f2b9b2edc09595569c7397cc3c888764ffd78b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 04 Feb 2012 05:55:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84f2b9b2edc09595569c7397cc3c888764ffd78b
Gitweb:     http://git.kernel.org/tip/84f2b9b2edc09595569c7397cc3c888764ffd78b
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 2 Feb 2012 12:04:01 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Feb 2012 08:24:40 +0100

perf: Remove deprecated WARN_ON_ONCE()

With the new throttling/unthrottling code introduced with
commit:

  e050e3f0a71b ("perf: Fix broken interrupt rate throttling")

we occasionally hit two WARN_ON_ONCE() checks in:

  - intel_pmu_pebs_enable()
  - intel_pmu_lbr_enable()
  - x86_pmu_start()

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
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/20120202110401.GA30911@quad
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c           |    3 ---
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |    1 -
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |    2 --
 3 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5adce10..2a30e5a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -986,9 +986,6 @@ static void x86_pmu_start(struct perf_event *event, int flags)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx = event->hw.idx;
 
-	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
-		return;
-
 	if (WARN_ON_ONCE(idx == -1))
 		return;
 
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
