Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab1A0DHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 22:07:47 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19202 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab1A0DHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 22:07:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Wed, 26 Jan 2011 19:07:15 -0800
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
Subject: [PATCH 2/3] USB: HCD: Add driver hooks for (un)?map_urb_for_dma
Date: Wed, 26 Jan 2011 19:06:48 -0800
Message-Id: <1296097609-32302-3-git-send-email-rmorell@nvidia.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295559715-14264-1-git-send-email-rmorell@nvidia.com>
References: <1295559715-14264-1-git-send-email-rmorell@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide optional hooks for the host controller driver to override the
default DMA mapping and unmapping routines.  In general, these shouldn't
be necessary unless the host controller has special DMA requirements,
such as alignment contraints.  If these are not specified, the
general usb_hcd_(un)?map_urb_for_dma functions will be used instead.
Also, pass the status to unmap_urb_for_dma so it can know whether the
DMA buffer has been overwritten.

Finally, add a flag to be used by these implementations if they
allocated a temporary buffer so it can be freed properly when unmapping.

Signed-off-by: Robert Morell <rmorell@nvidia.com>
---
 drivers/usb/core/hcd.c  |   22 ++++++++++++++++++++--
 include/linux/usb.h     |    1 +
 include/linux/usb/hcd.h |   15 +++++++++++++++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index cd7150a..6ed174b 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1282,6 +1282,14 @@ void usb_hcd_unmap_urb_setup_for_dma(struct usb_hcd *hcd, struct urb *urb)
 }
 EXPORT_SYMBOL_GPL(usb_hcd_unmap_urb_setup_for_dma);
 
+static void unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
+{
+	if (hcd->driver->unmap_urb_for_dma)
+		hcd->driver->unmap_urb_for_dma(hcd, urb);
+	else
+		usb_hcd_unmap_urb_for_dma(hcd, urb);
+}
+
 void usb_hcd_unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
 {
 	enum dma_data_direction dir;
@@ -1320,6 +1328,15 @@ EXPORT_SYMBOL_GPL(usb_hcd_unmap_urb_for_dma);
 static int map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 			   gfp_t mem_flags)
 {
+	if (hcd->driver->map_urb_for_dma)
+		return hcd->driver->map_urb_for_dma(hcd, urb, mem_flags);
+	else
+		return usb_hcd_map_urb_for_dma(hcd, urb, mem_flags);
+}
+
+int usb_hcd_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
+			    gfp_t mem_flags)
+{
 	enum dma_data_direction dir;
 	int ret = 0;
 
@@ -1415,6 +1432,7 @@ static int map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(usb_hcd_map_urb_for_dma);
 
 /*-------------------------------------------------------------------------*/
 
@@ -1452,7 +1470,7 @@ int usb_hcd_submit_urb (struct urb *urb, gfp_t mem_flags)
 		if (likely(status == 0)) {
 			status = hcd->driver->urb_enqueue(hcd, urb, mem_flags);
 			if (unlikely(status))
-				usb_hcd_unmap_urb_for_dma(hcd, urb);
+				unmap_urb_for_dma(hcd, urb);
 		}
 	}
 
@@ -1558,7 +1576,7 @@ void usb_hcd_giveback_urb(struct usb_hcd *hcd, struct urb *urb, int status)
 			!status))
 		status = -EREMOTEIO;
 
-	usb_hcd_unmap_urb_for_dma(hcd, urb);
+	unmap_urb_for_dma(hcd, urb);
 	usbmon_urb_complete(&hcd->self, urb, status);
 	usb_unanchor_urb(urb);
 
diff --git a/include/linux/usb.h b/include/linux/usb.h
index a28eb25..7a957f2 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -979,6 +979,7 @@ extern int usb_disabled(void);
 #define URB_SETUP_MAP_SINGLE	0x00100000	/* Setup packet DMA mapped */
 #define URB_SETUP_MAP_LOCAL	0x00200000	/* HCD-local setup packet */
 #define URB_DMA_SG_COMBINED	0x00400000	/* S-G entries were combined */
+#define URB_ALIGNED_TEMP_BUFFER	0x00800000	/* Temp buffer was alloc'd */
 
 struct usb_iso_packet_descriptor {
 	unsigned int offset;
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 5cee57f..d825816 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -233,6 +233,19 @@ struct hc_driver {
 	int	(*urb_dequeue)(struct usb_hcd *hcd,
 				struct urb *urb, int status);
 
+	/*
+	 * (optional) these hooks allow an HCD to override the default DMA
+	 * mapping and unmapping routines.  In general, they shouldn't be
+	 * necessary unless the host controller has special DMA requirements,
+	 * such as alignment contraints.  If these are not specified, the
+	 * general usb_hcd_(un)?map_urb_for_dma functions will be used instead
+	 * (and it may be a good idea to call these functions in your HCD
+	 * implementation)
+	 */
+	int	(*map_urb_for_dma)(struct usb_hcd *hcd, struct urb *urb,
+				   gfp_t mem_flags);
+	void    (*unmap_urb_for_dma)(struct usb_hcd *hcd, struct urb *urb);
+
 	/* hw synch, freeing endpoint resources that urb_dequeue can't */
 	void	(*endpoint_disable)(struct usb_hcd *hcd,
 			struct usb_host_endpoint *ep);
@@ -329,6 +342,8 @@ extern int usb_hcd_submit_urb(struct urb *urb, gfp_t mem_flags);
 extern int usb_hcd_unlink_urb(struct urb *urb, int status);
 extern void usb_hcd_giveback_urb(struct usb_hcd *hcd, struct urb *urb,
 		int status);
+extern int usb_hcd_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
+		gfp_t mem_flags);
 extern void usb_hcd_unmap_urb_setup_for_dma(struct usb_hcd *, struct urb *);
 extern void usb_hcd_unmap_urb_for_dma(struct usb_hcd *, struct urb *);
 extern void usb_hcd_flush_endpoint(struct usb_device *udev,
-- 
1.7.3.4

