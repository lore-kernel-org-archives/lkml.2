Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab1LETUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:20:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46812 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159Ab1LETT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:19:58 -0500
Date: Mon, 5 Dec 2011 20:18:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20111205191817.GA752@elte.hu>
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


out-of-topic modifications in x86-urgent-for-linus:
---------------------------------------------------
drivers/iommu/intel-iommu.c        # c8f369a: intel-iommu: Fix section mismatch
drivers/iommu/intr_remapping.c     # 61ed26e: intr_remapping: Fix section misma
drivers/power/intel_mid_battery.c  # a7a2804: x86/mrst: Battery fixes
include/linux/pci_ids.h            # f62ef5f: x86, amd: Fix up numa_node inform

 Thanks,

	Ingo

------------------>
Ajaykumar Hotchandani (1):
      x86/mtrr: Resolve inconsistency with Intel processor manual

Andreas Herrmann (1):
      x86, amd: Fix up numa_node information for AMD CPU family 15h model 0-0fh northbridge functions

Bjorn Helgaas (1):
      x86/mpparse: Account for bus types other than ISA and PCI

Borislav Petkov (2):
      x86: Document rdmsr_safe restrictions
      x86, AMD: Correct align_va_addr documentation

Feng Tang (1):
      x86, mrst: Change the pmic_gpio device type to IPC

Jack Steiner (1):
      x86, UV: Fix UV2 hub part number

Jacob Pan (1):
      x86,mrst: Power control commands update

Jekyll Lai (1):
      mrst: Added some platform data for the SFI translations

Konrad Rzeszutek Wilk (1):
      x86/paravirt: PTE updates in k(un)map_atomic need to be synchronous, regardless of lazy_mmu mode

Major Lee (1):
      x86/mrst: Battery fixes

Mathias Nyman (1):
      x86/rtc, mrst: Don't register a platform RTC device for for Intel MID platforms

Mitsuo Hayasaka (1):
      x86: Add user_mode_vm check in stack_overflow_check

Peter Chubb (1):
      x86: Fix "Acer Aspire 1" reboot hang

Prarit Bhargava (1):
      Add TAINT_FIRMWARE_WORKAROUND on MTRR fixup

Rafael J. Wysocki (1):
      x86/reboot: Blacklist Dell OptiPlex 990 known to require PCI reboot

Sergey Senozhatsky (2):
      intel-iommu: Fix section mismatch in dmar_parse_rmrr_atsr_dev()
      intr_remapping: Fix section mismatch in ir_dev_scope_init()

Srivatsa S. Bhat (1):
      x86, microcode: Fix the failure path of microcode update driver init code


 Documentation/kernel-parameters.txt  |    4 +-
 arch/x86/include/asm/intel_scu_ipc.h |   14 ++++--
 arch/x86/include/asm/mrst.h          |    9 ++++
 arch/x86/include/asm/msr.h           |    9 ++++-
 arch/x86/include/asm/uv/uv_mmrs.h    |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c   |    2 +
 arch/x86/kernel/cpu/mtrr/generic.c   |    2 +
 arch/x86/kernel/irq_64.c             |    3 +
 arch/x86/kernel/microcode_core.c     |   28 +++++++++----
 arch/x86/kernel/mpparse.c            |    2 +-
 arch/x86/kernel/quirks.c             |   13 ++++++
 arch/x86/kernel/reboot.c             |   21 +++++++++-
 arch/x86/kernel/rtc.c                |    5 ++
 arch/x86/mm/highmem_32.c             |    2 +
 arch/x86/platform/mrst/mrst.c        |   68 ++++++++++++++++++++++++++++-----
 drivers/iommu/intel-iommu.c          |    2 +-
 drivers/iommu/intr_remapping.c       |    2 +-
 drivers/power/intel_mid_battery.c    |   12 +++---
 include/linux/pci_ids.h              |    4 ++
 19 files changed, 164 insertions(+), 39 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a0c5c5f..5e22c3f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -315,8 +315,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			CPU-intensive style benchmark, and it can vary highly in
 			a microbenchmark depending on workload and compiler.
 
-			1: only for 32-bit processes
-			2: only for 64-bit processes
+			32: only for 32-bit processes
+			64: only for 64-bit processes
 			on: enable for both 32- and 64-bit processes
 			off: disable for both 32- and 64-bit processes
 
