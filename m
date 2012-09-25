Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2IYOdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:33:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59733 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab2IYOdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:33:19 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v3 1/7] PCI: make PCI device create/destroy logic symmetric
Date: Tue, 25 Sep 2012 22:29:24 +0800
Message-Id: <1348583370-11006-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Jiang Liu <jiang.liu@huawei.com>

According to device model documentation, the way to create/destroy PCI
devices should be symmetric.

/**
 * device_del - delete device from system.
 * @dev: device.
 *
 * This is the first part of the device unregistration
 * sequence. This removes the device from the lists we control
 * from here, has it removed from the other driver model
 * subsystems it was added to in device_add(), and removes it
 * from the kobject hierarchy.
 *
 * NOTE: this should be called manually _iff_ device_add() was
 * also called manually.
 */

The rule is to either use
1) device_register()/device_unregister()
or
2) device_initialize()/device_add()/device_del()/put_device().

So change PCI core logic to follow the rule and get rid of the redundant
pci_dev_get()/pci_dev_put() pair.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c  |    1 -
 drivers/pci/remove.c |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 2396111..5dbad03 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1293,7 +1293,6 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 {
 	device_initialize(&dev->dev);
 	dev->dev.release = pci_release_dev;
-	pci_dev_get(dev);
 
 	dev->dev.dma_mask = &dev->dma_mask;
 	dev->dev.dma_parms = &dev->dma_parms;
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 513972f..10693f5 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -22,7 +22,7 @@ static void pci_stop_dev(struct pci_dev *dev)
 	if (dev->is_added) {
 		pci_proc_detach_device(dev);
 		pci_remove_sysfs_dev_files(dev);
-		device_unregister(&dev->dev);
+		device_del(&dev->dev);
 		dev->is_added = 0;
 	}
 
@@ -37,7 +37,7 @@ static void pci_destroy_dev(struct pci_dev *dev)
 	up_write(&pci_bus_sem);
 
 	pci_free_resources(dev);
-	pci_dev_put(dev);
+	put_device(&dev->dev);
 }
 
 void pci_remove_bus(struct pci_bus *bus)
-- 
1.7.9.5

