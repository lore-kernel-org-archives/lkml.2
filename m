Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2FKP1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:27:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab2FKP1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:27:42 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v3 2/5] pci: Add ACS validation utility
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, konrad.wilk@oracle.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        ddutile@redhat.com, alex.williamson@redhat.com
Date: Mon, 11 Jun 2012 09:27:07 -0600
Message-ID: <20120611152707.25959.60516.stgit@bling.home>
In-Reply-To: <20120611152021.25959.71601.stgit@bling.home>
References: <20120611152021.25959.71601.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a PCI environment, transactions aren't always required to reach
the root bus before being re-routed.  Intermediate switches between
an endpoint and the root bus can redirect DMA back downstream before
things like IOMMUs have a chance to intervene.  Legacy PCI is always
susceptible to this as it operates on a shared bus.  PCIe added a
new capability to describe and control this behavior, Access Control
Services, or ACS.  The utility function pci_acs_enabled() allows us
to test the ACS capabilities of an individual devices against a set
of flags while pci_acs_path_enabled() tests a complete path from
a given downstream device up to the specified upstream device.  We
also include the ability to add device specific tests as it's
likely we'll see devices that do no implement ACS, but want to
indicate support for various capabilities in this space.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/pci.c    |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/quirks.c |   33 ++++++++++++++++++++++++
 include/linux/pci.h  |   10 +++++++
 3 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 447e834..1ccf7d4 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2360,6 +2360,75 @@ void pci_enable_acs(struct pci_dev *dev)
 }
 
 /**
+ * pci_acs_enabled - test ACS against required flags for a given device
+ * @pdev: device to test
+ * @acs_flags: required PCI ACS flags
+ *
+ * Return true if the device supports the provided flags.  Automatically
+ * filters out flags that are not implemented on multifunction devices.
+ */
+bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
+{
+	int pos, ret;
+	u16 ctrl;
+
+	ret = pci_dev_specific_acs_enabled(pdev, acs_flags);
+	if (ret >= 0)
+		return ret > 0;
+
+	if (!pci_is_pcie(pdev))
+		return false;
+
+	/* Filter out flags not applicable to multifunction */
+	if (pdev->multifunction)
+		acs_flags &= (PCI_ACS_RR | PCI_ACS_CR |
+			      PCI_ACS_EC | PCI_ACS_DT);
+
+	if (pdev->pcie_type == PCI_EXP_TYPE_DOWNSTREAM ||
+	    pdev->pcie_type == PCI_EXP_TYPE_ROOT_PORT ||
+	    pdev->multifunction) {
+		pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
+		if (!pos)
+			return false;
+
+		pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
+		if ((ctrl & acs_flags) != acs_flags)
+			return false;
+	}
+
+	return true;
+}
+
+/**
+ * pci_acs_path_enable - test ACS flags from start to end in a hierarchy
+ * @start: starting downstream device
+ * @end: ending upstream device or NULL to search to the root bus
+ * @acs_flags: required flags
+ *
+ * Walk up a device tree from start to end testing PCI ACS support.  If
+ * any step along the way does not support the required flags, return false.
+ */
+bool pci_acs_path_enabled(struct pci_dev *start,
+			  struct pci_dev *end, u16 acs_flags)
+{
+	struct pci_dev *pdev, *parent = start;
+
+	do {
+		pdev = parent;
+
+		if (!pci_acs_enabled(pdev, acs_flags))
+			return false;
+
+		if (pci_is_root_bus(pdev->bus))
+			return (end == NULL);
+
+		parent = pdev->bus->self;
+	} while (pdev != end);
+
+	return true;
+}
+
+/**
  * pci_swizzle_interrupt_pin - swizzle INTx for device behind bridge
  * @dev: the PCI device
  * @pin: the INTx pin (1=INTA, 2=INTB, 3=INTD, 4=INTD)
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index acd3956..27e2c8f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3230,3 +3230,36 @@ struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
 
 	return pci_dev_get(dev);
 }
+
+static const struct pci_dev_acs_enabled {
+	u16 vendor;
+	u16 device;
+	int (*acs_enabled)(struct pci_dev *dev, u16 acs_flags);
+} pci_dev_acs_enabled[] = {
+	{ 0 }
+};
+
+int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags)
+{
+	const struct pci_dev_acs_enabled *i;
+	int ret;
+
+	/*
+	 * Allow devices that do not expose standard PCIe ACS capabilities
+	 * or control to indicate their support here.  Multi-function express
+	 * devices which do not allow internal peer-to-peer between functions,
+	 * but do not implement PCIe ACS may wish to return true here.
+	 */
+	for (i = pci_dev_acs_enabled; i->acs_enabled; i++) {
+		if ((i->vendor == dev->vendor ||
+		     i->vendor == (u16)PCI_ANY_ID) &&
+		    (i->device == dev->device ||
+		     i->device == (u16)PCI_ANY_ID)) {
+			ret = i->acs_enabled(dev, acs_flags);
+			if (ret >= 0)
+				return ret;
+		}
+	}
+
+	return -ENOTTY;
+}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6badba3..ba51a21 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1487,6 +1487,7 @@ enum pci_fixup_pass {
 #ifdef CONFIG_PCI_QUIRKS
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
 struct pci_dev *pci_get_dma_source(struct pci_dev *dev);
+int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
 #else
 static inline void pci_fixup_device(enum pci_fixup_pass pass,
 				    struct pci_dev *dev) {}
@@ -1494,6 +1495,11 @@ static inline struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
 {
 	return pci_dev_get(dev);
 }
+static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
+					       u16 acs_flags)
+{
+	return -ENOTTY;
+}
 #endif
 
 void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
@@ -1596,7 +1602,9 @@ static inline bool pci_is_pcie(struct pci_dev *dev)
 }
 
 void pci_request_acs(void);
-
+bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags);
+bool pci_acs_path_enabled(struct pci_dev *start,
+			  struct pci_dev *end, u16 acs_flags);
 
 #define PCI_VPD_LRDT			0x80	/* Large Resource Data Type */
 #define PCI_VPD_LRDT_ID(x)		(x | PCI_VPD_LRDT)

