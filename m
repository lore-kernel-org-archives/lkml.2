Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab0LHBXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:23:20 -0500
Received: from kroah.org ([198.145.64.141]:33544 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563Ab0LHBCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:52 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:41 2010
Message-Id: <20101208005741.070593470@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [196/289] xhci: Dont let the USB core disable SuperSpeed ports.
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/usb/host/xhci-hub.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
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


