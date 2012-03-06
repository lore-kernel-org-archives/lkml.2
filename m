Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab2CFHQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:16:25 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:31937 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497Ab2CFHQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:16:21 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 14/23] PCI: add __pci_remove_bus_devices()
Date: Mon,  5 Mar 2012 23:13:51 -0800
Message-Id: <1331018040-30725-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F55B9C4.0081,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will use it with pci_stop_and_remove_bus later.

also remove __pci_remove_behind_bridge and pci_stop_behind_bridge.

they are same except one take bridge and one take bus.

and we already have pci_stop_bus_devices()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 243d59b..62c348c 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -78,7 +78,7 @@ void pci_remove_bus(struct pci_bus *pci_bus)
 }
 EXPORT_SYMBOL(pci_remove_bus);
 
-static void __pci_remove_behind_bridge(struct pci_dev *dev);
+static void __pci_remove_bus_devices(struct pci_bus *bus);
 /**
  * pci_stop_and_remove_bus_device - remove a PCI device and any children
  * @dev: the device to remove
@@ -96,7 +96,7 @@ void __pci_remove_bus_device(struct pci_dev *dev)
 	if (dev->subordinate) {
 		struct pci_bus *b = dev->subordinate;
 
-		__pci_remove_behind_bridge(dev);
+		__pci_remove_bus_devices(b);
 		pci_remove_bus(b);
 		dev->subordinate = NULL;
 	}
@@ -111,22 +111,12 @@ void pci_stop_and_remove_bus_device(struct pci_dev *dev)
 	__pci_remove_bus_device(dev);
 }
 
-static void __pci_remove_behind_bridge(struct pci_dev *dev)
+static void __pci_remove_bus_devices(struct pci_bus *bus)
 {
 	struct list_head *l, *n;
 
-	if (dev->subordinate)
-		list_for_each_safe(l, n, &dev->subordinate->devices)
-			__pci_remove_bus_device(pci_dev_b(l));
-}
-
-static void pci_stop_behind_bridge(struct pci_dev *dev)
-{
-	struct list_head *l, *n;
-
-	if (dev->subordinate)
-		list_for_each_safe(l, n, &dev->subordinate->devices)
-			pci_stop_bus_device(pci_dev_b(l));
+	list_for_each_safe(l, n, &bus->devices)
+		__pci_remove_bus_device(pci_dev_b(l));
 }
 
 static void pci_stop_bus_devices(struct pci_bus *bus)
@@ -158,8 +148,12 @@ static void pci_stop_bus_devices(struct pci_bus *bus)
  */
 void pci_stop_and_remove_behind_bridge(struct pci_dev *dev)
 {
-	pci_stop_behind_bridge(dev);
-	__pci_remove_behind_bridge(dev);
+	struct pci_bus *bus = dev->subordinate;
+
+	if (bus) {
+		pci_stop_bus_devices(bus);
+		__pci_remove_bus_devices(bus);
+	}
 }
 
 /**
-- 
1.7.7

