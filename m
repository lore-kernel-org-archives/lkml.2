Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab0JUN0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:26:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58807 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261Ab0JUN0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:26:45 -0400
Date: Thu, 21 Oct 2010 15:26:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups for v2.6.37
Message-ID: <20101021132635.GA3988@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cleanups-for-linus

out-of-topic modifications in x86-cleanups-for-linus:
-----------------------------------------------------
include/linux/acpi_pmtmr.h         # 40ffa93: x86: Remove stale pmtimer_64.c

 Thanks,

	Ingo

------------------>
Christian Dietrich (1):
      x86: Remove unnecessary #ifdef ACPI/X86_IO_ACPI

Jan Beulich (1):
      x86, cleanups: Use clear_page/copy_page rather than memset/memcpy

Robert Richter (1):
      x86, cleanup: Remove obsolete boot_cpu_id variable

Thomas Gleixner (1):
      x86: Remove stale pmtimer_64.c


 arch/x86/include/asm/apb_timer.h   |    1 -
 arch/x86/include/asm/cpu.h         |    1 -
 arch/x86/kernel/Makefile           |    1 -
 arch/x86/kernel/apb_timer.c        |    2 +-
 arch/x86/kernel/apic/io_apic.c     |   12 +++---
 arch/x86/kernel/cpu/amd.c          |    2 +-
 arch/x86/kernel/cpu/common.c       |    2 +-
 arch/x86/kernel/cpu/intel.c        |    2 +-
 arch/x86/kernel/early-quirks.c     |    2 -
 arch/x86/kernel/machine_kexec_64.c |    4 +-
 arch/x86/kernel/pmtimer_64.c       |   69 ------------------------------------
 arch/x86/kernel/reboot.c           |    2 +-
 arch/x86/kernel/setup.c            |    1 -
 arch/x86/kernel/setup_percpu.c     |    2 +-
 arch/x86/kvm/lapic.c               |    3 +-
 arch/x86/mm/init_32.c              |    4 +-
 arch/x86/mm/init_64.c              |    2 +-
 arch/x86/mm/k8topology_64.c        |    6 ++--
 include/linux/acpi_pmtmr.h         |    2 -
 19 files changed, 21 insertions(+), 99 deletions(-)
 delete mode 100644 arch/x86/kernel/pmtimer_64.c

diff --git a/arch/x86/include/asm/apb_timer.h b/arch/x86/include/asm/apb_timer.h
index a69b1ac..2fefa50 100644
--- a/arch/x86/include/asm/apb_timer.h
+++ b/arch/x86/include/asm/apb_timer.h
@@ -54,7 +54,6 @@ extern struct clock_event_device *global_clock_event;
 extern unsigned long apbt_quick_calibrate(void);
 extern int arch_setup_apbt_irqs(int irq, int trigger, int mask, int cpu);
 extern void apbt_setup_secondary_clock(void);
-extern unsigned int boot_cpu_id;
 
 extern struct sfi_timer_table_entry *sfi_get_mtmr(int hint);
 extern void sfi_free_mtmr(struct sfi_timer_table_entry *mtmr);
diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index b185091..4fab24d 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -32,6 +32,5 @@ extern void arch_unregister_cpu(int);
 
 DECLARE_PER_CPU(int, cpu_state);
 
-extern unsigned int boot_cpu_id;
 
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0925676..dd9a2e4 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -120,7 +120,6 @@ obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
 	obj-$(CONFIG_X86_UV)		+= tlb_uv.o bios_uv.o uv_irq.o uv_sysfs.o uv_time.o
-	obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
 	obj-$(CONFIG_AUDIT)		+= audit_64.o
 
 	obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 8dd7780..08f75fb 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -343,7 +343,7 @@ void apbt_setup_secondary_clock(void)
 
 	/* Don't register boot CPU clockevent */
 	cpu = smp_processor_id();
