Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235Ab2EKXva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:51:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38240 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761158Ab2EKXvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:51:17 -0400
Message-ID: <1336780252.8274.480.camel@deadeye>
Subject: Re: Linux 3.2.17
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: lwn@lwn.net
Date: Sat, 12 May 2012 00:50:52 +0100
In-Reply-To: <1336779865.8274.476.camel@deadeye>
References: <1336779865.8274.476.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-w8vLmN+3SrwjM5KzuptP"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 91.103.132.49
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-w8vLmN+3SrwjM5KzuptP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index 3da29cb..4c4efa3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 16
+SUBLEVEL =3D 17
 EXTRAVERSION =3D
 NAME =3D Saber-toothed Squirrel
=20
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ab3740e..ef642a0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1155,6 +1155,15 @@ if !MMU
 source "arch/arm/Kconfig-nommu"
 endif
=20
+config ARM_ERRATA_326103
+	bool "ARM errata: FSR write bit incorrect on a SWP to read-only memory"
+	depends on CPU_V6
+	help
+	  Executing a SWP instruction to read-only memory does not set bit 11
+	  of the FSR on the ARM 1136 prior to r1p0. This causes the kernel to
+	  treat the access as a read, preventing a COW from occurring and
+	  causing the faulting task to livelock.
+
 config ARM_ERRATA_411920
 	bool "ARM errata: Invalidation of the Instruction Cache operation can fai=
l"
 	depends on CPU_V6 || CPU_V6K
diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
index 60843eb..73409e6 100644
--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -7,6 +7,8 @@
=20
 	.macro set_tls_v6k, tp, tmp1, tmp2
 	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
+	mov	\tmp1, #0
+	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
 	.endm
=20
 	.macro set_tls_v6, tp, tmp1, tmp2
@@ -15,6 +17,8 @@
 	mov	\tmp2, #0xffff0fff
 	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
 	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
+	movne	\tmp1, #0
+	mcrne	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
 	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
=20
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 3efd82c..87c8be5 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -156,10 +156,10 @@ static bool migrate_one_irq(struct irq_desc *desc)
 	}
=20
 	c =3D irq_data_get_irq_chip(d);
-	if (c->irq_set_affinity)
-		c->irq_set_affinity(d, affinity, true);
-	else
+	if (!c->irq_set_affinity)
 		pr_debug("IRQ%u: unable to set affinity\n", d->irq);
+	else if (c->irq_set_affinity(d, affinity, true) =3D=3D IRQ_SET_MASK_OK &&=
 ret)
+		cpumask_copy(d->affinity, affinity);
=20
 	return ret;
 }
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index ef5640b..e10e59a 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -297,8 +297,6 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	struct mm_struct *mm =3D &init_mm;
 	unsigned int cpu =3D smp_processor_id();
=20
-	printk("CPU%u: Booted secondary processor\n", cpu);
-
 	/*
 	 * All kernel threads share the same mm context; grab a
 	 * reference and switch to it.
@@ -310,6 +308,8 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	enter_lazy_tlb(mm, current);
 	local_flush_tlb_all();
=20
+	printk("CPU%u: Booted secondary processor\n", cpu);
+
 	cpu_init();
 	preempt_disable();
 	trace_hardirqs_off();
diff --git a/arch/arm/kernel/sys_arm.c b/arch/arm/kernel/sys_arm.c
index d2b1779..76cbb05 100644
--- a/arch/arm/kernel/sys_arm.c
+++ b/arch/arm/kernel/sys_arm.c
@@ -115,7 +115,7 @@ int kernel_execve(const char *filename,
 		  "Ir" (THREAD_START_SP - sizeof(regs)),
 		  "r" (&regs),
 		  "Ir" (sizeof(regs))
-		: "r0", "r1", "r2", "r3", "ip", "lr", "memory");
+		: "r0", "r1", "r2", "r3", "r8", "r9", "ip", "lr", "memory");
=20
  out:
 	return ret;
diff --git a/arch/arm/mach-omap1/timer.c b/arch/arm/mach-omap1/timer.c
index 6e90665..fb202af 100644
--- a/arch/arm/mach-omap1/timer.c
+++ b/arch/arm/mach-omap1/timer.c
@@ -47,9 +47,9 @@ static int omap1_dm_timer_set_src(struct platform_device =
*pdev,
 	int n =3D (pdev->id - 1) << 1;
 	u32 l;
=20
-	l =3D __raw_readl(MOD_CONF_CTRL_1) & ~(0x03 << n);
+	l =3D omap_readl(MOD_CONF_CTRL_1) & ~(0x03 << n);
 	l |=3D source << n;
-	__raw_writel(l, MOD_CONF_CTRL_1);
+	omap_writel(l, MOD_CONF_CTRL_1);
=20
 	return 0;
 }
diff --git a/arch/arm/mm/abort-ev6.S b/arch/arm/mm/abort-ev6.S
index ff1f7cc..8074199 100644
--- a/arch/arm/mm/abort-ev6.S
+++ b/arch/arm/mm/abort-ev6.S
@@ -26,18 +26,23 @@ ENTRY(v6_early_abort)
 	mrc	p15, 0, r1, c5, c0, 0		@ get FSR
 	mrc	p15, 0, r0, c6, c0, 0		@ get FAR
 /*
- * Faulty SWP instruction on 1136 doesn't set bit 11 in DFSR (erratum 3261=
03).
- * The test below covers all the write situations, including Java bytecode=
s
+ * Faulty SWP instruction on 1136 doesn't set bit 11 in DFSR.
  */
-	bic	r1, r1, #1 << 11		@ clear bit 11 of FSR
+#ifdef CONFIG_ARM_ERRATA_326103
+	ldr	ip, =3D0x4107b36
+	mrc	p15, 0, r3, c0, c0, 0		@ get processor id
+	teq	ip, r3, lsr #4			@ r0 ARM1136?
+	bne	do_DataAbort
 	tst	r5, #PSR_J_BIT			@ Java?
+	tsteq	r5, #PSR_T_BIT			@ Thumb?
 	bne	do_DataAbort
-	do_thumb_abort fsr=3Dr1, pc=3Dr4, psr=3Dr5, tmp=3Dr3
-	ldreq	r3, [r4]			@ read aborted ARM instruction
+	bic	r1, r1, #1 << 11		@ clear bit 11 of FSR
+	ldr	r3, [r4]			@ read aborted ARM instruction
 #ifdef CONFIG_CPU_ENDIAN_BE8
-	reveq	r3, r3
+	rev	r3, r3
 #endif
 	do_ldrd_abort tmp=3Dip, insn=3Dr3
 	tst	r3, #1 << 20			@ L =3D 0 -> write
 	orreq	r1, r1, #1 << 11		@ yes.
+#endif
 	b	do_DataAbort
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index b1e192b..db7bcc0 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -32,6 +32,7 @@ static void __iomem *l2x0_base;
 static DEFINE_RAW_SPINLOCK(l2x0_lock);
 static uint32_t l2x0_way_mask;	/* Bitmask of active ways */
 static uint32_t l2x0_size;
+static unsigned long sync_reg_offset =3D L2X0_CACHE_SYNC;
=20
 struct l2x0_regs l2x0_saved_regs;
=20
@@ -61,12 +62,7 @@ static inline void cache_sync(void)
 {
 	void __iomem *base =3D l2x0_base;
=20
-#ifdef CONFIG_PL310_ERRATA_753970
-	/* write to an unmmapped register */
-	writel_relaxed(0, base + L2X0_DUMMY_REG);
-#else
-	writel_relaxed(0, base + L2X0_CACHE_SYNC);
-#endif
+	writel_relaxed(0, base + sync_reg_offset);
 	cache_wait(base + L2X0_CACHE_SYNC, 1);
 }
=20
@@ -85,10 +81,13 @@ static inline void l2x0_inv_line(unsigned long addr)
 }
=20
 #if defined(CONFIG_PL310_ERRATA_588369) || defined(CONFIG_PL310_ERRATA_727=
915)
+static inline void debug_writel(unsigned long val)
+{
+	if (outer_cache.set_debug)
+		outer_cache.set_debug(val);
+}
=20
-#define debug_writel(val)	outer_cache.set_debug(val)
-
-static void l2x0_set_debug(unsigned long val)
+static void pl310_set_debug(unsigned long val)
 {
 	writel_relaxed(val, l2x0_base + L2X0_DEBUG_CTRL);
 }
@@ -98,7 +97,7 @@ static inline void debug_writel(unsigned long val)
 {
 }
=20
-#define l2x0_set_debug	NULL
+#define pl310_set_debug	NULL
 #endif
=20
 #ifdef CONFIG_PL310_ERRATA_588369
@@ -331,6 +330,11 @@ void __init l2x0_init(void __iomem *base, __u32 aux_va=
l, __u32 aux_mask)
 		else
 			ways =3D 8;
 		type =3D "L310";
+#ifdef CONFIG_PL310_ERRATA_753970
+		/* Unmapped register. */
+		sync_reg_offset =3D L2X0_DUMMY_REG;
+#endif
+		outer_cache.set_debug =3D pl310_set_debug;
 		break;
 	case L2X0_CACHE_ID_PART_L210:
 		ways =3D (aux >> 13) & 0xf;
@@ -379,7 +383,6 @@ void __init l2x0_init(void __iomem *base, __u32 aux_val=
, __u32 aux_mask)
 	outer_cache.flush_all =3D l2x0_flush_all;
 	outer_cache.inv_all =3D l2x0_inv_all;
 	outer_cache.disable =3D l2x0_disable;
-	outer_cache.set_debug =3D l2x0_set_debug;
=20
 	printk(KERN_INFO "%s cache controller enabled\n", type);
 	printk(KERN_INFO "l2x0: %d ways, CACHE_ID 0x%08x, AUX_CTRL 0x%08x, Cache =
size: %d B\n",
diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/r=
elocs.c
index 89bbf4e..e77f4e4 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -402,13 +402,11 @@ static void print_absolute_symbols(void)
 	for (i =3D 0; i < ehdr.e_shnum; i++) {
 		struct section *sec =3D &secs[i];
 		char *sym_strtab;
-		Elf32_Sym *sh_symtab;
 		int j;
=20
 		if (sec->shdr.sh_type !=3D SHT_SYMTAB) {
 			continue;
 		}
-		sh_symtab =3D sec->symtab;
 		sym_strtab =3D sec->link->strtab;
 		for (j =3D 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
 			Elf32_Sym *sym;
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f98d84c..c4e3581 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1577,9 +1577,11 @@ static int __init apic_verify(void)
 	mp_lapic_addr =3D APIC_DEFAULT_PHYS_BASE;
=20
 	/* The BIOS may have set up the APIC at some other address */
-	rdmsr(MSR_IA32_APICBASE, l, h);
-	if (l & MSR_IA32_APICBASE_ENABLE)
-		mp_lapic_addr =3D l & MSR_IA32_APICBASE_BASE;
+	if (boot_cpu_data.x86 >=3D 6) {
+		rdmsr(MSR_IA32_APICBASE, l, h);
+		if (l & MSR_IA32_APICBASE_ENABLE)
+			mp_lapic_addr =3D l & MSR_IA32_APICBASE_BASE;
+	}
=20
 	pr_info("Found and enabled local APIC!\n");
 	return 0;
@@ -1597,13 +1599,15 @@ int __init apic_force_enable(unsigned long addr)
 	 * MSR. This can only be done in software for Intel P6 or later
 	 * and AMD K7 (Model > 1) or later.
 	 */
-	rdmsr(MSR_IA32_APICBASE, l, h);
-	if (!(l & MSR_IA32_APICBASE_ENABLE)) {
-		pr_info("Local APIC disabled by BIOS -- reenabling.\n");
-		l &=3D ~MSR_IA32_APICBASE_BASE;
-		l |=3D MSR_IA32_APICBASE_ENABLE | addr;
-		wrmsr(MSR_IA32_APICBASE, l, h);
-		enabled_via_apicbase =3D 1;
+	if (boot_cpu_data.x86 >=3D 6) {
+		rdmsr(MSR_IA32_APICBASE, l, h);
+		if (!(l & MSR_IA32_APICBASE_ENABLE)) {
+			pr_info("Local APIC disabled by BIOS -- reenabling.\n");
+			l &=3D ~MSR_IA32_APICBASE_BASE;
+			l |=3D MSR_IA32_APICBASE_ENABLE | addr;
+			wrmsr(MSR_IA32_APICBASE, l, h);
+			enabled_via_apicbase =3D 1;
+		}
 	}
 	return apic_verify();
 }
@@ -2149,10 +2153,12 @@ static void lapic_resume(void)
 		 * FIXME! This will be wrong if we ever support suspend on
 		 * SMP! We'll need to do this as part of the CPU restore!
 		 */
-		rdmsr(MSR_IA32_APICBASE, l, h);
-		l &=3D ~MSR_IA32_APICBASE_BASE;
-		l |=3D MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
-		wrmsr(MSR_IA32_APICBASE, l, h);
+		if (boot_cpu_data.x86 >=3D 6) {
+			rdmsr(MSR_IA32_APICBASE, l, h);
+			l &=3D ~MSR_IA32_APICBASE_BASE;
+			l |=3D MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
+			wrmsr(MSR_IA32_APICBASE, l, h);
+		}
 	}
=20
 	maxlvt =3D lapic_get_maxlvt();
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_c=
ore.c
index 9d46f5e..563a09d 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -418,10 +418,8 @@ static int mc_sysdev_add(struct sys_device *sys_dev)
 	if (err)
 		return err;
=20
-	if (microcode_init_cpu(cpu) =3D=3D UCODE_ERROR) {
-		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+	if (microcode_init_cpu(cpu) =3D=3D UCODE_ERROR)
 		return -EINVAL;
-	}
=20
 	return err;
 }
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.=
c
index 71f4727..5a98aa2 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -185,10 +185,22 @@ void __init setup_per_cpu_areas(void)
 #endif
 	rc =3D -EINVAL;
 	if (pcpu_chosen_fc !=3D PCPU_FC_PAGE) {
-		const size_t atom_size =3D cpu_has_pse ? PMD_SIZE : PAGE_SIZE;
 		const size_t dyn_size =3D PERCPU_MODULE_RESERVE +
 			PERCPU_DYNAMIC_RESERVE - PERCPU_FIRST_CHUNK_RESERVE;
+		size_t atom_size;
=20
+		/*
+		 * On 64bit, use PMD_SIZE for atom_size so that embedded
+		 * percpu areas are aligned to PMD.  This, in the future,
+		 * can also allow using PMD mappings in vmalloc area.  Use
+		 * PAGE_SIZE on 32bit as vmalloc space is highly contended
+		 * and large vmalloc area allocs can easily fail.
+		 */
+#ifdef CONFIG_X86_64
+		atom_size =3D PMD_SIZE;
+#else
+		atom_size =3D PAGE_SIZE;
+#endif
 		rc =3D pcpu_embed_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
 					    dyn_size, atom_size,
 					    pcpu_cpu_distance,
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 1f92865..e7c920b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -62,6 +62,7 @@
 #include <asm/reboot.h>
 #include <asm/stackprotector.h>
 #include <asm/hypervisor.h>
+#include <asm/pci_x86.h>
=20
 #include "xen-ops.h"
 #include "mmu.h"
@@ -1278,8 +1279,10 @@ asmlinkage void __init xen_start_kernel(void)
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
 	}
-	=09
-
+#ifdef CONFIG_PCI
+	/* PCI BIOS service won't work from a PV guest. */
+	pci_probe &=3D ~PCI_PROBE_BIOS;
+#endif
 	xen_raw_console_write("about to get started...\n");
=20
 	xen_setup_runstate_info(0);
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 87f6673..ec3d603 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -353,8 +353,13 @@ static pteval_t pte_mfn_to_pfn(pteval_t val)
 {
 	if (val & _PAGE_PRESENT) {
 		unsigned long mfn =3D (val & PTE_PFN_MASK) >> PAGE_SHIFT;
+		unsigned long pfn =3D mfn_to_pfn(mfn);
+
 		pteval_t flags =3D val & PTE_FLAGS_MASK;
-		val =3D ((pteval_t)mfn_to_pfn(mfn) << PAGE_SHIFT) | flags;
+		if (unlikely(pfn =3D=3D ~0))
+			val =3D flags & ~_PAGE_PRESENT;
+		else
+			val =3D ((pteval_t)pfn << PAGE_SHIFT) | flags;
 	}
=20
 	return val;
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 041d4fe..9a23fff 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -172,6 +172,7 @@ static void __init xen_fill_possible_map(void)
 static void __init xen_filter_cpu_maps(void)
 {
 	int i, rc;
+	unsigned int subtract =3D 0;
=20
 	if (!xen_initial_domain())
 		return;
@@ -186,8 +187,22 @@ static void __init xen_filter_cpu_maps(void)
 		} else {
 			set_cpu_possible(i, false);
 			set_cpu_present(i, false);
+			subtract++;
 		}
 	}
+#ifdef CONFIG_HOTPLUG_CPU
+	/* This is akin to using 'nr_cpus' on the Linux command line.
+	 * Which is OK as when we use 'dom0_max_vcpus=3DX' we can only
+	 * have up to X, while nr_cpu_ids is greater than X. This
+	 * normally is not a problem, except when CPU hotplugging
+	 * is involved and then there might be more than X CPUs
+	 * in the guest - which will not work as there is no
+	 * hypercall to expand the max number of VCPUs an already
+	 * running guest has. So cap it up to X. */
+	if (subtract)
+		nr_cpu_ids =3D nr_cpu_ids - subtract;
+#endif
+
 }
=20
 static void __init xen_smp_prepare_boot_cpu(void)
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 79d7362..3e45aa0 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -96,7 +96,7 @@ ENTRY(xen_restore_fl_direct)
=20
 	/* check for unmasked and pending */
 	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
-	jz 1f
+	jnz 1f
 2:	call check_events
 1:
 ENDPATCH(xen_restore_fl_direct)
diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 107f6f7..dd30f40 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -174,7 +174,7 @@ sha512_update(struct shash_desc *desc, const u8 *data, =
unsigned int len)
 	index =3D sctx->count[0] & 0x7f;
=20
 	/* Update number of bytes */
-	if (!(sctx->count[0] +=3D len))
+	if ((sctx->count[0] +=3D len) < len)
 		sctx->count[1]++;
=20
         part_len =3D 128 - index;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index a9b2820..58db834 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3500,7 +3500,8 @@ static int ata_count_probe_trials_cb(struct ata_ering=
_entry *ent, void *void_arg
 	u64 now =3D get_jiffies_64();
 	int *trials =3D void_arg;
=20
-	if (ent->timestamp < now - min(now, interval))
+	if ((ent->eflags & ATA_EFLAG_OLD_ER) ||
+	    (ent->timestamp < now - min(now, interval)))
 		return -1;
=20
 	(*trials)++;
diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 003cd8d..99fefbd 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -73,6 +73,7 @@ static struct usb_device_id ath3k_table[] =3D {
 	{ USB_DEVICE(0x0CF3, 0x3004) },
 	{ USB_DEVICE(0x0CF3, 0x311D) },
 	{ USB_DEVICE(0x13d3, 0x3375) },
+	{ USB_DEVICE(0x04CA, 0x3005) },
=20
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
@@ -91,6 +92,7 @@ static struct usb_device_id ath3k_blist_tbl[] =3D {
 	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info =3D BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x311D), .driver_info =3D BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info =3D BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3005), .driver_info =3D BTUSB_ATH3012 },
=20
 	{ }	/* Terminating entry */
 };
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index db44ad5..e56da6a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -129,6 +129,7 @@ static struct usb_device_id blacklist_table[] =3D {
 	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info =3D BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x311d), .driver_info =3D BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info =3D BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3005), .driver_info =3D BTUSB_ATH3012 },
=20
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info =3D BTUSB_IGNORE },
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index a60adbf..79dcf6e 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -239,10 +239,6 @@ static void atc_dostart(struct at_dma_chan *atchan, st=
ruct at_desc *first)
=20
 	vdbg_dump_regs(atchan);
=20
-	/* clear any pending interrupt */
-	while (dma_readl(atdma, EBCISR))
-		cpu_relax();
-
 	channel_writel(atchan, SADDR, 0);
 	channel_writel(atchan, DADDR, 0);
 	channel_writel(atchan, CTRLA, 0);
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index b0a8117..0535c21 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -191,6 +191,190 @@ utf16_strncmp(const efi_char16_t *a, const efi_char16=
_t *b, size_t len)
 	}
 }
=20
+static bool
+validate_device_path(struct efi_variable *var, int match, u8 *buffer,
+		     unsigned long len)
+{
+	struct efi_generic_dev_path *node;
+	int offset =3D 0;
+
+	node =3D (struct efi_generic_dev_path *)buffer;
+
+	if (len < sizeof(*node))
+		return false;
+
+	while (offset <=3D len - sizeof(*node) &&
+	       node->length >=3D sizeof(*node) &&
+		node->length <=3D len - offset) {
+		offset +=3D node->length;
+
+		if ((node->type =3D=3D EFI_DEV_END_PATH ||
+		     node->type =3D=3D EFI_DEV_END_PATH2) &&
+		    node->sub_type =3D=3D EFI_DEV_END_ENTIRE)
+			return true;
+
+		node =3D (struct efi_generic_dev_path *)(buffer + offset);
+	}
+
+	/*
+	 * If we're here then either node->length pointed past the end
+	 * of the buffer or we reached the end of the buffer without
+	 * finding a device path end node.
+	 */
+	return false;
+}
+
+static bool
+validate_boot_order(struct efi_variable *var, int match, u8 *buffer,
+		    unsigned long len)
+{
+	/* An array of 16-bit integers */
+	if ((len % 2) !=3D 0)
+		return false;
+
+	return true;
+}
+
+static bool
+validate_load_option(struct efi_variable *var, int match, u8 *buffer,
+		     unsigned long len)
+{
+	u16 filepathlength;
+	int i, desclength =3D 0, namelen;
+
+	namelen =3D utf16_strnlen(var->VariableName, sizeof(var->VariableName));
+
+	/* Either "Boot" or "Driver" followed by four digits of hex */
+	for (i =3D match; i < match+4; i++) {
+		if (var->VariableName[i] > 127 ||
+		    hex_to_bin(var->VariableName[i] & 0xff) < 0)
+			return true;
+	}
+
+	/* Reject it if there's 4 digits of hex and then further content */
+	if (namelen > match + 4)
+		return false;
+
+	/* A valid entry must be at least 8 bytes */
+	if (len < 8)
+		return false;
+
+	filepathlength =3D buffer[4] | buffer[5] << 8;
+
+	/*
+	 * There's no stored length for the description, so it has to be
+	 * found by hand
+	 */
+	desclength =3D utf16_strsize((efi_char16_t *)(buffer + 6), len - 6) + 2;
+
+	/* Each boot entry must have a descriptor */
+	if (!desclength)
+		return false;
+
+	/*
+	 * If the sum of the length of the description, the claimed filepath
+	 * length and the original header are greater than the length of the
+	 * variable, it's malformed
+	 */
+	if ((desclength + filepathlength + 6) > len)
+		return false;
+
+	/*
+	 * And, finally, check the filepath
+	 */
+	return validate_device_path(var, match, buffer + desclength + 6,
+				    filepathlength);
+}
+
+static bool
+validate_uint16(struct efi_variable *var, int match, u8 *buffer,
+		unsigned long len)
+{
+	/* A single 16-bit integer */
+	if (len !=3D 2)
+		return false;
+
+	return true;
+}
+
+static bool
+validate_ascii_string(struct efi_variable *var, int match, u8 *buffer,
+		      unsigned long len)
+{
+	int i;
+
+	for (i =3D 0; i < len; i++) {
+		if (buffer[i] > 127)
+			return false;
+
+		if (buffer[i] =3D=3D 0)
+			return true;
+	}
+
+	return false;
+}
+
+struct variable_validate {
+	char *name;
+	bool (*validate)(struct efi_variable *var, int match, u8 *data,
+			 unsigned long len);
+};
+
+static const struct variable_validate variable_validate[] =3D {
+	{ "BootNext", validate_uint16 },
+	{ "BootOrder", validate_boot_order },
+	{ "DriverOrder", validate_boot_order },
+	{ "Boot*", validate_load_option },
+	{ "Driver*", validate_load_option },
+	{ "ConIn", validate_device_path },
+	{ "ConInDev", validate_device_path },
+	{ "ConOut", validate_device_path },
+	{ "ConOutDev", validate_device_path },
+	{ "ErrOut", validate_device_path },
+	{ "ErrOutDev", validate_device_path },
+	{ "Timeout", validate_uint16 },
+	{ "Lang", validate_ascii_string },
+	{ "PlatformLang", validate_ascii_string },
+	{ "", NULL },
+};
+
+static bool
+validate_var(struct efi_variable *var, u8 *data, unsigned long len)
+{
+	int i;
+	u16 *unicode_name =3D var->VariableName;
+
+	for (i =3D 0; variable_validate[i].validate !=3D NULL; i++) {
+		const char *name =3D variable_validate[i].name;
+		int match;
+
+		for (match =3D 0; ; match++) {
+			char c =3D name[match];
+			u16 u =3D unicode_name[match];
+
+			/* All special variables are plain ascii */
+			if (u > 127)
+				return true;
+
+			/* Wildcard in the matching name means we've matched */
+			if (c =3D=3D '*')
+				return variable_validate[i].validate(var,
+							     match, data, len);
+
+			/* Case sensitive match */
+			if (c !=3D u)
+				break;
+
+			/* Reached the end of the string while matching */
+			if (!c)
+				return variable_validate[i].validate(var,
+							     match, data, len);
+		}
+	}
+
+	return true;
+}
+
 static efi_status_t
 get_var_data_locked(struct efivars *efivars, struct efi_variable *var)
 {
@@ -324,6 +508,12 @@ efivar_store_raw(struct efivar_entry *entry, const cha=
r *buf, size_t count)
 		return -EINVAL;
 	}
=20
+	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) !=3D 0 ||
+	    validate_var(new_var, new_var->Data, new_var->DataSize) =3D=3D false)=
 {
+		printk(KERN_ERR "efivars: Malformed variable content\n");
+		return -EINVAL;
+	}
+
 	spin_lock(&efivars->lock);
 	status =3D efivars->ops->set_variable(new_var->VariableName,
 					    &new_var->VendorGuid,
@@ -624,6 +814,12 @@ static ssize_t efivar_create(struct file *filp, struct=
 kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
=20
+	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) !=3D 0 ||
+	    validate_var(new_var, new_var->Data, new_var->DataSize) =3D=3D false)=
 {
+		printk(KERN_ERR "efivars: Malformed variable content\n");
+		return -EINVAL;
+	}
+
 	spin_lock(&efivars->lock);
=20
 	/*
diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i=
915/i915_gem_execbuffer.c
index b9da890..a6c2f7a 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -984,6 +984,7 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *da=
ta,
 	struct intel_ring_buffer *ring;
 	u32 exec_start, exec_len;
 	u32 seqno;
+	u32 mask;
 	int ret, mode, i;
=20
 	if (!i915_gem_check_execbuffer(args)) {
@@ -1021,6 +1022,7 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *=
data,
 	}
=20
 	mode =3D args->flags & I915_EXEC_CONSTANTS_MASK;
+	mask =3D I915_EXEC_CONSTANTS_MASK;
 	switch (mode) {
 	case I915_EXEC_CONSTANTS_REL_GENERAL:
 	case I915_EXEC_CONSTANTS_ABSOLUTE:
@@ -1034,18 +1036,9 @@ i915_gem_do_execbuffer(struct drm_device *dev, void =
*data,
 			    mode =3D=3D I915_EXEC_CONSTANTS_REL_SURFACE)
 				return -EINVAL;
=20
-			ret =3D intel_ring_begin(ring, 4);
-			if (ret)
-				return ret;
-
-			intel_ring_emit(ring, MI_NOOP);
-			intel_ring_emit(ring, MI_LOAD_REGISTER_IMM(1));
-			intel_ring_emit(ring, INSTPM);
-			intel_ring_emit(ring,
-					I915_EXEC_CONSTANTS_MASK << 16 | mode);
-			intel_ring_advance(ring);
-
-			dev_priv->relative_constants_mode =3D mode;
+			/* The HW changed the meaning on this bit on gen6 */
+			if (INTEL_INFO(dev)->gen >=3D 6)
+				mask &=3D ~I915_EXEC_CONSTANTS_REL_SURFACE;
 		}
 		break;
 	default:
@@ -1064,6 +1057,11 @@ i915_gem_do_execbuffer(struct drm_device *dev, void =
*data,
 			return -EINVAL;
 		}
=20
+		if (args->num_cliprects > UINT_MAX / sizeof(*cliprects)) {
+			DRM_DEBUG("execbuf with %u cliprects\n",
+				  args->num_cliprects);
+			return -EINVAL;
+		}
 		cliprects =3D kmalloc(args->num_cliprects * sizeof(*cliprects),
 				    GFP_KERNEL);
 		if (cliprects =3D=3D NULL) {
@@ -1176,6 +1174,21 @@ i915_gem_do_execbuffer(struct drm_device *dev, void =
*data,
 		}
 	}
