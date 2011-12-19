Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab1LSKcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 05:32:54 -0500
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:49899 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335Ab1LSKbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 05:31:16 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux USB Mailing List <linux-usb@vger.kernel.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM 
	,commit_signer:28/50=56%),
        Thomas Dahlmann <dahlmann.thomas@arcor.de> (supporter:AMD GEODE
	CS5536...),
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> (commit_signer:43/50=86%),
        linux-omap@vger.kernel.org (open list:DESIGNWARE USB3 D...),
        linux-kernel@vger.kernel.org (open list),
        linux-geode@lists.infradead.org (open list:AMD GEODE CS5536...)
Subject: [PATCH 4/9] usb: renesas: gadget: use generic map/unmap routines
Date: Mon, 19 Dec 2011 12:30:26 +0200
Message-Id: <1324290632-23758-5-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.rc3
In-Reply-To: <1324290632-23758-1-git-send-email-balbi@ti.com>
References: <1324290632-23758-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

those routines have everything we need to map/unmap
USB requests and it's better to use them.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/renesas_usbhs/mod_gadget.c |   60 ++++----------------------------
 1 files changed, 7 insertions(+), 53 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
index 528691d5f..cb92a1d 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -165,69 +165,23 @@ static void usbhsg_queue_push(struct usbhsg_uep *uep,
 /*
  *		dma map/unmap
  */
-static int usbhsg_dma_map(struct device *dev,
-			  struct usbhs_pkt *pkt,
-			  enum dma_data_direction dir)
-{
-	struct usbhsg_request *ureq = usbhsg_pkt_to_ureq(pkt);
-	struct usb_request *req = &ureq->req;
-
-	if (pkt->dma != DMA_ADDR_INVALID) {
-		dev_err(dev, "dma is already mapped\n");
-		return -EIO;
-	}
-
-	if (req->dma == DMA_ADDR_INVALID) {
-		pkt->dma = dma_map_single(dev, pkt->buf, pkt->length, dir);
-	} else {
-		dma_sync_single_for_device(dev, req->dma, req->length, dir);
-		pkt->dma = req->dma;
-	}
-
-	if (dma_mapping_error(dev, pkt->dma)) {
-		dev_err(dev, "dma mapping error %llx\n", (u64)pkt->dma);
-		return -EIO;
-	}
-
-	return 0;
-}
-
-static int usbhsg_dma_unmap(struct device *dev,
-			    struct usbhs_pkt *pkt,
-			    enum dma_data_direction dir)
+static int usbhsg_dma_map_ctrl(struct usbhs_pkt *pkt, int map)
 {
 	struct usbhsg_request *ureq = usbhsg_pkt_to_ureq(pkt);
 	struct usb_request *req = &ureq->req;
-
-	if (pkt->dma == DMA_ADDR_INVALID) {
-		dev_err(dev, "dma is not mapped\n");
-		return -EIO;
-	}
-
-	if (req->dma == DMA_ADDR_INVALID)
-		dma_unmap_single(dev, pkt->dma, pkt->length, dir);
-	else
-		dma_sync_single_for_cpu(dev, req->dma, req->length, dir);
-
-	pkt->dma = DMA_ADDR_INVALID;
-
-	return 0;
-}
-
-static int usbhsg_dma_map_ctrl(struct usbhs_pkt *pkt, int map)
-{
 	struct usbhs_pipe *pipe = pkt->pipe;
 	struct usbhsg_uep *uep = usbhsg_pipe_to_uep(pipe);
 	struct usbhsg_gpriv *gpriv = usbhsg_uep_to_gpriv(uep);
-	struct device *dev = usbhsg_gpriv_to_dev(gpriv);
 	enum dma_data_direction dir;
 
 	dir = usbhs_pipe_is_dir_in(pipe) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 
-	if (map)
-		return usbhsg_dma_map(dev, pkt, dir);
-	else
-		return usbhsg_dma_unmap(dev, pkt, dir);
+	if (map) {
+		return usb_gadget_map_request(&gpriv->gadget, req, dir);
+	} else {
+		usb_gadget_unmap_request(&gpriv->gadget, req, dir);
+		return 0;
+	}
 }
 
 /*
-- 
1.7.8.rc3