-	if (cpu == boot_cpu_id)
+	if (!cpu)
 		return;
 	/*
 	 * We need to calculate the scaled math multiplication factor for
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4dc0084..8884928 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -162,7 +162,7 @@ int __init arch_early_irq_init(void)
 
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
-	node= cpu_to_node(boot_cpu_id);
+	node = cpu_to_node(0);
 
 	for (i = 0; i < count; i++) {
 		desc = irq_to_desc(i);
@@ -1483,7 +1483,7 @@ static void __init setup_IO_APIC_irqs(void)
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	int node = cpu_to_node(boot_cpu_id);
+	int node = cpu_to_node(0);
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
@@ -1548,7 +1548,7 @@ static void __init setup_IO_APIC_irqs(void)
 void setup_IO_APIC_irq_extra(u32 gsi)
 {
 	int apic_id = 0, pin, idx, irq;
-	int node = cpu_to_node(boot_cpu_id);
+	int node = cpu_to_node(0);
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
 
@@ -2925,7 +2925,7 @@ static inline void __init check_timer(void)
 {
 	struct irq_desc *desc = irq_to_desc(0);
 	struct irq_cfg *cfg = desc->chip_data;
-	int node = cpu_to_node(boot_cpu_id);
+	int node = cpu_to_node(0);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
 	int no_pin1 = 0;
@@ -3279,7 +3279,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 
 int create_irq(void)
 {
-	int node = cpu_to_node(boot_cpu_id);
+	int node = cpu_to_node(0);
 	unsigned int irq_want;
 	int irq;
 
@@ -3901,7 +3901,7 @@ static int __io_apic_set_pci_routing(struct device *dev, int irq,
 	if (dev)
 		node = dev_to_node(dev);
 	else
-		node = cpu_to_node(boot_cpu_id);
+		node = cpu_to_node(0);
 
 	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 60a57b1..3a7c852 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -148,7 +148,7 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
 	/* calling is from identify_secondary_cpu() ? */
-	if (c->cpu_index == boot_cpu_id)
+	if (!c->cpu_index)
 		return;
 
 	/*
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 490dac6..787b3c7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -665,7 +665,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 		this_cpu->c_early_init(c);
 
 #ifdef CONFIG_SMP
-	c->cpu_index = boot_cpu_id;
+	c->cpu_index = 0;
 #endif
 	filter_cpuid_features(c, false);
 }
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 85f69cd..3a683ea 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -169,7 +169,7 @@ static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
 	/* calling is from identify_secondary_cpu() ? */
-	if (c->cpu_index == boot_cpu_id)
+	if (!c->cpu_index)
 		return;
 
 	/*
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index e5cc7e8..e4bd78c 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -98,7 +98,6 @@ static void __init nvidia_bugs(int num, int slot, int func)
 }
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
-#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
 static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 {
 	u32 d;
@@ -116,7 +115,6 @@ static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 	d &= 0xff;
 	return d;
 }
-#endif
 
 static void __init ati_bugs(int num, int slot, int func)
 {
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 035c8c5..b3ea9db 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -36,7 +36,7 @@ static int init_one_level2_page(struct kimage *image, pgd_t *pgd,
 		if (!page)
 			goto out;
 		pud = (pud_t *)page_address(page);
-		memset(pud, 0, PAGE_SIZE);
+		clear_page(pud);
 		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
 	}
 	pud = pud_offset(pgd, addr);
@@ -45,7 +45,7 @@ static int init_one_level2_page(struct kimage *image, pgd_t *pgd,
 		if (!page)
 			goto out;
 		pmd = (pmd_t *)page_address(page);
-		memset(pmd, 0, PAGE_SIZE);
+		clear_page(pmd);
 		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
 	}
 	pmd = pmd_offset(pud, addr);
diff --git a/arch/x86/kernel/pmtimer_64.c b/arch/x86/kernel/pmtimer_64.c
deleted file mode 100644
index b112406..0000000
--- a/arch/x86/kernel/pmtimer_64.c
+++ /dev/null
@@ -1,69 +0,0 @@
-/* Ported over from i386 by AK, original copyright was:
- *
- * (C) Dominik Brodowski <linux@brodo.de> 2003
- *
- * Driver to use the Power Management Timer (PMTMR) available in some
- * southbridges as primary timing source for the Linux kernel.
- *
- * Based on parts of linux/drivers/acpi/hardware/hwtimer.c, timer_pit.c,
- * timer_hpet.c, and on Arjan van de Ven's implementation for 2.4.
- *
- * This file is licensed under the GPL v2.
- *
- * Dropped all the hardware bug workarounds for now. Hopefully they
- * are not needed on 64bit chipsets.
- */
-
-#include <linux/jiffies.h>
-#include <linux/kernel.h>
-#include <linux/time.h>
-#include <linux/init.h>
-#include <linux/cpumask.h>
-#include <linux/acpi_pmtmr.h>
-
-#include <asm/io.h>
-#include <asm/proto.h>
-#include <asm/msr.h>
-#include <asm/vsyscall.h>
-
-static inline u32 cyc2us(u32 cycles)
-{
-	/* The Power Management Timer ticks at 3.579545 ticks per microsecond.
-	 * 1 / PM_TIMER_FREQUENCY == 0.27936511 =~ 286/1024 [error: 0.024%]
-	 *
-	 * Even with HZ = 100, delta is at maximum 35796 ticks, so it can
-	 * easily be multiplied with 286 (=0x11E) without having to fear
-	 * u32 overflows.
-	 */
-	cycles *= 286;
-	return (cycles >> 10);
-}
-
-static unsigned pmtimer_wait_tick(void)
-{
-	u32 a, b;
-	for (a = b = inl(pmtmr_ioport) & ACPI_PM_MASK;
-	     a == b;
-	     b = inl(pmtmr_ioport) & ACPI_PM_MASK)
-		cpu_relax();
-	return b;
-}
-
-/* note: wait time is rounded up to one tick */
-void pmtimer_wait(unsigned us)
-{
-	u32 a, b;
-	a = pmtimer_wait_tick();
-	do {
-		b = inl(pmtmr_ioport);
-		cpu_relax();
-	} while (cyc2us(b - a) < us);
-}
-
-static int __init nopmtimer_setup(char *s)
-{
-	pmtmr_ioport = 0;
-	return 1;
-}
-
-__setup("nopmtimer", nopmtimer_setup);
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index e3af342..7a4cf14 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -84,7 +84,7 @@ static int __init reboot_setup(char *str)
 			}
 				/* we will leave sorting out the final value
 				   when we are ready to reboot, since we might not
-				   have set up boot_cpu_id or smp_num_cpu */
+				   have detected BSP APIC ID or smp_num_cpu */
 			break;
 #endif /* CONFIG_SMP */
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b008e78..dede5c4 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -125,7 +125,6 @@ unsigned long max_pfn_mapped;
 RESERVE_BRK(dmi_alloc, 65536);
 #endif
 
