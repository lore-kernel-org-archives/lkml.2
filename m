Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab0EDKsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 06:48:14 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:20394 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab0EDKqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 06:46:48 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1W5XR-02-5I7-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/7] oprofile/x86: moving shutdown functions
Date: Tue, 4 May 2010 12:44:50 +0200
Message-ID: <1272969893-29233-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1272969893-29233-1-git-send-email-robert.richter@amd.com>
References: <1272969893-29233-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving some code in preparation of the next patch.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c  |   24 +++++++++++-----------
 arch/x86/oprofile/op_model_p4.c   |   38 +++++++++++++++++-------------------
 arch/x86/oprofile/op_model_ppro.c |   33 +++++++++++++++----------------
 3 files changed, 46 insertions(+), 49 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 2e2bc90..7e5886d 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -126,6 +126,18 @@ static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
 
 /* functions for op_amd_spec */
 
+static void op_amd_shutdown(struct op_msrs const * const msrs)
+{
+	int i;
+
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		if (!msrs->counters[i].addr)
+			continue;
+		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+	}
+}
+
 static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 {
 	int i;
@@ -422,18 +434,6 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	op_amd_stop_ibs();
 }
 
-static void op_amd_shutdown(struct op_msrs const * const msrs)
-{
-	int i;
-
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (!msrs->counters[i].addr)
-			continue;
-		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-	}
-}
-
 static u8 ibs_eilvt_off;
 
 static inline void apic_init_ibs_nmi_per_cpu(void *arg)
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index e6a160a..7cc80df 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -385,6 +385,24 @@ static unsigned int get_stagger(void)
 
 static unsigned long reset_value[NUM_COUNTERS_NON_HT];
 
+static void p4_shutdown(struct op_msrs const * const msrs)
+{
+	int i;
+
+	for (i = 0; i < num_counters; ++i) {
+		if (msrs->counters[i].addr)
+			release_perfctr_nmi(msrs->counters[i].addr);
+	}
+	/*
+	 * some of the control registers are specially reserved in
+	 * conjunction with the counter registers (hence the starting offset).
+	 * This saves a few bits.
+	 */
+	for (i = num_counters; i < num_controls; ++i) {
+		if (msrs->controls[i].addr)
+			release_evntsel_nmi(msrs->controls[i].addr);
+	}
+}
 
 static void p4_fill_in_addresses(struct op_msrs * const msrs)
 {
@@ -668,26 +686,6 @@ static void p4_stop(struct op_msrs const * const msrs)
 	}
 }
 
-static void p4_shutdown(struct op_msrs const * const msrs)
-{
-	int i;
-
-	for (i = 0; i < num_counters; ++i) {
-		if (msrs->counters[i].addr)
-			release_perfctr_nmi(msrs->counters[i].addr);
-	}
-	/*
-	 * some of the control registers are specially reserved in
-	 * conjunction with the counter registers (hence the starting offset).
-	 * This saves a few bits.
-	 */
-	for (i = num_counters; i < num_controls; ++i) {
-		if (msrs->controls[i].addr)
-			release_evntsel_nmi(msrs->controls[i].addr);
-	}
-}
-
-
 #ifdef CONFIG_SMP
 struct op_x86_model_spec op_p4_ht2_spec = {
 	.num_counters		= NUM_COUNTERS_HT2,
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index f8e268e..b07d25a 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -30,6 +30,22 @@ static int counter_width = 32;
 
 static u64 *reset_value;
 
+static void ppro_shutdown(struct op_msrs const * const msrs)
+{
+	int i;
+
+	for (i = 0; i < num_counters; ++i) {
+		if (!msrs->counters[i].addr)
+			continue;
+		release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
+		release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
+	}
+	if (reset_value) {
+		kfree(reset_value);
+		reset_value = NULL;
+	}
+}
+
 static void ppro_fill_in_addresses(struct op_msrs * const msrs)
 {
 	int i;
@@ -189,23 +205,6 @@ static void ppro_stop(struct op_msrs const * const msrs)
 	}
 }
 
-static void ppro_shutdown(struct op_msrs const * const msrs)
-{
-	int i;
-
-	for (i = 0; i < num_counters; ++i) {
-		if (!msrs->counters[i].addr)
-			continue;
-		release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
-		release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
-	}
-	if (reset_value) {
-		kfree(reset_value);
-		reset_value = NULL;
-	}
-}
-
-
 struct op_x86_model_spec op_ppro_spec = {
 	.num_counters		= 2,
 	.num_controls		= 2,
-- 
1.7.0.3


