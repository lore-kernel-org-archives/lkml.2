Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab2BIMll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 07:41:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54908 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2BIMlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 07:41:40 -0500
Date: Thu, 9 Feb 2012 04:41:05 -0800
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <tip-32c3233885eb10ac9cb9410f2f8cd64b8df2b2a1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, davej@redhat.com, Borislav.Petkov@amd.com,
        stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, davej@redhat.com, Borislav.Petkov@amd.com,
        stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120208195229.GA17523@alberich.amd.com>
References: <20120208195229.GA17523@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/amd:
  Fix L1i and L2 cache sharing information for AMD family 15h processors
Git-Commit-ID: 32c3233885eb10ac9cb9410f2f8cd64b8df2b2a1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 09 Feb 2012 04:41:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  32c3233885eb10ac9cb9410f2f8cd64b8df2b2a1
Gitweb:     http://git.kernel.org/tip/32c3233885eb10ac9cb9410f2f8cd64b8df2b2a1
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Wed, 8 Feb 2012 20:52:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Feb 2012 09:38:15 +0100

x86/amd: Fix L1i and L2 cache sharing information for AMD family 15h processors

For L1 instruction cache and L2 cache the shared CPU information
is wrong. On current AMD family 15h CPUs those caches are shared
between both cores of a compute unit.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=42607

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Petkov Borislav <Borislav.Petkov@amd.com>
Cc: Dave Jones <davej@redhat.com>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/20120208195229.GA17523@alberich.amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   44 +++++++++++++++++++++++++++------
 1 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 6b45e5e..73d08ed 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -326,8 +326,7 @@ static void __cpuinit amd_calc_l3_indices(struct amd_northbridge *nb)
 	l3->indices = (max(max3(sc0, sc1, sc2), sc3) << 10) - 1;
 }
 
-static void __cpuinit amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf,
-					int index)
+static void __cpuinit amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf, int index)
 {
 	int node;
 
@@ -725,14 +724,16 @@ static DEFINE_PER_CPU(struct _cpuid4_info *, ici_cpuid4_info);
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
@@ -743,8 +744,35 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
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
 
