Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab1FMVaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 17:30:11 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:51230 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab1FMVaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:30:09 -0400
Message-ID: <4DF68159.1090206@freemail.hu>
Date: Mon, 13 Jun 2011 23:30:01 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Max Vozeler <max@hinterhof.net>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] usbip: dump the port status difference
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 94.21.187.147
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

At the beginning of vhci_hub_control() function the port
status is saved to show what are the differences between the
previous and the new status. Change the dump function to
really show the differences in the status bit changes: put
a '+' sign before the symbolic name of a bit where a bit
was set, a '-' sign where the bit was cleared and a SPACE
where the bit was not changed. This is similar to the way
"diff -u" shows the changes and easy to understand.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
 drivers/staging/usbip/vhci_hcd.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 512a97f..d3ce569 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -92,14 +92,22 @@ static const char * const bit_desc[] = {
 	"R31",			/*31*/
 };

-static void dump_port_status(u32 status)
+static void dump_port_status_diff(u32 prev_status, u32 new_status)
 {
 	int i = 0;

-	pr_debug("status %08x:", status);
+	pr_debug("status %08x -> %08x:", prev_status, new_status);
 	for (i = 0; i < 32; i++) {
-		if (status & (1 << i))
-			pr_debug(" %s", bit_desc[i]);
+		if (!(prev_status & (1 << i)) &&
+		      new_status & (1 << i)) {
+			pr_debug(" +%s", bit_desc[i]);
+		} else if (prev_status & (1 << i) &&
+			   !(new_status & (1 << i))) {
+			pr_debug(" -%s", bit_desc[i]);
+		} else if (prev_status & (1 << i) &&
+			   new_status & (1 << i)) {
+			pr_debug("  %s", bit_desc[i]);
+		}
 	}
 	pr_debug("\n");
 }
@@ -466,8 +474,8 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		pr_debug("port %d\n", rhport);
 		/* Only dump valid port status */
 		if (0 <= rhport) {
-			dump_port_status(prev_port_status[rhport]);
-			dump_port_status(dum->port_status[rhport]);
+			dump_port_status_diff(prev_port_status[rhport],
+					      dum->port_status[rhport]);
 		}
 	}
 	usbip_dbg_vhci_rh(" bye\n");
-- 
1.7.2.5

