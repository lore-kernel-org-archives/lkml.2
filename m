Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab0EDKrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 06:47:13 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:2066 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab0EDKqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 06:46:54 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1W5XR-02-5I5-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 6/7] oprofile/x86: move IBS code
Date: Tue, 4 May 2010 12:44:52 +0200
Message-ID: <1272969893-29233-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1272969893-29233-1-git-send-email-robert.richter@amd.com>
References: <1272969893-29233-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving code to make future changes easier. This groups all IBS code
together.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |  220 +++++++++++++++++++-------------------
 1 files changed, 110 insertions(+), 110 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 536d0b0..e159254 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -102,116 +102,6 @@ static u32 get_ibs_caps(void)
 	return ibs_caps;
 }
 
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-
-static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
-			       struct op_msrs const * const msrs)
-{
-	u64 val;
-	int i;
-
-	/* enable active counters */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		int virt = op_x86_phys_to_virt(i);
-		if (!reset_value[virt])
-			continue;
-		rdmsrl(msrs->controls[i].addr, val);
-		val &= model->reserved;
-		val |= op_x86_get_ctrl(model, &counter_config[virt]);
-		wrmsrl(msrs->controls[i].addr, val);
-	}
-}
-
-#endif
-
-/* functions for op_amd_spec */
-
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
-static int op_amd_fill_in_addresses(struct op_msrs * const msrs)
-{
-	int i;
-
-	for (i = 0; i < NUM_COUNTERS; i++) {
-		if (!reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
-			goto fail;
-		if (!reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i)) {
-			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-			goto fail;
-		}
-		/* both registers must be reserved */
-		msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
-		msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
-		continue;
-	fail:
-		if (!counter_config[i].enabled)
-			continue;
-		op_x86_warn_reserved(i);
-		op_amd_shutdown(msrs);
-		return -EBUSY;
-	}
-
-	return 0;
-}
-
-static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
-			      struct op_msrs const * const msrs)
-{
-	u64 val;
-	int i;
-
-	/* setup reset_value */
-	for (i = 0; i < NUM_VIRT_COUNTERS; ++i) {
-		if (counter_config[i].enabled
-		    && msrs->counters[op_x86_virt_to_phys(i)].addr)
-			reset_value[i] = counter_config[i].count;
-		else
-			reset_value[i] = 0;
-	}
-
-	/* clear all counters */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (!msrs->controls[i].addr)
-			continue;
-		rdmsrl(msrs->controls[i].addr, val);
-		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
-			op_x86_warn_in_use(i);
-		val &= model->reserved;
-		wrmsrl(msrs->controls[i].addr, val);
-		/*
-		 * avoid a false detection of ctr overflows in NMI
-		 * handler
-		 */
-		wrmsrl(msrs->counters[i].addr, -1LL);
-	}
-
-	/* enable active counters */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		int virt = op_x86_phys_to_virt(i);
-		if (!reset_value[virt])
-			continue;
-
-		/* setup counter registers */
-		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[virt]);
-
-		/* setup control registers */
-		rdmsrl(msrs->controls[i].addr, val);
-		val &= model->reserved;
-		val |= op_x86_get_ctrl(model, &counter_config[virt]);
-		wrmsrl(msrs->controls[i].addr, val);
-	}
-}
-
 /*
  * 16-bit Linear Feedback Shift Register (LFSR)
  *
@@ -376,6 +266,116 @@ static void op_amd_stop_ibs(void)
 		wrmsrl(MSR_AMD64_IBSOPCTL, 0);
 }
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
+			       struct op_msrs const * const msrs)
+{
+	u64 val;
+	int i;
+
+	/* enable active counters */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (!reset_value[virt])
+			continue;
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		val |= op_x86_get_ctrl(model, &counter_config[virt]);
+		wrmsrl(msrs->controls[i].addr, val);
+	}
+}
+
+#endif
+
+/* functions for op_amd_spec */
+
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
+static int op_amd_fill_in_addresses(struct op_msrs * const msrs)
+{
+	int i;
+
+	for (i = 0; i < NUM_COUNTERS; i++) {
+		if (!reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
+			goto fail;
+		if (!reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i)) {
+			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+			goto fail;
+		}
+		/* both registers must be reserved */
+		msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
+		msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
+		continue;
+	fail:
+		if (!counter_config[i].enabled)
+			continue;
+		op_x86_warn_reserved(i);
+		op_amd_shutdown(msrs);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
+			      struct op_msrs const * const msrs)
+{
+	u64 val;
+	int i;
+
+	/* setup reset_value */
+	for (i = 0; i < NUM_VIRT_COUNTERS; ++i) {
+		if (counter_config[i].enabled
+		    && msrs->counters[op_x86_virt_to_phys(i)].addr)
+			reset_value[i] = counter_config[i].count;
+		else
+			reset_value[i] = 0;
+	}
+
+	/* clear all counters */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		if (!msrs->controls[i].addr)
+			continue;
+		rdmsrl(msrs->controls[i].addr, val);
+		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
+			op_x86_warn_in_use(i);
+		val &= model->reserved;
+		wrmsrl(msrs->controls[i].addr, val);
+		/*
+		 * avoid a false detection of ctr overflows in NMI
+		 * handler
+		 */
+		wrmsrl(msrs->counters[i].addr, -1LL);
+	}
+
+	/* enable active counters */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (!reset_value[virt])
+			continue;
+
+		/* setup counter registers */
+		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[virt]);
+
+		/* setup control registers */
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		val |= op_x86_get_ctrl(model, &counter_config[virt]);
+		wrmsrl(msrs->controls[i].addr, val);
+	}
+}
+
 static int op_amd_check_ctrs(struct pt_regs * const regs,
 			     struct op_msrs const * const msrs)
 {
-- 
1.7.0.3


