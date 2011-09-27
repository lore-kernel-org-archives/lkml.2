Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1I0N5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:57:36 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:37624
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322Ab1I0N5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:57:34 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz1803Mzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LS6PFM-02-EBN-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/4] PCI: Move ATS implementation into own file
Date: Tue, 27 Sep 2011 15:57:13 +0200
Message-ID: <1317131836-11822-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317131836-11822-1-git-send-email-joerg.roedel@amd.com>
References: <1317131836-11822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ATS does not depend on IOV support, so move the code into
its own file. This file will also include support for the
PRI and PASID capabilities later.
Also give ATS its own Kconfig variable to allow selecting it
without IOV support.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/Kconfig     |    4 +
 drivers/pci/Makefile    |    1 +
 drivers/pci/ats.c       |  155 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/iov.c       |  142 -------------------------------------------
 include/linux/pci-ats.h |    2 +
 5 files changed, 162 insertions(+), 142 deletions(-)
 create mode 100644 drivers/pci/ats.c

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 0fa466a..1d8ce83 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -71,9 +71,13 @@ config HT_IRQ
 
 	   If unsure say Y.
 
+config PCI_ATS
+	bool
+
 config PCI_IOV
 	bool "PCI IOV support"
 	depends on PCI
+	select PCI_ATS
 	help
 	  I/O Virtualization is a PCI feature supported by some devices
 	  which allows them to create virtual devices which share their
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 6fadae3..083a49f 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_PCI_MSI) += msi.o
 # Build the Hypertransport interrupt support
 obj-$(CONFIG_HT_IRQ) += htirq.o
 
+obj-$(CONFIG_PCI_ATS) += ats.o
 obj-$(CONFIG_PCI_IOV) += iov.o
 
 #
diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
new file mode 100644
index 0000000..ae4bf87
--- /dev/null
+++ b/drivers/pci/ats.c
@@ -0,0 +1,155 @@
+/*
+ * drivers/pci/ats.c
+ *
+ * Copyright (C) 2009 Intel Corporation, Yu Zhao <yu.zhao@intel.com>
+ *
+ * PCI Express I/O Virtualization (IOV) support.
+ *   Address Translation Service 1.0
+ */
+
+#include <linux/pci-ats.h>
+#include <linux/pci.h>
+
+#include "pci.h"
+
+static int ats_alloc_one(struct pci_dev *dev, int ps)
+{
+	int pos;
+	u16 cap;
+	struct pci_ats *ats;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ATS);
+	if (!pos)
+		return -ENODEV;
+
+	ats = kzalloc(sizeof(*ats), GFP_KERNEL);
+	if (!ats)
+		return -ENOMEM;
+
+	ats->pos = pos;
+	ats->stu = ps;
+	pci_read_config_word(dev, pos + PCI_ATS_CAP, &cap);
+	ats->qdep = PCI_ATS_CAP_QDEP(cap) ? PCI_ATS_CAP_QDEP(cap) :
+					    PCI_ATS_MAX_QDEP;
+	dev->ats = ats;
+
+	return 0;
+}
+
+static void ats_free_one(struct pci_dev *dev)
+{
+	kfree(dev->ats);
+	dev->ats = NULL;
+}
+
+/**
+ * pci_enable_ats - enable the ATS capability
+ * @dev: the PCI device
+ * @ps: the IOMMU page shift
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int pci_enable_ats(struct pci_dev *dev, int ps)
+{
+	int rc;
+	u16 ctrl;
+
+	BUG_ON(dev->ats && dev->ats->is_enabled);
+
+	if (ps < PCI_ATS_MIN_STU)
+		return -EINVAL;
+
+	if (dev->is_physfn || dev->is_virtfn) {
+		struct pci_dev *pdev = dev->is_physfn ? dev : dev->physfn;
+
+		mutex_lock(&pdev->sriov->lock);
+		if (pdev->ats)
+			rc = pdev->ats->stu == ps ? 0 : -EINVAL;
+		else
+			rc = ats_alloc_one(pdev, ps);
+
+		if (!rc)
+			pdev->ats->ref_cnt++;
+		mutex_unlock(&pdev->sriov->lock);
+		if (rc)
+			return rc;
+	}
+
+	if (!dev->is_physfn) {
+		rc = ats_alloc_one(dev, ps);
+		if (rc)
+			return rc;
+	}
+
+	ctrl = PCI_ATS_CTRL_ENABLE;
+	if (!dev->is_virtfn)
+		ctrl |= PCI_ATS_CTRL_STU(ps - PCI_ATS_MIN_STU);
+	pci_write_config_word(dev, dev->ats->pos + PCI_ATS_CTRL, ctrl);
+
+	dev->ats->is_enabled = 1;
+
+	return 0;
+}
+
+/**
+ * pci_disable_ats - disable the ATS capability
+ * @dev: the PCI device
+ */
+void pci_disable_ats(struct pci_dev *dev)
+{
+	u16 ctrl;
+
+	BUG_ON(!dev->ats || !dev->ats->is_enabled);
+
+	pci_read_config_word(dev, dev->ats->pos + PCI_ATS_CTRL, &ctrl);
+	ctrl &= ~PCI_ATS_CTRL_ENABLE;
+	pci_write_config_word(dev, dev->ats->pos + PCI_ATS_CTRL, ctrl);
+
+	dev->ats->is_enabled = 0;
+
+	if (dev->is_physfn || dev->is_virtfn) {
+		struct pci_dev *pdev = dev->is_physfn ? dev : dev->physfn;
+
+		mutex_lock(&pdev->sriov->lock);
+		pdev->ats->ref_cnt--;
+		if (!pdev->ats->ref_cnt)
+			ats_free_one(pdev);
+		mutex_unlock(&pdev->sriov->lock);
+	}
+
+	if (!dev->is_physfn)
+		ats_free_one(dev);
+}
+
+/**
+ * pci_ats_queue_depth - query the ATS Invalidate Queue Depth
+ * @dev: the PCI device
+ *
+ * Returns the queue depth on success, or negative on failure.
+ *
+ * The ATS spec uses 0 in the Invalidate Queue Depth field to
+ * indicate that the function can accept 32 Invalidate Request.
+ * But here we use the `real' values (i.e. 1~32) for the Queue
+ * Depth; and 0 indicates the function shares the Queue with
+ * other functions (doesn't exclusively own a Queue).
+ */
+int pci_ats_queue_depth(struct pci_dev *dev)
+{
+	int pos;
+	u16 cap;
+
+	if (dev->is_virtfn)
+		return 0;
+
+	if (dev->ats)
+		return dev->ats->qdep;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ATS);
+	if (!pos)
+		return -ENODEV;
+
+	pci_read_config_word(dev, pos + PCI_ATS_CAP, &cap);
+
+	return PCI_ATS_CAP_QDEP(cap) ? PCI_ATS_CAP_QDEP(cap) :
+				       PCI_ATS_MAX_QDEP;
+}
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 42fae47..9b4e88c 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -722,145 +722,3 @@ int pci_num_vf(struct pci_dev *dev)
 		return dev->sriov->nr_virtfn;
 }
 EXPORT_SYMBOL_GPL(pci_num_vf);
