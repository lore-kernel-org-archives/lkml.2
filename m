Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab2KJBcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:32:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:41258 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab2KJB2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:28:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,749,1344236400"; 
   d="scan'208";a="244848911"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 18/32] perf, x86: Support for printing PMU state on spurious PMIs v3
Date: Fri,  9 Nov 2012 17:27:34 -0800
Message-Id: <1352510868-7911-19-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

I had some problems with spurious PMIs, so print the PMU state
on a spurious one. This will not interact well with other NMI users.
Disabled by default, has to be explicitely enabled through sysfs.

Optional, but useful for debugging.

v2: Move to /sys/devices/cpu
v3: Print in more cases
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c       |    3 +++
 arch/x86/kernel/cpu/perf_event.h       |    2 ++
 arch/x86/kernel/cpu/perf_event_intel.c |   11 ++++++-----
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ec3c549..57bb4ce 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -38,6 +38,7 @@
 #include "perf_event.h"
 
 struct x86_pmu x86_pmu __read_mostly;
+int	       print_spurious_pmi __read_mostly;
 
 DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
@@ -1758,9 +1759,11 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 }
 
 static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
+static DEVICE_INT_ATTR(print_spurious_pmi, 0644, print_spurious_pmi);
 
 static struct attribute *x86_pmu_attrs[] = {
 	&dev_attr_rdpmc.attr,
+	&dev_attr_print_spurious_pmi.attr.attr,
 	NULL,
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index d55e502..2ef5b20 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -664,3 +664,5 @@ static inline struct intel_shared_regs *allocate_shared_regs(int cpu)
 }
 
 #endif /* CONFIG_CPU_SUP_INTEL */
+
+extern int print_spurious_pmi;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 20caf0a..dc2f2a1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1146,11 +1146,8 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	intel_pmu_disable_all();
 	handled = intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
-	if (!status) {
-		intel_pmu_enable_all(0);
-		return handled;
-	}
-
+	if (!status)
+		goto done;
 	loops = 0;
 again:
 	intel_pmu_ack_status(status);
@@ -1210,6 +1207,10 @@ again:
 		goto again;
 
 done:
+	if (!handled && print_spurious_pmi) {
+		pr_debug("Spurious PMI\n");
+		perf_event_print_debug();
+	}
 	intel_pmu_enable_all(0);
 	return handled;
 }
-- 
1.7.7.6

