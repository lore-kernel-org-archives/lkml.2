Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab2KGXFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 18:05:09 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:33069 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab2KGXFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 18:05:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
Date: Thu, 08 Nov 2012 00:09:19 +0100
Message-ID: <38669905.umVnjWsO2W@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1748065.Php9fUYGsh@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1211071653140.1188-100000@iolanthe.rowland.org> <1748065.Php9fUYGsh@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 07, 2012 11:51:15 PM Rafael J. Wysocki wrote:
> On Wednesday, November 07, 2012 04:56:49 PM Alan Stern wrote:
> > On Wed, 7 Nov 2012, Rafael J. Wysocki wrote:
> > 
> > > > Right.  The reasoning behind my proposal goes like this: When there's
> > > > no driver, the subsystem can let userspace directly control the
> > > > device's power level through the power/control attribute.
> > > 
> > > Well, we might as well just leave the runtime PM of PCI devices enabled, even
> > > if they have no drivers, but modify the PCI bus type's runtime PM callbacks
> > > to ignore devices with no drivers.
> > > 
> > > IIRC the reason why we decided to disable runtime PM for PCI device with no
> > > drivers was that some of them refused to work again after being put by the
> > > core into D3.  By making the PCI bus type's runtime PM callbacks ignore them
> > > we'd avoid this problem without modifying the core's behavior.
> > 
> > It comes down to a question of the parent.  If a driverless PCI device
> > isn't being used, shouldn't its parent be allowed to go into runtime
> > suspend?  As things stand now, we do allow it.
> > 
> > The problem is that we don't disallow it when the driverless device
> > _is_ being used.
> 
> We can make it depend on what's there in the control file.  Let's say if that's
> "on" (ie. the devices usage counter is not zero), we won't allow the parent
> to be suspended.
> 
> So, as I said, why don't we keep the runtime PM of PCI devices always enabled,
> regardless of whether or not there is a driver, and arrange things in such a
> way that the device is automatically "suspended" if user space writes "auto"
> to the control file.  IOW, I suppose we can do something like this:

It probably is better to treat the "no driver" case in a special way, though:

---
 drivers/pci/pci-driver.c |   45 +++++++++++++++++++++++++--------------------
 drivers/pci/pci.c        |    2 ++
 2 files changed, 27 insertions(+), 20 deletions(-)

Index: linux-pm/drivers/pci/pci-driver.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-driver.c
+++ linux-pm/drivers/pci/pci-driver.c
@@ -263,22 +263,17 @@ static long local_pci_probe(void *_ddi)
 	/* The parent bridge must be in active state when probing */
 	if (parent)
 		pm_runtime_get_sync(parent);
-	/* Unbound PCI devices are always set to disabled and suspended.
-	 * During probe, the device is set to enabled and active and the
-	 * usage count is incremented.  If the driver supports runtime PM,
-	 * it should call pm_runtime_put_noidle() in its probe routine and
+	/*
+	 * During probe, the device is set to active and the usage count is
+	 * incremented.  If the driver supports runtime PM, it should call
+	 * pm_runtime_put_noidle() in its probe routine and
 	 * pm_runtime_get_noresume() in its remove routine.
 	 */
-	pm_runtime_get_noresume(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
-
+	pm_runtime_get_sync(dev);
 	rc = ddi->drv->probe(ddi->dev, ddi->id);
-	if (rc) {
-		pm_runtime_disable(dev);
-		pm_runtime_set_suspended(dev);
-		pm_runtime_put_noidle(dev);
-	}
+	if (rc)
+		pm_runtime_put_sync(dev);
+
 	if (parent)
 		pm_runtime_put(parent);
 	return rc;
@@ -369,9 +364,7 @@ static int pci_device_remove(struct devi
 	}
 
 	/* Undo the runtime PM settings in local_pci_probe() */
-	pm_runtime_disable(dev);
-	pm_runtime_set_suspended(dev);
-	pm_runtime_put_noidle(dev);
+	pm_runtime_put_sync(dev);
 
 	/*
 	 * If the device is still on, set the power state as "unknown",
@@ -998,10 +991,14 @@ static int pci_pm_restore(struct device
 static int pci_pm_runtime_suspend(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm;
 	pci_power_t prev = pci_dev->current_state;
 	int error;
 
+	if (!dev->driver)
+		return 0;
+
+	pm = dev->driver->pm;
 	if (!pm || !pm->runtime_suspend)
 		return -ENOSYS;
 
@@ -1035,8 +1032,12 @@ static int pci_pm_runtime_resume(struct
 {
 	int rc;
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm;
+
+	if (!dev->driver)
+		return 0;
 
+	pm = dev->driver->pm;
 	if (!pm || !pm->runtime_resume)
 		return -ENOSYS;
 
@@ -1054,8 +1055,12 @@ static int pci_pm_runtime_resume(struct
 
 static int pci_pm_runtime_idle(struct device *dev)
 {
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm;
+
+	if (!dev->driver)
+		goto out:
 
+	pm = dev->driver->pm;
 	if (!pm)
 		return -ENOSYS;
 
@@ -1065,8 +1070,8 @@ static int pci_pm_runtime_idle(struct de
 			return ret;
 	}
 
+ out:
 	pm_runtime_suspend(dev);
-
 	return 0;
 }
 
Index: linux-pm/drivers/pci/pci.c
===================================================================
--- linux-pm.orig/drivers/pci/pci.c
+++ linux-pm/drivers/pci/pci.c
@@ -1868,6 +1868,8 @@ void pci_pm_init(struct pci_dev *dev)
 	u16 pmc;
 
 	pm_runtime_forbid(&dev->dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(&dev->dev);
 	device_enable_async_suspend(&dev->dev);
 	dev->wakeup_prepared = false;
 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
