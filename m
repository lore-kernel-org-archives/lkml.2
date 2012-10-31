Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595Ab2JaAlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:41:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:15557 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759075Ab2JaAee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:34:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,683,1344236400"; 
   d="scan'208";a="162644793"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 12/32] perf, x86: Support full width counting
Date: Tue, 30 Oct 2012 17:34:03 -0700
Message-Id: <1351643663-23828-13-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351643663-23828-1-git-send-email-andi@firstfloor.org>
References: <1351643663-23828-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Recent Intel CPUs have a new alternative MSR range for perfctrs that allows
writing the full counter width. Enable this range if the hardware reports it
using a new capability bit. This lowers overhead of perf stat slightly because
it has to do less interrupts to accumulate the counter value. On Haswell it
also avoids some problems with TSX aborting when the end of the counter
range is reached.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/msr-index.h       |    3 +++
 arch/x86/kernel/cpu/perf_event.h       |    1 +
 arch/x86/kernel/cpu/perf_event_intel.c |    6 ++++++
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 7f0edce..2070f46 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -126,6 +126,9 @@
 #define MSR_KNC_EVNTSEL0               0x00000028
 #define MSR_KNC_EVNTSEL1               0x00000029
 
+/* Alternative perfctr range with full access. */
+#define MSR_IA32_PMC0			0x000004c1
+
 /* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 1567b0d..ce2a863 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -278,6 +278,7 @@ union perf_capabilities {
 		u64	pebs_arch_reg:1;
 		u64	pebs_format:4;
 		u64	smm_freeze:1;
+		u64	fw_write:1;
 	};
 	u64	capabilities;
 };
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 44e18c02..bc21bce 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2247,5 +2247,11 @@ __init int intel_pmu_init(void)
 		}
 	}
 
+	/* Support full width counters using alternative MSR range */
+	if (x86_pmu.intel_cap.fw_write) {
+		x86_pmu.max_period = x86_pmu.cntval_mask;
+		x86_pmu.perfctr = MSR_IA32_PMC0;
+	}
+
 	return 0;
 }
-- 
1.7.7.6

