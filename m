Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab2GWRuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:50:17 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:11474
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754526Ab2GWRuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:50:15 -0400
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT003.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1202hzz8275bhz2fh2a8h668h839hd24he5bhf0ah107ah)
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <devel@driverdev.osuosl.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 2/5] staging: ozwpan: Insulate driver from HZ value
Date: Mon, 23 Jul 2012 18:49:44 +0100
Message-ID: <1343065787-7616-3-git-send-email-rgujare@ozmodevices.com>
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

This patch fixes issue caused due to different HZ
value on system which do not have HZ=1000

Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
---
 drivers/staging/ozwpan/ozhcd.c   |    8 ++++----
 drivers/staging/ozwpan/ozproto.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 617bfed..4ac1f27 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -1053,7 +1053,7 @@ int oz_hcd_heartbeat(void *hport)
 		ep = ep_from_link(e);
 		if (ep->credit < 0)
 			continue;
-		ep->credit += (now - ep->last_jiffies);
+		ep->credit += jiffies_to_msecs(now - ep->last_jiffies);
 		if (ep->credit > ep->credit_ceiling)
 			ep->credit = ep->credit_ceiling;
 		oz_event_log(OZ_EVT_EP_CREDIT, ep->ep_num, 0, 0, ep->credit);
@@ -1062,7 +1062,7 @@ int oz_hcd_heartbeat(void *hport)
 			urbl = list_first_entry(&ep->urb_list,
 				struct oz_urb_link, link);
 			urb = urbl->urb;
-			if (ep->credit < urb->number_of_packets)
+			if ((ep->credit + 1) < urb->number_of_packets)
 				break;
 			ep->credit -= urb->number_of_packets;
 			oz_event_log(OZ_EVT_EP_CREDIT, ep->ep_num, 0, 0,
@@ -1105,7 +1105,7 @@ int oz_hcd_heartbeat(void *hport)
 			}
 			continue;
 		}
-		ep->credit += (now - ep->last_jiffies);
+		ep->credit += jiffies_to_msecs(now - ep->last_jiffies);
 		oz_event_log(OZ_EVT_EP_CREDIT, ep->ep_num | USB_DIR_IN,
 			0, 0, ep->credit);
 		ep->last_jiffies = now;
@@ -1117,7 +1117,7 @@ int oz_hcd_heartbeat(void *hport)
 			int len = 0;
 			int copy_len;
 			int i;
-			if (ep->credit < urb->number_of_packets)
+			if ((ep->credit + 1) < urb->number_of_packets)
 				break;
 			if (ep->buffered_units < urb->number_of_packets)
 				break;
diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
index 89aea28..7d5b476 100644
--- a/drivers/staging/ozwpan/ozproto.h
+++ b/drivers/staging/ozwpan/ozproto.h
@@ -14,7 +14,7 @@
 
 /* Converts millisecs to jiffies.
  */
-#define oz_ms_to_jiffies(__x)	(((__x)*1000)/HZ)
+#define oz_ms_to_jiffies(__x)	msecs_to_jiffies(__x)
 
 /* Quantum milliseconds.
  */
-- 
1.7.5.4


