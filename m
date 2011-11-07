Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab1KGWb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 17:31:58 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59156 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176Ab1KGWbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 17:31:55 -0500
X-Sasl-enc: +oThmXoQN0TleFI65ptLzn4juJhb2NYSlqEFwNhWdpPY 1320705113
Date: Mon, 7 Nov 2011 14:31:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.33.20
Message-ID: <20111107223129.GB21771@kroah.com>
References: <20111107223111.GA21771@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107223111.GA21771@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index 5effa5b..2e073d5 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -25,10 +25,10 @@ Rules on what kind of patches are accepted, and which ones are not, into the
 Procedure for submitting patches to the -stable tree:
 
  - Send the patch, after verifying that it follows the above rules, to
-   stable@kernel.org.
+   stable@vger.kernel.org.
  - To have the patch automatically included in the stable tree, add the
    the tag
-     Cc: stable@kernel.org
+     Cc: stable@vger.kernel.org
    in the sign-off area. Once the patch is merged it will be applied to
    the stable tree without anything else needing to be done by the author
    or subsystem maintainer.
@@ -36,10 +36,10 @@ Procedure for submitting patches to the -stable tree:
    cherry-picked than this can be specified in the following format in
    the sign-off area:
 
-     Cc: <stable@kernel.org> # .32.x: a1f84a3: sched: Check for idle
-     Cc: <stable@kernel.org> # .32.x: 1b9508f: sched: Rate-limit newidle
-     Cc: <stable@kernel.org> # .32.x: fd21073: sched: Fix affinity logic
-     Cc: <stable@kernel.org> # .32.x
+     Cc: <stable@vger.kernel.org> # .32.x: a1f84a3: sched: Check for idle
+     Cc: <stable@vger.kernel.org> # .32.x: 1b9508f: sched: Rate-limit newidle
+     Cc: <stable@vger.kernel.org> # .32.x: fd21073: sched: Fix affinity logic
+     Cc: <stable@vger.kernel.org> # .32.x
     Signed-off-by: Ingo Molnar <mingo@elte.hu>
 
    The tag sequence has the meaning of:
diff --git a/Makefile b/Makefile
index 7c40be6..2349341 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 33
-EXTRAVERSION = .19
+EXTRAVERSION = .20
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 07de8db..3ecd94b 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -44,6 +44,32 @@
 
 #define DA850_MII_MDIO_CLKEN_PIN	GPIO_TO_PIN(2, 6)
 
