Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3ABW6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 17:58:32 -0500
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:58473 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752758Ab3ABW6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 17:58:21 -0500
X-TM-IMSS-Message-ID: <5cefc55900096f1d@nsa.gov>
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
To: viro@ZenIV.linux.org.uk, konrad.wilk@oracle.com
Cc: david.vrabel@citrix.com, stefano.stabellini@eu.citrix.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Daniel De Graaf <dgdegra@tycho.nsa.gov>
Subject: [PATCH 2/3] xen/gntdev: correctly unmap unlinked maps in mmu notifier
Date: Wed,  2 Jan 2013 17:57:12 -0500
Message-Id: <1357167433-16874-3-git-send-email-dgdegra@tycho.nsa.gov>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357167433-16874-1-git-send-email-dgdegra@tycho.nsa.gov>
References: <20121221201824.GA31554@phenom.dumpdata.com>
 <1357167433-16874-1-git-send-email-dgdegra@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If gntdev_ioctl_unmap_grant_ref is called on a range before unmapping
it, the entry is removed from priv->maps and the later call to
mn_invl_range_start won't find it to do the unmapping. Fix this by
creating another list of freeable maps that the mmu notifier can search
and use to unmap grants.

Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
---
 drivers/xen/gntdev.c | 92 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 63 insertions(+), 29 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index cca62cc..9be3e5e 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -56,10 +56,15 @@ MODULE_PARM_DESC(limit, "Maximum number of grants that may be mapped by "
 static atomic_t pages_mapped = ATOMIC_INIT(0);
 
 static int use_ptemod;
+#define populate_freeable_maps use_ptemod
 
 struct gntdev_priv {
+	/* maps with visible offsets in the file descriptor */
 	struct list_head maps;
-	/* lock protects maps from concurrent changes */
+	/* maps that are not visible; will be freed on munmap.
+	 * Only populated if populate_freeable_maps == 1 */
+	struct list_head freeable_maps;
+	/* lock protects maps and freeable_maps */
 	spinlock_t lock;
 	struct mm_struct *mm;
 	struct mmu_notifier mn;
@@ -193,7 +198,7 @@ static struct grant_map *gntdev_find_map_index(struct gntdev_priv *priv,
 	return NULL;
 }
 
-static void gntdev_put_map(struct grant_map *map)
+static void gntdev_put_map(struct gntdev_priv *priv, struct grant_map *map)
 {
 	if (!map)
 		return;
@@ -208,6 +213,12 @@ static void gntdev_put_map(struct grant_map *map)
 		evtchn_put(map->notify.event);
 	}
 
+	if (populate_freeable_maps && priv) {
+		spin_lock(&priv->lock);
+		list_del(&map->next);
+		spin_unlock(&priv->lock);
+	}
+
 	if (map->pages && !use_ptemod)
 		unmap_grant_pages(map, 0, map->count);
 	gntdev_free_map(map);
@@ -376,11 +387,11 @@ static void gntdev_vma_open(struct vm_area_struct *vma)
 static void gntdev_vma_close(struct vm_area_struct *vma)
 {
 	struct grant_map *map = vma->vm_private_data;
+	struct file *file = vma->vm_file;
+	struct gntdev_priv *priv = file->private_data;
 
 	pr_debug("gntdev_vma_close %p\n", vma);
 	if (use_ptemod) {
-		struct file *file = vma->vm_file;
-		struct gntdev_priv *priv = file->private_data;
 		/* It is possible that an mmu notifier could be running
 		 * concurrently, so take priv->lock to ensure that the vma won't
 		 * vanishing during the unmap_grant_pages call, since we will
@@ -393,7 +404,7 @@ static void gntdev_vma_close(struct vm_area_struct *vma)
 		spin_unlock(&priv->lock);
 	}
 	vma->vm_private_data = NULL;
-	gntdev_put_map(map);
+	gntdev_put_map(priv, map);
 }
 
 static struct vm_operations_struct gntdev_vmops = {
@@ -403,33 +414,43 @@ static struct vm_operations_struct gntdev_vmops = {
 
 /* ------------------------------------------------------------------ */
 
+static void unmap_if_in_range(struct grant_map *map,
+			      unsigned long start, unsigned long end)
+{
+	unsigned long mstart, mend;
+	int err;
+
+	if (!map->vma)
+		return;
+	if (map->vma->vm_start >= end)
+		return;
+	if (map->vma->vm_end <= start)
+		return;
+	mstart = max(start, map->vma->vm_start);
+	mend   = min(end,   map->vma->vm_end);
+	pr_debug("map %d+%d (%lx %lx), range %lx %lx, mrange %lx %lx\n",
+			map->index, map->count,
+			map->vma->vm_start, map->vma->vm_end,
+			start, end, mstart, mend);
+	err = unmap_grant_pages(map,
+				(mstart - map->vma->vm_start) >> PAGE_SHIFT,
+				(mend - mstart) >> PAGE_SHIFT);
+	WARN_ON(err);
+}
+
 static void mn_invl_range_start(struct mmu_notifier *mn,
 				struct mm_struct *mm,
 				unsigned long start, unsigned long end)
 {
 	struct gntdev_priv *priv = container_of(mn, struct gntdev_priv, mn);
 	struct grant_map *map;
-	unsigned long mstart, mend;
-	int err;
 
 	spin_lock(&priv->lock);
 	list_for_each_entry(map, &priv->maps, next) {
-		if (!map->vma)
-			continue;
-		if (map->vma->vm_start >= end)
-			continue;
-		if (map->vma->vm_end <= start)
-			continue;
-		mstart = max(start, map->vma->vm_start);
-		mend   = min(end,   map->vma->vm_end);
-		pr_debug("map %d+%d (%lx %lx), range %lx %lx, mrange %lx %lx\n",
-				map->index, map->count,
-				map->vma->vm_start, map->vma->vm_end,
-				start, end, mstart, mend);
-		err = unmap_grant_pages(map,
-					(mstart - map->vma->vm_start) >> PAGE_SHIFT,
-					(mend - mstart) >> PAGE_SHIFT);
-		WARN_ON(err);
+		unmap_if_in_range(map, start, end);
+	}
+	list_for_each_entry(map, &priv->freeable_maps, next) {
+		unmap_if_in_range(map, start, end);
 	}
 	spin_unlock(&priv->lock);
 }
@@ -458,6 +479,15 @@ static void mn_release(struct mmu_notifier *mn,
 		err = unmap_grant_pages(map, /* offset */ 0, map->count);
 		WARN_ON(err);
 	}
+	list_for_each_entry(map, &priv->freeable_maps, next) {
+		if (!map->vma)
+			continue;
+		pr_debug("map %d+%d (%lx %lx)\n",
+				map->index, map->count,
+				map->vma->vm_start, map->vma->vm_end);
+		err = unmap_grant_pages(map, /* offset */ 0, map->count);
+		WARN_ON(err);
+	}
 	spin_unlock(&priv->lock);
 }
 
@@ -479,6 +509,7 @@ static int gntdev_open(struct inode *inode, struct file *flip)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&priv->maps);
+	INIT_LIST_HEAD(&priv->freeable_maps);
 	spin_lock_init(&priv->lock);
 
 	if (use_ptemod) {
@@ -513,8 +544,9 @@ static int gntdev_release(struct inode *inode, struct file *flip)
 	while (!list_empty(&priv->maps)) {
 		map = list_entry(priv->maps.next, struct grant_map, next);
 		list_del(&map->next);
-		gntdev_put_map(map);
+		gntdev_put_map(NULL /* already removed */, map);
 	}
+	WARN_ON(!list_empty(&priv->freeable_maps));
 
 	if (use_ptemod)
 		mmu_notifier_unregister(&priv->mn, priv->mm);
@@ -542,14 +574,14 @@ static long gntdev_ioctl_map_grant_ref(struct gntdev_priv *priv,
 
 	if (unlikely(atomic_add_return(op.count, &pages_mapped) > limit)) {
 		pr_debug("can't map: over limit\n");
-		gntdev_put_map(map);
+		gntdev_put_map(NULL, map);
 		return err;
 	}
 
 	if (copy_from_user(map->grants, &u->refs,
 			   sizeof(map->grants[0]) * op.count) != 0) {
-		gntdev_put_map(map);
-		return err;
+		gntdev_put_map(NULL, map);
+		return -EFAULT;
 	}
 
 	spin_lock(&priv->lock);
@@ -578,11 +610,13 @@ static long gntdev_ioctl_unmap_grant_ref(struct gntdev_priv *priv,
 	map = gntdev_find_map_index(priv, op.index >> PAGE_SHIFT, op.count);
 	if (map) {
 		list_del(&map->next);
+		if (populate_freeable_maps)
+			list_add_tail(&map->next, &priv->freeable_maps);
 		err = 0;
 	}
 	spin_unlock(&priv->lock);
 	if (map)
-		gntdev_put_map(map);
+		gntdev_put_map(priv, map);
 	return err;
 }
 
@@ -797,7 +831,7 @@ out_unlock_put:
 out_put_map:
 	if (use_ptemod)
 		map->vma = NULL;
-	gntdev_put_map(map);
+	gntdev_put_map(priv, map);
 	return err;
 }
 
-- 
1.7.11.7

