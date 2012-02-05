Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab2BEG5r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 01:57:47 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:41360 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2BEGze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 01:55:34 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/9] pci: Fix pci cardbus removal
Date: Sat,  4 Feb 2012 22:55:00 -0800
Message-Id: <1328424908-6385-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
References: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F2E27DE.002C,ss=1,re=0.000,fgs=0
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

Restore the old behavoir of pci_remove_behind_bridge by:
1. rename pci_remove_behind_bridge to __pci_remove_behind_bridge, and let
	__pci_remove_bus_device() call it instead.
2. add pci-stop_befind_bridge that will stop device under bridge
3. add back pci_remove_behind_bridge that will stop and remove device
	under bridge.

This one is for v3.3

-v2: update commit description a little bit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |   28 ++++++++++++++++++++++------
 1 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index bd70f23..82f8ae5 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -77,6 +77,7 @@ void pci_remove_bus(struct pci_bus *pci_bus)
 }
 EXPORT_SYMBOL(pci_remove_bus);
 
+static void __pci_remove_behind_bridge(struct pci_dev *dev);
 /**
  * pci_remove_bus_device - remove a PCI device and any children
  * @dev: the device to remove
@@ -94,7 +95,7 @@ static void __pci_remove_bus_device(struct pci_dev *dev)
 	if (dev->subordinate) {
 		struct pci_bus *b = dev->subordinate;
 
-		pci_remove_behind_bridge(dev);
+		__pci_remove_behind_bridge(dev);
 		pci_remove_bus(b);
 		dev->subordinate = NULL;
 	}
@@ -107,6 +108,24 @@ void pci_remove_bus_device(struct pci_dev *dev)
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
@@ -117,11 +136,8 @@ void pci_remove_bus_device(struct pci_dev *dev)
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
-- 
1.7.7

