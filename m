Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab2FVObg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:31:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58047 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762397Ab2FVObc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:31:32 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC 4/4] remoteproc: Add driver for STE Modem
Date: Fri, 22 Jun 2012 16:31:10 +0200
Message-Id: <1340375470-13097-5-git-send-email-sjur.brandeland@stericsson.com>
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

Introduce the platform driver for ste-modems.
This driver uses the remoteproc framework for managing the
modem and for creating virtio devices used for communicating
with the modem.

A sysfs file is introduced for switching on/off the modem, as modem
start-up must be controlled from user space.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/Makefile          |    1 +
 drivers/remoteproc/ste_modem_rproc.c |  333 ++++++++++++++++++++++++++++++++++
 2 files changed, 334 insertions(+), 0 deletions(-)
 create mode 100644 drivers/remoteproc/ste_modem_rproc.c

diff --git a/drivers/remoteproc/Makefile b/drivers/remoteproc/Makefile
index b91ecb0b..aec7470 100644
--- a/drivers/remoteproc/Makefile
+++ b/drivers/remoteproc/Makefile
@@ -9,4 +9,5 @@ remoteproc-y				+= remoteproc_virtio.o
 remoteproc-y				+= remoteproc_elf_loader.o
 obj-$(CONFIG_OMAP_REMOTEPROC)		+= omap_remoteproc.o
 obj-$(CONFIG_STE_MODEM_RPROC)	 	+= ste_modem_remoteproc.o
+ste_modem_remoteproc-y 			+= ste_modem_rproc.o
 ste_modem_remoteproc-y 			+= remoteproc_ste_modem_loader.o
