Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab1CUXki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:40:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51864 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897Ab1CUXi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:38:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/6] x86: Use syscore_ops instead of sysdev classes and sysdevs
Date: Tue, 22 Mar 2011 00:34:43 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        cpufreq@vger.kernel.org
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl> <201103220031.22729.rjw@sisk.pl>
In-Reply-To: <201103220031.22729.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103220034.44226.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Some subsystems in the x86 tree need to carry out suspend/resume and
shutdown operations with one CPU on-line and interrupts disabled and
they define sysdev classes and sysdevs or sysdev drivers for this
purpose.  This leads to unnecessarily complicated code and excessive
memory usage, so switch them to using struct syscore_ops objects for
this purpose instead.

Generally, there are three categories of subsystems that use
sysdevs for implementing PM operations: (1) subsystems whose
suspend/resume callbacks ignore their arguments entirely (the
majority), (2) subsystems whose suspend/resume callbacks use their
struct sys_device argument, but don't really need to do that,
because they can be implemented differently in an arguably simpler
way (io_apic.c), and (3) subsystems whose suspend/resume callbacks
use their struct sys_device argument, but the value of that argument
is always the same and could be ignored (microcode_core.c).  In all
of these cases the subsystems in question may be readily converted to
using struct syscore_ops objects for power management and shutdown.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/amd_iommu_init.c |   26 ++--------
 arch/x86/kernel/apic/apic.c      |   33 +++----------
 arch/x86/kernel/apic/io_apic.c   |   97 ++++++++++++++++++---------------------
 arch/x86/kernel/cpu/mcheck/mce.c |   21 ++++----
 arch/x86/kernel/cpu/mtrr/main.c  |   10 ++--
 arch/x86/kernel/i8237.c          |   30 ++----------
 arch/x86/kernel/i8259.c          |   33 ++++---------
 arch/x86/kernel/microcode_core.c |   34 +++++--------
 arch/x86/kernel/pci-gart_64.c    |   32 ++----------
 arch/x86/oprofile/nmi_int.c      |   44 ++++-------------
 10 files changed, 128 insertions(+), 232 deletions(-)

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
@@ -2046,7 +2046,7 @@ static struct {
 	unsigned int apic_thmr;
 } apic_pm_state;
 
