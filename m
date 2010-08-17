Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab0HQMuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 08:50:07 -0400
Received: from liberdade2.minaslivre.org ([74.50.53.203]:36138 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab0HQMuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 08:50:05 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] usb: fix deadlock with bandwidth_mutex
Date: Tue, 17 Aug 2010 09:49:55 -0300
Message-Id: <1282049395-5718-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the remove sysfs file, the device configuration is set to -1
(unconfigured). This eventually unbind drivers with the bandwidth_mutex
held. Some drivers may call functions that hold said mutex, like
usb_reset_device. This is the case for rtl8187, for example. This will
lead to the same process holding the mutex twice, which deadlocks.

Unbinding the driver before holding the bandwidth_mutex solves the
problem. If any operation after that fails, drivers are not bound again.
But that would be a problem anyway that the user may solve resetting the
device configuration to one that works, just like he would need to do in
most other failure cases.
---

NOTE: Not signed-off yet, because I'm waiting for some review. Thanks!

---
 drivers/usb/core/message.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index fd4c36e..fe6b9e8 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1724,6 +1724,12 @@ free_interfaces:
 	if (ret)
 		goto free_interfaces;
 
+	/* if it's already configured, clear out old state first.
+	 * getting rid of old interfaces means unbinding their drivers.
+	 */
+	if (dev->state != USB_STATE_ADDRESS)
+		usb_disable_device(dev, 1);	/* Skip ep0 */
+
 	/* Make sure we have bandwidth (and available HCD resources) for this
 	 * configuration.  Remove endpoints from the schedule if we're dropping
 	 * this configuration to set configuration 0.  After this point, the
@@ -1738,12 +1744,6 @@ free_interfaces:
 		goto free_interfaces;
 	}
 
-	/* if it's already configured, clear out old state first.
-	 * getting rid of old interfaces means unbinding their drivers.
-	 */
-	if (dev->state != USB_STATE_ADDRESS)
-		usb_disable_device(dev, 1);	/* Skip ep0 */
-
 	/* Get rid of pending async Set-Config requests for this device */
 	cancel_async_set_config(dev);
 
-- 
1.7.1

