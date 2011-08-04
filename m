Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1HDO6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:58:51 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55748 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab1HDO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:58:43 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, Andre Przywara <Andre.Przywara@amd.com>,
        Martin Pohlack <Martin.Pohlack@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v3 3/3] x86, AMD: Move BSP code to cpuinit helper
Date: Thu,  4 Aug 2011 16:58:38 +0200
Message-Id: <1312469918-6641-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1312469918-6641-1-git-send-email-bp@amd64.org>
References: <1312469918-6641-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Move code which is run once on the BSP during boot into the cpuinit
helper.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/amd.c |   55 +++++++++++++++++++++++---------------------
 1 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 5a48cac..8e2d6f8 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -410,6 +410,34 @@ static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 #endif
 }
 
+static void __cpuinit amd_run_on_bsp(void)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	if (static_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
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
+		u32 cpuid, assoc;
+
+		cpuid = cpuid_edx(0x80000005);
+		assoc = cpuid >> 16 & 0xff;
+
+		align_upperbit = ((cpuid >> 24) << 10) / assoc;
+		align_va_addr  = ALIGN_VA_32 | ALIGN_VA_64;
+	}
+}
+
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 	early_init_amd_mc(c);
@@ -442,32 +470,7 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 	}
 #endif
 
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
-		u32 cpuid, assoc;
-
-		cpuid = cpuid_edx(0x80000005);
-		assoc = cpuid >> 16 & 0xff;
-
-		align_upperbit = ((cpuid >> 24) << 10) / assoc;
-		align_va_addr  = ALIGN_VA_32 | ALIGN_VA_64;
-	}
+	x86_cpuinit.run_on_bsp = amd_run_on_bsp;
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
-- 
1.7.4.rc2

