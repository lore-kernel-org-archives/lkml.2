Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1ATVmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:42:42 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8362 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab1ATVmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:42:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Thu, 20 Jan 2011 13:42:15 -0800
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
Subject: [PATCH 1/2] USB: HCD: Add driver hooks for (un)?map_urb_for_dma
Date: Thu, 20 Jan 2011 13:41:54 -0800
Message-Id: <1295559715-14264-2-git-send-email-rmorell@nvidia.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294356045-1018-1-git-send-email-rmorell@nvidia.com>
References: <1294356045-1018-1-git-send-email-rmorell@nvidia.com>
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

The original patches renamed the exported symbols from
(un)?map_urb_setup_for_dma to usb_hcd_(un)?map_urb_setup_for_dma, and continued
to use the ones not prefixed by "usb_hcd" internally.  However, due to commit
1dae423dd9b which already exported unmap_urb_setup_for_dma as-is, I reworked
this to export both unchanged and switch to the hooked_ prefix internally.

 drivers/usb/core/hcd.c  |   29 ++++++++++++++++++++++++-----
 include/linux/usb.h     |    1 +
 include/linux/usb/hcd.h |   14 ++++++++++++++
 3 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index ced846a..6fe339d 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1282,6 +1282,15 @@ void unmap_urb_setup_for_dma(struct usb_hcd *hcd, struct urb *urb)
 }
 EXPORT_SYMBOL_GPL(unmap_urb_setup_for_dma);
 
+static void hooked_unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
+				     int status)
+{
+	if (hcd->driver->unmap_urb_for_dma)
+		hcd->driver->unmap_urb_for_dma(hcd, urb, status);
+	else
+		unmap_urb_for_dma(hcd, urb);
+}
+
 void unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
 {
 	enum dma_data_direction dir;
@@ -1317,8 +1326,17 @@ void unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
 }
 EXPORT_SYMBOL_GPL(unmap_urb_for_dma);
 
-static int map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
-			   gfp_t mem_flags)
+static int hooked_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
+				  gfp_t mem_flags)
+{
+	if (hcd->driver->map_urb_for_dma)
+		return hcd->driver->map_urb_for_dma(hcd, urb, mem_flags);
+	else
+		return map_urb_for_dma(hcd, urb, mem_flags);
+}
+
+int map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
+		    gfp_t mem_flags)
 {
 	enum dma_data_direction dir;
 	int ret = 0;
@@ -1415,6 +1433,7 @@ static int map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(map_urb_for_dma);
 
 /*-------------------------------------------------------------------------*/
 
@@ -1448,11 +1467,11 @@ int usb_hcd_submit_urb (struct urb *urb, gfp_t mem_flags)
 	if (is_root_hub(urb->dev)) {
 		status = rh_urb_enqueue(hcd, urb);
 	} else {
-		status = map_urb_for_dma(hcd, urb, mem_flags);
+		status = hooked_map_urb_for_dma(hcd, urb, mem_flags);
 		if (likely(status == 0)) {
 			status = hcd->driver->urb_enqueue(hcd, urb, mem_flags);
 			if (unlikely(status))
-				unmap_urb_for_dma(hcd, urb);
+				hooked_unmap_urb_for_dma(hcd, urb, status);
 		}
 	}
 
@@ -1558,7 +1577,7 @@ void usb_hcd_giveback_urb(struct usb_hcd *hcd, struct urb *urb, int status)
 			!status))
 		status = -EREMOTEIO;
 
-	unmap_urb_for_dma(hcd, urb);
+	hooked_unmap_urb_for_dma(hcd, urb, status);
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
index 0b6e751..dc487ff 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -233,6 +233,18 @@ struct hc_driver {
 	int	(*urb_dequeue)(struct usb_hcd *hcd,
 				struct urb *urb, int status);
 
+	/* (optional) these hooks allow an HCD to override the default DMA
+	 * mapping and unmapping routines.  In general, they shouldn't be
+	 * necessary unless the host controller has special DMA requirements,
+	 * such as alignment contraints.  If these are not specified, the
+         * general (un)?map_urb_for_dma functions will be used instead (and it
+         * may be a good idea to call these functions in your HCD
+         * implementation) */
+	int	(*map_urb_for_dma)(struct usb_hcd *hcd, struct urb *urb,
+				   gfp_t mem_flags);
+	void    (*unmap_urb_for_dma)(struct usb_hcd *hcd, struct urb *urb,
+				     int status);
+
 	/* hw synch, freeing endpoint resources that urb_dequeue can't */
 	void	(*endpoint_disable)(struct usb_hcd *hcd,
 			struct usb_host_endpoint *ep);
@@ -329,6 +341,8 @@ extern int usb_hcd_submit_urb(struct urb *urb, gfp_t mem_flags);
 extern int usb_hcd_unlink_urb(struct urb *urb, int status);
 extern void usb_hcd_giveback_urb(struct usb_hcd *hcd, struct urb *urb,
 		int status);
+extern int map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
+		gfp_t mem_flags);
 extern void unmap_urb_setup_for_dma(struct usb_hcd *, struct urb *);
 extern void unmap_urb_for_dma(struct usb_hcd *, struct urb *);
 extern void usb_hcd_flush_endpoint(struct usb_device *udev,
-- 
1.7.3.4

