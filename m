Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab1KDL1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 07:27:03 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58209 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab1KDL0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 07:26:38 -0400
From: Borislav Petkov <bp@amd64.org>
To: linux-stable <stable@vger.kernel.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] x86, amd: Move BSP code to cpu_dev helper
Date: Fri,  4 Nov 2011 12:26:34 +0100
Message-Id: <1320405995-10199-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <20111104112209.GB8020@aftab>
References: <20111104112209.GB8020@aftab>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upstream commit: 8fa8b035085e7320c15875c1f6b03b290ca2dd66

Move code which is run once on the BSP during boot into the cpu_dev
helper.

[ hpa: removed bogus cpu_has -> static_cpu_has conversion ]

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/20110805180409.GC26217@aftab
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/amd.c |   59 ++++++++++++++++++++++-----------------------
 1 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index b0234bc..b6e3e87 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -410,6 +410,34 @@ static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 #endif
 }
 
+static void __cpuinit bsp_init_amd(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+
+		if (c->x86 > 0x10 ||
+		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
+			u64 val;
+
+			rdmsrl(MSR_K7_HWCR, val);
+			if (!(val & BIT(24)))
+				printk(KERN_WARNING FW_BUG "TSC doesn't count "
+					"with P0 frequency!\n");
+		}
+	}
+
+	if (c->x86 == 0x15) {
+		unsigned long upperbit;
+		u32 cpuid, assoc;
+
+		cpuid	 = cpuid_edx(0x80000005);
+		assoc	 = cpuid >> 16 & 0xff;
+		upperbit = ((cpuid >> 24) << 10) / assoc;
+
+		va_align.mask	  = (upperbit - 1) & PAGE_MASK;
+		va_align.flags    = ALIGN_VA_32 | ALIGN_VA_64;
+	}
+}
+
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 	early_init_amd_mc(c);
@@ -441,36 +469,6 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
 	}
 #endif
-
-	/* We need to do the following only once */
-	if (c != &boot_cpu_data)
-		return;
-
-	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
-
-		if (c->x86 > 0x10 ||
-		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
-			u64 val;
-
-			rdmsrl(MSR_K7_HWCR, val);
-			if (!(val & BIT(24)))
-				printk(KERN_WARNING FW_BUG "TSC doesn't count "
-					"with P0 frequency!\n");
-		}
-	}
-
-	if (c->x86 == 0x15) {
-		unsigned long upperbit;
-		u32 cpuid, assoc;
-
-		cpuid	 = cpuid_edx(0x80000005);
-		assoc	 = cpuid >> 16 & 0xff;
-		upperbit = ((cpuid >> 24) << 10) / assoc;
-
-		va_align.mask	  = (upperbit - 1) & PAGE_MASK;
-		va_align.flags    = ALIGN_VA_32 | ALIGN_VA_64;
-
-	}
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
@@ -692,6 +690,7 @@ static const struct cpu_dev __cpuinitconst amd_cpu_dev = {
 	.c_size_cache	= amd_size_cache,
 #endif
 	.c_early_init   = early_init_amd,
+	.c_bsp_init	= bsp_init_amd,
 	.c_init		= init_amd,
 	.c_x86_vendor	= X86_VENDOR_AMD,
 };
-- 
1.7.8.rc0

