Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab2KSPDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:03:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868Ab2KSPDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:03:38 -0500
Date: Mon, 19 Nov 2012 16:02:10 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 -tip 2/3] PCI, MSI: Enable multiple MSIs with
 pci_enable_msi_block_auto()
Message-ID: <c3de2419df94a0f95ca1a6f755afc421486455e6.1353324359.git.agordeev@redhat.com>
References: <cover.1353324359.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1353324359.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new function pci_enable_msi_block_auto() tries to allocate maximum
possible number of MSIs up to the number the device supports. It
generalizes a pattern when pci_enable_msi_block() is contiguously called
until it succeeds or fails.

Opposite to pci_enable_msi_block() which takes the number of MSIs to
allocate as a input parameter, pci_enable_msi_block_auto() could be used
by device drivers to obtain the number of assigned MSIs and the number
of MSIs the device supports.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
---
 Documentation/PCI/MSI-HOWTO.txt |   37 ++++++++++++++++++++++++++++++++-----
 drivers/pci/msi.c               |   26 ++++++++++++++++++++++++++
 include/linux/pci.h             |    7 +++++++
 3 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index 53e6fca..a091780 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -127,15 +127,42 @@ on the number of vectors that can be allocated; pci_enable_msi_block()
 returns as soon as it finds any constraint that doesn't allow the
 call to succeed.
 
-4.2.3 pci_disable_msi
+4.2.3 pci_enable_msi_block_auto
+
+int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *count)
+
+This variation on pci_enable_msi() call allows a device driver to request
+the maximum possible number of MSIs.  The MSI specification only allows
+interrupts to be allocated in powers of two, up to a maximum of 2^5 (32).
+
+If this function returns a positive number, it indicates that it has
+succeeded and the returned value is the number of allocated interrupts. In
+this case, the function enables MSI on this device and updates dev->irq to
+be the lowest of the new interrupts assigned to it.  The other interrupts
+assigned to the device are in the range dev->irq to dev->irq + returned
+value - 1.
+
+If this function returns a negative number, it indicates an error and
+the driver should not attempt to request any more MSI interrupts for
+this device.
+
+If the device driver needs to know the number of interrupts the device
+supports it can pass the pointer count where that number is stored. The
+device driver must decide what action to take if pci_enable_msi_block_auto()
+succeeds, but returns a value less than the number of interrupts supported.
+If the device driver does not need to know the number of interrupts
+supported, it can set the pointer count to NULL.
+
+4.2.4 pci_disable_msi
 
 void pci_disable_msi(struct pci_dev *dev)
 
 This function should be used to undo the effect of pci_enable_msi() or
-pci_enable_msi_block().  Calling it restores dev->irq to the pin-based
-interrupt number and frees the previously allocated message signaled
-interrupt(s).  The interrupt may subsequently be assigned to another
-device, so drivers should not cache the value of dev->irq.
+pci_enable_msi_block() or pci_enable_msi_block_auto().  Calling it restores
+dev->irq to the pin-based interrupt number and frees the previously
+allocated message signaled interrupt(s).  The interrupt may subsequently be
+assigned to another device, so drivers should not cache the value of
+dev->irq.
 
 Before calling this function, a device driver must always call free_irq()
 on any interrupt for which it previously called request_irq().
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index a825d78..6ec44e2 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -839,6 +839,32 @@ int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 }
 EXPORT_SYMBOL(pci_enable_msi_block);
 
+int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
+{
+	int ret, pos, nvec;
+	u16 msgctl;
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
+	if (!pos)
+		return -EINVAL;
+
+	pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &msgctl);
+	ret = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
+
+	if (maxvec)
+		*maxvec = ret;
+
+	do {
+		nvec = ret;
+		ret = pci_enable_msi_block(dev, nvec);
+	} while (ret > 0);
+
+	if (ret < 0)
+		return ret;
+	return nvec;
+}
+EXPORT_SYMBOL(pci_enable_msi_block_auto);
+
 void pci_msi_shutdown(struct pci_dev *dev)
 {
 	struct msi_desc *desc;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index ee21795..fbba374 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1080,6 +1080,12 @@ static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 	return -1;
 }
 
+static inline int
+pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
+{
+	return -1;
+}
+
 static inline void pci_msi_shutdown(struct pci_dev *dev)
 { }
 static inline void pci_disable_msi(struct pci_dev *dev)
@@ -1111,6 +1117,7 @@ static inline int pci_msi_enabled(void)
 }
 #else
 extern int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
+extern int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec);
 extern void pci_msi_shutdown(struct pci_dev *dev);
 extern void pci_disable_msi(struct pci_dev *dev);
 extern int pci_msix_table_size(struct pci_dev *dev);
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
