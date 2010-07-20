Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955Ab0GTAwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:52:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:38742 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757408Ab0GTAwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:52:06 -0400
Date: Tue, 20 Jul 2010 00:51:46 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100719230205.439900717@sbs-t61.sc.intel.com>
References: <20100719230205.439900717@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Make init_scattered_cpuid_features() consider cpuid subleaves
Message-ID: <tip-edb18f8ab02843453306601c4aa697f9691129cd@git.kernel.org>
Git-Commit-ID: edb18f8ab02843453306601c4aa697f9691129cd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 00:51:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  edb18f8ab02843453306601c4aa697f9691129cd
Gitweb:     http://git.kernel.org/tip/edb18f8ab02843453306601c4aa697f9691129cd
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 19 Jul 2010 16:05:50 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 19 Jul 2010 16:47:59 -0700

x86, cpu: Make init_scattered_cpuid_features() consider cpuid subleaves

Some cpuid features (like xsaveopt) are enumerated using cpuid
subleaves.

Extend init_scattered_cpuid_features() to take subleaf into account.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100719230205.439900717@sbs-t61.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 7369b4c..03cf24a 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -14,6 +14,7 @@ struct cpuid_bit {
 	u8 reg;
 	u8 bit;
 	u32 level;
+	u32 sub_leaf;
 };
 
 enum cpuid_regs {
@@ -30,16 +31,16 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	const struct cpuid_bit *cb;
 
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
-		{ X86_FEATURE_IDA,   		CR_EAX, 1, 0x00000006 },
-		{ X86_FEATURE_ARAT,  		CR_EAX, 2, 0x00000006 },
-		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006 },
-		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006 },
-		{ X86_FEATURE_CPB,   		CR_EDX, 9, 0x80000007 },
-		{ X86_FEATURE_NPT,   		CR_EDX, 0, 0x8000000a },
-		{ X86_FEATURE_LBRV,  		CR_EDX, 1, 0x8000000a },
-		{ X86_FEATURE_SVML,  		CR_EDX, 2, 0x8000000a },
-		{ X86_FEATURE_NRIPS, 		CR_EDX, 3, 0x8000000a },
-		{ 0, 0, 0, 0 }
+		{ X86_FEATURE_IDA,		CR_EAX, 1, 0x00000006, 0 },
+		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
+		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
+		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
+		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
+		{ X86_FEATURE_NPT,		CR_EDX, 0, 0x8000000a, 0 },
+		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },
+		{ X86_FEATURE_SVML,		CR_EDX, 2, 0x8000000a, 0 },
+		{ X86_FEATURE_NRIPS,		CR_EDX, 3, 0x8000000a, 0 },
+		{ 0, 0, 0, 0, 0 }
 	};
 
 	for (cb = cpuid_bits; cb->feature; cb++) {
@@ -50,8 +51,8 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		    max_level > (cb->level | 0xffff))
 			continue;
 
-		cpuid(cb->level, &regs[CR_EAX], &regs[CR_EBX],
-			&regs[CR_ECX], &regs[CR_EDX]);
+		cpuid_count(cb->level, cb->sub_leaf, &regs[CR_EAX],
+			    &regs[CR_EBX], &regs[CR_ECX], &regs[CR_EDX]);
 
 		if (regs[cb->reg] & (1 << cb->bit))
 			set_cpu_cap(c, cb->feature);