diff --git a/arch/x86/include/asm/intel_scu_ipc.h b/arch/x86/include/asm/intel_scu_ipc.h
index 4420993..925b605 100644
--- a/arch/x86/include/asm/intel_scu_ipc.h
+++ b/arch/x86/include/asm/intel_scu_ipc.h
@@ -3,11 +3,15 @@
 
 #include <linux/notifier.h>
 
-#define IPCMSG_VRTC	0xFA	 /* Set vRTC device */
-
-/* Command id associated with message IPCMSG_VRTC */
-#define IPC_CMD_VRTC_SETTIME      1 /* Set time */
-#define IPC_CMD_VRTC_SETALARM     2 /* Set alarm */
+#define IPCMSG_WARM_RESET	0xF0
+#define IPCMSG_COLD_RESET	0xF1
+#define IPCMSG_SOFT_RESET	0xF2
+#define IPCMSG_COLD_BOOT	0xF3
+
+#define IPCMSG_VRTC		0xFA	 /* Set vRTC device */
+	/* Command id associated with message IPCMSG_VRTC */
+	#define IPC_CMD_VRTC_SETTIME      1 /* Set time */
+	#define IPC_CMD_VRTC_SETALARM     2 /* Set alarm */
 
 /* Read single register */
 int intel_scu_ipc_ioread8(u16 addr, u8 *data);
diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index e628312..93f7909 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -31,11 +31,20 @@ enum mrst_cpu_type {
 };
 
 extern enum mrst_cpu_type __mrst_cpu_chip;
+
+#ifdef CONFIG_X86_INTEL_MID
+
 static inline enum mrst_cpu_type mrst_identify_cpu(void)
 {
 	return __mrst_cpu_chip;
 }
 
+#else /* !CONFIG_X86_INTEL_MID */
+
+#define mrst_identify_cpu()    (0)
+
+#endif /* !CONFIG_X86_INTEL_MID */
+
 enum mrst_timer_options {
 	MRST_TIMER_DEFAULT,
 	MRST_TIMER_APBT_ONLY,
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 084ef95..95203d4 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -169,7 +169,14 @@ static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
 	return native_write_msr_safe(msr, low, high);
 }
 
-/* rdmsr with exception handling */
+/*
+ * rdmsr with exception handling.
+ *
+ * Please note that the exception handling works only after we've
+ * switched to the "smart" #GP handler in trap_init() which knows about
+ * exception tables - using this macro earlier than that causes machine
+ * hangs on boxes which do not implement the @msr in the first argument.
+ */
 #define rdmsr_safe(msr, p1, p2)					\
 ({								\
 	int __err;						\
diff --git a/arch/x86/include/asm/uv/uv_mmrs.h b/arch/x86/include/asm/uv/uv_mmrs.h
index 10474fb..cf1d736 100644
--- a/arch/x86/include/asm/uv/uv_mmrs.h
+++ b/arch/x86/include/asm/uv/uv_mmrs.h
@@ -57,6 +57,7 @@
 
 #define UV1_HUB_PART_NUMBER	0x88a5
 #define UV2_HUB_PART_NUMBER	0x8eb8
+#define UV2_HUB_PART_NUMBER_X	0x1111
 
 /* Compat: if this #define is present, UV headers support UV2 */
 #define UV2_HUB_IS_SUPPORTED	1
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 62ae300..9d59bba 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -93,6 +93,8 @@ static int __init early_get_pnodeid(void)
 
 	if (node_id.s.part_number == UV2_HUB_PART_NUMBER)
 		uv_min_hub_revision_id += UV2_HUB_REVISION_BASE - 1;
+	if (node_id.s.part_number == UV2_HUB_PART_NUMBER_X)
+		uv_min_hub_revision_id += UV2_HUB_REVISION_BASE - 1;
 
 	uv_hub_info->hub_revision = uv_min_hub_revision_id;
 	pnode = (node_id.s.node_id >> 1) & ((1 << m_n_config.s.n_skt) - 1);
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index a71efcdb..97b2635 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -547,6 +547,7 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 
 		if (tmp != mask_lo) {
 			printk(KERN_WARNING "mtrr: your BIOS has configured an incorrect mask, fixing it.\n");
+			add_taint(TAINT_FIRMWARE_WORKAROUND);
 			mask_lo = tmp;
 		}
 	}
@@ -693,6 +694,7 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
 
 	/* Disable MTRRs, and set the default type to uncached */
 	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo & ~0xcff, deftype_hi);
