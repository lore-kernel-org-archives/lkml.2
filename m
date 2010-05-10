Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab0EJW7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:59:14 -0400
Received: from kroah.org ([198.145.64.141]:51642 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461Ab0EJW5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:38 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:36 2010
Message-Id: <20100510223536.046928826@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [18/98] USB: fix remote wakeup settings during system sleep
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

This is a backport of commit 5f677f1d45b2bf08085bbba7394392dfa586fa8e.
Some of the functionality had to be removed, but it should still fix
the webcam problem.

This patch (as1363b) changes the way USB remote wakeup is handled
during system sleeps.  It won't be enabled unless an interface driver
specifically needs it.  Also, it won't be enabled during the FREEZE or
QUIESCE phases of hibernation, when the system doesn't respond to
wakeup events anyway.

This will fix problems people have reported with certain USB webcams
that generate wakeup requests when they shouldn't, and as a result
cause system suspends to fail.  See

	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/515109


Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/driver.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1175,9 +1175,8 @@ static int usb_suspend_both(struct usb_d
 			udev->state == USB_STATE_SUSPENDED)
 		goto done;
 
-	udev->do_remote_wakeup = device_may_wakeup(&udev->dev);
-
 	if (msg.event & PM_EVENT_AUTO) {
+		udev->do_remote_wakeup = device_may_wakeup(&udev->dev);
 		status = autosuspend_check(udev, 0);
 		if (status < 0)
 			goto done;
@@ -1742,6 +1741,34 @@ int usb_external_resume_device(struct us
 	return status;
 }
 
+static void choose_wakeup(struct usb_device *udev, pm_message_t msg)
+{
+	int			w, i;
+	struct usb_interface	*intf;
+
+	/* Remote wakeup is needed only when we actually go to sleep.
+	 * For things like FREEZE and QUIESCE, if the device is already
+	 * autosuspended then its current wakeup setting is okay.
+	 */
+	if (msg.event == PM_EVENT_FREEZE || msg.event == PM_EVENT_QUIESCE) {
+		udev->do_remote_wakeup = 0;
+		return;
+	}
+
+	/* If remote wakeup is permitted, see whether any interface drivers
+	 * actually want it.
+	 */
+	w = 0;
+	if (device_may_wakeup(&udev->dev) && udev->actconfig) {
+		for (i = 0; i < udev->actconfig->desc.bNumInterfaces; i++) {
+			intf = udev->actconfig->interface[i];
+			w |= intf->needs_remote_wakeup;
+		}
+	}
+
+	udev->do_remote_wakeup = w;
+}
+
 int usb_suspend(struct device *dev, pm_message_t msg)
 {
 	struct usb_device	*udev;
@@ -1761,6 +1788,7 @@ int usb_suspend(struct device *dev, pm_m
 	}
 
 	udev->skip_sys_resume = 0;
+	choose_wakeup(udev, msg);
 	return usb_external_suspend_device(udev, msg);
 }
 


