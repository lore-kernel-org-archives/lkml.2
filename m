Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab1CQN57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:57:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1CQN54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 09:57:56 -0400
Date: Thu, 17 Mar 2011 09:57:54 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, dzickus@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110317135754.25241.88177.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH]: SMBIOS: Add initial code and export version via sysfs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing DMI code, drivers/firmware/dmi.c, is not really parsing DMI.  It
is actually SMBIOS code that is using the old DMI infrastructure to expose
SMBIOS entries.

We should be doing the following:

1.  Looking for SMBIOS (either EFI or mapped to it's standard location,
    0xF0000)
2.  If found, look for the SMBIOS' Intermediate Structure (aka "DMI" entry)
3.  If not found, look for an "old" DMI structure.

DMI is a predecessor of SMBIOS, so we should start treating it as such.

For this patch I have introduced drivers/firmware/smbios.c, exported the
SMBIOS version through sysfs, and modified the DMI code such that

a) dmi_scan_machine() is now called from init_smbios(), and
b) if an SMBIOS is found, the values in the SMBIOS STEP structure are used
in dmi_scan_machine().

Right now, removing the DMI code is not an option.  It is used by common
initscripts, etc., to bringup the system.  Later modifications in this area will
include additional parsing of the SMBIOS structs and a simultaneous cleanup
of the DMI code.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index fcf3b43..ff2f1a3 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -94,6 +94,11 @@ config HAVE_SETUP_PER_CPU_AREA
 
 config DMI
 	bool
+	depends on SMBIOS
+	default y
+
+config SMBIOS
+	bool
 	default y
 
 config EFI
diff --git a/arch/ia64/include/asm/smbios.h b/arch/ia64/include/asm/smbios.h
new file mode 100644
index 0000000..cf04e8a
--- /dev/null
+++ b/arch/ia64/include/asm/smbios.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_SMBIOS_H
+#define _ASM_SMBIOS_H
+
+#include <linux/slab.h>
+#include <asm/io.h>
+
+/* Use normal IO mappings for SMBIOS */
+#define smbios_ioremap ioremap
+#define smbios_iounmap(x, l) iounmap(x)
+#define smbios_alloc(l) kmalloc(l, GFP_ATOMIC)
+
+#endif
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 911cf97..1bdb320 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -1061,9 +1061,9 @@ check_bugs (void)
 			       (unsigned long) __end___mckinley_e9_bundles);
 }
 
-static int __init run_dmi_scan(void)
+static int __init run_smbios_scan(void)
 {
-	dmi_scan_machine();
+	init_smbios();
 	return 0;
 }
-core_initcall(run_dmi_scan);
+core_initcall(run_smbios_scan);
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f8958b0..9d70dcd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -637,6 +637,7 @@ config APB_TIMER
 # The code disables itself when not needed.
 config DMI
 	default y
+	depends on SMBIOS
 	bool "Enable DMI scanning" if EXPERT
 	---help---
 	  Enabled scanning of DMI to identify machine quirks. Say Y
@@ -644,6 +645,17 @@ config DMI
 	  affected by entries in the DMI blacklist. Required by PNP
 	  BIOS code.
 
+# Mark as expert because too many people got it wrong.
+# The code disables itself when not needed.
+config SMBIOS
+	default y
+	bool "Enable SMBIOS scan" if EXPERT
+	---help---
+	  Enables scanning of SMBIOS to identify machine quirks.  Say Y
+	  here unless you have verified that your setup is not
+	  affected by entries in the DMI and SMBIOS blacklists.  Required by
+	  PNP BIOS code
+
 config GART_IOMMU
 	bool "GART IOMMU support" if EXPERT
 	default y
diff --git a/arch/x86/include/asm/smbios.h b/arch/x86/include/asm/smbios.h
new file mode 100644
index 0000000..c5819ce
--- /dev/null
+++ b/arch/x86/include/asm/smbios.h
@@ -0,0 +1,19 @@
+#ifndef _ASM_X86_SMBIOS_H
+#define _ASM_X86_SMBIOS_H
+
+#include <linux/compiler.h>
+#include <linux/init.h>
+
+#include <asm/io.h>
+#include <asm/setup.h>
+
+static __always_inline __init void *smbios_alloc(unsigned len)
+{
+	return extend_brk(len, sizeof(int));
+}
+
+/* Use early IO mappings for SMIBIOS because it's initialized early */
+#define smbios_ioremap early_ioremap
+#define smbios_iounmap early_iounmap
+
+#endif /* _ASM_X86_SMBIOS_H */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b176f2b..a84930f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -68,6 +68,7 @@
 #include <linux/percpu.h>
 #include <linux/crash_dump.h>
 #include <linux/tboot.h>
+#include <linux/smbios.h>
 
 #include <video/edid.h>
 
@@ -126,6 +127,9 @@ unsigned long max_pfn_mapped;
 #ifdef CONFIG_DMI
 RESERVE_BRK(dmi_alloc, 65536);
 #endif
+#ifdef CONFIG_SMBIOS
+RESERVE_BRK(smbios_alloc, 65536);
+#endif
 
 
 static __initdata unsigned long _brk_start = (unsigned long)__brk_base;
