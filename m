Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab1DQPUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 11:20:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4890 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1DQPUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 11:20:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=RWDDIDCMFduABINgYn3XOkoUvPY+92eNytos4ile8iKaLnhLntNFLCSq+n8opLVgA
	1si8UKrZfNizhMJo4Z3aw==
From: Greg Thelen <gthelen@google.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Thelen <gthelen@google.com>
Subject: [PATCH] PCI: handle positive error codes
Date: Sun, 17 Apr 2011 08:20:32 -0700
Message-Id: <1303053632-32650-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Callers expect pci_user_{read,write}_config_*() to indicate errors by
returning negative values.  Prior to this change, the indicated routines
could return positive error codes (e.g. PCIBIOS_BAD_REGISTER_NUMBER)
which callers would mistakenly interpret as success.

This change converts any non-zero return from the mentioned routines
into unambiguous negative value return codes.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 drivers/pci/access.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 531bc69..502610b 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -143,33 +143,41 @@ static noinline void pci_wait_ucfg(struct pci_dev *dev)
 	__remove_wait_queue(&pci_ucfg_wait, &wait);
 }
 
+/* Returns 0 on success, negative values indicate error. */
 #define PCI_USER_READ_CONFIG(size,type)					\
 int pci_user_read_config_##size						\
 	(struct pci_dev *dev, int pos, type *val)			\
 {									\
 	int ret = 0;							\
 	u32 data = -1;							\
-	if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;	\
+	if (PCI_##size##_BAD)						\
+		return -EINVAL;						\
 	raw_spin_lock_irq(&pci_lock);				\
 	if (unlikely(dev->block_ucfg_access)) pci_wait_ucfg(dev);	\
 	ret = dev->bus->ops->read(dev->bus, dev->devfn,			\
 					pos, sizeof(type), &data);	\
 	raw_spin_unlock_irq(&pci_lock);				\
 	*val = (type)data;						\
+	if (ret > 0)							\
+		ret = -EINVAL;						\
 	return ret;							\
 }
 
+/* Returns 0 on success, negative values indicate error. */
 #define PCI_USER_WRITE_CONFIG(size,type)				\
 int pci_user_write_config_##size					\
 	(struct pci_dev *dev, int pos, type val)			\
 {									\
 	int ret = -EIO;							\
-	if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;	\
+	if (PCI_##size##_BAD)						\
+		return -EINVAL;						\
 	raw_spin_lock_irq(&pci_lock);				\
 	if (unlikely(dev->block_ucfg_access)) pci_wait_ucfg(dev);	\
 	ret = dev->bus->ops->write(dev->bus, dev->devfn,		\
 					pos, sizeof(type), val);	\
 	raw_spin_unlock_irq(&pci_lock);				\
+	if (ret > 0)							\
+		ret = -EINVAL;						\
 	return ret;							\
 }
 
@@ -197,6 +205,8 @@ struct pci_vpd_pci22 {
  * This code has to spin since there is no other notification from the PCI
  * hardware. Since the VPD is often implemented by serial attachment to an
  * EEPROM, it may take many milliseconds to complete.
+ *
+ * Returns 0 on success, negative values indicate error.
  */
 static int pci_vpd_pci22_wait(struct pci_dev *dev)
 {
@@ -212,7 +222,7 @@ static int pci_vpd_pci22_wait(struct pci_dev *dev)
 	for (;;) {
 		ret = pci_user_read_config_word(dev, vpd->cap + PCI_VPD_ADDR,
 						&status);
-		if (ret)
+		if (ret < 0)
 			return ret;
 
 		if ((status & PCI_VPD_ADDR_F) == vpd->flag) {
-- 
1.7.3.1

