Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2BBUQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:16:10 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:21804 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab2BBUQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:16:07 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] pci: Fix pci cardbus removal
Date: Thu,  2 Feb 2012 12:15:48 -0800
Message-Id: <1328213748-2804-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F2AEF01.0071,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During test busn_res allocation with cardbus, found pci card removal is not
working anymore, and it turns out it is broken by:

|commit 79cc9601c3e42b4f0650fe7e69132ebce7ab48f9
|Date:   Tue Nov 22 21:06:53 2011 -0800
|
|    PCI: Only call pci_stop_bus_device() one time for child devices at remove

that patch changed pci_remove_behind_bridge behavoir that yenta_carbus depends.

Restore the behavoir by:
1. rename pci_remove_behind_bridge to __pci_remove_behind_bridge, and let
	__pci_remove_bus_device() call it instead.
2. add pci-stop_befind_bridge that will stop device under bridge
3. add back new pci_remove_behind_bridge that will stop and remove device
	under bridge.

This one is for v3.3

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/remove.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/pci/remove.c
===================================================================
--- linux-2.6.orig/drivers/pci/remove.c
+++ linux-2.6/drivers/pci/remove.c
@@ -78,6 +78,7 @@ void pci_remove_bus(struct pci_bus *pci_
 }
 EXPORT_SYMBOL(pci_remove_bus);
 
+static void __pci_remove_behind_bridge(struct pci_dev *dev);
 /**
  * pci_remove_bus_device - remove a PCI device and any children
  * @dev: the device to remove
@@ -95,7 +96,7 @@ static void __pci_remove_bus_device(stru
 	if (dev->subordinate) {
 		struct pci_bus *b = dev->subordinate;
 
-		pci_remove_behind_bridge(dev);
+		__pci_remove_behind_bridge(dev);
 		pci_remove_bus(b);
 		dev->subordinate = NULL;
 	}
@@ -108,6 +109,24 @@ void pci_remove_bus_device(struct pci_de
 	__pci_remove_bus_device(dev);
 }
 
+static void __pci_remove_behind_bridge(struct pci_dev *dev)
+{
+	struct list_head *l, *n;
+
+	if (dev->subordinate)
+		list_for_each_safe(l, n, &dev->subordinate->devices)
+			__pci_remove_bus_device(pci_dev_b(l));
+}
+
+static void pci_stop_behind_bridge(struct pci_dev *dev)
+{
+	struct list_head *l, *n;
+
+	if (dev->subordinate)
+		list_for_each_safe(l, n, &dev->subordinate->devices)
+			pci_stop_bus_device(pci_dev_b(l));
+}
+
 /**
  * pci_remove_behind_bridge - remove all devices behind a PCI bridge
  * @dev: PCI bridge device
@@ -118,11 +137,8 @@ void pci_remove_bus_device(struct pci_de
  */
 void pci_remove_behind_bridge(struct pci_dev *dev)
 {
-	struct list_head *l, *n;
-
-	if (dev->subordinate)
-		list_for_each_safe(l, n, &dev->subordinate->devices)
-			__pci_remove_bus_device(pci_dev_b(l));
+	pci_stop_behind_bridge(dev);
+	__pci_remove_behind_bridge(dev);
 }
 
 static void pci_stop_bus_devices(struct pci_bus *bus)
