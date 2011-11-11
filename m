Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab1KKRHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:07:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab1KKRHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:07:38 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/2] PCI: More PRI/PASID cleanup
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        joerg.roedel@amd.com, bhelgaas@google.com
Date: Fri, 11 Nov 2011 10:07:36 -0700
Message-ID: <20111111170702.32668.50363.stgit@bling.home>
In-Reply-To: <20111111170319.32668.48479.stgit@bling.home>
References: <20111111170319.32668.48479.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More consistency cleanups.  Drop the _OFF, separate and indent
CTRL/CAP/STATUS bit definitions.  This helped find the previous
mis-use of bit 0 in the PASID capability register.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/ats.c        |   69 +++++++++++++++++++++++-----------------------
 include/linux/pci_regs.h |   30 +++++++++++---------
 2 files changed, 51 insertions(+), 48 deletions(-)

diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index 8e95a12..2df49af 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -178,17 +178,18 @@ int pci_enable_pri(struct pci_dev *pdev, u32 reqs)
 	if (!pos)
 		return -EINVAL;
 
-	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
-	pci_read_config_word(pdev, pos + PCI_PRI_STATUS_OFF,  &status);
-	if ((control & PCI_PRI_ENABLE) || !(status & PCI_PRI_STATUS_STOPPED))
+	pci_read_config_word(pdev, pos + PCI_PRI_CTRL, &control);
+	pci_read_config_word(pdev, pos + PCI_PRI_STATUS, &status);
+	if ((control & PCI_PRI_CTRL_ENABLE) ||
+	    !(status & PCI_PRI_STATUS_STOPPED))
 		return -EBUSY;
 
-	pci_read_config_dword(pdev, pos + PCI_PRI_MAX_REQ_OFF, &max_requests);
+	pci_read_config_dword(pdev, pos + PCI_PRI_MAX_REQ, &max_requests);
 	reqs = min(max_requests, reqs);
-	pci_write_config_dword(pdev, pos + PCI_PRI_ALLOC_REQ_OFF, reqs);
+	pci_write_config_dword(pdev, pos + PCI_PRI_ALLOC_REQ, reqs);
 
-	control |= PCI_PRI_ENABLE;
-	pci_write_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, control);
+	control |= PCI_PRI_CTRL_ENABLE;
+	pci_write_config_word(pdev, pos + PCI_PRI_CTRL, control);
 
 	return 0;
 }
@@ -209,9 +210,9 @@ void pci_disable_pri(struct pci_dev *pdev)
 	if (!pos)
 		return;
 
-	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
-	control &= ~PCI_PRI_ENABLE;
-	pci_write_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, control);
+	pci_read_config_word(pdev, pos + PCI_PRI_CTRL, &control);
+	control &= ~PCI_PRI_CTRL_ENABLE;
+	pci_write_config_word(pdev, pos + PCI_PRI_CTRL, control);
 }
 EXPORT_SYMBOL_GPL(pci_disable_pri);
 
@@ -230,9 +231,9 @@ bool pci_pri_enabled(struct pci_dev *pdev)
 	if (!pos)
 		return false;
 
-	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
+	pci_read_config_word(pdev, pos + PCI_PRI_CTRL, &control);
 
-	return (control & PCI_PRI_ENABLE) ? true : false;
+	return (control & PCI_PRI_CTRL_ENABLE) ? true : false;
 }
 EXPORT_SYMBOL_GPL(pci_pri_enabled);
 
@@ -252,13 +253,13 @@ int pci_reset_pri(struct pci_dev *pdev)
 	if (!pos)
 		return -EINVAL;
 
-	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
-	if (control & PCI_PRI_ENABLE)
+	pci_read_config_word(pdev, pos + PCI_PRI_CTRL, &control);
+	if (control & PCI_PRI_CTRL_ENABLE)
 		return -EBUSY;
 
-	control |= PCI_PRI_RESET;
+	control |= PCI_PRI_CTRL_RESET;
 
