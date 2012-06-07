Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435Ab2FGQrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 12:47:18 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:53811
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757676Ab2FGQqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 12:46:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M59AKW-02-6B6-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 4/5] x86, cacheinfo: use find_num_cache_leaves on AMD systems
Date: Thu, 7 Jun 2012 18:45:58 +0200
Message-ID: <1339087559-32604-4-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1339087559-32604-1-git-send-email-hans.rosenfeld@amd.com>
References: <1339087559-32604-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When AMD topology extensions are available, find_num_cache_leaves() can
be used to find out how many cache leaves there are.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/kernel/cpu/amd.c             |    5 ++++-
 arch/x86/kernel/cpu/cacheinfo.c       |    6 +++---
 arch/x86/kernel/cpu/cacheinfo.h       |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c |    2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 146bb62..ad1a59c 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -18,6 +18,7 @@
 #endif
 
 #include "cpu.h"
+#include "cacheinfo.h"
 
 #ifdef CONFIG_X86_32
 /*
@@ -610,7 +611,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	detect_ht(c);
 #endif
 
-	if (c->extended_cpuid_level >= 0x80000006) {
+	if (cpu_has_topoext) {
+		num_cache_leaves = find_num_cache_leaves(0x8000001d);
+	} else if (c->extended_cpuid_level >= 0x80000006) {
 		if (cpuid_edx(0x80000006) & 0xf000)
 			num_cache_leaves = 4;
 		else
diff --git a/arch/x86/kernel/cpu/cacheinfo.c b/arch/x86/kernel/cpu/cacheinfo.c
index 111617e..db04501 100644
--- a/arch/x86/kernel/cpu/cacheinfo.c
+++ b/arch/x86/kernel/cpu/cacheinfo.c
@@ -53,7 +53,7 @@ int __cpuinit cpuid_cacheinfo_lookup_regs(int index,
 	return 0;
 }
 
-int __cpuinit find_num_cache_leaves(void)
+int __cpuinit find_num_cache_leaves(unsigned int leaf)
 {
 	unsigned int		eax, ebx, ecx, edx;
 	union _cpuid_cacheinfo_eax	cache_eax;
@@ -61,8 +61,8 @@ int __cpuinit find_num_cache_leaves(void)
 
 	do {
 		++i;
-		/* Do cpuid(4) loop to find out num_cache_leaves */
-		cpuid_count(4, i, &eax, &ebx, &ecx, &edx);
+		/* Do cpuid loop to find out num_cache_leaves */
+		cpuid_count(leaf, i, &eax, &ebx, &ecx, &edx);
 		cache_eax.full = eax;
 	} while (cache_eax.split.type != CACHE_TYPE_NULL);
 	return i;
diff --git a/arch/x86/kernel/cpu/cacheinfo.h b/arch/x86/kernel/cpu/cacheinfo.h
index df5b83e..fe39da7 100644
--- a/arch/x86/kernel/cpu/cacheinfo.h
+++ b/arch/x86/kernel/cpu/cacheinfo.h
@@ -71,6 +71,6 @@ extern void amd_init_l3_cache(struct _cpuid_cacheinfo_regs *, int);
 extern void cache_shared_amd_cpu_map_setup(unsigned int, int);
 extern void cache_shared_intel_cpu_map_setup(unsigned int, int);
 extern int cpuid_cacheinfo_lookup_regs(int, struct _cpuid_cacheinfo_regs *);
-extern int find_num_cache_leaves(void);
+extern int find_num_cache_leaves(unsigned int);
 
 #endif /* __CACHEINFO_H */
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 7e5b1fb..2fc1b8b 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -132,7 +132,7 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 
 		if (is_initialized == 0) {
 			/* Init num_cache_leaves from boot CPU */
-			num_cache_leaves = find_num_cache_leaves();
+			num_cache_leaves = find_num_cache_leaves(4);
 			is_initialized++;
 		}
 
-- 
1.7.7


