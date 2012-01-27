Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab2A0S5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:57:19 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:40344 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2A0Szg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:55:36 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/7] PCI: Separate pci_bus_read_dev_vendor_id from pci_scan_device
Date: Fri, 27 Jan 2012 10:55:10 -0800
Message-Id: <1327690515-2991-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327690515-2991-1-git-send-email-yinghai@kernel.org>
References: <1327690515-2991-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F22F322.00B2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will reuse that function for pciehp probing.

-v2: according to Kenji, fix crs timeout checking, and export the function
     for later using when pciehp is compiled as module.

Suggested-by: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci.h   |    2 ++
 drivers/pci/probe.c |   48 +++++++++++++++++++++++++++++++-----------------
 2 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index b74084e..8dadbd3 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -205,6 +205,8 @@ enum pci_bar_type {
 	pci_bar_mem64,		/* A 64-bit memory BAR */
 };
 
+bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *pl,
+				int crs_timeout);
 extern int pci_setup_device(struct pci_dev *dev);
 extern int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 				struct resource *res, unsigned int reg);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 04e74f4..101e90f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1113,40 +1113,54 @@ struct pci_dev *alloc_pci_dev(void)
 }
 EXPORT_SYMBOL(alloc_pci_dev);
 
-/*
- * Read the config data for a PCI device, sanity-check it
- * and fill in the dev structure...
- */
-static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
+bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *l,
+				 int crs_timeout)
 {
-	struct pci_dev *dev;
-	u32 l;
 	int delay = 1;
 
-	if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, &l))
-		return NULL;
+	if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, l))
+		return false;
 
 	/* some broken boards return 0 or ~0 if a slot is empty: */
-	if (l == 0xffffffff || l == 0x00000000 ||
-	    l == 0x0000ffff || l == 0xffff0000)
-		return NULL;
+	if (*l == 0xffffffff || *l == 0x00000000 ||
+	    *l == 0x0000ffff || *l == 0xffff0000)
+		return false;
 
 	/* Configuration request Retry Status */
-	while (l == 0xffff0001) {
+	while (*l == 0xffff0001) {
+		if (!crs_timeout)
+			return false;
+
 		msleep(delay);
 		delay *= 2;
-		if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, &l))
-			return NULL;
+		if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, l))
+			return false;
 		/* Card hasn't responded in 60 seconds?  Must be stuck. */
-		if (delay > 60 * 1000) {
+		if (delay > crs_timeout) {
 			printk(KERN_WARNING "pci %04x:%02x:%02x.%d: not "
 					"responding\n", pci_domain_nr(bus),
 					bus->number, PCI_SLOT(devfn),
 					PCI_FUNC(devfn));
-			return NULL;
+			return false;
 		}
 	}
 
+	return true;
+}
+EXPORT_SYMBOL(pci_bus_read_dev_vendor_id);
+
+/*
+ * Read the config data for a PCI device, sanity-check it
+ * and fill in the dev structure...
+ */
+static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
+{
+	struct pci_dev *dev;
+	u32 l;
+
+	if (!pci_bus_read_dev_vendor_id(bus, devfn, &l, 60*1000))
+		return NULL;
+
 	dev = alloc_pci_dev();
 	if (!dev)
 		return NULL;
-- 
1.7.7