+#ifdef CONFIG_MTD
+static void da850_evm_m25p80_notify_add(struct mtd_info *mtd)
+{
+	char *mac_addr = davinci_soc_info.emac_pdata->mac_addr;
+	size_t retlen;
+
+	if (!strcmp(mtd->name, "MAC-Address")) {
+		mtd->read(mtd, 0, ETH_ALEN, &retlen, mac_addr);
+		if (retlen == ETH_ALEN)
+			pr_info("Read MAC addr from SPI Flash: %pM\n",
+				mac_addr);
+	}
+}
+
+static struct mtd_notifier da850evm_spi_notifier = {
+	.add	= da850_evm_m25p80_notify_add,
+};
+
+static void da850_evm_setup_mac_addr(void)
+{
+	register_mtd_user(&da850evm_spi_notifier);
+}
+#else
+static void da850_evm_setup_mac_addr(void) { }
+#endif
+
 static struct mtd_partition da850_evm_norflash_partition[] = {
 	{
 		.name           = "NOR filesystem",
@@ -696,6 +722,8 @@ static __init void da850_evm_init(void)
 	if (ret)
 		pr_warning("da850_evm_init: cpuidle registration failed: %d\n",
 				ret);
+
+	da850_evm_setup_mac_addr();
 }
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE
diff --git a/arch/arm/plat-mxc/include/mach/iomux-v3.h b/arch/arm/plat-mxc/include/mach/iomux-v3.h
index 1deda01..657c252 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-v3.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-v3.h
@@ -73,11 +73,11 @@ struct pad_desc {
 #define PAD_CTL_HYS			(1 << 8)
 
 #define PAD_CTL_PKE			(1 << 7)
-#define PAD_CTL_PUE			(1 << 6)
-#define PAD_CTL_PUS_100K_DOWN		(0 << 4)
-#define PAD_CTL_PUS_47K_UP		(1 << 4)
-#define PAD_CTL_PUS_100K_UP		(2 << 4)
-#define PAD_CTL_PUS_22K_UP		(3 << 4)
+#define PAD_CTL_PUE			(1 << 6 | PAD_CTL_PKE)
+#define PAD_CTL_PUS_100K_DOWN		(0 << 4 | PAD_CTL_PUE)
+#define PAD_CTL_PUS_47K_UP		(1 << 4 | PAD_CTL_PUE)
+#define PAD_CTL_PUS_100K_UP		(2 << 4 | PAD_CTL_PUE)
+#define PAD_CTL_PUS_22K_UP		(3 << 4 | PAD_CTL_PUE)
 
 #define PAD_CTL_ODE			(1 << 3)
 
diff --git a/arch/mips/alchemy/mtx-1/platform.c b/arch/mips/alchemy/mtx-1/platform.c
index 956f946..e30e42a 100644
--- a/arch/mips/alchemy/mtx-1/platform.c
+++ b/arch/mips/alchemy/mtx-1/platform.c
@@ -28,8 +28,6 @@
 #include <linux/mtd/physmap.h>
 #include <mtd/mtd-abi.h>
 
-#include <asm/mach-au1x00/au1xxx_eth.h>
-
 static struct gpio_keys_button mtx1_gpio_button[] = {
 	{
 		.gpio = 207,
@@ -142,17 +140,10 @@ static struct __initdata platform_device * mtx1_devs[] = {
 	&mtx1_mtd,
 };
 
-static struct au1000_eth_platform_data mtx1_au1000_eth0_pdata = {
-	.phy_search_highest_addr	= 1,
-	.phy1_search_mac0 		= 1,
-};
-
 static int __init mtx1_register_devices(void)
 {
 	int rc;
 
-	au1xxx_override_eth_cfg(0, &mtx1_au1000_eth0_pdata);
-
 	rc = gpio_request(mtx1_gpio_button[0].gpio,
 					mtx1_gpio_button[0].desc);
 	if (rc < 0) {
diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index 4aa1740..5c3c8c9 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -310,6 +310,8 @@ static void __devinit __of_scan_bus(struct device_node *node,
 	/* Scan direct children */
 	for_each_child_of_node(node, child) {
 		pr_debug("  * %s\n", child->full_name);
+		if (!of_device_is_available(child))
+			continue;
 		reg = of_get_property(child, "reg", &reglen);
 		if (reg == NULL || reglen < 20)
 			continue;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e06d18c..60d78e7 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -309,11 +309,17 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 				      unsigned int id)
 {
-	struct kvm_vcpu *vcpu = kzalloc(sizeof(struct kvm_vcpu), GFP_KERNEL);
-	int rc = -ENOMEM;
+	struct kvm_vcpu *vcpu;
+	int rc = -EINVAL;
+
+	if (id >= KVM_MAX_VCPUS)
+		goto out;
+
+	rc = -ENOMEM;
 
+	vcpu = kzalloc(sizeof(struct kvm_vcpu), GFP_KERNEL);
 	if (!vcpu)
-		goto out_nomem;
+		goto out;
 
 	vcpu->arch.sie_block = (struct kvm_s390_sie_block *)
 					get_zeroed_page(GFP_KERNEL);
@@ -348,7 +354,7 @@ out_free_sie_block:
 	free_page((unsigned long)(vcpu->arch.sie_block));
 out_free_cpu:
 	kfree(vcpu);
-out_nomem:
+out:
 	return ERR_PTR(rc);
 }
 
diff --git a/arch/sparc/include/asm/spinlock_32.h b/arch/sparc/include/asm/spinlock_32.h
index 7f9b9db..dc1355f 100644
--- a/arch/sparc/include/asm/spinlock_32.h
+++ b/arch/sparc/include/asm/spinlock_32.h
@@ -130,6 +130,15 @@ static inline void arch_write_lock(arch_rwlock_t *rw)
 	*(volatile __u32 *)&lp->lock = ~0U;
 }
 
+static void inline arch_write_unlock(arch_rwlock_t *lock)
+{
+	__asm__ __volatile__(
+"	st		%%g0, [%0]"
+	: /* no outputs */
+	: "r" (lock)
+	: "memory");
+}
+
 static inline int arch_write_trylock(arch_rwlock_t *rw)
 {
 	unsigned int val;
@@ -174,8 +183,6 @@ static inline int __arch_read_trylock(arch_rwlock_t *rw)
 	res; \
 })
 
-#define arch_write_unlock(rw)	do { (rw)->lock = 0; } while(0)
-
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
 #define arch_read_lock_flags(rw, flags)   arch_read_lock(rw)
 #define arch_write_lock_flags(rw, flags)  arch_write_lock(rw)
diff --git a/arch/sparc/include/asm/spinlock_64.h b/arch/sparc/include/asm/spinlock_64.h
index 073936a..9689176 100644
--- a/arch/sparc/include/asm/spinlock_64.h
+++ b/arch/sparc/include/asm/spinlock_64.h
@@ -210,14 +210,8 @@ static int inline arch_write_trylock(arch_rwlock_t *lock)
 	return result;
 }
 
-#define arch_read_lock(p)	arch_read_lock(p)
 #define arch_read_lock_flags(p, f) arch_read_lock(p)
-#define arch_read_trylock(p)	arch_read_trylock(p)
-#define arch_read_unlock(p)	arch_read_unlock(p)
-#define arch_write_lock(p)	arch_write_lock(p)
 #define arch_write_lock_flags(p, f) arch_write_lock(p)
-#define arch_write_unlock(p)	arch_write_unlock(p)
-#define arch_write_trylock(p)	arch_write_trylock(p)
 
 #define arch_read_can_lock(rw)		(!((rw)->lock & 0x80000000UL))
 #define arch_write_can_lock(rw)	(!(rw)->lock)
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index 4e2724e..c6ed432 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -349,8 +349,8 @@ int __init pcic_probe(void)
 	strcpy(pbm->prom_name, namebuf);
 
 	{
-		extern volatile int t_nmi[1];
-		extern int pcic_nmi_trap_patch[1];
+		extern volatile int t_nmi[4];
+		extern int pcic_nmi_trap_patch[4];
 
 		t_nmi[0] = pcic_nmi_trap_patch[0];
 		t_nmi[1] = pcic_nmi_trap_patch[1];
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7eb1dd7..79d59af 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -767,6 +767,29 @@ extern unsigned long		boot_option_idle_override;
 extern unsigned long		idle_halt;
 extern unsigned long		idle_nomwait;
 
+/*
+ * on systems with caches, caches must be flashed as the absolute
+ * last instruction before going into a suspended halt.  Otherwise,
+ * dirty data can linger in the cache and become stale on resume,
+ * leading to strange errors.
+ *
+ * perform a variety of operations to guarantee that the compiler
+ * will not reorder instructions.  wbinvd itself is serializing
+ * so the processor will not reorder.
+ *
+ * Systems without cache can just go into halt.
+ */
+static inline void wbinvd_halt(void)
+{
+	mb();
+	/* check for clflush to determine if wbinvd is legal */
+	if (cpu_has_clflush)
+		asm volatile("cli; wbinvd; 1: hlt; jmp 1b" : : : "memory");
+	else
+		while (1)
+			halt();
+}
+
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index e803550..0773533 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1066,7 +1066,7 @@ static int alloc_new_range(struct dma_ops_domain *dma_dom,
 		if (!pte || !IOMMU_PTE_PRESENT(*pte))
 			continue;
 
-		dma_ops_reserve_addresses(dma_dom, i << PAGE_SHIFT, 1);
+		dma_ops_reserve_addresses(dma_dom, i >> PAGE_SHIFT, 1);
 	}
 
 	update_domain(&dma_dom->domain);
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 5b8c750..f672f97 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -74,8 +74,10 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 	/*
 	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
 	 * Groups, and some special opcodes can not boost.
+	 * This is non-const to keep gcc from statically optimizing it out, as
+	 * variable_test_bit makes gcc think only *(unsigned long*) is used.
 	 */
-static const u32 twobyte_is_boostable[256 / 32] = {
+static u32 twobyte_is_boostable[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
 	/*      ----------------------------------------------          */
 	W(0x00, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0) | /* 00 */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ea1ab22..f9bdcdb 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1329,94 +1329,11 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
-#define MWAIT_SUBSTATE_MASK		0xf
-#define MWAIT_SUBSTATE_SIZE		4
-
-#define CPUID_MWAIT_LEAF		5
-#define CPUID5_ECX_EXTENSIONS_SUPPORTED 0x1
-
-/*
- * We need to flush the caches before going to sleep, lest we have
- * dirty data in our caches when we come back up.
- */
-static inline void mwait_play_dead(void)
-{
-	unsigned int eax, ebx, ecx, edx;
-	unsigned int highest_cstate = 0;
-	unsigned int highest_subcstate = 0;
-	int i;
-	void *mwait_ptr;
-
-	if (!cpu_has(&current_cpu_data, X86_FEATURE_MWAIT))
-		return;
-	if (!cpu_has(&current_cpu_data, X86_FEATURE_CLFLSH))
-		return;
-	if (current_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
-		return;
-
-	eax = CPUID_MWAIT_LEAF;
-	ecx = 0;
-	native_cpuid(&eax, &ebx, &ecx, &edx);
-
-	/*
-	 * eax will be 0 if EDX enumeration is not valid.
-	 * Initialized below to cstate, sub_cstate value when EDX is valid.
-	 */
-	if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED)) {
-		eax = 0;
-	} else {
-		edx >>= MWAIT_SUBSTATE_SIZE;
-		for (i = 0; i < 7 && edx; i++, edx >>= MWAIT_SUBSTATE_SIZE) {
-			if (edx & MWAIT_SUBSTATE_MASK) {
-				highest_cstate = i;
-				highest_subcstate = edx & MWAIT_SUBSTATE_MASK;
-			}
-		}
-		eax = (highest_cstate << MWAIT_SUBSTATE_SIZE) |
-			(highest_subcstate - 1);
-	}
-
-	/*
-	 * This should be a memory location in a cache line which is
-	 * unlikely to be touched by other processors.  The actual
-	 * content is immaterial as it is not actually modified in any way.
-	 */
-	mwait_ptr = &current_thread_info()->flags;
-
-	wbinvd();
-
-	while (1) {
-		/*
-		 * The CLFLUSH is a workaround for erratum AAI65 for
-		 * the Xeon 7400 series.  It's not clear it is actually
-		 * needed, but it should be harmless in either case.
-		 * The WBINVD is insufficient due to the spurious-wakeup
-		 * case where we return around the loop.
-		 */
-		clflush(mwait_ptr);
-		__monitor(mwait_ptr, 0, 0);
-		mb();
-		__mwait(eax, 0);
-	}
-}
-
-static inline void hlt_play_dead(void)
-{
-	if (current_cpu_data.x86 >= 4)
-		wbinvd();
-
-	while (1) {
-		native_halt();
-	}
-}
-
 void native_play_dead(void)
 {
 	play_dead_common();
 	tboot_shutdown(TB_SHUTDOWN_WFS);
-
-	mwait_play_dead();	/* Only returns on failure */
-	hlt_play_dead();
+	wbinvd_halt();
 }
 
 #else /* ... !CONFIG_HOTPLUG_CPU */
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index ad5df67..6c6e733 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -30,6 +30,7 @@
 #include <xen/page.h>
 #include <xen/events.h>
 
+#include <xen/hvc-console.h>
 #include "xen-ops.h"
 #include "mmu.h"
 
@@ -180,6 +181,15 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 {
 	unsigned cpu;
 
+	if (skip_ioapic_setup) {
+		char *m = (max_cpus == 0) ?
+			"The nosmp parameter is incompatible with Xen; " \
+			"use Xen dom0_max_vcpus=1 parameter" :
+			"The noapic parameter is incompatible with Xen";
+
+		xen_raw_printk(m);
+		panic(m);
+	}
 	xen_init_lock_cpu(0);
 
 	smp_store_cpu_info(0);
diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
index 88e15de..9a95a9c 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -113,11 +113,13 @@ xen_iret_start_crit:
 
 	/*
 	 * If there's something pending, mask events again so we can
-	 * jump back into xen_hypervisor_callback
+	 * jump back into xen_hypervisor_callback. Otherwise do not
+	 * touch XEN_vcpu_info_mask.
 	 */
-	sete XEN_vcpu_info_mask(%eax)
+	jne 1f
+	movb $1, XEN_vcpu_info_mask(%eax)
 
-	popl %eax
+1:	popl %eax
 
 	/*
 	 * From this point on the registers are restored and the stack
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 198224b..fd38ea9 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -2769,6 +2769,18 @@ static bool ahci_sb600_enable_64bit(struct pci_dev *pdev)
 				DMI_MATCH(DMI_BOARD_NAME, "MS-7376"),
 			},
 		},
+		/*
+		 * All BIOS versions for the Asus M3A support 64bit DMA.
+		 * (all release versions from 0301 to 1206 were tested)
+		 */
+		{
+			.ident = "ASUS M3A",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR,
+					  "ASUSTeK Computer INC."),
+				DMI_MATCH(DMI_BOARD_NAME, "M3A"),
+			},
+		},
 		{ }
 	};
 	const struct dmi_system_id *match;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 05a31e5..ed39cb1 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -890,7 +890,7 @@ static void blkfront_connect(struct blkfront_info *info)
 	}
 
 	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
-			    "feature-barrier", "%lu", &info->feature_barrier,
+			    "feature-barrier", "%d", &info->feature_barrier,
 			    NULL);
 	if (err)
 		info->feature_barrier = 0;
diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index 416d342..8894255 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -162,8 +162,10 @@ static void hvc_console_print(struct console *co, const char *b,
 		} else {
 			r = cons_ops[index]->put_chars(vtermnos[index], c, i);
 			if (r <= 0) {
-				/* throw away chars on error */
-				i = 0;
+				/* throw away characters on error
+				 * but spin in case of -EAGAIN */
+				if (r != -EAGAIN)
+					i = 0;
 			} else if (r > 0) {
 				i -= r;
 				if (i > 0)
@@ -442,7 +444,7 @@ static int hvc_push(struct hvc_struct *hp)
 
 	n = hp->ops->put_chars(hp->vtermno, hp->outbuf, hp->n_outbuf);
 	if (n <= 0) {
-		if (n == 0) {
+		if (n == 0 || n == -EAGAIN) {
 			hp->do_wakeup = 1;
 			return 0;
 		}
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 4b6c3ea..6fc2332 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -374,6 +374,9 @@ static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 	u32 count, ordinal;
 	unsigned long stop;
 
+	if (bufsiz > TPM_BUFSIZE)
+		bufsiz = TPM_BUFSIZE;
+
 	count = be32_to_cpu(*((__be32 *) (buf + 2)));
 	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 	if (count == 0)
@@ -1027,6 +1030,7 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 {
 	struct tpm_chip *chip = file->private_data;
 	ssize_t ret_size;
+	int rc;
 
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	flush_scheduled_work();
@@ -1037,8 +1041,11 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 			ret_size = size;
 
 		mutex_lock(&chip->buffer_mutex);
-		if (copy_to_user(buf, chip->data_buffer, ret_size))
+		rc = copy_to_user(buf, chip->data_buffer, ret_size);
+		memset(chip->data_buffer, 0, ret_size);
+		if (rc)
 			ret_size = -EFAULT;
+
 		mutex_unlock(&chip->buffer_mutex);
 	}
 
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 5ec8a79..e9a160d 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -389,6 +389,9 @@
 #define USB_VENDOR_ID_SAMSUNG		0x0419
 #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE	0x0001
 
+#define USB_VENDOR_ID_SIGMA_MICRO	0x1c4f
+#define USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD	0x0002
+
 #define USB_VENDOR_ID_SONY			0x054c
 #define USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE	0x024b
 #define USB_DEVICE_ID_SONY_PS3_CONTROLLER	0x0268
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 38773dc..24d8704 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -66,6 +66,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_WISEGROUP_LTD, USB_DEVICE_ID_SMARTJOY_DUAL_PLUS, HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_WISEGROUP_LTD2, USB_DEVICE_ID_SMARTJOY_DUAL_PLUS, HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
 
+	{ USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD, HID_QUIRK_NO_INIT_REPORTS },
 	{ 0, 0 }
 };
 
diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 0dcaba9..a679d01 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -1273,7 +1273,8 @@ static void w83627ehf_device_remove_files(struct device *dev)
 }
 
 /* Get the monitoring functions started */
-static inline void __devinit w83627ehf_init_device(struct w83627ehf_data *data)
+static inline void __devinit w83627ehf_init_device(struct w83627ehf_data *data,
+						   enum kinds kind)
 {
 	int i;
 	u8 tmp, diode;
@@ -1302,10 +1303,16 @@ static inline void __devinit w83627ehf_init_device(struct w83627ehf_data *data)
 		w83627ehf_write_value(data, W83627EHF_REG_VBAT, tmp | 0x01);
 
 	/* Get thermal sensor types */
-	diode = w83627ehf_read_value(data, W83627EHF_REG_DIODE);
+	switch (kind) {
+	case w83627ehf:
+		diode = w83627ehf_read_value(data, W83627EHF_REG_DIODE);
+		break;
+	default:
+		diode = 0x70;
+	}
 	for (i = 0; i < 3; i++) {
 		if ((tmp & (0x02 << i)))
-			data->temp_type[i] = (diode & (0x10 << i)) ? 1 : 2;
+			data->temp_type[i] = (diode & (0x10 << i)) ? 1 : 3;
 		else
 			data->temp_type[i] = 4; /* thermistor */
 	}
@@ -1353,7 +1360,7 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize the chip */
-	w83627ehf_init_device(data);
+	w83627ehf_init_device(data, sio_data->kind);
 
 	data->vrm = vid_which_vrm();
 	superio_enter(sio_data->sioreg);
diff --git a/drivers/md/linear.h b/drivers/md/linear.h
index 0ce29b6..2f2da05 100644
--- a/drivers/md/linear.h
+++ b/drivers/md/linear.h
@@ -10,9 +10,9 @@ typedef struct dev_info dev_info_t;
 
 struct linear_private_data
 {
+	struct rcu_head		rcu;
 	sector_t		array_sectors;
 	dev_info_t		disks[0];
-	struct rcu_head		rcu;
 };
 
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4610aa3..803f101 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -980,8 +980,11 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
 			ret = 0;
 	}
 	rdev->sectors = rdev->sb_start;
+	/* Limit to 4TB as metadata cannot record more than that */
+	if (rdev->sectors >= (2ULL << 32))
+		rdev->sectors = (2ULL << 32) - 2;
 
-	if (rdev->sectors < sb->size * 2 && sb->level > 1)
+	if (rdev->sectors < ((sector_t)sb->size) * 2 && sb->level >= 1)
 		/* "this cannot possibly happen" ... */
 		ret = -EINVAL;
 
@@ -1016,7 +1019,7 @@ static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 		mddev->clevel[0] = 0;
 		mddev->layout = sb->layout;
 		mddev->raid_disks = sb->raid_disks;
-		mddev->dev_sectors = sb->size * 2;
+		mddev->dev_sectors = ((sector_t)sb->size) * 2;
 		mddev->events = ev1;
 		mddev->bitmap_info.offset = 0;
 		mddev->bitmap_info.default_offset = MD_SB_BYTES >> 9;
@@ -1255,6 +1258,11 @@ super_90_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 	rdev->sb_start = calc_dev_sboffset(rdev->bdev);
 	if (!num_sectors || num_sectors > rdev->sb_start)
 		num_sectors = rdev->sb_start;
+	/* Limit to 4TB as metadata cannot record more than that.
+	 * 4TB == 2^32 KB, or 2*2^32 sectors.
+	 */
+	if (num_sectors >= (2ULL << 32))
+		num_sectors = (2ULL << 32) - 2;
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index e45d2df..a4f03e8 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -741,7 +741,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			static struct xc2028_ctrl ctl = {
 				.fname   = XC3028L_DEFAULT_FIRMWARE,
 				.max_len = 64,
-				.demod   = 5000,
+				.demod   = XC3028_FE_DIBCOM52,
 				/* This is true for all demods with
 					v36 firmware? */
 				.type    = XC2028_D2633,
diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 86699b1..860e823 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1891,7 +1891,7 @@ static int __uvc_resume(struct usb_interface *intf, int reset)
 
 	list_for_each_entry(stream, &dev->streams, list) {
 		if (stream->intf == intf)
-			return uvc_video_resume(stream);
+			return uvc_video_resume(stream, reset);
 	}
 
 	uvc_trace(UVC_TRACE_SUSPEND, "Resume: video streaming USB interface "
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 253eed8..a463b48 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -1045,10 +1045,18 @@ int uvc_video_suspend(struct uvc_streaming *stream)
  * buffers, making sure userspace applications are notified of the problem
  * instead of waiting forever.
  */
-int uvc_video_resume(struct uvc_streaming *stream)
+int uvc_video_resume(struct uvc_streaming *stream, int reset)
 {
 	int ret;
 
+	/* If the bus has been reset on resume, set the alternate setting to 0.
+	 * This should be the default value, but some devices crash or otherwise
+	 * misbehave if they don't receive a SET_INTERFACE request before any
+	 * other video control request.
+	 */
+	if (reset)
+		usb_set_interface(stream->dev->udev, stream->intfnum, 0);
+
 	stream->frozen = 0;
 
 	ret = uvc_commit_video(stream, &stream->ctrl);
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index b6f6f38..f5925f6 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -604,7 +604,7 @@ extern const struct v4l2_file_operations uvc_fops;
 /* Video */
 extern int uvc_video_init(struct uvc_streaming *stream);
 extern int uvc_video_suspend(struct uvc_streaming *stream);
-extern int uvc_video_resume(struct uvc_streaming *stream);
+extern int uvc_video_resume(struct uvc_streaming *stream, int reset);
 extern int uvc_video_enable(struct uvc_streaming *stream, int enable);
 extern int uvc_probe_video(struct uvc_streaming *stream,
 		struct uvc_streaming_control *probe);
diff --git a/drivers/net/cnic.c b/drivers/net/cnic.c
index 4332b3a..cd43fbb 100644
--- a/drivers/net/cnic.c
+++ b/drivers/net/cnic.c
@@ -4520,7 +4520,7 @@ static int cnic_netdev_event(struct notifier_block *this, unsigned long event,
 
 	dev = cnic_from_netdev(netdev);
 
-	if (!dev && (event == NETDEV_REGISTER || event == NETDEV_UP)) {
+	if (!dev && (event == NETDEV_REGISTER || netif_running(netdev))) {
 		/* Check for the hot-plug device */
 		dev = is_cnic_dev(netdev);
 		if (dev) {
@@ -4536,7 +4536,7 @@ static int cnic_netdev_event(struct notifier_block *this, unsigned long event,
 		else if (event == NETDEV_UNREGISTER)
 			cnic_ulp_exit(dev);
 
-		if (event == NETDEV_UP) {
+		if (event == NETDEV_UP || (new_dev && netif_running(netdev))) {
 			if (cnic_register_netdev(dev) != 0) {
 				cnic_put(dev);
 				goto done;
diff --git a/drivers/net/e1000/e1000_hw.c b/drivers/net/e1000/e1000_hw.c
index 8d7d87f..0d82be0 100644
--- a/drivers/net/e1000/e1000_hw.c
+++ b/drivers/net/e1000/e1000_hw.c
@@ -3842,6 +3842,12 @@ s32 e1000_validate_eeprom_checksum(struct e1000_hw *hw)
 		checksum += eeprom_data;
 	}
 
+#ifdef CONFIG_PARISC
+	/* This is a signature and not a checksum on HP c8000 */
+	if ((hw->subsystem_vendor_id == 0x103C) && (eeprom_data == 0x16d6))
+		return E1000_SUCCESS;
+
+#endif
 	if (checksum == (u16) EEPROM_SUM)
 		return E1000_SUCCESS;
 	else {
diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
index 8f7d0d1..eeeca07 100644
--- a/drivers/net/irda/smsc-ircc2.c
+++ b/drivers/net/irda/smsc-ircc2.c
@@ -515,7 +515,7 @@ static const struct net_device_ops smsc_ircc_netdev_ops = {
  *    Try to open driver instance
  *
  */
-static int __init smsc_ircc_open(unsigned int fir_base, unsigned int sir_base, u8 dma, u8 irq)
+static int __devinit smsc_ircc_open(unsigned int fir_base, unsigned int sir_base, u8 dma, u8 irq)
 {
 	struct smsc_ircc_cb *self;
 	struct net_device *dev;
diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index ede937e..ae88ce8 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -87,8 +87,8 @@ static struct rio_dev **rionet_active;
 #define dev_rionet_capable(dev) \
 	is_rionet_capable(dev->pef, dev->src_ops, dev->dst_ops)
 
-#define RIONET_MAC_MATCH(x)	(*(u32 *)x == 0x00010001)
-#define RIONET_GET_DESTID(x)	(*(u16 *)(x + 4))
+#define RIONET_MAC_MATCH(x)	(!memcmp((x), "\00\01\00\01", 4))
+#define RIONET_GET_DESTID(x)	((*((u8 *)x + 4) << 8) | *((u8 *)x + 5))
 
 static int rionet_rx_clean(struct net_device *ndev)
 {
diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index a516185..4dfbc79 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -1441,6 +1441,10 @@ static const struct usb_device_id	products [] = {
 	USB_DEVICE (0x04f1, 0x3008),
 	.driver_info = (unsigned long) &ax8817x_info,
 }, {
+	// ASIX AX88772B 10/100
+	USB_DEVICE (0x0b95, 0x772b),
+	.driver_info = (unsigned long) &ax88772_info,
+}, {
 	// ASIX AX88772 10/100
 	USB_DEVICE (0x0b95, 0x7720),
 	.driver_info = (unsigned long) &ax88772_info,
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 9eb4f5e..f16c136 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1526,7 +1526,8 @@ static void handle_irq_beacon(struct b43_wldev *dev)
 	u32 cmd, beacon0_valid, beacon1_valid;
 
 	if (!b43_is_mode(wl, NL80211_IFTYPE_AP) &&
-	    !b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT))
+	    !b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT) &&
+	    !b43_is_mode(wl, NL80211_IFTYPE_ADHOC))
 		return;
 
 	/* This is the bottom half of the asynchronous beacon update. */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9deae41..60f7ba4 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1694,14 +1694,15 @@ static void rt2800_efuse_read(struct rt2x00_dev *rt2x00dev, unsigned int i)
 	rt2800_regbusy_read(rt2x00dev, EFUSE_CTRL, EFUSE_CTRL_KICK, &reg);
 
 	/* Apparently the data is read from end to start */
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA3,
-					(u32 *)&rt2x00dev->eeprom[i]);
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA2,
-					(u32 *)&rt2x00dev->eeprom[i + 2]);
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA1,
-					(u32 *)&rt2x00dev->eeprom[i + 4]);
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA0,
-					(u32 *)&rt2x00dev->eeprom[i + 6]);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA3, &reg);
+	/* The returned value is in CPU order, but eeprom is le */
+	rt2x00dev->eeprom[i] = cpu_to_le32(reg);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA2, &reg);
+	*(u32 *)&rt2x00dev->eeprom[i + 2] = cpu_to_le32(reg);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA1, &reg);
+	*(u32 *)&rt2x00dev->eeprom[i + 4] = cpu_to_le32(reg);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA0, &reg);
+	*(u32 *)&rt2x00dev->eeprom[i + 6] = cpu_to_le32(reg);
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 0a751e7..3c3e1ec 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -705,18 +705,8 @@ int rt2x00usb_suspend(struct usb_interface *usb_intf, pm_message_t state)
 {
 	struct ieee80211_hw *hw = usb_get_intfdata(usb_intf);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	int retval;
-
-	retval = rt2x00lib_suspend(rt2x00dev, state);
-	if (retval)
-		return retval;
 
-	/*
-	 * Decrease usbdev refcount.
-	 */
-	usb_put_dev(interface_to_usbdev(usb_intf));
-
-	return 0;
+	return rt2x00lib_suspend(rt2x00dev, state);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_suspend);
 
@@ -725,8 +715,6 @@ int rt2x00usb_resume(struct usb_interface *usb_intf)
 	struct ieee80211_hw *hw = usb_get_intfdata(usb_intf);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
-	usb_get_dev(interface_to_usbdev(usb_intf));
-
 	return rt2x00lib_resume(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_resume);
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e7b0c3b..6fa918c 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -122,7 +122,9 @@ enum {
 };
 
 /* ACPI HIDs */
-#define TPACPI_ACPI_HKEY_HID		"IBM0068"
+#define TPACPI_ACPI_IBM_HKEY_HID	"IBM0068"
+#define TPACPI_ACPI_LENOVO_HKEY_HID	"LEN0068"
+#define TPACPI_ACPI_EC_HID		"PNP0C09"
 
 /* Input IDs */
 #define TPACPI_HKEY_INPUT_PRODUCT	0x5054 /* "TP" */
@@ -3849,7 +3851,8 @@ errexit:
 }
 
 static const struct acpi_device_id ibm_htk_device_ids[] = {
-	{TPACPI_ACPI_HKEY_HID, 0},
+	{TPACPI_ACPI_IBM_HKEY_HID, 0},
+	{TPACPI_ACPI_LENOVO_HKEY_HID, 0},
 	{"", 0},
 };
 
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 5f97ea2..fcedb92 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -66,6 +66,12 @@ __ccwgroup_remove_symlinks(struct ccwgroup_device *gdev)
 	
 }
 
+static ssize_t ccwgroup_online_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count);
+static ssize_t ccwgroup_online_show(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf);
 /*
  * Provide an 'ungroup' attribute so the user can remove group devices no
  * longer needed or accidentially created. Saves memory :)
@@ -112,6 +118,20 @@ out:
 }
 
 static DEVICE_ATTR(ungroup, 0200, NULL, ccwgroup_ungroup_store);
+static DEVICE_ATTR(online, 0644, ccwgroup_online_show, ccwgroup_online_store);
+
+static struct attribute *ccwgroup_attrs[] = {
+	&dev_attr_online.attr,
+	&dev_attr_ungroup.attr,
+	NULL,
+};
+static struct attribute_group ccwgroup_attr_group = {
+	.attrs = ccwgroup_attrs,
+};
+static const struct attribute_group *ccwgroup_attr_groups[] = {
+	&ccwgroup_attr_group,
+	NULL,
+};
 
 static void
 ccwgroup_release (struct device *dev)
@@ -280,25 +300,17 @@ int ccwgroup_create_from_string(struct device *root, unsigned int creator_id,
 	}
 
 	dev_set_name(&gdev->dev, "%s", dev_name(&gdev->cdev[0]->dev));
-
+	gdev->dev.groups = ccwgroup_attr_groups;
 	rc = device_add(&gdev->dev);
 	if (rc)
 		goto error;
 	get_device(&gdev->dev);
-	rc = device_create_file(&gdev->dev, &dev_attr_ungroup);
-
-	if (rc) {
-		device_unregister(&gdev->dev);
-		goto error;
-	}
-
 	rc = __ccwgroup_create_symlinks(gdev);
 	if (!rc) {
 		mutex_unlock(&gdev->reg_mutex);
 		put_device(&gdev->dev);
 		return 0;
 	}
-	device_remove_file(&gdev->dev, &dev_attr_ungroup);
 	device_unregister(&gdev->dev);
 error:
 	for (i = 0; i < num_devices; i++)
@@ -408,7 +420,7 @@ ccwgroup_online_store (struct device *dev, struct device_attribute *attr, const
 	int ret;
 
 	if (!dev->driver)
-		return -ENODEV;
+		return -EINVAL;
 
 	gdev = to_ccwgroupdev(dev);
 	gdrv = to_ccwgroupdrv(dev->driver);
@@ -441,8 +453,6 @@ ccwgroup_online_show (struct device *dev, struct device_attribute *attr, char *b
 	return sprintf(buf, online ? "1\n" : "0\n");
 }
 
-static DEVICE_ATTR(online, 0644, ccwgroup_online_show, ccwgroup_online_store);
-
 static int
 ccwgroup_probe (struct device *dev)
 {
@@ -454,12 +464,7 @@ ccwgroup_probe (struct device *dev)
 	gdev = to_ccwgroupdev(dev);
 	gdrv = to_ccwgroupdrv(dev->driver);
 
-	if ((ret = device_create_file(dev, &dev_attr_online)))
-		return ret;
-
 	ret = gdrv->probe ? gdrv->probe(gdev) : -ENODEV;
-	if (ret)
-		device_remove_file(dev, &dev_attr_online);
 
 	return ret;
 }
@@ -470,9 +475,6 @@ ccwgroup_remove (struct device *dev)
 	struct ccwgroup_device *gdev;
 	struct ccwgroup_driver *gdrv;
 
-	device_remove_file(dev, &dev_attr_online);
-	device_remove_file(dev, &dev_attr_ungroup);
-
 	if (!dev->driver)
 		return 0;
 
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 84d3bba..d121b36 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1793,10 +1793,12 @@ static int twa_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd
 	switch (retval) {
 	case SCSI_MLQUEUE_HOST_BUSY:
 		twa_free_request_id(tw_dev, request_id);
+		twa_unmap_scsi_data(tw_dev, request_id);
 		break;
 	case 1:
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		twa_free_request_id(tw_dev, request_id);
+		twa_unmap_scsi_data(tw_dev, request_id);
 		SCpnt->result = (DID_ERROR << 16);
 		done(SCpnt);
 		retval = 0;
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 94d2954..2cb663f 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1242,6 +1242,8 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced)
 	kfree(aac->queues);
 	aac->queues = NULL;
 	free_irq(aac->pdev->irq, aac);
+	if (aac->msi)
+		pci_disable_msi(aac->pdev);
 	kfree(aac->fsa_dev);
 	aac->fsa_dev = NULL;
 	quirks = aac_get_driver_ident(index)->quirks;
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 2f47ae7..354bf9d 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -704,12 +704,27 @@ static int fcoe_shost_config(struct fc_lport *lport, struct Scsi_Host *shost,
  * The offload EM that this routine is associated with will handle any
  * packets that are for SCSI read requests.
  *
+ * This has been enhanced to work when FCoE stack is operating in target
+ * mode.
+ *
  * Returns: True for read types I/O, otherwise returns false.
  */
 bool fcoe_oem_match(struct fc_frame *fp)
 {
-	return fc_fcp_is_read(fr_fsp(fp)) &&
-		(fr_fsp(fp)->data_len > fcoe_ddp_min);
+	struct fc_frame_header *fh = fc_frame_header_get(fp);
+	struct fcp_cmnd *fcp;
+
+	if (fc_fcp_is_read(fr_fsp(fp)) &&
+	    (fr_fsp(fp)->data_len > fcoe_ddp_min))
+		return true;
+	else if (!(ntoh24(fh->fh_f_ctl) & FC_FC_EX_CTX)) {
+		fcp = fc_frame_payload_get(fp, sizeof(*fcp));
+		if (ntohs(fh->fh_rx_id) == FC_XID_UNKNOWN &&
+		    fcp && (ntohl(fcp->fc_dl) > fcoe_ddp_min) &&
+		    (fcp->fc_flags & FCP_CFL_WRDATA))
+			return true;
+	}
+	return false;
 }
 
 /**
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 9e52d16..4d2950f 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -7673,7 +7673,7 @@ static int __devinit ipr_probe_ioa(struct pci_dev *pdev,
 	uproc = readl(ioa_cfg->regs.sense_uproc_interrupt_reg);
 	if ((mask & IPR_PCII_HRRQ_UPDATED) == 0 || (uproc & IPR_UPROCI_RESET_ALERT))
 		ioa_cfg->needs_hard_reset = 1;
-	if (interrupts & IPR_PCII_ERROR_INTERRUPTS)
+	if ((interrupts & IPR_PCII_ERROR_INTERRUPTS) || reset_devices)
 		ioa_cfg->needs_hard_reset = 1;
 	if (interrupts & IPR_PCII_IOA_UNIT_CHECKED)
 		ioa_cfg->ioa_unit_checked = 1;
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 4ad87fd..e37550c 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1072,7 +1072,8 @@ iscsi_tcp_conn_setup(struct iscsi_cls_session *cls_session, int dd_data_size,
 	struct iscsi_cls_conn *cls_conn;
 	struct iscsi_tcp_conn *tcp_conn;
 
-	cls_conn = iscsi_conn_setup(cls_session, sizeof(*tcp_conn), conn_idx);
+	cls_conn = iscsi_conn_setup(cls_session,
+				    sizeof(*tcp_conn) + dd_data_size, conn_idx);
 	if (!cls_conn)
 		return NULL;
 	conn = cls_conn->dd_data;
@@ -1084,22 +1085,13 @@ iscsi_tcp_conn_setup(struct iscsi_cls_session *cls_session, int dd_data_size,
 
 	tcp_conn = conn->dd_data;
 	tcp_conn->iscsi_conn = conn;
-
-	tcp_conn->dd_data = kzalloc(dd_data_size, GFP_KERNEL);
-	if (!tcp_conn->dd_data) {
-		iscsi_conn_teardown(cls_conn);
-		return NULL;
-	}
+	tcp_conn->dd_data = conn->dd_data + sizeof(*tcp_conn);
 	return cls_conn;
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_conn_setup);
 
 void iscsi_tcp_conn_teardown(struct iscsi_cls_conn *cls_conn)
 {
-	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-
-	kfree(tcp_conn->dd_data);
 	iscsi_conn_teardown(cls_conn);
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_conn_teardown);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 4f43306..b10ee2a 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -198,6 +198,8 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 	phy->virtual = dr->virtual;
 	phy->last_da_index = -1;
 
+	phy->phy->identify.sas_address = SAS_ADDR(phy->attached_sas_addr);
+	phy->phy->identify.device_type = phy->attached_dev_type;
 	phy->phy->identify.initiator_port_protocols = phy->attached_iproto;
 	phy->phy->identify.target_port_protocols = phy->attached_tproto;
 	phy->phy->identify.phy_identifier = phy_id;
@@ -1712,7 +1714,7 @@ static int sas_find_bcast_dev(struct domain_device *dev,
 	list_for_each_entry(ch, &ex->children, siblings) {
 		if (ch->dev_type == EDGE_DEV || ch->dev_type == FANOUT_DEV) {
 			res = sas_find_bcast_dev(ch, src_dev);
-			if (src_dev)
+			if (*src_dev)
 				return res;
 		}
 	}
@@ -1757,10 +1759,12 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 		sas_disable_routing(parent, phy->attached_sas_addr);
 	}
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
-	sas_port_delete_phy(phy->port, phy->phy);
-	if (phy->port->num_phys == 0)
-		sas_port_delete(phy->port);
-	phy->port = NULL;
+	if (phy->port) {
+		sas_port_delete_phy(phy->port, phy->phy);
+		if (phy->port->num_phys == 0)
+			sas_port_delete(phy->port);
+		phy->port = NULL;
+	}
 }
 
 static int sas_discover_bfs_by_root_level(struct domain_device *root,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3f8e849..f1ce96c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3481,15 +3481,12 @@ qla2x00_loop_resync(scsi_qla_host_t *vha)
 		req = vha->req;
 	rsp = req->rsp;
 
-	atomic_set(&vha->loop_state, LOOP_UPDATE);
 	clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
 	if (vha->flags.online) {
 		if (!(rval = qla2x00_fw_ready(vha))) {
 			/* Wait at most MAX_TARGET RSCNs for a stable link. */
 			wait_time = 256;
 			do {
-				atomic_set(&vha->loop_state, LOOP_UPDATE);
-
 				/* Issue a marker after FW becomes ready. */
 				qla2x00_marker(vha, req, rsp, 0, 0,
 					MK_SYNC_ALL);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 40807e4..4188b82 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -723,7 +723,6 @@ skip_rio:
 			vha->flags.rscn_queue_overflow = 1;
 		}
 
-		atomic_set(&vha->loop_state, LOOP_UPDATE);
 		atomic_set(&vha->loop_down_timer, 0);
 		vha->flags.management_server_logged_in = 0;
 
diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index f7726f1..ab6e3c7 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -921,9 +921,10 @@ static int qt2_ioctl(struct tty_struct *tty, struct file *file,
 		dbg("%s() port %d, cmd == TIOCMIWAIT enter",
 			__func__, port->number);
 		prev_msr_value = port_extra->shadowMSR  & QT2_SERIAL_MSR_MASK;
+		barrier();
+		__set_current_state(TASK_INTERRUPTIBLE);
 		while (1) {
 			add_wait_queue(&port_extra->wait, &wait);
-			set_current_state(TASK_INTERRUPTIBLE);
 			schedule();
 			dbg("%s(): port %d, cmd == TIOCMIWAIT here\n",
 				__func__, port->number);
@@ -931,9 +932,12 @@ static int qt2_ioctl(struct tty_struct *tty, struct file *file,
 			/* see if a signal woke us up */
 			if (signal_pending(current))
 				return -ERESTARTSYS;
+			set_current_state(TASK_INTERRUPTIBLE);
 			msr_value = port_extra->shadowMSR & QT2_SERIAL_MSR_MASK;
-			if (msr_value == prev_msr_value)
+			if (msr_value == prev_msr_value) {
+				__set_current_state(TASK_RUNNING);
 				return -EIO;  /* no change - error */
+			}
 			if ((arg & TIOCM_RNG &&
 				((prev_msr_value & QT2_SERIAL_MSR_RI) ==
 					(msr_value & QT2_SERIAL_MSR_RI))) ||
@@ -946,6 +950,7 @@ static int qt2_ioctl(struct tty_struct *tty, struct file *file,
 				(arg & TIOCM_CTS &&
 				((prev_msr_value & QT2_SERIAL_MSR_CTS) ==
 					(msr_value & QT2_SERIAL_MSR_CTS)))) {
+				__set_current_state(TASK_RUNNING);
 				return 0;
 			}
 		} /* end inifinite while */
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 61b1e73..48e9ed1 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1582,6 +1582,9 @@ static struct usb_device_id acm_ids[] = {
 	{ NOKIA_PCSUITE_ACM_INFO(0x0108), }, /* Nokia 5320 XpressMusic 2G */
 	{ NOKIA_PCSUITE_ACM_INFO(0x01f5), }, /* Nokia N97, RM-505 */
 
+	/* Support for Owen devices */
+	{ USB_DEVICE(0x03eb, 0x0030), }, /* Owen SI30 */
+
 	/* NOTE: non-Nokia COMM/ACM/0xff is likely MSFT RNDIS... NOT a modem! */
 
 	/* control interfaces with various AT-command sets */
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 6332fbb..ae212cd 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -403,7 +403,7 @@ static void async_completed(struct urb *urb)
 		sinfo.si_errno = as->status;
 		sinfo.si_code = SI_ASYNCIO;
 		sinfo.si_addr = as->userurb;
-		pid = as->pid;
+		pid = get_pid(as->pid);
 		uid = as->uid;
 		euid = as->euid;
 		secid = as->secid;
@@ -416,9 +416,11 @@ static void async_completed(struct urb *urb)
 		cancel_bulk_urbs(ps, as->bulk_addr);
 	spin_unlock(&ps->lock);
 
-	if (signr)
+	if (signr) {
 		kill_pid_info_as_uid(sinfo.si_signo, &sinfo, pid, uid,
 				      euid, secid);
+		put_pid(pid);
+	}
 
 	wake_up(&ps->wait);
 }
@@ -601,9 +603,10 @@ static int findintfep(struct usb_device *dev, unsigned int ep)
 }
 
 static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
-			   unsigned int index)
+			   unsigned int request, unsigned int index)
 {
 	int ret = 0;
+	struct usb_host_interface *alt_setting;
 
 	if (ps->dev->state != USB_STATE_UNAUTHENTICATED
 	 && ps->dev->state != USB_STATE_ADDRESS
@@ -612,6 +615,19 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
 	if (USB_TYPE_VENDOR == (USB_TYPE_MASK & requesttype))
 		return 0;
 
+	/*
+	 * check for the special corner case 'get_device_id' in the printer
+	 * class specification, where wIndex is (interface << 8 | altsetting)
+	 * instead of just interface
+	 */
+	if (requesttype == 0xa1 && request == 0) {
+		alt_setting = usb_find_alt_setting(ps->dev->actconfig,
+						   index >> 8, index & 0xff);
+		if (alt_setting
+		 && alt_setting->desc.bInterfaceClass == USB_CLASS_PRINTER)
+			index >>= 8;
+	}
+
 	index &= 0xff;
 	switch (requesttype & USB_RECIP_MASK) {
 	case USB_RECIP_ENDPOINT:
@@ -760,7 +776,8 @@ static int proc_control(struct dev_state *ps, void __user *arg)
 
 	if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
 		return -EFAULT;
-	ret = check_ctrlrecip(ps, ctrl.bRequestType, ctrl.wIndex);
+	ret = check_ctrlrecip(ps, ctrl.bRequestType, ctrl.bRequest,
+			      ctrl.wIndex);
 	if (ret)
 		return ret;
 	wLength = ctrl.wLength;		/* To suppress 64k PAGE_SIZE warning */
@@ -1082,7 +1099,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 			kfree(dr);
 			return -EINVAL;
 		}
-		ret = check_ctrlrecip(ps, dr->bRequestType,
+		ret = check_ctrlrecip(ps, dr->bRequestType, dr->bRequest,
 				      le16_to_cpup(&dr->wIndex));
 		if (ret) {
 			kfree(dr);
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 131fce2..e9d701d 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -245,7 +245,7 @@ static int ehci_bus_resume (struct usb_hcd *hcd)
 	u32			temp;
 	u32			power_okay;
 	int			i;
-	u8			resume_needed = 0;
+	unsigned long		resume_needed = 0;
 
 	if (time_before (jiffies, ehci->next_statechange))
 		msleep(5);
@@ -309,7 +309,7 @@ static int ehci_bus_resume (struct usb_hcd *hcd)
 		if (test_bit(i, &ehci->bus_suspended) &&
 				(temp & PORT_SUSPEND)) {
 			temp |= PORT_RESUME;
-			resume_needed = 1;
+			set_bit(i, &resume_needed);
 		}
 		ehci_writel(ehci, temp, &ehci->regs->port_status [i]);
 	}
@@ -324,8 +324,7 @@ static int ehci_bus_resume (struct usb_hcd *hcd)
 	i = HCS_N_PORTS (ehci->hcs_params);
 	while (i--) {
 		temp = ehci_readl(ehci, &ehci->regs->port_status [i]);
-		if (test_bit(i, &ehci->bus_suspended) &&
-				(temp & PORT_SUSPEND)) {
+		if (test_bit(i, &resume_needed)) {
 			temp &= ~(PORT_RWC_BITS | PORT_RESUME);
 			ehci_writel(ehci, temp, &ehci->regs->port_status [i]);
 			ehci_vdbg (ehci, "resumed port %d\n", i + 1);
diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c
index ff43747..b13d78a 100644
--- a/drivers/usb/host/fhci-sched.c
+++ b/drivers/usb/host/fhci-sched.c
@@ -1,7 +1,7 @@
 /*
  * Freescale QUICC Engine USB Host Controller Driver
  *
- * Copyright (c) Freescale Semicondutor, Inc. 2006.
+ * Copyright (c) Freescale Semicondutor, Inc. 2006, 2011.
  *               Shlomi Gridish <gridish@freescale.com>
  *               Jerry Huang <Chang-Ming.Huang@freescale.com>
  * Copyright (c) Logic Product Development, Inc. 2007
@@ -810,9 +810,11 @@ void fhci_queue_urb(struct fhci_hcd *fhci, struct urb *urb)
 		ed->dev_addr = usb_pipedevice(urb->pipe);
 		ed->max_pkt_size = usb_maxpacket(urb->dev, urb->pipe,
 			usb_pipeout(urb->pipe));
+		/* setup stage */
 		td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt++, FHCI_TA_SETUP,
 			USB_TD_TOGGLE_DATA0, urb->setup_packet, 8, 0, 0, true);
 
+		/* data stage */
 		if (data_len > 0) {
 			td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt++,
 				usb_pipeout(urb->pipe) ? FHCI_TA_OUT :
@@ -820,9 +822,18 @@ void fhci_queue_urb(struct fhci_hcd *fhci, struct urb *urb)
 				USB_TD_TOGGLE_DATA1, data, data_len, 0, 0,
 				true);
 		}
-		td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt++,
-			usb_pipeout(urb->pipe) ? FHCI_TA_IN : FHCI_TA_OUT,
-			USB_TD_TOGGLE_DATA1, data, 0, 0, 0, true);
+
+		/* status stage */
+		if (data_len > 0)
+			td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt++,
+				(usb_pipeout(urb->pipe) ? FHCI_TA_IN :
+							  FHCI_TA_OUT),
+				USB_TD_TOGGLE_DATA1, data, 0, 0, 0, true);
+		else
+			 td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt++,
+				FHCI_TA_IN,
+				USB_TD_TOGGLE_DATA1, data, 0, 0, 0, true);
+
 		urb_state = US_CTRL_SETUP;
 		break;
 	case FHCI_TF_ISO:
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index fe2b76c..0495089 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -110,18 +110,20 @@ void xhci_ring_free(struct xhci_hcd *xhci, struct xhci_ring *ring)
 	struct xhci_segment *seg;
 	struct xhci_segment *first_seg;
 
-	if (!ring || !ring->first_seg)
+	if (!ring)
 		return;
-	first_seg = ring->first_seg;
-	seg = first_seg->next;
-	xhci_dbg(xhci, "Freeing ring at %p\n", ring);
-	while (seg != first_seg) {
-		struct xhci_segment *next = seg->next;
-		xhci_segment_free(xhci, seg);
-		seg = next;
+	if (ring->first_seg) {
+		first_seg = ring->first_seg;
+		seg = first_seg->next;
+		xhci_dbg(xhci, "Freeing ring at %p\n", ring);
+		while (seg != first_seg) {
+			struct xhci_segment *next = seg->next;
+			xhci_segment_free(xhci, seg);
+			seg = next;
+		}
+		xhci_segment_free(xhci, first_seg);
+		ring->first_seg = NULL;
 	}
-	xhci_segment_free(xhci, first_seg);
-	ring->first_seg = NULL;
 	kfree(ring);
 }
 
diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 385ec05..fa5bd93 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1074,7 +1074,7 @@ static int mon_bin_ioctl(struct inode *inode, struct file *file,
 		nevents = mon_bin_queued(rp);
 
 		sp = (struct mon_bin_stats __user *)arg;
-		if (put_user(rp->cnt_lost, &sp->dropped))
+		if (put_user(ndropped, &sp->dropped))
 			return -EFAULT;
 		if (put_user(nevents, &sp->queued))
 			return -EFAULT;
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 2413c0f..e176a06 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1640,7 +1640,6 @@ void musb_dma_completion(struct musb *musb, u8 epnum, u8 transmit)
 			}
 		}
 	}
-	musb_writeb(musb_base, MUSB_INDEX, musb->context.index);
 }
 
 #else
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index dd2182c..c0684b9 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -105,6 +105,7 @@ static int   ftdi_jtag_probe(struct usb_serial *serial);
 static int   ftdi_mtxorb_hack_setup(struct usb_serial *serial);
 static int   ftdi_NDI_device_setup(struct usb_serial *serial);
 static int   ftdi_stmclite_probe(struct usb_serial *serial);
+static int   ftdi_8u2232c_probe(struct usb_serial *serial);
 static void  ftdi_USB_UIRT_setup(struct ftdi_private *priv);
 static void  ftdi_HE_TIRA1_setup(struct ftdi_private *priv);
 
@@ -132,6 +133,10 @@ static struct ftdi_sio_quirk ftdi_stmclite_quirk = {
 	.probe	= ftdi_stmclite_probe,
 };
 
+static struct ftdi_sio_quirk ftdi_8u2232c_quirk = {
+	.probe	= ftdi_8u2232c_probe,
+};
+
 /*
  * The 8U232AM has the same API as the sio except for:
  * - it can support MUCH higher baudrates; up to:
@@ -178,7 +183,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_8U232AM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_8U232AM_ALT_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_232RL_PID) },
-	{ USB_DEVICE(FTDI_VID, FTDI_8U2232C_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_8U2232C_PID) ,
+		.driver_info = (kernel_ulong_t)&ftdi_8u2232c_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_4232H_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MICRO_CHAMELEON_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RELAIS_PID) },
@@ -199,6 +205,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_640_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_642_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DSS20_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_URBAN_0_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_URBAN_1_PID) },
 	{ USB_DEVICE(FTDI_NF_RIC_VID, FTDI_NF_RIC_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_VNHCPCUSB_D_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_0_PID) },
@@ -736,6 +744,8 @@ static struct usb_device_id id_table_combined [] = {
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, LMI_LM3S_EVAL_BOARD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, LMI_LM3S_ICDI_BOARD_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_TURTELIZER_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
@@ -1740,6 +1750,18 @@ static int ftdi_jtag_probe(struct usb_serial *serial)
 	return 0;
 }
 
+static int ftdi_8u2232c_probe(struct usb_serial *serial)
+{
+	struct usb_device *udev = serial->dev;
+
+	dbg("%s", __func__);
+
+	if (strcmp(udev->manufacturer, "CALAO Systems") == 0)
+		return ftdi_jtag_probe(serial);
+
+	return 0;
+}
+
 /*
  * First and second port on STMCLiteadaptors is reserved for JTAG interface
  * and the forth port for pio
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index acf476a..c6caff2 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -48,6 +48,7 @@
 /* FTDI 2332C Dual channel device, side A=245 FIFO (JTAG), Side B=RS232 UART */
 #define LMI_LM3S_DEVEL_BOARD_PID	0xbcd8
 #define LMI_LM3S_EVAL_BOARD_PID		0xbcd9
+#define LMI_LM3S_ICDI_BOARD_PID		0xbcda
 
 #define FTDI_TURTELIZER_PID	0xBDC8 /* JTAG/RS-232 adapter by egnite GmBH */
 
@@ -399,9 +400,11 @@
 #define PROTEGO_SPECIAL_4	0xFC73	/* special/unknown device */
 
 /*
- * DSS-20 Sync Station for Sony Ericsson P800
+ * Sony Ericsson product ids
  */
-#define FTDI_DSS20_PID          0xFC82
+#define FTDI_DSS20_PID		0xFC82	/* DSS-20 Sync Station for Sony Ericsson P800 */
+#define FTDI_URBAN_0_PID	0xFC8A	/* Sony Ericsson Urban, uart #0 */
+#define FTDI_URBAN_1_PID	0xFC8B	/* Sony Ericsson Urban, uart #1 */
 
 /* www.irtrans.de device */
 #define FTDI_IRTRANS_PID 0xFC60 /* Product Id */
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 6849ca6..ca270fc 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -101,6 +101,7 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
 	{ USB_DEVICE(WINCHIPHEAD_VENDOR_ID, WINCHIPHEAD_USBSER_PRODUCT_ID) },
+	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
@@ -616,10 +617,28 @@ static void pl2303_set_termios(struct tty_struct *tty,
 				baud = 6000000;
 		}
 		dbg("%s - baud set = %d", __func__, baud);
-		buf[0] = baud & 0xff;
-		buf[1] = (baud >> 8) & 0xff;
-		buf[2] = (baud >> 16) & 0xff;
-		buf[3] = (baud >> 24) & 0xff;
+		if (baud <= 115200) {
+			buf[0] = baud & 0xff;
+			buf[1] = (baud >> 8) & 0xff;
+			buf[2] = (baud >> 16) & 0xff;
+			buf[3] = (baud >> 24) & 0xff;
+		} else {
+			/* apparently the formula for higher speeds is:
+			 * baudrate = 12M * 32 / (2^buf[1]) / buf[0]
+			 */
+			unsigned tmp = 12*1000*1000*32 / baud;
+			buf[3] = 0x80;
+			buf[2] = 0;
+			buf[1] = (tmp >= 256);
+			while (tmp >= 256) {
+				tmp >>= 2;
+				buf[1] <<= 1;
+			}
+			if (tmp > 256) {
+				tmp %= 256;
+			}
+			buf[0] = tmp;
+		}
 	}
 
 	/* For reference buf[4]=0 is 1 stop bits */
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index e854fb0..82b572e 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -144,3 +144,8 @@
 /* WinChipHead USB->RS 232 adapter */
 #define WINCHIPHEAD_VENDOR_ID		0x4348
 #define WINCHIPHEAD_USBSER_PRODUCT_ID	0x5523
+
+/* SMART USB Serial Adapter */
+#define SMART_VENDOR_ID	0x0b8c
+#define SMART_PRODUCT_ID	0x2303
+
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index d469673..e7f85a8 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -26,6 +26,7 @@ static struct usb_device_id id_table[] = {
 	{USB_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
 	{USB_DEVICE(0x03f0, 0x1f1d)},	/* HP un2400 Gobi Modem Device */
 	{USB_DEVICE(0x03f0, 0x201d)},	/* HP un2400 Gobi QDL Device */
+	{USB_DEVICE(0x03f0, 0x371d)},	/* HP un2430 Mobile Broadband Module */
 	{USB_DEVICE(0x04da, 0x250d)},	/* Panasonic Gobi Modem device */
 	{USB_DEVICE(0x04da, 0x250c)},	/* Panasonic Gobi QDL device */
 	{USB_DEVICE(0x413c, 0x8172)},	/* Dell Gobi Modem device */
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index cc313d1..ac115fd 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -693,6 +693,9 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		int temp_result;
 		struct scsi_eh_save ses;
 		int sense_size = US_SENSE_SIZE;
+		struct scsi_sense_hdr sshdr;
+		const u8 *scdd;
+		u8 fm_ili;
 
 		/* device supports and needs bigger sense buffer */
 		if (us->fflags & US_FL_SANE_SENSE)
@@ -776,32 +779,30 @@ Retry_Sense:
 			srb->sense_buffer[7] = (US_SENSE_SIZE - 8);
 		}
 
+		scsi_normalize_sense(srb->sense_buffer, SCSI_SENSE_BUFFERSIZE,
+				     &sshdr);
+
 		US_DEBUGP("-- Result from auto-sense is %d\n", temp_result);
 		US_DEBUGP("-- code: 0x%x, key: 0x%x, ASC: 0x%x, ASCQ: 0x%x\n",
-			  srb->sense_buffer[0],
-			  srb->sense_buffer[2] & 0xf,
-			  srb->sense_buffer[12], 
-			  srb->sense_buffer[13]);
+			  sshdr.response_code, sshdr.sense_key,
+			  sshdr.asc, sshdr.ascq);
 #ifdef CONFIG_USB_STORAGE_DEBUG
-		usb_stor_show_sense(
-			  srb->sense_buffer[2] & 0xf,
-			  srb->sense_buffer[12], 
-			  srb->sense_buffer[13]);
+		usb_stor_show_sense(sshdr.sense_key, sshdr.asc, sshdr.ascq);
 #endif
 
 		/* set the result so the higher layers expect this data */
 		srb->result = SAM_STAT_CHECK_CONDITION;
 
+		scdd = scsi_sense_desc_find(srb->sense_buffer,
+					    SCSI_SENSE_BUFFERSIZE, 4);
+		fm_ili = (scdd ? scdd[3] : srb->sense_buffer[2]) & 0xA0;
+
 		/* We often get empty sense data.  This could indicate that
 		 * everything worked or that there was an unspecified
 		 * problem.  We have to decide which.
 		 */
-		if (	/* Filemark 0, ignore EOM, ILI 0, no sense */
-				(srb->sense_buffer[2] & 0xaf) == 0 &&
-			/* No ASC or ASCQ */
-				srb->sense_buffer[12] == 0 &&
-				srb->sense_buffer[13] == 0) {
-
+		if (sshdr.sense_key == 0 && sshdr.asc == 0 && sshdr.ascq == 0 &&
+		    fm_ili == 0) {
 			/* If things are really okay, then let's show that.
 			 * Zero out the sense buffer so the higher layers
 			 * won't realize we did an unsolicited auto-sense.
@@ -816,7 +817,10 @@ Retry_Sense:
 			 */
 			} else {
 				srb->result = DID_ERROR << 16;
-				srb->sense_buffer[2] = HARDWARE_ERROR;
+				if ((sshdr.response_code & 0x72) == 0x72)
+					srb->sense_buffer[1] = HARDWARE_ERROR;
+				else
+					srb->sense_buffer[2] = HARDWARE_ERROR;
 			}
 		}
 	}
diff --git a/drivers/video/carminefb.c b/drivers/video/carminefb.c
index 0c02f8e..ce23e72 100644
--- a/drivers/video/carminefb.c
+++ b/drivers/video/carminefb.c
@@ -31,11 +31,11 @@
 #define CARMINEFB_DEFAULT_VIDEO_MODE	1
 
 static unsigned int fb_mode = CARMINEFB_DEFAULT_VIDEO_MODE;
-module_param(fb_mode, uint, 444);
+module_param(fb_mode, uint, 0444);
 MODULE_PARM_DESC(fb_mode, "Initial video mode as integer.");
 
 static char *fb_mode_str;
-module_param(fb_mode_str, charp, 444);
+module_param(fb_mode_str, charp, 0444);
 MODULE_PARM_DESC(fb_mode_str, "Initial video mode in characters.");
 
 /*
@@ -45,7 +45,7 @@ MODULE_PARM_DESC(fb_mode_str, "Initial video mode in characters.");
  * 0b010 Display 1
  */
 static int fb_displays = CARMINE_USE_DISPLAY0 | CARMINE_USE_DISPLAY1;
-module_param(fb_displays, int, 444);
+module_param(fb_displays, int, 0444);
 MODULE_PARM_DESC(fb_displays, "Bit mode, which displays are used");
 
 struct carmine_hw {
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index e797a2c..c9dbe11 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -211,13 +211,14 @@ static int __devinit mtx1_wdt_probe(struct platform_device *pdev)
 	int ret;
 
 	mtx1_wdt_device.gpio = pdev->resource[0].start;
-	ret = gpio_request_one(mtx1_wdt_device.gpio,
-				GPIOF_OUT_INIT_HIGH, "mtx1-wdt");
+	ret = gpio_request(mtx1_wdt_device.gpio, "mtx1-wdt");
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to request gpio");
 		return ret;
 	}
 
+	gpio_direction_output(mtx1_wdt_device.gpio, 1);
+
 	spin_lock_init(&mtx1_wdt_device.lock);
 	init_completion(&mtx1_wdt_device.stop);
 	mtx1_wdt_device.queue = 0;
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 7d6c213..be525f6 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -75,6 +75,25 @@ static const match_table_t tokens = {
 	{Opt_err, NULL}
 };
 
+/* Interpret mount options for cache mode */
+static int get_cache_mode(char *s)
+{
+	int version = -EINVAL;
+
+	if (!strcmp(s, "loose")) {
+		version = CACHE_LOOSE;
+		P9_DPRINTK(P9_DEBUG_9P, "Cache mode: loose\n");
+	} else if (!strcmp(s, "fscache")) {
+		version = CACHE_FSCACHE;
+		P9_DPRINTK(P9_DEBUG_9P, "Cache mode: fscache\n");
+	} else if (!strcmp(s, "none")) {
+		version = CACHE_NONE;
+		P9_DPRINTK(P9_DEBUG_9P, "Cache mode: none\n");
+	} else
+		printk(KERN_INFO "9p: Unknown Cache mode %s.\n", s);
+	return version;
+}
+
 /**
  * v9fs_parse_options - parse mount options into session structure
  * @v9ses: existing v9fs session information
@@ -94,7 +113,7 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 	/* setup defaults */
 	v9ses->afid = ~0;
 	v9ses->debug = 0;
-	v9ses->cache = 0;
+	v9ses->cache = CACHE_NONE;
 #ifdef CONFIG_9P_FSCACHE
 	v9ses->cachetag = NULL;
 #endif
@@ -168,13 +187,13 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 				  "problem allocating copy of cache arg\n");
 				goto free_and_return;
 			}
