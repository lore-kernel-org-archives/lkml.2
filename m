Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab1HESEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 14:04:15 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42434 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1HESEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 14:04:13 -0400
Date: Fri, 5 Aug 2011 20:04:09 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -v3.2 3/3] x86, AMD: Move BSP code to cpu_dev helper
Message-ID: <20110805180409.GC26217@aftab>
References: <1312550110-24160-1-git-send-email-bp@amd64.org>
 <4E3C2405.8090309@zytor.com>
 <20110805175522.GA26217@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805175522.GA26217@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move code which is run once on the BSP during boot into the cpu_dev
helper.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/amd.c |   59 ++++++++++++++++++++++-----------------------
 1 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index b0234bc..53d96f5 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -410,6 +410,34 @@ static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 #endif
 }
 
+static void __cpuinit bsp_init_amd(struct cpuinfo_x86 *c)
+{
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
1.7.4.rc2