+	wbinvd();
 }
 
 static void post_set(void) __releases(set_atomicity_lock)
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index acf8fbf..69bca46 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -38,6 +38,9 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	u64 curbase = (u64)task_stack_page(current);
 
+	if (user_mode_vm(regs))
+		return;
+
 	WARN_ONCE(regs->sp >= curbase &&
 		  regs->sp <= curbase + THREAD_SIZE &&
 		  regs->sp <  curbase + sizeof(struct thread_info) +
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index f2d2a66..9d46f5e 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -256,7 +256,7 @@ static int __init microcode_dev_init(void)
 	return 0;
 }
 
-static void microcode_dev_exit(void)
+static void __exit microcode_dev_exit(void)
 {
 	misc_deregister(&microcode_dev);
 }
@@ -519,10 +519,8 @@ static int __init microcode_init(void)
 
 	microcode_pdev = platform_device_register_simple("microcode", -1,
 							 NULL, 0);
-	if (IS_ERR(microcode_pdev)) {
-		microcode_dev_exit();
+	if (IS_ERR(microcode_pdev))
 		return PTR_ERR(microcode_pdev);
-	}
 
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
@@ -532,14 +530,12 @@ static int __init microcode_init(void)
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
 
-	if (error) {
-		platform_device_unregister(microcode_pdev);
-		return error;
-	}
+	if (error)
+		goto out_pdev;
 
 	error = microcode_dev_init();
 	if (error)
-		return error;
+		goto out_sysdev_driver;
 
 	register_syscore_ops(&mc_syscore_ops);
 	register_hotcpu_notifier(&mc_cpu_notifier);
@@ -548,6 +544,20 @@ static int __init microcode_init(void)
 		" <tigran@aivazian.fsnet.co.uk>, Peter Oruba\n");
 
 	return 0;
+
+out_sysdev_driver:
+	get_online_cpus();
+	mutex_lock(&microcode_mutex);
+
+	sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
+
+	mutex_unlock(&microcode_mutex);
+	put_online_cpus();
+
+out_pdev:
+	platform_device_unregister(microcode_pdev);
+	return error;
+
 }
 module_init(microcode_init);
 
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 9103b89..0741b062 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -95,8 +95,8 @@ static void __init MP_bus_info(struct mpc_bus *m)
 	}
 #endif
 
+	set_bit(m->busid, mp_bus_not_pci);
 	if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
-		set_bit(m->busid, mp_bus_not_pci);
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 		mp_bus_id_to_type[m->busid] = MP_BUS_ISA;
 #endif
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index b78643d..03920a1 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -553,4 +553,17 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC,
 			quirk_amd_nb_node);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_LINK,
 			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F0,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F1,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F2,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F5,
+			quirk_amd_nb_node);
+
 #endif
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index e334be1..37a458b 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -124,7 +124,7 @@ __setup("reboot=", reboot_setup);
  */
 
 /*
- * Some machines require the "reboot=b"  commandline option,
+ * Some machines require the "reboot=b" or "reboot=k"  commandline options,
  * this quirk makes that automatic.
  */
 static int __init set_bios_reboot(const struct dmi_system_id *d)
@@ -136,6 +136,15 @@ static int __init set_bios_reboot(const struct dmi_system_id *d)
 	return 0;
 }
 
+static int __init set_kbd_reboot(const struct dmi_system_id *d)
+{
+	if (reboot_type != BOOT_KBD) {
+		reboot_type = BOOT_KBD;
+		printk(KERN_INFO "%s series board detected. Selecting KBD-method for reboot.\n", d->ident);
+	}
+	return 0;
+}
+
 static struct dmi_system_id __initdata reboot_dmi_table[] = {
 	{	/* Handle problems with rebooting on Dell E520's */
 		.callback = set_bios_reboot,
@@ -295,7 +304,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 		},
 	},
 	{ /* Handle reboot issue on Acer Aspire one */
-		.callback = set_bios_reboot,
+		.callback = set_kbd_reboot,
 		.ident = "Acer Aspire One A110",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
@@ -443,6 +452,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
 		},
 	},
+	{	/* Handle problems with rebooting on the OptiPlex 990. */
+		.callback = set_pci_reboot,
+		.ident = "Dell OptiPlex 990",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
+		},
+	},
 	{ }
 };
 
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 348ce01..af6db6e 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -12,6 +12,7 @@
 #include <asm/vsyscall.h>
 #include <asm/x86_init.h>
 #include <asm/time.h>
