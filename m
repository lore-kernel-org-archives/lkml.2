Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab2BPFlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:41:53 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:20976 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2BPFlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:41:12 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/4] PCI: Move out pci reassigndev resource alignment out of quirk
Date: Wed, 15 Feb 2012 21:40:31 -0800
Message-Id: <1329370832-2253-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1329370832-2253-1-git-send-email-yinghai@kernel.org>
References: <1329370832-2253-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F3C96F7.0006,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That looks like abusing quirk framework.

calling it directly in pci_add_device. or do we have good place for it?

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/pci.c       |   62 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h       |    5 ---
 drivers/pci/probe.c     |    3 ++
 drivers/pci/quirks.c    |   63 ------------------------------------------------
 drivers/pci/setup-res.c |    4 ---
 5 files changed, 66 insertions(+), 71 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -3694,6 +3694,68 @@ int pci_is_reassigndev(struct pci_dev *d
 	return (pci_specified_resource_alignment(dev) != 0);
 }
 
+/*
+ * This function disables memory decoding and releases memory resources
+ * of the device specified by kernel's boot parameter 'pci=resource_alignment='.
+ * It also rounds up size to specified alignment.
+ * Later on, the kernel will assign page-aligned memory resource back
+ * to the device.
+ */
+void pci_reassigndev_resource_alignment(struct pci_dev *dev)
+{
+	int i;
+	struct resource *r;
+	resource_size_t align, size;
+	u16 command;
+
+	if (!pci_is_reassigndev(dev))
+		return;
+
+	if (dev->hdr_type == PCI_HEADER_TYPE_NORMAL &&
+	    (dev->class >> 8) == PCI_CLASS_BRIDGE_HOST) {
+		dev_warn(&dev->dev,
+			"Can't reassign resources to host bridge.\n");
+		return;
+	}
+
+	dev_info(&dev->dev,
+		"Disabling memory decoding and releasing memory resources.\n");
+	pci_read_config_word(dev, PCI_COMMAND, &command);
+	command &= ~PCI_COMMAND_MEMORY;
+	pci_write_config_word(dev, PCI_COMMAND, command);
+
+	align = pci_specified_resource_alignment(dev);
+	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++) {
+		r = &dev->resource[i];
+		if (!(r->flags & IORESOURCE_MEM))
+			continue;
+		size = resource_size(r);
+		if (size < align) {
+			size = align;
+			dev_info(&dev->dev,
+				"Rounding up size of resource #%d to %#llx.\n",
+				i, (unsigned long long)size);
+		}
+		r->end = size - 1;
+		r->start = 0;
+	}
+	/* Need to disable bridge's resource window,
+	 * to enable the kernel to reassign new resource
+	 * window later on.
+	 */
+	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE &&
+	    (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI) {
+		for (i = PCI_BRIDGE_RESOURCES; i < PCI_NUM_RESOURCES; i++) {
+			r = &dev->resource[i];
+			if (!(r->flags & IORESOURCE_MEM))
+				continue;
+			r->end = resource_size(r) - 1;
+			r->start = 0;
+		}
+		pci_disable_bridge_window(dev);
+	}
+}
+
 ssize_t pci_set_resource_alignment_param(const char *buf, size_t count)
 {
 	if (count > RESOURCE_ALIGNMENT_PARAM_SIZE - 1)
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -228,11 +228,8 @@ static inline int pci_ari_enabled(struct
 	return bus->self && bus->self->ari_enabled;
 }
 
-#ifdef CONFIG_PCI_QUIRKS
-extern int pci_is_reassigndev(struct pci_dev *dev);
-resource_size_t pci_specified_resource_alignment(struct pci_dev *dev);
+void pci_reassigndev_resource_alignment(struct pci_dev *dev);
 extern void pci_disable_bridge_window(struct pci_dev *dev);
-#endif
 
 /* Single Root I/O Virtualization */
 struct pci_sriov {
Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -32,69 +32,6 @@
 #include "pci.h"
 
 /*
- * This quirk function disables memory decoding and releases memory resources
- * of the device specified by kernel's boot parameter 'pci=resource_alignment='.
- * It also rounds up size to specified alignment.
- * Later on, the kernel will assign page-aligned memory resource back
- * to the device.
- */
-static void __devinit quirk_resource_alignment(struct pci_dev *dev)
-{
-	int i;
-	struct resource *r;
-	resource_size_t align, size;
-	u16 command;
-
-	if (!pci_is_reassigndev(dev))
-		return;
-
-	if (dev->hdr_type == PCI_HEADER_TYPE_NORMAL &&
-	    (dev->class >> 8) == PCI_CLASS_BRIDGE_HOST) {
-		dev_warn(&dev->dev,
-			"Can't reassign resources to host bridge.\n");
-		return;
-	}
-
-	dev_info(&dev->dev,
-		"Disabling memory decoding and releasing memory resources.\n");
-	pci_read_config_word(dev, PCI_COMMAND, &command);
-	command &= ~PCI_COMMAND_MEMORY;
-	pci_write_config_word(dev, PCI_COMMAND, command);
-
-	align = pci_specified_resource_alignment(dev);
-	for (i=0; i < PCI_BRIDGE_RESOURCES; i++) {
-		r = &dev->resource[i];
-		if (!(r->flags & IORESOURCE_MEM))
-			continue;
-		size = resource_size(r);
-		if (size < align) {
-			size = align;
-			dev_info(&dev->dev,
-				"Rounding up size of resource #%d to %#llx.\n",
-				i, (unsigned long long)size);
-		}
-		r->end = size - 1;
-		r->start = 0;
-	}
-	/* Need to disable bridge's resource window,
-	 * to enable the kernel to reassign new resource
-	 * window later on.
-	 */
-	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE &&
-	    (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI) {
-		for (i = PCI_BRIDGE_RESOURCES; i < PCI_NUM_RESOURCES; i++) {
-			r = &dev->resource[i];
-			if (!(r->flags & IORESOURCE_MEM))
-				continue;
-			r->end = resource_size(r) - 1;
-			r->start = 0;
-		}
-		pci_disable_bridge_window(dev);
-	}
-}
-DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, quirk_resource_alignment);
-
-/*
  * Decoding should be disabled for a PCI device during BAR sizing to avoid
  * conflict. But doing so may cause problems on host bridge and perhaps other
  * key system devices. For devices that need to have mmio decoding always-on,
Index: linux-2.6/drivers/pci/setup-res.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-res.c
+++ linux-2.6/drivers/pci/setup-res.c
@@ -114,7 +114,6 @@ int pci_claim_resource(struct pci_dev *d
 }
 EXPORT_SYMBOL(pci_claim_resource);
 
-#ifdef CONFIG_PCI_QUIRKS
 void pci_disable_bridge_window(struct pci_dev *dev)
 {
 	dev_info(&dev->dev, "disabling bridge mem windows\n");
@@ -127,9 +126,6 @@ void pci_disable_bridge_window(struct pc
 	pci_write_config_dword(dev, PCI_PREF_MEMORY_BASE, 0x0000fff0);
 	pci_write_config_dword(dev, PCI_PREF_BASE_UPPER32, 0xffffffff);
 }
-#endif	/* CONFIG_PCI_QUIRKS */
-
-
 
 static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 		int resno, resource_size_t size, resource_size_t align)
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1227,6 +1227,9 @@ void pci_device_add(struct pci_dev *dev,
 	/* Fix up broken headers */
 	pci_fixup_device(pci_fixup_header, dev);
 
+	/* moved out from quirk header fixup code */
+	pci_reassigndev_resource_alignment(dev);
+
 	/* Clear the state_saved flag. */
 	dev->state_saved = false;
 
