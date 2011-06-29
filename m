Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab1F2Pnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:43:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757043Ab1F2PnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:43:05 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/3] x86, perf: add constraints for architectural PMU v1
Date: Wed, 29 Jun 2011 18:42:36 +0300
Message-Id: <1309362157-6596-3-git-send-email-avi@redhat.com>
In-Reply-To: <1309362157-6596-1-git-send-email-avi@redhat.com>
References: <1309362157-6596-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The v1 PMU does not have any fixed counters.  Using the v2 constraints,
which do have fixed counters, causes an additional choice to be present
in the weight calculation, but not when actually scheduling the event,
leading to an event being not scheduled at all.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 41178c8..b46b70e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -137,6 +137,11 @@ static struct event_constraint intel_westmere_percore_constraints[] __read_mostl
 	EVENT_CONSTRAINT_END
 };
 
+static struct event_constraint intel_v1_event_constraints[] __read_mostly =
+{
+	EVENT_CONSTRAINT_END
+};
+
 static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
@@ -1512,11 +1517,19 @@ static __init int intel_pmu_init(void)
 		break;
 
 	default:
-		/*
-		 * default constraints for v2 and up
-		 */
-		x86_pmu.event_constraints = intel_gen_event_constraints;
-		pr_cont("generic architected perfmon, ");
+		switch (x86_pmu.version) {
+		case 1:
+			x86_pmu.event_constraints = intel_v1_event_constraints;
+			pr_cont("generic architected perfmon v1, ");
+			break;
+		default:
+			/*
+			 * default constraints for v2 and up
+			 */
+			x86_pmu.event_constraints = intel_gen_event_constraints;
+			pr_cont("generic architected perfmon, ");
+			break;
+		}
 	}
 	return 0;
 }
-- 
1.7.5.3

