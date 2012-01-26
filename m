Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab2AZUPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 15:15:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35192 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab2AZUPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 15:15:52 -0500
Date: Thu, 26 Jan 2012 21:15:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20120126201534.GA7933@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: 5b68edc91cdc972c46f76f85eded7ffddc3ff5c2 x86/microcode_amd: Add support for CPU family specific container files

 Thanks,

	Ingo

------------------>
Andreas Herrmann (2):
      x86/amd: Add missing feature flag for fam15h models 10h-1fh processors
      x86/microcode_amd: Add support for CPU family specific container files

Cliff Wickman (1):
      x86/uv: Fix uninitialized spinlocks

Daniel J Blueman (1):
      x86/numachip: Drop unnecessary conflict with EDAC

Jesper Juhl (1):
      x86/boot-image: Don't leak phdrs in arch/x86/boot/compressed/misc.c::Parse_elf()

Russ Anderson (1):
      x86/uv: Fix uv_gpa_to_soc_phys_ram() shift


 arch/x86/Kconfig                  |    1 -
 arch/x86/boot/compressed/misc.c   |    2 ++
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/include/asm/uv/uv_hub.h  |    4 ++--
 arch/x86/kernel/microcode_amd.c   |   24 ++++++++++++++++++++++--
 arch/x86/platform/uv/tlb_uv.c     |    2 ++
 arch/x86/platform/uv/uv_irq.c     |    2 +-
 7 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 864cc6e..5bed94e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -360,7 +360,6 @@ config X86_NUMACHIP
 	depends on NUMA
 	depends on SMP
 	depends on X86_X2APIC
-	depends on !EDAC_AMD64
 	---help---
 	  Adds support for Numascale NumaChip large-SMP systems. Needed to
 	  enable more than ~168 cores.
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 3a19d04..7116dcb 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -321,6 +321,8 @@ static void parse_elf(void *output)
 		default: /* Ignore other PT_* */ break;
 		}
 	}
+
+	free(phdrs);
 }
 
 asmlinkage void decompress_kernel(void *rmode, memptr heap,
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 17c5d4b..8d67d42 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -159,6 +159,7 @@
 #define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
 #define X86_FEATURE_LWP		(6*32+15) /* Light Weight Profiling */
 #define X86_FEATURE_FMA4	(6*32+16) /* 4 operands MAC instructions */
+#define X86_FEATURE_TCE		(6*32+17) /* translation cache extension */
 #define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
 #define X86_FEATURE_TBM		(6*32+21) /* trailing bit manipulations */
 #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 54a13aa..21f7385 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -318,13 +318,13 @@ uv_gpa_in_mmr_space(unsigned long gpa)
 /* UV global physical address --> socket phys RAM */
 static inline unsigned long uv_gpa_to_soc_phys_ram(unsigned long gpa)
 {
-	unsigned long paddr = gpa & uv_hub_info->gpa_mask;
+	unsigned long paddr;
 	unsigned long remap_base = uv_hub_info->lowmem_remap_base;
 	unsigned long remap_top =  uv_hub_info->lowmem_remap_top;
 
 	gpa = ((gpa << uv_hub_info->m_shift) >> uv_hub_info->m_shift) |
 		((gpa >> uv_hub_info->n_lshift) << uv_hub_info->m_val);
-	gpa = gpa & uv_hub_info->gpa_mask;
+	paddr = gpa & uv_hub_info->gpa_mask;
 	if (paddr >= remap_base && paddr < remap_base + remap_top)
 		paddr -= remap_base;
 	return paddr;
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index fe86493..ac0417b 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -311,13 +311,33 @@ out:
 	return state;
 }
 
+/*
+ * AMD microcode firmware naming convention, up to family 15h they are in
+ * the legacy file:
+ *
+ *    amd-ucode/microcode_amd.bin
+ *
+ * This legacy file is always smaller than 2K in size.
+ *
+ * Starting at family 15h they are in family specific firmware files:
+ *
+ *    amd-ucode/microcode_amd_fam15h.bin
+ *    amd-ucode/microcode_amd_fam16h.bin
+ *    ...
+ *
+ * These might be larger than 2K.
+ */
 static enum ucode_state request_microcode_amd(int cpu, struct device *device)
 {
-	const char *fw_name = "amd-ucode/microcode_amd.bin";
+	char fw_name[36] = "amd-ucode/microcode_amd.bin";
 	const struct firmware *fw;
 	enum ucode_state ret = UCODE_NFOUND;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
+	if (c->x86 >= 0x15)
+		snprintf(fw_name, sizeof(fw_name), "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
 
-	if (request_firmware(&fw, fw_name, device)) {
+	if (request_firmware(&fw, (const char *)fw_name, device)) {
 		pr_err("failed to load file %s\n", fw_name);
 		goto out;
 	}
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 9be4cff..3ae0e61 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1851,6 +1851,8 @@ static void __init init_per_cpu_tunables(void)
 		bcp->cong_reps			= congested_reps;
 		bcp->cong_period		= congested_period;
 		bcp->clocks_per_100_usec =	usec_2_cycles(100);
+		spin_lock_init(&bcp->queue_lock);
+		spin_lock_init(&bcp->uvhub_lock);
 	}
 }
 
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index 374a05d..f25c276 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -25,7 +25,7 @@ struct uv_irq_2_mmr_pnode{
 	int			irq;
 };
 
-static spinlock_t		uv_irq_lock;
+static DEFINE_SPINLOCK(uv_irq_lock);
 static struct rb_root		uv_irq_root;
 
 static int uv_set_irq_affinity(struct irq_data *, const struct cpumask *, bool);
