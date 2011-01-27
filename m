Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1A0DHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 22:07:46 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19201 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab1A0DHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 22:07:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Wed, 26 Jan 2011 19:07:15 -0800
From: Robert Morell <rmorell@nvidia.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Oliver Neukum <oliver@neukum.org>
Cc: Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>,
        Colin Cross <ccross@android.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Robert Morell <rmorell@nvidia.com>
Subject: [PATCH 1/3] USB: HCD: Add usb_hcd prefix to exported functions
Date: Wed, 26 Jan 2011 19:06:47 -0800
Message-Id: <1296097609-32302-2-git-send-email-rmorell@nvidia.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295559715-14264-1-git-send-email-rmorell@nvidia.com>
References: <1295559715-14264-1-git-send-email-rmorell@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The convention is to prefix symbols exported from the USB HCD core with
"usb_hcd".  This change makes unmap_urb_setup_for_dma() and
unmap_urb_for_dma() consistent with that.

Signed-off-by: Robert Morell <rmorell@nvidia.com>
---
 drivers/usb/core/hcd.c       |   16 ++++++++--------
 drivers/usb/host/imx21-hcd.c |    5 +++--
 drivers/usb/musb/musb_host.c |    4 ++--
 include/linux/usb/hcd.h      |    4 ++--
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index ced846a..cd7150a 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1263,7 +1263,7 @@ static void hcd_free_coherent(struct usb_bus *bus, dma_addr_t *dma_handle,
 	*dma_handle = 0;
 }
 
-void unmap_urb_setup_for_dma(struct usb_hcd *hcd, struct urb *urb)
+void usb_hcd_unmap_urb_setup_for_dma(struct usb_hcd *hcd, struct urb *urb)
 {
 	if (urb->transfer_flags & URB_SETUP_MAP_SINGLE)
 		dma_unmap_single(hcd->self.controller,
@@ -1280,13 +1280,13 @@ void unmap_urb_setup_for_dma(struct usb_hcd *hcd, struct urb *urb)
 	/* Make it safe to call this routine more than once */
 	urb->transfer_flags &= ~(URB_SETUP_MAP_SINGLE | URB_SETUP_MAP_LOCAL);
 }
-EXPORT_SYMBOL_GPL(unmap_urb_setup_for_dma);
+EXPORT_SYMBOL_GPL(usb_hcd_unmap_urb_setup_for_dma);
 
-void unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
+void usb_hcd_unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
 {
 	enum dma_data_direction dir;
 
-	unmap_urb_setup_for_dma(hcd, urb);
+	usb_hcd_unmap_urb_setup_for_dma(hcd, urb);
 
 	dir = usb_urb_dir_in(urb) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 	if (urb->transfer_flags & URB_DMA_MAP_SG)
@@ -1315,7 +1315,7 @@ void unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
 	urb->transfer_flags &= ~(URB_DMA_MAP_SG | URB_DMA_MAP_PAGE |
 			URB_DMA_MAP_SINGLE | URB_MAP_LOCAL);
 }
-EXPORT_SYMBOL_GPL(unmap_urb_for_dma);
+EXPORT_SYMBOL_GPL(usb_hcd_unmap_urb_for_dma);
 
 static int map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 			   gfp_t mem_flags)
@@ -1411,7 +1411,7 @@ static int map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 		}
 		if (ret && (urb->transfer_flags & (URB_SETUP_MAP_SINGLE |
 				URB_SETUP_MAP_LOCAL)))
-			unmap_urb_for_dma(hcd, urb);
+			usb_hcd_unmap_urb_for_dma(hcd, urb);
 	}
 	return ret;
 }
@@ -1452,7 +1452,7 @@ int usb_hcd_submit_urb (struct urb *urb, gfp_t mem_flags)
 		if (likely(status == 0)) {
 			status = hcd->driver->urb_enqueue(hcd, urb, mem_flags);
 			if (unlikely(status))
-				unmap_urb_for_dma(hcd, urb);
+				usb_hcd_unmap_urb_for_dma(hcd, urb);
 		}
 	}
 
