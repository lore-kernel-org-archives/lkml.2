Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0HKNS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 09:18:59 -0400
Received: from caiajhbdcbbj.dreamhost.com ([208.97.132.119]:38819 "EHLO
	homiemail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752317Ab0HKNS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 09:18:58 -0400
Subject: [PATCH] DRM: Replace kmalloc/memset combos with kzalloc
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Dave Airlie <airlied@redhat.com>, Dave Airlie <airlied@linux.ie>,
        eric@anholt.net
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 09:18:52 -0400
Message-ID: <1281532732.2067.11.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently most, if not all, memory allocation in drm_bufs.c is followed by initializing the memory with 0.

Replace the use of kmalloc+memset with kzalloc.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/gpu/drm/drm_bufs.c |   33 +++++++++++----------------------
 1 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
index a5c9ce9..3e257a5 100644
--- a/drivers/gpu/drm/drm_bufs.c
+++ b/drivers/gpu/drm/drm_bufs.c
@@ -328,14 +328,13 @@ static int drm_addmap_core(struct drm_device * dev, resource_size_t offset,
 		return -EINVAL;
 	}
 
-	list = kmalloc(sizeof(*list), GFP_KERNEL);
+	list = kzalloc(sizeof(*list), GFP_KERNEL);
 	if (!list) {
 		if (map->type == _DRM_REGISTERS)
 			iounmap(map->handle);
 		kfree(map);
 		return -EINVAL;
 	}
-	memset(list, 0, sizeof(*list));
 	list->map = map;
 
 	mutex_lock(&dev->struct_mutex);
@@ -678,13 +677,12 @@ int drm_addbufs_agp(struct drm_device * dev, struct drm_buf_desc * request)
 		return -EINVAL;
 	}
 
-	entry->buflist = kmalloc(count * sizeof(*entry->buflist), GFP_KERNEL);
+	entry->buflist = kzalloc(count * sizeof(*entry->buflist), GFP_KERNEL);
 	if (!entry->buflist) {
 		mutex_unlock(&dev->struct_mutex);
 		atomic_dec(&dev->buf_alloc);
 		return -ENOMEM;
 	}
-	memset(entry->buflist, 0, count * sizeof(*entry->buflist));
 
 	entry->buf_size = size;
 	entry->page_order = page_order;
@@ -708,7 +706,7 @@ int drm_addbufs_agp(struct drm_device * dev, struct drm_buf_desc * request)
 		buf->file_priv = NULL;
 
 		buf->dev_priv_size = dev->driver->dev_priv_size;
-		buf->dev_private = kmalloc(buf->dev_priv_size, GFP_KERNEL);
+		buf->dev_private = kzalloc(buf->dev_priv_size, GFP_KERNEL);
 		if (!buf->dev_private) {
 			/* Set count correctly so we free the proper amount. */
 			entry->buf_count = count;
@@ -717,7 +715,6 @@ int drm_addbufs_agp(struct drm_device * dev, struct drm_buf_desc * request)
 			atomic_dec(&dev->buf_alloc);
 			return -ENOMEM;
 		}
-		memset(buf->dev_private, 0, buf->dev_priv_size);
 
 		DRM_DEBUG("buffer %d @ %p\n", entry->buf_count, buf->address);
 
@@ -832,22 +829,20 @@ int drm_addbufs_pci(struct drm_device * dev, struct drm_buf_desc * request)
 		return -EINVAL;
 	}
 
-	entry->buflist = kmalloc(count * sizeof(*entry->buflist), GFP_KERNEL);
+	entry->buflist = kzalloc(count * sizeof(*entry->buflist), GFP_KERNEL);
 	if (!entry->buflist) {
 		mutex_unlock(&dev->struct_mutex);
 		atomic_dec(&dev->buf_alloc);
 		return -ENOMEM;
 	}
-	memset(entry->buflist, 0, count * sizeof(*entry->buflist));
 
-	entry->seglist = kmalloc(count * sizeof(*entry->seglist), GFP_KERNEL);
+	entry->seglist = kzalloc(count * sizeof(*entry->seglist), GFP_KERNEL);
 	if (!entry->seglist) {
 		kfree(entry->buflist);
 		mutex_unlock(&dev->struct_mutex);
 		atomic_dec(&dev->buf_alloc);
 		return -ENOMEM;
 	}