=20
+	if (ring =3D=3D &dev_priv->ring[RCS] &&
+	    mode !=3D dev_priv->relative_constants_mode) {
+		ret =3D intel_ring_begin(ring, 4);
+		if (ret)
+				goto err;
+
+		intel_ring_emit(ring, MI_NOOP);
+		intel_ring_emit(ring, MI_LOAD_REGISTER_IMM(1));
+		intel_ring_emit(ring, INSTPM);
+		intel_ring_emit(ring, mask << 16 | mode);
+		intel_ring_advance(ring);
+
+		dev_priv->relative_constants_mode =3D mode;
+	}
+
 	trace_i915_gem_ring_dispatch(ring, seqno);
=20
 	exec_start =3D batch_obj->gtt_offset + args->batch_start_offset;
@@ -1314,7 +1327,8 @@ i915_gem_execbuffer2(struct drm_device *dev, void *da=
ta,
 	struct drm_i915_gem_exec_object2 *exec2_list =3D NULL;
 	int ret;
=20
-	if (args->buffer_count < 1) {
+	if (args->buffer_count < 1 ||
+	    args->buffer_count > UINT_MAX / sizeof(*exec2_list)) {
 		DRM_ERROR("execbuf2 with %d buffers\n", args->buffer_count);
 		return -EINVAL;
 	}
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_re=
g.h
index 2f99fd4..cbe5a88 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -442,6 +442,7 @@
 #define   INSTPM_AGPBUSY_DIS (1<<11) /* gen3: when disabled, pending inter=
rupts
 					will not assert AGPBUSY# and will only
 					be delivered when out of C3. */
+#define   INSTPM_FORCE_ORDERING				(1<<7) /* GEN6+ */
 #define ACTHD	        0x020c8
 #define FW_BLC		0x020d8
 #define FW_BLC2		0x020dc
@@ -522,6 +523,7 @@
 #define   CM0_MASK_SHIFT          16
 #define   CM0_IZ_OPT_DISABLE      (1<<6)
 #define   CM0_ZR_OPT_DISABLE      (1<<5)
+#define	  CM0_STC_EVICT_DISABLE_LRA_SNB	(1<<5)
 #define   CM0_DEPTH_EVICT_DISABLE (1<<4)
 #define   CM0_COLOR_EVICT_DISABLE (1<<3)
 #define   CM0_DEPTH_WRITE_DISABLE (1<<1)
diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel=
_hdmi.c
index 64541f7..9cd81ba 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -136,7 +136,7 @@ static void i9xx_write_infoframe(struct drm_encoder *en=
coder,
=20
 	val &=3D ~VIDEO_DIP_SELECT_MASK;
=20
-	I915_WRITE(VIDEO_DIP_CTL, val | port | flags);
+	I915_WRITE(VIDEO_DIP_CTL, VIDEO_DIP_ENABLE | val | port | flags);
=20
 	for (i =3D 0; i < len; i +=3D 4) {
 		I915_WRITE(VIDEO_DIP_DATA, *data);
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915=
/intel_ringbuffer.c
index 8673581..62f9ac5 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -414,6 +414,22 @@ static int init_render_ring(struct intel_ring_buffer *=
ring)
 			return ret;
 	}
=20
+
+	if (IS_GEN6(dev)) {
+		/* From the Sandybridge PRM, volume 1 part 3, page 24:
+		 * "If this bit is set, STCunit will have LRA as replacement
+		 *  policy. [...] This bit must be reset.  LRA replacement
+		 *  policy is not supported."
+		 */
+		I915_WRITE(CACHE_MODE_0,
+			   CM0_STC_EVICT_DISABLE_LRA_SNB << CM0_MASK_SHIFT);
+	}
+
+	if (INTEL_INFO(dev)->gen >=3D 6) {
+		I915_WRITE(INSTPM,
+			   INSTPM_FORCE_ORDERING << 16 | INSTPM_FORCE_ORDERING);
+	}
+
 	return ret;
 }
=20
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel=
_sdvo.c
index e334ec3..8eddcca 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -731,6 +731,7 @@ static void intel_sdvo_get_dtd_from_mode(struct intel_s=
dvo_dtd *dtd,
 	uint16_t width, height;
 	uint16_t h_blank_len, h_sync_len, v_blank_len, v_sync_len;
 	uint16_t h_sync_offset, v_sync_offset;
+	int mode_clock;
=20
 	width =3D mode->crtc_hdisplay;
 	height =3D mode->crtc_vdisplay;
@@ -745,7 +746,11 @@ static void intel_sdvo_get_dtd_from_mode(struct intel_=
sdvo_dtd *dtd,
 	h_sync_offset =3D mode->crtc_hsync_start - mode->crtc_hblank_start;
 	v_sync_offset =3D mode->crtc_vsync_start - mode->crtc_vblank_start;
=20
-	dtd->part1.clock =3D mode->clock / 10;
+	mode_clock =3D mode->clock;
+	mode_clock /=3D intel_mode_get_pixel_multiplier(mode) ?: 1;
+	mode_clock /=3D 10;
+	dtd->part1.clock =3D mode_clock;
+
 	dtd->part1.h_active =3D width & 0xff;
 	dtd->part1.h_blank =3D h_blank_len & 0xff;
 	dtd->part1.h_high =3D (((width >> 8) & 0xf) << 4) |
@@ -997,7 +1002,7 @@ static void intel_sdvo_mode_set(struct drm_encoder *en=
coder,
 	struct intel_sdvo *intel_sdvo =3D to_intel_sdvo(encoder);
 	u32 sdvox;
 	struct intel_sdvo_in_out_map in_out;
-	struct intel_sdvo_dtd input_dtd;
+	struct intel_sdvo_dtd input_dtd, output_dtd;
 	int pixel_multiplier =3D intel_mode_get_pixel_multiplier(adjusted_mode);
 	int rate;
=20
@@ -1022,20 +1027,13 @@ static void intel_sdvo_mode_set(struct drm_encoder =
*encoder,
 					  intel_sdvo->attached_output))
 		return;
=20
-	/* We have tried to get input timing in mode_fixup, and filled into
-	 * adjusted_mode.
-	 */
-	if (intel_sdvo->is_tv || intel_sdvo->is_lvds) {
-		input_dtd =3D intel_sdvo->input_dtd;
-	} else {
-		/* Set the output timing to the screen */
-		if (!intel_sdvo_set_target_output(intel_sdvo,
-						  intel_sdvo->attached_output))
-			return;
-
-		intel_sdvo_get_dtd_from_mode(&input_dtd, adjusted_mode);
-		(void) intel_sdvo_set_output_timing(intel_sdvo, &input_dtd);
-	}
+	/* lvds has a special fixed output timing. */
+	if (intel_sdvo->is_lvds)
+		intel_sdvo_get_dtd_from_mode(&output_dtd,
+					     intel_sdvo->sdvo_lvds_fixed_mode);
+	else
+		intel_sdvo_get_dtd_from_mode(&output_dtd, mode);
+	(void) intel_sdvo_set_output_timing(intel_sdvo, &output_dtd);
=20
 	/* Set the input timing to the screen. Assume always input 0. */
 	if (!intel_sdvo_set_target_input(intel_sdvo))
@@ -1053,6 +1051,10 @@ static void intel_sdvo_mode_set(struct drm_encoder *=
encoder,
 	    !intel_sdvo_set_tv_format(intel_sdvo))
 		return;
=20
+	/* We have tried to get input timing in mode_fixup, and filled into
+	 * adjusted_mode.
+	 */
+	intel_sdvo_get_dtd_from_mode(&input_dtd, adjusted_mode);
 	(void) intel_sdvo_set_input_timing(intel_sdvo, &input_dtd);
=20
 	switch (pixel_multiplier) {
@@ -1219,8 +1221,14 @@ static bool intel_sdvo_get_capabilities(struct intel=
_sdvo *intel_sdvo, struct in
=20
 static int intel_sdvo_supports_hotplug(struct intel_sdvo *intel_sdvo)
 {
+	struct drm_device *dev =3D intel_sdvo->base.base.dev;
 	u8 response[2];
=20
+	/* HW Erratum: SDVO Hotplug is broken on all i945G chips, there's noise
+	 * on the line. */
+	if (IS_I945G(dev) || IS_I945GM(dev))
+		return false;
+
 	return intel_sdvo_get_value(intel_sdvo, SDVO_CMD_GET_HOT_PLUG_SUPPORT,
 				    &response, 2) && response[0];
 }
diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouve=
au/nouveau_acpi.c
index 525744d..3df56c7 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -245,7 +245,7 @@ static bool nouveau_dsm_detect(void)
 	struct acpi_buffer buffer =3D {sizeof(acpi_method_name), acpi_method_name=
};
 	struct pci_dev *pdev =3D NULL;
 	int has_dsm =3D 0;
-	int has_optimus;
+	int has_optimus =3D 0;
 	int vga_count =3D 0;
 	bool guid_valid;
 	int retval;
diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeo=
n/atombios_crtc.c
index b30081f..757c549 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -917,8 +917,8 @@ static void atombios_crtc_set_pll(struct drm_crtc *crtc=
, struct drm_display_mode
 		break;
 	}
=20
-	if (radeon_encoder->active_device &
-	    (ATOM_DEVICE_LCD_SUPPORT | ATOM_DEVICE_DFP_SUPPORT)) {
+	if ((radeon_encoder->active_device & (ATOM_DEVICE_LCD_SUPPORT | ATOM_DEVI=
CE_DFP_SUPPORT)) ||
+	    (radeon_encoder_get_dp_bridge_encoder_id(encoder) !=3D ENCODER_OBJECT=
_ID_NONE)) {
 		struct radeon_encoder_atom_dig *dig =3D radeon_encoder->enc_priv;
 		struct drm_connector *connector =3D
 			radeon_get_connector_for_encoder(encoder);
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 104b376..427468f 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -51,7 +51,7 @@ module_param_named(tjmax, force_tjmax, int, 0444);
 MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
=20
 #define BASE_SYSFS_ATTR_NO	2	/* Sysfs Base attr no for coretemp */
-#define NUM_REAL_CORES		16	/* Number of Real cores per cpu */
+#define NUM_REAL_CORES		32	/* Number of Real cores per cpu */
 #define CORETEMP_NAME_LENGTH	17	/* String Length of attrs */
 #define MAX_CORE_ATTRS		4	/* Maximum no of basic attrs */
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
@@ -705,6 +705,10 @@ static void __cpuinit put_core_offline(unsigned int cp=
u)
=20
 	indx =3D TO_ATTR_NO(cpu);
=20
+	/* The core id is too big, just return */
+	if (indx > MAX_CORE_DATA - 1)
+		return;
+
 	if (pdata->core_data[indx] && pdata->core_data[indx]->cpu =3D=3D cpu)
 		coretemp_remove_core(pdata, &pdev->dev, indx);
=20
diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 930370d..9a4c3ab 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -122,6 +122,41 @@ static bool __devinit fam15h_power_is_internal_node0(s=
truct pci_dev *f4)
 	return true;
 }
=20
+/*
+ * Newer BKDG versions have an updated recommendation on how to properly
+ * initialize the running average range (was: 0xE, now: 0x9). This avoids
+ * counter saturations resulting in bogus power readings.
+ * We correct this value ourselves to cope with older BIOSes.
+ */
+static DEFINE_PCI_DEVICE_TABLE(affected_device) =3D {
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ 0 }
+};
+
+static void __devinit tweak_runavg_range(struct pci_dev *pdev)
+{
+	u32 val;
+
+	/*
+	 * let this quirk apply only to the current version of the
+	 * northbridge, since future versions may change the behavior
+	 */
+	if (!pci_match_id(affected_device, pdev))
+		return;
+
+	pci_bus_read_config_dword(pdev->bus,
+		PCI_DEVFN(PCI_SLOT(pdev->devfn), 5),
+		REG_TDP_RUNNING_AVERAGE, &val);
+	if ((val & 0xf) !=3D 0xe)
+		return;
+
+	val &=3D ~0xf;
+	val |=3D  0x9;
+	pci_bus_write_config_dword(pdev->bus,
+		PCI_DEVFN(PCI_SLOT(pdev->devfn), 5),
+		REG_TDP_RUNNING_AVERAGE, val);
+}
+
 static void __devinit fam15h_power_init_data(struct pci_dev *f4,
 					     struct fam15h_power_data *data)
 {
@@ -155,6 +190,13 @@ static int __devinit fam15h_power_probe(struct pci_dev=
 *pdev,
 	struct device *dev;
 	int err;
=20
+	/*
+	 * though we ignore every other northbridge, we still have to
+	 * do the tweaking on _each_ node in MCM processors as the counters
+	 * are working hand-in-hand
+	 */
+	tweak_runavg_range(pdev);
+
 	if (!fam15h_power_is_internal_node0(pdev)) {
 		err =3D -ENODEV;
 		goto exit;
diff --git a/drivers/i2c/busses/i2c-pnx.c b/drivers/i2c/busses/i2c-pnx.c
index 04be9f8..eb8ad53 100644
--- a/drivers/i2c/busses/i2c-pnx.c
+++ b/drivers/i2c/busses/i2c-pnx.c
@@ -546,8 +546,7 @@ static int i2c_pnx_controller_suspend(struct platform_d=
evice *pdev,
 {
 	struct i2c_pnx_algo_data *alg_data =3D platform_get_drvdata(pdev);
=20
-	/* FIXME: shouldn't this be clk_disable? */
-	clk_enable(alg_data->clk);
+	clk_disable(alg_data->clk);
=20
 	return 0;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6f37aa4..065ab4f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8100,7 +8100,8 @@ static int md_notify_reboot(struct notifier_block *th=
is,
=20
 	for_each_mddev(mddev, tmp) {
 		if (mddev_trylock(mddev)) {
-			__md_stop_writes(mddev);
+			if (mddev->pers)
+				__md_stop_writes(mddev);
 			mddev->safemode =3D 2;
 			mddev_unlock(mddev);
 		}
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/fr=
ontends/drxk_hard.c
index f6431ef..a1f5e3d 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -1523,8 +1523,10 @@ static int scu_command(struct drxk_state *state,
 	dprintk(1, "\n");
=20
 	if ((cmd =3D=3D 0) || ((parameterLen > 0) && (parameter =3D=3D NULL)) ||
-	    ((resultLen > 0) && (result =3D=3D NULL)))
-		goto error;
+	    ((resultLen > 0) && (result =3D=3D NULL))) {
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		return status;
+	}
=20
 	mutex_lock(&state->mutex);
=20
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.=
c
index 13f54b5..a7e7d6f 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1046,6 +1046,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_=
device_id *dev_id)
 		goto exit_unregister_led;
 	}
=20
+	data->dev->driver_type =3D RC_DRIVER_IR_RAW;
 	data->dev->driver_name =3D WBCIR_NAME;
 	data->dev->input_name =3D WBCIR_NAME;
 	data->dev->input_phys =3D "wbcir/cir0";
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index e15e47d..34416d4 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -799,7 +799,7 @@ static int mmc_blk_issue_secdiscard_rq(struct mmc_queue=
 *mq,
 {
 	struct mmc_blk_data *md =3D mq->data;
 	struct mmc_card *card =3D md->queue.card;
-	unsigned int from, nr, arg;
+	unsigned int from, nr, arg, trim_arg, erase_arg;
 	int err =3D 0, type =3D MMC_BLK_SECDISCARD;
=20
 	if (!(mmc_can_secure_erase_trim(card) || mmc_can_sanitize(card))) {
@@ -807,20 +807,26 @@ static int mmc_blk_issue_secdiscard_rq(struct mmc_que=
ue *mq,
 		goto out;
 	}
=20
+	from =3D blk_rq_pos(req);
+	nr =3D blk_rq_sectors(req);
+
 	/* The sanitize operation is supported at v4.5 only */
 	if (mmc_can_sanitize(card)) {
-		err =3D mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-				EXT_CSD_SANITIZE_START, 1, 0);
-		goto out;
+		erase_arg =3D MMC_ERASE_ARG;
+		trim_arg =3D MMC_TRIM_ARG;
+	} else {
+		erase_arg =3D MMC_SECURE_ERASE_ARG;
+		trim_arg =3D MMC_SECURE_TRIM1_ARG;
 	}
=20
-	from =3D blk_rq_pos(req);
-	nr =3D blk_rq_sectors(req);
-
-	if (mmc_can_trim(card) && !mmc_erase_group_aligned(card, from, nr))
-		arg =3D MMC_SECURE_TRIM1_ARG;
-	else
-		arg =3D MMC_SECURE_ERASE_ARG;
+	if (mmc_erase_group_aligned(card, from, nr))
+		arg =3D erase_arg;
+	else if (mmc_can_trim(card))
+		arg =3D trim_arg;
+	else {
+		err =3D -EINVAL;
+		goto out;
+	}
 retry:
 	if (card->quirks & MMC_QUIRK_INAND_CMD38) {
 		err =3D mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
@@ -830,25 +836,41 @@ retry:
 				 INAND_CMD38_ARG_SECERASE,
 				 0);
 		if (err)
-			goto out;
+			goto out_retry;
 	}
+
 	err =3D mmc_erase(card, from, nr, arg);
-	if (!err && arg =3D=3D MMC_SECURE_TRIM1_ARG) {
+	if (err =3D=3D -EIO)
+		goto out_retry;
+	if (err)
+		goto out;
+
+	if (arg =3D=3D MMC_SECURE_TRIM1_ARG) {
 		if (card->quirks & MMC_QUIRK_INAND_CMD38) {
 			err =3D mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
 					 INAND_CMD38_ARG_EXT_CSD,
 					 INAND_CMD38_ARG_SECTRIM2,
 					 0);
 			if (err)
-				goto out;
+				goto out_retry;
 		}
+
 		err =3D mmc_erase(card, from, nr, MMC_SECURE_TRIM2_ARG);
+		if (err =3D=3D -EIO)
+			goto out_retry;
+		if (err)
+			goto out;
 	}
-out:
-	if (err =3D=3D -EIO && !mmc_blk_reset(md, card->host, type))
+
+	if (mmc_can_sanitize(card))
+		err =3D mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+				 EXT_CSD_SANITIZE_START, 1, 0);
+out_retry:
+	if (err && !mmc_blk_reset(md, card->host, type))
 		goto retry;
 	if (!err)
 		mmc_blk_reset_success(md, type);
+out:
 	spin_lock_irq(&md->lock);
 	__blk_end_request(req, err, blk_rq_bytes(req));
 	spin_unlock_irq(&md->lock);
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index dcad59c..78690f2 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -134,7 +134,7 @@ static void mmc_queue_setup_discard(struct request_queu=
e *q,
=20
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 	q->limits.max_discard_sectors =3D max_discard;
-	if (card->erased_byte =3D=3D 0)
+	if (card->erased_byte =3D=3D 0 && !mmc_can_discard(card))
 		q->limits.discard_zeroes_data =3D 1;
 	q->limits.discard_granularity =3D card->pref_erase << 9;
 	/* granularity must not be greater than max. discard */
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 950b97d..411a994 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1516,7 +1516,10 @@ static unsigned int mmc_mmc_erase_timeout(struct mmc=
_card *card,
 {
 	unsigned int erase_timeout;
=20
-	if (card->ext_csd.erase_group_def & 1) {
+	if (arg =3D=3D MMC_DISCARD_ARG ||
+	    (arg =3D=3D MMC_TRIM_ARG && card->ext_csd.rev >=3D 6)) {
+		erase_timeout =3D card->ext_csd.trim_timeout;
+	} else if (card->ext_csd.erase_group_def & 1) {
 		/* High Capacity Erase Group Size uses HC timeouts */
 		if (arg =3D=3D MMC_TRIM_ARG)
 			erase_timeout =3D card->ext_csd.trim_timeout;
@@ -1788,8 +1791,6 @@ int mmc_can_trim(struct mmc_card *card)
 {
 	if (card->ext_csd.sec_feature_support & EXT_CSD_SEC_GB_CL_EN)
 		return 1;
-	if (mmc_can_discard(card))
-		return 1;
 	return 0;
 }
 EXPORT_SYMBOL(mmc_can_trim);
@@ -1808,6 +1809,8 @@ EXPORT_SYMBOL(mmc_can_discard);
=20
 int mmc_can_sanitize(struct mmc_card *card)
 {
+	if (!mmc_can_trim(card) && !mmc_can_erase(card))
+		return 0;
 	if (card->ext_csd.sec_feature_support & EXT_CSD_SEC_SANITIZE)
 		return 1;
 	return 0;
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-es=
dhc-imx.c
index 4540e37..1b47937 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -467,8 +467,7 @@ static int __devinit sdhci_esdhc_imx_probe(struct platf=
orm_device *pdev)
 	clk_enable(clk);
 	pltfm_host->clk =3D clk;
=20
-	if (!is_imx25_esdhc(imx_data))
-		host->quirks |=3D SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
+	host->quirks |=3D SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
=20
 	if (is_imx25_esdhc(imx_data) || is_imx35_esdhc(imx_data))
 		/* Fix errata ENGcm07207 present on i.MX25 and i.MX35 */
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_mai=
n.c
index e58aa2b..f65e0b9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2982,7 +2982,11 @@ static void bond_ab_arp_commit(struct bonding *bond,=
 int delta_in_ticks)
 					   trans_start + delta_in_ticks)) ||
 			    bond->curr_active_slave !=3D slave) {
 				slave->link =3D BOND_LINK_UP;
-				bond->current_arp_slave =3D NULL;
+				if (bond->current_arp_slave) {
+					bond_set_slave_inactive_flags(
+						bond->current_arp_slave);
+					bond->current_arp_slave =3D NULL;
+				}
=20
 				pr_info("%s: link status definitely up for interface %s.\n",
 					bond->dev->name, slave->dev->name);
diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index a7c5e88..eeac9ca 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -106,14 +106,14 @@ static int dummy_dev_init(struct net_device *dev)
 	return 0;
 }
=20
-static void dummy_dev_free(struct net_device *dev)
+static void dummy_dev_uninit(struct net_device *dev)
 {
 	free_percpu(dev->dstats);
-	free_netdev(dev);
 }
=20
 static const struct net_device_ops dummy_netdev_ops =3D {
 	.ndo_init		=3D dummy_dev_init,
+	.ndo_uninit		=3D dummy_dev_uninit,
 	.ndo_start_xmit		=3D dummy_xmit,
 	.ndo_validate_addr	=3D eth_validate_addr,
 	.ndo_set_rx_mode	=3D set_multicast_list,
@@ -127,7 +127,7 @@ static void dummy_setup(struct net_device *dev)
=20
 	/* Initialize the device structure. */
 	dev->netdev_ops =3D &dummy_netdev_ops;
-	dev->destructor =3D dummy_dev_free;
+	dev->destructor =3D free_netdev;
=20
 	/* Fill in device structure with ethernet-generic values. */
 	dev->tx_queue_len =3D 0;
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/etherne=
t/atheros/atlx/atl1.c
index 33a4e35..ee532e1 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -2473,7 +2473,7 @@ static irqreturn_t atl1_intr(int irq, void *data)
 					"pcie phy link down %x\n", status);
 			if (netif_running(adapter->netdev)) {	/* reset MAC */
 				iowrite32(0, adapter->hw.hw_addr + REG_IMR);
-				schedule_work(&adapter->pcie_dma_to_rst_task);
+				schedule_work(&adapter->reset_dev_task);
 				return IRQ_HANDLED;
 			}
 		}
@@ -2485,7 +2485,7 @@ static irqreturn_t atl1_intr(int irq, void *data)
 					"pcie DMA r/w error (status =3D 0x%x)\n",
 					status);
 			iowrite32(0, adapter->hw.hw_addr + REG_IMR);
-			schedule_work(&adapter->pcie_dma_to_rst_task);
+			schedule_work(&adapter->reset_dev_task);
 			return IRQ_HANDLED;
 		}
=20
@@ -2630,10 +2630,10 @@ static void atl1_down(struct atl1_adapter *adapter)
 	atl1_clean_rx_ring(adapter);
 }
=20
-static void atl1_tx_timeout_task(struct work_struct *work)
+static void atl1_reset_dev_task(struct work_struct *work)
 {
 	struct atl1_adapter *adapter =3D
-		container_of(work, struct atl1_adapter, tx_timeout_task);
+		container_of(work, struct atl1_adapter, reset_dev_task);
 	struct net_device *netdev =3D adapter->netdev;
=20
 	netif_device_detach(netdev);
@@ -3032,12 +3032,10 @@ static int __devinit atl1_probe(struct pci_dev *pde=
v,
 		    (unsigned long)adapter);
 	adapter->phy_timer_pending =3D false;
=20
-	INIT_WORK(&adapter->tx_timeout_task, atl1_tx_timeout_task);
+	INIT_WORK(&adapter->reset_dev_task, atl1_reset_dev_task);
=20
 	INIT_WORK(&adapter->link_chg_task, atlx_link_chg_task);
=20
-	INIT_WORK(&adapter->pcie_dma_to_rst_task, atl1_tx_timeout_task);
-
 	err =3D register_netdev(netdev);
 	if (err)
 		goto err_common;
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.h b/drivers/net/etherne=
t/atheros/atlx/atl1.h
index 109d6da..e04bf4d 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.h
+++ b/drivers/net/ethernet/atheros/atlx/atl1.h
@@ -758,9 +758,8 @@ struct atl1_adapter {
 	u16 link_speed;
 	u16 link_duplex;
 	spinlock_t lock;
-	struct work_struct tx_timeout_task;
+	struct work_struct reset_dev_task;
 	struct work_struct link_chg_task;
-	struct work_struct pcie_dma_to_rst_task;
=20
 	struct timer_list phy_config_timer;
 	bool phy_timer_pending;
diff --git a/drivers/net/ethernet/atheros/atlx/atlx.c b/drivers/net/etherne=
t/atheros/atlx/atlx.c
index aabcf4b..41c6d83 100644
--- a/drivers/net/ethernet/atheros/atlx/atlx.c
+++ b/drivers/net/ethernet/atheros/atlx/atlx.c
@@ -193,7 +193,7 @@ static void atlx_tx_timeout(struct net_device *netdev)
 {
 	struct atlx_adapter *adapter =3D netdev_priv(netdev);
 	/* Do the reset outside of interrupt context */
-	schedule_work(&adapter->tx_timeout_task);
+	schedule_work(&adapter->reset_dev_task);
 }
=20
 /*
diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/etherne=
t/micrel/ks8851_mll.c
index d19c849..77241b6 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -40,7 +40,7 @@
 #define	DRV_NAME	"ks8851_mll"
=20
 static u8 KS_DEFAULT_MAC_ADDRESS[] =3D { 0x00, 0x10, 0xA1, 0x86, 0x95, 0x1=
1 };
-#define MAX_RECV_FRAMES			32
+#define MAX_RECV_FRAMES			255
 #define MAX_BUF_SIZE			2048
 #define TX_BUF_SIZE			2000
 #define RX_BUF_SIZE			2000
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/m=
icrel/ksz884x.c
index 7ece990..4b9f4bd 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -5679,7 +5679,7 @@ static int netdev_set_mac_address(struct net_device *=
dev, void *addr)
 		memcpy(hw->override_addr, mac->sa_data, MAC_ADDR_LEN);
 	}
=20
-	memcpy(dev->dev_addr, mac->sa_data, MAX_ADDR_LEN);
+	memcpy(dev->dev_addr, mac->sa_data, ETH_ALEN);
=20
 	interrupt =3D hw_block_intr(hw);
=20
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/r=
ealtek/8139cp.c
index aba4f67..8f47907 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -961,6 +961,11 @@ static inline void cp_start_hw (struct cp_private *cp)
 	cpw8(Cmd, RxOn | TxOn);
 }
=20
+static void cp_enable_irq(struct cp_private *cp)
+{
+	cpw16_f(IntrMask, cp_intr_mask);
+}
+
 static void cp_init_hw (struct cp_private *cp)
 {
 	struct net_device *dev =3D cp->dev;
@@ -1000,8 +1005,6 @@ static void cp_init_hw (struct cp_private *cp)
=20
 	cpw16(MultiIntr, 0);
=20
-	cpw16_f(IntrMask, cp_intr_mask);
-
 	cpw8_f(Cfg9346, Cfg9346_Lock);
 }
=20
@@ -1133,6 +1136,8 @@ static int cp_open (struct net_device *dev)
 	if (rc)
 		goto err_out_hw;
=20
+	cp_enable_irq(cp);
+
 	netif_carrier_off(dev);
 	mii_check_media(&cp->mii_if, netif_msg_link(cp), true);
 	netif_start_queue(dev);
@@ -2034,6 +2039,7 @@ static int cp_resume (struct pci_dev *pdev)
 	/* FIXME: sh*t may happen if the Rx ring buffer is depleted */
 	cp_init_rings_index (cp);
 	cp_init_hw (cp);
+	cp_enable_irq(cp);
 	netif_start_queue (dev);
=20
 	spin_lock_irqsave (&cp->lock, flags);
diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/sm=
sc/smsc911x.c
index 8843071..8c7dd21 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1089,10 +1089,8 @@ smsc911x_rx_counterrors(struct net_device *dev, unsi=
gned int rxstat)
=20
 /* Quickly dumps bad packets */
 static void
-smsc911x_rx_fastforward(struct smsc911x_data *pdata, unsigned int pktbytes=
)
+smsc911x_rx_fastforward(struct smsc911x_data *pdata, unsigned int pktwords=
)
 {
-	unsigned int pktwords =3D (pktbytes + NET_IP_ALIGN + 3) >> 2;
-
 	if (likely(pktwords >=3D 4)) {
 		unsigned int timeout =3D 500;
 		unsigned int val;
@@ -1156,7 +1154,7 @@ static int smsc911x_poll(struct napi_struct *napi, in=
t budget)
 			continue;
 		}
=20
-		skb =3D netdev_alloc_skb(dev, pktlength + NET_IP_ALIGN);
+		skb =3D netdev_alloc_skb(dev, pktwords << 2);
 		if (unlikely(!skb)) {
 			SMSC_WARN(pdata, rx_err,
 				  "Unable to allocate skb for rx packet");
@@ -1166,14 +1164,12 @@ static int smsc911x_poll(struct napi_struct *napi, =
int budget)
 			break;
 		}
=20
-		skb->data =3D skb->head;
-		skb_reset_tail_pointer(skb);
+		pdata->ops->rx_readfifo(pdata,
+				 (unsigned int *)skb->data, pktwords);
=20
 		/* Align IP on 16B boundary */
 		skb_reserve(skb, NET_IP_ALIGN);
 		skb_put(skb, pktlength - 4);
-		pdata->ops->rx_readfifo(pdata,
-				 (unsigned int *)skb->head, pktwords);
 		skb->protocol =3D eth_type_trans(skb, dev);
 		skb_checksum_none_assert(skb);
 		netif_receive_skb(skb);
@@ -1396,7 +1392,7 @@ static int smsc911x_open(struct net_device *dev)
 	smsc911x_reg_write(pdata, FIFO_INT, temp);
=20
 	/* set RX Data offset to 2 bytes for alignment */
-	smsc911x_reg_write(pdata, RX_CFG, (2 << 8));
+	smsc911x_reg_write(pdata, RX_CFG, (NET_IP_ALIGN << 8));
=20
 	/* enable NAPI polling before enabling RX interrupts */
 	napi_enable(&pdata->napi);
diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/=
ti/davinci_mdio.c
index 7615040..f470ab6 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -181,6 +181,11 @@ static inline int wait_for_user_access(struct davinci_=
mdio_data *data)
 		__davinci_mdio_reset(data);
 		return -EAGAIN;
 	}
+
+	reg =3D __raw_readl(&regs->user[0].access);
+	if ((reg & USERACCESS_GO) =3D=3D 0)
+		return 0;
+
 	dev_err(data->dev, "timed out waiting for user access\n");
 	return -ETIMEDOUT;
 }
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 486b404..3ed983c 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -968,7 +968,6 @@ ppp_start_xmit(struct sk_buff *skb, struct net_device *=
dev)
 	proto =3D npindex_to_proto[npi];
 	put_unaligned_be16(proto, pp);
=20
-	netif_stop_queue(dev);
 	skb_queue_tail(&ppp->file.xq, skb);
 	ppp_xmit_process(ppp);
 	return NETDEV_TX_OK;
@@ -1063,6 +1062,8 @@ ppp_xmit_process(struct ppp *ppp)
 		   code that we can accept some more. */
 		if (!ppp->xmit_pending && !skb_peek(&ppp->file.xq))
 			netif_wake_queue(ppp->dev);
+		else
+			netif_stop_queue(ppp->dev);
 	}
 	ppp_xmit_unlock(ppp);
 }
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index a5b9b12..7bd219b 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1050,6 +1050,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct u=
sb_interface *intf)
 	dev->net->ethtool_ops =3D &smsc75xx_ethtool_ops;
 	dev->net->flags |=3D IFF_MULTICAST;
 	dev->net->hard_header_len +=3D SMSC75XX_TX_OVERHEAD;
+	dev->hard_mtu =3D dev->net->mtu + dev->net->hard_header_len;
 	return 0;
 }
=20
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index eff6767..55b3218 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1190,7 +1190,7 @@ static const struct driver_info smsc95xx_info =3D {
 	.rx_fixup	=3D smsc95xx_rx_fixup,
 	.tx_fixup	=3D smsc95xx_tx_fixup,
 	.status		=3D smsc95xx_status,
-	.flags		=3D FLAG_ETHER | FLAG_SEND_ZLP,
+	.flags		=3D FLAG_ETHER | FLAG_SEND_ZLP | FLAG_LINK_INTR,
 };
=20
 static const struct usb_device_id products[] =3D {
diff --git a/drivers/net/wimax/i2400m/netdev.c b/drivers/net/wimax/i2400m/n=
etdev.c
index 64a1106..4697cf3 100644
--- a/drivers/net/wimax/i2400m/netdev.c
+++ b/drivers/net/wimax/i2400m/netdev.c
@@ -607,7 +607,8 @@ static void i2400m_get_drvinfo(struct net_device *net_d=
ev,
 	struct i2400m *i2400m =3D net_dev_to_i2400m(net_dev);
=20
 	strncpy(info->driver, KBUILD_MODNAME, sizeof(info->driver) - 1);
-	strncpy(info->fw_version, i2400m->fw_name, sizeof(info->fw_version) - 1);
+	strncpy(info->fw_version,
+	        i2400m->fw_name ? : "", sizeof(info->fw_version) - 1);
 	if (net_dev->dev.parent)
 		strncpy(info->bus_info, dev_name(net_dev->dev.parent),
 			sizeof(info->bus_info) - 1);
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/mai=
n.c
index 5634d9a..680709c 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4820,8 +4820,14 @@ static int b43_op_start(struct ieee80211_hw *hw)
  out_mutex_unlock:
 	mutex_unlock(&wl->mutex);
=20
-	/* reload configuration */
-	b43_op_config(hw, ~0);
+	/*
+	 * Configuration may have been overwritten during initialization.
+	 * Reload the configuration, but only if initialization was
+	 * successful. Reloading the configuration after a failed init
+	 * may hang the system.
+	 */
+	if (!err)
+		b43_op_config(hw, ~0);
=20
 	return err;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/w=
ireless/brcm80211/brcmsmac/main.c
index 453f58e..f98becc 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7865,6 +7865,7 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11r=
xhdr *rxh,
 {
 	int len_mpdu;
 	struct ieee80211_rx_status rx_status;
+	struct ieee80211_hdr *hdr;
=20
 	memset(&rx_status, 0, sizeof(rx_status));
 	prep_mac80211_status(wlc, rxh, p, &rx_status);
@@ -7874,6 +7875,13 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11=
rxhdr *rxh,
 	skb_pull(p, D11_PHY_HDR_LEN);
 	__skb_trim(p, len_mpdu);
=20
+	/* unmute transmit */
+	if (wlc->hw->suspended_fifos) {
+		hdr =3D (struct ieee80211_hdr *)p->data;
+		if (ieee80211_is_beacon(hdr->frame_control))
+			brcms_b_mute(wlc->hw, false);
+	}
+
 	memcpy(IEEE80211_SKB_RXCB(p), &rx_status, sizeof(rx_status));
 	ieee80211_rx_irqsafe(wlc->pub->ieee_hw, p);
 }
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/=
ipw2x00/ipw2200.c
index 99a710d..827889b 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -2183,6 +2183,7 @@ static int __ipw_send_cmd(struct ipw_priv *priv, stru=
ct host_cmd *cmd)
 {
 	int rc =3D 0;
 	unsigned long flags;
+	unsigned long now, end;
=20
 	spin_lock_irqsave(&priv->lock, flags);
 	if (priv->status & STATUS_HCMD_ACTIVE) {
@@ -2224,10 +2225,20 @@ static int __ipw_send_cmd(struct ipw_priv *priv, st=
ruct host_cmd *cmd)
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
=20
+	now =3D jiffies;
+	end =3D now + HOST_COMPLETE_TIMEOUT;
+again:
 	rc =3D wait_event_interruptible_timeout(priv->wait_command_queue,
 					      !(priv->
 						status & STATUS_HCMD_ACTIVE),
-					      HOST_COMPLETE_TIMEOUT);
+					      end - now);
+	if (rc < 0) {
+		now =3D jiffies;
+		if (time_before(now, end))
+			goto again;
+		rc =3D 0;
+	}
+
 	if (rc =3D=3D 0) {
 		spin_lock_irqsave(&priv->lock, flags);
 		if (priv->status & STATUS_HCMD_ACTIVE) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless=
/iwlwifi/iwl-1000.c
index dd008b0..1e6c8cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -45,8 +45,8 @@
 #include "iwl-cfg.h"
=20
 /* Highest firmware API version supported */
-#define IWL1000_UCODE_API_MAX 6
-#define IWL100_UCODE_API_MAX 6
+#define IWL1000_UCODE_API_MAX 5
+#define IWL100_UCODE_API_MAX 5
=20
 /* Oldest version we won't warn about */
 #define IWL1000_UCODE_API_OK 5
@@ -244,5 +244,5 @@ struct iwl_cfg iwl100_bg_cfg =3D {
 	IWL_DEVICE_100,
 };
=20
-MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL100_MODULE_FIRMWARE(IWL100_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_OK));
+MODULE_FIRMWARE(IWL100_MODULE_FIRMWARE(IWL100_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless=
/iwlwifi/iwl-2000.c
index 7943197..9823e41 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -51,10 +51,10 @@
 #define IWL135_UCODE_API_MAX 6
=20
 /* Oldest version we won't warn about */
-#define IWL2030_UCODE_API_OK 5
-#define IWL2000_UCODE_API_OK 5
-#define IWL105_UCODE_API_OK 5
-#define IWL135_UCODE_API_OK 5
+#define IWL2030_UCODE_API_OK 6
+#define IWL2000_UCODE_API_OK 6
+#define IWL105_UCODE_API_OK 6
+#define IWL135_UCODE_API_OK 6
=20
 /* Lowest firmware API version supported */
 #define IWL2030_UCODE_API_MIN 5
@@ -372,7 +372,7 @@ struct iwl_cfg iwl135_bgn_cfg =3D {
 	.ht_params =3D &iwl2000_ht_params,
 };
=20
-MODULE_FIRMWARE(IWL2000_MODULE_FIRMWARE(IWL2000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL2030_MODULE_FIRMWARE(IWL2030_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL105_MODULE_FIRMWARE(IWL105_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL135_MODULE_FIRMWARE(IWL135_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL2000_MODULE_FIRMWARE(IWL2000_UCODE_API_OK));
+MODULE_FIRMWARE(IWL2030_MODULE_FIRMWARE(IWL2030_UCODE_API_OK));
+MODULE_FIRMWARE(IWL105_MODULE_FIRMWARE(IWL105_UCODE_API_OK));
+MODULE_FIRMWARE(IWL135_MODULE_FIRMWARE(IWL135_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless=
/iwlwifi/iwl-5000.c
index f55fb2d..606213f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -50,6 +50,10 @@
 #define IWL5000_UCODE_API_MAX 5
 #define IWL5150_UCODE_API_MAX 2
=20
+/* Oldest version we won't warn about */
+#define IWL5000_UCODE_API_OK 5
+#define IWL5150_UCODE_API_OK 2
+
 /* Lowest firmware API version supported */
 #define IWL5000_UCODE_API_MIN 1
 #define IWL5150_UCODE_API_MIN 1
@@ -373,6 +377,7 @@ static struct iwl_ht_params iwl5000_ht_params =3D {
 #define IWL_DEVICE_5000						\
 	.fw_name_pre =3D IWL5000_FW_PRE,				\
 	.ucode_api_max =3D IWL5000_UCODE_API_MAX,			\
+	.ucode_api_ok =3D IWL5000_UCODE_API_OK,			\
 	.ucode_api_min =3D IWL5000_UCODE_API_MIN,			\
 	.eeprom_ver =3D EEPROM_5000_EEPROM_VERSION,		\
 	.eeprom_calib_ver =3D EEPROM_5000_TX_POWER_VERSION,	\
@@ -416,6 +421,7 @@ struct iwl_cfg iwl5350_agn_cfg =3D {
 	.name =3D "Intel(R) WiMAX/WiFi Link 5350 AGN",
 	.fw_name_pre =3D IWL5000_FW_PRE,
 	.ucode_api_max =3D IWL5000_UCODE_API_MAX,
+	.ucode_api_ok =3D IWL5000_UCODE_API_OK,
 	.ucode_api_min =3D IWL5000_UCODE_API_MIN,
 	.eeprom_ver =3D EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver =3D EEPROM_5050_TX_POWER_VERSION,
@@ -429,6 +435,7 @@ struct iwl_cfg iwl5350_agn_cfg =3D {
 #define IWL_DEVICE_5150						\
 	.fw_name_pre =3D IWL5150_FW_PRE,				\
 	.ucode_api_max =3D IWL5150_UCODE_API_MAX,			\
+	.ucode_api_ok =3D IWL5150_UCODE_API_OK,			\
 	.ucode_api_min =3D IWL5150_UCODE_API_MIN,			\
 	.eeprom_ver =3D EEPROM_5050_EEPROM_VERSION,		\
 	.eeprom_calib_ver =3D EEPROM_5050_TX_POWER_VERSION,	\
@@ -450,5 +457,5 @@ struct iwl_cfg iwl5150_abg_cfg =3D {
 	IWL_DEVICE_5150,
 };
=20
-MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_OK));
+MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless=
/iwlwifi/iwl-6000.c
index c840c78..b4f809c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -46,12 +46,15 @@
 #include "iwl-cfg.h"
=20
 /* Highest firmware API version supported */
-#define IWL6000_UCODE_API_MAX 4
+#define IWL6000_UCODE_API_MAX 6
 #define IWL6050_UCODE_API_MAX 5
 #define IWL6000G2_UCODE_API_MAX 6
=20
 /* Oldest version we won't warn about */
+#define IWL6000_UCODE_API_OK 4
 #define IWL6000G2_UCODE_API_OK 5
+#define IWL6050_UCODE_API_OK 5
+#define IWL6000G2B_UCODE_API_OK 6
=20
 /* Lowest firmware API version supported */
 #define IWL6000_UCODE_API_MIN 4
@@ -399,7 +402,7 @@ struct iwl_cfg iwl6005_2agn_d_cfg =3D {
 #define IWL_DEVICE_6030						\
 	.fw_name_pre =3D IWL6030_FW_PRE,				\
 	.ucode_api_max =3D IWL6000G2_UCODE_API_MAX,		\
-	.ucode_api_ok =3D IWL6000G2_UCODE_API_OK,			\
+	.ucode_api_ok =3D IWL6000G2B_UCODE_API_OK,		\
 	.ucode_api_min =3D IWL6000G2_UCODE_API_MIN,		\
 	.eeprom_ver =3D EEPROM_6030_EEPROM_VERSION,		\
 	.eeprom_calib_ver =3D EEPROM_6030_TX_POWER_VERSION,	\
@@ -479,6 +482,7 @@ struct iwl_cfg iwl130_bg_cfg =3D {
 #define IWL_DEVICE_6000i					\
 	.fw_name_pre =3D IWL6000_FW_PRE,				\
 	.ucode_api_max =3D IWL6000_UCODE_API_MAX,			\
+	.ucode_api_ok =3D IWL6000_UCODE_API_OK,			\
 	.ucode_api_min =3D IWL6000_UCODE_API_MIN,			\
 	.valid_tx_ant =3D ANT_BC,		/* .cfg overwrite */	\
 	.valid_rx_ant =3D ANT_BC,		/* .cfg overwrite */	\
@@ -559,6 +563,7 @@ struct iwl_cfg iwl6000_3agn_cfg =3D {
 	.name =3D "Intel(R) Centrino(R) Ultimate-N 6300 AGN",
 	.fw_name_pre =3D IWL6000_FW_PRE,
 	.ucode_api_max =3D IWL6000_UCODE_API_MAX,
+	.ucode_api_ok =3D IWL6000_UCODE_API_OK,
 	.ucode_api_min =3D IWL6000_UCODE_API_MIN,
 	.eeprom_ver =3D EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver =3D EEPROM_6000_TX_POWER_VERSION,
@@ -569,7 +574,7 @@ struct iwl_cfg iwl6000_3agn_cfg =3D {
 	.led_mode =3D IWL_LED_BLINK,
 };
=20
-MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_OK));
+MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_OK));
+MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_OK));
+MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2B_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/=
iwlwifi/iwl-agn.c
index e0e9a3d..d7d2512 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1504,7 +1504,6 @@ static void iwl_bg_run_time_calib_work(struct work_st=
ruct *work)
=20
 static void iwlagn_prepare_restart(struct iwl_priv *priv)
 {
-	struct iwl_rxon_context *ctx;
 	bool bt_full_concurrent;
 	u8 bt_ci_compliance;
 	u8 bt_load;
@@ -1513,8 +1512,6 @@ static void iwlagn_prepare_restart(struct iwl_priv *p=
riv)
=20
 	lockdep_assert_held(&priv->shrd->mutex);
=20
-	for_each_context(priv, ctx)
-		ctx->vif =3D NULL;
 	priv->is_open =3D 0;
=20
 	/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless=
/iwlwifi/iwl-core.c
index 3d75d4c..832ec4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1228,6 +1228,7 @@ int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 	struct iwl_rxon_context *tmp, *ctx =3D NULL;
 	int err;
 	enum nl80211_iftype viftype =3D ieee80211_vif_type_p2p(vif);
+	bool reset =3D false;
=20
 	IWL_DEBUG_MAC80211(priv, "enter: type %d, addr %pM\n",
 			   viftype, vif->addr);
@@ -1249,6 +1250,13 @@ int iwlagn_mac_add_interface(struct ieee80211_hw *hw=
,
 			tmp->interface_modes | tmp->exclusive_interface_modes;
=20
 		if (tmp->vif) {
+			/* On reset we need to add the same interface again */
+			if (tmp->vif =3D=3D vif) {
+				reset =3D true;
+				ctx =3D tmp;
+				break;
+			}
+
 			/* check if this busy context is exclusive */
 			if (tmp->exclusive_interface_modes &
 						BIT(tmp->vif->type)) {
@@ -1275,7 +1283,7 @@ int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 	ctx->vif =3D vif;
=20
 	err =3D iwl_setup_interface(priv, ctx);
-	if (!err)
+	if (!err || reset)
 		goto out;
=20
 	ctx->vif =3D NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/i=
wlwifi/iwl-fh.h
index 5bede9d..aae992a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -104,15 +104,29 @@
  * (see struct iwl_tfd_frame).  These 16 pointer registers are offset by 0=
x04
  * bytes from one another.  Each TFD circular buffer in DRAM must be 256-b=
yte
  * aligned (address bits 0-7 must be 0).
+ * Later devices have 20 (5000 series) or 30 (higher) queues, but the regi=
sters
+ * for them are in different places.
  *
  * Bit fields in each pointer register:
  *  27-0: TFD CB physical base address [35:8], must be 256-byte aligned
  */
-#define FH_MEM_CBBC_LOWER_BOUND          (FH_MEM_LOWER_BOUND + 0x9D0)
-#define FH_MEM_CBBC_UPPER_BOUND          (FH_MEM_LOWER_BOUND + 0xA10)
-
-/* Find TFD CB base pointer for given queue (range 0-15). */
-#define FH_MEM_CBBC_QUEUE(x)  (FH_MEM_CBBC_LOWER_BOUND + (x) * 0x4)
+#define FH_MEM_CBBC_0_15_LOWER_BOUND		(FH_MEM_LOWER_BOUND + 0x9D0)
+#define FH_MEM_CBBC_0_15_UPPER_BOUND		(FH_MEM_LOWER_BOUND + 0xA10)
+#define FH_MEM_CBBC_16_19_LOWER_BOUND		(FH_MEM_LOWER_BOUND + 0xBF0)
+#define FH_MEM_CBBC_16_19_UPPER_BOUND		(FH_MEM_LOWER_BOUND + 0xC00)
+#define FH_MEM_CBBC_20_31_LOWER_BOUND		(FH_MEM_LOWER_BOUND + 0xB20)
+#define FH_MEM_CBBC_20_31_UPPER_BOUND		(FH_MEM_LOWER_BOUND + 0xB80)
+
+/* Find TFD CB base pointer for given queue */
+static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
+{
+	if (chnl < 16)
+		return FH_MEM_CBBC_0_15_LOWER_BOUND + 4 * chnl;
+	if (chnl < 20)
+		return FH_MEM_CBBC_16_19_LOWER_BOUND + 4 * (chnl - 16);
+	WARN_ON_ONCE(chnl >=3D 32);
+	return FH_MEM_CBBC_20_31_LOWER_BOUND + 4 * (chnl - 20);
+}
=20
=20
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless=
/iwlwifi/iwl-prph.h
index bebdd82..d9b089e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -227,12 +227,33 @@
 #define SCD_AIT			(SCD_BASE + 0x0c)
 #define SCD_TXFACT		(SCD_BASE + 0x10)
 #define SCD_ACTIVE		(SCD_BASE + 0x14)
-#define SCD_QUEUE_WRPTR(x)	(SCD_BASE + 0x18 + (x) * 4)
-#define SCD_QUEUE_RDPTR(x)	(SCD_BASE + 0x68 + (x) * 4)
 #define SCD_QUEUECHAIN_SEL	(SCD_BASE + 0xe8)
 #define SCD_AGGR_SEL		(SCD_BASE + 0x248)
 #define SCD_INTERRUPT_MASK	(SCD_BASE + 0x108)
-#define SCD_QUEUE_STATUS_BITS(x)	(SCD_BASE + 0x10c + (x) * 4)
+
+static inline unsigned int SCD_QUEUE_WRPTR(unsigned int chnl)
+{
+	if (chnl < 20)
+		return SCD_BASE + 0x18 + chnl * 4;
+	WARN_ON_ONCE(chnl >=3D 32);
+	return SCD_BASE + 0x284 + (chnl - 20) * 4;
+}
+
+static inline unsigned int SCD_QUEUE_RDPTR(unsigned int chnl)
+{
+	if (chnl < 20)
+		return SCD_BASE + 0x68 + chnl * 4;
+	WARN_ON_ONCE(chnl >=3D 32);
+	return SCD_BASE + 0x2B4 + (chnl - 20) * 4;
+}
+
+static inline unsigned int SCD_QUEUE_STATUS_BITS(unsigned int chnl)
+{
+	if (chnl < 20)
+		return SCD_BASE + 0x10c + chnl * 4;
+	WARN_ON_ONCE(chnl >=3D 32);
+	return SCD_BASE + 0x384 + (chnl - 20) * 4;
+}
=20
 /*********************** END TX SCHEDULER ********************************=
*****/
=20
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwi=
fiex/pcie.h
index 445ff21..2f218f9 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -48,15 +48,15 @@
 #define PCIE_HOST_INT_STATUS_MASK			0xC3C
 #define PCIE_SCRATCH_2_REG				0xC40
 #define PCIE_SCRATCH_3_REG				0xC44
-#define PCIE_SCRATCH_4_REG				0xCC0
-#define PCIE_SCRATCH_5_REG				0xCC4
-#define PCIE_SCRATCH_6_REG				0xCC8
-#define PCIE_SCRATCH_7_REG				0xCCC
-#define PCIE_SCRATCH_8_REG				0xCD0
-#define PCIE_SCRATCH_9_REG				0xCD4
-#define PCIE_SCRATCH_10_REG				0xCD8
-#define PCIE_SCRATCH_11_REG				0xCDC
-#define PCIE_SCRATCH_12_REG				0xCE0
+#define PCIE_SCRATCH_4_REG				0xCD0
+#define PCIE_SCRATCH_5_REG				0xCD4
+#define PCIE_SCRATCH_6_REG				0xCD8
+#define PCIE_SCRATCH_7_REG				0xCDC
+#define PCIE_SCRATCH_8_REG				0xCE0
+#define PCIE_SCRATCH_9_REG				0xCE4
+#define PCIE_SCRATCH_10_REG				0xCE8
+#define PCIE_SCRATCH_11_REG				0xCEC
+#define PCIE_SCRATCH_12_REG				0xCF0
=20
 #define CPU_INTR_DNLD_RDY				BIT(0)
 #define CPU_INTR_DOOR_BELL				BIT(1)
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless=
/rt2x00/rt2800usb.c
index cb71e88..0ffa111 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -914,12 +914,14 @@ static struct usb_device_id rt2800usb_device_table[] =
=3D {
 	{ USB_DEVICE(0x050d, 0x8053) },
 	{ USB_DEVICE(0x050d, 0x805c) },
 	{ USB_DEVICE(0x050d, 0x815c) },
+	{ USB_DEVICE(0x050d, 0x825a) },
 	{ USB_DEVICE(0x050d, 0x825b) },
 	{ USB_DEVICE(0x050d, 0x935a) },
 	{ USB_DEVICE(0x050d, 0x935b) },
 	/* Buffalo */
 	{ USB_DEVICE(0x0411, 0x00e8) },
 	{ USB_DEVICE(0x0411, 0x0158) },
+	{ USB_DEVICE(0x0411, 0x015d) },
 	{ USB_DEVICE(0x0411, 0x016f) },
 	{ USB_DEVICE(0x0411, 0x01a2) },
 	/* Corega */
@@ -934,6 +936,8 @@ static struct usb_device_id rt2800usb_device_table[] =
=3D {
 	{ USB_DEVICE(0x07d1, 0x3c0e) },
 	{ USB_DEVICE(0x07d1, 0x3c0f) },
 	{ USB_DEVICE(0x07d1, 0x3c11) },
+	{ USB_DEVICE(0x07d1, 0x3c13) },
+	{ USB_DEVICE(0x07d1, 0x3c15) },
 	{ USB_DEVICE(0x07d1, 0x3c16) },
 	{ USB_DEVICE(0x2001, 0x3c1b) },
 	/* Draytek */
@@ -944,6 +948,7 @@ static struct usb_device_id rt2800usb_device_table[] =
=3D {
 	{ USB_DEVICE(0x7392, 0x7711) },
 	{ USB_DEVICE(0x7392, 0x7717) },
 	{ USB_DEVICE(0x7392, 0x7718) },
+	{ USB_DEVICE(0x7392, 0x7722) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x1480) },
 	{ USB_DEVICE(0x203d, 0x14a9) },
@@ -978,6 +983,7 @@ static struct usb_device_id rt2800usb_device_table[] =
=3D {
 	{ USB_DEVICE(0x1737, 0x0070) },
 	{ USB_DEVICE(0x1737, 0x0071) },
 	{ USB_DEVICE(0x1737, 0x0077) },
+	{ USB_DEVICE(0x1737, 0x0078) },
 	/* Logitec */
 	{ USB_DEVICE(0x0789, 0x0162) },
 	{ USB_DEVICE(0x0789, 0x0163) },
@@ -1001,9 +1007,13 @@ static struct usb_device_id rt2800usb_device_table[]=
 =3D {
 	{ USB_DEVICE(0x0db0, 0x871b) },
 	{ USB_DEVICE(0x0db0, 0x871c) },
 	{ USB_DEVICE(0x0db0, 0x899a) },
+	/* Ovislink */
+	{ USB_DEVICE(0x1b75, 0x3071) },
+	{ USB_DEVICE(0x1b75, 0x3072) },
 	/* Para */
 	{ USB_DEVICE(0x20b8, 0x8888) },
 	/* Pegatron */
+	{ USB_DEVICE(0x1d4d, 0x0002) },
 	{ USB_DEVICE(0x1d4d, 0x000c) },
 	{ USB_DEVICE(0x1d4d, 0x000e) },
 	{ USB_DEVICE(0x1d4d, 0x0011) },
@@ -1056,7 +1066,9 @@ static struct usb_device_id rt2800usb_device_table[] =
=3D {
 	/* Sparklan */
 	{ USB_DEVICE(0x15a9, 0x0006) },
 	/* Sweex */
+	{ USB_DEVICE(0x177f, 0x0153) },
 	{ USB_DEVICE(0x177f, 0x0302) },
+	{ USB_DEVICE(0x177f, 0x0313) },
 	/* U-Media */
 	{ USB_DEVICE(0x157e, 0x300e) },
 	{ USB_DEVICE(0x157e, 0x3013) },
@@ -1140,27 +1152,24 @@ static struct usb_device_id rt2800usb_device_table[=
] =3D {
 	{ USB_DEVICE(0x13d3, 0x3322) },
 	/* Belkin */
 	{ USB_DEVICE(0x050d, 0x1003) },
-	{ USB_DEVICE(0x050d, 0x825a) },
 	/* Buffalo */
 	{ USB_DEVICE(0x0411, 0x012e) },
 	{ USB_DEVICE(0x0411, 0x0148) },
 	{ USB_DEVICE(0x0411, 0x0150) },
-	{ USB_DEVICE(0x0411, 0x015d) },
 	/* Corega */
 	{ USB_DEVICE(0x07aa, 0x0041) },
 	{ USB_DEVICE(0x07aa, 0x0042) },
 	{ USB_DEVICE(0x18c5, 0x0008) },
 	/* D-Link */
 	{ USB_DEVICE(0x07d1, 0x3c0b) },
-	{ USB_DEVICE(0x07d1, 0x3c13) },
-	{ USB_DEVICE(0x07d1, 0x3c15) },
 	{ USB_DEVICE(0x07d1, 0x3c17) },
 	{ USB_DEVICE(0x2001, 0x3c17) },
 	/* Edimax */
 	{ USB_DEVICE(0x7392, 0x4085) },
-	{ USB_DEVICE(0x7392, 0x7722) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x14a1) },
+	/* Fujitsu Stylistic 550 */
+	{ USB_DEVICE(0x1690, 0x0761) },
 	/* Gemtek */
 	{ USB_DEVICE(0x15a9, 0x0010) },
 	/* Gigabyte */
@@ -1172,19 +1181,13 @@ static struct usb_device_id rt2800usb_device_table[=
] =3D {
 	/* LevelOne */
 	{ USB_DEVICE(0x1740, 0x0605) },
 	{ USB_DEVICE(0x1740, 0x0615) },
-	/* Linksys */
-	{ USB_DEVICE(0x1737, 0x0078) },
 	/* Logitec */
 	{ USB_DEVICE(0x0789, 0x0168) },
 	{ USB_DEVICE(0x0789, 0x0169) },
 	/* Motorola */
 	{ USB_DEVICE(0x100d, 0x9032) },
-	/* Ovislink */
-	{ USB_DEVICE(0x1b75, 0x3071) },
-	{ USB_DEVICE(0x1b75, 0x3072) },
 	/* Pegatron */
 	{ USB_DEVICE(0x05a6, 0x0101) },
-	{ USB_DEVICE(0x1d4d, 0x0002) },
 	{ USB_DEVICE(0x1d4d, 0x0010) },
 	/* Planex */
 	{ USB_DEVICE(0x2019, 0x5201) },
@@ -1203,9 +1206,6 @@ static struct usb_device_id rt2800usb_device_table[] =
=3D {
 	{ USB_DEVICE(0x083a, 0xc522) },
 	{ USB_DEVICE(0x083a, 0xd522) },
 	{ USB_DEVICE(0x083a, 0xf511) },
-	/* Sweex */
-	{ USB_DEVICE(0x177f, 0x0153) },
-	{ USB_DEVICE(0x177f, 0x0313) },
 	/* Zyxel */
 	{ USB_DEVICE(0x0586, 0x341a) },
 #endif
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlw=
ifi/pci.c
index d44d398..47ba0f7 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1961,6 +1961,7 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
 		rtl_deinit_deferred_work(hw);
 		rtlpriv->intf_ops->adapter_stop(hw);
 	}
+	rtlpriv->cfg->ops->disable_interrupt(hw);
=20
 	/*deinit rfkill */
 	rtl_deinit_rfkill(hw);
diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl12=
51/main.c
index ba3268e..40c1574 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -479,6 +479,7 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&wl->irq_work);
 	cancel_work_sync(&wl->tx_work);
 	cancel_work_sync(&wl->filter_work);
+	cancel_delayed_work_sync(&wl->elp_work);
=20
 	mutex_lock(&wl->mutex);
=20
diff --git a/drivers/net/wireless/wl1251/sdio.c b/drivers/net/wireless/wl12=
51/sdio.c
index f786942..1b851f6 100644
--- a/drivers/net/wireless/wl1251/sdio.c
+++ b/drivers/net/wireless/wl1251/sdio.c
@@ -315,8 +315,8 @@ static void __devexit wl1251_sdio_remove(struct sdio_fu=
nc *func)
=20
 	if (wl->irq)
 		free_irq(wl->irq, wl);
-	kfree(wl_sdio);
 	wl1251_free_hw(wl);
+	kfree(wl_sdio);
=20
 	sdio_claim_host(func);
 	sdio_release_irq(func);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6476547..78fda9c 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2906,6 +2906,40 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65f8=
, quirk_intel_mc_errata);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65f9, quirk_intel_mc_errat=
a);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65fa, quirk_intel_mc_errat=
a);
=20
+/*
+ * Some BIOS implementations leave the Intel GPU interrupts enabled,
+ * even though no one is handling them (f.e. i915 driver is never loaded).
+ * Additionally the interrupt destination is not set up properly
+ * and the interrupt ends up -somewhere-.
+ *
+ * These spurious interrupts are "sticky" and the kernel disables
+ * the (shared) interrupt line after 100.000+ generated interrupts.
+ *
+ * Fix it by disabling the still enabled interrupts.
+ * This resolves crashes often seen on monitor unplug.
+ */
+#define I915_DEIER_REG 0x4400c
+static void __devinit disable_igfx_irq(struct pci_dev *dev)
+{
+	void __iomem *regs =3D pci_iomap(dev, 0, 0);
+	if (regs =3D=3D NULL) {
+		dev_warn(&dev->dev, "igfx quirk: Can't iomap PCI device\n");
+		return;
+	}
+
+	/* Check if any interrupt line is still enabled */
+	if (readl(regs + I915_DEIER_REG) !=3D 0) {
+		dev_warn(&dev->dev, "BIOS left Intel GPU interrupts enabled; "
+			"disabling\n");
+
+		writel(0, regs + I915_DEIER_REG);
+	}
+
+	pci_iounmap(dev, regs);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0102, disable_igfx_irq);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x010a, disable_igfx_irq);
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell=
-laptop.c
index d93e962..1d3bcce 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -184,6 +184,34 @@ static struct dmi_system_id __devinitdata dell_quirks[=
] =3D {
 		},
 		.driver_data =3D &quirk_dell_vostro_v130,
 	},
+	{
+		.callback =3D dmi_matched,
+		.ident =3D "Dell Vostro 3555",
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 3555"),
+		},
+		.driver_data =3D &quirk_dell_vostro_v130,
+	},
+	{
+		.callback =3D dmi_matched,
+		.ident =3D "Dell Inspiron N311z",
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron N311z"),
+		},
+		.driver_data =3D &quirk_dell_vostro_v130,
+	},
+	{
+		.callback =3D dmi_matched,
+		.ident =3D "Dell Inspiron M5110",
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron M5110"),
+		},
+		.driver_data =3D &quirk_dell_vostro_v130,
+	},
+	{ }
 };
=20
 static struct calling_interface_buffer *buffer;
@@ -615,6 +643,7 @@ static void touchpad_led_set(struct led_classdev *led_c=
dev,
 static struct led_classdev touchpad_led =3D {
 	.name =3D "dell-laptop::touchpad",
 	.brightness_set =3D touchpad_led_set,
+	.flags =3D LED_CORE_SUSPENDRESUME,
 };
=20
 static int __devinit touchpad_led_init(struct device *dev)
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_e=
xpander.c
index 1b831c5..e48ba4b 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -192,7 +192,14 @@ static void sas_set_ex_phy(struct domain_device *dev, =
int phy_id,
 	phy->attached_sata_ps   =3D dr->attached_sata_ps;
 	phy->attached_iproto =3D dr->iproto << 1;
 	phy->attached_tproto =3D dr->tproto << 1;
-	memcpy(phy->attached_sas_addr, dr->attached_sas_addr, SAS_ADDR_SIZE);
+	/* help some expanders that fail to zero sas_address in the 'no
+	 * device' case
+	 */
+	if (phy->attached_dev_type =3D=3D NO_DEVICE ||
+	    phy->linkrate < SAS_LINK_RATE_1_5_GBPS)
+		memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
+	else
+		memcpy(phy->attached_sas_addr, dr->attached_sas_addr, SAS_ADDR_SIZE);
 	phy->attached_phy_id =3D dr->attached_phy_id;
 	phy->phy_change_count =3D dr->change_count;
 	phy->routing_attr =3D dr->routing_attr;
@@ -1643,9 +1650,17 @@ static int sas_find_bcast_phy(struct domain_device *=
dev, int *phy_id,
 		int phy_change_count =3D 0;
=20
 		res =3D sas_get_phy_change_count(dev, i, &phy_change_count);
-		if (res)
-			goto out;
-		else if (phy_change_count !=3D ex->ex_phy[i].phy_change_count) {
+		switch (res) {
+		case SMP_RESP_PHY_VACANT:
+		case SMP_RESP_NO_PHY:
+			continue;
+		case SMP_RESP_FUNC_ACC:
+			break;
+		default:
+			return res;
+		}
+
+		if (phy_change_count !=3D ex->ex_phy[i].phy_change_count) {
 			if (update)
 				ex->ex_phy[i].phy_change_count =3D
 					phy_change_count;
@@ -1653,8 +1668,7 @@ static int sas_find_bcast_phy(struct domain_device *d=
ev, int *phy_id,
 			return 0;
 		}
 	}
-out:
-	return res;
+	return 0;
 }
=20
 static int sas_get_ex_change_count(struct domain_device *dev, int *ecc)
diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 24cacff..5f748c0 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -139,10 +139,12 @@ static void fsl_spi_change_mode(struct spi_device *sp=
i)
 static void fsl_spi_chipselect(struct spi_device *spi, int value)
 {
 	struct mpc8xxx_spi *mpc8xxx_spi =3D spi_master_get_devdata(spi->master);
-	struct fsl_spi_platform_data *pdata =3D spi->dev.parent->platform_data;
+	struct fsl_spi_platform_data *pdata;
 	bool pol =3D spi->mode & SPI_CS_HIGH;
 	struct spi_mpc8xxx_cs	*cs =3D spi->controller_state;
=20
+	pdata =3D spi->dev.parent->parent->platform_data;
+
 	if (value =3D=3D BITBANG_CS_INACTIVE) {
 		if (pdata->cs_control)
 			pdata->cs_control(spi, !pol);
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 77eae99..b2ccdea 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -319,7 +319,7 @@ struct spi_device *spi_alloc_device(struct spi_master *=
master)
 	}
=20
 	spi->master =3D master;
-	spi->dev.parent =3D dev;
+	spi->dev.parent =3D &master->dev;
 	spi->dev.bus =3D &spi_bus_type;
 	spi->dev.release =3D spidev_release;
 	device_initialize(&spi->dev);
diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/o=
s_intfs.c
index fb11743..4bb2797 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -476,9 +476,6 @@ static int netdev_close(struct net_device *pnetdev)
 	r8712_free_assoc_resources(padapter);
 	/*s2-4.*/
 	r8712_free_network_queue(padapter);
-	release_firmware(padapter->fw);
-	/* never exit with a firmware callback pending */
-	wait_for_completion(&padapter->rtl8712_fw_ready);
 	return 0;
 }
=20
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/u=
sb_intf.c
index 9bade18..ec41d38 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -30,6 +30,7 @@
=20
 #include <linux/usb.h>
 #include <linux/module.h>
+#include <linux/firmware.h>
=20
 #include "osdep_service.h"
 #include "drv_types.h"
@@ -621,6 +622,10 @@ static void r871xu_dev_remove(struct usb_interface *pu=
sb_intf)
 	struct _adapter *padapter =3D netdev_priv(pnetdev);
 	struct usb_device *udev =3D interface_to_usbdev(pusb_intf);
=20
+	if (padapter->fw_found)
+		release_firmware(padapter->fw);
+	/* never exit with a firmware callback pending */
+	wait_for_completion(&padapter->rtl8712_fw_ready);
 	usb_set_intfdata(pusb_intf, NULL);
 	if (padapter) {
 		if (drvpriv.drv_registered =3D=3D true)
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index b84c834..8daf073 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1113,8 +1113,10 @@ static int set_serial_info(struct async_struct * inf=
o,
 		    (new_serial.close_delay !=3D state->close_delay) ||
 		    (new_serial.xmit_fifo_size !=3D state->xmit_fifo_size) ||
 		    ((new_serial.flags & ~ASYNC_USR_MASK) !=3D
-		     (state->flags & ~ASYNC_USR_MASK)))
+		     (state->flags & ~ASYNC_USR_MASK))) {
+			tty_unlock();
 			return -EPERM;
+		}
 		state->flags =3D ((state->flags & ~ASYNC_USR_MASK) |
 			       (new_serial.flags & ASYNC_USR_MASK));
 		info->flags =3D ((info->flags & ~ASYNC_USR_MASK) |
diff --git a/drivers/tty/serial/clps711x.c b/drivers/tty/serial/clps711x.c
index e6c3dbd..836fe273 100644
--- a/drivers/tty/serial/clps711x.c
+++ b/drivers/tty/serial/clps711x.c
@@ -154,10 +154,9 @@ static irqreturn_t clps711xuart_int_tx(int irq, void *=
dev_id)
 		port->x_char =3D 0;
 		return IRQ_HANDLED;
 	}
-	if (uart_circ_empty(xmit) || uart_tx_stopped(port)) {
-		clps711xuart_stop_tx(port);
-		return IRQ_HANDLED;
-	}
+
+	if (uart_circ_empty(xmit) || uart_tx_stopped(port))
+		goto disable_tx_irq;
=20
 	count =3D port->fifosize >> 1;
 	do {
@@ -171,8 +170,11 @@ static irqreturn_t clps711xuart_int_tx(int irq, void *=
dev_id)
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
=20
-	if (uart_circ_empty(xmit))
-		clps711xuart_stop_tx(port);
+	if (uart_circ_empty(xmit)) {
+	disable_tx_irq:
+		disable_irq_nosync(TX_IRQ(port));
+		tx_enabled(port) =3D 0;
+	}
=20
 	return IRQ_HANDLED;
 }
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index da776a0..a4b192d 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1356,9 +1356,11 @@ static int pch_uart_verify_port(struct uart_port *po=
rt,
 			__func__);
 		return -EOPNOTSUPP;
 #endif
-		priv->use_dma =3D 1;
 		priv->use_dma_flag =3D 1;
 		dev_info(priv->port.dev, "PCH UART : Use DMA Mode\n");
+		if (!priv->use_dma)
+			pch_request_dma(port);
+		priv->use_dma =3D 1;
 	}
=20
 	return 0;
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 9eb71d8..2db0327 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -108,8 +108,9 @@ static void wdm_out_callback(struct urb *urb)
 	spin_lock(&desc->iuspin);
 	desc->werr =3D urb->status;
 	spin_unlock(&desc->iuspin);
-	clear_bit(WDM_IN_USE, &desc->flags);
 	kfree(desc->outbuf);
+	desc->outbuf =3D NULL;
+	clear_bit(WDM_IN_USE, &desc->flags);
 	wake_up(&desc->wait);
 }
=20
@@ -312,7 +313,7 @@ static ssize_t wdm_write
 	if (we < 0)
 		return -EIO;
=20
-	desc->outbuf =3D buf =3D kmalloc(count, GFP_KERNEL);
+	buf =3D kmalloc(count, GFP_KERNEL);
 	if (!buf) {
 		rv =3D -ENOMEM;
 		goto outnl;
@@ -376,10 +377,12 @@ static ssize_t wdm_write
 	req->wIndex =3D desc->inum;
 	req->wLength =3D cpu_to_le16(count);
 	set_bit(WDM_IN_USE, &desc->flags);
+	desc->outbuf =3D buf;
=20
 	rv =3D usb_submit_urb(desc->command, GFP_KERNEL);
 	if (rv < 0) {
 		kfree(buf);
+		desc->outbuf =3D NULL;
 		clear_bit(WDM_IN_USE, &desc->flags);
 		dev_err(&desc->intf->dev, "Tx URB error: %d\n", rv);
 	} else {
diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index 61d08dd..5f1404a 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -495,6 +495,15 @@ static int hcd_pci_suspend_noirq(struct device *dev)
=20
 	pci_save_state(pci_dev);
=20
+	/*
+	 * Some systems crash if an EHCI controller is in D3 during
+	 * a sleep transition.  We have to leave such controllers in D0.
+	 */
+	if (hcd->broken_pci_sleep) {
+		dev_dbg(dev, "Staying in PCI D0\n");
+		return retval;
+	}
+
 	/* If the root hub is dead rather than suspended, disallow remote
 	 * wakeup.  usb_hc_died() should ensure that both hosts are marked as
 	 * dying, so we only need to check the primary roothub.
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index e238b3b..2b0a341 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1644,7 +1644,6 @@ void usb_disconnect(struct usb_device **pdev)
 {
 	struct usb_device	*udev =3D *pdev;
 	int			i;
-	struct usb_hcd		*hcd =3D bus_to_hcd(udev->bus);
=20
 	/* mark the device as inactive, so any further urb submissions for
 	 * this device (and any of its children) will fail immediately.
@@ -1667,9 +1666,7 @@ void usb_disconnect(struct usb_device **pdev)
 	 * so that the hardware is now fully quiesced.
 	 */
 	dev_dbg (&udev->dev, "unregistering device\n");
-	mutex_lock(hcd->bandwidth_mutex);
 	usb_disable_device(udev, 0);
-	mutex_unlock(hcd->bandwidth_mutex);
 	usb_hcd_synchronize_unlinks(udev);
=20
 	usb_remove_ep_devs(&udev->ep0);
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index aed3e07..ca717da 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1136,8 +1136,6 @@ void usb_disable_interface(struct usb_device *dev, st=
ruct usb_interface *intf,
  * Deallocates hcd/hardware state for the endpoints (nuking all or most
  * pending urbs) and usbcore state for the interfaces, so that usbcore
  * must usb_set_configuration() before any interfaces could be used.
- *
- * Must be called with hcd->bandwidth_mutex held.
  */
 void usb_disable_device(struct usb_device *dev, int skip_ep0)
 {
@@ -1190,7 +1188,9 @@ void usb_disable_device(struct usb_device *dev, int s=
kip_ep0)
 			usb_disable_endpoint(dev, i + USB_DIR_IN, false);
 		}
 		/* Remove endpoints from the host controller internal state */
+		mutex_lock(hcd->bandwidth_mutex);
 		usb_hcd_alloc_bandwidth(dev, NULL, NULL, NULL);
+		mutex_unlock(hcd->bandwidth_mutex);
 		/* Second pass: remove endpoint pointers */
 	}
 	for (i =3D skip_ep0; i < 16; ++i) {
@@ -1750,7 +1750,6 @@ free_interfaces:
 	/* if it's already configured, clear out old state first.
 	 * getting rid of old interfaces means unbinding their drivers.
 	 */
-	mutex_lock(hcd->bandwidth_mutex);
 	if (dev->state !=3D USB_STATE_ADDRESS)
 		usb_disable_device(dev, 1);	/* Skip ep0 */
=20
@@ -1763,6 +1762,7 @@ free_interfaces:
 	 * host controller will not allow submissions to dropped endpoints.  If
 	 * this call fails, the device state is unchanged.
 	 */
+	mutex_lock(hcd->bandwidth_mutex);
 	ret =3D usb_hcd_alloc_bandwidth(dev, cp, NULL, NULL);
 	if (ret < 0) {
 		mutex_unlock(hcd->bandwidth_mutex);
diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 27bd50a..c0dcf69 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -572,9 +572,10 @@ static void dwc3_ep0_complete_data(struct dwc3 *dwc,
 		dwc->ep0_bounced =3D false;
 	} else {
 		transferred =3D ur->length - trb.length;
-		ur->actual +=3D transferred;
 	}
=20
+	ur->actual +=3D transferred;
+
 	if ((epnum & 1) && ur->actual < ur->length) {
 		/* for some reason we did not get everything out */
=20
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.=
c
index ab8f1b4..527736e 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -925,7 +925,6 @@ static int dummy_udc_stop(struct usb_gadget *g,
=20
 	dum->driver =3D NULL;
=20
-	dummy_pullup(&dum->gadget, 0);
 	return 0;
 }
=20
diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index acb3800..0e641a1 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -712,7 +712,7 @@ static long ffs_ep0_ioctl(struct file *file, unsigned c=
ode, unsigned long value)
 	if (code =3D=3D FUNCTIONFS_INTERFACE_REVMAP) {
 		struct ffs_function *func =3D ffs->func;
 		ret =3D func ? ffs_func_revmap_intf(func, value) : -ENODEV;
-	} else if (gadget->ops->ioctl) {
+	} else if (gadget && gadget->ops->ioctl) {
 		ret =3D gadget->ops->ioctl(gadget, code, value);
 	} else {
 		ret =3D -ENOTTY;
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mas=
s_storage.c
index 1a6f415..a5570b6 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2182,7 +2182,7 @@ unknown_cmnd:
 		common->data_size_from_cmnd =3D 0;
 		sprintf(unknown, "Unknown x%02x", common->cmnd[0]);
 		reply =3D check_command(common, common->cmnd_size,
-				      DATA_DIR_UNKNOWN, 0xff, 0, unknown);
+				      DATA_DIR_UNKNOWN, ~0, 0, unknown);
 		if (reply =3D=3D 0) {
 			common->curlun->sense_data =3D SS_INVALID_COMMAND;
 			reply =3D -EINVAL;
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_st=
orage.c
index 11b5196..db2d607 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -2569,7 +2569,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		fsg->data_size_from_cmnd =3D 0;
 		sprintf(unknown, "Unknown x%02x", fsg->cmnd[0]);
 		if ((reply =3D check_command(fsg, fsg->cmnd_size,
-				DATA_DIR_UNKNOWN, 0xff, 0, unknown)) =3D=3D 0) {
+				DATA_DIR_UNKNOWN, ~0, 0, unknown)) =3D=3D 0) {
 			fsg->curlun->sense_data =3D SS_INVALID_COMMAND;
 			reply =3D -EINVAL;
 		}
diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
index 6939e17..901924a 100644
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -211,9 +211,9 @@ static void usb_gadget_remove_driver(struct usb_udc *ud=
c)
=20
 	if (udc_is_newstyle(udc)) {
 		udc->driver->disconnect(udc->gadget);
+		usb_gadget_disconnect(udc->gadget);
 		udc->driver->unbind(udc->gadget);
 		usb_gadget_udc_stop(udc->gadget, udc->driver);
-		usb_gadget_disconnect(udc->gadget);
 	} else {
 		usb_gadget_stop(udc->gadget, udc->driver);
 	}
@@ -359,9 +359,13 @@ static ssize_t usb_udc_softconn_store(struct device *d=
ev,
 	struct usb_udc		*udc =3D container_of(dev, struct usb_udc, dev);
=20
 	if (sysfs_streq(buf, "connect")) {
+		if (udc_is_newstyle(udc))
+			usb_gadget_udc_start(udc->gadget, udc->driver);
 		usb_gadget_connect(udc->gadget);
 	} else if (sysfs_streq(buf, "disconnect")) {
 		usb_gadget_disconnect(udc->gadget);
+		if (udc_is_newstyle(udc))
+			usb_gadget_udc_stop(udc->gadget, udc->driver);
 	} else {
 		dev_err(dev, "unsupported command '%s'\n", buf);
 		return -EINVAL;
diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
index bc78c60..ca4e03a 100644
--- a/drivers/usb/gadget/uvc.h
+++ b/drivers/usb/gadget/uvc.h
@@ -28,7 +28,7 @@
=20
 struct uvc_request_data
 {
-	unsigned int length;
+	__s32 length;
 	__u8 data[60];
 };
=20
diff --git a/drivers/usb/gadget/uvc_v4l2.c b/drivers/usb/gadget/uvc_v4l2.c
index f6e083b..54d7ca5 100644
--- a/drivers/usb/gadget/uvc_v4l2.c
+++ b/drivers/usb/gadget/uvc_v4l2.c
@@ -39,7 +39,7 @@ uvc_send_response(struct uvc_device *uvc, struct uvc_requ=
est_data *data)
 	if (data->length < 0)
 		return usb_ep_set_halt(cdev->gadget->ep0);
=20
-	req->length =3D min(uvc->event_length, data->length);
+	req->length =3D min_t(unsigned int, uvc->event_length, data->length);
 	req->zero =3D data->length < uvc->event_length;
 	req->dma =3D DMA_ADDR_INVALID;
=20
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 3ff9f82..da2f711 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -815,8 +815,13 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 		goto dead;
 	}
=20
+	/*
+	 * We don't use STS_FLR, but some controllers don't like it to
+	 * remain on, so mask it out along with the other status bits.
+	 */
+	masked_status =3D status & (INTR_MASK | STS_FLR);
+
 	/* Shared IRQ? */
-	masked_status =3D status & INTR_MASK;
 	if (!masked_status || unlikely(ehci->rh_state =3D=3D EHCI_RH_HALTED)) {
 		spin_unlock(&ehci->lock);
 		return IRQ_NONE;
@@ -867,7 +872,7 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 		pcd_status =3D status;
=20
 		/* resume root hub? */
-		if (!(cmd & CMD_RUN))
+		if (ehci->rh_state =3D=3D EHCI_RH_SUSPENDED)
 			usb_hcd_resume_root_hub(hcd);
=20
 		/* get per-port change detect bits */
diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index f4b627d..971d312 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -144,6 +144,14 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 			hcd->has_tt =3D 1;
 			tdi_reset(ehci);
 		}
+		if (pdev->subsystem_vendor =3D=3D PCI_VENDOR_ID_ASUSTEK) {
+			/* EHCI #1 or #2 on 6 Series/C200 Series chipset */
+			if (pdev->device =3D=3D 0x1c26 || pdev->device =3D=3D 0x1c2d) {
+				ehci_info(ehci, "broken D3 during system sleep on ASUS\n");
+				hcd->broken_pci_sleep =3D 1;
+				device_set_wakeup_capable(&pdev->dev, false);
+			}
+		}
 		break;
 	case PCI_VENDOR_ID_TDI:
 		if (pdev->device =3D=3D PCI_DEVICE_ID_TDI_EHCI) {
diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index ac5bfd6..2504694 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -99,9 +99,7 @@ static void yurex_delete(struct kref *kref)
 	usb_put_dev(dev->udev);
 	if (dev->cntl_urb) {
 		usb_kill_urb(dev->cntl_urb);
-		if (dev->cntl_req)
-			usb_free_coherent(dev->udev, YUREX_BUF_SIZE,
-				dev->cntl_req, dev->cntl_urb->setup_dma);
+		kfree(dev->cntl_req);
 		if (dev->cntl_buffer)
 			usb_free_coherent(dev->udev, YUREX_BUF_SIZE,
 				dev->cntl_buffer, dev->cntl_urb->transfer_dma);
@@ -234,9 +232,7 @@ static int yurex_probe(struct usb_interface *interface,=
 const struct usb_device_
 	}
=20
 	/* allocate buffer for control req */
-	dev->cntl_req =3D usb_alloc_coherent(dev->udev, YUREX_BUF_SIZE,
-					   GFP_KERNEL,
-					   &dev->cntl_urb->setup_dma);
+	dev->cntl_req =3D kmalloc(YUREX_BUF_SIZE, GFP_KERNEL);
 	if (!dev->cntl_req) {
 		err("Could not allocate cntl_req");
 		goto error;
@@ -286,7 +282,7 @@ static int yurex_probe(struct usb_interface *interface,=
 const struct usb_device_
 			 usb_rcvintpipe(dev->udev, dev->int_in_endpointAddr),
 			 dev->int_buffer, YUREX_BUF_SIZE, yurex_interrupt,
 			 dev, 1);
-	dev->cntl_urb->transfer_flags |=3D URB_NO_TRANSFER_DMA_MAP;
+	dev->urb->transfer_flags |=3D URB_NO_TRANSFER_DMA_MAP;
 	if (usb_submit_urb(dev->urb, GFP_KERNEL)) {
 		retval =3D -EIO;
 		err("Could not submitting URB");
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index ba85f27..a8f0c09 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -282,7 +282,8 @@ static int musb_otg_notifications(struct notifier_block=
 *nb,
=20
 static int omap2430_musb_init(struct musb *musb)
 {
-	u32 l, status =3D 0;
+	u32 l;
+	int status =3D 0;
 	struct device *dev =3D musb->controller;
 	struct musb_hdrc_platform_data *plat =3D dev->platform_data;
 	struct omap_musb_board_data *data =3D plat->board_data;
@@ -299,7 +300,7 @@ static int omap2430_musb_init(struct musb *musb)
=20
 	status =3D pm_runtime_get_sync(dev);
 	if (status < 0) {
-		dev_err(dev, "pm_runtime_get_sync FAILED");
+		dev_err(dev, "pm_runtime_get_sync FAILED %d\n", status);
 		goto err1;
 	}
=20
@@ -451,14 +452,14 @@ static int __init omap2430_probe(struct platform_devi=
ce *pdev)
 		goto err2;
 	}
=20
+	pm_runtime_enable(&pdev->dev);
+
 	ret =3D platform_device_add(musb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register musb device\n");
 		goto err2;
 	}
=20
-	pm_runtime_enable(&pdev->dev);
-
 	return 0;
=20
 err2:
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 4c12404..f2c57e0 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -285,7 +285,8 @@ static int cp210x_get_config(struct usb_serial_port *po=
rt, u8 request,
 	/* Issue the request, attempting to read 'size' bytes */
 	result =3D usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 				request, REQTYPE_DEVICE_TO_HOST, 0x0000,
-				port_priv->bInterfaceNumber, buf, size, 300);
+				port_priv->bInterfaceNumber, buf, size,
+				USB_CTRL_GET_TIMEOUT);
=20
 	/* Convert data into an array of integers */
 	for (i =3D 0; i < length; i++)
@@ -335,12 +336,14 @@ static int cp210x_set_config(struct usb_serial_port *=
port, u8 request,
 		result =3D usb_control_msg(serial->dev,
 				usb_sndctrlpipe(serial->dev, 0),
 				request, REQTYPE_HOST_TO_DEVICE, 0x0000,
-				port_priv->bInterfaceNumber, buf, size, 300);
+				port_priv->bInterfaceNumber, buf, size,
+				USB_CTRL_SET_TIMEOUT);
 	} else {
 		result =3D usb_control_msg(serial->dev,
 				usb_sndctrlpipe(serial->dev, 0),
 				request, REQTYPE_HOST_TO_DEVICE, data[0],
-				port_priv->bInterfaceNumber, NULL, 0, 300);
+				port_priv->bInterfaceNumber, NULL, 0,
+				USB_CTRL_SET_TIMEOUT);
 	}
=20
 	kfree(buf);
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 7c3ec9e..e093585 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -221,7 +221,7 @@ static const struct sierra_iface_info typeB_interface_l=
ist =3D {
 };
=20
 /* 'blacklist' of interfaces not served by this driver */
-static const u8 direct_ip_non_serial_ifaces[] =3D { 7, 8, 9, 10, 11 };
+static const u8 direct_ip_non_serial_ifaces[] =3D { 7, 8, 9, 10, 11, 19, 2=
0 };
 static const struct sierra_iface_info direct_ip_interface_blacklist =3D {
 	.infolen =3D ARRAY_SIZE(direct_ip_non_serial_ifaces),
 	.ifaceinfo =3D direct_ip_non_serial_ifaces,
@@ -289,7 +289,6 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(0x1199, 0x6856) },	/* Sierra Wireless AirCard 881 U */
 	{ USB_DEVICE(0x1199, 0x6859) },	/* Sierra Wireless AirCard 885 E */
 	{ USB_DEVICE(0x1199, 0x685A) },	/* Sierra Wireless AirCard 885 E */
-	{ USB_DEVICE(0x1199, 0x68A2) }, /* Sierra Wireless MC7710 */
 	/* Sierra Wireless C885 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x6880, 0xFF, 0xFF, 0xFF)},
 	/* Sierra Wireless C888, Air Card 501, USB 303, USB 304 */
@@ -299,6 +298,9 @@ static const struct usb_device_id id_table[] =3D {
 	/* Sierra Wireless HSPA Non-Composite Device */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x6892, 0xFF, 0xFF, 0xFF)},
 	{ USB_DEVICE(0x1199, 0x6893) },	/* Sierra Wireless Device */
+	{ USB_DEVICE(0x1199, 0x68A2),   /* Sierra Wireless MC77xx in QMI mode */
+	  .driver_info =3D (kernel_ulong_t)&direct_ip_interface_blacklist
+	},
 	{ USB_DEVICE(0x1199, 0x68A3), 	/* Sierra Wireless Direct IP modems */
 	  .driver_info =3D (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
diff --git a/drivers/uwb/hwa-rc.c b/drivers/uwb/hwa-rc.c
index 2babcd4..86685e9 100644
--- a/drivers/uwb/hwa-rc.c
+++ b/drivers/uwb/hwa-rc.c
@@ -645,7 +645,8 @@ void hwarc_neep_cb(struct urb *urb)
 		dev_err(dev, "NEEP: URB error %d\n", urb->status);
 	}
 	result =3D usb_submit_urb(urb, GFP_ATOMIC);
-	if (result < 0) {
+	if (result < 0 && result !=3D -ENODEV && result !=3D -EPERM) {
+		/* ignoring unrecoverable errors */
 		dev_err(dev, "NEEP: Can't resubmit URB (%d) resetting device\n",
 			result);
 		goto error;
diff --git a/drivers/uwb/neh.c b/drivers/uwb/neh.c
index a269937..8cb71bb 100644
--- a/drivers/uwb/neh.c
+++ b/drivers/uwb/neh.c
@@ -107,6 +107,7 @@ struct uwb_rc_neh {
 	u8 evt_type;
 	__le16 evt;
 	u8 context;
+	u8 completed;
 	uwb_rc_cmd_cb_f cb;
 	void *arg;
=20
@@ -409,6 +410,7 @@ static void uwb_rc_neh_grok_event(struct uwb_rc *rc, st=
ruct uwb_rceb *rceb, size
 	struct device *dev =3D &rc->uwb_dev.dev;
 	struct uwb_rc_neh *neh;
 	struct uwb_rceb *notif;
+	unsigned long flags;
=20
 	if (rceb->bEventContext =3D=3D 0) {
 		notif =3D kmalloc(size, GFP_ATOMIC);
@@ -422,7 +424,11 @@ static void uwb_rc_neh_grok_event(struct uwb_rc *rc, s=
truct uwb_rceb *rceb, size
 	} else {
 		neh =3D uwb_rc_neh_lookup(rc, rceb);
 		if (neh) {
-			del_timer_sync(&neh->timer);
+			spin_lock_irqsave(&rc->neh_lock, flags);
+			/* to guard against a timeout */
+			neh->completed =3D 1;
+			del_timer(&neh->timer);
+			spin_unlock_irqrestore(&rc->neh_lock, flags);
 			uwb_rc_neh_cb(neh, rceb, size);
 		} else
 			dev_warn(dev, "event 0x%02x/%04x/%02x (%zu bytes): nobody cared\n",
@@ -568,6 +574,10 @@ static void uwb_rc_neh_timer(unsigned long arg)
 	unsigned long flags;
=20
 	spin_lock_irqsave(&rc->neh_lock, flags);
+	if (neh->completed) {
+		spin_unlock_irqrestore(&rc->neh_lock, flags);
+		return;
+	}
 	if (neh->context)
 		__uwb_rc_neh_rm(rc, neh);
 	else
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index afca14d..625890c 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -692,7 +692,7 @@ static int gntdev_mmap(struct file *flip, struct vm_are=
a_struct *vma)
 	vma->vm_flags |=3D VM_RESERVED|VM_DONTEXPAND;
=20
 	if (use_ptemod)
-		vma->vm_flags |=3D VM_DONTCOPY|VM_PFNMAP;
+		vma->vm_flags |=3D VM_DONTCOPY;
=20
 	vma->vm_private_data =3D map;
=20
diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbu=
s/xenbus_probe_frontend.c
index 2f73195..2ce95c0 100644
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -129,7 +129,7 @@ static int read_backend_details(struct xenbus_device *x=
endev)
 	return xenbus_read_otherend_details(xendev, "backend-id", "backend");
 }
=20
-static int is_device_connecting(struct device *dev, void *data)
+static int is_device_connecting(struct device *dev, void *data, bool ignor=
e_nonessential)
 {
 	struct xenbus_device *xendev =3D to_xenbus_device(dev);
 	struct device_driver *drv =3D data;
@@ -146,16 +146,41 @@ static int is_device_connecting(struct device *dev, v=
oid *data)
 	if (drv && (dev->driver !=3D drv))
 		return 0;
=20
+	if (ignore_nonessential) {
+		/* With older QEMU, for PVonHVM guests the guest config files
+		 * could contain: vfb =3D [ 'vnc=3D1, vnclisten=3D0.0.0.0']
+		 * which is nonsensical as there is no PV FB (there can be
+		 * a PVKB) running as HVM guest. */
+
+		if ((strncmp(xendev->nodename, "device/vkbd", 11) =3D=3D 0))
+			return 0;
+
+		if ((strncmp(xendev->nodename, "device/vfb", 10) =3D=3D 0))
+			return 0;
+	}
 	xendrv =3D to_xenbus_driver(dev->driver);
 	return (xendev->state < XenbusStateConnected ||
 		(xendev->state =3D=3D XenbusStateConnected &&
 		 xendrv->is_ready && !xendrv->is_ready(xendev)));
 }
+static int essential_device_connecting(struct device *dev, void *data)
+{
+	return is_device_connecting(dev, data, true /* ignore PV[KBB+FB] */);
+}
+static int non_essential_device_connecting(struct device *dev, void *data)
+{
+	return is_device_connecting(dev, data, false);
+}
=20
-static int exists_connecting_device(struct device_driver *drv)
+static int exists_essential_connecting_device(struct device_driver *drv)
 {
 	return bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
-				is_device_connecting);
+				essential_device_connecting);
+}
+static int exists_non_essential_connecting_device(struct device_driver *dr=
v)
+{
+	return bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
+				non_essential_device_connecting);
 }
=20
 static int print_device_status(struct device *dev, void *data)
@@ -186,6 +211,23 @@ static int print_device_status(struct device *dev, voi=
d *data)
 /* We only wait for device setup after most initcalls have run. */
 static int ready_to_wait_for_devices;
=20
+static bool wait_loop(unsigned long start, unsigned int max_delay,
+		     unsigned int *seconds_waited)
+{
+	if (time_after(jiffies, start + (*seconds_waited+5)*HZ)) {
+		if (!*seconds_waited)
+			printk(KERN_WARNING "XENBUS: Waiting for "
+			       "devices to initialise: ");
+		*seconds_waited +=3D 5;
+		printk("%us...", max_delay - *seconds_waited);
+		if (*seconds_waited =3D=3D max_delay)
+			return true;
+	}
+
+	schedule_timeout_interruptible(HZ/10);
+
+	return false;
+}
 /*
  * On a 5-minute timeout, wait for all devices currently configured.  We n=
eed
  * to do this to guarantee that the filesystems and / or network devices
@@ -209,19 +251,14 @@ static void wait_for_devices(struct xenbus_driver *xe=
ndrv)
 	if (!ready_to_wait_for_devices || !xen_domain())
 		return;
=20
-	while (exists_connecting_device(drv)) {
-		if (time_after(jiffies, start + (seconds_waited+5)*HZ)) {
-			if (!seconds_waited)
-				printk(KERN_WARNING "XENBUS: Waiting for "
-				       "devices to initialise: ");
-			seconds_waited +=3D 5;
-			printk("%us...", 300 - seconds_waited);
-			if (seconds_waited =3D=3D 300)
-				break;
-		}
-
-		schedule_timeout_interruptible(HZ/10);
-	}
+	while (exists_non_essential_connecting_device(drv))
+		if (wait_loop(start, 30, &seconds_waited))
+			break;
+
+	/* Skips PVKB and PVFB check.*/
+	while (exists_essential_connecting_device(drv))
+		if (wait_loop(start, 270, &seconds_waited))
+			break;
=20
 	if (seconds_waited)
 		printk("\n");
diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 308a98b..650d520 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -110,7 +110,6 @@ struct autofs_sb_info {
 	int sub_version;
 	int min_proto;
 	int max_proto;
-	int compat_daemon;
 	unsigned long exp_timeout;
 	unsigned int type;
 	int reghost_enabled;
@@ -269,6 +268,17 @@ int autofs4_fill_super(struct super_block *, void *, i=
nt);
 struct autofs_info *autofs4_new_ino(struct autofs_sb_info *);
 void autofs4_clean_ino(struct autofs_info *);
=20
+static inline int autofs_prepare_pipe(struct file *pipe)
+{
+	if (!pipe->f_op || !pipe->f_op->write)
+		return -EINVAL;
+	if (!S_ISFIFO(pipe->f_dentry->d_inode->i_mode))
+		return -EINVAL;
+	/* We want a packet pipe */
+	pipe->f_flags |=3D O_DIRECT;
+	return 0;
+}
+
 /* Queue management functions */
=20
 int autofs4_wait(struct autofs_sb_info *,struct dentry *, enum autofs_noti=
fy);
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 56bac70..de54271 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -376,7 +376,7 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
 			err =3D -EBADF;
 			goto out;
 		}
-		if (!pipe->f_op || !pipe->f_op->write) {
+		if (autofs_prepare_pipe(pipe) < 0) {
 			err =3D -EPIPE;
 			fput(pipe);
 			goto out;
@@ -385,7 +385,6 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
 		sbi->pipefd =3D pipefd;
 		sbi->pipe =3D pipe;
 		sbi->catatonic =3D 0;
-		sbi->compat_daemon =3D is_compat_task();
 	}
 out:
 	mutex_unlock(&sbi->wq_mutex);
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 98a5695..7b5293e 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -19,7 +19,6 @@
 #include <linux/parser.h>
 #include <linux/bitops.h>
 #include <linux/magic.h>
-#include <linux/compat.h>
 #include "autofs_i.h"
 #include <linux/module.h>
=20
@@ -225,7 +224,6 @@ int autofs4_fill_super(struct super_block *s, void *dat=
a, int silent)
 	set_autofs_type_indirect(&sbi->type);
 	sbi->min_proto =3D 0;
 	sbi->max_proto =3D 0;
-	sbi->compat_daemon =3D is_compat_task();
 	mutex_init(&sbi->wq_mutex);
 	spin_lock_init(&sbi->fs_lock);
 	sbi->queues =3D NULL;
@@ -294,7 +292,7 @@ int autofs4_fill_super(struct super_block *s, void *dat=
a, int silent)
 		printk("autofs: could not open pipe file descriptor\n");
 		goto fail_dput;
 	}
-	if (!pipe->f_op || !pipe->f_op->write)
+	if (autofs_prepare_pipe(pipe) < 0)
 		goto fail_fput;
 	sbi->pipe =3D pipe;
 	sbi->pipefd =3D pipefd;
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 6861f61..e1fbdee 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -90,24 +90,7 @@ static int autofs4_write(struct file *file, const void *=
addr, int bytes)
=20
 	return (bytes > 0);
 }
-
-/*
- * The autofs_v5 packet was misdesigned.
- *
- * The packets are identical on x86-32 and x86-64, but have different
- * alignment. Which means that 'sizeof()' will give different results.
- * Fix it up for the case of running 32-bit user mode on a 64-bit kernel.
- */
-static noinline size_t autofs_v5_packet_size(struct autofs_sb_info *sbi)
-{
-	size_t pktsz =3D sizeof(struct autofs_v5_packet);
-#if defined(CONFIG_X86_64) && defined(CONFIG_COMPAT)
-	if (sbi->compat_daemon > 0)
-		pktsz -=3D 4;
-#endif
-	return pktsz;
-}
-
+=09
 static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 				 struct autofs_wait_queue *wq,
 				 int type)
@@ -164,7 +147,8 @@ static void autofs4_notify_daemon(struct autofs_sb_info=
 *sbi,
 	{
 		struct autofs_v5_packet *packet =3D &pkt.v5_pkt.v5_packet;
=20
-		pktsz =3D autofs_v5_packet_size(sbi);
+		pktsz =3D sizeof(*packet);
+
 		packet->wait_queue_token =3D wq->wait_queue_token;
 		packet->len =3D wq->name.len;
 		memcpy(packet->name, wq->name.name, wq->name.len);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6738503..83a871f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2025,7 +2025,7 @@ BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct b=
trfs_root_item,
=20
 static inline bool btrfs_root_readonly(struct btrfs_root *root)
 {
-	return root->root_item.flags & BTRFS_ROOT_SUBVOL_RDONLY;
+	return (root->root_item.flags & cpu_to_le64(BTRFS_ROOT_SUBVOL_RDONLY)) !=
=3D 0;
 }
=20
 /* struct btrfs_root_backup */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 0e6adac..e89803b 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4826,8 +4826,12 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *=
pSMBr,
 		max_len =3D data_end - temp;
 		node->node_name =3D cifs_strndup_from_ucs(temp, max_len,
 						      is_unicode, nls_codepage);
-		if (!node->node_name)
+		if (!node->node_name) {
 			rc =3D -ENOMEM;
+			goto parse_DFS_referrals_exit;
+		}
+
+		ref++;
 	}
=20
 parse_DFS_referrals_exit:
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index ea54cde..4d9d3a4 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -988,6 +988,10 @@ static int path_count[PATH_ARR_SIZE];
=20
 static int path_count_inc(int nests)
 {
+	/* Allow an arbitrary number of depth 1 paths */
+	if (nests =3D=3D 0)
+		return 0;
+
 	if (++path_count[nests] > path_limits[nests])
 		return -1;
 	return 0;
diff --git a/fs/exec.c b/fs/exec.c
index 3625464..160cd2f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -973,6 +973,9 @@ static int de_thread(struct task_struct *tsk)
 	sig->notify_count =3D 0;
=20
 no_thread_group:
+	/* we have changed execution domain */
+	tsk->exit_signal =3D SIGCHLD;
+
 	if (current->mm)
 		setmax_mm_hiwater_rss(&sig->maxrss, current->mm);
=20
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c2a2012..54f2bdc 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2812,7 +2812,7 @@ static int ext4_split_extent_at(handle_t *handle,
 		if (err)
 			goto fix_extent_len;
 		/* update the extent length and mark as initialized */
-		ex->ee_len =3D cpu_to_le32(ee_len);
+		ex->ee_len =3D cpu_to_le16(ee_len);
 		ext4_ext_try_to_merge(inode, path, ex);
 		err =3D ext4_ext_dirty(handle, inode, path + depth);
 		goto out;
diff --git a/fs/hfsplus/catalog.c b/fs/hfsplus/catalog.c
index 4dfbfec..ec2a9c2 100644
--- a/fs/hfsplus/catalog.c
+++ b/fs/hfsplus/catalog.c
@@ -366,6 +366,10 @@ int hfsplus_rename_cat(u32 cnid,
 	err =3D hfs_brec_find(&src_fd);
 	if (err)
 		goto out;
+	if (src_fd.entrylength > sizeof(entry) || src_fd.entrylength < 0) {
+		err =3D -EIO;
+		goto out;
+	}
=20
 	hfs_bnode_read(src_fd.bnode, &entry, src_fd.entryoffset,
 				src_fd.entrylength);
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 4536cd3..5adb740 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -150,6 +150,11 @@ static int hfsplus_readdir(struct file *filp, void *di=
rent, filldir_t filldir)
 		filp->f_pos++;
 		/* fall through */
 	case 1:
+		if (fd.entrylength > sizeof(entry) || fd.entrylength < 0) {
+			err =3D -EIO;
+			goto out;
+		}
+
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
 			fd.entrylength);
 		if (be16_to_cpu(entry.type) !=3D HFSPLUS_FOLDER_THREAD) {
@@ -181,6 +186,12 @@ static int hfsplus_readdir(struct file *filp, void *di=
rent, filldir_t filldir)
 			err =3D -EIO;
 			goto out;
 		}
+
+		if (fd.entrylength > sizeof(entry) || fd.entrylength < 0) {
+			err =3D -EIO;
+			goto out;
+		}
+
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
 			fd.entrylength);
 		type =3D be16_to_cpu(entry.type);
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 68d704d..d751f04 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -683,7 +683,7 @@ start_journal_io:
 	if (commit_transaction->t_need_data_flush &&
 	    (journal->j_fs_dev !=3D journal->j_dev) &&
 	    (journal->j_flags & JBD2_BARRIER))
-		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
+		blkdev_issue_flush(journal->j_fs_dev, GFP_NOFS, NULL);
=20
 	/* Done it all: now write the commit record asynchronously. */
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
@@ -819,7 +819,7 @@ wait_for_iobuf:
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
 				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT) &&
 	    journal->j_flags & JBD2_BARRIER) {
-		blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL);
+		blkdev_issue_flush(journal->j_dev, GFP_NOFS, NULL);
 	}
=20
 	if (err)
diff --git a/fs/lockd/clnt4xdr.c b/fs/lockd/clnt4xdr.c
index f848b52..046bb77 100644
--- a/fs/lockd/clnt4xdr.c
+++ b/fs/lockd/clnt4xdr.c
@@ -241,7 +241,7 @@ static int decode_nlm4_stat(struct xdr_stream *xdr, __b=
e32 *stat)
 	p =3D xdr_inline_decode(xdr, 4);
 	if (unlikely(p =3D=3D NULL))
 		goto out_overflow;
-	if (unlikely(*p > nlm4_failed))
+	if (unlikely(ntohl(*p) > ntohl(nlm4_failed)))
 		goto out_bad_xdr;
 	*stat =3D *p;
 	return 0;
diff --git a/fs/lockd/clntxdr.c b/fs/lockd/clntxdr.c
index 180ac34..36057ce 100644
--- a/fs/lockd/clntxdr.c
+++ b/fs/lockd/clntxdr.c
@@ -236,7 +236,7 @@ static int decode_nlm_stat(struct xdr_stream *xdr,
 	p =3D xdr_inline_decode(xdr, 4);
 	if (unlikely(p =3D=3D NULL))
 		goto out_overflow;
-	if (unlikely(*p > nlm_lck_denied_grace_period))
+	if (unlikely(ntohl(*p) > ntohl(nlm_lck_denied_grace_period)))
 		goto out_enum;
 	*stat =3D *p;
 	return 0;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 757293b..51f6a40 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4453,7 +4453,9 @@ static int _nfs4_do_setlk(struct nfs4_state *state, i=
nt cmd, struct file_lock *f
 static int nfs4_lock_reclaim(struct nfs4_state *state, struct file_lock *r=
equest)
 {
 	struct nfs_server *server =3D NFS_SERVER(state->inode);
-	struct nfs4_exception exception =3D { };
+	struct nfs4_exception exception =3D {
+		.inode =3D state->inode,
+	};
 	int err;
=20
 	do {
@@ -4471,7 +4473,9 @@ static int nfs4_lock_reclaim(struct nfs4_state *state=
, struct file_lock *request
 static int nfs4_lock_expired(struct nfs4_state *state, struct file_lock *r=
equest)
 {
 	struct nfs_server *server =3D NFS_SERVER(state->inode);
-	struct nfs4_exception exception =3D { };
+	struct nfs4_exception exception =3D {
+		.inode =3D state->inode,
+	};
 	int err;
=20
 	err =3D nfs4_set_lock_state(state, request);
@@ -4551,6 +4555,7 @@ static int nfs4_proc_setlk(struct nfs4_state *state, =
int cmd, struct file_lock *
 {
 	struct nfs4_exception exception =3D {
 		.state =3D state,
+		.inode =3D state->inode,
 	};
 	int err;
=20
@@ -4596,6 +4601,20 @@ nfs4_proc_lock(struct file *filp, int cmd, struct fi=
le_lock *request)
=20
 	if (state =3D=3D NULL)
 		return -ENOLCK;
+	/*
+	 * Don't rely on the VFS having checked the file open mode,
+	 * since it won't do this for flock() locks.
+	 */
+	switch (request->fl_type & (F_RDLCK|F_WRLCK|F_UNLCK)) {
+	case F_RDLCK:
+		if (!(filp->f_mode & FMODE_READ))
+			return -EBADF;
+		break;
+	case F_WRLCK:
+		if (!(filp->f_mode & FMODE_WRITE))
+			return -EBADF;
+	}
+
 	do {
 		status =3D nfs4_proc_setlk(state, cmd, request);
 		if ((status !=3D -EAGAIN) || IS_SETLK(cmd))
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index cfa175c..41bae32 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -324,7 +324,7 @@ out_bad:
 	while (!list_empty(res)) {
 		data =3D list_entry(res->next, struct nfs_read_data, list);
 		list_del(&data->list);
-		nfs_readdata_free(data);
+		nfs_readdata_release(data);
 	}
 	nfs_readpage_release(req);
 	return -ENOMEM;
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 3ada13c..376cd65 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2708,11 +2708,15 @@ static struct vfsmount *nfs_do_root_mount(struct fi=
le_system_type *fs_type,
 	char *root_devname;
 	size_t len;
=20
-	len =3D strlen(hostname) + 3;
+	len =3D strlen(hostname) + 5;
 	root_devname =3D kmalloc(len, GFP_KERNEL);
 	if (root_devname =3D=3D NULL)
 		return ERR_PTR(-ENOMEM);
-	snprintf(root_devname, len, "%s:/", hostname);
+	/* Does hostname needs to be enclosed in brackets? */
+	if (strchr(hostname, ':'))
+		snprintf(root_devname, len, "[%s]:/", hostname);
+	else
+		snprintf(root_devname, len, "%s:/", hostname);
 	root_mnt =3D vfs_kern_mount(fs_type, flags, root_devname, data);
 	kfree(root_devname);
 	return root_mnt;
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 1dda78d..4efd421 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -974,7 +974,7 @@ out_bad:
 	while (!list_empty(res)) {
 		data =3D list_entry(res->next, struct nfs_write_data, list);
 		list_del(&data->list);
-		nfs_writedata_free(data);
+		nfs_writedata_release(data);
 	}
 	nfs_redirty_request(req);
 	return -ENOMEM;
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 08c6e36..43f46cd 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -803,13 +803,13 @@ encode_entry_baggage(struct nfsd3_readdirres *cd, __b=
e32 *p, const char *name,
 	return p;
 }
=20
-static int
+static __be32
 compose_entry_fh(struct nfsd3_readdirres *cd, struct svc_fh *fhp,
 		const char *name, int namlen)
 {
 	struct svc_export	*exp;
 	struct dentry		*dparent, *dchild;
-	int rv =3D 0;
+	__be32 rv =3D nfserr_noent;
=20
 	dparent =3D cd->fh.fh_dentry;
 	exp  =3D cd->fh.fh_export;
@@ -817,26 +817,20 @@ compose_entry_fh(struct nfsd3_readdirres *cd, struct =
svc_fh *fhp,
 	if (isdotent(name, namlen)) {
 		if (namlen =3D=3D 2) {
 			dchild =3D dget_parent(dparent);
-			if (dchild =3D=3D dparent) {
-				/* filesystem root - cannot return filehandle for ".." */
-				dput(dchild);
-				return -ENOENT;
-			}
+			/* filesystem root - cannot return filehandle for ".." */
+			if (dchild =3D=3D dparent)
+				goto out;
 		} else
 			dchild =3D dget(dparent);
 	} else
 		dchild =3D lookup_one_len(name, dparent, namlen);
 	if (IS_ERR(dchild))
-		return -ENOENT;
-	rv =3D -ENOENT;
+		return rv;
 	if (d_mountpoint(dchild))
 		goto out;
-	rv =3D fh_compose(fhp, exp, dchild, &cd->fh);
-	if (rv)
-		goto out;
 	if (!dchild->d_inode)
 		goto out;
-	rv =3D 0;
+	rv =3D fh_compose(fhp, exp, dchild, &cd->fh);
 out:
 	dput(dchild);
 	return rv;
@@ -845,7 +839,7 @@ out:
 static __be32 *encode_entryplus_baggage(struct nfsd3_readdirres *cd, __be3=
2 *p, const char *name, int namlen)
 {
 	struct svc_fh	fh;
-	int err;
+	__be32 err;
=20
 	fh_init(&fh, NFS3_FHSIZE);
 	err =3D compose_entry_fh(cd, &fh, name, namlen);
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index fa38336..b8c5538 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -231,17 +231,17 @@ do_open_lookup(struct svc_rqst *rqstp, struct svc_fh =
*current_fh, struct nfsd4_o
 		 */
 		if (open->op_createmode =3D=3D NFS4_CREATE_EXCLUSIVE && status =3D=3D 0)
 			open->op_bmval[1] =3D (FATTR4_WORD1_TIME_ACCESS |
-						FATTR4_WORD1_TIME_MODIFY);
+							FATTR4_WORD1_TIME_MODIFY);
 	} else {
 		status =3D nfsd_lookup(rqstp, current_fh,
 				     open->op_fname.data, open->op_fname.len, &resfh);
 		fh_unlock(current_fh);
-		if (status)
-			goto out;
-		status =3D nfsd_check_obj_isreg(&resfh);
 	}
 	if (status)
 		goto out;
+	status =3D nfsd_check_obj_isreg(&resfh);
+	if (status)
+		goto out;
=20
 	if (is_create_with_attrs(open) && open->op_acl !=3D NULL)
 		do_set_nfs4_acl(rqstp, &resfh, open->op_acl, open->op_bmval);
@@ -827,6 +827,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_comp=
ound_state *cstate,
 	      struct nfsd4_setattr *setattr)
 {
 	__be32 status =3D nfs_ok;
+	int err;
=20
 	if (setattr->sa_iattr.ia_valid & ATTR_SIZE) {
 		nfs4_lock_state();
@@ -838,9 +839,9 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_comp=
ound_state *cstate,
 			return status;
 		}
 	}
-	status =3D mnt_want_write(cstate->current_fh.fh_export->ex_path.mnt);
-	if (status)
-		return status;
+	err =3D mnt_want_write(cstate->current_fh.fh_export->ex_path.mnt);
+	if (err)
+		return nfserrno(err);
 	status =3D nfs_ok;
=20
 	status =3D check_attr_support(rqstp, cstate, setattr->sa_bmval,
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 5abced7..4cfe260 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4080,16 +4080,14 @@ out:
  * vfs_test_lock.  (Arguably perhaps test_lock should be done with an
  * inode operation.)
  */
-static int nfsd_test_lock(struct svc_rqst *rqstp, struct svc_fh *fhp, stru=
ct file_lock *lock)
+static __be32 nfsd_test_lock(struct svc_rqst *rqstp, struct svc_fh *fhp, s=
truct file_lock *lock)
 {
 	struct file *file;
-	int err;
-
-	err =3D nfsd_open(rqstp, fhp, S_IFREG, NFSD_MAY_READ, &file);
-	if (err)
-		return err;
-	err =3D vfs_test_lock(file, lock);
-	nfsd_close(file);
+	__be32 err =3D nfsd_open(rqstp, fhp, S_IFREG, NFSD_MAY_READ, &file);
+	if (!err) {
+		err =3D nfserrno(vfs_test_lock(file, lock));
+		nfsd_close(file);
+	}
 	return err;
 }
=20
@@ -4103,7 +4101,6 @@ nfsd4_lockt(struct svc_rqst *rqstp, struct nfsd4_comp=
ound_state *cstate,
 	struct inode *inode;
 	struct file_lock file_lock;
 	struct nfs4_lockowner *lo;
-	int error;
 	__be32 status;
=20
 	if (locks_in_grace())
@@ -4149,12 +4146,10 @@ nfsd4_lockt(struct svc_rqst *rqstp, struct nfsd4_co=
mpound_state *cstate,
=20
 	nfs4_transform_lock_offset(&file_lock);
=20
-	status =3D nfs_ok;
-	error =3D nfsd_test_lock(rqstp, &cstate->current_fh, &file_lock);
-	if (error) {
-		status =3D nfserrno(error);
+	status =3D nfsd_test_lock(rqstp, &cstate->current_fh, &file_lock);
+	if (status)
 		goto out;
-	}
+
 	if (file_lock.fl_type !=3D F_UNLCK) {
 		status =3D nfserr_denied;
 		nfs4_set_lock_denied(&file_lock, &lockt->lt_denied);
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index b6fa792..9cfa60a 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3411,7 +3411,7 @@ nfsd4_encode_test_stateid(struct nfsd4_compoundres *r=
esp, int nfserr,
 		nfsd4_decode_stateid(argp, &si);
 		valid =3D nfs4_validate_stateid(cl, &si);
 		RESERVE_SPACE(4);
-		*p++ =3D htonl(valid);
+		*p++ =3D valid;
 		resp->p =3D p;
 	}
 	nfs4_unlock_state();
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 7a2e442..5c3cd82 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1439,7 +1439,7 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh =
*fhp,
 		switch (createmode) {
 		case NFS3_CREATE_UNCHECKED:
 			if (! S_ISREG(dchild->d_inode->i_mode))
-				err =3D nfserr_exist;
+				goto out;
 			else if (truncp) {
 				/* in nfsv4, we need to treat this case a little
 				 * differently.  we don't want to truncate the
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 3165aeb..31b9463 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1134,7 +1134,7 @@ static int ocfs2_adjust_rightmost_branch(handle_t *ha=
ndle,
 	}
=20
 	el =3D path_leaf_el(path);
-	rec =3D &el->l_recs[le32_to_cpu(el->l_next_free_rec) - 1];
+	rec =3D &el->l_recs[le16_to_cpu(el->l_next_free_rec) - 1];
=20
 	ocfs2_adjust_rightmost_records(handle, et, path, rec);
=20
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index cf78233..9f32d7c 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1036,14 +1036,14 @@ static int ocfs2_get_refcount_cpos_end(struct ocfs2=
_caching_info *ci,
=20
 	tmp_el =3D left_path->p_node[subtree_root].el;
 	blkno =3D left_path->p_node[subtree_root+1].bh->b_blocknr;
-	for (i =3D 0; i < le32_to_cpu(tmp_el->l_next_free_rec); i++) {
+	for (i =3D 0; i < le16_to_cpu(tmp_el->l_next_free_rec); i++) {
 		if (le64_to_cpu(tmp_el->l_recs[i].e_blkno) =3D=3D blkno) {
 			*cpos_end =3D le32_to_cpu(tmp_el->l_recs[i+1].e_cpos);
 			break;
 		}
 	}
=20
-	BUG_ON(i =3D=3D le32_to_cpu(tmp_el->l_next_free_rec));
+	BUG_ON(i =3D=3D le16_to_cpu(tmp_el->l_next_free_rec));
=20
 out:
 	ocfs2_free_path(left_path);
@@ -1468,7 +1468,7 @@ static int ocfs2_divide_leaf_refcount_block(struct bu=
ffer_head *ref_leaf_bh,
=20
 	trace_ocfs2_divide_leaf_refcount_block(
 		(unsigned long long)ref_leaf_bh->b_blocknr,
-		le32_to_cpu(rl->rl_count), le32_to_cpu(rl->rl_used));
+		le16_to_cpu(rl->rl_count), le16_to_cpu(rl->rl_used));
=20
 	/*
 	 * XXX: Improvement later.
@@ -2411,7 +2411,7 @@ static int ocfs2_calc_refcount_meta_credits(struct su=
per_block *sb,
 				rb =3D (struct ocfs2_refcount_block *)
 							prev_bh->b_data;
=20
-				if (le64_to_cpu(rb->rf_records.rl_used) +
+				if (le16_to_cpu(rb->rf_records.rl_used) +
 				    recs_add >
 				    le16_to_cpu(rb->rf_records.rl_count))
 					ref_blocks++;
@@ -2476,7 +2476,7 @@ static int ocfs2_calc_refcount_meta_credits(struct su=
per_block *sb,
 	if (prev_bh) {
 		rb =3D (struct ocfs2_refcount_block *)prev_bh->b_data;
=20
-		if (le64_to_cpu(rb->rf_records.rl_used) + recs_add >
+		if (le16_to_cpu(rb->rf_records.rl_used) + recs_add >
 		    le16_to_cpu(rb->rf_records.rl_count))
 			ref_blocks++;
=20
@@ -3629,7 +3629,7 @@ int ocfs2_refcounted_xattr_delete_need(struct inode *=
inode,
 			 * one will split a refcount rec, so totally we need
 			 * clusters * 2 new refcount rec.
 			 */
-			if (le64_to_cpu(rb->rf_records.rl_used) + clusters * 2 >
+			if (le16_to_cpu(rb->rf_records.rl_used) + clusters * 2 >
 			    le16_to_cpu(rb->rf_records.rl_count))
 				ref_blocks++;
=20
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index ba5d97e..f169da4 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -600,7 +600,7 @@ static void ocfs2_bg_alloc_cleanup(handle_t *handle,
 		ret =3D ocfs2_free_clusters(handle, cluster_ac->ac_inode,
 					  cluster_ac->ac_bh,
 					  le64_to_cpu(rec->e_blkno),
-					  le32_to_cpu(rec->e_leaf_clusters));
+					  le16_to_cpu(rec->e_leaf_clusters));
 		if (ret)
 			mlog_errno(ret);
 		/* Try all the clusters to free */
@@ -1628,7 +1628,7 @@ static int ocfs2_bg_discontig_fix_by_rec(struct ocfs2=
_suballoc_result *res,
 {
 	unsigned int bpc =3D le16_to_cpu(cl->cl_bpc);
 	unsigned int bitoff =3D le32_to_cpu(rec->e_cpos) * bpc;
-	unsigned int bitcount =3D le32_to_cpu(rec->e_leaf_clusters) * bpc;
+	unsigned int bitcount =3D le16_to_cpu(rec->e_leaf_clusters) * bpc;
=20
 	if (res->sr_bit_offset < bitoff)
 		return 0;
diff --git a/fs/pipe.c b/fs/pipe.c
index 4065f07..05ed5ca 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -345,6 +345,16 @@ static const struct pipe_buf_operations anon_pipe_buf_=
ops =3D {
 	.get =3D generic_pipe_buf_get,
 };
=20
+static const struct pipe_buf_operations packet_pipe_buf_ops =3D {
+	.can_merge =3D 0,
+	.map =3D generic_pipe_buf_map,
+	.unmap =3D generic_pipe_buf_unmap,
+	.confirm =3D generic_pipe_buf_confirm,
+	.release =3D anon_pipe_buf_release,
+	.steal =3D generic_pipe_buf_steal,
+	.get =3D generic_pipe_buf_get,
+};
+
 static ssize_t
 pipe_read(struct kiocb *iocb, const struct iovec *_iov,
 	   unsigned long nr_segs, loff_t pos)
@@ -406,6 +416,13 @@ redo:
 			ret +=3D chars;
 			buf->offset +=3D chars;
 			buf->len -=3D chars;
+
+			/* Was it a packet buffer? Clean up and exit */
+			if (buf->flags & PIPE_BUF_FLAG_PACKET) {
+				total_len =3D chars;
+				buf->len =3D 0;
+			}
+
 			if (!buf->len) {
 				buf->ops =3D NULL;
 				ops->release(pipe, buf);
@@ -458,6 +475,11 @@ redo:
 	return ret;
 }
=20
+static inline int is_packetized(struct file *file)
+{
+	return (file->f_flags & O_DIRECT) !=3D 0;
+}
+
 static ssize_t
 pipe_write(struct kiocb *iocb, const struct iovec *_iov,
 	    unsigned long nr_segs, loff_t ppos)
@@ -592,6 +614,11 @@ redo2:
 			buf->ops =3D &anon_pipe_buf_ops;
 			buf->offset =3D 0;
 			buf->len =3D chars;
+			buf->flags =3D 0;
+			if (is_packetized(filp)) {
+				buf->ops =3D &packet_pipe_buf_ops;
+				buf->flags =3D PIPE_BUF_FLAG_PACKET;
+			}
 			pipe->nrbufs =3D ++bufs;
 			pipe->tmp_page =3D NULL;
=20
@@ -1012,7 +1039,7 @@ struct file *create_write_pipe(int flags)
 		goto err_dentry;
 	f->f_mapping =3D inode->i_mapping;
=20
-	f->f_flags =3D O_WRONLY | (flags & O_NONBLOCK);
+	f->f_flags =3D O_WRONLY | (flags & (O_NONBLOCK | O_DIRECT));
 	f->f_version =3D 0;
=20
 	return f;
@@ -1056,7 +1083,7 @@ int do_pipe_flags(int *fd, int flags)
 	int error;
 	int fdw, fdr;
=20
-	if (flags & ~(O_CLOEXEC | O_NONBLOCK))
+	if (flags & ~(O_CLOEXEC | O_NONBLOCK | O_DIRECT))
 		return -EINVAL;
=20
 	fw =3D create_write_pipe(flags);
diff --git a/fs/splice.c b/fs/splice.c
index fa2defa..6d0dfb8 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -31,6 +31,7 @@
 #include <linux/uio.h>
 #include <linux/security.h>
 #include <linux/gfp.h>
+#include <linux/socket.h>
=20
 /*
  * Attempt to steal a page from a pipe buffer. This should perhaps go into
@@ -691,7 +692,9 @@ static int pipe_to_sendpage(struct pipe_inode_info *pip=
e,
 	if (!likely(file->f_op && file->f_op->sendpage))
 		return -EINVAL;
=20
-	more =3D (sd->flags & SPLICE_F_MORE) || sd->len < sd->total_len;
+	more =3D (sd->flags & SPLICE_F_MORE) ? MSG_MORE : 0;
+	if (sd->len < sd->total_len)
+		more |=3D MSG_SENDPAGE_NOTLAST;
 	return file->f_op->sendpage(file, buf->page, buf->offset,
 				    sd->len, &pos, more);
 }
diff --git a/include/asm-generic/statfs.h b/include/asm-generic/statfs.h
index 0fd28e0..c749af9 100644
--- a/include/asm-generic/statfs.h
+++ b/include/asm-generic/statfs.h
@@ -15,7 +15,7 @@ typedef __kernel_fsid_t	fsid_t;
  * with a 10' pole.
  */
 #ifndef __statfs_word
-#if BITS_PER_LONG =3D=3D 64
+#if __BITS_PER_LONG =3D=3D 64
 #define __statfs_word long
 #else
 #define __statfs_word __u32
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2362a0b..1328d8c 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -383,7 +383,18 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_VARIABLE_NON_VOLATILE       0x0000000000000001
 #define EFI_VARIABLE_BOOTSERVICE_ACCESS 0x0000000000000002
 #define EFI_VARIABLE_RUNTIME_ACCESS     0x0000000000000004
-
+#define EFI_VARIABLE_HARDWARE_ERROR_RECORD 0x0000000000000008
+#define EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS 0x0000000000000010
+#define EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS 0x0000000000000=
020
+#define EFI_VARIABLE_APPEND_WRITE	0x0000000000000040
+
+#define EFI_VARIABLE_MASK 	(EFI_VARIABLE_NON_VOLATILE | \
+				EFI_VARIABLE_BOOTSERVICE_ACCESS | \
+				EFI_VARIABLE_RUNTIME_ACCESS | \
+				EFI_VARIABLE_HARDWARE_ERROR_RECORD | \
+				EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS | \
+				EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS | \
+				EFI_VARIABLE_APPEND_WRITE)
 /*
  * EFI Device Path information
  */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d526231..35410ef 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -562,6 +562,7 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_so=
urce_id);
=20
 #ifdef CONFIG_IOMMU_API
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
+void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
 int kvm_iommu_map_guest(struct kvm *kvm);
 int kvm_iommu_unmap_guest(struct kvm *kvm);
 int kvm_assign_device(struct kvm *kvm,
@@ -575,6 +576,11 @@ static inline int kvm_iommu_map_pages(struct kvm *kvm,
 	return 0;
 }
=20
+static inline void kvm_iommu_unmap_pages(struct kvm *kvm,
+					 struct kvm_memory_slot *slot)
+{
+}
+
 static inline int kvm_iommu_map_guest(struct kvm *kvm)
 {
 	return -ENODEV;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a82ad4d..cbeb586 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2536,8 +2536,6 @@ extern void		net_disable_timestamp(void);
 extern void *dev_seq_start(struct seq_file *seq, loff_t *pos);
 extern void *dev_seq_next(struct seq_file *seq, void *v, loff_t *pos);
 extern void dev_seq_stop(struct seq_file *seq, void *v);
-extern int dev_seq_open_ops(struct inode *inode, struct file *file,
-			    const struct seq_operations *ops);
 #endif
=20
 extern int netdev_class_create_file(struct class_attribute *class_attr);
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 77257c9..0072a53 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -8,6 +8,7 @@
 #define PIPE_BUF_FLAG_LRU	0x01	/* page is on the LRU */
 #define PIPE_BUF_FLAG_ATOMIC	0x02	/* was atomically mapped */
 #define PIPE_BUF_FLAG_GIFT	0x04	/* page is a gift */
+#define PIPE_BUF_FLAG_PACKET	0x08	/* read() as a packet */
=20
 /**
  *	struct pipe_buffer - a linux kernel pipe buffer
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index c6db9fb..bb1fac5 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -141,7 +141,7 @@ static inline unsigned __read_seqcount_begin(const seqc=
ount_t *s)
 	unsigned ret;
=20
 repeat:
-	ret =3D s->sequence;
+	ret =3D ACCESS_ONCE(s->sequence);
 	if (unlikely(ret & 1)) {
 		cpu_relax();
 		goto repeat;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6cf8b53..e689b47 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -458,6 +458,7 @@ struct sk_buff {
 	union {
 		__u32		mark;
 		__u32		dropcount;
+		__u32		avail_size;
 	};
=20
 	__u16			vlan_tci;
@@ -1326,6 +1327,18 @@ static inline int skb_tailroom(const struct sk_buff =
*skb)
 }
=20
 /**
+ *	skb_availroom - bytes at buffer end
+ *	@skb: buffer to check
+ *
+ *	Return the number of bytes of free space at the tail of an sk_buff
+ *	allocated by sk_stream_alloc()
+ */
+static inline int skb_availroom(const struct sk_buff *skb)
+{
+	return skb_is_nonlinear(skb) ? 0 : skb->avail_size - skb->len;
+}
+
+/**
  *	skb_reserve - adjust headroom
  *	@skb: buffer to alter
  *	@len: bytes to move
diff --git a/include/linux/socket.h b/include/linux/socket.h
index d0e77f6..ad919e0 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -265,7 +265,7 @@ struct ucred {
 #define MSG_NOSIGNAL	0x4000	/* Do not generate SIGPIPE */
 #define MSG_MORE	0x8000	/* Sender will send more */
 #define MSG_WAITFORONE	0x10000	/* recvmmsg(): block until 1+ packets avail=
 */
-
+#define MSG_SENDPAGE_NOTLAST 0x20000 /* sendpage() internal : not the last=
 page */
 #define MSG_EOF         MSG_FIN
=20
 #define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exit for file
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 03354d5..64cec8d 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -128,6 +128,8 @@ struct usb_hcd {
 	unsigned		wireless:1;	/* Wireless USB HCD */
 	unsigned		authorized_default:1;
 	unsigned		has_tt:1;	/* Integrated TT in root hub */
+	unsigned		broken_pci_sleep:1;	/* Don't put the
+			controller in PCI-D3 for system sleep */
=20
 	int			irq;		/* irq allocated */
 	void __iomem		*regs;		/* device memory/io */
diff --git a/kernel/exit.c b/kernel/exit.c
index e6e01b9..5a8a66e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -819,25 +819,6 @@ static void exit_notify(struct task_struct *tsk, int g=
roup_dead)
 	if (group_dead)
 		kill_orphaned_pgrp(tsk->group_leader, NULL);
=20
-	/* Let father know we died
-	 *
-	 * Thread signals are configurable, but you aren't going to use
-	 * that to send signals to arbitrary processes.
-	 * That stops right now.
-	 *
-	 * If the parent exec id doesn't match the exec id we saved
-	 * when we started then we know the parent has changed security
-	 * domain.
-	 *
-	 * If our self_exec id doesn't match our parent_exec_id then
-	 * we have changed execution domain as these two values started
-	 * the same after a fork.
-	 */
-	if (thread_group_leader(tsk) && tsk->exit_signal !=3D SIGCHLD &&
-	    (tsk->parent_exec_id !=3D tsk->real_parent->self_exec_id ||
-	     tsk->self_exec_id !=3D tsk->parent_exec_id))
-		tsk->exit_signal =3D SIGCHLD;
-
 	if (unlikely(tsk->ptrace)) {
 		int sig =3D thread_group_leader(tsk) &&
 				thread_group_empty(tsk) &&
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 11a594c..b313086 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -52,6 +52,23 @@
=20
 #define MAP_PAGE_ENTRIES	(PAGE_SIZE / sizeof(sector_t) - 1)
=20
+/*
+ * Number of free pages that are not high.
+ */
+static inline unsigned long low_free_pages(void)
+{
+	return nr_free_pages() - nr_free_highpages();
+}
+
+/*
+ * Number of pages required to be kept free while writing the image. Alway=
s
+ * half of all available low pages before the writing starts.
+ */
+static inline unsigned long reqd_free_pages(void)
+{
+	return low_free_pages() / 2;
+}
+
 struct swap_map_page {
 	sector_t entries[MAP_PAGE_ENTRIES];
 	sector_t next_swap;
@@ -73,7 +90,7 @@ struct swap_map_handle {
 	sector_t cur_swap;
 	sector_t first_sector;
 	unsigned int k;
-	unsigned long nr_free_pages, written;
+	unsigned long reqd_free_pages;
 	u32 crc32;
 };
=20
@@ -317,8 +334,7 @@ static int get_swap_writer(struct swap_map_handle *hand=
le)
 		goto err_rel;
 	}
 	handle->k =3D 0;
-	handle->nr_free_pages =3D nr_free_pages() >> 1;
-	handle->written =3D 0;
+	handle->reqd_free_pages =3D reqd_free_pages();
 	handle->first_sector =3D handle->cur_swap;
 	return 0;
 err_rel:
@@ -353,11 +369,11 @@ static int swap_write_page(struct swap_map_handle *ha=
ndle, void *buf,
 		handle->cur_swap =3D offset;
 		handle->k =3D 0;
 	}
-	if (bio_chain && ++handle->written > handle->nr_free_pages) {
+	if (bio_chain && low_free_pages() <=3D handle->reqd_free_pages) {
 		error =3D hib_wait_on_bio_chain(bio_chain);
 		if (error)
 			goto out;
-		handle->written =3D 0;
+		handle->reqd_free_pages =3D reqd_free_pages();
 	}
  out:
 	return error;
@@ -619,7 +635,7 @@ static int save_image_lzo(struct swap_map_handle *handl=
e,
 	 * Adjust number of free pages after all allocations have been done.
 	 * We don't want to run out of pages when writing.
 	 */
-	handle->nr_free_pages =3D nr_free_pages() >> 1;
+	handle->reqd_free_pages =3D reqd_free_pages();
=20
 	/*
 	 * Start the CRC32 thread.
diff --git a/kernel/sched.c b/kernel/sched.c
index d6b149c..299f55c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3538,13 +3538,10 @@ calc_load_n(unsigned long load, unsigned long exp,
  * Once we've updated the global active value, we need to apply the expone=
ntial
  * weights adjusted to the number of cycles missed.
  */
-static void calc_global_nohz(unsigned long ticks)
+static void calc_global_nohz(void)
 {
 	long delta, active, n;
=20
-	if (time_before(jiffies, calc_load_update))
-		return;
-
 	/*
 	 * If we crossed a calc_load_update boundary, make sure to fold
 	 * any pending idle changes, the respective CPUs might have
@@ -3556,31 +3553,25 @@ static void calc_global_nohz(unsigned long ticks)
 		atomic_long_add(delta, &calc_load_tasks);
=20
 	/*
-	 * If we were idle for multiple load cycles, apply them.
+	 * It could be the one fold was all it took, we done!
 	 */
-	if (ticks >=3D LOAD_FREQ) {
-		n =3D ticks / LOAD_FREQ;
+	if (time_before(jiffies, calc_load_update + 10))
+		return;
=20
-		active =3D atomic_long_read(&calc_load_tasks);
-		active =3D active > 0 ? active * FIXED_1 : 0;
+	/*
+	 * Catch-up, fold however many we are behind still
+	 */
+	delta =3D jiffies - calc_load_update - 10;
+	n =3D 1 + (delta / LOAD_FREQ);
=20
-		avenrun[0] =3D calc_load_n(avenrun[0], EXP_1, active, n);
-		avenrun[1] =3D calc_load_n(avenrun[1], EXP_5, active, n);
-		avenrun[2] =3D calc_load_n(avenrun[2], EXP_15, active, n);
+	active =3D atomic_long_read(&calc_load_tasks);
+	active =3D active > 0 ? active * FIXED_1 : 0;
=20
-		calc_load_update +=3D n * LOAD_FREQ;
-	}
+	avenrun[0] =3D calc_load_n(avenrun[0], EXP_1, active, n);
+	avenrun[1] =3D calc_load_n(avenrun[1], EXP_5, active, n);
+	avenrun[2] =3D calc_load_n(avenrun[2], EXP_15, active, n);
=20
-	/*
-	 * Its possible the remainder of the above division also crosses
-	 * a LOAD_FREQ period, the regular check in calc_global_load()
-	 * which comes after this will take care of that.
-	 *
-	 * Consider us being 11 ticks before a cycle completion, and us
-	 * sleeping for 4*LOAD_FREQ + 22 ticks, then the above code will
-	 * age us 4 cycles, and the test in calc_global_load() will
-	 * pick up the final one.
-	 */
+	calc_load_update +=3D n * LOAD_FREQ;
 }
 #else
 static void calc_load_account_idle(struct rq *this_rq)
@@ -3592,7 +3583,7 @@ static inline long calc_load_fold_idle(void)
 	return 0;
 }
=20
-static void calc_global_nohz(unsigned long ticks)
+static void calc_global_nohz(void)
 {
 }
 #endif
@@ -3620,8 +3611,6 @@ void calc_global_load(unsigned long ticks)
 {
 	long active;
=20
-	calc_global_nohz(ticks);
-
 	if (time_before(jiffies, calc_load_update + 10))
 		return;
=20
@@ -3633,6 +3622,16 @@ void calc_global_load(unsigned long ticks)
 	avenrun[2] =3D calc_load(avenrun[2], EXP_15, active);
=20
 	calc_load_update +=3D LOAD_FREQ;
+
+	/*
+	 * Account one period with whatever state we found before
+	 * folding in the nohz state and ageing the entire idle period.
+	 *
+	 * This avoids loosing a sample when we go idle between=20
+	 * calc_load_account_active() (10 ticks ago) and now and thus
+	 * under-accounting.
+	 */
+	calc_global_nohz();
 }
=20
 /*
@@ -7605,16 +7604,26 @@ static void __sdt_free(const struct cpumask *cpu_ma=
p)
 		struct sd_data *sdd =3D &tl->data;
=20
 		for_each_cpu(j, cpu_map) {
-			struct sched_domain *sd =3D *per_cpu_ptr(sdd->sd, j);
-			if (sd && (sd->flags & SD_OVERLAP))
-				free_sched_groups(sd->groups, 0);
-			kfree(*per_cpu_ptr(sdd->sd, j));
-			kfree(*per_cpu_ptr(sdd->sg, j));
-			kfree(*per_cpu_ptr(sdd->sgp, j));
+			struct sched_domain *sd;
+
+			if (sdd->sd) {
+				sd =3D *per_cpu_ptr(sdd->sd, j);
+				if (sd && (sd->flags & SD_OVERLAP))
+					free_sched_groups(sd->groups, 0);
+				kfree(*per_cpu_ptr(sdd->sd, j));
+			}
+
+			if (sdd->sg)
+				kfree(*per_cpu_ptr(sdd->sg, j));
+			if (sdd->sgp)
+				kfree(*per_cpu_ptr(sdd->sgp, j));
 		}
 		free_percpu(sdd->sd);
+		sdd->sd =3D NULL;
 		free_percpu(sdd->sg);
+		sdd->sg =3D NULL;
 		free_percpu(sdd->sgp);
+		sdd->sgp =3D NULL;
 	}
 }
=20
diff --git a/kernel/signal.c b/kernel/signal.c
index 2065515..08e0b97 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1610,6 +1610,15 @@ bool do_notify_parent(struct task_struct *tsk, int s=
ig)
 	BUG_ON(!tsk->ptrace &&
 	       (tsk->group_leader !=3D tsk || !thread_group_empty(tsk)));
=20
+	if (sig !=3D SIGCHLD) {
+		/*
+		 * This is only possible if parent =3D=3D real_parent.
+		 * Check if it has changed security domain.
+		 */
+		if (tsk->parent_exec_id !=3D tsk->parent->self_exec_id)
+			sig =3D SIGCHLD;
+	}
+
 	info.si_signo =3D sig;
 	info.si_errno =3D 0;
 	/*
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 5199930..1dcf253 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -638,6 +638,8 @@ int trace_print_lat_context(struct trace_iterator *iter=
)
 {
 	u64 next_ts;
 	int ret;
+	/* trace_find_next_entry will reset ent_size */
+	int ent_size =3D iter->ent_size;
 	struct trace_seq *s =3D &iter->seq;
 	struct trace_entry *entry =3D iter->ent,
 			   *next_entry =3D trace_find_next_entry(iter, NULL,
@@ -646,6 +648,9 @@ int trace_print_lat_context(struct trace_iterator *iter=
)
 	unsigned long abs_usecs =3D ns2usecs(iter->ts - iter->tr->time_start);
 	unsigned long rel_usecs;
=20
+	/* Restore the original ent_size */
+	iter->ent_size =3D ent_size;
+
 	if (!next_entry)
 		next_ts =3D iter->ts;
 	rel_usecs =3D ns2usecs(next_ts - iter->ts);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 78cc4d1..7704d9c 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -27,7 +27,7 @@
  */
 static const struct address_space_operations swap_aops =3D {
 	.writepage	=3D swap_writepage,
-	.set_page_dirty	=3D __set_page_dirty_nobuffers,
+	.set_page_dirty	=3D __set_page_dirty_no_writeback,
 	.migratepage	=3D migrate_page,
 };
=20
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index e7c69f4..b04a6ef 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -2006,16 +2006,17 @@ static void __exit ax25_exit(void)
 	proc_net_remove(&init_net, "ax25_route");
 	proc_net_remove(&init_net, "ax25");
 	proc_net_remove(&init_net, "ax25_calls");
-	ax25_rt_free();
-	ax25_uid_free();
-	ax25_dev_free();
=20
-	ax25_unregister_sysctl();
 	unregister_netdevice_notifier(&ax25_dev_notifier);
+	ax25_unregister_sysctl();
=20
 	dev_remove_pack(&ax25_packet_type);
=20
 	sock_unregister(PF_AX25);
 	proto_unregister(&ax25_proto);
+
+	ax25_rt_free();
+	ax25_uid_free();
+	ax25_dev_free();
 }
 module_exit(ax25_exit);
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 8eb6b15..5ac1811 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -241,7 +241,6 @@ static void br_multicast_group_expired(unsigned long da=
ta)
 	hlist_del_rcu(&mp->hlist[mdb->ver]);
 	mdb->size--;
=20
-	del_timer(&mp->query_timer);
 	call_rcu_bh(&mp->rcu, br_multicast_free_group);
=20
 out:
@@ -271,7 +270,6 @@ static void br_multicast_del_pg(struct net_bridge *br,
 		rcu_assign_pointer(*pp, p->next);
 		hlist_del_init(&p->mglist);
 		del_timer(&p->timer);
-		del_timer(&p->query_timer);
 		call_rcu_bh(&p->rcu, br_multicast_free_pg);
=20
 		if (!mp->ports && !mp->mglist &&
@@ -507,74 +505,6 @@ static struct sk_buff *br_multicast_alloc_query(struct=
 net_bridge *br,
 	return NULL;
 }
=20
-static void br_multicast_send_group_query(struct net_bridge_mdb_entry *mp)
-{
-	struct net_bridge *br =3D mp->br;
-	struct sk_buff *skb;
-
-	skb =3D br_multicast_alloc_query(br, &mp->addr);
-	if (!skb)
-		goto timer;
-
-	netif_rx(skb);
-
-timer:
-	if (++mp->queries_sent < br->multicast_last_member_count)
-		mod_timer(&mp->query_timer,
-			  jiffies + br->multicast_last_member_interval);
-}
-
-static void br_multicast_group_query_expired(unsigned long data)
-{
-	struct net_bridge_mdb_entry *mp =3D (void *)data;
-	struct net_bridge *br =3D mp->br;
-
-	spin_lock(&br->multicast_lock);
-	if (!netif_running(br->dev) || !mp->mglist ||
-	    mp->queries_sent >=3D br->multicast_last_member_count)
-		goto out;
-
-	br_multicast_send_group_query(mp);
-
-out:
-	spin_unlock(&br->multicast_lock);
-}
-
-static void br_multicast_send_port_group_query(struct net_bridge_port_grou=
p *pg)
-{
-	struct net_bridge_port *port =3D pg->port;
-	struct net_bridge *br =3D port->br;
-	struct sk_buff *skb;
-
-	skb =3D br_multicast_alloc_query(br, &pg->addr);
-	if (!skb)
-		goto timer;
-
-	br_deliver(port, skb);
-
-timer:
-	if (++pg->queries_sent < br->multicast_last_member_count)
-		mod_timer(&pg->query_timer,
-			  jiffies + br->multicast_last_member_interval);
-}
-
-static void br_multicast_port_group_query_expired(unsigned long data)
-{
-	struct net_bridge_port_group *pg =3D (void *)data;
-	struct net_bridge_port *port =3D pg->port;
-	struct net_bridge *br =3D port->br;
-
-	spin_lock(&br->multicast_lock);
-	if (!netif_running(br->dev) || hlist_unhashed(&pg->mglist) ||
-	    pg->queries_sent >=3D br->multicast_last_member_count)
-		goto out;
-
-	br_multicast_send_port_group_query(pg);
-
-out:
-	spin_unlock(&br->multicast_lock);
-}
-
 static struct net_bridge_mdb_entry *br_multicast_get_group(
 	struct net_bridge *br, struct net_bridge_port *port,
 	struct br_ip *group, int hash)
@@ -690,8 +620,6 @@ rehash:
 	mp->addr =3D *group;
 	setup_timer(&mp->timer, br_multicast_group_expired,
 		    (unsigned long)mp);
-	setup_timer(&mp->query_timer, br_multicast_group_query_expired,
-		    (unsigned long)mp);
=20
 	hlist_add_head_rcu(&mp->hlist[mdb->ver], &mdb->mhash[hash]);
 	mdb->size++;
@@ -746,8 +674,6 @@ static int br_multicast_add_group(struct net_bridge *br=
,
 	hlist_add_head(&p->mglist, &port->mglist);
 	setup_timer(&p->timer, br_multicast_port_group_expired,
 		    (unsigned long)p);
-	setup_timer(&p->query_timer, br_multicast_port_group_query_expired,
-		    (unsigned long)p);
=20
 	rcu_assign_pointer(*pp, p);
=20
@@ -1291,9 +1217,6 @@ static void br_multicast_leave_group(struct net_bridg=
e *br,
 		     time_after(mp->timer.expires, time) :
 		     try_to_del_timer_sync(&mp->timer) >=3D 0)) {
 			mod_timer(&mp->timer, time);
-
-			mp->queries_sent =3D 0;
-			mod_timer(&mp->query_timer, now);
 		}
=20
 		goto out;
@@ -1310,9 +1233,6 @@ static void br_multicast_leave_group(struct net_bridg=
e *br,
 		     time_after(p->timer.expires, time) :
 		     try_to_del_timer_sync(&p->timer) >=3D 0)) {
 			mod_timer(&p->timer, time);
-
-			p->queries_sent =3D 0;
-			mod_timer(&p->query_timer, now);
 		}
=20
 		break;
@@ -1680,7 +1600,6 @@ void br_multicast_stop(struct net_bridge *br)
 		hlist_for_each_entry_safe(mp, p, n, &mdb->mhash[i],
 					  hlist[ver]) {
 			del_timer(&mp->timer);
-			del_timer(&mp->query_timer);
 			call_rcu_bh(&mp->rcu, br_multicast_free_group);
 		}
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index d7d6fb0..93264df 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -82,9 +82,7 @@ struct net_bridge_port_group {
 	struct hlist_node		mglist;
 	struct rcu_head			rcu;
 	struct timer_list		timer;
-	struct timer_list		query_timer;
 	struct br_ip			addr;
-	u32				queries_sent;
 };
=20
 struct net_bridge_mdb_entry
@@ -94,10 +92,8 @@ struct net_bridge_mdb_entry
 	struct net_bridge_port_group __rcu *ports;
 	struct rcu_head			rcu;
 	struct timer_list		timer;
-	struct timer_list		query_timer;
 	struct br_ip			addr;
 	bool				mglist;
-	u32				queries_sent;
 };
=20
 struct net_bridge_mdb_htable
diff --git a/net/core/dev.c b/net/core/dev.c
index 55cd370..cd5050e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4102,54 +4102,41 @@ static int dev_ifconf(struct net *net, char __user =
*arg)
=20
 #ifdef CONFIG_PROC_FS
=20
-#define BUCKET_SPACE (32 - NETDEV_HASHBITS)
-
-struct dev_iter_state {
-	struct seq_net_private p;
-	unsigned int pos; /* bucket << BUCKET_SPACE + offset */
-};
+#define BUCKET_SPACE (32 - NETDEV_HASHBITS - 1)
=20
 #define get_bucket(x) ((x) >> BUCKET_SPACE)
 #define get_offset(x) ((x) & ((1 << BUCKET_SPACE) - 1))
 #define set_bucket_offset(b, o) ((b) << BUCKET_SPACE | (o))
=20
-static inline struct net_device *dev_from_same_bucket(struct seq_file *seq=
)
+static inline struct net_device *dev_from_same_bucket(struct seq_file *seq=
, loff_t *pos)
 {
-	struct dev_iter_state *state =3D seq->private;
 	struct net *net =3D seq_file_net(seq);
 	struct net_device *dev;
 	struct hlist_node *p;
 	struct hlist_head *h;
-	unsigned int count, bucket, offset;
+	unsigned int count =3D 0, offset =3D get_offset(*pos);
=20
-	bucket =3D get_bucket(state->pos);
-	offset =3D get_offset(state->pos);
-	h =3D &net->dev_name_head[bucket];
-	count =3D 0;
+	h =3D &net->dev_name_head[get_bucket(*pos)];
 	hlist_for_each_entry_rcu(dev, p, h, name_hlist) {
-		if (count++ =3D=3D offset) {
-			state->pos =3D set_bucket_offset(bucket, count);
+		if (++count =3D=3D offset)
 			return dev;
-		}
 	}
=20
 	return NULL;
 }
=20
-static inline struct net_device *dev_from_new_bucket(struct seq_file *seq)
+static inline struct net_device *dev_from_bucket(struct seq_file *seq, lof=
f_t *pos)
 {
-	struct dev_iter_state *state =3D seq->private;
 	struct net_device *dev;
 	unsigned int bucket;
=20
-	bucket =3D get_bucket(state->pos);
 	do {
-		dev =3D dev_from_same_bucket(seq);
+		dev =3D dev_from_same_bucket(seq, pos);
 		if (dev)
 			return dev;
=20
-		bucket++;
-		state->pos =3D set_bucket_offset(bucket, 0);
+		bucket =3D get_bucket(*pos) + 1;
+		*pos =3D set_bucket_offset(bucket, 1);
 	} while (bucket < NETDEV_HASHENTRIES);
=20
 	return NULL;
@@ -4162,33 +4149,20 @@ static inline struct net_device *dev_from_new_bucke=
t(struct seq_file *seq)
 void *dev_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(RCU)
 {
-	struct dev_iter_state *state =3D seq->private;
-
 	rcu_read_lock();
 	if (!*pos)
 		return SEQ_START_TOKEN;
=20
-	/* check for end of the hash */
-	if (state->pos =3D=3D 0 && *pos > 1)
+	if (get_bucket(*pos) >=3D NETDEV_HASHENTRIES)
 		return NULL;
=20
-	return dev_from_new_bucket(seq);
+	return dev_from_bucket(seq, pos);
 }
=20
 void *dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct net_device *dev;
-
 	++*pos;
-
-	if (v =3D=3D SEQ_START_TOKEN)
-		return dev_from_new_bucket(seq);
-
-	dev =3D dev_from_same_bucket(seq);
-	if (dev)
-		return dev;
-
-	return dev_from_new_bucket(seq);
+	return dev_from_bucket(seq, pos);
 }
=20
 void dev_seq_stop(struct seq_file *seq, void *v)
@@ -4287,13 +4261,7 @@ static const struct seq_operations dev_seq_ops =3D {
 static int dev_seq_open(struct inode *inode, struct file *file)
 {
 	return seq_open_net(inode, file, &dev_seq_ops,
-			    sizeof(struct dev_iter_state));
-}
-
-int dev_seq_open_ops(struct inode *inode, struct file *file,
-		     const struct seq_operations *ops)
-{
-	return seq_open_net(inode, file, ops, sizeof(struct dev_iter_state));
+			    sizeof(struct seq_net_private));
 }
=20
 static const struct file_operations dev_seq_fops =3D {
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index febba51..277faef 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -696,7 +696,8 @@ static const struct seq_operations dev_mc_seq_ops =3D {
=20
 static int dev_mc_seq_open(struct inode *inode, struct file *file)
 {
-	return dev_seq_open_ops(inode, file, &dev_mc_seq_ops);
+	return seq_open_net(inode, file, &dev_mc_seq_ops,
+			    sizeof(struct seq_net_private));
 }
=20
 static const struct file_operations dev_mc_seq_fops =3D {
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 0e950fd..31a5ae5 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -83,21 +83,29 @@ assign:
=20
 static int ops_init(const struct pernet_operations *ops, struct net *net)
 {
-	int err;
+	int err =3D -ENOMEM;
+	void *data =3D NULL;
+
 	if (ops->id && ops->size) {
-		void *data =3D kzalloc(ops->size, GFP_KERNEL);
+		data =3D kzalloc(ops->size, GFP_KERNEL);
 		if (!data)
-			return -ENOMEM;
+			goto out;
=20
 		err =3D net_assign_generic(net, *ops->id, data);
-		if (err) {
-			kfree(data);
-			return err;
-		}
+		if (err)
+			goto cleanup;
 	}
+	err =3D 0;
 	if (ops->init)
-		return ops->init(net);
-	return 0;
+		err =3D ops->init(net);
+	if (!err)
+		return 0;
+
+cleanup:
+	kfree(data);
+
+out:
+	return err;
 }
=20
 static void ops_free(const struct pernet_operations *ops, struct net *net)
@@ -448,12 +456,7 @@ static void __unregister_pernet_operations(struct pern=
et_operations *ops)
 static int __register_pernet_operations(struct list_head *list,
 					struct pernet_operations *ops)
 {
-	int err =3D 0;
-	err =3D ops_init(ops, &init_net);
-	if (err)
-		ops_free(ops, &init_net);
-	return err;
-=09
+	return ops_init(ops, &init_net);
 }
=20
 static void __unregister_pernet_operations(struct pernet_operations *ops)
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3c30ee4..2ec200de 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -903,9 +903,11 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, i=
nt ntail,
 		goto adjust_others;
 	}
=20
-	data =3D kmalloc(size + sizeof(struct skb_shared_info), gfp_mask);
+	data =3D kmalloc(size + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
+		       gfp_mask);
 	if (!data)
 		goto nodata;
+	size =3D SKB_WITH_OVERHEAD(ksize(data));
=20
 	/* Copy only real data... and, alas, header. This should be
 	 * optimized for the cases when header is void.
@@ -3111,6 +3113,8 @@ static void sock_rmem_free(struct sk_buff *skb)
  */
 int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
 {
+	int len =3D skb->len;
+
 	if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=3D
 	    (unsigned)sk->sk_rcvbuf)
 		return -ENOMEM;
@@ -3125,7 +3129,7 @@ int sock_queue_err_skb(struct sock *sk, struct sk_buf=
f *skb)
=20
 	skb_queue_tail(&sk->sk_error_queue, skb);
 	if (!sock_flag(sk, SOCK_DEAD))
-		sk->sk_data_ready(sk, skb->len);
+		sk->sk_data_ready(sk, len);
 	return 0;
 }
 EXPORT_SYMBOL(sock_queue_err_skb);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 34f5db1..7904db4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -701,11 +701,12 @@ struct sk_buff *sk_stream_alloc_skb(struct sock *sk, =
int size, gfp_t gfp)
 	skb =3D alloc_skb_fclone(size + sk->sk_prot->max_header, gfp);
 	if (skb) {
 		if (sk_wmem_schedule(sk, skb->truesize)) {
+			skb_reserve(skb, sk->sk_prot->max_header);
 			/*
 			 * Make sure that we have exactly size bytes
 			 * available to the caller, no more, no less.
 			 */
-			skb_reserve(skb, skb_tailroom(skb) - size);
+			skb->avail_size =3D size;
 			return skb;
 		}
 		__kfree_skb(skb);
@@ -860,7 +861,7 @@ wait_for_memory:
 	}
=20
 out:
-	if (copied)
+	if (copied && !(flags & MSG_SENDPAGE_NOTLAST))
 		tcp_push(sk, flags, mss_now, tp->nonagle);
 	return copied;
=20
@@ -995,10 +996,9 @@ new_segment:
 				copy =3D seglen;
=20
 			/* Where to copy to? */
-			if (skb_tailroom(skb) > 0) {
+			if (skb_availroom(skb) > 0) {
 				/* We have some space in skb head. Superb! */
-				if (copy > skb_tailroom(skb))
-					copy =3D skb_tailroom(skb);
+				copy =3D min_t(int, copy, skb_availroom(skb));
 				err =3D skb_add_data_nocache(sk, skb, from, copy);
 				if (err)
 					goto do_fault;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e4d1e4a..daedc07 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -334,6 +334,7 @@ static void tcp_grow_window(struct sock *sk, const stru=
ct sk_buff *skb)
 			incr =3D __tcp_grow_window(sk, skb);
=20
 		if (incr) {
+			incr =3D max_t(int, incr, 2 * skb->len);
 			tp->rcv_ssthresh =3D min(tp->rcv_ssthresh + incr,
 					       tp->window_clamp);
 			inet_csk(sk)->icsk_ack.quick |=3D 1;
@@ -473,8 +474,11 @@ static void tcp_rcv_rtt_update(struct tcp_sock *tp, u3=
2 sample, int win_dep)
 		if (!win_dep) {
 			m -=3D (new_sample >> 3);
 			new_sample +=3D m;
-		} else if (m < new_sample)
-			new_sample =3D m << 3;
+		} else {
+			m <<=3D 3;
+			if (m < new_sample)
+				new_sample =3D m;
+		}
 	} else {
 		/* No previous measure. */
 		new_sample =3D m << 3;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 097e0c7..c51dd5b 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1093,6 +1093,14 @@ static void __pskb_trim_head(struct sk_buff *skb, in=
t len)
 {
 	int i, k, eat;
=20
+	eat =3D min_t(int, len, skb_headlen(skb));
+	if (eat) {
+		__skb_pull(skb, eat);
+		skb->avail_size -=3D eat;
+		len -=3D eat;
+		if (!len)
+			return;
+	}
 	eat =3D len;
 	k =3D 0;
 	for (i =3D 0; i < skb_shinfo(skb)->nr_frags; i++) {
@@ -1124,11 +1132,7 @@ int tcp_trim_head(struct sock *sk, struct sk_buff *s=
kb, u32 len)
 	if (skb_cloned(skb) && pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
 		return -ENOMEM;
=20
-	/* If len =3D=3D headlen, we avoid __skb_pull to preserve alignment. */
-	if (unlikely(len < skb_headlen(skb)))
-		__skb_pull(skb, len);
-	else
-		__pskb_trim_head(skb, len - skb_headlen(skb));
+	__pskb_trim_head(skb, len);
=20
 	TCP_SKB_CB(skb)->seq +=3D len;
 	skb->ip_summed =3D CHECKSUM_PARTIAL;
@@ -2057,7 +2061,7 @@ static void tcp_retrans_try_collapse(struct sock *sk,=
 struct sk_buff *to,
 		/* Punt if not enough space exists in the first SKB for
 		 * the data in the second
 		 */
-		if (skb->len > skb_tailroom(to))
+		if (skb->len > skb_availroom(to))
 			break;
=20
 		if (after(TCP_SKB_CB(skb)->end_seq, tcp_wnd_end(tp)))
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 2257366..f2d74ea 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2054,7 +2054,7 @@ static int ip6_mc_add_src(struct inet6_dev *idev, con=
st struct in6_addr *pmca,
 		if (!delta)
 			pmc->mca_sfcount[sfmode]--;
 		for (j=3D0; j<i; j++)
-			(void) ip6_mc_del1_src(pmc, sfmode, &psfsrc[i]);
+			ip6_mc_del1_src(pmc, sfmode, &psfsrc[j]);
 	} else if (isexclude !=3D (pmc->mca_sfcount[MCAST_EXCLUDE] !=3D 0)) {
 		struct ip6_sf_list *psf;
=20
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index b859e4a..4a56574 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1494,6 +1494,10 @@ static struct sock * tcp_v6_syn_recv_sock(struct soc=
k *sk, struct sk_buff *skb,
 	tcp_mtup_init(newsk);
 	tcp_sync_mss(newsk, dst_mtu(dst));
 	newtp->advmss =3D dst_metric_advmss(dst);
+	if (tcp_sk(sk)->rx_opt.user_mss &&
+	    tcp_sk(sk)->rx_opt.user_mss < newtp->advmss)
+		newtp->advmss =3D tcp_sk(sk)->rx_opt.user_mss;
+
 	tcp_initialize_rcv_mss(newsk);
 	if (tcp_rsk(req)->snt_synack)
 		tcp_valid_rtt_meas(newsk,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index eff1f4e..4ff35bf 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1121,7 +1121,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sd=
ata,
 		tx->sta =3D rcu_dereference(sdata->u.vlan.sta);
 		if (!tx->sta && sdata->dev->ieee80211_ptr->use_4addr)
 			return TX_DROP;
-	} else if (info->flags & IEEE80211_TX_CTL_INJECTED) {
+	} else if (info->flags & IEEE80211_TX_CTL_INJECTED ||
+		   tx->sdata->control_port_protocol =3D=3D tx->skb->protocol) {
 		tx->sta =3D sta_info_get_bss(sdata, hdr->addr1);
 	}
 	if (!tx->sta)
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 1201b6d..a99fb41 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -830,12 +830,19 @@ int netlink_attachskb(struct sock *sk, struct sk_buff=
 *skb,
 	return 0;
 }
=20
-int netlink_sendskb(struct sock *sk, struct sk_buff *skb)
+static int __netlink_sendskb(struct sock *sk, struct sk_buff *skb)
 {
 	int len =3D skb->len;
=20
 	skb_queue_tail(&sk->sk_receive_queue, skb);
 	sk->sk_data_ready(sk, len);
+	return len;
+}
+
+int netlink_sendskb(struct sock *sk, struct sk_buff *skb)
+{
+	int len =3D __netlink_sendskb(sk, skb);
+
 	sock_put(sk);
 	return len;
 }
@@ -960,8 +967,7 @@ static inline int netlink_broadcast_deliver(struct sock=
 *sk,
 	if (atomic_read(&sk->sk_rmem_alloc) <=3D sk->sk_rcvbuf &&
 	    !test_bit(0, &nlk->state)) {
 		skb_set_owner_r(skb, sk);
-		skb_queue_tail(&sk->sk_receive_queue, skb);
-		sk->sk_data_ready(sk, skb->len);
+		__netlink_sendskb(sk, skb);
 		return atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf;
 	}
 	return -1;
@@ -1684,10 +1690,8 @@ static int netlink_dump(struct sock *sk)
=20
 		if (sk_filter(sk, skb))
 			kfree_skb(skb);
-		else {
-			skb_queue_tail(&sk->sk_receive_queue, skb);
-			sk->sk_data_ready(sk, skb->len);
-		}
+		else
+			__netlink_sendskb(sk, skb);
 		return 0;
 	}
=20
@@ -1701,10 +1705,8 @@ static int netlink_dump(struct sock *sk)
=20
 	if (sk_filter(sk, skb))
 		kfree_skb(skb);
-	else {
-		skb_queue_tail(&sk->sk_receive_queue, skb);
-		sk->sk_data_ready(sk, skb->len);
-	}
+	else
+		__netlink_sendskb(sk, skb);
=20
 	if (cb->done)
 		cb->done(cb);
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 2ba6e9f..007546d 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -1046,6 +1046,9 @@ static int pep_sendmsg(struct kiocb *iocb, struct soc=
k *sk,
 	int flags =3D msg->msg_flags;
 	int err, done;
=20
+	if (len > USHRT_MAX)
+		return -EMSGSIZE;
+
 	if ((msg->msg_flags & ~(MSG_DONTWAIT|MSG_EOR|MSG_NOSIGNAL|
 				MSG_CMSG_COMPAT)) ||
 			!(msg->msg_flags & MSG_EOR))
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 6cd8ddf..e1afe0c 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -544,11 +544,8 @@ static int gred_dump(struct Qdisc *sch, struct sk_buff=
 *skb)
 		opt.packets	=3D q->packetsin;
 		opt.bytesin	=3D q->bytesin;
=20
-		if (gred_wred_mode(table)) {
-			q->parms.qidlestart =3D
-				table->tab[table->def]->parms.qidlestart;
-			q->parms.qavg =3D table->tab[table->def]->parms.qavg;
-		}
+		if (gred_wred_mode(table))
+			gred_load_wred_set(table, q);
=20
 		opt.qave =3D red_calc_qavg(&q->parms, q->parms.qavg);
=20
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 54a7cd2..0075554 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4133,9 +4133,10 @@ static int sctp_getsockopt_disable_fragments(struct =
sock *sk, int len,
 static int sctp_getsockopt_events(struct sock *sk, int len, char __user *o=
ptval,
 				  int __user *optlen)
 {
-	if (len < sizeof(struct sctp_event_subscribe))
+	if (len <=3D 0)
 		return -EINVAL;
-	len =3D sizeof(struct sctp_event_subscribe);
+	if (len > sizeof(struct sctp_event_subscribe))
+		len =3D sizeof(struct sctp_event_subscribe);
 	if (put_user(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &sctp_sk(sk)->subscribe, len))
diff --git a/net/socket.c b/net/socket.c
index 2dce67a..273cbce 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -791,9 +791,9 @@ static ssize_t sock_sendpage(struct file *file, struct =
page *page,
=20
 	sock =3D file->private_data;
=20
-	flags =3D !(file->f_flags & O_NONBLOCK) ? 0 : MSG_DONTWAIT;
-	if (more)
-		flags |=3D MSG_MORE;
+	flags =3D (file->f_flags & O_NONBLOCK) ? MSG_DONTWAIT : 0;
+	/* more is a combination of MSG_MORE and MSG_SENDPAGE_NOTLAST */
+	flags |=3D more;
=20
 	return kernel_sendpage(sock, page, offset, size, flags);
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ffafda5..c06c365 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1258,6 +1258,11 @@ static int nl80211_set_wiphy(struct sk_buff *skb, st=
ruct genl_info *info)
 			goto bad_res;
 		}
=20
+		if (!netif_running(netdev)) {
+			result =3D -ENETDOWN;
+			goto bad_res;
+		}
+
 		nla_for_each_nested(nl_txq_params,
 				    info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS],
 				    rem_txq_params) {
@@ -5944,7 +5949,7 @@ static struct genl_ops nl80211_ops[] =3D {
 		.doit =3D nl80211_get_key,
 		.policy =3D nl80211_policy,
 		.flags =3D GENL_ADMIN_PERM,
-		.internal_flags =3D NL80211_FLAG_NEED_NETDEV |
+		.internal_flags =3D NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -5976,7 +5981,7 @@ static struct genl_ops nl80211_ops[] =3D {
 		.policy =3D nl80211_policy,
 		.flags =3D GENL_ADMIN_PERM,
 		.doit =3D nl80211_addset_beacon,
-		.internal_flags =3D NL80211_FLAG_NEED_NETDEV |
+		.internal_flags =3D NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -5984,7 +5989,7 @@ static struct genl_ops nl80211_ops[] =3D {
 		.policy =3D nl80211_policy,
 		.flags =3D GENL_ADMIN_PERM,
 		.doit =3D nl80211_addset_beacon,
-		.internal_flags =3D NL80211_FLAG_NEED_NETDEV |
+		.internal_flags =3D NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6008,7 +6013,7 @@ static struct genl_ops nl80211_ops[] =3D {
 		.doit =3D nl80211_set_station,
 		.policy =3D nl80211_policy,
 		.flags =3D GENL_ADMIN_PERM,
-		.internal_flags =3D NL80211_FLAG_NEED_NETDEV |
+		.internal_flags =3D NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6024,7 +6029,7 @@ static struct genl_ops nl80211_ops[] =3D {
 		.doit =3D nl80211_del_station,
 		.policy =3D nl80211_policy,
 		.flags =3D GENL_ADMIN_PERM,
-		.internal_flags =3D NL80211_FLAG_NEED_NETDEV |
+		.internal_flags =3D NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6057,7 +6062,7 @@ static struct genl_ops nl80211_ops[] =3D {
 		.doit =3D nl80211_del_mpath,
 		.policy =3D nl80211_policy,
 		.flags =3D GENL_ADMIN_PERM,
-		.internal_flags =3D NL80211_FLAG_NEED_NETDEV |
+		.internal_flags =3D NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6065,7 +6070,7 @@ static struct genl_ops nl80211_ops[] =3D {
 		.doit =3D nl80211_set_bss,
 		.policy =3D nl80211_policy,
 		.flags =3D GENL_ADMIN_PERM,
-		.internal_flags =3D NL80211_FLAG_NEED_NETDEV |
+		.internal_flags =3D NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6091,7 +6096,7 @@ static struct genl_ops nl80211_ops[] =3D {
 		.doit =3D nl80211_get_mesh_config,
 		.policy =3D nl80211_policy,
 		/* can be retrieved by unprivileged users */
-		.internal_flags =3D NL80211_FLAG_NEED_NETDEV |
+		.internal_flags =3D NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6224,7 +6229,7 @@ static struct genl_ops nl80211_ops[] =3D {
 		.doit =3D nl80211_setdel_pmksa,
 		.policy =3D nl80211_policy,
 		.flags =3D GENL_ADMIN_PERM,
-		.internal_flags =3D NL80211_FLAG_NEED_NETDEV |
+		.internal_flags =3D NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6232,7 +6237,7 @@ static struct genl_ops nl80211_ops[] =3D {
 		.doit =3D nl80211_setdel_pmksa,
 		.policy =3D nl80211_policy,
 		.flags =3D GENL_ADMIN_PERM,
-		.internal_flags =3D NL80211_FLAG_NEED_NETDEV |
+		.internal_flags =3D NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6240,7 +6245,7 @@ static struct genl_ops nl80211_ops[] =3D {
 		.doit =3D nl80211_flush_pmksa,
 		.policy =3D nl80211_policy,
 		.flags =3D GENL_ADMIN_PERM,
-		.internal_flags =3D NL80211_FLAG_NEED_NETDEV |
+		.internal_flags =3D NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6328,7 +6333,7 @@ static struct genl_ops nl80211_ops[] =3D {
 		.doit =3D nl80211_set_wds_peer,
 		.policy =3D nl80211_policy,
 		.flags =3D GENL_ADMIN_PERM,
-		.internal_flags =3D NL80211_FLAG_NEED_NETDEV |
+		.internal_flags =3D NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 4dde429..8bf8902 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -996,7 +996,7 @@ int cfg80211_can_change_interface(struct cfg80211_regis=
tered_device *rdev,
 			if (rdev->wiphy.software_iftypes & BIT(iftype))
 				continue;
 			for (j =3D 0; j < c->n_limits; j++) {
-				if (!(limits[j].types & iftype))
+				if (!(limits[j].types & BIT(iftype)))
 					continue;
 				if (limits[j].max < num[iftype])
 					goto cont;
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index f936d1f..d1d0ae8 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -926,6 +926,10 @@ void handle_moddevtable(struct module *mod, struct elf=
_info *info,
 	if (!sym->st_shndx || get_secindex(info, sym) >=3D info->num_sections)
 		return;
=20
+	/* We're looking for an object */
+	if (ELF_ST_TYPE(sym->st_info) !=3D STT_OBJECT)
+		return;
+
 	/* Handle all-NULL symbols allocated into .bss */
 	if (info->sechdrs[get_secindex(info, sym)].sh_type & SHT_NOBITS) {
 		zeros =3D calloc(1, sym->st_size);
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.=
c
index ae94929..51a1afc 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4003,9 +4003,14 @@ static void cx_auto_init_output(struct hda_codec *co=
dec)
 	int i;
=20
 	mute_outputs(codec, spec->multiout.num_dacs, spec->multiout.dac_nids);
-	for (i =3D 0; i < cfg->hp_outs; i++)
+	for (i =3D 0; i < cfg->hp_outs; i++) {
+		unsigned int val =3D PIN_OUT;
+		if (snd_hda_query_pin_caps(codec, cfg->hp_pins[i]) &
+		    AC_PINCAP_HP_DRV)
+			val |=3D AC_PINCTL_HP_EN;
 		snd_hda_codec_write(codec, cfg->hp_pins[i], 0,
-				    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_HP);
+				    AC_VERB_SET_PIN_WIDGET_CONTROL, val);
+	}
 	mute_outputs(codec, cfg->hp_outs, cfg->hp_pins);
 	mute_outputs(codec, cfg->line_outs, cfg->line_out_pins);
 	mute_outputs(codec, cfg->speaker_outs, cfg->speaker_pins);
@@ -4408,8 +4413,10 @@ static void apply_pin_fixup(struct hda_codec *codec,
=20
 enum {
 	CXT_PINCFG_LENOVO_X200,
+	CXT_PINCFG_LENOVO_TP410,
 };
=20
+/* ThinkPad X200 & co with cxt5051 */
 static const struct cxt_pincfg cxt_pincfg_lenovo_x200[] =3D {
 	{ 0x16, 0x042140ff }, /* HP (seq# overridden) */
 	{ 0x17, 0x21a11000 }, /* dock-mic */
@@ -4417,15 +4424,33 @@ static const struct cxt_pincfg cxt_pincfg_lenovo_x2=
00[] =3D {
 	{}
 };
=20
+/* ThinkPad 410/420/510/520, X201 & co with cxt5066 */
+static const struct cxt_pincfg cxt_pincfg_lenovo_tp410[] =3D {
+	{ 0x19, 0x042110ff }, /* HP (seq# overridden) */
+	{ 0x1a, 0x21a190f0 }, /* dock-mic */
+	{ 0x1c, 0x212140ff }, /* dock-HP */
+	{}
+};
+
 static const struct cxt_pincfg *cxt_pincfg_tbl[] =3D {
 	[CXT_PINCFG_LENOVO_X200] =3D cxt_pincfg_lenovo_x200,
+	[CXT_PINCFG_LENOVO_TP410] =3D cxt_pincfg_lenovo_tp410,
 };
=20
-static const struct snd_pci_quirk cxt_fixups[] =3D {
+static const struct snd_pci_quirk cxt5051_fixups[] =3D {
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo X200", CXT_PINCFG_LENOVO_X200),
 	{}
 };
=20
+static const struct snd_pci_quirk cxt5066_fixups[] =3D {
+	SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo T400", CXT_PINCFG_LENOVO_TP410),
+	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo T410", CXT_PINCFG_LENOVO_TP410),
+	SND_PCI_QUIRK(0x17aa, 0x215f, "Lenovo T510", CXT_PINCFG_LENOVO_TP410),
+	SND_PCI_QUIRK(0x17aa, 0x21ce, "Lenovo T420", CXT_PINCFG_LENOVO_TP410),
+	SND_PCI_QUIRK(0x17aa, 0x21cf, "Lenovo T520", CXT_PINCFG_LENOVO_TP410),
+	{}
+};
+
 /* add "fake" mute amp-caps to DACs on cx5051 so that mixer mute switches
  * can be created (bko#42825)
  */
@@ -4462,11 +4487,13 @@ static int patch_conexant_auto(struct hda_codec *co=
dec)
 		break;
 	case 0x14f15051:
 		add_cx5051_fake_mutes(codec);
+		apply_pin_fixup(codec, cxt5051_fixups, cxt_pincfg_tbl);
+		break;
+	default:
+		apply_pin_fixup(codec, cxt5066_fixups, cxt_pincfg_tbl);
 		break;
 	}
=20
-	apply_pin_fixup(codec, cxt_fixups, cxt_pincfg_tbl);
-
 	err =3D cx_auto_search_adcs(codec);
 	if (err < 0)
 		return err;
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index dc8a6fc..0bc5a46 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5032,6 +5032,7 @@ static const struct alc_fixup alc269_fixups[] =3D {
 };
=20
 static const struct snd_pci_quirk alc269_fixup_tbl[] =3D {
+	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),
diff --git a/sound/soc/codecs/tlv320aic23.c b/sound/soc/codecs/tlv320aic23.=
c
index 336de8f..0e7e26e 100644
--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -473,7 +473,7 @@ static int tlv320aic23_set_dai_sysclk(struct snd_soc_da=
i *codec_dai,
 static int tlv320aic23_set_bias_level(struct snd_soc_codec *codec,
 				      enum snd_soc_bias_level level)
 {
-	u16 reg =3D snd_soc_read(codec, TLV320AIC23_PWR) & 0xff7f;
+	u16 reg =3D snd_soc_read(codec, TLV320AIC23_PWR) & 0x17f;
=20
 	switch (level) {
 	case SND_SOC_BIAS_ON:
@@ -492,7 +492,7 @@ static int tlv320aic23_set_bias_level(struct snd_soc_co=
dec *codec,
 	case SND_SOC_BIAS_OFF:
 		/* everything off, dac mute, inactive */
 		snd_soc_write(codec, TLV320AIC23_ACTIVE, 0x0);
-		snd_soc_write(codec, TLV320AIC23_PWR, 0xffff);
+		snd_soc_write(codec, TLV320AIC23_PWR, 0x1ff);
 		break;
 	}
 	codec->dapm.bias_level =3D level;
diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 2f1f5f8..7806301 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -883,61 +883,170 @@ static void wm8994_update_class_w(struct snd_soc_cod=
ec *codec)
 	}
 }
=20
-static int late_enable_ev(struct snd_soc_dapm_widget *w,
-			  struct snd_kcontrol *kcontrol, int event)
+static int aif1clk_ev(struct snd_soc_dapm_widget *w,
+		      struct snd_kcontrol *kcontrol, int event)
 {
 	struct snd_soc_codec *codec =3D w->codec;
-	struct wm8994_priv *wm8994 =3D snd_soc_codec_get_drvdata(codec);
+	struct wm8994 *control =3D codec->control_data;
+	int mask =3D WM8994_AIF1DAC1L_ENA | WM8994_AIF1DAC1R_ENA;
+	int dac;
+	int adc;
+	int val;
+
+	switch (control->type) {
+	case WM8994:
+	case WM8958:
+		mask |=3D WM8994_AIF1DAC2L_ENA | WM8994_AIF1DAC2R_ENA;
+		break;
+	default:
+		break;
+	}
=20
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		if (wm8994->aif1clk_enable) {
-			snd_soc_update_bits(codec, WM8994_AIF1_CLOCKING_1,
-					    WM8994_AIF1CLK_ENA_MASK,
-					    WM8994_AIF1CLK_ENA);
-			wm8994->aif1clk_enable =3D 0;
-		}
-		if (wm8994->aif2clk_enable) {
-			snd_soc_update_bits(codec, WM8994_AIF2_CLOCKING_1,
-					    WM8994_AIF2CLK_ENA_MASK,
-					    WM8994_AIF2CLK_ENA);
-			wm8994->aif2clk_enable =3D 0;
-		}
+		val =3D snd_soc_read(codec, WM8994_AIF1_CONTROL_1);
+		if ((val & WM8994_AIF1ADCL_SRC) &&
+		    (val & WM8994_AIF1ADCR_SRC))
+			adc =3D WM8994_AIF1ADC1R_ENA | WM8994_AIF1ADC2R_ENA;
+		else if (!(val & WM8994_AIF1ADCL_SRC) &&
+			 !(val & WM8994_AIF1ADCR_SRC))
+			adc =3D WM8994_AIF1ADC1L_ENA | WM8994_AIF1ADC2L_ENA;
+		else
+			adc =3D WM8994_AIF1ADC1R_ENA | WM8994_AIF1ADC2R_ENA |
+				WM8994_AIF1ADC1L_ENA | WM8994_AIF1ADC2L_ENA;
+
+		val =3D snd_soc_read(codec, WM8994_AIF1_CONTROL_2);
+		if ((val & WM8994_AIF1DACL_SRC) &&
+		    (val & WM8994_AIF1DACR_SRC))
+			dac =3D WM8994_AIF1DAC1R_ENA | WM8994_AIF1DAC2R_ENA;
+		else if (!(val & WM8994_AIF1DACL_SRC) &&
+			 !(val & WM8994_AIF1DACR_SRC))
+			dac =3D WM8994_AIF1DAC1L_ENA | WM8994_AIF1DAC2L_ENA;
+		else
+			dac =3D WM8994_AIF1DAC1R_ENA | WM8994_AIF1DAC2R_ENA |
+				WM8994_AIF1DAC1L_ENA | WM8994_AIF1DAC2L_ENA;
+
+		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_4,
+				    mask, adc);
+		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_5,
+				    mask, dac);
+		snd_soc_update_bits(codec, WM8994_CLOCKING_1,
+				    WM8994_AIF1DSPCLK_ENA |
+				    WM8994_SYSDSPCLK_ENA,
+				    WM8994_AIF1DSPCLK_ENA |
+				    WM8994_SYSDSPCLK_ENA);
+		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_4, mask,
+				    WM8994_AIF1ADC1R_ENA |
+				    WM8994_AIF1ADC1L_ENA |
+				    WM8994_AIF1ADC2R_ENA |
+				    WM8994_AIF1ADC2L_ENA);
+		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_5, mask,
+				    WM8994_AIF1DAC1R_ENA |
+				    WM8994_AIF1DAC1L_ENA |
+				    WM8994_AIF1DAC2R_ENA |
+				    WM8994_AIF1DAC2L_ENA);
+		break;
+
+	case SND_SOC_DAPM_PRE_PMD:
+	case SND_SOC_DAPM_POST_PMD:
+		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_5,
+				    mask, 0);
+		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_4,
+				    mask, 0);
+
+		val =3D snd_soc_read(codec, WM8994_CLOCKING_1);
+		if (val & WM8994_AIF2DSPCLK_ENA)
+			val =3D WM8994_SYSDSPCLK_ENA;
+		else
+			val =3D 0;
+		snd_soc_update_bits(codec, WM8994_CLOCKING_1,
+				    WM8994_SYSDSPCLK_ENA |
+				    WM8994_AIF1DSPCLK_ENA, val);
 		break;
 	}
=20
-	/* We may also have postponed startup of DSP, handle that. */
-	wm8958_aif_ev(w, kcontrol, event);
-
 	return 0;
 }
=20
-static int late_disable_ev(struct snd_soc_dapm_widget *w,
-			   struct snd_kcontrol *kcontrol, int event)
+static int aif2clk_ev(struct snd_soc_dapm_widget *w,
+		      struct snd_kcontrol *kcontrol, int event)
 {
 	struct snd_soc_codec *codec =3D w->codec;
-	struct wm8994_priv *wm8994 =3D snd_soc_codec_get_drvdata(codec);
+	int dac;
+	int adc;
+	int val;
=20
 	switch (event) {
+	case SND_SOC_DAPM_PRE_PMU:
+		val =3D snd_soc_read(codec, WM8994_AIF2_CONTROL_1);
+		if ((val & WM8994_AIF2ADCL_SRC) &&
+		    (val & WM8994_AIF2ADCR_SRC))
+			adc =3D WM8994_AIF2ADCR_ENA;
+		else if (!(val & WM8994_AIF2ADCL_SRC) &&
+			 !(val & WM8994_AIF2ADCR_SRC))
+			adc =3D WM8994_AIF2ADCL_ENA;
+		else
+			adc =3D WM8994_AIF2ADCL_ENA | WM8994_AIF2ADCR_ENA;
+
+
+		val =3D snd_soc_read(codec, WM8994_AIF2_CONTROL_2);
+		if ((val & WM8994_AIF2DACL_SRC) &&
+		    (val & WM8994_AIF2DACR_SRC))
+			dac =3D WM8994_AIF2DACR_ENA;
+		else if (!(val & WM8994_AIF2DACL_SRC) &&
+			 !(val & WM8994_AIF2DACR_SRC))
+			dac =3D WM8994_AIF2DACL_ENA;
+		else
+			dac =3D WM8994_AIF2DACL_ENA | WM8994_AIF2DACR_ENA;
+
+		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_4,
+				    WM8994_AIF2ADCL_ENA |
+				    WM8994_AIF2ADCR_ENA, adc);
+		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_5,
+				    WM8994_AIF2DACL_ENA |
+				    WM8994_AIF2DACR_ENA, dac);
+		snd_soc_update_bits(codec, WM8994_CLOCKING_1,
+				    WM8994_AIF2DSPCLK_ENA |
+				    WM8994_SYSDSPCLK_ENA,
+				    WM8994_AIF2DSPCLK_ENA |
+				    WM8994_SYSDSPCLK_ENA);
+		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_4,
+				    WM8994_AIF2ADCL_ENA |
+				    WM8994_AIF2ADCR_ENA,
+				    WM8994_AIF2ADCL_ENA |
+				    WM8994_AIF2ADCR_ENA);
+		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_5,
+				    WM8994_AIF2DACL_ENA |
+				    WM8994_AIF2DACR_ENA,
+				    WM8994_AIF2DACL_ENA |
+				    WM8994_AIF2DACR_ENA);
+		break;
+
+	case SND_SOC_DAPM_PRE_PMD:
 	case SND_SOC_DAPM_POST_PMD:
-		if (wm8994->aif1clk_disable) {
-			snd_soc_update_bits(codec, WM8994_AIF1_CLOCKING_1,
-					    WM8994_AIF1CLK_ENA_MASK, 0);
-			wm8994->aif1clk_disable =3D 0;
-		}
-		if (wm8994->aif2clk_disable) {
-			snd_soc_update_bits(codec, WM8994_AIF2_CLOCKING_1,
-					    WM8994_AIF2CLK_ENA_MASK, 0);
-			wm8994->aif2clk_disable =3D 0;
-		}
+		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_5,
+				    WM8994_AIF2DACL_ENA |
+				    WM8994_AIF2DACR_ENA, 0);
+		snd_soc_update_bits(codec, WM8994_POWER_MANAGEMENT_5,
+				    WM8994_AIF2ADCL_ENA |
+				    WM8994_AIF2ADCR_ENA, 0);
+
+		val =3D snd_soc_read(codec, WM8994_CLOCKING_1);
+		if (val & WM8994_AIF1DSPCLK_ENA)
+			val =3D WM8994_SYSDSPCLK_ENA;
+		else
+			val =3D 0;
+		snd_soc_update_bits(codec, WM8994_CLOCKING_1,
+				    WM8994_SYSDSPCLK_ENA |
+				    WM8994_AIF2DSPCLK_ENA, val);
 		break;
 	}
=20
 	return 0;
 }
=20
-static int aif1clk_ev(struct snd_soc_dapm_widget *w,
-		      struct snd_kcontrol *kcontrol, int event)
+static int aif1clk_late_ev(struct snd_soc_dapm_widget *w,
+			   struct snd_kcontrol *kcontrol, int event)
 {
 	struct snd_soc_codec *codec =3D w->codec;
 	struct wm8994_priv *wm8994 =3D snd_soc_codec_get_drvdata(codec);
@@ -954,8 +1063,8 @@ static int aif1clk_ev(struct snd_soc_dapm_widget *w,
 	return 0;
 }
=20
-static int aif2clk_ev(struct snd_soc_dapm_widget *w,
-		      struct snd_kcontrol *kcontrol, int event)
+static int aif2clk_late_ev(struct snd_soc_dapm_widget *w,
+			   struct snd_kcontrol *kcontrol, int event)
 {
 	struct snd_soc_codec *codec =3D w->codec;
 	struct wm8994_priv *wm8994 =3D snd_soc_codec_get_drvdata(codec);
@@ -972,6 +1081,63 @@ static int aif2clk_ev(struct snd_soc_dapm_widget *w,
 	return 0;
 }
=20
+static int late_enable_ev(struct snd_soc_dapm_widget *w,
+			  struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_codec *codec =3D w->codec;
+	struct wm8994_priv *wm8994 =3D snd_soc_codec_get_drvdata(codec);
+
+	switch (event) {
+	case SND_SOC_DAPM_PRE_PMU:
+		if (wm8994->aif1clk_enable) {
+			aif1clk_ev(w, kcontrol, event);
+			snd_soc_update_bits(codec, WM8994_AIF1_CLOCKING_1,
+					    WM8994_AIF1CLK_ENA_MASK,
+					    WM8994_AIF1CLK_ENA);
+			wm8994->aif1clk_enable =3D 0;
+		}
+		if (wm8994->aif2clk_enable) {
+			aif2clk_ev(w, kcontrol, event);
+			snd_soc_update_bits(codec, WM8994_AIF2_CLOCKING_1,
+					    WM8994_AIF2CLK_ENA_MASK,
+					    WM8994_AIF2CLK_ENA);
+			wm8994->aif2clk_enable =3D 0;
+		}
+		break;
+	}
+
+	/* We may also have postponed startup of DSP, handle that. */
+	wm8958_aif_ev(w, kcontrol, event);
+
+	return 0;
+}
+
+static int late_disable_ev(struct snd_soc_dapm_widget *w,
+			   struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_codec *codec =3D w->codec;
+	struct wm8994_priv *wm8994 =3D snd_soc_codec_get_drvdata(codec);
+
+	switch (event) {
+	case SND_SOC_DAPM_POST_PMD:
+		if (wm8994->aif1clk_disable) {
+			snd_soc_update_bits(codec, WM8994_AIF1_CLOCKING_1,
+					    WM8994_AIF1CLK_ENA_MASK, 0);
+			aif1clk_ev(w, kcontrol, event);
+			wm8994->aif1clk_disable =3D 0;
+		}
+		if (wm8994->aif2clk_disable) {
+			snd_soc_update_bits(codec, WM8994_AIF2_CLOCKING_1,
+					    WM8994_AIF2CLK_ENA_MASK, 0);
+			aif2clk_ev(w, kcontrol, event);
+			wm8994->aif2clk_disable =3D 0;
+		}
+		break;
+	}
+
+	return 0;
+}
+
 static int adc_mux_ev(struct snd_soc_dapm_widget *w,
 		      struct snd_kcontrol *kcontrol, int event)
 {
@@ -1268,9 +1434,9 @@ static const struct snd_kcontrol_new aif2dacr_src_mux=
 =3D
 	SOC_DAPM_ENUM("AIF2DACR Mux", aif2dacr_src_enum);
=20
 static const struct snd_soc_dapm_widget wm8994_lateclk_revd_widgets[] =3D =
{
-SND_SOC_DAPM_SUPPLY("AIF1CLK", SND_SOC_NOPM, 0, 0, aif1clk_ev,
+SND_SOC_DAPM_SUPPLY("AIF1CLK", SND_SOC_NOPM, 0, 0, aif1clk_late_ev,
 	SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD),
-SND_SOC_DAPM_SUPPLY("AIF2CLK", SND_SOC_NOPM, 0, 0, aif2clk_ev,
+SND_SOC_DAPM_SUPPLY("AIF2CLK", SND_SOC_NOPM, 0, 0, aif2clk_late_ev,
 	SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD),
=20
 SND_SOC_DAPM_PGA_E("Late DAC1L Enable PGA", SND_SOC_NOPM, 0, 0, NULL, 0,
@@ -1299,8 +1465,10 @@ SND_SOC_DAPM_POST("Late Disable PGA", late_disable_e=
v)
 };
=20
 static const struct snd_soc_dapm_widget wm8994_lateclk_widgets[] =3D {
-SND_SOC_DAPM_SUPPLY("AIF1CLK", WM8994_AIF1_CLOCKING_1, 0, 0, NULL, 0),
-SND_SOC_DAPM_SUPPLY("AIF2CLK", WM8994_AIF2_CLOCKING_1, 0, 0, NULL, 0),
+SND_SOC_DAPM_SUPPLY("AIF1CLK", WM8994_AIF1_CLOCKING_1, 0, 0, aif1clk_ev,
+		    SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_PRE_PMD),
+SND_SOC_DAPM_SUPPLY("AIF2CLK", WM8994_AIF2_CLOCKING_1, 0, 0, aif2clk_ev,
+		    SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_PRE_PMD),
 SND_SOC_DAPM_PGA("Direct Voice", SND_SOC_NOPM, 0, 0, NULL, 0),
 SND_SOC_DAPM_MIXER("SPKL", WM8994_POWER_MANAGEMENT_3, 8, 0,
 		   left_speaker_mixer, ARRAY_SIZE(left_speaker_mixer)),
@@ -1353,30 +1521,30 @@ SND_SOC_DAPM_SUPPLY("VMID", SND_SOC_NOPM, 0, 0, vmi=
d_event,
 SND_SOC_DAPM_SUPPLY("CLK_SYS", SND_SOC_NOPM, 0, 0, clk_sys_event,
 		    SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
=20
-SND_SOC_DAPM_SUPPLY("DSP1CLK", WM8994_CLOCKING_1, 3, 0, NULL, 0),
-SND_SOC_DAPM_SUPPLY("DSP2CLK", WM8994_CLOCKING_1, 2, 0, NULL, 0),
-SND_SOC_DAPM_SUPPLY("DSPINTCLK", WM8994_CLOCKING_1, 1, 0, NULL, 0),
+SND_SOC_DAPM_SUPPLY("DSP1CLK", SND_SOC_NOPM, 3, 0, NULL, 0),
+SND_SOC_DAPM_SUPPLY("DSP2CLK", SND_SOC_NOPM, 2, 0, NULL, 0),
+SND_SOC_DAPM_SUPPLY("DSPINTCLK", SND_SOC_NOPM, 1, 0, NULL, 0),
=20
 SND_SOC_DAPM_AIF_OUT("AIF1ADC1L", NULL,
-		     0, WM8994_POWER_MANAGEMENT_4, 9, 0),
+		     0, SND_SOC_NOPM, 9, 0),
 SND_SOC_DAPM_AIF_OUT("AIF1ADC1R", NULL,
-		     0, WM8994_POWER_MANAGEMENT_4, 8, 0),
+		     0, SND_SOC_NOPM, 8, 0),
 SND_SOC_DAPM_AIF_IN_E("AIF1DAC1L", NULL, 0,
-		      WM8994_POWER_MANAGEMENT_5, 9, 0, wm8958_aif_ev,
+		      SND_SOC_NOPM, 9, 0, wm8958_aif_ev,
 		      SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
 SND_SOC_DAPM_AIF_IN_E("AIF1DAC1R", NULL, 0,
-		      WM8994_POWER_MANAGEMENT_5, 8, 0, wm8958_aif_ev,
+		      SND_SOC_NOPM, 8, 0, wm8958_aif_ev,
 		      SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
=20
 SND_SOC_DAPM_AIF_OUT("AIF1ADC2L", NULL,
-		     0, WM8994_POWER_MANAGEMENT_4, 11, 0),
+		     0, SND_SOC_NOPM, 11, 0),
 SND_SOC_DAPM_AIF_OUT("AIF1ADC2R", NULL,
-		     0, WM8994_POWER_MANAGEMENT_4, 10, 0),
+		     0, SND_SOC_NOPM, 10, 0),
 SND_SOC_DAPM_AIF_IN_E("AIF1DAC2L", NULL, 0,
-		      WM8994_POWER_MANAGEMENT_5, 11, 0, wm8958_aif_ev,
+		      SND_SOC_NOPM, 11, 0, wm8958_aif_ev,
 		      SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
 SND_SOC_DAPM_AIF_IN_E("AIF1DAC2R", NULL, 0,
-		      WM8994_POWER_MANAGEMENT_5, 10, 0, wm8958_aif_ev,
+		      SND_SOC_NOPM, 10, 0, wm8958_aif_ev,
 		      SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
=20
 SND_SOC_DAPM_MIXER("AIF1ADC1L Mixer", SND_SOC_NOPM, 0, 0,
@@ -1403,14 +1571,14 @@ SND_SOC_DAPM_MIXER("DAC1R Mixer", SND_SOC_NOPM, 0, =
0,
 		   dac1r_mix, ARRAY_SIZE(dac1r_mix)),
=20
 SND_SOC_DAPM_AIF_OUT("AIF2ADCL", NULL, 0,
-		     WM8994_POWER_MANAGEMENT_4, 13, 0),
+		     SND_SOC_NOPM, 13, 0),
 SND_SOC_DAPM_AIF_OUT("AIF2ADCR", NULL, 0,
-		     WM8994_POWER_MANAGEMENT_4, 12, 0),
+		     SND_SOC_NOPM, 12, 0),
 SND_SOC_DAPM_AIF_IN_E("AIF2DACL", NULL, 0,
-		      WM8994_POWER_MANAGEMENT_5, 13, 0, wm8958_aif_ev,
+		      SND_SOC_NOPM, 13, 0, wm8958_aif_ev,
 		      SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
 SND_SOC_DAPM_AIF_IN_E("AIF2DACR", NULL, 0,
-		      WM8994_POWER_MANAGEMENT_5, 12, 0, wm8958_aif_ev,
+		      SND_SOC_NOPM, 12, 0, wm8958_aif_ev,
 		      SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
=20
 SND_SOC_DAPM_AIF_IN("AIF1DACDAT", "AIF1 Playback", 0, SND_SOC_NOPM, 0, 0),
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index ea909c5..90e93bf 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -69,6 +69,7 @@ static int dapm_up_seq[] =3D {
 	[snd_soc_dapm_out_drv] =3D 10,
 	[snd_soc_dapm_hp] =3D 10,
 	[snd_soc_dapm_spk] =3D 10,
+	[snd_soc_dapm_line] =3D 10,
 	[snd_soc_dapm_post] =3D 11,
 };
=20
@@ -77,6 +78,7 @@ static int dapm_down_seq[] =3D {
 	[snd_soc_dapm_adc] =3D 1,
 	[snd_soc_dapm_hp] =3D 2,
 	[snd_soc_dapm_spk] =3D 2,
+	[snd_soc_dapm_line] =3D 2,
 	[snd_soc_dapm_out_drv] =3D 2,
 	[snd_soc_dapm_pga] =3D 4,
 	[snd_soc_dapm_mixer_named_ctl] =3D 5,
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index adb372d..e0a0970 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -237,8 +237,8 @@ struct hist_entry *__hists__add_entry(struct hists *his=
ts,
 			 * mis-adjust symbol addresses when computing
 			 * the history counter to increment.
 			 */
-			if (he->ms.map !=3D entry->ms.map) {
-				he->ms.map =3D entry->ms.map;
+			if (he->ms.map !=3D entry.ms.map) {
+				he->ms.map =3D entry.ms.map;
 				if (he->ms.map)
 					he->ms.map->referenced =3D true;
 			}
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index a195c07..fd817a2 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -309,6 +309,11 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
 	}
 }
=20
+void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	kvm_iommu_put_pages(kvm, slot->base_gfn, slot->npages);
+}
+
 static int kvm_iommu_unmap_memslots(struct kvm *kvm)
 {
 	int i, idx;
@@ -317,10 +322,9 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm)
 	idx =3D srcu_read_lock(&kvm->srcu);
 	slots =3D kvm_memslots(kvm);
=20
-	for (i =3D 0; i < slots->nmemslots; i++) {
-		kvm_iommu_put_pages(kvm, slots->memslots[i].base_gfn,
-				    slots->memslots[i].npages);
-	}
+	for (i =3D 0; i < slots->nmemslots; i++)
+		kvm_iommu_unmap_pages(kvm, &slots->memslots[i]);
+
 	srcu_read_unlock(&kvm->srcu, idx);
=20
 	return 0;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d9cfb78..e401c1b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -802,12 +802,13 @@ skip_lpage:
 	if (r)
 		goto out_free;
=20
-	/* map the pages in iommu page table */
+	/* map/unmap the pages in iommu page table */
 	if (npages) {
 		r =3D kvm_iommu_map_pages(kvm, &new);
 		if (r)
 			goto out_free;
-	}
+	} else
+		kvm_iommu_unmap_pages(kvm, &old);
=20
 	r =3D -ENOMEM;
 	slots =3D kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);


--=-w8vLmN+3SrwjM5KzuptP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT62l3Oe/yOyVhhEJAQo6cA//cBZcU0sHjpyHobBApf8pZrru5KfSXGdJ
XY2nQ5qoL3ozV9WG3BZuH++rSTakLttRQakSFgLOBjbVWUETSxNf6I8HoRwM48XA
GeqWmyUDfRA85XwO6W0sqhPcJ+9Pe4EEQ0BLW2JnpIdxEHpnHZ6fZXdUr9Nio79q
vV7aoBzGd2nQfyc+thVB1vAavvAQE0A4EMTh7A+W4FD7ze+xqeoX57f5OhmgN1FV
7VC4mnqnLLSV9JAon+s0Lzva/fJrJat5i0UKZhYvXRHpX71hb1ymn/yGv9HzrimZ
JO94MYgiXAGOaUpNLV0AnxGaf0uKbRxaJXq7gq3P5bdb2U8m5uhaNnLGqQbG9zrC
9nV+AuJawPVJm6+wB3S4By8Wk69Ywj4bxYI0E4SryYVwDXk1TELNdrwYx47XzpUK
E4OZGr+14T9pEs1j5z/bS+lIyHbh0K1Q0IGSJKeHNgI9nzd1ftNuRl7h8RTB+UGR
PDO+uoryQIsrHa9H6c2K6zat3vWJkKjO1V9VuasK02tab0zJPGaddz9IVDNlwTZ5
gFepuPjxHCpLrimY7J4n1KJlVVUwvde5xAve1M7AEcTFtxXZhtPQtpijmHJfPAY5
ukL4mKecS3SL3mNWT6Mb9rXmboFQCkV9Y32PA2RBkTvayt0EOQv0KAEuxSnvHjAJ
OiWd9gOh5GY=
=HkZb
-----END PGP SIGNATURE-----

--=-w8vLmN+3SrwjM5KzuptP--
