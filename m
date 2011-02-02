Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab1BBAo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:35413 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab1BBAoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028580"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: sarah.a.sharp@linux.intel.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [106/139] xhci: Fix issue with port array setup and buggy hosts.
Message-Id: <20110202004504.AA88B3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/xhci-mem.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

Index: linux-2.6.35.y/drivers/usb/host/xhci-mem.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/xhci-mem.c
+++ linux-2.6.35.y/drivers/usb/host/xhci-mem.c
@@ -1670,6 +1670,7 @@ static void xhci_add_in_port(struct xhci
 				xhci->port_array[i] = (u8) -1;
 			}
 			/* FIXME: Should we disable the port? */
+			continue;
 		}
 		xhci->port_array[i] = major_revision;
 		if (major_revision == 0x03)
@@ -1748,16 +1749,20 @@ static int xhci_setup_port_arrays(struct
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
