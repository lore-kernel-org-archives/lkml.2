Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2JAOcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:32:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64462 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab2JAOcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:32:41 -0400
Date: Mon, 1 Oct 2012 16:32:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm changes for v3.7
Message-ID: <20121001143235.GA25070@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mm-for-linus

   HEAD: fd0f5869724ff6195c6e7f12f8287c66a132e0ba x86: Distinguish TLB shootdown interrupts from other functions call interrupts

The biggest change is new TLB partial flushing code for AMD 
CPUs. (The v3.6 kernel had the Intel CPU side code, see commits 
e0ba94f14f74..effee4b9b3b.)

There's also various other refinements around the TLB flush 
code.

 Thanks,

	Ingo

------------------>
Borislav Petkov (4):
      x86, cpu: Fixup tlb_flushall_shift formatting
      x86, cpu: Push TLB detection CPUID check down
      x86, cpu: Add AMD TLB size detection
      x86, cpu: Preset default tlb_flushall_shift on AMD

Jan Beulich (1):
      x86/mm: Fix range check in tlbflush debugfs interface

Tomoki Sekiyama (1):
      x86: Distinguish TLB shootdown interrupts from other functions call interrupts


 arch/x86/include/asm/hardirq.h |  4 +++
 arch/x86/kernel/cpu/amd.c      | 67 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/common.c   |  5 ++--
 arch/x86/kernel/cpu/intel.c    |  4 +++
 arch/x86/kernel/irq.c          |  4 +--
 arch/x86/mm/tlb.c              |  4 ++-
 6 files changed, 82 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index d3895db..81f04ce 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -18,6 +18,10 @@ typedef struct {
 #ifdef CONFIG_SMP
 	unsigned int irq_resched_count;
 	unsigned int irq_call_count;
+	/*
+	 * irq_tlb_count is double-counted in irq_call_count, so it must be
+	 * subtracted from irq_call_count when displaying irq_call_count
+	 */
 	unsigned int irq_tlb_count;
 #endif
 #ifdef CONFIG_X86_THERMAL_VECTOR
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 9d92e19..f7e98a2 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -737,6 +737,72 @@ static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c,
 }
 #endif
 
