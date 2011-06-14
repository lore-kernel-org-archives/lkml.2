Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab1FNG2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 02:28:40 -0400
Received: from relay03.digicable.hu ([92.249.128.185]:51231 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab1FNG2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 02:28:39 -0400
Message-ID: <4DF6FF8A.5090304@freemail.hu>
Date: Tue, 14 Jun 2011 08:28:26 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Max Vozeler <max@hinterhof.net>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] usbip: dump the port status difference
References: <4DF68159.1090206@freemail.hu> <1308003146.26699.43.camel@Joe-Laptop>
In-Reply-To: <1308003146.26699.43.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 92.249.250.109
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
Cc: Joe Perches <joe@perches.com>
---
---
 drivers/staging/usbip/vhci_hcd.c |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 658c674..d3f11a3 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -92,14 +92,28 @@ static const char * const bit_desc[] = {
 	"R31",			/*31*/
 };

-static void dump_port_status(u32 status)
+static void dump_port_status_diff(u32 prev_status, u32 new_status)
 {
 	int i = 0;
-
-	pr_debug("status %08x:", status);
-	for (i = 0; i < 32; i++) {
-		if (status & (1 << i))
-			pr_debug(" %s", bit_desc[i]);
+	u32 bit = 1;
+
+	pr_debug("status prev -> new: %08x -> %08x\n", prev_status, new_status);
+	while (bit) {
+		u32 prev = prev_status & bit;
+		u32 new = new_status & bit;
+		char change;
+
+		if (!prev && new)
+			change = '+';
+		else if (prev && !new)
+			change = '-';
+		else
+			change = ' ';
+
+		if (prev || new)
+			pr_debug(" %c%s\n", change, bit_desc[i]);
+		bit <<= 1;
+		i++;
 	}
 	pr_debug("\n");
 }
@@ -466,8 +480,8 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		pr_debug("port %d\n", rhport);
 		/* Only dump valid port status */
 		if (rhport >= 0) {
-			dump_port_status(prev_port_status[rhport]);
-			dump_port_status(dum->port_status[rhport]);
+			dump_port_status_diff(prev_port_status[rhport],
+					      dum->port_status[rhport]);
 		}
 	}
 	usbip_dbg_vhci_rh(" bye\n");
-- 
1.7.2.5

