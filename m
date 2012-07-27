Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2G0Qxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 12:53:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab2G0Qwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 12:52:47 -0400
From: Matthew Garrett <mjg@redhat.com>
To: matt.fleming@intel.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V2 2/4] PCI: Add pcibios_add_device
Date: Fri, 27 Jul 2012 12:52:12 -0400
Message-Id: <1343407934-459-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1343407934-459-1-git-send-email-mjg@redhat.com>
References: <1343407934-459-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platforms may want to provide architecture-specific functionality during
PCI enumeration. Add a pcibios_add_device() call that architectures can
override to do so.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Tested-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/pci/bus.c   |    5 +++++
 drivers/pci/pci.c   |   13 +++++++++++++
 include/linux/pci.h |    1 +
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
index f3ea977..fec3a92 100644
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
+int __weak pcibios_add_device(struct pci_dev *dev)
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
1.7.10.4

