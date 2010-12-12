Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab0LMADx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:03:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36418 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab0LLXr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:29 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: sarah.a.sharp@linux.intel.com, dzickus@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [145/223] xhci: Don't let the USB core disable SuperSpeed ports.
Message-Id: <20101212234728.29017B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 6dd0a3a7e0793dbeae1b951f091025d8cf896cb4 upstream.

Disabling SuperSpeed ports is a Very Bad Thing (TM).  It disables
SuperSpeed terminations, which means that devices will never connect at
SuperSpeed on that port.  For USB 2.0/1.1 ports, disabling the port meant
that the USB core could always get a connect status change later.  That's
not true with USB 3.0 ports.

Do not let the USB core disable SuperSpeed ports.  We can't rely on the
device speed in the port status registers, since that isn't valid until
there's a USB device connected to the port.  Instead, we use the port
speed array that's created from the Extended Capabilities registers.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Tested-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/xhci-hub.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux/drivers/usb/host/xhci-hub.c
===================================================================
--- linux.orig/drivers/usb/host/xhci-hub.c
+++ linux/drivers/usb/host/xhci-hub.c
@@ -132,6 +132,13 @@ static u32 xhci_port_state_to_neutral(u3
 static void xhci_disable_port(struct xhci_hcd *xhci, u16 wIndex,
 		u32 __iomem *addr, u32 port_status)
 {
+	/* Don't allow the USB core to disable SuperSpeed ports. */
+	if (xhci->port_array[wIndex] == 0x03) {
+		xhci_dbg(xhci, "Ignoring request to disable "
+				"SuperSpeed port.\n");
+		return;
+	}
+
 	/* Write 1 to disable the port */
 	xhci_writel(xhci, port_status | PORT_PE, addr);
 	port_status = xhci_readl(xhci, addr);
