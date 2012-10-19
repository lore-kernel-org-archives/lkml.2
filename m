Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab2JSI7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:59:48 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:18609 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756993Ab2JSI7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:59:46 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh668h839h93fhd25hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
X-WSS-ID: 0MC4UB6-02-3FE-02
X-M-MSG: 
Date: Fri, 19 Oct 2012 10:59:33 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] x86, cacheinfo: Determine number of cache leafs using
 CPUID 0x8000001d on AMD
Message-ID: <20121019085933.GE26718@alberich>
References: <20121019085519.GC26718@alberich>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20121019085519.GC26718@alberich>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CPUID 0x8000001d works quite similar to Intels' CPUID function 4.
Use it to determine number of cache leafs.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/processor.h      |    2 +-
 arch/x86/kernel/cpu/amd.c             |    7 +------
 arch/x86/kernel/cpu/intel_cacheinfo.c |   28 +++++++++++++++++++++++-----
 3 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b98c0d9..4bfa500 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -187,7 +187,7 @@ extern void print_cpu_info(struct cpuinfo_x86 *);
 void print_cpu_msr(struct cpuinfo_x86 *);
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
-extern unsigned short num_cache_leaves;
+extern void init_amd_cacheinfo(struct cpuinfo_x86 *c);
 
 extern void detect_extended_topology(struct cpuinfo_x86 *c);
 extern void detect_ht(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 64e9ad4..a8538e6 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -643,12 +643,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	detect_ht(c);
 #endif
 
-	if (c->extended_cpuid_level >= 0x80000006) {
-		if (cpuid_edx(0x80000006) & 0xf000)
-			num_cache_leaves = 4;
-		else
-			num_cache_leaves = 3;
-	}
+	init_amd_cacheinfo(c);
 
 	if (c->x86 >= 0xf)
 		set_cpu_cap(c, X86_FEATURE_K8);
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 93c5451..8ce7a83 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -557,21 +557,39 @@ __cpuinit cpuid4_cache_lookup_regs(int index,
 	return 0;
 }
 
-static int __cpuinit find_num_cache_leaves(void)
+static int __cpuinit find_num_cache_leaves(struct cpuinfo_x86 *c)
 {
-	unsigned int		eax, ebx, ecx, edx;
+	unsigned int		eax, ebx, ecx, edx, op;
 	union _cpuid4_leaf_eax	cache_eax;
 	int 			i = -1;
 
+	if (c->x86_vendor == X86_VENDOR_AMD)
+		op = 0x8000001d;
+	else
+		op = 4;
+
 	do {
 		++i;
-		/* Do cpuid(4) loop to find out num_cache_leaves */
-		cpuid_count(4, i, &eax, &ebx, &ecx, &edx);
+		/* Do cpuid(op) loop to find out num_cache_leaves */
+		cpuid_count(op, i, &eax, &ebx, &ecx, &edx);
 		cache_eax.full = eax;
 	} while (cache_eax.split.type != CACHE_TYPE_NULL);
 	return i;
 }
 
+void __cpuinit init_amd_cacheinfo(struct cpuinfo_x86 *c)
+{
+
+	if (cpu_has_topoext) {
+		num_cache_leaves = find_num_cache_leaves(c);
+	} else if (c->extended_cpuid_level >= 0x80000006) {
+		if (cpuid_edx(0x80000006) & 0xf000)
+			num_cache_leaves = 4;
+		else
+			num_cache_leaves = 3;
+	}
+}
+
 unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 {
 	/* Cache sizes */
@@ -588,7 +606,7 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 
 		if (is_initialized == 0) {
 			/* Init num_cache_leaves from boot CPU */
-			num_cache_leaves = find_num_cache_leaves();
+			num_cache_leaves = find_num_cache_leaves(c);
 			is_initialized++;
 		}
 
-- 
1.7.8.6


