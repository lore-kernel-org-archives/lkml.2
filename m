Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab1BPA0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:26:10 -0500
Received: from kroah.org ([198.145.64.141]:49994 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757734Ab1BPAZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:25:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:52 2011
Message-Id: <20110216001452.309105926@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:15:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [272/272] xhci: Use GFP_NOIO during device reset.
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit a6d940dd759bf240d28624198660ed34582a327b upstream.

When xhci_discover_or_reset_device() is called after a host controller
power loss, the virtual device may need to be reallocated.  Make sure
xhci_alloc_dev() uses GFP_NOIO.  This avoid causing a deadlock by allowing
the kernel to flush pending I/O while reallocating memory for a virtual
device for a USB mass storage device that's holding the backing store for
dirty memory buffers.

This patch should be queued for the 2.6.37 stable tree.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2431,8 +2431,12 @@ int xhci_alloc_dev(struct usb_hcd *hcd,
 		xhci_err(xhci, "Error while assigning device slot ID\n");
 		return 0;
 	}
-	/* xhci_alloc_virt_device() does not touch rings; no need to lock */
-	if (!xhci_alloc_virt_device(xhci, xhci->slot_id, udev, GFP_KERNEL)) {
+	/* xhci_alloc_virt_device() does not touch rings; no need to lock.
+	 * Use GFP_NOIO, since this function can be called from
+	 * xhci_discover_or_reset_device(), which may be called as part of
+	 * mass storage driver error handling.
+	 */
+	if (!xhci_alloc_virt_device(xhci, xhci->slot_id, udev, GFP_NOIO)) {
 		/* Disable slot, if we can do it without mem alloc */
 		xhci_warn(xhci, "Could not allocate xHCI USB device data structures\n");
 		spin_lock_irqsave(&xhci->lock, flags);