+			ret = get_cache_mode(s);
+			if (ret == -EINVAL) {
+				kfree(s);
+				goto free_and_return;
+			}
 
-			if (strcmp(s, "loose") == 0)
-				v9ses->cache = CACHE_LOOSE;
-			else if (strcmp(s, "fscache") == 0)
-				v9ses->cache = CACHE_FSCACHE;
-			else
-				v9ses->cache = CACHE_NONE;
+			v9ses->cache = ret;
 			kfree(s);
 			break;
 
@@ -195,9 +214,15 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 			else {
 				v9ses->flags |= V9FS_ACCESS_SINGLE;
 				v9ses->uid = simple_strtoul(s, &e, 10);
-				if (*e != '\0')
-					v9ses->uid = ~0;
+				if (*e != '\0') {
+					ret = -EINVAL;
+					printk(KERN_INFO "9p: Unknown access "
+							"argument %s.\n", s);
+					kfree(s);
+					goto free_and_return;
+				}
 			}
+
 			kfree(s);
 			break;
 
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 04b755a..665b128 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3596,7 +3596,8 @@ int CIFSFindNext(const int xid, struct cifsTconInfo *tcon,
 	T2_FNEXT_RSP_PARMS *parms;
 	char *response_data;
 	int rc = 0;
-	int bytes_returned, name_len;
+	int bytes_returned;
+	unsigned int name_len;
 	__u16 params, byte_count;
 
 	cFYI(1, ("In FindNext"));
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index a8dfe21..c066a76 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -70,6 +70,15 @@
  * simultaneous inserts (A into B and B into A) from racing and
  * constructing a cycle without either insert observing that it is
  * going to.
+ * It is necessary to acquire multiple "ep->mtx"es at once in the
+ * case when one epoll fd is added to another. In this case, we
+ * always acquire the locks in the order of nesting (i.e. after
+ * epoll_ctl(e1, EPOLL_CTL_ADD, e2), e1->mtx will always be acquired
+ * before e2->mtx). Since we disallow cycles of epoll file
+ * descriptors, this ensures that the mutexes are well-ordered. In
+ * order to communicate this nesting to lockdep, when walking a tree
+ * of epoll file descriptors, we use the current recursion depth as
+ * the lockdep subkey.
  * It is possible to drop the "ep->mtx" and to use the global
  * mutex "epmutex" (together with "ep->lock") to have it working,
  * but having "ep->mtx" will make the interface more scalable.
@@ -452,13 +461,15 @@ static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
  * @ep: Pointer to the epoll private data structure.
  * @sproc: Pointer to the scan callback.
  * @priv: Private opaque data passed to the @sproc callback.
+ * @depth: The current depth of recursive f_op->poll calls.
  *
  * Returns: The same integer error code returned by the @sproc callback.
  */
 static int ep_scan_ready_list(struct eventpoll *ep,
 			      int (*sproc)(struct eventpoll *,
 					   struct list_head *, void *),
-			      void *priv)
+			      void *priv,
+			      int depth)
 {
 	int error, pwake = 0;
 	unsigned long flags;
@@ -469,7 +480,7 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	 * We need to lock this because we could be hit by
 	 * eventpoll_release_file() and epoll_ctl().
 	 */
-	mutex_lock(&ep->mtx);
+	mutex_lock_nested(&ep->mtx, depth);
 
 	/*
 	 * Steal the ready list, and re-init the original one to the
@@ -658,7 +669,7 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 
 static int ep_poll_readyevents_proc(void *priv, void *cookie, int call_nests)
 {
-	return ep_scan_ready_list(priv, ep_read_events_proc, NULL);
+	return ep_scan_ready_list(priv, ep_read_events_proc, NULL, call_nests + 1);
 }
 
 static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
@@ -724,7 +735,7 @@ void eventpoll_release_file(struct file *file)
 
 		ep = epi->ep;
 		list_del_init(&epi->fllink);
-		mutex_lock(&ep->mtx);
+		mutex_lock_nested(&ep->mtx, 0);
 		ep_remove(ep, epi);
 		mutex_unlock(&ep->mtx);
 	}
@@ -1120,7 +1131,7 @@ static int ep_send_events(struct eventpoll *ep,
 	esed.maxevents = maxevents;
 	esed.events = events;
 
-	return ep_scan_ready_list(ep, ep_send_events_proc, &esed);
+	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0);
 }
 
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
@@ -1215,7 +1226,7 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
 	struct rb_node *rbp;
 	struct epitem *epi;
 
-	mutex_lock(&ep->mtx);
+	mutex_lock_nested(&ep->mtx, call_nests + 1);
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		if (unlikely(is_file_epoll(epi->ffd.file))) {
@@ -1357,7 +1368,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	}
 
 
-	mutex_lock(&ep->mtx);
+	mutex_lock_nested(&ep->mtx, 0);
 
 	/*
 	 * Try to lookup the file inside our RB tree, Since we grabbed "mtx"
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3744359..c1b4d6e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -291,8 +291,7 @@ struct flex_groups {
 
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
-			   EXT4_SYNC_FL | EXT4_IMMUTABLE_FL | EXT4_APPEND_FL |\
-			   EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
+			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
 			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
 			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL)
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 505a281..6cb1bbd 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2566,6 +2566,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		ex1 = ex;
 		ex1->ee_len = cpu_to_le16(iblock - ee_block);
 		ext4_ext_mark_uninitialized(ex1);
+		ext4_ext_dirty(handle, inode, path + depth);
 		ex2 = &newex;
 	}
 	/*
diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index c81249f..c325a83 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -709,7 +709,13 @@ static void nlmclnt_unlock_callback(struct rpc_task *task, void *data)
 
 	if (task->tk_status < 0) {
 		dprintk("lockd: unlock failed (err = %d)\n", -task->tk_status);
-		goto retry_rebind;
+		switch (task->tk_status) {
+		case -EACCES:
+		case -EIO:
+			goto die;
+		default:
+			goto retry_rebind;
+		}
 	}
 	if (status == NLM_LCK_DENIED_GRACE_PERIOD) {
 		rpc_delay(task, NLMCLNT_GRACE_WAIT);
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 3db35a4..70048ae 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -677,7 +677,7 @@ nfsd4_readdir(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	readdir->rd_bmval[1] &= nfsd_suppattrs1(cstate->minorversion);
 	readdir->rd_bmval[2] &= nfsd_suppattrs2(cstate->minorversion);
 
-	if ((cookie > ~(u32)0) || (cookie == 1) || (cookie == 2) ||
+	if ((cookie == 1) || (cookie == 2) ||
 	    (cookie == 0 && memcmp(readdir->rd_verf.data, zeroverf.data, NFS4_VERIFIER_SIZE)))
 		return nfserr_bad_cookie;
 
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index fcafe60..d214bce 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3062,6 +3062,8 @@ nfsd4_open_downgrade(struct svc_rqst *rqstp,
 	if (!access_valid(od->od_share_access, cstate->minorversion)
 			|| !deny_valid(od->od_share_deny))
 		return nfserr_inval;
+	/* We don't yet support WANT bits: */
+	od->od_share_access &= NFS4_SHARE_ACCESS_MASK;
 
 	nfs4_lock_state();
 	if ((status = nfs4_preprocess_seqid_op(cstate,
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 4de2837..99d450a 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1507,6 +1507,18 @@ static void write_cinfo(__be32 **p, struct nfsd4_change_info *c)
 								\
 	save = resp->p;
 
+static bool seqid_mutating_err(__be32 err)
+{
+	/* rfc 3530 section 8.1.5: */
+	return	err != nfserr_stale_clientid &&
+		err != nfserr_stale_stateid &&
+		err != nfserr_bad_stateid &&
+		err != nfserr_bad_seqid &&
+		err != nfserr_bad_xdr &&
+		err != nfserr_resource &&
+		err != nfserr_nofilehandle;
+}
+
 /*
  * Routine for encoding the result of a "seqid-mutating" NFSv4 operation.  This
  * is where sequence id's are incremented, and the replay cache is filled.
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index fefeae2..8e5d59f 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -363,12 +363,6 @@ struct nfs4_stateid {
 #define WR_STATE	        0x00000020
 #define CLOSE_STATE             0x00000040
 
-#define seqid_mutating_err(err)                       \
-	(((err) != nfserr_stale_clientid) &&    \
-	((err) != nfserr_bad_seqid) &&          \
-	((err) != nfserr_stale_stateid) &&      \
-	((err) != nfserr_bad_stateid))
-
 struct nfsd4_compound_state;
 
 extern __be32 nfs4_preprocess_stateid_op(struct nfsd4_compound_state *cstate,
diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index a44a789..b442dac 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -490,7 +490,7 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 		}
 		read_unlock(&kclist_lock);
 
-		if (m == NULL) {
+		if (&m->list == &kclist_head) {
 			if (clear_user(buffer, tsz))
 				return -EFAULT;
 		} else if (is_vmalloc_or_module_addr((void *)start)) {
diff --git a/fs/splice.c b/fs/splice.c
index 3920866..03e4238 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1231,7 +1231,8 @@ static int direct_splice_actor(struct pipe_inode_info *pipe,
 {
 	struct file *file = sd->u.file;
 
-	return do_splice_from(pipe, file, &sd->pos, sd->total_len, sd->flags);
+	return do_splice_from(pipe, file, &file->f_pos, sd->total_len,
+			      sd->flags);
 }
 
 /**
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 2dfa707..0bfcb76 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -196,8 +196,8 @@ struct ext2_group_desc
 
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT2_FL_INHERITED (EXT2_SECRM_FL | EXT2_UNRM_FL | EXT2_COMPR_FL |\
-			   EXT2_SYNC_FL | EXT2_IMMUTABLE_FL | EXT2_APPEND_FL |\
-			   EXT2_NODUMP_FL | EXT2_NOATIME_FL | EXT2_COMPRBLK_FL|\
+			   EXT2_SYNC_FL | EXT2_NODUMP_FL |\
+			   EXT2_NOATIME_FL | EXT2_COMPRBLK_FL |\
 			   EXT2_NOCOMP_FL | EXT2_JOURNAL_DATA_FL |\
 			   EXT2_NOTAIL_FL | EXT2_DIRSYNC_FL)
 
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 6b04903..fa60e2f 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -180,8 +180,8 @@ struct ext3_group_desc
 
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT3_FL_INHERITED (EXT3_SECRM_FL | EXT3_UNRM_FL | EXT3_COMPR_FL |\
-			   EXT3_SYNC_FL | EXT3_IMMUTABLE_FL | EXT3_APPEND_FL |\
-			   EXT3_NODUMP_FL | EXT3_NOATIME_FL | EXT3_COMPRBLK_FL|\
+			   EXT3_SYNC_FL | EXT3_NODUMP_FL |\
+			   EXT3_NOATIME_FL | EXT3_COMPRBLK_FL |\
 			   EXT3_NOCOMPR_FL | EXT3_JOURNAL_DATA_FL |\
 			   EXT3_NOTAIL_FL | EXT3_DIRSYNC_FL)
 
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 6811f4b..284c13d 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -303,7 +303,7 @@ extern void jiffies_to_timespec(const unsigned long jiffies,
 extern unsigned long timeval_to_jiffies(const struct timeval *value);
 extern void jiffies_to_timeval(const unsigned long jiffies,
 			       struct timeval *value);
-extern clock_t jiffies_to_clock_t(long x);
+extern clock_t jiffies_to_clock_t(unsigned long x);
 extern unsigned long clock_t_to_jiffies(unsigned long x);
 extern u64 jiffies_64_to_clock_t(u64 x);
 extern u64 nsec_to_clock_t(u64 x);
diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index 7bc7fd5..14c4f91 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -84,8 +84,8 @@ struct rpc_task {
 	long			tk_rtt;		/* round-trip time (jiffies) */
 
 	pid_t			tk_owner;	/* Process id for batching tasks */
-	unsigned char		tk_priority : 2;/* Task priority */
-
+	unsigned char		tk_priority : 2,/* Task priority */
+				tk_rebind_retry : 2;
 #ifdef RPC_DEBUG
 	unsigned short		tk_pid;		/* debugging aid */
 #endif
diff --git a/include/net/scm.h b/include/net/scm.h
index 8360e47..8b5cccd 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -10,11 +10,12 @@
 /* Well, we should have at least one descriptor open
  * to accept passed FDs 8)
  */
-#define SCM_MAX_FD	255
+#define SCM_MAX_FD	253
 
 struct scm_fp_list {
 	struct list_head	list;
-	int			count;
+	short			count;
+	short			max;
 	struct file		*fp[SCM_MAX_FD];
 };
 
diff --git a/kernel/kmod.c b/kernel/kmod.c
index bf0e231..f50a996 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -106,10 +106,12 @@ int __request_module(bool wait, const char *fmt, ...)
 	atomic_inc(&kmod_concurrent);
 	if (atomic_read(&kmod_concurrent) > max_modprobes) {
 		/* We may be blaming an innocent here, but unlikely */
-		if (kmod_loop_msg++ < 5)
+		if (kmod_loop_msg < 5) {
 			printk(KERN_ERR
 			       "request_module: runaway loop modprobe %s\n",
 			       module_name);
+			kmod_loop_msg++;
+		}
 		atomic_dec(&kmod_concurrent);
 		return -ENOMEM;
 	}
diff --git a/kernel/time.c b/kernel/time.c
index 8047980..af1bfb0 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -593,7 +593,7 @@ EXPORT_SYMBOL(jiffies_to_timeval);
 /*
  * Convert jiffies/jiffies_64 to clock_t and back.
  */
-clock_t jiffies_to_clock_t(long x)
+clock_t jiffies_to_clock_t(unsigned long x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
 # if HZ < USER_HZ
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8a58f51..a3f3d0c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3624,8 +3624,6 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 	if (info->read < PAGE_SIZE)
 		goto read;
 
-	info->read = 0;
-
 	trace_access_lock(info->cpu);
 	ret = ring_buffer_read_page(info->tr->buffer,
 				    &info->spare,
@@ -3640,6 +3638,8 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 	if (pos < PAGE_SIZE)
 		memset(info->spare + pos, 0, PAGE_SIZE - pos);
 
+	info->read = 0;
+
 read:
 	size = PAGE_SIZE - info->read;
 	if (size > count)
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 920a3ca..507b821 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -235,7 +235,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 			retval = netlink_broadcast(uevent_sock, skb, 0, 1,
 						   GFP_KERNEL);
 			/* ENOBUFS should be handled in userspace */
-			if (retval == -ENOBUFS)
+			if (retval == -ENOBUFS || retval == -ESRCH)
 				retval = 0;
 		} else
 			retval = -ENOMEM;
diff --git a/mm/mmap.c b/mm/mmap.c
index 892b7d3..25a3783 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1677,9 +1677,12 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 		size = address - vma->vm_start;
 		grow = (address - vma->vm_end) >> PAGE_SHIFT;
 
-		error = acct_stack_growth(vma, size, grow);
-		if (!error)
-			vma->vm_end = address;
+		error = -ENOMEM;
+		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
+			error = acct_stack_growth(vma, size, grow);
+			if (!error)
+				vma->vm_end = address;
+		}
 	}
 	anon_vma_unlock(vma);
 	return error;
@@ -1721,10 +1724,13 @@ static int expand_downwards(struct vm_area_struct *vma,
 		size = vma->vm_end - address;
 		grow = (vma->vm_start - address) >> PAGE_SHIFT;
 
-		error = acct_stack_growth(vma, size, grow);
-		if (!error) {
-			vma->vm_start = address;
-			vma->vm_pgoff -= grow;
+		error = -ENOMEM;
+		if (grow <= vma->vm_pgoff) {
+			error = acct_stack_growth(vma, size, grow);
+			if (!error) {
+				vma->vm_start = address;
+				vma->vm_pgoff -= grow;
+			}
 		}
 	}
 	anon_vma_unlock(vma);
diff --git a/net/9p/client.c b/net/9p/client.c
index 09d4f1e..e1b0e20 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -230,7 +230,8 @@ struct p9_req_t *p9_tag_lookup(struct p9_client *c, u16 tag)
 	 * buffer to read the data into */
 	tag++;
 
-	BUG_ON(tag >= c->max_tag);
+	if(tag >= c->max_tag)
+		return NULL;
 
 	row = tag / P9_ROW_MAXTAG;
 	col = tag % P9_ROW_MAXTAG;
@@ -707,8 +708,8 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (err)
 		goto destroy_fidpool;
 
-	if ((clnt->msize+P9_IOHDRSZ) > clnt->trans_mod->maxsize)
-		clnt->msize = clnt->trans_mod->maxsize-P9_IOHDRSZ;
+	if (clnt->msize > clnt->trans_mod->maxsize)
+		clnt->msize = clnt->trans_mod->maxsize;
 
 	err = p9_client_version(clnt);
 	if (err)
@@ -1037,9 +1038,11 @@ int p9_client_clunk(struct p9_fid *fid)
 	P9_DPRINTK(P9_DEBUG_9P, "<<< RCLUNK fid %d\n", fid->fid);
 
 	p9_free_req(clnt, req);
-	p9_fid_destroy(fid);
-
 error:
+	/*
+	 * Fid is not valid even after a failed clunk
+	 */
+	p9_fid_destroy(fid);
 	return err;
 }
 EXPORT_SYMBOL(p9_client_clunk);
diff --git a/net/atm/br2684.c b/net/atm/br2684.c
index be1c1d2..475b2bf 100644
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -530,12 +530,13 @@ static int br2684_regvcc(struct atm_vcc *atmvcc, void __user * arg)
 	spin_unlock_irqrestore(&rq->lock, flags);
 
 	skb_queue_walk_safe(&queue, skb, tmp) {
-		struct net_device *dev = skb->dev;
+		struct net_device *dev;
+
+		br2684_push(atmvcc, skb);
+		dev = skb->dev;
 
 		dev->stats.rx_bytes -= skb->len;
 		dev->stats.rx_packets--;
-
-		br2684_push(atmvcc, skb);
 	}
 	__module_get(THIS_MODULE);
 	return 0;
diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index 615fecc..96b5f42 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -1892,6 +1892,7 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname, char __us
 			break;
 		}
 
+		memset(&cinfo, 0, sizeof(cinfo));
 		cinfo.hci_handle = l2cap_pi(sk)->conn->hcon->handle;
 		memcpy(cinfo.dev_class, l2cap_pi(sk)->conn->hcon->dev_class, 3);
 
@@ -2740,7 +2741,7 @@ static inline int l2cap_config_req(struct l2cap_conn *conn, struct l2cap_cmd_hdr
 
 	/* Reject if config buffer is too small. */
 	len = cmd_len - sizeof(*req);
-	if (l2cap_pi(sk)->conf_len + len > sizeof(l2cap_pi(sk)->conf_req)) {
+	if (len < 0 || l2cap_pi(sk)->conf_len + len > sizeof(l2cap_pi(sk)->conf_req)) {
 		l2cap_send_cmd(conn, cmd->ident, L2CAP_CONF_RSP,
 				l2cap_build_conf_rsp(sk, rsp,
 					L2CAP_CONF_REJECT, flags), rsp);
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index bc03b50..46c3f60 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -879,6 +879,7 @@ static int rfcomm_sock_getsockopt_old(struct socket *sock, int optname, char __u
 
 		l2cap_sk = rfcomm_pi(sk)->dlc->session->sock->sk;
 
+		memset(&cinfo, 0, sizeof(cinfo));
 		cinfo.hci_handle = l2cap_pi(l2cap_sk)->conn->hcon->handle;
 		memcpy(cinfo.dev_class, l2cap_pi(l2cap_sk)->conn->hcon->dev_class, 3);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index d1d0ee2..0efe23a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2664,7 +2664,7 @@ pull:
 			put_page(skb_shinfo(skb)->frags[0].page);
 			memmove(skb_shinfo(skb)->frags,
 				skb_shinfo(skb)->frags + 1,
-				--skb_shinfo(skb)->nr_frags);
+				--skb_shinfo(skb)->nr_frags * sizeof(skb_frag_t));
 		}
 	}
 
diff --git a/net/core/scm.c b/net/core/scm.c
index 9b26463..d98eafc 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -78,10 +78,11 @@ static int scm_fp_copy(struct cmsghdr *cmsg, struct scm_fp_list **fplp)
 			return -ENOMEM;
 		*fplp = fpl;
 		fpl->count = 0;
+		fpl->max = SCM_MAX_FD;
 	}
 	fpp = &fpl->fp[fpl->count];
 
-	if (fpl->count + num > SCM_MAX_FD)
+	if (fpl->count + num > fpl->max)
 		return -EINVAL;
 
 	/*
@@ -302,11 +303,12 @@ struct scm_fp_list *scm_fp_dup(struct scm_fp_list *fpl)
 	if (!fpl)
 		return NULL;
 
-	new_fpl = kmalloc(sizeof(*fpl), GFP_KERNEL);
+	new_fpl = kmemdup(fpl, offsetof(struct scm_fp_list, fp[fpl->count]),
+			  GFP_KERNEL);
 	if (new_fpl) {
-		for (i=fpl->count-1; i>=0; i--)
+		for (i = 0; i < fpl->count; i++)
 			get_file(fpl->fp[i]);
-		memcpy(new_fpl, fpl, sizeof(*fpl));
+		new_fpl->max = new_fpl->count;
 	}
 	return new_fpl;
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index cad8e97..7865bec 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2578,6 +2578,10 @@ struct sk_buff *skb_segment(struct sk_buff *skb, int features)
 		__copy_skb_header(nskb, skb);
 		nskb->mac_len = skb->mac_len;
 
+		/* nskb and skb might have different headroom */
+		if (nskb->ip_summed == CHECKSUM_PARTIAL)
+			nskb->csum_start += skb_headroom(nskb) - headroom;
+
 		skb_reset_mac_header(nskb);
 		skb_set_network_header(nskb, skb->mac_len);
 		nskb->transport_header = (nskb->network_header +
@@ -2708,7 +2712,7 @@ int skb_gro_receive(struct sk_buff **head, struct sk_buff *skb)
 		return -E2BIG;
 
 	headroom = skb_headroom(p);
-	nskb = netdev_alloc_skb(p->dev, headroom + skb_gro_offset(p));
+	nskb = alloc_skb(headroom + skb_gro_offset(p), GFP_ATOMIC);
 	if (unlikely(!nskb))
 		return -ENOMEM;
 
@@ -2745,8 +2749,12 @@ int skb_gro_receive(struct sk_buff **head, struct sk_buff *skb)
 
 merge:
 	if (offset > headlen) {
-		skbinfo->frags[0].page_offset += offset - headlen;
-		skbinfo->frags[0].size -= offset - headlen;
+		unsigned int eat = offset - headlen;
+
+		skbinfo->frags[0].page_offset += eat;
+		skbinfo->frags[0].size -= eat;
+		skb->data_len -= eat;
+		skb->len -= eat;
 		offset = headlen;
 	}
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index b4c050a..5df1d46 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -509,7 +509,7 @@ int ip6_forward(struct sk_buff *skb)
 		}
 	}
 
-	if (skb->len > dst_mtu(dst)) {
+	if (skb->len > dst_mtu(dst) && !skb_is_gso(skb)) {
 		/* Again, force OUTPUT device used as source address */
 		skb->dev = dst->dev;
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, dst_mtu(dst), skb->dev);
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 75fd1c6..fe9198b 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1195,6 +1195,11 @@ nla_put_failure:
 	return -1;
 }
 
+static bool tc_qdisc_dump_ignore(struct Qdisc *q)
+{
+	return (q->flags & TCQ_F_BUILTIN) ? true : false;
+}
+
 static int qdisc_notify(struct sk_buff *oskb, struct nlmsghdr *n,
 			u32 clid, struct Qdisc *old, struct Qdisc *new)
 {
@@ -1205,11 +1210,11 @@ static int qdisc_notify(struct sk_buff *oskb, struct nlmsghdr *n,
 	if (!skb)
 		return -ENOBUFS;
 
-	if (old && old->handle) {
+	if (old && !tc_qdisc_dump_ignore(old)) {
 		if (tc_fill_qdisc(skb, old, clid, pid, n->nlmsg_seq, 0, RTM_DELQDISC) < 0)
 			goto err_out;
 	}
-	if (new) {
+	if (new && !tc_qdisc_dump_ignore(new)) {
 		if (tc_fill_qdisc(skb, new, clid, pid, n->nlmsg_seq, old ? NLM_F_REPLACE : 0, RTM_NEWQDISC) < 0)
 			goto err_out;
 	}
@@ -1222,11 +1227,6 @@ err_out:
 	return -EINVAL;
 }
 
-static bool tc_qdisc_dump_ignore(struct Qdisc *q)
-{
-	return (q->flags & TCQ_F_BUILTIN) ? true : false;
-}
-
 static int tc_dump_qdisc_root(struct Qdisc *root, struct sk_buff *skb,
 			      struct netlink_callback *cb,
 			      int *q_idx_p, int s_q_idx)
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 20b989e..c5ba898 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1052,6 +1052,9 @@ call_bind_status(struct rpc_task *task)
 			status = -EOPNOTSUPP;
 			break;
 		}
+		if (task->tk_rebind_retry == 0)
+			break;
+		task->tk_rebind_retry--;
 		rpc_delay(task, 3*HZ);
 		goto retry_timeout;
 	case -ETIMEDOUT:
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 416ca5e..e961e06 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -799,6 +799,7 @@ static void rpc_init_task(struct rpc_task *task, const struct rpc_task_setup *ta
 	/* Initialize retry counters */
 	task->tk_garb_retry = 2;
 	task->tk_cred_retry = 2;
+	task->tk_rebind_retry = 2;
 
 	task->tk_priority = task_setup_data->priority - RPC_PRIORITY_LOW;
 	task->tk_owner = current->tgid;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index eb1674f..9866844 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3078,11 +3078,11 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	i = 0;
 	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
-			request->ssids[i].ssid_len = nla_len(attr);
-			if (request->ssids[i].ssid_len > IEEE80211_MAX_SSID_LEN) {
+			if (nla_len(attr) > IEEE80211_MAX_SSID_LEN) {
 				err = -EINVAL;
 				goto out_free;
 			}
+			request->ssids[i].ssid_len = nla_len(attr);
 			memcpy(request->ssids[i].ssid, nla_data(attr), nla_len(attr));
 			i++;
 		}
@@ -3539,9 +3539,12 @@ static int nl80211_crypto_settings(struct genl_info *info,
 		if (len % sizeof(u32))
 			return -EINVAL;
 
+		if (settings->n_akm_suites > NL80211_MAX_NR_AKM_SUITES)
+			return -EINVAL;
+
 		memcpy(settings->akm_suites, data, len);
 
-		for (i = 0; i < settings->n_ciphers_pairwise; i++)
+		for (i = 0; i < settings->n_akm_suites; i++)
 			if (!nl80211_valid_akm_suite(settings->akm_suites[i]))
 				return -EINVAL;
 	}
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7a0754c..6c4d92d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -998,6 +998,7 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 		return;
 	}
 
+	chan->beacon_found = false;
 	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
 	chan->max_antenna_gain = min(chan->orig_mag,
 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 04f83ab..32422a4 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -294,7 +294,8 @@ static struct sock *x25_find_listener(struct x25_address *addr,
 			 * Found a listening socket, now check the incoming
 			 * call user data vs this sockets call user data
 			 */
-			if(skb->len > 0 && x25_sk(s)->cudmatchlength > 0) {
+			if (x25_sk(s)->cudmatchlength > 0 &&
+				skb->len >= x25_sk(s)->cudmatchlength) {
 				if((memcmp(x25_sk(s)->calluserdata.cuddata,
 					skb->data,
 					x25_sk(s)->cudmatchlength)) == 0) {
diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index fe0423c..cc209b1 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -508,7 +508,7 @@ static int add_volume(struct hda_codec *codec, const char *name,
 		      int index, unsigned int pval, int dir,
 		      struct snd_kcontrol **kctlp)
 {
-	char tmp[32];
+	char tmp[44];
 	struct snd_kcontrol_new knew =
 		HDA_CODEC_VOLUME_IDX(tmp, index, 0, 0, HDA_OUTPUT);
 	knew.private_value = pval;
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 64f966c..0ec4c15 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1346,7 +1346,9 @@ do_sku:
 	 * 15   : 1 --> enable the function "Mute internal speaker
 	 *	        when the external headphone out jack is plugged"
 	 */
-	if (!spec->autocfg.hp_pins[0]) {
+	if (!spec->autocfg.hp_pins[0] &&
+	    !(spec->autocfg.line_out_pins[0] &&
+	      spec->autocfg.line_out_type == AUTO_PIN_HP_OUT)) {
 		hda_nid_t nid;
 		tmp = (ass >> 11) & 0x3;	/* HP to chassis */
 		if (tmp == 0)
@@ -18115,6 +18117,8 @@ static struct hda_codec_preset snd_hda_preset_realtek[] = {
 	  .patch = patch_alc882 },
 	{ .id = 0x10ec0662, .rev = 0x100101, .name = "ALC662 rev1",
 	  .patch = patch_alc662 },
+	{ .id = 0x10ec0662, .rev = 0x100300, .name = "ALC662 rev3",
+	  .patch = patch_alc662 },
 	{ .id = 0x10ec0663, .name = "ALC663", .patch = patch_alc662 },
 	{ .id = 0x10ec0880, .name = "ALC880", .patch = patch_alc880 },
 	{ .id = 0x10ec0882, .name = "ALC882", .patch = patch_alc882 },
diff --git a/sound/soc/codecs/ak4535.c b/sound/soc/codecs/ak4535.c
index ff96656..38af9d6 100644
--- a/sound/soc/codecs/ak4535.c
+++ b/sound/soc/codecs/ak4535.c
@@ -40,11 +40,11 @@ struct ak4535_priv {
 /*
  * ak4535 register cache
  */
-static const u16 ak4535_reg[AK4535_CACHEREGNUM] = {
-    0x0000, 0x0080, 0x0000, 0x0003,
-    0x0002, 0x0000, 0x0011, 0x0001,
-    0x0000, 0x0040, 0x0036, 0x0010,
-    0x0000, 0x0000, 0x0057, 0x0000,
+static const u8 ak4535_reg[AK4535_CACHEREGNUM] = {
+	0x00, 0x80, 0x00, 0x03,
+	0x02, 0x00, 0x11, 0x01,
+	0x00, 0x40, 0x36, 0x10,
+	0x00, 0x00, 0x57, 0x00,
 };
 
 /*
diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index 3ef16bb..eaf9375 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -93,17 +93,17 @@ static struct snd_soc_codec *ak4642_codec;
 /*
  * ak4642 register cache
  */
-static const u16 ak4642_reg[AK4642_CACHEREGNUM] = {
-	0x0000, 0x0000, 0x0001, 0x0000,
-	0x0002, 0x0000, 0x0000, 0x0000,
-	0x00e1, 0x00e1, 0x0018, 0x0000,
-	0x00e1, 0x0018, 0x0011, 0x0008,
-	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000,
+static const u8 ak4642_reg[AK4642_CACHEREGNUM] = {
+	0x00, 0x00, 0x01, 0x00,
+	0x02, 0x00, 0x00, 0x00,
+	0xe1, 0xe1, 0x18, 0x00,
+	0xe1, 0x18, 0x11, 0x08,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00,
 };
 
 /*
diff --git a/sound/soc/soc-jack.c b/sound/soc/soc-jack.c
index 3c07a94..f097755 100644
--- a/sound/soc/soc-jack.c
+++ b/sound/soc/soc-jack.c
@@ -95,7 +95,7 @@ void snd_soc_jack_report(struct snd_soc_jack *jack, int status, int mask)
 
 	snd_soc_dapm_sync(codec);
 
-	snd_jack_report(jack->jack, status);
+	snd_jack_report(jack->jack, jack->status);
 
 out:
 	mutex_unlock(&codec->mutex);
