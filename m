Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab1G1Xq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:46:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:7471 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136Ab1G1Xov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33559598"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: will.deacon@arm.com, rmk+kernel@arm.linux.org.uk, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [46/50] ARM: 6989/1: perf: do not start the PMU when no events are
Message-Id: <20110728234451.20FF32403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Will Deacon <will.deacon@arm.com>

[ upstream commit f4f38430c94c38187db73a2cf3892cc8b12a2713 ]
 present

armpmu_enable can be called in situations where no events are present
(for example, from the event rotation tick after a profiled task has
exited). In this case, we currently start the PMU anyway which may
leave it active inevitably without any events being monitored.

This patch adds a simple check to the enabling code so that we avoid
starting the PMU when no events are present.

Cc: <stable@kernel.org>
Reported-by: Ashwin Chaugle <ashwinc@codeaurora.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/arch/arm/kernel/perf_event.c
===================================================================
--- linux-2.6.35.y.orig/arch/arm/kernel/perf_event.c
+++ linux-2.6.35.y/arch/arm/kernel/perf_event.c
@@ -531,7 +531,7 @@ void
 hw_perf_enable(void)
 {
 	/* Enable all of the perf events on hardware. */
-	int idx;
+	int idx, enabled = 0;
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	if (!armpmu)
@@ -544,9 +544,11 @@ hw_perf_enable(void)
 			continue;
 
 		armpmu->enable(&event->hw, idx);
+		enabled = 1;
 	}
 
-	armpmu->start();
+	if (enabled)
+		armpmu->start();
 }
 
 void
