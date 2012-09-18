Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab2IRS32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:29:28 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46950 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948Ab2IRS3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:29:23 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv2] remoteproc: Add STE modem driver for remoteproc
Date: Tue, 18 Sep 2012 20:29:12 +0200
Message-Id: <1347992952-4134-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Add support for the STE modem shared memory driver.
This driver hooks into the remoteproc framework
in order to manage configuration and the virtio
devices.

This driver adds custom firmware handlers, because
STE modem uses a custom firmware layout.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---

Changes since v1:
o Implement a driver for struct ste_modem_device. This driver is using
  the platform-device bus. New include file is added in 
  include/linux/modem_shm/.

o Changed from a stand-alone API for "kick" and control to a device.
  Now we use a device and driver with ops structure. Hopefully this
  cleans up the interface.

o Removed the character device for user-space control of remoteproc.
  I will have to come back to this later.

 drivers/remoteproc/Kconfig           |   12 +
 drivers/remoteproc/Makefile          |    1 +
 drivers/remoteproc/ste_modem_rproc.c |  408 ++++++++++++++++++++++++++++++++++
 include/linux/modem_shm/ste_modem.h  |   71 ++++++
 4 files changed, 492 insertions(+)
 create mode 100644 drivers/remoteproc/ste_modem_rproc.c
 create mode 100644 include/linux/modem_shm/ste_modem.h

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index e7d440c..14b70fd 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -28,4 +28,16 @@ config OMAP_REMOTEPROC
 	  It's safe to say n here if you're not interested in multimedia
 	  offloading or just want a bare minimum kernel.
 
+config STE_MODEM_RPROC
+	tristate "STE-Modem remoteproc support"
+	select REMOTEPROC
+	select VIRTIO_CONSOLE
+	depends on EXPERIMENTAL
+	depends on HAS_DMA
+	default n
+	help
+	  Say y or m here to support STE-Modem shared memory driver.
+	  This can be either built-in or a loadable module.
+	  If unsure say N.
+
 endmenu
diff --git a/drivers/remoteproc/Makefile b/drivers/remoteproc/Makefile
index 934ce6e..391b651 100644
--- a/drivers/remoteproc/Makefile
+++ b/drivers/remoteproc/Makefile
@@ -8,3 +8,4 @@ remoteproc-y				+= remoteproc_debugfs.o
 remoteproc-y				+= remoteproc_virtio.o
 remoteproc-y				+= remoteproc_elf_loader.o
 obj-$(CONFIG_OMAP_REMOTEPROC)		+= omap_remoteproc.o
