Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab2I0KhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:37:21 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:21131 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab2I0KhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:37:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkECAEQrZFBbdWObgWdsb2JhbABFvg8jAQEWJieCIAEBBRoBDEASECAxVwYTiAm3b4sYhh0DkjiDMZMU
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447833"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 15/17] staging: ipack: Rename bridges to carriers.
Date: Thu, 27 Sep 2012 12:37:39 +0200
Message-Id: <1348742261-28145-15-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

This is the name used by the standard.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/Kconfig            |    2 +-
 drivers/staging/ipack/Makefile           |    2 +-
 drivers/staging/ipack/bridges/Kconfig    |    7 -
 drivers/staging/ipack/bridges/Makefile   |    1 -
 drivers/staging/ipack/bridges/tpci200.c  |  634 ------------------------------
 drivers/staging/ipack/bridges/tpci200.h  |  167 --------
 drivers/staging/ipack/carriers/Kconfig   |    7 +
 drivers/staging/ipack/carriers/Makefile  |    1 +
 drivers/staging/ipack/carriers/tpci200.c |  634 ++++++++++++++++++++++++++++++
 drivers/staging/ipack/carriers/tpci200.h |  167 ++++++++
 10 files changed, 811 insertions(+), 811 deletions(-)
 delete mode 100644 drivers/staging/ipack/bridges/Kconfig
 delete mode 100644 drivers/staging/ipack/bridges/Makefile
 delete mode 100644 drivers/staging/ipack/bridges/tpci200.c
 delete mode 100644 drivers/staging/ipack/bridges/tpci200.h
 create mode 100644 drivers/staging/ipack/carriers/Kconfig
 create mode 100644 drivers/staging/ipack/carriers/Makefile
 create mode 100644 drivers/staging/ipack/carriers/tpci200.c
 create mode 100644 drivers/staging/ipack/carriers/tpci200.h

diff --git a/drivers/staging/ipack/Kconfig b/drivers/staging/ipack/Kconfig
index 4cf4706..9b4495a 100644
--- a/drivers/staging/ipack/Kconfig
+++ b/drivers/staging/ipack/Kconfig
@@ -14,7 +14,7 @@ menuconfig IPACK_BUS
 
 if IPACK_BUS
 
-source "drivers/staging/ipack/bridges/Kconfig"
+source "drivers/staging/ipack/carriers/Kconfig"
 
 source "drivers/staging/ipack/devices/Kconfig"
 
diff --git a/drivers/staging/ipack/Makefile b/drivers/staging/ipack/Makefile
index 85ff223..6f14ade 100644
--- a/drivers/staging/ipack/Makefile
+++ b/drivers/staging/ipack/Makefile
@@ -3,4 +3,4 @@
 #
 obj-$(CONFIG_IPACK_BUS)		+= ipack.o
 obj-y				+= devices/
