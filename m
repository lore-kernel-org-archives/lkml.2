Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab0JVTX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:23:58 -0400
Received: from kroah.org ([198.145.64.141]:33924 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923Ab0JVSzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:55:54 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:28 2010
Message-Id: <20101022185228.206369696@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>, Felipe Balbi <balbi@ti.com>
Subject: [010/103] usb: musb: gadget: restart request on clearing endpoint halt
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1095,7 +1095,7 @@ struct free_record {
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
@@ -105,4 +105,6 @@ extern void musb_gadget_cleanup(struct m
 
 extern void musb_g_giveback(struct musb_ep *, struct usb_request *, int);
 
+extern void musb_ep_restart(struct musb *, struct musb_request *);
+
 #endif		/* __MUSB_GADGET_H */
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


