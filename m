Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab2FVOcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:32:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35838 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762339Ab2FVOb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:31:29 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC 2/4] remoteproc: Add custom STE-modem firmware loader.
Date: Fri, 22 Jun 2012 16:31:08 +0200
Message-Id: <1340375470-13097-3-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Add custom firmware loader for STE firmware. This plugin adds
functions for extracting the resource table and loading the
firmware image into shared memory.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/Kconfig                       |   10 ++
 drivers/remoteproc/Makefile                      |    2 +
 drivers/remoteproc/remoteproc_internal.h         |    1 +
 drivers/remoteproc/remoteproc_ste_modem_loader.c |  179 ++++++++++++++++++++++
 4 files changed, 192 insertions(+), 0 deletions(-)
 create mode 100644 drivers/remoteproc/remoteproc_ste_modem_loader.c

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index 24d880e..9beb5ed 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -25,4 +25,14 @@ config OMAP_REMOTEPROC
 	  It's safe to say n here if you're not interested in multimedia
 	  offloading or just want a bare minimum kernel.
 
+config STE_MODEM_RPROC
+	tristate "STE-Modem remoteproc support"
+	select REMOTEPROC
+	depends on EXPERIMENTAL
+	default n
+	help
+	  Say y or m here to support STE-Modem shared memory driver.
+	  This can be either built-in or a loadable module.
+	  If unsure say N.
+
 endmenu
diff --git a/drivers/remoteproc/Makefile b/drivers/remoteproc/Makefile
index 934ce6e..b91ecb0b 100644
--- a/drivers/remoteproc/Makefile
+++ b/drivers/remoteproc/Makefile
@@ -8,3 +8,5 @@ remoteproc-y				+= remoteproc_debugfs.o
 remoteproc-y				+= remoteproc_virtio.o
 remoteproc-y				+= remoteproc_elf_loader.o
 obj-$(CONFIG_OMAP_REMOTEPROC)		+= omap_remoteproc.o
+obj-$(CONFIG_STE_MODEM_RPROC)	 	+= ste_modem_remoteproc.o
+ste_modem_remoteproc-y 			+= remoteproc_ste_modem_loader.o
diff --git a/drivers/remoteproc/remoteproc_internal.h b/drivers/remoteproc/remoteproc_internal.h
index 7823156..bc36302 100644
--- a/drivers/remoteproc/remoteproc_internal.h
+++ b/drivers/remoteproc/remoteproc_internal.h
@@ -80,5 +80,6 @@ struct resource_table *rproc_find_rsc_table(struct rproc *rproc,
 }
 
 extern const struct rproc_fw_ops rproc_elf_fw_ops;
+extern const struct rproc_fw_ops rproc_ste_modem_fw_ops;
 
 #endif /* REMOTEPROC_INTERNAL_H */
