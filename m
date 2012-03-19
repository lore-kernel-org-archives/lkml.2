Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161651Ab2CSFsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:48:19 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29531 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161566Ab2CSFsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:48:13 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 34/47] PCI, pciehp: Separate pci_hp_add_bridge()
Date: Sun, 18 Mar 2012 22:46:23 -0700
Message-Id: <1332135996-13860-35-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F66C89A.00B3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will use it for other pci hp hotplug support

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/hotplug-pci.c        |   13 +++++++++++++
 drivers/pci/hotplug/pciehp_pci.c |   18 ++----------------
 drivers/pci/pci.h                |    1 +
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/hotplug-pci.c b/drivers/pci/hotplug-pci.c
index d3509cd..24de840 100644
--- a/drivers/pci/hotplug-pci.c
+++ b/drivers/pci/hotplug-pci.c
@@ -4,6 +4,19 @@
 #include <linux/export.h>
 #include "pci.h"
 
+int __ref pci_hp_add_bridge(struct pci_dev *dev)
+{
+	struct pci_bus *parent = dev->bus;
+	int pass, busnr = parent->secondary;
+
+	for (pass = 0; pass < 2; pass++)
+		busnr = pci_scan_bridge(parent, dev, busnr, pass);
+	if (!dev->subordinate)
+		return -1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_hp_add_bridge);
 
 unsigned int __devinit pci_do_scan_bus(struct pci_bus *bus)
 {
diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
index e21171c..b9a9fce 100644
--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -34,19 +34,6 @@
 #include "../pci.h"
 #include "pciehp.h"
 
-static int __ref pciehp_add_bridge(struct pci_dev *dev)
-{
-	struct pci_bus *parent = dev->bus;
-	int pass, busnr = parent->secondary;
-
-	for (pass = 0; pass < 2; pass++)
-		busnr = pci_scan_bridge(parent, dev, busnr, pass);
-	if (!dev->subordinate)
-		return -1;
-
-	return 0;
-}
-
 int pciehp_configure_device(struct slot *p_slot)
 {
 	struct pci_dev *dev;
@@ -75,9 +62,8 @@ int pciehp_configure_device(struct slot *p_slot)
 		if (!dev)
 			continue;
 		if ((dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) ||
-				(dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)) {
-			pciehp_add_bridge(dev);
-		}
+		    (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS))
+			pci_hp_add_bridge(dev);
 		pci_dev_put(dev);
 	}
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 13b1159..9378d81 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -124,6 +124,7 @@ static inline int pci_proc_detach_bus(struct pci_bus *bus) { return 0; }
 #endif
 
 /* Functions for PCI Hotplug drivers to use */
+int pci_hp_add_bridge(struct pci_dev *dev);
 extern unsigned int pci_do_scan_bus(struct pci_bus *bus);
 
 #ifdef HAVE_PCI_LEGACY
-- 
1.7.7

