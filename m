Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1DMJ5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 05:57:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48624 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409Ab1DMJ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 05:57:19 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 1/5] gma500: ioctl first pass
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 13 Apr 2011 10:35:39 +0100
Message-ID: <20110413093519.28527.36552.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Go through the remaining ioctls and check they make sense

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.c |   61 -----------------------
 drivers/staging/gma500/psb_gtt.c |  103 --------------------------------------
 drivers/staging/gma500/psb_gtt.h |   11 ----
 3 files changed, 1 insertions(+), 174 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 05c31b9..df50553 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -73,10 +73,6 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 		DRM_IO(DRM_PSB_KMS_OFF + DRM_COMMAND_BASE)
 #define DRM_IOCTL_PSB_KMS_ON	\
 		DRM_IO(DRM_PSB_KMS_ON + DRM_COMMAND_BASE)
-#define DRM_IOCTL_PSB_VT_LEAVE	\
-		DRM_IO(DRM_PSB_VT_LEAVE + DRM_COMMAND_BASE)
-#define DRM_IOCTL_PSB_VT_ENTER	\
-		DRM_IO(DRM_PSB_VT_ENTER + DRM_COMMAND_BASE)
 #define DRM_IOCTL_PSB_SIZES	\
 		DRM_IOR(DRM_PSB_SIZES + DRM_COMMAND_BASE, \
 			struct drm_psb_sizes_arg)
@@ -96,15 +92,6 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 #define DRM_IOCTL_PSB_REGISTER_RW	\
 		DRM_IOWR(DRM_PSB_REGISTER_RW + DRM_COMMAND_BASE, \
 			 struct drm_psb_register_rw_arg)
-#define DRM_IOCTL_PSB_GTT_MAP	\
-		DRM_IOWR(DRM_PSB_GTT_MAP + DRM_COMMAND_BASE, \
-			 struct psb_gtt_mapping_arg)
-#define DRM_IOCTL_PSB_GTT_UNMAP	\
-		DRM_IOW(DRM_PSB_GTT_UNMAP + DRM_COMMAND_BASE, \
-			struct psb_gtt_mapping_arg)
-#define DRM_IOCTL_PSB_UPDATE_GUARD	\
-		DRM_IOWR(DRM_PSB_UPDATE_GUARD + DRM_COMMAND_BASE, \
-			 uint32_t)
 #define DRM_IOCTL_PSB_DPST	\
 		DRM_IOWR(DRM_PSB_DPST + DRM_COMMAND_BASE, \
 			 uint32_t)
@@ -118,13 +105,6 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 		DRM_IOWR(DRM_PSB_GET_PIPE_FROM_CRTC_ID + DRM_COMMAND_BASE, \
 			 struct drm_psb_get_pipe_from_crtc_id_arg)
 
-#define DRM_IOCTL_PSB_KMS_OFF	  DRM_IO(DRM_PSB_KMS_OFF + DRM_COMMAND_BASE)
-#define DRM_IOCTL_PSB_KMS_ON	  DRM_IO(DRM_PSB_KMS_ON + DRM_COMMAND_BASE)
-
-static int psb_vt_leave_ioctl(struct drm_device *dev, void *data,
-			      struct drm_file *file_priv);
-static int psb_vt_enter_ioctl(struct drm_device *dev, void *data,
-			      struct drm_file *file_priv);
 static int psb_sizes_ioctl(struct drm_device *dev, void *data,
 			   struct drm_file *file_priv);
 static int psb_dc_state_ioctl(struct drm_device *dev, void * data,
@@ -153,11 +133,6 @@ static struct drm_ioctl_desc psb_ioctls[] = {
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_KMS_ON,
 			psbfb_kms_on_ioctl,
 			DRM_ROOT_ONLY),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_VT_LEAVE, psb_vt_leave_ioctl,
-		      DRM_ROOT_ONLY),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_VT_ENTER,
-			psb_vt_enter_ioctl,
-			DRM_ROOT_ONLY),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_SIZES, psb_sizes_ioctl, DRM_AUTH),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_DC_STATE, psb_dc_state_ioctl, DRM_AUTH),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_ADB, psb_adb_ioctl, DRM_AUTH),
@@ -167,12 +142,6 @@ static struct drm_ioctl_desc psb_ioctls[] = {
 		      DRM_AUTH),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_REGISTER_RW, psb_register_rw_ioctl,
 		      DRM_AUTH),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GTT_MAP,