-	pci_write_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, control);
+	pci_write_config_word(pdev, pos + PCI_PRI_CTRL, control);
 
 	return 0;
 }
@@ -285,10 +286,10 @@ bool pci_pri_stopped(struct pci_dev *pdev)
 	if (!pos)
 		return true;
 
-	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
-	pci_read_config_word(pdev, pos + PCI_PRI_STATUS_OFF,  &status);
+	pci_read_config_word(pdev, pos + PCI_PRI_CTRL, &control);
+	pci_read_config_word(pdev, pos + PCI_PRI_STATUS, &status);
 
-	if (control & PCI_PRI_ENABLE)
+	if (control & PCI_PRI_CTRL_ENABLE)
 		return false;
 
 	return (status & PCI_PRI_STATUS_STOPPED) ? true : false;
@@ -314,11 +315,11 @@ int pci_pri_status(struct pci_dev *pdev)
 	if (!pos)
 		return -EINVAL;
 
-	pci_read_config_word(pdev, pos + PCI_PRI_CONTROL_OFF, &control);
-	pci_read_config_word(pdev, pos + PCI_PRI_STATUS_OFF,  &status);
+	pci_read_config_word(pdev, pos + PCI_PRI_CTRL, &control);
+	pci_read_config_word(pdev, pos + PCI_PRI_STATUS, &status);
 
 	/* Stopped bit is undefined when enable == 1, so clear it */
-	if (control & PCI_PRI_ENABLE)
+	if (control & PCI_PRI_CTRL_ENABLE)
 		status &= ~PCI_PRI_STATUS_STOPPED;
 
 	return status;
@@ -345,21 +346,21 @@ int pci_enable_pasid(struct pci_dev *pdev, int features)
 	if (!pos)
 		return -EINVAL;
 
-	pci_read_config_word(pdev, pos + PCI_PASID_CONTROL_OFF, &control);
-	pci_read_config_word(pdev, pos + PCI_PASID_CAP_OFF,     &supported);
+	pci_read_config_word(pdev, pos + PCI_PASID_CTRL, &control);
+	pci_read_config_word(pdev, pos + PCI_PASID_CAP, &supported);
 
-	if (control & PCI_PASID_ENABLE)
+	if (control & PCI_PASID_CTRL_ENABLE)
 		return -EINVAL;
 
-	supported &= PCI_PASID_EXEC | PCI_PASID_PRIV;
+	supported &= PCI_PASID_CAP_EXEC | PCI_PASID_CAP_PRIV;
 
 	/* User wants to enable anything unsupported? */
 	if ((supported & features) != features)
 		return -EINVAL;
 
-	control = PCI_PASID_ENABLE | features;
+	control = PCI_PASID_CTRL_ENABLE | features;
 
-	pci_write_config_word(pdev, pos + PCI_PASID_CONTROL_OFF, control);
+	pci_write_config_word(pdev, pos + PCI_PASID_CTRL, control);
 
 	return 0;
 }
@@ -379,7 +380,7 @@ void pci_disable_pasid(struct pci_dev *pdev)
 	if (!pos)
 		return;
 
-	pci_write_config_word(pdev, pos + PCI_PASID_CONTROL_OFF, control);
+	pci_write_config_word(pdev, pos + PCI_PASID_CTRL, control);
 }
 EXPORT_SYMBOL_GPL(pci_disable_pasid);
 
@@ -390,8 +391,8 @@ EXPORT_SYMBOL_GPL(pci_disable_pasid);
  * Returns a negative value when no PASI capability is present.
  * Otherwise is returns a bitmask with supported features. Current
  * features reported are:
