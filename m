Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab1C3Vxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:53:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:51403 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933379Ab1C3VHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621236802"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: sarah.a.sharp@linux.intel.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [87/275] usb: Realloc xHCI structures after a hub is verified.
Message-Id: <20110330210525.4A0003E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 653a39d1f61bdc9f277766736d21d2e9be0391cb upstream.

When there's an xHCI host power loss after a suspend from memory, the USB
core attempts to reset and verify the USB devices that are attached to the
system.  The xHCI driver has to reallocate those devices, since the
hardware lost all knowledge of them during the power loss.

When a hub is plugged in, and the host loses power, the xHCI hardware
structures are not updated to say the device is a hub.  This is usually
done in hub_configure() when the USB hub is detected.  That function is
skipped during a reset and verify by the USB core, since the core restores
the old configuration and alternate settings, and the hub driver has no
idea this happened.  This bug makes the xHCI host controller reject the
enumeration of low speed devices under the resumed hub.

Therefore, make the USB core re-setup the internal xHCI hub device
information by calling update_hub_device() when hub_activate() is called
for a hub reset resume.  After a host power loss, all devices under the
roothub get a reset-resume or a disconnect.

This patch should be queued for the 2.6.37 stable tree.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/core/hub.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: linux-2.6.35.y/drivers/usb/core/hub.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/core/hub.c	2011-03-29 23:02:58.824330253 -0700
+++ linux-2.6.35.y/drivers/usb/core/hub.c	2011-03-29 23:02:59.947301518 -0700
@@ -677,6 +677,8 @@
 static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 {
 	struct usb_device *hdev = hub->hdev;
+	struct usb_hcd *hcd;
+	int ret;
 	int port1;
 	int status;
 	bool need_debounce_delay = false;
@@ -715,6 +717,25 @@
 			usb_autopm_get_interface_no_resume(
 					to_usb_interface(hub->intfdev));
 			return;		/* Continues at init2: below */
+		} else if (type == HUB_RESET_RESUME) {
+			/* The internal host controller state for the hub device
+			 * may be gone after a host power loss on system resume.
+			 * Update the device's info so the HW knows it's a hub.
+			 */
+			hcd = bus_to_hcd(hdev->bus);
+			if (hcd->driver->update_hub_device) {
+				ret = hcd->driver->update_hub_device(hcd, hdev,
+						&hub->tt, GFP_NOIO);
+				if (ret < 0) {
+					dev_err(hub->intfdev, "Host not "
+							"accepting hub info "
+							"update.\n");
+					dev_err(hub->intfdev, "LS/FS devices "
+							"and hubs may not work "
+							"under this hub\n.");
+				}
+			}
+			hub_power_on(hub, true);
 		} else {
 			hub_power_on(hub, true);
 		}
