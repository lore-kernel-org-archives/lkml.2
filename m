Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab2I0Kkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:40:42 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:33408 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab2I0Kg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:36:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkECAEQrZFBbdWObgWdsb2JhbABFvg8jAQEWJieCIAEBBSdSECAxVwYTiAm3b5E1A5VpkxQ
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447820"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 11/17] Staging: ipack: remove memory mapping callbacks.
Date: Thu, 27 Sep 2012 12:37:35 +0200
Message-Id: <1348742261-28145-11-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Now that we have the infrastructure to use the regular function in place
and all existing users are converted, remove the map and unmap callbacks
from the ipack_bus_device->ops.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |  200 +------------------------------
 drivers/staging/ipack/bridges/tpci200.h |    4 -
 drivers/staging/ipack/ipack.h           |   17 ---
 3 files changed, 1 insertion(+), 220 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 8428e3b..901f657 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -87,8 +87,6 @@ static void tpci200_set_mask(struct tpci200_board *tpci200,
 
 static void tpci200_unregister(struct tpci200_board *tpci200)
 {
-	int i;
-
 	free_irq(tpci200->info->pdev->irq, (void *) tpci200);
 
 	pci_iounmap(tpci200->info->pdev, tpci200->info->interface_regs);
@@ -101,17 +99,6 @@ static void tpci200_unregister(struct tpci200_board *tpci200)
 
 	pci_disable_device(tpci200->info->pdev);
 	pci_dev_put(tpci200->info->pdev);
-
-	for (i = 0; i < TPCI200_NB_SLOT; i++) {
-		tpci200->slots[i].io_phys.start = 0;
-		tpci200->slots[i].io_phys.size = 0;
-		tpci200->slots[i].id_phys.start = 0;
-		tpci200->slots[i].id_phys.size = 0;
-		tpci200->slots[i].int_phys.start = 0;
-		tpci200->slots[i].int_phys.size = 0;
-		tpci200->slots[i].mem_phys.start = 0;
-		tpci200->slots[i].mem_phys.size = 0;
-	}
 }
 
 static void tpci200_enable_irq(struct tpci200_board *tpci200,
@@ -323,31 +310,8 @@ static int tpci200_register(struct tpci200_board *tpci200)
 	 * clock rate 8 MHz
 	 */
 	slot_ctrl = 0;
-
-	/* Set all slot physical address space */
-	for (i = 0; i < TPCI200_NB_SLOT; i++) {
-		tpci200->slots[i].io_phys.start =
-			tpci200->mod_mem[IPACK_IO_SPACE]
-			+ TPCI200_IO_SPACE_INTERVAL * i;
-		tpci200->slots[i].io_phys.size = TPCI200_IO_SPACE_SIZE;
-
-		tpci200->slots[i].id_phys.start =
-			tpci200->mod_mem[IPACK_ID_SPACE]
-			+ TPCI200_ID_SPACE_INTERVAL * i;
-		tpci200->slots[i].id_phys.size = TPCI200_ID_SPACE_SIZE;
-
-		tpci200->slots[i].int_phys.start =
-			tpci200->mod_mem[IPACK_INT_SPACE]
-			+ TPCI200_INT_SPACE_INTERVAL * i;
-		tpci200->slots[i].int_phys.size = TPCI200_INT_SPACE_SIZE;
-
-		tpci200->slots[i].mem_phys.start =
-			tpci200->mod_mem[IPACK_MEM_SPACE]
-			+ TPCI200_MEM8_SPACE_INTERVAL * i;
-		tpci200->slots[i].mem_phys.size = TPCI200_MEM8_SPACE_SIZE;
-
+	for (i = 0; i < TPCI200_NB_SLOT; i++)
 		writew(slot_ctrl, &tpci200->info->interface_regs->control[i]);
-	}
 
 	res = request_irq(tpci200->info->pdev->irq,
 			  tpci200_interrupt, IRQF_SHARED,
@@ -371,166 +335,6 @@ out_disable_pci:
 	return res;
 }
 
-static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
-{
-	struct ipack_addr_space *virt_addr_space;
-	struct tpci200_board *tpci200;
-
-	tpci200 = check_slot(dev);
-	if (tpci200 == NULL)
-		return -EINVAL;
-
-	if (mutex_lock_interruptible(&tpci200->mutex))
-		return -ERESTARTSYS;
-
-	switch (space) {
-	case IPACK_IO_SPACE:
-		if (dev->io_space.address == NULL) {
-			dev_info(&dev->dev,
-				 "Slot [%d:%d] IO space not mapped !\n",
-				 dev->bus->bus_nr, dev->slot);
-			goto out_unlock;
-		}
-		virt_addr_space = &dev->io_space;
-		break;
-	case IPACK_ID_SPACE:
-		if (dev->id_space.address == NULL) {
-			dev_info(&dev->dev,
-				 "Slot [%d:%d] ID space not mapped !\n",
-				 dev->bus->bus_nr, dev->slot);
-			goto out_unlock;
-		}
-		virt_addr_space = &dev->id_space;
-		break;
-	case IPACK_INT_SPACE:
-		if (dev->int_space.address == NULL) {
-			dev_info(&dev->dev,
-				 "Slot [%d:%d] INT space not mapped !\n",
-				 dev->bus->bus_nr, dev->slot);
-			goto out_unlock;
-		}
-		virt_addr_space = &dev->int_space;
-		break;
-	case IPACK_MEM_SPACE:
-		if (dev->mem_space.address == NULL) {
-			dev_info(&dev->dev,
-				 "Slot [%d:%d] MEM space not mapped !\n",
-				 dev->bus->bus_nr, dev->slot);
-			goto out_unlock;
-		}
-		virt_addr_space = &dev->mem_space;
-		break;
-	default:
-		dev_err(&dev->dev,
-			"Slot [%d:%d] space number %d doesn't exist !\n",
-			dev->bus->bus_nr, dev->slot, space);
-		mutex_unlock(&tpci200->mutex);
-		return -EINVAL;
-	}
-
-	iounmap(virt_addr_space->address);
-
-	virt_addr_space->address = NULL;
-	virt_addr_space->size = 0;
-out_unlock:
-	mutex_unlock(&tpci200->mutex);
-	return 0;
-}
-
-static int tpci200_slot_map_space(struct ipack_device *dev,
-				  ssize_t memory_size, int space)
-{
-	int res = 0;
-	size_t size_to_map;
-	phys_addr_t phys_address;
-	struct ipack_addr_space *virt_addr_space;
-	struct tpci200_board *tpci200;
-
-	tpci200 = check_slot(dev);
-	if (tpci200 == NULL)
-		return -EINVAL;
-
-	if (mutex_lock_interruptible(&tpci200->mutex))
-		return -ERESTARTSYS;
-
-	switch (space) {
-	case IPACK_IO_SPACE:
-		if (dev->io_space.address != NULL) {
-			dev_err(&dev->dev,
-				"Slot [%d:%d] IO space already mapped !\n",
-				tpci200->number, dev->slot);
-			res = -EINVAL;
-			goto out_unlock;
-		}
-		virt_addr_space = &dev->io_space;
-
-		phys_address = tpci200->slots[dev->slot].io_phys.start;
-		size_to_map = tpci200->slots[dev->slot].io_phys.size;
-		break;
-	case IPACK_ID_SPACE:
-		if (dev->id_space.address != NULL) {
-			dev_err(&dev->dev,
-				"Slot [%d:%d] ID space already mapped !\n",
-				tpci200->number, dev->slot);
-			res = -EINVAL;
-			goto out_unlock;
-		}
-		virt_addr_space = &dev->id_space;
-
-		phys_address = tpci200->slots[dev->slot].id_phys.start;
-		size_to_map = tpci200->slots[dev->slot].id_phys.size;
-		break;
-	case IPACK_INT_SPACE:
-		if (dev->int_space.address != NULL) {
-			dev_err(&dev->dev,
-				"Slot [%d:%d] INT space already mapped !\n",
-				tpci200->number, dev->slot);
-			res = -EINVAL;
-			goto out_unlock;
-		}
-		virt_addr_space = &dev->int_space;
-
-		phys_address = tpci200->slots[dev->slot].int_phys.start;
-		size_to_map = tpci200->slots[dev->slot].int_phys.size;
-		break;
-	case IPACK_MEM_SPACE:
-		if (dev->mem_space.address != NULL) {
-			dev_err(&dev->dev,
-				"Slot [%d:%d] MEM space already mapped !\n",
-				tpci200->number, dev->slot);
-			res = -EINVAL;
-			goto out_unlock;
-		}
-		virt_addr_space = &dev->mem_space;
-
-		if (memory_size > tpci200->slots[dev->slot].mem_phys.size) {
-			dev_err(&dev->dev,
-				"Slot [%d:%d] request is 0x%zX memory, only 0x%zX available !\n",
-				dev->bus->bus_nr, dev->slot, memory_size,
-				tpci200->slots[dev->slot].mem_phys.size);
-			res = -EINVAL;
-			goto out_unlock;
-		}
-
-		phys_address = tpci200->slots[dev->slot].mem_phys.start;
-		size_to_map = memory_size;
-		break;
-	default:
-		dev_err(&dev->dev, "Slot [%d:%d] space %d doesn't exist !\n",
-			tpci200->number, dev->slot, space);
-		res = -EINVAL;
-		goto out_unlock;
-	}
-
-	virt_addr_space->size = size_to_map;
-	virt_addr_space->address =
-		ioremap_nocache((unsigned long)phys_address, size_to_map);
-
-out_unlock:
-	mutex_unlock(&tpci200->mutex);
-	return res;
-}
-
 static int tpci200_get_clockrate(struct ipack_device *dev)
 {
 	struct tpci200_board *tpci200 = check_slot(dev);
@@ -618,8 +422,6 @@ static void tpci200_uninstall(struct tpci200_board *tpci200)
 }
 
 static const struct ipack_bus_ops tpci200_bus_ops = {
-	.map_space = tpci200_slot_map_space,
-	.unmap_space = tpci200_slot_unmap_space,
 	.request_irq = tpci200_request_irq,
 	.free_irq = tpci200_free_irq,
 	.get_clockrate = tpci200_get_clockrate,
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index fe8e97e..982f319 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -138,10 +138,6 @@ struct slot_irq {
  */
 struct tpci200_slot {
 	struct slot_irq	    *irq;
-	struct ipack_region  io_phys;
-	struct ipack_region  id_phys;
-	struct ipack_region  int_phys;
-	struct ipack_region  mem_phys;
 };
 
 /**
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index 43d152a..af95028 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -42,17 +42,6 @@ enum ipack_space {
 };
 
 /**
- *	struct ipack_addr_space - Virtual address space mapped for a specified type.
- *
- *	@address: virtual address
- *	@size: size of the mapped space
- */
-struct ipack_addr_space {
-	void __iomem *address;
-	unsigned int size;
-};
-
-/**
  */
 struct ipack_region {
 	phys_addr_t start;
@@ -76,10 +65,6 @@ struct ipack_region {
 struct ipack_device {
 	unsigned int slot;
 	struct ipack_bus_device *bus;
-	struct ipack_addr_space id_space;
-	struct ipack_addr_space io_space;
-	struct ipack_addr_space int_space;
-	struct ipack_addr_space mem_space;
 	struct device dev;
 	void (*release) (struct ipack_device *dev);
 	struct ipack_region      region[IPACK_SPACE_COUNT];
@@ -135,8 +120,6 @@ struct ipack_driver {
  *	@reset_timeout: Resets the state returned by get_timeout.
  */
 struct ipack_bus_ops {
-	int (*map_space) (struct ipack_device *dev, ssize_t memory_size, int space);
-	int (*unmap_space) (struct ipack_device *dev, int space);
 	int (*request_irq) (struct ipack_device *dev,
 			    irqreturn_t (*handler)(void *), void *arg);
 	int (*free_irq) (struct ipack_device *dev);
-- 
1.7.10.4

