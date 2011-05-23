Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab1EWRkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:40:31 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44722 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab1EWRk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=XNZY7hbg6Kc32sRauAakNHkETYb5FA/ALCi8ME2NODL79dlc3sITqqwrzhJME8KjUH
         CD3dAWysRGdw/qlSxu9FhJReui/g6kaY5VnCt5fFacdvpSyRRomKhaUeU3lDapkRYzXo
         BF8dn8aXnDUEfXEui+t3p7jHdXIc73W+4Hgdk=
Subject: [PATCH] drivers: Use kzalloc instead of 'kmalloc+memset', where
 possible.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 23:40:07 +0600
Message-ID: <1306172407.8198.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch removes the uses of 'kmalloc+memset' from various drivers subsystems, which is replaced by kzalloc. kzalloc take care of setting allocated memory with null, so it helps to get rid from using memset.


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 1c4b3aa..168b78f 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1638,13 +1638,12 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	const struct ata_port_info *ppi[] = { &pi, NULL };
 
 	/* Allocate DWC SATA device */
-	hsdev = kmalloc(sizeof(*hsdev), GFP_KERNEL);
+	hsdev = kzalloc(sizeof(*hsdev), GFP_KERNEL);
 	if (hsdev == NULL) {
 		dev_err(&ofdev->dev, "kmalloc failed for hsdev\n");
 		err = -ENOMEM;
 		goto error_out;
 	}
-	memset(hsdev, 0, sizeof(*hsdev));
 
 	/* Ioremap SATA registers */
 	base = of_iomap(ofdev->dev.of_node, 0);
diff --git a/drivers/gpu/drm/drm_scatter.c b/drivers/gpu/drm/drm_scatter.c
index d15e09b..37db1f8 100644
--- a/drivers/gpu/drm/drm_scatter.c
+++ b/drivers/gpu/drm/drm_scatter.c
@@ -83,30 +83,26 @@ int drm_sg_alloc(struct drm_device *dev, struct drm_scatter_gather * request)
 	if (dev->sg)
 		return -EINVAL;
 
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
 
-	memset(entry, 0, sizeof(*entry));
 	pages = (request->size + PAGE_SIZE - 1) / PAGE_SIZE;
 	DRM_DEBUG("size=%ld pages=%ld\n", request->size, pages);
 
 	entry->pages = pages;
-	entry->pagelist = kmalloc(pages * sizeof(*entry->pagelist), GFP_KERNEL);
+	entry->pagelist = kzalloc(pages * sizeof(*entry->pagelist), GFP_KERNEL);
 	if (!entry->pagelist) {
 		kfree(entry);
 		return -ENOMEM;
 	}
 
-	memset(entry->pagelist, 0, pages * sizeof(*entry->pagelist));
-
-	entry->busaddr = kmalloc(pages * sizeof(*entry->busaddr), GFP_KERNEL);
+	entry->busaddr = kzalloc(pages * sizeof(*entry->busaddr), GFP_KERNEL);
 	if (!entry->busaddr) {
 		kfree(entry->pagelist);
 		kfree(entry);
 		return -ENOMEM;
 	}
-	memset((void *)entry->busaddr, 0, pages * sizeof(*entry->busaddr));
 
 	entry->virtual = drm_vmalloc_dma(pages << PAGE_SHIFT);
 	if (!entry->virtual) {
diff --git a/drivers/gpu/drm/radeon/radeon_mem.c b/drivers/gpu/drm/radeon/radeon_mem.c
index ed95155..988548e 100644
--- a/drivers/gpu/drm/radeon/radeon_mem.c
+++ b/drivers/gpu/drm/radeon/radeon_mem.c
@@ -139,7 +139,7 @@ static int init_heap(struct mem_block **heap, int start, int size)
 	if (!blocks)
 		return -ENOMEM;
 
-	*heap = kmalloc(sizeof(**heap), GFP_KERNEL);
+	*heap = kzalloc(sizeof(**heap), GFP_KERNEL);
 	if (!*heap) {
 		kfree(blocks);
 		return -ENOMEM;
@@ -150,7 +150,6 @@ static int init_heap(struct mem_block **heap, int start, int size)
 	blocks->file_priv = NULL;
 	blocks->next = blocks->prev = *heap;
 
-	memset(*heap, 0, sizeof(**heap));
 	(*heap)->file_priv = (struct drm_file *) - 1;
 	(*heap)->next = (*heap)->prev = blocks;
 	return 0;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
index f1a52f9..07ce02d 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
@@ -585,11 +585,10 @@ int vmw_overlay_init(struct vmw_private *dev_priv)
 		return -ENOSYS;
 	}
 
-	overlay = kmalloc(sizeof(*overlay), GFP_KERNEL);
+	overlay = kzalloc(sizeof(*overlay), GFP_KERNEL);
 	if (!overlay)
 		return -ENOMEM;
 
-	memset(overlay, 0, sizeof(*overlay));
 	mutex_init(&overlay->mutex);
 	for (i = 0; i < VMW_MAX_NUM_STREAMS; i++) {
 		overlay->stream[i].buf = NULL;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index 5408b1b..bfe1bcc 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -612,11 +612,9 @@ int vmw_surface_define_ioctl(struct drm_device *dev, void *data,
 	    srf->sizes[0].height == 64 &&
 	    srf->format == SVGA3D_A8R8G8B8) {
 
-		srf->snooper.image = kmalloc(64 * 64 * 4, GFP_KERNEL);
-		/* clear the image */
-		if (srf->snooper.image) {
-			memset(srf->snooper.image, 0x00, 64 * 64 * 4);
-		} else {
+		/* allocate image area and clear it */
+		srf->snooper.image = kzalloc(64 * 64 * 4, GFP_KERNEL);
+		if (!srf->snooper.image) {
 			DRM_ERROR("Failed to allocate cursor_image\n");
 			ret = -ENOMEM;
 			goto out_err1;
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index be8d4cb..370de0b 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -1094,10 +1094,9 @@ static int vga_arb_open(struct inode *inode, struct file *file)
 
 	pr_debug("%s\n", __func__);
 
-	priv = kmalloc(sizeof(struct vga_arb_private), GFP_KERNEL);
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv == NULL)
 		return -ENOMEM;
-	memset(priv, 0, sizeof(*priv));
 	spin_lock_init(&priv->lock);
 	file->private_data = priv;
 


