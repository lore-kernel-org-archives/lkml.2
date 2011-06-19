Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab1FSTse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 15:48:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40035 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab1FSTsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 15:48:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PCI / PM: Block races between runtime PM and system sleep
Date: Sun, 19 Jun 2011 21:49:19 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106192149.19401.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After commit e8665002477f0278f84f898145b1f141ba26ee26
(PM: Allow pm_runtime_suspend() to succeed during system suspend) it
is possible that a device resumed by the pm_runtime_resume(dev) in
pci_pm_prepare() will be suspended immediately from a work item,
timer function or otherwise, defeating the very purpose of calling
pm_runtime_resume(dev) from there.  To prevent that from happening
it is necessary to increment the runtime PM usage counter of the
device by replacing pm_runtime_resume() with pm_runtime_get_sync().
Moreover, the incremented runtime PM usage counter has to be
decremented by the corresponding pci_pm_complete(), via
pm_runtime_put_noidle().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: stable@kernel.org
---
 drivers/pci/pci-driver.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -624,7 +624,7 @@ static int pci_pm_prepare(struct device
 	 * system from the sleep state, we'll have to prevent it from signaling
 	 * wake-up.
 	 */
-	pm_runtime_resume(dev);
+	pm_runtime_get_sync(dev);
 
 	if (drv && drv->pm && drv->pm->prepare)
 		error = drv->pm->prepare(dev);
@@ -638,6 +638,8 @@ static void pci_pm_complete(struct devic
 
 	if (drv && drv->pm && drv->pm->complete)
 		drv->pm->complete(dev);
+
+	pm_runtime_put_noidle(dev);
 }
 
 #else /* !CONFIG_PM_SLEEP */
