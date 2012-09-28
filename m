Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2I1EiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:38:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:51577 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab2I1Ebx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:31:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="199033676"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 26/31] perf, x86: Support for printing PMU state on spurious PMIs
Date: Thu, 27 Sep 2012 21:31:31 -0700
Message-Id: <1348806696-31170-27-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

I had some problems with spurious PMIs, so print the PMU state
on a spurious one. This will not interact well with other NMI users.
Disabled by default, has to be explicitely enabled through sysfs.

Optional, but useful for debugging.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index be0d3c8..baf78e0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/moduleparam.h>
 
 #include <asm/cpufeature.h>
 #include <asm/hardirq.h>
@@ -19,6 +20,9 @@
 
 #include "perf_event.h"
 
+static bool print_spurious_pmi __read_mostly;
+module_param(print_spurious_pmi, bool, 0644);
+
 /*
  * Intel PerfMon, used on Core and later.
  */
@@ -1237,6 +1241,10 @@ again:
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

