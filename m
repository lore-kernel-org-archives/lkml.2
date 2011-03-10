Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab1CJAeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:34:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43252 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab1CJAeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:34:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 2/2] Convert several sysdev users to using struct syscore_ops
Date: Thu, 10 Mar 2011 01:34:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de
References: <201103100131.58206.rjw@sisk.pl>
In-Reply-To: <201103100131.58206.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103100134.02675.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some subsystems need to carry out suspend/resume and shutdown
operations with one CPU on-line and interrupts disabled and they
define sysdev classes and sysdevs specifically for this purpose.
This leads to unnecessarily complicated code and excessive memory
usage, so switch them to using struct syscore_ops objects for this
purpose instead.

---
 arch/x86/kernel/amd_iommu_init.c |   26 ++--------
 arch/x86/kernel/apic/apic.c      |   29 +++--------
 arch/x86/kernel/apic/io_apic.c   |   97 ++++++++++++++++++---------------------
 arch/x86/kernel/i8237.c          |   30 ++----------
 arch/x86/kernel/i8259.c          |   33 ++++---------
 arch/x86/kernel/pci-gart_64.c    |   32 ++----------
 arch/x86/oprofile/nmi_int.c      |   44 ++++-------------
 drivers/acpi/pci_link.c          |   30 +++---------
 drivers/pci/intel-iommu.c        |   38 +++------------
 kernel/time/timekeeping.c        |   27 +++-------
 10 files changed, 121 insertions(+), 265 deletions(-)

Index: linux-2.6/arch/x86/kernel/amd_iommu_init.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/amd_iommu_init.c
+++ linux-2.6/arch/x86/kernel/amd_iommu_init.c
@@ -21,7 +21,7 @@
 #include <linux/acpi.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/interrupt.h>
 #include <linux/msi.h>
 #include <asm/pci-direct.h>
@@ -1260,7 +1260,7 @@ static void disable_iommus(void)
  * disable suspend until real resume implemented
  */
 
