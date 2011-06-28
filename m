Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1F1WIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:08:06 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40999 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab1F1WIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:08:01 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 19/29] gma500: Move our other GEM helper into the bits want to
 push into GEM
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:07:37 +0100
Message-ID: <20110628220728.898.68440.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/gem_glue.c |   54 ++++++++++++++++++++++++++++++++++++
 drivers/staging/gma500/gem_glue.h |    2 +
 drivers/staging/gma500/psb_gem.c  |   56 +------------------------------------
 3 files changed, 56 insertions(+), 56 deletions(-)


diff --git a/drivers/staging/gma500/gem_glue.c b/drivers/staging/gma500/gem_glue.c
index 0817497..0e7364b 100644
--- a/drivers/staging/gma500/gem_glue.c
+++ b/drivers/staging/gma500/gem_glue.c
@@ -45,3 +45,57 @@ void drm_gem_object_release_wrap(struct drm_gem_object *obj)
 	if (obj->filp)
 		drm_gem_object_release(obj);
 }
+
+/**
+ *	gem_create_mmap_offset		-	invent an mmap offset
+ *	@obj: our object
+ *
+ *	Standard implementation of offset generation for mmap as is
+ *	duplicated in several drivers. This belongs in GEM.
+ */
+int gem_create_mmap_offset(struct drm_gem_object *obj)
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
+	map->handle = obj;
+
+	list->file_offset_node = drm_mm_search_free(&mm->offset_manager,
+					obj->size / PAGE_SIZE, 0, 0);
+	if (!list->file_offset_node) {
+		dev_err(dev->dev, "failed to allocate offset for bo %d\n",
+								obj->name);
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
+		dev_err(dev->dev, "failed to add to map hash\n");
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
diff --git a/drivers/staging/gma500/gem_glue.h b/drivers/staging/gma500/gem_glue.h
index c38285b..a0f2bc4 100644
--- a/drivers/staging/gma500/gem_glue.h
+++ b/drivers/staging/gma500/gem_glue.h
@@ -1,4 +1,4 @@
 extern void drm_gem_object_release_wrap(struct drm_gem_object *obj);
 extern int drm_gem_private_object_init(struct drm_device *dev,
 			struct drm_gem_object *obj, size_t size);
-
+extern int gem_create_mmap_offset(struct drm_gem_object *obj);
diff --git a/drivers/staging/gma500/psb_gem.c b/drivers/staging/gma500/psb_gem.c
index 3f658e4..1e7faae 100644
--- a/drivers/staging/gma500/psb_gem.c
+++ b/drivers/staging/gma500/psb_gem.c
@@ -61,60 +61,6 @@ int psb_gem_get_aperture(struct drm_device *dev, void *data,
 }
 
 /**
- *	psb_gem_create_mmap_offset	-	invent an mmap offset
- *	@obj: our object
- *
- *	This is basically doing by hand a pile of ugly crap which should
- *	be done automatically by the GEM library code but isn't
- */
-static int psb_gem_create_mmap_offset(struct drm_gem_object *obj)
-{
-	struct drm_device *dev = obj->dev;
-	struct drm_gem_mm *mm = dev->mm_private;
-	struct drm_map_list *list;
-	struct drm_local_map *map;
-	int ret;
-
-	list = &obj->map_list;
-	list->map = kzalloc(sizeof(struct drm_map_list), GFP_KERNEL);
-	if (list->map == NULL)
-		return -ENOMEM;
-	map = list->map;
-	map->type = _DRM_GEM;
-	map->size = obj->size;
-	map->handle = obj;
-
-	list->file_offset_node = drm_mm_search_free(&mm->offset_manager,
-					obj->size / PAGE_SIZE, 0, 0);
-	if (!list->file_offset_node) {
-		dev_err(dev->dev, "failed to allocate offset for bo %d\n",
-								obj->name);
-		ret = -ENOSPC;
-		goto free_it;
-	}
-	list->file_offset_node = drm_mm_get_block(list->file_offset_node,
-					obj->size / PAGE_SIZE, 0);
-	if (!list->file_offset_node) {
-		ret = -ENOMEM;
-		goto free_it;
-	}
-	list->hash.key = list->file_offset_node->start;
-	ret = drm_ht_insert_item(&mm->offset_hash, &list->hash);
-	if (ret) {
-		dev_err(dev->dev, "failed to add to map hash\n");
-		goto free_mm;
-	}
-	return 0;
-
-free_mm:
-	drm_mm_put_block(list->file_offset_node);
-free_it:
-	kfree(list->map);
-	list->map = NULL;
-	return ret;
-}
-
-/**
  *	psb_gem_dumb_map_gtt	-	buffer mapping for dumb interface
  *	@file: our drm client file
  *	@dev: drm device
@@ -144,7 +90,7 @@ int psb_gem_dumb_map_gtt(struct drm_file *file, struct drm_device *dev,
 
 	/* Make it mmapable */
 	if (!obj->map_list.map) {
-		ret = psb_gem_create_mmap_offset(obj);
+		ret = gem_create_mmap_offset(obj);
 		if (ret)
 			goto out;
 	}

