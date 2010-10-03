Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab0JCMea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 08:34:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab0JCMe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 08:34:28 -0400
Date: Sun, 3 Oct 2010 14:27:52 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tom Lyon <pugs@cisco.com>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        randy.dunlap@oracle.com, arnd@arndb.de, joro@8bytes.org,
        hjk@linutronix.de, avi@redhat.com, gregkh@suse.de, chrisw@sous-sol.org,
        alex.williamson@redhat.com
Subject: Re: [PATCH 3/3] VFIO V4: VFIO driver: Non-privileged user level PCI
 drivers
Message-ID: <20101003122752.GA17867@redhat.com>
References: <4c9a72a0.u2cnjUB7QZ91tLeo%pugs@cisco.com>
 <20100926145419.GA21843@redhat.com>
 <201009301443.11604.pugs@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009301443.11604.pugs@cisco.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 02:43:11PM -0700, Tom Lyon wrote:
> > > +	vdev->mapcount--;
> > > +	listener->mm->locked_vm -= mlp->npage;
> > 
> > Is there a race against mlock call here?
> Alas, yes. I took another look at the related infiniband code, and now
> have adopted their way of doing it.

Just make sure to hang on to the mm and decrement locked_vm
on close in the same mm where you incremented it. Remember
that you can not be sure that the same process which
locked memory is holding the last reference to the fd.

> > Can address become unaligned? Most logic seems to assume
> > an aligned address ...
> Just extra paranoia.

BUG_ON/WARN_ON then so we catch the bugs?

...

> > 
> > > +			printk(KERN_WARNING
> > > +				"%s: demap start %lx end %lx va %lx pa %lx\n",
> > > +				__func__, start, end,
> > > +				mlp->vaddr, (long)mlp->daddr);
> > > +			vfio_dma_unmap(listener, mlp);
> > 
> > And then what would happen? How does user interpret this warning?
> > How can driver/device recover?
> It's just a warning that the buffer was demapped due to mmu notifier, instead 
> of explicitly.  If the user code accidentally frees or reuses its buffers this 
> can happen.

Can malicious userspace use this to fill kernel log with warnings?

....

> > > +int vfio_dma_map_common(struct vfio_listener *listener,
> > > +		unsigned int cmd, struct vfio_dma_map *dmp)
> > > +{
> > > +	int locked, lock_limit;
> > > +	struct page **pages;
> > > +	int npage;
> > > +	struct dma_map_page *mlp;
> > > +	int rdwr = (dmp->flags & VFIO_FLAG_WRITE) ? 1 : 0;
> > > +	int ret = 0;
> > > +
> > > +	if (dmp->vaddr & (PAGE_SIZE-1))
> > > +		return -EINVAL;
> > > +	if (dmp->size & (PAGE_SIZE-1))
> > > +		return -EINVAL;
> > 
> > size must be full pages? Maybe document this?
> Its in the header file and Doc file.

Documention at source is better than in header IMHO.

> > 
> > > +	if (dmp->size <= 0)
> > 
> > It's u64. Can it be < 0?
> More paranoia.


BUG_ON too?

> > 
> > > +		return -EINVAL;
> > > +	npage = dmp->size >> PAGE_SHIFT;
> Added a check for max size - 4G for now.

It's a signed int - so 2G?

> > 
> > This assignment can overflow the integer.
> > 
> > > +	if (npage <= 0)
> > > +		return -EINVAL;
> > > +
> > > +	mutex_lock(&listener->vdev->dgate);
> > > +
> > > +	/* account for locked pages */
> > > +	locked = npage + current->mm->locked_vm;
> > 
> > Again this can race against mlock I think.
> Yes.
> 
> > 
> > > +	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur
> > > +			>> PAGE_SHIFT;
> > > +	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
> > 
> > rlimit/capability access might also be racy: don't we need
> > task lock for that?
> Noone else seems to take a task lock for this sort of thing. Can you point me 
> at task lock code?

If not a lock, we should at least use rlimit() function I think: this is what
e.g. kernel/perf_event.c does - so we go through ACCESS_ONCE and get
a consistent value.

> > 
> > > +		printk(KERN_WARNING "%s: RLIMIT_MEMLOCK exceeded\n",
> > > +			__func__);
> > > +		ret = -ENOMEM;
> > > +		goto out_lock;
> > > +	}
> > > +	/* only 1 address space per fd */
> > > +	if (current->mm != listener->mm) {
> > > +		if (listener->mm != NULL) {
> > > +			ret = -EINVAL;
> > > +			goto out_lock;
> > > +		}
> > > +		listener->mm = current->mm;
> > > +#ifdef CONFIG_MMU_NOTIFIER
> > > +		listener->mmu_notifier.ops = &vfio_dma_mmu_notifier_ops;
> > > +		ret = mmu_notifier_register(&listener->mmu_notifier,
> > > +						listener->mm);
> > > +		if (ret)
> > > +			printk(KERN_ERR "%s: mmu_notifier_register failed %d\n",
> > > +				__func__, ret);
> > > +		ret = 0;
> > 
> > What exactly are you doing with the notifiers?
> > This driver seems to lock all DMA memory, how can
> > it get moved?
> > And why is an error ignored?
> The physical pages get locked, but the mmu notifier detects when the virtual 
> pages get re-used without an intervening de-map.

Well it detects but then all it does it just a printk.
And in fact, all such buggy userspace does is hurt itself
as pages are still locked. Right?
So it it's just a debugging tool, maybe we are better
off without it in a default build - it's a non-inconsiderable
amount of code, and it does add overhead to mmu operations.

> > 
> > > +#endif
> > > +	}
> > > +
> > > +	pages = vmalloc(npage * sizeof(struct page *));
> > 
> > npage comes from userspace? What if it's a huge value?
> > Also, on a 32 bit system, we will run out of vmalloc space
> > quickly if we let userspace tie it up indefinitely ...
> > This is slow path - maybe just lock pages one by one?
> Still have to lock and remember all the locked pages.

