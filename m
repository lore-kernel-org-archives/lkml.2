Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1EJUqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 16:46:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57604 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751398Ab1EJUqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 16:46:37 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH] gma500: enable GEM mmap
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 10 May 2011 21:27:31 +0100
Message-ID: <20110510202645.23878.78117.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support mapping of GEM objects. This ought to be a small plumbing change but
instead we have to cut and paste a pile of stuff into the driver. This
really wants to be handled *IN* GEM

You can now allocate, mmap and munmap GEM objects in the driver. You can't
yet map them into the GART or display them however.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.c |    4 +-
 drivers/staging/gma500/psb_gem.c |   86 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 84 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 360d582..4da0b18 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -1422,11 +1422,11 @@ static struct drm_driver driver = {
 		 .open = drm_open,
 		 .release = drm_release,
 		 .unlocked_ioctl = psb_unlocked_ioctl,
-		 .mmap = drm_mmap,
+		 .mmap = drm_gem_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
 		 .read = drm_read,
-		 },
+	 },
 	.name = DRIVER_NAME,
 	.desc = DRIVER_DESC,
 	.date = PSB_DRM_DRIVER_DATE,
diff --git a/drivers/staging/gma500/psb_gem.c b/drivers/staging/gma500/psb_gem.c
index 518f8c1..2132fe9 100644
--- a/drivers/staging/gma500/psb_gem.c
+++ b/drivers/staging/gma500/psb_gem.c
@@ -41,6 +41,15 @@ void psb_gem_free_object(struct drm_gem_object *obj)
 {
 	struct gtt_range *gtt = container_of(obj, struct gtt_range, gem);
 	psb_gtt_free_range(obj->dev, gtt);
+	if (obj->map_list.map) {
+		/* Do things GEM should do for us */
+		struct drm_gem_mm *mm = obj->dev->mm_private;
+		struct drm_map_list *list = &obj->map_list;
+		drm_ht_remove_item(&mm->offset_hash, &list->hash);
+		drm_mm_put_block(list->file_offset_node);
+		kfree(list->map);
+		list->map = NULL;
+	}
 	drm_gem_object_release(obj);
 }
 
@@ -51,6 +60,59 @@ int psb_gem_get_aperture(struct drm_device *dev, void *data,
 }
 
 /**
+ *	psb_gem_create_mmap_offset	-	invent an mmap offset
+ *	@obj: our object
+ *
+ *	This is basically doing by hand a pile of ugly crap which should
+ *	be done automatically by the GEM library code but isn't
+ */
+static int psb_gem_create_mmap_offset(struct drm_gem_object *obj)
+{
+	struct drm_device *dev = obj->dev;
+	struct drm_gem_mm *mm = dev->mm_private;
+	struct drm_map_list *list;
+	struct drm_local_map *map;
+	int ret;
+
+	list = &obj->map_list;
+	list->map = kzalloc(sizeof(struct drm_map_list), GFP_KERNEL);
+	if (list->map == NULL)
+		return -ENOMEM;
+	map = list->map;
+	map->type = _DRM_GEM;
+	map->size = obj->size;
+	map->handle =obj;
+
+	list->file_offset_node = drm_mm_search_free(&mm->offset_manager,
+					obj->size / PAGE_SIZE, 0, 0);
+	if (!list->file_offset_node) {
+		DRM_ERROR("failed to allocate offset for bo %d\n", obj->name);
+		ret = -ENOSPC;
+		goto free_it;
+	}
+	list->file_offset_node = drm_mm_get_block(list->file_offset_node,
+					obj->size / PAGE_SIZE, 0);
+	if (!list->file_offset_node) {
+		ret = -ENOMEM;
+		goto free_it;
+	}
+	list->hash.key = list->file_offset_node->start;
+	ret = drm_ht_insert_item(&mm->offset_hash, &list->hash);
+	if (ret) {
+		DRM_ERROR("failed to add to map hash\n");
+		goto free_mm;
+	}
+	return 0;
+
+free_mm:
+	drm_mm_put_block(list->file_offset_node);
+free_it:
+	kfree(list->map);
+	list->map = NULL;
+	return ret;
+}
+
+/**
  *	psb_gem_dumb_map_gtt	-	buffer mapping for dumb interface
  *	@file: our drm client file
  *	@dev: drm device
@@ -62,19 +124,35 @@ int psb_gem_get_aperture(struct drm_device *dev, void *data,
 int psb_gem_dumb_map_gtt(struct drm_file *file, struct drm_device *dev,
 			 uint32_t handle, uint64_t *offset)
 {
+	int ret = 0;
 	struct drm_gem_object *obj;
+
 	if (!(dev->driver->driver_features & DRIVER_GEM))
 		return -ENODEV;
+		
+	mutex_lock(&dev->struct_mutex);
+
 	/* GEM does all our handle to object mapping */
 	obj = drm_gem_object_lookup(dev, file, handle);
-	if (obj == NULL)
-		return -ENOENT;
+	if (obj == NULL) {
+		ret = -ENOENT;
+		goto unlock;
+	}
 	/* What validation is needed here ? */
 	
-	/* GEM works out the hash offsets for us */
+	/* Make it mmapable */
+	if (!obj->map_list.map) {
+		ret = psb_gem_create_mmap_offset(obj);
+		if (ret)
+			goto out;
+	}
+	/* GEM should really work out the hash offsets for us */
 	*offset = (u64)obj->map_list.hash.key << PAGE_SHIFT;
+out:
 	drm_gem_object_unreference(obj);
-	return 0;
+unlock:
+	mutex_unlock(&dev->struct_mutex);
+	return ret;
 }
 
 /**

