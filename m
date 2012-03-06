Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab2CFHPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:15:05 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:31427 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820Ab2CFHPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:15:01 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/23] PCI: Add pci_bus_add_single_device()
Date: Mon,  5 Mar 2012 23:13:40 -0800
Message-Id: <1331018040-30725-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F55B974.0026,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will use it to pci_bus_bridge_scan_resize(0 to make bridge will
have pci_bus directory created.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/bus.c   |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    1 +
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 4ce5ef2..1eb7944 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -255,6 +255,45 @@ void pci_bus_add_devices(const struct pci_bus *bus)
 	}
 }
 
+void pci_bus_add_single_device(struct pci_dev *dev)
+{
+	struct pci_bus *child;
+	int retval;
+
+	/* Skip already-added devices */
+	if (!dev->is_added) {
+		retval = pci_bus_add_device(dev);
+		if (retval)
+			dev_err(&dev->dev, "Error adding device, continuing\n");
+	}
+
+	BUG_ON(!dev->is_added);
+
+	child = dev->subordinate;
+	/*
+	 * If there is an unattached subordinate bus, attach
+	 * it and then scan for unattached PCI devices.
+	 */
+	if (child) {
+		if (list_empty(&child->node)) {
+			down_write(&pci_bus_sem);
+			list_add_tail(&child->node, &dev->bus->children);
+			up_write(&pci_bus_sem);
+		}
+		pci_bus_add_devices(child);
+
+		/*
+		 * register the bus with sysfs as the parent is now
+		 * properly registered.
+		 */
+		if (!child->is_added) {
+			retval = pci_bus_add_child(child);
+			if (retval)
+				dev_err(&dev->dev, "Error adding bus, continuing\n");
+		}
+	}
+}
+
 void pci_enable_bridges(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 40606c1..28556cb 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -665,6 +665,7 @@ void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 void pcibios_scan_specific_bus(int busn);
 extern struct pci_bus *pci_find_bus(int domain, int busnr);
 void pci_bus_add_devices(const struct pci_bus *bus);
+void pci_bus_add_single_device(struct pci_dev *dev);
 struct pci_bus *pci_scan_bus_parented(struct device *parent, int bus,
 				      struct pci_ops *ops, void *sysdata);
 struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
-- 
1.7.7

