Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab1HEW7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 18:59:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:56401 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756923Ab1HEW7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 18:59:35 -0400
Date: Fri, 5 Aug 2011 22:59:24 GMT
From: tip-bot for Borislav Petkov <bp@amd64.org>
Message-ID: <tip-8fa8b035085e7320c15875c1f6b03b290ca2dd66@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, bp@amd64.org,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@amd64.org, hpa@linux.intel.com,
        borislav.petkov@amd.com
In-Reply-To: <20110805180409.GC26217@aftab>
References: <20110805180409.GC26217@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, amd: Move BSP code to cpu_dev helper
Git-Commit-ID: 8fa8b035085e7320c15875c1f6b03b290ca2dd66
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Aug 2011 22:59:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8fa8b035085e7320c15875c1f6b03b290ca2dd66
Gitweb:     http://git.kernel.org/tip/8fa8b035085e7320c15875c1f6b03b290ca2dd66
Author:     Borislav Petkov <bp@amd64.org>
AuthorDate: Fri, 5 Aug 2011 20:04:09 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 5 Aug 2011 12:32:33 -0700

x86, amd: Move BSP code to cpu_dev helper

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
