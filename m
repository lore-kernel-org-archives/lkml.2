Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab2EWJOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:14:39 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:41403 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751647Ab2EWJOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:14:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAI2pvE9bdWOb/2dsb2JhbABDtC2BB4IWAQUnUhBRVwYTiBK6WpBPA5Ucj3CCbA
X-IronPort-AV: E=Sophos;i="4.75,644,1330902000"; 
   d="scan'208";a="917470974"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Staging: ipack: fix failure registering an ipack device
Date: Wed, 23 May 2012 11:13:14 +0200
Message-Id: <1337764395-23200-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337764395-23200-1-git-send-email-siglesias@igalia.com>
References: <1337764395-23200-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to install an ipack device it always failed in the match() function. This
patch fixes all the bugs present there.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   60 +++++++++++--------------------
 drivers/staging/ipack/ipack.c           |    3 +-
 2 files changed, 22 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index c6cc67e..676f338 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -59,13 +59,6 @@ static struct tpci200_board *check_slot(struct ipack_device *dev)
 		return NULL;
 	}
 
-	BUG_ON(tpci200->slots == NULL);
-	if (tpci200->slots[dev->slot].dev == NULL) {
-		pr_info("Slot [%d:%d] is not registered !\n", dev->bus_nr,
-			dev->slot);
-		return NULL;
-	}
-
 	return tpci200;
 }
 
@@ -455,13 +448,6 @@ static int tpci200_register(struct tpci200_board *tpci200)
 
 		writew(slot_ctrl, (tpci200->info->interface_regs +
 				   control_reg[i]));
-		/*
-		 * Give the same IRQ number as the slot number.
-		 * The TPCI200 has assigned his own two IRQ by PCI bus driver
-		 */
-		tpci200->slots[i].dev =
-			ipack_device_register(tpci200->info->ipack_bus, i, i);
-
 	}
 
 	res = request_irq(tpci200->info->pdev->irq,
@@ -471,18 +457,11 @@ static int tpci200_register(struct tpci200_board *tpci200)
 		pr_err("(bn 0x%X, sn 0x%X) unable to register IRQ !",
 		       tpci200->info->pdev->bus->number,
 		       tpci200->info->pdev->devfn);
-		tpci200_unregister(tpci200);
-		goto out_err;
+		goto out_release_ioid_int_space;
 	}
 
 	return 0;
 
-out_err:
-	for (i = 0; i < TPCI200_NB_SLOT; i++) {
-		ipack_device_unregister(tpci200->slots[i].dev);
-		tpci200->slots[i].dev = NULL;
-	}
-
 out_release_ioid_int_space:
 	pci_release_region(tpci200->info->pdev, TPCI200_IO_ID_INT_SPACES_BAR);
 out_release_ip_space:
@@ -565,20 +544,15 @@ out:
 
 static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 {
-	int res;
 	struct ipack_addr_space *virt_addr_space;
 	struct tpci200_board *tpci200;
 
 	tpci200 = check_slot(dev);
-	if (tpci200 == NULL) {
-		res = -EINVAL;
-		goto out;
-	}
+	if (tpci200 == NULL)
+		return -EINVAL;
 
-	if (mutex_lock_interruptible(&tpci200->mutex)) {
-		res = -ERESTARTSYS;
-		goto out;
-	}
+	if (mutex_lock_interruptible(&tpci200->mutex))
+		return -ERESTARTSYS;
 
 	switch (space) {
 	case IPACK_IO_SPACE:
@@ -601,16 +575,15 @@ static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 		if (dev->mem_space.address == NULL) {
 			pr_info("Slot [%d:%d] MEM space not mapped !\n",
 				dev->bus_nr, dev->slot);
-		goto out_unlock;
+			goto out_unlock;
 		}
 		virt_addr_space = &dev->mem_space;
 		break;
 	default:
 		pr_err("Slot [%d:%d] space number %d doesn't exist !\n",
 		       dev->bus_nr, dev->slot, space);
-		res = -EINVAL;
-		goto out_unlock;
-		break;
+		mutex_unlock(&tpci200->mutex);
+		return -EINVAL;
 	}
 
 	iounmap(virt_addr_space->address);
@@ -619,8 +592,7 @@ static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 	virt_addr_space->size = 0;
 out_unlock:
 	mutex_unlock(&tpci200->mutex);
-out:
-	return res;
+	return 0;
 }
 
 static int tpci200_slot_unregister(struct ipack_device *dev)
@@ -649,7 +621,7 @@ static int tpci200_slot_unregister(struct ipack_device *dev)
 static int tpci200_slot_map_space(struct ipack_device *dev,
 				  unsigned int memory_size, int space)
 {
-	int res;
+	int res = 0;
 	unsigned int size_to_map;
 	void __iomem *phys_address;
 	struct ipack_addr_space *virt_addr_space;
@@ -785,6 +757,8 @@ out:
 static void tpci200_slot_remove(struct tpci200_slot *slot)
 {
 	if ((slot->dev == NULL) ||
+	    (slot->dev->driver == NULL) ||
+	    (slot->dev->driver->ops == NULL) ||
 	    (slot->dev->driver->ops->remove == NULL))
 		return;
 
@@ -844,7 +818,7 @@ out_err:
 static int tpci200_pciprobe(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
-	int ret;
+	int ret, i;
 	struct tpci200_board *tpci200;
 
 	tpci200 = kzalloc(sizeof(struct tpci200_board), GFP_KERNEL);
@@ -887,6 +861,14 @@ static int tpci200_pciprobe(struct pci_dev *pdev,
 	dev_set_drvdata(&pdev->dev, tpci200);
 	/* add the registered device in an internal linked list */
 	list_add_tail(&tpci200->list, &tpci200_list);
+
+	/*
+	 * Give the same IRQ number as the slot number.
+	 * The TPCI200 has assigned his own two IRQ by PCI bus driver
+	 */
+	for (i = 0; i < TPCI200_NB_SLOT; i++)
+		tpci200->slots[i].dev =
+			ipack_device_register(tpci200->info->ipack_bus, i, i);
 	return ret;
 }
 
diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index 2b4fa51..378c3e5 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -48,7 +48,7 @@ static int ipack_bus_match(struct device *device, struct device_driver *driver)
 	if (ret)
 		dev->driver = drv;
 
-	return 0;
+	return ret;
 }
 
 static int ipack_bus_probe(struct device *device)
@@ -172,7 +172,6 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
 	ret = device_register(&dev->dev);
 	if (ret < 0) {
 		pr_err("error registering the device.\n");
-		dev->driver->ops->remove(dev);
 		kfree(dev);
 		return NULL;
 	}
-- 
1.7.10