@@ -879,11 +883,11 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled)
 		efi_init();
 
-	dmi_scan_machine();
+	init_smbios();
 
 	/*
 	 * VMware detection requires dmi to be available, so this
-	 * needs to be done after dmi_scan_machine, for the BP.
+	 * needs to be done after init_smbios(), for the BP.
 	 */
 	init_hypervisor_platform();
 
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 1c3c173..fe3ade4 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_DMIID)		+= dmi-id.o
 obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
 obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
+obj-$(CONFIG_SMBIOS)		+= smbios.o
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index bcb1126..6080034 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -6,6 +6,7 @@
 #include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/bootmem.h>
+#include <linux/smbios.h>
 #include <asm/dmi.h>
 
 /*
@@ -429,49 +430,37 @@ void __init dmi_scan_machine(void)
 	char __iomem *p, *q;
 	int rc;
 
-	if (efi_enabled) {
-		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
-			goto error;
+	if (smbios_present) {
+		/* use values from SMBIOS STEP struct */
+		dmi_num = smbios_step->num_structs;
+		dmi_len = smbios_step->struct_len;
+		dmi_base = smbios_step->struct_addr;
 
-		/* This is called as a core_initcall() because it isn't
-		 * needed during early boot.  This also means we can
-		 * iounmap the space when we're done with it.
-		 */
-		p = dmi_ioremap(efi.smbios, 32);
-		if (p == NULL)
-			goto error;
-
-		rc = dmi_present(p + 0x10); /* offset of _DMI_ string */
-		dmi_iounmap(p, 32);
-		if (!rc) {
+		printk(KERN_INFO "DMI present.\n");
+		if (dmi_walk_early(dmi_decode) == 0) {
+			dmi_dump_ids();
 			dmi_available = 1;
-			goto out;
 		}
-	}
-	else {
-		/*
-		 * no iounmap() for that ioremap(); it would be a no-op, but
-		 * it's so early in setup that sucker gets confused into doing
-		 * what it shouldn't if we actually call it.
-		 */
+
+		dmi_initialized = 1;
+	} else {
+		/* Old school DMI table */
 		p = dmi_ioremap(0xF0000, 0x10000);
-		if (p == NULL)
-			goto error;
+		if (!p) {
+			printk(KERN_INFO "DMI not present.\n");
+			return;
+		}
 
 		for (q = p; q < p + 0x10000; q += 16) {
 			rc = dmi_present(q);
 			if (!rc) {
 				dmi_available = 1;
 				dmi_iounmap(p, 0x10000);
-				goto out;
+				return;
 			}
 		}
 		dmi_iounmap(p, 0x10000);
 	}
