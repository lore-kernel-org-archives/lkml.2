Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab2JANxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:53:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35978 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab2JANxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:53:42 -0400
Date: Mon, 1 Oct 2012 15:53:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/efi changes for v3.7
Message-ID: <20121001135336.GA24254@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-efi-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-efi-for-linus

   HEAD: 2223af389032425e3d1a70f9cb3a63feaa654ced efi: Fix the ACPI BGRT driver for images located in EFI boot services memory

EFI loader robustness enhancements plus smaller fixes.

out-of-topic modifications in x86-efi-for-linus:
------------------------------------------------
drivers/acpi/Kconfig               # 2223af3: efi: Fix the ACPI BGRT driver for
drivers/acpi/bgrt.c                # 2223af3: efi: Fix the ACPI BGRT driver for
drivers/video/efifb.c              # f462ed9: efifb: Skip DMI checks if the boo
include/linux/efi-bgrt.h           # 2223af3: efi: Fix the ACPI BGRT driver for
include/linux/screen_info.h        # f462ed9: efifb: Skip DMI checks if the boo

 Thanks,

	Ingo

------------------>
Josh Triplett (3):
      efi: Defer freeing boot services memory until after ACPI init
      efi: Add a function to look up existing IO memory mappings
      efi: Fix the ACPI BGRT driver for images located in EFI boot services memory

Matthew Garrett (4):
      X86: Improve GOP detection in the EFI boot stub
      efi: Build EFI stub with EFI-appropriate options
      efifb: Skip DMI checks if the bootloader knows what it's doing
      x86, EFI: Calculate the EFI framebuffer size instead of trusting the firmware

Seiji Aguchi (1):
      efi: initialize efi.runtime_version to make query_variable_info/update_capsule workable


 arch/x86/boot/compressed/Makefile |  3 ++
 arch/x86/boot/compressed/eboot.c  | 34 ++++++++++--------
 arch/x86/boot/compressed/eboot.h  |  4 +++
 arch/x86/platform/efi/Makefile    |  1 +
 arch/x86/platform/efi/efi-bgrt.c  | 76 +++++++++++++++++++++++++++++++++++++++
 arch/x86/platform/efi/efi.c       | 66 +++++++++++++++++++++++++++-------
 drivers/acpi/Kconfig              |  4 +--
 drivers/acpi/bgrt.c               | 76 +++++----------------------------------
 drivers/video/efifb.c             |  4 ++-
 include/linux/efi-bgrt.h          | 21 +++++++++++
 include/linux/efi.h               |  8 +++++
 include/linux/screen_info.h       |  2 ++
 init/main.c                       |  5 +++
 13 files changed, 207 insertions(+), 97 deletions(-)
 create mode 100644 arch/x86/platform/efi/efi-bgrt.c
 create mode 100644 include/linux/efi-bgrt.h

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index e398bb5..8a84501 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -28,6 +28,9 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
 	$(obj)/piggy.o
 