-static int lapic_suspend(struct sys_device *dev, pm_message_t state)
+static int lapic_suspend(void)
 {
 	unsigned long flags;
 	int maxlvt;
@@ -2084,23 +2084,21 @@ static int lapic_suspend(struct sys_devi
 	return 0;
 }
 
-static int lapic_resume(struct sys_device *dev)
+static void lapic_resume(void)
 {
 	unsigned int l, h;
 	unsigned long flags;
-	int maxlvt;
-	int ret = 0;
+	int maxlvt, ret;
 	struct IO_APIC_route_entry **ioapic_entries = NULL;
 
 	if (!apic_pm_state.active)
-		return 0;
+		return;
 
 	local_irq_save(flags);
 	if (intr_remapping_enabled) {
 		ioapic_entries = alloc_ioapic_entries();
 		if (!ioapic_entries) {
 			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
-			ret = -ENOMEM;
 			goto restore;
 		}
 
@@ -2162,8 +2160,6 @@ static int lapic_resume(struct sys_devic
 	}
 restore:
 	local_irq_restore(flags);
-
-	return ret;
 }
 
 /*
@@ -2171,17 +2167,11 @@ restore:
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
@@ -2189,16 +2179,11 @@ static void __cpuinit apic_pm_activate(v
 
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
@@ -2918,89 +2918,84 @@ static int __init io_apic_bug_finalize(v
 
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
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
@@ -21,6 +21,7 @@
 #include <linux/percpu.h>
 #include <linux/string.h>
 #include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/delay.h>
 #include <linux/ctype.h>
 #include <linux/sched.h>
@@ -1749,14 +1750,14 @@ static int mce_disable_error_reporting(v
 	return 0;
 }
 
-static int mce_suspend(struct sys_device *dev, pm_message_t state)
+static int mce_suspend(void)
 {
 	return mce_disable_error_reporting();
 }
 
-static int mce_shutdown(struct sys_device *dev)
+static void mce_shutdown(void)
 {
-	return mce_disable_error_reporting();
+	mce_disable_error_reporting();
 }
 
 /*
@@ -1764,14 +1765,18 @@ static int mce_shutdown(struct sys_devic
  * Only one CPU is active at this time, the others get re-added later using
  * CPU hotplug:
  */
-static int mce_resume(struct sys_device *dev)
+static void mce_resume(void)
 {
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_vendor(__this_cpu_ptr(&cpu_info));
-
-	return 0;
 }
 
+static struct syscore_ops mce_syscore_ops = {
+	.suspend	= mce_suspend,
+	.shutdown	= mce_shutdown,
+	.resume		= mce_resume,
+};
+
 static void mce_cpu_restart(void *data)
 {
 	del_timer_sync(&__get_cpu_var(mce_timer));
@@ -1808,9 +1813,6 @@ static void mce_enable_ce(void *all)
 }
 
 static struct sysdev_class mce_sysclass = {
-	.suspend	= mce_suspend,
-	.shutdown	= mce_shutdown,
-	.resume		= mce_resume,
 	.name		= "machinecheck",
 };
 
@@ -2139,6 +2141,7 @@ static __init int mcheck_init_device(voi
 			return err;
 	}
 
+	register_syscore_ops(&mce_syscore_ops);
 	register_hotcpu_notifier(&mce_cpu_notifier);
 	misc_register(&mce_log_device);
 
Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -45,6 +45,7 @@
 #include <linux/cpu.h>
 #include <linux/pci.h>
 #include <linux/smp.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/processor.h>
 #include <asm/e820.h>
@@ -630,7 +631,7 @@ struct mtrr_value {
 
 static struct mtrr_value mtrr_value[MTRR_MAX_VAR_RANGES];
 
-static int mtrr_save(struct sys_device *sysdev, pm_message_t state)
+static int mtrr_save(void)
 {
 	int i;
 
@@ -642,7 +643,7 @@ static int mtrr_save(struct sys_device *
 	return 0;
 }
 
-static int mtrr_restore(struct sys_device *sysdev)
+static void mtrr_restore(void)
 {
 	int i;
 
@@ -653,12 +654,11 @@ static int mtrr_restore(struct sys_devic
 				    mtrr_value[i].ltype);
 		}
 	}
-	return 0;
 }
 
 
 
-static struct sysdev_driver mtrr_sysdev_driver = {
+static struct syscore_ops mtrr_syscore_ops = {
 	.suspend	= mtrr_save,
 	.resume		= mtrr_restore,
 };
@@ -839,7 +839,7 @@ static int __init mtrr_init_finialize(vo
 	 * TBD: is there any system with such CPU which supports
 	 * suspend/resume? If no, we should remove the code.
 	 */
-	sysdev_driver_register(&cpu_sysdev_class, &mtrr_sysdev_driver);
+	register_syscore_ops(&mtrr_syscore_ops);
 
 	return 0;
 }
Index: linux-2.6/arch/x86/kernel/microcode_core.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/microcode_core.c
+++ linux-2.6/arch/x86/kernel/microcode_core.c
@@ -82,6 +82,7 @@
 #include <linux/cpu.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/microcode.h>
 #include <asm/processor.h>
@@ -438,33 +439,25 @@ static int mc_sysdev_remove(struct sys_d
 	return 0;
 }
 
-static int mc_sysdev_resume(struct sys_device *dev)
+static struct sysdev_driver mc_sysdev_driver = {
+	.add			= mc_sysdev_add,
+	.remove			= mc_sysdev_remove,
+};
+
+/**
+ * mc_bp_resume - Update boot CPU microcode during resume.
+ */
+static void mc_bp_resume(void)
 {
-	int cpu = dev->id;
+	int cpu = smp_processor_id();
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
-	if (!cpu_online(cpu))
-		return 0;
-
-	/*
-	 * All non-bootup cpus are still disabled,
-	 * so only CPU 0 will apply ucode here.
-	 *
-	 * Moreover, there can be no concurrent
-	 * updates from any other places at this point.
-	 */
-	WARN_ON(cpu != 0);
-
 	if (uci->valid && uci->mc)
 		microcode_ops->apply_microcode(cpu);
-
-	return 0;
 }
 
-static struct sysdev_driver mc_sysdev_driver = {
-	.add			= mc_sysdev_add,
-	.remove			= mc_sysdev_remove,
-	.resume			= mc_sysdev_resume,
+static struct syscore_ops mc_syscore_ops = {
+	.resume			= mc_bp_resume,
 };
 
 static __cpuinit int
@@ -542,6 +535,7 @@ static int __init microcode_init(void)
 	if (error)
 		return error;
 
+	register_syscore_ops(&mc_syscore_ops);
 	register_hotcpu_notifier(&mc_cpu_notifier);
 
 	pr_info("Microcode Update Driver: v" MICROCODE_VERSION

