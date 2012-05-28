Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2E1DtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:49:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51987 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753784Ab2E1D3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:22 -0400
Message-Id: <20120528031209.225411314@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Chen <peter.chen@freescale.com>,
        Li Yang <leoli@freescale.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 046/117] usb: gadget: fsl_udc_core: dTDs next dtd pointer need to be updated
 once written
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/fsl_udc_core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 8f6fc70..5a52d42 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -735,6 +735,8 @@ static void fsl_queue_td(struct fsl_ep *ep, struct fsl_req *req)
 		lastreq = list_entry(ep->queue.prev, struct fsl_req, queue);
 		lastreq->tail->next_td_ptr =
 			cpu_to_hc32(req->head->td_dma & DTD_ADDR_MASK);
+		/* Ensure dTD's next dtd pointer to be updated */
+		wmb();
 		/* Read prime bit, if 1 goto done */
 		if (fsl_readl(&dr_regs->endpointprime) & bitmask)
 			return;


