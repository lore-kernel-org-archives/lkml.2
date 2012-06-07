Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729Ab2FGQqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 12:46:19 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:46812
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752718Ab2FGQqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 12:46:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M59AKW-02-6B7-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 5/5] x86, cacheinfo, amd: fix reported cache parameters for family 0x10
Date: Thu, 7 Jun 2012 18:45:59 +0200
Message-ID: <1339087559-32604-5-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1339087559-32604-1-git-send-email-hans.rosenfeld@amd.com>
References: <1339087559-32604-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Family 0x10 RevD and later can use a part of the L3 cache as probe
filter. The size information from CPUID leaf 8000_0006 takes this into
account, but the reported associativity does not. The result are weird
values for ways_of_associativity and number_of_sets.

This patch fixes this for the affected models of family 0x10.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/kernel/cpu/amd_cacheinfo.c |   11 ++++++++++-
 arch/x86/kernel/cpu/cacheinfo.c     |    4 ++--
 arch/x86/kernel/cpu/cacheinfo.h     |    3 ++-
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd_cacheinfo.c b/arch/x86/kernel/cpu/amd_cacheinfo.c
index e3fda975..5f77600 100644
--- a/arch/x86/kernel/cpu/amd_cacheinfo.c
+++ b/arch/x86/kernel/cpu/amd_cacheinfo.c
@@ -71,7 +71,8 @@ static const unsigned char __cpuinitconst types[] = { 1, 2, 3, 3 };
 void __cpuinit amd_cpuid4(int leaf,
 			  union _cpuid_cacheinfo_eax *eax,
 			  union _cpuid_cacheinfo_ebx *ebx,
-			  union _cpuid_cacheinfo_ecx *ecx)
+			  union _cpuid_cacheinfo_ecx *ecx,
+			  struct amd_northbridge *nb)
 {
 	unsigned dummy;
 	unsigned line_size, lines_per_tag, assoc, size_in_kb;
@@ -118,6 +119,14 @@ void __cpuinit amd_cpuid4(int leaf,
 			size_in_kb = size_in_kb >> 1;
 			assoc = assoc >> 1;
 		}
+		/* reduce associativity by amount used by probe filter */
+		if (boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model >= 8 &&
+		    nb != NULL) {
+			unsigned int reg;
+			pci_read_config_dword(nb->misc, 0x1d4, &reg);
+			if ((reg & 0x3))
+				assoc -= 8;
+		}
 		break;
 	default:
 		return;
diff --git a/arch/x86/kernel/cpu/cacheinfo.c b/arch/x86/kernel/cpu/cacheinfo.c
index db04501..9f879bf 100644
--- a/arch/x86/kernel/cpu/cacheinfo.c
+++ b/arch/x86/kernel/cpu/cacheinfo.c
@@ -27,12 +27,12 @@ int __cpuinit cpuid_cacheinfo_lookup_regs(int index,
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
 #if defined(CONFIG_CPU_SUP_AMD)
+		amd_init_l3_cache(this_leaf, index);
 		if (cpu_has_topoext)
 			cpuid_count(0x8000001d, index, &eax.full, &ebx.full,
 				    &ecx.full, &edx);
 		else
-			amd_cpuid4(index, &eax, &ebx, &ecx);
-		amd_init_l3_cache(this_leaf, index);
+			amd_cpuid4(index, &eax, &ebx, &ecx, this_leaf->nb);
 #endif
 	} else {
 #if defined(CONFIG_CPU_SUP_INTEL)
diff --git a/arch/x86/kernel/cpu/cacheinfo.h b/arch/x86/kernel/cpu/cacheinfo.h
index fe39da7..104f818 100644
--- a/arch/x86/kernel/cpu/cacheinfo.h
+++ b/arch/x86/kernel/cpu/cacheinfo.h
@@ -66,7 +66,8 @@ struct _cache_attr {
 extern struct attribute ** amd_l3_attrs(struct attribute **);
 extern void amd_cpuid4(int, union _cpuid_cacheinfo_eax *,
 		       union _cpuid_cacheinfo_ebx *,
-		       union _cpuid_cacheinfo_ecx *);
+		       union _cpuid_cacheinfo_ecx *,
+		       struct amd_northbridge *nb);
 extern void amd_init_l3_cache(struct _cpuid_cacheinfo_regs *, int);
 extern void cache_shared_amd_cpu_map_setup(unsigned int, int);
 extern void cache_shared_intel_cpu_map_setup(unsigned int, int);
-- 
1.7.7


