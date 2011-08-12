Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab1HLKfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 06:35:11 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:25699 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab1HLKeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 06:34:15 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 1/5] staging: vme: make [alloc|free]_consistent bridge specific
Date: Fri, 12 Aug 2011 12:30:47 +0200
Message-ID: <1313145051-13397-2-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch>
References: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make PCI dependent functions ([alloc|free]_consistent() in
'vme.c') bridge specific. By removing the dependency of the
VME bridge framework on PCI, this patch allows for addition of
non-PCI based VME bridges.

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/bridges/vme_ca91cx42.c |   24 ++++++++++++++++++
 drivers/staging/vme/bridges/vme_tsi148.c   |   24 ++++++++++++++++++
 drivers/staging/vme/vme.c                  |   36 ++++++++++++++++-----------
 drivers/staging/vme/vme_bridge.h           |   10 +++++--
 4 files changed, 76 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 5122c13..0e4feac 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -1500,6 +1500,28 @@ static int ca91cx42_slot_get(struct vme_bridge *ca91cx42_bridge)
 
 }
 
+void *ca91cx42_alloc_consistent(struct device *parent, size_t size,
+	dma_addr_t *dma)
+{
+	struct pci_dev *pdev;
+
+	/* Find pci_dev container of dev */
+	pdev = container_of(parent, struct pci_dev, dev);
+
+	return pci_alloc_consistent(pdev, size, dma);
+}
+
+void ca91cx42_free_consistent(struct device *parent, size_t size, void *vaddr,
+	dma_addr_t dma)
+{
+	struct pci_dev *pdev;
+
+	/* Find pci_dev container of dev */
+	pdev = container_of(parent, struct pci_dev, dev);
+
+	pci_free_consistent(pdev, size, vaddr, dma);
+}
+
 static int __init ca91cx42_init(void)
 {
 	return pci_register_driver(&ca91cx42_driver);
@@ -1769,6 +1791,8 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ca91cx42_bridge->lm_attach = ca91cx42_lm_attach;
 	ca91cx42_bridge->lm_detach = ca91cx42_lm_detach;
 	ca91cx42_bridge->slot_get = ca91cx42_slot_get;
+	ca91cx42_bridge->alloc_consistent = ca91cx42_alloc_consistent;
+	ca91cx42_bridge->free_consistent = ca91cx42_free_consistent;
 
 	data = ioread32(ca91cx42_device->base + MISC_CTL);
 	dev_info(&pdev->dev, "Board is%s the VME system controller\n",
diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 9c53951..6c1167c 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -2114,6 +2114,28 @@ static int tsi148_slot_get(struct vme_bridge *tsi148_bridge)
 	return (int)slot;
 }
 
+void *tsi148_alloc_consistent(struct device *parent, size_t size,
+	dma_addr_t *dma)
+{
+	struct pci_dev *pdev;
+
+	/* Find pci_dev container of dev */
+	pdev = container_of(parent, struct pci_dev, dev);
+
+	return pci_alloc_consistent(pdev, size, dma);
+}
+
+void tsi148_free_consistent(struct device *parent, size_t size, void *vaddr,
+	dma_addr_t dma)
+{
+	struct pci_dev *pdev;
+
+	/* Find pci_dev container of dev */
+	pdev = container_of(parent, struct pci_dev, dev);
+
+	pci_free_consistent(pdev, size, vaddr, dma);
+}
+
 static int __init tsi148_init(void)
 {
 	return pci_register_driver(&tsi148_driver);
@@ -2443,6 +2465,8 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	tsi148_bridge->lm_attach = tsi148_lm_attach;
 	tsi148_bridge->lm_detach = tsi148_lm_detach;
 	tsi148_bridge->slot_get = tsi148_slot_get;
+	tsi148_bridge->alloc_consistent = tsi148_alloc_consistent;
+	tsi148_bridge->free_consistent = tsi148_free_consistent;
 
 	data = ioread32be(tsi148_device->base + TSI148_LCSR_VSTAT);
 	dev_info(&pdev->dev, "Board is%s the VME system controller\n",
diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index c078ce3..d243a4a 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -83,15 +83,11 @@ static struct vme_bridge *find_bridge(struct vme_resource *resource)
 /*
  * Allocate a contiguous block of memory for use by the driver. This is used to
  * create the buffers for the slave windows.
- *
- * XXX VME bridges could be available on buses other than PCI. At the momment
- *     this framework only supports PCI devices.
  */
 void *vme_alloc_consistent(struct vme_resource *resource, size_t size,
 	dma_addr_t *dma)
 {
 	struct vme_bridge *bridge;
-	struct pci_dev *pdev;
 
 	if (resource == NULL) {
 		printk(KERN_ERR "No resource\n");
@@ -104,28 +100,29 @@ void *vme_alloc_consistent(struct vme_resource *resource, size_t size,
 		return NULL;
 	}
 
-	/* Find pci_dev container of dev */
 	if (bridge->parent == NULL) {
-		printk(KERN_ERR "Dev entry NULL\n");
+		printk(KERN_ERR "Dev entry NULL for bridge %s\n",
+			bridge->name);
+		return NULL;
+	}
+
+	if (bridge->alloc_consistent == NULL) {
+		pr_err("alloc_consistent not supported by bridge %s\n",
+			bridge->name);
 		return NULL;
 	}
-	pdev = container_of(bridge->parent, struct pci_dev, dev);
 
-	return pci_alloc_consistent(pdev, size, dma);
+	return bridge->alloc_consistent(bridge->parent, size, dma);
 }
 EXPORT_SYMBOL(vme_alloc_consistent);
 
 /*
  * Free previously allocated contiguous block of memory.
- *
- * XXX VME bridges could be available on buses other than PCI. At the momment
- *     this framework only supports PCI devices.
  */
 void vme_free_consistent(struct vme_resource *resource, size_t size,
 	void *vaddr, dma_addr_t dma)
 {
 	struct vme_bridge *bridge;
-	struct pci_dev *pdev;
 
 	if (resource == NULL) {
 		printk(KERN_ERR "No resource\n");
@@ -138,10 +135,19 @@ void vme_free_consistent(struct vme_resource *resource, size_t size,
 		return;
 	}
 
-	/* Find pci_dev container of dev */
-	pdev = container_of(bridge->parent, struct pci_dev, dev);
+	if (bridge->parent == NULL) {
+		printk(KERN_ERR "Dev entry NULL for bridge %s\n",
+			bridge->name);
+		return;
+	}
+
+	if (bridge->free_consistent == NULL) {
+		pr_err("free_consistent not supported by bridge %s\n",
+			bridge->name);
+		return;
+	}
 
-	pci_free_consistent(pdev, size, vaddr, dma);
+	bridge->free_consistent(bridge->parent, size, vaddr, dma);
 }
 EXPORT_SYMBOL(vme_free_consistent);
 
diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
index 4c6ec31..a9084f0 100644
--- a/drivers/staging/vme/vme_bridge.h
+++ b/drivers/staging/vme/vme_bridge.h
@@ -98,8 +98,6 @@ struct vme_irq {
 /* This structure stores all the information about one bridge
  * The structure should be dynamically allocated by the driver and one instance
  * of the structure should be present for each VME chip present in the system.
- *
- * Currently we assume that all chips are PCI-based
  */
 struct vme_bridge {
 	char name[VMENAMSIZ];
@@ -112,7 +110,7 @@ struct vme_bridge {
 	struct list_head vme_errors;	/* List for errors generated on VME */
 
 	/* Bridge Info - XXX Move to private structure? */
-	struct device *parent;	/* Generic device struct (pdev->dev for PCI) */
+	struct device *parent;	/* Parent device (eg. pdev->dev for PCI) */
 	void *driver_priv;	/* Private pointer for the bridge driver */
 
 	struct device dev[VME_SLOTS_MAX];	/* Device registered with
@@ -165,6 +163,12 @@ struct vme_bridge {
 
 	/* CR/CSR space functions */
 	int (*slot_get) (struct vme_bridge *);
+
+	/* Bridge parent interface */
+	void *(*alloc_consistent)(struct device *dev, size_t size,
+		dma_addr_t *dma);
+	void (*free_consistent)(struct device *dev, size_t size,
+		void *vaddr, dma_addr_t dma);
 };
 
 void vme_irq_handler(struct vme_bridge *, int, int);
-- 
1.7.4.1