-obj-y				+= bridges/
+obj-y				+= carriers/
diff --git a/drivers/staging/ipack/bridges/Kconfig b/drivers/staging/ipack/bridges/Kconfig
deleted file mode 100644
index 33fdc24..0000000
--- a/drivers/staging/ipack/bridges/Kconfig
+++ /dev/null
@@ -1,7 +0,0 @@
-config BOARD_TPCI200
-	tristate "TEWS TPCI-200 support for IndustryPack bus"
-	depends on IPACK_BUS
-	depends on PCI
-	help
-	  This driver supports the TEWS TPCI200 device for the IndustryPack bus.
-	default n
diff --git a/drivers/staging/ipack/bridges/Makefile b/drivers/staging/ipack/bridges/Makefile
deleted file mode 100644
index d8b7645..0000000
--- a/drivers/staging/ipack/bridges/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-$(CONFIG_BOARD_TPCI200) += tpci200.o
diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
deleted file mode 100644
index 376e794..0000000
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ /dev/null
@@ -1,634 +0,0 @@
-/**
- * tpci200.c
- *
- * driver for the TEWS TPCI-200 device
- * Copyright (c) 2009 Nicolas Serafini, EIC2 SA
- * Copyright (c) 2010,2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
- * Copyright (c) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; version 2 of the License.
- */
-
-#include <linux/module.h>
-#include "tpci200.h"
-
-static const u16 tpci200_status_timeout[] = {
-	TPCI200_A_TIMEOUT,
-	TPCI200_B_TIMEOUT,
-	TPCI200_C_TIMEOUT,
-	TPCI200_D_TIMEOUT,
-};
-
-static const u16 tpci200_status_error[] = {
-	TPCI200_A_ERROR,
-	TPCI200_B_ERROR,
-	TPCI200_C_ERROR,
-	TPCI200_D_ERROR,
-};
-
-static const size_t tpci200_space_size[IPACK_SPACE_COUNT] = {
-	[IPACK_IO_SPACE]    = TPCI200_IO_SPACE_SIZE,
-	[IPACK_ID_SPACE]    = TPCI200_ID_SPACE_SIZE,
-	[IPACK_INT_SPACE]   = TPCI200_INT_SPACE_SIZE,
-	[IPACK_MEM8_SPACE]  = TPCI200_MEM8_SPACE_SIZE,
-	[IPACK_MEM16_SPACE] = TPCI200_MEM16_SPACE_SIZE,
-};
-
-static const size_t tpci200_space_interval[IPACK_SPACE_COUNT] = {
-	[IPACK_IO_SPACE]    = TPCI200_IO_SPACE_INTERVAL,
-	[IPACK_ID_SPACE]    = TPCI200_ID_SPACE_INTERVAL,
-	[IPACK_INT_SPACE]   = TPCI200_INT_SPACE_INTERVAL,
-	[IPACK_MEM8_SPACE]  = TPCI200_MEM8_SPACE_INTERVAL,
-	[IPACK_MEM16_SPACE] = TPCI200_MEM16_SPACE_INTERVAL,
-};
-
-static struct tpci200_board *check_slot(struct ipack_device *dev)
-{
-	struct tpci200_board *tpci200;
-
-	if (dev == NULL)
-		return NULL;
-
-
-	tpci200 = dev_get_drvdata(dev->bus->parent);
-
-	if (tpci200 == NULL) {
-		dev_info(&dev->dev, "carrier board not found\n");
-		return NULL;
-	}
-
-	if (dev->slot >= TPCI200_NB_SLOT) {
-		dev_info(&dev->dev,
-			 "Slot [%d:%d] doesn't exist! Last tpci200 slot is %d.\n",
-			 dev->bus->bus_nr, dev->slot, TPCI200_NB_SLOT-1);
-		return NULL;
-	}
-
-	return tpci200;
-}
-
-static void tpci200_clear_mask(struct tpci200_board *tpci200,
-			       __le16 __iomem *addr, u16 mask)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&tpci200->regs_lock, flags);
-	iowrite16(ioread16(addr) & (~mask), addr);
-	spin_unlock_irqrestore(&tpci200->regs_lock, flags);
-}
-
-static void tpci200_set_mask(struct tpci200_board *tpci200,
-			     __le16 __iomem *addr, u16 mask)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&tpci200->regs_lock, flags);
-	iowrite16(ioread16(addr) | mask, addr);
-	spin_unlock_irqrestore(&tpci200->regs_lock, flags);
-}
-
-static void tpci200_unregister(struct tpci200_board *tpci200)
-{
-	free_irq(tpci200->info->pdev->irq, (void *) tpci200);
-
-	pci_iounmap(tpci200->info->pdev, tpci200->info->interface_regs);
-	pci_iounmap(tpci200->info->pdev, tpci200->info->cfg_regs);
-
-	pci_release_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR);
-	pci_release_region(tpci200->info->pdev, TPCI200_IO_ID_INT_SPACES_BAR);
-	pci_release_region(tpci200->info->pdev, TPCI200_MEM16_SPACE_BAR);
-	pci_release_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR);
-	pci_release_region(tpci200->info->pdev, TPCI200_CFG_MEM_BAR);
-
-	pci_disable_device(tpci200->info->pdev);
-	pci_dev_put(tpci200->info->pdev);
-}
-
-static void tpci200_enable_irq(struct tpci200_board *tpci200,
-			       int islot)
-{
-	tpci200_set_mask(tpci200,
-			&tpci200->info->interface_regs->control[islot],
-			TPCI200_INT0_EN | TPCI200_INT1_EN);
-}
-
-static void tpci200_disable_irq(struct tpci200_board *tpci200,
-				int islot)
-{
-	tpci200_clear_mask(tpci200,
-			&tpci200->info->interface_regs->control[islot],
-			TPCI200_INT0_EN | TPCI200_INT1_EN);
-}
-
-static irqreturn_t tpci200_slot_irq(struct slot_irq *slot_irq)
-{
-	irqreturn_t ret;
-
-	if (!slot_irq)
-		return -ENODEV;
-	ret = slot_irq->handler(slot_irq->arg);
-
-	return ret;
-}
-
-static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
-{
-	struct tpci200_board *tpci200 = (struct tpci200_board *) dev_id;
-	struct slot_irq *slot_irq;
-	irqreturn_t ret;
-	u16 status_reg;
-	int i;
-
-	/* Read status register */
-	status_reg = ioread16(&tpci200->info->interface_regs->status);
-
-	/* Did we cause the interrupt? */
-	if (!(status_reg & TPCI200_SLOT_INT_MASK))
-		return IRQ_NONE;
-
-	/* callback to the IRQ handler for the corresponding slot */
-	rcu_read_lock();
-	for (i = 0; i < TPCI200_NB_SLOT; i++) {
-		if (!(status_reg & ((TPCI200_A_INT0 | TPCI200_A_INT1) << (2 * i))))
-			continue;
-		slot_irq = rcu_dereference(tpci200->slots[i].irq);
-		ret = tpci200_slot_irq(slot_irq);
-		if (ret == -ENODEV) {
-			dev_info(&tpci200->info->pdev->dev,
-				 "No registered ISR for slot [%d:%d]!. IRQ will be disabled.\n",
-				 tpci200->number, i);
-			tpci200_disable_irq(tpci200, i);
-		}
-	}
-	rcu_read_unlock();
-
-	return IRQ_HANDLED;
-}
-
-static int tpci200_free_irq(struct ipack_device *dev)
-{
-	struct slot_irq *slot_irq;
-	struct tpci200_board *tpci200;
-
-	tpci200 = check_slot(dev);
-	if (tpci200 == NULL)
-		return -EINVAL;
-
-	if (mutex_lock_interruptible(&tpci200->mutex))
-		return -ERESTARTSYS;
-
-	if (tpci200->slots[dev->slot].irq == NULL) {
-		mutex_unlock(&tpci200->mutex);
-		return -EINVAL;
-	}
-
-	tpci200_disable_irq(tpci200, dev->slot);
-	slot_irq = tpci200->slots[dev->slot].irq;
-	/* uninstall handler */
-	RCU_INIT_POINTER(tpci200->slots[dev->slot].irq, NULL);
-	synchronize_rcu();
-	kfree(slot_irq);
-	mutex_unlock(&tpci200->mutex);
-	return 0;
-}
-
-static int tpci200_request_irq(struct ipack_device *dev,
-			       irqreturn_t (*handler)(void *), void *arg)
-{
-	int res = 0;
-	struct slot_irq *slot_irq;
-	struct tpci200_board *tpci200;
-
-	tpci200 = check_slot(dev);
-	if (tpci200 == NULL)
-		return -EINVAL;
-
-	if (mutex_lock_interruptible(&tpci200->mutex))
-		return -ERESTARTSYS;
-
-	if (tpci200->slots[dev->slot].irq != NULL) {
-		dev_err(&dev->dev,
-			"Slot [%d:%d] IRQ already registered !\n", dev->bus->bus_nr,
-			dev->slot);
-		res = -EINVAL;
-		goto out_unlock;
-	}
-
-	slot_irq = kzalloc(sizeof(struct slot_irq), GFP_KERNEL);
-	if (slot_irq == NULL) {
-		dev_err(&dev->dev,
-			"Slot [%d:%d] unable to allocate memory for IRQ !\n",
-			dev->bus->bus_nr, dev->slot);
-		res = -ENOMEM;
-		goto out_unlock;
-	}
-
-	/*
-	 * WARNING: Setup Interrupt Vector in the IndustryPack device
-	 * before an IRQ request.
-	 * Read the User Manual of your IndustryPack device to know
-	 * where to write the vector in memory.
-	 */
-	slot_irq->handler = handler;
-	slot_irq->arg = arg;
-	slot_irq->holder = dev;
-
-	rcu_assign_pointer(tpci200->slots[dev->slot].irq, slot_irq);
-	tpci200_enable_irq(tpci200, dev->slot);
-
-out_unlock:
-	mutex_unlock(&tpci200->mutex);
-	return res;
-}
-
-static int tpci200_register(struct tpci200_board *tpci200)
-{
-	int i;
-	int res;
-	phys_addr_t ioidint_base;
-	unsigned short slot_ctrl;
-
-	if (pci_enable_device(tpci200->info->pdev) < 0)
-		return -ENODEV;
-
-	/* Request IP interface register (Bar 2) */
-	res = pci_request_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR,
-				 "Carrier IP interface registers");
-	if (res) {
-		dev_err(&tpci200->info->pdev->dev,
-			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 2 !",
-			tpci200->info->pdev->bus->number,
-			tpci200->info->pdev->devfn);
-		goto out_disable_pci;
-	}
-
-	/* Request IO ID INT space (Bar 3) */
-	res = pci_request_region(tpci200->info->pdev,
-				 TPCI200_IO_ID_INT_SPACES_BAR,
-				 "Carrier IO ID INT space");
-	if (res) {
-		dev_err(&tpci200->info->pdev->dev,
-			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 3 !",
-			tpci200->info->pdev->bus->number,
-			tpci200->info->pdev->devfn);
-		goto out_release_ip_space;
-	}
-
-	/* Request MEM8 space (Bar 5) */
-	res = pci_request_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR,
-				 "Carrier MEM8 space");
-	if (res) {
-		dev_err(&tpci200->info->pdev->dev,
-			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 5!",
-			tpci200->info->pdev->bus->number,
-			tpci200->info->pdev->devfn);
-		goto out_release_ioid_int_space;
-	}
-
-	/* Request MEM16 space (Bar 4) */
-	res = pci_request_region(tpci200->info->pdev, TPCI200_MEM16_SPACE_BAR,
-				 "Carrier MEM16 space");
-	if (res) {
-		dev_err(&tpci200->info->pdev->dev,
-			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 4!",
-			tpci200->info->pdev->bus->number,
-			tpci200->info->pdev->devfn);
-		goto out_release_mem8_space;
-	}
-
-	/* Map internal tpci200 driver user space */
-	tpci200->info->interface_regs =
-		ioremap_nocache(pci_resource_start(tpci200->info->pdev,
-					   TPCI200_IP_INTERFACE_BAR),
-			TPCI200_IFACE_SIZE);
-
-	/* Initialize lock that protects interface_regs */
-	spin_lock_init(&tpci200->regs_lock);
-
-	ioidint_base = pci_resource_start(tpci200->info->pdev,
-					  TPCI200_IO_ID_INT_SPACES_BAR);
-	tpci200->mod_mem[IPACK_IO_SPACE] = ioidint_base + TPCI200_IO_SPACE_OFF;
-	tpci200->mod_mem[IPACK_ID_SPACE] = ioidint_base + TPCI200_ID_SPACE_OFF;
-	tpci200->mod_mem[IPACK_INT_SPACE] =
-		ioidint_base + TPCI200_INT_SPACE_OFF;
-	tpci200->mod_mem[IPACK_MEM8_SPACE] =
-		pci_resource_start(tpci200->info->pdev,
-				   TPCI200_MEM8_SPACE_BAR);
-	tpci200->mod_mem[IPACK_MEM16_SPACE] =
-		pci_resource_start(tpci200->info->pdev,
-				   TPCI200_MEM16_SPACE_BAR);
-
-	/* Set the default parameters of the slot
-	 * INT0 disabled, level sensitive
-	 * INT1 disabled, level sensitive
-	 * error interrupt disabled
-	 * timeout interrupt disabled
-	 * recover time disabled
-	 * clock rate 8 MHz
-	 */
-	slot_ctrl = 0;
-	for (i = 0; i < TPCI200_NB_SLOT; i++)
-		writew(slot_ctrl, &tpci200->info->interface_regs->control[i]);
-
-	res = request_irq(tpci200->info->pdev->irq,
-			  tpci200_interrupt, IRQF_SHARED,
-			  KBUILD_MODNAME, (void *) tpci200);
-	if (res) {
-		dev_err(&tpci200->info->pdev->dev,
-			"(bn 0x%X, sn 0x%X) unable to register IRQ !",
-			tpci200->info->pdev->bus->number,
-			tpci200->info->pdev->devfn);
-		goto out_release_ioid_int_space;
-	}
-
-	return 0;
-
-out_release_mem8_space:
-	pci_release_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR);
-out_release_ioid_int_space:
-	pci_release_region(tpci200->info->pdev, TPCI200_IO_ID_INT_SPACES_BAR);
-out_release_ip_space:
-	pci_release_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR);
-out_disable_pci:
-	pci_disable_device(tpci200->info->pdev);
-	return res;
-}
-
-static int tpci200_get_clockrate(struct ipack_device *dev)
-{
-	struct tpci200_board *tpci200 = check_slot(dev);
-	__le16 __iomem *addr;
-
-	if (!tpci200)
-		return -ENODEV;
-
-	addr = &tpci200->info->interface_regs->control[dev->slot];
-	return (ioread16(addr) & TPCI200_CLK32) ? 32 : 8;
-}
-
-static int tpci200_set_clockrate(struct ipack_device *dev, int mherz)
-{
-	struct tpci200_board *tpci200 = check_slot(dev);
-	__le16 __iomem *addr;
-
-	if (!tpci200)
-		return -ENODEV;
-
-	addr = &tpci200->info->interface_regs->control[dev->slot];
-
-	switch (mherz) {
-	case 8:
-		tpci200_clear_mask(tpci200, addr, TPCI200_CLK32);
-		break;
-	case 32:
-		tpci200_set_mask(tpci200, addr, TPCI200_CLK32);
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int tpci200_get_error(struct ipack_device *dev)
-{
-	struct tpci200_board *tpci200 = check_slot(dev);
-	__le16 __iomem *addr;
-	u16 mask;
-
-	if (!tpci200)
-		return -ENODEV;
-
-	addr = &tpci200->info->interface_regs->status;
-	mask = tpci200_status_error[dev->slot];
-	return (ioread16(addr) & mask) ? 1 : 0;
-}
-
-static int tpci200_get_timeout(struct ipack_device *dev)
-{
-	struct tpci200_board *tpci200 = check_slot(dev);
-	__le16 __iomem *addr;
-	u16 mask;
-
-	if (!tpci200)
-		return -ENODEV;
-
-	addr = &tpci200->info->interface_regs->status;
-	mask = tpci200_status_timeout[dev->slot];
-
-	return (ioread16(addr) & mask) ? 1 : 0;
-}
-
-static int tpci200_reset_timeout(struct ipack_device *dev)
-{
-	struct tpci200_board *tpci200 = check_slot(dev);
-	__le16 __iomem *addr;
-	u16 mask;
-
-	if (!tpci200)
-		return -ENODEV;
-
-	addr = &tpci200->info->interface_regs->status;
-	mask = tpci200_status_timeout[dev->slot];
-
-	iowrite16(mask, addr);
-	return 0;
-}
-
-static void tpci200_uninstall(struct tpci200_board *tpci200)
-{
-	tpci200_unregister(tpci200);
-	kfree(tpci200->slots);
-}
-
-static const struct ipack_bus_ops tpci200_bus_ops = {
-	.request_irq = tpci200_request_irq,
-	.free_irq = tpci200_free_irq,
-	.get_clockrate = tpci200_get_clockrate,
-	.set_clockrate = tpci200_set_clockrate,
-	.get_error     = tpci200_get_error,
-	.get_timeout   = tpci200_get_timeout,
-	.reset_timeout = tpci200_reset_timeout,
-};
-
-static int tpci200_install(struct tpci200_board *tpci200)
-{
-	int res;
-
-	tpci200->slots = kzalloc(
-		TPCI200_NB_SLOT * sizeof(struct tpci200_slot), GFP_KERNEL);
-	if (tpci200->slots == NULL)
-		return -ENOMEM;
-
-	res = tpci200_register(tpci200);
-	if (res) {
-		kfree(tpci200->slots);
-		tpci200->slots = NULL;
-		return res;
-	}
-
-	mutex_init(&tpci200->mutex);
-	return 0;
-}
-
-static void tpci200_release_device(struct ipack_device *dev)
-{
-	kfree(dev);
-}
-
-static int tpci200_create_device(struct tpci200_board *tpci200, int i)
-{
-	enum ipack_space space;
-	struct ipack_device *dev =
-		kzalloc(sizeof(struct ipack_device), GFP_KERNEL);
-	if (!dev)
-		return -ENOMEM;
-	dev->slot = i;
-	dev->bus = tpci200->info->ipack_bus;
-	dev->release = tpci200_release_device;
-
-	for (space = 0; space < IPACK_SPACE_COUNT; space++) {
-		dev->region[space].start =
-			tpci200->mod_mem[space]
-			+ tpci200_space_interval[space] * i;
-		dev->region[space].size = tpci200_space_size[space];
-	}
-	return ipack_device_register(dev);
-}
-
-static int tpci200_pci_probe(struct pci_dev *pdev,
-			     const struct pci_device_id *id)
-{
-	int ret, i;
-	struct tpci200_board *tpci200;
-	u32 reg32;
-
-	tpci200 = kzalloc(sizeof(struct tpci200_board), GFP_KERNEL);
-	if (!tpci200)
-		return -ENOMEM;
-
-	tpci200->info = kzalloc(sizeof(struct tpci200_infos), GFP_KERNEL);
-	if (!tpci200->info) {
-		ret = -ENOMEM;
-		goto out_err_info;
-	}
-
-	pci_dev_get(pdev);
-
-	/* Obtain a mapping of the carrier's PCI configuration registers */
-	ret = pci_request_region(pdev, TPCI200_CFG_MEM_BAR,
-				 KBUILD_MODNAME " Configuration Memory");
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to allocate PCI Configuration Memory");
-		ret = -EBUSY;
-		goto out_err_pci_request;
-	}
-	tpci200->info->cfg_regs = ioremap_nocache(
-			pci_resource_start(pdev, TPCI200_CFG_MEM_BAR),
-			pci_resource_len(pdev, TPCI200_CFG_MEM_BAR));
-	if (!tpci200->info->cfg_regs) {
-		dev_err(&pdev->dev, "Failed to map PCI Configuration Memory");
-		ret = -EFAULT;
-		goto out_err_ioremap;
-	}
-
-	/* Disable byte swapping for 16 bit IP module access. This will ensure
-	 * that the Industrypack big endian byte order is preserved by the
-	 * carrier. */
-	reg32 = ioread32(tpci200->info->cfg_regs + LAS1_DESC);
-	reg32 |= 1 << LAS_BIT_BIGENDIAN;
-	iowrite32(reg32, tpci200->info->cfg_regs + LAS1_DESC);
-
-	reg32 = ioread32(tpci200->info->cfg_regs + LAS2_DESC);
-	reg32 |= 1 << LAS_BIT_BIGENDIAN;
-	iowrite32(reg32, tpci200->info->cfg_regs + LAS2_DESC);
-
-	/* Save struct pci_dev pointer */
-	tpci200->info->pdev = pdev;
-	tpci200->info->id_table = (struct pci_device_id *)id;
-
-	/* register the device and initialize it */
-	ret = tpci200_install(tpci200);
-	if (ret) {
-		dev_err(&pdev->dev, "error during tpci200 install\n");
-		ret = -ENODEV;
-		goto out_err_install;
-	}
-
-	/* Register the carrier in the industry pack bus driver */
-	tpci200->info->ipack_bus = ipack_bus_register(&pdev->dev,
-						      TPCI200_NB_SLOT,
-						      &tpci200_bus_ops);
-	if (!tpci200->info->ipack_bus) {
-		dev_err(&pdev->dev,
-			"error registering the carrier on ipack driver\n");
-		ret = -EFAULT;
-		goto out_err_bus_register;
-	}
-
-	/* save the bus number given by ipack to logging purpose */
-	tpci200->number = tpci200->info->ipack_bus->bus_nr;
-	dev_set_drvdata(&pdev->dev, tpci200);
-
-	for (i = 0; i < TPCI200_NB_SLOT; i++)
-		tpci200_create_device(tpci200, i);
-	return 0;
-
-out_err_bus_register:
-	tpci200_uninstall(tpci200);
-out_err_install:
-	iounmap(tpci200->info->cfg_regs);
-out_err_ioremap:
-	pci_release_region(pdev, TPCI200_CFG_MEM_BAR);
-out_err_pci_request:
-	pci_dev_put(pdev);
-	kfree(tpci200->info);
-out_err_info:
-	kfree(tpci200);
-	return ret;
-}
-
-static void __tpci200_pci_remove(struct tpci200_board *tpci200)
-{
-	ipack_bus_unregister(tpci200->info->ipack_bus);
-	tpci200_uninstall(tpci200);
-
-	kfree(tpci200->info);
-	kfree(tpci200);
-}
-
-static void __devexit tpci200_pci_remove(struct pci_dev *dev)
-{
-	struct tpci200_board *tpci200 = pci_get_drvdata(dev);
-
-	__tpci200_pci_remove(tpci200);
-}
-
-static DEFINE_PCI_DEVICE_TABLE(tpci200_idtable) = {
-	{ TPCI200_VENDOR_ID, TPCI200_DEVICE_ID, TPCI200_SUBVENDOR_ID,
-	  TPCI200_SUBDEVICE_ID },
-	{ 0, },
-};
-
-MODULE_DEVICE_TABLE(pci, tpci200_idtable);
-
-static struct pci_driver tpci200_pci_drv = {
-	.name = "tpci200",
-	.id_table = tpci200_idtable,
-	.probe = tpci200_pci_probe,
-	.remove = __devexit_p(tpci200_pci_remove),
-};
-
-static int __init tpci200_drvr_init_module(void)
-{
-	return pci_register_driver(&tpci200_pci_drv);
-}
-
-static void __exit tpci200_drvr_exit_module(void)
-{
-	pci_unregister_driver(&tpci200_pci_drv);
-}
-
-MODULE_DESCRIPTION("TEWS TPCI-200 device driver");
-MODULE_LICENSE("GPL");
-module_init(tpci200_drvr_init_module);
-module_exit(tpci200_drvr_exit_module);
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
deleted file mode 100644
index 982f319..0000000
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ /dev/null
@@ -1,167 +0,0 @@
-/**
- * tpci200.h
- *
- * driver for the carrier TEWS TPCI-200
- * Copyright (c) 2009 Nicolas Serafini, EIC2 SA
- * Copyright (c) 2010,2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
- * Copyright (c) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; version 2 of the License.
- */
-
-#ifndef _TPCI200_H_
-#define _TPCI200_H_
-
-#include <linux/limits.h>
-#include <linux/pci.h>
-#include <linux/spinlock.h>
-#include <linux/swab.h>
-#include <linux/io.h>
-
-#include "../ipack.h"
-
-#define TPCI200_NB_SLOT               0x4
-#define TPCI200_NB_BAR                0x6
-
-#define TPCI200_VENDOR_ID             0x1498
-#define TPCI200_DEVICE_ID             0x30C8
-#define TPCI200_SUBVENDOR_ID          0x1498
-#define TPCI200_SUBDEVICE_ID          0x300A
-
-#define TPCI200_CFG_MEM_BAR           0
-#define TPCI200_IP_INTERFACE_BAR      2
-#define TPCI200_IO_ID_INT_SPACES_BAR  3
-#define TPCI200_MEM16_SPACE_BAR       4
-#define TPCI200_MEM8_SPACE_BAR        5
-
-struct tpci200_regs {
-	__le16	revision;
-	/* writes to control should occur with the mutex held to protect
-	 * read-modify-write operations */
-	__le16  control[4];
-	__le16	reset;
-	__le16	status;
-	u8	reserved[242];
-} __packed;
-
-#define TPCI200_IFACE_SIZE            0x100
-
-#define TPCI200_IO_SPACE_OFF          0x0000
-#define TPCI200_IO_SPACE_INTERVAL     0x0100
-#define TPCI200_IO_SPACE_SIZE         0x0080
-#define TPCI200_ID_SPACE_OFF          0x0080
-#define TPCI200_ID_SPACE_INTERVAL     0x0100
-#define TPCI200_ID_SPACE_SIZE         0x0040
-#define TPCI200_INT_SPACE_OFF         0x00C0
-#define TPCI200_INT_SPACE_INTERVAL    0x0100
-#define TPCI200_INT_SPACE_SIZE        0x0040
-#define TPCI200_IOIDINT_SIZE          0x0400
-
-#define TPCI200_MEM8_SPACE_INTERVAL   0x00400000
-#define TPCI200_MEM8_SPACE_SIZE       0x00400000
-#define TPCI200_MEM16_SPACE_INTERVAL  0x00800000
-#define TPCI200_MEM16_SPACE_SIZE      0x00800000
-
-/* control field in tpci200_regs */
-#define TPCI200_INT0_EN               0x0040
-#define TPCI200_INT1_EN               0x0080
-#define TPCI200_INT0_EDGE             0x0010
-#define TPCI200_INT1_EDGE             0x0020
-#define TPCI200_ERR_INT_EN            0x0008
-#define TPCI200_TIME_INT_EN           0x0004
-#define TPCI200_RECOVER_EN            0x0002
-#define TPCI200_CLK32                 0x0001
-
-/* reset field in tpci200_regs */
-#define TPCI200_A_RESET               0x0001
-#define TPCI200_B_RESET               0x0002
-#define TPCI200_C_RESET               0x0004
-#define TPCI200_D_RESET               0x0008
-
-/* status field in tpci200_regs */
-#define TPCI200_A_TIMEOUT             0x1000
-#define TPCI200_B_TIMEOUT             0x2000
-#define TPCI200_C_TIMEOUT             0x4000
-#define TPCI200_D_TIMEOUT             0x8000
-
-#define TPCI200_A_ERROR               0x0100
-#define TPCI200_B_ERROR               0x0200
-#define TPCI200_C_ERROR               0x0400
-#define TPCI200_D_ERROR               0x0800
-
-#define TPCI200_A_INT0                0x0001
-#define TPCI200_A_INT1                0x0002
-#define TPCI200_B_INT0                0x0004
-#define TPCI200_B_INT1                0x0008
-#define TPCI200_C_INT0                0x0010
-#define TPCI200_C_INT1                0x0020
-#define TPCI200_D_INT0                0x0040
-#define TPCI200_D_INT1                0x0080
-
-#define TPCI200_SLOT_INT_MASK         0x00FF
-
-/* PCI Configuration registers. The PCI bridge is a PLX Technology PCI9030. */
-#define LAS1_DESC		      0x2C
-#define LAS2_DESC		      0x30
-
-/* Bits in the LAS?_DESC registers */
-#define LAS_BIT_BIGENDIAN	      24
-
-#define VME_IOID_SPACE  "IOID"
-#define VME_MEM_SPACE  "MEM"
-
-/**
- * struct slot_irq - slot IRQ definition.
- * @vector	Vector number
- * @handler	Handler called when IRQ arrives
- * @arg		Handler argument
- *
- */
-struct slot_irq {
-	struct ipack_device *holder;
-	int		vector;
-	irqreturn_t	(*handler)(void *);
-	void		*arg;
-};
-
-/**
- * struct tpci200_slot - data specific to the tpci200 slot.
- * @slot_id	Slot identification gived to external interface
- * @irq		Slot IRQ infos
- * @io_phys	IO physical base address register of the slot
- * @id_phys	ID physical base address register of the slot
- * @int_phys	INT physical base address register of the slot
- * @mem_phys	MEM physical base address register of the slot
- *
- */
-struct tpci200_slot {
-	struct slot_irq	    *irq;
-};
-
-/**
- * struct tpci200_infos - informations specific of the TPCI200 tpci200.
- * @pci_dev		PCI device
- * @interface_regs	Pointer to IP interface space (Bar 2)
- * @ioidint_space	Pointer to IP ID, IO and INT space (Bar 3)
- * @mem8_space		Pointer to MEM space (Bar 4)
- *
- */
-struct tpci200_infos {
-	struct pci_dev			*pdev;
-	struct pci_device_id		*id_table;
-	struct tpci200_regs __iomem	*interface_regs;
-	void __iomem			*cfg_regs;
-	struct ipack_bus_device		*ipack_bus;
-};
-struct tpci200_board {
-	unsigned int		number;
-	struct mutex		mutex;
-	spinlock_t		regs_lock;
-	struct tpci200_slot	*slots;
-	struct tpci200_infos	*info;
-	phys_addr_t             mod_mem[IPACK_SPACE_COUNT];
-};
-
-#endif /* _TPCI200_H_ */
diff --git a/drivers/staging/ipack/carriers/Kconfig b/drivers/staging/ipack/carriers/Kconfig
new file mode 100644
index 0000000..33fdc24
--- /dev/null
+++ b/drivers/staging/ipack/carriers/Kconfig
@@ -0,0 +1,7 @@
+config BOARD_TPCI200
+	tristate "TEWS TPCI-200 support for IndustryPack bus"
+	depends on IPACK_BUS
+	depends on PCI
+	help
+	  This driver supports the TEWS TPCI200 device for the IndustryPack bus.
+	default n
diff --git a/drivers/staging/ipack/carriers/Makefile b/drivers/staging/ipack/carriers/Makefile
new file mode 100644
index 0000000..d8b7645
--- /dev/null
+++ b/drivers/staging/ipack/carriers/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_BOARD_TPCI200) += tpci200.o
diff --git a/drivers/staging/ipack/carriers/tpci200.c b/drivers/staging/ipack/carriers/tpci200.c
new file mode 100644
index 0000000..376e794
--- /dev/null
+++ b/drivers/staging/ipack/carriers/tpci200.c
@@ -0,0 +1,634 @@
+/**
+ * tpci200.c
+ *
+ * driver for the TEWS TPCI-200 device
+ * Copyright (c) 2009 Nicolas Serafini, EIC2 SA
+ * Copyright (c) 2010,2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
+ * Copyright (c) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; version 2 of the License.
+ */
+
+#include <linux/module.h>
+#include "tpci200.h"
+
+static const u16 tpci200_status_timeout[] = {
+	TPCI200_A_TIMEOUT,
+	TPCI200_B_TIMEOUT,
+	TPCI200_C_TIMEOUT,
+	TPCI200_D_TIMEOUT,
+};
+
+static const u16 tpci200_status_error[] = {
+	TPCI200_A_ERROR,
+	TPCI200_B_ERROR,
+	TPCI200_C_ERROR,
+	TPCI200_D_ERROR,
+};
+
+static const size_t tpci200_space_size[IPACK_SPACE_COUNT] = {
+	[IPACK_IO_SPACE]    = TPCI200_IO_SPACE_SIZE,
+	[IPACK_ID_SPACE]    = TPCI200_ID_SPACE_SIZE,
+	[IPACK_INT_SPACE]   = TPCI200_INT_SPACE_SIZE,
+	[IPACK_MEM8_SPACE]  = TPCI200_MEM8_SPACE_SIZE,
+	[IPACK_MEM16_SPACE] = TPCI200_MEM16_SPACE_SIZE,
+};
+
+static const size_t tpci200_space_interval[IPACK_SPACE_COUNT] = {
+	[IPACK_IO_SPACE]    = TPCI200_IO_SPACE_INTERVAL,
+	[IPACK_ID_SPACE]    = TPCI200_ID_SPACE_INTERVAL,
+	[IPACK_INT_SPACE]   = TPCI200_INT_SPACE_INTERVAL,
+	[IPACK_MEM8_SPACE]  = TPCI200_MEM8_SPACE_INTERVAL,
+	[IPACK_MEM16_SPACE] = TPCI200_MEM16_SPACE_INTERVAL,
+};
+
+static struct tpci200_board *check_slot(struct ipack_device *dev)
+{
+	struct tpci200_board *tpci200;
+
+	if (dev == NULL)
+		return NULL;
+
+
+	tpci200 = dev_get_drvdata(dev->bus->parent);
+
+	if (tpci200 == NULL) {
+		dev_info(&dev->dev, "carrier board not found\n");
+		return NULL;
+	}
+
+	if (dev->slot >= TPCI200_NB_SLOT) {
+		dev_info(&dev->dev,
+			 "Slot [%d:%d] doesn't exist! Last tpci200 slot is %d.\n",
+			 dev->bus->bus_nr, dev->slot, TPCI200_NB_SLOT-1);
+		return NULL;
+	}
+
+	return tpci200;
+}
+
+static void tpci200_clear_mask(struct tpci200_board *tpci200,
+			       __le16 __iomem *addr, u16 mask)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&tpci200->regs_lock, flags);
+	iowrite16(ioread16(addr) & (~mask), addr);
+	spin_unlock_irqrestore(&tpci200->regs_lock, flags);
+}
+
+static void tpci200_set_mask(struct tpci200_board *tpci200,
+			     __le16 __iomem *addr, u16 mask)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&tpci200->regs_lock, flags);
+	iowrite16(ioread16(addr) | mask, addr);
+	spin_unlock_irqrestore(&tpci200->regs_lock, flags);
+}
+
+static void tpci200_unregister(struct tpci200_board *tpci200)
+{
+	free_irq(tpci200->info->pdev->irq, (void *) tpci200);
+
+	pci_iounmap(tpci200->info->pdev, tpci200->info->interface_regs);
+	pci_iounmap(tpci200->info->pdev, tpci200->info->cfg_regs);
+
+	pci_release_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR);
+	pci_release_region(tpci200->info->pdev, TPCI200_IO_ID_INT_SPACES_BAR);
+	pci_release_region(tpci200->info->pdev, TPCI200_MEM16_SPACE_BAR);
+	pci_release_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR);
+	pci_release_region(tpci200->info->pdev, TPCI200_CFG_MEM_BAR);
+
+	pci_disable_device(tpci200->info->pdev);
+	pci_dev_put(tpci200->info->pdev);
+}
+
+static void tpci200_enable_irq(struct tpci200_board *tpci200,
+			       int islot)
+{
+	tpci200_set_mask(tpci200,
+			&tpci200->info->interface_regs->control[islot],
+			TPCI200_INT0_EN | TPCI200_INT1_EN);
+}
+
+static void tpci200_disable_irq(struct tpci200_board *tpci200,
+				int islot)
+{
+	tpci200_clear_mask(tpci200,
+			&tpci200->info->interface_regs->control[islot],
+			TPCI200_INT0_EN | TPCI200_INT1_EN);
+}
+
+static irqreturn_t tpci200_slot_irq(struct slot_irq *slot_irq)
+{
+	irqreturn_t ret;
+
+	if (!slot_irq)
+		return -ENODEV;
+	ret = slot_irq->handler(slot_irq->arg);
+
+	return ret;
+}
+
+static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
+{
+	struct tpci200_board *tpci200 = (struct tpci200_board *) dev_id;
+	struct slot_irq *slot_irq;
+	irqreturn_t ret;
+	u16 status_reg;
+	int i;
+
+	/* Read status register */
+	status_reg = ioread16(&tpci200->info->interface_regs->status);
+
+	/* Did we cause the interrupt? */
+	if (!(status_reg & TPCI200_SLOT_INT_MASK))
+		return IRQ_NONE;
+
+	/* callback to the IRQ handler for the corresponding slot */
+	rcu_read_lock();
+	for (i = 0; i < TPCI200_NB_SLOT; i++) {
+		if (!(status_reg & ((TPCI200_A_INT0 | TPCI200_A_INT1) << (2 * i))))
+			continue;
+		slot_irq = rcu_dereference(tpci200->slots[i].irq);
+		ret = tpci200_slot_irq(slot_irq);
+		if (ret == -ENODEV) {
+			dev_info(&tpci200->info->pdev->dev,
+				 "No registered ISR for slot [%d:%d]!. IRQ will be disabled.\n",
+				 tpci200->number, i);
+			tpci200_disable_irq(tpci200, i);
+		}
+	}
+	rcu_read_unlock();
+
+	return IRQ_HANDLED;
+}
+
+static int tpci200_free_irq(struct ipack_device *dev)
+{
+	struct slot_irq *slot_irq;
+	struct tpci200_board *tpci200;
+
+	tpci200 = check_slot(dev);
+	if (tpci200 == NULL)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&tpci200->mutex))
+		return -ERESTARTSYS;
+
+	if (tpci200->slots[dev->slot].irq == NULL) {
+		mutex_unlock(&tpci200->mutex);
+		return -EINVAL;
+	}
+
+	tpci200_disable_irq(tpci200, dev->slot);
+	slot_irq = tpci200->slots[dev->slot].irq;
+	/* uninstall handler */
+	RCU_INIT_POINTER(tpci200->slots[dev->slot].irq, NULL);
+	synchronize_rcu();
+	kfree(slot_irq);
+	mutex_unlock(&tpci200->mutex);
+	return 0;
+}
+
+static int tpci200_request_irq(struct ipack_device *dev,
+			       irqreturn_t (*handler)(void *), void *arg)
+{
+	int res = 0;
+	struct slot_irq *slot_irq;
+	struct tpci200_board *tpci200;
+
+	tpci200 = check_slot(dev);
+	if (tpci200 == NULL)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&tpci200->mutex))
+		return -ERESTARTSYS;
+
+	if (tpci200->slots[dev->slot].irq != NULL) {
+		dev_err(&dev->dev,
+			"Slot [%d:%d] IRQ already registered !\n", dev->bus->bus_nr,
+			dev->slot);
+		res = -EINVAL;
+		goto out_unlock;
+	}
+
+	slot_irq = kzalloc(sizeof(struct slot_irq), GFP_KERNEL);
+	if (slot_irq == NULL) {
+		dev_err(&dev->dev,
+			"Slot [%d:%d] unable to allocate memory for IRQ !\n",
+			dev->bus->bus_nr, dev->slot);
+		res = -ENOMEM;
+		goto out_unlock;
+	}
+
+	/*
+	 * WARNING: Setup Interrupt Vector in the IndustryPack device
+	 * before an IRQ request.
+	 * Read the User Manual of your IndustryPack device to know
+	 * where to write the vector in memory.
+	 */
+	slot_irq->handler = handler;
+	slot_irq->arg = arg;
+	slot_irq->holder = dev;
+
+	rcu_assign_pointer(tpci200->slots[dev->slot].irq, slot_irq);
+	tpci200_enable_irq(tpci200, dev->slot);
+
+out_unlock:
+	mutex_unlock(&tpci200->mutex);
+	return res;
+}
+
+static int tpci200_register(struct tpci200_board *tpci200)
+{
+	int i;
+	int res;
+	phys_addr_t ioidint_base;
+	unsigned short slot_ctrl;
+
+	if (pci_enable_device(tpci200->info->pdev) < 0)
+		return -ENODEV;
+
+	/* Request IP interface register (Bar 2) */
+	res = pci_request_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR,
+				 "Carrier IP interface registers");
+	if (res) {
+		dev_err(&tpci200->info->pdev->dev,
+			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 2 !",
+			tpci200->info->pdev->bus->number,
+			tpci200->info->pdev->devfn);
+		goto out_disable_pci;
+	}
+
+	/* Request IO ID INT space (Bar 3) */
+	res = pci_request_region(tpci200->info->pdev,
+				 TPCI200_IO_ID_INT_SPACES_BAR,
+				 "Carrier IO ID INT space");
+	if (res) {
+		dev_err(&tpci200->info->pdev->dev,
+			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 3 !",
+			tpci200->info->pdev->bus->number,
+			tpci200->info->pdev->devfn);
+		goto out_release_ip_space;
+	}
+
+	/* Request MEM8 space (Bar 5) */
+	res = pci_request_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR,
+				 "Carrier MEM8 space");
+	if (res) {
+		dev_err(&tpci200->info->pdev->dev,
+			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 5!",
+			tpci200->info->pdev->bus->number,
+			tpci200->info->pdev->devfn);
+		goto out_release_ioid_int_space;
+	}
+
+	/* Request MEM16 space (Bar 4) */
+	res = pci_request_region(tpci200->info->pdev, TPCI200_MEM16_SPACE_BAR,
+				 "Carrier MEM16 space");
+	if (res) {
+		dev_err(&tpci200->info->pdev->dev,
+			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 4!",
+			tpci200->info->pdev->bus->number,
+			tpci200->info->pdev->devfn);
+		goto out_release_mem8_space;
+	}
+
+	/* Map internal tpci200 driver user space */
+	tpci200->info->interface_regs =
+		ioremap_nocache(pci_resource_start(tpci200->info->pdev,
+					   TPCI200_IP_INTERFACE_BAR),
+			TPCI200_IFACE_SIZE);
+
+	/* Initialize lock that protects interface_regs */
+	spin_lock_init(&tpci200->regs_lock);
+
+	ioidint_base = pci_resource_start(tpci200->info->pdev,
+					  TPCI200_IO_ID_INT_SPACES_BAR);
+	tpci200->mod_mem[IPACK_IO_SPACE] = ioidint_base + TPCI200_IO_SPACE_OFF;
+	tpci200->mod_mem[IPACK_ID_SPACE] = ioidint_base + TPCI200_ID_SPACE_OFF;
+	tpci200->mod_mem[IPACK_INT_SPACE] =
+		ioidint_base + TPCI200_INT_SPACE_OFF;
+	tpci200->mod_mem[IPACK_MEM8_SPACE] =
+		pci_resource_start(tpci200->info->pdev,
+				   TPCI200_MEM8_SPACE_BAR);
+	tpci200->mod_mem[IPACK_MEM16_SPACE] =
+		pci_resource_start(tpci200->info->pdev,
+				   TPCI200_MEM16_SPACE_BAR);
+
+	/* Set the default parameters of the slot
+	 * INT0 disabled, level sensitive
+	 * INT1 disabled, level sensitive
+	 * error interrupt disabled
+	 * timeout interrupt disabled
+	 * recover time disabled
+	 * clock rate 8 MHz
+	 */
+	slot_ctrl = 0;
+	for (i = 0; i < TPCI200_NB_SLOT; i++)
+		writew(slot_ctrl, &tpci200->info->interface_regs->control[i]);
+
+	res = request_irq(tpci200->info->pdev->irq,
+			  tpci200_interrupt, IRQF_SHARED,
+			  KBUILD_MODNAME, (void *) tpci200);
+	if (res) {
+		dev_err(&tpci200->info->pdev->dev,
+			"(bn 0x%X, sn 0x%X) unable to register IRQ !",
+			tpci200->info->pdev->bus->number,
+			tpci200->info->pdev->devfn);
+		goto out_release_ioid_int_space;
+	}
+
+	return 0;
+
+out_release_mem8_space:
+	pci_release_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR);
+out_release_ioid_int_space:
+	pci_release_region(tpci200->info->pdev, TPCI200_IO_ID_INT_SPACES_BAR);
+out_release_ip_space:
+	pci_release_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR);
+out_disable_pci:
+	pci_disable_device(tpci200->info->pdev);
+	return res;
+}
+
+static int tpci200_get_clockrate(struct ipack_device *dev)
+{
+	struct tpci200_board *tpci200 = check_slot(dev);
+	__le16 __iomem *addr;
+
+	if (!tpci200)
+		return -ENODEV;
+
+	addr = &tpci200->info->interface_regs->control[dev->slot];
+	return (ioread16(addr) & TPCI200_CLK32) ? 32 : 8;
+}
+
+static int tpci200_set_clockrate(struct ipack_device *dev, int mherz)
+{
+	struct tpci200_board *tpci200 = check_slot(dev);
+	__le16 __iomem *addr;
+
+	if (!tpci200)
+		return -ENODEV;
+
+	addr = &tpci200->info->interface_regs->control[dev->slot];
+
+	switch (mherz) {
+	case 8:
+		tpci200_clear_mask(tpci200, addr, TPCI200_CLK32);
+		break;
+	case 32:
+		tpci200_set_mask(tpci200, addr, TPCI200_CLK32);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int tpci200_get_error(struct ipack_device *dev)
+{
+	struct tpci200_board *tpci200 = check_slot(dev);
+	__le16 __iomem *addr;
+	u16 mask;
+
+	if (!tpci200)
+		return -ENODEV;
+
+	addr = &tpci200->info->interface_regs->status;
+	mask = tpci200_status_error[dev->slot];
+	return (ioread16(addr) & mask) ? 1 : 0;
+}
+
+static int tpci200_get_timeout(struct ipack_device *dev)
+{
+	struct tpci200_board *tpci200 = check_slot(dev);
+	__le16 __iomem *addr;
+	u16 mask;
+
+	if (!tpci200)
+		return -ENODEV;
+
+	addr = &tpci200->info->interface_regs->status;
+	mask = tpci200_status_timeout[dev->slot];
+
+	return (ioread16(addr) & mask) ? 1 : 0;
+}
+
+static int tpci200_reset_timeout(struct ipack_device *dev)
+{
+	struct tpci200_board *tpci200 = check_slot(dev);
+	__le16 __iomem *addr;
+	u16 mask;
+
+	if (!tpci200)
+		return -ENODEV;
+
+	addr = &tpci200->info->interface_regs->status;
+	mask = tpci200_status_timeout[dev->slot];
+
+	iowrite16(mask, addr);
+	return 0;
+}
+
+static void tpci200_uninstall(struct tpci200_board *tpci200)
+{
+	tpci200_unregister(tpci200);
+	kfree(tpci200->slots);
+}
+
+static const struct ipack_bus_ops tpci200_bus_ops = {
+	.request_irq = tpci200_request_irq,
+	.free_irq = tpci200_free_irq,
+	.get_clockrate = tpci200_get_clockrate,
+	.set_clockrate = tpci200_set_clockrate,
+	.get_error     = tpci200_get_error,
+	.get_timeout   = tpci200_get_timeout,
+	.reset_timeout = tpci200_reset_timeout,
+};
+
+static int tpci200_install(struct tpci200_board *tpci200)
+{
+	int res;
+
+	tpci200->slots = kzalloc(
+		TPCI200_NB_SLOT * sizeof(struct tpci200_slot), GFP_KERNEL);
+	if (tpci200->slots == NULL)
+		return -ENOMEM;
+
+	res = tpci200_register(tpci200);
+	if (res) {
+		kfree(tpci200->slots);
+		tpci200->slots = NULL;
+		return res;
+	}
+
+	mutex_init(&tpci200->mutex);
+	return 0;
+}
+
+static void tpci200_release_device(struct ipack_device *dev)
+{
+	kfree(dev);
+}
+
+static int tpci200_create_device(struct tpci200_board *tpci200, int i)
+{
+	enum ipack_space space;
+	struct ipack_device *dev =
+		kzalloc(sizeof(struct ipack_device), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+	dev->slot = i;
+	dev->bus = tpci200->info->ipack_bus;
+	dev->release = tpci200_release_device;
+
+	for (space = 0; space < IPACK_SPACE_COUNT; space++) {
+		dev->region[space].start =
+			tpci200->mod_mem[space]
+			+ tpci200_space_interval[space] * i;
+		dev->region[space].size = tpci200_space_size[space];
+	}
+	return ipack_device_register(dev);
+}
+
+static int tpci200_pci_probe(struct pci_dev *pdev,
+			     const struct pci_device_id *id)
+{
+	int ret, i;
+	struct tpci200_board *tpci200;
+	u32 reg32;
+
+	tpci200 = kzalloc(sizeof(struct tpci200_board), GFP_KERNEL);
+	if (!tpci200)
+		return -ENOMEM;
+
+	tpci200->info = kzalloc(sizeof(struct tpci200_infos), GFP_KERNEL);
+	if (!tpci200->info) {
+		ret = -ENOMEM;
+		goto out_err_info;
+	}
+
+	pci_dev_get(pdev);
+
+	/* Obtain a mapping of the carrier's PCI configuration registers */
+	ret = pci_request_region(pdev, TPCI200_CFG_MEM_BAR,
+				 KBUILD_MODNAME " Configuration Memory");
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to allocate PCI Configuration Memory");
+		ret = -EBUSY;
+		goto out_err_pci_request;
+	}
+	tpci200->info->cfg_regs = ioremap_nocache(
+			pci_resource_start(pdev, TPCI200_CFG_MEM_BAR),
+			pci_resource_len(pdev, TPCI200_CFG_MEM_BAR));
+	if (!tpci200->info->cfg_regs) {
+		dev_err(&pdev->dev, "Failed to map PCI Configuration Memory");
+		ret = -EFAULT;
+		goto out_err_ioremap;
+	}
+
+	/* Disable byte swapping for 16 bit IP module access. This will ensure
+	 * that the Industrypack big endian byte order is preserved by the
+	 * carrier. */
+	reg32 = ioread32(tpci200->info->cfg_regs + LAS1_DESC);
+	reg32 |= 1 << LAS_BIT_BIGENDIAN;
+	iowrite32(reg32, tpci200->info->cfg_regs + LAS1_DESC);
+
+	reg32 = ioread32(tpci200->info->cfg_regs + LAS2_DESC);
+	reg32 |= 1 << LAS_BIT_BIGENDIAN;
+	iowrite32(reg32, tpci200->info->cfg_regs + LAS2_DESC);
+
+	/* Save struct pci_dev pointer */
+	tpci200->info->pdev = pdev;
+	tpci200->info->id_table = (struct pci_device_id *)id;
+
+	/* register the device and initialize it */
+	ret = tpci200_install(tpci200);
+	if (ret) {
+		dev_err(&pdev->dev, "error during tpci200 install\n");
+		ret = -ENODEV;
+		goto out_err_install;
+	}
+
+	/* Register the carrier in the industry pack bus driver */
+	tpci200->info->ipack_bus = ipack_bus_register(&pdev->dev,
+						      TPCI200_NB_SLOT,
+						      &tpci200_bus_ops);
+	if (!tpci200->info->ipack_bus) {
+		dev_err(&pdev->dev,
+			"error registering the carrier on ipack driver\n");
+		ret = -EFAULT;
+		goto out_err_bus_register;
+	}
+
+	/* save the bus number given by ipack to logging purpose */
+	tpci200->number = tpci200->info->ipack_bus->bus_nr;
+	dev_set_drvdata(&pdev->dev, tpci200);
+
+	for (i = 0; i < TPCI200_NB_SLOT; i++)
+		tpci200_create_device(tpci200, i);
+	return 0;
+
+out_err_bus_register:
+	tpci200_uninstall(tpci200);
+out_err_install:
+	iounmap(tpci200->info->cfg_regs);
+out_err_ioremap:
+	pci_release_region(pdev, TPCI200_CFG_MEM_BAR);
+out_err_pci_request:
+	pci_dev_put(pdev);
+	kfree(tpci200->info);
+out_err_info:
+	kfree(tpci200);
+	return ret;
+}
+
+static void __tpci200_pci_remove(struct tpci200_board *tpci200)
+{
+	ipack_bus_unregister(tpci200->info->ipack_bus);
+	tpci200_uninstall(tpci200);
+
+	kfree(tpci200->info);
+	kfree(tpci200);
+}
+
+static void __devexit tpci200_pci_remove(struct pci_dev *dev)
+{
+	struct tpci200_board *tpci200 = pci_get_drvdata(dev);
+
+	__tpci200_pci_remove(tpci200);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(tpci200_idtable) = {
+	{ TPCI200_VENDOR_ID, TPCI200_DEVICE_ID, TPCI200_SUBVENDOR_ID,
+	  TPCI200_SUBDEVICE_ID },
+	{ 0, },
+};
+
+MODULE_DEVICE_TABLE(pci, tpci200_idtable);
+
+static struct pci_driver tpci200_pci_drv = {
+	.name = "tpci200",
+	.id_table = tpci200_idtable,
+	.probe = tpci200_pci_probe,
+	.remove = __devexit_p(tpci200_pci_remove),
+};
+
+static int __init tpci200_drvr_init_module(void)
+{
+	return pci_register_driver(&tpci200_pci_drv);
+}
+
+static void __exit tpci200_drvr_exit_module(void)
+{
+	pci_unregister_driver(&tpci200_pci_drv);
+}
+
+MODULE_DESCRIPTION("TEWS TPCI-200 device driver");
+MODULE_LICENSE("GPL");
+module_init(tpci200_drvr_init_module);
+module_exit(tpci200_drvr_exit_module);
diff --git a/drivers/staging/ipack/carriers/tpci200.h b/drivers/staging/ipack/carriers/tpci200.h
new file mode 100644
index 0000000..982f319
--- /dev/null
+++ b/drivers/staging/ipack/carriers/tpci200.h
@@ -0,0 +1,167 @@
+/**
+ * tpci200.h
+ *
+ * driver for the carrier TEWS TPCI-200
+ * Copyright (c) 2009 Nicolas Serafini, EIC2 SA
+ * Copyright (c) 2010,2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
+ * Copyright (c) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; version 2 of the License.
+ */
+
+#ifndef _TPCI200_H_
+#define _TPCI200_H_
+
+#include <linux/limits.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/swab.h>
+#include <linux/io.h>
+
+#include "../ipack.h"
+
+#define TPCI200_NB_SLOT               0x4
+#define TPCI200_NB_BAR                0x6
+
+#define TPCI200_VENDOR_ID             0x1498
+#define TPCI200_DEVICE_ID             0x30C8
+#define TPCI200_SUBVENDOR_ID          0x1498
+#define TPCI200_SUBDEVICE_ID          0x300A
+
+#define TPCI200_CFG_MEM_BAR           0
+#define TPCI200_IP_INTERFACE_BAR      2
+#define TPCI200_IO_ID_INT_SPACES_BAR  3
+#define TPCI200_MEM16_SPACE_BAR       4
+#define TPCI200_MEM8_SPACE_BAR        5
+
+struct tpci200_regs {
+	__le16	revision;
+	/* writes to control should occur with the mutex held to protect
+	 * read-modify-write operations */
+	__le16  control[4];
+	__le16	reset;
+	__le16	status;
+	u8	reserved[242];
+} __packed;
+
+#define TPCI200_IFACE_SIZE            0x100
+
+#define TPCI200_IO_SPACE_OFF          0x0000
+#define TPCI200_IO_SPACE_INTERVAL     0x0100
+#define TPCI200_IO_SPACE_SIZE         0x0080
+#define TPCI200_ID_SPACE_OFF          0x0080
+#define TPCI200_ID_SPACE_INTERVAL     0x0100
+#define TPCI200_ID_SPACE_SIZE         0x0040
+#define TPCI200_INT_SPACE_OFF         0x00C0
+#define TPCI200_INT_SPACE_INTERVAL    0x0100
+#define TPCI200_INT_SPACE_SIZE        0x0040
+#define TPCI200_IOIDINT_SIZE          0x0400
+
+#define TPCI200_MEM8_SPACE_INTERVAL   0x00400000
+#define TPCI200_MEM8_SPACE_SIZE       0x00400000
+#define TPCI200_MEM16_SPACE_INTERVAL  0x00800000
+#define TPCI200_MEM16_SPACE_SIZE      0x00800000
+
+/* control field in tpci200_regs */
+#define TPCI200_INT0_EN               0x0040
+#define TPCI200_INT1_EN               0x0080
+#define TPCI200_INT0_EDGE             0x0010
+#define TPCI200_INT1_EDGE             0x0020
+#define TPCI200_ERR_INT_EN            0x0008
+#define TPCI200_TIME_INT_EN           0x0004
+#define TPCI200_RECOVER_EN            0x0002
+#define TPCI200_CLK32                 0x0001
+
+/* reset field in tpci200_regs */
+#define TPCI200_A_RESET               0x0001
+#define TPCI200_B_RESET               0x0002
+#define TPCI200_C_RESET               0x0004
+#define TPCI200_D_RESET               0x0008
+
+/* status field in tpci200_regs */
+#define TPCI200_A_TIMEOUT             0x1000
+#define TPCI200_B_TIMEOUT             0x2000
+#define TPCI200_C_TIMEOUT             0x4000
+#define TPCI200_D_TIMEOUT             0x8000
+
+#define TPCI200_A_ERROR               0x0100
+#define TPCI200_B_ERROR               0x0200
+#define TPCI200_C_ERROR               0x0400
+#define TPCI200_D_ERROR               0x0800
+
+#define TPCI200_A_INT0                0x0001
+#define TPCI200_A_INT1                0x0002
+#define TPCI200_B_INT0                0x0004
+#define TPCI200_B_INT1                0x0008
+#define TPCI200_C_INT0                0x0010
+#define TPCI200_C_INT1                0x0020
+#define TPCI200_D_INT0                0x0040
+#define TPCI200_D_INT1                0x0080
+
+#define TPCI200_SLOT_INT_MASK         0x00FF
+
+/* PCI Configuration registers. The PCI bridge is a PLX Technology PCI9030. */
+#define LAS1_DESC		      0x2C
+#define LAS2_DESC		      0x30
+
+/* Bits in the LAS?_DESC registers */
+#define LAS_BIT_BIGENDIAN	      24
+
+#define VME_IOID_SPACE  "IOID"
+#define VME_MEM_SPACE  "MEM"
+
+/**
+ * struct slot_irq - slot IRQ definition.
+ * @vector	Vector number
+ * @handler	Handler called when IRQ arrives
+ * @arg		Handler argument
+ *
+ */
+struct slot_irq {
+	struct ipack_device *holder;
+	int		vector;
+	irqreturn_t	(*handler)(void *);
+	void		*arg;
+};
+
+/**
+ * struct tpci200_slot - data specific to the tpci200 slot.
+ * @slot_id	Slot identification gived to external interface
+ * @irq		Slot IRQ infos
+ * @io_phys	IO physical base address register of the slot
+ * @id_phys	ID physical base address register of the slot
+ * @int_phys	INT physical base address register of the slot
+ * @mem_phys	MEM physical base address register of the slot
+ *
+ */
+struct tpci200_slot {
+	struct slot_irq	    *irq;
+};
+
+/**
+ * struct tpci200_infos - informations specific of the TPCI200 tpci200.
+ * @pci_dev		PCI device
+ * @interface_regs	Pointer to IP interface space (Bar 2)
+ * @ioidint_space	Pointer to IP ID, IO and INT space (Bar 3)
+ * @mem8_space		Pointer to MEM space (Bar 4)
+ *
+ */
+struct tpci200_infos {
+	struct pci_dev			*pdev;
+	struct pci_device_id		*id_table;
+	struct tpci200_regs __iomem	*interface_regs;
+	void __iomem			*cfg_regs;
+	struct ipack_bus_device		*ipack_bus;
+};
+struct tpci200_board {
+	unsigned int		number;
+	struct mutex		mutex;
+	spinlock_t		regs_lock;
+	struct tpci200_slot	*slots;
+	struct tpci200_infos	*info;
+	phys_addr_t             mod_mem[IPACK_SPACE_COUNT];
+};
+
+#endif /* _TPCI200_H_ */
-- 
1.7.10.4

