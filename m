Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab1EKUrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:47:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271Ab1EKUre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:47:34 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] vfio: Fixup uiommu sharing
To: pugs@ieee.org
Cc: alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Date: Wed, 11 May 2011 14:47:26 -0600
Message-ID: <20110511204330.8810.5764.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When setting up a vfio device, we can either create a new iommu
domain for each device, or use an iommu domain shared between
multiple devices.  In the first case, we open /dev/uiommu for
each device and pass the new file descriptor for each device's
VFIO_DOMAIN_SET ioctl.  For the latter, we use a single file
descriptor multiple times.

This doesn't currently work because the dma region list is
tied to the instance of the vfio device file opening.  This
completely breaks any kind of page accounting or dma region
tracking, and if one device is closed, the other is in bad
shape.

Instead, manage the uiommu connection around VFIO_DOMAIN_{UN}SET.
The first vfio device to set a domain will create a vfio_uiommu
object and add it to a list, subsequent users trying to use the
same domain will share the object, last one out does the cleanup.
For virtual machine usage, this means we can now have a single
iommu domain context persist across addition and removal of
devices, so long as there's at least one device always attached.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

Tom,

This is the thing that was confusing me the other day.  I think
the model below makes more sense, but it's entirely possible
that I'm overlooking your usage model.  Let me know.  Thanks,

Alex

Note: patch against "vfio: Allow sub-ranges to be unmapped"

 drivers/vfio/vfio_dma.c     |  212 +++++++++++++++++++++++++------------------
 drivers/vfio/vfio_main.c    |   91 ++++++------------
 drivers/vfio/vfio_netlink.c |    2 
 drivers/vfio/vfio_sysfs.c   |    3 -
 include/linux/vfio.h        |   36 ++++---
 5 files changed, 177 insertions(+), 167 deletions(-)

diff --git a/drivers/vfio/vfio_dma.c b/drivers/vfio/vfio_dma.c
index bf260e4..154ccb7 100644
--- a/drivers/vfio/vfio_dma.c
+++ b/drivers/vfio/vfio_dma.c
@@ -42,6 +42,9 @@
 #include <linux/workqueue.h>
 #include <linux/vfio.h>
 
