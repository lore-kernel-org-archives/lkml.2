Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0CQMLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 08:11:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:34945 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab0CQMLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 08:11:09 -0400
Date: Wed, 17 Mar 2010 12:10:26 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1268826553-19518-5-git-send-email-robert.richter@amd.com>
References: <1268826553-19518-5-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/core, x86: Remove duplicate perf_event_mask variable
Message-ID: <tip-d6dc0b4ead6e8720096ecfa3d9e899b47ddbc8ed@git.kernel.org>
Git-Commit-ID: d6dc0b4ead6e8720096ecfa3d9e899b47ddbc8ed
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 12:10:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6dc0b4ead6e8720096ecfa3d9e899b47ddbc8ed
Gitweb:     http://git.kernel.org/tip/d6dc0b4ead6e8720096ecfa3d9e899b47ddbc8ed
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 17 Mar 2010 12:49:13 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Mar 2010 13:06:59 +0100

perf/core, x86: Remove duplicate perf_event_mask variable

The same information is stored also in x86_pmu.intel_ctrl. This
patch removes perf_event_mask and instead uses
x86_pmu.intel_ctrl directly.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268826553-19518-5-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 104292a..c97d5b5 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -75,8 +75,6 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	return len;
 }
 
-static u64 perf_event_mask __read_mostly;
-
 struct event_constraint {
 	union {
 		unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
@@ -1406,7 +1404,7 @@ void __init init_hw_perf_events(void)
 		     x86_pmu.num_events, X86_PMC_MAX_GENERIC);
 		x86_pmu.num_events = X86_PMC_MAX_GENERIC;
 	}
-	perf_event_mask = (1 << x86_pmu.num_events) - 1;
+	x86_pmu.intel_ctrl = (1 << x86_pmu.num_events) - 1;
 	perf_max_events = x86_pmu.num_events;
 
 	if (x86_pmu.num_events_fixed > X86_PMC_MAX_FIXED) {
@@ -1415,9 +1413,8 @@ void __init init_hw_perf_events(void)
 		x86_pmu.num_events_fixed = X86_PMC_MAX_FIXED;
 	}
 
-	perf_event_mask |=
+	x86_pmu.intel_ctrl |=
 		((1LL << x86_pmu.num_events_fixed)-1) << X86_PMC_IDX_FIXED;
-	x86_pmu.intel_ctrl = perf_event_mask;
 
 	perf_events_lapic_init();
 	register_die_notifier(&perf_event_nmi_notifier);
@@ -1442,7 +1439,7 @@ void __init init_hw_perf_events(void)
 	pr_info("... value mask:             %016Lx\n", x86_pmu.event_mask);
 	pr_info("... max period:             %016Lx\n", x86_pmu.max_period);
 	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_events_fixed);
-	pr_info("... event mask:             %016Lx\n", perf_event_mask);
+	pr_info("... event mask:             %016Lx\n", x86_pmu.intel_ctrl);
 
 	perf_cpu_notifier(x86_pmu_notifier);
 }
