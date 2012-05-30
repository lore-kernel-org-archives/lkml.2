Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2E3UKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:10:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab2E3UJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:09:48 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 4/5] pci: Create common pcibios_err_to_errno
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, konrad.wilk@oracle.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        ddutile@redhat.com, alex.williamson@redhat.com,
        shangw@linux.vnet.ibm.com, liuj97@gmail.com
Date: Wed, 30 May 2012 14:09:07 -0600
Message-ID: <20120530200907.31085.71368.stgit@bling.home>
In-Reply-To: <20120530200343.31085.78920.stgit@bling.home>
References: <20120530200343.31085.78920.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For returning errors out to non-PCI code.  Re-name xen's version.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---

 drivers/xen/xen-pciback/conf_space.c |    6 +++---
 include/linux/pci.h                  |   26 ++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xen-pciback/conf_space.c b/drivers/xen/xen-pciback/conf_space.c
index 30d7be0..46ae0f9 100644
--- a/drivers/xen/xen-pciback/conf_space.c
+++ b/drivers/xen/xen-pciback/conf_space.c
@@ -124,7 +124,7 @@ static inline u32 merge_value(u32 val, u32 new_val, u32 new_val_mask,
 	return val;
 }
 
-static int pcibios_err_to_errno(int err)
+static int xen_pcibios_err_to_errno(int err)
 {
 	switch (err) {
 	case PCIBIOS_SUCCESSFUL:
@@ -202,7 +202,7 @@ out:
 		       pci_name(dev), size, offset, value);
 
 	*ret_val = value;
-	return pcibios_err_to_errno(err);
+	return xen_pcibios_err_to_errno(err);
 }
 
 int xen_pcibk_config_write(struct pci_dev *dev, int offset, int size, u32 value)
@@ -290,7 +290,7 @@ int xen_pcibk_config_write(struct pci_dev *dev, int offset, int size, u32 value)
 		}
 	}
 
-	return pcibios_err_to_errno(err);
+	return xen_pcibios_err_to_errno(err);
 }
 
 void xen_pcibk_config_free_dyn_fields(struct pci_dev *dev)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2274ff1..66e196f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -474,6 +474,32 @@ static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev) { return false;
 #define PCIBIOS_SET_FAILED		0x88
 #define PCIBIOS_BUFFER_TOO_SMALL	0x89
 
+/*
+ * Translate above to generic errno for passing back through non-pci.
+ */
+static inline int pcibios_err_to_errno(int err)
+{
+	if (err <= PCIBIOS_SUCCESSFUL)
+		return err; /* Assume already errno */
+
+	switch (err) {
+	case PCIBIOS_FUNC_NOT_SUPPORTED:
+		return -ENOENT;
+	case PCIBIOS_BAD_VENDOR_ID:
+		return -EINVAL;
+	case PCIBIOS_DEVICE_NOT_FOUND:
+		return -ENODEV;
+	case PCIBIOS_BAD_REGISTER_NUMBER:
+		return -EFAULT;
+	case PCIBIOS_SET_FAILED:
+		return -EIO;
+	case PCIBIOS_BUFFER_TOO_SMALL:
+		return -ENOSPC;
+	}
+
+	return -ENOTTY;
+}
+
 /* Low-level architecture-dependent routines */
 
 struct pci_ops {

