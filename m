Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab2CPEXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 00:23:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45225 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab2CPEWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 00:22:35 -0400
Date: Fri, 16 Mar 2012 15:18:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] powerpc: remove FW_FEATURE ISERIES from arch code
Message-Id: <20120316151800.addc99d430bf3960563d3dba@canb.auug.org.au>
In-Reply-To: <20120316151459.dab3cdcc2d5984b05e2d2b5c@canb.auug.org.au>
References: <20120316151459.dab3cdcc2d5984b05e2d2b5c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Mar_2012_15_18_00_+1100_1M9hr/g0wJoshEdO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Mar_2012_15_18_00_+1100_1M9hr/g0wJoshEdO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This is no longer selectable, so just remove all the dependent code.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/include/asm/abs_addr.h   |   21 +------
 arch/powerpc/include/asm/firmware.h   |    9 ---
 arch/powerpc/include/asm/time.h       |   15 -----
 arch/powerpc/kernel/irq.c             |   14 ----
 arch/powerpc/kernel/isa-bridge.c      |    3 -
 arch/powerpc/kernel/lparcfg.c         |  108 ++---------------------------=
---
 arch/powerpc/kernel/paca.c            |   12 +---
 arch/powerpc/kernel/pci-common.c      |   15 -----
 arch/powerpc/kernel/sysfs.c           |    7 +--
 arch/powerpc/kernel/time.c            |  108 +----------------------------=
----
 arch/powerpc/lib/locks.c              |   24 ++------
 arch/powerpc/mm/hash_utils_64.c       |    9 +--
 arch/powerpc/mm/slb.c                 |    6 --
 arch/powerpc/mm/stab.c                |    9 ---
 arch/powerpc/oprofile/common.c        |    3 -
 arch/powerpc/platforms/powernv/pci.c  |    1 +
 arch/powerpc/platforms/pseries/lpar.c |    1 +
 arch/powerpc/xmon/xmon.c              |   28 ---------
 18 files changed, 26 insertions(+), 367 deletions(-)

diff --git a/arch/powerpc/include/asm/abs_addr.h b/arch/powerpc/include/asm=
/abs_addr.h
index 5ab0b71..9d92ba0 100644
--- a/arch/powerpc/include/asm/abs_addr.h
+++ b/arch/powerpc/include/asm/abs_addr.h
@@ -17,7 +17,6 @@
 #include <asm/types.h>
 #include <asm/page.h>
 #include <asm/prom.h>