@@ -1558,7 +1558,7 @@ void usb_hcd_giveback_urb(struct usb_hcd *hcd, struct urb *urb, int status)
 			!status))
 		status = -EREMOTEIO;
 
-	unmap_urb_for_dma(hcd, urb);
+	usb_hcd_unmap_urb_for_dma(hcd, urb);
 	usbmon_urb_complete(&hcd->self, urb, status);
 	usb_unanchor_urb(urb);
 
diff --git a/drivers/usb/host/imx21-hcd.c b/drivers/usb/host/imx21-hcd.c
index e49b75a..f8ba23c 100644
--- a/drivers/usb/host/imx21-hcd.c
+++ b/drivers/usb/host/imx21-hcd.c
@@ -927,7 +927,8 @@ static void schedule_nonisoc_etd(struct imx21 *imx21, struct urb *urb)
 		if (state == US_CTRL_SETUP) {
 			dir = TD_DIR_SETUP;
 			if (unsuitable_for_dma(urb->setup_dma))
-				unmap_urb_setup_for_dma(imx21->hcd, urb);
+				usb_hcd_unmap_urb_setup_for_dma(imx21->hcd,
+					urb);
 			etd->dma_handle = urb->setup_dma;
 			etd->cpu_buffer = urb->setup_packet;
 			bufround = 0;
@@ -943,7 +944,7 @@ static void schedule_nonisoc_etd(struct imx21 *imx21, struct urb *urb)
 		dir = usb_pipeout(pipe) ? TD_DIR_OUT : TD_DIR_IN;
 		bufround = (dir == TD_DIR_IN) ? 1 : 0;
 		if (unsuitable_for_dma(urb->transfer_dma))
-			unmap_urb_for_dma(imx21->hcd, urb);
+			usb_hcd_unmap_urb_for_dma(imx21->hcd, urb);
 
 		etd->dma_handle = urb->transfer_dma;
 		etd->cpu_buffer = urb->transfer_buffer;
diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 4d5bcb4..4d2f3f7 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -1336,7 +1336,7 @@ void musb_host_tx(struct musb *musb, u8 epnum)
 	if (length > qh->maxpacket)
 		length = qh->maxpacket;
 	/* Unmap the buffer so that CPU can use it */
-	unmap_urb_for_dma(musb_to_hcd(musb), urb);
+	usb_hcd_unmap_urb_for_dma(musb_to_hcd(musb), urb);
 	musb_write_fifo(hw_ep, length, urb->transfer_buffer + offset);
 	qh->segsize = length;
 
@@ -1758,7 +1758,7 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 
 		if (!dma) {
 			/* Unmap the buffer so that CPU can use it */
-			unmap_urb_for_dma(musb_to_hcd(musb), urb);
+			usb_hcd_unmap_urb_for_dma(musb_to_hcd(musb), urb);
 			done = musb_host_packet_rx(musb, urb,
 					epnum, iso_err);
 			DBG(6, "read %spacket\n", done ? "last " : "");
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 0b6e751..5cee57f 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -329,8 +329,8 @@ extern int usb_hcd_submit_urb(struct urb *urb, gfp_t mem_flags);
 extern int usb_hcd_unlink_urb(struct urb *urb, int status);
 extern void usb_hcd_giveback_urb(struct usb_hcd *hcd, struct urb *urb,
 		int status);
-extern void unmap_urb_setup_for_dma(struct usb_hcd *, struct urb *);
-extern void unmap_urb_for_dma(struct usb_hcd *, struct urb *);
+extern void usb_hcd_unmap_urb_setup_for_dma(struct usb_hcd *, struct urb *);
+extern void usb_hcd_unmap_urb_for_dma(struct usb_hcd *, struct urb *);
 extern void usb_hcd_flush_endpoint(struct usb_device *udev,
 		struct usb_host_endpoint *ep);
 extern void usb_hcd_disable_endpoint(struct usb_device *udev,
-- 
1.7.3.4

