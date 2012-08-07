Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab2HGXio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:38:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38566 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab2HGW2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:28:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 032/122] USB: Disable LPM while the device is unconfigured.
Date: Tue,  7 Aug 2012 15:25:20 -0700
Message-Id: <20120807221951.137841680@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 9cf65991dd93ac3d5f97f536171c388918b7c1a9 upstream.

The USB 3.0 Set/Clear Feature U1/U2 Enable cannot be sent to a device in
the Default or Addressed state.  It can only be sent to a configured
device.  Change the USB core to initialize the LPM disable count to 1
(disabled), which reflects this limitation.

Change usb_set_configuration() to ensure that if the device is
unconfigured on entry, usb_lpm_disable() is not called.  This avoids
sending the Clear Feature U1/U2 when the device is in the Addressed
state.  When usb_set_configuration() exits with a successfully installed
configuration, usb_lpm_enable() will be called.

Once the new configuration is installed, make sure
usb_set_configuration() only calls usb_enable_lpm() if the device moved
to the Configured state.  If we have unconfigured the device by sending
it a Set Configuration for config 0, don't enable LPM.

This commit should be backported to kernels as old as 3.5, that contain
the commit 8306095fd2c1100e8244c09bf560f97aca5a311d "USB: Disable USB
3.0 LPM in critical sections."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/message.c |    7 ++++---
 drivers/usb/core/usb.c     |    1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1791,14 +1791,15 @@ free_interfaces:
 	 * installed, so that the xHCI driver can recalculate the U1/U2
 	 * timeouts.
 	 */
-	if (usb_disable_lpm(dev)) {
+	if (dev->actconfig && usb_disable_lpm(dev)) {
 		dev_err(&dev->dev, "%s Failed to disable LPM\n.", __func__);
 		mutex_unlock(hcd->bandwidth_mutex);
 		return -ENOMEM;
 	}
 	ret = usb_hcd_alloc_bandwidth(dev, cp, NULL, NULL);
 	if (ret < 0) {
-		usb_enable_lpm(dev);
+		if (dev->actconfig)
+			usb_enable_lpm(dev);
 		mutex_unlock(hcd->bandwidth_mutex);
 		usb_autosuspend_device(dev);
 		goto free_interfaces;
@@ -1818,7 +1819,7 @@ free_interfaces:
 	if (!cp) {
 		usb_set_device_state(dev, USB_STATE_ADDRESS);
 		usb_hcd_alloc_bandwidth(dev, NULL, NULL, NULL);
-		usb_enable_lpm(dev);
+		/* Leave LPM disabled while the device is unconfigured. */
 		mutex_unlock(hcd->bandwidth_mutex);
 		usb_autosuspend_device(dev);
 		goto free_interfaces;
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -396,6 +396,7 @@ struct usb_device *usb_alloc_dev(struct
 	dev->dev.dma_mask = bus->controller->dma_mask;
 	set_dev_node(&dev->dev, dev_to_node(bus->controller));
 	dev->state = USB_STATE_ATTACHED;
+	dev->lpm_disable_count = 1;
 	atomic_set(&dev->urbnum, 0);
 
 	INIT_LIST_HEAD(&dev->ep0.urb_list);


