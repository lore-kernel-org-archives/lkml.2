Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965196Ab2E0BK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:10:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965067Ab2E0BKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:10:24 -0400
Message-Id: <20120527010431.670358859@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:19 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Chen <peter.chen@freescale.com>,
        Li Yang <leoli@freescale.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 56/94] usb: gadget: fsl_udc_core: dTDs next dtd pointer need to be updated once written
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@freescale.com>

commit 4d0947dec4db1224354e2f6f00ae22ce38e62a43 upstream.

dTD's next dtd pointer need to be updated once CPU writes it, or this
request may not be handled by controller, then host will get NAK from
device forever.

This problem occurs when there is a request is handling, we need to add
a new request to dTD list, if this new request is added before the current
one is finished, the new request is intended to added as next dtd pointer
at current dTD, but without wmb(), the dTD's next dtd pointer may not be
updated when the controller reads it. In that case, the controller will
still get Terminate Bit is 1 at dTD's next dtd pointer, that means there is
no next request, then this new request is missed by controller.

Signed-off-by: Peter Chen <peter.chen@freescale.com>
Acked-by: Li Yang <leoli@freescale.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/fsl_udc_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -737,6 +737,8 @@ static void fsl_queue_td(struct fsl_ep *
 		lastreq = list_entry(ep->queue.prev, struct fsl_req, queue);
 		lastreq->tail->next_td_ptr =
 			cpu_to_hc32(req->head->td_dma & DTD_ADDR_MASK);
+		/* Ensure dTD's next dtd pointer to be updated */
+		wmb();
 		/* Read prime bit, if 1 goto done */
 		if (fsl_readl(&dr_regs->endpointprime) & bitmask)
 			return;


