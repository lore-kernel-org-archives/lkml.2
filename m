Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab1I0N64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:58:56 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:57239
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680Ab1I0N6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:58:53 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LS6PFI-02-EBJ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/4] PCI: Add support for PASID capability
Date: Tue, 27 Sep 2011 15:57:16 +0200
Message-ID: <1317131836-11822-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317131836-11822-1-git-send-email-joerg.roedel@amd.com>
References: <1317131836-11822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices supporting Process Address Space Identifiers
(PASIDs) can use an IOMMU to access multiple IO address
spaces at the same time. A PCIe device indicates support for
this feature by implementing the PASID capability. This
patch adds support for the capability to the Linux kernel.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/Kconfig      |   13 +++++
 drivers/pci/ats.c        |  113 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci-ats.h  |   31 +++++++++++++
 include/linux/pci_regs.h |    8 +++
 4 files changed, 165 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index fb1e9707..cec6606 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -94,6 +94,19 @@ config PCI_PRI
 
 	  If unsure, say N.
 
+config PCI_PASID
+	bool "PCI PASID support"
+	depends on PCI
+	select PCI_ATS
+	help
+	  Process Address Space Identifiers (PASIDs) can be used by PCI devices
+	  to access more than one IO address space at the same time. To make
+	  use of this feature an IOMMU is required which also supports PASIDs.
+	  Select this option if you have such an IOMMU and want to compile the
+	  driver for it into your kernel.
+
+	  If unsure, say N.
+
 config PCI_IOAPIC
 	bool
 	depends on PCI
diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index bf892a0..f727a09 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -7,6 +7,7 @@
  * PCI Express I/O Virtualization (IOV) support.
  *   Address Translation Service 1.0
  *   Page Request Interface added by Joerg Roedel <joerg.roedel@amd.com>
+ *   PASID support added by Joerg Roedel <joerg.roedel@amd.com>
  */
 
 #include <linux/pci-ats.h>
@@ -323,3 +324,115 @@ int pci_pri_status(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL_GPL(pci_pri_status);
 #endif /* CONFIG_PCI_PRI */
+
+#ifdef CONFIG_PCI_PASID
+/**
+ * pci_enable_pasid - Enable the PASID capability
+ * @pdev: PCI device structure
+ * @features: Features to enable
+ *
+ * Returns 0 on success, negative value on error. This function checks
+ * whether the features are actually supported by the device and returns
+ * an error if not.
+ */
+int pci_enable_pasid(struct pci_dev *pdev, int features)
+{
+	u16 control, supported;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_PASID_CAP);
+	if (!pos)
+		return -EINVAL;
+
+	pci_read_config_word(pdev, pos + PCI_PASID_CONTROL_OFF, &control);
+	pci_read_config_word(pdev, pos + PCI_PASID_CAP_OFF,     &supported);
+
+	if (!(supported & PCI_PASID_ENABLE))
+		return -EINVAL;
+
+	supported &= PCI_PASID_EXEC | PCI_PASID_PRIV;
+
+	/* User wants to enable anything unsupported? */
+	if ((supported & features) != features)
+		return -EINVAL;
+
+	control = PCI_PASID_ENABLE | features;
+
+	pci_write_config_word(pdev, pos + PCI_PASID_CONTROL_OFF, control);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_enable_pasid);
+
+/**
+ * pci_disable_pasid - Disable the PASID capability
+ * @pdev: PCI device structure
+ *
+ */
+void pci_disable_pasid(struct pci_dev *pdev)
+{
+	u16 control = 0;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_PASID_CAP);
+	if (!pos)
+		return;
+
+	pci_write_config_word(pdev, pos + PCI_PASID_CONTROL_OFF, control);
+}
+EXPORT_SYMBOL_GPL(pci_disable_pasid);
+
+/**
+ * pci_pasid_features - Check which PASID features are supported
+ * @pdev: PCI device structure
+ *
+ * Returns a negative value when no PASI capability is present.
+ * Otherwise is returns a bitmask with supported features. Current
+ * features reported are:
+ * PCI_PASID_ENABLE - PASID capability can be enabled
+ * PCI_PASID_EXEC - Execute permission supported
+ * PCI_PASID_PRIV - Priviledged mode supported
+ */
+int pci_pasid_features(struct pci_dev *pdev)
+{
+	u16 supported;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_PASID_CAP);
+	if (!pos)
+		return -EINVAL;
+
+	pci_read_config_word(pdev, pos + PCI_PASID_CAP_OFF, &supported);
+
+	supported &= PCI_PASID_ENABLE | PCI_PASID_EXEC | PCI_PASID_PRIV;
+
+	return supported;
+}
+EXPORT_SYMBOL_GPL(pci_pasid_features);
+
+#define PASID_NUMBER_SHIFT	8
+#define PASID_NUMBER_MASK	(0x1f << PASID_NUMBER_SHIFT)
+/**
+ * pci_max_pasid - Get maximum number of PASIDs supported by device
+ * @pdev: PCI device structure
+ *
+ * Returns negative value when PASID capability is not present.
+ * Otherwise it returns the numer of supported PASIDs.
+ */
+int pci_max_pasids(struct pci_dev *pdev)
+{
+	u16 supported;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_PASID_CAP);
+	if (!pos)
+		return -EINVAL;
+
+	pci_read_config_word(pdev, pos + PCI_PASID_CAP_OFF, &supported);
+
+	supported = (supported & PASID_NUMBER_MASK) >> PASID_NUMBER_SHIFT;
+
+	return (1 << supported);
+}
+EXPORT_SYMBOL_GPL(pci_max_pasids);
+#endif /* CONFIG_PCI_PASID */
diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
index 0713952..e3d0b38 100644
--- a/include/linux/pci-ats.h
+++ b/include/linux/pci-ats.h
@@ -93,4 +93,35 @@ static inline int pci_pri_status(struct pci_dev *pdev)
 }
 #endif /* CONFIG_PCI_PRI */
 