-unsigned int boot_cpu_id __read_mostly;
 
 static __initdata unsigned long _brk_start = (unsigned long)__brk_base;
 unsigned long _brk_end = (unsigned long)__brk_base;
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index a60df9a..2335c15 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -253,7 +253,7 @@ void __init setup_per_cpu_areas(void)
 		 * Up to this point, the boot CPU has been using .init.data
 		 * area.  Reload any changed state for the boot CPU.
 		 */
-		if (cpu == boot_cpu_id)
+		if (!cpu)
 			switch_to_new_gdt(cpu);
 	}
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 77d8c0f..22b06f7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1056,14 +1056,13 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.apic = apic;
 
-	apic->regs_page = alloc_page(GFP_KERNEL);
+	apic->regs_page = alloc_page(GFP_KERNEL|__GFP_ZERO);
 	if (apic->regs_page == NULL) {
 		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
 		       vcpu->vcpu_id);
 		goto nomem_free_apic;
 	}
 	apic->regs = page_address(apic->regs_page);
-	memset(apic->regs, 0, PAGE_SIZE);
 	apic->vcpu = vcpu;
 
 	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index bca7909..558f2d3 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -67,7 +67,7 @@ static __init void *alloc_low_page(void)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = __va(pfn * PAGE_SIZE);
-	memset(adr, 0, PAGE_SIZE);
+	clear_page(adr);
 	return adr;
 }
 
@@ -558,7 +558,7 @@ char swsusp_pg_dir[PAGE_SIZE]
 
 static inline void save_pg_dir(void)
 {
-	memcpy(swsusp_pg_dir, swapper_pg_dir, PAGE_SIZE);
+	copy_page(swsusp_pg_dir, swapper_pg_dir);
 }
 #else /* !CONFIG_ACPI_SLEEP */
 static inline void save_pg_dir(void)
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 9a66746..7c48ad4 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -293,7 +293,7 @@ static __ref void *alloc_low_page(unsigned long *phys)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
-	memset(adr, 0, PAGE_SIZE);
+	clear_page(adr);
 	*phys  = pfn * PAGE_SIZE;
 	return adr;
 }
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index 970ed57..240f864 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -54,8 +54,8 @@ static __init int find_northbridge(void)
 static __init void early_get_boot_cpu_id(void)
 {
 	/*
-	 * need to get boot_cpu_id so can use that to create apicid_to_node
-	 * in k8_scan_nodes()
+	 * need to get the APIC ID of the BSP so can use that to
+	 * create apicid_to_node in k8_scan_nodes()
 	 */
 #ifdef CONFIG_X86_MPPARSE
 	/*
@@ -212,7 +212,7 @@ int __init k8_scan_nodes(void)
 	bits = boot_cpu_data.x86_coreid_bits;
 	cores = (1<<bits);
 	apicid_base = 0;
-	/* need to get boot_cpu_id early for system with apicid lifting */
+	/* get the APIC ID of the BSP early for systems with apicid lifting */
 	early_get_boot_cpu_id();
 	if (boot_cpu_physical_apicid > 0) {
 		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
diff --git a/include/linux/acpi_pmtmr.h b/include/linux/acpi_pmtmr.h
index 7e3d285..1d0ef1a 100644
--- a/include/linux/acpi_pmtmr.h
+++ b/include/linux/acpi_pmtmr.h
@@ -25,8 +25,6 @@ static inline u32 acpi_pm_read_early(void)
 	return acpi_pm_read_verified() & ACPI_PM_MASK;
 }
 
-extern void pmtimer_wait(unsigned);
-
 #else
 
 static inline u32 acpi_pm_read_early(void)
