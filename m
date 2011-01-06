Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1AFXYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:24:22 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16034 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1AFXYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:24:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 06 Jan 2011 15:13:53 -0800
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
Subject: [PATCH v4 2/2] USB: ehci: tegra: Align DMA transfers to 32 bytes
Date: Thu,  6 Jan 2011 15:20:45 -0800
Message-Id: <1294356045-1018-3-git-send-email-rmorell@nvidia.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1292794698-19534-1-git-send-email-rmorell@nvidia.com>
References: <1292794698-19534-1-git-send-email-rmorell@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra2 USB controller doesn't properly deal with misaligned DMA
buffers, causing corruption.  This is especially prevalent with USB
network adapters, where skbuff alignment is often in the middle of a
4-byte dword.

To avoid this, allocate a temporary buffer for the DMA if the provided
buffer isn't sufficiently aligned.

Signed-off-by: Robert Morell <rmorell@nvidia.com>
---
 drivers/usb/host/ehci-tegra.c |   92 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 92 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 21c58df..4aa484b 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -32,6 +32,8 @@
 #define TEGRA_USB_USBMODE_HOST			(3 << 0)
 #define TEGRA_USB_PORTSC1_PTC(x)		(((x) & 0xf) << 16)
 
+#define TEGRA_USB_DMA_ALIGN 32
+
 struct tegra_ehci_context {
 	bool valid;
 	u32 command;
@@ -456,6 +458,94 @@ static int tegra_ehci_bus_resume(struct usb_hcd *hcd)
 }
 #endif
 
+struct temp_buffer {
+	void *kmalloc_ptr;
+	void *old_xfer_buffer;
+	u8 data[0];
+};
+
+static void free_temp_buffer(struct urb *urb, int status)
+{
+	enum dma_data_direction dir;
+	struct temp_buffer *temp;
+
+	if (!(urb->transfer_flags & URB_ALIGNED_TEMP_BUFFER))
+		return;
+
+	dir = usb_urb_dir_in(urb) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+
+	temp = container_of(urb->transfer_buffer, struct temp_buffer,
+			    data);
+
+	if (dir == DMA_FROM_DEVICE && !status)
+		memcpy(temp->old_xfer_buffer, temp->data,
+		       urb->transfer_buffer_length);
+	urb->transfer_buffer = temp->old_xfer_buffer;
+	kfree(temp->kmalloc_ptr);
+
+	urb->transfer_flags &= ~URB_ALIGNED_TEMP_BUFFER;
+}
+
+static int alloc_temp_buffer(struct urb *urb, gfp_t mem_flags)
+{
+	enum dma_data_direction dir;
+	struct temp_buffer *temp, *kmalloc_ptr;
+	size_t kmalloc_size;
+	void *data;
+
+	if (urb->num_sgs || urb->sg ||
+	    urb->transfer_buffer_length == 0 ||
+	    !((uintptr_t)urb->transfer_buffer & (TEGRA_USB_DMA_ALIGN - 1)))
+		return 0;
+
+	dir = usb_urb_dir_in(urb) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+
+	/* Allocate a buffer with enough padding for alignment */
+	kmalloc_size = urb->transfer_buffer_length +
+		sizeof(struct temp_buffer) + TEGRA_USB_DMA_ALIGN - 1;
+
+	kmalloc_ptr = kmalloc(kmalloc_size, mem_flags);
+	if (!kmalloc_ptr)
+		return -ENOMEM;
+
+	/* Position our struct temp_buffer such that data is aligned */
+	temp = PTR_ALIGN(kmalloc_ptr + 1, TEGRA_USB_DMA_ALIGN) - 1;
+
+	temp->kmalloc_ptr = kmalloc_ptr;
+	temp->old_xfer_buffer = urb->transfer_buffer;
+	if (dir == DMA_TO_DEVICE)
+		memcpy(temp->data, urb->transfer_buffer,
+		       urb->transfer_buffer_length);
+	urb->transfer_buffer = temp->data;
+
+	urb->transfer_flags |= URB_ALIGNED_TEMP_BUFFER;
+
+	return 0;
+}
+
+static int tegra_ehci_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
+				      gfp_t mem_flags)
+{
+	int ret;
+
+	ret = alloc_temp_buffer(urb, mem_flags);
+	if (ret)
+		return ret;
+
+	ret = usb_hcd_map_urb_for_dma(hcd, urb, mem_flags);
+	if (ret)
+		free_temp_buffer(urb, ret);
+
+	return ret;
+}
+
+static void tegra_ehci_unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
+					 int status)
+{
+	usb_hcd_unmap_urb_for_dma(hcd, urb);
+	free_temp_buffer(urb, status);
+}
+
 static const struct hc_driver tegra_ehci_hc_driver = {
 	.description		= hcd_name,
 	.product_desc		= "Tegra EHCI Host Controller",
@@ -471,6 +561,8 @@ static const struct hc_driver tegra_ehci_hc_driver = {
 	.shutdown		= tegra_ehci_shutdown,
 	.urb_enqueue		= ehci_urb_enqueue,
 	.urb_dequeue		= ehci_urb_dequeue,
+	.map_urb_for_dma	= tegra_ehci_map_urb_for_dma,
+	.unmap_urb_for_dma	= tegra_ehci_unmap_urb_for_dma,
 	.endpoint_disable	= ehci_endpoint_disable,
 	.endpoint_reset		= ehci_endpoint_reset,
 	.get_frame_number	= ehci_get_frame,
-- 
1.7.2.2

