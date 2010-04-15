Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab0DOU6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 16:58:17 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:21391 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab0DOU6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 16:58:15 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAMax0urR7Hu/2dsb2JhbACbbXGlFJooglwSCIIYBIMp
X-IronPort-AV: E=Sophos;i="4.52,214,1270425600"; 
   d="scan'208";a="115979435"
Date: Thu, 15 Apr 2010 13:55:29 -0700
From: "Tom Lyon" <pugs@cisco.com>
To: mst@redhat.com, hjk@linutronix.de, gregkh@suse.de, chrisw@sous-sol.org,
       joro@8bytes.org, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH V2] drivers/uio/uio.c: DMA mapping, interrupt extensions,
 etc.
Message-ID: <4bc77d41.njZFTBp9Nkn93l72%pugs@cisco.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second of 2 related, but independent, patches. This is for 
uio.c, the previous is for uio_pci_generic.c.

The 2 patches were previously one large patch. Changes for this version:
- uio_pci_generic.c just gets extensions so that a single fd can be used
  by non-privileged processes for interrupt control and mmaps
- All of the DMA and IOMMU related stuff move to uio.c; no longer a need
  to pass ioctls to individual uio drivers. It turns out that the code 
  is not PCI specific anyways.
- A new ioctl to pin DMA buffers to certain IO virtual addresses for KVM.
- New eventfd based interrupt notifications, including support for PCI
  specific MSI and MSI-X interrupts.
- PCI specific code to reset PCI functions before and after use

diff -ruNP linux-2.6.33/drivers/uio/uio.c uio-2.6.33/drivers/uio/uio.c
--- linux-2.6.33/drivers/uio/uio.c	2010-02-24 10:52:17.000000000 -0800
+++ uio-2.6.33/drivers/uio/uio.c	2010-04-15 12:39:02.000000000 -0700
@@ -23,6 +23,11 @@
 #include <linux/string.h>
 #include <linux/kobject.h>
 #include <linux/uio_driver.h>
+#include <linux/mmu_notifier.h>
+#include <linux/pci.h>
+#include <linux/iommu.h>
+#include <linux/eventfd.h>
+#include <linux/semaphore.h>
 
 #define UIO_MAX_DEVICES 255
 
@@ -37,8 +42,37 @@
 	struct uio_info		*info;
 	struct kobject		*map_dir;
 	struct kobject		*portio_dir;
+	struct pci_dev		*pdev;
+	int			pmaster;
+	struct semaphore	gate;
+	int			listeners;
+	atomic_t		mapcount;
+	struct msix_entry	*msix;
+	int			nvec;
+	struct iommu_domain	*domain;
+	int			cachec;
+	struct eventfd_ctx	*ev_irq;
+	struct eventfd_ctx	*ev_msi;
+	struct eventfd_ctx	**ev_msix;
 };
 
+/*
+ * Structure for keeping track of memory nailed down by the
+ * user for DMA
+ */
+struct dma_map_page {
+        struct list_head list;
+        struct page     **pages;
+	struct scatterlist *sg;
+        dma_addr_t      daddr;
+	unsigned long	vaddr;
+	int		npage;
+	int		rdwr;
+};
+
+static void uio_disable_msi(struct uio_device *);
+static void uio_disable_msix(struct uio_device *);
+
 static int uio_major;
 static DEFINE_IDR(uio_idr);
 static const struct file_operations uio_fops;
@@ -440,17 +474,38 @@
 	struct uio_device *idev = (struct uio_device *)dev_id;
 	irqreturn_t ret = idev->info->handler(irq, idev->info);
 
-	if (ret == IRQ_HANDLED)
+	if (ret != IRQ_HANDLED)
+		return ret;
+	if (idev->ev_irq)
+		eventfd_signal(idev->ev_irq, 1);
+	else
 		uio_event_notify(idev->info);
 
 	return ret;
 }
 
