Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab0DAAPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 20:15:17 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:28779 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab0DAAPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 20:15:14 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am8IAGOCs0urR7Hu/2dsb2JhbACDEpgocRwBm3+IQ5BUgSuBKhIIgSdqBIMj
X-IronPort-AV: E=Sophos;i="4.51,344,1267401600"; 
   d="scan'208";a="506393640"
From: Tom Lyon <pugs@lyon-about.com>
To: kvm@vger.kernel.org
Subject: [PATCH 1/1] uio_pci_generic: extensions to allow access for non-privileged processes
Date: Wed, 31 Mar 2010 17:12:35 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, mst@redhat.com
References: <201003311708.38961.pugs@lyon-about.com>
In-Reply-To: <201003311708.38961.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003311712.36105.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


diff -rupN linux-2.6.33/drivers/uio/uio.c uio-2.6.33/drivers/uio/uio.c
--- linux-2.6.33/drivers/uio/uio.c	2010-02-24 10:52:17.000000000 -0800
+++ uio-2.6.33/drivers/uio/uio.c	2010-03-31 12:26:24.000000000 -0700
@@ -730,12 +730,24 @@ static int uio_mmap(struct file *filep,
 	}
 }
 
+static int uio_ioctl(struct inode *inode, struct file *filep,
+			unsigned int cmd, unsigned long arg) 
+{
+	struct uio_listener *listener = filep->private_data;
+	struct uio_device *idev = listener->dev;
+
+	if (idev == NULL || idev->info == NULL || idev->info->ioctl == NULL)
+		return -EINVAL;
+	return idev->info->ioctl(idev->info, cmd, arg);
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
diff -rupN linux-2.6.33/drivers/uio/uio_pci_generic.c 
uio-2.6.33/drivers/uio/uio_pci_generic.c
--- linux-2.6.33/drivers/uio/uio_pci_generic.c	2010-02-24 
10:52:17.000000000 -0800
+++ uio-2.6.33/drivers/uio/uio_pci_generic.c	2010-03-31 
16:28:33.000000000 -0700
@@ -1,4 +1,7 @@
-/* uio_pci_generic - generic UIO driver for PCI 2.3 devices
+/* uio_pci_generic - generic UIO driver for PCI 2.3 and PCIe devices 
+ *
+ * Copyright (C) 2010 Cisco Systems, Inc.
+ * Extensions by Tom Lyon <pugs@cisco.com>
  *
  * Copyright (C) 2009 Red Hat, Inc.
  * Author: Michael S. Tsirkin <mst@redhat.com>
@@ -14,25 +17,35 @@
  * # ls -l /sys/bus/pci/devices/0000:00:19.0/driver
  * .../0000:00:19.0/driver -> ../../../bus/pci/drivers/uio_pci_generic
  *
- * Driver won't bind to devices which do not support the Interrupt Disable 
Bit
+ * Driver won't bind to devices which do not support MSI, MSI-x, or the 
Interrupt Disable Bit
  * in the command register. All devices compliant to PCI 2.3 (circa 2002) and
- * all compliant PCI Express devices should support this bit.
+ * all compliant PCI Express devices should support one of these.
  */
 
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/mmu_notifier.h>
 #include <linux/uio_driver.h>
 #include <linux/spinlock.h>
+#include <linux/iommu.h>
 
-#define DRIVER_VERSION	"0.01.0"
+#define DRIVER_VERSION	"0.02.0"
 #define DRIVER_AUTHOR	"Michael S. Tsirkin <mst@redhat.com>"
-#define DRIVER_DESC	"Generic UIO driver for PCI 2.3 devices"
+#define DRIVER_DESC	"Generic UIO driver for PCI devices"
 
 struct uio_pci_generic_dev {
 	struct uio_info info;
 	struct pci_dev *pdev;
 	spinlock_t lock; /* guards command register accesses */
+	int	msi;
+	struct msix_entry *msix;
+	int nvec;
+	struct mm_struct *mm;
+	struct mmu_notifier mmu_notifier;
+	struct list_head dm_list;
 };
 
 static inline struct uio_pci_generic_dev *
@@ -41,6 +54,51 @@ to_uio_pci_generic_dev(struct uio_info *
 	return container_of(info, struct uio_pci_generic_dev, info);
 }
 
+/* Read/modify/write command register to disable interrupts.
+ * Note: we could cache the value and optimize the read if there was a way to
+ * get notified of user changes to command register through sysfs.
+ * */
+static void irqtoggle(struct uio_pci_generic_dev *gdev, int irq_on)
+{
+       struct pci_dev *pdev = gdev->pdev;
+       unsigned long flags;
+       u16 orig, new;
+
+       spin_lock_irqsave(&gdev->lock, flags);
+       pci_block_user_cfg_access(pdev);
+       pci_read_config_word(pdev, PCI_COMMAND, &orig);
+       new = irq_on ? (orig & ~PCI_COMMAND_INTX_DISABLE)
+		    : (orig | PCI_COMMAND_INTX_DISABLE);
+       if (new != orig)
+               pci_write_config_word(gdev->pdev, PCI_COMMAND, new);
+       pci_unblock_user_cfg_access(pdev);
+       spin_unlock_irqrestore(&gdev->lock, flags);
+}
+
+/* irqcontrol is use by userspace to enable/disable interrupts. */
+/* A privileged app can write the PCI_COMMAND register directly,
+ * but we need this for normal apps
+ */
+static int irqcontrol(struct uio_info *info, s32 irq_on)
+{
+	struct uio_pci_generic_dev *gdev = to_uio_pci_generic_dev(info);
+
+	irqtoggle(gdev, irq_on);
+	return 0;
+}
+
+/* MSI and MSI-X Interrupt handler.
+ * For bad devices, we may get an interrupt per event/packet, but most
+ * devices will self-throttle until user driver wants more
+ */
+static irqreturn_t msihandler(int irq, void *arg)
+{
+	struct uio_info *info = arg;
+
+	uio_event_notify(info);
+	return IRQ_HANDLED;
+}
+
 /* Interrupt handler. Read/modify/write the command register to disable
  * the interrupt. */
 static irqreturn_t irqhandler(int irq, struct uio_info *info)
@@ -89,7 +147,7 @@ done:
 /* Verify that the device supports Interrupt Disable bit in command register,
  * per PCI 2.3, by flipping this bit and reading it back: this bit was 
readonly
  * in PCI 2.2. */
-static int __devinit verify_pci_2_3(struct pci_dev *pdev)
+static int verify_pci_2_3(struct pci_dev *pdev)
 {
 	u16 orig, new;
 	int err = 0;
@@ -121,17 +179,412 @@ err:
 	return err;
 }
 
-static int __devinit probe(struct pci_dev *pdev,
-			   const struct pci_device_id *id)
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
+};
+
+/* Unmap DMA region */
+static void uio_pci_unmap(struct uio_pci_generic_dev *gdev, struct 
dma_map_page *mlp)
+{
+	struct pci_dev *pdev = gdev->pdev;
+	int i;
+
+	list_del(&mlp->list);
+	dma_unmap_sg(&pdev->dev, mlp->sg, mlp->npage, DMA_BIDIRECTIONAL);
+	for (i=0; i<mlp->npage; i++)
+		put_page(mlp->pages[i]);
+	gdev->mm->locked_vm -= mlp->npage;
+	kfree(mlp->sg);
+	kfree(mlp->pages);
+	kfree(mlp);
+}
+
+/* Unmap ALL DMA regions */
+static void uio_pci_unmapall(struct uio_pci_generic_dev *gdev)
+{
+        struct list_head *pos, *pos2;
+        struct dma_map_page *mlp;
+
+        list_for_each_safe(pos, pos2, &gdev->dm_list) {
+                mlp = list_entry(pos, struct dma_map_page, list);
+		uio_pci_unmap(gdev, mlp);
+        }
+}
+
+/* Handle MMU notifications - user process freed or realloced memory
+ * which may be in use in a DMA region. Clean up region if so.
+ */
+static void uio_pci_handle_mmu_notify(struct mmu_notifier *mn,
+		unsigned long start, unsigned long end)
 {
 	struct uio_pci_generic_dev *gdev;
-	int err;
+	unsigned long myend;
+        struct list_head *pos, *pos2;
+        struct dma_map_page *mlp;
+
+	gdev = container_of(mn, struct uio_pci_generic_dev, mmu_notifier);
+	list_for_each_safe(pos, pos2, &gdev->dm_list) {
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
+			printk(KERN_WARNING "%s: demap start %lx end %lx va %lx pa %lx\n",
+				__func__, start, end, mlp->vaddr, (long)mlp->daddr);
+			uio_pci_unmap(gdev, mlp);
+		}
+	}
+}
 
