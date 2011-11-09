Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab1KJD3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:29:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934393Ab1KJD3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:18 2011
Message-Id: <20111109212718.665528097@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [180/262] xhci: If no endpoints changed, dont issue BW command.
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 2dc3753997f3c80ce8b950242ab9bb3fb936acfd upstream.

Some alternate interface settings have no endpoints associated with them.
This shows up in some USB webcams, particularly the Logitech HD 1080p,
which uses the uvcvideo driver.  If a driver switches between two alt
settings with no endpoints, there is no need to issue a configure endpoint
command, because there is no endpoint information to update.

The only time a configure endpoint command with just the add slot flag set
makes sense is when the driver is updating hub characteristics in the slot
context.  However, that code never calls xhci_check_bandwidth, so we
should be safe not issuing a command if only the slot context add flag is
set.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1889,6 +1889,12 @@ int xhci_check_bandwidth(struct usb_hcd
 	ctrl_ctx->add_flags |= cpu_to_le32(SLOT_FLAG);
 	ctrl_ctx->add_flags &= cpu_to_le32(~EP0_FLAG);
 	ctrl_ctx->drop_flags &= cpu_to_le32(~(SLOT_FLAG | EP0_FLAG));
+
+	/* Don't issue the command if there's no endpoints to update. */
+	if (ctrl_ctx->add_flags == cpu_to_le32(SLOT_FLAG) &&
+			ctrl_ctx->drop_flags == 0)
+		return 0;
+
 	xhci_dbg(xhci, "New Input Control Context:\n");
 	slot_ctx = xhci_get_slot_ctx(xhci, virt_dev->in_ctx);
 	xhci_dbg_ctx(xhci, virt_dev->in_ctx,


