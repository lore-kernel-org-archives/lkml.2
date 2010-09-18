Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab0IRTde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:33:34 -0400
Received: from kroah.org ([198.145.64.141]:43363 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769Ab0IRTPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:08 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:00 2010
Message-Id: <20100918191300.894154332@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [042/129] usb: allow drivers to use allocated bandwidth until unbound
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

commit 0791971ba8fbc44e4f476079f856335ed45e6324 upstream.

When using the remove sysfs file, the device configuration is set to -1
(unconfigured). This eventually unbind drivers with the bandwidth_mutex
held. Some drivers may call functions that hold said mutex, like
usb_reset_device. This is the case for rtl8187, for example. This will
lead to the same process holding the mutex twice, which deadlocks.

Besides, according to Alan Stern:
"The deadlock problem probably could be handled somehow, but there's a
separate issue: Until the usb_disable_device call finishes unbinding
the drivers, the drivers are free to continue using their allocated
bandwidth.  We musn't change the bandwidth allocations until after the
unbinding is done.  So this patch is indeed necessary."

Unbinding the driver before holding the bandwidth_mutex solves the
problem. If any operation after that fails, drivers are not bound again.
But that would be a problem anyway that the user may solve resetting the
device configuration to one that works, just like he would need to do in
most other failure cases.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/message.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1724,6 +1724,15 @@ free_interfaces:
 	if (ret)
 		goto free_interfaces;
 
+	/* if it's already configured, clear out old state first.
+	 * getting rid of old interfaces means unbinding their drivers.
+	 */
+	if (dev->state != USB_STATE_ADDRESS)
+		usb_disable_device(dev, 1);	/* Skip ep0 */
+
+	/* Get rid of pending async Set-Config requests for this device */
+	cancel_async_set_config(dev);
+
 	/* Make sure we have bandwidth (and available HCD resources) for this
 	 * configuration.  Remove endpoints from the schedule if we're dropping
 	 * this configuration to set configuration 0.  After this point, the
@@ -1733,20 +1742,11 @@ free_interfaces:
 	mutex_lock(&hcd->bandwidth_mutex);
 	ret = usb_hcd_alloc_bandwidth(dev, cp, NULL, NULL);
 	if (ret < 0) {
-		usb_autosuspend_device(dev);
 		mutex_unlock(&hcd->bandwidth_mutex);
+		usb_autosuspend_device(dev);
 		goto free_interfaces;
 	}
 
-	/* if it's already configured, clear out old state first.
-	 * getting rid of old interfaces means unbinding their drivers.
-	 */
-	if (dev->state != USB_STATE_ADDRESS)
-		usb_disable_device(dev, 1);	/* Skip ep0 */
-
-	/* Get rid of pending async Set-Config requests for this device */
-	cancel_async_set_config(dev);
-
 	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 			      USB_REQ_SET_CONFIGURATION, 0, configuration, 0,
 			      NULL, 0, USB_CTRL_SET_TIMEOUT);
@@ -1761,8 +1761,8 @@ free_interfaces:
 	if (!cp) {
 		usb_set_device_state(dev, USB_STATE_ADDRESS);
 		usb_hcd_alloc_bandwidth(dev, NULL, NULL, NULL);
-		usb_autosuspend_device(dev);
 		mutex_unlock(&hcd->bandwidth_mutex);
+		usb_autosuspend_device(dev);
 		goto free_interfaces;
 	}
 	mutex_unlock(&hcd->bandwidth_mutex);


