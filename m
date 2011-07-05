Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1GEOrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:47:42 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59109 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1GEOrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:47:40 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 18/49] gma500: Update the GEM todo
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:37:55 +0100
Message-ID: <20110705143752.23872.81948.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We also pull out the undo side of the mmap offset processing so we can later
push it into GEM where it belongs

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/gem_glue.c |    9 +++++++++
 drivers/staging/gma500/psb_gem.c  |   15 +--------------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/gma500/gem_glue.c b/drivers/staging/gma500/gem_glue.c
index 0e7364b..779ac1a 100644
--- a/drivers/staging/gma500/gem_glue.c
+++ b/drivers/staging/gma500/gem_glue.c
@@ -42,6 +42,15 @@ int drm_gem_private_object_init(struct drm_device *dev,
 
 void drm_gem_object_release_wrap(struct drm_gem_object *obj)
 {
+	/* Remove the list map if one is present */
+	if (obj->map_list.map) {
+		struct drm_gem_mm *mm = obj->dev->mm_private;
+		struct drm_map_list *list = &obj->map_list;
+		drm_ht_remove_item(&mm->offset_hash, &list->hash);
+		drm_mm_put_block(list->file_offset_node);
+		kfree(list->map);
+		list->map = NULL;
+	}
 	if (obj->filp)
 		drm_gem_object_release(obj);
 }
diff --git a/drivers/staging/gma500/psb_gem.c b/drivers/staging/gma500/psb_gem.c
index 1e7faae..a63ad9e 100644
--- a/drivers/staging/gma500/psb_gem.c
+++ b/drivers/staging/gma500/psb_gem.c
@@ -19,12 +19,8 @@
  * Authors: Alan Cox
  *
  * TODO:
- *	-	we don't actually put GEM objects into the GART yet
- *	-	we need to work out if the MMU is relevant as well (eg for
+ *	-	we need to work out if the MMU is relevant (eg for
  *		accelerated operations on a GEM object)
- *	-	cache coherency
- *
- * ie this is just an initial framework to get us going.
  */
 
 #include <drm/drmP.h>
@@ -40,15 +36,6 @@ int psb_gem_init_object(struct drm_gem_object *obj)
 void psb_gem_free_object(struct drm_gem_object *obj)
 {
 	struct gtt_range *gtt = container_of(obj, struct gtt_range, gem);
-	if (obj->map_list.map) {
-		/* Do things GEM should do for us */
-		struct drm_gem_mm *mm = obj->dev->mm_private;
-		struct drm_map_list *list = &obj->map_list;
-		drm_ht_remove_item(&mm->offset_hash, &list->hash);
-		drm_mm_put_block(list->file_offset_node);
-		kfree(list->map);
-		list->map = NULL;
-	}
 	drm_gem_object_release_wrap(obj);
 	/* This must occur last as it frees up the memory of the GEM object */
 	psb_gtt_free_range(obj->dev, gtt);

