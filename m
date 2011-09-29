Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab1I2Vtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 17:49:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38008 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab1I2Vti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 17:49:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: PME via interrupt or SCI mechanism?
Date: Thu, 29 Sep 2011 23:51:49 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <20110912171003.GA7939@xanatos> <201109292328.45375.rjw@sisk.pl> <201109292338.48690.rjw@sisk.pl>
In-Reply-To: <201109292338.48690.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109292351.50176.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 29, 2011, Rafael J. Wysocki wrote:
> On Thursday, September 29, 2011, Rafael J. Wysocki wrote:
> > On Thursday, September 29, 2011, Sarah Sharp wrote:
> > > On Thu, Sep 29, 2011 at 09:39:56PM +0200, Rafael J. Wysocki wrote:
> > > > On Thursday, September 29, 2011, Sarah Sharp wrote:
> > > > > On Thu, Sep 29, 2011 at 12:21:28AM +0200, Rafael J. Wysocki wrote:
> > > > Please try the appended patch and check if you see the "Notification error
> > > > for GPE" message (please keep your previous debug patches applied).
> > > 
> > > Do I need to have the ACPI debug_level or debug_layer set to anything in
> > > particular to see this message?
> > 
> > No, I don't think so, but just in case please try the patch below instead
> > of the previous one.
> 
> Actually, please don't, it's a BIOS-related issue after all.  Apparently,
> wakeup from xHCD is not supported by the BIOS, because the DSDT defines
> the _L0D method for GPE 0D (13), which is the following:
> 
>         Method (_L0D, 0, NotSerialized)
>         {
>             Notify (\_SB.PCI0.EHC1, 0x02)
>             Notify (\_SB.PCI0.EHC2, 0x02)
>             Notify (\_SB.PCI0.HDEF, 0x02)
>             Notify (\_SB.PCI0.GLAN, 0x02)
>         }
> 
> so it notifies some devices, but not the xHCD.
> 
> We might work around this by doing what Matthew has suggested (ie. polling
> all PCI and PCIe devices to check if they have PME pending) or perhaps
> we can do something about this in ACPICA.
> 
> Still, the right fix is to put Notify () for the ACPI objects
> corresponding to xHCD into the above method.

Or to remove this method altogether (in which case our ACPICA code
should take care of the notifications).

Below is a patch (untested!) that should help, but it's kind of
suboptimal.  Nevertheless, please try if it works for you.

Thanks,
Rafael


---
 drivers/pci/pci.c |   57 +++++++++++++++++++-----------------------------------
 1 file changed, 21 insertions(+), 36 deletions(-)

Index: linux/drivers/pci/pci.c
===================================================================
--- linux.orig/drivers/pci/pci.c
+++ linux/drivers/pci/pci.c
@@ -1458,19 +1458,6 @@ static void pci_pme_list_scan(struct wor
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
@@ -1480,6 +1467,7 @@ static bool pci_external_pme(struct pci_
  */
 void pci_pme_active(struct pci_dev *dev, bool enable)
 {
+	struct pci_pme_device *pme_dev;
 	u16 pmcsr;
 
 	if (!dev->pm_cap)
@@ -1503,31 +1491,28 @@ void pci_pme_active(struct pci_dev *dev,
 	   hit, and the power savings from the devices will still be a
 	   win. */
 
-	if (pci_external_pme(dev)) {
-		struct pci_pme_device *pme_dev;
-		if (enable) {
-			pme_dev = kmalloc(sizeof(struct pci_pme_device),
-					  GFP_KERNEL);
-			if (!pme_dev)
-				goto out;
-			pme_dev->dev = dev;
-			mutex_lock(&pci_pme_list_mutex);
-			list_add(&pme_dev->list, &pci_pme_list);
-			if (list_is_singular(&pci_pme_list))
-				schedule_delayed_work(&pci_pme_work,
-						      msecs_to_jiffies(PME_TIMEOUT));
-			mutex_unlock(&pci_pme_list_mutex);
-		} else {
-			mutex_lock(&pci_pme_list_mutex);
-			list_for_each_entry(pme_dev, &pci_pme_list, list) {
-				if (pme_dev->dev == dev) {
-					list_del(&pme_dev->list);
-					kfree(pme_dev);
-					break;
-				}
+	if (enable) {
+		pme_dev = kmalloc(sizeof(struct pci_pme_device), GFP_KERNEL);
+		if (!pme_dev)
+			goto out;
+
+		pme_dev->dev = dev;
+		mutex_lock(&pci_pme_list_mutex);
+		list_add(&pme_dev->list, &pci_pme_list);
+		if (list_is_singular(&pci_pme_list))
+			schedule_delayed_work(&pci_pme_work,
+					      msecs_to_jiffies(PME_TIMEOUT));
+		mutex_unlock(&pci_pme_list_mutex);
+	} else {
+		mutex_lock(&pci_pme_list_mutex);
+		list_for_each_entry(pme_dev, &pci_pme_list, list) {
+			if (pme_dev->dev == dev) {
+				list_del(&pme_dev->list);
+				kfree(pme_dev);
+				break;
 			}
-			mutex_unlock(&pci_pme_list_mutex);
 		}
+		mutex_unlock(&pci_pme_list_mutex);
 	}
 
 out:
