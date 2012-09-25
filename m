Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab2IYOdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:33:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36607 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab2IYOdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:33:32 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v3 2/7] PCI: split registration of PCI bus devices into two stages
Date: Tue, 25 Sep 2012 22:29:25 +0800
Message-Id: <1348583370-11006-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348583370-11006-1-git-send-email-jiang.liu@huawei.com>
References: <1348583370-11006-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Jiang Liu <jiang.liu@huawei.com>

When handling BUS_NOTIFY_ADD_DEVICE event for a PCI bridge device,
the notification handler can't hold reference count to the new PCI bus
because the device object for the new bus (pci_dev->subordinate->dev)
hasn't been initialized yet.

Split the registration of PCI bus device into two stages as below,
so that the event handler could hold reference count to the new PCI bus
when handling BUS_NOTIFY_ADD_DEVICE event.

1) device_initialize(&pci_dev->dev)
2) device_initialize(&pci_dev->subordinate->dev)
3) notify BUS_NOTIFY_ADD_DEVICE event for pci_dev
4) device_add(&pci_dev->dev)
5) device_add(&pci_dev->subordinate->dev)

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/bus.c    |    2 +-
 drivers/pci/probe.c  |    4 +++-
 drivers/pci/remove.c |   10 +++++-----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 4b0970b..11a5c28 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -189,7 +189,7 @@ int pci_bus_add_child(struct pci_bus *bus)
 	if (bus->bridge)
 		bus->dev.parent = bus->bridge;
 
-	retval = device_register(&bus->dev);
+	retval = device_add(&bus->dev);
 	if (retval)
 		return retval;
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5dbad03..7ef8c1b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -639,6 +639,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	 */
 	child->dev.class = &pcibus_class;
 	dev_set_name(&child->dev, "%04x:%02x", pci_domain_nr(child), busnr);
+	device_initialize(&child->dev);
 
 	/*
 	 * Set up the primary, secondary and subordinate
@@ -1672,7 +1673,8 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	b->dev.class = &pcibus_class;
 	b->dev.parent = b->bridge;
 	dev_set_name(&b->dev, "%04x:%02x", pci_domain_nr(b), bus);
-	error = device_register(&b->dev);
+	device_initialize(&b->dev);
+	error = device_add(&b->dev);
 	if (error)
 		goto class_dev_reg_err;
 
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 10693f5..0d03026 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -48,11 +48,11 @@ void pci_remove_bus(struct pci_bus *bus)
 	list_del(&bus->node);
 	pci_bus_release_busn_res(bus);
 	up_write(&pci_bus_sem);
-	if (!bus->is_added)
-		return;
-
-	pci_remove_legacy_files(bus);
-	device_unregister(&bus->dev);
+	if (bus->is_added) {
+		pci_remove_legacy_files(bus);
+		device_del(&bus->dev);
+	}
+	put_device(&bus->dev);
 }
 EXPORT_SYMBOL(pci_remove_bus);
 
-- 
1.7.9.5