-
-static int ats_alloc_one(struct pci_dev *dev, int ps)
-{
-	int pos;
-	u16 cap;
-	struct pci_ats *ats;
-
-	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ATS);
-	if (!pos)
-		return -ENODEV;
-
-	ats = kzalloc(sizeof(*ats), GFP_KERNEL);
-	if (!ats)
-		return -ENOMEM;
-
-	ats->pos = pos;
-	ats->stu = ps;
-	pci_read_config_word(dev, pos + PCI_ATS_CAP, &cap);
-	ats->qdep = PCI_ATS_CAP_QDEP(cap) ? PCI_ATS_CAP_QDEP(cap) :
-					    PCI_ATS_MAX_QDEP;
-	dev->ats = ats;
-
-	return 0;
-}
-
-static void ats_free_one(struct pci_dev *dev)
-{
-	kfree(dev->ats);
-	dev->ats = NULL;
-}
-
-/**
- * pci_enable_ats - enable the ATS capability
- * @dev: the PCI device
- * @ps: the IOMMU page shift
- *
- * Returns 0 on success, or negative on failure.
- */
-int pci_enable_ats(struct pci_dev *dev, int ps)
-{
-	int rc;
-	u16 ctrl;
-
-	BUG_ON(dev->ats && dev->ats->is_enabled);
-
-	if (ps < PCI_ATS_MIN_STU)
-		return -EINVAL;
-
-	if (dev->is_physfn || dev->is_virtfn) {
-		struct pci_dev *pdev = dev->is_physfn ? dev : dev->physfn;
-
-		mutex_lock(&pdev->sriov->lock);
-		if (pdev->ats)
-			rc = pdev->ats->stu == ps ? 0 : -EINVAL;
-		else
-			rc = ats_alloc_one(pdev, ps);
-
-		if (!rc)
-			pdev->ats->ref_cnt++;
-		mutex_unlock(&pdev->sriov->lock);
-		if (rc)
-			return rc;
-	}
-
-	if (!dev->is_physfn) {
-		rc = ats_alloc_one(dev, ps);
-		if (rc)
-			return rc;
-	}
-
-	ctrl = PCI_ATS_CTRL_ENABLE;
-	if (!dev->is_virtfn)
-		ctrl |= PCI_ATS_CTRL_STU(ps - PCI_ATS_MIN_STU);
-	pci_write_config_word(dev, dev->ats->pos + PCI_ATS_CTRL, ctrl);
-
-	dev->ats->is_enabled = 1;
-
-	return 0;
-}
-
-/**
- * pci_disable_ats - disable the ATS capability
- * @dev: the PCI device
- */
-void pci_disable_ats(struct pci_dev *dev)
-{
-	u16 ctrl;
-
-	BUG_ON(!dev->ats || !dev->ats->is_enabled);
-
-	pci_read_config_word(dev, dev->ats->pos + PCI_ATS_CTRL, &ctrl);
-	ctrl &= ~PCI_ATS_CTRL_ENABLE;
-	pci_write_config_word(dev, dev->ats->pos + PCI_ATS_CTRL, ctrl);
-
-	dev->ats->is_enabled = 0;
-
-	if (dev->is_physfn || dev->is_virtfn) {
-		struct pci_dev *pdev = dev->is_physfn ? dev : dev->physfn;
-
-		mutex_lock(&pdev->sriov->lock);
-		pdev->ats->ref_cnt--;
-		if (!pdev->ats->ref_cnt)
-			ats_free_one(pdev);
-		mutex_unlock(&pdev->sriov->lock);
-	}
-
-	if (!dev->is_physfn)
-		ats_free_one(dev);
-}
-
-/**
- * pci_ats_queue_depth - query the ATS Invalidate Queue Depth
- * @dev: the PCI device
- *
- * Returns the queue depth on success, or negative on failure.
- *
- * The ATS spec uses 0 in the Invalidate Queue Depth field to
- * indicate that the function can accept 32 Invalidate Request.
- * But here we use the `real' values (i.e. 1~32) for the Queue
- * Depth; and 0 indicates the function shares the Queue with
- * other functions (doesn't exclusively own a Queue).
- */
-int pci_ats_queue_depth(struct pci_dev *dev)
-{
-	int pos;
-	u16 cap;
-
-	if (dev->is_virtfn)
-		return 0;
-
-	if (dev->ats)
-		return dev->ats->qdep;
-
-	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ATS);
-	if (!pos)
-		return -ENODEV;
-
-	pci_read_config_word(dev, pos + PCI_ATS_CAP, &cap);
-
-	return PCI_ATS_CAP_QDEP(cap) ? PCI_ATS_CAP_QDEP(cap) :
-				       PCI_ATS_MAX_QDEP;
-}
diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
index 655824f..4eab42b 100644
--- a/include/linux/pci-ats.h
+++ b/include/linux/pci-ats.h
@@ -1,6 +1,8 @@
 #ifndef LINUX_PCI_ATS_H
 #define LINUX_PCI_ATS_H
 
+#include <linux/pci.h>
+
 /* Address Translation Service */
 struct pci_ats {
 	int pos;        /* capability position */
-- 
1.7.4.1


