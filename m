Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab2JOGDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 02:03:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:48312 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab2JOGDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 02:03:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,587,1344236400"; 
   d="scan'208";a="205651237"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: peterz@infradead.org, tglx@linutronix.de, eranian@google.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] perf/x86: Avoid kfree() in CPU_{STARTING,DYING}
Date: Mon, 15 Oct 2012 14:03:43 +0800
Message-Id: <1350281023-9262-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

On -rt kfree() can schedule, but CPU_{STARTING,DYING} should be
atomic. So use a list to defer kfree until CPU_{ONLINE,DEAD}.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 99d96a4..6df0e60 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2611,6 +2611,20 @@ static void __init uncore_pci_exit(void)
 	}
 }
 
+static LIST_HEAD(boxes_to_free);
+
+static void __cpuinit uncore_kfree_boxes(void)
+{
+	struct intel_uncore_box *box;
+
+	while (!list_empty(&boxes_to_free)) {
+		box = list_entry(boxes_to_free.next,
+				 struct intel_uncore_box, list);
+		list_del(&box->list);
+		kfree(box);
+	}
+}
+
 static void __cpuinit uncore_cpu_dying(int cpu)
 {
 	struct intel_uncore_type *type;
@@ -2625,7 +2639,7 @@ static void __cpuinit uncore_cpu_dying(int cpu)
 			box = *per_cpu_ptr(pmu->box, cpu);
 			*per_cpu_ptr(pmu->box, cpu) = NULL;
 			if (box && atomic_dec_and_test(&box->refcnt))
-				kfree(box);
+				list_add(&box->list, &boxes_to_free);
 		}
 	}
 }
@@ -2655,8 +2669,11 @@ static int __cpuinit uncore_cpu_starting(int cpu)
 				if (exist && exist->phys_id == phys_id) {
 					atomic_inc(&exist->refcnt);
 					*per_cpu_ptr(pmu->box, cpu) = exist;
-					kfree(box);
-					box = NULL;
+					if (box) {
+						list_add(&box->list,
+							 &boxes_to_free);
+						box = NULL;
+					}
 					break;
 				}
 			}
@@ -2795,6 +2812,10 @@ static int
 	case CPU_DYING:
 		uncore_cpu_dying(cpu);
 		break;
+	case CPU_ONLINE:
+	case CPU_DEAD:
+		uncore_kfree_boxes();
+		break;
 	default:
 		break;
 	}
-- 
1.7.11.7

