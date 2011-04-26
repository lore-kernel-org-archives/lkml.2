Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab1DZV1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:27:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:61258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347Ab1DZVOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738831873"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: joerg.roedel@amd.com, ak@linux.intel.com, alexandre.f.demers@gmail.com,
        hpa@linux.intel.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [66/106] x86, amd: Disable GartTlbWlkErr when BIOS forgets it
Message-Id: <20110426211347.3AF473E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Joerg Roedel <joerg.roedel@amd.com>

commit 5bbc097d890409d8eff4e3f1d26f11a9d6b7c07e upstream.

This patch disables GartTlbWlk errors on AMD Fam10h CPUs if
the BIOS forgets to do is (or is just too old). Letting
these errors enabled can cause a sync-flood on the CPU
causing a reboot.

The AMD BKDG recommends disabling GART TLB Wlk Error completely.

This patch is the fix for

	https://bugzilla.kernel.org/show_bug.cgi?id=33012

on my machine.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/20110415131152.GJ18463@8bytes.org
Tested-by: Alexandre Demers <alexandre.f.demers@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/msr-index.h |    4 ++++
 arch/x86/kernel/cpu/amd.c        |   19 +++++++++++++++++++
 2 files changed, 23 insertions(+)

Index: linux-2.6.35.y/arch/x86/include/asm/msr-index.h
===================================================================
--- linux-2.6.35.y.orig/arch/x86/include/asm/msr-index.h
+++ linux-2.6.35.y/arch/x86/include/asm/msr-index.h
@@ -85,11 +85,15 @@
 #define MSR_IA32_MC0_ADDR		0x00000402
 #define MSR_IA32_MC0_MISC		0x00000403
 
+#define MSR_AMD64_MC0_MASK		0xc0010044
+
 #define MSR_IA32_MCx_CTL(x)		(MSR_IA32_MC0_CTL + 4*(x))
 #define MSR_IA32_MCx_STATUS(x)		(MSR_IA32_MC0_STATUS + 4*(x))
 #define MSR_IA32_MCx_ADDR(x)		(MSR_IA32_MC0_ADDR + 4*(x))
 #define MSR_IA32_MCx_MISC(x)		(MSR_IA32_MC0_MISC + 4*(x))
 
+#define MSR_AMD64_MCx_MASK(x)		(MSR_AMD64_MC0_MASK + (x))
+
 /* These are consecutive and not in the normal 4er MCE bank block */
 #define MSR_IA32_MC0_CTL2		0x00000280
 #define MSR_IA32_MCx_CTL2(x)		(MSR_IA32_MC0_CTL2 + (x))
Index: linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
@@ -568,6 +568,25 @@ static void __cpuinit init_amd(struct cp
 	/* As a rule processors have APIC timer running in deep C states */
 	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
 		set_cpu_cap(c, X86_FEATURE_ARAT);
+
+	/*
+	 * Disable GART TLB Walk Errors on Fam10h. We do this here
+	 * because this is always needed when GART is enabled, even in a
+	 * kernel which has no MCE support built in.
+	 */
+	if (c->x86 == 0x10) {
+		/*
+		 * BIOS should disable GartTlbWlk Errors themself. If
+		 * it doesn't do it here as suggested by the BKDG.
+		 *
+		 * Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=33012
+		 */
+		u64 mask;
+
+		rdmsrl(MSR_AMD64_MCx_MASK(4), mask);
+		mask |= (1 << 10);
+		wrmsrl(MSR_AMD64_MCx_MASK(4), mask);
+	}
 }
 
 #ifdef CONFIG_X86_32