+static LIST_HEAD(vfio_uiommu_list);
+static DEFINE_MUTEX(vfio_uiommu_lock);
+
 struct vwork {
 	struct mm_struct *mm;
 	unsigned long npage;
@@ -97,77 +100,75 @@ static void vfio_lock_acct(unsigned long npage)
 
 /* Unmap DMA region */
 /* dgate must be held */
-static void vfio_dma_unmap(struct vfio_listener *listener, unsigned long iova,
+static void vfio_dma_unmap(struct vfio_uiommu *uiommu, unsigned long iova,
 			   unsigned long npage, struct page **pages, int rdwr)
 {
-	struct vfio_dev *vdev = listener->vdev;
 	unsigned long i;
 
 	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
-		uiommu_unmap(vdev->udomain, iova, 0);
+		uiommu_unmap(uiommu->udomain, iova, 0);
 		if (rdwr)
 			SetPageDirty(pages[i]);
 		put_page(pages[i]);
 	}
-	vdev->locked_pages -= npage;
+	uiommu->locked_pages -= npage;
 	vfio_lock_acct(-npage);
 }
 
 /* Unmap ALL DMA regions */
-void vfio_dma_unmapall(struct vfio_listener *listener)
+static void vfio_dma_unmapall(struct vfio_uiommu *uiommu)
 {
 	struct list_head *pos, *pos2;
 	struct dma_map_page *mlp;
 
-	mutex_lock(&listener->vdev->dgate);
-	list_for_each_safe(pos, pos2, &listener->dm_list) {
+	mutex_lock(&uiommu->dgate);
+	list_for_each_safe(pos, pos2, &uiommu->dm_list) {
 		mlp = list_entry(pos, struct dma_map_page, list);
-		vfio_dma_unmap(listener, mlp->daddr, mlp->npage,
+		vfio_dma_unmap(uiommu, mlp->daddr, mlp->npage,
 			       mlp->pages, mlp->rdwr);
 		list_del(&mlp->list);
 		vfree(mlp->pages);
 		kfree(mlp);
 	}
-	mutex_unlock(&listener->vdev->dgate);
+	mutex_unlock(&uiommu->dgate);
 }
 
 /* Map DMA region */
 /* dgate must be held */
-static int vfio_dma_map(struct vfio_listener *listener, unsigned long iova,
+static int vfio_dma_map(struct vfio_uiommu *uiommu, unsigned long iova,
 			unsigned long npage, struct page **pages, int rdwr)
 {
-	struct vfio_dev *vdev = listener->vdev;
 	unsigned long i;
 	int ret;
 
 	/* Verify pages are not already mapped */
 	for (i = 0; i < npage; i++)
-		if (uiommu_iova_to_phys(vdev->udomain, iova + i * PAGE_SIZE))
+		if (uiommu_iova_to_phys(uiommu->udomain, iova + i * PAGE_SIZE))
 			return -EBUSY;
 
 	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
-		ret = uiommu_map(vdev->udomain, iova,
+		ret = uiommu_map(uiommu->udomain, iova,
 				 page_to_phys(pages[i]), 0, rdwr);
 		if (!ret)
 			continue;
 
 		/* Back out mappings on error */
 		for (i--, iova -= PAGE_SIZE; i >= 0; i--, iova -= PAGE_SIZE)
-			uiommu_unmap(vdev->udomain, iova, 0);
+			uiommu_unmap(uiommu->udomain, iova, 0);
 		return ret;
 	}
-	vdev->locked_pages += npage;
+	uiommu->locked_pages += npage;
 	vfio_lock_acct(npage);
 	return 0;
 }
 
-static struct dma_map_page *vfio_find_dma(struct vfio_listener *listener,
+static struct dma_map_page *vfio_find_dma(struct vfio_uiommu *uiommu,
 					  dma_addr_t start, size_t size)
 {
 	struct list_head *pos;
 	struct dma_map_page *mlp;
 
-	list_for_each(pos, &listener->dm_list) {
+	list_for_each(pos, &uiommu->dm_list) {
 		mlp = list_entry(pos, struct dma_map_page, list);
 		if (!(mlp->daddr + (mlp->npage << PAGE_SHIFT) <= start ||
 		      mlp->daddr >= start + size))
@@ -176,13 +177,13 @@ static struct dma_map_page *vfio_find_dma(struct vfio_listener *listener,
 	return NULL;
 }
 
-static struct dma_map_page *vfio_find_vaddr(struct vfio_listener *listener,
+static struct dma_map_page *vfio_find_vaddr(struct vfio_uiommu *uiommu,
 					    unsigned long start, size_t size)
 {
 	struct list_head *pos;
 	struct dma_map_page *mlp;
 
-	list_for_each(pos, &listener->dm_list) {
+	list_for_each(pos, &uiommu->dm_list) {
 		mlp = list_entry(pos, struct dma_map_page, list);
 		if (!(mlp->vaddr + (mlp->npage << PAGE_SHIFT) <= start ||
 		      mlp->vaddr >= start + size))
@@ -191,7 +192,7 @@ static struct dma_map_page *vfio_find_vaddr(struct vfio_listener *listener,
 	return NULL;
 }
 
-int vfio_remove_dma_overlap(struct vfio_listener *listener, dma_addr_t start,
+int vfio_remove_dma_overlap(struct vfio_uiommu *uiommu, dma_addr_t start,
 			    size_t size, struct dma_map_page *mlp,
 			    size_t *remaining)
 {
@@ -202,7 +203,7 @@ int vfio_remove_dma_overlap(struct vfio_listener *listener, dma_addr_t start,
 	/* Existing dma region is completely covered, unmap all */
 	if (start <= mlp->daddr &&
 	    start + size >= mlp->daddr + (mlp->npage << PAGE_SHIFT)) {
-		vfio_dma_unmap(listener, mlp->daddr, mlp->npage,
+		vfio_dma_unmap(uiommu, mlp->daddr, mlp->npage,
 			       mlp->pages, mlp->rdwr);
 		list_del(&mlp->list);
 		vfree(mlp->pages);
@@ -224,7 +225,7 @@ int vfio_remove_dma_overlap(struct vfio_listener *listener, dma_addr_t start,
 		if (!pages_hi)
 			return -ENOMEM;
 
-		vfio_dma_unmap(listener, mlp->daddr, npage_lo,
+		vfio_dma_unmap(uiommu, mlp->daddr, npage_lo,
 			       mlp->pages, mlp->rdwr);
 		mlp->daddr += overlap;
 		mlp->vaddr += overlap;
@@ -250,7 +251,7 @@ int vfio_remove_dma_overlap(struct vfio_listener *listener, dma_addr_t start,
 		if (!pages_lo)
 			return -ENOMEM;
 
-		vfio_dma_unmap(listener, start, npage_hi,
+		vfio_dma_unmap(uiommu, start, npage_hi,
 			       &mlp->pages[npage_lo], mlp->rdwr);
 		mlp->npage -= npage_hi;
 		memcpy(pages_lo, mlp->pages,
@@ -283,7 +284,7 @@ int vfio_remove_dma_overlap(struct vfio_listener *listener, dma_addr_t start,
 		return -ENOMEM;
 	}
 
-	vfio_dma_unmap(listener, start, size >> PAGE_SHIFT,
+	vfio_dma_unmap(uiommu, start, size >> PAGE_SHIFT,
 		       &mlp->pages[npage_lo], mlp->rdwr);
 
 	memcpy(pages_lo, mlp->pages, npage_lo * sizeof(struct page *));
@@ -299,13 +300,13 @@ int vfio_remove_dma_overlap(struct vfio_listener *listener, dma_addr_t start,
 	split->daddr = start + size;
 	split->vaddr = mlp->vaddr + (npage_lo << PAGE_SHIFT) + size;
 	split->rdwr = mlp->rdwr;
-	list_add(&split->list, &listener->dm_list);
+	list_add(&split->list, &uiommu->dm_list);
 	if (remaining)
 		*remaining -= size;
 	return 0;
 }
 
-int vfio_dma_unmap_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
+int vfio_dma_unmap_dm(struct vfio_uiommu *uiommu, struct vfio_dma_map *dmp)
 {
 	struct dma_map_page *mlp;
 	int ret = 0;
@@ -316,18 +317,18 @@ int vfio_dma_unmap_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
 	if (size & (PAGE_SIZE-1))
 		return -EINVAL;
 
-	if (!listener->vdev->udomain)
+	if (!uiommu)
 		return -EINVAL;
 
-	mutex_lock(&listener->vdev->dgate);
+	mutex_lock(&uiommu->dgate);
 	while (size &&
-	       (mlp = vfio_find_dma(listener, dmp->dmaaddr, dmp->size))) {
-		ret = vfio_remove_dma_overlap(listener, dmp->dmaaddr,
+	       (mlp = vfio_find_dma(uiommu, dmp->dmaaddr, dmp->size))) {
+		ret = vfio_remove_dma_overlap(uiommu, dmp->dmaaddr,
 					      dmp->size, mlp, &size);
 		if (ret)
 			break;
 	}
-	mutex_unlock(&listener->vdev->dgate);
+	mutex_unlock(&uiommu->dgate);
 	return ret;
 }
 
@@ -338,16 +339,16 @@ int vfio_dma_unmap_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
 static void vfio_dma_handle_mmu_notify(struct mmu_notifier *mn,
 		unsigned long start, unsigned long end)
 {
-	struct vfio_listener *listener;
+	struct vfio_uiommu *uiommu;
 	struct dma_map_page *mlp;
 
-	listener = container_of(mn, struct vfio_listener, mmu_notifier);
-	mutex_lock(&listener->vdev->dgate);
+	uiommu = container_of(mn, struct vfio_uiommu, mmu_notifier);
+	mutex_lock(&uiommu->dgate);
 
 	/* vaddrs are not unique (multiple daddrs could be mapped to the
 	 * same vaddr), therefore we have to search to exhaustion rather
 	 * than tracking how much we've unmapped. */
-	while ((mlp = vfio_find_vaddr(listener, start, end - start))) {
+	while ((mlp = vfio_find_vaddr(uiommu, start, end - start))) {
 		dma_addr_t dma_start;
 		int ret;
 
@@ -356,7 +357,7 @@ static void vfio_dma_handle_mmu_notify(struct mmu_notifier *mn,
 			dma_start -= mlp->vaddr - start;
 		else
 			dma_start += start - mlp->vaddr;
-		ret = vfio_remove_dma_overlap(listener, dma_start,
+		ret = vfio_remove_dma_overlap(uiommu, dma_start,
 					      end - start, mlp, NULL);
 		if (ret) {
 			printk(KERN_ERR "%s: "
@@ -365,7 +366,7 @@ static void vfio_dma_handle_mmu_notify(struct mmu_notifier *mn,
 			break;
 		}
 	}
-	mutex_unlock(&listener->vdev->dgate);
+	mutex_unlock(&uiommu->dgate);
 }
 
 static void vfio_dma_inval_page(struct mmu_notifier *mn,
@@ -386,9 +387,8 @@ static const struct mmu_notifier_ops vfio_dma_mmu_notifier_ops = {
 };
 #endif	/* CONFIG_MMU_NOTIFIER */
 
-int vfio_dma_map_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
+int vfio_dma_map_dm(struct vfio_uiommu *uiommu, struct vfio_dma_map *dmp)
 {
-	struct vfio_dev *vdev = listener->vdev;
 	int locked, lock_limit;
 	struct page **pages;
 	struct dma_map_page *mlp, *nmlp, *mmlp = NULL;
@@ -409,17 +409,17 @@ int vfio_dma_map_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
 	if (!npage)
 		return -EINVAL;
 
-	if (!vdev->udomain)
+	if (!uiommu)
 		return -EINVAL;
 
 	if (dmp->flags & VFIO_FLAG_WRITE)
 		rdwr |= IOMMU_WRITE;
-	if (vdev->cachec)
+	if (uiommu->cachec)
 		rdwr |= IOMMU_CACHE;
 
-	mutex_lock(&listener->vdev->dgate);
+	mutex_lock(&uiommu->dgate);
 
-	if (vfio_find_dma(listener, daddr, size)) {
+	if (vfio_find_dma(uiommu, daddr, size)) {
 		ret = -EBUSY;
 		goto out_lock;
 	}
@@ -433,23 +433,6 @@ int vfio_dma_map_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
 		ret = -ENOMEM;
 		goto out_lock;
 	}
-	/* only 1 address space per fd */
-	if (current->mm != listener->mm) {
-		if (listener->mm) {
-			ret = -EINVAL;
-			goto out_lock;
-		}
-		listener->mm = current->mm;
-#ifdef CONFIG_MMU_NOTIFIER
-		listener->mmu_notifier.ops = &vfio_dma_mmu_notifier_ops;
-		ret = mmu_notifier_register(&listener->mmu_notifier,
-						listener->mm);
-		if (ret)
-			printk(KERN_ERR "%s: mmu_notifier_register failed %d\n",
-				__func__, ret);
-		ret = 0;
-#endif
-	}
 
 	/* Allocate a new mlp, this may not be used if we merge, but
 	 * ENOMEM is easier to handle before we do the iova mapping */
@@ -478,7 +461,7 @@ int vfio_dma_map_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
 		goto out_lock;
 	}
 
-	ret = vfio_dma_map(listener, daddr, npage, pages, rdwr);
+	ret = vfio_dma_map(uiommu, daddr, npage, pages, rdwr);
 	if (ret) {
 		while (npage--)
 			put_page(pages[npage]);
@@ -489,7 +472,7 @@ int vfio_dma_map_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
 
 	/* Check if we abut a region below */
 	if (daddr) {
-		mlp = vfio_find_dma(listener, daddr - 1, 1);
+		mlp = vfio_find_dma(uiommu, daddr - 1, 1);
 		if (mlp && mlp->rdwr == rdwr &&
 		    mlp->vaddr + (mlp->npage << PAGE_SHIFT) == vaddr) {
 			struct page **mpages;
@@ -521,7 +504,7 @@ int vfio_dma_map_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
 	}
 
 	if (daddr + size) {
-		mlp = vfio_find_dma(listener, daddr + size, 1);
+		mlp = vfio_find_dma(uiommu, daddr + size, 1);
 		if (mlp && mlp->rdwr == rdwr && mlp->vaddr == vaddr + size) {
 			struct page **mpages;
 
@@ -558,56 +541,67 @@ no_merge:
 		nmlp->daddr = daddr;
 		nmlp->vaddr = vaddr;
 		nmlp->rdwr = rdwr;
-		list_add(&nmlp->list, &listener->dm_list);
+		list_add(&nmlp->list, &uiommu->dm_list);
 	} else
 		kfree(nmlp);
 
 out_lock:
-	mutex_unlock(&listener->vdev->dgate);
+	mutex_unlock(&uiommu->dgate);
 	return ret;
 }
 
-int vfio_domain_unset(struct vfio_listener *listener)
+int vfio_domain_unset(struct vfio_dev *vdev)
 {
-	struct vfio_dev *vdev = listener->vdev;
 	struct pci_dev *pdev = vdev->pdev;
+	struct uiommu_domain *udomain;
 
-	if (!vdev->udomain)
+	if (!vdev->uiommu)
 		return 0;
-	if (!list_empty(&listener->dm_list))
-		return -EBUSY;
-	uiommu_detach_device(vdev->udomain, &pdev->dev);
-	uiommu_put(vdev->udomain);
-	vdev->udomain = NULL;
+
+	udomain = vdev->uiommu->udomain;
+
+	mutex_lock(&vfio_uiommu_lock);
+	if (--vdev->uiommu->refcnt == 0) {
+#ifdef CONFIG_MMU_NOTIFIER
+		mmu_notifier_unregister(&vdev->uiommu->mmu_notifier,
+					vdev->uiommu->mm);
+#endif
+		vfio_dma_unmapall(vdev->uiommu);
+		list_del(&vdev->uiommu->next);
+		kfree(vdev->uiommu);
+	}
+	mutex_unlock(&vfio_uiommu_lock);
+
+	uiommu_detach_device(udomain, &pdev->dev);
+	uiommu_put(udomain);
+	vdev->uiommu = NULL;
 	return 0;
 }
 
-int vfio_domain_set(struct vfio_listener *listener, int fd, int unsafe_ok)
+int vfio_domain_set(struct vfio_dev *vdev, int fd, int unsafe_ok)
 {
-	struct vfio_dev *vdev = listener->vdev;
-	struct uiommu_domain *udomain;
 	struct pci_dev *pdev = vdev->pdev;
-	int ret;
-	int safe;
+	struct uiommu_domain *udomain;
+	struct list_head *pos;
+	struct vfio_uiommu *uiommu = NULL;
+	int ret, cachec, intremap = 0;
 
-	if (vdev->udomain)
+	if (vdev->uiommu)
 		return -EBUSY;
+
 	udomain = uiommu_fdget(fd);
 	if (IS_ERR(udomain))
 		return PTR_ERR(udomain);
 
-	safe = 0;
 #ifdef IOMMU_CAP_INTR_REMAP	/* >= 2.6.36 */
 	/* iommu domain must also isolate dev interrupts */
-	if (uiommu_domain_has_cap(udomain, IOMMU_CAP_INTR_REMAP))
-		safe = 1;
+	intremap = uiommu_domain_has_cap(udomain, IOMMU_CAP_INTR_REMAP);
 #endif
-	if (!safe && !unsafe_ok) {
+	if (!intremap && !unsafe_ok) {
 		printk(KERN_WARNING "%s: no interrupt remapping!\n", __func__);
 		return -EINVAL;
 	}
 
-	vfio_domain_unset(listener);
 	ret = uiommu_attach_device(udomain, &pdev->dev);
 	if (ret) {
 		printk(KERN_ERR "%s: attach_device failed %d\n",
@@ -615,8 +609,50 @@ int vfio_domain_set(struct vfio_listener *listener, int fd, int unsafe_ok)
 		uiommu_put(udomain);
 		return ret;
 	}
-	vdev->cachec = iommu_domain_has_cap(udomain->domain,
-				IOMMU_CAP_CACHE_COHERENCY);
-	vdev->udomain = udomain;
-	return 0;
+
+	cachec = iommu_domain_has_cap(udomain->domain,
+				      IOMMU_CAP_CACHE_COHERENCY);
+
+	mutex_lock(&vfio_uiommu_lock);
+	list_for_each(pos, &vfio_uiommu_list) {
+		uiommu = list_entry(pos, struct vfio_uiommu, next);
+		if (uiommu->udomain == udomain)
+			break;
+		uiommu = NULL;
+	}
+
+	if (!uiommu) {
+		uiommu = kzalloc(sizeof(*uiommu), GFP_KERNEL);
+		if (!uiommu) {
+			uiommu_detach_device(udomain, &pdev->dev);
+			uiommu_put(udomain);
+			ret = -ENOMEM;
+			goto out_lock;
+		}
+		uiommu->udomain = udomain;
+		uiommu->cachec = cachec;
+		uiommu->mm = current->mm;
+#ifdef CONFIG_MMU_NOTIFIER
+		uiommu->mmu_notifier.ops = &vfio_dma_mmu_notifier_ops;
+		ret = mmu_notifier_register(&uiommu->mmu_notifier, uiommu->mm);
+		if (ret)
+			printk(KERN_ERR "%s: mmu_notifier_register failed %d\n",
+				__func__, ret);
+		ret = 0;
+#endif
+		INIT_LIST_HEAD(&uiommu->dm_list);
+		mutex_init(&uiommu->dgate);
+		list_add(&uiommu->next, &vfio_uiommu_list);
+	} else if (uiommu->cachec != cachec || uiommu->mm != current->mm) {
+		uiommu_detach_device(udomain, &pdev->dev);
+		uiommu_put(udomain);
+		ret = -EINVAL;
+		goto out_lock;
+	}
+	uiommu->refcnt++;
+	mutex_unlock(&vfio_uiommu_lock);
+
+	vdev->uiommu = uiommu;
+out_lock:
+	return ret;
 }
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 82fe40c..bb21c0b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -93,27 +93,16 @@ static inline int overlap(int a1, int b1, int a2, int b2)
 static int vfio_open(struct inode *inode, struct file *filep)
 {
 	struct vfio_dev *vdev;
-	struct vfio_listener *listener;
 	int ret = 0;
 
 	mutex_lock(&vfio_minor_lock);
 	vdev = idr_find(&vfio_idr, iminor(inode));
 	mutex_unlock(&vfio_minor_lock);
-	if (!vdev) {
-		ret = -ENODEV;
-		goto out;
-	}
-
-	listener = kzalloc(sizeof(*listener), GFP_KERNEL);
-	if (!listener) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!vdev)
+		return -ENODEV;
 
-	mutex_lock(&vdev->lgate);
-	listener->vdev = vdev;
-	INIT_LIST_HEAD(&listener->dm_list);
-	if (vdev->listeners == 0) {
+	mutex_lock(&vdev->vgate);
+	if (!vdev->refcnt) {
 		u16 cmd;
 		(void) pci_reset_function(vdev->pdev);
 		msleep(100);	/* 100ms for reset recovery */
@@ -125,13 +114,12 @@ static int vfio_open(struct inode *inode, struct file *filep)
 		ret = pci_enable_device(vdev->pdev);
 	}
 	if (!ret) {
-		filep->private_data = listener;
-		vdev->listeners++;
+		vdev->refcnt++;
+		filep->private_data = vdev;
 	}
-	mutex_unlock(&vdev->lgate);
-	if (ret)
-		kfree(listener);
-out:
+
+	mutex_unlock(&vdev->vgate);
+
 	return ret;
 }
 
@@ -157,22 +145,12 @@ static void vfio_disable_pci(struct vfio_dev *vdev)
 
 static int vfio_release(struct inode *inode, struct file *filep)
 {
-	int ret = 0;
-	struct vfio_listener *listener = filep->private_data;
-	struct vfio_dev *vdev = listener->vdev;
-
-	vfio_dma_unmapall(listener);
-	if (listener->mm) {
-#ifdef CONFIG_MMU_NOTIFIER
-		mmu_notifier_unregister(&listener->mmu_notifier, listener->mm);
-#endif
-		listener->mm = NULL;
-	}
+	struct vfio_dev *vdev = filep->private_data;
 
-	mutex_lock(&vdev->lgate);
-	if (--vdev->listeners <= 0) {
+	mutex_lock(&vdev->vgate);
+	if (--vdev->refcnt == 0) {
 		/* we don't need to hold igate here since there are
-		 * no more listeners doing ioctls
+		 * no other users doing ioctls
 		 */
 		if (vdev->ev_msix)
 			vfio_drop_msix(vdev);
@@ -190,20 +168,17 @@ static int vfio_release(struct inode *inode, struct file *filep)
 		kfree(vdev->pci_config_map);
 		vdev->pci_config_map = NULL;
 		vfio_disable_pci(vdev);
-		vfio_domain_unset(listener);
+		vfio_domain_unset(vdev);
 		wake_up(&vdev->dev_idle_q);
 	}
-	mutex_unlock(&vdev->lgate);
-
-	kfree(listener);
-	return ret;
+	mutex_unlock(&vdev->vgate);
+	return 0;
 }
 
 static ssize_t vfio_read(struct file *filep, char __user *buf,
 			size_t count, loff_t *ppos)
 {
-	struct vfio_listener *listener = filep->private_data;
-	struct vfio_dev *vdev = listener->vdev;
+	struct vfio_dev *vdev = filep->private_data;
 	struct pci_dev *pdev = vdev->pdev;
 	u8 pci_space;
 
@@ -214,7 +189,7 @@ static ssize_t vfio_read(struct file *filep, char __user *buf,
 		return vfio_config_readwrite(0, vdev, buf, count, ppos);
 
 	/* no other reads until IOMMU domain set */
-	if (!vdev->udomain)
+	if (!vdev->uiommu)
 		return -EINVAL;
 	if (pci_space > PCI_ROM_RESOURCE)
 		return -EINVAL;
@@ -261,14 +236,13 @@ static int vfio_msix_check(struct vfio_dev *vdev, u64 start, u32 len)
 static ssize_t vfio_write(struct file *filep, const char __user *buf,
 			size_t count, loff_t *ppos)
 {
-	struct vfio_listener *listener = filep->private_data;
-	struct vfio_dev *vdev = listener->vdev;
+	struct vfio_dev *vdev = filep->private_data;
 	struct pci_dev *pdev = vdev->pdev;
 	u8 pci_space;
 	int ret;
 
 	/* no writes until IOMMU domain set */
-	if (!vdev->udomain)
+	if (!vdev->uiommu)
 		return -EINVAL;
 	pci_space = vfio_offset_to_pci_space(*ppos);
 	if (pci_space == VFIO_PCI_CONFIG_RESOURCE)
@@ -294,8 +268,7 @@ static ssize_t vfio_write(struct file *filep, const char __user *buf,
 
 static int vfio_mmap(struct file *filep, struct vm_area_struct *vma)
 {
-	struct vfio_listener *listener = filep->private_data;
-	struct vfio_dev *vdev = listener->vdev;
+	struct vfio_dev *vdev = filep->private_data;
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long requested, actual;
 	int pci_space;
@@ -305,7 +278,7 @@ static int vfio_mmap(struct file *filep, struct vm_area_struct *vma)
 	int ret;
 
 	/* no reads or writes until IOMMU domain set */
-	if (!vdev->udomain)
+	if (!vdev->uiommu)
 		return -EINVAL;
 
 	if (vma->vm_end < vma->vm_start)
@@ -365,8 +338,7 @@ static long vfio_unl_ioctl(struct file *filep,
 			unsigned int cmd,
 			unsigned long arg)
 {
-	struct vfio_listener *listener = filep->private_data;
-	struct vfio_dev *vdev = listener->vdev;
+	struct vfio_dev *vdev = filep->private_data;
 	void __user *uarg = (void __user *)arg;
 	int __user *intargp = (void __user *)arg;
 	struct pci_dev *pdev = vdev->pdev;
@@ -383,7 +355,7 @@ static long vfio_unl_ioctl(struct file *filep,
 	case VFIO_DMA_MAP_IOVA:
 		if (copy_from_user(&dm, uarg, sizeof dm))
 			return -EFAULT;
-		ret = vfio_dma_map_dm(listener, &dm);
+		ret = vfio_dma_map_dm(vdev->uiommu, &dm);
 		if (!ret && copy_to_user(uarg, &dm, sizeof dm))
 			ret = -EFAULT;
 		break;
@@ -391,7 +363,7 @@ static long vfio_unl_ioctl(struct file *filep,
 	case VFIO_DMA_UNMAP:
 		if (copy_from_user(&dm, uarg, sizeof dm))
 			return -EFAULT;
-		ret = vfio_dma_unmap_dm(listener, &dm);
+		ret = vfio_dma_unmap_dm(vdev->uiommu, &dm);
 		break;
 
 	case VFIO_EVENTFD_IRQ:
@@ -473,11 +445,11 @@ static long vfio_unl_ioctl(struct file *filep,
 	case VFIO_DOMAIN_SET:
 		if (get_user(fd, intargp))
 			return -EFAULT;
-		ret = vfio_domain_set(listener, fd, allow_unsafe_intrs);
+		ret = vfio_domain_set(vdev, fd, allow_unsafe_intrs);
 		break;
 
 	case VFIO_DOMAIN_UNSET:
-		ret = vfio_domain_unset(listener);
+		ret = vfio_domain_unset(vdev);
 		break;
 
 	case VFIO_IRQ_EOI:
@@ -635,8 +607,7 @@ static int vfio_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	vdev->pci_2_3 = (verify_pci_2_3(pdev) == 0);
 
-	mutex_init(&vdev->lgate);
-	mutex_init(&vdev->dgate);
+	mutex_init(&vdev->vgate);
 	mutex_init(&vdev->igate);
 	mutex_init(&vdev->ngate);
 	INIT_LIST_HEAD(&vdev->nlc_list);
@@ -686,7 +657,7 @@ static void vfio_remove(struct pci_dev *pdev)
 	ret = vfio_nl_remove(vdev);
 
 	/* wait for all closed */
-	wait_event(vdev->dev_idle_q, vdev->listeners == 0);
+	wait_event(vdev->dev_idle_q, vdev->refcnt == 0);
 
 	pci_disable_device(pdev);
 
@@ -734,7 +705,7 @@ static int vfio_pm_suspend(void)
 		vdev = idr_find(&vfio_idr, id);
 		if (!vdev)
 			continue;
-		if (vdev->listeners == 0)
+		if (vdev->refcnt == 0)
 			continue;
 		alive++;
 		ret = vfio_nl_upcall(vdev, VFIO_MSG_PM_SUSPEND, 0, 0);
@@ -765,7 +736,7 @@ static int vfio_pm_resume(void)
 		vdev = idr_find(&vfio_idr, id);
 		if (!vdev)
 			continue;
-		if (vdev->listeners == 0)
+		if (vdev->refcnt == 0)
 			continue;
 		(void) vfio_nl_upcall(vdev, VFIO_MSG_PM_RESUME, 0, 0);
 	}
diff --git a/drivers/vfio/vfio_netlink.c b/drivers/vfio/vfio_netlink.c
index 7a53e7b..063001e 100644
--- a/drivers/vfio/vfio_netlink.c
+++ b/drivers/vfio/vfio_netlink.c
@@ -272,7 +272,7 @@ static int vfio_nl_pm_suspend_reply(struct sk_buff *skb, struct genl_info *info)
 	vdev = vfio_nl_get_vdev(info);
 	if (!vdev)
 		return -EINVAL;
-	if (vdev->listeners == 0)
+	if (vdev->refcnt == 0)
 		return -EINVAL;
 	vfio_pm_process_reply(value);
 	return 0;
diff --git a/drivers/vfio/vfio_sysfs.c b/drivers/vfio/vfio_sysfs.c
index c6193fd..6b44096 100644
--- a/drivers/vfio/vfio_sysfs.c
+++ b/drivers/vfio/vfio_sysfs.c
@@ -98,7 +98,8 @@ static ssize_t show_locked_pages(struct device *dev,
 
 	if (!vdev)
 		return -ENODEV;
-	return sprintf(buf, "%u\n", vdev->locked_pages);
+	return sprintf(buf, "%u\n", vdev->uiommu ?
+		       vdev->uiommu->locked_pages : 0);
 }
 
 static DEVICE_ATTR(locked_pages, S_IRUGO, show_locked_pages, NULL);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index a8b2405..74c156e 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -42,6 +42,18 @@ struct vfio_nl_client {
 	u32			pid;
 };
 
+struct vfio_uiommu {
+	struct uiommu_domain	*udomain;
+	struct mutex		dgate;		/* dma op gate */
+	struct list_head	dm_list;
+	u32			locked_pages;
+	struct mm_struct	*mm;
+	struct mmu_notifier	mmu_notifier;
+	struct list_head	next;
+	int			refcnt;
+	int			cachec;
+};
+
 struct perm_bits;
 struct eoi_eventfd;
 struct vfio_dev {
@@ -53,10 +65,9 @@ struct vfio_dev {
 	int		devnum;
 	void __iomem	*barmap[PCI_STD_RESOURCE_END+1];
 	spinlock_t	irqlock;	/* guards command register accesses */
-	int		listeners;
-	u32		locked_pages;
-	struct mutex	lgate;		/* listener gate */
-	struct mutex	dgate;		/* dma op gate */
+	struct vfio_uiommu	*uiommu;
+	int		refcnt;
+	struct mutex	vgate;		/* device init/shutdown, refcnt gate */
 	struct mutex	igate;		/* intr op gate */
 	struct mutex	ngate;		/* netlink op gate */
 	struct list_head nlc_list;	/* netlink clients */
@@ -64,7 +75,6 @@ struct vfio_dev {
 	wait_queue_head_t nl_wait_q;
 	u32		nl_reply_seq;
 	u32		nl_reply_value;
-	struct uiommu_domain	*udomain;
 	int			cachec;
 	struct msix_entry	*msix;
 	struct eventfd_ctx	*ev_irq;
@@ -83,13 +93,6 @@ struct vfio_dev {
 	struct eoi_eventfd	*ev_eoi;
 };
 
-struct vfio_listener {
-	struct vfio_dev	*vdev;
-	struct list_head	dm_list;
-	struct mm_struct	*mm;
-	struct mmu_notifier	mmu_notifier;
-};
-
 /*
  * Structure for keeping track of memory nailed down by the
  * user for DMA
@@ -130,11 +133,10 @@ int vfio_setup_msix(struct vfio_dev *, int, int __user *);
 #endif
 
 struct vfio_dma_map;
-void vfio_dma_unmapall(struct vfio_listener *);
-int vfio_dma_unmap_dm(struct vfio_listener *, struct vfio_dma_map *);
-int vfio_dma_map_dm(struct vfio_listener *, struct vfio_dma_map *);
-int vfio_domain_set(struct vfio_listener *, int, int);
-int vfio_domain_unset(struct vfio_listener *);
+int vfio_dma_unmap_dm(struct vfio_uiommu *, struct vfio_dma_map *);
+int vfio_dma_map_dm(struct vfio_uiommu *, struct vfio_dma_map *);
+int vfio_domain_set(struct vfio_dev *, int, int);
+int vfio_domain_unset(struct vfio_dev *);
 
 int vfio_class_init(void);
 void vfio_class_destroy(void);

