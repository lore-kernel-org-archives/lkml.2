Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab0E1XK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 19:10:56 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:50636 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0E1XKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 19:10:53 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,321,1272844800"; 
   d="scan'208";a="536910008"
Date: Fri, 28 May 2010 16:07:38 -0700
From: "Tom Lyon" <pugs@cisco.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, mst@redhat.com, avi@redhat.com,
       gregkh@suse.de
Cc: aafabbri@cisco.com, scofeldm@cisco.com
Subject: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VFIO "driver" is used to allow privileged AND non-privileged processes to 
implement user-level device drivers for any well-behaved PCI, PCI-X, and PCIe
devices.
	Signed-off-by: Tom Lyon <pugs@cisco.com>
---
This patch is the evolution of code which was first proposed as a patch to
uio/uio_pci_generic, then as a more generic uio patch. Now it is taken entirely
out of the uio framework, and things seem much cleaner. Of course, there is
a lot of functional overlap with uio, but the previous version just seemed
like a giant mode switch in the uio code that did not lead to clarity for
either the new or old code.

[a pony for avi...]
The major new functionality in this version is the ability to deal with
PCI config space accesses (through read & write calls) - but includes table
driven code to determine whats safe to write and what is not. Also, some
virtualization of the config space to allow drivers to think they're writing
some registers when they're not.  Also, IO space accesses are also allowed.
Drivers for devices which use MSI-X are now prevented from directly writing
the MSI-X vector area.

All interrupts are now handled using eventfds, which makes things very simple.

The name VFIO refers to the Virtual Function capabilities of SR-IOV devices
but the driver does support many more types of devices.  I was none too sure
what driver directory this should live in, so for now I made up my own under
drivers/vfio. As a new driver/new directory, who makes the commit decision?

I currently have user level drivers working for 3 different network adapters
- the Cisco "Palo" enic, the Intel 82599 VF, and the Intel 82576 VF (but the
whole user level framework is a long ways from release).  This driver could
also clearly replace a number of other drivers written just to give user
access to certain devices - but that will take time.

diff -uprN linux-2.6.34/Documentation/vfio.txt vfio-linux-2.6.34/Documentation/vfio.txt
--- linux-2.6.34/Documentation/vfio.txt	1969-12-31 16:00:00.000000000 -0800
+++ vfio-linux-2.6.34/Documentation/vfio.txt	2010-05-28 14:03:05.000000000 -0700
@@ -0,0 +1,176 @@
+-------------------------------------------------------------------------------
+The VFIO "driver" is used to allow privileged AND non-privileged processes to
+implement user-level device drivers for any well-behaved PCI, PCI-X, and PCIe
+devices.
+
+Why is this interesting?  Some applications, especially in the high performance
+computing field, need access to hardware functions with as little overhead as
+possible. Examples are in network adapters (typically non tcp/ip based) and
+in compute accelerators - i.e., array processors, FPGA processors, etc.
+Previous to the VFIO drivers these apps would need either a kernel-level
+driver (with corrsponding overheads), or else root permissions to directly
+access the hardware. The VFIO driver allows generic access to the hardware
+from non-privileged apps IF the hardware is "well-behaved" enough for this
+to be safe.
+
+While there have long been ways to implement user-level drivers using specific
+corresponding drivers in the kernel, it was not until the introduction of the
+UIO driver framework, and the uio_pci_generic driver that one could have a
+generic kernel component supporting many types of user level drivers. However,
+even with the uio_pci_generic driver, processes implementing the user level
+drivers had to be trusted - they could do dangerous manipulation of DMA
+addreses and were required to be root to write PCI configuration space
+registers.
+
+Recent hardware technologies - I/O MMUs and PCI I/O Virtualization - provide
+new hardware capabilities which the VFIO solution exploits to allow non-root
+user level drivers. The main role of the IOMMU is to ensure that DMA accesses
+from devices go only to the appropriate memory locations, this allows VFIO to
+ensure that user level drivers do not corrupt inappropriate memory.  PCI I/O
+virtualization (SR-IOV) was defined to allow "pass-through" of virtual devices
+to guest virtual machines. VFIO in essence implements pass-through of devices
+to user processes, not virtual machines.  SR-IOV devices implement a
+traditional PCI device (the physical function) and a dynamic number of special
+PCI devices (virtual functions) whose feature set is somewhat restricted - in
+order to allow the operating system or virtual machine monitor to ensure the
+safe operation of the system.
+
+Any SR-IOV virtual function meets the VFIO definition of "well-behaved", but
+there are many other non-IOV PCI devices which also meet the defintion.
+Elements of this definition are:
+- The size of any memory BARs to be mmap'ed into the user process space must be
+  a multiple of the system page size.
+- If MSI-X interrupts are used, the device driver must not attempt to mmap or
+  write the MSI-X vector area.
+- If the device is a PCI device (not PCI-X or PCIe), it must conform to PCI
+  revision 2.3 to allow its interrupts to be masked in a generic way.
+- The device must not use the PCI configuration space in any non-standard way,
+  i.e., the user level driver will be permitted only to read and write standard
+  fields of the PCI config space, and only if those fields cannot cause harm to
+  the system. In addition, some fields are "virtualized", so that the user
+  driver can read/write them like a kernel driver, but they do not affect the
+  real device.
+- For now, there is no support for user access to the PCIe and PCI-X extended
+  capabilities configuration space.
+
+Even with these restrictions, there are bound to be devices which are unsafe
+for user level use - it is still up to the system admin to decide whether to
+grant access to the device.  When the vfio module is loaded, it will have
+access to no devices until the desired PCI devices are "bound" to the driver.
+First, make sure the devices are not bound to another kernel driver. You can
+unload that driver if you wish to unbind all its devices, or else enter the
+driver's sysfs directory, and unbind a specific device:
+	cd /sys/bus/pci/drivers/<drivername>
+	echo 0000:06:02.00 > unbind
+(The 0000:06:02.00 is a fully qualified PCI device name - different for each
+device).  Now, to bind to the vfio driver, go to /sys/bus/pci/drivers/vfio and
+write the PCI device type of the target device to the new_id file:
+	echo 8086 10ca > new_id
+(8086 10ca are the vendor and device type for the Intel 82576 virtual function
+devices). A /dev/vfio<N> entry will be created for each device bound. The final
+step is to grant users permission by changing the mode and/or owner of the /dev
+entry - "chmod 666 /dev/vfio0".
+
+Reads & Writes:
+
+The user driver will typically use mmap to access the memory BAR(s) of a
+device; the I/O BARs and the PCI config space may be accessed through normal
+read and write system calls. Only 1 file descriptor is needed for all driver
+functions -- the desired BAR for I/O, memory, or config space is indicated via
+high-order bits of the file offset.  For instance, the following implements a
+write to the PCI config space:
+
+	#include <linux/vfio.h>
+	void pci_write_config_word(int pci_fd, u16 off, u16 wd)
+	{
+		off_t cfg_off = VFIO_PCI_CONFIG_OFF + off;
+
+		if (pwrite(pci_fd, &wd, 2, cfg_off) != 2)
+			perror("pwrite config_dword");
+	}
+
+The routines vfio_pci_space_to_offset and vfio_offset_to_pci_space are provided
+in vfio.h to convert bar numbers to file offsets and vice-versa.
+
+Interrupts:
+
+Device interrupts are translated by the vfio driver into input events on event
+notification file descriptors created by the eventfd system call. The user
+program must one or more event descriptors and pass them to the vfio driver
+via ioctls to arrange for the interrupt mapping:
+1.
+	efd = eventfd(0, 0);
+	ioctl(vfio_fd, VFIO_EVENTFD_IRQ, &efd);
+		This provides an eventfd for traditional IRQ interrupts.
+		IRQs will be disable after each interrupt until the driver
+		re-enables them via the PCI COMMAND register.
+2.
+	efd = eventfd(0, 0);
+	ioctl(vfio_fd, VFIO_EVENTFD_MSI, &efd);
+		This connects MSI interrupts to an eventfd.
+3.
+ 	int arg[N+1];
+	arg[0] = N;
+	arg[1..N] = eventfd(0, 0);
+	ioctl(vfio_fd, VFIO_EVENTFDS_MSIX, arg);
+		This connects N MSI-X interrupts with N eventfds.
+
+Waiting and checking for interrupts is done by the user program by reads,
+polls, or selects on the related event file descriptors.
+
+DMA:
+
+The VFIO driver uses ioctls to allow the user level driver to get DMA
+addresses which correspond to virtual addresses.  In systems with IOMMUs,
+each PCI device will have its own address space for DMA operations, so when
+the user level driver programs the device registers, only addresses known to
+the IOMMU will be valid, any others will be rejected.  The IOMMU creates the
+illusion (to the device) that multi-page buffers are physically contiguous,
+so a single DMA operation can safely span multiple user pages.  Note that
+the VFIO driver is still useful in systems without IOMMUs, but only for
+trusted processes which can deal with DMAs which do not span pages (Huge
+pages count as a single page also).
+
+If the user process desires many DMA buffers, it may be wise to do a mapping
+of a single large buffer, and then allocate the smaller buffers from the
+large one.
+
+The DMA buffers are locked into physical memory for the duration of their
+existence - until VFIO_DMA_UNMAP is called, until the user pages are
+unmapped from the user process, or until the vfio file descriptor is closed.
+The user process must have permission to lock the pages given by the ulimit(-l)
+command, which in turn relies on settings in the /etc/security/limits.conf
+file.
+
+The vfio_dma_map structure is used as an argument to the ioctls which
+do the DMA mapping. Its vaddr, dmaaddr, and size fields must always be a
+multiple of a page. Its rdwr field is zero for read-only (outbound), and
+non-zero for read/write buffers.
+
+	struct vfio_dma_map {
+		__u64	vaddr;	  /* process virtual addr */
+		__u64	dmaaddr;  /* desired and/or returned dma address */
+		__u64	size;	  /* size in bytes */
+		int	rdwr;	  /* bool: 0 for r/o; 1 for r/w */
+	};
+
+The VFIO_DMA_MAP_ANYWHERE is called with a vfio_dma_map structure as its
+argument, and returns the structure with a valid dmaaddr field.
+
+The VFIO_DMA_MAP_IOVA is called with a vfio_dma_map structure with the
+dmaaddr field already assigned. The system will attempt to map the DMA
+buffer into the IO space at the givne dmaaddr. This is expected to be
+useful if KVM or other virtualization facilities use this driver.
+
+The VFIO_DMA_UNMAP takes a fully filled vfio_dma_map structure and unmaps
+the buffer and releases the corresponding system resources.
+
+The VFIO_DMA_MASK ioctl is used to set the maximum permissible DMA address
+(device dependent). It takes a single unsigned 64 bit integer as an argument.
+This call also has the side effect on enabled PCI bus mastership.
+
+Miscellaneous:
+
+The VFIO_BAR_LEN ioctl provides an easy way to determine the size of a PCI
+device's base address region. It is passed a single integer specifying which
+BAR (0-5 or 6 for ROM bar), and passes back the length in the same field.
diff -uprN linux-2.6.34/drivers/Kconfig vfio-linux-2.6.34/drivers/Kconfig
--- linux-2.6.34/drivers/Kconfig	2010-05-16 14:17:36.000000000 -0700
+++ vfio-linux-2.6.34/drivers/Kconfig	2010-05-27 17:01:02.000000000 -0700
@@ -111,4 +111,6 @@ source "drivers/xen/Kconfig"
 source "drivers/staging/Kconfig"
 
 source "drivers/platform/Kconfig"
