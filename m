Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab1JCVO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:14:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45634 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757577Ab1JCVOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 17:14:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI / PM: Extend PME polling to all PCI devices
Date: Mon, 3 Oct 2011 23:16:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110032316.33786.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The land of PCI power management is a land of sorrow and ugliness,
especially in the area of signaling events by devices.  There are
devices that set their PME Status bits, but don't really bother
to send a PME message or assert PME#.  There are hardware vendors
who don't connect PME# lines to the system core logic (they know
who they are).  There are PCI Express Root Ports that don't bother
to trigger interrupts when they receive PME messages from the devices
below.  There are ACPI BIOSes that forget to provide _PRW methods for
devices capable of signaling wakeup.  Finally, there are BIOSes that
do provide _PRW methods for such devices, but then don't bother to
call Notify() for those devices from the corresponding _Lxx/_Exx
GPE-handling methods.  In all of these cases the kernel doesn't have
a chance to receive a proper notification that it should wake up a
device, so devices stay in low-power states forever.  Worse yet, in
some cases they continuously send PME Messages that are silently
ignored, because the kernel simply doesn't know that it should clear
the device's PME Status bit.

This problem was first observed for "parallel" (non-Express) PCI
devices on add-on cards and Matthew Garrett addressed it by adding
code that polls PME Status bits of such devices, if they are enabled
to signal PME, to the kernel.  Recently, however, it has turned out
that PCI Express devices are also affected by this issue and that it
is not limited to add-on devices, so it seems necessary to extend
the PME polling to all PCI devices, including PCI Express and planar
ones.  Still, it would be wasteful to poll the PME Status bits of
devices that are known to receive proper PME notifications, so make
the kernel (1) poll the PME Status bits of all PCI and PCIe devices
enabled to signal PME and (2) disable the PME Status polling for
devices for which correct PME notifications are received.

Tested-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-acpi.c |    3 +++
 drivers/pci/pci.c      |   41 ++++++++++++++++++++---------------------
 drivers/pci/pcie/pme.c |    9 +++++++++
 include/linux/pci.h    |    1 +
 4 files changed, 33 insertions(+), 21 deletions(-)

