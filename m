Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab0LSO5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 09:57:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39009 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073Ab0LSO5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 09:57:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Wilcox <matthew@wil.cx>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI / PCIe: Clear Root PME Status bits early during system resume
Date: Sun, 19 Dec 2010 15:57:16 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: linux-pci@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201012191149.40547.rjw@sisk.pl> <201012191341.23601.rjw@sisk.pl> <201012191354.47960.rjw@sisk.pl>
In-Reply-To: <201012191354.47960.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012191557.16403.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

I noticed that PCI Express PMEs don't work on my Toshiba Portege R500
after the system has been woken up from a sleep state by a PME
(through Wake-on-LAN).  After some investigation it turned out that
the BIOS didn't clear the Root PME Status bit in the root port that
received the wakeup PME and since the Requester ID was also set in
the port's Root Status register, any subsequent PMEs didn't trigger
interrupts.

This problem can be avoided by clearing the Root PME Status bits in
all PCI Express root ports during early resume.  For this purpose,
add an early resume routine to the PCIe port driver and make this
driver be always registered, even if pci_ports_disable is set (in
which case the driver's only function is to provide the early
resume callback).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Hi,

I think this one is better (tested on Toshiba Portege R500).

Thanks,
Rafael

---
 drivers/pci/pcie/pme.c          |   27 ++++-----------------------
 drivers/pci/pcie/portdrv.h      |    2 ++
 drivers/pci/pcie/portdrv_core.c |   25 ++++++++++++++-----------
 drivers/pci/pcie/portdrv_pci.c  |   37 +++++++++++++++++++++++++++++++++----
 include/linux/pci_regs.h        |    2 ++
 5 files changed, 55 insertions(+), 38 deletions(-)

Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-2.6/drivers/pci/pcie/portdrv_core.c
@@ -241,17 +241,17 @@ static int get_port_device_capability(st
 	int cap_mask;
 	int err;
 
+	if (pcie_ports_disabled)
+		return 0;
+
 	err = pcie_port_platform_notify(dev, &cap_mask);
-	if (pcie_ports_auto) {
-		if (err) {
-			pcie_no_aspm();
-			return 0;
-		}
-	} else {
+	if (!pcie_ports_auto) {
 		cap_mask = PCIE_PORT_SERVICE_PME | PCIE_PORT_SERVICE_HP
 				| PCIE_PORT_SERVICE_VC;
 		if (pci_aer_available())
 			cap_mask |= PCIE_PORT_SERVICE_AER;
+	} else if (err) {
+			return 0;
 	}
 
 	pos = pci_pcie_cap(dev);
@@ -349,15 +349,18 @@ int pcie_port_device_register(struct pci
 	int status, capabilities, i, nr_service;
 	int irqs[PCIE_PORT_DEVICE_MAXSERVICES];
 
-	/* Get and check PCI Express port services */
-	capabilities = get_port_device_capability(dev);
-	if (!capabilities)
-		return -ENODEV;
-
 	/* Enable PCI Express port device */
 	status = pci_enable_device(dev);
 	if (status)
 		return status;
+
+	/* Get and check PCI Express port services */
+	capabilities = get_port_device_capability(dev);
+	if (!capabilities) {
+		pcie_no_aspm();
+		return 0;
+	}
+
 	pci_set_master(dev);
 	/*
 	 * Initialize service irqs. Don't use service devices that
Index: linux-2.6/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_pci.c
+++ linux-2.6/drivers/pci/pcie/portdrv_pci.c
@@ -57,6 +57,22 @@ __setup("pcie_ports=", pcie_port_setup);
 
 /* global data */
 
+/**
+ * pcie_clear_root_pme_status - Clear root port PME interrupt status.
+ * @dev: PCIe root port or event collector.
+ */
+void pcie_clear_root_pme_status(struct pci_dev *dev)
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
 static int pcie_portdrv_restore_config(struct pci_dev *dev)
 {
 	int retval;
@@ -69,6 +85,20 @@ static int pcie_portdrv_restore_config(s
 }
 
 #ifdef CONFIG_PM
+static int pcie_port_resume_noirq(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	/*
+	 * Some BIOSes forget to clear Root PME Status bits after system wakeup
+	 * which breaks ACPI-based runtime wakeup on PCI Express, so clear those
+	 * bits now just in case (shouldn't hurt).
+	 */
+	if(pdev->pcie_type == PCI_EXP_TYPE_ROOT_PORT)
+		pcie_clear_root_pme_status(pdev);
+	return 0;
+}
+
 static const struct dev_pm_ops pcie_portdrv_pm_ops = {
 	.suspend	= pcie_port_device_suspend,
 	.resume		= pcie_port_device_resume,
@@ -76,6 +106,7 @@ static const struct dev_pm_ops pcie_port
 	.thaw		= pcie_port_device_resume,
 	.poweroff	= pcie_port_device_suspend,
 	.restore	= pcie_port_device_resume,
+	.resume_noirq	= pcie_port_resume_noirq,
 };
 
 #define PCIE_PORTDRV_PM_OPS	(&pcie_portdrv_pm_ops)
@@ -327,10 +358,8 @@ static int __init pcie_portdrv_init(void
 {
 	int retval;
 
-	if (pcie_ports_disabled) {
-		pcie_no_aspm();
-		return -EACCES;
-	}
+	if (pcie_ports_disabled)
+		return pci_register_driver(&pcie_portdriver);
 
 	dmi_check_system(pcie_portdrv_dmi_table);
 
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
+			pcie_clear_root_pme_status(port);
 
 			spin_unlock_irq(&data->lock);
 			pcie_pme_handle_request(port, rtsta & 0xffff);
@@ -378,7 +359,7 @@ static int pcie_pme_probe(struct pcie_de
 
 	port = srv->port;
 	pcie_pme_interrupt_enable(port, false);
-	pcie_pme_clear_status(port);
+	pcie_clear_root_pme_status(port);
 
 	ret = request_irq(srv->irq, pcie_pme_irq, IRQF_SHARED, "PCIe PME", srv);
 	if (ret) {
@@ -402,7 +383,7 @@ static int pcie_pme_suspend(struct pcie_
 
 	spin_lock_irq(&data->lock);
 	pcie_pme_interrupt_enable(port, false);
-	pcie_pme_clear_status(port);
+	pcie_clear_root_pme_status(port);
 	data->noirq = true;
 	spin_unlock_irq(&data->lock);
 
@@ -422,7 +403,7 @@ static int pcie_pme_resume(struct pcie_d
 
 	spin_lock_irq(&data->lock);
 	data->noirq = false;
-	pcie_pme_clear_status(port);
+	pcie_clear_root_pme_status(port);
 	pcie_pme_interrupt_enable(port, true);
 	spin_unlock_irq(&data->lock);
 
Index: linux-2.6/drivers/pci/pcie/portdrv.h
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv.h
+++ linux-2.6/drivers/pci/pcie/portdrv.h
@@ -35,6 +35,8 @@ extern void pcie_port_bus_unregister(voi
 
 struct pci_dev;
 
+extern void pcie_clear_root_pme_status(struct pci_dev *dev);
+
 #ifdef CONFIG_PCIE_PME
 extern bool pcie_pme_msi_disabled;
 
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