-	memset(entry->seglist, 0, count * sizeof(*entry->seglist));
 
 	/* Keep the original pagelist until we know all the allocations
 	 * have succeeded
@@ -911,8 +906,8 @@ int drm_addbufs_pci(struct drm_device * dev, struct drm_buf_desc * request)
 			buf->file_priv = NULL;
 
 			buf->dev_priv_size = dev->driver->dev_priv_size;
-			buf->dev_private = kmalloc(buf->dev_priv_size,
-						  GFP_KERNEL);
+			buf->dev_private = kzalloc(buf->dev_priv_size,
+						GFP_KERNEL);
 			if (!buf->dev_private) {
 				/* Set count correctly so we free the proper amount. */
 				entry->buf_count = count;
@@ -923,7 +918,6 @@ int drm_addbufs_pci(struct drm_device * dev, struct drm_buf_desc * request)
 				atomic_dec(&dev->buf_alloc);
 				return -ENOMEM;
 			}
-			memset(buf->dev_private, 0, buf->dev_priv_size);
 
 			DRM_DEBUG("buffer %d @ %p\n",
 				  entry->buf_count, buf->address);
@@ -1048,14 +1042,13 @@ static int drm_addbufs_sg(struct drm_device * dev, struct drm_buf_desc * request
 		return -EINVAL;
 	}
 
-	entry->buflist = kmalloc(count * sizeof(*entry->buflist),
+	entry->buflist = kzalloc(count * sizeof(*entry->buflist),
 				GFP_KERNEL);
 	if (!entry->buflist) {
 		mutex_unlock(&dev->struct_mutex);
 		atomic_dec(&dev->buf_alloc);
 		return -ENOMEM;
 	}
-	memset(entry->buflist, 0, count * sizeof(*entry->buflist));
 
 	entry->buf_size = size;
 	entry->page_order = page_order;
@@ -1080,7 +1073,7 @@ static int drm_addbufs_sg(struct drm_device * dev, struct drm_buf_desc * request
 		buf->file_priv = NULL;
 
 		buf->dev_priv_size = dev->driver->dev_priv_size;
-		buf->dev_private = kmalloc(buf->dev_priv_size, GFP_KERNEL);
+		buf->dev_private = kzalloc(buf->dev_priv_size, GFP_KERNEL);
 		if (!buf->dev_private) {
 			/* Set count correctly so we free the proper amount. */
 			entry->buf_count = count;
@@ -1090,8 +1083,6 @@ static int drm_addbufs_sg(struct drm_device * dev, struct drm_buf_desc * request
 			return -ENOMEM;
 		}
 
-		memset(buf->dev_private, 0, buf->dev_priv_size);
-
 		DRM_DEBUG("buffer %d @ %p\n", entry->buf_count, buf->address);
 
 		offset += alignment;
@@ -1209,14 +1200,13 @@ static int drm_addbufs_fb(struct drm_device * dev, struct drm_buf_desc * request
 		return -EINVAL;
 	}
 
-	entry->buflist = kmalloc(count * sizeof(*entry->buflist),
+	entry->buflist = kzalloc(count * sizeof(*entry->buflist),
 				GFP_KERNEL);
 	if (!entry->buflist) {
 		mutex_unlock(&dev->struct_mutex);
 		atomic_dec(&dev->buf_alloc);
 		return -ENOMEM;
 	}
-	memset(entry->buflist, 0, count * sizeof(*entry->buflist));
 
 	entry->buf_size = size;
 	entry->page_order = page_order;
@@ -1240,7 +1230,7 @@ static int drm_addbufs_fb(struct drm_device * dev, struct drm_buf_desc * request
 		buf->file_priv = NULL;
 
 		buf->dev_priv_size = dev->driver->dev_priv_size;
-		buf->dev_private = kmalloc(buf->dev_priv_size, GFP_KERNEL);
+		buf->dev_private = kzalloc(buf->dev_priv_size, GFP_KERNEL);
 		if (!buf->dev_private) {
 			/* Set count correctly so we free the proper amount. */
 			entry->buf_count = count;
@@ -1249,7 +1239,6 @@ static int drm_addbufs_fb(struct drm_device * dev, struct drm_buf_desc * request
 			atomic_dec(&dev->buf_alloc);
 			return -ENOMEM;
 		}
-		memset(buf->dev_private, 0, buf->dev_priv_size);
 
 		DRM_DEBUG("buffer %d @ %p\n", entry->buf_count, buf->address);
 
-- 
1.7.0.4

