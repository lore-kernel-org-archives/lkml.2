Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2HBGhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:37:13 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:52860 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753082Ab2HBGhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:37:11 -0400
From: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <praveen.nadahally@stericsson.com>
Subject: [PATCH] usb:musb:musb_host: Handle highmem in PIO mode
Date: Thu, 2 Aug 2012 12:06:42 +0530
Message-ID: <1343889402-7826-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
X-Mailer: git-send-email 1.7.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of USB bulk transfer, when himem page
is received, the usb_sg_init function sets the
urb transfer buffer to NULL. When such URB
transfer is handled, kernel crashes in PIO mode.
Handle this by mapping the highmem buffer in PIO mode.

Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
---
 drivers/usb/musb/musb_host.c |   98 +++++++++++++++++++++++++++++++++++++++--
 include/linux/usb.h          |    2 +
 2 files changed, 95 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 4bb717d..ff1af0a 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -813,9 +813,28 @@ static void musb_ep_program(struct musb *musb, u8 epnum,
 		if (load_count) {
 			/* PIO to load FIFO */
 			qh->segsize = load_count;
-			musb_write_fifo(hw_ep, load_count, buf);
+			if (!buf) {
+				sg_miter_start(&urb->sg_miter, urb->sg, 1,
+						SG_MITER_ATOMIC
+						| SG_MITER_FROM_SG);
+				if (!sg_miter_next(&urb->sg_miter)) {
+					dev_err(musb->controller,
+							"error: sg"
+							"list empty\n");
+					sg_miter_stop(&urb->sg_miter);
+					goto finish;
+				}
+				buf = urb->sg_miter.addr + urb->sg->offset +
+					urb->actual_length;
+				load_count = min_t(u32, load_count,
+						urb->sg_miter.length);
+				musb_write_fifo(hw_ep, load_count, buf);
+				urb->sg_miter.consumed = load_count;
+				sg_miter_stop(&urb->sg_miter);
+			} else
+				musb_write_fifo(hw_ep, load_count, buf);
 		}
-
+finish:
 		/* re-enable interrupt */
 		musb_writew(mbase, MUSB_INTRTXE, int_txe);
 
@@ -1116,6 +1135,7 @@ void musb_host_tx(struct musb *musb, u8 epnum)
 	void __iomem		*mbase = musb->mregs;
 	struct dma_channel	*dma;
 	bool			transfer_pending = false;
+	static bool use_sg;
 
 	musb_ep_select(mbase, epnum);
 	tx_csr = musb_readw(epio, MUSB_TXCSR);
@@ -1163,6 +1183,7 @@ void musb_host_tx(struct musb *musb, u8 epnum)
 		return;
 	}
 
+done:
 	if (status) {
 		if (dma_channel_status(dma) == MUSB_DMA_STATUS_BUSY) {
 			dma->status = MUSB_DMA_STATUS_CORE_ABORT;
@@ -1332,9 +1353,38 @@ void musb_host_tx(struct musb *musb, u8 epnum)
 		length = qh->maxpacket;
 	/* Unmap the buffer so that CPU can use it */
 	usb_hcd_unmap_urb_for_dma(musb_to_hcd(musb), urb);
-	musb_write_fifo(hw_ep, length, urb->transfer_buffer + offset);
+
+	/*
+	 * We need to map sg if the transfer_buffer is
+	 * NULL.
+	 */
+	if (!urb->transfer_buffer)
+		use_sg = true;
+
+	if (use_sg) {
+		/* sg_miter_start is already done in musb_ep_program */
+		if (!sg_miter_next(&urb->sg_miter)) {
+			dev_err(musb->controller, "error: sg list empty\n");
+			sg_miter_stop(&urb->sg_miter);
+			status = -EINVAL;
+			goto done;
+		}
+		urb->transfer_buffer = urb->sg_miter.addr;
+		length = min_t(u32, length, urb->sg_miter.length);
+		musb_write_fifo(hw_ep, length, urb->transfer_buffer);
+		urb->sg_miter.consumed = length;
+		sg_miter_stop(&urb->sg_miter);
+	} else {
+		musb_write_fifo(hw_ep, length, urb->transfer_buffer + offset);
+	}
+
 	qh->segsize = length;
 
+	if (use_sg) {
+		if (offset + length >= urb->transfer_buffer_length)
+			use_sg = false;
+	}
+
 	musb_ep_select(mbase, epnum);
 	musb_writew(epio, MUSB_TXCSR,
 			MUSB_TXCSR_H_WZC_BITS | MUSB_TXCSR_TXPKTRDY);
@@ -1442,6 +1492,8 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 	bool			done = false;
 	u32			status;
 	struct dma_channel	*dma;
+	static bool use_sg;
+	unsigned int sg_flags = SG_MITER_ATOMIC | SG_MITER_TO_SG;
 
 	musb_ep_select(mbase, epnum);
 
@@ -1756,10 +1808,43 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 #endif	/* Mentor DMA */
 
 		if (!dma) {
+			unsigned int received_len;
+
 			/* Unmap the buffer so that CPU can use it */
 			usb_hcd_unmap_urb_for_dma(musb_to_hcd(musb), urb);
-			done = musb_host_packet_rx(musb, urb,
-					epnum, iso_err);
+
+			/*
+			 * We need to map sg if the transfer_buffer is
+			 * NULL.
+			 */
+			if (!urb->transfer_buffer) {
+				use_sg = true;
+				sg_miter_start(&urb->sg_miter, urb->sg, 1,
+						sg_flags);
+			}
+
+			if (use_sg) {
+				if (!sg_miter_next(&urb->sg_miter)) {
+					dev_err(musb->controller, "error: sg list empty\n");
+					sg_miter_stop(&urb->sg_miter);
+					status = -EINVAL;
+					done = true;
+					goto finish;
+				}
+				urb->transfer_buffer = urb->sg_miter.addr;
+				received_len = urb->actual_length;
+				qh->offset = 0x0;
+				done = musb_host_packet_rx(musb, urb, epnum,
+						iso_err);
+				/* Calculate the number of bytes received */
+				received_len = urb->actual_length -
+					received_len;
+				urb->sg_miter.consumed = received_len;
+				sg_miter_stop(&urb->sg_miter);
+			} else {
+				done = musb_host_packet_rx(musb, urb,
+						epnum, iso_err);
+			}
 			dev_dbg(musb->controller, "read %spacket\n", done ? "last " : "");
 		}
 	}
@@ -1768,6 +1853,9 @@ finish:
 	urb->actual_length += xfer_len;
 	qh->offset += xfer_len;
 	if (done) {
+		if (use_sg)
+			use_sg = false;
+
 		if (urb->status == -EINPROGRESS)
 			urb->status = status;
 		musb_advance_schedule(musb, urb, hw_ep, USB_DIR_IN);
diff --git a/include/linux/usb.h b/include/linux/usb.h
index dea39dc..348648a 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -21,6 +21,7 @@
 #include <linux/sched.h>	/* for current && schedule_timeout */
 #include <linux/mutex.h>	/* for struct mutex */
 #include <linux/pm_runtime.h>	/* for runtime PM */
+#include <linux/scatterlist.h>
 
 struct usb_device;
 struct usb_driver;
@@ -1309,6 +1310,7 @@ struct urb {
 	usb_complete_t complete;	/* (in) completion routine */
 	struct usb_iso_packet_descriptor iso_frame_desc[0];
 					/* (in) ISO ONLY */
+	struct sg_mapping_iter sg_miter; /* handling highmem data in PIO mode */
 };
 
 /* ----------------------------------------------------------------------- */
-- 
1.7.4.3

