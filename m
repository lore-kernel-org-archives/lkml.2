Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2GWRuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:50:23 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:55498
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754430Ab2GWRuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:50:20 -0400
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT003.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1202hzz8275bhz2fh2a8h668h839hd24he5bhf0ah107ah)
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <devel@driverdev.osuosl.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 3/5] staging: ozwpan: Return correct actual_length to userland
Date: Mon, 23 Jul 2012 18:49:45 +0100
Message-ID: <1343065787-7616-4-git-send-email-rgujare@ozmodevices.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1343065787-7616-1-git-send-email-rgujare@ozmodevices.com>
References: <1343065787-7616-1-git-send-email-rgujare@ozmodevices.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes issue where wrong retrun value was received
by userland application after writing data to raw hid device.

Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
---
 drivers/staging/ozwpan/ozhcd.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 4ac1f27..76821cb 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -933,13 +933,14 @@ void oz_hcd_control_cnf(void *hport, u8 req_id, u8 rcode, u8 *data,
 	} else {
 		int copy_len;
 		oz_trace("VENDOR-CLASS - cnf\n");
-		if (data_len <= urb->transfer_buffer_length)
-			copy_len = data_len;
-		else
-			copy_len = urb->transfer_buffer_length;
-		if (copy_len)
+		if (data_len) {
+			if (data_len <= urb->transfer_buffer_length)
+				copy_len = data_len;
+			else
+				copy_len = urb->transfer_buffer_length;
 			memcpy(urb->transfer_buffer, data, copy_len);
-		urb->actual_length = copy_len;
+			urb->actual_length = copy_len;
+		}
 		oz_complete_urb(hcd, urb, 0, 0);
 	}
 }
@@ -1517,6 +1518,7 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 		int data_len = 0;
 		if ((setup->bRequestType & USB_DIR_IN) == 0)
 			data_len = wlength;
+		urb->actual_length = data_len;
 		if (oz_usb_control_req(port->hpd, req_id, setup,
 				urb->transfer_buffer, data_len)) {
 			rc = -ENOMEM;
-- 
1.7.5.4


