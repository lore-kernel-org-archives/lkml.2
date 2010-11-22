Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab0KVV4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 16:56:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932211Ab0KVV4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 16:56:12 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, jason.wessel@windriver.com,
        gorcunov@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH] x86, perf, nmi:  Disable perf if counters are not accessable
Date: Mon, 22 Nov 2010 16:55:23 -0500
Message-Id: <1290462923-30734-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a kvm virt guests, the perf counters are not emulated.  Instead they
return zero on a rdmsrl.  The perf nmi handler uses the fact that crossing
a zero means the counter overflowed (for those counters that do not have
specific interrupt bits).  Therefore on kvm guests, perf will swallow all
NMIs thinking the counters overflowed.

This causes problems for subsystems like kgdb which needs NMIs to do its
magic.  This problem was discovered by running kgdb tests.

The solution is to write garbage into a perf counter during the
initialization and hopefully reading back the same number.  On kvm
guests, the value will be read back as zero and we disable perf as
a result.

Reported-by: Jason Wessel <jason.wessel@windriver.com>
Patch-inspired-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index bbe3c4a..e4c4899 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -381,6 +381,19 @@ static void release_pmc_hardware(void) {}
 
 #endif
 
+static bool check_hw_exists(void)
+{
+	u64 val, val_new;
+
+	val = 0xabcdUL;
+	(void) checking_wrmsrl(x86_pmu.perfctr, val);
+	rdmsrl_safe(x86_pmu.perfctr, &val_new);
+	if (val != val_new)
+		return false;
+
+	return true;
+}
+
 static void reserve_ds_buffers(void);
 static void release_ds_buffers(void);
 
@@ -1371,6 +1384,12 @@ void __init init_hw_perf_events(void)
 
 	pmu_check_apic();
 
+	/* sanity check that the hardware exists or is emulated */
+	if (!check_hw_exists()) {
+		pr_cont("Broken PMU hardware detected, software events only.\n");
+		return;
+	}
+
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
 	if (x86_pmu.quirks)
-- 
1.7.3.2

