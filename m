Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab1DONLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 09:11:55 -0400
Received: from 8bytes.org ([88.198.83.132]:59029 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab1DONLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 09:11:54 -0400
Date: Fri, 15 Apr 2011 15:11:52 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        alexandre.f.demers@gmail.com
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110415131152.GJ18463@8bytes.org>
References: <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org> <20110413193459.GL19819@8bytes.org> <4DA60C30.4060606@kernel.org> <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com> <4DA6145D.9070703@kernel.org> <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com> <4DA655E7.3000904@zytor.com> <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com> <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 07:33:40PM -0700, Linus Torvalds wrote:
>  we definitely want to also understand the reason for things not
> working, even if we do revert..

Okay, here it is.

After experimenting with different configurations for the north-bridge
it turned out that a GART related MCE fires at the time the machine
reboots. BIOSes configure the machine to sync-flood in that case which
causes a reboot.

After decoding the MCE it turned out to be a GART TBL Wlk Error. Such
errors can happen if devices (speculativly) access GART ranges mapped
invalid. The AMD BKDG for Fam10h CPUs recommends to disable these errors
at all. But unfortunatly some BIOSes (including the one on my laptop)
forget to do this.

Below is a patch which disables these errors if the BIOS didn't do it.
It fixes the problem on my site.

Alexandre, can you try this patch on your machine too, please?

Regards,

	Joerg

>From aaacff8db50b6ed4345e337ecbe53e505699c7e5 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Fri, 15 Apr 2011 14:47:40 +0200
Subject: [PATCH] x86/amd: Disable GartTlbWlkErr when BIOS forgets it

This patch disables GartTlbWlk errors on AMD Fam10h CPUs if
the BIOS forgets to do is (or is just too old). Letting
these errors enabled can cause a sync-flood on the CPU
causing a reboot.

This patch is the fix for

	https://bugzilla.kernel.org/show_bug.cgi?id=33012

on my machine.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
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
-- 
1.7.1

