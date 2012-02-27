Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab2B0KdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:33:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53434 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab2B0KdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:33:13 -0500
Date: Mon, 27 Feb 2012 11:32:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20120227103258.GA3729@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: 3f806e50981825fa56a7f1938f24c0680816be45 x86/mce/AMD: Fix UP build error

 Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86/amd: Fix L1i and L2 cache sharing information for AMD family 15h processors

Borislav Petkov (1):
      x86/mce/AMD: Fix UP build error

Prarit Bhargava (1):
      x86/microcode: Remove noisy AMD microcode warning

Steven Rostedt (2):
      x86/nmi: Test saved %cs in NMI to determine nested NMI case
      x86: Specify a size for the cmp in the NMI handler


 arch/x86/kernel/cpu/intel_cacheinfo.c |   44 +++++++++++++++++++++++++++------
 arch/x86/kernel/cpu/mcheck/mce_amd.c  |    2 +
 arch/x86/kernel/entry_64.S            |    9 ++++++-
 arch/x86/kernel/microcode_amd.c       |    1 -
 4 files changed, 46 insertions(+), 10 deletions(-)

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
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 786e76a..e4eeaaf 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -528,6 +528,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 	sprintf(name, "threshold_bank%i", bank);
 
+#ifdef CONFIG_SMP
 	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
 		i = cpumask_first(cpu_llc_shared_mask(cpu));
 
@@ -553,6 +554,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 		goto out;
 	}
+#endif
 
 	b = kzalloc(sizeof(struct threshold_bank), GFP_KERNEL);
 	if (!b) {
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3fe8239..1333d98 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1532,10 +1532,17 @@ ENTRY(nmi)
 	pushq_cfi %rdx
 
 	/*
+	 * If %cs was not the kernel segment, then the NMI triggered in user
+	 * space, which means it is definitely not nested.
+	 */
+	cmpl $__KERNEL_CS, 16(%rsp)
+	jne first_nmi
+
+	/*
 	 * Check the special variable on the stack to see if NMIs are
 	 * executing.
 	 */
-	cmp $1, -8(%rsp)
+	cmpl $1, -8(%rsp)
 	je nested_nmi
 
 	/*
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index ac0417b..73465aa 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -360,7 +360,6 @@ out:
 static enum ucode_state
 request_microcode_user(int cpu, const void __user *buf, size_t size)
 {
-	pr_info("AMD microcode update via /dev/cpu/microcode not supported\n");
 	return UCODE_ERROR;
 }
 
