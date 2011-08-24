Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab1HXAuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:50:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:62032 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088Ab1HXAtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:49:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="41195062"
Message-Id: <20110824001456.171766616@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Aug 2011 17:05:18 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org
Cc: yinghai@kernel.org, youquan.song@intel.com, joerg.roedel@amd.com,
        tony.luck@intel.com, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/8] x86, x2apic: enable the bios request for x2apic optout
References: <20110824000517.710353624@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=x2apic_optout_20110823.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the platforms which are x2apic and interrupt-remapping capable, Linux
kernel is enabling x2apic even if the BIOS doesn't. This is to take
advantage of the features that x2apic brings in.

Some of the OEM platforms are running into issues because of this, as their
bios is not x2apic aware. For example, this was resulting in interrupt migration
issues on one of the platforms. Also if the BIOS SMI handling uses APIC
interface to send SMI's, then the BIOS need to be aware of x2apic mode
that OS has enabled.

On some of these platforms, BIOS doesn't have a HW mechanism to turnoff
the x2apic feature to prevent OS from enabling it.

To resolve this mess, recent changes to the VT-d2 specification
(http://download.intel.com/technology/computing/vptech/Intel(r)_VT_for_Direct_IO.pdf)
includes a mechanism that provides BIOS a way to request system software
to opt out of enabling x2apic mode.

Look at the x2apic optout flag in the DMAR tables before enabling the x2apic
mode in the platform. Also print a warning that we have disabled x2apic
based on the BIOS request.

Kernel boot parameter "intremap=no_x2apic_optout" can be used to override
the BIOS x2apic optout request.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 Documentation/kernel-parameters.txt |    3 +-
 arch/x86/kernel/apic/apic.c         |   31 ++++++++++++-------------
 drivers/iommu/dmar.c                |    2 -
 drivers/iommu/intr_remapping.c      |   44 +++++++++++++++++++++++++++++-------
 include/linux/dmar.h                |   14 +++++++++--
 5 files changed, 66 insertions(+), 28 deletions(-)

Index: linux-2.6-tip/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6-tip.orig/Documentation/kernel-parameters.txt
+++ linux-2.6-tip/Documentation/kernel-parameters.txt
@@ -1027,10 +1027,11 @@ bytes respectively. Such letter suffixes
 			has the capability. With this option, super page will
 			not be supported.
 	intremap=	[X86-64, Intel-IOMMU]
-			Format: { on (default) | off | nosid }
 			on	enable Interrupt Remapping (default)
 			off	disable Interrupt Remapping
 			nosid	disable Source ID checking
+			no_x2apic_optout
+				BIOS x2APIC opt-out request will be ignored
 
 	inttest=	[IA-64]
 
Index: linux-2.6-tip/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/apic.c
@@ -1440,24 +1440,18 @@ int __init enable_IR(void)
 #ifdef CONFIG_INTR_REMAP
 	if (!intr_remapping_supported()) {
 		pr_debug("intr-remapping not supported\n");
-		return 0;
+		return -1;
 	}
 
 	if (!x2apic_preenabled && skip_ioapic_setup) {
 		pr_info("Skipped enabling intr-remap because of skipping "
 			"io-apic setup\n");
-		return 0;
+		return -1;
 	}
 
-	if (enable_intr_remapping(x2apic_supported()))
-		return 0;
-
-	pr_info("Enabled Interrupt-remapping\n");
-
-	return 1;
-
+	return enable_intr_remapping();
 #endif
-	return 0;
+	return -1;
 }
 
 void __init enable_IR_x2apic(void)
@@ -1481,11 +1475,11 @@ void __init enable_IR_x2apic(void)
 	mask_ioapic_entries();
 
 	if (dmar_table_init_ret)
-		ret = 0;
+		ret = -1;
 	else
 		ret = enable_IR();
 
-	if (!ret) {
+	if (ret < 0) {
 		/* IR is required if there is APIC ID > 255 even when running
 		 * under KVM
 		 */
@@ -1499,6 +1493,9 @@ void __init enable_IR_x2apic(void)
 		x2apic_force_phys();
 	}
 
+	if (ret == IRQ_REMAP_XAPIC_MODE)
+		goto nox2apic;
+
 	x2apic_enabled = 1;
 
 	if (x2apic_supported() && !x2apic_mode) {
@@ -1508,19 +1505,21 @@ void __init enable_IR_x2apic(void)
 	}
 
 nox2apic:
-	if (!ret) /* IR enabling failed */
+	if (ret < 0) /* IR enabling failed */
 		restore_ioapic_entries();
 	legacy_pic->restore_mask();
 	local_irq_restore(flags);
 
 out:
-	if (x2apic_enabled)
+	if (x2apic_enabled || !x2apic_supported())
 		return;
 
 	if (x2apic_preenabled)
 		panic("x2apic: enabled by BIOS but kernel init failed.");
-	else if (cpu_has_x2apic)
-		pr_info("Not enabling x2apic, Intr-remapping init failed.\n");
+	else if (ret == IRQ_REMAP_XAPIC_MODE)
+		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
+	else if (ret < 0)
+		pr_info("x2apic not enabled, IRQ remapping init failed\n");
 }
 
 #ifdef CONFIG_X86_64
