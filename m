Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2DEF7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 01:59:33 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14959 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab2DEF7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 01:59:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 04 Apr 2012 22:57:36 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: stern@rowland.harvard.edu, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] usb: host: tegra: code clean up
Date: Thu,  5 Apr 2012 11:25:30 +0530
Message-Id: <1333605330-5629-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch:
	1. Renamed structure and function names to be more meaningful.
	2. Removed unnecessary local variables.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/usb/host/ehci-tegra.c |   35 ++++++++++++++---------------------
 1 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 96c942c..65f4283 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -462,26 +462,23 @@ static int tegra_ehci_bus_resume(struct usb_hcd *hcd)
 }
 #endif
 
-struct temp_buffer {
+struct dma_aligned_buffer {
 	void *kmalloc_ptr;
 	void *old_xfer_buffer;
 	u8 data[0];
 };
 
-static void free_temp_buffer(struct urb *urb)
+static void free_dma_aligned_buffer(struct urb *urb)
 {
-	enum dma_data_direction dir;
-	struct temp_buffer *temp;
+	struct dma_aligned_buffer *temp;
 
 	if (!(urb->transfer_flags & URB_ALIGNED_TEMP_BUFFER))
 		return;
 
-	dir = usb_urb_dir_in(urb) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	temp = container_of(urb->transfer_buffer,
+		struct dma_aligned_buffer, data);
 
-	temp = container_of(urb->transfer_buffer, struct temp_buffer,
-			    data);
-
-	if (dir == DMA_FROM_DEVICE)
+	if (usb_urb_dir_in(urb))
 		memcpy(temp->old_xfer_buffer, temp->data,
 		       urb->transfer_buffer_length);
 	urb->transfer_buffer = temp->old_xfer_buffer;
@@ -490,10 +487,9 @@ static void free_temp_buffer(struct urb *urb)
 	urb->transfer_flags &= ~URB_ALIGNED_TEMP_BUFFER;
 }
 
-static int alloc_temp_buffer(struct urb *urb, gfp_t mem_flags)
+static int alloc_dma_aligned_buffer(struct urb *urb, gfp_t mem_flags)
 {
-	enum dma_data_direction dir;
-	struct temp_buffer *temp, *kmalloc_ptr;
+	struct dma_aligned_buffer *temp, *kmalloc_ptr;
 	size_t kmalloc_size;
 
 	if (urb->num_sgs || urb->sg ||
@@ -501,22 +497,19 @@ static int alloc_temp_buffer(struct urb *urb, gfp_t mem_flags)
 	    !((uintptr_t)urb->transfer_buffer & (TEGRA_USB_DMA_ALIGN - 1)))
 		return 0;
 
-	dir = usb_urb_dir_in(urb) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-
 	/* Allocate a buffer with enough padding for alignment */
 	kmalloc_size = urb->transfer_buffer_length +
-		sizeof(struct temp_buffer) + TEGRA_USB_DMA_ALIGN - 1;
+		sizeof(struct dma_aligned_buffer) + TEGRA_USB_DMA_ALIGN - 1;
 
 	kmalloc_ptr = kmalloc(kmalloc_size, mem_flags);
 	if (!kmalloc_ptr)
 		return -ENOMEM;
 
-	/* Position our struct temp_buffer such that data is aligned */
+	/* Position our struct dma_aligned_buffer such that data is aligned */
 	temp = PTR_ALIGN(kmalloc_ptr + 1, TEGRA_USB_DMA_ALIGN) - 1;
-
 	temp->kmalloc_ptr = kmalloc_ptr;
 	temp->old_xfer_buffer = urb->transfer_buffer;
-	if (dir == DMA_TO_DEVICE)
+	if (usb_urb_dir_out(urb))
 		memcpy(temp->data, urb->transfer_buffer,
 		       urb->transfer_buffer_length);
 	urb->transfer_buffer = temp->data;
@@ -531,13 +524,13 @@ static int tegra_ehci_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 {
 	int ret;
 
-	ret = alloc_temp_buffer(urb, mem_flags);
+	ret = alloc_dma_aligned_buffer(urb, mem_flags);
 	if (ret)
 		return ret;
 
 	ret = usb_hcd_map_urb_for_dma(hcd, urb, mem_flags);
 	if (ret)
-		free_temp_buffer(urb);
+		free_dma_aligned_buffer(urb);
 
 	return ret;
 }
@@ -545,7 +538,7 @@ static int tegra_ehci_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 static void tegra_ehci_unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
 {
 	usb_hcd_unmap_urb_for_dma(hcd, urb);
-	free_temp_buffer(urb);
+	free_dma_aligned_buffer(urb);
 }
 
 static const struct hc_driver tegra_ehci_hc_driver = {
-- 
1.7.1.1

