Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab2AXLsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:48:05 -0500
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:37514 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100Ab2AXLsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:48:02 -0500
MIME-Version: 1.0
From: Felipe Balbi <balbi@ti.com>
To: Linux USB Mailing List <linux-usb@vger.kernel.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM 
	,commit_signer:28/51=55%),
        Thomas Dahlmann <dahlmann.thomas@arcor.de> (supporter:AMD GEODE
	CS5536...),
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> (commit_signer:43/51=84%),
        linux-omap@vger.kernel.org (open list:DESIGNWARE USB3 D...),
        linux-kernel@vger.kernel.org (open list),
        linux-geode@lists.infradead.org (open list:AMD GEODE CS5536...)
Subject: [PATCH 6/9] usb: gadget: r8a66597: use generic map/unmap routines
Date: Tue, 24 Jan 2012 13:45:27 +0200
Message-Id: <1327405543-27589-7-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.2
In-Reply-To: <1327405543-27589-1-git-send-email-balbi@ti.com>
References: <1327405543-27589-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

those routines have everything we need to map/unmap
USB requests and it's better to use them.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/gadget/r8a66597-udc.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index f5b8d21..c4401e7 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -663,11 +663,7 @@ static int sudmac_alloc_channel(struct r8a66597 *r8a66597,
 	ep->fifoctr = D0FIFOCTR;
 
 	/* dma mapping */
-	req->req.dma = dma_map_single(r8a66597_to_dev(ep->r8a66597),
-				req->req.buf, req->req.length,
-				dma->dir ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
-
-	return 0;
+	return usb_gadget_map_request(&r8a66597->gadget, &req->req, dma->dir);
 }
 
 static void sudmac_free_channel(struct r8a66597 *r8a66597,
@@ -677,9 +673,7 @@ static void sudmac_free_channel(struct r8a66597 *r8a66597,
 	if (!r8a66597_is_sudmac(r8a66597))
 		return;
 
-	dma_unmap_single(r8a66597_to_dev(ep->r8a66597),
-			 req->req.dma, req->req.length,
-			 ep->dma->dir ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+	usb_gadget_unmap_request(&r8a66597->gadget, &req->req, ep->dma->dir);
 
 	r8a66597_bclr(r8a66597, DREQE, ep->fifosel);
 	r8a66597_change_curpipe(r8a66597, 0, 0, ep->fifosel);
-- 
1.7.8.2