diff --git a/drivers/remoteproc/ste_modem_rproc.c b/drivers/remoteproc/ste_modem_rproc.c
new file mode 100644
index 0000000..a575e2a
--- /dev/null
+++ b/drivers/remoteproc/ste_modem_rproc.c
@@ -0,0 +1,333 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2012
+ * Author: Sjur Brændeland <sjur.brandeland@stericsson.com>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s(): " fmt, __func__
+
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
+#include "remoteproc_internal.h"
+#include "stemod_kick.h"
+
+/* Maxium number of "channels" */
+#define MAX_VQS 14
+
+/* Maxium size of the STE firmwaree image 160Kb */
+#define STEMOD_FW_SIZE (40 * 4096)
+
+struct sproc {
+	struct rproc *rproc;
+	/* Number of kick identifiers needed */
+	u32 nvqs;
+	/* Track the user requested power state */
+	bool powered;
+	int (*kick_modem)(int notifyid);
+};
+
+/* kick a virtqueue */
+static void ste_rproc_kick(struct rproc *rproc, int vqid)
+{
+	struct sproc *sproc = rproc->priv;
+	dev_dbg(rproc->dev, "kick vqid:%d\n", vqid);
+	sproc->kick_modem(vqid + MAX_VQS);
+}
+
+/* modem is kicking us */
+static void ste_rproc_callback(int vqid, void *data)
+{
+	struct sproc *sproc = data;
+	if (rproc_vq_interrupt(sproc->rproc, vqid) == IRQ_NONE)
+		dev_dbg(sproc->rproc->dev,
+			"no message was found in vqid %d\n", vqid);
+}
+
+/* Iterator called by idr_for_each(), tracking notification Ids */
+static int ste_rproc_set_vqid(int id, void *p, void *data)
+{
+	u32 *mask = data;
+	*mask |= 1 << id;
+	return 0;
+}
+
+/* Setup the kick API for notification subscriptions */
+static int ste_rproc_subscribe_to_kicks(struct rproc *rproc)
+{
+	int i, err;
+	u32 txmask = 0, rxmask = 0;
+	int (*kick_subscribe)(int notifyid,
+		       void (*notify_cb)(int notifyid, void *data), void *data);
+	int (*notifyid_alloc)(u32 setter_mask, u32 getter_mask);
+
+	/*
+	 * We need to declare for the HW what notification IDs
+	 * we're going to use. So we create a bitmask with the
+	 * notification IDs used for RX and TX by iterating over
+	 * the notification IDs.
+	 */
+	idr_for_each(&rproc->notifyids, ste_rproc_set_vqid, &rxmask);
+
+	/* Verify that notification ID is in the range 0-13 */
+	if (rxmask & 0x3fff) {
+		dev_err(rproc->dev, "Bad Notification IDs used: %x\n", rxmask);
+		return -EINVAL;
+	}
+	/*
+	 * Bits 0-13 are used for RX kicks and bits 14-27 for TX.
+	 * We simply set TX notification ID to be RX notification ID + 14.
+	 */
+	txmask = rxmask << MAX_VQS;
+
+	notifyid_alloc = symbol_get(stemod_kick_notifyid_alloc);
+	if (notifyid_alloc == NULL)
+		return -EINVAL;
+
+	/* Tell kick-hw what bit we use for RX and TX */
+	err = notifyid_alloc(rxmask, txmask);
+	symbol_put(stemod_kick_notifyid_alloc);
+
+	if (err < 0) {
+		dev_err(rproc->dev, "allocation of bits %x/%x failed:%d\n",
+			rxmask, txmask, err);
+		return err;
+	}
+
+	kick_subscribe = symbol_get(stemod_kick_subscribe);
+	if (kick_subscribe == NULL)
+		return -EINVAL;
+
+	/* Subscribe for RX interrupts */
+	for (err = 0, i = 0; i < MAX_VQS && !err; i++)
+		if (rxmask & (1 << i))
+			err = kick_subscribe(i, ste_rproc_callback,
+						    rproc->priv);
+	symbol_put(stemod_kick_subscribe);
+	if (err) {
+		dev_err(rproc->dev, "subscription of kicks failed:%d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+int power_switch(bool on)
+{
+	int err = 0;
+	int (*power)(bool on);
+
+	power = symbol_get(stemod_power);
+	if (power == NULL)
+		err =  -EINVAL;
+	err = power(on);
+	symbol_put(stemod_power);
+	return err;
+}
+
+/* Start the STE modem */
+static int ste_rproc_start(struct rproc *rproc)
+{
+	int err;
+	dev_info(rproc->dev, "start modem\n");
+
+	err = ste_rproc_subscribe_to_kicks(rproc->priv);
+	if (err)
+		return err;
+
+	/* Power on modem */
+	return power_switch(true);
+}
+
+/* Stop the STE modem */
+static int ste_rproc_stop(struct rproc *rproc)
+{
+	struct device *dev = rproc->dev;
+	int (*reset)(void);
+
+	dev_info(dev, "stop modem\n");
+
+	/* Reset kick HW */
+	reset = symbol_get(stemod_kick_reset);
+	reset();
+	symbol_put(stemod_kick_reset);
+
+	/* Power off modem */
+	return power_switch(true);
+}
+
+static struct rproc_ops ste_rproc_ops = {
+	.start		= ste_rproc_start,
+	.stop		= ste_rproc_stop,
+	.kick		= ste_rproc_kick,
+};
+
+/* Get ste_rproc given platform device */
+static struct sproc *ste_rproc_get_by_dev(const struct device *dev)
+{
+	struct platform_device *pdev;
+	struct rproc *rproc;
+	pdev = container_of(dev, struct platform_device, dev);
+	rproc = platform_get_drvdata(pdev);
+	if (rproc == NULL)
+		return NULL;
+	return rproc->priv;
+}
+
+/* Read sysfs entry 'powered' */
+static ssize_t ste_rproc_powered_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct sproc *sproc = ste_rproc_get_by_dev(dev);
+	ssize_t size;
+
+	if (sproc == NULL)
+		return -EINVAL;
+
+	size = sprintf(buf, "%d\n", sproc->powered);
+	return size;
+}
+
+/* Write sysfs entry 'powered' */
+static ssize_t ste_rproc_powered_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	unsigned long val;
+	int ret = -EINVAL;
+	struct sproc *sproc = ste_rproc_get_by_dev(dev);
+
+	if (sproc == NULL)
+		return -EINVAL;
+
+	if (kstrtoul(buf, 10, &val) < 0)
+		goto err;
+
+	if (sproc->powered && val == 0) {
+		rproc_shutdown(sproc->rproc);
+		sproc->powered = false;
+	} else if (!sproc->powered && val == 1) {
+
+		if (rproc_boot(sproc->rproc))
+			goto err;
+		sproc->powered = true;
+	} else {
+		dev_err(dev, "invalid sysfs state entered\n");
+		goto err;
+	}
+	ret = count;
+err:
+	return ret;
+}
+
+/* Declare sysfs entry powered */
+static DEVICE_ATTR(powered, S_IRUGO | S_IWUSR | S_IWGRP ,
+			ste_rproc_powered_show, ste_rproc_powered_store);
+struct device_attribute *remoteproc_attrs[] = { &dev_attr_powered };
+
+/* Platform device for STE modem is registered */
+static int __devinit ste_rproc_probe(struct platform_device *pdev)
+{
+	struct sproc *ste_proc;
+	struct rproc *rproc;
+	int ret;
+	void *reserved;
+	dma_addr_t dma;
+
+	/*
+	 * Prerequisite: The platform device must declare the shared
+	 * memory region to be used by STE-modem and make memory
+	 * available for rproc by using  dma_declare_coherent_memory
+	 * (or CMA).
+	 */
+	rproc = rproc_alloc(&pdev->dev,
+			    pdev->name,
+			    &ste_rproc_ops,
+			    "ste-modem-fw",
+			    sizeof(*ste_proc));
+	if (!rproc)
+		return -ENOMEM;
+
+	ste_proc = rproc->priv;
+	ste_proc->rproc = rproc;
+	platform_set_drvdata(pdev, rproc);
+
+	/* Inject the STE-modem specific firmware handler */
+	rproc->fw_ops = &rproc_ste_modem_fw_ops;
+
+	/*
+	 * We're dynamically looking up the symbols for the API used
+	 * for generating kicks to and from the modem.
+	 */
+	ste_proc->kick_modem = symbol_get(stemod_kick_notifyid);
+	if (ste_proc->kick_modem == NULL) {
+		ret =  -EINVAL;
+		dev_err(rproc->dev, "cannot load stemod_kick API\n");
+		goto free_rproc;
+	}
+
+	/*
+	 * Registration of the ste_modem_rproc will cause firmware to
+	 * to be fetched and the virtio resource entries to be allocated
+	 * in memory. However STE-modem requires the firmware to be located
+	 * at the start of the shared memory region. So we need to
+	 * reserve space for firmware at the start of the shared memory
+	 * region.
+	 */
+	reserved = dma_alloc_coherent(&pdev->dev, STEMOD_FW_SIZE,
+				      &dma, GFP_KERNEL);
+
+	ret = rproc_register(rproc);
+	if (ret)
+		goto free_rproc;
+
+	/*
+	 * When firmware loading is completed and virtio resource
+	 * entries are allocated in memory, we can release the
+	 * memory space reserved for modem firmware.
+	 * When user switch on the modem, the firmware will be
+	 * loaded at the start of the memory region.
+	 */
+	wait_for_completion(&rproc->firmware_loading_complete);
+	dma_free_coherent(&pdev->dev, PAGE_SIZE * 10, reserved, dma);
+
+	/* Create powered sysfs entry, to start/stop STE modem */
+	ret = device_create_file(&pdev->dev, &dev_attr_powered);
+	if (ret)
+		goto free_rproc;
+
+	return 0;
+
+free_rproc:
+	platform_set_drvdata(pdev, NULL);
+	rproc_free(rproc);
+	return ret;
+}
+
+/* Platform device for STE modem is unregistered */
+static int __devexit ste_rproc_remove(struct platform_device *pdev)
+{
+	struct rproc *rproc = platform_get_drvdata(pdev);
+	symbol_put(stemod_kick_notifyid);
+	return rproc_unregister(rproc);
+}
+
+static struct platform_driver ste_rproc_driver = {
+	.probe = ste_rproc_probe,
+	.remove = __devexit_p(ste_rproc_remove),
+	.driver = {
+		.name = "ste-modem",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_platform_driver(ste_rproc_driver);
+MODULE_LICENSE("GPL v2");
-- 
1.7.5.4