+/*
+ * MSI and MSI-X Interrupt handler.
+ * Just record an event
+ */
+static irqreturn_t msihandler(int irq, void *arg)
+{
+	struct eventfd_ctx *ctx = arg;
+
+	eventfd_signal(ctx, 1);
+	return IRQ_HANDLED;
+}
+
 struct uio_listener {
 	struct uio_device *dev;
 	s32 event_count;
+	struct mm_struct	*mm;
+	struct mmu_notifier	mmu_notifier;
+	struct list_head	dm_list;
 };
 
+static void uio_dma_unmapall(struct uio_listener *);
+
 static int uio_open(struct inode *inode, struct file *filep)
 {
 	struct uio_device *idev;
@@ -470,7 +525,7 @@
 		goto out;
 	}
 
-	listener = kmalloc(sizeof(*listener), GFP_KERNEL);
+	listener = kzalloc(sizeof(*listener), GFP_KERNEL);
 	if (!listener) {
 		ret = -ENOMEM;
 		goto err_alloc_listener;
@@ -478,8 +533,22 @@
 
 	listener->dev = idev;
 	listener->event_count = atomic_read(&idev->event);
+	INIT_LIST_HEAD(&listener->dm_list);
 	filep->private_data = listener;
 
+	down(&idev->gate);
+	if (idev->listeners == 0) {		/* first open */
+		if (idev->pmaster && !iommu_found() && !capable(CAP_SYS_RAWIO)) {
+			up(&idev->gate);
+			return -EPERM;
+		}
+		/* reset to known state if we can */
+		if (idev->pdev)
+			(void) pci_reset_function(idev->pdev);
+	}
+	idev->listeners++;
+	up(&idev->gate);
+
 	if (idev->info->open) {
 		ret = idev->info->open(idev->info, inode);
 		if (ret)
@@ -514,6 +583,34 @@
 	if (idev->info->release)
 		ret = idev->info->release(idev->info, inode);
 
+	uio_dma_unmapall(listener);
+	if (listener->mm) {
+		mmu_notifier_unregister(&listener->mmu_notifier, listener->mm);
+		listener->mm = NULL;
+	}
+
+	down(&idev->gate);
+	if (--idev->listeners <= 0) {
+		if (idev->msix) {
+			uio_disable_msix(idev);
+		}
+		if (idev->ev_msi) {
+			uio_disable_msi(idev);
+		}
+		if (idev->ev_irq) {
+			eventfd_ctx_put(idev->ev_msi);
+			idev->ev_irq = NULL;
+		}
+		if (idev->domain) {
+			iommu_domain_free(idev->domain);
+			idev->domain = NULL;
+		}
+		/* reset to known state if we can */
+		if (idev->pdev)
+			(void) pci_reset_function(idev->pdev);
+	}
+	up(&idev->gate);
+
 	module_put(idev->owner);
 	kfree(listener);
 	return ret;
@@ -730,12 +827,510 @@
 	}
 }
 