Index: linux/include/linux/pci.h
===================================================================
--- linux.orig/include/linux/pci.h
+++ linux/include/linux/pci.h
@@ -273,6 +273,7 @@ struct pci_dev {
 	unsigned int	pme_support:5;	/* Bitmask of states from which PME#
 					   can be generated */
 	unsigned int	pme_interrupt:1;
+	unsigned int	pme_poll:1;	/* Poll device's PME status bit */
 	unsigned int	d1_support:1;	/* Low power state D1 is supported */
 	unsigned int	d2_support:1;	/* Low power state D2 is supported */
 	unsigned int	no_d1d2:1;	/* Only allow D0 and D3 */
Index: linux/drivers/pci/pci-acpi.c
===================================================================
--- linux.orig/drivers/pci/pci-acpi.c
+++ linux/drivers/pci/pci-acpi.c
@@ -46,6 +46,9 @@ static void pci_acpi_wake_dev(acpi_handl
 	struct pci_dev *pci_dev = context;
 
 	if (event == ACPI_NOTIFY_DEVICE_WAKE && pci_dev) {
+		if (pci_dev->pme_poll)
+			pci_dev->pme_poll = false;
+
 		pci_wakeup_event(pci_dev);
 		pci_check_pme_status(pci_dev);
 		pm_runtime_resume(&pci_dev->dev);
Index: linux/drivers/pci/pci.c
===================================================================
--- linux.orig/drivers/pci/pci.c
+++ linux/drivers/pci/pci.c
@@ -1407,13 +1407,16 @@ bool pci_check_pme_status(struct pci_dev
 /**
  * pci_pme_wakeup - Wake up a PCI device if its PME Status bit is set.
  * @dev: Device to handle.
- * @ign: Ignored.
+ * @pme_poll_reset: Whether or not to reset the device's pme_poll flag.
  *
  * Check if @dev has generated PME and queue a resume request for it in that
  * case.
  */
-static int pci_pme_wakeup(struct pci_dev *dev, void *ign)
+static int pci_pme_wakeup(struct pci_dev *dev, void *pme_poll_reset)
 {
+	if (pme_poll_reset && dev->pme_poll)
+		dev->pme_poll = false;
+
 	if (pci_check_pme_status(dev)) {
 		pci_wakeup_event(dev);
 		pm_request_resume(&dev->dev);
@@ -1428,7 +1431,7 @@ static int pci_pme_wakeup(struct pci_dev
 void pci_pme_wakeup_bus(struct pci_bus *bus)
 {
 	if (bus)
-		pci_walk_bus(bus, pci_pme_wakeup, NULL);
+		pci_walk_bus(bus, pci_pme_wakeup, (void *)true);
 }
 
 /**
@@ -1446,31 +1449,26 @@ bool pci_pme_capable(struct pci_dev *dev
 
 static void pci_pme_list_scan(struct work_struct *work)
 {
-	struct pci_pme_device *pme_dev;
+	struct pci_pme_device *pme_dev, *n;
 
 	mutex_lock(&pci_pme_list_mutex);
 	if (!list_empty(&pci_pme_list)) {
-		list_for_each_entry(pme_dev, &pci_pme_list, list)
-			pci_pme_wakeup(pme_dev->dev, NULL);
-		schedule_delayed_work(&pci_pme_work, msecs_to_jiffies(PME_TIMEOUT));
+		list_for_each_entry_safe(pme_dev, n, &pci_pme_list, list) {
+			if (pme_dev->dev->pme_poll) {
+				pci_pme_wakeup(pme_dev->dev, NULL);
+			} else {
+				list_del(&pme_dev->list);
+				kfree(pme_dev);
+			}
+		}
+		if (!list_empty(&pci_pme_list))
+			schedule_delayed_work(&pci_pme_work,
+					      msecs_to_jiffies(PME_TIMEOUT));
 	}
 	mutex_unlock(&pci_pme_list_mutex);
 }
 
 /**
- * pci_external_pme - is a device an external PCI PME source?
- * @dev: PCI device to check
- *
- */
-
-static bool pci_external_pme(struct pci_dev *dev)
-{
-	if (pci_is_pcie(dev) || dev->bus->number == 0)
-		return false;
-	return true;
-}
-
-/**
  * pci_pme_active - enable or disable PCI device's PME# function
  * @dev: PCI device to handle.
  * @enable: 'true' to enable PME# generation; 'false' to disable it.
@@ -1503,7 +1501,7 @@ void pci_pme_active(struct pci_dev *dev,
 	   hit, and the power savings from the devices will still be a
 	   win. */
 
-	if (pci_external_pme(dev)) {
+	if (dev->pme_poll) {
 		struct pci_pme_device *pme_dev;
 		if (enable) {
 			pme_dev = kmalloc(sizeof(struct pci_pme_device),
@@ -1821,6 +1819,7 @@ void pci_pm_init(struct pci_dev *dev)
 			 (pmc & PCI_PM_CAP_PME_D3) ? " D3hot" : "",
 			 (pmc & PCI_PM_CAP_PME_D3cold) ? " D3cold" : "");
 		dev->pme_support = pmc >> PCI_PM_CAP_PME_SHIFT;
+		dev->pme_poll = true;
 		/*
 		 * Make device's PM flags reflect the wake-up capability, but
 		 * let the user space enable it to wake up the system as needed.
Index: linux/drivers/pci/pcie/pme.c
===================================================================
--- linux.orig/drivers/pci/pcie/pme.c
+++ linux/drivers/pci/pcie/pme.c
@@ -84,6 +84,9 @@ static bool pcie_pme_walk_bus(struct pci
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		/* Skip PCIe devices in case we started from a root port. */
 		if (!pci_is_pcie(dev) && pci_check_pme_status(dev)) {
+			if (dev->pme_poll)
+				dev->pme_poll = false;
+
 			pci_wakeup_event(dev);
 			pm_request_resume(&dev->dev);
 			ret = true;
@@ -142,6 +145,9 @@ static void pcie_pme_handle_request(stru
 
 	/* First, check if the PME is from the root port itself. */
 	if (port->devfn == devfn && port->bus->number == busnr) {
+		if (port->pme_poll)
+			port->pme_poll = false;
+
 		if (pci_check_pme_status(port)) {
 			pm_request_resume(&port->dev);
 			found = true;
@@ -187,6 +193,9 @@ static void pcie_pme_handle_request(stru
 		/* The device is there, but we have to check its PME status. */
 		found = pci_check_pme_status(dev);
 		if (found) {
+			if (dev->pme_poll)
+				dev->pme_poll = false;
+
 			pci_wakeup_event(dev);
 			pm_request_resume(&dev->dev);
 		}
