Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab2ICNuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 09:50:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54785 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab2ICNuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 09:50:18 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: [RFC 3/3] remoteproc: Add STE modem driver for remoteproc
Date: Mon,  3 Sep 2012 15:49:53 +0200
Message-Id: <1346680193-5443-3-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346680193-5443-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1346680193-5443-1-git-send-email-sjur.brandeland@stericsson.com>
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

When this platform device driver is probed, a
character device is added. This character device
is used to start and stop the modem.
When the character device is opened the driver
adds a rproc device instance. This causes firmware
to be requested and loaded into shared memory
and modem to be started. Closing the device
will stop the modem. Errors are reported to user-
space as POLLERR from the poll() function.

This driver adds custom firmware handlers, because
STE modem uses a custom firmware layout.

The memory region shared with the modem is declared
as a platform device resource.

This driver users modem_ctrl.h and modem_kick.h for
power control and interrupt handling.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
cc: Linus Walleij <linus.walleij@linaro.org>
cc: Arun Murthy <arun.murthy@stericsson.com>
---
 drivers/remoteproc/Kconfig           |   14 +
 drivers/remoteproc/Makefile          |    1 +
 drivers/remoteproc/ste_modem_rproc.c |  691 ++++++++++++++++++++++++++++++++++
 3 files changed, 706 insertions(+), 0 deletions(-)
 create mode 100644 drivers/remoteproc/ste_modem_rproc.c

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index f8d818a..05d036e 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -27,4 +27,18 @@ config OMAP_REMOTEPROC
 	  It's safe to say n here if you're not interested in multimedia
 	  offloading or just want a bare minimum kernel.
 
