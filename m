Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab0G3Rth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:49:37 -0400
Received: from kroah.org ([198.145.64.141]:36011 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932377Ab0G3Rfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:35:32 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:11 2010
Message-Id: <20100730173111.273896180@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:31:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [095/140] USB: obey the sysfs power/wakeup setting
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 48826626263d4a61d06fd8c5805da31f925aefa0 upstream.

This patch (as1403) is a partial reversion of an earlier change
(commit 5f677f1d45b2bf08085bbba7394392dfa586fa8e "USB: fix remote
wakeup settings during system sleep").  After hearing from a user, I
realized that remote wakeup should be enabled during system sleep
whenever userspace allows it, and not only if a driver requests it
too.

Indeed, there could be a device with no driver, that does nothing but
generate a wakeup request when the user presses a button.  Such a
device should be allowed to do its job.

The problem fixed by the earlier patch -- device generating a wakeup
request for no reason, causing system suspend to abort -- was also
addressed by a later patch ("USB: don't enable remote wakeup by
default", accepted but not yet merged into mainline).  The device
won't be able to generate the bogus wakeup requests because it will be
disabled for remote wakeup by default.  Hence this reversion will not
re-introduce any old problems.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/usb/core/driver.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1790,9 +1790,6 @@ int usb_external_resume_device(struct us
 
 static void choose_wakeup(struct usb_device *udev, pm_message_t msg)
 {
-	int			w, i;
-	struct usb_interface	*intf;
-
 	/* Remote wakeup is needed only when we actually go to sleep.
 	 * For things like FREEZE and QUIESCE, if the device is already
 	 * autosuspended then its current wakeup setting is okay.
@@ -1802,18 +1799,10 @@ static void choose_wakeup(struct usb_dev
 		return;
 	}
 
-	/* If remote wakeup is permitted, see whether any interface drivers
+	/* Allow remote wakeup if it is enabled, even if no interface drivers
 	 * actually want it.
 	 */
-	w = 0;
-	if (device_may_wakeup(&udev->dev) && udev->actconfig) {
-		for (i = 0; i < udev->actconfig->desc.bNumInterfaces; i++) {
-			intf = udev->actconfig->interface[i];
-			w |= intf->needs_remote_wakeup;
-		}
-	}
-
-	udev->do_remote_wakeup = w;
+	udev->do_remote_wakeup = device_may_wakeup(&udev->dev);
 }
 
 int usb_suspend(struct device *dev, pm_message_t msg)


