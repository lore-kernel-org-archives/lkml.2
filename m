Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab2IBVyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:54:37 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20005 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab2IBVye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:54:34 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part4 03/11] PCI: Add pci_stop_and_remove_bus()
Date: Sun,  2 Sep 2012 14:54:13 -0700
Message-Id: <1346622861-30865-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622861-30865-1-git-send-email-yinghai@kernel.org>
References: <1346622861-30865-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It supports both pci root bus and pci bus under pci bridge.

-v2: clear pci_bridge's subordinate.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |   32 ++++++++++++++++++++++++++++++++
 include/linux/pci.h  |    1 +
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index b9f553b..94407d4 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -136,3 +136,35 @@ void pci_stop_and_remove_behind_bridge(struct pci_dev *dev)
 	if (dev->subordinate)
 		pci_remove_bus_devices(dev->subordinate);
 }
+
+static void pci_stop_host_bridge(struct pci_host_bridge *bridge)
+{
+	device_unregister(&bridge->dev);
+}
+/*
+ * it will support pci root bus too, in that case we need
+ *  stop and remove host bridge
+ */
+void pci_stop_and_remove_bus(struct pci_bus *bus)
+{
+	struct pci_host_bridge *host_bridge = NULL;
+	struct pci_dev *pci_bridge = NULL;
+
+	pci_stop_bus_devices(bus);
+
+	if (pci_is_root_bus(bus)) {
+		host_bridge = to_pci_host_bridge(bus->bridge);
+		pci_stop_host_bridge(host_bridge);
+	} else
+		pci_bridge = bus->self;
+
+	pci_remove_bus_devices(bus);
+
+	pci_remove_bus(bus);
+
+	if (host_bridge)
+		host_bridge->bus = NULL;
+
+	if (pci_bridge)
+		pci_bridge->subordinate = NULL;
+}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 4446448..8b2c722 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -738,6 +738,7 @@ extern void pci_remove_bus(struct pci_bus *b);
 extern void pci_stop_and_remove_bus_device(struct pci_dev *dev);
 void pci_stop_bus_devices(struct pci_bus *bus);
 void pci_stop_and_remove_behind_bridge(struct pci_dev *dev);
+void pci_stop_and_remove_bus(struct pci_bus *bus);
 void pci_setup_cardbus(struct pci_bus *bus);
 extern void pci_sort_breadthfirst(void);
 #define dev_is_pci(d) ((d)->bus == &pci_bus_type)
-- 
1.7.7

