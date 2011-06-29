Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab1F2Vgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:36:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41295 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757937Ab1F2Vf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:35:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 3/6 v2] PCI / PM: Detect early wakeup in pci_pm_prepare()
Date: Wed, 29 Jun 2011 23:33:17 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        linux-scsi@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <201106260054.20578.rjw@sisk.pl> <201106292329.04163.rjw@sisk.pl>
In-Reply-To: <201106292329.04163.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106292333.17308.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

A subsequent patch is going to move the invocation of
pm_runtime_barrier() from dpm_prepare() to __device_suspend().
Consequently, early wakeup events resulting from runtime resume
requests for wakeup devices queued up right before system suspend
will only be detected after all of the subsystem-level .prepare()
callbacks have run.  However, the PCI bus type calls
pm_runtime_get_sync() from its pci_pm_prepare() callback routine,
so it would destroy the early wakeup events information regarding PCI
devices.  To prevent this from happening add an early wakeup
detection mechanism, analogous to the one currently in dpm_prepare(),
to pci_pm_prepare().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
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

