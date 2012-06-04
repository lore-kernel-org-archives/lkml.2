Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab2FDFR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:17:27 -0400
Received: from szxga01-in.huawei.com ([58.251.152.64]:40905 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab2FDFRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:17:25 -0400
Date: Mon, 04 Jun 2012 13:16:58 +0800
From: Jiang Liu <jiang.liu@huawei.com>
Subject: [RFC PATCH v1 2/6] PCI: split PCI bus device registration into two
 stages
In-reply-to: <1338787022-400-1-git-send-email-jiang.liu@huawei.com>
X-Originating-IP: [10.107.208.49]
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <liuj97@gmail.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Don Dutile <ddutile@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-id: <1338787022-400-2-git-send-email-jiang.liu@huawei.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.8.msysgit.0
Content-type: text/plain
Content-transfer-encoding: 7BIT
X-CFilter-Loop: Reflected
References: <1338787022-400-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <liuj97@gmail.com>

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
 drivers/pci/probe.c  |    1 +
 drivers/pci/remove.c |   10 +++++-----
 3 files changed, 7 insertions(+), 6 deletions(-)

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
index dacca26..47ffa6c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -667,6 +667,7 @@ struct pci_bus *__ref pci_add_new_bus(struct pci_bus *parent, struct pci_dev *de
 		down_write(&pci_bus_sem);
 		list_add_tail(&child->node, &parent->children);
 		up_write(&pci_bus_sem);
+		device_initialize(&child->dev);
 	}
 	return child;
 }
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 6c07bc5..edbd117 100644
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
1.7.1


