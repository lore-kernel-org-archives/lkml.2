Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1HQODi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 10:03:38 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:57944 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821Ab1HQODc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 10:03:32 -0400
X-AuditID: 12074424-b7bcaae000000a05-7b-4e4bca5fa43e
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Fenghua Yu <fenghua.yu@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v4 1/2] x86: Enable fast strings on Intel if BIOS hasn't already
Date: Wed, 17 Aug 2011 10:03:18 -0400
Message-Id: <e6c5440954c28e9738b8d4919a9db2d10c9a1757.1313586473.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1313586473.git.luto@mit.edu>
References: <cover.1313586473.git.luto@mit.edu>
In-Reply-To: <cover.1313586473.git.luto@mit.edu>
References: <cover.1313586473.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsUixG6noht/ytvPYMdiPou+K0fZLdqmOVrs
	fPiWzWL5vn5Gi8u75rBZbLnUzGpx9eFsFosfGx6zOnB43Gr7w+yxc9Zddo/Fe14yeWxa1cnm
	se7GV3aPz5vkAtiiuGxSUnMyy1KL9O0SuDIWfj/OWHBAvOJt52LWBsYpwl2MnBwSAiYS/3d/
	YYKwxSQu3FvP1sXIxSEksI9R4n7zHGYIZwOjxJMpF5ggnGdMEt/eT2cGaWETUJHoWPoArF1E
	wEBiy8oXrCBFzAJXGCUuzr8BViQsECBxZ9Z3FhCbRUBV4tXnD2BxXoEgiSubfkPtlpM4cvk5
	mM0JNOhz3yl2EFtIQF9i2ZoL7LjEJzAKLGBkWMUom5JbpZubmJlTnJqsW5ycmJeXWqRrrpeb
	WaKXmlK6iREcxC4qOxibDykdYhTgYFTi4Q3q9/ITYk0sK67MPcQoycGkJMobd9LbT4gvKT+l
	MiOxOCO+qDQntfgQowQHs5IIr89BoBxvSmJlVWpRPkxKmoNFSZzXZqeDn5BAemJJanZqakFq
	EUxWhoNDSYI3DWSoYFFqempFWmZOCUKaiYMTZDgP0PDJIDW8xQWJucWZ6RD5U4yKUuK86SAJ
	AZBERmkeXC8sybxiFAd6RZg3HKSKB5ig4LpfAQ1mAhp8a5cHyOCSRISUVAMjmwO3S4/Hfrnz
	L7+IXnXbti/Zhqn6z1c/JeXvXMfOeutE5j3g0pj379U0lk3P3XZ02244eiSC/96FWdwt9kbq
	LOGpMzOTpbsXqL1cm9jW5OqYdk+L2TKRS/2AxfsHsmYPXT22/XFb+uLS5UtTluZIanOvcVuz
	RmZFML/f7DN3Ek3nb5x/bqmGEktxRqKhFnNRcSIA0yU8BA0DAAA=
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
 arch/x86/kernel/cpu/intel.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ed6086e..1f7367d 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -30,6 +30,7 @@
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
 	u64 misc_enable;
+	bool allow_fast_string = true;
 
 	/* Unmask CPUID levels if masked: */
 	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
@@ -118,10 +119,11 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	 * (model 2) with the same problem.
 	 */
 	if (c->x86 == 15) {
-		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		allow_fast_string = false;
 
+		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
-			printk(KERN_INFO "kmemcheck: Disabling fast string operations\n");
+			printk_once(KERN_INFO "kmemcheck: Disabling fast string operations\n");
 
 			misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
 			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
@@ -130,13 +132,29 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
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
+				printk_once(KERN_INFO FW_WARN "IA32_MISC_ENABLE.FAST_STRING_ENABLE was not set\n");
+		}
+
 		if (!(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
-			printk(KERN_INFO "Disabled fast string operations\n");
+			if (allow_fast_string)
+				printk_once(KERN_INFO "Failed to enable fast string operations\n");
 			setup_clear_cpu_cap(X86_FEATURE_REP_GOOD);
 			setup_clear_cpu_cap(X86_FEATURE_ERMS);
 		}
-- 
1.7.6

