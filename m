Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab2I1Ujq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:39:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40590 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758894Ab2I1Ujo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:39:44 -0400
X-Sasl-enc: wpKuxLiJhrpAyVs/FqAMDdu8tN7tuiatAbXvSK8mSwYj 1348864783
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>,
        Don Zickus <dzickus@redhat.com>
Subject: [ 212/218] USB: Fix race condition when removing host controllers
Date: Fri, 28 Sep 2012 13:17:09 -0700
Message-Id: <20120928201525.927855802@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/core/devices.c |    2 +-
 drivers/usb/core/hcd.c     |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -624,7 +624,7 @@ static ssize_t usb_device_read(struct fi
 	/* print devices for all busses */
 	list_for_each_entry(bus, &usb_bus_list, bus_list) {
 		/* recurse through all children of the root hub */
-		if (!bus->root_hub)
+		if (!bus_to_hcd(bus)->rh_registered)
 			continue;
 		usb_lock_device(bus->root_hub);
 		ret = usb_device_dump(&buf, &nbytes, &skip_bytes, ppos,
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1002,10 +1002,7 @@ static int register_root_hub(struct usb_
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
@@ -1014,6 +1011,7 @@ static int register_root_hub(struct usb_
 		if (HCD_DEAD(hcd))
 			usb_hc_died (hcd);	/* This time clean up */
 	}
+	mutex_unlock(&usb_bus_list_lock);
 
 	return retval;
 }