-	if (!pdev->irq) {
-		dev_warn(&pdev->dev, "No IRQ assigned to device: "
-			 "no support for interrupts?\n");
-		return -ENODEV;
+static void uio_pci_inval_page(struct mmu_notifier *mn,
+		struct mm_struct *mm, unsigned long addr)
+{
+	uio_pci_handle_mmu_notify(mn, addr, addr + PAGE_SIZE);
+}
+
+static void uio_pci_inval_range_start(struct mmu_notifier *mn,
+		struct mm_struct *mm, unsigned long start, unsigned long end)
+{
+	uio_pci_handle_mmu_notify(mn, start, end);
+}
+
+static const struct mmu_notifier_ops uio_pci_mmu_notifier_ops = {
+	.invalidate_page = uio_pci_inval_page,
+	.invalidate_range_start = uio_pci_inval_range_start,
+};
+
+static int uio_pci_ioctl(struct uio_info *info, unsigned int cmd, unsigned 
long arg)
+{
+	struct uio_pci_generic_dev *gdev = to_uio_pci_generic_dev(info);
+	struct pci_dev *pdev = gdev->pdev;
+	void __user *uarg = (void __user *)arg;
+	int err = -EINVAL;
+	int nvec;
+	int i;
+	struct uio_pci_dma_map dm;
+	unsigned long start, daddr;
+	struct page **pages;
+	struct dma_map_page *mlp = NULL;
+	struct list_head *pos, *pos2;
+	int npage, nents;
+	u64 mask;
+	struct scatterlist *sg, *nsg;
+	int length;
+	int locked, lock_limit;
+
+	switch (cmd) {
+
+	/* Use MSI interrupts */
+	case UIO_PCI_MSI_SET:
+		if (copy_from_user(&nvec, uarg, sizeof (int)))
+			return -EFAULT;
+		if (nvec == 1 && gdev->msi == 0 && gdev->msix == NULL) {
+			pci_enable_msi(pdev);
+			err = request_irq(pdev->irq, msihandler, 0,
+					info->name, info);
+			if (err)
+				pci_disable_msi(pdev);
+			else 
+				gdev->msi = 1;
+		}
+		if (nvec == 0 && gdev->msi == 1) {
+			free_irq(pdev->irq, info);
+			pci_disable_msi(pdev);
+			gdev->msi = 0;
+			err = 0;
+		}
+		break;
+
+	/* Use (n) MSI-X interrupts */
+	/* More than 1 isn't useful, but some devices may require it */
+	case UIO_PCI_MSIX_SET:
+		if (copy_from_user(&nvec, uarg, sizeof (int)))
+			return -EFAULT;
+		if (nvec && nvec < 1024 && gdev->msi == 0 && gdev->msix == NULL) {
+			gdev->msix = kzalloc(nvec * sizeof(struct msix_entry), GFP_KERNEL);
+			if (gdev->msix == NULL)
+				return -ENOMEM;
+			gdev->nvec = nvec;
+			for (i=0; i<nvec; i++)
+				gdev->msix[i].entry = i;
+			err = pci_enable_msix(pdev, gdev->msix, nvec);
+			if (err > 0) err = -EINVAL;
+			if (err < 0) {
+				kfree(gdev->msix);
+				gdev->msix = NULL;
+				break;
+			}
+			for (i=0; i<nvec; i++) {
+				err = request_irq(gdev->msix[i].vector, msihandler, 0,
+					info->name, info);	
+				if (err) {
+					while (--i >= 0)
+						free_irq(gdev->msix[i].vector, info);
+					kfree(gdev->msix);
+					gdev->msix = NULL;
+					break;
+				}
+			}
+		}
+		if (nvec == 0 && gdev->msix) {
+			err = 0;
+			pci_disable_msix(pdev);
+			for (i=0; i<gdev->nvec; i++) {
+				free_irq(gdev->msix[i].vector, info);
+			}
+			kfree(gdev->msix);
+			gdev->msix = NULL;
+		}
+		break;
+
+	/* set master mode and DMA mask */
+        case UIO_PCI_SET_DMA_MASK:
+                if (copy_from_user(&mask, uarg, sizeof mask))
+                        return -EFAULT;
+
+		pci_set_master(pdev);
+		err = pci_set_dma_mask(pdev, mask);
+		if (err)
+			return err;
+		err = pci_set_consistent_dma_mask(pdev, mask);
+		if (err)
+			return err;
+                break;
+
+	/* Lock down and provide a "physical" address for a buffer */
+	case UIO_PCI_DMA_MAP:
+		if (copy_from_user(&dm, uarg, sizeof dm))
+                        return -EFAULT;
+                if ((long)dm.vaddr & (PAGE_SIZE-1))
+                        return -EINVAL;
+                if (dm.size & (PAGE_SIZE-1))
+                        return -EINVAL;
+                if (dm.size <= 0)
+                        return -EINVAL;
+                start = (unsigned long)dm.vaddr;
+                npage = dm.size >> PAGE_SHIFT;
+
+		/* account for locked pages */
+		locked = npage + current->mm->locked_vm;
+		lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+		if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+			printk(KERN_WARNING "%s: RLIMIT_MEMLOCK exceeded\n",
+				__func__);
+			return -ENOMEM;
+		}
+		if (current->mm != gdev->mm) {
+			if (gdev->mm != NULL)
+				return -EINVAL;
+			gdev->mm = current->mm;
+			gdev->mmu_notifier.ops = &uio_pci_mmu_notifier_ops;
+			err = mmu_notifier_register(&gdev->mmu_notifier, gdev->mm);
+			if (err)
+				printk(KERN_ERR "%s: mmu_notifier_register failed %d\n",
+					__func__, err);
+		}
+
+		pages = kzalloc(npage * sizeof(struct page *), GFP_KERNEL);
+		sg = kzalloc(npage * sizeof(struct scatterlist), GFP_KERNEL);
+		if (pages == NULL || sg == NULL)
+			return -ENOMEM;
+		err = get_user_pages_fast(start, npage, dm.rdwr, pages);
+		if (err != npage) {
+			printk(KERN_ERR "%s: get_user_pages_fast returns %d, not %d\n",
+				__func__, err, npage);
+			kfree(sg);
+			kfree(pages);
+			return -EFAULT;
+		}
+		for (i=0; i<npage; i++) {
+			sg_set_page(&sg[i], pages[i], PAGE_SIZE, 0);
+		}
+		nents = dma_map_sg(&pdev->dev, sg, npage,
+				dm.rdwr ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
+		/* The API for dma_map_sg suggests that it may squash together
+		 * adjacent pages, but noone seems to really do that. So we squash 
+		 * it ourselves, because the user level wants a single buffer.
+		 * This works if (a) there is an iommu, or (b) the user allocates 
+		 * large buffers from a huge page
+		 */
+		nsg = sg;
+		for (i=1; i<nents; i++) {
+			length = sg[i].dma_length;
+			sg[i].dma_length = 0;
+			if (sg[i].dma_address == (nsg->dma_address + nsg->dma_length)) {
+				nsg->dma_length += length;
+			} else {
+				nsg++;
+				nsg->dma_address = sg[i].dma_address;
+				nsg->dma_length = length;
+			}
+		}
+		nents = 1 + (nsg - sg);
+		if (nents != 1) {
+			if (nents > 0)
+				dma_unmap_sg(&pdev->dev, sg, npage, DMA_BIDIRECTIONAL);
+			for (i=0; i<npage; i++)
+				put_page(pages[i]);
+			kfree(sg);
+			kfree(pages);
+			printk(KERN_ERR "%s: sequential dma mapping failed\n", __func__);
+			return -EFAULT;
+		}
+
+		daddr = sg_dma_address(sg);
+		
+		mlp = kzalloc(sizeof *mlp, GFP_KERNEL);
+		mlp->pages = pages;
+		mlp->sg = sg;
+		mlp->daddr = daddr;
+		mlp->vaddr = start;
+		mlp->npage = npage;
+		list_add(&mlp->list, &gdev->dm_list);
+                if (dm.rdwr) {
+			for (i=0; i<npage; i++)
+				SetPageDirty(pages[i]);
+		}
+                dm.dmaaddr = daddr;
+
+		current->mm->locked_vm += npage;
+
+                if (copy_to_user(uarg, &dm, sizeof dm))
+                        return -EFAULT;
+		break;
+
+	/* release DMA region */
+	case UIO_PCI_DMA_UNMAP:
+		if (copy_from_user(&dm, uarg, sizeof dm))
+			return -EFAULT;
+		start = ((unsigned long)dm.vaddr) & ~PAGE_SIZE;
+                npage = dm.size >> PAGE_SHIFT;
+
+		err = -ENXIO;
+		list_for_each_safe(pos, pos2, &gdev->dm_list) {
+			mlp = list_entry(pos, struct dma_map_page, list);
+			if ((unsigned long)dm.vaddr != mlp->vaddr || mlp->npage != npage)
+				continue;
+			err = 0;
+			uio_pci_unmap(gdev, mlp);
+			break;
+		}
+		break;
+
+	default:
+		err = -ENOTTY;
+		break;
+	}
+	return err;
+}
+
+/*
+ * We assume a PCI device is master-capable if we can write its
+ * master-enable bit to 1. If so, then its not safe for unprivileged
+ * users unless there is an IOMMU
+ */
+static int uio_pci_open(struct uio_info *info, struct inode *inode)
+{
+	struct uio_pci_generic_dev *gdev = to_uio_pci_generic_dev(info);
+	struct pci_dev *pdev = gdev->pdev;
+	u16 old_cmd, cmd;
+
+        pci_read_config_word(pdev, PCI_COMMAND, &old_cmd);
+	cmd = old_cmd | PCI_COMMAND_MASTER;
+	pci_write_config_word(pdev, PCI_COMMAND, cmd);
+        pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+	pci_write_config_word(pdev, PCI_COMMAND, old_cmd);
+	if (cmd & PCI_COMMAND_MASTER) {
+		if (!iommu_found() && !capable(CAP_SYS_RAWIO))
+			return -EPERM;
+	}
+	return 0;
+}
+
+static int uio_pci_release(struct uio_info *info, struct inode *inode)
+{
+	struct uio_pci_generic_dev *gdev = to_uio_pci_generic_dev(info);
+	struct pci_dev *pdev = gdev->pdev;
+	int i;
+
+	if (gdev->msix) {
+		for (i=0; i<gdev->nvec; i++) {
+			free_irq(gdev->msix[i].vector, info);
+		}
+		pci_disable_msix(pdev);
+		kfree(gdev->msix);
+		gdev->msix = NULL;
+	}
+	if (gdev->msi) {
+		free_irq(pdev->irq, info);
+		pci_disable_msi(pdev);
+		gdev->msi = 0;
+	}
+	uio_pci_unmapall(gdev);
+	if (gdev->mm) {
+		mmu_notifier_unregister(&gdev->mmu_notifier, gdev->mm);
+		gdev->mm = NULL;
 	}
+	return 0;
+}
+
+/* we could've used the generic pci sysfs stuff for mmap,
+ * but this way we can allow non-privileged users as long
+ * as /dev/uio* has the right permissions
+ */
+static void uio_do_maps(struct uio_pci_generic_dev *gdev)
+{
+	struct pci_dev *pdev = gdev->pdev;
+	struct uio_info *info = &gdev->info;
+	int i, j;
+	char *name;
+
+	for (i=0, j=0; i<PCI_STD_RESOURCE_END && j<MAX_UIO_MAPS; i++) {
+		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
+			name = kmalloc(8, GFP_KERNEL);
+			if (name == NULL)
+				break;
+			sprintf(name, "membar%d", i);
+			info->mem[j].name = name; 
+			info->mem[j].addr = pci_resource_start(pdev, i); 
+			info->mem[j].size = pci_resource_len(pdev, i);
+			info->mem[j].memtype = UIO_MEM_PHYS; 
+			j++;
+		}
+	}
+	for (i=0, j=0; i<PCI_STD_RESOURCE_END && j<MAX_UIO_PORT_REGIONS; i++) {
+		if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
+			name = kmalloc(8, GFP_KERNEL);
+			if (name == NULL)
+				break;
+			sprintf(name, "iobar%d", i);
+			info->port[j].name = name;
+			info->port[j].start = pci_resource_start(pdev, i);
+			info->port[j].size = pci_resource_len(pdev, i);
+			info->port[j].porttype = UIO_PORT_X86;
+			j++;
+		}
+	}
+}
+
+static int probe(struct pci_dev *pdev,
+			   const struct pci_device_id *id)
+{
+	struct uio_pci_generic_dev *gdev;
+	int err;
+	int msi=0;
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -140,9 +593,26 @@ static int __devinit probe(struct pci_de
 		return err;
 	}
 
-	err = verify_pci_2_3(pdev);
-	if (err)
-		goto err_verify;
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
+		msi++;
+		pci_disable_msi(pdev);
+	}
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+		msi++;
+		pci_disable_msix(pdev);
+	}
+
+	if (!msi && !pdev->irq) {
+		dev_warn(&pdev->dev, "No MSI, MSIX, or IRQ assigned to device: "
+			 "no support for interrupts?\n");
+		return -ENODEV;
+	}
+
+	if (pdev->irq) {
+		err = verify_pci_2_3(pdev);
+		if (err)
+			goto err_verify;
+	}
 
 	gdev = kzalloc(sizeof(struct uio_pci_generic_dev), GFP_KERNEL);
 	if (!gdev) {
@@ -152,10 +622,19 @@ static int __devinit probe(struct pci_de
 
 	gdev->info.name = "uio_pci_generic";
 	gdev->info.version = DRIVER_VERSION;
-	gdev->info.irq = pdev->irq;
-	gdev->info.irq_flags = IRQF_SHARED;
-	gdev->info.handler = irqhandler;
+	if (pdev->irq) {
+		gdev->info.irq = pdev->irq;
+		gdev->info.irq_flags = IRQF_SHARED;
+		gdev->info.handler = irqhandler;
+		gdev->info.irqcontrol = irqcontrol;
+		gdev->info.open = uio_pci_open;
+	} else
+		gdev->info.irq = -1;
+	gdev->info.ioctl = uio_pci_ioctl;
+	gdev->info.release = uio_pci_release;
 	gdev->pdev = pdev;
+	uio_do_maps(gdev);
+	INIT_LIST_HEAD(&gdev->dm_list);
 	spin_lock_init(&gdev->lock);
 
 	if (uio_register_device(&pdev->dev, &gdev->info))
diff -rupN linux-2.6.33/include/linux/uio_driver.h 
uio-2.6.33/include/linux/uio_driver.h
--- linux-2.6.33/include/linux/uio_driver.h	2010-02-24 
10:52:17.000000000 -0800
+++ uio-2.6.33/include/linux/uio_driver.h	2010-03-31 12:26:24.000000000 -0700
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
@@ -92,6 +96,7 @@ struct uio_info {
 	int (*open)(struct uio_info *info, struct inode *inode);
 	int (*release)(struct uio_info *info, struct inode *inode);
 	int (*irqcontrol)(struct uio_info *info, s32 irq_on);
+	int (*ioctl)(struct uio_info *info, unsigned int cmd, unsigned long arg);
 };
 
 extern int __must_check
@@ -122,4 +127,21 @@ extern void uio_event_notify(struct uio_
 #define UIO_PORT_GPIO	2
 #define UIO_PORT_OTHER	3
 
+#endif	/* __KERNEL__ */
+
+// Kernel & User level defines for ioctls
+
+struct uio_pci_dma_map {
+	void *vaddr;
+	unsigned long long dmaaddr;
+	int	size;
+	int	rdwr;
+};
+
+#define	UIO_PCI_DMA_MAP		_IOWR(';', 101, struct uio_pci_dma_map)
+#define	UIO_PCI_DMA_UNMAP	_IOW(';', 102, struct uio_pci_dma_map)
+#define	UIO_PCI_SET_DMA_MASK	_IOW(';', 103, unsigned long long)
+#define	UIO_PCI_MSI_SET		_IOW(';', 104, int)
+#define	UIO_PCI_MSIX_SET	_IOW(';', 105, int)
+
 #endif /* _LINUX_UIO_DRIVER_H_ */
