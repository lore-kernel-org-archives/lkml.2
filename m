Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab1HFLm5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 07:42:57 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:61094 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755638Ab1HFLmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 07:42:53 -0400
X-AuditID: 1209190e-b7c22ae000000a2c-2c-4e3d2853d9f4
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Fenghua Yu <fenghua.yu@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 1/2] x86: Enable fast strings on Intel if BIOS hasn't already
Date: Sat,  6 Aug 2011 07:42:35 -0400
Message-Id: <9a8f28ccbe44cd323a01e9a23b531cb869185a21.1312630712.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312630712.git.luto@mit.edu>
References: <cover.1312630712.git.luto@mit.edu>
In-Reply-To: <cover.1312630712.git.luto@mit.edu>
References: <cover.1312630712.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsUixG6nohusYetnsL9FzaLvylF2i7ZpjhY7
	H75ls1i+r5/R4vKuOWwWWy41s1pcfTibxeLHhsesDhwet9r+MHvsnHWX3WPxnpdMHptWdbJ5
	rLvxld3j8ya5ALYoLpuU1JzMstQifbsEroze1VUFi0Qrjn07x9bA2CvYxcjJISFgInFgTTcj
	hC0mceHeerYuRi4OIYF9jBIzDvWwQzjrGSVONmxignCeMkmcmTuBBaSFTUBFomPpAyYQW0TA
	QGLLyhesIEXMAlcYJS7Ov8HcxcjBISwQIPH6OSdIDYuAqsTH88/YQWxegSCJJ78esUOslpM4
	cvk52BxOoDmfv7azgdhCAvoSR45OZcMlPoFRYAEjwypG2ZTcKt3cxMyc4tRk3eLkxLy81CJd
	Y73czBK91JTSTYygAOaU5NvB+PWg0iFGAQ5GJR5eS3kbPyHWxLLiytxDjJIcTEqivKzqtn5C
	fEn5KZUZicUZ8UWlOanFhxglOJiVRHhzdIHKeVMSK6tSi/JhUtIcLErivFHe/32FBNITS1Kz
	U1MLUotgsjIcHEoSvCdAhgoWpaanVqRl5pQgpJk4OEGG8wANtwOp4S0uSMwtzkyHyJ9iVJQS
	570KkhAASWSU5sH1whLMK0ZxoFeEefeBVPEAkxNc9yugwUxAg3OfgFxdXJKIkJJqYDTRfyrR
	feWMUu9pbmcPzqqm/uLtH+R5DE9dy9nHHfp/7e8Xr5ewGl/2WJ/VVtl1hJ83x76/Rejo/Kwf
	//axrb598ljI4j/axb6i+cE3Sz63ay35Kvkw28zsXH3wjKRT7N+eVD51N2gp1dauLt7a3qjT
	/tq/1mjuz45OmzNeE6IV437l3MqsVmIpzkg01GIuKk4EAIdNcJkLAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel SDM volume 3A, 8.4.2 says:

  Software can disable fast-string operation by clearing the
  fast-string-enable bit (bit 0) of IA32_MISC_ENABLE MSR.
  However, Intel recomments that system software always enable
  fast-string operation.

The Intel DQ67SW board (with latest BIOS) disables fast string
operations if TXT is enabled.  A Lenovo X220 disables it regardless
of TXT setting.  I doubt I'm the only person with a dumb BIOS like
this.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/cpu/intel.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ed6086e..c80ab41 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -30,6 +30,7 @@
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
 	u64 misc_enable;
+	bool allow_fast_string = true;
 
 	/* Unmask CPUID levels if masked: */
 	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
@@ -118,8 +119,9 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	 * (model 2) with the same problem.
 	 */
 	if (c->x86 == 15) {
-		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		allow_fast_string = false;
 
+		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
 			printk(KERN_INFO "kmemcheck: Disabling fast string operations\n");
 
@@ -130,11 +132,28 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 #endif
 
 	/*
-	 * If fast string is not enabled in IA32_MISC_ENABLE for any reason,
-	 * clear the fast string and enhanced fast string CPU capabilities.
+	 * If BIOS didn't enable fast string operation, try to enable
+	 * it ourselves.  If that fails, then clear the fast string
+	 * and enhanced fast string CPU capabilities.
 	 */
 	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
 		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+
+		if (allow_fast_string &&
+		    !(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
+			misc_enable |= MSR_IA32_MISC_ENABLE_FAST_STRING;
+			wrmsr_safe(MSR_IA32_MISC_ENABLE, (u32)misc_enable,
+				   (u32)(misc_enable >> 32));
+
+			/* Re-read to make sure it stuck. */
+			rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+
+			if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)
+				printk(KERN_WARNING FW_WARN "CPU #%d: "
+				       "IA32_MISC_ENABLE.FAST_STRING_ENABLE "
+				       "was not set", c->cpu_index);
+		}
+
 		if (!(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
 			printk(KERN_INFO "Disabled fast string operations\n");
 			setup_clear_cpu_cap(X86_FEATURE_REP_GOOD);
-- 
1.7.6

