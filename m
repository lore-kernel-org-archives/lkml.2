Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab1AFAkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:40:25 -0500
Received: from kroah.org ([198.145.64.141]:35978 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab1AFAbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:08 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:07 2011
Message-Id: <20110106002307.453805563@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [113/152] xhci: Fix issue with port array setup and buggy hosts.
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit f8bbeabc34aa945ab4275abc9a4dfde0aea798ca upstream.

Fix two bugs with the port array setup.

The first bug will only show up with broken xHCI hosts with Extended
Capabilities registers that have duplicate port speed entries for the same
port.  The idea with the original code was to set the port_array entry to
-1 if the duplicate port speed entry said the port was a different speed
than the original port speed entry.  That would mean that later, the port
would not be exposed to the USB core. Unfortunately, I forgot a continue
statement, and the port_array entry would just be overwritten in the next
line.

The second bug would happen if there are conflicting port speed registers
(so that some entry in port_array is -1), or one of the hardware port
registers was not described in the port speed registers (so that some
entry in port_array is 0).  The code that sets up the usb2_ports array
would accidentally claim those ports.  That wouldn't really cause any
user-visible issues, but it is a bug.

This patch should go into the stable trees that have the port array and
USB 3.0 port disabling prevention patches.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-mem.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1677,6 +1677,7 @@ static void xhci_add_in_port(struct xhci
 				xhci->port_array[i] = (u8) -1;
 			}
 			/* FIXME: Should we disable the port? */
+			continue;
 		}
 		xhci->port_array[i] = major_revision;
 		if (major_revision == 0x03)
@@ -1755,16 +1756,20 @@ static int xhci_setup_port_arrays(struct
 			return -ENOMEM;
 
 		port_index = 0;
-		for (i = 0; i < num_ports; i++)
-			if (xhci->port_array[i] != 0x03) {
-				xhci->usb2_ports[port_index] =
-					&xhci->op_regs->port_status_base +
-					NUM_PORT_REGS*i;
-				xhci_dbg(xhci, "USB 2.0 port at index %u, "
-						"addr = %p\n", i,
-						xhci->usb2_ports[port_index]);
-				port_index++;
-			}
+		for (i = 0; i < num_ports; i++) {
+			if (xhci->port_array[i] == 0x03 ||
+					xhci->port_array[i] == 0 ||
+					xhci->port_array[i] == -1)
+				continue;
+
+			xhci->usb2_ports[port_index] =
+				&xhci->op_regs->port_status_base +
+				NUM_PORT_REGS*i;
+			xhci_dbg(xhci, "USB 2.0 port at index %u, "
+					"addr = %p\n", i,
+					xhci->usb2_ports[port_index]);
+			port_index++;
+		}
 	}
 	if (xhci->num_usb3_ports) {
 		xhci->usb3_ports = kmalloc(sizeof(*xhci->usb3_ports)*


