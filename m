Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab0LMAdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:33:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48369 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109Ab0LMAdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 19:33:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC][PATCH 3/4] PM: Replace the device power.status filed with a bit field
Date: Mon, 13 Dec 2010 01:32:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201012130128.31243.rjw@sisk.pl>
In-Reply-To: <201012130128.31243.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012130132.41892.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The device power.status field is too complicated for its purpose
(storing the information about whether or not the device is in the
"active" state from the PM core's point of view), so replace it with
a bit field and modify all of its users accordingly.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   17 ++++-------------
 drivers/usb/core/driver.c |    7 +++----
 include/linux/device.h    |    4 ++--
 include/linux/pm.h        |   43 ++-----------------------------------------
 4 files changed, 11 insertions(+), 60 deletions(-)

Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -508,13 +508,13 @@ static inline int device_is_registered(s
 
 static inline void device_enable_async_suspend(struct device *dev)
 {
-	if (dev->power.status == DPM_ON)
+	if (!dev->power.in_suspend)
 		dev->power.async_suspend = true;
 }
 
 static inline void device_disable_async_suspend(struct device *dev)
 {
-	if (dev->power.status == DPM_ON)
+	if (!dev->power.in_suspend)
 		dev->power.async_suspend = false;
 }
 
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -367,45 +367,6 @@ extern struct dev_pm_ops generic_subsys_
 					{ .event = PM_EVENT_AUTO_RESUME, })
 
 /**
- * Device power management states
- *
- * These state labels are used internally by the PM core to indicate the current
- * status of a device with respect to the PM core operations.
- *
- * DPM_ON		Device is regarded as operational.  Set this way
- *			initially and when ->complete() is about to be called.
- *			Also set when ->prepare() fails.
- *
- * DPM_PREPARING	Device is going to be prepared for a PM transition.  Set
- *			when ->prepare() is about to be called.
- *
- * DPM_RESUMING		Device is going to be resumed.  Set when ->resume(),
- *			->thaw(), or ->restore() is about to be called.
- *
- * DPM_SUSPENDING	Device has been prepared for a power transition.  Set
- *			when ->prepare() has just succeeded.
- *
- * DPM_OFF		Device is regarded as inactive.  Set immediately after
- *			->suspend(), ->freeze(), or ->poweroff() has succeeded.
- *			Also set when ->resume()_noirq, ->thaw_noirq(), or
- *			->restore_noirq() is about to be called.
- *
- * DPM_OFF_IRQ		Device is in a "deep sleep".  Set immediately after
- *			->suspend_noirq(), ->freeze_noirq(), or
- *			->poweroff_noirq() has just succeeded.
- */
-
-enum dpm_state {
-	DPM_INVALID,
-	DPM_ON,
-	DPM_PREPARING,
-	DPM_RESUMING,
-	DPM_SUSPENDING,
-	DPM_OFF,
-	DPM_OFF_IRQ,
-};
-
-/**
  * Device run-time power management status.
  *
  * These status labels are used internally by the PM core to indicate the
@@ -463,8 +424,8 @@ struct wakeup_source;
 struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned int		can_wakeup:1;
-	unsigned		async_suspend:1;
-	enum dpm_state		status;		/* Owned by the PM core */
+	unsigned int		async_suspend:1;
+	unsigned int		in_suspend:1;	/* Owned by the PM core */
 	spinlock_t		lock;
 #ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -63,7 +63,7 @@ static int async_error;
  */
 void device_pm_init(struct device *dev)
 {
-	dev->power.status = DPM_ON;
+	dev->power.in_suspend = false;
 	init_completion(&dev->power.completion);
 	complete_all(&dev->power.completion);
 	dev->power.wakeup = NULL;
@@ -98,7 +98,7 @@ void device_pm_add(struct device *dev)
 		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
 	if (dev->parent) {
-		if (dev->parent->power.status >= DPM_SUSPENDING)
+		if (dev->parent->power.in_suspend)
 			dev_warn(dev, "parent %s should not be sleeping\n",
 				 dev_name(dev->parent));
 	} else if (transition_started) {
@@ -488,7 +488,6 @@ void dpm_resume_noirq(pm_message_t state
 		int error;
 
 		get_device(dev);
-		dev->power.status = DPM_OFF;
 		mutex_unlock(&dpm_list_mtx);
 
 		error = device_resume_noirq(dev, state);
@@ -542,8 +541,6 @@ static int device_resume(struct device *
 	dpm_wait(dev->parent, async);
 	device_lock(dev);
 
-	dev->power.status = DPM_RESUMING;
-
 	if (dev->bus) {
 		if (dev->bus->pm) {
 			pm_dev_dbg(dev, state, "");
@@ -691,7 +688,7 @@ static void dpm_complete(pm_message_t st
 		struct device *dev = to_device(dpm_prepared_list.prev);
 
 		get_device(dev);
-		dev->power.status = DPM_ON;
+		dev->power.in_suspend = false;
 		mutex_unlock(&dpm_list_mtx);
 
 		device_complete(dev, state);
@@ -808,7 +805,6 @@ int dpm_suspend_noirq(pm_message_t state
 			put_device(dev);
 			break;
 		}
-		dev->power.status = DPM_OFF_IRQ;
 		if (!list_empty(&dev->power.entry))
 			list_move(&dev->power.entry, &dpm_noirq_list);
 		put_device(dev);
@@ -896,9 +892,6 @@ static int __device_suspend(struct devic
 		}
 	}
 
-	if (!error)
-		dev->power.status = DPM_OFF;
-
  End:
 	device_unlock(dev);
 	complete_all(&dev->power.completion);
@@ -1032,7 +1025,6 @@ static int dpm_prepare(pm_message_t stat
 		struct device *dev = to_device(dpm_list.next);
 
 		get_device(dev);
-		dev->power.status = DPM_PREPARING;
 		mutex_unlock(&dpm_list_mtx);
 
 		pm_runtime_get_noresume(dev);
@@ -1048,7 +1040,6 @@ static int dpm_prepare(pm_message_t stat
 
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
-			dev->power.status = DPM_ON;
 			if (error == -EAGAIN) {
 				put_device(dev);
 				error = 0;
@@ -1060,7 +1051,7 @@ static int dpm_prepare(pm_message_t stat
 			put_device(dev);
 			break;
 		}
-		dev->power.status = DPM_SUSPENDING;
+		dev->power.in_suspend = true;
 		if (!list_empty(&dev->power.entry))
 			list_move_tail(&dev->power.entry, &dpm_prepared_list);
 		put_device(dev);
Index: linux-2.6/drivers/usb/core/driver.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/driver.c
+++ linux-2.6/drivers/usb/core/driver.c
@@ -376,7 +376,7 @@ static int usb_unbind_interface(struct d
 		 * Just re-enable it without affecting the endpoint toggles.
 		 */
 		usb_enable_interface(udev, intf, false);
-	} else if (!error && intf->dev.power.status == DPM_ON) {
+	} else if (!error && !intf->dev.power.in_suspend) {
 		r = usb_set_interface(udev, intf->altsetting[0].
 				desc.bInterfaceNumber, 0);
 		if (r < 0)
@@ -961,7 +961,7 @@ void usb_rebind_intf(struct usb_interfac
 	}
 
 	/* Try to rebind the interface */
-	if (intf->dev.power.status == DPM_ON) {
+	if (!intf->dev.power.in_suspend) {
 		intf->needs_binding = 0;
 		rc = device_attach(&intf->dev);
 		if (rc < 0)
@@ -1108,8 +1108,7 @@ static int usb_resume_interface(struct u
 	if (intf->condition == USB_INTERFACE_UNBOUND) {
 
 		/* Carry out a deferred switch to altsetting 0 */
-		if (intf->needs_altsetting0 &&
-				intf->dev.power.status == DPM_ON) {
+		if (intf->needs_altsetting0 && !intf->dev.power.in_suspend) {
 			usb_set_interface(udev, intf->altsetting[0].
 					desc.bInterfaceNumber, 0);
 			intf->needs_altsetting0 = 0;

