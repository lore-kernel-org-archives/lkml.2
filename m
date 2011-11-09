Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935165Ab1KJE7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:59:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046Ab1KJD3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:18 2011
Message-Id: <20111109212718.777557060@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andiry Xu <andiry.xu@amd.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [181/262] xHCI: test and clear RWC bit
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andiry Xu <andiry.xu@amd.com>

commit d2f52c9e585bbb1a3c164e02b8dcd0d996c67353 upstream.

Introduce xhci_test_and_clear_bit() to clear RWC bit in PORTSC register.

Signed-off-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-hub.c  |   22 ++++++++++++++++------
 drivers/usb/host/xhci-ring.c |    6 ++----
 drivers/usb/host/xhci.h      |    2 ++
 3 files changed, 20 insertions(+), 10 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -392,6 +392,20 @@ static int xhci_get_ports(struct usb_hcd
 	return max_ports;
 }
 
+/* Test and clear port RWC bit */
+void xhci_test_and_clear_bit(struct xhci_hcd *xhci, __le32 __iomem **port_array,
+				int port_id, u32 port_bit)
+{
+	u32 temp;
+
+	temp = xhci_readl(xhci, port_array[port_id]);
+	if (temp & port_bit) {
+		temp = xhci_port_state_to_neutral(temp);
+		temp |= port_bit;
+		xhci_writel(xhci, temp, port_array[port_id]);
+	}
+}
+
 int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		u16 wIndex, char *buf, u16 wLength)
 {
@@ -938,12 +952,8 @@ int xhci_bus_resume(struct usb_hcd *hcd)
 			spin_lock_irqsave(&xhci->lock, flags);
 
 			/* Clear PLC */
-			temp = xhci_readl(xhci, port_array[port_index]);
-			if (temp & PORT_PLC) {
-				temp = xhci_port_state_to_neutral(temp);
-				temp |= PORT_PLC;
-				xhci_writel(xhci, temp, port_array[port_index]);
-			}
+			xhci_test_and_clear_bit(xhci, port_array, port_index,
+						PORT_PLC);
 
 			slot_id = xhci_find_slot_id_by_port(hcd,
 					xhci, port_index + 1);
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1347,10 +1347,8 @@ static void handle_port_status(struct xh
 			xhci_ring_device(xhci, slot_id);
 			xhci_dbg(xhci, "resume SS port %d finished\n", port_id);
 			/* Clear PORT_PLC */
-			temp = xhci_readl(xhci, port_array[faked_port_index]);
-			temp = xhci_port_state_to_neutral(temp);
-			temp |= PORT_PLC;
-			xhci_writel(xhci, temp, port_array[faked_port_index]);
+			xhci_test_and_clear_bit(xhci, port_array,
+						faked_port_index, PORT_PLC);
 		} else {
 			xhci_dbg(xhci, "resume HS port %d\n", port_id);
 			bus_state->resume_done[faked_port_index] = jiffies +
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1566,6 +1566,8 @@ void xhci_ring_ep_doorbell(struct xhci_h
 		unsigned int ep_index, unsigned int stream_id);
 
 /* xHCI roothub code */
+void xhci_test_and_clear_bit(struct xhci_hcd *xhci, __le32 __iomem **port_array,
+				int port_id, u32 port_bit);
 int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex,
 		char *buf, u16 wLength);
 int xhci_hub_status_data(struct usb_hcd *hcd, char *buf);


