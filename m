Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab2IEGsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 02:48:50 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36742 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2IEGst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 02:48:49 -0400
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 14:48:48 +0800
Message-ID: <CAPgLHd99uzo41CmwGtwhTgiv9=ANDmiAxWfBhxDSoBhkQrBKjw@mail.gmail.com>
Subject: [PATCH] staging: ozwpan: use list_move_tail instead of list_del/list_add_tail
From: Wei Yongjun <weiyj.lk@gmail.com>
To: rgujare@ozmodevices.com, ckelly@ozmodevices.com,
        gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/ozwpan/ozhcd.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 251f07c..ba9ac93 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -1014,8 +1014,7 @@ int oz_hcd_heartbeat(void *hport)
 			ep->credit -= urb->number_of_packets;
 			oz_event_log(OZ_EVT_EP_CREDIT, ep->ep_num, 0, 0,
 				ep->credit);
-			list_del(&urbl->link);
-			list_add_tail(&urbl->link, &xfr_list);
+			list_move_tail(&urbl->link, &xfr_list);
 		}
 	}
 	spin_unlock_bh(&ozhcd->hcd_lock);
@@ -1096,8 +1095,7 @@ int oz_hcd_heartbeat(void *hport)
 			urb->error_count = 0;
 			urb->start_frame = ep->start_frame;
 			ep->start_frame += urb->number_of_packets;
-			list_del(&urbl->link);
-			list_add_tail(&urbl->link, &xfr_list);
+			list_move_tail(&urbl->link, &xfr_list);
 			ep->credit -= urb->number_of_packets;
 			oz_event_log(OZ_EVT_EP_CREDIT, ep->ep_num | USB_DIR_IN,
 				0, 0, ep->credit);
@@ -1129,8 +1127,7 @@ int oz_hcd_heartbeat(void *hport)
 				oz_trace("%ld: Request 0x%p timeout\n",
 						now, urbl->urb);
 				urbl->submit_jiffies = now;
-				list_del(e);
-				list_add_tail(e, &xfr_list);
+				list_move_tail(e, &xfr_list);
 			}
 		}
 		if (!list_empty(&ep->urb_list))
@@ -1247,16 +1244,14 @@ static void oz_clean_endpoints_for_interface(struct usb_hcd *hcd,
 			port->out_ep[i] = 0;
 			/* Remove from isoc list if present.
 			 */
-			list_del(e);
-			list_add_tail(e, &ep_list);
+			list_move_tail(e, &ep_list);
 		}
 		/* Gather IN endpoints.
 		 */
 		if ((mask & (1<<(i+OZ_NB_ENDPOINTS))) && port->in_ep[i]) {
 			e = &port->in_ep[i]->link;
 			port->in_ep[i] = 0;
-			list_del(e);
-			list_add_tail(e, &ep_list);
+			list_move_tail(e, &ep_list);
 		}
 	}
 	spin_unlock_bh(&ozhcd->hcd_lock);