Yes but then you can use a linked list.

>  Max lock size of 4G will help this.

It's still 1M page pointers. On 32 bit systems this is 4M
of vmalloc space so you will quickly drink up all vmalloc
space with these.

> 
> > 
> > > +	if (pages == NULL) {
> > > +		ret = ENOMEM;
> > > +		goto out_lock;
> > > +	}
> > > +	ret = get_user_pages_fast(dmp->vaddr, npage, rdwr, pages);
> > > +	if (ret != npage) {
> > > +		printk(KERN_ERR "%s: get_user_pages_fast returns %d, not %d\n",
> > > +			__func__, ret, npage);
> > > +		kfree(pages);
> > > +		ret = -EFAULT;
> > > +		goto out_lock;
> > > +	}
> > > +	ret = 0;
> > > +
> > > +	mlp = vfio_dma_map_iova(listener, dmp->dmaaddr,
> > > +				pages, npage, rdwr);
> > > +	if (IS_ERR(mlp)) {
> > > +		ret = PTR_ERR(mlp);
> > > +		vfree(pages);
> > > +		goto out_lock;
> > > +	}
> > > +	mlp->vaddr = dmp->vaddr;
> > > +	mlp->rdwr = rdwr;
> > > +	dmp->dmaaddr = mlp->daddr;
> > > +	list_add(&mlp->list, &listener->dm_list);
> > > +
> > > +	current->mm->locked_vm += npage;
> > > +	listener->vdev->locked_pages += npage;
> > 
> > This looks too aggressive.
> > So if you want to use 2 devices, you will
> > have to double the mlock rlimit for the process?
> If you know 2 devices are in the same domain, you don't have to repeat the 
> call. If you don't know, then you might double lock pages.

Hmm. If you assign devices A and B, lock through device A,
then close device A, will pages stay locked until you
close B?

> > 
> > I think this ioctl would be better done
> > on the iommu device than on vfio: all it does
> > is pass calls to iommu anyway.
> > The you can share locking between devices.
> Yes, but you have to carry around another fd

Seems a very small price to pay - what's another 4 byte integer?



....