+obj-$(CONFIG_STE_MODEM_RPROC)	 	+= ste_modem_rproc.o
diff --git a/drivers/remoteproc/ste_modem_rproc.c b/drivers/remoteproc/ste_modem_rproc.c
new file mode 100644
index 0000000..9290bf3
--- /dev/null
+++ b/drivers/remoteproc/ste_modem_rproc.c
@@ -0,0 +1,408 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2012
+ * Author: Sjur Brændeland <sjur.brandeland@stericsson.com>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+#include <linux/module.h>
+#include <linux/remoteproc.h>
+#include <linux/dma-mapping.h>
+#include <linux/remoteproc.h>
+#include <linux/modem_shm/ste_modem.h>
+
+#include "remoteproc_internal.h"
+
+#define SPROC_MAX_NOTIFY_ID 14
+#define SPROC_RESOURCE_NAME "rsc-table"
+#define SPROC_MODEM_NAME "ste-modem"
+#define SPROC_MODEM_FIRMWARE SPROC_MODEM_NAME "-fw.bin"
+
+#define sproc_dbg(sproc, fmt, ...) \
+	dev_dbg(&sproc->mdev->pdev.dev, fmt, ##__VA_ARGS__)
+#define sproc_err(sproc, fmt, ...) \
+	dev_err(&sproc->mdev->pdev.dev, fmt, ##__VA_ARGS__)
+
+/* STE-modem control structure */
+struct sproc {
+	struct rproc *rproc;
+	struct ste_modem_device *mdev;
+	int error;
+	void *fw_addr;
+	size_t fw_size;
+	dma_addr_t fw_dma_addr;
+};
+
+/* STE-Modem firmware entry */
+struct ste_toc_entry {
+	__le32 start;
+	__le32 size;
+	__le32 flags;
+	__le32 entry_point;
+	__le32 load_addr;
+	char name[12];
+};
+
+/*
+ * The Table Of Content is located at the start of the firmware image and
+ * at offset zero in the shared memory region. The resource table typically
+ * contains the initial boot image (boot strap) and other information elements
+ * such as remoteproc resource table. Each entry is identified by a unique
+ * name.
+ */
+struct ste_toc {
+	struct ste_toc_entry table[32];
+};
+
+/*
+ * Loads the firmware to shared memory.
+ * The memory area to load fw into must be pre-allocated before
+ * this function is called (because remoteproc has already allocated
+ * device memory when this function is called)
+ */
+static int sproc_load_segments(struct rproc *rproc, const struct firmware *fw)
+{
+	struct sproc *sproc = rproc->priv;
+
+	/* Convert to pages before checking if we have enough space for fw*/
+	if (sproc->fw_addr == NULL ||
+	    PFN_DOWN(sproc->fw_size) < PFN_DOWN(fw->size)) {
+		sproc_err(sproc, "Not sufficient space for firmware\n");
+		return -EINVAL;
+	}
+
+	memcpy(sproc->fw_addr, fw->data, fw->size);
+	return 0;
+}
+
+/* Find the entry for resource table in the Table of Content */
+static struct ste_toc_entry *sproc_find_rsc_entry(const struct firmware *fw)
+{
+	int i;
+	struct ste_toc *toc;
+	int entries = ARRAY_SIZE(toc->table);
+
+	if (!fw)
+		return NULL;
+
+	toc = (void *)fw->data;
+
+	/* Search the table for the resource table */
+	for (i = 0; i < entries && toc->table[i].start != 0xffffffff; i++) {
+		if (!strncmp(toc->table[i].name, SPROC_RESOURCE_NAME,
+			     sizeof(toc->table[i].name))) {
+			if (toc->table[i].start > fw->size)
+				return NULL;
+			return &toc->table[i];
+		}
+	}
+	return NULL;
+}
+
+/*
+ * Find the resource table inside the remote processor's firmware.
+ * This function will allocate area used for firmware image in the memory
+ * region shared with the modem.
+ */
+static struct resource_table *
+sproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
+		     int *tablesz)
+{
+	struct resource_table *table;
+	struct ste_toc_entry *entry = sproc_find_rsc_entry(fw);
+	struct sproc *sproc = rproc->priv;
+
+	if (!entry) {
+		sproc_err(sproc, "resource table not found in fw\n");
+		return NULL;
+	}
+
+	table = (void *)(fw->data + entry->start);
+
+	/* make sure we have the entire table */
+	if (entry->start + entry->size > fw->size) {
+		sproc_err(sproc, "resource table truncated\n");
+		return NULL;
+	}
+
+	/* make sure table has at least the header */
+	if (sizeof(struct resource_table) > entry->size) {
+		sproc_err(sproc, "header-less resource table\n");
+		return NULL;
+	}
+
+	/* we don't support any version beyond the first */
+	if (table->ver != 1) {
+		sproc_err(sproc, "unsupported fw ver: %d\n", table->ver);
+		return NULL;
+	}
+
+	/* make sure reserved bytes are zeroes */
+	if (table->reserved[0] || table->reserved[1]) {
+		sproc_err(sproc, "non zero reserved bytes\n");
+		return NULL;
+	}
+
+	/* make sure the offsets array isn't truncated */
+	if (table->num * sizeof(table->offset[0]) +
+	    sizeof(struct resource_table) > entry->size) {
+		sproc_err(sproc, "resource table incomplete\n");
+		return NULL;
+	}
+
+	/* If the fw size has grown, release the previous fw allocation */
+	if (sproc->fw_addr && PFN_DOWN(sproc->fw_size) < PFN_DOWN(fw->size)) {
+		dma_free_coherent(&rproc->dev, sproc->fw_size,
+				  sproc->fw_addr,
+				  sproc->fw_dma_addr);
+		sproc->fw_addr = NULL;
+		sproc->fw_size = 0;
+		sproc->fw_dma_addr = 0;
+	}
+
+	/*
+	 * STE-modem requires the firmware to be located
+	 * at the start of the shared memory region. So we need to
+	 * reserve space for firmware at the start.
+	 * This cannot be done in the function sproc_load_segments because
+	 * then dma_alloc_coherent is already called by Core and the
+	 * start of the share memory area would already have been occupied.
+	 */
+	if (!sproc->fw_addr) {
+		sproc->fw_addr = dma_alloc_coherent(rproc->dev.parent, fw->size,
+						    &sproc->fw_dma_addr,
+						    GFP_KERNEL);
+		if (!sproc->fw_addr) {
+			sproc_err(sproc,
+				  "cannot allocate space (%zd) for fw image\n",
+				  fw->size);
+			return NULL;
+		}
+
+		if (sproc->mdev->shm_pa != (unsigned long)sproc->fw_addr) {
+			sproc_err(sproc,
+				  "bad fw address (%lx), should have been %p\n",
+				  sproc->mdev->shm_pa,
+				  sproc->fw_addr);
+			dma_free_coherent(rproc->dev.parent, sproc->fw_size,
+					  sproc->fw_addr,
+					  sproc->fw_dma_addr);
+			sproc->fw_addr = NULL;
+			return NULL;
+		}
+	}
+
+	sproc->fw_size = fw->size;
+	*tablesz = entry->size;
+	return table;
+}
+
+/* STE modem firmware handler operations */
+const struct rproc_fw_ops sproc_fw_ops = {
+	.load = sproc_load_segments,
+	.find_rsc_table = sproc_find_rsc_table
+};
+
+/* Kick the modem with specified notification id */
+static void sproc_kick(struct rproc *rproc, int vqid)
+{
+	struct sproc *sproc = rproc->priv;
+
+	sproc_dbg(sproc, "kick vqid:%d\n", vqid);
+
+	/*
+	 * We need different notification IDs for RX and TX so add
+	 * an offset on TX notification IDs.
+	 */
+	sproc->mdev->ops.kick(sproc->mdev, vqid + SPROC_MAX_NOTIFY_ID);
+}
+
+/* Received a kick from a modem, kick the virtqueue */
+static void sproc_kick_callback(struct ste_modem_device *mdev, int vqid)
+{
+	struct sproc *sproc = mdev->drv_data;
+	if (rproc_vq_interrupt(sproc->rproc, vqid) == IRQ_NONE)
+		sproc_dbg(sproc,
+			  "no message was found in vqid %d\n", vqid);
+}
+
+/* Start the STE modem */
+static int sproc_start(struct rproc *rproc)
+{
+	struct sproc *sproc = rproc->priv;
+	int i, err;
+
+	sproc_dbg(sproc, "start ste-modem\n");
+
+	/* Sanity test the max_notifyid */
+	if (rproc->max_notifyid > SPROC_MAX_NOTIFY_ID) {
+		sproc_err(sproc, "Notification IDs too high:%d\n",
+			  rproc->max_notifyid);
+		return -EINVAL;
+	}
+
+	/* Subscribe to notifications */
+	for (i = 0; i < rproc->max_notifyid; i++) {
+		err = sproc->mdev->ops.kick_subscribe(sproc->mdev, i);
+		if (err) {
+			sproc_err(sproc,
+				  "subscription of kicks failed:%d\n", err);
+			return err;
+		}
+	}
+
+	/* Request modem start-up*/
+	return sproc->mdev->ops.power(sproc->mdev, true);
+}
+
+/* Stop the STE modem */
+static int sproc_stop(struct rproc *rproc)
+{
+	struct sproc *sproc = rproc->priv;
+	sproc_dbg(sproc, "stop ste-modem\n");
+
+	return sproc->mdev->ops.power(sproc->mdev, false);
+}
+
+static struct rproc_ops sproc_ops = {
+	.start		= sproc_start,
+	.stop		= sproc_stop,
+	.kick		= sproc_kick,
+};
+
+/* STE modem device is unregistered */
+static int sproc_drv_remove(struct platform_device *pdev)
+{
+	struct ste_modem_device *mdev =
+		container_of(pdev, struct ste_modem_device, pdev);
+	struct sproc *sproc = mdev->drv_data;
+
+	sproc_dbg(sproc, "remove ste-modem\n");
+
+	/* Unregister as remoteproc device */
+	rproc_del(sproc->rproc);
+
+	/* Release DMA memory */
+	dma_release_declared_memory(&pdev->dev);
+
+	mdev->drv_data = NULL;
+	return 0;
+}
+
+/* Handle probe of a modem device */
+static int sproc_probe(struct platform_device *pdev)
+{
+	struct ste_modem_device *mdev =
+		container_of(pdev, struct ste_modem_device, pdev);
+	dma_addr_t device_addr = 0;
+	struct sproc *sproc;
+	struct rproc *rproc;
+	int err;
+
+	dev_dbg(&mdev->pdev.dev, "probe ste-modem\n");
+	rproc = rproc_alloc(&mdev->pdev.dev,
+			    mdev->pdev.name,
+			    &sproc_ops,
+			    SPROC_MODEM_FIRMWARE,
+			    sizeof(*sproc));
+	if (!rproc)
+		return -ENOMEM;
+
+	sproc = rproc->priv;
+	sproc->mdev = mdev;
+	sproc->rproc = rproc;
+	mdev->drv_data = sproc;
+	/*
+	 * Get the memory region shared with the modem
+	 * and declare it as dma memory.
+	 */
+	sproc_dbg(sproc, "Shared memory region pa:0x%lx  sz:0x%zx\n",
+		  (unsigned long) mdev->shm_pa,
+		  (unsigned long) mdev->shm_size);
+
+	err = dma_declare_coherent_memory(&mdev->pdev.dev,
+					  (dma_addr_t) mdev->shm_pa,
+					  device_addr,
+					  mdev->shm_size,
+					 DMA_MEMORY_MAP |
+					 DMA_MEMORY_EXCLUSIVE |
+					 DMA_MEMORY_INCLUDES_CHILDREN);
+	if (!err) {
+		sproc_err(sproc,
+			  "Cannot declare modem-shm memory region\n");
+		err = -ENOMEM;
+		goto free_rproc;
+	}
+
+	/* Set the STE-modem specific firmware handler */
+	rproc->fw_ops = &sproc_fw_ops;
+
+	/* Register as a remoteproc device */
+	err = rproc_add(rproc);
+	if (err)
+		goto free_dmamem;
+
+	return 0;
+
+free_dmamem:
+	dma_release_declared_memory(&mdev->pdev.dev);
+free_rproc:
+	mdev->drv_data = NULL;
+	rproc_put(rproc);
+	return err;
+}
+
+/**
+ * register_ste_shm_modem() - Register a modem into the remoteproc framework.
+ * @mdev: Modem device to register with the remoteproc framework.
+ */
+int register_ste_shm_modem(struct ste_modem_device *mdev)
+{
+	dev_dbg(&mdev->pdev.dev, "register ste-modem\n");
+
+	if (!mdev->ops.power || !mdev->ops.kick || !mdev->ops.kick_subscribe)
+		return -EINVAL;
+
+	return platform_device_register(&mdev->pdev);
+}
+EXPORT_SYMBOL(register_ste_shm_modem);
+
+/**
+ * unregister_ste_shm_modem() - Unregister from the remoteproc framework.
+ * @mdev: Device to unregister from the remoteproc framework.
+ */
+int unregister_ste_shm_modem(struct ste_modem_device *mdev)
+{
+	dev_dbg(&mdev->pdev.dev, "unregister ste-modem\n");
+
+	platform_device_unregister(&mdev->pdev);
+	return 0;
+}
+EXPORT_SYMBOL(unregister_ste_shm_modem);
+
+static struct ste_modem_driver sproc_driver = {
+	.drv = {
+		.driver = {
+			.name = SPROC_MODEM_NAME,
+			.owner   = THIS_MODULE,
+		},
+		.probe		= sproc_probe,
+		.remove		= sproc_drv_remove,
+	},
+	.ops = {
+		.kick = sproc_kick_callback
+	}
+};
+
+static int __init sproc_init(void)
+{
+	return platform_driver_register(&sproc_driver.drv);
+}
+module_init(sproc_init);
+
+static void __exit sproc_exit(void)
+{
+	platform_driver_unregister(&sproc_driver.drv);
+}
+module_exit(sproc_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("STE Modem driver using the Remote Processor Framework");
diff --git a/include/linux/modem_shm/ste_modem.h b/include/linux/modem_shm/ste_modem.h
new file mode 100644
index 0000000..d4632d1
--- /dev/null
+++ b/include/linux/modem_shm/ste_modem.h
@@ -0,0 +1,71 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2012
+ * Author: Sjur Brendeland / sjur.brandeland@stericsson.com
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef __INC_MODEM_DEV_H
+#define __INC_MODEM_DEV_H
+#include <linux/types.h>
+#include <linux/platform_device.h>
+
+struct ste_modem_device;
+
+/**
+ * struct ste_modem_dev_ops - Functions to control modem and modem interface.
+ *
+ * @power:	Main power switch, used for cold-start or complete power off.
+ * @kick:	Kick the modem.
+ * @kick_subscribe: Subscribe for notifications from the modem.
+ *
+ * This structure contains functions used by the ste remoteproc driver
+ * to manage the modem.
+ */
+struct ste_modem_dev_ops {
+	int (*power)(struct ste_modem_device *mdev, bool on);
+	int (*kick)(struct ste_modem_device *mdev, int notify_id);
+	int (*kick_subscribe)(struct ste_modem_device *mdev, int notify_id);
+};
+
+/**
+ * struct ste_modem_drv_ops - Callbacks for modem initiated events.
+ * @kick: Called when the modem kicks the host.
+ *
+ * This structure contains callbacks for actions triggered by the modem.
+ */
+struct ste_modem_drv_ops {
+	void (*kick)(struct ste_modem_device *mdev, int notify_id);
+};
+
+/**
+ * struct ste_modem_device - represent the STE modem device
+ * @pdev: Reference to platform device
+ * @ops: Operations used to manage the modem.
+ * @shm_pa: Physical address of the shared memory region.
+ * @shm_size: Size of the shared memory area.
+ * @drv_data: Driver private data.
+ *
+ */
+struct ste_modem_device {
+	struct platform_device pdev;
+	struct ste_modem_dev_ops ops;
+	unsigned long shm_pa;
+	size_t shm_size;
+	void *drv_data;
+};
+
+/**
+ * struct ste_modem_driver - Modem driver structure.
+ * @drv: Reference to driver
+ * @ops: Notification and status callbacks functions from modem.
+*/
+struct ste_modem_driver {
+	struct platform_driver drv;
+	struct ste_modem_drv_ops ops;
+};
+
+int register_ste_shm_modem(struct ste_modem_device *mdev);
+int unregister_ste_shm_modem(struct ste_modem_device *mdev);
+
+#endif /*INC_MODEM_DEV_H*/
-- 
1.7.9.5