- error:
-	printk(KERN_INFO "DMI not present or invalid.\n");
- out:
-	dmi_initialized = 1;
 }
 
 /**
diff --git a/drivers/firmware/smbios.c b/drivers/firmware/smbios.c
new file mode 100644
index 0000000..19e59e1
--- /dev/null
+++ b/drivers/firmware/smbios.c
@@ -0,0 +1,175 @@
+#include <linux/dmi.h>
+#include <linux/efi.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/smbios.h>
+
+#include <asm/setup.h>
+
+int smbios_present = 0;
+struct smbios_step *smbios_step;
+static struct device *smbios_dev;
+/* The actual address of the SMBIOS */
+static unsigned long smbios_addr = 0;
+
+#ifdef CONFIG_SYSFS
+static ssize_t version_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u.%u\n", smbios_step->major,
+		       smbios_step->minor);
+}
+
+/* add additional sysfs files here */
+static struct device_attribute smbios_attrs[] = {
+	__ATTR_RO(version),
+};
+
+static struct class smbios_class = {
+	.name = "smbios",
+	.dev_release = (void(*)(struct device *)) kfree,
+};
+
+static struct device *smbios_dev;
+
+static int __init smbios_setup_sysfs(void)
+{
+	int attr, i, ret = 0;
+
+	ret = class_register(&smbios_class);
+	if (ret)
+		goto out;
+
+	smbios_dev = kzalloc(sizeof(*smbios_dev), GFP_KERNEL);
+	if (!smbios_dev) {
+		ret = -ENOMEM;
+		goto out_cleanup_class;
+	}
+
+	smbios_dev->class = &smbios_class;
+	dev_set_name(smbios_dev, "id");
+
+	ret = device_register(smbios_dev);
+	if (ret)
+		goto out_cleanup_smbios_dev;
+
+	for (attr = 0; attr < ARRAY_SIZE(smbios_attrs); attr++) {
+		ret = device_create_file(smbios_dev, &smbios_attrs[attr]);
+		if (ret)
+			goto out_cleanup_files;
+	}
+
+	return 0;
+
+out_cleanup_files:
+	for (i = 0; i < attr; i++)
+		device_remove_file(smbios_dev, &smbios_attrs[attr]);
+	device_unregister(smbios_dev);
+out_cleanup_smbios_dev:
+	kfree(smbios_dev);
+out_cleanup_class:
+	class_unregister(&smbios_class);
+out:
+	return ret;
+}
+#endif /* CONFIG_SYSFS */
+
+static int __init smbios_decode_step(void)
+{
+	u8 chksum1, chksum2, *buf, fp;
+
+	if (!smbios_addr)
+		return -ENODEV;
+
+	smbios_step = smbios_alloc(sizeof(*smbios_step));
+	if (!smbios_step)
+		return -ENOMEM;
+
+	buf = smbios_ioremap(smbios_addr, sizeof(*smbios_step));
+	if (!buf)
+		return -ENODEV;
+
+	memcpy(smbios_step, buf, sizeof(*smbios_step));
+
+	/* checksum the entire STEP structure */
+	for (fp = 0; fp < smbios_step->length; fp++)
+		chksum1 += buf[fp];
+	if (chksum1) {
+		smbios_iounmap(buf, sizeof(*smbios_step));
+		printk(KERN_INFO "SMBIOS: Invalid STEP table checksum = %u\n",
+		       chksum1);
+		return -EINVAL;
+	}
+
+	/* checksum the Intermediate structure */
+	for (fp = 0x10; fp < smbios_step->length; fp++)
+		chksum2 += buf[fp];
+	if (chksum2) {
+		smbios_iounmap(buf, sizeof(*smbios_step));
+		printk(KERN_INFO "SMBIOS: Invalid Intermediate checksum = %u\n",
+		       chksum2);
+		return -EINVAL;
+	}
+
+	smbios_iounmap(buf, sizeof(*smbios_step));
+
+	printk(KERN_INFO "SMBIOS: version %u.%u @ 0x%lX\n",
+	       smbios_step->major, smbios_step->minor, smbios_addr);
+
+	/* is there a _DMI_ table? */
+	if (!(memcmp(smbios_step->dmi_string, "_DMI_", 5)))
+		dmi_scan_machine();
+	else
+		printk(KERN_INFO "SMBIOS: No DMI Table.\n");
+
+	return 0;
+}
+
+/* Should only be called from x86 system setup code */
+void __init init_smbios(void)
+{
+	u8 *buf;
+	int fp = 0, rc;
+
+	if (smbios_present)
+		return;
+
+	if (efi_enabled) {
+		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
+			goto error;
+		smbios_addr = efi.smbios;
+	} else {
+		/* "Legacy" SMBIOS is mapped @ 0xF0000 */
+		smbios_addr = 0xF0000;
+	}
+	buf = smbios_ioremap(smbios_addr, 0x10000);
+	if (!buf)
+		goto error;
+
+	/* Find the entry point */
+	for (fp = 0; fp <= 0xFFF0; fp += 0x10)
+		if (!memcmp(buf + fp, "_SM_", 4)) {
+			smbios_addr += fp;
+			smbios_present = 1;
+			break;
+		}
+	smbios_iounmap(buf, 0x10000);
+
+	/* decode calls */
+	if (smbios_present) {
+		rc = smbios_decode_step();
+		if (rc)
+			return;
+	}
+error:
+	if (!smbios_present) {
+		printk(KERN_INFO "SMBIOS not present.");
+		/* call dmi_scan_table in case there is a "old" DMI table */
+		dmi_scan_machine();
+	}
+}
+
+#ifdef CONFIG_SYSFS
+arch_initcall(smbios_setup_sysfs);
+#endif
diff --git a/include/linux/smbios.h b/include/linux/smbios.h
new file mode 100644
index 0000000..774caaf
--- /dev/null
+++ b/include/linux/smbios.h
@@ -0,0 +1,51 @@
+#ifndef _SMBIOS_H
+#define _SMBIOS_H
+
+#include <linux/kernel.h>
+#include <asm/smbios.h>
+/*
+ * "The SMBIOS Specification addresses how motherboard and system vendors
+ * present management information about their products in a standard format by
+ * extending the BIOS interface on x86 architecture systems. The information is
+ * intended to allow generic instrumentation to deliver this information to
+ * management applications that use DMI, CIM or direct access, eliminating the
+ * need for error prone operations like probing system hardware for presence
+ * detection."
+ *
+ * From http://www.dmtf.org/standards/smbios
+ */
+
+/*
+ * SMBIOS Structure Table Entry Point, STEP
+ */
+
+#ifdef CONFIG_SMBIOS
+
+struct smbios_step {
+	char	anchor_string[4];	/* 0x0, always is "_SM_" */
+	u8	checksum;
+	u8	length;
+	u8	major;
+	u8	minor;
+	u16	max_size;
+	u8	eps_revision;
+	u8	reserved[5];
+	u8	dmi_string[5];	/* 0x10, should be "_DMI_" if available */
+	u8	intermediate_chksum;
+	u16	struct_len;
+	u32	struct_addr;
+	u16	num_structs;
+	u8	bcd_revision;
+} __packed;
+
+extern struct smbios_step *smbios_step;
+extern int smbios_present;
+
+extern void init_smbios(void);
+
+#else /* ifdef CONFIG_SMBIOS */
+
+void init_smbios(void) { return; }
+
+#endif
+#endif /* _SMBIOS_H */
