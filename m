Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab2BAVmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:42:39 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41983 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757165Ab2BAVJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:25 -0500
X-Sasl-enc: 8zgcxdyf8ukpJUFU8cRryyfvtc1aNGxLCOWMp5k11sQR 1328130564
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:41 2012
Message-Id: <20120201205741.075391093@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andiry Xu <andiry.xu@amd.com>
Subject: [41/65] xhci: Fix USB 3.0 device restart on resume.
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit d0cd5d482b8a6dc92c6c69a5387baf72ea84f23a upstream.

The xHCI hub port code gets passed a zero-based port number by the USB
core.  It then adds one to in order to find a device slot by port number
and device speed by calling xhci_find_slot_id_by_port.  That function
clearly states it requires a one-based port number.  The xHCI port
status change event handler was using a zero-based port number that it
got from find_faked_portnum_from_hw_portnum, not a one-based port
number.  This lead to the doorbells never being rung for a device after
a resume, or worse, a different device with the same speed having its
doorbell rung (which could lead to bad power management in the xHCI host
controller).

This patch should be backported to kernels as old as 2.6.39.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1218,6 +1218,7 @@ static void handle_vendor_event(struct x
  *
  * Returns a zero-based port number, which is suitable for indexing into each of
  * the split roothubs' port arrays and bus state arrays.
+ * Add one to it in order to call xhci_find_slot_id_by_port.
  */
 static unsigned int find_faked_portnum_from_hw_portnum(struct usb_hcd *hcd,
 		struct xhci_hcd *xhci, u32 port_id)
@@ -1340,7 +1341,7 @@ static void handle_port_status(struct xh
 			temp |= PORT_LINK_STROBE | XDEV_U0;
 			xhci_writel(xhci, temp, port_array[faked_port_index]);
 			slot_id = xhci_find_slot_id_by_port(hcd, xhci,
-					faked_port_index);
+					faked_port_index + 1);
 			if (!slot_id) {
 				xhci_dbg(xhci, "slot_id is zero\n");
 				goto cleanup;


