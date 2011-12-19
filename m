Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab1LSKbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 05:31:07 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:41494 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296Ab1LSKbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 05:31:05 -0500
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
Subject: [PATCH 1/9] usb: gadget: add generic map/unmap request utilities
Date: Mon, 19 Dec 2011 12:30:23 +0200
Message-Id: <1324290632-23758-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.rc3
In-Reply-To: <1324290632-23758-1-git-send-email-balbi@ti.com>
References: <1324290632-23758-1-git-send-email-balbi@ti.com>
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
 drivers/usb/gadget/udc-core.c |   53 +++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/gadget.h    |   10 +++++++
 2 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
index 0b0d12c..2031c11 100644
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -22,6 +22,7 @@
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/err.h>
+#include <linux/dma-mapping.h>
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
@@ -49,6 +50,58 @@ static DEFINE_MUTEX(udc_lock);
 
 /* ------------------------------------------------------------------------- */
 
+int usb_gadget_map_request(struct usb_gadget *gadget,
+		struct usb_request *req, int direction)
+{
+	if (req->length == 0)
+		return 0;
+
+	if (req->num_sgs) {
+		int     mapped;
+
+		mapped = dma_map_sg(&gadget->dev, req->sg, req->num_sgs,
+				direction ? DMA_TO_DEVICE
+				: DMA_FROM_DEVICE);
+		if (mapped == 0) {
+			dev_err(&gadget->dev, "failed to map SGs\n");
+			return -EFAULT;
+		}
+
+		req->num_mapped_sgs = mapped;
+	} else {
+		req->dma = dma_map_single(&gadget->dev, req->buf, req->length,
+				direction ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
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
+		struct usb_request *req, int direction)
+{
+	if (req->length == 0)
+		return;
+
+	if (req->num_mapped_sgs) {
+		dma_unmap_sg(&gadget->dev, req->sg, req->num_sgs,
+				direction ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+
+		req->num_mapped_sgs = 0;
+	} else {
+		dma_unmap_single(&gadget->dev, req->dma, req->length,
+				direction ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
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
index 911d4c7..9f84fdf 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -950,6 +950,16 @@ static inline void usb_free_descriptors(struct usb_descriptor_header **v)
 
 /*-------------------------------------------------------------------------*/
 
+/* utility to simplify map/unmap of usb_requests to/from DMA */
+
+extern int usb_gadget_map_request(struct usb_gadget *gadget,
+		struct usb_request *req, int direction);
+
+extern void usb_gadget_unmap_request(struct usb_gadget *gadget,
+		struct usb_request *req, int direction);
+
+/*-------------------------------------------------------------------------*/
+
 /* utility wrapping a simple endpoint selection policy */
 
 extern struct usb_ep *usb_ep_autoconfig(struct usb_gadget *,
-- 
1.7.8.rc3

