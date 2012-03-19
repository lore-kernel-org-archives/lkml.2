Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161469Ab2CSFsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:48:00 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30699 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161370Ab2CSFrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:47:55 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 22/47] PCI: Add __pci_remove_bus_devices()
Date: Sun, 18 Mar 2012 22:46:11 -0700
Message-Id: <1332135996-13860-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F66C888.007C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will use it with pci_stop_and_remove_bus later.

Also remove __pci_remove_behind_bridge and pci_stop_behind_bridge.

They are same except one take bridge and one take bus.

We already have pci_stop_bus_devices().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 3f540ce..4bdda43 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -77,7 +77,7 @@ void pci_remove_bus(struct pci_bus *pci_bus)
 }
 EXPORT_SYMBOL(pci_remove_bus);
 
-static void __pci_remove_behind_bridge(struct pci_dev *dev);
+static void __pci_remove_bus_devices(struct pci_bus *bus);
 /**
  * pci_stop_and_remove_bus_device - remove a PCI device and any children
  * @dev: the device to remove
@@ -95,7 +95,7 @@ void __pci_remove_bus_device(struct pci_dev *dev)
 	if (dev->subordinate) {
 		struct pci_bus *b = dev->subordinate;
 
-		__pci_remove_behind_bridge(dev);
+		__pci_remove_bus_devices(b);
 		pci_remove_bus(b);
 		dev->subordinate = NULL;
 	}
@@ -110,22 +110,12 @@ void pci_stop_and_remove_bus_device(struct pci_dev *dev)
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
@@ -157,8 +147,12 @@ static void pci_stop_bus_devices(struct pci_bus *bus)
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

