Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965334Ab2B1BMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:12:33 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57828 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965313Ab2B1BMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:12:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.243.197 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010434.234420688@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:05:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Petkov Borislav <Borislav.Petkov@amd.com>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [ 55/72] x86/amd: Fix L1i and L2 cache sharing information for AMD family 15h processors
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 32c3233885eb10ac9cb9410f2f8cd64b8df2b2a1 upstream.

For L1 instruction cache and L2 cache the shared CPU information
is wrong. On current AMD family 15h CPUs those caches are shared
between both cores of a compute unit.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=42607

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Petkov Borislav <Borislav.Petkov@amd.com>
Cc: Dave Jones <davej@redhat.com>
Link: http://lkml.kernel.org/r/20120208195229.GA17523@alberich.amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   44 +++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -326,8 +326,7 @@ static void __cpuinit amd_calc_l3_indice
 	l3->indices = (max(max3(sc0, sc1, sc2), sc3) << 10) - 1;
 }
 
-static void __cpuinit amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf,
-					int index)
+static void __cpuinit amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf, int index)
 {
 	int node;
 
@@ -725,14 +724,16 @@ static DEFINE_PER_CPU(struct _cpuid4_inf
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
@@ -743,8 +744,35 @@ static void __cpuinit cache_shared_cpu_m
 				set_bit(sibling, this_leaf->shared_cpu_map);
 			}
 		}
-		return;
+	} else if ((c->x86 == 0x15) && ((index == 1) || (index == 2))) {
+		ret = 1;
+		for_each_cpu(i, cpu_sibling_mask(cpu)) {
+			if (!per_cpu(ici_cpuid4_info, i))
+				continue;
+			this_leaf = CPUID4_INFO_IDX(i, index);
+			for_each_cpu(sibling, cpu_sibling_mask(cpu)) {
+				if (!cpu_online(sibling))
+					continue;
+				set_bit(sibling, this_leaf->shared_cpu_map);
+			}
+		}
 	}
+
+	return ret;
+}
+
+static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
+{
+	struct _cpuid4_info *this_leaf, *sibling_leaf;
+	unsigned long num_threads_sharing;
+	int index_msb, i;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		if (cache_shared_amd_cpu_map_setup(cpu, index))
+			return;
+	}
+
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
 	num_threads_sharing = 1 + this_leaf->base.eax.split.num_threads_sharing;
 