+#include <asm/mrst.h>
 
 #ifdef CONFIG_X86_32
 /*
@@ -242,6 +243,10 @@ static __init int add_rtc_cmos(void)
 	if (of_have_populated_dt())
 		return 0;
 
+	/* Intel MID platforms don't have ioport rtc */
+	if (mrst_identify_cpu())
+		return -ENODEV;
+
 	platform_device_register(&rtc_device);
 	dev_info(&rtc_device.dev,
 		 "registered platform RTC device (no PNP device found)\n");
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index b499626..f4f29b1 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -45,6 +45,7 @@ void *kmap_atomic_prot(struct page *page, pgprot_t prot)
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
 	set_pte(kmap_pte-idx, mk_pte(page, prot));
+	arch_flush_lazy_mmu_mode();
 
 	return (void *)vaddr;
 }
@@ -88,6 +89,7 @@ void __kunmap_atomic(void *kvaddr)
 		 */
 		kpte_clear_flush(kmap_pte-idx, vaddr);
 		kmap_atomic_idx_pop();
+		arch_flush_lazy_mmu_mode();
 	}
 #ifdef CONFIG_DEBUG_HIGHMEM
 	else {
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index b1489a0..ad4ec1c 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -76,6 +76,20 @@ struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
 EXPORT_SYMBOL_GPL(sfi_mrtc_array);
 int sfi_mrtc_num;
 
+static void mrst_power_off(void)
+{
+	if (__mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT)
+		intel_scu_ipc_simple_command(IPCMSG_COLD_RESET, 1);
+}
+
+static void mrst_reboot(void)
+{
+	if (__mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT)
+		intel_scu_ipc_simple_command(IPCMSG_COLD_RESET, 0);
+	else
+		intel_scu_ipc_simple_command(IPCMSG_COLD_BOOT, 0);
+}
+
 /* parse all the mtimer info to a static mtimer array */
 static int __init sfi_parse_mtmr(struct sfi_table_header *table)
 {
@@ -265,17 +279,6 @@ static int mrst_i8042_detect(void)
 	return 0;
 }
 
-/* Reboot and power off are handled by the SCU on a MID device */
-static void mrst_power_off(void)
-{
-	intel_scu_ipc_simple_command(0xf1, 1);
-}
-
-static void mrst_reboot(void)
-{
-	intel_scu_ipc_simple_command(0xf1, 0);
-}
-
 /*
  * Moorestown does not have external NMI source nor port 0x61 to report
  * NMI status. The possible NMI sources are from pmu as a result of NMI
@@ -484,6 +487,46 @@ static void __init *max7315_platform_data(void *info)
 	return max7315;
 }
 
+static void *tca6416_platform_data(void *info)
+{
+	static struct pca953x_platform_data tca6416;
+	struct i2c_board_info *i2c_info = info;
+	int gpio_base, intr;
+	char base_pin_name[SFI_NAME_LEN + 1];
+	char intr_pin_name[SFI_NAME_LEN + 1];
+
+	strcpy(i2c_info->type, "tca6416");
+	strcpy(base_pin_name, "tca6416_base");
+	strcpy(intr_pin_name, "tca6416_int");
+
+	gpio_base = get_gpio_by_name(base_pin_name);
+	intr = get_gpio_by_name(intr_pin_name);
+
+	if (gpio_base == -1)
+		return NULL;
+	tca6416.gpio_base = gpio_base;
+	if (intr != -1) {
+		i2c_info->irq = intr + MRST_IRQ_OFFSET;
+		tca6416.irq_base = gpio_base + MRST_IRQ_OFFSET;
+	} else {
+		i2c_info->irq = -1;
+		tca6416.irq_base = -1;
+	}
+	return &tca6416;
+}
+
+static void *mpu3050_platform_data(void *info)
+{
+	struct i2c_board_info *i2c_info = info;
+	int intr = get_gpio_by_name("mpu3050_int");
+
+	if (intr == -1)
+		return NULL;
+
+	i2c_info->irq = intr + MRST_IRQ_OFFSET;
+	return NULL;
+}
+
 static void __init *emc1403_platform_data(void *info)
 {
 	static short intr2nd_pdata;
@@ -646,12 +689,15 @@ static void *msic_ocd_platform_data(void *info)
 static const struct devs_id __initconst device_ids[] = {
 	{"bma023", SFI_DEV_TYPE_I2C, 1, &no_platform_data},
 	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data},
+	{"pmic_gpio", SFI_DEV_TYPE_IPC, 1, &pmic_gpio_platform_data},
 	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data},
 	{"i2c_max7315", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data},
 	{"i2c_max7315_2", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data},
+	{"tca6416", SFI_DEV_TYPE_I2C, 1, &tca6416_platform_data},
 	{"emc1403", SFI_DEV_TYPE_I2C, 1, &emc1403_platform_data},
 	{"i2c_accel", SFI_DEV_TYPE_I2C, 0, &lis331dl_platform_data},
 	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data},
+	{"mpu3050", SFI_DEV_TYPE_I2C, 1, &mpu3050_platform_data},
 
 	/* MSIC subdevices */
 	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data},
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c0c7820..a004c39 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3524,7 +3524,7 @@ found:
 	return 0;
 }
 
