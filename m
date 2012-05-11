Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964823Ab2EKW5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:57:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759814Ab2EKW4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:56:55 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 10/13] pci: export pci_user functions for use by other drivers
To: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org
Cc: chrisw@sous-sol.org, agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, alex.williamson@redhat.com
Date: Fri, 11 May 2012 16:56:37 -0600
Message-ID: <20120511225636.30496.26907.stgit@bling.home>
In-Reply-To: <20120511222148.30496.68571.stgit@bling.home>
References: <20120511222148.30496.68571.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO PCI support will make use of these for user initiated
PCI config accesses.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/access.c |    6 ++++--
 drivers/pci/pci.h    |    7 -------
 include/linux/pci.h  |    8 ++++++++
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 2a58164..ba91a7e 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -162,7 +162,8 @@ int pci_user_read_config_##size						\
 	if (ret > 0)							\
 		ret = -EINVAL;						\
 	return ret;							\
-}
+}									\
+EXPORT_SYMBOL_GPL(pci_user_read_config_##size);
 
 /* Returns 0 on success, negative values indicate error. */
 #define PCI_USER_WRITE_CONFIG(size,type)				\
@@ -181,7 +182,8 @@ int pci_user_write_config_##size					\
 	if (ret > 0)							\
 		ret = -EINVAL;						\
 	return ret;							\
-}
+}									\
+EXPORT_SYMBOL_GPL(pci_user_write_config_##size);
 
 PCI_USER_READ_CONFIG(byte, u8)
 PCI_USER_READ_CONFIG(word, u16)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index e8f2f8f..68e3475 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -86,13 +86,6 @@ static inline bool pci_is_bridge(struct pci_dev *pci_dev)
 	return !!(pci_dev->subordinate);
 }
 
-extern int pci_user_read_config_byte(struct pci_dev *dev, int where, u8 *val);
-extern int pci_user_read_config_word(struct pci_dev *dev, int where, u16 *val);
-extern int pci_user_read_config_dword(struct pci_dev *dev, int where, u32 *val);
-extern int pci_user_write_config_byte(struct pci_dev *dev, int where, u8 val);
-extern int pci_user_write_config_word(struct pci_dev *dev, int where, u16 val);
-extern int pci_user_write_config_dword(struct pci_dev *dev, int where, u32 val);
-
 struct pci_vpd_ops {
 	ssize_t (*read)(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
 	ssize_t (*write)(struct pci_dev *dev, loff_t pos, size_t count, const void *buf);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index dc25da3..b437225 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -770,6 +770,14 @@ static inline int pci_write_config_dword(const struct pci_dev *dev, int where,
 	return pci_bus_write_config_dword(dev->bus, dev->devfn, where, val);
 }
 
+/* user-space driven config access */
+extern int pci_user_read_config_byte(struct pci_dev *dev, int where, u8 *val);
+extern int pci_user_read_config_word(struct pci_dev *dev, int where, u16 *val);
+extern int pci_user_read_config_dword(struct pci_dev *dev, int where, u32 *val);
+extern int pci_user_write_config_byte(struct pci_dev *dev, int where, u8 val);
+extern int pci_user_write_config_word(struct pci_dev *dev, int where, u16 val);
+extern int pci_user_write_config_dword(struct pci_dev *dev, int where, u32 val);
+
 int __must_check pci_enable_device(struct pci_dev *dev);
 int __must_check pci_enable_device_io(struct pci_dev *dev);
 int __must_check pci_enable_device_mem(struct pci_dev *dev);

