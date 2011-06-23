Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab1FWRf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:35:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:34202 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab1FWRfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:35:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 081/247] usb: Realloc xHCI structures after a hub is verified.
Date: Thu, 23 Jun 2011 13:32:29 -0400
Message-Id: <1308850515-15242-22-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/core/hub.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index f4e54ba..e5363de 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -677,6 +677,8 @@ static void hub_init_func3(struct work_struct *ws);
 static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 {
 	struct usb_device *hdev = hub->hdev;
+	struct usb_hcd *hcd;
+	int ret;
 	int port1;
 	int status;
 	bool need_debounce_delay = false;
@@ -715,6 +717,25 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
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
-- 
1.7.4.4

