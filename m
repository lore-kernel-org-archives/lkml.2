Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab2EPOpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:45:20 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:11846
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301Ab2EPOpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:45:17 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M44EB9-02-BSP-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH] x86, cacheinfo, amd: use cpuid topology extensions to enumerate caches
Date: Wed, 16 May 2012 16:44:46 +0200
Message-ID: <1337179486-21424-1-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD CPU family 0x15 introduced a new CPUID leaf for topology extensions,
which can be used to enumerate the systems caches. Although a different
CPUID leaf number is used, it is essentially compatible with Intels
CPUID leaf 4. This means the existing code parsing CPUID leaf 4 can be
used here. The old code emulating Intels CPUID leaf 4 for AMD systems will
still be used on AMD CPUs that don't support the topology extensions
leaf.

There are two differences to the information in Intels CPUID leaf 4:
- the "number of cores on the die" field is missing
- AMD returns extra information in the EDX register about WBINVD
  behaviour and cache inclusiveness
Both are currently unused in Linux.

The shared_cpu_map can now be set up using the extended topology
information on systems that support it, the old code for family 0x15
cache indices 1 and 2 is gone. The old code for cache index 3 stays for
CPUs not supporting the topology extensions.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/cpufeature.h     |    1 +
 arch/x86/kernel/cpu/intel_cacheinfo.c |   48 ++++++++++++++++++++++----------
 2 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 340ee49..ab53e60 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -303,6 +303,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_perfctr_core	boot_cpu_has(X86_FEATURE_PERFCTR_CORE)
 #define cpu_has_cx8		boot_cpu_has(X86_FEATURE_CX8)
 #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
+#define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 73d08ed..e5b24f0 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -538,7 +538,10 @@ __cpuinit cpuid4_cache_lookup_regs(int index,
 	unsigned		edx;
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
-		amd_cpuid4(index, &eax, &ebx, &ecx);
+		if (cpu_has_topoext)
+			cpuid_count(0x8000001d, index, &eax.full, &ebx.full, &ecx.full, &edx);
+		else
+			amd_cpuid4(index, &eax, &ebx, &ecx);
 		amd_init_l3_cache(this_leaf, index);
 	} else {
 		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full, &edx);
@@ -728,37 +731,52 @@ static DEFINE_PER_CPU(struct _cpuid4_info *, ici_cpuid4_info);
 static int __cpuinit cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
 {
 	struct _cpuid4_info *this_leaf;
-	int ret, i, sibling;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	int i, sibling;
+
+	if (cpu_has_topoext) {
+		unsigned int apicid = cpu_data(cpu).apicid;
+		int nshared, first;
+
+		if (!per_cpu(ici_cpuid4_info, cpu))
+			return 0;
+
+		this_leaf = CPUID4_INFO_IDX(cpu, index);
+		nshared = 1 + this_leaf->base.eax.split.num_threads_sharing;
+		first = apicid - apicid % nshared;
+
+		for_each_online_cpu(i) {
+			if (cpu_data(i).apicid < first ||
+			    cpu_data(i).apicid >= first + nshared)
+				continue;
 
-	ret = 0;
-	if (index == 3) {
-		ret = 1;
-		for_each_cpu(i, cpu_llc_shared_mask(cpu)) {
 			if (!per_cpu(ici_cpuid4_info, i))
 				continue;
+
 			this_leaf = CPUID4_INFO_IDX(i, index);
-			for_each_cpu(sibling, cpu_llc_shared_mask(cpu)) {
-				if (!cpu_online(sibling))
+			for_each_online_cpu(sibling) {
+				if (cpu_data(sibling).apicid < first ||
+				    cpu_data(sibling).apicid >= first + nshared)
 					continue;
+
 				set_bit(sibling, this_leaf->shared_cpu_map);
 			}
 		}
-	} else if ((c->x86 == 0x15) && ((index == 1) || (index == 2))) {
-		ret = 1;
-		for_each_cpu(i, cpu_sibling_mask(cpu)) {
+	} else if (index == 3) {
+		for_each_cpu(i, cpu_llc_shared_mask(cpu)) {
 			if (!per_cpu(ici_cpuid4_info, i))
 				continue;
 			this_leaf = CPUID4_INFO_IDX(i, index);
-			for_each_cpu(sibling, cpu_sibling_mask(cpu)) {
+			for_each_cpu(sibling, cpu_llc_shared_mask(cpu)) {
 				if (!cpu_online(sibling))
 					continue;
 				set_bit(sibling, this_leaf->shared_cpu_map);
 			}
-		}
+		}		
+	} else {
+		return 0;
 	}
 
-	return ret;
+	return 1;
 }
 
 static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
-- 
1.7.7