+/* Unmap DMA region */
+static void uio_dma_unmap(struct uio_listener *listener,
+			struct dma_map_page *mlp)
+{
+	int i;
+	struct uio_device *idev = listener->dev;
+
+	list_del(&mlp->list);
+	if (mlp->sg) {
+		dma_unmap_sg(idev->dev->parent, mlp->sg, mlp->npage, DMA_BIDIRECTIONAL);
+		kfree(mlp->sg);
+	} else {
+		for (i=0; i<mlp->npage; i++)
+			(void) iommu_unmap_range(idev->domain,
+					mlp->daddr + i*PAGE_SIZE, PAGE_SIZE);
+	}
+	for (i=0; i<mlp->npage; i++) {
+		if (mlp->rdwr)
+			SetPageDirty(mlp->pages[i]);
+		put_page(mlp->pages[i]);
+	}
+	listener->mm->locked_vm -= mlp->npage;
+	kfree(mlp->pages);
+	kfree(mlp);
+	atomic_dec(&idev->mapcount);
+}
+
+/* Unmap ALL DMA regions */
+static void uio_dma_unmapall(struct uio_listener *listener)
+{
+        struct list_head *pos, *pos2;
+        struct dma_map_page *mlp;
+
+        list_for_each_safe(pos, pos2, &listener->dm_list) {
+                mlp = list_entry(pos, struct dma_map_page, list);
+		uio_dma_unmap(listener, mlp);
+        }
+}
+
+int uio_dma_unmap_dm(struct uio_listener *listener, struct uio_dma_map *dmp)
+{
+	unsigned long start, npage;
+	struct dma_map_page *mlp;
+        struct list_head *pos, *pos2;
+	int ret;
+
+	start = dmp->vaddr & ~PAGE_SIZE;
+	npage = dmp->size >> PAGE_SHIFT;
+
+	ret = -ENXIO;
+	list_for_each_safe(pos, pos2, &listener->dm_list) {
+		mlp = list_entry(pos, struct dma_map_page, list);
+		if (dmp->vaddr != mlp->vaddr || mlp->npage != npage)
+			continue;
+		ret = 0;
+		uio_dma_unmap(listener, mlp);
+		break;
+	}
+	return ret;
+}
+
+/* Handle MMU notifications - user process freed or realloced memory
+ * which may be in use in a DMA region. Clean up region if so.
+ */
+static void uio_dma_handle_mmu_notify(struct mmu_notifier *mn,
+		unsigned long start, unsigned long end)
+{
+	struct uio_listener *listener;
+	unsigned long myend;
+        struct list_head *pos, *pos2;
+        struct dma_map_page *mlp;
+
+	listener = container_of(mn, struct uio_listener, mmu_notifier);
+	list_for_each_safe(pos, pos2, &listener->dm_list) {
+		mlp = list_entry(pos, struct dma_map_page, list);
+		if (mlp->vaddr >= end)
+			continue;
+		/*
+		 * Ranges overlap if they're not disjoint; and they're
+		 * disjoint if the end of one is before the start of
+		 * the other one.
+		 */
+		myend = mlp->vaddr + (mlp->npage << PAGE_SHIFT) - 1;
+		if (!(myend <= start || end <= mlp->vaddr)) {
+			printk(KERN_WARNING
+				"%s: demap start %lx end %lx va %lx pa %lx\n",
+				__func__, start, end, mlp->vaddr, (long)mlp->daddr);
+			uio_dma_unmap(listener, mlp);
+		}
+	}
+}
+
+static void uio_dma_inval_page(struct mmu_notifier *mn,
+		struct mm_struct *mm, unsigned long addr)
+{
+	uio_dma_handle_mmu_notify(mn, addr, addr + PAGE_SIZE);
+}
+
+static void uio_dma_inval_range_start(struct mmu_notifier *mn,
+		struct mm_struct *mm, unsigned long start, unsigned long end)
+{
+	uio_dma_handle_mmu_notify(mn, start, end);
+}
+
+static const struct mmu_notifier_ops uio_dma_mmu_notifier_ops = {
+	.invalidate_page = uio_dma_inval_page,
+	.invalidate_range_start = uio_dma_inval_range_start,
+};
+
+static int uio_dma_map_iova(
+		struct uio_listener *listener,
+		unsigned long start_iova,
+		struct page **pages,
+		int npage,
+		int rdwr,
+		struct dma_map_page **mlpp)
+{
+	struct uio_device *idev = listener->dev;
+	int ret;
+	int i;
+	phys_addr_t hpa;
+	struct dma_map_page *mlp;
+	unsigned long iova = start_iova;
+
+	if (idev->domain == NULL) {
+		if (!list_empty(&listener->dm_list))	/* no mix with anywhere */
+			return -EINVAL;
+		if (!iommu_found())
+			return -EINVAL;
+		idev->domain = iommu_domain_alloc();
+		if (idev->domain == NULL)
+			return -ENXIO;
+		idev->cachec = iommu_domain_has_cap(idev->domain,
+					IOMMU_CAP_CACHE_COHERENCY);
+		ret = iommu_attach_device(idev->domain, idev->dev->parent);
+		if (ret) {
+			iommu_domain_free(idev->domain);
+			idev->domain = NULL;
+			printk(KERN_ERR "%s: device_attach failed %d\n", __func__, ret);
+			return ret;
+		}
+	}
+	for (i=0; i<npage; i++) {
+		if (iommu_iova_to_phys(idev->domain, iova + i*PAGE_SIZE))
+			return -EBUSY;
+	}
+	rdwr = rdwr ? IOMMU_READ|IOMMU_WRITE : IOMMU_READ;
+	if (idev->cachec) rdwr |= IOMMU_CACHE;
+	for (i=0; i<npage; i++) {
+		hpa = page_to_phys(pages[i]);
+		ret = iommu_map_range(idev->domain, iova, 
+			hpa, PAGE_SIZE, rdwr);
+		if (ret) {
+			while (--i > 0) {
+				iova -= PAGE_SIZE;
+				(void) iommu_unmap_range(idev->domain, iova, PAGE_SIZE);
+			}
+			return ret;
+		}
+		iova += PAGE_SIZE;
+	} 
+
+	mlp = kzalloc(sizeof *mlp, GFP_KERNEL);
+	mlp->pages = pages;
+	mlp->daddr = start_iova;
+	mlp->npage = npage;
+	*mlpp = mlp;
+	atomic_inc(&idev->mapcount);
+	return 0;
+}
+
+static int uio_dma_map_anywhere(
+		struct uio_listener *listener,
+		struct page **pages,
+		int npage,
+		int rdwr,
+		struct dma_map_page **mlpp)
+{
+	struct uio_device *idev = listener->dev;
+	struct scatterlist *sg, *nsg;
+	int i, nents;
+	struct dma_map_page *mlp;
+	unsigned long length;
+
+	if (idev->domain) {
+		/* map anywhere and map iova don't mix */
+		if (atomic_read(&idev->mapcount) == 0) {
+			iommu_domain_free(idev->domain);
+			idev->domain = NULL;
+		} else
+			return -EINVAL;
+	}
+	sg = kzalloc(npage * sizeof(struct scatterlist), GFP_KERNEL);
+	if (sg == NULL)
+		return -ENOMEM;
+	for (i=0; i<npage; i++) {
+		sg_set_page(&sg[i], pages[i], PAGE_SIZE, 0);
+	}
+	nents = dma_map_sg(idev->dev->parent, sg, npage,
+			rdwr ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
+	/* The API for dma_map_sg suggests that it may squash together
+	 * adjacent pages, but noone seems to really do that. So we squash 
+	 * it ourselves, because the user level wants a single buffer.
+	 * This works if (a) there is an iommu, or (b) the user allocates 
+	 * large buffers from a huge page
+	 */
+	nsg = sg;
+	for (i=1; i<nents; i++) {
+		length = sg[i].dma_length;
+		sg[i].dma_length = 0;
+		if (sg[i].dma_address == (nsg->dma_address + nsg->dma_length)) {
+			nsg->dma_length += length;
+		} else {
+			nsg++;
+			nsg->dma_address = sg[i].dma_address;
+			nsg->dma_length = length;
+		}
+	}
+	nents = 1 + (nsg - sg);
+	if (nents != 1) {
+		if (nents > 0)
+			dma_unmap_sg(idev->dev->parent, sg, npage, DMA_BIDIRECTIONAL);
+		for (i=0; i<npage; i++)
+			put_page(pages[i]);
+		kfree(sg);
+		printk(KERN_ERR "%s: sequential dma mapping failed\n", __func__);
+		return -EFAULT;
+	}
+
+	mlp = kzalloc(sizeof *mlp, GFP_KERNEL);
+	mlp->pages = pages;
+	mlp->sg = sg;
+	mlp->daddr = sg_dma_address(sg);
+	mlp->npage = npage;
+	*mlpp = mlp;
+	atomic_inc(&idev->mapcount);
+	return 0;
+}
+
+static int uio_dma_map_common(struct uio_listener *listener,
+		unsigned int cmd, struct uio_dma_map *dmp)
+{
+	int locked, lock_limit;
+	struct page **pages;
+	int npage;
+	struct dma_map_page *mlp = NULL;
+	int ret=0;
+
+	if (dmp->vaddr & (PAGE_SIZE-1))
+		return -EINVAL;
+	if (dmp->size & (PAGE_SIZE-1))
+		return -EINVAL;
+	if (dmp->size <= 0)
+		return -EINVAL;
+	npage = dmp->size >> PAGE_SHIFT;
+
+	/* account for locked pages */
+	locked = npage + current->mm->locked_vm;
+	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+		printk(KERN_WARNING "%s: RLIMIT_MEMLOCK exceeded\n",
+			__func__);
+		return -ENOMEM;
+	}
+	/* only 1 address space per fd */
+	if (current->mm != listener->mm) {
+		if (listener->mm != NULL)
+			return -EINVAL;
+		listener->mm = current->mm;
+		listener->mmu_notifier.ops = &uio_dma_mmu_notifier_ops;
+		ret = mmu_notifier_register(&listener->mmu_notifier,
+						listener->mm);
+		if (ret)
+			printk(KERN_ERR "%s: mmu_notifier_register failed %d\n",
+				__func__, ret);
+	}
+
+	pages = kzalloc(npage * sizeof(struct page *), GFP_KERNEL);
+	if (pages == NULL)
+		return -ENOMEM;
+	ret = get_user_pages_fast(dmp->vaddr, npage, dmp->rdwr, pages);
+	if (ret != npage) {
+		printk(KERN_ERR "%s: get_user_pages_fast returns %d, not %d\n",
+			__func__, ret, npage);
+		kfree(pages);
+		return -EFAULT;
+	}
+
+	if (cmd == UIO_DMA_MAP_IOVA)
+		ret = uio_dma_map_iova(listener, dmp->dmaaddr,
+				pages, npage, dmp->rdwr, &mlp);
+	else
+		ret = uio_dma_map_anywhere(listener, pages,
+				npage, dmp->rdwr, &mlp);
+	if (ret) {
+		kfree(pages);
+		return ret;
+	}
+	mlp->vaddr = dmp->vaddr;
+	mlp->rdwr = dmp->rdwr;
+	dmp->dmaaddr = mlp->daddr;
+	list_add(&mlp->list, &listener->dm_list);
+
+	current->mm->locked_vm += npage;
+	return 0;
+}
+
+static void uio_disable_msi(struct uio_device *idev)
+{
+	struct pci_dev *pdev = idev->pdev;
+
+	if (!pdev)		/* pci specific */
+		return;
+	if (idev->ev_msi) {
+		eventfd_ctx_put(idev->ev_msi);
+		free_irq(pdev->irq, idev->ev_msi);
+		idev->ev_msi = NULL;
+	}
+	pci_disable_msi(pdev);
+}
+
+static int uio_enable_msi(struct uio_device *idev, int fd)
+{
+	struct pci_dev *pdev = idev->pdev;
+	int ret;
+
+	if (!pdev)		/* pci specific */
+		return -EINVAL;
+	idev->ev_msi = eventfd_ctx_fdget(fd);
+	if (idev->ev_msi == NULL)
+		return -EINVAL;
+	pci_enable_msi(pdev);
+	ret = request_irq(pdev->irq, msihandler, 0,
+			idev->info->name, idev->ev_msi);
+	if (ret) {
+		eventfd_ctx_put(idev->ev_msi);
+		pci_disable_msi(pdev);
+		idev->ev_msi = NULL;
+	}
+	return ret;
+}
+
+static void uio_disable_msix(struct uio_device *idev)
+{
+	struct pci_dev *pdev = idev->pdev;
+	int i;
+
+	if (!pdev)		/* pci specific */
+		return;
+	if (idev->ev_msix && idev->msix) {
+		for (i=0; i<idev->nvec; i++) {
+			free_irq(idev->msix[i].vector, idev->ev_msix[i]);
+			eventfd_ctx_put(idev->ev_msix[i]);
+		}
+	}
+	if (idev->ev_msix) {
+		kfree(idev->ev_msix);
+		idev->ev_msix = NULL;
+	}
+	if (idev->msix) {
+		kfree(idev->msix);
+		idev->msix = NULL;
+	}
+	idev->nvec = 0;
+	pci_disable_msix(pdev);
+}
+
+static int uio_enable_msix(struct uio_device *idev, int nvec, void __user *uarg)
+{
+	struct pci_dev *pdev = idev->pdev;
+	struct eventfd_ctx *ctx;
+	int ret = 0;
+	int i;
+	int fd;
+
+	if (!pdev)		/* pci specific */
+		return -EINVAL;
+	idev->msix = kzalloc(nvec * sizeof(struct msix_entry), GFP_KERNEL);
+	idev->ev_msix = kzalloc(nvec * sizeof(struct eventfd_ctx *), GFP_KERNEL);
+	if (idev->msix == NULL || idev->ev_msix == NULL)
+		ret = -ENOMEM;
+	else {
+		for (i=0; i<nvec; i++) {
+			if (copy_from_user(&fd, uarg, sizeof fd)) {
+				ret = -EFAULT;
+				break;
+			}
+			uarg += sizeof fd;
+			ctx = eventfd_ctx_fdget(fd);
+			if (ctx == NULL) {
+				ret = -EINVAL;
+				break;
+			}
+			idev->msix[i].entry = i;
+			idev->ev_msix[i] = ctx;
+		}
+	}
+	if (!ret)
+		ret = pci_enable_msix(pdev, idev->msix, nvec);
+	idev->nvec = 0;
+	for (i=0; i<nvec && !ret; i++) {
+		ret = request_irq(idev->msix[i].vector, msihandler, 0,
+			idev->info->name, idev->ev_msix[i]);
+		if (ret)
+			break;
+		idev->nvec = i+1;
+	}
+	if (ret)
+		uio_disable_msix(idev);
+	return ret;
+}
+
+static int uio_ioctl(struct inode *inode, struct file *filep,
+			unsigned int cmd, unsigned long arg) 
+{
+	struct uio_listener *listener = filep->private_data;
+	struct uio_device *idev = listener->dev;
+	void __user *uarg = (void __user *)arg;
+	struct pci_dev *pdev = idev->pdev;
+	struct uio_dma_map dm;
+	int ret = 0;
+	u64 mask;
+	int fd, nfd;
+
+	if (idev == NULL || idev->info == NULL)
+		return -EINVAL;
+
+	switch(cmd) {
+
+	case UIO_DMA_MAP_ANYWHERE:
+	case UIO_DMA_MAP_IOVA:
+		if (copy_from_user(&dm, uarg, sizeof dm))
+                        return -EFAULT;
+		ret = uio_dma_map_common(listener, cmd, &dm);
+		if (!ret && copy_to_user(uarg, &dm, sizeof dm))
+			ret = -EFAULT;
+		break;
+
+	case UIO_DMA_UNMAP:
+		if (copy_from_user(&dm, uarg, sizeof dm))
+			return -EFAULT;
+		ret = uio_dma_unmap_dm(listener, &dm);
+		break;
+
+	case UIO_DMA_MASK:	/* set master mode and DMA mask */
+                if (copy_from_user(&mask, uarg, sizeof mask))
+                        return -EFAULT;
+		if (pdev) {
+			pci_set_master(pdev);
+			ret = pci_set_dma_mask(pdev, mask);
+		} else {
+			ret = dma_set_mask(idev->dev->parent, mask);
+		}
+		break;
+
+	case UIO_EVENTFD_IRQ:
+                if (copy_from_user(&fd, uarg, sizeof fd))
+                        return -EFAULT;
+		if (idev->ev_irq)
+			eventfd_ctx_put(idev->ev_irq);
+		if (fd >= 0) {
+			idev->ev_irq = eventfd_ctx_fdget(fd);
+			if (idev->ev_irq == NULL)
+				ret = -EINVAL;
+		}
+		break;
+
+	case UIO_EVENTFD_MSI:
+		if (copy_from_user(&fd, uarg, sizeof fd))
+			return -EFAULT;
+		if (fd >= 0 && idev->ev_msi == NULL && idev->ev_msix == NULL) {
+			ret = uio_enable_msi(idev, fd);
+		} else if (fd < 0 && idev->ev_msi) {
+			uio_disable_msi(idev);
+		} else
+			ret = -EINVAL;
+		break;
+
+	case UIO_EVENTFDS_MSIX:
+		if (copy_from_user(&nfd, uarg, sizeof nfd))
+			return -EFAULT;
+		uarg += sizeof nfd;
+		if (nfd > 0 && idev->ev_msi == NULL && idev->ev_msix == NULL) 
+			ret = uio_enable_msix(idev, nfd, uarg);
+		else if (nfd == 0 && idev->ev_msix)
+			uio_disable_msix(idev);
+		else {
+			ret = -EINVAL;
+		}
+		break;
+
+	default:
+		return -EINVAL;
+	}
+	return ret;
+}
+
 static const struct file_operations uio_fops = {
 	.owner		= THIS_MODULE,
 	.open		= uio_open,
 	.release	= uio_release,
 	.read		= uio_read,
 	.write		= uio_write,
+	.ioctl		= uio_ioctl,
 	.mmap		= uio_mmap,
 	.poll		= uio_poll,
 	.fasync		= uio_fasync,
@@ -836,6 +1431,7 @@
 		ret = -ENOMEM;
 		goto err_kzalloc;
 	}
