Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab1FPHdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:33:47 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35133 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755888Ab1FPHBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:17 -0400
X-Sasl-enc: KixmzoC2fS4fZInpi8CchUqPEcBBwhaQVWzjP8jEIWHY 1308207676
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:35 2011
Message-Id: <20110616000234.982812588@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [61/89] xhci: Do not issue device reset when device is not setup
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maarten Lankhorst <m.b.lankhorst@gmail.com>

commit 001fd3826f4c736ce292315782d015f768399080 upstream.

xHCI controllers respond to a Reset Device command when the Slot is in the
Enabled/Disabled state by returning an error.  This is fine on other host
controllers, but the Etron xHCI host controller returns a vendor-specific
error code that the xHCI driver doesn't understand.  The xHCI driver then
gives up on device enumeration.

Instead of issuing a command that will fail, just return.  This fixes the
issue with the xhci driver not working on ASRock P67 Pro/Extreme boards.

This should be backported to stable kernels as far back as 2.6.34.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2284,6 +2284,7 @@ int xhci_discover_or_reset_device(struct
 	struct xhci_command *reset_device_cmd;
 	int timeleft;
 	int last_freed_endpoint;
+	struct xhci_slot_ctx *slot_ctx;
 
 	ret = xhci_check_args(hcd, udev, NULL, 0, false, __func__);
 	if (ret <= 0)
@@ -2316,6 +2317,12 @@ int xhci_discover_or_reset_device(struct
 			return -EINVAL;
 	}
 
+	/* If device is not setup, there is no point in resetting it */
+	slot_ctx = xhci_get_slot_ctx(xhci, virt_dev->out_ctx);
+	if (GET_SLOT_STATE(le32_to_cpu(slot_ctx->dev_state)) ==
+						SLOT_STATE_DISABLED)
+		return 0;
+
 	xhci_dbg(xhci, "Resetting device with slot ID %u\n", slot_id);
 	/* Allocate the command structure that holds the struct completion.
 	 * Assume we're in process context, since the normal device reset


