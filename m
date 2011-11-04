Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1KDIqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 04:46:21 -0400
Received: from thoth.sbs.de ([192.35.17.2]:33764 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab1KDIqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 04:46:15 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 2/3] pci: Introduce INTx check & mask API
Date: Fri,  4 Nov 2011 09:46:00 +0100
Message-Id: <1c76cbaa8181b83e49b3d2fd106e773afafe80c5.1320396359.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1320396359.git.jan.kiszka@siemens.com>
References: <cover.1320396359.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1320396359.git.jan.kiszka@siemens.com>
References: <cover.1320396359.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These new PCI services allow to probe for 2.3-compliant INTx masking
support and then use the feature from PCI interrupt handlers. The
services are properly synchronized with concurrent config space access
via sysfs or on device reset.

This enables generic PCI device drivers like uio_pci_generic or KVM's
device assignment to implement the necessary kernel-side IRQ handling
without any knowledge about device-specific interrupt status and control
registers.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 drivers/pci/access.c |    2 +-
 drivers/pci/pci.c    |  110 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h    |    2 +
 include/linux/pci.h  |    3 +
 4 files changed, 116 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 0c4c717..2a58164 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -13,7 +13,7 @@
  * configuration space.
  */
 
-static DEFINE_RAW_SPINLOCK(pci_lock);
+DEFINE_RAW_SPINLOCK(pci_lock);
 
 /*
  *  Wrappers for all PCI configuration access functions.  They just check
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e40fdaa..89bc546 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2761,6 +2761,116 @@ pci_intx(struct pci_dev *pdev, int enable)
 }
 
 /**
+ * pci_intx_mask_supported - probe for INTx masking support
+ * @pdev: the PCI device to operate on
+ *
+ * Check if the device dev support INTx masking via the config space
+ * command word.
+ */
+bool pci_intx_mask_supported(struct pci_dev *dev)
+{
+	bool mask_supported = false;
+	u16 orig, new;
+
+	pci_cfg_access_lock(dev);
+
+	pci_read_config_word(dev, PCI_COMMAND, &orig);
+	pci_write_config_word(dev, PCI_COMMAND,
+			      orig ^ PCI_COMMAND_INTX_DISABLE);
+	pci_read_config_word(dev, PCI_COMMAND, &new);
+
+	/*
+	 * There's no way to protect against hardware bugs or detect them
+	 * reliably, but as long as we know what the value should be, let's
+	 * go ahead and check it.
+	 */
+	if ((new ^ orig) & ~PCI_COMMAND_INTX_DISABLE) {
+		dev_err(&dev->dev, "Command register changed from "
+			"0x%x to 0x%x: driver or hardware bug?\n", orig, new);
+	} else if ((new ^ orig) & PCI_COMMAND_INTX_DISABLE) {
+		mask_supported = true;
+		pci_write_config_word(dev, PCI_COMMAND, orig);
+	}
+
+	pci_cfg_access_unlock(dev);
+	return mask_supported;
+}
+EXPORT_SYMBOL_GPL(pci_intx_mask_supported);
+
+static bool pci_check_and_set_intx_mask(struct pci_dev *dev, bool mask)
+{
+	struct pci_bus *bus = dev->bus;
+	bool mask_updated = true;
+	u32 cmd_status_dword;
+	u16 origcmd, newcmd;
+	unsigned long flags;
+	bool irq_pending;
+
+	/*
+	 * We do a single dword read to retrieve both command and status.
+	 * Document assumptions that make this possible.
+	 */
+	BUILD_BUG_ON(PCI_COMMAND % 4);
+	BUILD_BUG_ON(PCI_COMMAND + 2 != PCI_STATUS);
+
+	raw_spin_lock_irqsave(&pci_lock, flags);
+
+	bus->ops->read(bus, dev->devfn, PCI_COMMAND, 4, &cmd_status_dword);
+
+	irq_pending = (cmd_status_dword >> 16) & PCI_STATUS_INTERRUPT;
+
+	/*
+	 * Check interrupt status register to see whether our device
+	 * triggered the interrupt (when masking) or the next IRQ is
+	 * already pending (when unmasking).
+	 */
+	if (mask != irq_pending) {
+		mask_updated = false;
+		goto done;
+	}
+
+	origcmd = cmd_status_dword;
+	newcmd = origcmd & ~PCI_COMMAND_INTX_DISABLE;
+	if (mask)
+		newcmd |= PCI_COMMAND_INTX_DISABLE;
+	if (newcmd != origcmd)
+		bus->ops->write(bus, dev->devfn, PCI_COMMAND, 2, newcmd);
+
+done:
+	raw_spin_unlock_irqrestore(&pci_lock, flags);
+
+	return mask_updated;
+}
+
+/**
+ * pci_check_and_mask_intx - mask INTx on pending interrupt
+ * @pdev: the PCI device to operate on
+ *
+ * Check if the device dev has its INTx line asserted, mask it and
+ * return true in that case. False is returned if not interrupt was
+ * pending.
+ */
+bool pci_check_and_mask_intx(struct pci_dev *dev)
+{
+	return pci_check_and_set_intx_mask(dev, true);
+}
+EXPORT_SYMBOL_GPL(pci_check_and_mask_intx);
+
+/**
+ * pci_check_and_mask_intx - unmask INTx of no interrupt is pending
+ * @pdev: the PCI device to operate on
+ *
+ * Check if the device dev has its INTx line asserted, unmask it if not
+ * and return true. False is returned and the mask remains active if
+ * there was still an interrupt pending.
+ */
+bool pci_check_and_unmask_intx(struct pci_dev *dev)
+{
+	return pci_check_and_set_intx_mask(dev, false);
+}
+EXPORT_SYMBOL_GPL(pci_check_and_unmask_intx);
+
+/**
  * pci_msi_off - disables any msi or msix capabilities
  * @dev: the PCI device to operate on
  *
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index b74084e..3b6e4ed 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -136,6 +136,8 @@ static inline void pci_remove_legacy_files(struct pci_bus *bus) { return; }
 /* Lock for read/write access to pci device and bus lists */
 extern struct rw_semaphore pci_bus_sem;
 
+extern raw_spinlock_t pci_lock;
+
 extern unsigned int pci_pm_d3_delay;
 
 #ifdef CONFIG_PCI_MSI
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 033fe76..1cc3ac1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -803,6 +803,9 @@ int __must_check pci_set_mwi(struct pci_dev *dev);
 int pci_try_set_mwi(struct pci_dev *dev);
 void pci_clear_mwi(struct pci_dev *dev);
 void pci_intx(struct pci_dev *dev, int enable);
+bool pci_intx_mask_supported(struct pci_dev *dev);
+bool pci_check_and_mask_intx(struct pci_dev *dev);
+bool pci_check_and_unmask_intx(struct pci_dev *dev);
 void pci_msi_off(struct pci_dev *dev);
 int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
 int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask);
-- 
1.7.3.4

