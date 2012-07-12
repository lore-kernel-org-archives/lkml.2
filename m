Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab2GLJqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 05:46:14 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:37219 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231Ab2GLJqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 05:46:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH] PM / Runtime: Do not increment device usage counts before probing
Date: Thu, 12 Jul 2012 11:51:48 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, Kevin Hilman <khilman@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207121151.48819.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The pm_runtime_get_noresume() calls before really_probe() and
before executing __device_attach() for each driver on the
device's bus cause problems to happen if probing fails and if the
driver has enabled runtime PM for the device in its .probe()
callback.  Namely, in that case, if the device has been resumed
by the driver after enabling its runtime PM and if it turns out that
.probe() should return an error, the driver is supposed to suspend
the device and disable its runtime PM before exiting .probe().
However, because the device's runtime PM usage counter was
incremented by the core before calling .probe(), the driver's attempt
to suspend the device will not succeed and the device will remain in
the full-power state after the failing .probe() has returned.

To fix this issue, remove the pm_runtime_get_noresume() calls from
driver_probe_device() and from device_attach() and replace the
corresponding pm_runtime_put_sync() calls with pm_runtime_idle()
to preserve the existing behavior (which is to check if the device
is idle and to suspend it eventually in that case after probing).

Reported-and-tested-by: Kevin Hilman <khilman@ti.com>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/dd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux/drivers/base/dd.c
===================================================================
--- linux.orig/drivers/base/dd.c
+++ linux/drivers/base/dd.c
@@ -356,10 +356,9 @@ int driver_probe_device(struct device_dr
 	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
 		 drv->bus->name, __func__, dev_name(dev), drv->name);
 
-	pm_runtime_get_noresume(dev);
 	pm_runtime_barrier(dev);
 	ret = really_probe(dev, drv);
-	pm_runtime_put_sync(dev);
+	pm_runtime_idle(dev);
 
 	return ret;
 }
@@ -406,9 +405,8 @@ int device_attach(struct device *dev)
 			ret = 0;
 		}
 	} else {
-		pm_runtime_get_noresume(dev);
 		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
-		pm_runtime_put_sync(dev);
+		pm_runtime_idle(dev);
 	}
 out_unlock:
 	device_unlock(dev);
