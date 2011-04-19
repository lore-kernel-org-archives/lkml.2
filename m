Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab1DSVHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:07:35 -0400
Received: from kroah.org ([198.145.64.141]:39401 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab1DSVEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:04:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 14:03:23 2011
Message-Id: <20110419210323.778372899@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 14:02:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [14/26] x86, amd: Disable GartTlbWlkErr when BIOS forgets it
In-Reply-To: <20110419210333.GA17417@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
Link: http://lkml.kernel.org/r/20110415131152.GJ18463@8bytes.org
Tested-by: Alexandre Demers <alexandre.f.demers@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/msr-index.h |    4 ++++
 arch/x86/kernel/cpu/amd.c        |   19 +++++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -82,11 +82,15 @@
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
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
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


