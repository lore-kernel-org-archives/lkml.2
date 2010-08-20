Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab0HTOSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 10:18:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:55724 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab0HTOSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 10:18:04 -0400
Date: Fri, 20 Aug 2010 14:17:46 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1282228033.2605.204.camel@laptop>
References: <1282228033.2605.204.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Fix handle_irq return values
Message-ID: <tip-4a31bebe71ab2e4f6ecd6e5f9f2ac9f0ff38ff76@git.kernel.org>
Git-Commit-ID: 4a31bebe71ab2e4f6ecd6e5f9f2ac9f0ff38ff76
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 Aug 2010 14:17:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a31bebe71ab2e4f6ecd6e5f9f2ac9f0ff38ff76
Gitweb:     http://git.kernel.org/tip/4a31bebe71ab2e4f6ecd6e5f9f2ac9f0ff38ff76
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 19 Aug 2010 16:28:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Aug 2010 15:00:06 +0200

perf, x86: Fix handle_irq return values

Now that we rely on the number of handled overflows, ensure all handle_irq
implementations actually return the right number.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Don Zickus <dzickus@redhat.com>
LKML-Reference: <1282228033.2605.204.camel@laptop>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    9 +++++++--
 arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index d8d86d0..4539b4b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -713,6 +713,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	struct cpu_hw_events *cpuc;
 	int bit, loops;
 	u64 ack, status;
+	int handled = 0;
 
 	perf_sample_data_init(&data, 0);
 
@@ -743,12 +744,16 @@ again:
 	/*
 	 * PEBS overflow sets bit 62 in the global status register
 	 */
-	if (__test_and_clear_bit(62, (unsigned long *)&status))
+	if (__test_and_clear_bit(62, (unsigned long *)&status)) {
+		handled++;
 		x86_pmu.drain_pebs(regs);
+	}
 
 	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
+		handled++;
+
 		if (!test_bit(bit, cpuc->active_mask))
 			continue;
 
@@ -772,7 +777,7 @@ again:
 
 done:
 	intel_pmu_enable_all(0);
-	return 1;
+	return handled;
 }
 
 static struct event_constraint *
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index febb12c..d470c91 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -690,7 +690,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 		inc_irq_stat(apic_perf_irqs);
 	}
 
-	return handled > 0;
+	return handled;
 }
 
 /*
