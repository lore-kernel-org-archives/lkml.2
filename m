Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab2DXWgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:36:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab2DXWgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:36:01 -0400
Message-Id: <20120424223245.491940047@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 41/62] USB: fix deadlock in bConfigurationValue attribute method
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 8963c487a80b4688c9e68dcc504a90074aacc145 upstream.

This patch (as154) fixes a self-deadlock that occurs when userspace
writes to the bConfigurationValue sysfs attribute for a hub with
children.  The task tries to lock the bandwidth_mutex at a time when
it already owns the lock:

	The attribute's method calls usb_set_configuration(),
	which calls usb_disable_device() with the bandwidth_mutex
	held.

	usb_disable_device() unregisters the existing interfaces,
	which causes the hub driver to be unbound.

	The hub_disconnect() routine calls hub_quiesce(), which
	calls usb_disconnect() for each of the hub's children.

	usb_disconnect() attempts to acquire the bandwidth_mutex
	around a call to usb_disable_device().

The solution is to make usb_disable_device() acquire the mutex for
itself instead of requiring the caller to hold it.  Then the mutex can
cover only the bandwidth deallocation operation and not the region
where the interfaces are unregistered.

This has the potential to change system behavior slightly when a
config change races with another config or altsetting change.  Some of
the bandwidth released from the old config might get claimed by the
other config or altsetting, make it impossible to restore the old
config in case of a failure.  But since we don't try to recover from
config-change failures anyway, this doesn't matter.

[This should be marked for stable kernels that contain the commit
fccf4e86200b8f5edd9a65da26f150e32ba79808 "USB: Free bandwidth when
usb_disable_device is called."
That commit was marked for stable kernels as old as 2.6.32.]

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c     |    3 ---
 drivers/usb/core/message.c |    6 +++---
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1643,7 +1643,6 @@ void usb_disconnect(struct usb_device **
 {
 	struct usb_device	*udev = *pdev;
 	int			i;
-	struct usb_hcd		*hcd = bus_to_hcd(udev->bus);
 
 	/* mark the device as inactive, so any further urb submissions for
 	 * this device (and any of its children) will fail immediately.
@@ -1666,9 +1665,7 @@ void usb_disconnect(struct usb_device **
 	 * so that the hardware is now fully quiesced.
 	 */
 	dev_dbg (&udev->dev, "unregistering device\n");
-	mutex_lock(hcd->bandwidth_mutex);
 	usb_disable_device(udev, 0);
-	mutex_unlock(hcd->bandwidth_mutex);
 	usb_hcd_synchronize_unlinks(udev);
 
 	usb_remove_ep_devs(&udev->ep0);
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1136,8 +1136,6 @@ void usb_disable_interface(struct usb_de
  * Deallocates hcd/hardware state for the endpoints (nuking all or most
  * pending urbs) and usbcore state for the interfaces, so that usbcore
  * must usb_set_configuration() before any interfaces could be used.
- *
- * Must be called with hcd->bandwidth_mutex held.
  */
 void usb_disable_device(struct usb_device *dev, int skip_ep0)
 {
@@ -1190,7 +1188,9 @@ void usb_disable_device(struct usb_devic
 			usb_disable_endpoint(dev, i + USB_DIR_IN, false);
 		}
 		/* Remove endpoints from the host controller internal state */
+		mutex_lock(hcd->bandwidth_mutex);
 		usb_hcd_alloc_bandwidth(dev, NULL, NULL, NULL);
+		mutex_unlock(hcd->bandwidth_mutex);
 		/* Second pass: remove endpoint pointers */
 	}
 	for (i = skip_ep0; i < 16; ++i) {
@@ -1750,7 +1750,6 @@ free_interfaces:
 	/* if it's already configured, clear out old state first.
 	 * getting rid of old interfaces means unbinding their drivers.
 	 */
-	mutex_lock(hcd->bandwidth_mutex);
 	if (dev->state != USB_STATE_ADDRESS)
 		usb_disable_device(dev, 1);	/* Skip ep0 */
 
@@ -1763,6 +1762,7 @@ free_interfaces:
 	 * host controller will not allow submissions to dropped endpoints.  If
 	 * this call fails, the device state is unchanged.
 	 */
+	mutex_lock(hcd->bandwidth_mutex);
 	ret = usb_hcd_alloc_bandwidth(dev, cp, NULL, NULL);
 	if (ret < 0) {
 		mutex_unlock(hcd->bandwidth_mutex);