-			psb_gtt_map_meminfo_ioctl,
-			DRM_AUTH),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GTT_UNMAP,
-			psb_gtt_unmap_meminfo_ioctl,
-			DRM_AUTH),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_DPST, psb_dpst_ioctl, DRM_AUTH),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GAMMA, psb_gamma_ioctl, DRM_AUTH),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_DPST_BL, psb_dpst_bl_ioctl, DRM_AUTH),
@@ -495,7 +464,6 @@ static int psb_do_init(struct drm_device *dev)
 	psb_spank(dev_priv);
 
 	/* mmu_gatt ?? */
-	printk(KERN_INFO "TWOD base %08lX\n", (u32) pg->gatt_start);
       	PSB_WSGX32(pg->gatt_start, PSB_CR_BIF_TWOD_REQ_BASE);
 
 	return 0;
@@ -721,18 +689,6 @@ int psb_driver_device_is_agp(struct drm_device *dev)
 }
 
 
-static int psb_vt_leave_ioctl(struct drm_device *dev, void *data,
-			      struct drm_file *file_priv)
-{
-	return 0;
-}
-
-static int psb_vt_enter_ioctl(struct drm_device *dev, void *data,
-			      struct drm_file *file_priv)
-{
-	return 0;
-}
-
 static int psb_sizes_ioctl(struct drm_device *dev, void *data,
 			   struct drm_file *file_priv)
 {
@@ -840,7 +796,7 @@ static int psb_dpst_ioctl(struct drm_device *dev, void *data,
 	uint32_t reg;
 
 	if (!gma_power_begin(dev, 0))
-		return 0;
+		return -EIO;
 
 	reg = PSB_RVDC32(PIPEASRC);
 
@@ -1368,28 +1324,13 @@ static unsigned int psb_poll(struct file *filp,
 	return POLLIN | POLLRDNORM;
 }
 
-/* Not sure what we will need yet - in the PVR driver this disappears into
-   a tangle of abstracted handlers and per process crap */
-
-struct psb_priv {
-	int dummy;
-};
-
 static int psb_driver_open(struct drm_device *dev, struct drm_file *priv)
 {
-	struct psb_priv *psb = kzalloc(sizeof(struct psb_priv), GFP_KERNEL);
-	if (psb == NULL)
-		return -ENOMEM;
-	priv->driver_priv = psb;
-	DRM_DEBUG("\n");
-	/*return PVRSRVOpen(dev, priv);*/
 	return 0;
 }
 
 static void psb_driver_close(struct drm_device *dev, struct drm_file *priv)
 {
-	kfree(priv->driver_priv);
-	priv->driver_priv = NULL;
 }
 
 static long psb_unlocked_ioctl(struct file *filp, unsigned int cmd,
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 093d7df..5f2acef 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -884,106 +884,3 @@ int psb_gtt_unmap_meminfo(struct drm_device *dev, void * hKernelMemInfo)
 	return 0;
 }
 
-int psb_gtt_map_meminfo_ioctl(struct drm_device *dev, void *data,
-			       struct drm_file *file_priv)
-{
-	struct psb_gtt_mapping_arg *arg
-	       = (struct psb_gtt_mapping_arg *)data;
-	uint32_t *offset_pages = &arg->offset_pages;
-
-	DRM_DEBUG("\n");
-
-	return psb_gtt_map_meminfo(dev, arg->hKernelMemInfo, offset_pages);
-}
-
-int psb_gtt_unmap_meminfo_ioctl(struct drm_device *dev, void *data,
-				struct drm_file *file_priv)
-{
-
-	struct psb_gtt_mapping_arg *arg
-	       = (struct psb_gtt_mapping_arg *)data;
-
-	DRM_DEBUG("\n");
-
-	return psb_gtt_unmap_meminfo(dev, arg->hKernelMemInfo);
-}
-
-int psb_gtt_map_pvr_memory(struct drm_device *dev,  unsigned int hHandle,
-			unsigned int ui32TaskId, dma_addr_t *pPages,
-			unsigned int ui32PagesNum, unsigned int *ui32Offset)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct psb_gtt_mm *mm = dev_priv->gtt_mm;
-	struct psb_gtt *pg = dev_priv->pg;
-	uint32_t size, pages, offset_pages;
-	struct drm_mm_node *node = NULL;
-	struct psb_gtt_mem_mapping *mapping = NULL;
-	int ret;
-
-	size = ui32PagesNum * PAGE_SIZE;
-	pages = 0;
-
-	/*alloc memory in TT apeture*/
-	ret = psb_gtt_mm_alloc_mem(mm, ui32PagesNum, 0, &node);
-	if (ret) {
-		DRM_DEBUG("alloc TT memory error\n");
-		goto failed_pages_alloc;
-	}
-
-   /*update psb_gtt_mm*/
-	ret = psb_gtt_add_node(mm,
-						   (u32)ui32TaskId,
-						   (u32)hHandle,
-						   node,
-						   &mapping);
-	if (ret) {
-		DRM_DEBUG("add_node failed");
-		goto failed_add_node;
-	}
-
-	node = mapping->node;
-	offset_pages = node->start;
-
-	DRM_DEBUG("get free node for %ld pages, offset %ld pages",
-							pages, offset_pages);
-
-	/*update gtt*/
-	psb_gtt_insert_phys_addresses(pg, pPages, (unsigned)offset_pages,
-						(unsigned)ui32PagesNum, 0);
-
-	*ui32Offset = offset_pages;
-	return 0;
-
-failed_add_node:
-	psb_gtt_mm_free_mem(mm, node);
-failed_pages_alloc:
-	return ret;
-}
-
-
-int psb_gtt_unmap_pvr_memory(struct drm_device *dev, unsigned int hHandle,
-						unsigned int ui32TaskId)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct psb_gtt_mm *mm = dev_priv->gtt_mm;
-	struct psb_gtt *pg = dev_priv->pg;
-	uint32_t pages, offset_pages;
-	struct drm_mm_node *node;
-	int ret;
-
-	ret = psb_gtt_remove_node(mm, (u32)ui32TaskId, (u32)hHandle, &node);
-	if (ret) {
-		printk(KERN_ERR "remove node failed\n");
-		return ret;
-	}
-
-	/*remove gtt entries*/
-	offset_pages = node->start;
-	pages = node->size;
-
-	psb_gtt_remove_pages(pg, offset_pages, pages, 0, 0, 1);
-
-	/*free tt node*/
-	psb_gtt_mm_free_mem(mm, node);
-	return 0;
-}
diff --git a/drivers/staging/gma500/psb_gtt.h b/drivers/staging/gma500/psb_gtt.h
index 8a0ef77..5ddc3ae 100644
--- a/drivers/staging/gma500/psb_gtt.h
+++ b/drivers/staging/gma500/psb_gtt.h
@@ -87,15 +87,4 @@ extern int psb_gtt_unmap_meminfo_ioctl(struct drm_device *dev, void *data,
 extern int psb_gtt_mm_init(struct psb_gtt *pg);
 extern void psb_gtt_mm_takedown(void);
 
-extern int psb_gtt_map_pvr_memory(struct drm_device *dev,
-                                                                  unsigned int hHandle,
-                                                                  unsigned int ui32TaskId,
-                                                                  dma_addr_t *pPages,
-                                                                  unsigned int ui32PagesNum,
-                                                                  unsigned int *ui32Offset);
-
-extern int psb_gtt_unmap_pvr_memory(struct drm_device *dev,
-                                                                        unsigned int hHandle,
-                                                                        unsigned int ui32TaskId);
-
 #endif