- * PCI_PASID_EXEC - Execute permission supported
- * PCI_PASID_PRIV - Priviledged mode supported
+ * PCI_PASID_CAP_EXEC - Execute permission supported
+ * PCI_PASID_CAP_PRIV - Priviledged mode supported
  */
 int pci_pasid_features(struct pci_dev *pdev)
 {
@@ -402,9 +403,9 @@ int pci_pasid_features(struct pci_dev *pdev)
 	if (!pos)
 		return -EINVAL;
 
-	pci_read_config_word(pdev, pos + PCI_PASID_CAP_OFF, &supported);
+	pci_read_config_word(pdev, pos + PCI_PASID_CAP, &supported);
 
-	supported &= PCI_PASID_EXEC | PCI_PASID_PRIV;
+	supported &= PCI_PASID_CAP_EXEC | PCI_PASID_CAP_PRIV;
 
 	return supported;
 }
@@ -428,7 +429,7 @@ int pci_max_pasids(struct pci_dev *pdev)
 	if (!pos)
 		return -EINVAL;
 
-	pci_read_config_word(pdev, pos + PCI_PASID_CAP_OFF, &supported);
+	pci_read_config_word(pdev, pos + PCI_PASID_CAP, &supported);
 
 	supported = (supported & PASID_NUMBER_MASK) >> PASID_NUMBER_SHIFT;
 
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index 090d3a9..28fe380 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -666,22 +666,24 @@
 #define  PCI_ATS_MIN_STU	12	/* shift of minimum STU block */
 
 /* Page Request Interface */
-#define PCI_PRI_CONTROL_OFF	0x04	/* Offset of control register */
-#define PCI_PRI_STATUS_OFF	0x06	/* Offset of status register */
-#define PCI_PRI_ENABLE		0x0001	/* Enable mask */
-#define PCI_PRI_RESET		0x0002	/* Reset bit mask */
-#define PCI_PRI_STATUS_RF	0x0001  /* Request Failure */
-#define PCI_PRI_STATUS_UPRGI	0x0002  /* Unexpected PRG index */
-#define PCI_PRI_STATUS_STOPPED	0x0100  /* PRI Stopped */
-#define PCI_PRI_MAX_REQ_OFF	0x08	/* Cap offset for max reqs supported */
-#define PCI_PRI_ALLOC_REQ_OFF	0x0c	/* Cap offset for max reqs allowed */
+#define PCI_PRI_CTRL		0x04	/* PRI control register */
+#define  PCI_PRI_CTRL_ENABLE	0x01	/* Enable */
+#define  PCI_PRI_CTRL_RESET	0x02	/* Reset */
+#define PCI_PRI_STATUS		0x06	/* PRI status register */
+#define  PCI_PRI_STATUS_RF	0x001	/* Response Failure */
+#define  PCI_PRI_STATUS_UPRGI	0x002	/* Unexpected PRG index */
+#define  PCI_PRI_STATUS_STOPPED	0x100	/* PRI Stopped */
+#define PCI_PRI_MAX_REQ		0x08	/* PRI max reqs supported */
+#define PCI_PRI_ALLOC_REQ	0x0c	/* PRI max reqs allowed */
 
 /* PASID capability */
-#define PCI_PASID_CAP_OFF	0x04    /* PASID feature register */
-#define PCI_PASID_CONTROL_OFF   0x06    /* PASID control register */
-#define PCI_PASID_ENABLE	0x01	/* Enable/Supported bit */
-#define PCI_PASID_EXEC		0x02	/* Exec permissions Enable/Supported */
-#define PCI_PASID_PRIV		0x04	/* Priviledge Mode Enable/Support */
+#define PCI_PASID_CAP		0x04    /* PASID feature register */
+#define  PCI_PASID_CAP_EXEC	0x02	/* Exec permissions Supported */
+#define  PCI_PASID_CAP_PRIV	0x04	/* Priviledge Mode Supported */
+#define PCI_PASID_CTRL		0x06    /* PASID control register */
+#define  PCI_PASID_CTRL_ENABLE	0x01	/* Enable bit */
+#define  PCI_PASID_CTRL_EXEC	0x02	/* Exec permissions Enable */
+#define  PCI_PASID_CTRL_PRIV	0x04	/* Priviledge Mode Enable */
 
 /* Single Root I/O Virtualization */
 #define PCI_SRIOV_CAP		0x04	/* SR-IOV Capabilities */

