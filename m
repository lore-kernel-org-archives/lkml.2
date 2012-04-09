Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab2DISvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:51:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55991 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2DISvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:51:31 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 9 Apr 2012 20:51:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: core: fix DMA mapping direction
Message-ID: <20120409205118.41f7c9d3@stein>
In-Reply-To: <20120409182623.2e3f5646@stein>
References: <20120409182623.2e3f5646@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seen with recent libdc1394:  If a client mmap()s the buffer of an
isochronous reception buffer with PROT_READ|PROT_WRITE instead of just
PROT_READ, firewire-core sets the wrong DMA mapping direction during
buffer initialization.

The fix is to split fw_iso_buffer_init() into allocation and DMA mapping
and to perform the latter after both buffer and DMA context were
allocated.  Buffer allocation and context allocation may happen in any
order, but we need the context type (reception or transmission) in order
to set the DMA direction of the buffer.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |   51 ++++++++++++++++++----
 drivers/firewire/core-iso.c  |   80 +++++++++++++++++++++++------------
 drivers/firewire/core.h      |    7 +++
 include/linux/firewire.h     |    1 +
 4 files changed, 100 insertions(+), 39 deletions(-)

--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -22,6 +22,7 @@
 #include <linux/compat.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/errno.h>
 #include <linux/firewire.h>
 #include <linux/firewire-cdev.h>
@@ -71,6 +72,7 @@ struct client {
 	u64 iso_closure;
 	struct fw_iso_buffer buffer;
 	unsigned long vm_start;
+	bool buffer_is_mapped;
 
 	struct list_head phy_receiver_link;
 	u64 phy_receiver_closure;
@@ -960,11 +962,20 @@ static void iso_mc_callback(struct fw_is
 		    sizeof(e->interrupt), NULL, 0);
 }
 