+static void __cpuinit cpu_set_tlb_flushall_shift(struct cpuinfo_x86 *c)
+{
+	if (!cpu_has_invlpg)
+		return;
+
+	tlb_flushall_shift = 5;
+
+	if (c->x86 <= 0x11)
+		tlb_flushall_shift = 4;
+}
+
+static void __cpuinit cpu_detect_tlb_amd(struct cpuinfo_x86 *c)
+{
+	u32 ebx, eax, ecx, edx;
+	u16 mask = 0xfff;
+
+	if (c->x86 < 0xf)
+		return;
+
+	if (c->extended_cpuid_level < 0x80000006)
+		return;
+
+	cpuid(0x80000006, &eax, &ebx, &ecx, &edx);
+
+	tlb_lld_4k[ENTRIES] = (ebx >> 16) & mask;
+	tlb_lli_4k[ENTRIES] = ebx & mask;
+
+	/*
+	 * K8 doesn't have 2M/4M entries in the L2 TLB so read out the L1 TLB
+	 * characteristics from the CPUID function 0x80000005 instead.
+	 */
+	if (c->x86 == 0xf) {
+		cpuid(0x80000005, &eax, &ebx, &ecx, &edx);
+		mask = 0xff;
+	}
+
+	/* Handle DTLB 2M and 4M sizes, fall back to L1 if L2 is disabled */
+	if (!((eax >> 16) & mask)) {
+		u32 a, b, c, d;
+
+		cpuid(0x80000005, &a, &b, &c, &d);
+		tlb_lld_2m[ENTRIES] = (a >> 16) & 0xff;
+	} else {
+		tlb_lld_2m[ENTRIES] = (eax >> 16) & mask;
+	}
+
+	/* a 4M entry uses two 2M entries */
+	tlb_lld_4m[ENTRIES] = tlb_lld_2m[ENTRIES] >> 1;
+
+	/* Handle ITLB 2M and 4M sizes, fall back to L1 if L2 is disabled */
+	if (!(eax & mask)) {
+		/* Erratum 658 */
+		if (c->x86 == 0x15 && c->x86_model <= 0x1f) {
+			tlb_lli_2m[ENTRIES] = 1024;
+		} else {
+			cpuid(0x80000005, &eax, &ebx, &ecx, &edx);
+			tlb_lli_2m[ENTRIES] = eax & 0xff;
+		}
+	} else
+		tlb_lli_2m[ENTRIES] = eax & mask;
+
+	tlb_lli_4m[ENTRIES] = tlb_lli_2m[ENTRIES] >> 1;
+
+	cpu_set_tlb_flushall_shift(c);
+}
+
 static const struct cpu_dev __cpuinitconst amd_cpu_dev = {
 	.c_vendor	= "AMD",
 	.c_ident	= { "AuthenticAMD" },
@@ -756,6 +822,7 @@ static const struct cpu_dev __cpuinitconst amd_cpu_dev = {
 	.c_size_cache	= amd_size_cache,
 #endif
 	.c_early_init   = early_init_amd,
+	.c_detect_tlb	= cpu_detect_tlb_amd,
 	.c_bsp_init	= bsp_init_amd,
 	.c_init		= init_amd,
 	.c_x86_vendor	= X86_VENDOR_AMD,
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 46d8786..080f4a7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -474,7 +474,7 @@ void __cpuinit cpu_detect_tlb(struct cpuinfo_x86 *c)
 
 	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n" \
 		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d\n"	     \
-		"tlb_flushall_shift is 0x%x\n",
+		"tlb_flushall_shift: %d\n",
 		tlb_lli_4k[ENTRIES], tlb_lli_2m[ENTRIES],
 		tlb_lli_4m[ENTRIES], tlb_lld_4k[ENTRIES],
 		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES],
@@ -940,8 +940,7 @@ void __init identify_boot_cpu(void)
 #else
 	vgetcpu_set_mode();
 #endif
-	if (boot_cpu_data.cpuid_level >= 2)
-		cpu_detect_tlb(&boot_cpu_data);
+	cpu_detect_tlb(&boot_cpu_data);
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 0a4ce29..198e019 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -648,6 +648,10 @@ static void __cpuinit intel_detect_tlb(struct cpuinfo_x86 *c)
 	int i, j, n;
 	unsigned int regs[4];
 	unsigned char *desc = (unsigned char *)regs;
+
+	if (c->cpuid_level < 2)
+		return;
+
 	/* Number of times to iterate */
 	n = cpuid_eax(2) & 0xFF;
 
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 1f5f1d5..355b13f 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -92,7 +92,8 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	seq_printf(p, "  Rescheduling interrupts\n");
 	seq_printf(p, "%*s: ", prec, "CAL");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->irq_call_count);
+		seq_printf(p, "%10u ", irq_stats(j)->irq_call_count -
+					irq_stats(j)->irq_tlb_count);
 	seq_printf(p, "  Function call interrupts\n");
 	seq_printf(p, "%*s: ", prec, "TLB");
 	for_each_online_cpu(j)
@@ -147,7 +148,6 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 #ifdef CONFIG_SMP
 	sum += irq_stats(cpu)->irq_resched_count;
 	sum += irq_stats(cpu)->irq_call_count;
-	sum += irq_stats(cpu)->irq_tlb_count;
 #endif
 #ifdef CONFIG_X86_THERMAL_VECTOR
 	sum += irq_stats(cpu)->irq_thermal_count;
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 613cd83..0777f04 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -98,6 +98,8 @@ static void flush_tlb_func(void *info)
 {
 	struct flush_tlb_info *f = info;
 
+	inc_irq_stat(irq_tlb_count);
+
 	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
 		return;
 
@@ -320,7 +322,7 @@ static ssize_t tlbflush_write_file(struct file *file,
 	if (kstrtos8(buf, 0, &shift))
 		return -EINVAL;
 
-	if (shift > 64)
+	if (shift < -1 || shift >= BITS_PER_LONG)
 		return -EINVAL;
 
 	tlb_flushall_shift = shift;
