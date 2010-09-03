Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab0ICHLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:11:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:43097 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab0ICHLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:11:19 -0400
Date: Fri, 3 Sep 2010 07:10:39 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1283454469-1909-4-git-send-email-dzickus@redhat.com>
References: <1283454469-1909-4-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Fix handle_irq return values
Message-ID: <tip-de725dec9de7a7541996176d59cf8542365b8b0e@git.kernel.org>
Git-Commit-ID: de725dec9de7a7541996176d59cf8542365b8b0e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 07:10:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de725dec9de7a7541996176d59cf8542365b8b0e
Gitweb:     http://git.kernel.org/tip/de725dec9de7a7541996176d59cf8542365b8b0e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 2 Sep 2010 15:07:49 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Sep 2010 08:05:18 +0200

perf, x86: Fix handle_irq return values

Now that we rely on the number of handled overflows, ensure all
handle_irq implementations actually return the right number.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: peterz@infradead.org
Cc: robert.richter@amd.com
Cc: gorcunov@gmail.com
Cc: fweisbec@gmail.com
Cc: ying.huang@intel.com
Cc: ming.m.lin@intel.com
Cc: eranian@google.com
LKML-Reference: <1283454469-1909-4-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    9 +++++++--
 arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 1297bf1..ee05c90 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -713,6 +713,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	struct cpu_hw_events *cpuc;
 	int bit, loops;
 	u64 status;
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
 
@@ -770,7 +775,7 @@ again:
 
 done:
 	intel_pmu_enable_all(0);
-	return 1;
+	return handled;
 }
 
 static struct event_constraint *
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 7e578e9..b560db3 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -692,7 +692,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 		inc_irq_stat(apic_perf_irqs);
 	}
 
-	return handled > 0;
+	return handled;
 }
 
 /*
