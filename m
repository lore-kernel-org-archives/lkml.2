Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2I1TAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:00:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab2I1S7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:59:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jakob Bornecrantz <jakob@vmware.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 115/262] vmwgfx: add dumb ioctl support
Date: Fri, 28 Sep 2012 11:50:44 -0700
Message-Id: <20120928183011.723955950@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 5e1782d224c79b26ab7d5c31e3f87657000714fb upstream.

Testing and works with the -modesetting driver,

Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c      |    5 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h      |   10 ++++
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |   73 +++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -1159,6 +1159,11 @@ static struct drm_driver driver = {
 	.open = vmw_driver_open,
 	.preclose = vmw_preclose,
 	.postclose = vmw_postclose,
+
+	.dumb_create = vmw_dumb_create,
+	.dumb_map_offset = vmw_dumb_map_offset,
+	.dumb_destroy = vmw_dumb_destroy,
+
 	.fops = &vmwgfx_driver_fops,
 	.name = VMWGFX_DRIVER_NAME,
 	.desc = VMWGFX_DRIVER_DESC,
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -645,6 +645,16 @@ int vmw_kms_readback(struct vmw_private
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
@@ -1917,3 +1917,76 @@ err_ref:
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


