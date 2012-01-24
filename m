Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab2AXLrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:47:42 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:41081 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754983Ab2AXLrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:47:37 -0500
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
Subject: [PATCH 4/9] usb: renesas: gadget: use generic map/unmap routines
Date: Tue, 24 Jan 2012 13:45:25 +0200
Message-Id: <1327405543-27589-5-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.2
In-Reply-To: <1327405543-27589-1-git-send-email-balbi@ti.com>
References: <1327405543-27589-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

those routines have everything we need to map/unmap
USB requests and it's better to use them.

Tested-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/renesas_usbhs/mod_gadget.c |   73 +++++++------------------------
 1 files changed, 17 insertions(+), 56 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
index 528691d5f..5339741 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -165,69 +165,32 @@ static void usbhsg_queue_push(struct usbhsg_uep *uep,
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
+	int ret = 0;
 
-	dir = usbhs_pipe_is_dir_in(pipe) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	dir = usbhs_pipe_is_dir_host(pipe);
 
-	if (map)
-		return usbhsg_dma_map(dev, pkt, dir);
-	else
-		return usbhsg_dma_unmap(dev, pkt, dir);
+	if (map) {
+		/* it can not use scatter/gather */
+		WARN_ON(req->num_sgs);
+
+		ret = usb_gadget_map_request(&gpriv->gadget, req, dir);
+		if (ret < 0)
+			return ret;
+
+		pkt->dma = req->dma;
+	} else {
+		usb_gadget_unmap_request(&gpriv->gadget, req, dir);
+	}
+
+	return ret;
 }
 
 /*
@@ -657,8 +620,6 @@ static struct usb_request *usbhsg_ep_alloc_request(struct usb_ep *ep,
 
 	usbhs_pkt_init(usbhsg_ureq_to_pkt(ureq));
 
-	ureq->req.dma = DMA_ADDR_INVALID;
-
 	return &ureq->req;
 }
 
-- 
1.7.8.2