+$(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
+$(obj)/efi_stub_$(BITS).o: KBUILD_CLFAGS += -fshort-wchar -mno-red-zone
+
 ifeq ($(CONFIG_EFI_STUB), y)
 	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
 endif
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b3e0227..c760e07 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -276,8 +276,9 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 	nr_gops = size / sizeof(void *);
 	for (i = 0; i < nr_gops; i++) {
 		struct efi_graphics_output_mode_info *info;
-		efi_guid_t pciio_proto = EFI_PCI_IO_PROTOCOL_GUID;
-		void *pciio;
+		efi_guid_t conout_proto = EFI_CONSOLE_OUT_DEVICE_GUID;
+		bool conout_found = false;
+		void *dummy;
 		void *h = gop_handle[i];
 
 		status = efi_call_phys3(sys_table->boottime->handle_protocol,
@@ -285,19 +286,21 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 		if (status != EFI_SUCCESS)
 			continue;
 
-		efi_call_phys3(sys_table->boottime->handle_protocol,
-			       h, &pciio_proto, &pciio);
+		status = efi_call_phys3(sys_table->boottime->handle_protocol,
+					h, &conout_proto, &dummy);
+
+		if (status == EFI_SUCCESS)
+			conout_found = true;
 
 		status = efi_call_phys4(gop->query_mode, gop,
 					gop->mode->mode, &size, &info);
-		if (status == EFI_SUCCESS && (!first_gop || pciio)) {
+		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
 			/*
-			 * Apple provide GOPs that are not backed by
-			 * real hardware (they're used to handle
-			 * multiple displays). The workaround is to
-			 * search for a GOP implementing the PCIIO
-			 * protocol, and if one isn't found, to just
-			 * fallback to the first GOP.
+			 * Systems that use the UEFI Console Splitter may
+			 * provide multiple GOP devices, not all of which are
+			 * backed by real hardware. The workaround is to search
+			 * for a GOP implementing the ConOut protocol, and if
+			 * one isn't found, to just fall back to the first GOP.
 			 */
 			width = info->horizontal_resolution;
 			height = info->vertical_resolution;
@@ -308,10 +311,10 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 			pixels_per_scan_line = info->pixels_per_scan_line;
 
 			/*
-			 * Once we've found a GOP supporting PCIIO,
+			 * Once we've found a GOP supporting ConOut,
 			 * don't bother looking any further.
 			 */
-			if (pciio)
+			if (conout_found)
 				break;
 
 			first_gop = gop;
@@ -328,7 +331,6 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 	si->lfb_width = width;
 	si->lfb_height = height;
 	si->lfb_base = fb_base;
-	si->lfb_size = fb_size;
 	si->pages = 1;
 
 	if (pixel_format == PIXEL_RGB_RESERVED_8BIT_PER_COLOR) {
@@ -376,6 +378,10 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 		si->rsvd_pos = 0;
 	}
 
+	si->lfb_size = si->lfb_linelength * si->lfb_height;
+
+	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
+
 free_handle:
 	efi_call_phys1(sys_table->boottime->free_pool, gop_handle);
 	return status;
diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index 3b6e156..e5b0a8f 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -14,6 +14,10 @@
 #define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
 #define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
+#define EFI_CONSOLE_OUT_DEVICE_GUID    \
+	EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4, 0x9a, 0x46, 0x0, 0x90, 0x27, \
+		  0x3f, 0xc1, 0x4d)
+
 #define PIXEL_RGB_RESERVED_8BIT_PER_COLOR		0
 #define PIXEL_BGR_RESERVED_8BIT_PER_COLOR		1
 #define PIXEL_BIT_MASK					2
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
index 92660eda..aded2a9 100644
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
@@ -419,10 +420,21 @@ void __init efi_reserve_boot_services(void)
 	}
 }
 
-static void __init efi_free_boot_services(void)
+static void __init efi_unmap_memmap(void)
+{
+	if (memmap.map) {
+		early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
+		memmap.map = NULL;
+	}
+}
+
+void __init efi_free_boot_services(void)
 {
 	void *p;
 
+	if (!efi_native)
+		return;
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		efi_memory_desc_t *md = p;
 		unsigned long long start = md->phys_addr;
@@ -438,6 +450,8 @@ static void __init efi_free_boot_services(void)
 
 		free_bootmem_late(start, size);
 	}
+
+	efi_unmap_memmap();
 }
 
 static int __init efi_systab_init(void *phys)
