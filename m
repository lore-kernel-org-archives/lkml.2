Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2AXLrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:47:16 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:50022 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238Ab2AXLrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:47:13 -0500
MIME-Version: 1.0
From: Felipe Balbi <balbi@ti.com>
To: Linux USB Mailing List <linux-usb@vger.kernel.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM 
	,commit_signer:27/51=53%),
        Thomas Dahlmann <dahlmann.thomas@arcor.de> (supporter:AMD GEODE
	CS5536...),
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> (commit_signer:44/51=86%),
        linux-omap@vger.kernel.org (open list:DESIGNWARE USB3 D...),
        linux-kernel@vger.kernel.org (open list),
        linux-geode@lists.infradead.org (open list:AMD GEODE CS5536...)
Subject: [PATCH 1/9] usb: gadget: add generic map/unmap request utilities
Date: Tue, 24 Jan 2012 13:45:22 +0200
Message-Id: <1327405543-27589-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.2
In-Reply-To: <1327405543-27589-1-git-send-email-balbi@ti.com>
References: <1327405543-27589-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

such utilities are currently duplicated on all UDC
drivers basically with the same structure. Let's group
all implementations into one generic implementation
and get rid of that duplication.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/gadget/udc-core.c |   52 +++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/gadget.h    |   10 ++++++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
index 0b0d12c..56da49f 100644
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -22,6 +22,7 @@
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/err.h>
+#include <linux/dma-mapping.h>
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
@@ -49,6 +50,57 @@ static DEFINE_MUTEX(udc_lock);
 
 /* ------------------------------------------------------------------------- */
 
+int usb_gadget_map_request(struct usb_gadget *gadget,
+		struct usb_request *req, int is_in)
+{
+	if (req->length == 0)
+		return 0;
+
+	if (req->num_sgs) {
+		int     mapped;
+
+		mapped = dma_map_sg(&gadget->dev, req->sg, req->num_sgs,
+				is_in ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+		if (mapped == 0) {
+			dev_err(&gadget->dev, "failed to map SGs\n");
+			return -EFAULT;
+		}
+
+		req->num_mapped_sgs = mapped;
+	} else {
+		req->dma = dma_map_single(&gadget->dev, req->buf, req->length,
+				is_in ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+
+		if (dma_mapping_error(&gadget->dev, req->dma)) {
+			dev_err(&gadget->dev, "failed to map buffer\n");
+			return -EFAULT;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(usb_gadget_map_request);
+
+void usb_gadget_unmap_request(struct usb_gadget *gadget,
+		struct usb_request *req, int is_in)
+{
+	if (req->length == 0)
+		return;
+
+	if (req->num_mapped_sgs) {
+		dma_unmap_sg(&gadget->dev, req->sg, req->num_mapped_sgs,
+				is_in ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+
+		req->num_mapped_sgs = 0;
+	} else {
+		dma_unmap_single(&gadget->dev, req->dma, req->length,
+				is_in ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+	}
+}
+EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
+
+/* ------------------------------------------------------------------------- */
+
 /**
  * usb_gadget_start - tells usb device controller to start up
  * @gadget: The gadget we want to get started
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index da653b5..9517466 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -950,6 +950,16 @@ static inline void usb_free_descriptors(struct usb_descriptor_header **v)
 
 /*-------------------------------------------------------------------------*/
 
+/* utility to simplify map/unmap of usb_requests to/from DMA */
+
+extern int usb_gadget_map_request(struct usb_gadget *gadget,
+		struct usb_request *req, int is_in);
+
+extern void usb_gadget_unmap_request(struct usb_gadget *gadget,
+		struct usb_request *req, int is_in);
+
+/*-------------------------------------------------------------------------*/
+
 /* utility wrapping a simple endpoint selection policy */
 
 extern struct usb_ep *usb_ep_autoconfig(struct usb_gadget *,
-- 
1.7.8.2

