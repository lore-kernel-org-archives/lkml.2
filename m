Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab2HGDKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:10:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43164 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2HGDKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:10:01 -0400
Date: Mon, 6 Aug 2012 20:09:48 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-b46882e4c4de4813947fce940fe74af794a1eb72@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1344272439-29080-4-git-send-email-bp@amd64.org>
References: <1344272439-29080-4-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, cpu: Add AMD TLB size detection
Git-Commit-ID: b46882e4c4de4813947fce940fe74af794a1eb72
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 06 Aug 2012 20:09:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b46882e4c4de4813947fce940fe74af794a1eb72
Gitweb:     http://git.kernel.org/tip/b46882e4c4de4813947fce940fe74af794a1eb72
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Mon, 6 Aug 2012 19:00:38 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 6 Aug 2012 19:18:34 -0700

x86, cpu: Add AMD TLB size detection

Read I- and DTLB entries count from CPUID on AMD. Handle all the
different family-specific cases.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1344272439-29080-4-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/amd.c |   54 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 9d92e19..bcd2008 100644
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
