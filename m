Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945Ab2CMH2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:28:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49741 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab2CMH2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:28:32 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/12] PCI, pciehp: Separate pci_hp_add_bridge()
Date: Tue, 13 Mar 2012 00:26:32 -0700
Message-Id: <1331623594-30543-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
References: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F5EF71E.005A,ss=1,re=0.000,fgs=0
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
index d3509cd..d0999b1 100644
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
+EXPORT_SYMBOL(pci_hp_add_bridge);
 
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

