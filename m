Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab0IZPA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 11:00:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab0IZPAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 11:00:54 -0400
Date: Sun, 26 Sep 2010 16:54:19 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tom Lyon <pugs@cisco.com>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        randy.dunlap@oracle.com, arnd@arndb.de, joro@8bytes.org,
        hjk@linutronix.de, avi@redhat.com, gregkh@suse.de, chrisw@sous-sol.org,
        alex.williamson@redhat.com
Subject: Re: [PATCH 3/3] VFIO V4: VFIO driver: Non-privileged user level PCI
 drivers
Message-ID: <20100926145419.GA21843@redhat.com>
References: <4c9a72a0.u2cnjUB7QZ91tLeo%pugs@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c9a72a0.u2cnjUB7QZ91tLeo%pugs@cisco.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did a quick pass, mostly on memory locking/DMA code.
Some comments inside.

> +/*
> + * This code handles mapping and unmapping of user data buffers
> + * into DMA'ble space using the IOMMU
> + */
> +
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/pci.h>
> +#include <linux/mm.h>
> +#include <linux/mmu_notifier.h>
> +#include <linux/iommu.h>
> +#include <linux/uiommu.h>
> +#include <linux/sched.h>
> +#include <linux/vfio.h>
> +
> +/* Unmap DMA region */
> +/* dgate must be held */
> +static void vfio_dma_unmap(struct vfio_listener *listener,
> +			struct dma_map_page *mlp)
> +{
> +	int i;
> +	struct vfio_dev *vdev = listener->vdev;
> +
> +	list_del(&mlp->list);
> +	for (i = 0; i < mlp->npage; i++)
> +		(void) uiommu_unmap(vdev->udomain,
> +				mlp->daddr + i*PAGE_SIZE, 0);

Pls put spaces around *, + etc.
I think recent checkpatch versions even warn around this ...

> +	for (i = 0; i < mlp->npage; i++) {
> +		if (mlp->rdwr)
> +			SetPageDirty(mlp->pages[i]);
> +		put_page(mlp->pages[i]);
> +	}
> +	vdev->mapcount--;
> +	listener->mm->locked_vm -= mlp->npage;

Is there a race against mlock call here?

> +	vdev->locked_pages -= mlp->npage;
> +	vfree(mlp->pages);
> +	kfree(mlp);
> +}
> +
> +/* Unmap ALL DMA regions */
> +void vfio_dma_unmapall(struct vfio_listener *listener)
> +{
> +	struct list_head *pos, *pos2;
> +	struct dma_map_page *mlp;
> +
> +	mutex_lock(&listener->vdev->dgate);
> +	list_for_each_safe(pos, pos2, &listener->dm_list) {
> +		mlp = list_entry(pos, struct dma_map_page, list);
> +		vfio_dma_unmap(listener, mlp);
> +	}
> +	mutex_unlock(&listener->vdev->dgate);
> +}
> +
> +int vfio_dma_unmap_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
> +{
> +	unsigned long start, npage;
> +	struct dma_map_page *mlp;
> +	struct list_head *pos, *pos2;
> +	int ret;
> +
> +	start = dmp->vaddr & ~PAGE_SIZE;

Can address become unaligned? Most logic seems to assume
an aligned address ...

> +	npage = dmp->size >> PAGE_SHIFT;
> +
> +	ret = -ENXIO;
> +	mutex_lock(&listener->vdev->dgate);
> +	list_for_each_safe(pos, pos2, &listener->dm_list) {
> +		mlp = list_entry(pos, struct dma_map_page, list);
> +		if (dmp->vaddr != mlp->vaddr || mlp->npage != npage)
> +			continue;
> +		ret = 0;
> +		vfio_dma_unmap(listener, mlp);
> +		break;
> +	}
> +	mutex_unlock(&listener->vdev->dgate);
> +	return ret;
> +}
> +
> +#ifdef CONFIG_MMU_NOTIFIER
> +/* Handle MMU notifications - user process freed or realloced memory
> + * which may be in use in a DMA region. Clean up region if so.
> + */
> +static void vfio_dma_handle_mmu_notify(struct mmu_notifier *mn,
> +		unsigned long start, unsigned long end)
> +{
> +	struct vfio_listener *listener;
> +	unsigned long myend;
> +	struct list_head *pos, *pos2;
> +	struct dma_map_page *mlp;
> +
> +	listener = container_of(mn, struct vfio_listener, mmu_notifier);
> +	mutex_lock(&listener->vdev->dgate);
> +	list_for_each_safe(pos, pos2, &listener->dm_list) {
> +		mlp = list_entry(pos, struct dma_map_page, list);
> +		if (mlp->vaddr >= end)
> +			continue;
> +		/*
> +		 * Ranges overlap if they're not disjoint; and they're
> +		 * disjoint if the end of one is before the start of
> +		 * the other one.
> +		 */
> +		myend = mlp->vaddr + (mlp->npage << PAGE_SHIFT) - 1;
> +		if (!(myend <= start || end <= mlp->vaddr)) {

I suggest open the () and ivert the condition.

> +			printk(KERN_WARNING
> +				"%s: demap start %lx end %lx va %lx pa %lx\n",
> +				__func__, start, end,
> +				mlp->vaddr, (long)mlp->daddr);
> +			vfio_dma_unmap(listener, mlp);


And then what would happen? How does user interpret this warning?
How can driver/device recover?

> +		}
> +	}
> +	mutex_unlock(&listener->vdev->dgate);
> +}
> +
> +static void vfio_dma_inval_page(struct mmu_notifier *mn,
> +		struct mm_struct *mm, unsigned long addr)
> +{
> +	vfio_dma_handle_mmu_notify(mn, addr, addr + PAGE_SIZE);
> +}
> +
> +static void vfio_dma_inval_range_start(struct mmu_notifier *mn,
> +		struct mm_struct *mm, unsigned long start, unsigned long end)
> +{
> +	vfio_dma_handle_mmu_notify(mn, start, end);
> +}
> +
> +static const struct mmu_notifier_ops vfio_dma_mmu_notifier_ops = {
> +	.invalidate_page = vfio_dma_inval_page,
> +	.invalidate_range_start = vfio_dma_inval_range_start,
> +};
> +#endif	/* CONFIG_MMU_NOTIFIER */
> +
> +/*
> + * Map usr buffer at specific IO virtual address
> + */
> +static struct dma_map_page *vfio_dma_map_iova(
> +		struct vfio_listener *listener,
> +		unsigned long start_iova,
> +		struct page **pages,
> +		int npage,
> +		int rdwr)
> +{
> +	struct vfio_dev *vdev = listener->vdev;
> +	int ret;
> +	int i;
> +	phys_addr_t hpa;
> +	struct dma_map_page *mlp;
> +	unsigned long iova = start_iova;
> +
> +	if (vdev->udomain == NULL)
> +		return ERR_PTR(-EINVAL);
> +
> +	for (i = 0; i < npage; i++) {
> +		if (uiommu_iova_to_phys(vdev->udomain, iova + i*PAGE_SIZE))
> +			return ERR_PTR(-EBUSY);
> +	}
> +
> +	mlp = kzalloc(sizeof *mlp, GFP_KERNEL);
> +	if (mlp == NULL)
> +		return ERR_PTR(-ENOMEM);
> +	rdwr = rdwr ? IOMMU_READ|IOMMU_WRITE : IOMMU_READ;
> +	if (vdev->cachec)
> +		rdwr |= IOMMU_CACHE;
> +	for (i = 0; i < npage; i++) {
> +		hpa = page_to_phys(pages[i]);
> +		ret = uiommu_map(vdev->udomain, iova, hpa, 0, rdwr);
> +		if (ret) {
> +			while (--i > 0) {
> +				iova -= PAGE_SIZE;
> +				(void) uiommu_unmap(vdev->udomain,
> +						iova, 0);
> +			}
> +			kfree(mlp);
> +			return ERR_PTR(ret);
> +		}
> +		iova += PAGE_SIZE;
> +	}
> +	vdev->mapcount++;
> +
> +	mlp->pages = pages;
> +	mlp->daddr = start_iova;
> +	mlp->npage = npage;
> +	return mlp;
> +}
> +
> +int vfio_dma_map_common(struct vfio_listener *listener,
> +		unsigned int cmd, struct vfio_dma_map *dmp)
> +{
> +	int locked, lock_limit;
> +	struct page **pages;
> +	int npage;
> +	struct dma_map_page *mlp;
> +	int rdwr = (dmp->flags & VFIO_FLAG_WRITE) ? 1 : 0;
> +	int ret = 0;
> +
> +	if (dmp->vaddr & (PAGE_SIZE-1))
> +		return -EINVAL;
> +	if (dmp->size & (PAGE_SIZE-1))
> +		return -EINVAL;

size must be full pages? Maybe document this?

> +	if (dmp->size <= 0)

It's u64. Can it be < 0?

> +		return -EINVAL;
> +	npage = dmp->size >> PAGE_SHIFT;

This assignment can overflow the integer.

> +	if (npage <= 0)
> +		return -EINVAL;
> +
> +	mutex_lock(&listener->vdev->dgate);
> +
> +	/* account for locked pages */
> +	locked = npage + current->mm->locked_vm;

Again this can race against mlock I think.

> +	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur
> +			>> PAGE_SHIFT;
> +	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {

rlimit/capability access might also be racy: don't we need
task lock for that?

> +		printk(KERN_WARNING "%s: RLIMIT_MEMLOCK exceeded\n",
> +			__func__);
> +		ret = -ENOMEM;
> +		goto out_lock;
> +	}
> +	/* only 1 address space per fd */
> +	if (current->mm != listener->mm) {
> +		if (listener->mm != NULL) {
> +			ret = -EINVAL;
> +			goto out_lock;
> +		}
> +		listener->mm = current->mm;
> +#ifdef CONFIG_MMU_NOTIFIER
> +		listener->mmu_notifier.ops = &vfio_dma_mmu_notifier_ops;
> +		ret = mmu_notifier_register(&listener->mmu_notifier,
> +						listener->mm);
> +		if (ret)
> +			printk(KERN_ERR "%s: mmu_notifier_register failed %d\n",
> +				__func__, ret);
> +		ret = 0;


What exactly are you doing with the notifiers?
This driver seems to lock all DMA memory, how can
it get moved?
And why is an error ignored?

> +#endif
> +	}
> +
> +	pages = vmalloc(npage * sizeof(struct page *));

npage comes from userspace? What if it's a huge value?
Also, on a 32 bit system, we will run out of vmalloc space
quickly if we let userspace tie it up indefinitely ...
This is slow path - maybe just lock pages one by one?

> +	if (pages == NULL) {
> +		ret = ENOMEM;
> +		goto out_lock;
> +	}
> +	ret = get_user_pages_fast(dmp->vaddr, npage, rdwr, pages);
> +	if (ret != npage) {
> +		printk(KERN_ERR "%s: get_user_pages_fast returns %d, not %d\n",
> +			__func__, ret, npage);
> +		kfree(pages);
> +		ret = -EFAULT;
> +		goto out_lock;
> +	}
> +	ret = 0;
> +
> +	mlp = vfio_dma_map_iova(listener, dmp->dmaaddr,
> +				pages, npage, rdwr);
> +	if (IS_ERR(mlp)) {
> +		ret = PTR_ERR(mlp);
> +		vfree(pages);
> +		goto out_lock;
> +	}
> +	mlp->vaddr = dmp->vaddr;
> +	mlp->rdwr = rdwr;
> +	dmp->dmaaddr = mlp->daddr;
> +	list_add(&mlp->list, &listener->dm_list);
> +
> +	current->mm->locked_vm += npage;
> +	listener->vdev->locked_pages += npage;

This looks too aggressive.
So if you want to use 2 devices, you will
have to double the mlock rlimit for the process?

I think this ioctl would be better done
on the iommu device than on vfio: all it does
is pass calls to iommu anyway.
The you can share locking between devices.

> +out_lock:
> +	mutex_unlock(&listener->vdev->dgate);
> +	return ret;
> +}
> +
> +int vfio_domain_unset(struct vfio_dev *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +
> +	if (vdev->udomain == NULL)

!vdev->udomain

> +		return 0;
> +	if (vdev->mapcount)
> +		return -EBUSY;
> +	uiommu_detach_device(vdev->udomain, &pdev->dev);
> +	uiommu_put(vdev->udomain);
> +	vdev->udomain = NULL;
> +	return 0;
> +}
> +
> +int vfio_domain_set(struct vfio_dev *vdev, int fd, int unsafe_ok)
> +{
> +	struct uiommu_domain *udomain;
> +	struct pci_dev *pdev = vdev->pdev;
> +	int ret;
> +	int safe;
> +
> +	if (vdev->udomain)
> +		return -EBUSY;
> +	udomain = uiommu_fdget(fd);
> +	if (IS_ERR(udomain))
> +		return PTR_ERR(udomain);
> +
> +	safe = 0;
> +#ifdef IOMMU_CAP_INTR_REMAP	/* >= 2.6.36 */
> +	/* iommu domain must also isolate dev interrupts */
> +	if (uiommu_domain_has_cap(udomain, IOMMU_CAP_INTR_REMAP))
> +		safe = 1;
> +#endif
> +	if (!safe && !unsafe_ok) {
> +		printk(KERN_WARNING "%s: no interrupt remapping!\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	vfio_domain_unset(vdev);
> +	ret = uiommu_attach_device(udomain, &pdev->dev);
> +	if (ret) {
> +		printk(KERN_ERR "%s: attach_device failed %d\n",
> +				__func__, ret);
> +		uiommu_put(udomain);
> +		return ret;
> +	}
> +	vdev->cachec = iommu_domain_has_cap(udomain->domain,
> +				IOMMU_CAP_CACHE_COHERENCY);
> +	vdev->udomain = udomain;
> +	return 0;
> +}
> diff --git a/drivers/vfio/vfio_intrs.c b/drivers/vfio/vfio_intrs.c
> new file mode 100644
> index 0000000..4ced09c
> --- /dev/null
> +++ b/drivers/vfio/vfio_intrs.c
> @@ -0,0 +1,257 @@
> +/*
> + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> + * Author: Tom Lyon, pugs@cisco.com
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + * Portions derived from drivers/uio/uio.c:
> + * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
> + * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
> + * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
> + * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
> + *
> + * Portions derived from drivers/uio/uio_pci_generic.c:
> + * Copyright (C) 2009 Red Hat, Inc.
> + * Author: Michael S. Tsirkin <mst@redhat.com>
> + */
> +
> +/*
> + * This code handles catching interrupts and translating
> + * them to events on eventfds
> + */
> +
> +#include <linux/device.h>
> +#include <linux/interrupt.h>
> +#include <linux/eventfd.h>
> +#include <linux/pci.h>
> +#include <linux/mmu_notifier.h>
> +
> +#include <linux/vfio.h>
> +
> +
> +/*
> + * vfio_interrupt - IRQ hardware interrupt handler
> + */
> +irqreturn_t vfio_interrupt(int irq, void *dev_id)
> +{
> +	struct vfio_dev *vdev = (struct vfio_dev *)dev_id;

don't cast void pointers

> +	struct pci_dev *pdev = vdev->pdev;
> +	irqreturn_t ret = IRQ_NONE;
> +	u32 cmd_status_dword;
> +	u16 origcmd, newcmd, status;
> +
> +	spin_lock_irq(&vdev->irqlock);
> +	pci_block_user_cfg_access(pdev);
> +
> +	/* Read both command and status registers in a single 32-bit operation.
> +	 * Note: we could cache the value for command and move the status read
> +	 * out of the lock if there was a way to get notified of user changes
> +	 * to command register through sysfs. Should be good for shared irqs. */
> +	pci_read_config_dword(pdev, PCI_COMMAND, &cmd_status_dword);
> +	origcmd = cmd_status_dword;
> +	status = cmd_status_dword >> 16;
> +
> +	/* Check interrupt status register to see whether our device
> +	 * triggered the interrupt. */
> +	if (!(status & PCI_STATUS_INTERRUPT))
> +		goto done;
> +
> +	/* We triggered the interrupt, disable it. */
> +	newcmd = origcmd | PCI_COMMAND_INTX_DISABLE;
> +	if (newcmd != origcmd)
> +		pci_write_config_word(pdev, PCI_COMMAND, newcmd);
> +
> +	ret = IRQ_HANDLED;
> +done:
> +	pci_unblock_user_cfg_access(pdev);
> +	spin_unlock_irq(&vdev->irqlock);
> +	if (ret != IRQ_HANDLED)
> +		return ret;
> +	if (vdev->ev_irq)
> +		eventfd_signal(vdev->ev_irq, 1);
> +	return ret;
> +}
> +
> +/*
> + * MSI and MSI-X Interrupt handler.
> + * Just signal an event
> + */
> +static irqreturn_t msihandler(int irq, void *arg)
> +{
> +	struct eventfd_ctx *ctx = arg;
> +
> +	eventfd_signal(ctx, 1);
> +	return IRQ_HANDLED;
> +}
> +
> +void vfio_drop_msi(struct vfio_dev *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	int i;
> +
> +	if (vdev->ev_msi) {
> +		for (i = 0; i < vdev->msi_nvec; i++) {
> +			free_irq(pdev->irq + i, vdev->ev_msi[i]);
> +			if (vdev->ev_msi[i])
> +				eventfd_ctx_put(vdev->ev_msi[i]);
> +		}
> +	}
> +	kfree(vdev->ev_msi);
> +	vdev->ev_msi = NULL;
> +	vdev->msi_nvec = 0;
> +	pci_disable_msi(pdev);
> +}
> +
> +int vfio_setup_msi(struct vfio_dev *vdev, int nvec, void __user *uarg)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct eventfd_ctx *ctx;
> +	int i, n, l2;
> +	int ret = 0;
> +	int fd;
> +
> +	if (nvec < 1 || nvec > 32)
> +		return -EINVAL;
> +	vdev->ev_msi = kzalloc(nvec * sizeof(struct eventfd_ctx *),
> +				GFP_KERNEL);
> +	if (vdev->ev_msi == NULL)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < nvec; i++) {
> +		if (copy_from_user(&fd, uarg, sizeof fd)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +		uarg += sizeof fd;
> +		ctx = eventfd_ctx_fdget(fd);
> +		if (IS_ERR(ctx)) {
> +			ret = PTR_ERR(ctx);
> +			break;

so goto out here?

> +		}
> +		vdev->ev_msi[i] = ctx;
> +	}
> +	if (ret)
> +		goto out;
> +	ret = pci_enable_msi_block(pdev, nvec);
> +	if (ret) {
> +		if (ret > 0)
> +			ret = -EINVAL;
> +		goto out;
> +	}
> +	for (i = 0; i < nvec; i++) {
> +		ret = request_irq(pdev->irq + i, msihandler, 0,
> +			vdev->name, vdev->ev_msi[i]);
> +		if (ret)
> +			break;
> +		vdev->msi_nvec = i+1;
> +	}
> +
> +	/*
> +	 * compute the virtual hardware field for max msi vectors -
> +	 * it is the log base 2 of the number of vectors
> +	 */
> +	l2 = 0;
> +	n = vdev->msi_nvec;
> +	if (n >= (1 << 4)) {
> +		n >>= 4;
> +		l2 += 4;
> +	}
> +	if (n >= (1 << 2)) {
> +		n >>= 2;
> +		l2 += 2;
> +	}
> +	if (n >= (1 << 1))
> +		l2 += 1;

what is this doing? Will using fls() help?

> +	vdev->msi_qmax = l2;
> +out:
> +	if (ret)
> +		vfio_drop_msi(vdev);
> +	return ret;
> +}
> +
> +void vfio_drop_msix(struct vfio_dev *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	int i;
> +
> +	if (vdev->ev_msix && vdev->msix) {
> +		for (i = 0; i < vdev->msix_nvec; i++) {
> +			free_irq(vdev->msix[i].vector, vdev->ev_msix[i]);
> +			if (vdev->ev_msix[i])
> +				eventfd_ctx_put(vdev->ev_msix[i]);
> +		}
> +	}


No need for external {}


> +	kfree(vdev->ev_msix);
> +	vdev->ev_msix = NULL;
> +	kfree(vdev->msix);
> +	vdev->msix = NULL;
> +	vdev->msix_nvec = 0;
> +	pci_disable_msix(pdev);
> +}
> +
> +int vfio_setup_msix(struct vfio_dev *vdev, int nvec, void __user *uarg)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct eventfd_ctx *ctx;
> +	int ret = 0;
> +	int i;
> +	int fd;
> +	int pos;
> +	u16 flags = 0;
> +
> +	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
> +	if (!pos)
> +		return -EINVAL;
> +	pci_read_config_word(pdev, pos + PCI_MSIX_FLAGS, &flags);
> +	if (nvec < 1 || nvec > (flags & PCI_MSIX_FLAGS_QSIZE) + 1)
> +		return -EINVAL;
> +
> +	vdev->msix = kzalloc(nvec * sizeof(struct msix_entry),
> +				GFP_KERNEL);
> +	if (vdev->msix == NULL)
> +		return -ENOMEM;
> +	vdev->ev_msix = kzalloc(nvec * sizeof(struct eventfd_ctx *),
> +				GFP_KERNEL);
> +	if (vdev->ev_msix == NULL) {
> +		kfree(vdev->msix);
> +		return -ENOMEM;
> +	}
> +	for (i = 0; i < nvec; i++) {
> +		if (copy_from_user(&fd, uarg, sizeof fd)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +		uarg += sizeof fd;
> +		ctx = eventfd_ctx_fdget(fd);
> +		if (IS_ERR(ctx)) {
> +			ret = PTR_ERR(ctx);
> +			break;
> +		}
> +		vdev->msix[i].entry = i;
> +		vdev->ev_msix[i] = ctx;
> +	}
> +	if (!ret)
> +		ret = pci_enable_msix(pdev, vdev->msix, nvec);
> +	vdev->msix_nvec = 0;
> +	for (i = 0; i < nvec && !ret; i++) {
> +		ret = request_irq(vdev->msix[i].vector, msihandler, 0,
> +			vdev->name, vdev->ev_msix[i]);
> +		if (ret)
> +			break;
> +		vdev->msix_nvec = i+1;
> +	}
> +	if (ret)
> +		vfio_drop_msix(vdev);
> +	return ret;
> +}
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> new file mode 100644
> index 0000000..a18e39a
> --- /dev/null
> +++ b/drivers/vfio/vfio_main.c
> @@ -0,0 +1,768 @@
> +/*
> + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> + * Author: Tom Lyon, pugs@cisco.com
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + * Portions derived from drivers/uio/uio.c:
> + * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
> + * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
> + * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
> + * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
> + *
> + * Portions derived from drivers/uio/uio_pci_generic.c:
> + * Copyright (C) 2009 Red Hat, Inc.
> + * Author: Michael S. Tsirkin <mst@redhat.com>
> + */
> +
> +/*
> + * VFIO main module: driver to allow non-privileged user programs
> + * to imlpement direct mapped device drivers for PCI* devices
> + */
> +
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/mm.h>
> +#include <linux/idr.h>
> +#include <linux/string.h>
> +#include <linux/interrupt.h>
> +#include <linux/fs.h>
> +#include <linux/eventfd.h>
> +#include <linux/pci.h>
> +#include <linux/iommu.h>
> +#include <linux/mmu_notifier.h>
> +#include <linux/uaccess.h>
> +#include <linux/suspend.h>
> +
> +#include <linux/vfio.h>
> +
> +
> +#define DRIVER_VERSION	"0.1"
> +#define DRIVER_AUTHOR	"Tom Lyon <pugs@cisco.com>"
> +#define DRIVER_DESC	"VFIO - User Level PCI meta-driver"
> +
> +/*
> + * Only a very few platforms today (Intel X7500) fully support
> + * both DMA remapping and interrupt remapping in the IOMMU.
> + * Everyone has DMA remapping but interrupt remapping is missing
> + * in some Intel hardware and software, and its missing in the AMD
> + * IOMMU software. Interrupt remapping is needed to really protect the
> + * system from user level driver mischief.  Until it is in more platforms
> + * we allow the admin to load the module with allow_unsafe_intrs=1
> + * which will make this driver useful (but not safe)
> + * on those platforms.
> + */
> +static int allow_unsafe_intrs;
> +module_param(allow_unsafe_intrs, int, 0);
> +
> +static int vfio_major = -1;
> +static DEFINE_IDR(vfio_idr);
> +static int vfio_max_minor;
> +/* Protect idr accesses */
> +static DEFINE_MUTEX(vfio_minor_lock);
> +
> +/*
> + * Does [a1,b1) overlap [a2,b2) ?
> + */
> +static inline int overlap(int a1, int b1, int a2, int b2)
> +{
> +	/*
> +	 * Ranges overlap if they're not disjoint; and they're
> +	 * disjoint if the end of one is before the start of
> +	 * the other one.
> +	 */
> +	return !(b2 <= a1 || b1 <= a2);
> +}
> +
> +static int vfio_open(struct inode *inode, struct file *filep)
> +{
> +	struct vfio_dev *vdev;
> +	struct vfio_listener *listener;
> +	int ret = 0;
> +
> +	mutex_lock(&vfio_minor_lock);
> +	vdev = idr_find(&vfio_idr, iminor(inode));
> +	mutex_unlock(&vfio_minor_lock);
> +	if (!vdev) {
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +
> +	listener = kzalloc(sizeof(*listener), GFP_KERNEL);
> +	if (!listener) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	mutex_lock(&vdev->lgate);
> +	listener->vdev = vdev;
> +	INIT_LIST_HEAD(&listener->dm_list);
> +	filep->private_data = listener;
> +	if (vdev->listeners == 0)
> +		ret = pci_enable_device(vdev->pdev);

Why would you want to enable device on open?
Doing this later when domain is set would add an extra level of
protection as device would reject reads/writes when not enabled.


Also, don't you want to do pci_set_master at some point?


> +	if (ret == 0)

!ret or better if (ret)
		 goto err;

> +		vdev->listeners++;
> +	mutex_unlock(&vdev->lgate);
> +	if (ret)
> +		kfree(listener);

this error handling is 
> +out:
> +	return ret;
> +}
> +
> +static int vfio_release(struct inode *inode, struct file *filep)
> +{
> +	int ret = 0;
> +	struct vfio_listener *listener = filep->private_data;
> +	struct vfio_dev *vdev = listener->vdev;
> +
> +	vfio_dma_unmapall(listener);
> +	if (listener->mm) {
> +#ifdef CONFIG_MMU_NOTIFIER
> +		mmu_notifier_unregister(&listener->mmu_notifier, listener->mm);
> +#endif
> +		listener->mm = NULL;
> +	}
> +
> +	mutex_lock(&vdev->lgate);
> +	if (--vdev->listeners <= 0) {
> +		/* we don't need to hold igate here since there are
> +		 * no more listeners doing ioctls
> +		 */
> +		if (vdev->ev_msix)
> +			vfio_drop_msix(vdev);
> +		if (vdev->ev_msi)
> +			vfio_drop_msi(vdev);
> +		if (vdev->ev_irq) {
> +			eventfd_ctx_put(vdev->ev_irq);
> +			vdev->ev_irq = NULL;
> +		}
> +		kfree(vdev->vconfig);
> +		vdev->vconfig = NULL;
> +		kfree(vdev->pci_config_map);
> +		vdev->pci_config_map = NULL;
> +		pci_disable_device(vdev->pdev);
> +		vfio_domain_unset(vdev);

This does not seem to remove bus master before close.
If the userspace driver dies, and device is doing DMA
into userspace, what will prevent DMA after
you unset the domain?


> +		wake_up(&vdev->dev_idle_q);
> +	}
> +	mutex_unlock(&vdev->lgate);
> +
> +	kfree(listener);
> +	return ret;
> +}
> +
> +static ssize_t vfio_read(struct file *filep, char __user *buf,
> +			size_t count, loff_t *ppos)
> +{
> +	struct vfio_listener *listener = filep->private_data;
> +	struct vfio_dev *vdev = listener->vdev;
> +	struct pci_dev *pdev = vdev->pdev;
> +	int pci_space;
> +
> +	pci_space = vfio_offset_to_pci_space(*ppos);
> +
> +	/* config reads are OK before iommu domain set */
> +	if (pci_space == VFIO_PCI_CONFIG_RESOURCE)
> +		return vfio_config_readwrite(0, vdev, buf, count, ppos);
> +
> +	/* no other reads until IOMMU domain set */
> +	if (vdev->udomain == NULL)
> +		return -EINVAL;
> +	if (pci_space > PCI_ROM_RESOURCE)
> +		return -EINVAL;
> +	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_IO)
> +		return vfio_io_readwrite(0, vdev, buf, count, ppos);
> +	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM)
> +		return vfio_mem_readwrite(0, vdev, buf, count, ppos);
> +	if (pci_space == PCI_ROM_RESOURCE)
> +		return vfio_mem_readwrite(0, vdev, buf, count, ppos);
> +	return -EINVAL;
> +}
> +
> +static int vfio_msix_check(struct vfio_dev *vdev, u64 start, u32 len)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	u16 pos;
> +	u32 table_offset;
> +	u16 table_size;
> +	u8 bir;
> +	u32 lo, hi, startp, endp;
> +
> +	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
> +	if (!pos)
> +		return 0;
> +
> +	pci_read_config_word(pdev, pos + PCI_MSIX_FLAGS, &table_size);
> +	table_size = (table_size & PCI_MSIX_FLAGS_QSIZE) + 1;
> +	pci_read_config_dword(pdev, pos + 4, &table_offset);
> +	bir = table_offset & PCI_MSIX_FLAGS_BIRMASK;
> +	lo = table_offset >> PAGE_SHIFT;
> +	hi = (table_offset + PCI_MSIX_ENTRY_SIZE * table_size + PAGE_SIZE - 1)
> +		>> PAGE_SHIFT;
> +	startp = start >> PAGE_SHIFT;
> +	endp = (start + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	if (bir == vfio_offset_to_pci_space(start) &&
> +	    overlap(lo, hi, startp, endp)) {
> +		printk(KERN_WARNING "%s: cannot write msi-x vectors\n",
> +			__func__);
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static ssize_t vfio_write(struct file *filep, const char __user *buf,
> +			size_t count, loff_t *ppos)
> +{
> +	struct vfio_listener *listener = filep->private_data;
> +	struct vfio_dev *vdev = listener->vdev;
> +	struct pci_dev *pdev = vdev->pdev;
> +	int pci_space;
> +	int ret;
> +
> +	/* no writes until IOMMU domain set */
> +	if (vdev->udomain == NULL)
> +		return -EINVAL;
> +	pci_space = vfio_offset_to_pci_space(*ppos);
> +	if (pci_space == VFIO_PCI_CONFIG_RESOURCE)
> +		return vfio_config_readwrite(1, vdev,
> +					(char __user *)buf, count, ppos);
> +	if (pci_space > PCI_ROM_RESOURCE)
> +		return -EINVAL;
> +	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_IO)
> +		return vfio_io_readwrite(1, vdev,
> +					(char __user *)buf, count, ppos);
> +	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM) {
> +		if (allow_unsafe_intrs) {
> +			/* don't allow writes to msi-x vectors */
> +			ret = vfio_msix_check(vdev, *ppos, count);
> +			if (ret)
> +				return ret;
> +		}
> +		return vfio_mem_readwrite(1, vdev,
> +				(char __user *)buf, count, ppos);
> +	}
> +	return -EINVAL;
> +}
> +
> +static int vfio_mmap(struct file *filep, struct vm_area_struct *vma)
> +{
> +	struct vfio_listener *listener = filep->private_data;
> +	struct vfio_dev *vdev = listener->vdev;
> +	struct pci_dev *pdev = vdev->pdev;
> +	unsigned long requested, actual;
> +	int pci_space;
> +	u64 start;
> +	u32 len;
> +	unsigned long phys;
> +	int ret;
> +
> +	/* no reads or writes until IOMMU domain set */
> +	if (vdev->udomain == NULL)
> +		return -EINVAL;

What happens if user creates a mapping when domain is
set, and then removes it with DOMAIN_UNSET ioctl?
Can't userdpace access an unprotected device now?
 we should just drop DOMAIN_UNSET, and document
that iommu can not be changed once set.


> +
> +	if (vma->vm_end < vma->vm_start)
> +		return -EINVAL;
> +	if ((vma->vm_flags & VM_SHARED) == 0)
> +		return -EINVAL;
> +
> +
> +	pci_space = vfio_offset_to_pci_space((u64)vma->vm_pgoff << PAGE_SHIFT);
> +	if (pci_space > PCI_ROM_RESOURCE)
> +		return -EINVAL;
> +	switch (pci_space) {
> +	case PCI_ROM_RESOURCE:
> +		if (vma->vm_flags & VM_WRITE)
> +			return -EINVAL;
> +		if (pci_resource_flags(pdev, PCI_ROM_RESOURCE) == 0)
> +			return -EINVAL;
> +		actual = pci_resource_len(pdev, PCI_ROM_RESOURCE) >> PAGE_SHIFT;
> +		break;
> +	default:
> +		if ((pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM) == 0)
> +			return -EINVAL;
> +		actual = pci_resource_len(pdev, pci_space) >> PAGE_SHIFT;
> +		break;
> +	}
> +
> +	requested = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> +	if (requested > actual || actual == 0)
> +		return -EINVAL;
> +
> +	start = vma->vm_pgoff << PAGE_SHIFT;
> +	len = vma->vm_end - vma->vm_start;
> +	if (allow_unsafe_intrs && (vma->vm_flags & VM_WRITE)) {
> +		/*
> +		 * Deter users from screwing up MSI-X intrs
> +		 */
> +		ret = vfio_msix_check(vdev, start, len);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	vma->vm_private_data = vdev;
> +	vma->vm_flags |= VM_IO | VM_RESERVED;
> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	phys = pci_resource_start(pdev, pci_space) >> PAGE_SHIFT;
> +
> +	return remap_pfn_range(vma, vma->vm_start, phys,
> +			       vma->vm_end - vma->vm_start,
> +			       vma->vm_page_prot);
> +}
> +
> +static long vfio_unl_ioctl(struct file *filep,
> +			unsigned int cmd,
> +			unsigned long arg)
> +{
> +	struct vfio_listener *listener = filep->private_data;
> +	struct vfio_dev *vdev = listener->vdev;
> +	void __user *uarg = (void __user *)arg;
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct vfio_dma_map *dm;
> +	int ret = 0;
> +	int fd, nfd;
> +	int bar;
> +
> +	if (vdev == NULL)
> +		return -EINVAL;
> +
> +	switch (cmd) {
> +
> +	case VFIO_DMA_MAP_IOVA:
> +		dm = kmalloc(sizeof *dm, GFP_KERNEL);

Why bother allocating on heap? It's a small structure ...

> +		if (dm == NULL)
> +			return -ENOMEM;
> +		if (copy_from_user(dm, uarg, sizeof *dm)) {
> +			kfree(dm);
> +			return -EFAULT;
> +		}
> +		ret = vfio_dma_map_common(listener, cmd, dm);
> +		if (!ret && copy_to_user(uarg, dm, sizeof *dm))
> +			ret = -EFAULT;
> +		kfree(dm);
> +		break;
> +
> +	case VFIO_DMA_UNMAP:
> +		dm = kmalloc(sizeof *dm, GFP_KERNEL);

same here

> +		if (dm == NULL)
> +			return -ENOMEM;
> +		if (copy_from_user(dm, uarg, sizeof *dm)) {
> +			kfree(dm);
> +			return -EFAULT;
> +		}
> +		ret = vfio_dma_unmap_dm(listener, dm);
> +		kfree(dm);
> +		break;
> +
> +	case VFIO_EVENTFD_IRQ:
> +		if (copy_from_user(&fd, uarg, sizeof fd))
> +			return -EFAULT;
> +		mutex_lock(&vdev->igate);
> +		if (vdev->ev_irq)
> +			eventfd_ctx_put(vdev->ev_irq);
> +		if (fd >= 0) {
> +			vdev->ev_irq = eventfd_ctx_fdget(fd);
> +			if (vdev->ev_irq == NULL)
> +				ret = -EINVAL;
> +		}
> +		mutex_unlock(&vdev->igate);
> +		break;
> +
> +	case VFIO_EVENTFDS_MSI:
> +		if (copy_from_user(&nfd, uarg, sizeof nfd))
> +			return -EFAULT;
> +		uarg += sizeof nfd;
> +		mutex_lock(&vdev->igate);
> +		if (nfd > 0 && vdev->ev_msi == NULL)

== NULL -> ! here and elsewhere

> +			ret = vfio_setup_msi(vdev, nfd, uarg);
> +		else if (nfd == 0 && vdev->ev_msi)
> +			vfio_drop_msi(vdev);
> +		else
> +			ret = -EINVAL;
> +		mutex_unlock(&vdev->igate);
> +		break;
> +
> +	case VFIO_EVENTFDS_MSIX:
> +		if (copy_from_user(&nfd, uarg, sizeof nfd))
> +			return -EFAULT;
> +		uarg += sizeof nfd;

Maybe cast to int __user *.
Then use simple + 1 for access instead of sizeof,
and get_user instead of copy_from_user.

> +		mutex_lock(&vdev->igate);
> +		if (nfd > 0 && vdev->ev_msix == NULL)
> +			ret = vfio_setup_msix(vdev, nfd, uarg);
> +		else if (nfd == 0 && vdev->ev_msix)
> +			vfio_drop_msix(vdev);
> +		else
> +			ret = -EINVAL;
> +		mutex_unlock(&vdev->igate);
> +		break;
> +
> +	case VFIO_BAR_LEN:
> +		if (copy_from_user(&bar, uarg, sizeof bar))
> +			return -EFAULT;
> +		if (bar < 0 || bar > PCI_ROM_RESOURCE)
> +			return -EINVAL;
> +		if (pci_resource_start(pdev, bar))
> +			bar = pci_resource_len(pdev, bar);
> +		else
> +			bar = 0;
> +		if (copy_to_user(uarg, &bar, sizeof bar))
> +			return -EFAULT;
> +		break;
> +
> +	case VFIO_DOMAIN_SET:
> +		if (copy_from_user(&fd, uarg, sizeof fd))
> +			return -EFAULT;
> +		ret = vfio_domain_set(vdev, fd, allow_unsafe_intrs);
> +		break;
> +
> +	case VFIO_DOMAIN_UNSET:
> +		ret = vfio_domain_unset(vdev);
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +	return ret;
> +}
> +
> +static const struct file_operations vfio_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= vfio_open,
> +	.release	= vfio_release,
> +	.read		= vfio_read,
> +	.write		= vfio_write,
> +	.unlocked_ioctl	= vfio_unl_ioctl,
> +	.mmap		= vfio_mmap,
> +};
> +
> +static int vfio_get_devnum(struct vfio_dev *vdev)
> +{
> +	int retval = -ENOMEM;
> +	int id;
> +
> +	mutex_lock(&vfio_minor_lock);
> +	if (idr_pre_get(&vfio_idr, GFP_KERNEL) == 0)
> +		goto exit;
> +
> +	retval = idr_get_new(&vfio_idr, vdev, &id);
> +	if (retval < 0) {
> +		if (retval == -EAGAIN)
> +			retval = -ENOMEM;
> +		goto exit;
> +	}
> +	if (id > MINORMASK) {
> +		idr_remove(&vfio_idr, id);
> +		retval = -ENOMEM;
> +	}
> +	if (id > vfio_max_minor)
> +		vfio_max_minor = id;
> +	if (vfio_major < 0) {
> +		retval = register_chrdev(0, "vfio", &vfio_fops);
> +		if (retval < 0)
> +			goto exit;
> +		vfio_major = retval;
> +	}
> +
> +	retval = MKDEV(vfio_major, id);
> +exit:
> +	mutex_unlock(&vfio_minor_lock);
> +	return retval;
> +}
> +
> +int vfio_validate(struct vfio_dev *vdev)
> +{
> +	int rc = 0;
> +	int id;
> +
> +	mutex_lock(&vfio_minor_lock);
> +	for (id = 0; id <= vfio_max_minor; id++)
> +		if (vdev == idr_find(&vfio_idr, id))
> +			goto out;
> +	rc = 1;
> +out:
> +	mutex_unlock(&vfio_minor_lock);
> +	return rc;
> +}
> +
> +static void vfio_free_minor(struct vfio_dev *vdev)
> +{
> +	mutex_lock(&vfio_minor_lock);
> +	idr_remove(&vfio_idr, MINOR(vdev->devnum));
> +	mutex_unlock(&vfio_minor_lock);
> +}
> +
> +/*
> + * Verify that the device supports Interrupt Disable bit in command register,
> + * per PCI 2.3, by flipping this bit and reading it back: this bit was readonly
> + * in PCI 2.2.  (from uio_pci_generic)
> + */
> +static int verify_pci_2_3(struct pci_dev *pdev)
> +{
> +	u16 orig, new;
> +	u8 pin;
> +
> +	pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
> +	if (pin == 0)		/* irqs not needed */
> +		return 0;
> +
> +	pci_read_config_word(pdev, PCI_COMMAND, &orig);
> +	pci_write_config_word(pdev, PCI_COMMAND,
> +			      orig ^ PCI_COMMAND_INTX_DISABLE);
> +	pci_read_config_word(pdev, PCI_COMMAND, &new);
> +	/* There's no way to protect against
> +	 * hardware bugs or detect them reliably, but as long as we know
> +	 * what the value should be, let's go ahead and check it. */
> +	if ((new ^ orig) & ~PCI_COMMAND_INTX_DISABLE) {
> +		dev_err(&pdev->dev, "Command changed from 0x%x to 0x%x: "
> +			"driver or HW bug?\n", orig, new);
> +		return -EBUSY;
> +	}
> +	if (!((new ^ orig) & PCI_COMMAND_INTX_DISABLE)) {
> +		dev_warn(&pdev->dev, "Device does not support "
> +			 "disabling interrupts: unable to bind.\n");
> +		return -ENODEV;
> +	}
> +	/* Now restore the original value. */
> +	pci_write_config_word(pdev, PCI_COMMAND, orig);
> +	return 0;
> +}
> +
> +static int vfio_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct vfio_dev *vdev;
> +	int err;
> +	u8 type;
> +
> +	if (!iommu_found())
> +		return -EINVAL;
> +
> +	pci_read_config_byte(pdev, PCI_HEADER_TYPE, &type);
> +	if ((type & 0x7F) != PCI_HEADER_TYPE_NORMAL)
> +		return -EINVAL;
> +
> +	err = verify_pci_2_3(pdev);
> +	if (err)
> +		return err;
> +
> +	vdev = kzalloc(sizeof(struct vfio_dev), GFP_KERNEL);
> +	if (!vdev)
> +		return -ENOMEM;
> +	vdev->pdev = pdev;
> +
> +	mutex_init(&vdev->lgate);
> +	mutex_init(&vdev->dgate);
> +	mutex_init(&vdev->igate);
> +	mutex_init(&vdev->ngate);
> +	INIT_LIST_HEAD(&vdev->nlc_list);
> +	init_waitqueue_head(&vdev->dev_idle_q);
> +	init_waitqueue_head(&vdev->nl_wait_q);
> +
> +	err = vfio_get_devnum(vdev);
> +	if (err < 0)
> +		goto err_get_devnum;
> +	vdev->devnum = err;
> +	err = 0;
> +
> +	sprintf(vdev->name, "vfio%d", MINOR(vdev->devnum));
> +	pci_set_drvdata(pdev, vdev);
> +	vdev->dev = device_create(vfio_class->class, &pdev->dev,
> +			  vdev->devnum, vdev, vdev->name);
> +	if (IS_ERR(vdev->dev)) {
> +		printk(KERN_ERR "VFIO: device register failed\n");
> +		err = PTR_ERR(vdev->dev);
> +		goto err_device_create;
> +	}
> +
> +	err = vfio_dev_add_attributes(vdev);
> +	if (err)
> +		goto err_vfio_dev_add_attributes;
> +
> +
> +	if (pdev->irq > 0) {
> +		err = request_irq(pdev->irq, vfio_interrupt,
> +				  IRQF_SHARED, vdev->name, vdev);
> +		if (err)
> +			goto err_request_irq;

Since this is a sahred interrupt, you will get called
even if MSI in device is enabled, which will confuse
users. How about requesting irq upon an ioctl?

> +	}
> +
> +	return 0;
> +
> +err_request_irq:
> +err_vfio_dev_add_attributes:
> +	device_destroy(vfio_class->class, vdev->devnum);
> +err_device_create:
> +	vfio_free_minor(vdev);
> +err_get_devnum:
> +	kfree(vdev);
> +	return err;
> +}
> +
> +static void vfio_remove(struct pci_dev *pdev)
> +{
> +	struct vfio_dev *vdev = pci_get_drvdata(pdev);
> +	int ret;
> +
> +	/* prevent further opens */
> +	vfio_free_minor(vdev);
> +
> +	/* notify users */
> +	ret = vfio_nl_remove(vdev);
> +
> +	/* wait for all closed */
> +	wait_event(vdev->dev_idle_q, vdev->listeners == 0);
> +
> +	pci_disable_device(pdev);
> +	if (pdev->irq > 0)
> +		free_irq(pdev->irq, vdev);
> +
> +	vfio_nl_freeclients(vdev);
> +	device_destroy(vfio_class->class, vdev->devnum);
> +	pci_set_drvdata(pdev, NULL);
> +	kfree(vdev);
> +}
> +
> +static struct pci_error_handlers vfio_error_handlers = {
> +	.error_detected	= vfio_error_detected,
> +	.mmio_enabled	= vfio_mmio_enabled,
> +	.link_reset	= vfio_link_reset,
> +	.slot_reset	= vfio_slot_reset,
> +	.resume		= vfio_error_resume,
> +};
> +
> +static struct pci_driver driver = {
> +	.name		= "vfio",
> +	.id_table	= NULL, /* only dynamic id's */
> +	.probe		 = vfio_probe,
> +	.remove		 = vfio_remove,
> +	.err_handler	 = &vfio_error_handlers,
> +};
> +
> +static atomic_t vfio_pm_suspend_count;
> +static int vfio_pm_suspend_result;
> +static DECLARE_WAIT_QUEUE_HEAD(vfio_pm_wait_q);
> +
> +/*
> + * Notify user level drivers of hibernation/suspend request
> + * Send all the notifies in parallel, collect all the replies
> + * If one ULD can't suspend, none can
> + */
> +static int vfio_pm_suspend(void)
> +{
> +	struct vfio_dev *vdev;
> +	int id, alive = 0;
> +	int ret;
> +
> +	mutex_lock(&vfio_minor_lock);
> +	atomic_set(&vfio_pm_suspend_count, 0);
> +	vfio_pm_suspend_result = NOTIFY_DONE;
> +	for (id = 0; id <= vfio_max_minor; id++) {
> +		vdev = idr_find(&vfio_idr, id);
> +		if (vdev == NULL)
> +			continue;
> +		if (vdev->listeners == 0)
> +			continue;
> +		alive++;
> +		ret = vfio_nl_upcall(vdev, VFIO_MSG_PM_SUSPEND, 0, 0);
> +		if (ret == 0)
> +			atomic_inc(&vfio_pm_suspend_count);
> +	}
> +	mutex_unlock(&vfio_minor_lock);
> +	if (alive > atomic_read(&vfio_pm_suspend_count))
> +		return NOTIFY_BAD;
> +
> +	/* sleep for reply */
> +	if (wait_event_interruptible_timeout(vfio_pm_wait_q,
> +	    (atomic_read(&vfio_pm_suspend_count) == 0),
> +	    VFIO_SUSPEND_REPLY_TIMEOUT) <= 0) {
> +		printk(KERN_ERR "vfio upcall suspend reply timeout\n");
> +		return NOTIFY_BAD;
> +	}
> +	return vfio_pm_suspend_result;
> +}
> +
> +static int vfio_pm_resume(void)
> +{
> +	struct vfio_dev *vdev;
> +	int id;
> +
> +	mutex_lock(&vfio_minor_lock);
> +	for (id = 0; id <= vfio_max_minor; id++) {
> +		vdev = idr_find(&vfio_idr, id);
> +		if (vdev == NULL)
> +			continue;
> +		if (vdev->listeners == 0)
> +			continue;
> +		(void) vfio_nl_upcall(vdev, VFIO_MSG_PM_RESUME, 0, 0);
> +	}
> +	mutex_unlock(&vfio_minor_lock);
> +	return NOTIFY_DONE;
> +}
> +
> +
> +void vfio_pm_process_reply(int reply)
> +{
> +	if (vfio_pm_suspend_result == NOTIFY_DONE) {
> +		if (reply != NOTIFY_DONE)
> +			vfio_pm_suspend_result = NOTIFY_BAD;
> +	}
> +	if (atomic_dec_and_test(&vfio_pm_suspend_count))
> +		wake_up(&vfio_pm_wait_q);
> +}
> +
> +static int vfio_pm_notify(struct notifier_block *this, unsigned long event,
> +	void *notused)
> +{
> +	switch (event) {
> +	case PM_HIBERNATION_PREPARE:
> +	case PM_SUSPEND_PREPARE:
> +		return vfio_pm_suspend();
> +		break;
> +	case PM_POST_HIBERNATION:
> +	case PM_POST_SUSPEND:
> +		return vfio_pm_resume();
> +		break;
> +	default:
> +		return NOTIFY_DONE;
> +	}
> +}
> +
> +struct notifier_block vfio_pm_nb = {
> +	.notifier_call = vfio_pm_notify,
> +};
> +
> +static int __init init(void)
> +{
> +	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
> +	vfio_class_init();
> +	vfio_nl_init();
> +	register_pm_notifier(&vfio_pm_nb);
> +	return pci_register_driver(&driver);
> +}
> +
> +static void __exit cleanup(void)
> +{
> +	if (vfio_major >= 0)
> +		unregister_chrdev(vfio_major, "vfio");
> +	pci_unregister_driver(&driver);
> +	unregister_pm_notifier(&vfio_pm_nb);
> +	unregister_pm_notifier(&vfio_pm_nb);
> +	vfio_nl_exit();
> +	vfio_class_destroy();
> +}
> +
> +module_init(init);
> +module_exit(cleanup);
> +
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> diff --git a/drivers/vfio/vfio_netlink.c b/drivers/vfio/vfio_netlink.c
> new file mode 100644
> index 0000000..bc9a7d3
> --- /dev/null
> +++ b/drivers/vfio/vfio_netlink.c
> @@ -0,0 +1,459 @@
> +/*
> + * Netlink inteface for VFIO
> + * Author: Tom Lyon (pugs@cisco.com)
> + *
> + * Copyright 2010, Cisco Systems, Inc.
> + * Copyright 2007, 2008 Siemens AG
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2
> + * as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + *
> + * Derived from net/ieee802154/netlink.c Written by:
> + * Sergey Lapin <slapin@ossfans.org>
> + * Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> + * Maxim Osipov <maxim.osipov@siemens.com>
> + */
> +
> +/*
> + * This code handles the signaling of various system events
> + * to the user level driver, using the generic netlink facilities.
> + * In many cases, we wait for replies from the user driver as well.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/gfp.h>
> +#include <linux/pci.h>
> +#include <linux/sched.h>
> +#include <net/genetlink.h>
> +#include <linux/mmu_notifier.h>
> +#include <linux/vfio.h>
> +
> +static u32 vfio_seq_num;
> +static DEFINE_SPINLOCK(vfio_seq_lock);
> +
> +struct genl_family vfio_nl_family = {
> +	.id		= GENL_ID_GENERATE,
> +	.hdrsize	= 0,
> +	.name		= VFIO_GENL_NAME,
> +	.version	= 1,
> +	.maxattr	= VFIO_NL_ATTR_MAX,
> +};
> +
> +/* Requests to userspace */
> +struct sk_buff *vfio_nl_create(u8 req)
> +{
> +	void *hdr;
> +	struct sk_buff *msg = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
> +	unsigned long f;
> +
> +	if (!msg)
> +		return NULL;
> +
> +	spin_lock_irqsave(&vfio_seq_lock, f);
> +	hdr = genlmsg_put(msg, 0, ++vfio_seq_num,
> +			&vfio_nl_family, 0, req);
> +	spin_unlock_irqrestore(&vfio_seq_lock, f);
> +	if (!hdr) {
> +		nlmsg_free(msg);
> +		return NULL;
> +	}
> +
> +	return msg;
> +}
> +
> +/*
> + * We would have liked to use NL multicast, but
> + * (a) multicast sockets are only for root
> + * (b) there's no multicast user level api in libnl
> + * (c) we need to know what net namespaces are involved
> + * Sigh.
> + */
> +int vfio_nl_mcast(struct vfio_dev *vdev, struct sk_buff *msg, u8 type)
> +{
> +	struct list_head *pos;
> +	struct vfio_nl_client *nlc;
> +	struct sk_buff *skb;
> +	/* XXX: nlh is right at the start of msg */
> +	void *hdr = genlmsg_data(NLMSG_DATA(msg->data));
> +	int good = 0;
> +	int rc;
> +
> +	if (genlmsg_end(msg, hdr) < 0) {
> +		nlmsg_free(msg);
> +		return -ENOBUFS;
> +	}
> +
> +	mutex_lock(&vdev->ngate);
> +	list_for_each(pos, &vdev->nlc_list) {
> +		nlc = list_entry(pos, struct vfio_nl_client, list);
> +		if (nlc->msgcap & (1LL << type)) {
> +			skb = skb_copy(msg, GFP_KERNEL);
> +			if (skb == NULL)  {
> +				rc = -ENOBUFS;
> +				goto out;
> +			}
> +			rc = genlmsg_unicast(nlc->net, skb, nlc->pid);
> +			if (rc == 0)
> +				good++;
> +		}
> +	}
> +	rc = 0;
> +out:
> +	mutex_unlock(&vdev->ngate);
> +	nlmsg_free(msg);
> +	if (good)
> +		return good;
> +	return rc;
> +}
> +
> +#ifdef notdef
> +struct sk_buff *vfio_nl_new_reply(struct genl_info *info,
> +		int flags, u8 req)
> +{
> +	void *hdr;
> +	struct sk_buff *msg = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
> +
> +	if (!msg)
> +		return NULL;
> +
> +	hdr = genlmsg_put_reply(msg, info,
> +			&vfio_nl_family, flags, req);
> +	if (!hdr) {
> +		nlmsg_free(msg);
> +		return NULL;
> +	}
> +
> +	return msg;
> +}
> +
> +int vfio_nl_reply(struct sk_buff *msg, struct genl_info *info)
> +{
> +	/* XXX: nlh is right at the start of msg */
> +	void *hdr = genlmsg_data(NLMSG_DATA(msg->data));
> +
> +	if (genlmsg_end(msg, hdr) < 0)
> +		goto out;
> +
> +	return genlmsg_reply(msg, info);
> +out:
> +	nlmsg_free(msg);
> +	return -ENOBUFS;
> +}
> +#endif
> +
> +
> +static const struct nla_policy vfio_nl_reg_policy[VFIO_NL_ATTR_MAX+1] = {
> +	[VFIO_ATTR_MSGCAP]	= { .type = NLA_U64 },
> +	[VFIO_ATTR_PCI_DOMAIN]	= { .type = NLA_U32 },
> +	[VFIO_ATTR_PCI_BUS]	= { .type = NLA_U16 },
> +	[VFIO_ATTR_PCI_SLOT]	= { .type = NLA_U8 },
> +	[VFIO_ATTR_PCI_FUNC]	= { .type = NLA_U8 },
> +};
> +
> +struct vfio_dev *vfio_nl_get_vdev(struct genl_info *info)
> +{
> +	u32 domain;
> +	u16 bus;
> +	u8 slot, func;
> +	u16 devfn;
> +	struct pci_dev *pdev;
> +	struct vfio_dev *vdev;
> +
> +	domain = nla_get_u32(info->attrs[VFIO_ATTR_PCI_DOMAIN]);
> +	bus = nla_get_u16(info->attrs[VFIO_ATTR_PCI_BUS]);
> +	slot = nla_get_u8(info->attrs[VFIO_ATTR_PCI_SLOT]);
> +	func = nla_get_u8(info->attrs[VFIO_ATTR_PCI_FUNC]);
> +	devfn = PCI_DEVFN(slot, func);
> +	pdev = pci_get_domain_bus_and_slot(domain, bus, devfn);
> +	if (pdev == NULL)
> +		return NULL;
> +	vdev = pci_get_drvdata(pdev);
> +	if (vdev == NULL)
> +		return NULL;
> +	if (vfio_validate(vdev))
> +		return NULL;
> +	if (vdev->pdev != pdev || strncmp(vdev->name, "vfio", 4))
> +		return NULL;
> +	return vdev;
> +}
> +
> +/*
> + * The user driver must register here with a bitmask of which
> + * events it is interested in receiving
> + */
> +static int vfio_nl_user_register(struct sk_buff *skb, struct genl_info *info)
> +{
> +	u64 msgcap;
> +	struct list_head *pos;
> +	struct vfio_nl_client *nlc;
> +	int rc = 0;
> +	struct vfio_dev *vdev;
> +
> +	msgcap = nla_get_u64(info->attrs[VFIO_ATTR_MSGCAP]);
> +	if (msgcap == 0)
> +		return -EINVAL;
> +	vdev = vfio_nl_get_vdev(info);
> +	if (vdev == NULL)
> +		return -EINVAL;
> +
> +	mutex_lock(&vdev->ngate);
> +	list_for_each(pos, &vdev->nlc_list) {
> +		nlc = list_entry(pos, struct vfio_nl_client, list);
> +		if (nlc->pid == info->snd_pid &&
> +		    nlc->net == info->_net)	/* already here */
> +			goto update;
> +	}
> +	nlc = kzalloc(sizeof(struct vfio_nl_client), GFP_KERNEL);
> +	if (nlc == NULL) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +	nlc->pid = info->snd_pid;
> +	nlc->net = info->_net;
> +	list_add(&nlc->list, &vdev->nlc_list);
> +update:
> +	nlc->msgcap = msgcap;
> +out:
> +	mutex_unlock(&vdev->ngate);
> +	return rc;
> +}
> +
> +static const struct nla_policy vfio_nl_err_policy[VFIO_NL_ATTR_MAX+1] = {
> +	[VFIO_ATTR_ERROR_HANDLING_REPLY] = { .type = NLA_U32 },
> +	[VFIO_ATTR_PCI_DOMAIN]	= { .type = NLA_U32 },
> +	[VFIO_ATTR_PCI_BUS]	= { .type = NLA_U16 },
> +	[VFIO_ATTR_PCI_SLOT]	= { .type = NLA_U8 },
> +	[VFIO_ATTR_PCI_FUNC]	= { .type = NLA_U8 },
> +};
> +
> +static int vfio_nl_error_handling_reply(struct sk_buff *skb,
> +					struct genl_info *info)
> +{
> +	u32 value, seq;
> +	struct vfio_dev *vdev;
> +
> +	value = nla_get_u32(info->attrs[VFIO_ATTR_ERROR_HANDLING_REPLY]);
> +	vdev = vfio_nl_get_vdev(info);
> +	if (vdev == NULL)
> +		return -EINVAL;
> +	seq = nlmsg_hdr(skb)->nlmsg_seq;
> +	if (seq > vdev->nl_reply_seq) {
> +		vdev->nl_reply_value = value;
> +		vdev->nl_reply_seq = seq;
> +		wake_up(&vdev->nl_wait_q);
> +	}
> +	return 0;
> +}
> +
> +static const struct nla_policy vfio_nl_pm_policy[VFIO_NL_ATTR_MAX+1] = {
> +	[VFIO_ATTR_PM_SUSPEND_REPLY] = { .type = NLA_U32 },
> +	[VFIO_ATTR_PCI_DOMAIN]	= { .type = NLA_U32 },
> +	[VFIO_ATTR_PCI_BUS]	= { .type = NLA_U16 },
> +	[VFIO_ATTR_PCI_SLOT]	= { .type = NLA_U8 },
> +	[VFIO_ATTR_PCI_FUNC]	= { .type = NLA_U8 },
> +};
> +
> +static int vfio_nl_pm_suspend_reply(struct sk_buff *skb, struct genl_info *info)
> +{
> +	u32 value;
> +	struct vfio_dev *vdev;
> +
> +	value = nla_get_u32(info->attrs[VFIO_ATTR_PM_SUSPEND_REPLY]);
> +	vdev = vfio_nl_get_vdev(info);
> +	if (vdev == NULL)
> +		return -EINVAL;
> +	if (vdev->listeners == 0)
> +		return -EINVAL;
> +	vfio_pm_process_reply(value);
> +	return 0;
> +}
> +
> +void vfio_nl_freeclients(struct vfio_dev *vdev)
> +{
> +	struct list_head *pos, *pos2;
> +	struct vfio_nl_client *nlc;
> +
> +	mutex_lock(&vdev->ngate);
> +	list_for_each_safe(pos, pos2, &vdev->nlc_list) {
> +		nlc = list_entry(pos, struct vfio_nl_client, list);
> +		list_del(&nlc->list);
> +		kfree(nlc);
> +	}
> +	mutex_unlock(&vdev->ngate);
> +}
> +
> +static struct genl_ops vfio_nl_reg_ops = {
> +	.cmd	= VFIO_MSG_REGISTER,
> +	.doit	= vfio_nl_user_register,
> +	.policy	= vfio_nl_reg_policy,
> +};
> +
> +static struct genl_ops vfio_nl_err_ops = {
> +	.cmd	= VFIO_MSG_ERROR_HANDLING_REPLY,
> +	.doit	= vfio_nl_error_handling_reply,
> +	.policy	= vfio_nl_err_policy,
> +};
> +
> +static struct genl_ops vfio_nl_pm_ops = {
> +	.cmd	= VFIO_MSG_PM_SUSPEND_REPLY,
> +	.doit	= vfio_nl_pm_suspend_reply,
> +	.policy	= vfio_nl_pm_policy,
> +};
> +
> +int vfio_nl_init(void)
> +{
> +	int rc;
> +
> +	rc = genl_register_family(&vfio_nl_family);
> +	if (rc)
> +		goto fail;
> +
> +	rc = genl_register_ops(&vfio_nl_family, &vfio_nl_reg_ops);
> +	if (rc < 0)
> +		goto fail;
> +	rc = genl_register_ops(&vfio_nl_family, &vfio_nl_err_ops);
> +	if (rc < 0)
> +		goto fail;
> +	rc = genl_register_ops(&vfio_nl_family, &vfio_nl_pm_ops);
> +	if (rc < 0)
> +		goto fail;
> +	return 0;
> +
> +fail:
> +	genl_unregister_family(&vfio_nl_family);
> +	return rc;
> +}
> +
> +void vfio_nl_exit(void)
> +{
> +	genl_unregister_family(&vfio_nl_family);
> +}
> +
> +int vfio_nl_remove(struct vfio_dev *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct sk_buff *msg;
> +	int rc;
> +
> +	msg = vfio_nl_create(VFIO_MSG_REMOVE);
> +	if (!msg)
> +		return -ENOBUFS;
> +
> +	NLA_PUT_U32(msg, VFIO_ATTR_PCI_DOMAIN, pci_domain_nr(pdev->bus));
> +	NLA_PUT_U16(msg, VFIO_ATTR_PCI_BUS, pdev->bus->number);
> +	NLA_PUT_U8(msg, VFIO_ATTR_PCI_SLOT, PCI_SLOT(pdev->devfn));
> +	NLA_PUT_U8(msg, VFIO_ATTR_PCI_FUNC, PCI_FUNC(pdev->devfn));
> +
> +	rc = vfio_nl_mcast(vdev, msg, VFIO_MSG_REMOVE);
> +	if (rc > 0)
> +		rc = 0;
> +	return rc;
> +
> +nla_put_failure:
> +	nlmsg_free(msg);
> +	return -ENOBUFS;
> +}
> +
> +int vfio_nl_upcall(struct vfio_dev *vdev, u8 type, int state, int waitret)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct sk_buff *msg;
> +	u32 seq;
> +
> +	msg = vfio_nl_create(type);
> +	if (!msg)
> +		goto null_out;
> +	seq = nlmsg_hdr(msg)->nlmsg_seq;
> +
> +	NLA_PUT_U32(msg, VFIO_ATTR_PCI_DOMAIN, pci_domain_nr(pdev->bus));
> +	NLA_PUT_U16(msg, VFIO_ATTR_PCI_BUS, pdev->bus->number);
> +	NLA_PUT_U8(msg, VFIO_ATTR_PCI_SLOT, PCI_SLOT(pdev->devfn));
> +	NLA_PUT_U8(msg, VFIO_ATTR_PCI_FUNC, PCI_FUNC(pdev->devfn));
> +
> +	if (type == VFIO_MSG_ERROR_DETECTED)
> +		NLA_PUT_U32(msg, VFIO_ATTR_CHANNEL_STATE, state);
> +
> +	if (vfio_nl_mcast(vdev, msg, type) <= 0)
> +		goto null_out;
> +	if (!waitret)
> +		return 0;
> +
> +	/* sleep for reply */
> +	if (wait_event_interruptible_timeout(vdev->nl_wait_q,
> +	    (vdev->nl_reply_seq >= seq), VFIO_ERROR_REPLY_TIMEOUT) <= 0) {
> +		printk(KERN_ERR "vfio upcall timeout\n");
> +		goto null_out;
> +	}
> +	if (seq != vdev->nl_reply_seq)
> +		goto null_out;
> +	return vdev->nl_reply_value;
> +
> +nla_put_failure:
> +	nlmsg_free(msg);
> +null_out:
> +	return -1;
> +}
> +
> +/* the following routines invoked for pci error handling */
> +
> +pci_ers_result_t vfio_error_detected(struct pci_dev *pdev,
> +					pci_channel_state_t state)
> +{
> +	struct vfio_dev *vdev = pci_get_drvdata(pdev);
> +	int ret;
> +
> +	ret = vfio_nl_upcall(vdev, VFIO_MSG_ERROR_DETECTED, (int)state, 1);
> +	if (ret >= 0)
> +		return ret;
> +	return PCI_ERS_RESULT_NONE;
> +}
> +
> +pci_ers_result_t vfio_mmio_enabled(struct pci_dev *pdev)
> +{
> +	struct vfio_dev *vdev = pci_get_drvdata(pdev);
> +	int ret;
> +
> +	ret = vfio_nl_upcall(vdev, VFIO_MSG_MMIO_ENABLED, 0, 1);
> +	if (ret >= 0)
> +		return ret;
> +	return PCI_ERS_RESULT_NONE;
> +}
> +
> +pci_ers_result_t vfio_link_reset(struct pci_dev *pdev)
> +{
> +	struct vfio_dev *vdev = pci_get_drvdata(pdev);
> +	int ret;
> +
> +	ret = vfio_nl_upcall(vdev, VFIO_MSG_LINK_RESET, 0, 1);
> +	if (ret >= 0)
> +		return ret;
> +	return PCI_ERS_RESULT_NONE;
> +}
> +
> +pci_ers_result_t vfio_slot_reset(struct pci_dev *pdev)
> +{
> +	struct vfio_dev *vdev = pci_get_drvdata(pdev);
> +	int ret;
> +
> +	ret = vfio_nl_upcall(vdev, VFIO_MSG_SLOT_RESET, 0, 1);
> +	if (ret >= 0)
> +		return ret;
> +	return PCI_ERS_RESULT_NONE;
> +}
> +
> +void vfio_error_resume(struct pci_dev *pdev)
> +{
> +	struct vfio_dev *vdev = pci_get_drvdata(pdev);
> +
> +	(void) vfio_nl_upcall(vdev, VFIO_MSG_ERROR_RESUME, 0, 0);
> +}
> diff --git a/drivers/vfio/vfio_pci_config.c b/drivers/vfio/vfio_pci_config.c
> new file mode 100644
> index 0000000..b7de0bf
> --- /dev/null
> +++ b/drivers/vfio/vfio_pci_config.c
> @@ -0,0 +1,698 @@
> +/*
> + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> + * Author: Tom Lyon, pugs@cisco.com
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + * Portions derived from drivers/uio/uio.c:
> + * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
> + * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
> + * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
> + * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
> + *
> + * Portions derived from drivers/uio/uio_pci_generic.c:
> + * Copyright (C) 2009 Red Hat, Inc.
> + * Author: Michael S. Tsirkin <mst@redhat.com>
> + */
> +
> +/*
> + * This code handles reading and writing of PCI configuration registers.
> + * This is hairy because we want to allow a lot of flexibility to the
> + * user driver, but cannot trust it with all of the config fields.
> + * Tables determine which fields can be read and written, as well as
> + * which fields are 'virtualized' - special actions and translations to
> + * make it appear to the user that he has control, when in fact things
> + * must be negotiated with the underlying OS.
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/pci.h>
> +#include <linux/mmu_notifier.h>
> +#include <linux/uaccess.h>
> +#include <linux/vfio.h>
> +
> +#define PCI_CAP_ID_BASIC	0
> +#ifndef PCI_CAP_ID_MAX
> +#define	PCI_CAP_ID_MAX		PCI_CAP_ID_AF
> +#endif
> +
> +/*
> + * Lengths of PCI Config Capabilities
> + * 0 means unknown (but at least 4)
> + * FF means special/variable
> + */
> +static u8 pci_capability_length[] = {
> +	[PCI_CAP_ID_BASIC]	= 64,		/* pci config header */
> +	[PCI_CAP_ID_PM]		= PCI_PM_SIZEOF,
> +	[PCI_CAP_ID_AGP]	= PCI_AGP_SIZEOF,
> +	[PCI_CAP_ID_VPD]	= 8,
> +	[PCI_CAP_ID_SLOTID]	= 4,
> +	[PCI_CAP_ID_MSI]	= 0xFF,		/* 10, 14, 20, or 24 */
> +	[PCI_CAP_ID_CHSWP]	= 4,
> +	[PCI_CAP_ID_PCIX]	= 0xFF,		/* 8 or 24 */
> +	[PCI_CAP_ID_HT]		= 28,
> +	[PCI_CAP_ID_VNDR]	= 0xFF,
> +	[PCI_CAP_ID_DBG]	= 0,
> +	[PCI_CAP_ID_CCRC]	= 0,
> +	[PCI_CAP_ID_SHPC]	= 0,
> +	[PCI_CAP_ID_SSVID]	= 0,		/* bridge only - not supp */
> +	[PCI_CAP_ID_AGP3]	= 0,
> +	[PCI_CAP_ID_EXP]	= 36,
> +	[PCI_CAP_ID_MSIX]	= 12,
> +	[PCI_CAP_ID_AF]		= 6,
> +};
> +
> +/*
> + * Read/Write Permission Bits - one bit for each bit in capability
> + * Any field can be read if it exists,
> + * but what is read depends on whether the field
> + * is 'virtualized', or just pass thru to the hardware.
> + * Any virtualized field is also virtualized for writes.
> + * Writes are only permitted if they have a 1 bit here.
> + */
> +struct perm_bits {
> +	u32	rvirt;		/* read bits which must be virtualized */
> +	u32	write;		/* writeable bits - virt if read virt */
> +};
> +
> +static struct perm_bits pci_cap_basic_perm[] = {
> +	{ 0xFFFFFFFF,	0, },		/* 0x00 vendor & device id - RO */
> +	{ 0x00000003,	0xFFFFFFFF, },	/* 0x04 cmd - mem & io bits virt */
> +	{ 0,		0, },		/* 0x08 class code & revision id */
> +	{ 0,		0xFF00FFFF, },	/* 0x0c bist, htype, lat, cache */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x10 bar */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x14 bar */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x18 bar */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x1c bar */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x20 bar */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x24 bar */
> +	{ 0,		0, },		/* 0x28 cardbus - not yet */
> +	{ 0,		0, },		/* 0x2c subsys vendor & dev */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x30 rom bar */
> +	{ 0,		0, },		/* 0x34 capability ptr & resv */
> +	{ 0,		0, },		/* 0x38 resv */
> +	{ 0x000000FF,	0x000000FF, },	/* 0x3c max_lat ... irq */
> +};
> +
> +static struct perm_bits pci_cap_pm_perm[] = {
> +	{ 0,		0, },		/* 0x00 PM capabilities */
> +	{ 0,		0xFFFFFFFF, },	/* 0x04 PM control/status */
> +};
> +
> +static struct perm_bits pci_cap_vpd_perm[] = {
> +	{ 0,		0xFFFF0000, },	/* 0x00 address */
> +	{ 0,		0xFFFFFFFF, },	/* 0x04 data */
> +};
> +
> +static struct perm_bits pci_cap_slotid_perm[] = {
> +	{ 0,		0, },		/* 0x00 all read only */
> +};
> +
> +/* 4 different possible layouts of MSI capability */
> +static struct perm_bits pci_cap_msi_10_perm[] = {
> +	{ 0x00FF0000,	0x00FF0000, },	/* 0x00 MSI message control */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
> +	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x08 MSI message data */
> +};
> +static struct perm_bits pci_cap_msi_14_perm[] = {
> +	{ 0x00FF0000,	0x00FF0000, },	/* 0x00 MSI message control */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x08 MSI message upper addr */
> +	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x0c MSI message data */
> +};
> +static struct perm_bits pci_cap_msi_20_perm[] = {
> +	{ 0x00FF0000,	0x00FF0000, },	/* 0x00 MSI message control */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
> +	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x08 MSI message data */
> +	{ 0,		0xFFFFFFFF, },	/* 0x0c MSI mask bits */
> +	{ 0,		0xFFFFFFFF, },	/* 0x10 MSI pending bits */
> +};
> +static struct perm_bits pci_cap_msi_24_perm[] = {
> +	{ 0x00FF0000,	0x00FF0000, },	/* 0x00 MSI message control */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x08 MSI message upper addr */
> +	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x0c MSI message data */
> +	{ 0,		0xFFFFFFFF, },	/* 0x10 MSI mask bits */
> +	{ 0,		0xFFFFFFFF, },	/* 0x14 MSI pending bits */
> +};
> +
> +static struct perm_bits pci_cap_pcix_perm[] = {
> +	{ 0,		0xFFFF0000, },	/* 0x00 PCI_X_CMD */
> +	{ 0,		0, },		/* 0x04 PCI_X_STATUS */
> +	{ 0,		0xFFFFFFFF, },	/* 0x08 ECC ctlr & status */
> +	{ 0,		0, },		/* 0x0c ECC first addr */
> +	{ 0,		0, },		/* 0x10 ECC second addr */
> +	{ 0,		0, },		/* 0x14 ECC attr */
> +};
> +
> +/* pci express capabilities */
> +static struct perm_bits pci_cap_exp_perm[] = {
> +	{ 0,		0, },		/* 0x00 PCIe capabilities */
> +	{ 0,		0, },		/* 0x04 PCIe device capabilities */
> +	{ 0,		0xFFFFFFFF, },	/* 0x08 PCIe device control & status */
> +	{ 0,		0, },		/* 0x0c PCIe link capabilities */
> +	{ 0,		0x000000FF, },	/* 0x10 PCIe link ctl/stat - SAFE? */
> +	{ 0,		0, },		/* 0x14 PCIe slot capabilities */
> +	{ 0,		0x00FFFFFF, },	/* 0x18 PCIe link ctl/stat - SAFE? */
> +	{ 0,		0, },		/* 0x1c PCIe root port stuff */
> +	{ 0,		0, },		/* 0x20 PCIe root port stuff */
> +};
> +
> +static struct perm_bits pci_cap_msix_perm[] = {
> +	{ 0,		0, },		/* 0x00 MSI-X Enable */
> +	{ 0,		0, },		/* 0x04 table offset & bir */
> +	{ 0,		0, },		/* 0x08 pba offset & bir */
> +};
> +
> +static struct perm_bits pci_cap_af_perm[] = {
> +	{ 0,		0, },		/* 0x00 af capability */
> +	{ 0,		0x0001,	 },	/* 0x04 af flr bit */
> +};
> +
> +static struct perm_bits *pci_cap_perms[] = {
> +	[PCI_CAP_ID_BASIC]	= pci_cap_basic_perm,
> +	[PCI_CAP_ID_PM]		= pci_cap_pm_perm,
> +	[PCI_CAP_ID_VPD]	= pci_cap_vpd_perm,
> +	[PCI_CAP_ID_SLOTID]	= pci_cap_slotid_perm,
> +	[PCI_CAP_ID_MSI]	= NULL,			/* special */
> +	[PCI_CAP_ID_PCIX]	= pci_cap_pcix_perm,
> +	[PCI_CAP_ID_EXP]	= pci_cap_exp_perm,
> +	[PCI_CAP_ID_MSIX]	= pci_cap_msix_perm,
> +	[PCI_CAP_ID_AF]		= pci_cap_af_perm,
> +};
> +
> +static int vfio_msi_cap_len(struct vfio_dev *vdev, u8 pos)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	int len;
> +	int ret;
> +	u16 flags;
> +
> +	ret = pci_read_config_word(pdev, pos + PCI_MSI_FLAGS, &flags);
> +	if (ret < 0)
> +		return ret;
> +	if (flags & PCI_MSI_FLAGS_64BIT)
> +		len = 14;
> +	else
> +		len = 10;
> +	if (flags & PCI_MSI_FLAGS_MASKBIT)
> +		len += 10;
> +
> +	switch (len) {
> +	case 10:
> +		vdev->msi_perm = pci_cap_msi_10_perm;
> +		break;
> +	case 14:
> +		vdev->msi_perm = pci_cap_msi_14_perm;
> +		break;
> +	case 20:
> +		vdev->msi_perm = pci_cap_msi_20_perm;
> +		break;
> +	case 24:
> +		vdev->msi_perm = pci_cap_msi_24_perm;
> +		break;
> +	}
> +	return len;
> +}
> +
> +/*
> + * We build a map of the config space that tells us where
> + * and what capabilities exist, so that we can map reads and
> + * writes back to capabilities, and thus figure out what to
> + * allow, deny, or virtualize
> + */
> +int vfio_build_config_map(struct vfio_dev *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	u8 *map;
> +	int i, len;
> +	u8 pos, cap, tmp;
> +	u16 flags;
> +	int ret;
> +#ifndef PCI_FIND_CAP_TTL
> +#define PCI_FIND_CAP_TTL	48
> +#endif
> +	int loops = PCI_FIND_CAP_TTL;
> +
> +	map = kmalloc(pdev->cfg_size, GFP_KERNEL);
> +	if (map == NULL)
> +		return -ENOMEM;
> +	for (i = 0; i < pdev->cfg_size; i++)
> +		map[i] = 0xFF;
> +	vdev->pci_config_map = map;
> +
> +	/* default config space */
> +	for (i = 0; i < pci_capability_length[0]; i++)
> +		map[i] = 0;
> +
> +	/* any capabilities? */
> +	ret = pci_read_config_word(pdev, PCI_STATUS, &flags);
> +	if (ret < 0)
> +		return ret;
> +	if ((flags & PCI_STATUS_CAP_LIST) == 0)
> +		return 0;
> +
> +	ret = pci_read_config_byte(pdev, PCI_CAPABILITY_LIST, &pos);
> +	if (ret < 0)
> +		return ret;
> +	while (pos && --loops > 0) {
> +		ret = pci_read_config_byte(pdev, pos, &cap);
> +		if (ret < 0)
> +			return ret;
> +		if (cap == 0) {
> +			printk(KERN_WARNING "%s: cap 0\n", __func__);
> +			break;
> +		}
> +		if (cap > PCI_CAP_ID_MAX) {
> +			printk(KERN_WARNING "%s: unknown pci capability id %x\n",
> +					__func__, cap);
> +			len = 0;
> +		} else
> +			len = pci_capability_length[cap];
> +		if (len == 0) {
> +			printk(KERN_WARNING "%s: unknown length for pci cap %x\n",
> +					__func__, cap);
> +			len = 4;
> +		}
> +		if (len == 0xFF) {
> +			switch (cap) {
> +			case PCI_CAP_ID_MSI:
> +				len = vfio_msi_cap_len(vdev, pos);
> +				if (len < 0)
> +					return len;
> +				break;
> +			case PCI_CAP_ID_PCIX:
> +				ret = pci_read_config_word(pdev, pos + 2,
> +					&flags);
> +				if (ret < 0)
> +					return ret;
> +				if (flags & 0x3000)
> +					len = 24;
> +				else
> +					len = 8;
> +				break;
> +			case PCI_CAP_ID_VNDR:
> +				/* length follows next field */
> +				ret = pci_read_config_byte(pdev, pos + 2, &tmp);
> +				if (ret < 0)
> +					return ret;
> +				len = tmp;
> +				break;
> +			default:
> +				len = 0;
> +				break;
> +			}
> +		}
> +
> +		for (i = 0; i < len; i++) {
> +			if (map[pos+i] != 0xFF)
> +				printk(KERN_WARNING
> +					"%s: pci config conflict at %x, "
> +					"caps %x %x\n",
> +					__func__, i, map[pos+i], cap);
> +			map[pos+i] = cap;
> +		}
> +		ret = pci_read_config_byte(pdev, pos + PCI_CAP_LIST_NEXT, &pos);
> +		if (ret < 0)
> +			return ret;
> +	}
> +	if (loops <= 0)
> +		printk(KERN_ERR "%s: config space loop!\n", __func__);
> +	return 0;
> +}
> +
> +static int vfio_virt_init(struct vfio_dev *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	u32 *lp;
> +	int i;
> +
> +	vdev->vconfig = kmalloc(256, GFP_KERNEL);
> +	if (vdev->vconfig == NULL)
> +		return -ENOMEM;
> +
> +	lp = (u32 *)vdev->vconfig;
> +	for (i = 0; i < 256/sizeof(u32); i++, lp++)
> +		pci_read_config_dword(pdev, i * sizeof(u32), lp);
> +	vdev->bardirty = 1;
> +
> +	vdev->rbar[0] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
> +	vdev->rbar[1] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_1];
> +	vdev->rbar[2] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_2];
> +	vdev->rbar[3] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_3];
> +	vdev->rbar[4] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_4];
> +	vdev->rbar[5] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_5];
> +	vdev->rbar[6] = *(u32 *)&vdev->vconfig[PCI_ROM_ADDRESS];
> +
> +	/* for sr-iov devices */
> +	vdev->vconfig[PCI_VENDOR_ID] = pdev->vendor & 0xFF;
> +	vdev->vconfig[PCI_VENDOR_ID+1] = pdev->vendor >> 8;
> +	vdev->vconfig[PCI_DEVICE_ID] = pdev->device & 0xFF;
> +	vdev->vconfig[PCI_DEVICE_ID+1] = pdev->device >> 8;
> +
> +	return 0;
> +}
> +
> +/*
> + * Restore the *real* BARs after we detect a backdoor reset.
> + * (backdoor = some device specific technique that we didn't catch)
> + */
> +static void vfio_bar_restore(struct vfio_dev *vdev)
> +{
> +	printk(KERN_WARNING "%s: restoring real bars\n", __func__);
> +
> +#define do_bar(off, which) \
> +	pci_user_write_config_dword(vdev->pdev, off, vdev->rbar[which])
> +
> +	do_bar(PCI_BASE_ADDRESS_0, 0);
> +	do_bar(PCI_BASE_ADDRESS_1, 1);
> +	do_bar(PCI_BASE_ADDRESS_2, 2);
> +	do_bar(PCI_BASE_ADDRESS_3, 3);
> +	do_bar(PCI_BASE_ADDRESS_4, 4);
> +	do_bar(PCI_BASE_ADDRESS_5, 5);
> +	do_bar(PCI_ROM_ADDRESS, 6);
> +#undef do_bar
> +}
> +
> +/*
> + * Pretend we're hardware and tweak the values
> + * of the *virtual* pci BARs to reflect the hardware
> + * capabilities
> + */
> +static void vfio_bar_fixup(struct vfio_dev *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	int bar;
> +	u32 *lp;
> +	u64 mask;
> +
> +	for (bar = 0; bar <= 5; bar++) {
> +		if (pci_resource_start(pdev, bar))
> +			mask = ~(pci_resource_len(pdev, bar) - 1);
> +		else
> +			mask = 0;
> +		lp = (u32 *)vdev->vconfig + PCI_BASE_ADDRESS_0 + 4*bar;
> +		*lp &= (u32)mask;
> +
> +		if (pci_resource_flags(pdev, bar) & IORESOURCE_IO)
> +			*lp |= PCI_BASE_ADDRESS_SPACE_IO;
> +		else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
> +			*lp |= PCI_BASE_ADDRESS_SPACE_MEMORY;
> +			if (pci_resource_flags(pdev, bar) & IORESOURCE_PREFETCH)
> +				*lp |= PCI_BASE_ADDRESS_MEM_PREFETCH;
> +			if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM_64) {
> +				*lp |= PCI_BASE_ADDRESS_MEM_TYPE_64;
> +				lp++;
> +				*lp &= (u32)(mask >> 32);
> +				bar++;
> +			}
> +		}
> +	}
> +
> +	if (pci_resource_start(pdev, PCI_ROM_RESOURCE))
> +		mask = ~(pci_resource_len(pdev, PCI_ROM_RESOURCE) - 1);
> +	else
> +		mask = 0;
> +	lp = (u32 *)vdev->vconfig + PCI_ROM_ADDRESS;
> +	*lp &= (u32)mask;
> +
> +	vdev->bardirty = 0;
> +}
> +
> +static inline int vfio_read_config_byte(struct vfio_dev *vdev,
> +					int pos, u8 *valp)
> +{
> +	return pci_user_read_config_byte(vdev->pdev, pos, valp);
> +}
> +
> +static inline int vfio_write_config_byte(struct vfio_dev *vdev,
> +					int pos, u8 val)
> +{
> +	vdev->vconfig[pos] = val;
> +	return pci_user_write_config_byte(vdev->pdev, pos, val);
> +}
> +
> +static int vfio_config_rwbyte(int write,
> +				struct vfio_dev *vdev,
> +				int pos,
> +				char __user *buf)
> +{
> +	u8 *map = vdev->pci_config_map;
> +	u8 cap, val, newval;
> +	u16 start, off;
> +	int p;
> +	struct perm_bits *perm;
> +	u8 wr, virt;
> +	int ret;
> +
> +	cap = map[pos];
> +	if (cap == 0xFF) {	/* unknown region */
> +		if (write)
> +			return 0;	/* silent no-op */
> +		val = 0;
> +		if (pos <= pci_capability_length[0])	/* ok to read */
> +			(void) vfio_read_config_byte(vdev, pos, &val);
> +		if (copy_to_user(buf, &val, 1))
> +			return -EFAULT;
> +		return 0;
> +	}
> +
> +	/* scan back to start of cap region */
> +	for (p = pos; p >= 0; p--) {
> +		if (map[p] != cap)
> +			break;
> +		start = p;
> +	}
> +	off = pos - start;	/* offset within capability */
> +
> +	if (cap == PCI_CAP_ID_MSI)
> +		perm = vdev->msi_perm;
> +	else
> +		perm = pci_cap_perms[cap];
> +	if (perm == NULL) {
> +		wr = 0;
> +		virt = 0;
> +	} else {
> +		perm += (off >> 2);
> +		wr = perm->write >> ((off & 3) * 8);
> +		virt = perm->rvirt >> ((off & 3) * 8);
> +	}
> +	if (write && !wr)		/* no writeable bits */
> +		return 0;
> +	if (!virt) {
> +		if (write) {
> +			if (copy_from_user(&val, buf, 1))
> +				return -EFAULT;
> +			val &= wr;
> +			if (wr != 0xFF) {
> +				u8 existing;
> +
> +				ret = vfio_read_config_byte(vdev, pos,
> +							&existing);
> +				if (ret < 0)
> +					return ret;
> +				val |= (existing & ~wr);
> +			}
> +			vfio_write_config_byte(vdev, pos, val);
> +		} else {
> +			ret = vfio_read_config_byte(vdev, pos, &val);
> +			if (ret < 0)
> +				return ret;
> +			if (copy_to_user(buf, &val, 1))
> +				return -EFAULT;
> +		}
> +		return 0;
> +	}
> +
> +	if (write) {
> +		if (copy_from_user(&newval, buf, 1))
> +			return -EFAULT;
> +	}
> +	/*
> +	 * We get here if there are some virt bits
> +	 * handle remaining real bits, if any
> +	 */
> +	if (~virt) {
> +		u8 rbits = (~virt) & wr;
> +
> +		ret = vfio_read_config_byte(vdev, pos, &val);
> +		if (ret < 0)
> +			return ret;
> +		if (write && rbits) {
> +			val &= ~rbits;
> +			val |= (newval & rbits);
> +			vfio_write_config_byte(vdev, pos, val);
> +		}
> +	}
> +	/*
> +	 * Now handle entirely virtual fields
> +	 */
> +	switch (cap) {
> +	case PCI_CAP_ID_BASIC:		/* virtualize BARs */
> +		switch (off) {
> +		/*
> +		 * vendor and device are virt because they don't
> +		 * show up otherwise for sr-iov vfs
> +		 */
> +		case PCI_VENDOR_ID:
> +		case PCI_VENDOR_ID + 1:
> +		case PCI_DEVICE_ID:
> +		case PCI_DEVICE_ID + 1:
> +			/* read only */
> +			val = vdev->vconfig[pos];
> +			break;
> +		case PCI_COMMAND:
> +			/*
> +			 * If the real mem or IO enable bits are zero
> +			 * then there may have been a backdoor reset.
> +			 * Restore the real BARs before allowing those
> +			 * bits to re-enable
> +			 */
> +			if (vdev->pdev->is_virtfn)
> +				val |= PCI_COMMAND_MEMORY;
> +			if (write) {
> +				int upd = 0;
> +
> +				upd = (newval & PCI_COMMAND_MEMORY) >
> +				      (val & PCI_COMMAND_MEMORY);
> +				upd += (newval & PCI_COMMAND_IO) >
> +				       (val & PCI_COMMAND_IO);
> +				if (upd)
> +					vfio_bar_restore(vdev);
> +				vfio_write_config_byte(vdev, pos, newval);
> +			}
> +			break;
> +		case PCI_INTERRUPT_LINE:
> +			if (write)
> +				vdev->vconfig[pos] = newval;
> +			else
> +				val = vdev->vconfig[pos];
> +			break;
> +		case PCI_BASE_ADDRESS_0:
> +		case PCI_BASE_ADDRESS_0+1:
> +		case PCI_BASE_ADDRESS_0+2:
> +		case PCI_BASE_ADDRESS_0+3:
> +		case PCI_BASE_ADDRESS_1:
> +		case PCI_BASE_ADDRESS_1+1:
> +		case PCI_BASE_ADDRESS_1+2:
> +		case PCI_BASE_ADDRESS_1+3:
> +		case PCI_BASE_ADDRESS_2:
> +		case PCI_BASE_ADDRESS_2+1:
> +		case PCI_BASE_ADDRESS_2+2:
> +		case PCI_BASE_ADDRESS_2+3:
> +		case PCI_BASE_ADDRESS_3:
> +		case PCI_BASE_ADDRESS_3+1:
> +		case PCI_BASE_ADDRESS_3+2:
> +		case PCI_BASE_ADDRESS_3+3:
> +		case PCI_BASE_ADDRESS_4:
> +		case PCI_BASE_ADDRESS_4+1:
> +		case PCI_BASE_ADDRESS_4+2:
> +		case PCI_BASE_ADDRESS_4+3:
> +		case PCI_BASE_ADDRESS_5:
> +		case PCI_BASE_ADDRESS_5+1:
> +		case PCI_BASE_ADDRESS_5+2:
> +		case PCI_BASE_ADDRESS_5+3:
> +		case PCI_ROM_ADDRESS:
> +		case PCI_ROM_ADDRESS+1:
> +		case PCI_ROM_ADDRESS+2:
> +		case PCI_ROM_ADDRESS+3:
> +			if (write) {
> +				vdev->vconfig[pos] = newval;
> +				vdev->bardirty = 1;
> +			} else {
> +				if (vdev->bardirty)
> +					vfio_bar_fixup(vdev);
> +				val = vdev->vconfig[pos];
> +			}
> +			break;
> +		}
> +		break;
> +	case PCI_CAP_ID_MSI:		/* virtualize (parts of) MSI */
> +		if (off == PCI_MSI_FLAGS) {
> +			u8 num;
> +
> +			if (write) {
> +				if (vdev->ev_msi == NULL)
> +					newval &= ~PCI_MSI_FLAGS_ENABLE;
> +				num = (newval & PCI_MSI_FLAGS_QSIZE) >> 4;
> +				if (num > vdev->msi_qmax)
> +					num = vdev->msi_qmax;
> +				newval &= ~PCI_MSI_FLAGS_QSIZE;
> +				newval |= num << 4;
> +				vfio_write_config_byte(vdev, pos, newval);
> +			} else {
> +				ret = vfio_read_config_byte(vdev, pos, &val);
> +				if (ret < 0)
> +					return ret;
> +				val &= ~PCI_MSI_FLAGS_QMASK;
> +				val |= vdev->msi_qmax << 1;
> +			}
> +		} else {
> +			if (write)
> +				vdev->vconfig[pos] = newval;
> +			else
> +				val = vdev->vconfig[pos];
> +		}
> +		break;
> +	}
> +	if (!write && copy_to_user(buf, &val, 1))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +ssize_t vfio_config_readwrite(int write,
> +		struct vfio_dev *vdev,
> +		char __user *buf,
> +		size_t count,
> +		loff_t *ppos)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	int done = 0;
> +	int ret;
> +	u16 pos;
> +
> +
> +	if (vdev->pci_config_map == NULL) {
> +		ret = vfio_build_config_map(vdev);
> +		if (ret)
> +			goto out;
> +	}
> +	if (vdev->vconfig == NULL) {
> +		ret = vfio_virt_init(vdev);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	while (count > 0) {
> +		pos = *ppos;
> +		if (pos == pdev->cfg_size)
> +			break;
> +		if (pos > pdev->cfg_size) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		ret = vfio_config_rwbyte(write, vdev, pos, buf);
> +
> +		if (ret < 0)
> +			goto out;
> +		buf++;
> +		done++;
> +		count--;
> +		(*ppos)++;
> +	}
> +	ret = done;
> +out:
> +	return ret;
> +}
> diff --git a/drivers/vfio/vfio_rdwr.c b/drivers/vfio/vfio_rdwr.c
> new file mode 100644
> index 0000000..1fd50a6
> --- /dev/null
> +++ b/drivers/vfio/vfio_rdwr.c
> @@ -0,0 +1,158 @@
> +/*
> + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> + * Author: Tom Lyon, pugs@cisco.com
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + * Portions derived from drivers/uio/uio.c:
> + * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
> + * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
> + * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
> + * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
> + *
> + * Portions derived from drivers/uio/uio_pci_generic.c:
> + * Copyright (C) 2009 Red Hat, Inc.
> + * Author: Michael S. Tsirkin <mst@redhat.com>
> + */
> +
> +/*
> + * This code handles normal read and write system calls; allowing
> + * access to device memory or I/O registers
> + * without the need for mmap'ing.
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/mmu_notifier.h>
> +#include <linux/pci.h>
> +#include <linux/uaccess.h>
> +#include <linux/io.h>
> +
> +#include <linux/vfio.h>
> +
> +ssize_t vfio_io_readwrite(
> +		int write,
> +		struct vfio_dev *vdev,
> +		char __user *buf,
> +		size_t count,
> +		loff_t *ppos)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	size_t done = 0;
> +	resource_size_t end;
> +	void __iomem *io;
> +	loff_t pos;
> +	int pci_space;
> +	int unit;
> +
> +	pci_space = vfio_offset_to_pci_space(*ppos);
> +	pos = vfio_offset_to_pci_offset(*ppos);
> +
> +	if (!pci_resource_start(pdev, pci_space))
> +		return -EINVAL;
> +	end = pci_resource_len(pdev, pci_space);
> +	if (pos + count > end)
> +		return -EINVAL;
> +	if (vdev->barmap[pci_space] == NULL)
> +		vdev->barmap[pci_space] = pci_iomap(pdev, pci_space, 0);
> +	io = vdev->barmap[pci_space];
> +
> +	while (count > 0) {
> +		if ((pos % 4) == 0 && count >= 4) {
> +			u32 val;
> +
> +			if (write) {
> +				if (copy_from_user(&val, buf, 4))
> +					return -EFAULT;
> +				iowrite32(val, io + pos);
> +			} else {
> +				val = ioread32(io + pos);
> +				if (copy_to_user(buf, &val, 4))
> +					return -EFAULT;
> +			}
> +			unit = 4;
> +		} else if ((pos % 2) == 0 && count >= 2) {
> +			u16 val;
> +
> +			if (write) {
> +				if (copy_from_user(&val, buf, 2))
> +					return -EFAULT;
> +				iowrite16(val, io + pos);
> +			} else {
> +				val = ioread16(io + pos);
> +				if (copy_to_user(buf, &val, 2))
> +					return -EFAULT;
> +			}
> +			unit = 2;
> +		} else {
> +			u8 val;
> +
> +			if (write) {
> +				if (copy_from_user(&val, buf, 1))
> +					return -EFAULT;
> +				iowrite8(val, io + pos);
> +			} else {
> +				val = ioread8(io + pos);
> +				if (copy_to_user(buf, &val, 1))
> +					return -EFAULT;
> +			}
> +			unit = 1;
> +		}
> +		pos += unit;
> +		buf += unit;
> +		count -= unit;
> +		done += unit;
> +	}
> +	*ppos += done;
> +	return done;
> +}

Can we export and use pci_write_legacy_io? Same for read.
Drivers don't do unaligned accesses, do they?

> +
> +ssize_t vfio_mem_readwrite(
> +		int write,
> +		struct vfio_dev *vdev,
> +		char __user *buf,
> +		size_t count,
> +		loff_t *ppos)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	resource_size_t end;
> +	void __iomem *io;
> +	loff_t pos;
> +	int pci_space;
> +
> +	pci_space = vfio_offset_to_pci_space(*ppos);
> +	pos = vfio_offset_to_pci_offset(*ppos);
> +
> +	if (!pci_resource_start(pdev, pci_space))
> +		return -EINVAL;
> +	end = pci_resource_len(pdev, pci_space);
> +	if (vdev->barmap[pci_space] == NULL)
> +		vdev->barmap[pci_space] = pci_iomap(pdev, pci_space, 0);
> +	io = vdev->barmap[pci_space];
> +
> +	if (pos > end)
> +		return -EINVAL;
> +	if (pos == end)
> +		return 0;
> +	if (pos + count > end)
> +		count = end - pos;
> +	if (write) {
> +		if (copy_from_user(io + pos, buf, count))
> +			return -EFAULT;
> +	} else {
> +		if (copy_to_user(buf, io + pos, count))
> +			return -EFAULT;
> +	}
> +	*ppos += count;
> +	return count;
> +}
> diff --git a/drivers/vfio/vfio_sysfs.c b/drivers/vfio/vfio_sysfs.c
> new file mode 100644
> index 0000000..a3ddba1
> --- /dev/null
> +++ b/drivers/vfio/vfio_sysfs.c
> @@ -0,0 +1,118 @@
> +/*
> + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> + * Author: Tom Lyon, pugs@cisco.com
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + * Portions derived from drivers/uio/uio.c:
> + * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
> + * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
> + * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
> + * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
> + *
> + * Portions derived from drivers/uio/uio_pci_generic.c:
> + * Copyright (C) 2009 Red Hat, Inc.
> + * Author: Michael S. Tsirkin <mst@redhat.com>
> + */
> +
> +/*
> + * This code handles vfio related files in sysfs
> + * (not much useful yet)
> + */
> +
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/kobject.h>
> +#include <linux/sysfs.h>
> +#include <linux/mm.h>
> +#include <linux/fs.h>
> +#include <linux/pci.h>
> +#include <linux/mmu_notifier.h>
> +
> +#include <linux/vfio.h>
> +
> +struct vfio_class *vfio_class;
> +
> +int vfio_class_init(void)
> +{
> +	int ret = 0;
> +
> +	if (vfio_class != NULL) {
> +		kref_get(&vfio_class->kref);
> +		goto exit;
> +	}
> +
> +	vfio_class = kzalloc(sizeof(*vfio_class), GFP_KERNEL);
> +	if (!vfio_class) {
> +		ret = -ENOMEM;
> +		goto err_kzalloc;
> +	}
> +
> +	kref_init(&vfio_class->kref);
> +	vfio_class->class = class_create(THIS_MODULE, "vfio");
> +	if (IS_ERR(vfio_class->class)) {
> +		ret = IS_ERR(vfio_class->class);
> +		printk(KERN_ERR "class_create failed for vfio\n");
> +		goto err_class_create;
> +	}
> +	return 0;
> +
> +err_class_create:
> +	kfree(vfio_class);
> +	vfio_class = NULL;
> +err_kzalloc:
> +exit:
> +	return ret;
> +}
> +
> +static void vfio_class_release(struct kref *kref)
> +{
> +	/* Ok, we cheat as we know we only have one vfio_class */
> +	class_destroy(vfio_class->class);
> +	kfree(vfio_class);
> +	vfio_class = NULL;
> +}
> +
> +void vfio_class_destroy(void)
> +{
> +	if (vfio_class)
> +		kref_put(&vfio_class->kref, vfio_class_release);
> +}
> +
> +static ssize_t show_locked_pages(struct device *dev,
> +				 struct device_attribute *attr,
> +				 char *buf)
> +{
> +	struct vfio_dev *vdev = dev_get_drvdata(dev);
> +
> +	if (vdev == NULL)
> +		return -ENODEV;
> +	return sprintf(buf, "%u\n", vdev->locked_pages);
> +}
> +
> +static DEVICE_ATTR(locked_pages, S_IRUGO, show_locked_pages, NULL);
> +
> +static struct attribute *vfio_attrs[] = {
> +	&dev_attr_locked_pages.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group vfio_attr_grp = {
> +	.attrs = vfio_attrs,
> +};
> +
> +int vfio_dev_add_attributes(struct vfio_dev *vdev)
> +{
> +	return sysfs_create_group(&vdev->dev->kobj, &vfio_attr_grp);
> +}
> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index 2fc8e14..3121529 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -167,6 +167,7 @@ header-y += ultrasound.h
>  header-y += un.h
>  header-y += utime.h
>  header-y += veth.h
> +header-y += vfio.h
>  header-y += videotext.h
>  header-y += x25.h
>  
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> new file mode 100644
> index 0000000..b7dd524
> --- /dev/null
> +++ b/include/linux/vfio.h
> @@ -0,0 +1,267 @@
> +/*
> + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> + * Author: Tom Lyon, pugs@cisco.com
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + * Portions derived from drivers/uio/uio.c:
> + * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
> + * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
> + * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
> + * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
> + *
> + * Portions derived from drivers/uio/uio_pci_generic.c:
> + * Copyright (C) 2009 Red Hat, Inc.
> + * Author: Michael S. Tsirkin <mst@redhat.com>
> + */
> +#include <linux/types.h>
> +
> +/*
> + * VFIO driver - allow mapping and use of certain PCI devices
> + * in unprivileged user processes. (If IOMMU is present)
> + * Especially useful for Virtual Function parts of SR-IOV devices
> + */
> +
> +#ifdef __KERNEL__
> +
> +struct vfio_nl_client {
> +	struct list_head	list;
> +	u64			msgcap;
> +	struct net		*net;
> +	u32			pid;
> +};
> +
> +struct perm_bits;
> +struct vfio_dev {
> +	struct device	*dev;
> +	struct pci_dev	*pdev;
> +	char		name[8];
> +	u8		*pci_config_map;
> +	int		pci_config_size;
> +	int		devnum;
> +	void __iomem	*barmap[PCI_ROM_RESOURCE+1];
> +	spinlock_t	irqlock;	/* guards command register accesses */
> +	int		listeners;
> +	u32		locked_pages;
> +	struct mutex	lgate;		/* listener gate */
> +	struct mutex	dgate;		/* dma op gate */
> +	struct mutex	igate;		/* intr op gate */
> +	struct mutex	ngate;		/* netlink op gate */
> +	struct list_head nlc_list;	/* netlink clients */
> +	wait_queue_head_t dev_idle_q;
> +	wait_queue_head_t nl_wait_q;
> +	u32		nl_reply_seq;
> +	u32		nl_reply_value;
> +	int		mapcount;
> +	struct uiommu_domain	*udomain;
> +	int			cachec;
> +	struct msix_entry	*msix;
> +	struct eventfd_ctx	*ev_irq;
> +	struct eventfd_ctx	**ev_msi;
> +	struct eventfd_ctx	**ev_msix;
> +	int			msi_nvec;
> +	int			msix_nvec;
> +	u8		*vconfig;
> +	u32		rbar[7];	/* copies of real bars */
> +	u8		msi_qmax;
> +	u8		bardirty;
> +	struct perm_bits	*msi_perm;
> +};
> +
> +struct vfio_listener {
> +	struct vfio_dev	*vdev;
> +	struct list_head	dm_list;
> +	struct mm_struct	*mm;
> +	struct mmu_notifier	mmu_notifier;
> +};
> +
> +/*
> + * Structure for keeping track of memory nailed down by the
> + * user for DMA
> + */
> +struct dma_map_page {
> +	struct list_head list;
> +	struct page     **pages;
> +	dma_addr_t      daddr;
> +	unsigned long	vaddr;
> +	int		npage;
> +	int		rdwr;
> +};
> +
> +/* VFIO class infrastructure */
> +struct vfio_class {
> +	struct kref kref;
> +	struct class *class;
> +};
> +extern struct vfio_class *vfio_class;
> +
> +ssize_t vfio_io_readwrite(int, struct vfio_dev *,
> +			char __user *, size_t, loff_t *);
> +ssize_t vfio_mem_readwrite(int, struct vfio_dev *,
> +			char __user *, size_t, loff_t *);
> +ssize_t vfio_config_readwrite(int, struct vfio_dev *,
> +			char __user *, size_t, loff_t *);
> +
> +void vfio_drop_msi(struct vfio_dev *);
> +void vfio_drop_msix(struct vfio_dev *);
> +int vfio_setup_msi(struct vfio_dev *, int, void __user *);
> +int vfio_setup_msix(struct vfio_dev *, int, void __user *);
> +
> +#ifndef PCI_MSIX_ENTRY_SIZE
> +#define	PCI_MSIX_ENTRY_SIZE	16
> +#endif
> +#ifndef PCI_STATUS_INTERRUPT
> +#define	PCI_STATUS_INTERRUPT	0x08
> +#endif
> +
> +struct vfio_dma_map;
> +void vfio_dma_unmapall(struct vfio_listener *);
> +int vfio_dma_unmap_dm(struct vfio_listener *, struct vfio_dma_map *);
> +int vfio_dma_map_common(struct vfio_listener *, unsigned int,
> +			struct vfio_dma_map *);
> +int vfio_domain_set(struct vfio_dev *, int, int);
> +int vfio_domain_unset(struct vfio_dev *);
> +
> +int vfio_class_init(void);
> +void vfio_class_destroy(void);
> +int vfio_dev_add_attributes(struct vfio_dev *);
> +int vfio_build_config_map(struct vfio_dev *);
> +
> +int vfio_nl_init(void);
> +void vfio_nl_freeclients(struct vfio_dev *);
> +void vfio_nl_exit(void);
> +int vfio_nl_remove(struct vfio_dev *);
> +int vfio_validate(struct vfio_dev *);
> +int vfio_nl_upcall(struct vfio_dev *, u8, int, int);
> +void vfio_pm_process_reply(int);
> +pci_ers_result_t vfio_error_detected(struct pci_dev *, pci_channel_state_t);
> +pci_ers_result_t vfio_mmio_enabled(struct pci_dev *);
> +pci_ers_result_t vfio_link_reset(struct pci_dev *);
> +pci_ers_result_t vfio_slot_reset(struct pci_dev *);
> +void vfio_error_resume(struct pci_dev *);
> +#define VFIO_ERROR_REPLY_TIMEOUT	(3*HZ)
> +#define VFIO_SUSPEND_REPLY_TIMEOUT	(5*HZ)
> +
> +irqreturn_t vfio_interrupt(int, void *);
> +
> +#endif	/* __KERNEL__ */
> +
> +/* Kernel & User level defines for ioctls */
> +
> +/*
> + * Structure for DMA mapping of user buffers
> + * vaddr, dmaaddr, and size must all be page aligned
> + * buffer may only be larger than 1 page if (a) there is
> + * an iommu in the system, or (b) buffer is part of a huge page
> + */
> +struct vfio_dma_map {
> +	__u64	vaddr;		/* process virtual addr */
> +	__u64	dmaaddr;	/* desired and/or returned dma address */
> +	__u64	size;		/* size in bytes */
> +	__u64	flags;		/* bool: 0 for r/o; 1 for r/w */
> +#define	VFIO_FLAG_WRITE		0x1	/* req writeable DMA mem */
> +};
> +
> +/* map user pages at specific dma address */
> +/* requires previous VFIO_DOMAIN_SET */
> +#define	VFIO_DMA_MAP_IOVA	_IOWR(';', 101, struct vfio_dma_map)
> +
> +/* unmap user pages */
> +#define	VFIO_DMA_UNMAP		_IOW(';', 102, struct vfio_dma_map)
> +
> +/* request IRQ interrupts; use given eventfd */
> +#define	VFIO_EVENTFD_IRQ	_IOW(';', 103, int)
> +
> +/* Request MSI interrupts: arg[0] is #, arg[1-n] are eventfds */
> +#define	VFIO_EVENTFDS_MSI	_IOW(';', 104, int)
> +
> +/* Request MSI-X interrupts: arg[0] is #, arg[1-n] are eventfds */
> +#define	VFIO_EVENTFDS_MSIX	_IOW(';', 105, int)
> +
> +/* Get length of a BAR */
> +#define	VFIO_BAR_LEN		_IOWR(';', 167, __u32)
> +
> +/* Set the IOMMU domain - arg is fd from uiommu driver */
> +#define	VFIO_DOMAIN_SET		_IOW(';', 107, int)
> +
> +/* Unset the IOMMU domain */
> +#define	VFIO_DOMAIN_UNSET	_IO(';', 108)
> +
> +/*
> + * Reads, writes, and mmaps determine which PCI BAR (or config space)
> + * from the high level bits of the file offset
> + */
> +#define	VFIO_PCI_BAR0_RESOURCE		0x0
> +#define	VFIO_PCI_BAR1_RESOURCE		0x1
> +#define	VFIO_PCI_BAR2_RESOURCE		0x2
> +#define	VFIO_PCI_BAR3_RESOURCE		0x3
> +#define	VFIO_PCI_BAR4_RESOURCE		0x4
> +#define	VFIO_PCI_BAR5_RESOURCE		0x5
> +#define	VFIO_PCI_ROM_RESOURCE		0x6
> +#define	VFIO_PCI_CONFIG_RESOURCE	0xF
> +#define	VFIO_PCI_SPACE_SHIFT	32
> +#define VFIO_PCI_CONFIG_OFF vfio_pci_space_to_offset(VFIO_PCI_CONFIG_RESOURCE)
> +
> +static inline int vfio_offset_to_pci_space(__u64 off)
> +{
> +	return (off >> VFIO_PCI_SPACE_SHIFT) & 0xF;
> +}
> +
> +static inline __u32 vfio_offset_to_pci_offset(__u64 off)
> +{
> +	return off & (__u32)0xFFFFFFFF;

You don't really need the cast, do you?

> +}
> +
> +static inline __u64 vfio_pci_space_to_offset(int sp)
> +{
> +	return (__u64)(sp) << VFIO_PCI_SPACE_SHIFT;
> +}
> +

Is this ever used besides VFIO_PCI_CONFIG_OFF?
If not it's likely an overkill.
If yes note that sp will get sign extended when cast.

> +/*
> + * Netlink defines:
> + */
> +#define VFIO_GENL_NAME	"VFIO"
> +
> +/* message types */
> +enum {
> +	VFIO_MSG_INVAL = 0,
> +	/* kernel to user */
> +	VFIO_MSG_REMOVE,		/* unbind, module or hotplug remove */
> +	VFIO_MSG_ERROR_DETECTED,	/* pci err handling - error detected */
> +	VFIO_MSG_MMIO_ENABLED,		/* pci err handling - mmio enabled */
> +	VFIO_MSG_LINK_RESET,		/* pci err handling - link reset */
> +	VFIO_MSG_SLOT_RESET,		/* pci err handling - slot reset */
> +	VFIO_MSG_ERROR_RESUME,		/* pci err handling - resume normal */
> +	VFIO_MSG_PM_SUSPEND,		/* suspend or hibernate notification */
> +	VFIO_MSG_PM_RESUME,		/* resume after suspend or hibernate */
> +	/* user to kernel */
> +	VFIO_MSG_REGISTER,
> +	VFIO_MSG_ERROR_HANDLING_REPLY,	/* err handling reply */
> +	VFIO_MSG_PM_SUSPEND_REPLY,	/* suspend notify reply */
> +};
> +
> +/* attributes */
> +enum {
> +	VFIO_ATTR_UNSPEC,
> +	VFIO_ATTR_MSGCAP,	/* bitmask of messages desired */
> +	VFIO_ATTR_PCI_DOMAIN,
> +	VFIO_ATTR_PCI_BUS,
> +	VFIO_ATTR_PCI_SLOT,
> +	VFIO_ATTR_PCI_FUNC,
> +	VFIO_ATTR_CHANNEL_STATE,
> +	VFIO_ATTR_ERROR_HANDLING_REPLY,
> +	VFIO_ATTR_PM_SUSPEND_REPLY,
> +	__VFIO_NL_ATTR_MAX
> +};
> +#define VFIO_NL_ATTR_MAX (__VFIO_NL_ATTR_MAX - 1)
> -- 
> 1.6.0.2