+#ifdef CONFIG_PCI_PASID
+
+extern int pci_enable_pasid(struct pci_dev *pdev, int features);
+extern void pci_disable_pasid(struct pci_dev *pdev);
+extern int pci_pasid_features(struct pci_dev *pdev);
+extern int pci_max_pasids(struct pci_dev *pdev);
+
+#else  /* CONFIG_PCI_PASID */
+
+static inline int pci_enable_pasid(struct pci_dev *pdev, int features)
+{
+	return -EINVAL;
+}
+
+static inline void pci_disable_pasid(struct pci_dev *pdev)
+{
+}
+
+static inline int pci_pasid_features(struct pci_dev *pdev)
+{
+	return -EINVAL;
+}
+
+static inline int pci_max_pasids(struct pci_dev *pdev)
+{
+	return -EINVAL;
+}
+
+#endif /* CONFIG_PCI_PASID */
+
+
 #endif /* LINUX_PCI_ATS_H*/
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index 7fc32af..b5d9657 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -675,6 +675,14 @@
 #define PCI_PRI_MAX_REQ_OFF	0x08	/* Cap offset for max reqs supported */
 #define PCI_PRI_ALLOC_REQ_OFF	0x0c	/* Cap offset for max reqs allowed */
 
+/* PASID capability */
+#define PCI_PASID_CAP		0x1b    /* PASID capability ID */
+#define PCI_PASID_CAP_OFF	0x04    /* PASID feature register */
+#define PCI_PASID_CONTROL_OFF   0x06    /* PASID control register */
+#define PCI_PASID_ENABLE	0x01	/* Enable/Supported bit */
+#define PCI_PASID_EXEC		0x02	/* Exec permissions Enable/Supported */
+#define PCI_PASID_PRIV		0x04	/* Priviledge Mode Enable/Support */
+
 /* Single Root I/O Virtualization */
 #define PCI_SRIOV_CAP		0x04	/* SR-IOV Capabilities */
 #define  PCI_SRIOV_CAP_VFM	0x01	/* VF Migration Capable */
-- 
1.7.4.1