> > > +
> > > +int vfio_setup_msi(struct vfio_dev *vdev, int nvec, void __user *uarg)
> > > +{
> > > +	struct pci_dev *pdev = vdev->pdev;
> > > +	struct eventfd_ctx *ctx;
> > > +	int i, n, l2;
> > > +	int ret = 0;
> > > +	int fd;
> > > +
> > > +	if (nvec < 1 || nvec > 32)
> > > +		return -EINVAL;
> > > +	vdev->ev_msi = kzalloc(nvec * sizeof(struct eventfd_ctx *),
> > > +				GFP_KERNEL);
> > > +	if (vdev->ev_msi == NULL)
> > > +		return -ENOMEM;
> > > +
> > > +	for (i = 0; i < nvec; i++) {
> > > +		if (copy_from_user(&fd, uarg, sizeof fd)) {
> > > +			ret = -EFAULT;
> > > +			break;
> > > +		}
> > > +		uarg += sizeof fd;
> > > +		ctx = eventfd_ctx_fdget(fd);
> > > +		if (IS_ERR(ctx)) {
> > > +			ret = PTR_ERR(ctx);
> > > +			break;
> > 
> > so goto out here?
> Why?

So that error handling is easier to follow.
I find the way it's written hard to follow:
you break followed by another goto after the loop. And you rely on ret
being set to 0 before. It's easier for the reader if you
just unroll this and put the goto to the right place:
further, then ret does not need to get initialized,
and it is only used as return code, not as exit condition.
As a bonus, compiler will warn if ret is used uninitialized somewhere.

> > 
> > > +		}
> > > +		vdev->ev_msi[i] = ctx;
> > > +	}
> > > +	if (ret)
> > > +		goto out;
> > > +	ret = pci_enable_msi_block(pdev, nvec);
> > > +	if (ret) {
> > > +		if (ret > 0)
> > > +			ret = -EINVAL;
> > > +		goto out;
> > > +	}
> > > +	for (i = 0; i < nvec; i++) {
> > > +		ret = request_irq(pdev->irq + i, msihandler, 0,
> > > +			vdev->name, vdev->ev_msi[i]);
> > > +		if (ret)
> > > +			break;
> > > +		vdev->msi_nvec = i+1;
> > > +	}
> > > +
> > > +	/*
> > > +	 * compute the virtual hardware field for max msi vectors -
> > > +	 * it is the log base 2 of the number of vectors
> > > +	 */
> > > +	l2 = 0;
> > > +	n = vdev->msi_nvec;
> > > +	if (n >= (1 << 4)) {
> > > +		n >>= 4;
> > > +		l2 += 4;
> > > +	}
> > > +	if (n >= (1 << 2)) {
> > > +		n >>= 2;
> > > +		l2 += 2;
> > > +	}
> > > +	if (n >= (1 << 1))
> > > +		l2 += 1;
> > 
> > what is this doing? Will using fls() help?
> It is computing log2(n) for n <= 32. I added a comment.

So why can't we just use fls? you want the # of high bit - 1,
and for exact powers of 2 subtract 1.

l2 = fls(n * 2 - 1) - 1

Much less code, isn't it?


...

> > > +#include <linux/module.h>
> > > +#include <linux/device.h>
> > > +#include <linux/mm.h>
> > > +#include <linux/idr.h>
> > > +#include <linux/string.h>
> > > +#include <linux/interrupt.h>
> > > +#include <linux/fs.h>
> > > +#include <linux/eventfd.h>
> > > +#include <linux/pci.h>
> > > +#include <linux/iommu.h>
> > > +#include <linux/mmu_notifier.h>
> > > +#include <linux/uaccess.h>
> > > +#include <linux/suspend.h>
> > > +
> > > +#include <linux/vfio.h>
> > > +
> > > +
> > > +#define DRIVER_VERSION	"0.1"
> > > +#define DRIVER_AUTHOR	"Tom Lyon <pugs@cisco.com>"
> > > +#define DRIVER_DESC	"VFIO - User Level PCI meta-driver"
> > > +
> > > +/*
> > > + * Only a very few platforms today (Intel X7500) fully support
> > > + * both DMA remapping and interrupt remapping in the IOMMU.
> > > + * Everyone has DMA remapping but interrupt remapping is missing
> > > + * in some Intel hardware and software, and its missing in the AMD
> > > + * IOMMU software. Interrupt remapping is needed to really protect the
> > > + * system from user level driver mischief.  Until it is in more
> > > platforms + * we allow the admin to load the module with
> > > allow_unsafe_intrs=1 + * which will make this driver useful (but not
> > > safe)
> > > + * on those platforms.
> > > + */
> > > +static int allow_unsafe_intrs;
> > > +module_param(allow_unsafe_intrs, int, 0);
> > > +
> > > +static int vfio_major = -1;
> > > +static DEFINE_IDR(vfio_idr);
> > > +static int vfio_max_minor;
> > > +/* Protect idr accesses */
> > > +static DEFINE_MUTEX(vfio_minor_lock);
> > > +
> > > +/*
> > > + * Does [a1,b1) overlap [a2,b2) ?
> > > + */
> > > +static inline int overlap(int a1, int b1, int a2, int b2)
> > > +{
> > > +	/*
> > > +	 * Ranges overlap if they're not disjoint; and they're
> > > +	 * disjoint if the end of one is before the start of
> > > +	 * the other one.
> > > +	 */
> > > +	return !(b2 <= a1 || b1 <= a2);
> > > +}
> > > +
> > > +static int vfio_open(struct inode *inode, struct file *filep)
> > > +{
> > > +	struct vfio_dev *vdev;
> > > +	struct vfio_listener *listener;
> > > +	int ret = 0;
> > > +
> > > +	mutex_lock(&vfio_minor_lock);
> > > +	vdev = idr_find(&vfio_idr, iminor(inode));
> > > +	mutex_unlock(&vfio_minor_lock);
> > > +	if (!vdev) {
> > > +		ret = -ENODEV;
> > > +		goto out;
> > > +	}
> > > +
> > > +	listener = kzalloc(sizeof(*listener), GFP_KERNEL);
> > > +	if (!listener) {
> > > +		ret = -ENOMEM;
> > > +		goto out;
> > > +	}
> > > +
> > > +	mutex_lock(&vdev->lgate);
> > > +	listener->vdev = vdev;
> > > +	INIT_LIST_HEAD(&listener->dm_list);
> > > +	filep->private_data = listener;
> > > +	if (vdev->listeners == 0)
> > > +		ret = pci_enable_device(vdev->pdev);
> > 
> > Why would you want to enable device on open?
> > Doing this later when domain is set would add an extra level of
> > protection as device would reject reads/writes when not enabled.
> Unfortunately, pci_enable_device does some black magic with pci_bios_enable 
> which is platform dependent and which I don't really understand.  I'm pretty 
> sure this has to be there before an assignment to an iommu.

Hmm, didn't check, but I note that OTOH you disable device before
you deassign from iommu?

> > 
> > 
> > Also, don't you want to do pci_set_master at some point?
> No, the user code can do it and the rest of the kernel doesn't care once  its 
> under the iommu.

Hmm, the only thing I see it doing is set busmaster field,
is that only used on resume?

> > > +	if (ret == 0)
> > 
> > !ret or better if (ret)
> > 		 goto err;
> OK.
> 
> > 
> > > +		vdev->listeners++;
> > > +	mutex_unlock(&vdev->lgate);
> > > +	if (ret)
> > > +		kfree(listener);
> > 
> > this error handling is
> > 
> > > +out:
> > > +	return ret;
> > > +}
> > > +
> > > +static int vfio_release(struct inode *inode, struct file *filep)
> > > +{
> > > +	int ret = 0;
> > > +	struct vfio_listener *listener = filep->private_data;
> > > +	struct vfio_dev *vdev = listener->vdev;
> > > +
> > > +	vfio_dma_unmapall(listener);
> > > +	if (listener->mm) {
> > > +#ifdef CONFIG_MMU_NOTIFIER
> > > +		mmu_notifier_unregister(&listener->mmu_notifier, listener->mm);
> > > +#endif
> > > +		listener->mm = NULL;
> > > +	}
> > > +
> > > +	mutex_lock(&vdev->lgate);
> > > +	if (--vdev->listeners <= 0) {
> > > +		/* we don't need to hold igate here since there are
> > > +		 * no more listeners doing ioctls
> > > +		 */
> > > +		if (vdev->ev_msix)
> > > +			vfio_drop_msix(vdev);
> > > +		if (vdev->ev_msi)
> > > +			vfio_drop_msi(vdev);
> > > +		if (vdev->ev_irq) {
> > > +			eventfd_ctx_put(vdev->ev_irq);
> > > +			vdev->ev_irq = NULL;
> > > +		}
> > > +		kfree(vdev->vconfig);
> > > +		vdev->vconfig = NULL;
> > > +		kfree(vdev->pci_config_map);
> > > +		vdev->pci_config_map = NULL;
> > > +		pci_disable_device(vdev->pdev);
> > > +		vfio_domain_unset(vdev);
> > 
> > This does not seem to remove bus master before close.
> > If the userspace driver dies, and device is doing DMA
> > into userspace, what will prevent DMA after
> > you unset the domain?
> Actually, pci_disable_device does little else than disable bus master.

Full reset might be better ...

> > 
> > > +		wake_up(&vdev->dev_idle_q);
> > > +	}
> > > +	mutex_unlock(&vdev->lgate);
> > > +
> > > +	kfree(listener);
> > > +	return ret;
> > > +}
> > > +
> > > +static ssize_t vfio_read(struct file *filep, char __user *buf,
> > > +			size_t count, loff_t *ppos)
> > > +{
> > > +	struct vfio_listener *listener = filep->private_data;
> > > +	struct vfio_dev *vdev = listener->vdev;
> > > +	struct pci_dev *pdev = vdev->pdev;
> > > +	int pci_space;
> > > +
> > > +	pci_space = vfio_offset_to_pci_space(*ppos);
> > > +
> > > +	/* config reads are OK before iommu domain set */
> > > +	if (pci_space == VFIO_PCI_CONFIG_RESOURCE)
> > > +		return vfio_config_readwrite(0, vdev, buf, count, ppos);
> > > +
> > > +	/* no other reads until IOMMU domain set */
> > > +	if (vdev->udomain == NULL)
> > > +		return -EINVAL;
> > > +	if (pci_space > PCI_ROM_RESOURCE)
> > > +		return -EINVAL;
> > > +	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_IO)
> > > +		return vfio_io_readwrite(0, vdev, buf, count, ppos);
> > > +	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM)
> > > +		return vfio_mem_readwrite(0, vdev, buf, count, ppos);
> > > +	if (pci_space == PCI_ROM_RESOURCE)
> > > +		return vfio_mem_readwrite(0, vdev, buf, count, ppos);
> > > +	return -EINVAL;
> > > +}
> > > +
> > > +static int vfio_msix_check(struct vfio_dev *vdev, u64 start, u32 len)
> > > +{
> > > +	struct pci_dev *pdev = vdev->pdev;
> > > +	u16 pos;
> > > +	u32 table_offset;
> > > +	u16 table_size;
> > > +	u8 bir;
> > > +	u32 lo, hi, startp, endp;
> > > +
> > > +	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
> > > +	if (!pos)
> > > +		return 0;
> > > +
> > > +	pci_read_config_word(pdev, pos + PCI_MSIX_FLAGS, &table_size);
> > > +	table_size = (table_size & PCI_MSIX_FLAGS_QSIZE) + 1;
> > > +	pci_read_config_dword(pdev, pos + 4, &table_offset);
> > > +	bir = table_offset & PCI_MSIX_FLAGS_BIRMASK;
> > > +	lo = table_offset >> PAGE_SHIFT;
> > > +	hi = (table_offset + PCI_MSIX_ENTRY_SIZE * table_size + PAGE_SIZE - 
> 1)
> > > +		>> PAGE_SHIFT;
> > > +	startp = start >> PAGE_SHIFT;
> > > +	endp = (start + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > > +	if (bir == vfio_offset_to_pci_space(start) &&
> > > +	    overlap(lo, hi, startp, endp)) {
> > > +		printk(KERN_WARNING "%s: cannot write msi-x vectors\n",
> > > +			__func__);
> > > +		return -EINVAL;
> > > +	}
> > > +	return 0;
> > > +}
> > > +
> > > +static ssize_t vfio_write(struct file *filep, const char __user *buf,
> > > +			size_t count, loff_t *ppos)
> > > +{
> > > +	struct vfio_listener *listener = filep->private_data;
> > > +	struct vfio_dev *vdev = listener->vdev;
> > > +	struct pci_dev *pdev = vdev->pdev;
> > > +	int pci_space;
> > > +	int ret;
> > > +
> > > +	/* no writes until IOMMU domain set */
> > > +	if (vdev->udomain == NULL)
> > > +		return -EINVAL;
> > > +	pci_space = vfio_offset_to_pci_space(*ppos);
> > > +	if (pci_space == VFIO_PCI_CONFIG_RESOURCE)
> > > +		return vfio_config_readwrite(1, vdev,
> > > +					(char __user *)buf, count, ppos);
> > > +	if (pci_space > PCI_ROM_RESOURCE)
> > > +		return -EINVAL;
> > > +	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_IO)
> > > +		return vfio_io_readwrite(1, vdev,
> > > +					(char __user *)buf, count, ppos);
> > > +	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM) {
> > > +		if (allow_unsafe_intrs) {
> > > +			/* don't allow writes to msi-x vectors */
> > > +			ret = vfio_msix_check(vdev, *ppos, count);
> > > +			if (ret)
> > > +				return ret;
> > > +		}
> > > +		return vfio_mem_readwrite(1, vdev,
> > > +				(char __user *)buf, count, ppos);
> > > +	}
> > > +	return -EINVAL;
> > > +}
> > > +
> > > +static int vfio_mmap(struct file *filep, struct vm_area_struct *vma)
> > > +{
> > > +	struct vfio_listener *listener = filep->private_data;
> > > +	struct vfio_dev *vdev = listener->vdev;
> > > +	struct pci_dev *pdev = vdev->pdev;
> > > +	unsigned long requested, actual;
> > > +	int pci_space;
> > > +	u64 start;
> > > +	u32 len;
> > > +	unsigned long phys;
> > > +	int ret;
> > > +
> > > +	/* no reads or writes until IOMMU domain set */
> > > +	if (vdev->udomain == NULL)
> > > +		return -EINVAL;
> > 
> > What happens if user creates a mapping when domain is
> > set, and then removes it with DOMAIN_UNSET ioctl?
> > Can't userdpace access an unprotected device now?
> >  we should just drop DOMAIN_UNSET, and document
> > that iommu can not be changed once set.
> Unset returns EBUSY if mappings are still in place.

How exactly does it work?

> But I don't expect anyone to bother with unsets.


Actually, another issue - there is no ioctl to reset the device,
is there? I think we need one, to call e.g. on system reset.

...

> > > +	if (pdev->irq > 0) {
> > > +		err = request_irq(pdev->irq, vfio_interrupt,
> > > +				  IRQF_SHARED, vdev->name, vdev);
> > > +		if (err)
> > > +			goto err_request_irq;
> > 
> > Since this is a sahred interrupt, you will get called
> > even if MSI in device is enabled, which will confuse
> > users. How about requesting irq upon an ioctl?
> OK, now requested at ioctl and freed on release.

And hopefully there's an ioctl to free as well.
As I said, qemu needs a way to reset the fd to
original state without closing it.

....

> > Is this ever used besides VFIO_PCI_CONFIG_OFF?
> > If not it's likely an overkill.
> > If yes note that sp will get sign extended when cast.
> Can be used when accessing different bar areas.

So a negative sp will get you a strange result.

> > 
> > > +/*
> > > + * Netlink defines:
> > > + */
> > > +#define VFIO_GENL_NAME	"VFIO"
> > > +
> > > +/* message types */
> > > +enum {
> > > +	VFIO_MSG_INVAL = 0,
> > > +	/* kernel to user */
> > > +	VFIO_MSG_REMOVE,		/* unbind, module or hotplug remove */
> > > +	VFIO_MSG_ERROR_DETECTED,	/* pci err handling - error detected */
> > > +	VFIO_MSG_MMIO_ENABLED,		/* pci err handling - mmio enabled */
> > > +	VFIO_MSG_LINK_RESET,		/* pci err handling - link reset */
> > > +	VFIO_MSG_SLOT_RESET,		/* pci err handling - slot reset */
> > > +	VFIO_MSG_ERROR_RESUME,		/* pci err handling - resume normal */
> > > +	VFIO_MSG_PM_SUSPEND,		/* suspend or hibernate notification */
> > > +	VFIO_MSG_PM_RESUME,		/* resume after suspend or hibernate */
> > > +	/* user to kernel */
> > > +	VFIO_MSG_REGISTER,
> > > +	VFIO_MSG_ERROR_HANDLING_REPLY,	/* err handling reply */
> > > +	VFIO_MSG_PM_SUSPEND_REPLY,	/* suspend notify reply */
> > > +};
> > > +
> > > +/* attributes */
> > > +enum {
> > > +	VFIO_ATTR_UNSPEC,
> > > +	VFIO_ATTR_MSGCAP,	/* bitmask of messages desired */
> > > +	VFIO_ATTR_PCI_DOMAIN,
> > > +	VFIO_ATTR_PCI_BUS,
> > > +	VFIO_ATTR_PCI_SLOT,
> > > +	VFIO_ATTR_PCI_FUNC,
> > > +	VFIO_ATTR_CHANNEL_STATE,
> > > +	VFIO_ATTR_ERROR_HANDLING_REPLY,
> > > +	VFIO_ATTR_PM_SUSPEND_REPLY,
> > > +	__VFIO_NL_ATTR_MAX
> > > +};
> > > +#define VFIO_NL_ATTR_MAX (__VFIO_NL_ATTR_MAX - 1)
