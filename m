Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab1BPVsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 16:48:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55733 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab1BPVsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 16:48:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 2/2] PM: Make system-wide PM and runtime PM handle subsystems consistently
Date: Wed, 16 Feb 2011 22:47:49 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Len Brown <lenb@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.44L0.1102160955210.2108-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1102160955210.2108-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102162247.49924.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 16, 2011, Alan Stern wrote:
> On Wed, 16 Feb 2011, Rafael J. Wysocki wrote:
> 
> > Unfortunately, it doesn't work on my Acer Ferrari One.  The problem is that
> > hcd_pci_suspend() fails for the EHCI controller, apparently because the root
> > hub is not suspended.  Do root hubs need both class suspend and bus type
> > suspend to work at the same time?
> 
> No, only the bus type suspend method is needed.

Bus type or device type?  It appears to be the latter from reading the code
(although admittedly not too thorough).

> Can you provide the dmesg log using a kernel built with CONFIG_USB_DEBUG?

Well, I know what the problem is.

USB defines usb_device_type pointing to usb_device_pm_ops that provides
system-wide PM callbacks only and usb_bus_type pointing to
usb_bus_pm_ops that provides runtime PM callbacks only.  So it looks like
we should move either the system-wide PM callbacks to usb_bus_pm_ops,
or the runtime PM callbacks to usb_device_pm_ops.

FWIW, the appended patch helps on my test machine, but I'm not sure if it
is the right thing to do.

Apart from this I think the order of checks introduced by the $subject patch
should be:
(1) If dev->class != NULL and dev->class->pm != NULL, use dev->class,
    or otherwise
(2) if dev->type != NULL and dev->type->pm != NULL, use dev->type,
    or otherwise
(3) use dev->bus (if present).
as that would allow classes and device types to override bus type PM
callbacks if they wish to.

Thanks,
Rafael

---
 drivers/usb/core/driver.c |   15 +++------------
 drivers/usb/core/usb.c    |    5 +++++
 drivers/usb/core/usb.h    |   18 ++++++++++++++++++
 3 files changed, 26 insertions(+), 12 deletions(-)

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
 
@@ -90,6 +93,21 @@ static inline int usb_remote_wakeup(stru
 {
 	return 0;
 }
+
+static inline int usb_runtime_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static inline int usb_runtime_resume(struct device *dev)
+{
+	return 0;
+}
+
+static inline int usb_runtime_idle(struct device *dev)
+{
+	return 0;
+}
 
 #endif
 
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
