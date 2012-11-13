Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2KMWAC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:00:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37872 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab2KMV77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:59:59 -0500
Date: Tue, 13 Nov 2012 13:59:45 -0800
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <tip-04a1541828ea223169eb44a336bfad8ec0dfb46a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20121019085933.GE26718@alberich>
References: <20121019085933.GE26718@alberich>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cacheinfo:
  Determine number of cache leafs using CPUID 0x8000001d on AMD
Git-Commit-ID: 04a1541828ea223169eb44a336bfad8ec0dfb46a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 13:59:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04a1541828ea223169eb44a336bfad8ec0dfb46a
Gitweb:     http://git.kernel.org/tip/04a1541828ea223169eb44a336bfad8ec0dfb46a
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Fri, 19 Oct 2012 10:59:33 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 13 Nov 2012 11:22:29 -0800

x86, cacheinfo: Determine number of cache leafs using CPUID 0x8000001d on AMD

CPUID 0x8000001d works quite similar to Intels' CPUID function 4.
Use it to determine number of cache leafs.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Link: http://lkml.kernel.org/r/20121019085933.GE26718@alberich
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/processor.h      |    2 +-
 arch/x86/kernel/cpu/amd.c             |    7 +------
 arch/x86/kernel/cpu/intel_cacheinfo.c |   28 +++++++++++++++++++++++-----
 3 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index ad1fc85..db0d8c3 100644
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
 
