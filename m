Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162107Ab2CSGB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:01:57 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30717 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161298Ab2CSFr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:47:57 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 24/47] PCI: Add pci_stop_and_remove_bus()
Date: Sun, 18 Mar 2012 22:46:13 -0700
Message-Id: <1332135996-13860-25-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090202.4F66C88A.0067,ss=1,re=0.000,fgs=0
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
index 64ba5b1..75b0092 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -169,6 +169,38 @@ void pci_stop_bus_device(struct pci_dev *dev)
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
+	__pci_remove_bus_devices(bus);
+
+	pci_remove_bus(bus);
+
+	if (host_bridge)
+		host_bridge->bus = NULL;
+
+	if (pci_bridge)
+		pci_bridge->subordinate = NULL;
+}
+
 EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
 EXPORT_SYMBOL(pci_stop_and_remove_behind_bridge);
 EXPORT_SYMBOL_GPL(pci_stop_bus_device);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b434401..aec945d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -703,6 +703,7 @@ extern void pci_dev_put(struct pci_dev *dev);
 extern void pci_remove_bus(struct pci_bus *b);
 extern void __pci_remove_bus_device(struct pci_dev *dev);
 extern void pci_stop_and_remove_bus_device(struct pci_dev *dev);
+void pci_stop_and_remove_bus(struct pci_bus *bus);
 extern void pci_stop_bus_device(struct pci_dev *dev);
 void pci_setup_cardbus(struct pci_bus *bus);
 extern void pci_sort_breadthfirst(void);
-- 
1.7.7