@@ -732,6 +746,11 @@ void __init efi_init(void)
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
@@ -764,6 +783,34 @@ static void __init runtime_code_page_mkexec(void)
 }
 
 /*
+ * We can't ioremap data in EFI boot services RAM, because we've already mapped
+ * it as RAM.  So, look it up in the existing EFI memory map instead.  Only
+ * callable after efi_enter_virtual_mode and before efi_free_boot_services.
+ */
+void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
+{
+	void *p;
+	if (WARN_ON(!memmap.map))
+		return NULL;
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		efi_memory_desc_t *md = p;
+		u64 size = md->num_pages << EFI_PAGE_SHIFT;
+		u64 end = md->phys_addr + size;
+		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+		    md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+		if (!md->virt_addr)
+			continue;
+		if (phys_addr >= md->phys_addr && phys_addr < end) {
+			phys_addr += md->virt_addr - md->phys_addr;
+			return (__force void __iomem *)(unsigned long)phys_addr;
+		}
+	}
+	return NULL;
+}
+
+/*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, look through the EFI memmap and map every region that
  * has the runtime attribute bit set in its memory descriptor and update
@@ -787,8 +834,10 @@ void __init efi_enter_virtual_mode(void)
 	 * non-native EFI
 	 */
 
-	if (!efi_native)
-		goto out;
+	if (!efi_native) {
+		efi_unmap_memmap();
+		return;
+	}
 
 	/* Merge contiguous regions of the same type and attribute */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
@@ -878,18 +927,12 @@ void __init efi_enter_virtual_mode(void)
 	}
 
 	/*
-	 * Thankfully, it does seem that no runtime services other than
-	 * SetVirtualAddressMap() will touch boot services code, so we can
-	 * get rid of it all at this point
-	 */
-	efi_free_boot_services();
-
-	/*
 	 * Now that EFI is in virtual mode, update the function
 	 * pointers in the runtime service table to the new virtual addresses.
 	 *
 	 * Call EFI services through wrapper functions.
 	 */
+	efi.runtime_version = efi_systab.fw_revision;
 	efi.get_time = virt_efi_get_time;
 	efi.set_time = virt_efi_set_time;
 	efi.get_wakeup_time = virt_efi_get_wakeup_time;
@@ -906,9 +949,6 @@ void __init efi_enter_virtual_mode(void)
 	if (__supported_pte_mask & _PAGE_NX)
 		runtime_code_page_mkexec();
 
-out:
-	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
-	memmap.map = NULL;
 	kfree(new_memmap);
 }
 
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
diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index b4a632a..932abaa 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -553,7 +553,9 @@ static int __init efifb_init(void)
 	int ret;
 	char *option = NULL;
 
-	dmi_check_system(dmi_system_table);
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI ||
+	    !(screen_info.capabilities & VIDEO_CAPABILITY_SKIP_QUIRKS))
+		dmi_check_system(dmi_system_table);
 
 	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
 		return -ENODEV;
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
index ec45ccd..8670eb1 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -496,6 +496,14 @@ extern void efi_map_pal_code (void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
+#ifdef CONFIG_X86
+extern void efi_late_init(void);
+extern void efi_free_boot_services(void);
+#else
+static inline void efi_late_init(void) {}
+static inline void efi_free_boot_services(void) {}
+#endif
+extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
index 899fbb4..fb3c5a8 100644
--- a/include/linux/screen_info.h
+++ b/include/linux/screen_info.h
@@ -68,6 +68,8 @@ struct screen_info {
 
 #define VIDEO_FLAGS_NOCURSOR	(1 << 0) /* The video mode has no cursor set */
 
+#define VIDEO_CAPABILITY_SKIP_QUIRKS	(1 << 0)
+
 #ifdef __KERNEL__
 extern struct screen_info screen_info;
 
diff --git a/init/main.c b/init/main.c
index b286730..db34c0e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -631,6 +631,11 @@ asmlinkage void __init start_kernel(void)
 	acpi_early_init(); /* before LAPIC and SMP init */
 	sfi_init_late();
 
+	if (efi_enabled) {
+		efi_late_init();
+		efi_free_boot_services();
+	}
+
 	ftrace_init();
 
 	/* Do the rest non-__init'ed, we're now alive */
