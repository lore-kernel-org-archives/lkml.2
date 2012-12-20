Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab2LTN35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 08:29:57 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:49106 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab2LTN3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 08:29:51 -0500
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 08:29:50 EST
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: DRI Development <dri-devel@lists.freedesktop.org>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Aaron Plattner <aplattner@nvidia.com>
Subject: [PATCH] [RFC] dma-buf: implement vmap refcounting in the interface logic
Date: Thu, 20 Dec 2012 14:14:23 +0100
Message-Id: <1356009263-15822-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <50D255F5.5030602@nvidia.com>
References: <50D255F5.5030602@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All drivers which implement this need to have some sort of refcount to
allow concurrent vmap usage. Hence implement this in the dma-buf core.

To protect against concurrent calls we need a lock, which potentially
causes new funny locking inversions. But this shouldn't be a problem
for exporters with statically allocated backing storage, and more
dynamic drivers have decent issues already anyway.

Inspired by some refactoring patches from Aaron Plattner, who
implemented the same idea, but only for drm/prime drivers.

v2: Check in dma_buf_release that no dangling vmaps are left.
Suggested by Aaron Plattner. We might want to do similar checks for
attachments, but that's for another patch. Also fix up ERR_PTR return
for vmap.

v3: Check whether the passed-in vmap address matches with the cached
one for vunmap. Eventually we might want to remove that parameter -
compared to the kmap functions there's no need for the vaddr for
unmapping.  Suggested by Chris Wilson.

v4: Fix a brown-paper-bag bug spotted by Aaron Plattner.

Cc: Aaron Plattner <aplattner@nvidia.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 Documentation/dma-buf-sharing.txt |  6 +++++-
 drivers/base/dma-buf.c            | 43 ++++++++++++++++++++++++++++++++++-----
 include/linux/dma-buf.h           |  4 +++-
 3 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index 0188903..4966b1b 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -302,7 +302,11 @@ Access to a dma_buf from the kernel context involves three steps:
       void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
 
    The vmap call can fail if there is no vmap support in the exporter, or if it
-   runs out of vmalloc space. Fallback to kmap should be implemented.
+   runs out of vmalloc space. Fallback to kmap should be implemented. Note that
+   the dma-buf layer keeps a reference count for all vmap access and calls down
+   into the exporter's vmap function only when no vmapping exists, and only
+   unmaps it once. Protection against concurrent vmap/vunmap calls is provided
+   by taking the dma_buf->lock mutex.
 
 3. Finish access
 
diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index a3f79c4..26b68de 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -39,6 +39,8 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 
 	dmabuf = file->private_data;
 
+	BUG_ON(dmabuf->vmapping_counter);
+
 	dmabuf->ops->release(dmabuf);
 	kfree(dmabuf);
 	return 0;
@@ -482,12 +484,34 @@ EXPORT_SYMBOL_GPL(dma_buf_mmap);
  */
 void *dma_buf_vmap(struct dma_buf *dmabuf)
 {
+	void *ptr;
+
 	if (WARN_ON(!dmabuf))
 		return NULL;
 
-	if (dmabuf->ops->vmap)
-		return dmabuf->ops->vmap(dmabuf);
-	return NULL;
+	if (!dmabuf->ops->vmap)
+		return NULL;
+
+	mutex_lock(&dmabuf->lock);
+	if (dmabuf->vmapping_counter) {
+		dmabuf->vmapping_counter++;
+		BUG_ON(!dmabuf->vmap_ptr);
+		ptr = dmabuf->vmap_ptr;
+		goto out_unlock;
+	}
+
+	BUG_ON(dmabuf->vmap_ptr);
+
+	ptr = dmabuf->ops->vmap(dmabuf);
+	if (IS_ERR_OR_NULL(ptr))
+		goto out_unlock;
+
+	dmabuf->vmap_ptr = ptr;
+	dmabuf->vmapping_counter = 1;
+
+out_unlock:
+	mutex_unlock(&dmabuf->lock);
+	return ptr;
 }
 EXPORT_SYMBOL_GPL(dma_buf_vmap);
 
@@ -501,7 +525,16 @@ void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
 	if (WARN_ON(!dmabuf))
 		return;
 
-	if (dmabuf->ops->vunmap)
-		dmabuf->ops->vunmap(dmabuf, vaddr);
+	BUG_ON(!dmabuf->vmap_ptr);
+	BUG_ON(dmabuf->vmapping_counter == 0);
+	BUG_ON(dmabuf->vmap_ptr != vaddr);
+
+	mutex_lock(&dmabuf->lock);
+	if (--dmabuf->vmapping_counter == 0) {
+		if (dmabuf->ops->vunmap)
+			dmabuf->ops->vunmap(dmabuf, vaddr);
+		dmabuf->vmap_ptr = NULL;
+	}
+	mutex_unlock(&dmabuf->lock);
 }
 EXPORT_SYMBOL_GPL(dma_buf_vunmap);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index bd2e52c..e3bf2f6 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -119,8 +119,10 @@ struct dma_buf {
 	struct file *file;
 	struct list_head attachments;
 	const struct dma_buf_ops *ops;
-	/* mutex to serialize list manipulation and attach/detach */
+	/* mutex to serialize list manipulation, attach/detach and vmap/unmap */
 	struct mutex lock;
+	unsigned vmapping_counter;
+	void *vmap_ptr;
 	void *priv;
 };
 
-- 
1.7.11.7

