Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab1IVPwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 11:52:00 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:42849
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416Ab1IVPv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 11:51:56 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRXLA8-01-1FL-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/4] PCI: Add implementation for PRI capability
Date: Thu, 22 Sep 2011 17:49:10 +0200
Message-ID: <1316706551-16138-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316706551-16138-1-git-send-email-joerg.roedel@amd.com>
References: <1316706551-16138-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the necessary functions to handle PRI capabilities
on PCIe devices. With PRI devices behind an IOMMU can signal
page fault conditions to software and recover from such
faults.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/Kconfig      |    9 +++
 drivers/pci/ats.c        |  167 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci-ats.h  |   42 ++++++++++++
 include/linux/pci_regs.h |   12 +++
 4 files changed, 230 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 1d8ce83..fb1e9707 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -85,6 +85,15 @@ config PCI_IOV
 
 	  If unsure, say N.
 
+config PCI_PRI
+	bool "PCI PRI support"
+	select PCI_ATS
+	help
+	  PRI is the PCI Page Request Interface. It allows PCI devices that are
+	  behind an IOMMU to recover from page faults.
+
+	  If unsure, say N.
+
 config PCI_IOAPIC
 	bool
 	depends on PCI
diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index 5ceff3e..bf892a0 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -2,9 +2,11 @@
  * drivers/pci/ats.c
  *
  * Copyright (C) 2009 Intel Corporation, Yu Zhao <yu.zhao@intel.com>
+ * Copyright (C) 2011 Advanced Micro Devices,
  *
  * PCI Express I/O Virtualization (IOV) support.
  *   Address Translation Service 1.0
+ *   Page Request Interface added by Joerg Roedel <joerg.roedel@amd.com>
  */
 
 #include <linux/pci-ats.h>
@@ -156,3 +158,168 @@ int pci_ats_queue_depth(struct pci_dev *dev)
 				       PCI_ATS_MAX_QDEP;
 }
 EXPORT_SYMBOL_GPL(pci_ats_queue_depth);