+static enum dma_data_direction iso_dma_direction(struct fw_iso_context *context)
+{
+		if (context->type == FW_ISO_CONTEXT_TRANSMIT)
+			return DMA_TO_DEVICE;
+		else
+			return DMA_FROM_DEVICE;
+}
+
 static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
 {
 	struct fw_cdev_create_iso_context *a = &arg->create_iso_context;
 	struct fw_iso_context *context;
 	fw_iso_callback_t cb;
+	int ret;
 
 	BUILD_BUG_ON(FW_CDEV_ISO_CONTEXT_TRANSMIT != FW_ISO_CONTEXT_TRANSMIT ||
 		     FW_CDEV_ISO_CONTEXT_RECEIVE  != FW_ISO_CONTEXT_RECEIVE  ||
@@ -1005,8 +1016,21 @@ static int ioctl_create_iso_context(stru
 	if (client->iso_context != NULL) {
 		spin_unlock_irq(&client->lock);
 		fw_iso_context_destroy(context);
+
 		return -EBUSY;
 	}
+	if (!client->buffer_is_mapped) {
+		ret = fw_iso_buffer_map_dma(&client->buffer,
+					    client->device->card,
+					    iso_dma_direction(context));
+		if (ret < 0) {
+			spin_unlock_irq(&client->lock);
+			fw_iso_context_destroy(context);
+
+			return ret;
+		}
+		client->buffer_is_mapped = true;
+	}
 	client->iso_closure = a->closure;
 	client->iso_context = context;
 	spin_unlock_irq(&client->lock);
@@ -1652,7 +1676,6 @@ static long fw_device_op_compat_ioctl(st
 static int fw_device_op_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct client *client = file->private_data;
-	enum dma_data_direction direction;
 	unsigned long size;
 	int page_count, ret;
 
@@ -1675,20 +1698,28 @@ static int fw_device_op_mmap(struct file
 	if (size & ~PAGE_MASK)
 		return -EINVAL;
 
-	if (vma->vm_flags & VM_WRITE)
-		direction = DMA_TO_DEVICE;
-	else
-		direction = DMA_FROM_DEVICE;
-
-	ret = fw_iso_buffer_init(&client->buffer, client->device->card,
-				 page_count, direction);
+	ret = fw_iso_buffer_alloc(&client->buffer, page_count);
 	if (ret < 0)
 		return ret;
 
-	ret = fw_iso_buffer_map(&client->buffer, vma);
+	spin_lock_irq(&client->lock);
+	if (client->iso_context) {
+		ret = fw_iso_buffer_map_dma(&client->buffer,
+				client->device->card,
+				iso_dma_direction(client->iso_context));
+		client->buffer_is_mapped = (ret == 0);
+	}
+	spin_unlock_irq(&client->lock);
 	if (ret < 0)
-		fw_iso_buffer_destroy(&client->buffer, client->device->card);
+		goto fail;
 
+	ret = fw_iso_buffer_map_vma(&client->buffer, vma);
+	if (ret < 0)
+		goto fail;
+
+	return 0;
+ fail:
+	fw_iso_buffer_destroy(&client->buffer, client->device->card);
 	return ret;
 }
 
--- a/drivers/firewire/core-iso.c
+++ b/drivers/firewire/core-iso.c
@@ -39,52 +39,73 @@
  * Isochronous DMA context management
  */
 
-int fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
-		       int page_count, enum dma_data_direction direction)
+int fw_iso_buffer_alloc(struct fw_iso_buffer *buffer, int page_count)
 {
-	int i, j;
-	dma_addr_t address;
-
-	buffer->page_count = page_count;
-	buffer->direction = direction;
+	int i;
 
+	buffer->page_count = 0;
+	buffer->page_count_mapped = 0;
 	buffer->pages = kmalloc(page_count * sizeof(buffer->pages[0]),
 				GFP_KERNEL);
 	if (buffer->pages == NULL)
-		goto out;
+		return -ENOMEM;
 
-	for (i = 0; i < buffer->page_count; i++) {
+	for (i = 0; i < page_count; i++) {
 		buffer->pages[i] = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
 		if (buffer->pages[i] == NULL)
-			goto out_pages;
+			break;
+	}
+	buffer->page_count = i;
+	if (i < page_count) {
+		fw_iso_buffer_destroy(buffer, NULL);
+		return -ENOMEM;
+	}
 
+	return 0;
+}
+
+int fw_iso_buffer_map_dma(struct fw_iso_buffer *buffer, struct fw_card *card,
+			  enum dma_data_direction direction)
+{
+	dma_addr_t address;
+	int i;
+
+	buffer->direction = direction;
+
+	for (i = 0; i < buffer->page_count; i++) {
 		address = dma_map_page(card->device, buffer->pages[i],
 				       0, PAGE_SIZE, direction);
-		if (dma_mapping_error(card->device, address)) {
-			__free_page(buffer->pages[i]);
-			goto out_pages;
-		}
+		if (dma_mapping_error(card->device, address))
+			break;
+
 		set_page_private(buffer->pages[i], address);
 	}
+	buffer->page_count_mapped = i;
+	if (i < buffer->page_count)
+		return -ENOMEM;
 
 	return 0;
+}
 
- out_pages:
-	for (j = 0; j < i; j++) {
-		address = page_private(buffer->pages[j]);
-		dma_unmap_page(card->device, address,
-			       PAGE_SIZE, direction);
-		__free_page(buffer->pages[j]);
-	}
-	kfree(buffer->pages);
- out:
-	buffer->pages = NULL;
+int fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
+		       int page_count, enum dma_data_direction direction)
+{
+	int ret;
+
+	ret = fw_iso_buffer_alloc(buffer, page_count);
+	if (ret < 0)
+		return ret;
 
-	return -ENOMEM;
+	ret = fw_iso_buffer_map_dma(buffer, card, direction);
+	if (ret < 0)
+		fw_iso_buffer_destroy(buffer, card);
+
+	return ret;
 }
 EXPORT_SYMBOL(fw_iso_buffer_init);
 
-int fw_iso_buffer_map(struct fw_iso_buffer *buffer, struct vm_area_struct *vma)
+int fw_iso_buffer_map_vma(struct fw_iso_buffer *buffer,
+			  struct vm_area_struct *vma)
 {
 	unsigned long uaddr;
 	int i, err;
@@ -107,15 +128,18 @@ void fw_iso_buffer_destroy(struct fw_iso
 	int i;
 	dma_addr_t address;
 
-	for (i = 0; i < buffer->page_count; i++) {
+	for (i = 0; i < buffer->page_count_mapped; i++) {
 		address = page_private(buffer->pages[i]);
 		dma_unmap_page(card->device, address,
 			       PAGE_SIZE, buffer->direction);
-		__free_page(buffer->pages[i]);
 	}
+	for (i = 0; i < buffer->page_count; i++)
+		__free_page(buffer->pages[i]);
 
 	kfree(buffer->pages);
 	buffer->pages = NULL;
+	buffer->page_count = 0;
+	buffer->page_count_mapped = 0;
 }
 EXPORT_SYMBOL(fw_iso_buffer_destroy);
 
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -3,6 +3,7 @@
 
 #include <linux/compiler.h>
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/fs.h>
 #include <linux/list.h>
 #include <linux/idr.h>
@@ -169,7 +170,11 @@ void fw_node_event(struct fw_card *card,
 
 /* -iso */
 
-int fw_iso_buffer_map(struct fw_iso_buffer *buffer, struct vm_area_struct *vma);
+int fw_iso_buffer_alloc(struct fw_iso_buffer *buffer, int page_count);
+int fw_iso_buffer_map_dma(struct fw_iso_buffer *buffer, struct fw_card *card,
+			  enum dma_data_direction direction);
+int fw_iso_buffer_map_vma(struct fw_iso_buffer *buffer,
+			  struct vm_area_struct *vma);
 
 
 /* -topology */
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -391,6 +391,7 @@ struct fw_iso_buffer {
 	enum dma_data_direction direction;
 	struct page **pages;
 	int page_count;
+	int page_count_mapped;
 };
 
 int fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,


-- 
Stefan Richter
-=====-===-- -=-- -=--=
http://arcgraph.de/sr/
