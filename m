Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab0LQWBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 17:01:24 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8247 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab0LQWBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 17:01:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Fri, 17 Dec 2010 13:59:06 -0800
From: Robert Morell <rmorell@nvidia.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>
Cc: Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>,
        Colin Cross <ccross@android.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Morell <rmorell@nvidia.com>
Subject: [PATCH 1/2] USB: Add driver hooks for (un)?map_urb_for_dma
Date: Fri, 17 Dec 2010 13:58:48 -0800
Message-Id: <1292623129-26361-2-git-send-email-rmorell@nvidia.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1292623129-26361-1-git-send-email-rmorell@nvidia.com>
References: <1292623129-26361-1-git-send-email-rmorell@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are useful in case your device has quirks involving what memory
is and is not DMAable.

Signed-off-by: Robert Morell <rmorell@nvidia.com>
Reviewed-by: Scott Williams <scwilliams@nvidia.com>
Reviewed-by: Janne Hellsten <jhellsten@nvidia.com>
---
 drivers/usb/core/hcd.c  |   19 ++++++++++++++++++-
 include/linux/usb/hcd.h |    8 ++++++++
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 5cca00a..84fee0f 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1265,6 +1265,14 @@ static void hcd_free_coherent(struct usb_bus *bus, dma_addr_t *dma_handle,
 
 static void unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
 {
+	if (hcd->driver->unmap_urb_for_dma)
+		hcd->driver->unmap_urb_for_dma(hcd, urb);
+	else
+		usb_hcd_unmap_urb_for_dma(hcd, urb);
+}
+
+void usb_hcd_unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
+{
 	enum dma_data_direction dir;
 
 	if (urb->transfer_flags & URB_SETUP_MAP_SINGLE)
@@ -1311,6 +1319,15 @@ static void unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
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
 
@@ -1400,7 +1417,7 @@ static int map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 		}
 		if (ret && (urb->transfer_flags & (URB_SETUP_MAP_SINGLE |
 				URB_SETUP_MAP_LOCAL)))
-			unmap_urb_for_dma(hcd, urb);
+			usb_hcd_unmap_urb_for_dma(hcd, urb);
 	}
 	return ret;
 }
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 3b571f1..8aaf687 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -233,6 +233,11 @@ struct hc_driver {
 	int	(*urb_dequeue)(struct usb_hcd *hcd,
 				struct urb *urb, int status);
 
+	/* dma support */
+	int	(*map_urb_for_dma)(struct usb_hcd *hcd, struct urb *urb,
+				   gfp_t mem_flags);
+	void    (*unmap_urb_for_dma)(struct usb_hcd *hcd, struct urb *urb);
+
 	/* hw synch, freeing endpoint resources that urb_dequeue can't */
 	void	(*endpoint_disable)(struct usb_hcd *hcd,
 			struct usb_host_endpoint *ep);
@@ -327,6 +332,9 @@ extern void usb_hcd_unlink_urb_from_ep(struct usb_hcd *hcd, struct urb *urb);
 
 extern int usb_hcd_submit_urb(struct urb *urb, gfp_t mem_flags);
 extern int usb_hcd_unlink_urb(struct urb *urb, int status);
+extern int usb_hcd_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
+		gfp_t mem_flags);
+extern void usb_hcd_unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb);
 extern void usb_hcd_giveback_urb(struct usb_hcd *hcd, struct urb *urb,
 		int status);
 extern void usb_hcd_flush_endpoint(struct usb_device *udev,
-- 
1.7.2.2

