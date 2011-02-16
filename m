Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1BPX7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 18:59:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55982 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab1BPX7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 18:59:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH] USB: Move runtime PM callbacks to usb_device_pm_ops
Date: Thu, 17 Feb 2011 00:58:56 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102170058.56503.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

USB defines usb_device_type pointing to usb_device_pm_ops that
provides system-wide PM callbacks only and usb_bus_type pointing to
usb_bus_pm_ops that provides runtime PM callbacks only.  However,
the USB runtime PM callbacks may be defined in usb_device_pm_ops
which makes it possible to drop usb_bus_pm_ops and will allow us
to consolidate the handling of subsystems by the PM core code.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Hi Greg,

Would you mind if I merged the following patch?  It is requisite for
https://patchwork.kernel.org/patch/552411/ which I think is the right thing
to do and people seem to generally agree with me.

Alan has seen it and says it is fine.

Thanks,
Rafael

---
 drivers/usb/core/driver.c |   15 +++------------
 drivers/usb/core/usb.c    |    5 +++++
 drivers/usb/core/usb.h    |    3 +++
 3 files changed, 11 insertions(+), 12 deletions(-)

Index: linux-2.6/drivers/usb/core/driver.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/driver.c
+++ linux-2.6/drivers/usb/core/driver.c
@@ -1646,7 +1646,7 @@ static int autosuspend_check(struct usb_
 	return 0;
 }
 
-static int usb_runtime_suspend(struct device *dev)
+int usb_runtime_suspend(struct device *dev)
 {
 	struct usb_device	*udev = to_usb_device(dev);
 	int			status;
@@ -1662,7 +1662,7 @@ static int usb_runtime_suspend(struct de
 	return status;
 }
 
-static int usb_runtime_resume(struct device *dev)
+int usb_runtime_resume(struct device *dev)
 {
 	struct usb_device	*udev = to_usb_device(dev);
 	int			status;
@@ -1674,7 +1674,7 @@ static int usb_runtime_resume(struct dev
 	return status;
 }
 
-static int usb_runtime_idle(struct device *dev)
+int usb_runtime_idle(struct device *dev)
 {
 	struct usb_device	*udev = to_usb_device(dev);
 
@@ -1686,19 +1686,10 @@ static int usb_runtime_idle(struct devic
 	return 0;
 }
 
-static const struct dev_pm_ops usb_bus_pm_ops = {
-	.runtime_suspend =	usb_runtime_suspend,
-	.runtime_resume =	usb_runtime_resume,
-	.runtime_idle =		usb_runtime_idle,
-};
-
 #endif /* CONFIG_USB_SUSPEND */
 
 struct bus_type usb_bus_type = {
 	.name =		"usb",
 	.match =	usb_device_match,
 	.uevent =	usb_uevent,
-#ifdef CONFIG_USB_SUSPEND
-	.pm =		&usb_bus_pm_ops,
-#endif
 };
Index: linux-2.6/drivers/usb/core/usb.h
===================================================================
--- linux-2.6.orig/drivers/usb/core/usb.h
+++ linux-2.6/drivers/usb/core/usb.h
@@ -77,6 +77,9 @@ static inline int usb_port_resume(struct
 extern void usb_autosuspend_device(struct usb_device *udev);
 extern int usb_autoresume_device(struct usb_device *udev);
 extern int usb_remote_wakeup(struct usb_device *dev);
+extern int usb_runtime_suspend(struct device *dev);
+extern int usb_runtime_resume(struct device *dev);
+extern int usb_runtime_idle(struct device *dev);
 
 #else
 
Index: linux-2.6/drivers/usb/core/usb.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/usb.c
+++ linux-2.6/drivers/usb/core/usb.c
@@ -315,6 +315,11 @@ static const struct dev_pm_ops usb_devic
 	.thaw =		usb_dev_thaw,
 	.poweroff =	usb_dev_poweroff,
 	.restore =	usb_dev_restore,
+#ifdef CONFIG_USB_SUSPEND
+	.runtime_suspend =	usb_runtime_suspend,
+	.runtime_resume =	usb_runtime_resume,
+	.runtime_idle =		usb_runtime_idle,
+#endif
 };
 
 #endif	/* CONFIG_PM */
