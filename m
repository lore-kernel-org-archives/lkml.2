Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab1IUWm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 18:42:56 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21812 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab1IUWmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 18:42:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jbeulich@suse.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/pciback: use mutex rather than spinlock in vpci backend
Date: Wed, 21 Sep 2011 18:42:46 -0400
Message-Id: <1316644966-19386-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316644966-19386-1-git-send-email-konrad.wilk@oracle.com>
References: <1316644966-19386-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E7A686B.006F:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to the "xen/pciback: use mutex rather than spinlock in passthrough backend"
this patch converts the vpci backend to use a mutex instead of
a spinlock. Note that the code taking the lock won't ever get called
from non-sleepable context

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/vpci.c |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/xen/xen-pciback/vpci.c b/drivers/xen/xen-pciback/vpci.c
index a778552..01222d7 100644
--- a/drivers/xen/xen-pciback/vpci.c
+++ b/drivers/xen/xen-pciback/vpci.c
@@ -8,7 +8,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include "pciback.h"
 
 #define PCI_SLOT_MAX 32
@@ -16,7 +16,7 @@
 struct vpci_dev_data {
 	/* Access to dev_list must be protected by lock */
 	struct list_head dev_list[PCI_SLOT_MAX];
-	spinlock_t lock;
+	struct mutex lock;
 };
 
 static inline struct list_head *list_first(struct list_head *head)
@@ -32,13 +32,12 @@ static struct pci_dev *__xen_pcibk_get_pci_dev(struct xen_pcibk_device *pdev,
 	struct pci_dev_entry *entry;
 	struct pci_dev *dev = NULL;
 	struct vpci_dev_data *vpci_dev = pdev->pci_dev_data;
-	unsigned long flags;
 
 	if (domain != 0 || bus != 0)
 		return NULL;
 
 	if (PCI_SLOT(devfn) < PCI_SLOT_MAX) {
-		spin_lock_irqsave(&vpci_dev->lock, flags);
+		mutex_lock(&vpci_dev->lock);
 
 		list_for_each_entry(entry,
 				    &vpci_dev->dev_list[PCI_SLOT(devfn)],
@@ -49,7 +48,7 @@ static struct pci_dev *__xen_pcibk_get_pci_dev(struct xen_pcibk_device *pdev,
 			}
 		}
 
-		spin_unlock_irqrestore(&vpci_dev->lock, flags);
+		mutex_unlock(&vpci_dev->lock);
 	}
 	return dev;
 }
@@ -70,7 +69,6 @@ static int __xen_pcibk_add_pci_dev(struct xen_pcibk_device *pdev,
 	int err = 0, slot, func = -1;
 	struct pci_dev_entry *t, *dev_entry;
 	struct vpci_dev_data *vpci_dev = pdev->pci_dev_data;
-	unsigned long flags;
 
 	if ((dev->class >> 24) == PCI_BASE_CLASS_BRIDGE) {
 		err = -EFAULT;
@@ -89,7 +87,7 @@ static int __xen_pcibk_add_pci_dev(struct xen_pcibk_device *pdev,
 
 	dev_entry->dev = dev;
 
-	spin_lock_irqsave(&vpci_dev->lock, flags);
+	mutex_lock(&vpci_dev->lock);
 
 	/* Keep multi-function devices together on the virtual PCI bus */
 	for (slot = 0; slot < PCI_SLOT_MAX; slot++) {
@@ -128,7 +126,7 @@ static int __xen_pcibk_add_pci_dev(struct xen_pcibk_device *pdev,
 			 "No more space on root virtual PCI bus");
 
 unlock:
-	spin_unlock_irqrestore(&vpci_dev->lock, flags);
+	mutex_unlock(&vpci_dev->lock);
 
 	/* Publish this device. */
 	if (!err)
@@ -144,9 +142,8 @@ static void __xen_pcibk_release_pci_dev(struct xen_pcibk_device *pdev,
 	int slot;
 	struct vpci_dev_data *vpci_dev = pdev->pci_dev_data;
 	struct pci_dev *found_dev = NULL;
-	unsigned long flags;
 
-	spin_lock_irqsave(&vpci_dev->lock, flags);
+	mutex_lock(&vpci_dev->lock);
 
 	for (slot = 0; slot < PCI_SLOT_MAX; slot++) {
 		struct pci_dev_entry *e;
@@ -162,7 +159,7 @@ static void __xen_pcibk_release_pci_dev(struct xen_pcibk_device *pdev,
 	}
 
 out:
-	spin_unlock_irqrestore(&vpci_dev->lock, flags);
+	mutex_unlock(&vpci_dev->lock);
 
 	if (found_dev)
 		pcistub_put_pci_dev(found_dev);
@@ -177,7 +174,7 @@ static int __xen_pcibk_init_devices(struct xen_pcibk_device *pdev)
 	if (!vpci_dev)
 		return -ENOMEM;
 
-	spin_lock_init(&vpci_dev->lock);
+	mutex_init(&vpci_dev->lock);
 
 	for (slot = 0; slot < PCI_SLOT_MAX; slot++)
 		INIT_LIST_HEAD(&vpci_dev->dev_list[slot]);
@@ -221,10 +218,9 @@ static int __xen_pcibk_get_pcifront_dev(struct pci_dev *pcidev,
 	struct pci_dev_entry *entry;
 	struct pci_dev *dev = NULL;
 	struct vpci_dev_data *vpci_dev = pdev->pci_dev_data;
-	unsigned long flags;
 	int found = 0, slot;
 
-	spin_lock_irqsave(&vpci_dev->lock, flags);
+	mutex_lock(&vpci_dev->lock);
 	for (slot = 0; slot < PCI_SLOT_MAX; slot++) {
 		list_for_each_entry(entry,
 			    &vpci_dev->dev_list[slot],
@@ -242,7 +238,7 @@ static int __xen_pcibk_get_pcifront_dev(struct pci_dev *pcidev,
 			}
 		}
 	}
-	spin_unlock_irqrestore(&vpci_dev->lock, flags);
+	mutex_lock(&vpci_dev->lock);
 	return found;
 }
 
-- 
1.7.4.1

