Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2KGWrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 17:47:08 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:33052 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab2KGWrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 17:47:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
Date: Wed, 07 Nov 2012 23:51:15 +0100
Message-ID: <1748065.Php9fUYGsh@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1211071653140.1188-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1211071653140.1188-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 07, 2012 04:56:49 PM Alan Stern wrote:
> On Wed, 7 Nov 2012, Rafael J. Wysocki wrote:
> 
> > > Right.  The reasoning behind my proposal goes like this: When there's
> > > no driver, the subsystem can let userspace directly control the
> > > device's power level through the power/control attribute.
> > 
> > Well, we might as well just leave the runtime PM of PCI devices enabled, even
> > if they have no drivers, but modify the PCI bus type's runtime PM callbacks
> > to ignore devices with no drivers.
> > 
> > IIRC the reason why we decided to disable runtime PM for PCI device with no
> > drivers was that some of them refused to work again after being put by the
> > core into D3.  By making the PCI bus type's runtime PM callbacks ignore them
> > we'd avoid this problem without modifying the core's behavior.
> 
> It comes down to a question of the parent.  If a driverless PCI device
> isn't being used, shouldn't its parent be allowed to go into runtime
> suspend?  As things stand now, we do allow it.
> 
> The problem is that we don't disallow it when the driverless device
> _is_ being used.

We can make it depend on what's there in the control file.  Let's say if that's
"on" (ie. the devices usage counter is not zero), we won't allow the parent
to be suspended.

So, as I said, why don't we keep the runtime PM of PCI devices always enabled,
regardless of whether or not there is a driver, and arrange things in such a
way that the device is automatically "suspended" if user space writes "auto"
to the control file.  IOW, I suppose we can do something like this:

---
 drivers/pci/pci-driver.c |   34 ++++++++++++----------------------
 drivers/pci/pci.c        |    2 ++
 2 files changed, 14 insertions(+), 22 deletions(-)

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
@@ -1003,7 +996,7 @@ static int pci_pm_runtime_suspend(struct
 	int error;
 
 	if (!pm || !pm->runtime_suspend)
-		return -ENOSYS;
+		return 0;
 
 	pci_dev->no_d3cold = false;
 	error = pm->runtime_suspend(dev);
@@ -1038,7 +1031,7 @@ static int pci_pm_runtime_resume(struct
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	if (!pm || !pm->runtime_resume)
-		return -ENOSYS;
+		return 0;
 
 	pci_restore_standard_config(pci_dev);
 	pci_fixup_device(pci_fixup_resume_early, pci_dev);
@@ -1056,10 +1049,7 @@ static int pci_pm_runtime_idle(struct de
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
-	if (!pm)
-		return -ENOSYS;
-
-	if (pm->runtime_idle) {
+	if (pm && pm->runtime_idle) {
 		int ret = pm->runtime_idle(dev);
 		if (ret)
 			return ret;
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
