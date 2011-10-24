Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab1JXMxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:53:05 -0400
Received: from sestofw01.enea.se ([192.36.1.252]:14277 "HELO mx-3.enea.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932303Ab1JXMxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:53:03 -0400
Message-ID: <4EA55FAC.9040200@enea.com>
Date: Mon, 24 Oct 2011 14:53:00 +0200
From: Arvid Brodin <arvid.brodin@enea.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Memory leak in isp1760-hcd.c - [PATCH 2/2] usb/isp1760: Fix race
 condition memory leak
References: <20111019152132.GH29653@arm.com>
In-Reply-To: <20111019152132.GH29653@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.23.1.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a condition reported by Catalin Marinas:

schedule_ptds() is called from isp1760_irq() and removes the qh from the
controlqhs queue but ep->hcpriv still points to the qh and therefore it is not
freed.

Shortly after this, the isp1760_endpoint_disable() function sets ep->hcpriv to
NULL and calls schedule_ptds() but since the corresponding qh is no longer in
the queue, it is simply forgotten and reported by kmemleak.

While I was at it, I also replaced the lines in isp1760_endpoint_disable()
that removed remaining qtds from the qh with a WARN_ON check for non-empty qh,
in line with earlier comments from Alan Stern (2011-07-20).
---
 drivers/usb/host/isp1760-hcd.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
index 1adb21e..2df6631 100644
--- a/drivers/usb/host/isp1760-hcd.c
+++ b/drivers/usb/host/isp1760-hcd.c
@@ -922,7 +922,6 @@ void schedule_ptds(struct usb_hcd *hcd)
 	struct isp1760_hcd *priv;
 	struct isp1760_qh *qh, *qh_next;
 	struct list_head *ep_queue;
-	struct usb_host_endpoint *ep;
 	LIST_HEAD(urb_list);
 	struct urb_listitem *urb_listitem, *urb_listitem_next;
 	int i;
@@ -940,17 +939,9 @@ void schedule_ptds(struct usb_hcd *hcd)
 	for (i = 0; i < QH_END; i++) {
 		ep_queue = &priv->qh_list[i];
 		list_for_each_entry_safe(qh, qh_next, ep_queue, qh_list) {
-			ep = list_entry(qh->qtd_list.next, struct isp1760_qtd,
-							qtd_list)->urb->ep;
 			collect_qtds(hcd, qh, &urb_list);
-			if (list_empty(&qh->qtd_list)) {
+			if (list_empty(&qh->qtd_list))
 				list_del(&qh->qh_list);
-				if (ep->hcpriv == NULL) {
-					/* Endpoint has been disabled, so we
-					can free the associated queue head. */
-					qh_free(qh);
-				}
-			}
 		}
 	}
 
@@ -1692,8 +1683,8 @@ static void isp1760_endpoint_disable(struct usb_hcd *hcd,
 {
 	struct isp1760_hcd *priv = hcd_to_priv(hcd);
 	unsigned long spinflags;
-	struct isp1760_qh *qh;
-	struct isp1760_qtd *qtd;
+	struct isp1760_qh *qh, *qh_iter;
+	int i;
 
 	spin_lock_irqsave(&priv->lock, spinflags);
 
@@ -1701,14 +1692,17 @@ static void isp1760_endpoint_disable(struct usb_hcd *hcd,
 	if (!qh)
 		goto out;
 
-	list_for_each_entry(qtd, &qh->qtd_list, qtd_list)
-		if (qtd->status != QTD_RETIRE) {
-			dequeue_urb_from_qtd(hcd, qh, qtd);
-			qtd->urb->status = -ECONNRESET;
-		}
+	WARN_ON(!list_empty(&qh->qtd_list));
 
+	for (i = 0; i < QH_END; i++)
+		list_for_each_entry(qh_iter, &priv->qh_list[i], qh_list)
+			if (qh_iter == qh) {
+				list_del(&qh_iter->qh_list);
+				i = QH_END;
+				break;
+			}
+	qh_free(qh);
 	ep->hcpriv = NULL;
-	/* Cannot free qh here since it will be parsed by schedule_ptds() */
 
 	schedule_ptds(hcd);
 
-- 
1.6.3.3

-- 
Arvid Brodin
Enea Services Stockholm AB
