Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2JGXba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:31:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38572 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754529Ab2JGXXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:04 -0400
Message-Id: <20121007225841.487720345@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:23 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>,
        Don Zickus <dzickus@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 049/108] USB: Fix race condition when removing host controllers
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 0d00dc2611abbe6ad244d50569c2ee82ce42846c upstream.

This patch (as1607) fixes a race that can occur if a USB host
controller is removed while a process is reading the
/sys/kernel/debug/usb/devices file.

The usb_device_read() routine uses the bus->root_hub pointer to
determine whether or not the root hub is registered.  The is not a
valid test, because the pointer is set before the root hub gets
registered and remains set even after the root hub is unregistered and
deallocated.  As a result, usb_device_read() or usb_device_dump() can
access freed memory, causing an oops.

The patch changes the test to use the hcd->rh_registered flag, which
does get set and cleared at the appropriate times.  It also makes sure
to hold the usb_bus_list_lock mutex while setting the flag, so that
usb_device_read() will become aware of new root hubs as soon as they
are registered.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/devices.c |    2 +-
 drivers/usb/core/hcd.c     |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index d956965..3440812 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -624,7 +624,7 @@ static ssize_t usb_device_read(struct file *file, char __user *buf,
 	/* print devices for all busses */
 	list_for_each_entry(bus, &usb_bus_list, bus_list) {
 		/* recurse through all children of the root hub */
-		if (!bus->root_hub)
+		if (!bus_to_hcd(bus)->rh_registered)
 			continue;
 		usb_lock_device(bus->root_hub);
 		ret = usb_device_dump(&buf, &nbytes, &skip_bytes, ppos,
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index bc84106..75ba209 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1011,10 +1011,7 @@ static int register_root_hub(struct usb_hcd *hcd)
 	if (retval) {
 		dev_err (parent_dev, "can't register root hub for %s, %d\n",
 				dev_name(&usb_dev->dev), retval);
-	}
-	mutex_unlock(&usb_bus_list_lock);
-
-	if (retval == 0) {
+	} else {
 		spin_lock_irq (&hcd_root_hub_lock);
 		hcd->rh_registered = 1;
 		spin_unlock_irq (&hcd_root_hub_lock);
@@ -1023,6 +1020,7 @@ static int register_root_hub(struct usb_hcd *hcd)
 		if (HCD_DEAD(hcd))
 			usb_hc_died (hcd);	/* This time clean up */
 	}
+	mutex_unlock(&usb_bus_list_lock);
 
 	return retval;
 }