+
+source "drivers/vfio/Kconfig"
 endmenu
diff -uprN linux-2.6.34/drivers/Makefile vfio-linux-2.6.34/drivers/Makefile
--- linux-2.6.34/drivers/Makefile	2010-05-16 14:17:36.000000000 -0700
+++ vfio-linux-2.6.34/drivers/Makefile	2010-05-27 17:25:33.000000000 -0700
@@ -52,6 +52,7 @@ obj-$(CONFIG_FUSION)		+= message/
 obj-$(CONFIG_FIREWIRE)		+= firewire/
 obj-y				+= ieee1394/
 obj-$(CONFIG_UIO)		+= uio/
+obj-$(CONFIG_VFIO)		+= vfio/
 obj-y				+= cdrom/
 obj-y				+= auxdisplay/
 obj-$(CONFIG_PCCARD)		+= pcmcia/
diff -uprN linux-2.6.34/drivers/vfio/Kconfig vfio-linux-2.6.34/drivers/vfio/Kconfig
--- linux-2.6.34/drivers/vfio/Kconfig	1969-12-31 16:00:00.000000000 -0800
+++ vfio-linux-2.6.34/drivers/vfio/Kconfig	2010-05-27 17:07:25.000000000 -0700
@@ -0,0 +1,9 @@
+menuconfig VFIO
+	tristate "Non-Priv User Space PCI drivers"
+	depends on PCI
+	help
+	  Driver to allow advanced user space drivers for PCI, PCI-X,
+	  and PCIe devices.  Requires IOMMU to allow non-privilged
+	  processes to directly control the PCI devices.
+
+	  If you don't know what to do here, say N.
diff -uprN linux-2.6.34/drivers/vfio/Makefile vfio-linux-2.6.34/drivers/vfio/Makefile
--- linux-2.6.34/drivers/vfio/Makefile	1969-12-31 16:00:00.000000000 -0800
+++ vfio-linux-2.6.34/drivers/vfio/Makefile	2010-05-27 17:32:35.000000000 -0700
@@ -0,0 +1,5 @@
+obj-$(CONFIG_VFIO) := vfio.o
+
+vfio-y := vfio_main.o vfio_dma.o vfio_intrs.o \
+		vfio_pci_config.o vfio_rdwr.o vfio_sysfs.o
+
diff -uprN linux-2.6.34/drivers/vfio/vfio_dma.c vfio-linux-2.6.34/drivers/vfio/vfio_dma.c
--- linux-2.6.34/drivers/vfio/vfio_dma.c	1969-12-31 16:00:00.000000000 -0800
+++ vfio-linux-2.6.34/drivers/vfio/vfio_dma.c	2010-05-28 14:04:04.000000000 -0700
@@ -0,0 +1,372 @@
+/*
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ * Portions derived from drivers/uio/uio.c:
+ * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
+ * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
+ * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
+ * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
+ *
+ * Portions derived from drivers/uio/uio_pci_generic.c:
+ * Copyright (C) 2009 Red Hat, Inc.
+ * Author: Michael S. Tsirkin <mst@redhat.com>
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/mm.h>
+#include <linux/mmu_notifier.h>
+#include <linux/iommu.h>
+#include <linux/sched.h>
+
+#include <linux/vfio.h>
+
+/* Unmap DMA region */
+static void vfio_dma_unmap(struct vfio_listener *listener,
+			struct dma_map_page *mlp)
+{
+	int i;
+	struct vfio_dev *vdev = listener->vdev;
+	struct pci_dev *pdev = vdev->pdev;
+
+	mutex_lock(&vdev->gate);
+	list_del(&mlp->list);
+	if (mlp->sg) {
+		dma_unmap_sg(&pdev->dev, mlp->sg, mlp->npage,
+				DMA_BIDIRECTIONAL);
+		kfree(mlp->sg);
+	} else {
+		for (i = 0; i < mlp->npage; i++)
+			(void) iommu_unmap_range(vdev->domain,
+					mlp->daddr + i*PAGE_SIZE, PAGE_SIZE);
+	}
+	for (i = 0; i < mlp->npage; i++) {
+		if (mlp->rdwr)
+			SetPageDirty(mlp->pages[i]);
+		put_page(mlp->pages[i]);
+	}
+	listener->mm->locked_vm -= mlp->npage;
+	vdev->locked_pages -= mlp->npage;
+	kfree(mlp->pages);
+	kfree(mlp);
+	vdev->mapcount--;
+	mutex_unlock(&vdev->gate);
+}
+
+/* Unmap ALL DMA regions */
+void vfio_dma_unmapall(struct vfio_listener *listener)
+{
+	struct list_head *pos, *pos2;
+	struct dma_map_page *mlp;
+
+	list_for_each_safe(pos, pos2, &listener->dm_list) {
+		mlp = list_entry(pos, struct dma_map_page, list);
+		vfio_dma_unmap(listener, mlp);
+	}
+}
+
+int vfio_dma_unmap_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
+{
+	unsigned long start, npage;
+	struct dma_map_page *mlp;
+	struct list_head *pos, *pos2;
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
+		vfio_dma_unmap(listener, mlp);
+		break;
+	}
+	return ret;
+}
+
+/* Handle MMU notifications - user process freed or realloced memory
+ * which may be in use in a DMA region. Clean up region if so.
+ */
+static void vfio_dma_handle_mmu_notify(struct mmu_notifier *mn,
+		unsigned long start, unsigned long end)
+{
+	struct vfio_listener *listener;
+	unsigned long myend;
+	struct list_head *pos, *pos2;
+	struct dma_map_page *mlp;
+
+	listener = container_of(mn, struct vfio_listener, mmu_notifier);
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
+				__func__, start, end,
+				mlp->vaddr, (long)mlp->daddr);
+			vfio_dma_unmap(listener, mlp);
+		}
+	}
+}
+
+static void vfio_dma_inval_page(struct mmu_notifier *mn,
+		struct mm_struct *mm, unsigned long addr)
+{
+	vfio_dma_handle_mmu_notify(mn, addr, addr + PAGE_SIZE);
+}
+
+static void vfio_dma_inval_range_start(struct mmu_notifier *mn,
+		struct mm_struct *mm, unsigned long start, unsigned long end)
+{
+	vfio_dma_handle_mmu_notify(mn, start, end);
+}
+
+static const struct mmu_notifier_ops vfio_dma_mmu_notifier_ops = {
+	.invalidate_page = vfio_dma_inval_page,
+	.invalidate_range_start = vfio_dma_inval_range_start,
+};
+
+/*
+ * Map usr buffer at specific IO virtual address
+ */
+static int vfio_dma_map_iova(
+		struct vfio_listener *listener,
+		unsigned long start_iova,
+		struct page **pages,
+		int npage,
+		int rdwr,
+		struct dma_map_page **mlpp)
+{
+	struct vfio_dev *vdev = listener->vdev;
+	struct pci_dev *pdev = vdev->pdev;
+	int ret;
+	int i;
+	phys_addr_t hpa;
+	struct dma_map_page *mlp;
+	unsigned long iova = start_iova;
+
+	if (vdev->domain == NULL) {
+		/* can't mix iova with anywhere */
+		if (vdev->mapcount > 0)
+			return -EINVAL;
+		if (!iommu_found())
+			return -EINVAL;
+		vdev->domain = iommu_domain_alloc();
+		if (vdev->domain == NULL)
+			return -ENXIO;
+		vdev->cachec = iommu_domain_has_cap(vdev->domain,
+					IOMMU_CAP_CACHE_COHERENCY);
+		ret = iommu_attach_device(vdev->domain, &pdev->dev);
+		if (ret) {
+			iommu_domain_free(vdev->domain);
+			vdev->domain = NULL;
+			printk(KERN_ERR "%s: device_attach failed %d\n",
+					__func__, ret);
+			return ret;
+		}
+	}
+	for (i = 0; i < npage; i++) {
+		if (iommu_iova_to_phys(vdev->domain, iova + i*PAGE_SIZE))
+			return -EBUSY;
+	}
+	rdwr = rdwr ? IOMMU_READ|IOMMU_WRITE : IOMMU_READ;
+	if (vdev->cachec)
+		rdwr |= IOMMU_CACHE;
+	for (i = 0; i < npage; i++) {
+		hpa = page_to_phys(pages[i]);
+		ret = iommu_map_range(vdev->domain, iova,
+			hpa, PAGE_SIZE, rdwr);
+		if (ret) {
+			while (--i > 0) {
+				iova -= PAGE_SIZE;
+				(void) iommu_unmap_range(vdev->domain,
+							iova, PAGE_SIZE);
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
+	return 0;
+}
+
+/*
+ * Map user buffer - return IO virtual address
+ */
+static int vfio_dma_map_anywhere(
+		struct vfio_listener *listener,
+		struct page **pages,
+		int npage,
+		int rdwr,
+		struct dma_map_page **mlpp)
+{
+	struct vfio_dev *vdev = listener->vdev;
+	struct pci_dev *pdev = vdev->pdev;
+	struct scatterlist *sg, *nsg;
+	int i, nents;
+	struct dma_map_page *mlp;
+	unsigned long length;
+
+	if (vdev->domain) {
+		/* map anywhere and map iova don't mix */
+		if (vdev->mapcount > 0)
+			return -EINVAL;
+		iommu_domain_free(vdev->domain);
+		vdev->domain = NULL;
+	}
+	sg = kzalloc(npage * sizeof(struct scatterlist), GFP_KERNEL);
+	if (sg == NULL)
+		return -ENOMEM;
+	for (i = 0; i < npage; i++)
+		sg_set_page(&sg[i], pages[i], PAGE_SIZE, 0);
+	nents = dma_map_sg(&pdev->dev, sg, npage,
+			rdwr ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
+	/* The API for dma_map_sg suggests that it may squash together
+	 * adjacent pages, but noone seems to really do that. So we squash
+	 * it ourselves, because the user level wants a single buffer.
+	 * This works if (a) there is an iommu, or (b) the user allocates
+	 * large buffers from a huge page
+	 */
+	nsg = sg;
+	for (i = 1; i < nents; i++) {
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
+			dma_unmap_sg(&pdev->dev, sg, npage,
+					DMA_BIDIRECTIONAL);
+		for (i = 0; i < npage; i++)
+			put_page(pages[i]);
+		kfree(sg);
+		printk(KERN_ERR "%s: sequential dma mapping failed\n",
+				__func__);
+		return -EFAULT;
+	}
+
+	mlp = kzalloc(sizeof *mlp, GFP_KERNEL);
+	mlp->pages = pages;
+	mlp->sg = sg;
+	mlp->daddr = sg_dma_address(sg);
+	mlp->npage = npage;
+	*mlpp = mlp;
+	return 0;
+}
+
+int vfio_dma_map_common(struct vfio_listener *listener,
+		unsigned int cmd, struct vfio_dma_map *dmp)
+{
+	int locked, lock_limit;
+	struct page **pages;
+	int npage;
+	struct dma_map_page *mlp = NULL;
+	int ret = 0;
+
+	if (dmp->vaddr & (PAGE_SIZE-1))
+		return -EINVAL;
+	if (dmp->size & (PAGE_SIZE-1))
+		return -EINVAL;
+	if (dmp->size <= 0)
+		return -EINVAL;
+	npage = dmp->size >> PAGE_SHIFT;
+
+	mutex_lock(&listener->vdev->gate);
+
+	/* account for locked pages */
+	locked = npage + current->mm->locked_vm;
+	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur
+			>> PAGE_SHIFT;
+	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+		printk(KERN_WARNING "%s: RLIMIT_MEMLOCK exceeded\n",
+			__func__);
+		ret = -ENOMEM;
+		goto out_lock;
+	}
+	/* only 1 address space per fd */
+	if (current->mm != listener->mm) {
+		if (listener->mm != NULL)
+			return -EINVAL;
+		listener->mm = current->mm;
+		listener->mmu_notifier.ops = &vfio_dma_mmu_notifier_ops;
+		ret = mmu_notifier_register(&listener->mmu_notifier,
+						listener->mm);
+		if (ret)
+			printk(KERN_ERR "%s: mmu_notifier_register failed %d\n",
+				__func__, ret);
+		ret = 0;
+	}
+
+	pages = kzalloc(npage * sizeof(struct page *), GFP_KERNEL);
+	if (pages == NULL) {
+		ret = ENOMEM;
+		goto out_lock;
+	}
+	ret = get_user_pages_fast(dmp->vaddr, npage, dmp->rdwr, pages);
+	if (ret != npage) {
+		printk(KERN_ERR "%s: get_user_pages_fast returns %d, not %d\n",
+			__func__, ret, npage);
+		kfree(pages);
+		ret = -EFAULT;
+		goto out_lock;
+	}
+
+	if (cmd == VFIO_DMA_MAP_IOVA)
+		ret = vfio_dma_map_iova(listener, dmp->dmaaddr,
+				pages, npage, dmp->rdwr, &mlp);
+	else
+		ret = vfio_dma_map_anywhere(listener, pages,
+				npage, dmp->rdwr, &mlp);
+	if (ret) {
+		kfree(pages);
+		goto out_lock;
+	}
+	listener->vdev->mapcount++;
+	mlp->vaddr = dmp->vaddr;
+	mlp->rdwr = dmp->rdwr;
+	dmp->dmaaddr = mlp->daddr;
+	list_add(&mlp->list, &listener->dm_list);
+
+	current->mm->locked_vm += npage;
+	listener->vdev->locked_pages += npage;
+out_lock:
+	mutex_unlock(&listener->vdev->gate);
+	return ret;
+}
diff -uprN linux-2.6.34/drivers/vfio/vfio_intrs.c vfio-linux-2.6.34/drivers/vfio/vfio_intrs.c
--- linux-2.6.34/drivers/vfio/vfio_intrs.c	1969-12-31 16:00:00.000000000 -0800
+++ vfio-linux-2.6.34/drivers/vfio/vfio_intrs.c	2010-05-28 14:09:15.000000000 -0700
@@ -0,0 +1,189 @@
+/*
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ * Portions derived from drivers/uio/uio.c:
+ * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
+ * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
+ * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
+ * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
+ *
+ * Portions derived from drivers/uio/uio_pci_generic.c:
+ * Copyright (C) 2009 Red Hat, Inc.
+ * Author: Michael S. Tsirkin <mst@redhat.com>
+ */
+
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/eventfd.h>
+#include <linux/pci.h>
+#include <linux/mmu_notifier.h>
+
+#include <linux/vfio.h>
+
+
+/*
+ * vfio_interrupt - IRQ hardware interrupt handler
+ */
+irqreturn_t vfio_interrupt(int irq, void *dev_id)
+{
+	struct vfio_dev *vdev = (struct vfio_dev *)dev_id;
+	struct pci_dev *pdev = vdev->pdev;
+	irqreturn_t ret = IRQ_NONE;
+	u32 cmd_status_dword;
+	u16 origcmd, newcmd, status;
+
+	spin_lock_irq(&vdev->lock);
+	pci_block_user_cfg_access(pdev);
+
+	/* Read both command and status registers in a single 32-bit operation.
+	 * Note: we could cache the value for command and move the status read
+	 * out of the lock if there was a way to get notified of user changes
+	 * to command register through sysfs. Should be good for shared irqs. */
+	pci_read_config_dword(pdev, PCI_COMMAND, &cmd_status_dword);
+	origcmd = cmd_status_dword;
+	status = cmd_status_dword >> 16;
+
+	/* Check interrupt status register to see whether our device
+	 * triggered the interrupt. */
+	if (!(status & PCI_STATUS_INTERRUPT))
+		goto done;
+
+	/* We triggered the interrupt, disable it. */
+	newcmd = origcmd | PCI_COMMAND_INTX_DISABLE;
+	if (newcmd != origcmd)
+		pci_write_config_word(pdev, PCI_COMMAND, newcmd);
+
+	ret = IRQ_HANDLED;
+done:
+	pci_unblock_user_cfg_access(pdev);
+	spin_unlock_irq(&vdev->lock);
+	if (ret != IRQ_HANDLED)
+		return ret;
+	if (vdev->ev_irq)
+		eventfd_signal(vdev->ev_irq, 1);
+	return ret;
+}
+
+/*
+ * MSI and MSI-X Interrupt handler.
+ * Just signal an event
+ */
+static irqreturn_t msihandler(int irq, void *arg)
+{
+	struct eventfd_ctx *ctx = arg;
+
+	eventfd_signal(ctx, 1);
+	return IRQ_HANDLED;
+}
+
+void vfio_disable_msi(struct vfio_dev *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+
+	if (vdev->ev_msi) {
+		eventfd_ctx_put(vdev->ev_msi);
+		free_irq(pdev->irq, vdev->ev_msi);
+		vdev->ev_msi = NULL;
+	}
+	pci_disable_msi(pdev);
+}
+
+int vfio_enable_msi(struct vfio_dev *vdev, int fd)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	struct eventfd_ctx *ctx;
+	int ret;
+
+	ctx = eventfd_ctx_fdget(fd);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	vdev->ev_msi = ctx;
+	pci_enable_msi(pdev);
+	ret = request_irq(pdev->irq, msihandler, 0,
+			vdev->name, ctx);
+	if (ret) {
+		eventfd_ctx_put(ctx);
+		pci_disable_msi(pdev);
+		vdev->ev_msi = NULL;
+	}
+	return ret;
+}
+
+void vfio_disable_msix(struct vfio_dev *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int i;
+
+	if (vdev->ev_msix && vdev->msix) {
+		for (i = 0; i < vdev->nvec; i++) {
+			free_irq(vdev->msix[i].vector, vdev->ev_msix[i]);
+			if (vdev->ev_msix[i])
+				eventfd_ctx_put(vdev->ev_msix[i]);
+		}
+	}
+	kfree(vdev->ev_msix);
+	vdev->ev_msix = NULL;
+	kfree(vdev->msix);
+	vdev->msix = NULL;
+	vdev->nvec = 0;
+	pci_disable_msix(pdev);
+}
+
+int vfio_enable_msix(struct vfio_dev *vdev, int nvec, void __user *uarg)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	struct eventfd_ctx *ctx;
+	int ret = 0;
+	int i;
+	int fd;
+
+	vdev->msix = kzalloc(nvec * sizeof(struct msix_entry),
+				GFP_KERNEL);
+	vdev->ev_msix = kzalloc(nvec * sizeof(struct eventfd_ctx *),
+				GFP_KERNEL);
+	if (vdev->msix == NULL || vdev->ev_msix == NULL)
+		ret = -ENOMEM;
+	else {
+		for (i = 0; i < nvec; i++) {
+			if (copy_from_user(&fd, uarg, sizeof fd)) {
+				ret = -EFAULT;
+				break;
+			}
+			uarg += sizeof fd;
+			ctx = eventfd_ctx_fdget(fd);
+			if (IS_ERR(ctx)) {
+				ret = PTR_ERR(ctx);
+				break;
+			}
+			vdev->msix[i].entry = i;
+			vdev->ev_msix[i] = ctx;
+		}
+	}
+	if (!ret)
+		ret = pci_enable_msix(pdev, vdev->msix, nvec);
+	vdev->nvec = 0;
+	for (i = 0; i < nvec && !ret; i++) {
+		ret = request_irq(vdev->msix[i].vector, msihandler, 0,
+			vdev->name, vdev->ev_msix[i]);
+		if (ret)
+			break;
+		vdev->nvec = i+1;
+	}
+	if (ret)
+		vfio_disable_msix(vdev);
+	return ret;
+}
diff -uprN linux-2.6.34/drivers/vfio/vfio_main.c vfio-linux-2.6.34/drivers/vfio/vfio_main.c
--- linux-2.6.34/drivers/vfio/vfio_main.c	1969-12-31 16:00:00.000000000 -0800
+++ vfio-linux-2.6.34/drivers/vfio/vfio_main.c	2010-05-28 14:13:38.000000000 -0700
@@ -0,0 +1,627 @@
+/*
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ * Portions derived from drivers/uio/uio.c:
+ * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
+ * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
+ * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
+ * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
+ *
+ * Portions derived from drivers/uio/uio_pci_generic.c:
+ * Copyright (C) 2009 Red Hat, Inc.
+ * Author: Michael S. Tsirkin <mst@redhat.com>
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/mm.h>
+#include <linux/idr.h>
+#include <linux/string.h>
+#include <linux/interrupt.h>
+#include <linux/fs.h>
+#include <linux/eventfd.h>
+#include <linux/pci.h>
+#include <linux/iommu.h>
+#include <linux/mmu_notifier.h>
+#include <linux/uaccess.h>
+
+#include <linux/vfio.h>
+
+
+#define DRIVER_VERSION	"0.1"
+#define DRIVER_AUTHOR	"Tom Lyon <pugs@cisco.com>"
+#define DRIVER_DESC	"VFIO - User Level PCI meta-driver"
+
+static int vfio_major = -1;
+DEFINE_IDR(vfio_idr);
+/* Protect idr accesses */
+DEFINE_MUTEX(vfio_minor_lock);
+
+/*
+ * Does [a1,b1) overlap [a2,b2) ?
+ */
+static inline int overlap(int a1, int b1, int a2, int b2)
+{
+	/*
+	 * Ranges overlap if they're not disjoint; and they're
+	 * disjoint if the end of one is before the start of
+	 * the other one.
+	 */
+	return !(b2 <= a1 || b1 <= a2);
+}
+
+static int vfio_open(struct inode *inode, struct file *filep)
+{
+	struct vfio_dev *vdev;
+	struct vfio_listener *listener;
+	int ret = 0;
+
+	mutex_lock(&vfio_minor_lock);
+	vdev = idr_find(&vfio_idr, iminor(inode));
+	mutex_unlock(&vfio_minor_lock);
+	if (!vdev) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	listener = kzalloc(sizeof(*listener), GFP_KERNEL);
+	if (!listener) {
+		ret = -ENOMEM;
+		goto err_alloc_listener;
+	}
+
+	listener->vdev = vdev;
+	INIT_LIST_HEAD(&listener->dm_list);
+	filep->private_data = listener;
+
+	mutex_lock(&vdev->gate);
+	if (vdev->listeners == 0) {		/* first open */
+		if (vdev->pmaster && !iommu_found() &&
+		    !capable(CAP_SYS_RAWIO)) {
+			mutex_unlock(&vdev->gate);
+			ret = -EPERM;
+			goto err_perm;
+		}
+		/* reset to known state if we can */
+		(void) pci_reset_function(vdev->pdev);
+	}
+	vdev->listeners++;
+	mutex_unlock(&vdev->gate);
+	return 0;
+
+err_perm:
+	kfree(listener);
+
+err_alloc_listener:
+out:
+	return ret;
+}
+
+static int vfio_release(struct inode *inode, struct file *filep)
+{
+	int ret = 0;
+	struct vfio_listener *listener = filep->private_data;
+	struct vfio_dev *vdev = listener->vdev;
+
+	vfio_dma_unmapall(listener);
+	if (listener->mm) {
+		mmu_notifier_unregister(&listener->mmu_notifier, listener->mm);
+		listener->mm = NULL;
+	}
+
+	mutex_lock(&vdev->gate);
+	if (--vdev->listeners <= 0) {
+		if (vdev->ev_msix)
+			vfio_disable_msix(vdev);
+		if (vdev->ev_msi)
+			vfio_disable_msi(vdev);
+		if (vdev->ev_irq) {
+			eventfd_ctx_put(vdev->ev_msi);
+			vdev->ev_irq = NULL;
+		}
+		if (vdev->domain) {
+			iommu_domain_free(vdev->domain);
+			vdev->domain = NULL;
+		}
+		/* reset to known state if we can */
+		(void) pci_reset_function(vdev->pdev);
+	}
+	mutex_unlock(&vdev->gate);
+
+	kfree(listener);
+	return ret;
+}
+
+static ssize_t vfio_read(struct file *filep, char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	struct vfio_listener *listener = filep->private_data;
+	struct vfio_dev *vdev = listener->vdev;
+	struct pci_dev *pdev = vdev->pdev;
+	int pci_space;
+
+	pci_space = vfio_offset_to_pci_space(*ppos);
+	if (pci_space == VFIO_PCI_CONFIG_RESOURCE)
+		return vfio_config_readwrite(0, vdev, buf, count, ppos);
+	if (pci_space > PCI_ROM_RESOURCE)
+		return -EINVAL;
+	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_IO)
+		return vfio_io_readwrite(0, vdev, buf, count, ppos);
+	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM)
+		return vfio_mem_readwrite(0, vdev, buf, count, ppos);
+	if (pci_space == PCI_ROM_RESOURCE)
+		return vfio_mem_readwrite(0, vdev, buf, count, ppos);
+	return -EINVAL;
+}
+
+static int vfio_msix_check(struct vfio_dev *vdev, u64 start, u32 len)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	u16 pos;
+	u32 table_offset;
+	u16 table_size;
+	u8 bir;
+	u32 lo, hi, startp, endp;
+
+	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
+	if (!pos)
+		return 0;
+
+	pci_read_config_word(pdev, pos + PCI_MSIX_FLAGS, &table_size);
+	table_size = (table_size & PCI_MSIX_FLAGS_QSIZE) + 1;
+	pci_read_config_dword(pdev, pos + 4, &table_offset);
+	bir = table_offset & PCI_MSIX_FLAGS_BIRMASK;
+	lo = table_offset >> PAGE_SHIFT;
+	hi = (table_offset + PCI_MSIX_ENTRY_SIZE * table_size + PAGE_SIZE - 1)
+		>> PAGE_SHIFT;
+	startp = start >> PAGE_SHIFT;
+	endp = (start + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (bir == vfio_offset_to_pci_space(start) &&
+	    overlap(lo, hi, startp, endp)) {
+		printk(KERN_WARNING "%s: cannot write msi-x vectors\n",
+			__func__);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static ssize_t vfio_write(struct file *filep, const char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	struct vfio_listener *listener = filep->private_data;
+	struct vfio_dev *vdev = listener->vdev;
+	struct pci_dev *pdev = vdev->pdev;
+	int pci_space;
+	int ret;
+
+	pci_space = vfio_offset_to_pci_space(*ppos);
+	if (pci_space == VFIO_PCI_CONFIG_RESOURCE)
+		return vfio_config_readwrite(1, vdev,
+					(char __user *)buf, count, ppos);
+	if (pci_space > PCI_ROM_RESOURCE)
+		return -EINVAL;
+	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_IO)
+		return vfio_io_readwrite(1, vdev,
+					(char __user *)buf, count, ppos);
+	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM) {
+		/* don't allow writes to msi-x vectors */
+		ret = vfio_msix_check(vdev, *ppos, count);
+		if (ret)
+			return ret;
+		return vfio_mem_readwrite(1, vdev,
+				(char __user *)buf, count, ppos);
+	}
+	return -EINVAL;
+}
+
+static int vfio_mmap(struct file *filep, struct vm_area_struct *vma)
+{
+	struct vfio_listener *listener = filep->private_data;
+	struct vfio_dev *vdev = listener->vdev;
+	struct pci_dev *pdev = vdev->pdev;
+	unsigned long requested, actual;
+	int pci_space;
+	u64 start;
+	u32 len;
+	unsigned long phys;
+	int ret;
+
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+	if ((vma->vm_flags & VM_SHARED) == 0)
+		return -EINVAL;
+
+
+	pci_space = vfio_offset_to_pci_space((u64)vma->vm_pgoff << PAGE_SHIFT);
+	if (pci_space > PCI_ROM_RESOURCE)
+		return -EINVAL;
+	switch (pci_space) {
+	case PCI_ROM_RESOURCE:
+		if (vma->vm_flags & VM_WRITE)
+			return -EINVAL;
+		if (pci_resource_flags(pdev, PCI_ROM_RESOURCE) == 0)
+			return -EINVAL;
+		actual = pci_resource_len(pdev, PCI_ROM_RESOURCE) >> PAGE_SHIFT;
+		break;
+	default:
+		if ((pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM) == 0)
+			return -EINVAL;
+		actual = pci_resource_len(pdev, pci_space) >> PAGE_SHIFT;
+		break;
+	}
+
+	requested = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+	if (requested > actual || actual == 0)
+		return -EINVAL;
+
+	/*
+	 * Can't allow non-priv users to mmap MSI-X vectors
+	 * else they can write anywhere in phys memory
+	 */
+	start = vma->vm_pgoff << PAGE_SHIFT;
+	len = vma->vm_end - vma->vm_start;
+	if (vma->vm_flags & VM_WRITE) {
+		ret = vfio_msix_check(vdev, start, len);
+		if (ret)
+			return ret;
+	}
+
+	vma->vm_private_data = vdev;
+	vma->vm_flags |= VM_IO | VM_RESERVED;
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	phys = pci_resource_start(pdev, pci_space) >> PAGE_SHIFT;
+
+	return remap_pfn_range(vma, vma->vm_start, phys,
+			       vma->vm_end - vma->vm_start,
+			       vma->vm_page_prot);
+}
+
+static long vfio_unl_ioctl(struct file *filep,
+			unsigned int cmd,
+			unsigned long arg)
+{
+	struct vfio_listener *listener = filep->private_data;
+	struct vfio_dev *vdev = listener->vdev;
+	void __user *uarg = (void __user *)arg;
+	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_dma_map dm;
+	int ret = 0;
+	u64 mask;
+	int fd, nfd;
+	int bar;
+
+	if (vdev == NULL)
+		return -EINVAL;
+
+	switch (cmd) {
+
+	case VFIO_DMA_MAP_ANYWHERE:
+	case VFIO_DMA_MAP_IOVA:
+		if (copy_from_user(&dm, uarg, sizeof dm))
+			return -EFAULT;
+		ret = vfio_dma_map_common(listener, cmd, &dm);
+		if (!ret && copy_to_user(uarg, &dm, sizeof dm))
+			ret = -EFAULT;
+		break;
+
+	case VFIO_DMA_UNMAP:
+		if (copy_from_user(&dm, uarg, sizeof dm))
+			return -EFAULT;
+		ret = vfio_dma_unmap_dm(listener, &dm);
+		break;
+
+	case VFIO_DMA_MASK:	/* set master mode and DMA mask */
+		if (copy_from_user(&mask, uarg, sizeof mask))
+			return -EFAULT;
+		pci_set_master(pdev);
+		ret = pci_set_dma_mask(pdev, mask);
+		break;
+
+	case VFIO_EVENTFD_IRQ:
+		if (copy_from_user(&fd, uarg, sizeof fd))
+			return -EFAULT;
+		if (vdev->ev_irq)
+			eventfd_ctx_put(vdev->ev_irq);
+		if (fd >= 0) {
+			vdev->ev_irq = eventfd_ctx_fdget(fd);
+			if (vdev->ev_irq == NULL)
+				ret = -EINVAL;
+		}
+		break;
+
+	case VFIO_EVENTFD_MSI:
+		if (copy_from_user(&fd, uarg, sizeof fd))
+			return -EFAULT;
+		if (fd >= 0 && vdev->ev_msi == NULL && vdev->ev_msix == NULL)
+			ret = vfio_enable_msi(vdev, fd);
+		else if (fd < 0 && vdev->ev_msi)
+			vfio_disable_msi(vdev);
+		else
+			ret = -EINVAL;
+		break;
+
+	case VFIO_EVENTFDS_MSIX:
+		if (copy_from_user(&nfd, uarg, sizeof nfd))
+			return -EFAULT;
+		uarg += sizeof nfd;
+		if (nfd > 0 && vdev->ev_msi == NULL && vdev->ev_msix == NULL)
+			ret = vfio_enable_msix(vdev, nfd, uarg);
+		else if (nfd == 0 && vdev->ev_msix)
+			vfio_disable_msix(vdev);
+		else
+			ret = -EINVAL;
+		break;
+
+	case VFIO_BAR_LEN:
+		if (copy_from_user(&bar, uarg, sizeof bar))
+			return -EFAULT;
+		if (bar < 0 || bar > PCI_ROM_RESOURCE)
+			return -EINVAL;
+		bar = pci_resource_len(pdev, bar);
+		if (copy_to_user(uarg, &bar, sizeof bar))
+			return -EFAULT;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+	return ret;
+}
+
+static const struct file_operations vfio_fops = {
+	.owner		= THIS_MODULE,
+	.open		= vfio_open,
+	.release	= vfio_release,
+	.read		= vfio_read,
+	.write		= vfio_write,
+	.unlocked_ioctl	= vfio_unl_ioctl,
+	.mmap		= vfio_mmap,
+};
+
+static int vfio_get_devnum(struct vfio_dev *vdev)
+{
+	int retval = -ENOMEM;
+	int id;
+
+	mutex_lock(&vfio_minor_lock);
+	if (idr_pre_get(&vfio_idr, GFP_KERNEL) == 0)
+		goto exit;
+
+	retval = idr_get_new(&vfio_idr, vdev, &id);
+	if (retval < 0) {
+		if (retval == -EAGAIN)
+			retval = -ENOMEM;
+		goto exit;
+	}
+	if (id > MINORMASK) {
+		idr_remove(&vfio_idr, id);
+		retval = -ENOMEM;
+	}
+	if (vfio_major < 0) {
+		retval = register_chrdev(0, "vfio", &vfio_fops);
+		if (retval < 0)
+			goto exit;
+		vfio_major = retval;
+	}
+
+	retval = MKDEV(vfio_major, id);
+exit:
+	mutex_unlock(&vfio_minor_lock);
+	return retval;
+}
+
+static void vfio_free_minor(struct vfio_dev *vdev)
+{
+	mutex_lock(&vfio_minor_lock);
+	idr_remove(&vfio_idr, MINOR(vdev->devnum));
+	mutex_unlock(&vfio_minor_lock);
+}
+
+/*
+ * Verify that the device supports Interrupt Disable bit in command register,
+ * per PCI 2.3, by flipping this bit and reading it back: this bit was readonly
+ * in PCI 2.2.  (from uio_pci_generic)
+ */
+static int verify_pci_2_3(struct pci_dev *pdev)
+{
+	u16 orig, new;
+	int err = 0;
+	u8 line;
+
+	pci_block_user_cfg_access(pdev);
+
+	pci_read_config_byte(pdev, PCI_INTERRUPT_LINE, &line);
+	if (line == 0)
+		goto out;
+
+	pci_read_config_word(pdev, PCI_COMMAND, &orig);
+	pci_write_config_word(pdev, PCI_COMMAND,
+			      orig ^ PCI_COMMAND_INTX_DISABLE);
+	pci_read_config_word(pdev, PCI_COMMAND, &new);
+	/* There's no way to protect against
+	 * hardware bugs or detect them reliably, but as long as we know
+	 * what the value should be, let's go ahead and check it. */
+	if ((new ^ orig) & ~PCI_COMMAND_INTX_DISABLE) {
+		err = -EBUSY;
+		dev_err(&pdev->dev, "Command changed from 0x%x to 0x%x: "
+			"driver or HW bug?\n", orig, new);
+		goto out;
+	}
+	if (!((new ^ orig) & PCI_COMMAND_INTX_DISABLE)) {
+		dev_warn(&pdev->dev, "Device does not support "
+			 "disabling interrupts: unable to bind.\n");
+		err = -ENODEV;
+		goto out;
+	}
+	/* Now restore the original value. */
+	pci_write_config_word(pdev, PCI_COMMAND, orig);
+out:
+	pci_unblock_user_cfg_access(pdev);
+	return err;
+}
+
+static int pci_is_master(struct pci_dev *pdev)
+{
+	int ret;
+	u16 orig, new;
+
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSI))
+		return 1;
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX))
+		return 1;
+
+	pci_block_user_cfg_access(pdev);
+
+	pci_read_config_word(pdev, PCI_COMMAND, &orig);
+	ret = orig & PCI_COMMAND_MASTER;
+	if (!ret) {
+		new = orig | PCI_COMMAND_MASTER;
+		pci_write_config_word(pdev, PCI_COMMAND, new);
+		pci_read_config_word(pdev, PCI_COMMAND, &new);
+		ret = new & PCI_COMMAND_MASTER;
+		pci_write_config_word(pdev, PCI_COMMAND, orig);
+	}
+
+	pci_unblock_user_cfg_access(pdev);
+	return ret;
+}
+
+static int vfio_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct vfio_dev *vdev;
+	int err;
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "%s: pci_enable_device failed: %d\n",
+			__func__, err);
+		return err;
+	}
+
+	err = verify_pci_2_3(pdev);
+	if (err)
+		goto err_verify;
+
+	vdev = kzalloc(sizeof(struct vfio_dev), GFP_KERNEL);
+	if (!vdev) {
+		err = -ENOMEM;
+		goto err_alloc;
+	}
+	vdev->pdev = pdev;
+	vdev->pmaster = pci_is_master(pdev);
+
+	err = vfio_class_init();
+	if (err)
+		goto err_class;
+
+	mutex_init(&vdev->gate);
+
+	err = vfio_get_devnum(vdev);
+	if (err < 0)
+		goto err_get_devnum;
+	vdev->devnum = err;
+	err = 0;
+
+	sprintf(vdev->name, "vfio%d", MINOR(vdev->devnum));
+	pci_set_drvdata(pdev, vdev);
+	vdev->dev = device_create(vfio_class->class, &pdev->dev,
+			  vdev->devnum, vdev, vdev->name);
+	if (IS_ERR(vdev->dev)) {
+		printk(KERN_ERR "VFIO: device register failed\n");
+		err = PTR_ERR(vdev->dev);
+		goto err_device_create;
+	}
+
+	err = vfio_dev_add_attributes(vdev);
+	if (err)
+		goto err_vfio_dev_add_attributes;
+
+
+	if (pdev->irq > 0) {
+		err = request_irq(pdev->irq, vfio_interrupt,
+				  IRQF_SHARED, "vfio", vdev);
+		if (err)
+			goto err_request_irq;
+	}
+	vdev->vinfo.bardirty = 1;
+
+	return 0;
+
+err_request_irq:
+#ifdef notdef
+	vfio_dev_del_attributes(vdev);
+#endif
+err_vfio_dev_add_attributes:
+	device_destroy(vfio_class->class, vdev->devnum);
+err_device_create:
+	vfio_free_minor(vdev);
+err_get_devnum:
+err_class:
+	kfree(vdev);
+err_alloc:
+err_verify:
+	pci_disable_device(pdev);
+	return err;
+}
+
+static void vfio_remove(struct pci_dev *pdev)
+{
+	struct vfio_dev *vdev = pci_get_drvdata(pdev);
+
+	vfio_free_minor(vdev);
+
+	if (pdev->irq > 0)
+		free_irq(pdev->irq, vdev);
+
+#ifdef notdef
+	vfio_dev_del_attributes(vdev);
+#endif
+
+	pci_set_drvdata(pdev, NULL);
+	device_destroy(vfio_class->class, vdev->devnum);
+	kfree(vdev);
+	vfio_class_destroy();
+	pci_disable_device(pdev);
+}
+
+static struct pci_driver driver = {
+	.name = "vfio",
+	.id_table = NULL, /* only dynamic id's */
+	.probe = vfio_probe,
+	.remove = vfio_remove,
+};
+
+static int __init init(void)
+{
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
+	return pci_register_driver(&driver);
+}
+
+static void __exit cleanup(void)
+{
+	if (vfio_major >= 0)
+		unregister_chrdev(vfio_major, "vfio");
+	pci_unregister_driver(&driver);
+}
+
+module_init(init);
+module_exit(cleanup);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff -uprN linux-2.6.34/drivers/vfio/vfio_pci_config.c vfio-linux-2.6.34/drivers/vfio/vfio_pci_config.c
--- linux-2.6.34/drivers/vfio/vfio_pci_config.c	1969-12-31 16:00:00.000000000 -0800
+++ vfio-linux-2.6.34/drivers/vfio/vfio_pci_config.c	2010-05-28 14:26:47.000000000 -0700
@@ -0,0 +1,554 @@
+/*
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ * Portions derived from drivers/uio/uio.c:
+ * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
+ * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
+ * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
+ * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
+ *
+ * Portions derived from drivers/uio/uio_pci_generic.c:
+ * Copyright (C) 2009 Red Hat, Inc.
+ * Author: Michael S. Tsirkin <mst@redhat.com>
+ */
+
+#include <linux/fs.h>
+#include <linux/pci.h>
+#include <linux/mmu_notifier.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+
+#define PCI_CAP_ID_BASIC	0
+#ifndef PCI_CAP_ID_MAX
+#define	PCI_CAP_ID_MAX		PCI_CAP_ID_AF
+#endif
+
+/*
+ * Lengths of PCI Config Capabilities
+ * 0 means unknown (but at least 4)
+ * FF means special/variable
+ */
+static u8 pci_capability_length[] = {
+	[PCI_CAP_ID_BASIC]	= 64,		/* pci config header */
+	[PCI_CAP_ID_PM]		= PCI_PM_SIZEOF,
+	[PCI_CAP_ID_AGP]	= PCI_AGP_SIZEOF,
+	[PCI_CAP_ID_VPD]	= 8,
+	[PCI_CAP_ID_SLOTID]	= 4,
+	[PCI_CAP_ID_MSI]	= 0xFF,		/* 10, 14, or 24 */
+	[PCI_CAP_ID_CHSWP]	= 4,
+	[PCI_CAP_ID_PCIX]	= 0xFF,		/* 8 or 24 */
+	[PCI_CAP_ID_HT]		= 28,
+	[PCI_CAP_ID_VNDR]	= 0xFF,
+	[PCI_CAP_ID_DBG]	= 0,
+	[PCI_CAP_ID_CCRC]	= 0,
+	[PCI_CAP_ID_SHPC]	= 0,
+	[PCI_CAP_ID_SSVID]	= 0,		/* bridge only - not supp */
+	[PCI_CAP_ID_AGP3]	= 0,
+	[PCI_CAP_ID_EXP]	= 36,
+	[PCI_CAP_ID_MSIX]	= 12,
+	[PCI_CAP_ID_AF]		= 6,
+};
+
+/*
+ * Read/Write Permission Bits - one bit for each bit in capability
+ * Any field can be read if it exists,
+ * but what is read depends on whether the field
+ * is 'virtualized', or just pass thru to the hardware.
+ * Any virtualized field is also virtualized for writes.
+ * Writes are only permitted if they have a 1 bit here.
+ */
+struct perm_bits {
+	u32	rvirt;		/* read bits which must be virtualized */
+	u32	write;		/* writeable bits - virt if read virt */
+};
+
+static struct perm_bits pci_cap_basic_perm[] = {
+	{ 0xFFFFFFFF,	0, },		/* 0x00 vendor & device id - RO */
+	{ 0,		0xFFFFFFFC, },	/* 0x04 cmd & status except mem/io */
+	{ 0,		0xFF00FFFF, },	/* 0x08 bist, htype, lat, cache */
+	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x0c bar */
+	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x10 bar */
+	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x14 bar */
+	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x18 bar */
+	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x1c bar */
+	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x20 bar */
+	{ 0,		0, },		/* 0x24 cardbus - not yet */
+	{ 0,		0, },		/* 0x28 subsys vendor & dev */
+	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x2c rom bar */
+	{ 0,		0, },		/* 0x30 capability ptr & resv */
+	{ 0,		0, },		/* 0x34 resv */
+	{ 0,		0, },		/* 0x38 resv */
+	{ 0x000000FF,	0x000000FF, },	/* 0x3c max_lat ... irq */
+};
+
+static struct perm_bits pci_cap_pm_perm[] = {
+	{ 0,		0, },		/* 0x00 PM capabilities */
+	{ 0,		0xFFFFFFFF, },	/* 0x04 PM control/status */
+};
+
+static struct perm_bits pci_cap_vpd_perm[] = {
+	{ 0,		0xFFFF0000, },	/* 0x00 address */
+	{ 0,		0xFFFFFFFF, },	/* 0x04 data */
+};
+
+static struct perm_bits pci_cap_slotid_perm[] = {
+	{ 0,		0, },		/* 0x00 all read only */
+};
+
+static struct perm_bits pci_cap_msi_perm[] = {
+	{ 0,		0, },		/* 0x00 MSI message control */
+	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
+	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x08 MSI message addr/data */
+	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x0c MSI message data */
+	{ 0,		0xFFFFFFFF, },	/* 0x10 MSI mask bits */
+	{ 0,		0xFFFFFFFF, },	/* 0x14 MSI pending bits */
+};
+
+static struct perm_bits pci_cap_pcix_perm[] = {
+	{ 0,		0xFFFF0000, },	/* 0x00 PCI_X_CMD */
+	{ 0,		0, },		/* 0x04 PCI_X_STATUS */
+	{ 0,		0xFFFFFFFF, },	/* 0x08 ECC ctlr & status */
+	{ 0,		0, },		/* 0x0c ECC first addr */
+	{ 0,		0, },		/* 0x10 ECC second addr */
+	{ 0,		0, },		/* 0x14 ECC attr */
+};
+
+/* pci express capabilities */
+static struct perm_bits pci_cap_exp_perm[] = {
+	{ 0,		0, },		/* 0x00 PCIe capabilities */
+	{ 0,		0, },		/* 0x04 PCIe device capabilities */
+	{ 0,		0xFFFFFFFF, },	/* 0x08 PCIe device control & status */
+	{ 0,		0, },		/* 0x0c PCIe link capabilities */
+	{ 0,		0x000000FF, },	/* 0x10 PCIe link ctl/stat - SAFE? */
+	{ 0,		0, },		/* 0x14 PCIe slot capabilities */
+	{ 0,		0x00FFFFFF, },	/* 0x18 PCIe link ctl/stat - SAFE? */
+	{ 0,		0, },		/* 0x1c PCIe root port stuff */
+	{ 0,		0, },		/* 0x20 PCIe root port stuff */
+};
+
+static struct perm_bits pci_cap_msix_perm[] = {
+	{ 0,		0, },		/* 0x00 MSI-X Enable */
+	{ 0,		0, },		/* 0x04 table offset & bir */
+	{ 0,		0, },		/* 0x08 pba offset & bir */
+};
+
+static struct perm_bits pci_cap_af_perm[] = {
+	{ 0,		0, },		/* 0x00 af capability */
+	{ 0,		0x0001,	 },	/* 0x04 af flr bit */
+};
+
+static struct perm_bits *pci_cap_perms[] = {
+	[PCI_CAP_ID_BASIC]	= pci_cap_basic_perm,
+	[PCI_CAP_ID_PM]		= pci_cap_pm_perm,
+	[PCI_CAP_ID_VPD]	= pci_cap_vpd_perm,
+	[PCI_CAP_ID_SLOTID]	= pci_cap_slotid_perm,
+	[PCI_CAP_ID_MSI]	= pci_cap_msi_perm,
+	[PCI_CAP_ID_PCIX]	= pci_cap_pcix_perm,
+	[PCI_CAP_ID_EXP]	= pci_cap_exp_perm,
+	[PCI_CAP_ID_MSIX]	= pci_cap_msix_perm,
+	[PCI_CAP_ID_AF]		= pci_cap_af_perm,
+};
+
+/*
+ * We build a map of the config space that tells us where
+ * and what capabilities exist, so that we can map reads and
+ * writes back to capabilities, and thus figure out what to
+ * allow, deny, or virtualize
+ */
+int vfio_build_config_map(struct vfio_dev *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	u8 *map;
+	int i, len;
+	u8 pos, cap, tmp;
+	u16 flags;
+	int ret;
+	int loops = 100;
+
+	map = kmalloc(pdev->cfg_size, GFP_KERNEL);
+	if (map == NULL)
+		return -ENOMEM;
+	for (i = 0; i < pdev->cfg_size; i++)
+		map[i] = 0xFF;
+	vdev->pci_config_map = map;
+
+	/* default config space */
+	for (i = 0; i < pci_capability_length[0]; i++)
+		map[i] = 0;
+
+	/* any capabilities? */
+	ret = pci_read_config_word(pdev, PCI_STATUS, &flags);
+	if (ret < 0)
+		return ret;
+	if ((flags & PCI_STATUS_CAP_LIST) == 0)
+		return 0;
+
+	ret = pci_read_config_byte(pdev, PCI_CAPABILITY_LIST, &pos);
+	if (ret < 0)
+		return ret;
+	while (pos && --loops > 0) {
+		ret = pci_read_config_byte(pdev, pos, &cap);
+		if (ret < 0)
+			return ret;
+		if (cap == 0) {
+			printk(KERN_WARNING "%s: cap 0\n", __func__);
+			break;
+		}
+		if (cap > PCI_CAP_ID_MAX) {
+			printk(KERN_WARNING "%s: unknown pci capability id %x\n",
+					__func__, cap);
+			len = 0;
+		} else
+			len = pci_capability_length[cap];
+		if (len == 0) {
+			printk(KERN_WARNING "%s: unknown length for pci cap %x\n",
+					__func__, cap);
+			len = 4;
+		}
+		if (len == 0xFF) {
+			switch (cap) {
+			case PCI_CAP_ID_MSI:
+				ret = pci_read_config_word(pdev,
+						pos + PCI_MSI_FLAGS, &flags);
+				if (ret < 0)
+					return ret;
+				if (flags & PCI_MSI_FLAGS_MASKBIT)
+					/* per vec masking */
+					len = 24;
+				else if (flags & PCI_MSI_FLAGS_64BIT)
+					/* 64 bit */
+					len = 14;
+				else
+					len = 10;
+				break;
+			case PCI_CAP_ID_PCIX:
+				ret = pci_read_config_word(pdev, pos + 2,
+					&flags);
+				if (ret < 0)
+					return ret;
+				if (flags & 0x3000)
+					len = 24;
+				else
+					len = 8;
+				break;
+			case PCI_CAP_ID_VNDR:
+				/* length follows next field */
+				ret = pci_read_config_byte(pdev, pos + 2, &tmp);
+				if (ret < 0)
+					return ret;
+				len = tmp;
+				break;
+			default:
+				len = 0;
+				break;
+			}
+		}
+
+		for (i = 0; i < len; i++) {
+			if (map[pos+i] != 0xFF)
+				printk(KERN_WARNING
+					"%s: pci config conflict at %x, "
+					"caps %x %x\n",
+					__func__, i, map[pos+i], cap);
+			map[pos+i] = cap;
+		}
+		ret = pci_read_config_byte(pdev, pos + PCI_CAP_LIST_NEXT, &pos);
+		if (ret < 0)
+			return ret;
+	}
+	if (loops <= 0)
+		printk(KERN_ERR "%s: config space loop!\n", __func__);
+	return 0;
+}
+
+static void vfio_virt_init(struct vfio_dev *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int bar;
+	u32 *lp;
+	u32 val;
+	u8 *map, pos;
+	u16 flags;
+	int i, len;
+	int ret;
+
+	for (bar = 0; bar <= 5; bar++) {
+		lp = (u32 *)&vdev->vinfo.bar[bar * 4];
+		pci_read_config_dword(pdev, PCI_BASE_ADDRESS_0 + 4*bar, &val);
+		*lp++ = val;
+	}
+	lp = (u32 *)vdev->vinfo.rombar;
+	pci_read_config_dword(pdev, PCI_ROM_ADDRESS, &val);
+	*lp = val;
+
+	vdev->vinfo.intr = pdev->irq;
+
+	pos = pci_find_capability(pdev, PCI_CAP_ID_MSI);
+	map = vdev->pci_config_map + pos;
+	if (pos > 0) {
+		ret = pci_read_config_word(pdev, pos + PCI_MSI_FLAGS, &flags);
+		if (ret < 0)
+			return;
+		if (flags & PCI_MSI_FLAGS_MASKBIT)	/* per vec masking */
+			len = 24;
+		else if (flags & PCI_MSI_FLAGS_64BIT)	/* 64 bit */
+			len = 14;
+		else
+			len = 10;
+		for (i = 0; i < len; i++)
+			(void) pci_read_config_byte(pdev, pos + i,
+						&vdev->vinfo.msi[i]);
+	}
+}
+
+static void vfio_bar_fixup(struct vfio_dev *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int bar;
+	u32 *lp;
+	u32 len;
+
+	for (bar = 0; bar <= 5; bar++) {
+		len = pci_resource_len(pdev, bar);
+		lp = (u32 *)&vdev->vinfo.bar[bar * 4];
+		if (len == 0) {
+			*lp = 0;
+		} else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
+			*lp &= ~0x1;
+			*lp = (*lp & ~(len-1)) |
+				(*lp & ~PCI_BASE_ADDRESS_MEM_MASK);
+			if (*lp & PCI_BASE_ADDRESS_MEM_TYPE_64)
+				bar++;
+		} else if (pci_resource_flags(pdev, bar) & IORESOURCE_IO) {
+			*lp |= PCI_BASE_ADDRESS_SPACE_IO;
+			*lp = (*lp & ~(len-1)) |
+				(*lp & ~PCI_BASE_ADDRESS_IO_MASK);
+		}
+	}
+	lp = (u32 *)vdev->vinfo.rombar;
+	len = pci_resource_len(pdev, PCI_ROM_RESOURCE);
+	*lp = *lp & PCI_ROM_ADDRESS_MASK & ~(len-1);
+	vdev->vinfo.bardirty = 0;
+}
+
+static int vfio_config_rwbyte(int write,
+				struct vfio_dev *vdev,
+				int pos,
+				char __user *buf)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	u8 *map = vdev->pci_config_map;
+	u8 cap, val, newval;
+	u16 start, off;
+	int p;
+	struct perm_bits *perm;
+	u8 wr, virt;
+	int ret;
+
+	cap = map[pos];
+	if (cap == 0xFF) {	/* unknown region */
+		if (write)
+			return 0;	/* silent no-op */
+		val = 0;
+		if (pos <= pci_capability_length[0])	/* ok to read */
+			(void) pci_read_config_byte(pdev, pos, &val);
+		if (copy_to_user(buf, &val, 1))
+			return -EFAULT;
+		return 0;
+	}
+
+	/* scan back to start of cap region */
+	for (p = pos; p >= 0; p--) {
+		if (map[p] != cap)
+			break;
+		start = p;
+	}
+	off = pos - start;	/* offset within capability */
+
+	perm = pci_cap_perms[cap];
+	if (perm == NULL) {
+		wr = 0;
+		virt = 0;
+	} else {
+		perm += (off >> 2);
+		wr = perm->write >> ((off & 3) * 8);
+		virt = perm->rvirt >> ((off & 3) * 8);
+	}
+	if (write && !wr)		/* no writeable bits */
+		return 0;
+	if (!virt) {
+		if (write) {
+			if (copy_from_user(&val, buf, 1))
+				return -EFAULT;
+			val &= wr;
+			if (wr != 0xFF) {
+				u8 existing;
+
+				ret = pci_read_config_byte(pdev, pos,
+								&existing);
+				if (ret < 0)
+					return ret;
+				val |= (existing & ~wr);
+			}
+			pci_write_config_byte(pdev, pos, val);
+		} else {
+			ret = pci_read_config_byte(pdev, pos, &val);
+			if (ret < 0)
+				return ret;
+			if (copy_to_user(buf, &val, 1))
+				return -EFAULT;
+		}
+		return 0;
+	}
+
+	if (write) {
+		if (copy_from_user(&newval, buf, 1))
+			return -EFAULT;
+	}
+	/*
+	 * We get here if there are some virt bits
+	 * handle remaining real bits, if any
+	 */
+	if (~virt) {
+		u8 rbits = (~virt) & wr;
+
+		ret = pci_read_config_byte(pdev, pos, &val);
+		if (ret < 0)
+			return ret;
+		if (write && rbits) {
+			val &= ~rbits;
+			newval &= rbits;
+			val |= newval;
+			pci_write_config_byte(pdev, pos, val);
+		}
+	}
+	/*
+	 * Now handle entirely virtual fields
+	 */
+	switch (cap) {
+	case PCI_CAP_ID_BASIC:		/* virtualize BARs */
+		switch (off) {
+		/*
+		 * vendor and device are virt because they don't
+		 * show up otherwise for sr-iov vfs
+		 */
+		case PCI_VENDOR_ID:
+			val = pdev->vendor;
+			break;
+		case PCI_VENDOR_ID + 1:
+			val = pdev->vendor >> 8;
+			break;
+		case PCI_DEVICE_ID:
+			val = pdev->device;
+			break;
+		case PCI_DEVICE_ID + 1:
+			val = pdev->device >> 8;
+			break;
+		case PCI_INTERRUPT_LINE:
+			if (write)
+				vdev->vinfo.intr = newval;
+			else
+				val = vdev->vinfo.intr;
+			break;
+		case PCI_ROM_ADDRESS:
+		case PCI_ROM_ADDRESS+1:
+		case PCI_ROM_ADDRESS+2:
+		case PCI_ROM_ADDRESS+3:
+			if (write) {
+				vdev->vinfo.rombar[off & 3] = newval;
+				vdev->vinfo.bardirty = 1;
+			} else {
+				if (vdev->vinfo.bardirty)
+					vfio_bar_fixup(vdev);
+				val = vdev->vinfo.rombar[off & 3];
+			}
+			break;
+		default:
+			if (off >= PCI_BASE_ADDRESS_0 &&
+			    off <= PCI_BASE_ADDRESS_5 + 3) {
+				int boff = off - PCI_BASE_ADDRESS_0;
+
+				if (write) {
+					vdev->vinfo.bar[boff] = newval;
+					vdev->vinfo.bardirty = 1;
+				} else {
+					if (vdev->vinfo.bardirty)
+						vfio_bar_fixup(vdev);
+					val = vdev->vinfo.bar[boff];
+				}
+			}
+			break;
+		}
+		break;
+	case PCI_CAP_ID_MSI:		/* virtualize MSI */
+		if (off >= PCI_MSI_ADDRESS_LO && off <= (PCI_MSI_DATA_64 + 2)) {
+			int moff = off - PCI_MSI_ADDRESS_LO;
+
+			if (write)
+				vdev->vinfo.msi[moff] = newval;
+			else
+				val = vdev->vinfo.msi[moff];
+			break;
+		}
+		break;
+	}
+	if (!write && copy_to_user(buf, &val, 1))
+		return -EFAULT;
+	return 0;
+}
+
+ssize_t vfio_config_readwrite(int write,
+		struct vfio_dev *vdev,
+		char __user *buf,
+		size_t count,
+		loff_t *ppos)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int done = 0;
+	int ret;
+	int pos;
+
+	pci_block_user_cfg_access(pdev);
+
+	if (vdev->pci_config_map == NULL) {
+		ret = vfio_build_config_map(vdev);
+		if (ret < 0)
+			goto out;
+		vfio_virt_init(vdev);
+	}
+
+	while (count > 0) {
+		pos = *ppos;
+		if (pos == pdev->cfg_size)
+			break;
+		if (pos > pdev->cfg_size) {
+			ret = -EINVAL;
+			goto out;
+		}
+		ret = vfio_config_rwbyte(write, vdev, pos, buf);
+		if (ret < 0)
+			goto out;
+		buf++;
+		done++;
+		count--;
+		(*ppos)++;
+	}
+	ret = done;
+out:
+	pci_unblock_user_cfg_access(pdev);
+	return ret;
+}
diff -uprN linux-2.6.34/drivers/vfio/vfio_rdwr.c vfio-linux-2.6.34/drivers/vfio/vfio_rdwr.c
--- linux-2.6.34/drivers/vfio/vfio_rdwr.c	1969-12-31 16:00:00.000000000 -0800
+++ vfio-linux-2.6.34/drivers/vfio/vfio_rdwr.c	2010-05-28 14:27:40.000000000 -0700
@@ -0,0 +1,147 @@
+/*
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ * Portions derived from drivers/uio/uio.c:
+ * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
+ * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
+ * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
+ * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
+ *
+ * Portions derived from drivers/uio/uio_pci_generic.c:
+ * Copyright (C) 2009 Red Hat, Inc.
+ * Author: Michael S. Tsirkin <mst@redhat.com>
+ */
+
+#include <linux/fs.h>
+#include <linux/mmu_notifier.h>
+#include <linux/pci.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+
+#include <linux/vfio.h>
+
+ssize_t vfio_io_readwrite(
+		int write,
+		struct vfio_dev *vdev,
+		char __user *buf,
+		size_t count,
+		loff_t *ppos)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	size_t done = 0;
+	resource_size_t end;
+	void __iomem *io;
+	loff_t pos;
+	int pci_space;
+	int unit;
+
+	pci_space = vfio_offset_to_pci_space(*ppos);
+	pos = (*ppos & 0xFFFFFFFF);
+
+	if (vdev->bar[pci_space] == NULL)
+		vdev->bar[pci_space] = pci_iomap(pdev, pci_space, 0);
+	io = vdev->bar[pci_space];
+	end = pci_resource_len(pdev, pci_space);
+	if (pos + count > end)
+		return -EINVAL;
+
+	while (count > 0) {
+		if ((pos % 4) == 0 && count >= 4) {
+			u32 val;
+
+			if (write) {
+				if (copy_from_user(&val, buf, 4))
+					return -EFAULT;
+				iowrite32(val, io + pos);
+			} else {
+				val = ioread32(io + pos);
+				if (copy_to_user(buf, &val, 4))
+					return -EFAULT;
+			}
+			unit = 4;
+		} else if ((pos % 2) == 0 && count >= 2) {
+			u16 val;
+
+			if (write) {
+				if (copy_from_user(&val, buf, 2))
+					return -EFAULT;
+				iowrite16(val, io + pos);
+			} else {
+				val = ioread16(io + pos);
+				if (copy_to_user(buf, &val, 2))
+					return -EFAULT;
+			}
+			unit = 2;
+		} else {
+			u8 val;
+
+			if (write) {
+				if (copy_from_user(&val, buf, 1))
+					return -EFAULT;
+				iowrite8(val, io + pos);
+			} else {
+				val = ioread8(io + pos);
+				if (copy_to_user(buf, &val, 1))
+					return -EFAULT;
+			}
+			unit = 1;
+		}
+		pos += unit;
+		buf += unit;
+		count -= unit;
+		done += unit;
+	}
+	*ppos += done;
+	return done;
+}
+
+ssize_t vfio_mem_readwrite(
+		int write,
+		struct vfio_dev *vdev,
+		char __user *buf,
+		size_t count,
+		loff_t *ppos)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	resource_size_t end;
+	void __iomem *io;
+	loff_t pos;
+	int pci_space;
+
+	pci_space = vfio_offset_to_pci_space(*ppos);
+	pos = (*ppos & 0xFFFFFFFF);
+
+	if (vdev->bar[pci_space] == NULL)
+		vdev->bar[pci_space] = pci_iomap(pdev, pci_space, 0);
+	io = vdev->bar[pci_space];
+	end = pci_resource_len(pdev, pci_space);
+	if (pos > end)
+		return -EINVAL;
+	if (pos == end)
+		return 0;
+	if (pos + count > end)
+		count = end - pos;
+	if (write) {
+		if (copy_from_user(io + pos, buf, count))
+			return -EFAULT;
+	} else {
+		if (copy_to_user(buf, io + pos, count))
+			return -EFAULT;
+	}
+	*ppos += count;
+	return count;
+}
diff -uprN linux-2.6.34/drivers/vfio/vfio_sysfs.c vfio-linux-2.6.34/drivers/vfio/vfio_sysfs.c
--- linux-2.6.34/drivers/vfio/vfio_sysfs.c	1969-12-31 16:00:00.000000000 -0800
+++ vfio-linux-2.6.34/drivers/vfio/vfio_sysfs.c	2010-05-28 14:04:34.000000000 -0700
@@ -0,0 +1,153 @@
+/*
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ * Portions derived from drivers/uio/uio.c:
+ * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
+ * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
+ * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
+ * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
+ *
+ * Portions derived from drivers/uio/uio_pci_generic.c:
+ * Copyright (C) 2009 Red Hat, Inc.
+ * Author: Michael S. Tsirkin <mst@redhat.com>
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/pci.h>
+#include <linux/mmu_notifier.h>
+
+#include <linux/vfio.h>
+
+struct vfio_class *vfio_class;
+
+int vfio_class_init(void)
+{
+	int ret = 0;
+
+	if (vfio_class != NULL) {
+		kref_get(&vfio_class->kref);
+		goto exit;
+	}
+
+	vfio_class = kzalloc(sizeof(*vfio_class), GFP_KERNEL);
+	if (!vfio_class) {
+		ret = -ENOMEM;
+		goto err_kzalloc;
+	}
+
+	kref_init(&vfio_class->kref);
+	vfio_class->class = class_create(THIS_MODULE, "vfio");
+	if (IS_ERR(vfio_class->class)) {
+		ret = IS_ERR(vfio_class->class);
+		printk(KERN_ERR "class_create failed for vfio\n");
+		goto err_class_create;
+	}
+	return 0;
+
+err_class_create:
+	kfree(vfio_class);
+	vfio_class = NULL;
+err_kzalloc:
+exit:
+	return ret;
+}
+
+static void vfio_class_release(struct kref *kref)
+{
+	/* Ok, we cheat as we know we only have one vfio_class */
+	class_destroy(vfio_class->class);
+	kfree(vfio_class);
+	vfio_class = NULL;
+}
+
+void vfio_class_destroy(void)
+{
+	if (vfio_class)
+		kref_put(&vfio_class->kref, vfio_class_release);
+}
+
+ssize_t config_map_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct vfio_dev *vdev = bin_attr->private;
+	int ret;
+
+	if (off >= 256)
+		return 0;
+	if (off + count > 256)
+		count = 256 - off;
+	if (vdev->pci_config_map == NULL) {
+		ret = vfio_build_config_map(vdev);
+		if (ret < 0)
+			return ret;
+	}
+	memcpy(buf, vdev->pci_config_map + off, count);
+	return count;
+}
+
+static ssize_t show_locked_pages(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct vfio_dev *vdev = dev_get_drvdata(dev);
+
+	if (vdev == NULL)
+		return -ENODEV;
+	return sprintf(buf, "%u\n", vdev->locked_pages);
+}
+
+static DEVICE_ATTR(locked_pages, S_IRUGO, show_locked_pages, NULL);
+
+static struct attribute *vfio_attrs[] = {
+	&dev_attr_locked_pages.attr,
+	NULL,
+};
+
+static struct attribute_group vfio_attr_grp = {
+	.attrs = vfio_attrs,
+};
+
+struct bin_attribute config_map_bin_attribute = {
+	.attr	= {
+		.name = "config_map",
+		.mode = S_IRUGO,
+	},
+	.size	= 256,
+	.read	= config_map_read,
+};
+
+int vfio_dev_add_attributes(struct vfio_dev *vdev)
+{
+	struct bin_attribute *bi;
+	int ret;
+
+	ret = sysfs_create_group(&vdev->dev->kobj, &vfio_attr_grp);
+	if (ret)
+		return ret;
+	bi = kmalloc(sizeof(*bi), GFP_KERNEL);
+	if (bi == NULL)
+		return -ENOMEM;
+	*bi = config_map_bin_attribute;
+	bi->private = vdev;
+	return sysfs_create_bin_file(&vdev->dev->kobj, bi);
+}
diff -uprN linux-2.6.34/include/linux/vfio.h vfio-linux-2.6.34/include/linux/vfio.h
--- linux-2.6.34/include/linux/vfio.h	1969-12-31 16:00:00.000000000 -0800
+++ vfio-linux-2.6.34/include/linux/vfio.h	2010-05-28 14:29:49.000000000 -0700
@@ -0,0 +1,193 @@
+/*
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ * Portions derived from drivers/uio/uio.c:
+ * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
+ * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
+ * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
+ * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
+ *
+ * Portions derived from drivers/uio/uio_pci_generic.c:
+ * Copyright (C) 2009 Red Hat, Inc.
+ * Author: Michael S. Tsirkin <mst@redhat.com>
+ */
+
+/*
+ * VFIO driver - allow mapping and use of certain PCI devices
+ * in unprivileged user processes. (If IOMMU is present)
+ * Especially useful for Virtual Function parts of SR-IOV devices
+ */
+
+#ifdef __KERNEL__
+
+struct vfio_dev {
+	struct device	*dev;
+	struct pci_dev	*pdev;
+	u8		*pci_config_map;
+	int		pci_config_size;
+	char		name[8];
+	int		devnum;
+	int		pmaster;
+	void __iomem	*bar[PCI_ROM_RESOURCE+1];
+	spinlock_t	lock; /* guards command register accesses */
+	int		listeners;
+	int		mapcount;
+	u32		locked_pages;
+	struct mutex	gate;
+	struct msix_entry	*msix;
+	int			nvec;
+	struct iommu_domain	*domain;
+	int			cachec;
+	struct eventfd_ctx	*ev_irq;
+	struct eventfd_ctx	*ev_msi;
+	struct eventfd_ctx	**ev_msix;
+	struct {
+		u8	intr;
+		u8	bardirty;
+		u8	rombar[4];
+		u8	bar[6*4];
+		u8	msi[24];
+	} vinfo;
+};
+
+struct vfio_listener {
+	struct vfio_dev	*vdev;
+	struct list_head	dm_list;
+	struct mm_struct	*mm;
+	struct mmu_notifier	mmu_notifier;
+};
+
+/*
+ * Structure for keeping track of memory nailed down by the
+ * user for DMA
+ */
+struct dma_map_page {
+	struct list_head list;
+	struct page     **pages;
+	struct scatterlist *sg;
+	dma_addr_t      daddr;
+	unsigned long	vaddr;
+	int		npage;
+	int		rdwr;
+};
+
+/* VFIO class infrastructure */
+struct vfio_class {
+	struct kref kref;
+	struct class *class;
+};
+extern struct vfio_class *vfio_class;
+
+ssize_t vfio_io_readwrite(int, struct vfio_dev *,
+			char __user *, size_t, loff_t *);
+ssize_t vfio_mem_readwrite(int, struct vfio_dev *,
+			char __user *, size_t, loff_t *);
+ssize_t vfio_config_readwrite(int, struct vfio_dev *,
+			char __user *, size_t, loff_t *);
+
+void vfio_disable_msi(struct vfio_dev *);
+void vfio_disable_msix(struct vfio_dev *);
+int vfio_enable_msi(struct vfio_dev *, int);
+int vfio_enable_msix(struct vfio_dev *, int, void __user *);
+
+#ifndef PCI_MSIX_ENTRY_SIZE
+#define	PCI_MSIX_ENTRY_SIZE	16
+#endif
+#ifndef PCI_STATUS_INTERRUPT
+#define	PCI_STATUS_INTERRUPT	0x08
+#endif
+
+struct vfio_dma_map;
+void vfio_dma_unmapall(struct vfio_listener *);
+int vfio_dma_unmap_dm(struct vfio_listener *, struct vfio_dma_map *);
+int vfio_dma_map_common(struct vfio_listener *, unsigned int,
+			struct vfio_dma_map *);
+
+int vfio_class_init(void);
+void vfio_class_destroy(void);
+int vfio_dev_add_attributes(struct vfio_dev *);
+extern struct idr vfio_idr;
+extern struct mutex vfio_minor_lock;
+int vfio_build_config_map(struct vfio_dev *);
+
+irqreturn_t vfio_interrupt(int, void *);
+
+#endif	/* __KERNEL__ */
+
+/* Kernel & User level defines for ioctls */
+
+/*
+ * Structure for DMA mapping of user buffers
+ * vaddr, dmaaddr, and size must all be page aligned
+ * buffer may only be larger than 1 page if (a) there is
+ * an iommu in the system, or (b) buffer is part of a huge page
+ */
+struct vfio_dma_map {
+	__u64	vaddr;		/* process virtual addr */
+	__u64	dmaaddr;	/* desired and/or returned dma address */
+	__u64	size;		/* size in bytes */
+	int	rdwr;		/* bool: 0 for r/o; 1 for r/w */
+};
+
+/* map user pages at any dma address */
+#define	VFIO_DMA_MAP_ANYWHERE	_IOWR(';', 100, struct vfio_dma_map)
+
+/* map user pages at specific dma address */
+#define	VFIO_DMA_MAP_IOVA	_IOWR(';', 101, struct vfio_dma_map)
+
+/* unmap user pages */
+#define	VFIO_DMA_UNMAP		_IOW(';', 102, struct vfio_dma_map)
+
+/* set device DMA mask & master status */
+#define	VFIO_DMA_MASK		_IOW(';', 103, __u64)
+
+/* request IRQ interrupts; use given eventfd */
+#define	VFIO_EVENTFD_IRQ		_IOW(';', 104, int)
+
+/* request MSI interrupts; use given eventfd */
+#define	VFIO_EVENTFD_MSI		_IOW(';', 105, int)
+
+/* Request MSI-X interrupts: arg[0] is #, arg[1-n] are eventfds */
+#define	VFIO_EVENTFDS_MSIX	_IOW(';', 106, int)
+
+/* Get length of a BAR */
+#define	VFIO_BAR_LEN		_IOWR(';', 107, __u32)
+
+/*
+ * Reads, writes, and mmaps determine which PCI BAR (or config space)
+ * from the high level bits of the file offset
+ */
+#define	VFIO_PCI_BAR0_RESOURCE		0x0
+#define	VFIO_PCI_BAR1_RESOURCE		0x1
+#define	VFIO_PCI_BAR2_RESOURCE		0x2
+#define	VFIO_PCI_BAR3_RESOURCE		0x3
+#define	VFIO_PCI_BAR4_RESOURCE		0x4
+#define	VFIO_PCI_BAR5_RESOURCE		0x5
+#define	VFIO_PCI_ROM_RESOURCE		0x6
+#define	VFIO_PCI_CONFIG_RESOURCE	0xF
+#define	VFIO_PCI_SPACE_SHIFT	32
+#define VFIO_PCI_CONFIG_OFF vfio_pci_space_to_offset(VFIO_PCI_CONFIG_RESOURCE)
+
+static inline int vfio_offset_to_pci_space(__u64 off)
+{
+	return (off >> VFIO_PCI_SPACE_SHIFT) & 0xF;
+}
+
+static __u64 vfio_pci_space_to_offset(int sp)
+{
+	return (__u64)(sp) << VFIO_PCI_SPACE_SHIFT;
+}
diff -uprN linux-2.6.34/MAINTAINERS vfio-linux-2.6.34/MAINTAINERS
--- linux-2.6.34/MAINTAINERS	2010-05-16 14:17:36.000000000 -0700
+++ vfio-linux-2.6.34/MAINTAINERS	2010-05-28 12:30:21.000000000 -0700
@@ -5968,6 +5968,13 @@ S:	Maintained
 F:	Documentation/fb/uvesafb.txt
 F:	drivers/video/uvesafb.*
 
+VFIO DRIVER
+M:	Tom Lyon <pugs@cisco.com>
+S:	Supported
+F:	Documentation/vfio.txt
+F:	drivers/vfio/
+F:	include/linux/vfio.h
+
 VFAT/FAT/MSDOS FILESYSTEM
 M:	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
 S:	Maintained