-#include <asm/firmware.h>
=20
 struct mschunks_map {
         unsigned long num_chunks;
@@ -46,30 +45,12 @@ static inline unsigned long addr_to_chunk(unsigned long=
 addr)
=20
 static inline unsigned long phys_to_abs(unsigned long pa)
 {
-	unsigned long chunk;
-
-	/* This is a no-op on non-iSeries */
-	if (!firmware_has_feature(FW_FEATURE_ISERIES))
-		return pa;
-
-	chunk =3D addr_to_chunk(pa);
-
-	if (chunk < mschunks_map.num_chunks)
-		chunk =3D mschunks_map.mapping[chunk];
-
-	return chunk_to_addr(chunk) + (pa & MSCHUNKS_OFFSET_MASK);
+	return pa;
 }
=20
 /* Convenience macros */
 #define virt_to_abs(va) phys_to_abs(__pa(va))
 #define abs_to_virt(aa) __va(aa)
=20
-/*
- * Converts Virtual Address to Real Address for
- * Legacy iSeries Hypervisor calls
- */
-#define iseries_hv_addr(virtaddr)	\
-	(0x8000000000000000UL | virt_to_abs(virtaddr))
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_ABS_ADDR_H */
diff --git a/arch/powerpc/include/asm/firmware.h b/arch/powerpc/include/asm=
/firmware.h
index 14db29b..ad0b751 100644
--- a/arch/powerpc/include/asm/firmware.h
+++ b/arch/powerpc/include/asm/firmware.h
@@ -41,7 +41,6 @@
 #define FW_FEATURE_XDABR	ASM_CONST(0x0000000000040000)
 #define FW_FEATURE_MULTITCE	ASM_CONST(0x0000000000080000)
 #define FW_FEATURE_SPLPAR	ASM_CONST(0x0000000000100000)
-#define FW_FEATURE_ISERIES	ASM_CONST(0x0000000000200000)
 #define FW_FEATURE_LPAR		ASM_CONST(0x0000000000400000)
 #define FW_FEATURE_PS3_LV1	ASM_CONST(0x0000000000800000)
 #define FW_FEATURE_BEAT		ASM_CONST(0x0000000001000000)
@@ -65,8 +64,6 @@ enum {
 		FW_FEATURE_MULTITCE | FW_FEATURE_SPLPAR | FW_FEATURE_LPAR |
 		FW_FEATURE_CMO | FW_FEATURE_VPHN | FW_FEATURE_XCMO,
 	FW_FEATURE_PSERIES_ALWAYS =3D 0,
-	FW_FEATURE_ISERIES_POSSIBLE =3D FW_FEATURE_ISERIES | FW_FEATURE_LPAR,
-	FW_FEATURE_ISERIES_ALWAYS =3D FW_FEATURE_ISERIES | FW_FEATURE_LPAR,
 	FW_FEATURE_POWERNV_POSSIBLE =3D FW_FEATURE_OPAL | FW_FEATURE_OPALv2,
 	FW_FEATURE_POWERNV_ALWAYS =3D 0,
 	FW_FEATURE_PS3_POSSIBLE =3D FW_FEATURE_LPAR | FW_FEATURE_PS3_LV1,
@@ -79,9 +76,6 @@ enum {
 #ifdef CONFIG_PPC_PSERIES
 		FW_FEATURE_PSERIES_POSSIBLE |
 #endif
-#ifdef CONFIG_PPC_ISERIES
-		FW_FEATURE_ISERIES_POSSIBLE |
-#endif
 #ifdef CONFIG_PPC_POWERNV
 		FW_FEATURE_POWERNV_POSSIBLE |
 #endif
@@ -99,9 +93,6 @@ enum {
 #ifdef CONFIG_PPC_PSERIES
 		FW_FEATURE_PSERIES_ALWAYS &
 #endif
-#ifdef CONFIG_PPC_ISERIES
-		FW_FEATURE_ISERIES_ALWAYS &
-#endif
 #ifdef CONFIG_PPC_POWERNV
 		FW_FEATURE_POWERNV_ALWAYS &
 #endif
diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/tim=
e.h
index 7eb10fb..2136f58 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -18,11 +18,6 @@
 #include <linux/percpu.h>
=20
 #include <asm/processor.h>
-#ifdef CONFIG_PPC_ISERIES
-#include <asm/paca.h>
-#include <asm/firmware.h>
-#include <asm/iseries/hv_call.h>
-#endif
=20
 /* time.c */
 extern unsigned long tb_ticks_per_jiffy;
@@ -167,15 +162,6 @@ static inline void set_dec(int val)
 #ifndef CONFIG_BOOKE
 	--val;
 #endif
-#ifdef CONFIG_PPC_ISERIES
-	if (firmware_has_feature(FW_FEATURE_ISERIES) &&
-			get_lppaca()->shared_proc) {
-		get_lppaca()->virtual_decr =3D val;
-		if (get_dec() > val)
-			HvCall_setVirtualDecr();
-		return;
-	}
-#endif
 	mtspr(SPRN_DEC, val);
 #endif /* not 40x or 8xx_CPU6 */
 }
@@ -217,7 +203,6 @@ DECLARE_PER_CPU(struct cpu_usage, cpu_usage_array);
 #endif
=20
 extern void secondary_cpu_time_init(void);
-extern void iSeries_time_init_early(void);
=20
 DECLARE_PER_CPU(u64, decrementers_next_tb);
=20
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index eb804e1..45b367c 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -211,11 +211,6 @@ notrace void arch_local_irq_restore(unsigned long en)
 	 * External interrupt events on non-iseries will have caused
 	 * interrupts to be hard-disabled, so there is no problem, we
 	 * cannot have preempted.
-	 *
-	 * That leaves us with EEs on iSeries or decrementer interrupts,
-	 * which I decided to safely ignore. The preemption would have
-	 * itself been the result of an interrupt, upon which return we
-	 * will have checked for pending events on the old CPU.
 	 */
 	irq_happened =3D get_irq_happened();
 	if (!irq_happened)
@@ -458,15 +453,6 @@ void do_IRQ(struct pt_regs *regs)
 	irq_exit();
 	set_irq_regs(old_regs);
=20
-#ifdef CONFIG_PPC_ISERIES
-	if (firmware_has_feature(FW_FEATURE_ISERIES) &&
-			get_lppaca()->int_dword.fields.decr_int) {
-		get_lppaca()->int_dword.fields.decr_int =3D 0;
-		/* Signal a fake decrementer interrupt */
-		timer_interrupt(regs);
-	}
-#endif
-
 	trace_irq_exit(regs);
 }
=20
diff --git a/arch/powerpc/kernel/isa-bridge.c b/arch/powerpc/kernel/isa-bri=
dge.c
index 4797529..d45ec58 100644
--- a/arch/powerpc/kernel/isa-bridge.c
+++ b/arch/powerpc/kernel/isa-bridge.c
@@ -29,7 +29,6 @@
 #include <asm/pci-bridge.h>
 #include <asm/machdep.h>
 #include <asm/ppc-pci.h>
-#include <asm/firmware.h>
=20
 unsigned long isa_io_base;	/* NULL if no ISA bus */
 EXPORT_SYMBOL(isa_io_base);
@@ -261,8 +260,6 @@ static struct notifier_block isa_bridge_notifier =3D {
  */
 static int __init isa_bridge_init(void)
 {
-	if (firmware_has_feature(FW_FEATURE_ISERIES))
-		return 0;
 	bus_register_notifier(&pci_bus_type, &isa_bridge_notifier);
 	return 0;
 }
diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
index 578f35f..ac12bd8 100644
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -26,7 +26,6 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
-#include <asm/iseries/hv_lp_config.h>
 #include <asm/lppaca.h>
 #include <asm/hvcall.h>
 #include <asm/firmware.h>
@@ -55,80 +54,14 @@ static unsigned long get_purr(void)
 	int cpu;
=20
 	for_each_possible_cpu(cpu) {
-		if (firmware_has_feature(FW_FEATURE_ISERIES))
-			sum_purr +=3D lppaca_of(cpu).emulated_time_base;
-		else {
-			struct cpu_usage *cu;
+		struct cpu_usage *cu;
=20
-			cu =3D &per_cpu(cpu_usage_array, cpu);
-			sum_purr +=3D cu->current_tb;
-		}
+		cu =3D &per_cpu(cpu_usage_array, cpu);
+		sum_purr +=3D cu->current_tb;
 	}
 	return sum_purr;
 }
=20
-#ifdef CONFIG_PPC_ISERIES
-
-/*
- * Methods used to fetch LPAR data when running on an iSeries platform.
- */
-static int iseries_lparcfg_data(struct seq_file *m, void *v)
-{
-	unsigned long pool_id;
-	int shared, entitled_capacity, max_entitled_capacity;
-	int processors, max_processors;
-	unsigned long purr =3D get_purr();
-
-	shared =3D (int)(local_paca->lppaca_ptr->shared_proc);
-
-	seq_printf(m, "system_active_processors=3D%d\n",
-		   (int)HvLpConfig_getSystemPhysicalProcessors());
-
-	seq_printf(m, "system_potential_processors=3D%d\n",
-		   (int)HvLpConfig_getSystemPhysicalProcessors());
-
-	processors =3D (int)HvLpConfig_getPhysicalProcessors();
-	seq_printf(m, "partition_active_processors=3D%d\n", processors);
-
-	max_processors =3D (int)HvLpConfig_getMaxPhysicalProcessors();
-	seq_printf(m, "partition_potential_processors=3D%d\n", max_processors);
-
-	if (shared) {
-		entitled_capacity =3D HvLpConfig_getSharedProcUnits();
-		max_entitled_capacity =3D HvLpConfig_getMaxSharedProcUnits();
-	} else {
-		entitled_capacity =3D processors * 100;
-		max_entitled_capacity =3D max_processors * 100;
-	}
-	seq_printf(m, "partition_entitled_capacity=3D%d\n", entitled_capacity);
-
-	seq_printf(m, "partition_max_entitled_capacity=3D%d\n",
-		   max_entitled_capacity);
-
-	if (shared) {
-		pool_id =3D HvLpConfig_getSharedPoolIndex();
-		seq_printf(m, "pool=3D%d\n", (int)pool_id);
-		seq_printf(m, "pool_capacity=3D%d\n",
-			   (int)(HvLpConfig_getNumProcsInSharedPool(pool_id) *
-				 100));
-		seq_printf(m, "purr=3D%ld\n", purr);
-	}
-
-	seq_printf(m, "shared_processor_mode=3D%d\n", shared);
-
-	return 0;
-}
-
-#else				/* CONFIG_PPC_ISERIES */
-
-static int iseries_lparcfg_data(struct seq_file *m, void *v)
-{
-	return 0;
-}
-
-#endif				/* CONFIG_PPC_ISERIES */
-
-#ifdef CONFIG_PPC_PSERIES
 /*
  * Methods used to fetch LPAR data when running on a pSeries platform.
  */
@@ -648,8 +581,7 @@ static ssize_t lparcfg_write(struct file *file, const c=
har __user * buf,
 	u8 new_weight, *new_weight_ptr =3D &new_weight;
 	ssize_t retval;
=20
-	if (!firmware_has_feature(FW_FEATURE_SPLPAR) ||
-			firmware_has_feature(FW_FEATURE_ISERIES))
+	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
 		return -EINVAL;
=20
 	if (count > kbuf_sz)
@@ -709,21 +641,6 @@ static ssize_t lparcfg_write(struct file *file, const =
char __user * buf,
 	return retval;
 }
=20
-#else				/* CONFIG_PPC_PSERIES */
-
-static int pseries_lparcfg_data(struct seq_file *m, void *v)
-{
-	return 0;
-}
-
-static ssize_t lparcfg_write(struct file *file, const char __user * buf,
-			     size_t count, loff_t * off)
-{
-	return -EINVAL;
-}
-
-#endif				/* CONFIG_PPC_PSERIES */
-
 static int lparcfg_data(struct seq_file *m, void *v)
 {
 	struct device_node *rootdn;
@@ -738,19 +655,11 @@ static int lparcfg_data(struct seq_file *m, void *v)
 	rootdn =3D of_find_node_by_path("/");
 	if (rootdn) {
 		tmp =3D of_get_property(rootdn, "model", NULL);
-		if (tmp) {
+		if (tmp)
 			model =3D tmp;
-			/* Skip "IBM," - see platforms/iseries/dt.c */
-			if (firmware_has_feature(FW_FEATURE_ISERIES))
-				model +=3D 4;
-		}
 		tmp =3D of_get_property(rootdn, "system-id", NULL);
-		if (tmp) {
+		if (tmp)
 			system_id =3D tmp;
-			/* Skip "IBM," - see platforms/iseries/dt.c */
-			if (firmware_has_feature(FW_FEATURE_ISERIES))
-				system_id +=3D 4;
-		}
 		lp_index_ptr =3D of_get_property(rootdn, "ibm,partition-no",
 					NULL);
 		if (lp_index_ptr)
@@ -761,8 +670,6 @@ static int lparcfg_data(struct seq_file *m, void *v)
 	seq_printf(m, "system_type=3D%s\n", model);
 	seq_printf(m, "partition_id=3D%d\n", (int)lp_index);
=20
-	if (firmware_has_feature(FW_FEATURE_ISERIES))
-		return iseries_lparcfg_data(m, v);
 	return pseries_lparcfg_data(m, v);
 }
=20
@@ -786,8 +693,7 @@ static int __init lparcfg_init(void)
 	umode_t mode =3D S_IRUSR | S_IRGRP | S_IROTH;
=20
 	/* Allow writing if we have FW_FEATURE_SPLPAR */
-	if (firmware_has_feature(FW_FEATURE_SPLPAR) &&
-			!firmware_has_feature(FW_FEATURE_ISERIES))
+	if (firmware_has_feature(FW_FEATURE_SPLPAR))
 		mode |=3D S_IWUSR;
=20
 	ent =3D proc_create("powerpc/lparcfg", mode, NULL, &lparcfg_fops);
diff --git a/arch/powerpc/kernel/paca.c b/arch/powerpc/kernel/paca.c
index 41456ff..0bb1f98 100644
--- a/arch/powerpc/kernel/paca.c
+++ b/arch/powerpc/kernel/paca.c
@@ -11,13 +11,10 @@
 #include <linux/export.h>
 #include <linux/memblock.h>
=20
-#include <asm/firmware.h>
 #include <asm/lppaca.h>
 #include <asm/paca.h>
 #include <asm/sections.h>
 #include <asm/pgtable.h>
-#include <asm/iseries/lpar_map.h>
-#include <asm/iseries/hv_types.h>
 #include <asm/kexec.h>
=20
 /* This symbol is provided by the linker - let it fill in the paca
@@ -30,8 +27,8 @@ extern unsigned long __toc_start;
  * The structure which the hypervisor knows about - this structure
  * should not cross a page boundary.  The vpa_init/register_vpa call
  * is now known to fail if the lppaca structure crosses a page
- * boundary.  The lppaca is also used on legacy iSeries and POWER5
- * pSeries boxes.  The lppaca is 640 bytes long, and cannot readily
+ * boundary.  The lppaca is also used on POWER5 pSeries boxes.
+ * The lppaca is 640 bytes long, and cannot readily
  * change since the hypervisor knows its layout, so a 1kB alignment
  * will suffice to ensure that it doesn't cross a page boundary.
  */
@@ -183,12 +180,9 @@ void __init allocate_pacas(void)
 	/*
 	 * We can't take SLB misses on the paca, and we want to access them
 	 * in real mode, so allocate them within the RMA and also within
-	 * the first segment. On iSeries they must be within the area mapped
-	 * by the HV, which is HvPagesToMap * HVPAGESIZE bytes.
+	 * the first segment.
 	 */
 	limit =3D min(0x10000000ULL, ppc64_rma_size);
-	if (firmware_has_feature(FW_FEATURE_ISERIES))
-		limit =3D min(limit, HvPagesToMap * HVPAGESIZE);
=20
 	paca_size =3D PAGE_ALIGN(sizeof(struct paca_struct) * nr_cpu_ids);
=20
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-com=
mon.c
index cce98d7..d0373bc 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -38,7 +38,6 @@
 #include <asm/byteorder.h>
 #include <asm/machdep.h>
 #include <asm/ppc-pci.h>
-#include <asm/firmware.h>
 #include <asm/eeh.h>
=20
 static DEFINE_SPINLOCK(hose_spinlock);
@@ -219,20 +218,6 @@ static int pci_read_irq_line(struct pci_dev *pci_dev)
 	struct of_irq oirq;
 	unsigned int virq;
=20
-	/* The current device-tree that iSeries generates from the HV
-	 * PCI informations doesn't contain proper interrupt routing,
-	 * and all the fallback would do is print out crap, so we
-	 * don't attempt to resolve the interrupts here at all, some
-	 * iSeries specific fixup does it.
-	 *
-	 * In the long run, we will hopefully fix the generated device-tree
-	 * instead.
-	 */
-#ifdef CONFIG_PPC_ISERIES
-	if (firmware_has_feature(FW_FEATURE_ISERIES))
-		return -1;
-#endif
-
 	pr_debug("PCI: Try to map irq for %s...\n", pci_name(pci_dev));
=20
 #ifdef DEBUG
diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index 883e74c..0c683d3 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -12,7 +12,6 @@
 #include <asm/current.h>
 #include <asm/processor.h>
 #include <asm/cputable.h>
-#include <asm/firmware.h>
 #include <asm/hvcall.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
@@ -341,8 +340,7 @@ static void __cpuinit register_cpu_online(unsigned int =
cpu)
 	int i, nattrs;
=20
 #ifdef CONFIG_PPC64
-	if (!firmware_has_feature(FW_FEATURE_ISERIES) &&
-			cpu_has_feature(CPU_FTR_SMT))
+	if (cpu_has_feature(CPU_FTR_SMT))
 		device_create_file(s, &dev_attr_smt_snooze_delay);
 #endif
=20
@@ -414,8 +412,7 @@ static void unregister_cpu_online(unsigned int cpu)
 	BUG_ON(!c->hotpluggable);
=20
 #ifdef CONFIG_PPC64
-	if (!firmware_has_feature(FW_FEATURE_ISERIES) &&
-			cpu_has_feature(CPU_FTR_SMT))
+	if (cpu_has_feature(CPU_FTR_SMT))
 		device_remove_file(s, &dev_attr_smt_snooze_delay);
 #endif
=20
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index f81c81b..2c42cd7 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -17,8 +17,7 @@
  *
  * TODO (not necessarily in this file):
  * - improve precision and reproducibility of timebase frequency
- * measurement at boot time. (for iSeries, we calibrate the timebase
- * against the Titan chip's clock.)
+ * measurement at boot time.
  * - for astronomical applications: add a new function to get
  * non ambiguous timestamps even around leap seconds. This needs
  * a new timestamp format and a good name.
@@ -70,10 +69,6 @@
 #include <asm/vdso_datapage.h>
 #include <asm/firmware.h>
 #include <asm/cputime.h>
-#ifdef CONFIG_PPC_ISERIES
-#include <asm/iseries/it_lp_queue.h>
-#include <asm/iseries/hv_call_xm.h>
-#endif
=20
 /* powerpc clocksource/clockevent code */
=20
@@ -117,14 +112,6 @@ static struct clock_event_device decrementer_clockeven=
t =3D {
 DEFINE_PER_CPU(u64, decrementers_next_tb);
 static DEFINE_PER_CPU(struct clock_event_device, decrementers);
=20
-#ifdef CONFIG_PPC_ISERIES
-static unsigned long __initdata iSeries_recal_titan;
-static signed long __initdata iSeries_recal_tb;
-
-/* Forward declaration is only needed for iSereis compiles */
-static void __init clocksource_init(void);
-#endif
-
 #define XSEC_PER_SEC (1024*1024)
=20
 #ifdef CONFIG_PPC64
@@ -423,74 +410,6 @@ unsigned long profile_pc(struct pt_regs *regs)
 EXPORT_SYMBOL(profile_pc);
 #endif
=20
-#ifdef CONFIG_PPC_ISERIES
-
-/*=20
- * This function recalibrates the timebase based on the 49-bit time-of-day
- * value in the Titan chip.  The Titan is much more accurate than the value
- * returned by the service processor for the timebase frequency.
- */
-
-static int __init iSeries_tb_recal(void)
-{
-	unsigned long titan, tb;
-
-	/* Make sure we only run on iSeries */
-	if (!firmware_has_feature(FW_FEATURE_ISERIES))
-		return -ENODEV;
-
-	tb =3D get_tb();
-	titan =3D HvCallXm_loadTod();
-	if ( iSeries_recal_titan ) {
-		unsigned long tb_ticks =3D tb - iSeries_recal_tb;
-		unsigned long titan_usec =3D (titan - iSeries_recal_titan) >> 12;
-		unsigned long new_tb_ticks_per_sec   =3D (tb_ticks * USEC_PER_SEC)/titan=
_usec;
-		unsigned long new_tb_ticks_per_jiffy =3D
-			DIV_ROUND_CLOSEST(new_tb_ticks_per_sec, HZ);
-		long tick_diff =3D new_tb_ticks_per_jiffy - tb_ticks_per_jiffy;
-		char sign =3D '+';	=09
-		/* make sure tb_ticks_per_sec and tb_ticks_per_jiffy are consistent */
-		new_tb_ticks_per_sec =3D new_tb_ticks_per_jiffy * HZ;
-
-		if ( tick_diff < 0 ) {
-			tick_diff =3D -tick_diff;
-			sign =3D '-';
-		}
-		if ( tick_diff ) {
-			if ( tick_diff < tb_ticks_per_jiffy/25 ) {
-				printk( "Titan recalibrate: new tb_ticks_per_jiffy =3D %lu (%c%ld)\n",
-						new_tb_ticks_per_jiffy, sign, tick_diff );
-				tb_ticks_per_jiffy =3D new_tb_ticks_per_jiffy;
-				tb_ticks_per_sec   =3D new_tb_ticks_per_sec;
-				calc_cputime_factors();
-				vdso_data->tb_ticks_per_sec =3D tb_ticks_per_sec;
-				setup_cputime_one_jiffy();
-			}
-			else {
-				printk( "Titan recalibrate: FAILED (difference > 4 percent)\n"
-					"                   new tb_ticks_per_jiffy =3D %lu\n"
-					"                   old tb_ticks_per_jiffy =3D %lu\n",
-					new_tb_ticks_per_jiffy, tb_ticks_per_jiffy );
-			}
-		}
-	}
-	iSeries_recal_titan =3D titan;
-	iSeries_recal_tb =3D tb;
-
-	/* Called here as now we know accurate values for the timebase */
-	clocksource_init();
-	return 0;
-}
-late_initcall(iSeries_tb_recal);
-
-/* Called from platform early init */
-void __init iSeries_time_init_early(void)
-{
-	iSeries_recal_tb =3D get_tb();
-	iSeries_recal_titan =3D HvCallXm_loadTod();
-}
-#endif /* CONFIG_PPC_ISERIES */
-
 #ifdef CONFIG_IRQ_WORK
=20
 /*
@@ -547,16 +466,6 @@ void arch_irq_work_raise(void)
 #endif /* CONFIG_IRQ_WORK */
=20
 /*
- * For iSeries shared processors, we have to let the hypervisor
- * set the hardware decrementer.  We set a virtual decrementer
- * in the lppaca and call the hypervisor if the virtual
- * decrementer is less than the current value in the hardware
- * decrementer. (almost always the new decrementer value will
- * be greater than the current hardware decementer so the hypervisor
- * call will not be needed)
- */
-
-/*
  * timer_interrupt - gets called when the decrementer overflows,
  * with interrupts disabled.
  */
@@ -599,20 +508,10 @@ void timer_interrupt(struct pt_regs * regs)
 		irq_work_run();
 	}
=20
-#ifdef CONFIG_PPC_ISERIES
-	if (firmware_has_feature(FW_FEATURE_ISERIES))
-		get_lppaca()->int_dword.fields.decr_int =3D 0;
-#endif
-
 	*next_tb =3D ~(u64)0;
 	if (evt->event_handler)
 		evt->event_handler(evt);
=20
-#ifdef CONFIG_PPC_ISERIES
-	if (firmware_has_feature(FW_FEATURE_ISERIES) && hvlpevent_is_pending())
-		process_hvlpevents();
-#endif
-
 #ifdef CONFIG_PPC64
 	/* collect purr register values often, for accurate calculations */
 	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
@@ -984,9 +883,8 @@ void __init time_init(void)
 	 */
 	start_cpu_decrementer();
=20
-	/* Register the clocksource, if we're not running on iSeries */
-	if (!firmware_has_feature(FW_FEATURE_ISERIES))
-		clocksource_init();
+	/* Register the clocksource */
+	clocksource_init();
=20
 	init_decrementer_clockevent();
 }
diff --git a/arch/powerpc/lib/locks.c b/arch/powerpc/lib/locks.c
index a6ebba5..bb7cfec 100644
--- a/arch/powerpc/lib/locks.c
+++ b/arch/powerpc/lib/locks.c
@@ -19,11 +19,9 @@
 #include <linux/smp.h>
=20
 /* waiting for a spinlock... */
-#if defined(CONFIG_PPC_SPLPAR) || defined(CONFIG_PPC_ISERIES)
+#if defined(CONFIG_PPC_SPLPAR)
 #include <asm/hvcall.h>
-#include <asm/iseries/hv_call.h>
 #include <asm/smp.h>
-#include <asm/firmware.h>
=20
 void __spin_yield(arch_spinlock_t *lock)
 {
@@ -40,14 +38,8 @@ void __spin_yield(arch_spinlock_t *lock)
 	rmb();
 	if (lock->slock !=3D lock_value)
 		return;		/* something has changed */
-	if (firmware_has_feature(FW_FEATURE_ISERIES))
-		HvCall2(HvCallBaseYieldProcessor, HvCall_YieldToProc,
-			((u64)holder_cpu << 32) | yield_count);
-#ifdef CONFIG_PPC_SPLPAR
-	else
-		plpar_hcall_norets(H_CONFER,
-			get_hard_smp_processor_id(holder_cpu), yield_count);
-#endif
+	plpar_hcall_norets(H_CONFER,
+		get_hard_smp_processor_id(holder_cpu), yield_count);
 }
=20
 /*
@@ -71,14 +63,8 @@ void __rw_yield(arch_rwlock_t *rw)
 	rmb();
 	if (rw->lock !=3D lock_value)
 		return;		/* something has changed */
-	if (firmware_has_feature(FW_FEATURE_ISERIES))
-		HvCall2(HvCallBaseYieldProcessor, HvCall_YieldToProc,
-			((u64)holder_cpu << 32) | yield_count);
-#ifdef CONFIG_PPC_SPLPAR
-	else
-		plpar_hcall_norets(H_CONFER,
-			get_hard_smp_processor_id(holder_cpu), yield_count);
-#endif
+	plpar_hcall_norets(H_CONFER,
+		get_hard_smp_processor_id(holder_cpu), yield_count);
 }
 #endif
=20
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_6=
4.c
index b534bba..3e8c37a 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -56,6 +56,7 @@
 #include <asm/udbg.h>
 #include <asm/code-patching.h>
 #include <asm/fadump.h>
+#include <asm/firmware.h>
=20
 #ifdef DEBUG
 #define DBG(fmt...) udbg_printf(fmt)
@@ -756,12 +757,9 @@ void __init early_init_mmu(void)
 	 */
 	htab_initialize();
=20
-	/* Initialize stab / SLB management except on iSeries
-	 */
+	/* Initialize stab / SLB management */
 	if (mmu_has_feature(MMU_FTR_SLB))
 		slb_initialize();
-	else if (!firmware_has_feature(FW_FEATURE_ISERIES))
-		stab_initialize(get_paca()->stab_real);
 }
=20
 #ifdef CONFIG_SMP
@@ -772,8 +770,7 @@ void __cpuinit early_init_mmu_secondary(void)
 		mtspr(SPRN_SDR1, _SDR1);
=20
 	/* Initialize STAB/SLB. We use a virtual address as it works
-	 * in real mode on pSeries and we want a virtual address on
-	 * iSeries anyway
+	 * in real mode on pSeries.
 	 */
 	if (mmu_has_feature(MMU_FTR_SLB))
 		slb_initialize();
diff --git a/arch/powerpc/mm/slb.c b/arch/powerpc/mm/slb.c
index e22276c..a538c80 100644
--- a/arch/powerpc/mm/slb.c
+++ b/arch/powerpc/mm/slb.c
@@ -21,7 +21,6 @@
 #include <asm/cputable.h>
 #include <asm/cacheflush.h>
 #include <asm/smp.h>
-#include <asm/firmware.h>
 #include <linux/compiler.h>
 #include <asm/udbg.h>
 #include <asm/code-patching.h>
@@ -307,11 +306,6 @@ void slb_initialize(void)
=20
 	get_paca()->stab_rr =3D SLB_NUM_BOLTED;
=20
-	/* On iSeries the bolted entries have already been set up by
-	 * the hypervisor from the lparMap data in head.S */
-	if (firmware_has_feature(FW_FEATURE_ISERIES))
-		return;
-
 	lflags =3D SLB_VSID_KERNEL | linear_llp;
 	vflags =3D SLB_VSID_KERNEL | vmalloc_llp;
=20
diff --git a/arch/powerpc/mm/stab.c b/arch/powerpc/mm/stab.c
index 41e3164..9106ebb 100644
--- a/arch/powerpc/mm/stab.c
+++ b/arch/powerpc/mm/stab.c
@@ -21,8 +21,6 @@
 #include <asm/cputable.h>
 #include <asm/prom.h>
 #include <asm/abs_addr.h>
-#include <asm/firmware.h>
-#include <asm/iseries/hv_call.h>
=20
 struct stab_entry {
 	unsigned long esid_data;
@@ -285,12 +283,5 @@ void stab_initialize(unsigned long stab)
 	/* Set ASR */
 	stabreal =3D get_paca()->stab_real | 0x1ul;
=20
-#ifdef CONFIG_PPC_ISERIES
-	if (firmware_has_feature(FW_FEATURE_ISERIES)) {
-		HvCall1(HvCallBaseSetASR, stabreal);
-		return;
-	}
-#endif /* CONFIG_PPC_ISERIES */
-
 	mtspr(SPRN_ASR, stabreal);
 }
diff --git a/arch/powerpc/oprofile/common.c b/arch/powerpc/oprofile/common.c
index d65e68f..6f01624 100644
--- a/arch/powerpc/oprofile/common.c
+++ b/arch/powerpc/oprofile/common.c
@@ -195,9 +195,6 @@ int __init oprofile_arch_init(struct oprofile_operation=
s *ops)
 	if (!cur_cpu_spec->oprofile_cpu_type)
 		return -ENODEV;
=20
-	if (firmware_has_feature(FW_FEATURE_ISERIES))
-		return -ENODEV;
-
 	switch (cur_cpu_spec->oprofile_type) {
 #ifdef CONFIG_PPC_BOOK3S_64
 #ifdef CONFIG_OPROFILE_CELL
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/=
powernv/pci.c
index f92b9ef..214478d 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -31,6 +31,7 @@
 #include <asm/iommu.h>
 #include <asm/tce.h>
 #include <asm/abs_addr.h>
+#include <asm/firmware.h>
=20
 #include "powernv.h"
 #include "pci.h"
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms=
/pseries/lpar.c
index 7bc73af..5f3ef87 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -41,6 +41,7 @@
 #include <asm/udbg.h>
 #include <asm/smp.h>
 #include <asm/trace.h>
+#include <asm/firmware.h>
=20
 #include "plpar_wrappers.h"
 #include "pseries.h"
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 974a47b..68a9cbb 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -39,7 +39,6 @@
 #include <asm/irq_regs.h>
 #include <asm/spu.h>
 #include <asm/spu_priv1.h>
-#include <asm/firmware.h>
 #include <asm/setjmp.h>
 #include <asm/reg.h>
=20
@@ -1635,25 +1634,6 @@ static void super_regs(void)
 		       mfspr(SPRN_DEC), mfspr(SPRN_SPRG2));
 		printf("sp   =3D "REG"  sprg3=3D "REG"\n", sp, mfspr(SPRN_SPRG3));
 		printf("toc  =3D "REG"  dar  =3D "REG"\n", toc, mfspr(SPRN_DAR));
-#ifdef CONFIG_PPC_ISERIES
-		if (firmware_has_feature(FW_FEATURE_ISERIES)) {
-			struct paca_struct *ptrPaca;
-			struct lppaca *ptrLpPaca;
-
-			/* Dump out relevant Paca data areas. */
-			printf("Paca: \n");
-			ptrPaca =3D local_paca;
-
-			printf("  Local Processor Control Area (LpPaca): \n");
-			ptrLpPaca =3D ptrPaca->lppaca_ptr;
-			printf("    Saved Srr0=3D%.16lx  Saved Srr1=3D%.16lx \n",
-			       ptrLpPaca->saved_srr0, ptrLpPaca->saved_srr1);
-			printf("    Saved Gpr3=3D%.16lx  Saved Gpr4=3D%.16lx \n",
-			       ptrLpPaca->saved_gpr3, ptrLpPaca->saved_gpr4);
-			printf("    Saved Gpr5=3D%.16lx \n",
-				ptrLpPaca->gpr5_dword.saved_gpr5);
-		}
-#endif
=20
 		return;
 	}
@@ -2856,10 +2836,6 @@ static void dump_tlb_book3e(void)
=20
 static void xmon_init(int enable)
 {
-#ifdef CONFIG_PPC_ISERIES
-	if (firmware_has_feature(FW_FEATURE_ISERIES))
-		return;
-#endif
 	if (enable) {
 		__debugger =3D xmon;
 		__debugger_ipi =3D xmon_ipi;
@@ -2896,10 +2872,6 @@ static struct sysrq_key_op sysrq_xmon_op =3D {
=20
 static int __init setup_xmon_sysrq(void)
 {
-#ifdef CONFIG_PPC_ISERIES
-	if (firmware_has_feature(FW_FEATURE_ISERIES))
-		return 0;
-#endif
 	register_sysrq_key('x', &sysrq_xmon_op);
 	return 0;
 }
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Mar_2012_15_18_00_+1100_1M9hr/g0wJoshEdO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYr74AAoJEECxmPOUX5FEdBUP/2EMitYHFEzcqnJwxw0uN62L
lyGlEp8gA7hkP2Sx81KnNwiSkfilSKUp+As0xZln2Xds7MCrXrfSH9rut5W9lem/
8ArFu1hkD4I/B3R6ikM14gtCnrGl28kwGpifRnn9sEl0jLmAsyeVD3XsXMTX5boH
IGRRzkVEtQnjkuL1rr/NtkTYyyh0CZwla4ABrVWRDkkwLtTnyJPhih6PbdmPECbD
5N/8Rtyiwi7TbmuZvzKQ1ttAVSo4hYg+lJvttM1TCeY5R+nixLsGjbjN9YKE8n4p
OKqrnzPW2sRlTyX/uJUv2iUyoEzqwjSjxvE0855J0HZNYR/ReRwm/+OIreE8biZD
pyBM08OzQv7HJ2q+h9arBAFPePuDJxduRwfE6JFmUY6wQAbtXDe7+ymeF+PrENr4
wypWSfc2V5Gw1tKTIXIgRZ/6U2zxN9F+EQrFOdyC5HN3qmu8t1nY11fOm1whHEzu
m8u54f2+rZj8s64dhgCXkyi1gMmrauaEdAnPuPrN7kv92da1e8acIQ4x81GesFNg
3F175M2VacW1EenATmab2HKP2CAUT/mcKDx8izGjRN4Hp+XjCgz7BhCwMPKGDQYf
th+BRhv7DPN+6KoTteDSm1tnRAMwcY9Xvrt+ZyHj1p1m4ST3FnJTDdwfGpijTWCS
Drum/0G6RiX5/kofsK58
=ZiSz
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Mar_2012_15_18_00_+1100_1M9hr/g0wJoshEdO--
