Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2JBXuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:50:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:61637 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730Ab2JBXtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:49:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,525,1344236400"; 
   d="scan'208";a="200845777"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, x86@vger.kernel.org, eranian@google.com, jolsa@redhat.com,
        a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 19/31] perf, x86: Support for printing PMU state on spurious PMIs v2
Date: Tue,  2 Oct 2012 16:48:39 -0700
Message-Id: <1349221731-15665-20-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
References: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

I had some problems with spurious PMIs, so print the PMU state
on a spurious one. This will not interact well with other NMI users.
Disabled by default, has to be explicitely enabled through sysfs.

Optional, but useful for debugging.

v2: Move to /sys/devices/cpu
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c       |    3 +++
 arch/x86/kernel/cpu/perf_event.h       |    2 ++
 arch/x86/kernel/cpu/perf_event_intel.c |    4 ++++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 87c2ab0..b0f4edd 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -38,6 +38,7 @@
 #include "perf_event.h"
 
 struct x86_pmu x86_pmu __read_mostly;
+int	       print_spurious_pmi __read_mostly;
 
 DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
@@ -1630,9 +1631,11 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 }
 
 static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
+static DEVICE_INT_ATTR(print_spurious_pmi, 0644, print_spurious_pmi);
 
 static struct attribute *x86_pmu_attrs[] = {
 	&dev_attr_rdpmc.attr,
+	&dev_attr_print_spurious_pmi.attr.attr,
 	NULL,
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 2f714f0..002ecc9 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -657,3 +657,5 @@ static inline struct intel_shared_regs *allocate_shared_regs(int cpu)
 }
 
 #endif /* CONFIG_CPU_SUP_INTEL */
+
+extern int print_spurious_pmi;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 0b8251a..8b8bb61 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1205,6 +1205,10 @@ again:
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

