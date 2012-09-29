Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab2I2XQI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 19:16:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54123 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab2I2XQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 19:16:05 -0400
Date: Sat, 29 Sep 2012 16:15:50 -0700
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Message-ID: <tip-2223af389032425e3d1a70f9cb3a63feaa654ced@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        josh@joshtriplett.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, josh@joshtriplett.org, hpa@linux.intel.com
In-Reply-To: <93ce9f823f1c1f3bb88bdd662cce08eee7a17f5d.1348876882.git.josh@joshtriplett.org>
References: <93ce9f823f1c1f3bb88bdd662cce08eee7a17f5d.1348876882.git.josh@joshtriplett.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] efi:
  Fix the ACPI BGRT driver for images located in EFI boot services memory
Git-Commit-ID: 2223af389032425e3d1a70f9cb3a63feaa654ced
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 29 Sep 2012 16:15:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2223af389032425e3d1a70f9cb3a63feaa654ced
Gitweb:     http://git.kernel.org/tip/2223af389032425e3d1a70f9cb3a63feaa654ced
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Fri, 28 Sep 2012 17:57:05 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 29 Sep 2012 12:21:03 -0700

efi: Fix the ACPI BGRT driver for images located in EFI boot services memory

The ACPI BGRT driver accesses the BIOS logo image when it initializes.
However, ACPI 5.0 (which introduces the BGRT) recommends putting the
logo image in EFI boot services memory, so that the OS can reclaim that
memory.  Production systems follow this recommendation, breaking the
ACPI BGRT driver.

Move the bulk of the BGRT code to run during a new EFI late
initialization phase, which occurs after switching EFI to virtual mode,
and after initializing ACPI, but before freeing boot services memory.
Copy the BIOS logo image to kernel memory at that point, and make it
accessible to the BGRT driver.  Rework the existing ACPI BGRT driver to
act as a simple wrapper exposing that image (and the properties from the
BGRT) via sysfs.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Link: http://lkml.kernel.org/r/93ce9f823f1c1f3bb88bdd662cce08eee7a17f5d.1348876882.git.josh@joshtriplett.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/efi/Makefile   |    1 +
 arch/x86/platform/efi/efi-bgrt.c |   76 ++++++++++++++++++++++++++++++++++++++
 arch/x86/platform/efi/efi.c      |    6 +++
 drivers/acpi/Kconfig             |    4 +-
 drivers/acpi/bgrt.c              |   76 ++++---------------------------------
 include/linux/efi-bgrt.h         |   21 ++++++++++
 include/linux/efi.h              |    2 +
 init/main.c                      |    4 +-
 8 files changed, 120 insertions(+), 70 deletions(-)

diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
index 73b8be0..6db1cc4 100644
--- a/arch/x86/platform/efi/Makefile
+++ b/arch/x86/platform/efi/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
+obj-$(CONFIG_ACPI_BGRT) += efi-bgrt.o
diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
new file mode 100644
index 0000000..f6a0c1b
--- /dev/null
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -0,0 +1,76 @@
+/*
+ * Copyright 2012 Intel Corporation
+ * Author: Josh Triplett <josh@joshtriplett.org>
+ *
+ * Based on the bgrt driver:
+ * Copyright 2012 Red Hat, Inc <mjg@redhat.com>
+ * Author: Matthew Garrett
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/acpi.h>
+#include <linux/efi.h>
+#include <linux/efi-bgrt.h>
+
+struct acpi_table_bgrt *bgrt_tab;
+void *bgrt_image;
+size_t bgrt_image_size;
+
+struct bmp_header {
+	u16 id;
+	u32 size;
+} __packed;
+
+void efi_bgrt_init(void)
+{
+	acpi_status status;
+	void __iomem *image;
+	bool ioremapped = false;
+	struct bmp_header bmp_header;
+
+	if (acpi_disabled)
+		return;
+
+	status = acpi_get_table("BGRT", 0,
+	                        (struct acpi_table_header **)&bgrt_tab);
+	if (ACPI_FAILURE(status))
+		return;
+
+	if (bgrt_tab->version != 1)
+		return;
+	if (bgrt_tab->image_type != 0 || !bgrt_tab->image_address)
+		return;
+
+	image = efi_lookup_mapped_addr(bgrt_tab->image_address);
+	if (!image) {
+		image = ioremap(bgrt_tab->image_address, sizeof(bmp_header));
+		ioremapped = true;
+		if (!image)
+			return;
+	}
+
+	memcpy_fromio(&bmp_header, image, sizeof(bmp_header));
+	if (ioremapped)
+		iounmap(image);
+	bgrt_image_size = bmp_header.size;
+
+	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL);
+	if (!bgrt_image)
+		return;
+
+	if (ioremapped) {
+		image = ioremap(bgrt_tab->image_address, bmp_header.size);
+		if (!image) {
+			kfree(bgrt_image);
+			bgrt_image = NULL;
+			return;
+		}
+	}
+
+	memcpy_fromio(bgrt_image, image, bgrt_image_size);
+	if (ioremapped)
+		iounmap(image);
+}
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f7f928c..aded2a9 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -31,6 +31,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/efi.h>
+#include <linux/efi-bgrt.h>
 #include <linux/export.h>
 #include <linux/bootmem.h>
 #include <linux/memblock.h>
@@ -745,6 +746,11 @@ void __init efi_init(void)
 #endif
 }
 
+void __init efi_late_init(void)
+{
+	efi_bgrt_init();
+}
+
 void __init efi_set_executable(efi_memory_desc_t *md, bool executable)
 {
 	u64 addr, npages;
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 8099895..119d58d 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -385,8 +385,8 @@ config ACPI_CUSTOM_METHOD
 	  to override that restriction).
 
 config ACPI_BGRT
-        tristate "Boottime Graphics Resource Table support"
-        default n
+	bool "Boottime Graphics Resource Table support"
+	depends on EFI
         help
 	  This driver adds support for exposing the ACPI Boottime Graphics
 	  Resource Table, which allows the operating system to obtain
diff --git a/drivers/acpi/bgrt.c b/drivers/acpi/bgrt.c
index 6680df3..be60399 100644
--- a/drivers/acpi/bgrt.c
+++ b/drivers/acpi/bgrt.c
@@ -1,5 +1,6 @@
 /*
  * Copyright 2012 Red Hat, Inc <mjg@redhat.com>
+ * Copyright 2012 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -11,20 +12,10 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/sysfs.h>
-#include <linux/io.h>
-#include <acpi/acpi.h>
-#include <acpi/acpi_bus.h>
+#include <linux/efi-bgrt.h>
 
-static struct acpi_table_bgrt *bgrt_tab;
 static struct kobject *bgrt_kobj;
 
-struct bmp_header {
-	u16 id;
-	u32 size;
-} __attribute ((packed));
-
-static struct bmp_header bmp_header;
-
 static ssize_t show_version(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
@@ -63,18 +54,7 @@ static DEVICE_ATTR(yoffset, S_IRUGO, show_yoffset, NULL);
 static ssize_t show_image(struct file *file, struct kobject *kobj,
 	       struct bin_attribute *attr, char *buf, loff_t off, size_t count)
 {
-	int size = attr->size;
-	void __iomem *image = attr->private;
-
-	if (off >= size) {
-		count = 0;
-	} else {
-		if (off + count > size)
-			count = size - off;
-
-		memcpy_fromio(buf, image+off, count);
-	}
-
+	memcpy(buf, attr->private + off, count);
 	return count;
 }
 
@@ -101,45 +81,18 @@ static struct attribute_group bgrt_attribute_group = {
 
 static int __init bgrt_init(void)
 {
-	acpi_status status;
 	int ret;
-	void __iomem *bgrt;
 
-	if (acpi_disabled)
-		return -ENODEV;
-
-	status = acpi_get_table("BGRT", 0,
-				(struct acpi_table_header **)&bgrt_tab);
-
-	if (ACPI_FAILURE(status))
+	if (!bgrt_image)
 		return -ENODEV;
 
 	sysfs_bin_attr_init(&image_attr);
-
-	bgrt = ioremap(bgrt_tab->image_address, sizeof(struct bmp_header));
-
-	if (!bgrt) {
-		ret = -EINVAL;
-		goto out_err;
-	}
-
-	memcpy_fromio(&bmp_header, bgrt, sizeof(bmp_header));
-	image_attr.size = bmp_header.size;
-	iounmap(bgrt);
-
-	image_attr.private = ioremap(bgrt_tab->image_address, image_attr.size);
-
-	if (!image_attr.private) {
-		ret = -EINVAL;
-		goto out_err;
-	}
-
+	image_attr.private = bgrt_image;
+	image_attr.size = bgrt_image_size;
 
 	bgrt_kobj = kobject_create_and_add("bgrt", acpi_kobj);
-	if (!bgrt_kobj) {
-		ret = -EINVAL;
-		goto out_iounmap;
-	}
+	if (!bgrt_kobj)
+		return -EINVAL;
 
 	ret = sysfs_create_group(bgrt_kobj, &bgrt_attribute_group);
 	if (ret)
@@ -155,22 +108,11 @@ out_group:
 	sysfs_remove_group(bgrt_kobj, &bgrt_attribute_group);
 out_kobject:
 	kobject_put(bgrt_kobj);
-out_iounmap:
-	iounmap(image_attr.private);
-out_err:
 	return ret;
 }
 
-static void __exit bgrt_exit(void)
-{
-	iounmap(image_attr.private);
-	sysfs_remove_group(bgrt_kobj, &bgrt_attribute_group);
-	sysfs_remove_bin_file(bgrt_kobj, &image_attr);
-}
-
 module_init(bgrt_init);
-module_exit(bgrt_exit);
 
-MODULE_AUTHOR("Matthew Garrett");
+MODULE_AUTHOR("Matthew Garrett, Josh Triplett <josh@joshtriplett.org>");
 MODULE_DESCRIPTION("BGRT boot graphic support");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/efi-bgrt.h b/include/linux/efi-bgrt.h
new file mode 100644
index 0000000..051b21f
--- /dev/null
+++ b/include/linux/efi-bgrt.h
@@ -0,0 +1,21 @@
+#ifndef _LINUX_EFI_BGRT_H
+#define _LINUX_EFI_BGRT_H
+
+#ifdef CONFIG_ACPI_BGRT
+
+#include <linux/acpi.h>
+
+void efi_bgrt_init(void);
+
+/* The BGRT data itself; only valid if bgrt_image != NULL. */
+extern void *bgrt_image;
+extern size_t bgrt_image_size;
+extern struct acpi_table_bgrt *bgrt_tab;
+
+#else /* !CONFIG_ACPI_BGRT */
+
+static inline void efi_bgrt_init(void) {}
+
+#endif /* !CONFIG_ACPI_BGRT */
+
+#endif /* _LINUX_EFI_BGRT_H */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index fff135d..8670eb1 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -497,8 +497,10 @@ extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
 #ifdef CONFIG_X86
+extern void efi_late_init(void);
 extern void efi_free_boot_services(void);
 #else
+static inline void efi_late_init(void) {}
 static inline void efi_free_boot_services(void) {}
 #endif
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
diff --git a/init/main.c b/init/main.c
index d61ec54..db34c0e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -631,8 +631,10 @@ asmlinkage void __init start_kernel(void)
 	acpi_early_init(); /* before LAPIC and SMP init */
 	sfi_init_late();
 
-	if (efi_enabled)
+	if (efi_enabled) {
+		efi_late_init();
 		efi_free_boot_services();
+	}
 
 	ftrace_init();
 