-int dmar_parse_rmrr_atsr_dev(void)
+int __init dmar_parse_rmrr_atsr_dev(void)
 {
 	struct dmar_rmrr_unit *rmrr, *rmrr_n;
 	struct dmar_atsr_unit *atsr, *atsr_n;
diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intr_remapping.c
index 07c9f18..6777ca0 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -773,7 +773,7 @@ int __init parse_ioapics_under_ir(void)
 	return ir_supported;
 }
 
-int ir_dev_scope_init(void)
+int __init ir_dev_scope_init(void)
 {
 	if (!intr_remapping_enabled)
 		return 0;
diff --git a/drivers/power/intel_mid_battery.c b/drivers/power/intel_mid_battery.c
index cffcb7c..01fa671 100644
--- a/drivers/power/intel_mid_battery.c
+++ b/drivers/power/intel_mid_battery.c
@@ -61,7 +61,8 @@ MODULE_PARM_DESC(debug, "Flag to enable PMIC Battery debug messages.");
 #define PMIC_BATT_CHR_SBATDET_MASK	(1 << 5)
 #define PMIC_BATT_CHR_SDCLMT_MASK	(1 << 6)
 #define PMIC_BATT_CHR_SUSBOVP_MASK	(1 << 7)
-#define PMIC_BATT_CHR_EXCPT_MASK	0xC6
+#define PMIC_BATT_CHR_EXCPT_MASK	0x86
+
 #define PMIC_BATT_ADC_ACCCHRG_MASK	(1 << 31)
 #define PMIC_BATT_ADC_ACCCHRGVAL_MASK	0x7FFFFFFF
 
@@ -304,11 +305,6 @@ static void pmic_battery_read_status(struct pmic_power_module_info *pbi)
 			pbi->batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
 			pmic_battery_log_event(BATT_EVENT_BATOVP_EXCPT);
 			batt_exception = 1;
-		} else if (r8 & PMIC_BATT_CHR_SDCLMT_MASK) {
-			pbi->batt_health = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
-			pbi->batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
-			pmic_battery_log_event(BATT_EVENT_DCLMT_EXCPT);
-			batt_exception = 1;
 		} else if (r8 & PMIC_BATT_CHR_STEMP_MASK) {
 			pbi->batt_health = POWER_SUPPLY_HEALTH_OVERHEAT;
 			pbi->batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
@@ -316,6 +312,10 @@ static void pmic_battery_read_status(struct pmic_power_module_info *pbi)
 			batt_exception = 1;
 		} else {
 			pbi->batt_health = POWER_SUPPLY_HEALTH_GOOD;
+			if (r8 & PMIC_BATT_CHR_SDCLMT_MASK) {
+				/* PMIC will change charging current automatically */
+				pmic_battery_log_event(BATT_EVENT_DCLMT_EXCPT);
+			}
 		}
 	}
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 172ba70..2aaee0c 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -517,8 +517,12 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_DRAM	0x1302
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
+#define PCI_DEVICE_ID_AMD_15H_NB_F0	0x1600
+#define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
+#define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
 #define PCI_DEVICE_ID_AMD_15H_NB_F3	0x1603
 #define PCI_DEVICE_ID_AMD_15H_NB_F4	0x1604
+#define PCI_DEVICE_ID_AMD_15H_NB_F5	0x1605
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
