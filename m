Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab1I3US4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:18:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40389 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab1I3USy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:18:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: PME via interrupt or SCI mechanism?
Date: Fri, 30 Sep 2011 22:21:06 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <20110912171003.GA7939@xanatos> <20110929225700.GA6207@xanatos> <201109301840.20402.rjw@sisk.pl>
In-Reply-To: <201109301840.20402.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201109302221.06714.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 30, 2011, Rafael J. Wysocki wrote:
> On Friday, September 30, 2011, Sarah Sharp wrote:
> > On Thu, Sep 29, 2011 at 11:51:49PM +0200, Rafael J. Wysocki wrote:
> > > On Thursday, September 29, 2011, Rafael J. Wysocki wrote:
> > > > On Thursday, September 29, 2011, Rafael J. Wysocki wrote:
> > > > > On Thursday, September 29, 2011, Sarah Sharp wrote:
> > > > > > On Thu, Sep 29, 2011 at 09:39:56PM +0200, Rafael J. Wysocki wrote:
> > > > > > > On Thursday, September 29, 2011, Sarah Sharp wrote:
> > > > > > > > On Thu, Sep 29, 2011 at 12:21:28AM +0200, Rafael J. Wysocki wrote:
> > > > > > > Please try the appended patch and check if you see the "Notification error
> > > > > > > for GPE" message (please keep your previous debug patches applied).
> > > > > > 
> > > > > > Do I need to have the ACPI debug_level or debug_layer set to anything in
> > > > > > particular to see this message?
> > > > > 
> > > > > No, I don't think so, but just in case please try the patch below instead
> > > > > of the previous one.
> > > > 
> > > > Actually, please don't, it's a BIOS-related issue after all.  Apparently,
> > > > wakeup from xHCD is not supported by the BIOS, because the DSDT defines
> > > > the _L0D method for GPE 0D (13), which is the following:
> > > > 
> > > >         Method (_L0D, 0, NotSerialized)
> > > >         {
> > > >             Notify (\_SB.PCI0.EHC1, 0x02)
> > > >             Notify (\_SB.PCI0.EHC2, 0x02)
> > > >             Notify (\_SB.PCI0.HDEF, 0x02)
> > > >             Notify (\_SB.PCI0.GLAN, 0x02)
> > > >         }
> > > > 
> > > > so it notifies some devices, but not the xHCD.
> > 
> > Ok, I'll let our BIOS guys know they need to add the XHC Notify line.
> 
> As stated below, it actually may be better to remove the _L0D method
> entirely, because our ACPICA GPE handling code should take care of
> notifying all of the devices associated with GPE 0D in that case.
> 
> > I should see if the x220 ACPI tables have a similar issue or it's a
> > different issue with D3.
> 
> Yes, that would be good to know.
> 
> > > > We might work around this by doing what Matthew has suggested (ie. polling
> > > > all PCI and PCIe devices to check if they have PME pending) or perhaps
> > > > we can do something about this in ACPICA.
> > > > 
> > > > Still, the right fix is to put Notify () for the ACPI objects
> > > > corresponding to xHCD into the above method.
> > > 
> > > Or to remove this method altogether (in which case our ACPICA code
> > > should take care of the notifications).
> > > 
> > > Below is a patch (untested!) that should help, but it's kind of
> > > suboptimal.  Nevertheless, please try if it works for you.
> > 
> > The patch seems to finally get the host controller out of D3 when a
> > remote wakeup is triggered.
> 
> OK
> 
> I'll try to prepare a better patch for you to test.

OK, please test the appended patch.  The difference is that it should only
continuously poll devices that don't get notifications.  You'll still see
the debug messages from your previous patches, but this one should be a bit
less wasteful than the previous one in general.

Thanks,
Rafael


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
