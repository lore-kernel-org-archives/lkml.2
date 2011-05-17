Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab1EQWmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:42:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:7744 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731Ab1EQWmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:42:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,227,1304319600"; 
   d="scan'208";a="3050257"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Avi Kivity" <avi@redhat.com>,
        "Arjan van de Ven" <arjan@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 2/9] x86/kernel/cpu/intel.c: Initialize Enhanced REP MOVSB/STOSBenhanced
Date: Tue, 17 May 2011 15:29:11 -0700
Message-Id: <1305671358-14478-3-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

If kernel intends to use enhanced REP MOVSB/STOSB, it must ensure
IA32_MISC_ENABLE.Fast_String_Enable (bit 0) is set and CPUID.(EAX=07H, ECX=0H):
EBX[bit 9] also reports 1.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/cpu/intel.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 32e86aa..1edf5ba 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -29,10 +29,10 @@
 
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
+	u64 misc_enable;
+
 	/* Unmask CPUID levels if masked: */
 	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
-		u64 misc_enable;
-
 		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 
 		if (misc_enable & MSR_IA32_MISC_ENABLE_LIMIT_CPUID) {
@@ -118,8 +118,6 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	 * (model 2) with the same problem.
 	 */
 	if (c->x86 == 15) {
-		u64 misc_enable;
-
 		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 
 		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
@@ -130,6 +128,19 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+
+	/*
+	 * If fast string is not enabled in IA32_MISC_ENABLE for any reason,
+	 * clear the fast string and enhanced fast string CPU capabilities.
+	 */
+	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
+		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		if (!(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
+			printk(KERN_INFO "Disabled fast string operations\n");
+			setup_clear_cpu_cap(X86_FEATURE_REP_GOOD);
+			setup_clear_cpu_cap(X86_FEATURE_ERMS);
+		}
+	}
 }
 
 #ifdef CONFIG_X86_32
-- 
1.7.2

