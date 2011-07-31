Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1GaSjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 14:39:17 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:36532 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1GaSjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 14:39:12 -0400
Message-ID: <4E35A14E.90702@gmail.com>
Date: Sun, 31 Jul 2011 20:39:10 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] oprofile, x86: Move memory allocation for ppro out of
 per cpu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ppro_setup_ctrs is called on all cpu's, while init is only called once.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>

---
Oprofile shutdown is still broken. Doing kfree in the shutdown call gave
me a warning of in_atomic, so I moved to exit. This also allowed me to
remove the null pointer checks, by zeroing reset_value on shutdown. But
even with shutdown being broken on -rt at least I can run oprofile now. :)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 96646b3..fef08b2 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -790,5 +790,7 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 
 void op_nmi_exit(void)
 {
+	if (model->exit)
+		model->exit();
 	exit_suspend_resume();
 }
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 94b7450..aefefcc 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -30,6 +30,20 @@ static int counter_width = 32;
 
 static u64 *reset_value;
 
+static int ppro_init(struct oprofile_operations *ignore)
+{
+	reset_value = kzalloc(sizeof(reset_value[0]) * num_counters,
+				GFP_KERNEL);
+	if (!reset_value)
+		return -ENOMEM;
+	return 0;
+}
+
+static void ppro_exit(void)
+{
+	kfree(reset_value);
+}
+
 static void ppro_shutdown(struct op_msrs const * const msrs)
 {
 	int i;
@@ -39,10 +53,7 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 			continue;
 		release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
 		release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
-	}
-	if (reset_value) {
-		kfree(reset_value);
-		reset_value = NULL;
+		reset_value[i] = 0;
 	}
 }
 
@@ -79,13 +90,6 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 	u64 val;
 	int i;
 
-	if (!reset_value) {
-		reset_value = kzalloc(sizeof(reset_value[0]) * num_counters,
-					GFP_ATOMIC);
-		if (!reset_value)
-			return;
-	}
-
 	if (cpu_has_arch_perfmon) {
 		union cpuid10_eax eax;
 		eax.full = cpuid_eax(0xa);
@@ -141,13 +145,6 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 	u64 val;
 	int i;
 
-	/*
-	 * This can happen if perf counters are in use when
-	 * we steal the die notifier NMI.
-	 */
-	if (unlikely(!reset_value))
-		goto out;
-
 	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
@@ -158,7 +155,6 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 		wrmsrl(msrs->counters[i].addr, -reset_value[i]);
 	}
 
-out:
 	/* Only P6 based Pentium M need to re-unmask the apic vector but it
 	 * doesn't hurt other P6 variant */
 	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
@@ -179,8 +175,6 @@ static void ppro_start(struct op_msrs const * const msrs)
 	u64 val;
 	int i;
 
-	if (!reset_value)
-		return;
 	for (i = 0; i < num_counters; ++i) {
 		if (reset_value[i]) {
 			rdmsrl(msrs->controls[i].addr, val);
@@ -196,8 +190,6 @@ static void ppro_stop(struct op_msrs const * const msrs)
 	u64 val;
 	int i;
 
-	if (!reset_value)
-		return;
 	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
@@ -211,6 +203,8 @@ struct op_x86_model_spec op_ppro_spec = {
 	.num_counters		= 2,
 	.num_controls		= 2,
 	.reserved		= MSR_PPRO_EVENTSEL_RESERVED,
+	.init			= &ppro_init,
+	.exit			= &ppro_exit,
 	.fill_in_addresses	= &ppro_fill_in_addresses,
 	.setup_ctrs		= &ppro_setup_ctrs,
 	.check_ctrs		= &ppro_check_ctrs,
@@ -251,12 +245,13 @@ static void arch_perfmon_setup_counters(void)
 static int arch_perfmon_init(struct oprofile_operations *ignore)
 {
 	arch_perfmon_setup_counters();
-	return 0;
+	return ppro_init(ignore);
 }
 
 struct op_x86_model_spec op_arch_perfmon_spec = {
 	.reserved		= MSR_PPRO_EVENTSEL_RESERVED,
 	.init			= &arch_perfmon_init,
+	.exit			= &ppro_exit,
 	/* num_counters/num_controls filled in at runtime */
 	.fill_in_addresses	= &ppro_fill_in_addresses,
 	/* user space does the cpuid check for available events */
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 89017fa..e77fd91 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -40,6 +40,7 @@ struct op_x86_model_spec {
 	u64		reserved;
 	u16		event_mask;
 	int		(*init)(struct oprofile_operations *ops);
+	void		(*exit)(void);
 	int		(*fill_in_addresses)(struct op_msrs * const msrs);
 	void		(*setup_ctrs)(struct op_x86_model_spec const *model,
 				      struct op_msrs const * const msrs);

