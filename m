Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab1GaQuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 12:50:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61583 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1GaQuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 12:50:11 -0400
Message-ID: <4E3587C0.4040406@gmail.com>
Date: Sun, 31 Jul 2011 18:50:08 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] oprofile, x86: Move memory allocation to init
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ppro_setup_ctrs is called on all cpu's, while init is only called once.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>

---
Fixes oprofile on 3.0 rt6.

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 94b7450..53a84fc 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -79,13 +79,6 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
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
@@ -228,7 +221,7 @@ struct op_x86_model_spec op_ppro_spec = {
  * the specific CPU.
  */
 
-static void arch_perfmon_setup_counters(void)
+static int arch_perfmon_setup_counters(void)
 {
 	union cpuid10_eax eax;
 
@@ -246,12 +239,17 @@ static void arch_perfmon_setup_counters(void)
 
 	op_arch_perfmon_spec.num_counters = num_counters;
 	op_arch_perfmon_spec.num_controls = num_counters;
+
+	reset_value = kzalloc(sizeof(reset_value[0]) * num_counters,
+				GFP_KERNEL);
+	if (!reset_value)
+		return -ENOMEM;
+	return 0;
 }
 
 static int arch_perfmon_init(struct oprofile_operations *ignore)
 {
-	arch_perfmon_setup_counters();
-	return 0;
+	return arch_perfmon_setup_counters();
 }
 
 struct op_x86_model_spec op_arch_perfmon_spec = {


