Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab2HFRAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:00:46 -0400
Received: from mail.x86-64.org ([217.9.48.20]:57560 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756720Ab2HFRAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:00:43 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alex Shi <alex.shi@intel.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v1 3/4] x86, CPU: Add AMD TLB size detection
Date: Mon,  6 Aug 2012 19:00:38 +0200
Message-Id: <1344272439-29080-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1344272439-29080-1-git-send-email-bp@amd64.org>
References: <1344272439-29080-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Read I- and DTLB entries count from CPUID on AMD. Handle all the
different family-specific cases.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/amd.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 9d92e19039f0..bcd200839c90 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -737,6 +737,59 @@ static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c,
 }
 #endif
 
+static void __cpuinit cpu_detect_tlb_amd(struct cpuinfo_x86 *c)
+{
+	u32 ebx, eax, ecx, edx;
+	u16 mask = 0xfff;
+
+	if (c->x86 < 0xf)
+		return;
+
+	if (c->extended_cpuid_level < 0x80000006)
+		return;
+
+	cpuid(0x80000006, &eax, &ebx, &ecx, &edx);
+
+	tlb_lld_4k[ENTRIES] = (ebx >> 16) & mask;
+	tlb_lli_4k[ENTRIES] = ebx & mask;
+
+	/*
+	 * K8 doesn't have 2M/4M entries in the L2 TLB so read out the L1 TLB
+	 * characteristics from the CPUID function 0x80000005 instead.
+	 */
+	if (c->x86 == 0xf) {
+		cpuid(0x80000005, &eax, &ebx, &ecx, &edx);
+		mask = 0xff;
+	}
+
+	/* Handle DTLB 2M and 4M sizes, fall back to L1 if L2 is disabled */
+	if (!((eax >> 16) & mask)) {
+		u32 a, b, c, d;
+
+		cpuid(0x80000005, &a, &b, &c, &d);
+		tlb_lld_2m[ENTRIES] = (a >> 16) & 0xff;
+	} else {
+		tlb_lld_2m[ENTRIES] = (eax >> 16) & mask;
+	}
+
+	/* a 4M entry uses two 2M entries */
+	tlb_lld_4m[ENTRIES] = tlb_lld_2m[ENTRIES] >> 1;
+
+	/* Handle ITLB 2M and 4M sizes, fall back to L1 if L2 is disabled */
+	if (!(eax & mask)) {
+		/* Erratum 658 */
+		if (c->x86 == 0x15 && c->x86_model <= 0x1f) {
+			tlb_lli_2m[ENTRIES] = 1024;
+		} else {
+			cpuid(0x80000005, &eax, &ebx, &ecx, &edx);
+			tlb_lli_2m[ENTRIES] = eax & 0xff;
+		}
+	} else
+		tlb_lli_2m[ENTRIES] = eax & mask;
+
+	tlb_lli_4m[ENTRIES] = tlb_lli_2m[ENTRIES] >> 1;
+}
+
 static const struct cpu_dev __cpuinitconst amd_cpu_dev = {
 	.c_vendor	= "AMD",
 	.c_ident	= { "AuthenticAMD" },
@@ -756,6 +809,7 @@ static const struct cpu_dev __cpuinitconst amd_cpu_dev = {
 	.c_size_cache	= amd_size_cache,
 #endif
 	.c_early_init   = early_init_amd,
+	.c_detect_tlb	= cpu_detect_tlb_amd,
 	.c_bsp_init	= bsp_init_amd,
 	.c_init		= init_amd,
 	.c_x86_vendor	= X86_VENDOR_AMD,
-- 
1.7.11.rc1