Index: linux-2.6-tip/drivers/iommu/dmar.c
===================================================================
--- linux-2.6-tip.orig/drivers/iommu/dmar.c
+++ linux-2.6-tip/drivers/iommu/dmar.c
@@ -46,7 +46,7 @@
  */
 LIST_HEAD(dmar_drhd_units);
 
-static struct acpi_table_header * __initdata dmar_tbl;
+struct acpi_table_header * __initdata dmar_tbl;
 static acpi_size dmar_tbl_size;
 
 static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
Index: linux-2.6-tip/drivers/iommu/intr_remapping.c
===================================================================
--- linux-2.6-tip.orig/drivers/iommu/intr_remapping.c
+++ linux-2.6-tip/drivers/iommu/intr_remapping.c
@@ -21,6 +21,7 @@ int intr_remapping_enabled;
 
 static int disable_intremap;
 static int disable_sourceid_checking;
+static int no_x2apic_optout;
 
 static __init int setup_nointremap(char *str)
 {
@@ -34,12 +35,20 @@ static __init int setup_intremap(char *s
 	if (!str)
 		return -EINVAL;
 
-	if (!strncmp(str, "on", 2))
-		disable_intremap = 0;
-	else if (!strncmp(str, "off", 3))
-		disable_intremap = 1;
-	else if (!strncmp(str, "nosid", 5))
-		disable_sourceid_checking = 1;
+	while (*str) {
+		if (!strncmp(str, "on", 2))
+			disable_intremap = 0;
+		else if (!strncmp(str, "off", 3))
+			disable_intremap = 1;
+		else if (!strncmp(str, "nosid", 5))
+			disable_sourceid_checking = 1;
+		else if (!strncmp(str, "no_x2apic_optout", 16))
+			no_x2apic_optout = 1;
+
+		str += strcspn(str, ",");
+		while (*str == ',')
+			str++;
+	}
 
 	return 0;
 }
@@ -501,6 +510,15 @@ end:
 	spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
 
+static int __init dmar_x2apic_optout(void)
+{
+	struct acpi_table_dmar *dmar;
+	dmar = (struct acpi_table_dmar *)dmar_tbl;
+	if (!dmar || no_x2apic_optout)
+		return 0;
+	return dmar->flags & DMAR_X2APIC_OPT_OUT;
+}
+
 int __init intr_remapping_supported(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -521,16 +539,25 @@ int __init intr_remapping_supported(void
 	return 1;
 }
 
-int __init enable_intr_remapping(int eim)
+int __init enable_intr_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
 	int setup = 0;
+	int eim = 0;
 
 	if (parse_ioapics_under_ir() != 1) {
 		printk(KERN_INFO "Not enable interrupt remapping\n");
 		return -1;
 	}
 
+	if (x2apic_supported()) {
+		eim = !dmar_x2apic_optout();
+		WARN(!eim, KERN_WARNING
+			   "Your BIOS is broken and requested that x2apic be disabled\n"
+			   "This will leave your machine vulnerable to irq-injection attacks\n"
+			   "Use 'intremap=no_x2apic_optout' to override BIOS request\n");
+	}
+
 	for_each_drhd_unit(drhd) {
 		struct intel_iommu *iommu = drhd->iommu;
 
@@ -606,8 +633,9 @@ int __init enable_intr_remapping(int eim
 		goto error;
 
 	intr_remapping_enabled = 1;
+	pr_info("Enabled IRQ remapping in %s mode\n", eim ? "x2apic" : "xapic");
 
-	return 0;
+	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;
 
 error:
 	/*
Index: linux-2.6-tip/include/linux/dmar.h
===================================================================
--- linux-2.6-tip.orig/include/linux/dmar.h
+++ linux-2.6-tip/include/linux/dmar.h
@@ -26,8 +26,13 @@
 #include <linux/msi.h>
 #include <linux/irqreturn.h>
 
+/* DMAR Flags */
+#define DMAR_INTR_REMAP		0x1
+#define DMAR_X2APIC_OPT_OUT	0x2
+
 struct intel_iommu;
 #if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
+extern struct acpi_table_header *dmar_tbl;
 struct dmar_drhd_unit {
 	struct list_head list;		/* list of drhd units	*/
 	struct  acpi_dmar_header *hdr;	/* ACPI header		*/
@@ -110,7 +115,7 @@ struct irte {
 #ifdef CONFIG_INTR_REMAP
 extern int intr_remapping_enabled;
 extern int intr_remapping_supported(void);
-extern int enable_intr_remapping(int);
+extern int enable_intr_remapping(void);
 extern void disable_intr_remapping(void);
 extern int reenable_intr_remapping(int);
 
@@ -177,7 +182,7 @@ static inline int set_msi_sid(struct irt
 
 #define intr_remapping_enabled		(0)
 
-static inline int enable_intr_remapping(int eim)
+static inline int enable_intr_remapping(void)
 {
 	return -1;
 }
@@ -192,6 +197,11 @@ static inline int reenable_intr_remappin
 }
 #endif
 
+enum {
+	IRQ_REMAP_XAPIC_MODE,
+	IRQ_REMAP_X2APIC_MODE,
+};
+
 /* Can't use the common MSI interrupt functions
  * since DMAR is not a pci device
  */


