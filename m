Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab1EJSHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:07:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab1EJSHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:07:08 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] vfio: Allow sub-ranges to be unmapped
To: pugs@ieee.org
Cc: alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Date: Tue, 10 May 2011 12:06:37 -0600
Message-ID: <20110510172903.9289.99964.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're currently very strict in requiring that DMA unmaps are done
using the exact same regions as used for the original mapping.
In a VM environment, we may want to change sub-areas of a previous
mapping without tearing down the entire region.  This might also
also us to support ballooning or memory hotplug in a guest making
use of a vfio device.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

Tom,

I'm a little confused why we have the list of mapped areas attached
to the listener.  If we want to support multiple devices sharing the same
uiommu, don't we instead need to create a separate object hosting this
list with reference counting so multiple vdevs can point to it?  I would
expect that's where the locked_page accounting would be moved to as well.
There also seems to be support that each vdev could have multiple
listeners, each with their own list of dma mapped areas, but we can
only have one udomain per vdev, which just further confuses me.  Can you
hlp me out?  Thanks,

Alex

Note the change of npage to unsigned long below is just to avoid needing
to cast it every time we do a << PAGE_SHIFT to avoid overflow.

 drivers/vfio/vfio_dma.c  |  486 ++++++++++++++++++++++++++++++++++------------
 drivers/vfio/vfio_main.c |    8 -
 include/linux/vfio.h     |   10 -
 3 files changed, 362 insertions(+), 142 deletions(-)

diff --git a/drivers/vfio/vfio_dma.c b/drivers/vfio/vfio_dma.c
index 4a488b6..bf260e4 100644
--- a/drivers/vfio/vfio_dma.c
+++ b/drivers/vfio/vfio_dma.c
@@ -44,7 +44,7 @@
 
 struct vwork {
 	struct mm_struct *mm;
-	int		npage;
+	unsigned long npage;
 	struct work_struct work;
 };
 
@@ -62,7 +62,7 @@ static void vfio_lock_acct_bg(struct work_struct *work)
 	kfree(vwork);
 }
 
-static void vfio_lock_acct(int npage)
+static void vfio_lock_acct(unsigned long npage)
 {
 	struct vwork *vwork;
 	struct mm_struct *mm;
@@ -97,27 +97,19 @@ static void vfio_lock_acct(int npage)
 
 /* Unmap DMA region */
 /* dgate must be held */
-static void vfio_dma_unmap(struct vfio_listener *listener,
-			struct dma_map_page *mlp)
+static void vfio_dma_unmap(struct vfio_listener *listener, unsigned long iova,
+			   unsigned long npage, struct page **pages, int rdwr)
 {
-	int i;
 	struct vfio_dev *vdev = listener->vdev;
-	int npage;
-
-	list_del(&mlp->list);
-	for (i = 0; i < mlp->npage; i++)
-		(void) uiommu_unmap(vdev->udomain,
-				mlp->daddr + i * PAGE_SIZE, 0);
-	for (i = 0; i < mlp->npage; i++) {
-		if (mlp->rdwr)
-			SetPageDirty(mlp->pages[i]);
-		put_page(mlp->pages[i]);
+	unsigned long i;
+
+	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
+		uiommu_unmap(vdev->udomain, iova, 0);
+		if (rdwr)
+			SetPageDirty(pages[i]);
+		put_page(pages[i]);
 	}
-	vdev->mapcount--;
-	npage = mlp->npage;
-	vdev->locked_pages -= mlp->npage;
-	vfree(mlp->pages);
-	kfree(mlp);
+	vdev->locked_pages -= npage;
 	vfio_lock_acct(-npage);
 }
 
@@ -130,29 +122,210 @@ void vfio_dma_unmapall(struct vfio_listener *listener)
 	mutex_lock(&listener->vdev->dgate);
 	list_for_each_safe(pos, pos2, &listener->dm_list) {
 		mlp = list_entry(pos, struct dma_map_page, list);
-		vfio_dma_unmap(listener, mlp);
+		vfio_dma_unmap(listener, mlp->daddr, mlp->npage,
+			       mlp->pages, mlp->rdwr);
+		list_del(&mlp->list);
+		vfree(mlp->pages);
+		kfree(mlp);
 	}
 	mutex_unlock(&listener->vdev->dgate);
 }
 