+	init_MUTEX(&idev->gate);
 
 	idev->owner = owner;
 	idev->info = info;
@@ -861,6 +1457,22 @@
 
 	info->uio_dev = idev;
 
+	/* See if we have a PCI device */
+	if (parent->bus == &pci_bus_type) {
+		u16 old_cmd, cmd;
+		struct pci_dev *pdev = to_pci_dev(parent);
+
+		idev->pdev = pdev;
+		/* see if its a master */
+		pci_read_config_word(pdev, PCI_COMMAND, &old_cmd);
+		cmd = old_cmd | PCI_COMMAND_MASTER;
+		pci_write_config_word(pdev, PCI_COMMAND, cmd);
+		pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+		pci_write_config_word(pdev, PCI_COMMAND, old_cmd);
+		if (cmd & PCI_COMMAND_MASTER)
+			idev->pmaster = 1;
+	}
+
 	if (idev->info->irq >= 0) {
 		ret = request_irq(idev->info->irq, uio_interrupt,
 				  idev->info->irq_flags, idev->info->name, idev);
diff -ruNP linux-2.6.33/include/linux/uio_driver.h uio-2.6.33/include/linux/uio_driver.h
--- linux-2.6.33/include/linux/uio_driver.h	2010-02-24 10:52:17.000000000 -0800
+++ uio-2.6.33/include/linux/uio_driver.h	2010-04-14 15:42:57.000000000 -0700
@@ -14,8 +14,12 @@
 #ifndef _UIO_DRIVER_H_
 #define _UIO_DRIVER_H_
 
-#include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/ioctl.h>
+
+#ifdef __KERNEL__
+
+#include <linux/module.h>
 #include <linux/interrupt.h>
 
 struct uio_map;
@@ -122,4 +126,23 @@
 #define UIO_PORT_GPIO	2
 #define UIO_PORT_OTHER	3
 
+#endif	/* __KERNEL__ */
+
+// Kernel & User level defines for ioctls
+
+struct uio_dma_map {
+	unsigned long	vaddr;
+	unsigned long long dmaaddr;
+	int	size;
+	int	rdwr;
+};
+
+#define	UIO_DMA_MAP_ANYWHERE	_IOWR(';', 100, struct uio_dma_map)
+#define	UIO_DMA_MAP_IOVA	_IOWR(';', 101, struct uio_dma_map)
+#define	UIO_DMA_UNMAP		_IOW(';', 102, struct uio_dma_map)
+#define	UIO_DMA_MASK		_IOW(';', 103, unsigned long long)
+#define	UIO_EVENTFD_IRQ		_IOW(';', 104, int)
+#define	UIO_EVENTFD_MSI		_IOW(';', 105, int)
+#define	UIO_EVENTFDS_MSIX	_IOW(';', 106, int)
+
 #endif /* _LINUX_UIO_DRIVER_H_ */
