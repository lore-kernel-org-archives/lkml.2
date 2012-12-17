Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2LQLxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 06:53:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab2LQLxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 06:53:30 -0500
Date: Mon, 17 Dec 2012 12:53:23 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH RFC -tip 4/6] perf/x86/Core PMU: IRQ-bound performance events
Message-ID: <5c5570487652e8ab5d17aff7b2771cf62fb8a921.1355744680.git.agordeev@redhat.com>
References: <cover.1355744680.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1355744680.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 61e6db4..71086c4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1585,6 +1585,25 @@ static void core_pmu_enable_all(int added)
 	}
 }
 
+void core_pmu_enable_irq(int irq)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx;
+
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		struct perf_event *event = cpuc->events[idx];
+
+		if (!test_bit(idx, cpuc->actirq_mask) ||
+				cpuc->events[idx]->attr.exclude_host)
+			continue;
+		if (event->irq != irq)
+			continue;
+
+		__x86_pmu_enable_event(&event->hw,
+				       ARCH_PERFMON_EVENTSEL_ENABLE);
+	}
+}
+
 PMU_FORMAT_ATTR(event,	"config:0-7"	);
 PMU_FORMAT_ATTR(umask,	"config:8-15"	);
 PMU_FORMAT_ATTR(edge,	"config:18"	);
@@ -1615,8 +1634,8 @@ static __initconst const struct x86_pmu core_pmu = {
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= x86_pmu_disable_all,
 	.enable_all		= core_pmu_enable_all,
-	.disable_irq		= x86_pmu_enable_irq_nop_int,
-	.enable_irq		= x86_pmu_enable_irq_nop_int,
+	.disable_irq		= x86_pmu_disable_irq,
+	.enable_irq		= core_pmu_enable_irq,
 	.enable			= core_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
 	.hw_config		= x86_pmu_hw_config,
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