diff --git a/drivers/remoteproc/remoteproc_ste_modem_loader.c b/drivers/remoteproc/remoteproc_ste_modem_loader.c
new file mode 100644
index 0000000..139222d
--- /dev/null
+++ b/drivers/remoteproc/remoteproc_ste_modem_loader.c
@@ -0,0 +1,179 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2012
+ * Author: Sjur Brendeland / sjur.brandeland@stericsson.com
+ * License terms: GNU General Public License (GPL) version 2.
+ */
+
+#define pr_fmt(fmt)	"%s: " fmt, __func__
+#include <linux/module.h>
+#include <linux/firmware.h>
+#include <linux/remoteproc.h>
+#include "remoteproc_internal.h"
+
+#define TOC_RSC_TAB_NAME "rsc-table"
+
+/* struct toc_entry - Table of content entry
+ *
+ * @start: Offset to the image data.
+ * @size:  Size of the images in bytes.
+ * @flags: Use 0 if no flags are in use.
+ * @entry_point: Modem internal information. Where to jump to start executing.
+ *		 Only applicable when using SDRAM. Set to 0xffffffff if unused.
+ * @load_addr: Modem internal information. Location in SDRAM to move image.
+ *		Set to 0xffffffff if not applicable.
+ * @name: Name of image.
+ */
+struct toc_entry {
+	__le32 start;
+	__le32 size;
+	__le32 flags;
+	__le32 entry_point;
+	__le32 load_addr;
+	char name[12];
+};
+
+/** struct toc - Table of content
+ * @table: Table of toc entries.
+ * The Table Of Content is located at the start of the firmware image and
+ * at offset zero in the shared memory region. The resource table typically
+ * contains the initial boot image (boot strap) and other information elements
+ * such as remoteproc resource table. Each entry is identified by a unique
+ * @name.
+ */
+struct toc {
+	struct toc_entry table[32];
+};
+
+/**
+ * ste_load_segments() - load firmware segments to memory
+ * @rproc: remote processor which will be booted using these fw segments
+ * @fw: the TOC and firmware image to load
+ *
+ * This function loads the firmware segments to memory. STE Modem SHM
+ * does not use an IOMMU, and expects the firmware containing the
+ * "Table Of Content" (TOC) first in the firmware. The TOC specifies the
+ * offset and size of the boot image.
+ */
+static int
+ste_load_segments(struct rproc *rproc, const struct firmware *fw)
+{
+	/*
+	 * STE-Modem does not use a IOMMU and the virtual and physical
+	 * addresses of the device (modem) is not known. Instead
+	 * offsets from the start of the shared memory region is used
+	 * as device address (da).
+	 *
+	 * The STE-Modem must provide a carveout as the first entry with
+	 * sufficient space for the firmware image. The device address in
+	 * this carveout must be set to zero.
+	 *
+	 * The firmware must be copied into offset zero, i.e at the start of
+	 * the shared memory area.
+	 */
+
+	u32 offset = 0;
+	void *ptr = rproc_da_to_va(rproc, offset, fw->size);
+
+	if (!ptr) {
+		dev_err(rproc->dev, "bad offset 0x%x mem 0x%zx\n",
+			offset, fw->size);
+		return -EINVAL;
+	}
+
+	memcpy(ptr, fw->data, fw->size);
+	return 0;
+}
+
+/* Find the entry for resource table in the Table of Content */
+static struct toc_entry *__find_rsc_entry(const struct firmware *fw)
+{
+	int i;
+	struct toc *toc;
+	int entries = ARRAY_SIZE(toc->table);
+
+	if (!fw)
+		return NULL;
+
+	toc = (void *)fw->data;
+
+	/* Search the table for the resource table */
+	for (i = 0; i < entries && toc->table[i].start != 0xffffffff; i++) {
+		if (!strncmp(toc->table[i].name, TOC_RSC_TAB_NAME,
+			     sizeof(toc->table[i].name))) {
+			if (toc->table[i].start > fw->size)
+				return NULL;
+			return &toc->table[i];
+		}
+	}
+	return NULL;
+}
+
+/**
+ * ste_find_rsc_table() - find the resource table
+ * @rproc: the rproc handle
+ * @fw: the firmware image
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
+static struct resource_table *
+ste_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
+							int *tablesz)
+{
+	struct resource_table *table;
+	struct device *dev = rproc->dev;
+	struct toc_entry *entry = __find_rsc_entry(fw);
+
+	if (!entry) {
+		dev_err(dev, "resource table not found in fw\n");
+		return NULL;
+	}
+
+	table = (void *) (fw->data + entry->start);
+
+	/* make sure we have the entire table */
+	if (entry->start + entry->size > fw->size) {
+		dev_err(dev, "resource table truncated\n");
+		return NULL;
+	}
+
+	/* make sure table has at least the header */
+	if (sizeof(struct resource_table) > entry->size) {
+		dev_err(dev, "header-less resource table\n");
+		return NULL;
+	}
+
+	/* we don't support any version beyond the first */
+	if (table->ver != 1) {
+		dev_err(dev, "unsupported fw ver: %d\n", table->ver);
+		return NULL;
+	}
+
+	/* make sure reserved bytes are zeroes */
+	if (table->reserved[0] || table->reserved[1]) {
+		dev_err(dev, "non zero reserved bytes\n");
+		return NULL;
+	}
+
+	/* make sure the offsets array isn't truncated */
+	if (table->num * sizeof(table->offset[0]) +
+	    sizeof(struct resource_table) > entry->size) {
+		dev_err(dev, "resource table incomplete\n");
+		return NULL;
+	}
+
+	*tablesz = entry->size;
+	return table;
+}
+
+const struct rproc_fw_ops rproc_ste_modem_fw_ops = {
+	.load = ste_load_segments,
+	.find_rsc_table = ste_find_rsc_table
+};
-- 
1.7.5.4

