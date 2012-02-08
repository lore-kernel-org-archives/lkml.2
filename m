Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab2BHTwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 14:52:40 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:4897 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757281Ab2BHTwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 14:52:39 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ3B7I-02-5O3-02
X-M-MSG: 
Date: Wed, 8 Feb 2012 20:52:29 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: [PATCH] x86/amd: Fix L1i and L2 cache sharing information for AMD
 family 15h processors
Message-ID: <20120208195229.GA17523@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For L1 instruction cache and L2 cache the shared CPU information
is wrong. On current AMD family 15h CPUs those caches are shared
between both cores of a compute unit.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=42607

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   45 +++++++++++++++++++++++++++-----
 1 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 6b45e5e..8e58fdb 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -725,14 +725,16 @@ static DEFINE_PER_CPU(struct _cpuid4_info *, ici_cpuid4_info);
 #define CPUID4_INFO_IDX(x, y)	(&((per_cpu(ici_cpuid4_info, x))[y]))
 
 #ifdef CONFIG_SMP
-static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
+
+static int __cpuinit cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
 {
-	struct _cpuid4_info	*this_leaf, *sibling_leaf;
-	unsigned long num_threads_sharing;
-	int index_msb, i, sibling;
+	struct _cpuid4_info *this_leaf;
+	int ret, i, sibling;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	if ((index == 3) && (c->x86_vendor == X86_VENDOR_AMD)) {
+	ret = 0;
+	if (index == 3) {
+		ret = 1;
 		for_each_cpu(i, cpu_llc_shared_mask(cpu)) {
 			if (!per_cpu(ici_cpuid4_info, i))
 				continue;
@@ -740,11 +742,40 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
 			for_each_cpu(sibling, cpu_llc_shared_mask(cpu)) {
 				if (!cpu_online(sibling))
 					continue;
-				set_bit(sibling, this_leaf->shared_cpu_map);
+				set_bit(sibling,
+					this_leaf->shared_cpu_map);
+			}
+		}
+	} else if ((c->x86 == 0x15) && ((index == 1) || (index == 2))) {
+		ret = 1;
+		for_each_cpu(i, cpu_sibling_mask(cpu)) {
+			if (!per_cpu(ici_cpuid4_info, i))
+				continue;
+			this_leaf = CPUID4_INFO_IDX(i, index);
+			for_each_cpu(sibling, cpu_sibling_mask(cpu)) {
+				if (!cpu_online(sibling))
+					continue;
+				set_bit(sibling,
+					this_leaf->shared_cpu_map);
 			}
 		}
-		return;
 	}
+
+	return ret;
+}
+
+static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
+{
+	struct _cpuid4_info	*this_leaf, *sibling_leaf;
+	unsigned long num_threads_sharing;
+	int index_msb, i;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		if (cache_shared_amd_cpu_map_setup(cpu, index))
+		    return;
+	}
+
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
 	num_threads_sharing = 1 + this_leaf->base.eax.split.num_threads_sharing;
 
-- 
1.7.8.3



