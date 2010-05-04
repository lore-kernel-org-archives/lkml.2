Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab0EDKrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 06:47:46 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:25590 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab0EDKqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 06:46:49 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1W5XR-02-5I3-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/7] oprofile/x86: reserve counter msrs pairwise
Date: Tue, 4 May 2010 12:44:49 +0200
Message-ID: <1272969893-29233-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1272969893-29233-1-git-send-email-robert.richter@amd.com>
References: <1272969893-29233-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For AMD's and Intel's P6 generic performance counters have pairwise
counter and control msrs. This patch changes the counter reservation
in a way that both msrs must be registered. It joins some counter
loops and also removes the unnecessary NUM_CONTROLS macro in the AMD
implementation.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c  |   43 ++++++++++++++++--------------------
 arch/x86/oprofile/op_model_ppro.c |   36 ++++++++++++++----------------
 2 files changed, 36 insertions(+), 43 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 090cbbe..2e2bc90 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -30,13 +30,10 @@
 #include "op_counter.h"
 
 #define NUM_COUNTERS 4
-#define NUM_CONTROLS 4
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 #define NUM_VIRT_COUNTERS 32
-#define NUM_VIRT_CONTROLS 32
 #else
 #define NUM_VIRT_COUNTERS NUM_COUNTERS
-#define NUM_VIRT_CONTROLS NUM_CONTROLS
 #endif
 
 #define OP_EVENT_MASK			0x0FFF
@@ -134,13 +131,15 @@ static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 	int i;
 
 	for (i = 0; i < NUM_COUNTERS; i++) {
-		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
-			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
-	}
-
-	for (i = 0; i < NUM_CONTROLS; i++) {
-		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i))
-			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
+		if (!reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
+			continue;
+		if (!reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i)) {
+			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+			continue;
+		}
+		/* both registers must be reserved */
+		msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
+		msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
 	}
 }
 
@@ -160,7 +159,7 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	}
 
 	/* clear all counters */
-	for (i = 0; i < NUM_CONTROLS; ++i) {
+	for (i = 0; i < NUM_COUNTERS; ++i) {
 		if (unlikely(!msrs->controls[i].addr)) {
 			if (counter_config[i].enabled && !smp_processor_id())
 				/*
@@ -175,12 +174,10 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 			op_x86_warn_in_use(i);
 		val &= model->reserved;
 		wrmsrl(msrs->controls[i].addr, val);
-	}
-
-	/* avoid a false detection of ctr overflows in NMI handler */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (unlikely(!msrs->counters[i].addr))
-			continue;
+		/*
+		 * avoid a false detection of ctr overflows in NMI
+		 * handler
+		 */
 		wrmsrl(msrs->counters[i].addr, -1LL);
 	}
 
@@ -430,12 +427,10 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 	int i;
 
 	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (msrs->counters[i].addr)
-			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-	}
-	for (i = 0; i < NUM_CONTROLS; ++i) {
-		if (msrs->controls[i].addr)
-			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+		if (!msrs->counters[i].addr)
+			continue;
+		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
 	}
 }
 
@@ -583,7 +578,7 @@ static void op_amd_exit(void)
 
 struct op_x86_model_spec op_amd_spec = {
 	.num_counters		= NUM_COUNTERS,
-	.num_controls		= NUM_CONTROLS,
+	.num_controls		= NUM_COUNTERS,
 	.num_virt_counters	= NUM_VIRT_COUNTERS,
 	.reserved		= MSR_AMD_EVENTSEL_RESERVED,
 	.event_mask		= OP_EVENT_MASK,
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 2bf90fa..f8e268e 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -35,13 +35,15 @@ static void ppro_fill_in_addresses(struct op_msrs * const msrs)
 	int i;
 
 	for (i = 0; i < num_counters; i++) {
-		if (reserve_perfctr_nmi(MSR_P6_PERFCTR0 + i))
-			msrs->counters[i].addr = MSR_P6_PERFCTR0 + i;
-	}
-
-	for (i = 0; i < num_counters; i++) {
-		if (reserve_evntsel_nmi(MSR_P6_EVNTSEL0 + i))
-			msrs->controls[i].addr = MSR_P6_EVNTSEL0 + i;
+		if (!reserve_perfctr_nmi(MSR_P6_PERFCTR0 + i))
+			continue;
+		if (!reserve_evntsel_nmi(MSR_P6_EVNTSEL0 + i)) {
+			release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
+			continue;
+		}
+		/* both registers must be reserved */
+		msrs->counters[i].addr = MSR_P6_PERFCTR0 + i;
+		msrs->controls[i].addr = MSR_P6_EVNTSEL0 + i;
 	}
 }
 
@@ -92,12 +94,10 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 			op_x86_warn_in_use(i);
 		val &= model->reserved;
 		wrmsrl(msrs->controls[i].addr, val);
-	}
-
-	/* avoid a false detection of ctr overflows in NMI handler */
-	for (i = 0; i < num_counters; ++i) {
-		if (unlikely(!msrs->counters[i].addr))
-			continue;
+		/*
+		 * avoid a false detection of ctr overflows in NMI *
+		 * handler
+		 */
 		wrmsrl(msrs->counters[i].addr, -1LL);
 	}
 
@@ -194,12 +194,10 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 	int i;
 
 	for (i = 0; i < num_counters; ++i) {
-		if (msrs->counters[i].addr)
-			release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
-	}
-	for (i = 0; i < num_counters; ++i) {
-		if (msrs->controls[i].addr)
-			release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
+		if (!msrs->counters[i].addr)
+			continue;
+		release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
+		release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
 	}
 	if (reset_value) {
 		kfree(reset_value);
-- 
1.7.0.3


