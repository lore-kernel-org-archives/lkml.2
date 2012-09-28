Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031283Ab2I1Tb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:31:27 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50498 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030200Ab2I1TBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:01:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Marc Kleine-Budde <mkl@pengutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [ 156/262] usb: chipidea: udc: fix setup of endpoint maxpacket size
Date: Fri, 28 Sep 2012 11:51:25 -0700
Message-Id: <20120928183016.410560625@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 7f67c38bdcb6d8bce02e10521fbf1618b586319f upstream.

This patch changes the setup of the endpoint maxpacket size. All non control
endpoints are initialized with an undefined ((unsigned short)~0) maxpacket
size. The maxpacket size of Endpoint 0 will be kept at CTRL_PAYLOAD_MAX.

Some gadget drivers check for the maxpacket size before they enable the
endpoint, which leads to a wrong state in these drivers.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/udc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1468,7 +1468,12 @@ static int init_eps(struct ci13xxx *udc)
 
 			mEp->ep.name      = mEp->name;
 			mEp->ep.ops       = &usb_ep_ops;
-			mEp->ep.maxpacket = CTRL_PAYLOAD_MAX;
+			/*
+			 * for ep0: maxP defined in desc, for other
+			 * eps, maxP is set by epautoconfig() called
+			 * by gadget layer
+			 */
+			mEp->ep.maxpacket = (unsigned short)~0;
 
 			INIT_LIST_HEAD(&mEp->qh.queue);
 			mEp->qh.ptr = dma_pool_alloc(udc->qh_pool, GFP_KERNEL,
@@ -1488,6 +1493,7 @@ static int init_eps(struct ci13xxx *udc)
 				else
 					udc->ep0in = mEp;
 
+				mEp->ep.maxpacket = CTRL_PAYLOAD_MAX;
 				continue;
 			}
 


