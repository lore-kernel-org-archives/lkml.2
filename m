Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342Ab0J1TnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 15:43:25 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:5214 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760685Ab0J1TnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 15:43:11 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.58,253,1286150400"; 
   d="scan'208";a="208386873"
Date: Thu, 28 Oct 2010 12:43:41 -0700
From: Tom Lyon <pugs@cisco.com>
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        randy.dunlap@oracle.com, arnd@arndb.de, joro@8bytes.org,
        hjk@linutronix.de, avi@redhat.com, gregkh@suse.de, chrisw@sous-sol.org,
        alex.williamson@redhat.com, mst@redhat.com
Subject: [PATCH 1/4] VFIO V5: export pci_user_{read,write}_config
Message-ID: <4cc9d26d.uLL4p1en685Xf3md%pugs@cisco.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by:	Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Tom Lyon <pugs@cisco.com>
---
 drivers/pci/access.c |    6 ++++--
 drivers/pci/pci.h    |    7 -------
 include/linux/pci.h  |    8 ++++++++
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 531bc69..96ed449 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -157,7 +157,8 @@ int pci_user_read_config_##size						\
 	raw_spin_unlock_irq(&pci_lock);				\
 	*val = (type)data;						\
 	return ret;							\
-}
+}									\
+EXPORT_SYMBOL_GPL(pci_user_read_config_##size);
 
 #define PCI_USER_WRITE_CONFIG(size,type)				\
 int pci_user_write_config_##size					\
@@ -171,7 +172,8 @@ int pci_user_write_config_##size					\
 					pos, sizeof(type), val);	\
 	raw_spin_unlock_irq(&pci_lock);				\
 	return ret;							\
-}
+}									\
+EXPORT_SYMBOL_GPL(pci_user_write_config_##size);
 
 PCI_USER_READ_CONFIG(byte, u8)
 PCI_USER_READ_CONFIG(word, u16)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 6beb11b..e1db481 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -77,13 +77,6 @@ static inline bool pci_is_bridge(struct pci_dev *pci_dev)
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
index c8d95e3..7f22c8a 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -756,6 +756,14 @@ static inline int pci_write_config_dword(struct pci_dev *dev, int where,
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
-- 
1.6.0.2