+config STE_MODEM_RPROC
+	tristate "STE-Modem remoteproc support"
+	select REMOTEPROC
+	select VIRTIO_CONSOLE
+	select VIRTIO_CAIF
+	depends on EXPERIMENTAL
+	depends on MODEM_KICK
+	depends on MODEM_CTRL
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
index 0000000..53cad9d
--- /dev/null
+++ b/drivers/remoteproc/ste_modem_rproc.c
@@ -0,0 +1,691 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2012
+ * Author: Sjur Brændeland <sjur.brandeland@stericsson.com>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s(): " fmt, __func__
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/device.h>
+#include <linux/sysfs.h>
+#include <linux/interrupt.h>
+#include <linux/remoteproc.h>
+#include <linux/dma-mapping.h>
+#include <linux/firmware.h>
+#include <linux/remoteproc.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include "remoteproc_internal.h"
+#include <linux/modem_kick.h>
+#include <linux/modem_ctrl.h>
+
+#define SPROC_MAX_NOTIFY_ID 14
+#define SPROC_RESOURCE_NAME "rsc-table"
+#define SPROC_NAME "ste-modem"
+#define SPROC_MODEM_FIRMWARE SPROC_NAME "-fw.bin"
+#define SPROC_MEM_AREA "modem_shm"
+
+/* struct sproc - ST-Ericsson modem control structure
+ *
+ * @rproc: Remoteproc handle.
+ * @error: Error reported by underlying "kick" driver.
+ * @fw_addr: Location of firmware in memory shared with modem.
+ * @chardev: Character device used to remoteproc for STE modem.
+ * @kick: Handle to the kick interface.
+ * @ctrl: Handle to the modem control interface.
+ * @wq: Wait queue used by poll to wait for errors reported.
+ */
+struct sproc {
+	struct rproc *rproc;
+	struct platform_device *pdev;
+	int error;
+	void *fw_addr;
+	size_t fw_size;
+	dma_addr_t fw_dma_addr;
+	struct device chardev;
+	struct modem_kick *kick;
+	struct modem_ctrl *ctrl;
+	wait_queue_head_t wq;
+};
+
+/* struct ste_toc_entry - Table of content entry
+ *
+ * @start: Offset to the image data.
+ * @size:  Size of the images in bytes.
+ * @flags: Use 0 if no flags are in use.
+ * @entry_point: Modem internal information.
+ * @load_addr: Modem internal information.
+ * @name: Name of image.
+ */
+struct ste_toc_entry {
+	__le32 start;
+	__le32 size;
+	__le32 flags;
+	__le32 entry_point;
+	__le32 load_addr;
+	char name[12];
+};
+
+/* struct ste_toc - Table of content
+ * @table: Table of toc entries.
+ *
+ * The Table Of Content is located at the start of the firmware image and
+ * at offset zero in the shared memory region. The resource table typically
+ * contains the initial boot image (boot strap) and other information elements
+ * such as remoteproc resource table. Each entry is identified by a unique
+ */
+struct ste_toc {
+	struct ste_toc_entry table[32];
+};
+
+/* Dynamically assigned major number of the control character device */
+static int sproc_chr_major;
+
+/*
+ * sproc_load_segments() - load firmware segments to memory
+ * @rproc: remote processor which will be booted using these fw segments
+ * @fw: the TOC and firmware image to load
+ *
+ * This function loads the firmware segments to memory. STE Modem SHM
+ * does not use an IOMMU, and expects the firmware containing the
+ * "Table Of Content" (TOC) first in the firmware. The TOC specifies the
+ * offset and size of the boot image.
+ */
+static int
+sproc_load_segments(struct rproc *rproc, const struct firmware *fw)
+{
+	struct sproc *sproc = rproc->priv;
+
+	if (!sproc->fw_addr) {
+		dev_err(&rproc->dev, "Firmware address not specified\n");
+		return -EINVAL;
+	}
+	if (PFN_DOWN(sproc->fw_size) < PFN_DOWN(PAGE_SHIFT)) {
+		dev_err(&rproc->dev, "Not sufficient space for firmware\n");
+		return -EINVAL;
+	}
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
+ * sproc_find_rsc_table() - find the resource table
+ * @rproc: the rproc handle
+ * @fw: the firmware image
+ * @tablesz: place holder for providing back the table size
+ *
+ * This function finds the resource table inside the remote processor's
+ * firmware. It is used both upon the registration of @rproc (in order
+ * to look for and register the supported virito devices), and when the
+ * @rproc is booted.
+ *
+ * This function will allocate area used for firmware image in the memory
+ * region shared with the modem.
+ *
+ * Returns the pointer to the resource table if it is found, and write its
+ * size into @tablesz. If a valid table isn't found, NULL is returned
+ * (and @tablesz isn't set).
+ */
+static struct resource_table *
+sproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
+		     int *tablesz)
+{
+	struct resource_table *table;
+	struct device *dev = &rproc->dev;
+	struct ste_toc_entry *entry = sproc_find_rsc_entry(fw);
+	struct sproc *sproc = rproc->priv;
+
+	if (!entry) {
+		dev_err(dev, "resource table not found in fw\n");
+		return NULL;
+	}
+
+	table = (void *)(fw->data + entry->start);
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
+	 * reserve space for firmware at the start of the shared memory
+	 * region.
+	 * This cannot be done in the function sproc_load_segments because
+	 * then dma_alloc_coherent is already called by Core and the
+	 * start of the share memory area would alreay have been occupied.
+	 */
+	if (!sproc->fw_addr) {
+		struct resource *modem_shm;
+
+		sproc->fw_addr = dma_alloc_coherent(rproc->dev.parent, fw->size,
+						    &sproc->fw_dma_addr,
+						    GFP_KERNEL);
+		if (!sproc->fw_addr) {
+			dev_err(dev,
+				"cannot allocate space (%zd) for fw image\n",
+				fw->size);
+			return NULL;
+		}
+
+		/* Verify that the fw is at start of the share memory area */
+		modem_shm = platform_get_resource_byname(sproc->pdev,
+							 IORESOURCE_MEM,
+							 SPROC_MEM_AREA);
+		if (modem_shm->start != (unsigned long)sproc->fw_addr) {
+			dev_err(dev,
+				"bad fw address (%lx), should have been %p\n",
+				(unsigned long) modem_shm->start,
+				sproc->fw_addr);
+			dma_free_coherent(dev, sproc->fw_size,
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
+	dev_dbg(&rproc->dev, "kick vqid:%d\n", vqid);
+	modem_kick_trigger(sproc->kick, vqid + SPROC_MAX_NOTIFY_ID);
+}
+
+/* Received a kick from a modem, kick the virtqueue */
+static void sproc_kick_callback(int vqid, void *data)
+{
+	struct sproc *sproc = data;
+	if (rproc_vq_interrupt(sproc->rproc, vqid) == IRQ_NONE) {
+		dev_dbg(&sproc->rproc->dev,
+			"no message was found in vqid %d\n", vqid);
+	}
+}
+
+/* Setup the kick API for notification subscriptions */
+static int sproc_subscribe_to_kicks(struct rproc *rproc)
+{
+	struct sproc *sproc = rproc->priv;
+	int i, err;
+	u32 txmask = 0, rxmask = 0;
+
+	/* Check that the highest notifyid is within range */
+	if (rproc->max_notifyid > SPROC_MAX_NOTIFY_ID) {
+		dev_err(&rproc->dev, "Notification IDs too high:%d\n",
+			rproc->max_notifyid);
+		return -EINVAL;
+	}
+
+	/* Set a bit (0 - 14) for each notification-ID we're using. */
+	for (i = 0; i <= rproc->max_notifyid && i < SPROC_MAX_NOTIFY_ID; i++)
+		rxmask |= 1 << i;
+
+	/*
+	 * For notifications bits 0-13 are used in RX direction,
+	 * and bits 14-27 in TX direction. Left-Shift the rx mask
+	 * to get the tx mask.
+	 */
+	txmask = rxmask << SPROC_MAX_NOTIFY_ID;
+
+	/*
+	 * We need to tell the kick driver what notification IDs
+	 * we're actually using.
+	 */
+	err = modem_kick_alloc_notifyid(sproc->kick, rxmask, txmask);
+
+	if (err < 0) {
+		dev_err(&rproc->dev, "allocation of bits %x/%x failed:%d\n",
+			rxmask, txmask, err);
+		return err;
+	}
+
+	for (i = 0; i < rproc->max_notifyid; i++) {
+		err = modem_kick_subscribe(sproc->kick, i, sproc_kick_callback,
+					   rproc->priv);
+		if (err) {
+			dev_err(&rproc->dev,
+				"subscription of kicks failed:%d\n", err);
+			modem_kick_reset(sproc->kick);
+			return err;
+		}
+	}
+	return 0;
+}
+
+/*
+ * The kick driver below us can signal errors on the HW interface
+ * managing modem interrupts. We should then signal this error to user space.
+ */
+void sproc_kick_errhandler(void *userdata, int errno)
+{
+	struct sproc *sproc = userdata;
+	if (WARN_ON(!sproc))
+		return;
+
+	dev_dbg(&sproc->rproc->dev,
+		"error handler called with errno:%d\n", errno);
+
+	sproc->error = errno;
+	wake_up_interruptible(&sproc->wq);
+}
+
+/* Start the STE modem */
+static int sproc_start(struct rproc *rproc)
+{
+	struct sproc *sproc = rproc->priv;
+	int err = sproc->error;
+
+	/*
+	 * For STE-Modem user-space must stay in control of start-up, so
+	 * reject to start unless the start-up is initiated from user space.
+	 */
+	dev_info(&rproc->dev, "start modem\n");
+	if (err) {
+		dev_dbg(&sproc->rproc->dev,
+			"startup is not initiated from user space:%d\n", err);
+		goto out;
+	}
+
+	/*
+	 * Get hold of the kick handler, and subscribe to kicks (interrupts)
+	 * and error events.
+	 */
+	sproc->kick = modem_kick_get(sproc->rproc->name);
+	if (!sproc->kick) {
+		dev_err(&rproc->dev, "Failed to get modem_kick API for %s\n",
+			sproc->rproc->name);
+		err = -EINVAL;
+		goto out;
+	}
+	modem_kick_register_errhandler(sproc->kick, sproc,
+				       sproc_kick_errhandler);
+	err = sproc_subscribe_to_kicks(sproc->rproc);
+	if (err)
+		goto kick_put;
+
+	/* Get the handle for modem power control */
+	sproc->ctrl = modem_ctrl_get(sproc->rproc->name);
+	if (!sproc->ctrl) {
+		dev_err(&rproc->dev, "Failed to get modem_kick API for %s\n",
+			sproc->rproc->name);
+		err = -EINVAL;
+		goto kick_put;
+	}
+
+	/* Power on modem */
+	err = modem_start(sproc->ctrl);
+	if (err)
+		goto ctrl_put;
+
+	return 0;
+ctrl_put:
+	modem_ctrl_put(sproc->ctrl);
+kick_put:
+	modem_kick_put(sproc->kick);
+out:
+	return err;
+}
+
+/* Stop the STE modem */
+static int sproc_stop(struct rproc *rproc)
+{
+	struct sproc *sproc = rproc->priv;
+
+	dev_info(&rproc->dev, "stop modem\n");
+
+	modem_ctrl_put(sproc->ctrl);
+	modem_kick_put(sproc->kick);
+
+	/* Reset kick HW */
+	modem_kick_reset(sproc->kick);
+
+	/* Notify user space when modem is stopped.  */
+	sproc->error = -EPIPE;
+	wake_up_interruptible(&sproc->wq);
+
+	/* Power off modem */
+	return modem_stop(sproc->ctrl);
+}
+
+static struct rproc_ops sproc_ops = {
+	.start		= sproc_start,
+	.stop		= sproc_stop,
+	.kick		= sproc_kick,
+};
+
+/* Match platform device with the right name and matching major/minor number */
+static int sproc_pdev_match(struct device *dev, void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct sproc *sproc = platform_get_drvdata(pdev);
+	dev_t *devt = data;
+
+	if (sproc && !strncmp(pdev->name, SPROC_NAME, sizeof(SPROC_NAME)))
+		return  sproc->chardev.devt == *devt;
+
+	return 0;
+}
+
+/* Search through platform devices for match on name and major/minor number */
+static struct sproc *sproc_find_from_inode(struct inode *inode)
+{
+	struct device *dev;
+	struct platform_device *pdev;
+	dev = bus_find_device(&platform_bus_type, NULL, &inode->i_rdev,
+			      sproc_pdev_match);
+	if (!dev)
+		return NULL;
+
+	pdev = to_platform_device(dev);
+	return platform_get_drvdata(pdev);
+}
+
+/*
+ * In order for user-space to initiate startup of the ste-modem,
+ * registration of the remoteproc driver is done when the
+ * character device is opened. Remoteproc will then start with
+ * firmware loading, resource table parsing, registration of
+ * the virtio devices, and finally start the modem.
+ */
+static int sproc_chr_open(struct inode *inode, struct file *filp)
+{
+	struct sproc *sproc = sproc_find_from_inode(inode);
+	int err = -EBUSY;
+
+	if (sproc == NULL)
+		goto out;
+	device_lock(&sproc->chardev);
+
+	if (filp->private_data)
+		goto unlock;
+
+	err = rproc_add(sproc->rproc);
+	if (err)
+		goto unlock;
+
+	filp->private_data = sproc;
+
+unlock:
+	device_unlock(&sproc->chardev);
+out:
+	return err;
+}
+
+/*
+ * Closing the character device will unregister the remoteproc driver
+ * causing all virtio devices to be removed, and finally stop of the modem.
+ */
+static int sproc_chr_close(struct inode *inode, struct file *filp)
+{
+	int err;
+	struct sproc *sproc = filp->private_data;
+	if (sproc == NULL)
+		return -ENODEV;
+
+	err = rproc_del(sproc->rproc);
+	if (err)
+		return -EIO;
+
+	/* Reset any error reports */
+	sproc->error = 0;
+	filp->private_data = NULL;
+	return 0;
+}
+
+/*
+ * Poll is used by user-space to detect error event. If
+ * poll returns POLLERR, the modem should be restarted by
+ * close and re-open the character device.
+ */
+static unsigned int sproc_chr_poll(struct file *filp, poll_table *waittab)
+{
+	struct sproc *sproc = filp->private_data;
+
+	if (sproc == NULL)
+		return -ENODEV;
+
+	if (sproc->error)
+		goto out;
+
+	poll_wait(filp, &sproc->wq, waittab);
+
+out:
+
+	if (sproc->error)
+		return POLLERR;
+
+	return 0;
+}
+
+static const struct file_operations sproc_cdev_fops = {
+	.owner = THIS_MODULE,
+	.open = sproc_chr_open,
+	.release = sproc_chr_close,
+	.poll = sproc_chr_poll,
+};
+
+void sproc_chr_release(struct device *dev)
+{
+	struct sproc *sproc = container_of(dev, struct sproc, chardev);
+	dev_dbg(dev, "release the chardev\n");
+	rproc_put(sproc->rproc);
+}
+
+/*
+ * Platform device for STE modem is registered.
+ * Create the device node for the character device.
+ */
+static int __devinit sproc_probe(struct platform_device *pdev)
+{
+	struct sproc *sproc;
+	struct rproc *rproc;
+	int err;
+	dma_addr_t device_addr = 0;
+	struct resource *modem_shm;
+
+	dev_dbg(&pdev->dev, "probe ste-modem platform device\n");
+	rproc = rproc_alloc(&pdev->dev,
+			    pdev->name,
+			    &sproc_ops,
+			    SPROC_MODEM_FIRMWARE,
+			    sizeof(*sproc));
+	if (!rproc)
+		return -ENOMEM;
+
+	sproc = rproc->priv;
+	sproc->rproc = rproc;
+	platform_set_drvdata(pdev, sproc);
+	init_waitqueue_head(&sproc->wq);
+
+	/*
+	 * Get the memory region shared with the modem
+	 * and declare it as dma memory.
+	 */
+	modem_shm = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						 SPROC_MEM_AREA);
+	dev_dbg(&rproc->dev, "Shared memory region:0x%lx - 0x%lx\n",
+		(unsigned long) modem_shm->start,
+		(unsigned long) modem_shm->end);
+
+	err = dma_declare_coherent_memory(&pdev->dev,
+					 (dma_addr_t) modem_shm->start,
+					 device_addr,
+					 modem_shm->end - modem_shm->start,
+					 DMA_MEMORY_MAP |
+					 DMA_MEMORY_EXCLUSIVE |
+					 DMA_MEMORY_INCLUDES_CHILDREN);
+	if (!err) {
+		dev_err(&rproc->dev,
+			"Cannot declare modem-shm memory region\n");
+		err = -ENOMEM;
+		goto free_rproc;
+	}
+
+	/* Set the STE-modem specific firmware handler */
+	rproc->fw_ops = &sproc_fw_ops;
+
+	/*
+	 * Add a character device called ste-modem, as a child of the
+	 * platform device. Use the assigned major number and pdev->id
+	 * as minor number.
+	 * User space will find the major/minor number by looking in:
+	 * sysfs under devices/platform/ste-modem<id>/ste-modem/dev.
+	 */
+	device_initialize(&sproc->chardev);
+	sproc->chardev.parent = &pdev->dev;
+	sproc->chardev.release = sproc_chr_release,
+	dev_set_name(&sproc->chardev, pdev->name);
+	sproc->chardev.devt = MKDEV(sproc_chr_major, max(0, pdev->id));
+	err = device_add(&sproc->chardev);
+	if (err) {
+		dev_err(&rproc->dev, "Failed to add char device\n");
+		goto free_dmamem;
+	}
+
+	/* Take a ref to rproc for the character device */
+	get_device(&rproc->dev);
+	sproc->pdev = pdev;
+
+	dev_info(&sproc->chardev, "STE modem control device - major=%d minor=%d\n",
+		 MAJOR(sproc->chardev.devt),
+		 MINOR(sproc->chardev.devt));
+
+	return 0;
+free_dmamem:
+	dma_release_declared_memory(&pdev->dev);
+free_rproc:
+	rproc_put(rproc);
+	platform_set_drvdata(pdev, NULL);
+	return err;
+}
+
+/* Platform device for STE modem is unregistered */
+static int sproc_remove(struct platform_device *pdev)
+{
+	struct sproc *sproc = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "Remove platform device\n");
+
+	/* Notify the user that the platform device is gone */
+	sproc->error = -ENODEV;
+	wake_up_interruptible(&sproc->wq);
+
+	dma_release_declared_memory(&pdev->dev);
+	platform_set_drvdata(pdev, NULL);
+	device_del(&sproc->chardev);
+	put_device(&sproc->chardev);
+	return 0;
+}
+
+static struct platform_driver sproc_driver = {
+	.probe = sproc_probe,
+	.remove = sproc_remove,
+	.driver = {
+		.name = SPROC_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init sproc_modem_rproc_init(void)
+{
+	/* TODO: Consider requesting our own major number? */
+	/* Register a character device, and get a major number automatically */
+	sproc_chr_major = register_chrdev(0, SPROC_NAME, &sproc_cdev_fops);
+	if (!sproc_chr_major) {
+		pr_warn("unable to register chr device\n");
+		return -EIO;
+	}
+	pr_info("major number:%d\n", sproc_chr_major);
+	return platform_driver_register(&sproc_driver);
+}
+module_init(sproc_modem_rproc_init);
+
+static void __exit sproc_modem_rproc_exit(void)
+{
+	unregister_chrdev(sproc_chr_major, SPROC_NAME);
+	platform_driver_unregister(&sproc_driver);
+}
+module_exit(sproc_modem_rproc_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("STE Modem driver using the Remote Processor Framework");
-- 
1.7.5.4

