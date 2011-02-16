Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab1BPBv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:51:56 -0500
Received: from kroah.org ([198.145.64.141]:49203 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758538Ab1BPBvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:51:19 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:02 2011
Message-Id: <20110216014702.755080591@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [085/115] usb: Realloc xHCI structures after a hub is verified.
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/usb/core/hub.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -648,6 +648,8 @@ static void hub_init_func3(struct work_s
 static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 {
 	struct usb_device *hdev = hub->hdev;
+	struct usb_hcd *hcd;
+	int ret;
 	int port1;
 	int status;
 	bool need_debounce_delay = false;
@@ -686,6 +688,25 @@ static void hub_activate(struct usb_hub
 			atomic_set(&to_usb_interface(hub->intfdev)->
 					pm_usage_cnt, 1);
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