+
+#ifdef CONFIG_PCI_PRI
+/**
+ * pci_enable_pri - Enable PRI capability
+ * @ pdev: PCI device structure
+ *
+ * Returns 0 on success, negative value on error
+ */
+int pci_enable_pri(struct pci_dev *pdev, u32 reqs)
+{
+	u16 control, status;
+	u32 max_requests;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	if (!pos)
+		return -EINVAL;
+
+	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
+	pci_read_config_word(pdev, pos + PCI_PRI_STATUS_OFF,  &status);
+	if ((control & PCI_PRI_ENABLE) || !(status & PCI_PRI_STATUS_STOPPED))
+		return -EBUSY;
+
+	pci_read_config_dword(pdev, pos + PCI_PRI_MAX_REQ_OFF, &max_requests);
+	reqs = min(max_requests, reqs);
+	pci_write_config_dword(pdev, pos + PCI_PRI_ALLOC_REQ_OFF, reqs);
+
+	control |= PCI_PRI_ENABLE;
+	pci_write_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, control);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_enable_pri);
+
+/**
+ * pci_disable_pri - Disable PRI capability
+ * @pdev: PCI device structure
+ *
+ * Only clears the enabled-bit, regardless of its former value
+ */
+void pci_disable_pri(struct pci_dev *pdev)
+{
+	u16 control;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	if (!pos)
+		return;
+
+	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
+	control &= ~PCI_PRI_ENABLE;
+	pci_write_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, control);
+}
+EXPORT_SYMBOL_GPL(pci_disable_pri);
+
+/**
+ * pci_pri_enabled - Checks if PRI capability is enabled
+ * @pdev: PCI device structure
+ *
+ * Returns true if PRI is enabled on the device, false otherwise
+ */
+bool pci_pri_enabled(struct pci_dev *pdev)
+{
+	u16 control;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	if (!pos)
+		return false;
+
+	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
+
+	return (control & PCI_PRI_ENABLE) ? true : false;
+}
+EXPORT_SYMBOL_GPL(pci_pri_enabled);
+
+/**
+ * pci_reset_pri - Resets device's PRI state
+ * @pdev: PCI device structure
+ *
+ * The PRI capability must be disabled before this function is called.
+ * Returns 0 on success, negative value on error.
+ */
+int pci_reset_pri(struct pci_dev *pdev)
+{
+	u16 control;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	if (!pos)
+		return -EINVAL;
+
+	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
+	if (control & PCI_PRI_ENABLE)
+		return -EBUSY;
+
+	control |= PCI_PRI_RESET;
+
+	pci_write_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, control);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_reset_pri);
+
+/**
+ * pci_pri_stopped - Checks whether the PRI capability is stopped
+ * @pdev: PCI device structure
+ *
+ * Returns true if the PRI capability on the device is disabled and the
+ * device has no outstanding PRI requests, false otherwise. The device
+ * indicates this via the STOPPED bit in the status register of the
+ * capability.
+ * The device internal state can be cleared by resetting the PRI state
+ * with pci_reset_pri(). This can force the capability into the STOPPED
+ * state.
+ */
+bool pci_pri_stopped(struct pci_dev *pdev)
+{
+	u16 control, status;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	if (!pos)
+		return true;
+
+	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
+	pci_read_config_word(pdev, pos + PCI_PRI_STATUS_OFF,  &status);
+
+	if (control & PCI_PRI_ENABLE)
+		return false;
+
+	return (status & PCI_PRI_STATUS_STOPPED) ? true : false;
+}
+EXPORT_SYMBOL_GPL(pci_pri_stopped);
+
+/**
+ * pci_pri_status - Request PRI status of a device
+ * @pdev: PCI device structure
+ *
+ * Returns negative value on failure, status on success. The status can
+ * be checked against status-bits. Supported bits are currently:
+ * PCI_PRI_STATUS_RF:      Response failure
+ * PCI_PRI_STATUS_UPRGI:   Unexpected Page Request Group Index
+ * PCI_PRI_STATUS_STOPPED: PRI has stopped
+ */
+int pci_pri_status(struct pci_dev *pdev)
+{
+	u16 status, control;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_PRI_CAP);
+	if (!pos)
+		return -EINVAL;
+
+	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
+	pci_read_config_word(pdev, pos + PCI_PRI_STATUS_OFF,  &status);
+
+	/* Stopped bit is undefined when enable == 1, so clear it */
+	if (control & PCI_PRI_ENABLE)
+		status &= ~PCI_PRI_STATUS_STOPPED;
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(pci_pri_status);
+#endif /* CONFIG_PCI_PRI */
diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
index 4eab42b..0713952 100644
--- a/include/linux/pci-ats.h
+++ b/include/linux/pci-ats.h
@@ -17,6 +17,7 @@ struct pci_ats {
 extern int pci_enable_ats(struct pci_dev *dev, int ps);
 extern void pci_disable_ats(struct pci_dev *dev);
 extern int pci_ats_queue_depth(struct pci_dev *dev);
+
 /**
  * pci_ats_enabled - query the ATS status
  * @dev: the PCI device
@@ -51,4 +52,45 @@ static inline int pci_ats_enabled(struct pci_dev *dev)
 
 #endif /* CONFIG_PCI_IOV */
 
+#ifdef CONFIG_PCI_PRI
+
+extern int  pci_enable_pri(struct pci_dev *pdev, u32 reqs);
+extern void pci_disable_pri(struct pci_dev *pdev);
+extern bool pci_pri_enabled(struct pci_dev *pdev);
+extern int  pci_reset_pri(struct pci_dev *pdev);
+extern bool pci_pri_stopped(struct pci_dev *pdev);
+extern int  pci_pri_status(struct pci_dev *pdev);
+
+#else /* CONFIG_PCI_PRI */
+
+static inline int pci_enable_pri(struct pci_dev *pdev, u32 reqs)
+{
+	return -ENODEV;
+}
+
+static inline void pci_disable_pri(struct pci_dev *pdev)
+{
+}
+
+static inline bool pci_pri_enabled(struct pci_dev *pdev)
+{
+	return false;
+}
+
+static inline int pci_reset_pri(struct pci_dev *pdev)
+{
+	return -ENODEV;
+}
+
+static inline bool pci_pri_stopped(struct pci_dev *pdev)
+{
+	return true;
+}
+
+static inline int pci_pri_status(struct pci_dev *pdev)
+{
+	return -ENODEV;
+}
+#endif /* CONFIG_PCI_PRI */
+
 #endif /* LINUX_PCI_ATS_H*/
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index e884096..7fc32af 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -663,6 +663,18 @@
 #define  PCI_ATS_CTRL_STU(x)	((x) & 0x1f)	/* Smallest Translation Unit */
 #define  PCI_ATS_MIN_STU	12	/* shift of minimum STU block */
 
+/* Page Request Interface */
+#define PCI_PRI_CAP		0x13    /* PRI capability ID */
+#define PCI_PRI_CONTROL_OFF	0x04	/* Offset of control register */
+#define PCI_PRI_STATUS_OFF	0x06	/* Offset of status register */
+#define PCI_PRI_ENABLE		0x0001	/* Enable mask */
+#define PCI_PRI_RESET		0x0002	/* Reset bit mask */
+#define PCI_PRI_STATUS_RF	0x0001  /* Request Failure */
+#define PCI_PRI_STATUS_UPRGI	0x0002  /* Unexpected PRG index */
+#define PCI_PRI_STATUS_STOPPED	0x0100  /* PRI Stopped */
+#define PCI_PRI_MAX_REQ_OFF	0x08	/* Cap offset for max reqs supported */
+#define PCI_PRI_ALLOC_REQ_OFF	0x0c	/* Cap offset for max reqs allowed */
+
 /* Single Root I/O Virtualization */
 #define PCI_SRIOV_CAP		0x04	/* SR-IOV Capabilities */
 #define  PCI_SRIOV_CAP_VFM	0x01	/* VF Migration Capable */
-- 
1.7.4.1


