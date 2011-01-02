Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1ABHpD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:45:03 -0500
Received: from mail.windriver.com ([147.11.1.11]:36311 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab1ABHYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:24 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 167/260] usb: musb: gadget: restart request on clearing endpoint halt
Date: Sun,  2 Jan 2011 02:17:43 -0500
Message-Id: <1293952756-15010-168-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:13.0822 (UTC) FILETIME=[EAC5B3E0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit a666e3e6098a9f56310e4ec2705f1dad124a34b5 upstream.

Commit 46034dca515bc4ddca0399ae58106d1f5f0d809f (USB: musb_gadget_ep0: stop
abusing musb_gadget_set_halt()) forgot to restart a queued request after
clearing the endpoint halt feature. This results in a couple of USB resets
while enumerating the file-backed storage gadget due to CSW packet not being
sent for the MODE SENSE(10) command.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/musb/musb_gadget.c     |    2 +-
 drivers/usb/musb/musb_gadget.h     |    2 ++
 drivers/usb/musb/musb_gadget_ep0.c |    9 +++++++++
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index de0ca90..180da4e 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1095,7 +1095,7 @@ struct free_record {
 /*
  * Context: controller locked, IRQs blocked.
  */
-static void musb_ep_restart(struct musb *musb, struct musb_request *req)
+void musb_ep_restart(struct musb *musb, struct musb_request *req)
 {
 	DBG(3, "<== %s request %p len %u on hw_ep%d\n",
 		req->tx ? "TX/IN" : "RX/OUT",
diff --git a/drivers/usb/musb/musb_gadget.h b/drivers/usb/musb/musb_gadget.h
index c8b1403..572b1da 100644
--- a/drivers/usb/musb/musb_gadget.h
+++ b/drivers/usb/musb/musb_gadget.h
@@ -105,4 +105,6 @@ extern void musb_gadget_cleanup(struct musb *);
 
 extern void musb_g_giveback(struct musb_ep *, struct usb_request *, int);
 
+extern void musb_ep_restart(struct musb *, struct musb_request *);
+
 #endif		/* __MUSB_GADGET_H */
diff --git a/drivers/usb/musb/musb_gadget_ep0.c b/drivers/usb/musb/musb_gadget_ep0.c
index 53d0645..2eb90b3 100644
--- a/drivers/usb/musb/musb_gadget_ep0.c
+++ b/drivers/usb/musb/musb_gadget_ep0.c
@@ -261,6 +261,7 @@ __acquires(musb->lock)
 					ctrlrequest->wIndex & 0x0f;
 				struct musb_ep		*musb_ep;
 				struct musb_hw_ep	*ep;
+				struct musb_request	*request;
 				void __iomem		*regs;
 				int			is_in;
 				u16			csr;
@@ -302,6 +303,14 @@ __acquires(musb->lock)
 					musb_writew(regs, MUSB_RXCSR, csr);
 				}
 
+				/* Maybe start the first request in the queue */
+				request = to_musb_request(
+						next_request(musb_ep));
+				if (!musb_ep->busy && request) {
+					DBG(3, "restarting the request\n");
+					musb_ep_restart(musb, request);
+				}
+
 				/* select ep0 again */
 				musb_ep_select(mbase, 0);
 				} break;
-- 
1.7.3.3

