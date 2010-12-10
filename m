Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0LJLnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 06:43:43 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:13798
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755076Ab0LJLnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 06:43:39 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LD7N8H-02-2MM-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/2] oprofile, x86: Add support for 6 counters (AMD family 15h)
Date: Fri, 10 Dec 2010 12:29:58 +0100
Message-ID: <1291980598-21625-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291980598-21625-1-git-send-email-robert.richter@amd.com>
References: <1291980598-21625-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for up to 6 hardware counters for AMD family
15h cpus. There is a new MSR range for hardware counters beginning at
MSRC001_0200 Performance Event Select (PERF_CTL0).

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/msr-index.h |    4 +++
 arch/x86/oprofile/op_model_amd.c |   54 +++++++++++++++++++++++++------------
 2 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3ea3dc4..e1636d6 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -123,6 +123,10 @@
 #define MSR_AMD64_IBSCTL		0xc001103a
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
 
+/* Fam 15h MSRs */
+#define MSR_F15H_PERF_CTL		0xc0010200
+#define MSR_F15H_PERF_CTR		0xc0010201
+
 /* Fam 10h MSRs */
 #define MSR_FAM10H_MMIO_CONF_BASE	0xc0010058
 #define FAM10H_MMIO_CONF_ENABLE		(1<<0)
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index a011bcc..f2984d4 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -29,11 +29,12 @@
 #include "op_x86_model.h"
 #include "op_counter.h"
 
-#define NUM_COUNTERS 4
+#define NUM_COUNTERS		4
+#define NUM_COUNTERS_F15H	6
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-#define NUM_VIRT_COUNTERS 32
+#define NUM_VIRT_COUNTERS	32
 #else
-#define NUM_VIRT_COUNTERS NUM_COUNTERS
+#define NUM_VIRT_COUNTERS	0
 #endif
 
 #define OP_EVENT_MASK			0x0FFF
@@ -41,7 +42,8 @@
 
 #define MSR_AMD_EVENTSEL_RESERVED	((0xFFFFFCF0ULL<<32)|(1ULL<<21))
 
-static unsigned long reset_value[NUM_VIRT_COUNTERS];
+static int num_counters;
+static unsigned long reset_value[OP_MAX_COUNTER];
 
 #define IBS_FETCH_SIZE			6
 #define IBS_OP_SIZE			12
@@ -387,7 +389,7 @@ static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
 	int i;
 
 	/* enable active counters */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		int virt = op_x86_phys_to_virt(i);
 		if (!reset_value[virt])
 			continue;
@@ -406,7 +408,7 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 {
 	int i;
 
-	for (i = 0; i < NUM_COUNTERS; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (!msrs->counters[i].addr)
 			continue;
 		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
@@ -418,7 +420,7 @@ static int op_amd_fill_in_addresses(struct op_msrs * const msrs)
 {
 	int i;
 
-	for (i = 0; i < NUM_COUNTERS; i++) {
+	for (i = 0; i < num_counters; i++) {
 		if (!reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
 			goto fail;
 		if (!reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i)) {
@@ -426,8 +428,13 @@ static int op_amd_fill_in_addresses(struct op_msrs * const msrs)
 			goto fail;
 		}
 		/* both registers must be reserved */
-		msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
-		msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
+		if (num_counters == NUM_COUNTERS_F15H) {
+			msrs->counters[i].addr = MSR_F15H_PERF_CTR + (i << 1);
+			msrs->controls[i].addr = MSR_F15H_PERF_CTL + (i << 1);
+		} else {
+			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
+			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
+		}
 		continue;
 	fail:
 		if (!counter_config[i].enabled)
@@ -447,7 +454,7 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	int i;
 
 	/* setup reset_value */
-	for (i = 0; i < NUM_VIRT_COUNTERS; ++i) {
+	for (i = 0; i < OP_MAX_COUNTER; ++i) {
 		if (counter_config[i].enabled
 		    && msrs->counters[op_x86_virt_to_phys(i)].addr)
 			reset_value[i] = counter_config[i].count;
@@ -456,7 +463,7 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	}
 
 	/* clear all counters */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (!msrs->controls[i].addr)
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
@@ -472,7 +479,7 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	}
 
 	/* enable active counters */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		int virt = op_x86_phys_to_virt(i);
 		if (!reset_value[virt])
 			continue;
@@ -503,7 +510,7 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 	u64 val;
 	int i;
 
-	for (i = 0; i < NUM_COUNTERS; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		int virt = op_x86_phys_to_virt(i);
 		if (!reset_value[virt])
 			continue;
@@ -526,7 +533,7 @@ static void op_amd_start(struct op_msrs const * const msrs)
 	u64 val;
 	int i;
 
-	for (i = 0; i < NUM_COUNTERS; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[op_x86_phys_to_virt(i)])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
@@ -546,7 +553,7 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	 * Subtle: stop on all counters to avoid race with setting our
 	 * pm callback
 	 */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[op_x86_phys_to_virt(i)])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
@@ -698,18 +705,29 @@ static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 	return 0;
 }
 
+struct op_x86_model_spec op_amd_spec;
+
 static int op_amd_init(struct oprofile_operations *ops)
 {
 	init_ibs();
 	create_arch_files = ops->create_files;
 	ops->create_files = setup_ibs_files;
+
+	if (boot_cpu_data.x86 == 0x15) {
+		num_counters = NUM_COUNTERS_F15H;
+	} else {
+		num_counters = NUM_COUNTERS;
+	}
+
+	op_amd_spec.num_counters = num_counters;
+	op_amd_spec.num_controls = num_counters;
+	op_amd_spec.num_virt_counters = max(num_counters, NUM_VIRT_COUNTERS);
+
 	return 0;
 }
 
 struct op_x86_model_spec op_amd_spec = {
-	.num_counters		= NUM_COUNTERS,
-	.num_controls		= NUM_COUNTERS,
-	.num_virt_counters	= NUM_VIRT_COUNTERS,
+	/* num_counters/num_controls filled in at runtime */
 	.reserved		= MSR_AMD_EVENTSEL_RESERVED,
 	.event_mask		= OP_EVENT_MASK,
 	.init			= op_amd_init,
-- 
1.7.3.2


