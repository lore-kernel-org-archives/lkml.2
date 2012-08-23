Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2HWQiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:38:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab2HWQhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:37:22 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, linux-efi@vger.kernel.org, mfleming@intel.com,
        dwmw2@infradead.org, bhelgaas@google.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V3 2/4] PCI: Add pcibios_add_device
Date: Thu, 23 Aug 2012 12:36:41 -0400
Message-Id: <1345739803-21017-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1345739803-21017-1-git-send-email-mjg@redhat.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platforms may want to provide architecture-specific functionality during
PCI enumeration. Add a pcibios_add_device() call that architectures can
override to do so.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/pci/bus.c   |  5 +++++
 drivers/pci/pci.c   | 13 +++++++++++++
 include/linux/pci.h |  1 +
 3 files changed, 19 insertions(+)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 4b0970b..e2f447e 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -166,6 +166,11 @@ int pci_bus_add_device(struct pci_dev *dev)
 	int retval;
 
 	pci_fixup_device(pci_fixup_final, dev);
+
+	retval = pcibios_add_device(dev);
+	if (retval)
+		return retval;
+
 	retval = device_add(&dev->dev);
 	if (retval)
 		return retval;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index f3ea977..5a9a4d8 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1385,6 +1385,19 @@ void pcim_pin_device(struct pci_dev *pdev)
 		dr->pinned = 1;
 }
 
+/*
+ * pcibios_add_device - provide arch specific hooks when adding device dev
+ * @dev: the PCI device being added
+ *
+ * Permits the platform to provide architecture specific functionality when
+ * devices are added. This is the default implementation. Architecture
+ * implementations can override this.
+ */
+int __attribute__ ((weak)) pcibios_add_device (struct pci_dev *dev)
+{
+	return 0;
+}
+
 /**
  * pcibios_disable_device - disable arch specific PCI resources for device dev
  * @dev: the PCI device to disable
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5faa831..6a2625c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1582,6 +1582,7 @@ void pcibios_disable_device(struct pci_dev *dev);
 void pcibios_set_master(struct pci_dev *dev);
 int pcibios_set_pcie_reset_state(struct pci_dev *dev,
 				 enum pcie_reset_state state);
+int pcibios_add_device(struct pci_dev *dev);
 
 #ifdef CONFIG_PCI_MMCONFIG
 extern void __init pci_mmcfg_early_init(void);
-- 
1.7.11.2

