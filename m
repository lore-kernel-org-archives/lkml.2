Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab2FRPWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:22:38 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34930 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab2FRPWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:22:07 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv3 3/4] remoteproc: Move Elf related functions to separate file
Date: Mon, 18 Jun 2012 17:21:54 +0200
Message-Id: <1340032915-10734-4-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340032915-10734-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1340032915-10734-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Prepare for introduction of custom firmware loaders by
moving all ELF related handling into a separate file.

The functions: rproc_find_rsc_table(), rproc_fw_sanity_check(),
rproc_find_rsc_table() and rproc_get_boot_addr() are moved
to the new file remoteproc_elf_loader.c. The function
rproc_da_to_va() is made non-static and is declared in
remoteproc_internal.h

No functional changes are introduced in this patch.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/Makefile                |    1 +
 drivers/remoteproc/remoteproc_core.c       |  245 +------------------------
 drivers/remoteproc/remoteproc_elf_loader.c |  282 ++++++++++++++++++++++++++++
 drivers/remoteproc/remoteproc_internal.h   |    1 +
 include/linux/remoteproc.h                 |    9 +
 5 files changed, 294 insertions(+), 244 deletions(-)
 create mode 100644 drivers/remoteproc/remoteproc_elf_loader.c

diff --git a/drivers/remoteproc/Makefile b/drivers/remoteproc/Makefile
index 5445d9b..934ce6e 100644
--- a/drivers/remoteproc/Makefile
+++ b/drivers/remoteproc/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_REMOTEPROC)		+= remoteproc.o
 remoteproc-y				:= remoteproc_core.o
 remoteproc-y				+= remoteproc_debugfs.o
 remoteproc-y				+= remoteproc_virtio.o
+remoteproc-y				+= remoteproc_elf_loader.o
 obj-$(CONFIG_OMAP_REMOTEPROC)		+= omap_remoteproc.o
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 648ff88..b642850 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -165,7 +165,7 @@ static void rproc_disable_iommu(struct rproc *rproc)
  * but only on kernel direct mapped RAM memory. Instead, we're just using
  * here the output of the DMA API, which should be more correct.
  */
-static void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
+void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
 {
 	struct rproc_mem_entry *carveout;
 	void *ptr = NULL;
@@ -189,96 +189,6 @@ static void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
 	return ptr;
 }
 
