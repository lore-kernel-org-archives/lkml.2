Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0IBTIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:08:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab0IBTIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:08:19 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: peterz@infradead.org, robert.richter@amd.com, gorcunov@gmail.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
        ming.m.lin@intel.com, yinghai@kernel.org, andi@firstfloor.org,
        eranian@google.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/3] perf, x86: Fix accidentally ack'ing a second event on intel perf counter
Date: Thu,  2 Sep 2010 15:07:47 -0400
Message-Id: <1283454469-1909-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During testing of a patch to stop having the perf subsytem swallow nmis,
it was uncovered that Nehalem boxes were randomly getting unknown nmis
when using the perf tool.

Moving the ack'ing of the PMI closer to when we get the status allows
the hardware to properly re-set the PMU bit signaling another PMI was
triggered during the processing of the first PMI.  This allows the new
logic for dealing with the shortcomings of multiple PMIs to handle the
extra NMI by 'eat'ing it later.

Now one can wonder why are we getting a second PMI when we disable all
the PMUs in the begining of the NMI handler to prevent such a case, for
that I do not know.  But I know the fix below helps deal with this quirk.

Tested on multiple Nehalems where the problem was occuring.  With the
patch, the code now loops a second time to handle the second PMI (whereas
before it was not).

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index d8d86d0..1297bf1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -712,7 +712,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	struct perf_sample_data data;
 	struct cpu_hw_events *cpuc;
 	int bit, loops;
-	u64 ack, status;
+	u64 status;
 
 	perf_sample_data_init(&data, 0);
 
@@ -728,6 +728,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 
 	loops = 0;
 again:
+	intel_pmu_ack_status(status);
 	if (++loops > 100) {
 		WARN_ONCE(1, "perfevents: irq loop stuck!\n");
 		perf_event_print_debug();
@@ -736,7 +737,6 @@ again:
 	}
 
 	inc_irq_stat(apic_perf_irqs);
-	ack = status;
 
 	intel_pmu_lbr_read();
 
@@ -761,8 +761,6 @@ again:
 			x86_pmu_stop(event);
 	}
 
-	intel_pmu_ack_status(ack);
-
 	/*
 	 * Repeat if there is more work to be done:
 	 */
-- 
1.7.2.2

