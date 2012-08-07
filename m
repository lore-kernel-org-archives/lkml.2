Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab2HGQTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:19:18 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40380 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab2HGQTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:19:14 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v1 04/22] PCI: split PCI bus device registration into two stages
Date: Wed,  8 Aug 2012 00:10:44 +0800
Message-Id: <1344355862-2726-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When handling BUS_NOTIFY_ADD_DEVICE event for a new PCI bridge
device, the notification handler can't hold reference count
to the new PCI bus because the device object for the new bus
(pci_dev->subordinate->dev) hasn't been initialized yet.

Split the PCI bus device registration into two stages as below,
so that the event handler could hold reference counts to the new
PCI bus when handling BUS_NOTIFY_ADD_DEVICE event.

1) device_initialize(&pci_dev->dev)
2) device_initialize(&pci_dev->subordinate->dev)
3) notify BUS_NOTIFY_ADD_DEVICE event for pci_dev
4) device_add(&pci_dev->dev)
5) device_add(&pci_dev->subordinate->dev)

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/bus.c    |    2 +-
 drivers/pci/probe.c  |    3 ++-
 drivers/pci/remove.c |   10 +++++-----
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 4ce5ef2..e2a0c52 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -187,7 +187,7 @@ int pci_bus_add_child(struct pci_bus *bus)
 	if (bus->bridge)
 		bus->dev.parent = bus->bridge;
 
-	retval = device_register(&bus->dev);
+	retval = device_add(&bus->dev);
 	if (retval)
 		return retval;
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index dacca26..ad77ae5 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -456,6 +456,7 @@ static struct pci_bus * pci_alloc_bus(void)
 		INIT_LIST_HEAD(&b->resources);
 		b->max_bus_speed = PCI_SPEED_UNKNOWN;
 		b->cur_bus_speed = PCI_SPEED_UNKNOWN;
+		device_initialize(&b->dev);
 	}
 	return b;
 }
@@ -1672,7 +1673,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	b->dev.class = &pcibus_class;
 	b->dev.parent = b->bridge;
 	dev_set_name(&b->dev, "%04x:%02x", pci_domain_nr(b), bus);
-	error = device_register(&b->dev);
+	error = device_add(&b->dev);
 	if (error)
 		goto class_dev_reg_err;
 
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index b9ac765..ba03059 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -70,11 +70,11 @@ void pci_remove_bus(struct pci_bus *pci_bus)
 	list_del(&pci_bus->node);
 	pci_bus_release_busn_res(pci_bus);
 	up_write(&pci_bus_sem);
-	if (!pci_bus->is_added)
-		return;
-
-	pci_remove_legacy_files(pci_bus);
-	device_unregister(&pci_bus->dev);
+	if (pci_bus->is_added) {
+		pci_remove_legacy_files(pci_bus);
+		device_del(&pci_bus->dev);
+	}
+	put_device(&pci_bus->dev);
 }
 EXPORT_SYMBOL(pci_remove_bus);
 
-- 
1.7.9.5

