Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217Ab1KWAkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:40:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759202Ab1KWAkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:40:31 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:06 2011
Message-Id: <20111123002406.006681458@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Chen <peter.chen@freescale.com>,
        Ming Lei <tom.leiming@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [15/53] PM / driver core: disable devices runtime PM during shutdown
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@freescale.com>

commit af8db1508f2c9f3b6e633e2d2d906c6557c617f9 upstream.

There may be an issue when the user issue "reboot/shutdown" command, then
the device has shut down its hardware, after that, this runtime-pm featured
device's driver will probably be scheduled to do its suspend routine,
and at its suspend routine, it may access hardware, but the device has
already shutdown physically, then the system hang may be occurred.

I ran out this issue using an auto-suspend supported USB devices, like
3G modem, keyboard. The usb runtime suspend routine may be scheduled
after the usb controller has been shut down, and the usb runtime suspend
routine will try to suspend its roothub(controller), it will access
register, then the system hang occurs as the controller is shutdown.

Signed-off-by: Peter Chen <peter.chen@freescale.com>
Acked-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -22,6 +22,7 @@
 #include <linux/kallsyms.h>
 #include <linux/mutex.h>
 #include <linux/async.h>
+#include <linux/pm_runtime.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -1742,6 +1743,8 @@ void device_shutdown(void)
 		 */
 		list_del_init(&dev->kobj.entry);
 		spin_unlock(&devices_kset->list_lock);
+		/* Disable all device's runtime power management */
+		pm_runtime_disable(dev);
 
 		if (dev->bus && dev->bus->shutdown) {
 			dev_dbg(dev, "shutdown\n");


