Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab2CFHQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:16:30 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:17247 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497Ab2CFHQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:16:28 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 15/23] PCI: add pci_stop_and_remove_bus()
Date: Mon,  5 Mar 2012 23:13:52 -0800
Message-Id: <1331018040-30725-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090206.4F55B9CB.0010,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it supports both pci root bus and pci bus under pci bridge.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |   27 +++++++++++++++++++++++++++
 include/linux/pci.h  |    1 +
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 62c348c..13a1555 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -172,6 +172,33 @@ void pci_stop_bus_device(struct pci_dev *dev)
 	pci_stop_dev(dev);
 }
 
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
+
+	pci_stop_bus_devices(bus);
+
+	if (pci_is_root_bus(bus)) {
+		host_bridge = to_pci_host_bridge(bus->bridge);
+		pci_stop_host_bridge(host_bridge);
+	}
+
+	__pci_remove_bus_devices(bus);
+
+	pci_remove_bus(bus);
+
+	if (host_bridge)
+		host_bridge->bus = NULL;
+}
+
 EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
 EXPORT_SYMBOL(pci_stop_and_remove_behind_bridge);
 EXPORT_SYMBOL_GPL(pci_stop_bus_device);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 4f30cd1..3d5feda 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -702,6 +702,7 @@ extern void pci_dev_put(struct pci_dev *dev);
 extern void pci_remove_bus(struct pci_bus *b);
 extern void __pci_remove_bus_device(struct pci_dev *dev);
 extern void pci_stop_and_remove_bus_device(struct pci_dev *dev);
+void pci_stop_and_remove_bus(struct pci_bus *bus);
 extern void pci_stop_bus_device(struct pci_dev *dev);
 void pci_setup_cardbus(struct pci_bus *bus);
 extern void pci_sort_breadthfirst(void);
-- 
1.7.7

