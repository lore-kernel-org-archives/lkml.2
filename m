Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab0FIKQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:16:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:36329 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421Ab0FIKQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:16:43 -0400
Date: Wed, 9 Jun 2010 10:16:09 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, gorcunov@openvz.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, robert.richter@amd.com, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, gorcunov@openvz.org,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, robert.richter@amd.com,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100602212304.GC5264@lenovo>
References: <20100602212304.GC5264@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Make a second write to performance counter if needed
Message-ID: <tip-68aa00ac0a82e9a876c799bf6be7622b8f1c8517@git.kernel.org>
Git-Commit-ID: 68aa00ac0a82e9a876c799bf6be7622b8f1c8517
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:16:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68aa00ac0a82e9a876c799bf6be7622b8f1c8517
Gitweb:     http://git.kernel.org/tip/68aa00ac0a82e9a876c799bf6be7622b8f1c8517
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Thu, 3 Jun 2010 01:23:04 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 11:12:35 +0200

perf, x86: Make a second write to performance counter if needed

On Netburst PMU we need a second write to a performance counter
due to cpu erratum.

A simple flag test instead of alternative instructions was choosen
because wrmsrl is already a macro and if virtualization is turned
on will need an additional wrapper call which is more expencise.

nb: we should propably switch to jump-labels as only this facility
reach the mainline.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100602212304.GC5264@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c    |   12 +++++++++++-
 arch/x86/kernel/cpu/perf_event_p4.c |    9 +++++++++
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index af04c6f..79e1998 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -220,6 +220,7 @@ struct x86_pmu {
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
 	void		(*quirks)(void);
+	int		perfctr_second_write;
 
 	int		(*cpu_prepare)(int cpu);
 	void		(*cpu_starting)(int cpu);
@@ -925,8 +926,17 @@ x86_perf_event_set_period(struct perf_event *event)
 	 */
 	atomic64_set(&hwc->prev_count, (u64)-left);
 
-	wrmsrl(hwc->event_base + idx,
+	wrmsrl(hwc->event_base + idx, (u64)(-left) & x86_pmu.cntval_mask);
+
+	/*
+	 * Due to erratum on certan cpu we need
+	 * a second write to be sure the register
+	 * is updated properly
+	 */
+	if (x86_pmu.perfctr_second_write) {
+		wrmsrl(hwc->event_base + idx,
 			(u64)(-left) & x86_pmu.cntval_mask);
+	}
 
 	perf_event_update_userpage(event);
 
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index ae85d69..9286e73 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -829,6 +829,15 @@ static __initconst const struct x86_pmu p4_pmu = {
 	.max_period		= (1ULL << 39) - 1,
 	.hw_config		= p4_hw_config,
 	.schedule_events	= p4_pmu_schedule_events,
+	/*
+	 * This handles erratum N15 in intel doc 249199-029,
+	 * the counter may not be updated correctly on write
+	 * so we need a second write operation to do the trick
+	 * (the official workaround didn't work)
+	 *
+	 * the former idea is taken from OProfile code
+	 */
+	.perfctr_second_write	= 1,
 };
 
 static __init int p4_pmu_init(void)
