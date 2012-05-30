Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab2E3UJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:09:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644Ab2E3UJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:09:20 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 3/5] pci: export pci_user functions for use by other drivers
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, konrad.wilk@oracle.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        ddutile@redhat.com, alex.williamson@redhat.com,
        shangw@linux.vnet.ibm.com, liuj97@gmail.com
Date: Wed, 30 May 2012 14:08:55 -0600
Message-ID: <20120530200855.31085.941.stgit@bling.home>
In-Reply-To: <20120530200343.31085.78920.stgit@bling.home>
References: <20120530200343.31085.78920.stgit@bling.home>
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
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
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
index e494347..f2dcc46 100644
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
index 2fa696e..2274ff1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -777,6 +777,14 @@ static inline int pci_write_config_dword(const struct pci_dev *dev, int where,
 	return pci_bus_write_config_dword(dev->bus, dev->devfn, where, val);
 }
 
+/* user-space driven config access */
+int pci_user_read_config_byte(struct pci_dev *dev, int where, u8 *val);
+int pci_user_read_config_word(struct pci_dev *dev, int where, u16 *val);
+int pci_user_read_config_dword(struct pci_dev *dev, int where, u32 *val);
+int pci_user_write_config_byte(struct pci_dev *dev, int where, u8 val);
+int pci_user_write_config_word(struct pci_dev *dev, int where, u16 val);
+int pci_user_write_config_dword(struct pci_dev *dev, int where, u32 val);
+
 int __must_check pci_enable_device(struct pci_dev *dev);
 int __must_check pci_enable_device_io(struct pci_dev *dev);
 int __must_check pci_enable_device_mem(struct pci_dev *dev);

