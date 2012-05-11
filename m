Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864Ab2EKW6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:58:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964828Ab2EKW5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:57:06 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 11/13] pci: Create common pcibios_err_to_errno
To: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org
Cc: chrisw@sous-sol.org, agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, alex.williamson@redhat.com
Date: Fri, 11 May 2012 16:56:44 -0600
Message-ID: <20120511225643.30496.36823.stgit@bling.home>
In-Reply-To: <20120511222148.30496.68571.stgit@bling.home>
References: <20120511222148.30496.68571.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For returning errors out to non-PCI code.  Re-name xen's version.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
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
index b437225..20a8f2e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -467,6 +467,32 @@ static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev) { return false;
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

