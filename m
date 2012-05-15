Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965133Ab2EOC4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:56:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:49565 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965014Ab2EOCRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 081/179] xhci: Reject double add of active endpoints.
Date: Mon, 14 May 2012 22:12:57 -0400
Message-ID: <1337048075-6132-82-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit fa75ac379e63c2864e9049b5e8615e40f65c1e70 upstream.

While trying to switch a UAS device from the BOT configuration to the UAS
configuration via the bConfigurationValue file, Tanya ran into an issue in
the USB core.  usb_disable_device() sets entries in udev->ep_out and
udev->ep_out to NULL, but doesn't call into the xHCI bandwidth management
functions to remove the BOT configuration endpoints from the xHCI host's
internal structures.

The USB core would then attempt to add endpoints for the UAS
configuration, and some of the endpoints had the same address as endpoints
in the BOT configuration.  The xHCI driver blindly added the endpoints
again, but the xHCI host controller rejected the Configure Endpoint
command because active endpoints were added without being dropped.

Make the xHCI driver reject calls to xhci_add_endpoint() that attempt to
add active endpoints without first calling xhci_drop_endpoint().

This should be backported to kernels as old as 2.6.31.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Tanya Brokhman <tlinder@codeaurora.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/xhci.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 5a752d6..0a5901f 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -996,6 +996,7 @@ int xhci_add_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 	u32 added_ctxs;
 	unsigned int last_ctx;
 	u32 new_add_flags, new_drop_flags, new_slot_info;
+	struct xhci_virt_device *virt_dev;
 	int ret = 0;
 
 	ret = xhci_check_args(hcd, udev, ep, 1, __func__);
@@ -1024,11 +1025,25 @@ int xhci_add_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 		return -EINVAL;
 	}
 
-	in_ctx = xhci->devs[udev->slot_id]->in_ctx;
-	out_ctx = xhci->devs[udev->slot_id]->out_ctx;
+	virt_dev = xhci->devs[udev->slot_id];
+	in_ctx = virt_dev->in_ctx;
+	out_ctx = virt_dev->out_ctx;
 	ctrl_ctx = xhci_get_input_control_ctx(xhci, in_ctx);
 	ep_index = xhci_get_endpoint_index(&ep->desc);
 	ep_ctx = xhci_get_ep_ctx(xhci, out_ctx, ep_index);
+
+	/* If this endpoint is already in use, and the upper layers are trying
+	 * to add it again without dropping it, reject the addition.
+	 */
+	if (virt_dev->eps[ep_index].ring &&
+			!(le32_to_cpu(ctrl_ctx->drop_flags) &
+				xhci_get_endpoint_flag(&ep->desc))) {
+		xhci_warn(xhci, "Trying to add endpoint 0x%x "
+				"without dropping it.\n",
+				(unsigned int) ep->desc.bEndpointAddress);
+		return -EINVAL;
+	}
+
 	/* If the HCD has already noted the endpoint is enabled,
 	 * ignore this request.
 	 */
@@ -1043,8 +1058,7 @@ int xhci_add_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 	 * process context, not interrupt context (or so documenation
 	 * for usb_set_interface() and usb_set_configuration() claim).
 	 */
-	if (xhci_endpoint_init(xhci, xhci->devs[udev->slot_id],
-				udev, ep, GFP_NOIO) < 0) {
+	if (xhci_endpoint_init(xhci, virt_dev, udev, ep, GFP_NOIO) < 0) {
 		dev_dbg(&udev->dev, "%s - could not initialize ep %#x\n",
 				__func__, ep->desc.bEndpointAddress);
 		return -ENOMEM;
-- 
1.7.9.6

