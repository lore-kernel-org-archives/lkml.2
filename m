Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2IQBWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:22:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33569 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753278Ab2IQAuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:01 -0400
Message-Id: <20120917003643.757393322@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Airlie <airlied@redhat.com>,
        Jakob Bornecrantz <jakob@vmware.com>
Subject: [ 127/135] vmwgfx: add dumb ioctl support
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

Is this useful for 3.2 or does it depend on any other later changes?
(All I know is that it builds cleanly.)

------------------

From: Dave Airlie <airlied@redhat.com>

commit 5e1782d224c79b26ab7d5c31e3f87657000714fb upstream.

Testing and works with the -modesetting driver,

Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c      |    5 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h      |   10 ++++
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |   73 ++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -1089,6 +1089,11 @@ static struct drm_driver driver = {
 	.master_drop = vmw_master_drop,
 	.open = vmw_driver_open,
 	.postclose = vmw_postclose,
+
+	.dumb_create = vmw_dumb_create,
+	.dumb_map_offset = vmw_dumb_map_offset,
+	.dumb_destroy = vmw_dumb_destroy,
+
 	.fops = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -641,6 +641,16 @@ int vmw_kms_readback(struct vmw_private
 int vmw_kms_update_layout_ioctl(struct drm_device *dev, void *data,
 				struct drm_file *file_priv);
 
+int vmw_dumb_create(struct drm_file *file_priv,
+		    struct drm_device *dev,
+		    struct drm_mode_create_dumb *args);
+
+int vmw_dumb_map_offset(struct drm_file *file_priv,
+			struct drm_device *dev, uint32_t handle,
+			uint64_t *offset);
+int vmw_dumb_destroy(struct drm_file *file_priv,
+		     struct drm_device *dev,
+		     uint32_t handle);
 /**
  * Overlay control - vmwgfx_overlay.c
  */
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -1950,3 +1950,76 @@ err_ref:
 	vmw_resource_unreference(&res);
 	return ret;
 }
+
+
+int vmw_dumb_create(struct drm_file *file_priv,
+		    struct drm_device *dev,
+		    struct drm_mode_create_dumb *args)
+{
+	struct vmw_private *dev_priv = vmw_priv(dev);
+	struct vmw_master *vmaster = vmw_master(file_priv->master);
+	struct vmw_user_dma_buffer *vmw_user_bo;
+	struct ttm_buffer_object *tmp;
+	int ret;
+
+	args->pitch = args->width * ((args->bpp + 7) / 8);
+	args->size = args->pitch * args->height;
+
+	vmw_user_bo = kzalloc(sizeof(*vmw_user_bo), GFP_KERNEL);
+	if (vmw_user_bo == NULL)
+		return -ENOMEM;
+
+	ret = ttm_read_lock(&vmaster->lock, true);
+	if (ret != 0) {
+		kfree(vmw_user_bo);
+		return ret;
+	}
+
+	ret = vmw_dmabuf_init(dev_priv, &vmw_user_bo->dma, args->size,
+			      &vmw_vram_sys_placement, true,
+			      &vmw_user_dmabuf_destroy);
+	if (ret != 0)
+		goto out_no_dmabuf;
+
+	tmp = ttm_bo_reference(&vmw_user_bo->dma.base);
+	ret = ttm_base_object_init(vmw_fpriv(file_priv)->tfile,
+				   &vmw_user_bo->base,
+				   false,
+				   ttm_buffer_type,
+				   &vmw_user_dmabuf_release, NULL);
+	if (unlikely(ret != 0))
+		goto out_no_base_object;
+
+	args->handle = vmw_user_bo->base.hash.key;
+
+out_no_base_object:
+	ttm_bo_unref(&tmp);
+out_no_dmabuf:
+	ttm_read_unlock(&vmaster->lock);
+	return ret;
+}
+
+int vmw_dumb_map_offset(struct drm_file *file_priv,
+			struct drm_device *dev, uint32_t handle,
+			uint64_t *offset)
+{
+	struct ttm_object_file *tfile = vmw_fpriv(file_priv)->tfile;
+	struct vmw_dma_buffer *out_buf;
+	int ret;
+
+	ret = vmw_user_dmabuf_lookup(tfile, handle, &out_buf);
+	if (ret != 0)
+		return -EINVAL;
+
+	*offset = out_buf->base.addr_space_offset;
+	vmw_dmabuf_unreference(&out_buf);
+	return 0;
+}
+
+int vmw_dumb_destroy(struct drm_file *file_priv,
+		     struct drm_device *dev,
+		     uint32_t handle)
+{
+	return ttm_ref_object_base_unref(vmw_fpriv(file_priv)->tfile,
+					 handle, TTM_REF_USAGE);
+}


