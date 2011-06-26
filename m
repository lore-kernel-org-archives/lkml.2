Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab1FZM0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 08:26:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58794 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab1FZM0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 08:26:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI / PM: Detect early wakeup in pci_pm_prepare()
Date: Sun, 26 Jun 2011 14:27:29 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106261427.30155.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After commit e8665002477f0278f84f898145b1f141ba26ee26
(PM: Allow pm_runtime_suspend() to succeed during system suspend)
runtime resume requests may be put into the PM workqueue after
the pm_runtime_barrier() in dpm_prepare().  If the given device
is configured to wake up the system from sleep states, this should
be regarded as a wakeup event, because it means that a wakeup device
requires attention.  However, for PCI devices the subsequent
pm_runtime_get_sync() in pci_pm_prepare() will resume the device
unconditionally and the wakeup event situation will not be detected.

To fix this problem, it is necessary to add an early wakeup detection
mechanism, analogous to the one in dpm_prepare(), to
pci_pm_prepare().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

---

Hi,

I think we need this patch in 3.0 (in addition to all of the previously
applied patches).  I'm sorry I didn't notice that before, it only came
to my mind when I was working on the "PM: Fix up interactions between system
suspend/resume and runtime PM" patch series.

Thanks,
Rafael

---
 drivers/pci/pci-driver.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -18,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/cpu.h>
 #include <linux/pm_runtime.h>
+#include <linux/suspend.h>
 #include "pci.h"
 
 struct pci_dynid {
@@ -616,6 +617,19 @@ static int pci_pm_prepare(struct device
 	int error = 0;
 
 	/*
+	 * If a PCI device configured to wake up the system from sleep states
+	 * has been suspended at run time and there's a resume request pending
+	 * for it, this is equivalent to the device signaling wakeup, so the
+	 * system suspend operation should be aborted.
+	 */
+	pm_runtime_get_noresume(dev);
+	if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
+		pm_wakeup_event(dev, 0);
+
+	if (pm_wakeup_pending())
+		return -EBUSY;
+
+	/*
 	 * PCI devices suspended at run time need to be resumed at this
 	 * point, because in general it is necessary to reconfigure them for
 	 * system suspend.  Namely, if the device is supposed to wake up the
@@ -624,7 +638,7 @@ static int pci_pm_prepare(struct device
 	 * system from the sleep state, we'll have to prevent it from signaling
 	 * wake-up.
 	 */
-	pm_runtime_get_sync(dev);
+	pm_runtime_resume(dev);
 
 	if (drv && drv->pm && drv->pm->prepare)
 		error = drv->pm->prepare(dev);
