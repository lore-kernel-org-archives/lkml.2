Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab1DPAEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 20:04:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:57096 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab1DPAET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 20:04:19 -0400
Date: Sat, 16 Apr 2011 00:03:57 GMT
From: tip-bot for Joerg Roedel <joerg.roedel@amd.com>
Message-ID: <tip-5bbc097d890409d8eff4e3f1d26f11a9d6b7c07e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joerg.roedel@amd.com, stable@kernel.org, alexandre.f.demers@gmail.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, stable@kernel.org, tglx@linutronix.de,
        alexandre.f.demers@gmail.com, hpa@linux.intel.com
In-Reply-To: <20110415131152.GJ18463@8bytes.org>
References: <20110415131152.GJ18463@8bytes.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, amd: Disable GartTlbWlkErr when BIOS forgets it
Git-Commit-ID: 5bbc097d890409d8eff4e3f1d26f11a9d6b7c07e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Apr 2011 00:03:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5bbc097d890409d8eff4e3f1d26f11a9d6b7c07e
Gitweb:     http://git.kernel.org/tip/5bbc097d890409d8eff4e3f1d26f11a9d6b7c07e
Author:     Joerg Roedel <joerg.roedel@amd.com>
AuthorDate: Fri, 15 Apr 2011 14:47:40 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 15 Apr 2011 16:03:16 -0700

x86, amd: Disable GartTlbWlkErr when BIOS forgets it

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
Cc: <stable@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/msr-index.h |    4 ++++
 arch/x86/kernel/cpu/amd.c        |   19 +++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index fd5a1f3..3cce714 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -96,11 +96,15 @@
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
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 3ecece0..3532d3b 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -615,6 +615,25 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
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
