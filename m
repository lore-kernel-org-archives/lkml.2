Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122Ab0JVSyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:54:43 -0400
Received: from kroah.org ([198.145.64.141]:45596 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487Ab0JVSiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:17 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:35:57 2010
Message-Id: <20101022183557.048448775@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:34:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>, Felipe Balbi <balbi@ti.com>
Subject: [09/66] usb: musb: gadget: restart request on clearing endpoint halt
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

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

---
 drivers/usb/musb/musb_gadget.c     |    2 +-
 drivers/usb/musb/musb_gadget.h     |    2 ++
 drivers/usb/musb/musb_gadget_ep0.c |    9 +++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1088,7 +1088,7 @@ struct free_record {
 /*
  * Context: controller locked, IRQs blocked.
  */
-static void musb_ep_restart(struct musb *musb, struct musb_request *req)
+void musb_ep_restart(struct musb *musb, struct musb_request *req)
 {
 	DBG(3, "<== %s request %p len %u on hw_ep%d\n",
 		req->tx ? "TX/IN" : "RX/OUT",
--- a/drivers/usb/musb/musb_gadget.h
+++ b/drivers/usb/musb/musb_gadget.h
@@ -105,4 +105,6 @@ extern void musb_g_giveback(struct musb_
 
 extern int musb_gadget_set_halt(struct usb_ep *ep, int value);
 
+extern void musb_ep_restart(struct musb *, struct musb_request *);
+
 #endif		/* __MUSB_GADGET_H */
--- a/drivers/usb/musb/musb_gadget_ep0.c
+++ b/drivers/usb/musb/musb_gadget_ep0.c
@@ -369,6 +369,7 @@ stall:
 					ctrlrequest->wIndex & 0x0f;
 				struct musb_ep		*musb_ep;
 				struct musb_hw_ep	*ep;
+				struct musb_request	*request;
 				void __iomem		*regs;
 				int			is_in;
 				u16			csr;
@@ -411,6 +412,14 @@ stall:
 							csr);
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
 				handled = 1;