+/* Map DMA region */
+/* dgate must be held */
+static int vfio_dma_map(struct vfio_listener *listener, unsigned long iova,
+			unsigned long npage, struct page **pages, int rdwr)
+{
+	struct vfio_dev *vdev = listener->vdev;
+	unsigned long i;
+	int ret;
+
+	/* Verify pages are not already mapped */
+	for (i = 0; i < npage; i++)
+		if (uiommu_iova_to_phys(vdev->udomain, iova + i * PAGE_SIZE))
+			return -EBUSY;
+
+	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
+		ret = uiommu_map(vdev->udomain, iova,
+				 page_to_phys(pages[i]), 0, rdwr);
+		if (!ret)
+			continue;
+
+		/* Back out mappings on error */
+		for (i--, iova -= PAGE_SIZE; i >= 0; i--, iova -= PAGE_SIZE)
+			uiommu_unmap(vdev->udomain, iova, 0);
+		return ret;
+	}
+	vdev->locked_pages += npage;
+	vfio_lock_acct(npage);
+	return 0;
+}
+
+static struct dma_map_page *vfio_find_dma(struct vfio_listener *listener,
+					  dma_addr_t start, size_t size)
+{
+	struct list_head *pos;
+	struct dma_map_page *mlp;
+
+	list_for_each(pos, &listener->dm_list) {
+		mlp = list_entry(pos, struct dma_map_page, list);
+		if (!(mlp->daddr + (mlp->npage << PAGE_SHIFT) <= start ||
+		      mlp->daddr >= start + size))
+			return mlp;
+	}
+	return NULL;
+}
+
+static struct dma_map_page *vfio_find_vaddr(struct vfio_listener *listener,
+					    unsigned long start, size_t size)
+{
+	struct list_head *pos;
+	struct dma_map_page *mlp;
+
+	list_for_each(pos, &listener->dm_list) {
+		mlp = list_entry(pos, struct dma_map_page, list);
+		if (!(mlp->vaddr + (mlp->npage << PAGE_SHIFT) <= start ||
+		      mlp->vaddr >= start + size))
+			return mlp;
+	}
+	return NULL;
+}
+
+int vfio_remove_dma_overlap(struct vfio_listener *listener, dma_addr_t start,
+			    size_t size, struct dma_map_page *mlp,
+			    size_t *remaining)
+{
+	struct dma_map_page *split;
+	struct page **pages_lo, **pages_hi;
+	unsigned long npage_lo, npage_hi;
+
+	/* Existing dma region is completely covered, unmap all */
+	if (start <= mlp->daddr &&
+	    start + size >= mlp->daddr + (mlp->npage << PAGE_SHIFT)) {
+		vfio_dma_unmap(listener, mlp->daddr, mlp->npage,
+			       mlp->pages, mlp->rdwr);
+		list_del(&mlp->list);
+		vfree(mlp->pages);
+		kfree(mlp);
+		if (remaining)
+			*remaining -= mlp->npage << PAGE_SHIFT;
+		return 0;
+	}
+
+	/* Overlap low address of existing range */
+	if (start <= mlp->daddr) {
+		unsigned long overlap;
+
+		overlap = start + size - mlp->daddr;
+		npage_lo = overlap >> PAGE_SHIFT;
+		npage_hi = mlp->npage - npage_lo;
+
+		pages_hi = vmalloc(npage_hi * sizeof(struct page *));
+		if (!pages_hi)
+			return -ENOMEM;
+
+		vfio_dma_unmap(listener, mlp->daddr, npage_lo,
+			       mlp->pages, mlp->rdwr);
+		mlp->daddr += overlap;
+		mlp->vaddr += overlap;
+		mlp->npage -= npage_lo;
+		memcpy(pages_hi, &mlp->pages[npage_lo],
+		       mlp->npage * sizeof(struct page *));
+		vfree(mlp->pages);
+		mlp->pages = pages_hi;
+		if (remaining)
+			*remaining -= overlap;
+		return 0;
+	}
+
+	/* Overlap high address of existing range */
+	if (start + size >= mlp->daddr + (mlp->npage << PAGE_SHIFT)) {
+		unsigned long overlap;
+
+		overlap = mlp->daddr + (mlp->npage << PAGE_SHIFT) - start;
+		npage_hi = overlap >> PAGE_SHIFT;
+		npage_lo = mlp->npage - npage_hi;
+
+		pages_lo = vmalloc(npage_lo * sizeof(struct page *));
+		if (!pages_lo)
+			return -ENOMEM;
+
+		vfio_dma_unmap(listener, start, npage_hi,
+			       &mlp->pages[npage_lo], mlp->rdwr);
+		mlp->npage -= npage_hi;
+		memcpy(pages_lo, mlp->pages,
+		       mlp->npage * sizeof(struct page *));
+		vfree(mlp->pages);
+		mlp->pages = pages_lo;
+		if (remaining)
+			*remaining -= overlap;
+		return 0;
+	}
+
+	/* Split existing */
+	npage_lo = (start - mlp->daddr) >> PAGE_SHIFT;
+	npage_hi = mlp->npage - (size >> PAGE_SHIFT) - npage_lo;
+
+	split = kzalloc(sizeof *split, GFP_KERNEL);
+	if (!split)
+		return -ENOMEM;
+
+	pages_lo = vmalloc(npage_lo * sizeof(struct page *));
+	if (!pages_lo) {
+		kfree(split);
+		return -ENOMEM;
+	}
+
+	pages_hi = vmalloc(npage_hi * sizeof(struct page *));
+	if (!pages_hi) {
+		kfree(split);
+		vfree(pages_lo);
+		return -ENOMEM;
+	}
+
+	vfio_dma_unmap(listener, start, size >> PAGE_SHIFT,
+		       &mlp->pages[npage_lo], mlp->rdwr);
+
+	memcpy(pages_lo, mlp->pages, npage_lo * sizeof(struct page *));
+	memcpy(pages_hi, &mlp->pages[npage_lo + (size >> PAGE_SHIFT)],
+	       npage_hi * sizeof(struct page *));
+
+	vfree(mlp->pages);
+	mlp->npage = npage_lo;
+	mlp->pages = pages_lo;
+
+	split->npage = npage_hi;
+	split->pages = pages_hi;
+	split->daddr = start + size;
+	split->vaddr = mlp->vaddr + (npage_lo << PAGE_SHIFT) + size;
+	split->rdwr = mlp->rdwr;
+	list_add(&split->list, &listener->dm_list);
+	if (remaining)
+		*remaining -= size;
+	return 0;
+}
+
 int vfio_dma_unmap_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
 {
-	int npage;
 	struct dma_map_page *mlp;
-	struct list_head *pos, *pos2;
-	int ret;
+	int ret = 0;
+	size_t size = dmp->size;
+
+	if (dmp->dmaaddr & (PAGE_SIZE-1))
+		return -EINVAL;
+	if (size & (PAGE_SIZE-1))
+		return -EINVAL;
 
-	npage = dmp->size >> PAGE_SHIFT;
+	if (!listener->vdev->udomain)
+		return -EINVAL;
 
-	ret = -ENXIO;
 	mutex_lock(&listener->vdev->dgate);
-	list_for_each_safe(pos, pos2, &listener->dm_list) {
-		mlp = list_entry(pos, struct dma_map_page, list);
-		if (dmp->vaddr != mlp->vaddr || mlp->npage != npage)
-			continue;
-		ret = 0;
-		vfio_dma_unmap(listener, mlp);
-		break;
+	while (size &&
+	       (mlp = vfio_find_dma(listener, dmp->dmaaddr, dmp->size))) {
+		ret = vfio_remove_dma_overlap(listener, dmp->dmaaddr,
+					      dmp->size, mlp, &size);
+		if (ret)
+			break;
 	}
 	mutex_unlock(&listener->vdev->dgate);
 	return ret;
@@ -166,28 +339,30 @@ static void vfio_dma_handle_mmu_notify(struct mmu_notifier *mn,
 		unsigned long start, unsigned long end)
 {
 	struct vfio_listener *listener;
-	unsigned long myend;
-	struct list_head *pos, *pos2;
 	struct dma_map_page *mlp;
 
 	listener = container_of(mn, struct vfio_listener, mmu_notifier);
 	mutex_lock(&listener->vdev->dgate);
-	list_for_each_safe(pos, pos2, &listener->dm_list) {
-		mlp = list_entry(pos, struct dma_map_page, list);
-		if (mlp->vaddr >= end)
-			continue;
-		/*
-		 * Ranges overlap if they're not disjoint; and they're
-		 * disjoint if the end of one is before the start of
-		 * the other one.
-		 */
-		myend = mlp->vaddr + (mlp->npage << PAGE_SHIFT) - 1;
-		if (!(myend <= start || end <= mlp->vaddr)) {
-			printk(KERN_WARNING
-				"%s: demap start %lx end %lx va %lx pa %lx\n",
-				__func__, start, end,
-				mlp->vaddr, (long)mlp->daddr);
-			vfio_dma_unmap(listener, mlp);
+
+	/* vaddrs are not unique (multiple daddrs could be mapped to the
+	 * same vaddr), therefore we have to search to exhaustion rather
+	 * than tracking how much we've unmapped. */
+	while ((mlp = vfio_find_vaddr(listener, start, end - start))) {
+		dma_addr_t dma_start;
+		int ret;
+
+		dma_start = mlp->daddr;
+		if (start < mlp->vaddr)
+			dma_start -= mlp->vaddr - start;
+		else
+			dma_start += start - mlp->vaddr;
+		ret = vfio_remove_dma_overlap(listener, dma_start,
+					      end - start, mlp, NULL);
+		if (ret) {
+			printk(KERN_ERR "%s: "
+			       "failed to unmap mmu notify range "
+			       "%lx - %lx (%d)\n", __func__, start, end, ret);
+			break;
 		}
 	}
 	mutex_unlock(&listener->vdev->dgate);
@@ -211,81 +386,44 @@ static const struct mmu_notifier_ops vfio_dma_mmu_notifier_ops = {
 };
 #endif	/* CONFIG_MMU_NOTIFIER */
 
-/*
- * Map usr buffer at specific IO virtual address
- */
-static struct dma_map_page *vfio_dma_map_iova(
-		struct vfio_listener *listener,
-		unsigned long start_iova,
-		struct page **pages,
-		int npage,
-		int rdwr)
+int vfio_dma_map_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
 {
 	struct vfio_dev *vdev = listener->vdev;
-	int ret;
-	int i;
-	phys_addr_t hpa;
-	struct dma_map_page *mlp;
-	unsigned long iova = start_iova;
-
-	if (!vdev->udomain)
-		return ERR_PTR(-EINVAL);
-
-	for (i = 0; i < npage; i++) {
-		if (uiommu_iova_to_phys(vdev->udomain, iova + i * PAGE_SIZE))
-			return ERR_PTR(-EBUSY);
-	}
-
-	mlp = kzalloc(sizeof *mlp, GFP_KERNEL);
-	if (!mlp)
-		return ERR_PTR(-ENOMEM);
-	rdwr = rdwr ? IOMMU_READ|IOMMU_WRITE : IOMMU_READ;
-	if (vdev->cachec)
-		rdwr |= IOMMU_CACHE;
-	for (i = 0; i < npage; i++) {
-		hpa = page_to_phys(pages[i]);
-		ret = uiommu_map(vdev->udomain, iova, hpa, 0, rdwr);
-		if (ret) {
-			while (--i > 0) {
-				iova -= PAGE_SIZE;
-				(void) uiommu_unmap(vdev->udomain,
-						iova, 0);
-			}
-			kfree(mlp);
-			return ERR_PTR(ret);
-		}
-		iova += PAGE_SIZE;
-	}
-	vdev->mapcount++;
-
-	mlp->pages = pages;
-	mlp->daddr = start_iova;
-	mlp->npage = npage;
-	return mlp;
-}
-
-int vfio_dma_map_common(struct vfio_listener *listener,
-		unsigned int cmd, struct vfio_dma_map *dmp)
-{
 	int locked, lock_limit;
 	struct page **pages;
-	int npage;
-	struct dma_map_page *mlp;
-	int rdwr = (dmp->flags & VFIO_FLAG_WRITE) ? 1 : 0;
+	struct dma_map_page *mlp, *nmlp, *mmlp = NULL;
+	int rdwr = IOMMU_READ;
+	dma_addr_t daddr = dmp->dmaaddr;
+	unsigned long npage, vaddr = dmp->vaddr;
+	size_t size = dmp->size;
 	int ret = 0;
 
-	if (dmp->vaddr & (PAGE_SIZE-1))
+	if (vaddr & (PAGE_SIZE-1))
 		return -EINVAL;
-	if (dmp->dmaaddr & (PAGE_SIZE-1))
+	if (daddr & (PAGE_SIZE-1))
 		return -EINVAL;
-	if (dmp->size & (PAGE_SIZE-1))
+	if (size & (PAGE_SIZE-1))
+		return -EINVAL;
+
+	npage = size >> PAGE_SHIFT;
+	if (!npage)
 		return -EINVAL;
-	if (dmp->size > VFIO_MAX_MAP_SIZE)
+
+	if (!vdev->udomain)
 		return -EINVAL;
-	npage = dmp->size >> PAGE_SHIFT;
+
+	if (dmp->flags & VFIO_FLAG_WRITE)
+		rdwr |= IOMMU_WRITE;
+	if (vdev->cachec)
+		rdwr |= IOMMU_CACHE;
 
 	mutex_lock(&listener->vdev->dgate);
 
+	if (vfio_find_dma(listener, daddr, size)) {
+		ret = -EBUSY;
+		goto out_lock;
+	}
+
 	/* account for locked pages */
 	locked = npage + current->mm->locked_vm;
 	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
@@ -313,47 +451,130 @@ int vfio_dma_map_common(struct vfio_listener *listener,
 #endif
 	}
 
+	/* Allocate a new mlp, this may not be used if we merge, but
+	 * ENOMEM is easier to handle before we do the iova mapping */
+	nmlp = kzalloc(sizeof *nmlp, GFP_KERNEL);
+	if (!nmlp) {
+		ret = -ENOMEM;
+		goto out_lock;
+	}
+
 	pages = vmalloc(npage * sizeof(struct page *));
 	if (!pages) {
+		kfree(nmlp);
 		ret = -ENOMEM;
 		goto out_lock;
 	}
-	ret = get_user_pages_fast(dmp->vaddr, npage, rdwr, pages);
+
+	ret = get_user_pages_fast(vaddr, npage, rdwr & IOMMU_WRITE, pages);
 	if (ret != npage) {
-		printk(KERN_ERR "%s: get_user_pages_fast returns %d, not %d\n",
-			__func__, ret, npage);
+		kfree(nmlp);
 		vfree(pages);
-		ret = -EFAULT;
+		if (ret >= 0) {
+			while (ret)
+				put_page(pages[--ret]);
+			ret = -EAGAIN;
+		}
 		goto out_lock;
 	}
-	ret = 0;
 
-	mlp = vfio_dma_map_iova(listener, dmp->dmaaddr,
-				pages, npage, rdwr);
-	if (IS_ERR(mlp)) {
-		ret = PTR_ERR(mlp);
+	ret = vfio_dma_map(listener, daddr, npage, pages, rdwr);
+	if (ret) {
+		while (npage--)
+			put_page(pages[npage]);
+		kfree(nmlp);
 		vfree(pages);
 		goto out_lock;
 	}
-	mlp->vaddr = dmp->vaddr;
-	mlp->rdwr = rdwr;
-	dmp->dmaaddr = mlp->daddr;
-	list_add(&mlp->list, &listener->dm_list);
 
-	vfio_lock_acct(npage);
-	listener->vdev->locked_pages += npage;
+	/* Check if we abut a region below */
+	if (daddr) {
+		mlp = vfio_find_dma(listener, daddr - 1, 1);
+		if (mlp && mlp->rdwr == rdwr &&
+		    mlp->vaddr + (mlp->npage << PAGE_SHIFT) == vaddr) {
+			struct page **mpages;
+
+			mpages = vmalloc((mlp->npage + npage) *
+					 sizeof(struct page *));
+			if (!mpages)
+				goto no_merge;
+
+			memcpy(mpages, mlp->pages,
+			       mlp->npage * sizeof(struct page *));
+			memcpy(&mpages[mlp->npage], pages,
+			       npage * sizeof(struct page *));
+
+			vfree(mlp->pages);
+			vfree(pages);
+
+			mlp->pages = mpages;
+			mlp->npage += npage;
+
+			daddr = mlp->daddr;
+			vaddr = mlp->vaddr;
+			npage = mlp->npage;
+			size = npage << PAGE_SHIFT;
+			pages = mlp->pages;
+
+			mmlp = mlp;
+		}
+	}
+
+	if (daddr + size) {
+		mlp = vfio_find_dma(listener, daddr + size, 1);
+		if (mlp && mlp->rdwr == rdwr && mlp->vaddr == vaddr + size) {
+			struct page **mpages;
+
+			mpages = vmalloc((mlp->npage + npage) *
+					 sizeof(struct page *));
+			if (!mpages)
+				goto no_merge;
+
+			memcpy(mpages, pages,
+			       npage * sizeof(struct page *));
+			memcpy(&mpages[npage], mlp->pages,
+			       mlp->npage * sizeof(struct page *));
+
+			vfree(mlp->pages);
+			vfree(pages);
+
+			mlp->pages = mpages;
+			mlp->npage += npage;
+			mlp->daddr = daddr;
+			mlp->vaddr = vaddr;
+
+			if (mmlp) {
+				list_del(&mmlp->list);
+				kfree(mmlp);
+			}
+			mmlp = mlp;
+		}
+	}
+
+no_merge:
+	if (!mmlp) {
+		nmlp->pages = pages;
+		nmlp->npage = npage;
+		nmlp->daddr = daddr;
+		nmlp->vaddr = vaddr;
+		nmlp->rdwr = rdwr;
+		list_add(&nmlp->list, &listener->dm_list);
+	} else
+		kfree(nmlp);
+
 out_lock:
 	mutex_unlock(&listener->vdev->dgate);
 	return ret;
 }
 
-int vfio_domain_unset(struct vfio_dev *vdev)
+int vfio_domain_unset(struct vfio_listener *listener)
 {
+	struct vfio_dev *vdev = listener->vdev;
 	struct pci_dev *pdev = vdev->pdev;
 
 	if (!vdev->udomain)
 		return 0;
-	if (vdev->mapcount)
+	if (!list_empty(&listener->dm_list))
 		return -EBUSY;
 	uiommu_detach_device(vdev->udomain, &pdev->dev);
 	uiommu_put(vdev->udomain);
@@ -361,8 +582,9 @@ int vfio_domain_unset(struct vfio_dev *vdev)
 	return 0;
 }
 
-int vfio_domain_set(struct vfio_dev *vdev, int fd, int unsafe_ok)
+int vfio_domain_set(struct vfio_listener *listener, int fd, int unsafe_ok)
 {
+	struct vfio_dev *vdev = listener->vdev;
 	struct uiommu_domain *udomain;
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -385,7 +607,7 @@ int vfio_domain_set(struct vfio_dev *vdev, int fd, int unsafe_ok)
 		return -EINVAL;
 	}
 
-	vfio_domain_unset(vdev);
+	vfio_domain_unset(listener);
 	ret = uiommu_attach_device(udomain, &pdev->dev);
 	if (ret) {
 		printk(KERN_ERR "%s: attach_device failed %d\n",
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index b9bb692..82fe40c 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -190,7 +190,7 @@ static int vfio_release(struct inode *inode, struct file *filep)
 		kfree(vdev->pci_config_map);
 		vdev->pci_config_map = NULL;
 		vfio_disable_pci(vdev);
-		vfio_domain_unset(vdev);
+		vfio_domain_unset(listener);
 		wake_up(&vdev->dev_idle_q);
 	}
 	mutex_unlock(&vdev->lgate);
@@ -383,7 +383,7 @@ static long vfio_unl_ioctl(struct file *filep,
 	case VFIO_DMA_MAP_IOVA:
 		if (copy_from_user(&dm, uarg, sizeof dm))
 			return -EFAULT;
-		ret = vfio_dma_map_common(listener, cmd, &dm);
+		ret = vfio_dma_map_dm(listener, &dm);
 		if (!ret && copy_to_user(uarg, &dm, sizeof dm))
 			ret = -EFAULT;
 		break;
@@ -473,11 +473,11 @@ static long vfio_unl_ioctl(struct file *filep,
 	case VFIO_DOMAIN_SET:
 		if (get_user(fd, intargp))
 			return -EFAULT;
-		ret = vfio_domain_set(vdev, fd, allow_unsafe_intrs);
+		ret = vfio_domain_set(listener, fd, allow_unsafe_intrs);
 		break;
 
 	case VFIO_DOMAIN_UNSET:
-		ret = vfio_domain_unset(vdev);
+		ret = vfio_domain_unset(listener);
 		break;
 
 	case VFIO_IRQ_EOI:
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 47d9bb9..a8b2405 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -64,7 +64,6 @@ struct vfio_dev {
 	wait_queue_head_t nl_wait_q;
 	u32		nl_reply_seq;
 	u32		nl_reply_value;
-	int		mapcount;
 	struct uiommu_domain	*udomain;
 	int			cachec;
 	struct msix_entry	*msix;
@@ -100,7 +99,7 @@ struct dma_map_page {
 	struct page     **pages;
 	dma_addr_t      daddr;
 	unsigned long	vaddr;
-	int		npage;
+	unsigned long	npage;
 	int		rdwr;
 };
 
@@ -133,10 +132,9 @@ int vfio_setup_msix(struct vfio_dev *, int, int __user *);
 struct vfio_dma_map;
 void vfio_dma_unmapall(struct vfio_listener *);
 int vfio_dma_unmap_dm(struct vfio_listener *, struct vfio_dma_map *);
-int vfio_dma_map_common(struct vfio_listener *, unsigned int,
-			struct vfio_dma_map *);
-int vfio_domain_set(struct vfio_dev *, int, int);
-int vfio_domain_unset(struct vfio_dev *);
+int vfio_dma_map_dm(struct vfio_listener *, struct vfio_dma_map *);
+int vfio_domain_set(struct vfio_listener *, int, int);
+int vfio_domain_unset(struct vfio_listener *);
 
 int vfio_class_init(void);
 void vfio_class_destroy(void);