-/**
- * rproc_load_segments() - load firmware segments to memory
- * @rproc: remote processor which will be booted using these fw segments
- * @fw: the ELF firmware image
- *
- * This function loads the firmware segments to memory, where the remote
- * processor expects them.
- *
- * Some remote processors will expect their code and data to be placed
- * in specific device addresses, and can't have them dynamically assigned.
- *
- * We currently support only those kind of remote processors, and expect
- * the program header's paddr member to contain those addresses. We then go
- * through the physically contiguous "carveout" memory regions which we
- * allocated (and mapped) earlier on behalf of the remote processor,
- * and "translate" device address to kernel addresses, so we can copy the
- * segments where they are expected.
- *
- * Currently we only support remote processors that required carveout
- * allocations and got them mapped onto their iommus. Some processors
- * might be different: they might not have iommus, and would prefer to
- * directly allocate memory for every segment/resource. This is not yet
- * supported, though.
- */
-static int
-rproc_load_segments(struct rproc *rproc, const struct firmware *fw)
-{
-	struct device *dev = rproc->dev;
-	struct elf32_hdr *ehdr;
-	struct elf32_phdr *phdr;
-	int i, ret = 0;
-	const u8 *elf_data = fw->data;
-
-	ehdr = (struct elf32_hdr *)elf_data;
-	phdr = (struct elf32_phdr *)(elf_data + ehdr->e_phoff);
-
-	/* go through the available ELF segments */
-	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
-		u32 da = phdr->p_paddr;
-		u32 memsz = phdr->p_memsz;
-		u32 filesz = phdr->p_filesz;
-		u32 offset = phdr->p_offset;
-		void *ptr;
-
-		if (phdr->p_type != PT_LOAD)
-			continue;
-
-		dev_dbg(dev, "phdr: type %d da 0x%x memsz 0x%x filesz 0x%x\n",
-					phdr->p_type, da, memsz, filesz);
-
-		if (filesz > memsz) {
-			dev_err(dev, "bad phdr filesz 0x%x memsz 0x%x\n",
-							filesz, memsz);
-			ret = -EINVAL;
-			break;
-		}
-
-		if (offset + filesz > fw->size) {
-			dev_err(dev, "truncated fw: need 0x%x avail 0x%x\n",
-					offset + filesz, fw->size);
-			ret = -EINVAL;
-			break;
-		}
-
-		/* grab the kernel address for this device address */
-		ptr = rproc_da_to_va(rproc, da, memsz);
-		if (!ptr) {
-			dev_err(dev, "bad phdr da 0x%x mem 0x%x\n", da, memsz);
-			ret = -EINVAL;
-			break;
-		}
-
-		/* put the segment where the remote processor expects it */
-		if (phdr->p_filesz)
-			memcpy(ptr, elf_data + phdr->p_offset, filesz);
-
-		/*
-		 * Zero out remaining memory for this segment.
-		 *
-		 * This isn't strictly required since dma_alloc_coherent already
-		 * did this for us. albeit harmless, we may consider removing
-		 * this.
-		 */
-		if (memsz > filesz)
-			memset(ptr + filesz, 0, memsz - filesz);
-	}
-
-	return ret;
-}
-
 static int
 __rproc_handle_vring(struct rproc_vdev *rvdev, struct fw_rsc_vdev *rsc, int i)
 {
@@ -822,85 +732,6 @@ rproc_handle_virtio_rsc(struct rproc *rproc, struct resource_table *table, int l
 }
 
 /**
- * rproc_find_rsc_table() - find the resource table
- * @rproc: the rproc handle
- * @fw: the ELF firmware image
- * @tablesz: place holder for providing back the table size
- *
- * This function finds the resource table inside the remote processor's
- * firmware. It is used both upon the registration of @rproc (in order
- * to look for and register the supported virito devices), and when the
- * @rproc is booted.
- *
- * Returns the pointer to the resource table if it is found, and write its
- * size into @tablesz. If a valid table isn't found, NULL is returned
- * (and @tablesz isn't set).
- */
-static struct resource_table *
-rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
-							int *tablesz)
-{
-	struct elf32_hdr *ehdr;
-	struct elf32_shdr *shdr;
-	const char *name_table;
-	struct device *dev = rproc->dev;
-	struct resource_table *table = NULL;
-	int i;
-	const u8 *elf_data = fw->data;
-
-	ehdr = (struct elf32_hdr *)elf_data;
-	shdr = (struct elf32_shdr *)(elf_data + ehdr->e_shoff);
-	name_table = elf_data + shdr[ehdr->e_shstrndx].sh_offset;
-
-	/* look for the resource table and handle it */
-	for (i = 0; i < ehdr->e_shnum; i++, shdr++) {
-		int size = shdr->sh_size;
-		int offset = shdr->sh_offset;
-
-		if (strcmp(name_table + shdr->sh_name, ".resource_table"))
-			continue;
-
-		table = (struct resource_table *)(elf_data + offset);
-
-		/* make sure we have the entire table */
-		if (offset + size > fw->size) {
-			dev_err(dev, "resource table truncated\n");
-			return NULL;
-		}
-
-		/* make sure table has at least the header */
-		if (sizeof(struct resource_table) > size) {
-			dev_err(dev, "header-less resource table\n");
-			return NULL;
-		}
-
-		/* we don't support any version beyond the first */
-		if (table->ver != 1) {
-			dev_err(dev, "unsupported fw ver: %d\n", table->ver);
-			return NULL;
-		}
-
-		/* make sure reserved bytes are zeroes */
-		if (table->reserved[0] || table->reserved[1]) {
-			dev_err(dev, "non zero reserved bytes\n");
-			return NULL;
-		}
-
-		/* make sure the offsets array isn't truncated */
-		if (table->num * sizeof(table->offset[0]) +
-				sizeof(struct resource_table) > size) {
-			dev_err(dev, "resource table incomplete\n");
-			return NULL;
-		}
-
-		*tablesz = shdr->sh_size;
-		break;
-	}
-
-	return table;
-}
-
-/**
  * rproc_resource_cleanup() - clean up and free all acquired resources
  * @rproc: rproc handle
  *
@@ -943,80 +774,6 @@ static void rproc_resource_cleanup(struct rproc *rproc)
 	}
 }
 
-/* make sure this fw image is sane */
-static int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
-{
-	const char *name = rproc->firmware;
-	struct device *dev = rproc->dev;
-	struct elf32_hdr *ehdr;
-	char class;
-
-	if (!fw) {
-		dev_err(dev, "failed to load %s\n", name);
-		return -EINVAL;
-	}
-
-	if (fw->size < sizeof(struct elf32_hdr)) {
-		dev_err(dev, "Image is too small\n");
-		return -EINVAL;
-	}
-
-	ehdr = (struct elf32_hdr *)fw->data;
-
-	/* We only support ELF32 at this point */
-	class = ehdr->e_ident[EI_CLASS];
-	if (class != ELFCLASS32) {
-		dev_err(dev, "Unsupported class: %d\n", class);
-		return -EINVAL;
-	}
-
-	/* We assume the firmware has the same endianess as the host */
-# ifdef __LITTLE_ENDIAN
-	if (ehdr->e_ident[EI_DATA] != ELFDATA2LSB) {
-# else /* BIG ENDIAN */
-	if (ehdr->e_ident[EI_DATA] != ELFDATA2MSB) {
-# endif
-		dev_err(dev, "Unsupported firmware endianess\n");
-		return -EINVAL;
-	}
-
-	if (fw->size < ehdr->e_shoff + sizeof(struct elf32_shdr)) {
-		dev_err(dev, "Image is too small\n");
-		return -EINVAL;
-	}
-
-	if (memcmp(ehdr->e_ident, ELFMAG, SELFMAG)) {
-		dev_err(dev, "Image is corrupted (bad magic)\n");
-		return -EINVAL;
-	}
-
-	if (ehdr->e_phnum == 0) {
-		dev_err(dev, "No loadable segments\n");
-		return -EINVAL;
-	}
-
-	if (ehdr->e_phoff > fw->size) {
-		dev_err(dev, "Firmware size is too small\n");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/**
- * rproc_get_boot_addr() - Get rproc's boot address.
- * @fw: the ELF firmware image
- *
- * This function reads the ELF entry point address.
- * Note that the boot address is not a configurable property of all remote
- * processors. Some will always boot at a specific hard-coded address.
- */
-u32 rproc_get_boot_addr(struct rproc *rproc, const struct firmware *fw)
-{
-	struct elf32_hdr *ehdr  = (struct elf32_hdr *)fw->data;
-	return ehdr->e_entry;
-}
-
 /*
  * take a firmware and boot a remote processor with it.
  */
diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
new file mode 100644
index 0000000..06e35dc
--- /dev/null
+++ b/drivers/remoteproc/remoteproc_elf_loader.c
@@ -0,0 +1,282 @@
+/*
+ * Remote Processor Framework Elf loader
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ * Copyright (C) 2011 Google, Inc.
+ *
+ * Ohad Ben-Cohen <ohad@wizery.com>
+ * Brian Swetland <swetland@google.com>
+ * Mark Grosen <mgrosen@ti.com>
+ * Fernando Guzman Lugo <fernando.lugo@ti.com>
+ * Suman Anna <s-anna@ti.com>
+ * Robert Tivy <rtivy@ti.com>
+ * Armando Uribe De Leon <x0095078@ti.com>
+ * Sjur Brændeland <sjur.brandeland@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt)    "%s: " fmt, __func__
+
+#include <linux/module.h>
+#include <linux/firmware.h>
+#include <linux/remoteproc.h>
+#include <linux/elf.h>
+
+#include "remoteproc_internal.h"
+
+/**
+ * rproc_fw_sanity_check() - Sanity Check ELF firmware image
+ * @fw: the ELF firmware image
+ *
+ * Make sure this fw image is sane.
+ */
+int
+rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
+{
+	const char *name = rproc->firmware;
+	struct device *dev = rproc->dev;
+	struct elf32_hdr *ehdr;
+	char class;
+
+	if (!fw) {
+		dev_err(dev, "failed to load %s\n", name);
+		return -EINVAL;
+	}
+
+	if (fw->size < sizeof(struct elf32_hdr)) {
+		dev_err(dev, "Image is too small\n");
+		return -EINVAL;
+	}
+
+	ehdr = (struct elf32_hdr *)fw->data;
+
+	/* We only support ELF32 at this point */
+	class = ehdr->e_ident[EI_CLASS];
+	if (class != ELFCLASS32) {
+		dev_err(dev, "Unsupported class: %d\n", class);
+		return -EINVAL;
+	}
+
+	/* We assume the firmware has the same endianess as the host */
+# ifdef __LITTLE_ENDIAN
+	if (ehdr->e_ident[EI_DATA] != ELFDATA2LSB) {
+# else /* BIG ENDIAN */
+	if (ehdr->e_ident[EI_DATA] != ELFDATA2MSB) {
+# endif
+		dev_err(dev, "Unsupported firmware endianess\n");
+		return -EINVAL;
+	}
+
+	if (fw->size < ehdr->e_shoff + sizeof(struct elf32_shdr)) {
+		dev_err(dev, "Image is too small\n");
+		return -EINVAL;
+	}
+
+	if (memcmp(ehdr->e_ident, ELFMAG, SELFMAG)) {
+		dev_err(dev, "Image is corrupted (bad magic)\n");
+		return -EINVAL;
+	}
+
+	if (ehdr->e_phnum == 0) {
+		dev_err(dev, "No loadable segments\n");
+		return -EINVAL;
+	}
+
+	if (ehdr->e_phoff > fw->size) {
+		dev_err(dev, "Firmware size is too small\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * rproc_get_boot_addr() - Get rproc's boot address.
+ * @fw: the ELF firmware image
+ *
+ * This function reads the ELF entry point address.
+ * Note that the boot address is not a configurable property of all remote
+ * processors. Some will always boot at a specific hard-coded address.
+ */
+u32 rproc_get_boot_addr(struct rproc *rproc, const struct firmware *fw)
+{
+	struct elf32_hdr *ehdr  = (struct elf32_hdr *)fw->data;
+	return ehdr->e_entry;
+}
+
+/**
+ * rproc_load_segments() - load firmware segments to memory
+ * @rproc: remote processor which will be booted using these fw segments
+ * @fw: the  the ELF firmware image
+ *
+ * This function loads the firmware segments to memory, where the remote
+ * processor expects them.
+ *
+ * Some remote processors will expect their code and data to be placed
+ * in specific device addresses, and can't have them dynamically assigned.
+ *
+ * We currently support only those kind of remote processors, and expect
+ * the program header's paddr member to contain those addresses. We then go
+ * through the physically contiguous "carveout" memory regions which we
+ * allocated (and mapped) earlier on behalf of the remote processor,
+ * and "translate" device address to kernel addresses, so we can copy the
+ * segments where they are expected.
+ *
+ * Currently we only support remote processors that required carveout
+ * allocations and got them mapped onto their iommus. Some processors
+ * might be different: they might not have iommus, and would prefer to
+ * directly allocate memory for every segment/resource. This is not yet
+ * supported, though.
+ */
+int
+rproc_load_segments(struct rproc *rproc, const struct firmware *fw)
+{
+	struct device *dev = rproc->dev;
+	struct elf32_hdr *ehdr;
+	struct elf32_phdr *phdr;
+	int i, ret = 0;
+	const u8 *elf_data = fw->data;
+
+	ehdr = (struct elf32_hdr *)elf_data;
+	phdr = (struct elf32_phdr *)(elf_data + ehdr->e_phoff);
+
+	/* go through the available ELF segments */
+	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
+		u32 da = phdr->p_paddr;
+		u32 memsz = phdr->p_memsz;
+		u32 filesz = phdr->p_filesz;
+		u32 offset = phdr->p_offset;
+		void *ptr;
+
+		if (phdr->p_type != PT_LOAD)
+			continue;
+
+		dev_dbg(dev, "phdr: type %d da 0x%x memsz 0x%x filesz 0x%x\n",
+					phdr->p_type, da, memsz, filesz);
+
+		if (filesz > memsz) {
+			dev_err(dev, "bad phdr filesz 0x%x memsz 0x%x\n",
+							filesz, memsz);
+			ret = -EINVAL;
+			break;
+		}
+
+		if (offset + filesz > fw->size) {
+			dev_err(dev, "truncated fw: need 0x%x avail 0x%zx\n",
+					offset + filesz, fw->size);
+			ret = -EINVAL;
+			break;
+		}
+
+		/* grab the kernel address for this device address */
+		ptr = rproc_da_to_va(rproc, da, memsz);
+		if (!ptr) {
+			dev_err(dev, "bad phdr da 0x%x mem 0x%x\n", da, memsz);
+			ret = -EINVAL;
+			break;
+		}
+
+		/* put the segment where the remote processor expects it */
+		if (phdr->p_filesz)
+			memcpy(ptr, elf_data + phdr->p_offset, filesz);
+
+		/*
+		 * Zero out remaining memory for this segment.
+		 *
+		 * This isn't strictly required since dma_alloc_coherent already
+		 * did this for us. albeit harmless, we may consider removing
+		 * this.
+		 */
+		if (memsz > filesz)
+			memset(ptr + filesz, 0, memsz - filesz);
+	}
+
+	return ret;
+}
+
+/**
+ * rproc_find_rsc_table() - find the resource table
+ * @rproc: the rproc handle
+ * @fw: the ELF firmware image
+ * @tablesz: place holder for providing back the table size
+ *
+ * This function finds the resource table inside the remote processor's
+ * firmware. It is used both upon the registration of @rproc (in order
+ * to look for and register the supported virito devices), and when the
+ * @rproc is booted.
+ *
+ * Returns the pointer to the resource table if it is found, and write its
+ * size into @tablesz. If a valid table isn't found, NULL is returned
+ * (and @tablesz isn't set).
+ */
+struct resource_table *
+rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
+							int *tablesz)
+{
+	struct elf32_hdr *ehdr;
+	struct elf32_shdr *shdr;
+	const char *name_table;
+	struct device *dev = rproc->dev;
+	struct resource_table *table = NULL;
+	int i;
+	const u8 *elf_data = fw->data;
+
+	ehdr = (struct elf32_hdr *)elf_data;
+	shdr = (struct elf32_shdr *)(elf_data + ehdr->e_shoff);
+	name_table = elf_data + shdr[ehdr->e_shstrndx].sh_offset;
+
+	/* look for the resource table and handle it */
+	for (i = 0; i < ehdr->e_shnum; i++, shdr++) {
+		int size = shdr->sh_size;
+		int offset = shdr->sh_offset;
+
+		if (strcmp(name_table + shdr->sh_name, ".resource_table"))
+			continue;
+
+		table = (struct resource_table *)(elf_data + offset);
+
+		/* make sure we have the entire table */
+		if (offset + size > fw->size) {
+			dev_err(dev, "resource table truncated\n");
+			return NULL;
+		}
+
+		/* make sure table has at least the header */
+		if (sizeof(struct resource_table) > size) {
+			dev_err(dev, "header-less resource table\n");
+			return NULL;
+		}
+
+		/* we don't support any version beyond the first */
+		if (table->ver != 1) {
+			dev_err(dev, "unsupported fw ver: %d\n", table->ver);
+			return NULL;
+		}
+
+		/* make sure reserved bytes are zeroes */
+		if (table->reserved[0] || table->reserved[1]) {
+			dev_err(dev, "non zero reserved bytes\n");
+			return NULL;
+		}
+
+		/* make sure the offsets array isn't truncated */
+		if (table->num * sizeof(table->offset[0]) +
+				sizeof(struct resource_table) > size) {
+			dev_err(dev, "resource table incomplete\n");
+			return NULL;
+		}
+
+		*tablesz = shdr->sh_size;
+		break;
+	}
+
+	return table;
+}
diff --git a/drivers/remoteproc/remoteproc_internal.h b/drivers/remoteproc/remoteproc_internal.h
index 9f336d6..25e0b91 100644
--- a/drivers/remoteproc/remoteproc_internal.h
+++ b/drivers/remoteproc/remoteproc_internal.h
@@ -40,5 +40,6 @@ void rproc_delete_debug_dir(struct rproc *rproc);
 void rproc_create_debug_dir(struct rproc *rproc);
 void rproc_init_debugfs(void);
 void rproc_exit_debugfs(void);
+void *rproc_da_to_va(struct rproc *rproc, u64 da, int len);
 
 #endif /* REMOTEPROC_INTERNAL_H */
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index f1ffabb..d6853da 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -42,6 +42,7 @@
 #include <linux/virtio.h>
 #include <linux/completion.h>
 #include <linux/idr.h>
+#include <linux/firmware.h>
 
 /**
  * struct resource_table - firmware resource table header
@@ -326,6 +327,14 @@ struct rproc_mem_entry {
 
 struct rproc;
 
+struct resource_table *rproc_find_rsc_table(struct rproc *rproc,
+						const struct firmware *fw,
+						int *tablesz);
+int rproc_load_segments(struct rproc *rproc, const struct firmware *fw);
+int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw);
+u32 rproc_get_boot_addr(struct rproc *rproc, const struct firmware *fw);
+
+
 /**
  * struct rproc_ops - platform-specific device handlers
  * @start:	power on the device and boot it
-- 
1.7.5.4