-static int amd_iommu_resume(struct sys_device *dev)
+static void amd_iommu_resume(void)
 {
 	struct amd_iommu *iommu;
 
@@ -1276,11 +1276,9 @@ static int amd_iommu_resume(struct sys_d
 	 */
 	amd_iommu_flush_all_devices();
 	amd_iommu_flush_all_domains();
-
-	return 0;
 }
 
-static int amd_iommu_suspend(struct sys_device *dev, pm_message_t state)
+static int amd_iommu_suspend(void)
 {
 	/* disable IOMMUs to go out of the way for BIOS */
 	disable_iommus();
@@ -1288,17 +1286,11 @@ static int amd_iommu_suspend(struct sys_
 	return 0;
 }
 
-static struct sysdev_class amd_iommu_sysdev_class = {
-	.name = "amd_iommu",
+static struct syscore_ops amd_iommu_syscore_ops = {
 	.suspend = amd_iommu_suspend,
 	.resume = amd_iommu_resume,
 };
 
-static struct sys_device device_amd_iommu = {
-	.id = 0,
-	.cls = &amd_iommu_sysdev_class,
-};
-
 /*
  * This is the core init function for AMD IOMMU hardware in the system.
  * This function is called from the generic x86 DMA layer initialization
@@ -1415,14 +1407,6 @@ static int __init amd_iommu_init(void)
 		goto free;
 	}
 
-	ret = sysdev_class_register(&amd_iommu_sysdev_class);
-	if (ret)
-		goto free;
-
-	ret = sysdev_register(&device_amd_iommu);
-	if (ret)
-		goto free;
-
 	ret = amd_iommu_init_devices();
 	if (ret)
 		goto free;
@@ -1441,6 +1425,8 @@ static int __init amd_iommu_init(void)
 
 	amd_iommu_init_notifier();
 
+	register_syscore_ops(&amd_iommu_syscore_ops);
+
 	if (iommu_pass_through)
 		goto out;
 
Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -24,7 +24,7 @@
 #include <linux/ftrace.h>
 #include <linux/ioport.h>
 #include <linux/module.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/delay.h>
 #include <linux/timex.h>
 #include <linux/dmar.h>
@@ -2036,7 +2036,7 @@ static struct {
 	unsigned int apic_thmr;
 } apic_pm_state;
 
-static int lapic_suspend(struct sys_device *dev, pm_message_t state)
+static int lapic_suspend(void)
 {
 	unsigned long flags;
 	int maxlvt;
@@ -2074,7 +2074,7 @@ static int lapic_suspend(struct sys_devi
 	return 0;
 }
 
-static int lapic_resume(struct sys_device *dev)
+static void lapic_resume(void)
 {
 	unsigned int l, h;
 	unsigned long flags;
@@ -2083,7 +2083,7 @@ static int lapic_resume(struct sys_devic
 	struct IO_APIC_route_entry **ioapic_entries = NULL;
 
 	if (!apic_pm_state.active)
-		return 0;
+		return;
 
 	local_irq_save(flags);
 	if (intr_remapping_enabled) {
@@ -2152,8 +2152,6 @@ static int lapic_resume(struct sys_devic
 	}
 restore:
 	local_irq_restore(flags);
-
-	return ret;
 }
 
 /*
@@ -2161,17 +2159,11 @@ restore:
  * are needed on every CPU up until machine_halt/restart/poweroff.
  */
 
-static struct sysdev_class lapic_sysclass = {
-	.name		= "lapic",
+static struct syscore_ops lapic_syscore_ops = {
 	.resume		= lapic_resume,
 	.suspend	= lapic_suspend,
 };
 
-static struct sys_device device_lapic = {
-	.id	= 0,
-	.cls	= &lapic_sysclass,
-};
-
 static void __cpuinit apic_pm_activate(void)
 {
 	apic_pm_state.active = 1;
@@ -2179,16 +2171,11 @@ static void __cpuinit apic_pm_activate(v
 
 static int __init init_lapic_sysfs(void)
 {
-	int error;
-
-	if (!cpu_has_apic)
-		return 0;
 	/* XXX: remove suspend/resume procs if !apic_pm_state.active? */
+	if (cpu_has_apic)
+		register_syscore_ops(&lapic_syscore_ops);
 
-	error = sysdev_class_register(&lapic_sysclass);
-	if (!error)
-		error = sysdev_register(&device_lapic);
-	return error;
+	return 0;
 }
 
 /* local apic needs to resume before other devices access its registers. */
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -30,7 +30,7 @@
 #include <linux/compiler.h>
 #include <linux/acpi.h>
 #include <linux/module.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/msi.h>
 #include <linux/htirq.h>
 #include <linux/freezer.h>
@@ -2948,89 +2948,84 @@ static int __init io_apic_bug_finalize(v
 
 late_initcall(io_apic_bug_finalize);
 
-struct sysfs_ioapic_data {
-	struct sys_device dev;
-	struct IO_APIC_route_entry entry[0];
-};
-static struct sysfs_ioapic_data * mp_ioapic_data[MAX_IO_APICS];
+static struct IO_APIC_route_entry *ioapic_saved_data[MAX_IO_APICS];
 
-static int ioapic_suspend(struct sys_device *dev, pm_message_t state)
+static void suspend_ioapic(int ioapic_id)
 {
-	struct IO_APIC_route_entry *entry;
-	struct sysfs_ioapic_data *data;
+	struct IO_APIC_route_entry *saved_data = ioapic_saved_data[ioapic_id];
 	int i;
 
-	data = container_of(dev, struct sysfs_ioapic_data, dev);
-	entry = data->entry;
-	for (i = 0; i < nr_ioapic_registers[dev->id]; i ++, entry ++ )
-		*entry = ioapic_read_entry(dev->id, i);
+	if (!saved_data)
+		return;
+
+	for (i = 0; i < nr_ioapic_registers[ioapic_id]; i++)
+		saved_data[i] = ioapic_read_entry(ioapic_id, i);
+}
+
+static int ioapic_suspend(void)
+{
+	int ioapic_id;
+
+	for (ioapic_id = 0; ioapic_id < nr_ioapics; ioapic_id++)
+		suspend_ioapic(ioapic_id);
 
 	return 0;
 }
 
-static int ioapic_resume(struct sys_device *dev)
+static void resume_ioapic(int ioapic_id)
 {
-	struct IO_APIC_route_entry *entry;
-	struct sysfs_ioapic_data *data;
+	struct IO_APIC_route_entry *saved_data = ioapic_saved_data[ioapic_id];
 	unsigned long flags;
 	union IO_APIC_reg_00 reg_00;
 	int i;
 
-	data = container_of(dev, struct sysfs_ioapic_data, dev);
-	entry = data->entry;
+	if (!saved_data)
+		return;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	reg_00.raw = io_apic_read(dev->id, 0);
-	if (reg_00.bits.ID != mp_ioapics[dev->id].apicid) {
-		reg_00.bits.ID = mp_ioapics[dev->id].apicid;
-		io_apic_write(dev->id, 0, reg_00.raw);
+	reg_00.raw = io_apic_read(ioapic_id, 0);
+	if (reg_00.bits.ID != mp_ioapics[ioapic_id].apicid) {
+		reg_00.bits.ID = mp_ioapics[ioapic_id].apicid;
+		io_apic_write(ioapic_id, 0, reg_00.raw);
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-	for (i = 0; i < nr_ioapic_registers[dev->id]; i++)
-		ioapic_write_entry(dev->id, i, entry[i]);
+	for (i = 0; i < nr_ioapic_registers[ioapic_id]; i++)
+		ioapic_write_entry(ioapic_id, i, saved_data[i]);
+}
 
-	return 0;
+static void ioapic_resume(void)
+{
+	int ioapic_id;
+
+	for (ioapic_id = nr_ioapics - 1; ioapic_id >= 0; ioapic_id--)
+		resume_ioapic(ioapic_id);
 }
 
-static struct sysdev_class ioapic_sysdev_class = {
-	.name = "ioapic",
+static struct syscore_ops ioapic_syscore_ops = {
 	.suspend = ioapic_suspend,
 	.resume = ioapic_resume,
 };
 
-static int __init ioapic_init_sysfs(void)
+static int __init ioapic_init_ops(void)
 {
-	struct sys_device * dev;
-	int i, size, error;
+	int i;
 
-	error = sysdev_class_register(&ioapic_sysdev_class);
-	if (error)
-		return error;
+	for (i = 0; i < nr_ioapics; i++) {
+		unsigned int size;
 
-	for (i = 0; i < nr_ioapics; i++ ) {
-		size = sizeof(struct sys_device) + nr_ioapic_registers[i]
+		size = nr_ioapic_registers[i]
 			* sizeof(struct IO_APIC_route_entry);
-		mp_ioapic_data[i] = kzalloc(size, GFP_KERNEL);
-		if (!mp_ioapic_data[i]) {
-			printk(KERN_ERR "Can't suspend/resume IOAPIC %d\n", i);
-			continue;
-		}
-		dev = &mp_ioapic_data[i]->dev;
-		dev->id = i;
-		dev->cls = &ioapic_sysdev_class;
-		error = sysdev_register(dev);
-		if (error) {
-			kfree(mp_ioapic_data[i]);
-			mp_ioapic_data[i] = NULL;
-			printk(KERN_ERR "Can't suspend/resume IOAPIC %d\n", i);
-			continue;
-		}
+		ioapic_saved_data[i] = kzalloc(size, GFP_KERNEL);
+		if (!ioapic_saved_data[i])
+			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
 	}
 
+	register_syscore_ops(&ioapic_syscore_ops);
+
 	return 0;
 }
 
-device_initcall(ioapic_init_sysfs);
+device_initcall(ioapic_init_ops);
 
 /*
  * Dynamic irq allocate and deallocation
Index: linux-2.6/arch/x86/kernel/i8237.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/i8237.c
+++ linux-2.6/arch/x86/kernel/i8237.c
@@ -10,7 +10,7 @@
  */
 
 #include <linux/init.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/dma.h>
 
@@ -21,7 +21,7 @@
  * in asm/dma.h.
  */
 
-static int i8237A_resume(struct sys_device *dev)
+static void i8237A_resume(void)
 {
 	unsigned long flags;
 	int i;
@@ -41,31 +41,15 @@ static int i8237A_resume(struct sys_devi
 	enable_dma(4);
 
 	release_dma_lock(flags);
-
-	return 0;
 }
 
-static int i8237A_suspend(struct sys_device *dev, pm_message_t state)
-{
-	return 0;
-}
-
-static struct sysdev_class i8237_sysdev_class = {
-	.name		= "i8237",
-	.suspend	= i8237A_suspend,
+static struct syscore_ops i8237_syscore_ops = {
 	.resume		= i8237A_resume,
 };
 
-static struct sys_device device_i8237A = {
-	.id		= 0,
-	.cls		= &i8237_sysdev_class,
-};
-
-static int __init i8237A_init_sysfs(void)
+static int __init i8237A_init_ops(void)
 {
-	int error = sysdev_class_register(&i8237_sysdev_class);
-	if (!error)
-		error = sysdev_register(&device_i8237A);
-	return error;
+	register_syscore_ops(&i8237_syscore_ops);
+	return 0;
 }
-device_initcall(i8237A_init_sysfs);
+device_initcall(i8237A_init_ops);
Index: linux-2.6/arch/x86/kernel/i8259.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/i8259.c
+++ linux-2.6/arch/x86/kernel/i8259.c
@@ -8,7 +8,7 @@
 #include <linux/random.h>
 #include <linux/init.h>
 #include <linux/kernel_stat.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/bitops.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
@@ -245,20 +245,19 @@ static void save_ELCR(char *trigger)
 	trigger[1] = inb(0x4d1) & 0xDE;
 }
 
-static int i8259A_resume(struct sys_device *dev)
+static void i8259A_resume(void)
 {
 	init_8259A(i8259A_auto_eoi);
 	restore_ELCR(irq_trigger);
-	return 0;
 }
 
-static int i8259A_suspend(struct sys_device *dev, pm_message_t state)
+static int i8259A_suspend(void)
 {
 	save_ELCR(irq_trigger);
 	return 0;
 }
 
-static int i8259A_shutdown(struct sys_device *dev)
+static void i8259A_shutdown(void)
 {
 	/* Put the i8259A into a quiescent state that
 	 * the kernel initialization code can get it
@@ -266,21 +265,14 @@ static int i8259A_shutdown(struct sys_de
 	 */
 	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
 	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-1 */
-	return 0;
 }
 
-static struct sysdev_class i8259_sysdev_class = {
-	.name = "i8259",
+static struct syscore_ops i8259_syscore_ops = {
 	.suspend = i8259A_suspend,
 	.resume = i8259A_resume,
 	.shutdown = i8259A_shutdown,
 };
 
-static struct sys_device device_i8259A = {
-	.id	= 0,
-	.cls	= &i8259_sysdev_class,
-};
-
 static void mask_8259A(void)
 {
 	unsigned long flags;
@@ -399,17 +391,12 @@ struct legacy_pic default_legacy_pic = {
 
 struct legacy_pic *legacy_pic = &default_legacy_pic;
 
-static int __init i8259A_init_sysfs(void)
+static int __init i8259A_init_ops(void)
 {
-	int error;
-
-	if (legacy_pic != &default_legacy_pic)
-		return 0;
+	if (legacy_pic == &default_legacy_pic)
+		register_syscore_ops(&i8259_syscore_ops);
 
-	error = sysdev_class_register(&i8259_sysdev_class);
-	if (!error)
-		error = sysdev_register(&device_i8259A);
-	return error;
+	return 0;
 }
 
-device_initcall(i8259A_init_sysfs);
+device_initcall(i8259A_init_ops);
Index: linux-2.6/arch/x86/kernel/pci-gart_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-gart_64.c
+++ linux-2.6/arch/x86/kernel/pci-gart_64.c
@@ -27,7 +27,7 @@
 #include <linux/kdebug.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/io.h>
 #include <linux/gfp.h>
 #include <asm/atomic.h>
@@ -589,7 +589,7 @@ void set_up_gart_resume(u32 aper_order,
 	aperture_alloc = aper_alloc;
 }
 
-static void gart_fixup_northbridges(struct sys_device *dev)
+static void gart_fixup_northbridges(void)
 {
 	int i;
 
@@ -613,33 +613,20 @@ static void gart_fixup_northbridges(stru
 	}
 }
 
-static int gart_resume(struct sys_device *dev)
+static void gart_resume(void)
 {
 	pr_info("PCI-DMA: Resuming GART IOMMU\n");
 
-	gart_fixup_northbridges(dev);
+	gart_fixup_northbridges();
 
 	enable_gart_translations();
-
-	return 0;
 }
 
-static int gart_suspend(struct sys_device *dev, pm_message_t state)
-{
-	return 0;
-}
-
-static struct sysdev_class gart_sysdev_class = {
-	.name		= "gart",
-	.suspend	= gart_suspend,
+static struct syscore_ops gart_syscore_ops = {
 	.resume		= gart_resume,
 
 };
 
-static struct sys_device device_gart = {
-	.cls		= &gart_sysdev_class,
-};
-
 /*
  * Private Northbridge GATT initialization in case we cannot use the
  * AGP driver for some reason.
@@ -650,7 +637,7 @@ static __init int init_amd_gatt(struct a
 	unsigned aper_base, new_aper_base;
 	struct pci_dev *dev;
 	void *gatt;
-	int i, error;
+	int i;
 
 	pr_info("PCI-DMA: Disabling AGP.\n");
 
@@ -685,12 +672,7 @@ static __init int init_amd_gatt(struct a
 
 	agp_gatt_table = gatt;
 
-	error = sysdev_class_register(&gart_sysdev_class);
-	if (!error)
-		error = sysdev_register(&device_gart);
-	if (error)
-		panic("Could not register gart_sysdev -- "
-		      "would corrupt data on next suspend");
+	register_syscore_ops(&gart_syscore_ops);
 
 	flush_gart();
 
Index: linux-2.6/arch/x86/oprofile/nmi_int.c
===================================================================
--- linux-2.6.orig/arch/x86/oprofile/nmi_int.c
+++ linux-2.6/arch/x86/oprofile/nmi_int.c
@@ -15,7 +15,7 @@
 #include <linux/notifier.h>
 #include <linux/smp.h>
 #include <linux/oprofile.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/slab.h>
 #include <linux/moduleparam.h>
 #include <linux/kdebug.h>
@@ -536,7 +536,7 @@ static void nmi_shutdown(void)
 
 #ifdef CONFIG_PM
 
-static int nmi_suspend(struct sys_device *dev, pm_message_t state)
+static int nmi_suspend(void)
 {
 	/* Only one CPU left, just stop that one */
 	if (nmi_enabled == 1)
@@ -544,49 +544,31 @@ static int nmi_suspend(struct sys_device
 	return 0;
 }
 
-static int nmi_resume(struct sys_device *dev)
+static void nmi_resume(void)
 {
 	if (nmi_enabled == 1)
 		nmi_cpu_start(NULL);
-	return 0;
 }
 
-static struct sysdev_class oprofile_sysclass = {
-	.name		= "oprofile",
+static struct syscore_ops oprofile_syscore_ops = {
 	.resume		= nmi_resume,
 	.suspend	= nmi_suspend,
 };
 
-static struct sys_device device_oprofile = {
-	.id	= 0,
-	.cls	= &oprofile_sysclass,
-};
-
-static int __init init_sysfs(void)
+static void __init init_suspend_resume(void)
 {
-	int error;
-
-	error = sysdev_class_register(&oprofile_sysclass);
-	if (error)
-		return error;
-
-	error = sysdev_register(&device_oprofile);
-	if (error)
-		sysdev_class_unregister(&oprofile_sysclass);
-
-	return error;
+	register_syscore_ops(&oprofile_syscore_ops);
 }
 
-static void exit_sysfs(void)
+static void exit_suspend_resume(void)
 {
-	sysdev_unregister(&device_oprofile);
-	sysdev_class_unregister(&oprofile_sysclass);
+	unregister_syscore_ops(&oprofile_syscore_ops);
 }
 
 #else
 
-static inline int  init_sysfs(void) { return 0; }
-static inline void exit_sysfs(void) { }
+static inline void init_suspend_resume(void) { }
+static inline void exit_suspend_resume(void) { }
 
 #endif /* CONFIG_PM */
 
@@ -789,9 +771,7 @@ int __init op_nmi_init(struct oprofile_o
 
 	mux_init(ops);
 
-	ret = init_sysfs();
-	if (ret)
-		return ret;
+	init_suspend_resume();
 
 	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
 	return 0;
@@ -799,5 +779,5 @@ int __init op_nmi_init(struct oprofile_o
 
 void op_nmi_exit(void)
 {
-	exit_sysfs();
+	exit_suspend_resume();
 }
Index: linux-2.6/drivers/acpi/pci_link.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_link.c
+++ linux-2.6/drivers/acpi/pci_link.c
@@ -29,7 +29,7 @@
  *	   for IRQ management (e.g. start()->_SRS).
  */
 
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -757,14 +757,13 @@ static int acpi_pci_link_resume(struct a
 	return 0;
 }
 
-static int irqrouter_resume(struct sys_device *dev)
+static void irqrouter_resume(void)
 {
 	struct acpi_pci_link *link;
 
 	list_for_each_entry(link, &acpi_link_list, list) {
 		acpi_pci_link_resume(link);
 	}
-	return 0;
 }
 
 static int acpi_pci_link_remove(struct acpi_device *device, int type)
@@ -871,32 +870,19 @@ static int __init acpi_irq_balance_set(c
 
 __setup("acpi_irq_balance", acpi_irq_balance_set);
 
-/* FIXME: we will remove this interface after all drivers call pci_disable_device */
-static struct sysdev_class irqrouter_sysdev_class = {
-	.name = "irqrouter",
+static struct syscore_ops irqrouter_syscore_ops = {
 	.resume = irqrouter_resume,
 };
 
-static struct sys_device device_irqrouter = {
-	.id = 0,
-	.cls = &irqrouter_sysdev_class,
-};
-
-static int __init irqrouter_init_sysfs(void)
+static int __init irqrouter_init_ops(void)
 {
-	int error;
+	if (!acpi_disabled && !acpi_noirq)
+		register_syscore_ops(&irqrouter_syscore_ops);
 
-	if (acpi_disabled || acpi_noirq)
-		return 0;
-
-	error = sysdev_class_register(&irqrouter_sysdev_class);
-	if (!error)
-		error = sysdev_register(&device_irqrouter);
-
-	return error;
+	return 0;
 }
 
-device_initcall(irqrouter_init_sysfs);
+device_initcall(irqrouter_init_ops);
 
 static int __init acpi_pci_link_init(void)
 {
Index: linux-2.6/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.c
+++ linux-2.6/drivers/pci/intel-iommu.c
@@ -36,7 +36,7 @@
 #include <linux/iova.h>
 #include <linux/iommu.h>
 #include <linux/intel-iommu.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <asm/cacheflush.h>
@@ -3135,7 +3135,7 @@ static void iommu_flush_all(void)
 	}
 }
 
-static int iommu_suspend(struct sys_device *dev, pm_message_t state)
+static int iommu_suspend(void)
 {
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu = NULL;
@@ -3175,7 +3175,7 @@ nomem:
 	return -ENOMEM;
 }
 
-static int iommu_resume(struct sys_device *dev)
+static void iommu_resume(void)
 {
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu = NULL;
@@ -3183,7 +3183,7 @@ static int iommu_resume(struct sys_devic
 
 	if (init_iommu_hw()) {
 		WARN(1, "IOMMU setup failed, DMAR can not resume!\n");
-		return -EIO;
+		return;
 	}
 
 	for_each_active_iommu(iommu, drhd) {
@@ -3204,40 +3204,20 @@ static int iommu_resume(struct sys_devic
 
 	for_each_active_iommu(iommu, drhd)
 		kfree(iommu->iommu_state);
-
-	return 0;
 }
 
-static struct sysdev_class iommu_sysclass = {
-	.name		= "iommu",
+static struct syscore_ops iommu_syscore_ops = {
 	.resume		= iommu_resume,
 	.suspend	= iommu_suspend,
 };
 
-static struct sys_device device_iommu = {
-	.cls	= &iommu_sysclass,
-};
-
-static int __init init_iommu_sysfs(void)
+static void __init init_iommu_pm_ops(void)
 {
-	int error;
-
-	error = sysdev_class_register(&iommu_sysclass);
-	if (error)
-		return error;
-
-	error = sysdev_register(&device_iommu);
-	if (error)
-		sysdev_class_unregister(&iommu_sysclass);
-
-	return error;
+	register_syscore_ops(&iommu_syscore_ops);
 }
 
 #else
-static int __init init_iommu_sysfs(void)
-{
-	return 0;
-}
+static inline int init_iommu_pm_ops(void) { }
 #endif	/* CONFIG_PM */
 
 /*
@@ -3320,7 +3300,7 @@ int __init intel_iommu_init(void)
 #endif
 	dma_ops = &intel_dma_ops;
 
-	init_iommu_sysfs();
+	init_iommu_pm_ops();
 
 	register_iommu(&intel_iommu_ops);
 
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -14,7 +14,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/clocksource.h>
 #include <linux/jiffies.h>
 #include <linux/time.h>
@@ -561,13 +561,12 @@ static struct timespec timekeeping_suspe
 
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
- * @dev:	unused
  *
  * This is for the generic clocksource timekeeping.
  * xtime/wall_to_monotonic/jiffies/etc are
  * still managed by arch specific suspend/resume code.
  */
-static int timekeeping_resume(struct sys_device *dev)
+static void timekeeping_resume(void)
 {
 	unsigned long flags;
 	struct timespec ts;
@@ -596,11 +595,9 @@ static int timekeeping_resume(struct sys
 
 	/* Resume hrtimers */
 	hres_timers_resume();
-
-	return 0;
 }
 
-static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
+static int timekeeping_suspend(void)
 {
 	unsigned long flags;
 
@@ -618,26 +615,18 @@ static int timekeeping_suspend(struct sy
 }
 
 /* sysfs resume/suspend bits for timekeeping */
-static struct sysdev_class timekeeping_sysclass = {
-	.name		= "timekeeping",
+static struct syscore_ops timekeeping_syscore_ops = {
 	.resume		= timekeeping_resume,
 	.suspend	= timekeeping_suspend,
 };
 
-static struct sys_device device_timer = {
-	.id		= 0,
-	.cls		= &timekeeping_sysclass,
-};
-
-static int __init timekeeping_init_device(void)
+static int __init timekeeping_init_ops(void)
 {
-	int error = sysdev_class_register(&timekeeping_sysclass);
-	if (!error)
-		error = sysdev_register(&device_timer);
-	return error;
+	register_syscore_ops(&timekeeping_syscore_ops);
+	return 0;
 }
 
-device_initcall(timekeeping_init_device);
+device_initcall(timekeeping_init_ops);
 
 /*
  * If the error is already larger, we look ahead even further

