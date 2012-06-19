Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2FSSLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:11:14 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:52256
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003Ab2FSSLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:11:10 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M5VMIH-01-1OC-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 02/10] perf, x86: Rework counter reservation code
Date: Tue, 19 Jun 2012 20:10:40 +0200
Message-ID: <1340129448-8690-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will have non-countinous counter masks with the AMD family 15h pmu.
Rework the code for later use of counter masks.

No functional changes.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e7540c8..ac1cb32 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -132,29 +132,26 @@ static DEFINE_MUTEX(pmc_reserve_mutex);
 
 static bool reserve_pmc_hardware(void)
 {
-	int i;
+	int idx1, idx2;
 
-	for (i = 0; i < x86_pmu.num_counters; i++) {
-		if (!reserve_perfctr_nmi(x86_pmu_event_addr(i)))
+	for (idx1 = 0; idx1 < x86_pmu.num_counters; idx1++) {
+		if (!reserve_perfctr_nmi(x86_pmu_event_addr(idx1)))
 			goto perfctr_fail;
-	}
-
-	for (i = 0; i < x86_pmu.num_counters; i++) {
-		if (!reserve_evntsel_nmi(x86_pmu_config_addr(i)))
+		if (!reserve_evntsel_nmi(x86_pmu_config_addr(idx1)))
 			goto eventsel_fail;
 	}
 
 	return true;
 
 eventsel_fail:
-	for (i--; i >= 0; i--)
-		release_evntsel_nmi(x86_pmu_config_addr(i));
-
-	i = x86_pmu.num_counters;
-
+	release_perfctr_nmi(x86_pmu_event_addr(idx1));
 perfctr_fail:
-	for (i--; i >= 0; i--)
-		release_perfctr_nmi(x86_pmu_event_addr(i));
+	for (idx2 = 0; idx2 < x86_pmu.num_counters; idx2++) {
+		if (idx2 >= idx1)
+			break;
+		release_evntsel_nmi(x86_pmu_config_addr(idx2));
+		release_perfctr_nmi(x86_pmu_event_addr(idx2));
+	}
 
 	return false;
 }
-- 
1.7.8.4


