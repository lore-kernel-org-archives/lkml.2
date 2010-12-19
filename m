Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0LSKuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 05:50:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38184 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab0LSKuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 05:50:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pci@vger.kernel.org
Subject: [PATCH] PCI / PCIe: Clear Root PME Status bits during early resume
Date: Sun, 19 Dec 2010 11:49:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012191149.40547.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

I noticed that PCI Express PMEs don't work on my Toshiba Portege R500
after the system has been woken up from a sleep state by a PME
(through Wake-on-LAN).  After some investigation it turned out that
the BIOS didn't clear the Root PME Status bit in the root port that
received the wakeup PME and since the Requester ID was also set in
the port's Root Status register, subsequent PMEs didn't trigger
interrupts.

This problem can be avoided by clearing the Root PME Status bits in
all PCI Express root ports during early resume (it needs to be done
in pci_pm_default_resume_early() and not in the port's resume
routine, because it's generally necessary even if the PCI Express
port driver is not used).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |    7 +++++++
 drivers/pci/pci.c        |   16 ++++++++++++++++
 drivers/pci/pcie/pme.c   |   27 ++++-----------------------
 include/linux/pci.h      |    1 +
 include/linux/pci_regs.h |    2 ++
 5 files changed, 30 insertions(+), 23 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -456,6 +456,13 @@ static void pci_pm_default_resume_early(
 {
 	pci_restore_standard_config(pci_dev);
 	pci_fixup_device(pci_fixup_resume_early, pci_dev);
+	/*
+	 * Some BIOSes forget to clear Root PME Status bits after system wakeup
+	 * which breaks ACPI-based runtime wakeup on PCI Express, so clear those
+	 * bits now just in case (shouldn't hurt).
+	 */
+	if(pci_is_pcie(pci_dev) && pci_dev->pcie_type == PCI_EXP_TYPE_ROOT_PORT)
+		pcie_pme_clear_root_status(pci_dev);
 }
 
 #endif
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1266,6 +1266,22 @@ int pci_set_pcie_reset_state(struct pci_
 }
 
 /**
+ * pcie_pme_clear_root_status - Clear root port PME interrupt status.
+ * @dev: PCIe root port or event collector.
+ */
+void pcie_pme_clear_root_status(struct pci_dev *dev)
+{
+	int rtsta_pos;
+	u32 rtsta;
+
+	rtsta_pos = pci_pcie_cap(dev) + PCI_EXP_RTSTA;
+
+	pci_read_config_dword(dev, rtsta_pos, &rtsta);
+	rtsta |= PCI_EXP_RTSTA_PME;
+	pci_write_config_dword(dev, rtsta_pos, rtsta);
+}
+
+/**
  * pci_check_pme_status - Check if given device has generated PME.
  * @dev: Device to check.
  *
Index: linux-2.6/drivers/pci/pcie/pme.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/pme.c
+++ linux-2.6/drivers/pci/pcie/pme.c
@@ -26,9 +26,6 @@
 #include "../pci.h"
 #include "portdrv.h"
 
-#define PCI_EXP_RTSTA_PME	0x10000 /* PME status */
-#define PCI_EXP_RTSTA_PENDING	0x20000 /* PME pending */
-
 /*
  * If this switch is set, MSI will not be used for PCIe PME signaling.  This
  * causes the PCIe port driver to use INTx interrupts only, but it turns out
@@ -74,22 +71,6 @@ void pcie_pme_interrupt_enable(struct pc
 }
 
 /**
- * pcie_pme_clear_status - Clear root port PME interrupt status.
- * @dev: PCIe root port or event collector.
- */
-static void pcie_pme_clear_status(struct pci_dev *dev)
-{
-	int rtsta_pos;
-	u32 rtsta;
-
-	rtsta_pos = pci_pcie_cap(dev) + PCI_EXP_RTSTA;
-
-	pci_read_config_dword(dev, rtsta_pos, &rtsta);
-	rtsta |= PCI_EXP_RTSTA_PME;
-	pci_write_config_dword(dev, rtsta_pos, rtsta);
-}
-
-/**
  * pcie_pme_walk_bus - Scan a PCI bus for devices asserting PME#.
  * @bus: PCI bus to scan.
  *
@@ -253,7 +234,7 @@ static void pcie_pme_work_fn(struct work
 			 * Clear PME status of the port.  If there are other
 			 * pending PMEs, the status will be set again.
 			 */
-			pcie_pme_clear_status(port);
+			pcie_pme_clear_root_status(port);
 
 			spin_unlock_irq(&data->lock);
 			pcie_pme_handle_request(port, rtsta & 0xffff);
@@ -378,7 +359,7 @@ static int pcie_pme_probe(struct pcie_de
 
 	port = srv->port;
 	pcie_pme_interrupt_enable(port, false);
-	pcie_pme_clear_status(port);
+	pcie_pme_clear_root_status(port);
 
 	ret = request_irq(srv->irq, pcie_pme_irq, IRQF_SHARED, "PCIe PME", srv);
 	if (ret) {
@@ -402,7 +383,7 @@ static int pcie_pme_suspend(struct pcie_
 
 	spin_lock_irq(&data->lock);
 	pcie_pme_interrupt_enable(port, false);
-	pcie_pme_clear_status(port);
+	pcie_pme_clear_root_status(port);
 	data->noirq = true;
 	spin_unlock_irq(&data->lock);
 
@@ -422,7 +403,7 @@ static int pcie_pme_resume(struct pcie_d
 
 	spin_lock_irq(&data->lock);
 	data->noirq = false;
-	pcie_pme_clear_status(port);
+	pcie_pme_clear_root_status(port);
 	pcie_pme_interrupt_enable(port, true);
 	spin_unlock_irq(&data->lock);
 
Index: linux-2.6/include/linux/pci_regs.h
===================================================================
--- linux-2.6.orig/include/linux/pci_regs.h
+++ linux-2.6/include/linux/pci_regs.h
@@ -496,6 +496,8 @@
 #define  PCI_EXP_RTCTL_CRSSVE	0x10	/* CRS Software Visibility Enable */
 #define PCI_EXP_RTCAP		30	/* Root Capabilities */
 #define PCI_EXP_RTSTA		32	/* Root Status */
+#define PCI_EXP_RTSTA_PME	0x10000 /* PME status */
+#define PCI_EXP_RTSTA_PENDING	0x20000 /* PME pending */
 #define PCI_EXP_DEVCAP2		36	/* Device Capabilities 2 */
 #define  PCI_EXP_DEVCAP2_ARI	0x20	/* Alternative Routing-ID */
 #define PCI_EXP_DEVCTL2		40	/* Device Control 2 */
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -821,6 +821,7 @@ int pci_back_from_sleep(struct pci_dev *
 bool pci_dev_run_wake(struct pci_dev *dev);
 bool pci_check_pme_status(struct pci_dev *dev);
 void pci_pme_wakeup_bus(struct pci_bus *bus);
+void pcie_pme_clear_root_status(struct pci_dev *dev);
 
 static inline int pci_enable_wake(struct pci_dev *dev, pci_power_t state,
 				  bool enable)
