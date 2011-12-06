Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab1LFP0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:26:17 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54629 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754187Ab1LFP0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:26:15 -0500
Date: Tue, 6 Dec 2011 10:26:14 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: NeilBrown <neilb@suse.de>, Ming Lei <tom.leiming@gmail.com>,
        Chen Peter-B29397 <B29397@freescale.com>, Greg KH <greg@kroah.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        "hzpeterchen@gmail.com" <hzpeterchen@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: [PATCH] Driver core: leave runtime PM enabled during system shutdown
In-Reply-To: <201112052332.10822.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1112061024240.1469-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disabling all runtime PM during system shutdown turns out not to be a
good idea, because some devices may need to be woken up from a
low-power state at that time.

The whole point of disabling runtime PM for system shutdown was to
prevent untimely runtime-suspend method calls.  This patch (as1504)
accomplishes the same result by incrementing the usage count for each
device and waiting for ongoing runtime-PM callbacks to finish.  This
is what we already do during system suspend and hibernation, which
makes sense since the shutdown method is pretty much a legacy analog
of the pm->poweroff method.

This fixes a regression on some OMAP systems.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: NeilBrown <neilb@suse.de>
CC: Chen Peter-B29397 <B29397@freescale.com>

---

 drivers/base/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: usb-3.2/drivers/base/core.c
===================================================================
--- usb-3.2.orig/drivers/base/core.c
+++ usb-3.2/drivers/base/core.c
@@ -1743,8 +1743,10 @@ void device_shutdown(void)
 		 */
 		list_del_init(&dev->kobj.entry);
 		spin_unlock(&devices_kset->list_lock);
-		/* Disable all device's runtime power management */
-		pm_runtime_disable(dev);
+
+		/* Don't allow any more runtime suspends */
+		pm_runtime_get_noresume(dev);
+		pm_runtime_barrier(dev);
 
 		if (dev->bus && dev->bus->shutdown) {
 			dev_dbg(dev, "shutdown\n");

