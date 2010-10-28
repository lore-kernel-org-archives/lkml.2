Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426Ab0J1Tnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 15:43:50 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:13861 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761107Ab0J1TnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 15:43:23 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.58,253,1286150400"; 
   d="scan'208";a="277381390"
Date: Thu, 28 Oct 2010 12:43:52 -0700
From: Tom Lyon <pugs@cisco.com>
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        randy.dunlap@oracle.com, arnd@arndb.de, joro@8bytes.org,
        hjk@linutronix.de, avi@redhat.com, gregkh@suse.de, chrisw@sous-sol.org,
        alex.williamson@redhat.com, mst@redhat.com
Subject: [PATCH 4/4] VFIO V5: Non-privileged user level PCI drivers
Message-ID: <4cc9d278.Aer/aLphT7U9yKPy%pugs@cisco.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tom Lyon <pugs@cisco.com>
---
 Documentation/ioctl/ioctl-number.txt |    1 +
 Documentation/vfio.txt               |  182 ++++++
 MAINTAINERS                          |    8 +
 drivers/Makefile                     |    1 +
 drivers/vfio/Kconfig                 |   10 +
 drivers/vfio/Makefile                |   10 +
 drivers/vfio/vfio_dma.c              |  400 ++++++++++++
 drivers/vfio/vfio_intrs.c            |  243 ++++++++
 drivers/vfio/vfio_main.c             |  782 ++++++++++++++++++++++++
 drivers/vfio/vfio_netlink.c          |  459 ++++++++++++++
 drivers/vfio/vfio_pci_config.c       | 1117 ++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_rdwr.c             |  205 +++++++
 drivers/vfio/vfio_sysfs.c            |  118 ++++
 include/linux/Kbuild                 |    1 +
 include/linux/vfio.h                 |  267 ++++++++
 15 files changed, 3804 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/vfio.txt
 create mode 100644 drivers/vfio/vfio_dma.c
 create mode 100644 drivers/vfio/vfio_intrs.c
 create mode 100644 drivers/vfio/vfio_main.c
 create mode 100644 drivers/vfio/vfio_netlink.c
 create mode 100644 drivers/vfio/vfio_pci_config.c
 create mode 100644 drivers/vfio/vfio_rdwr.c
 create mode 100644 drivers/vfio/vfio_sysfs.c
 create mode 100644 include/linux/vfio.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 33223ff..9462154 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -88,6 +88,7 @@ Code  Seq#(hex)	Include File		Comments
 		and kernel/power/user.c
 '8'	all				SNP8023 advanced NIC card
 					<mailto:mcr@solidum.com>
+';'	64-6F	linux/vfio.h
 '@'	00-0F	linux/radeonfb.h	conflict!
 '@'	00-0F	drivers/video/aty/aty128fb.c	conflict!
 'A'	00-1F	linux/apm_bios.h	conflict!
diff --git a/Documentation/vfio.txt b/Documentation/vfio.txt
new file mode 100644
index 0000000..f4feb72
--- /dev/null
+++ b/Documentation/vfio.txt
@@ -0,0 +1,182 @@
+-------------------------------------------------------------------------------
+The VFIO "driver" is used to allow privileged AND non-privileged processes to
+implement user-level device drivers for any well-behaved PCI, PCI-X, and PCIe
+devices.
+
+Why is this interesting?  Some applications, especially in the high performance
+computing field, need access to hardware functions with as little overhead as
+possible. Examples are in network adapters (typically non TCP/IP based) and
+in compute accelerators - i.e., array processors, FPGA processors, etc.
+Previous to the VFIO drivers these apps would need either a kernel-level
+driver (with corresponding overheads), or else root permissions to directly
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
+from devices go only to the appropriate memory locations; this allows VFIO to
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
+
+Only a very few platforms today (Intel X7500 is one) fully support both DMA
+remapping and interrupt remapping in the IOMMU.  Everyone has DMA remapping
+but interrupt remapping is missing in some Intel hardware and software, and
+it is missing in the AMD IOMMU software. Interrupt remapping is needed to
+protect a user level driver from triggering interrupts for other devices in
+the system.  Until interrupt remapping is in more platforms we allow the
+admin to load the module with allow_unsafe_intrs=1 which will make this driver useful (but not safe) on those platforms.
+
+When the vfio module is loaded, it will have access to no devices until the
+desired PCI devices are "bound" to the driver.  First, make sure the devices
+are not bound to another kernel driver. You can unload that driver if you wish
+to unbind all its devices, or else enter the driver's sysfs directory, and
+unbind a specific device:
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
+		wd = htole16(wd);
+		if (pwrite(pci_fd, &wd, 2, cfg_off) != 2)
+			perror("pwrite config_dword");
+	}
+
+The routines vfio_pci_space_to_offset and vfio_offset_to_pci_space are provided
+in vfio.h to convert BAR numbers to file offsets and vice-versa.
+
+Interrupts:
+
+Device interrupts are translated by the vfio driver into input events on event
+notification file descriptors created by the eventfd system call. The user
+program must create one or more event descriptors and pass them to the vfio
+driver via ioctls to arrange for the interrupt mapping:
+1.
+	efd = eventfd(0, 0);
+	ioctl(vfio_fd, VFIO_EVENTFD_IRQ, &efd);
+		This provides an eventfd for traditional IRQ interrupts.
+		IRQs will be disabled after each interrupt until the driver
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
+so a single DMA operation can safely span multiple user pages.
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
+The VFIO_DMA_MAP_IOVA is called with a vfio_dma_map structure with the
+dmaaddr field already assigned. The system will attempt to map the DMA
+buffer into the IO space at the given dmaaddr. This is expected to be
+useful if KVM or other virtualization facilities use this driver.
+Use of VFIO_DMA_MAP_IOVA requires an explicit assignment of the device
+to an IOMMU domain.  A file descriptor for an empty IOMMU domain is
+acquired by opening /dev/uiommu.  The device is then attached to the
+domain by issuing a VFIO_DOMAIN_SET ioctl with the domain fd address as
+the argument.  The device may be detached from the domain with the
+VFIO_DOMAIN_UNSET ioctl (no argument).  It is expected that hypervisors
+may wish to attach many devices to the same domain.
+
+The VFIO_DMA_UNMAP takes a fully filled vfio_dma_map structure and unmaps
+the buffer and releases the corresponding system resources.
+
+The VFIO_DMA_MASK ioctl is used to set the maximum permissible DMA address
+(device dependent). It takes a single unsigned 64 bit integer as an argument.
+This call also has the side effect of enabling PCI bus mastership.
+
+Miscellaneous:
+
+The VFIO_BAR_LEN ioctl provides an easy way to determine the size of a PCI
+device's base address region. It is passed a single integer specifying which
+BAR (0-5 or 6 for ROM bar), and passes back the length in the same field.
diff --git a/MAINTAINERS b/MAINTAINERS
index f2a2b8e..d62cb51 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6260,6 +6260,14 @@ S:	Maintained
 F:	Documentation/fb/uvesafb.txt
 F:	drivers/video/uvesafb.*
 
+VFIO DRIVER
+M:	Tom Lyon <pugs@cisco.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	Documentation/vfio.txt
+F:	drivers/vfio/
+F:	include/linux/vfio.h
+
 VFAT/FAT/MSDOS FILESYSTEM
 M:	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
 S:	Maintained
diff --git a/drivers/Makefile b/drivers/Makefile
index c445440..5759bd8 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -54,6 +54,7 @@ obj-y				+= firewire/
 obj-y				+= ieee1394/
 obj-$(CONFIG_UIO)		+= uio/
 obj-$(CONFIG_UIOMMU)		+= vfio/
+obj-$(CONFIG_VFIO)		+= vfio/
 obj-y				+= cdrom/
 obj-y				+= auxdisplay/
 obj-$(CONFIG_PCCARD)		+= pcmcia/
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 3ab9af3..2bbc1da 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -1,3 +1,13 @@
+menuconfig VFIO
+	tristate "Non-Privileged User Space PCI drivers"
+	depends on UIOMMU && PCI && IOMMU_API
+	help
+	  Driver to allow advanced user space drivers for PCI, PCI-X,
+	  and PCIe devices.  Requires IOMMU to allow non-privileged
+	  processes to directly control the PCI devices.
+
+	  If you don't know what to do here, say N.
+
 menuconfig UIOMMU
 	tristate "User level manipulation of IOMMU"
 	help
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 556f3c1..018c56b 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -1 +1,11 @@
+obj-$(CONFIG_VFIO) := vfio.o
 obj-$(CONFIG_UIOMMU) += uiommu.o
+
+vfio-y := vfio_main.o	\
+	vfio_dma.o		\
+	vfio_intrs.o		\
+	vfio_netlink.o		\
+	vfio_pci_config.o	\
+	vfio_rdwr.o		\
+	vfio_sysfs.o
+
diff --git a/drivers/vfio/vfio_dma.c b/drivers/vfio/vfio_dma.c
new file mode 100644
index 0000000..661cf3f
--- /dev/null
+++ b/drivers/vfio/vfio_dma.c
@@ -0,0 +1,400 @@
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
+ * This code handles mapping and unmapping of user data buffers
+ * into DMA'ble space using the IOMMU
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/mm.h>
+#include <linux/mmu_notifier.h>
+#include <linux/iommu.h>
+#include <linux/uiommu.h>
+#include <linux/sched.h>
+#include <linux/workqueue.h>
+#include <linux/vfio.h>
+
+struct vwork {
+	struct mm_struct *mm;
+	int		npage;
+	struct work_struct work;
+};
+
+/* delayed decrement for locked_vm */
+static void vfio_lock_acct_bg(struct work_struct *work)
+{
+	struct vwork *vwork = container_of(work, struct vwork, work);
+	struct mm_struct *mm;
+
+	mm = vwork->mm;
+	down_write(&mm->mmap_sem);
+	mm->locked_vm -= vwork->npage;
+	up_write(&mm->mmap_sem);
+	mmput(mm);		/* unref mm */
+	kfree(vwork);
+}
+
+static void vfio_lock_acct(int npage)
+{
+	struct vwork *vwork;
+	struct mm_struct *mm;
+
+	if (!current->mm) {
+		/* process exited */
+		return;
+	}
+	if (down_write_trylock(&current->mm->mmap_sem)) {
+		current->mm->locked_vm += npage;
+		up_write(&current->mm->mmap_sem);
+		return;
+	}
+	/*
+	 * Couldn't get mmap_sem lock, so must setup to decrement
+	 * mm->locked_vm later. If locked_vm were atomic, we wouldn't
+	 * need this silliness
+	 */
+	vwork = kmalloc(sizeof(struct vwork), GFP_KERNEL);
+	if (!vwork)
+		return;
+	mm = get_task_mm(current);	/* take ref mm */
+	if (!mm) {
+		kfree(vwork);
+		return;
+	}
+	INIT_WORK(&vwork->work, vfio_lock_acct_bg);
+	vwork->mm = mm;
+	vwork->npage = npage;
+	schedule_work(&vwork->work);
+}
+
+/* Unmap DMA region */
+/* dgate must be held */
+static void vfio_dma_unmap(struct vfio_listener *listener,
+			struct dma_map_page *mlp)
+{
+	int i;
+	struct vfio_dev *vdev = listener->vdev;
+	int npage;
+
+	list_del(&mlp->list);
+	for (i = 0; i < mlp->npage; i++)
+		(void) uiommu_unmap(vdev->udomain,
+				mlp->daddr + i * PAGE_SIZE, 0);
+	for (i = 0; i < mlp->npage; i++) {
+		if (mlp->rdwr)
+			SetPageDirty(mlp->pages[i]);
+		put_page(mlp->pages[i]);
+	}
+	vdev->mapcount--;
+	npage = mlp->npage;
+	vdev->locked_pages -= mlp->npage;
+	vfree(mlp->pages);
+	kfree(mlp);
+	vfio_lock_acct(-npage);
+}
+
+/* Unmap ALL DMA regions */
+void vfio_dma_unmapall(struct vfio_listener *listener)
+{
+	struct list_head *pos, *pos2;
+	struct dma_map_page *mlp;
+
+	mutex_lock(&listener->vdev->dgate);
+	list_for_each_safe(pos, pos2, &listener->dm_list) {
+		mlp = list_entry(pos, struct dma_map_page, list);
+		vfio_dma_unmap(listener, mlp);
+	}
+	mutex_unlock(&listener->vdev->dgate);
+}
+
+int vfio_dma_unmap_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
+{
+	int npage;
+	struct dma_map_page *mlp;
+	struct list_head *pos, *pos2;
+	int ret;
+
+	npage = dmp->size >> PAGE_SHIFT;
+
+	ret = -ENXIO;
+	mutex_lock(&listener->vdev->dgate);
+	list_for_each_safe(pos, pos2, &listener->dm_list) {
+		mlp = list_entry(pos, struct dma_map_page, list);
+		if (dmp->vaddr != mlp->vaddr || mlp->npage != npage)
+			continue;
+		ret = 0;
+		vfio_dma_unmap(listener, mlp);
+		break;
+	}
+	mutex_unlock(&listener->vdev->dgate);
+	return ret;
+}
+
+#ifdef CONFIG_MMU_NOTIFIER
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
+	mutex_lock(&listener->vdev->dgate);
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
+	mutex_unlock(&listener->vdev->dgate);
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
+#endif	/* CONFIG_MMU_NOTIFIER */
+
+/*
+ * Map usr buffer at specific IO virtual address
+ */
+static struct dma_map_page *vfio_dma_map_iova(
+		struct vfio_listener *listener,
+		unsigned long start_iova,
+		struct page **pages,
+		int npage,
+		int rdwr)
+{
+	struct vfio_dev *vdev = listener->vdev;
+	int ret;
+	int i;
+	phys_addr_t hpa;
+	struct dma_map_page *mlp;
+	unsigned long iova = start_iova;
+
+	if (!vdev->udomain)
+		return ERR_PTR(-EINVAL);
+
+	for (i = 0; i < npage; i++) {
+		if (uiommu_iova_to_phys(vdev->udomain, iova + i * PAGE_SIZE))
+			return ERR_PTR(-EBUSY);
+	}
+
+	mlp = kzalloc(sizeof *mlp, GFP_KERNEL);
+	if (!mlp)
+		return ERR_PTR(-ENOMEM);
+	rdwr = rdwr ? IOMMU_READ|IOMMU_WRITE : IOMMU_READ;
+	if (vdev->cachec)
+		rdwr |= IOMMU_CACHE;
+	for (i = 0; i < npage; i++) {
+		hpa = page_to_phys(pages[i]);
+		ret = uiommu_map(vdev->udomain, iova, hpa, 0, rdwr);
+		if (ret) {
+			while (--i > 0) {
+				iova -= PAGE_SIZE;
+				(void) uiommu_unmap(vdev->udomain,
+						iova, 0);
+			}
+			kfree(mlp);
+			return ERR_PTR(ret);
+		}
+		iova += PAGE_SIZE;
+	}
+	vdev->mapcount++;
+
+	mlp->pages = pages;
+	mlp->daddr = start_iova;
+	mlp->npage = npage;
+	return mlp;
+}
+
+int vfio_dma_map_common(struct vfio_listener *listener,
+		unsigned int cmd, struct vfio_dma_map *dmp)
+{
+	int locked, lock_limit;
+	struct page **pages;
+	int npage;
+	struct dma_map_page *mlp;
+	int rdwr = (dmp->flags & VFIO_FLAG_WRITE) ? 1 : 0;
+	int ret = 0;
+
+	if (dmp->vaddr & (PAGE_SIZE-1))
+		return -EINVAL;
+	if (dmp->dmaaddr & (PAGE_SIZE-1))
+		return -EINVAL;
+	if (dmp->size & (PAGE_SIZE-1))
+		return -EINVAL;
+	if (dmp->size >= VFIO_MAX_MAP_SIZE)
+		return -EINVAL;
+	npage = dmp->size >> PAGE_SHIFT;
+
+	mutex_lock(&listener->vdev->dgate);
+
+	/* account for locked pages */
+	locked = npage + current->mm->locked_vm;
+	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+		printk(KERN_WARNING "%s: RLIMIT_MEMLOCK exceeded\n",
+			__func__);
+		ret = -ENOMEM;
+		goto out_lock;
+	}
+	/* only 1 address space per fd */
+	if (current->mm != listener->mm) {
+		if (listener->mm) {
+			ret = -EINVAL;
+			goto out_lock;
+		}
+		listener->mm = current->mm;
+#ifdef CONFIG_MMU_NOTIFIER
+		listener->mmu_notifier.ops = &vfio_dma_mmu_notifier_ops;
+		ret = mmu_notifier_register(&listener->mmu_notifier,
+						listener->mm);
+		if (ret)
+			printk(KERN_ERR "%s: mmu_notifier_register failed %d\n",
+				__func__, ret);
+		ret = 0;
+#endif
+	}
+
+	pages = vmalloc(npage * sizeof(struct page *));
+	if (!pages) {
+		ret = -ENOMEM;
+		goto out_lock;
+	}
+	ret = get_user_pages_fast(dmp->vaddr, npage, rdwr, pages);
+	if (ret != npage) {
+		printk(KERN_ERR "%s: get_user_pages_fast returns %d, not %d\n",
+			__func__, ret, npage);
+		kfree(pages);
+		ret = -EFAULT;
+		goto out_lock;
+	}
+	ret = 0;
+
+	mlp = vfio_dma_map_iova(listener, dmp->dmaaddr,
+				pages, npage, rdwr);
+	if (IS_ERR(mlp)) {
+		ret = PTR_ERR(mlp);
+		vfree(pages);
+		goto out_lock;
+	}
+	mlp->vaddr = dmp->vaddr;
+	mlp->rdwr = rdwr;
+	dmp->dmaaddr = mlp->daddr;
+	list_add(&mlp->list, &listener->dm_list);
+
+	vfio_lock_acct(npage);
+	listener->vdev->locked_pages += npage;
+out_lock:
+	mutex_unlock(&listener->vdev->dgate);
+	return ret;
+}
+
+int vfio_domain_unset(struct vfio_dev *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+
+	if (!vdev->udomain)
+		return 0;
+	if (vdev->mapcount)
+		return -EBUSY;
+	uiommu_detach_device(vdev->udomain, &pdev->dev);
+	uiommu_put(vdev->udomain);
+	vdev->udomain = NULL;
+	return 0;
+}
+
+int vfio_domain_set(struct vfio_dev *vdev, int fd, int unsafe_ok)
+{
+	struct uiommu_domain *udomain;
+	struct pci_dev *pdev = vdev->pdev;
+	int ret;
+	int safe;
+
+	if (vdev->udomain)
+		return -EBUSY;
+	udomain = uiommu_fdget(fd);
+	if (IS_ERR(udomain))
+		return PTR_ERR(udomain);
+
+	safe = 0;
+#ifdef IOMMU_CAP_INTR_REMAP	/* >= 2.6.36 */
+	/* iommu domain must also isolate dev interrupts */
+	if (uiommu_domain_has_cap(udomain, IOMMU_CAP_INTR_REMAP))
+		safe = 1;
+#endif
+	if (!safe && !unsafe_ok) {
+		printk(KERN_WARNING "%s: no interrupt remapping!\n", __func__);
+		return -EINVAL;
+	}
+
+	vfio_domain_unset(vdev);
+	ret = uiommu_attach_device(udomain, &pdev->dev);
+	if (ret) {
+		printk(KERN_ERR "%s: attach_device failed %d\n",
+				__func__, ret);
+		uiommu_put(udomain);
+		return ret;
+	}
+	vdev->cachec = iommu_domain_has_cap(udomain->domain,
+				IOMMU_CAP_CACHE_COHERENCY);
+	vdev->udomain = udomain;
+	return 0;
+}
diff --git a/drivers/vfio/vfio_intrs.c b/drivers/vfio/vfio_intrs.c
new file mode 100644
index 0000000..aaee175
--- /dev/null
+++ b/drivers/vfio/vfio_intrs.c
@@ -0,0 +1,243 @@
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
+ * This code handles catching interrupts and translating
+ * them to events on eventfds
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
+	struct vfio_dev *vdev = dev_id;
+	struct pci_dev *pdev = vdev->pdev;
+	irqreturn_t ret = IRQ_NONE;
+	u32 cmd_status_dword;
+	u16 origcmd, newcmd, status;
+
+	spin_lock_irq(&vdev->irqlock);
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
+	spin_unlock_irq(&vdev->irqlock);
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
+void vfio_drop_msi(struct vfio_dev *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int i;
+
+	if (vdev->ev_msi) {
+		for (i = 0; i < vdev->msi_nvec; i++) {
+			free_irq(pdev->irq + i, vdev->ev_msi[i]);
+			if (vdev->ev_msi[i])
+				eventfd_ctx_put(vdev->ev_msi[i]);
+		}
+	}
+	kfree(vdev->ev_msi);
+	vdev->ev_msi = NULL;
+	vdev->msi_nvec = 0;
+	pci_disable_msi(pdev);
+}
+
+int vfio_setup_msi(struct vfio_dev *vdev, int nvec, int __user *intargp)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	struct eventfd_ctx *ctx;
+	int i;
+	int ret = 0;
+	int fd;
+
+	if (nvec < 1 || nvec > 32)
+		return -EINVAL;
+	vdev->ev_msi = kzalloc(nvec * sizeof(struct eventfd_ctx *),
+				GFP_KERNEL);
+	if (!vdev->ev_msi)
+		return -ENOMEM;
+
+	for (i = 0; i < nvec; i++) {
+		if (get_user(fd, intargp)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		intargp++;
+		ctx = eventfd_ctx_fdget(fd);
+		if (IS_ERR(ctx)) {
+			ret = PTR_ERR(ctx);
+			goto out;
+		}
+		vdev->ev_msi[i] = ctx;
+	}
+	ret = pci_enable_msi_block(pdev, nvec);
+	if (ret) {
+		if (ret > 0)
+			ret = -EINVAL;
+		goto out;
+	}
+	for (i = 0; i < nvec; i++) {
+		ret = request_irq(pdev->irq + i, msihandler, 0,
+			vdev->name, vdev->ev_msi[i]);
+		if (ret)
+			goto out;
+		vdev->msi_nvec = i+1;
+	}
+
+	/*
+	 * compute the virtual hardware field for max msi vectors -
+	 * it is the log base 2 of the number of vectors
+	 */
+	vdev->msi_qmax = fls(vdev->msi_nvec * 2 - 1) - 1;
+out:
+	if (ret)
+		vfio_drop_msi(vdev);
+	return ret;
+}
+
+void vfio_drop_msix(struct vfio_dev *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int i;
+
+	if (vdev->ev_msix && vdev->msix) {
+		for (i = 0; i < vdev->msix_nvec; i++) {
+			free_irq(vdev->msix[i].vector, vdev->ev_msix[i]);
+			if (vdev->ev_msix[i])
+				eventfd_ctx_put(vdev->ev_msix[i]);
+		}
+	}
+	kfree(vdev->ev_msix);
+	vdev->ev_msix = NULL;
+	kfree(vdev->msix);
+	vdev->msix = NULL;
+	vdev->msix_nvec = 0;
+	pci_disable_msix(pdev);
+}
+
+int vfio_setup_msix(struct vfio_dev *vdev, int nvec, int __user *intargp)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	struct eventfd_ctx *ctx;
+	int ret = 0;
+	int i;
+	int fd;
+	int pos;
+	u16 flags = 0;
+
+	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
+	if (!pos)
+		return -EINVAL;
+	pci_read_config_word(pdev, pos + PCI_MSIX_FLAGS, &flags);
+	if (nvec < 1 || nvec > (flags & PCI_MSIX_FLAGS_QSIZE) + 1)
+		return -EINVAL;
+
+	vdev->msix = kzalloc(nvec * sizeof(struct msix_entry),
+				GFP_KERNEL);
+	if (!vdev->msix)
+		return -ENOMEM;
+	vdev->ev_msix = kzalloc(nvec * sizeof(struct eventfd_ctx *),
+				GFP_KERNEL);
+	if (!vdev->ev_msix) {
+		kfree(vdev->msix);
+		return -ENOMEM;
+	}
+	for (i = 0; i < nvec; i++) {
+		if (get_user(fd, intargp)) {
+			ret = -EFAULT;
+			break;
+		}
+		intargp++;
+		ctx = eventfd_ctx_fdget(fd);
+		if (IS_ERR(ctx)) {
+			ret = PTR_ERR(ctx);
+			break;
+		}
+		vdev->msix[i].entry = i;
+		vdev->ev_msix[i] = ctx;
+	}
+	if (!ret)
+		ret = pci_enable_msix(pdev, vdev->msix, nvec);
+	vdev->msix_nvec = 0;
+	for (i = 0; i < nvec && !ret; i++) {
+		ret = request_irq(vdev->msix[i].vector, msihandler, 0,
+			vdev->name, vdev->ev_msix[i]);
+		if (ret)
+			break;
+		vdev->msix_nvec = i+1;
+	}
+	if (ret)
+		vfio_drop_msix(vdev);
+	return ret;
+}
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
new file mode 100644
index 0000000..3b7d352
--- /dev/null
+++ b/drivers/vfio/vfio_main.c
@@ -0,0 +1,782 @@
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
+ * VFIO main module: driver to allow non-privileged user programs
+ * to imlpement direct mapped device drivers for PCI* devices
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
+#include <linux/suspend.h>
+
+#include <linux/vfio.h>
+
+
+#define DRIVER_VERSION	"0.1"
+#define DRIVER_AUTHOR	"Tom Lyon <pugs@cisco.com>"
+#define DRIVER_DESC	"VFIO - User Level PCI meta-driver"
+
+/*
+ * Only a very few platforms today (Intel X7500) fully support
+ * both DMA remapping and interrupt remapping in the IOMMU.
+ * Everyone has DMA remapping but interrupt remapping is missing
+ * in some Intel hardware and software, and its missing in the AMD
+ * IOMMU software. Interrupt remapping is needed to really protect the
+ * system from user level driver mischief.  Until it is in more platforms
+ * we allow the admin to load the module with allow_unsafe_intrs=1
+ * which will make this driver useful (but not safe)
+ * on those platforms.
+ */
+static int allow_unsafe_intrs;
+module_param(allow_unsafe_intrs, int, 0);
+
+static int vfio_major = -1;
+static DEFINE_IDR(vfio_idr);
+static int vfio_max_minor;
+/* Protect idr accesses */
+static DEFINE_MUTEX(vfio_minor_lock);
+
+/*
+ * Does [a1,b1) overlap [a2,b2) ?
+ */
+static inline int overlap(int a1, int b1, int a2, int b2)
+{
+	/*
+	 * Ranges overlap if they're not disjoint; and they're
+	 * disjoint if the end of one is before the start of
+	 rq
+* the other one.
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
+		goto out;
+	}
+
+	mutex_lock(&vdev->lgate);
+	listener->vdev = vdev;
+	INIT_LIST_HEAD(&listener->dm_list);
+	if (vdev->listeners == 0) {
+		(void) pci_reset_function(vdev->pdev);
+		msleep(100);	/* 100ms for reset recovery */
+		ret = pci_enable_device(vdev->pdev);
+	}
+	if (!ret) {
+		filep->private_data = listener;
+		vdev->listeners++;
+	}
+	mutex_unlock(&vdev->lgate);
+	if (ret)
+		kfree(listener);
+out:
+	return ret;
+}
+
+/*
+ * Disable PCI device
+ * Can't call pci_reset_function here because it needs the
+ * device lock which may be held during _remove events
+ */
+static void vfio_disable_pci(struct vfio_dev *vdev)
+{
+	int bar;
+	struct pci_dev *pdev = vdev->pdev;
+
+	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
+		if (!vdev->barmap[bar])
+			continue;
+		pci_iounmap(pdev, vdev->barmap[bar]);
+		pci_release_selected_regions(pdev, 1 << bar);
+		vdev->barmap[bar] = NULL;
+	}
+	pci_disable_device(pdev);
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
+#ifdef CONFIG_MMU_NOTIFIER
+		mmu_notifier_unregister(&listener->mmu_notifier, listener->mm);
+#endif
+		listener->mm = NULL;
+	}
+
+	mutex_lock(&vdev->lgate);
+	if (--vdev->listeners <= 0) {
+		/* we don't need to hold igate here since there are
+		 * no more listeners doing ioctls
+		 */
+		if (vdev->ev_msix)
+			vfio_drop_msix(vdev);
+		if (vdev->ev_msi)
+			vfio_drop_msi(vdev);
+		if (vdev->ev_irq) {
+			free_irq(vdev->pdev->irq, vdev);
+			eventfd_ctx_put(vdev->ev_irq);
+			vdev->ev_irq = NULL;
+		}
+		kfree(vdev->vconfig);
+		vdev->vconfig = NULL;
+		kfree(vdev->pci_config_map);
+		vdev->pci_config_map = NULL;
+		vfio_disable_pci(vdev);
+		vfio_domain_unset(vdev);
+		wake_up(&vdev->dev_idle_q);
+	}
+	mutex_unlock(&vdev->lgate);
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
+	u8 pci_space;
+
+	pci_space = vfio_offset_to_pci_space(*ppos);
+
+	/* config reads are OK before iommu domain set */
+	if (pci_space == VFIO_PCI_CONFIG_RESOURCE)
+		return vfio_config_readwrite(0, vdev, buf, count, ppos);
+
+	/* no other reads until IOMMU domain set */
+	if (!vdev->udomain)
+		return -EINVAL;
+	if (pci_space > PCI_ROM_RESOURCE)
+		return -EINVAL;
+	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_IO)
+		return vfio_io_readwrite(0, vdev, buf, count, ppos);
+	else if (pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM)
+		return vfio_mem_readwrite(0, vdev, buf, count, ppos);
+	else if (pci_space == PCI_ROM_RESOURCE)
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
+	u8 pci_space;
+	int ret;
+
+	/* no writes until IOMMU domain set */
+	if (!vdev->udomain)
+		return -EINVAL;
+	pci_space = vfio_offset_to_pci_space(*ppos);
+	if (pci_space == VFIO_PCI_CONFIG_RESOURCE)
+		return vfio_config_readwrite(1, vdev,
+					(char __user *)buf, count, ppos);
+	if (pci_space > PCI_ROM_RESOURCE)
+		return -EINVAL;
+	if (pci_resource_flags(pdev, pci_space) & IORESOURCE_IO)
+		return vfio_io_readwrite(1, vdev,
+					(char __user *)buf, count, ppos);
+	else if (pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM) {
+		if (allow_unsafe_intrs) {
+			/* don't allow writes to msi-x vectors */
+			ret = vfio_msix_check(vdev, *ppos, count);
+			if (ret)
+				return ret;
+		}
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
+	/* no reads or writes until IOMMU domain set */
+	if (!vdev->udomain)
+		return -EINVAL;
+
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+	if ((vma->vm_flags & VM_SHARED) == 0)
+		return -EINVAL;
+
+
+	pci_space = vfio_offset_to_pci_space((u64)vma->vm_pgoff << PAGE_SHIFT);
+	/*
+	 * Can't mmap ROM - see vfio_mem_readwrite
+	 */
+	if (pci_space > PCI_STD_RESOURCE_END)
+		return -EINVAL;
+	if ((pci_resource_flags(pdev, pci_space) & IORESOURCE_MEM) == 0)
+		return -EINVAL;
+	actual = pci_resource_len(pdev, pci_space) >> PAGE_SHIFT;
+
+	requested = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+	if (requested > actual || actual == 0)
+		return -EINVAL;
+
+	start = vma->vm_pgoff << PAGE_SHIFT;
+	len = vma->vm_end - vma->vm_start;
+	if (allow_unsafe_intrs && (vma->vm_flags & VM_WRITE)) {
+		/*
+		 * Deter users from screwing up MSI-X intrs
+		 */
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
+	int __user *intargp = (void __user *)arg;
+	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_dma_map dm;
+	int ret = 0;
+	int fd, nfd;
+	int bar;
+
+	if (!vdev)
+		return -EINVAL;
+
+	switch (cmd) {
+
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
+	case VFIO_EVENTFD_IRQ:
+		if (get_user(fd, intargp))
+			return -EFAULT;
+		if (!pdev->irq)
+			return -EINVAL;
+		mutex_lock(&vdev->igate);
+		if (vdev->ev_irq) {
+			eventfd_ctx_put(vdev->ev_irq);
+			free_irq(pdev->irq, vdev);
+			vdev->ev_irq = NULL;
+		}
+		if (vdev->ev_msi) {	/* irq and msi both use pdev->irq */
+			ret = -EINVAL;
+		} else {
+			if (fd >= 0) {
+				vdev->ev_irq = eventfd_ctx_fdget(fd);
+				if (vdev->ev_irq)
+					ret = request_irq(pdev->irq,
+						vfio_interrupt,
+						IRQF_SHARED, vdev->name, vdev);
+				else
+					ret = -EINVAL;
+			}
+		}
+		mutex_unlock(&vdev->igate);
+		break;
+
+	case VFIO_EVENTFDS_MSI:
+		if (get_user(nfd, intargp))
+			return -EFAULT;
+		intargp++;
+		mutex_lock(&vdev->igate);
+		if (vdev->ev_irq) {	/* irq and msi both use pdev->irq */
+			ret = -EINVAL;
+		} else {
+			if (nfd > 0 && !vdev->ev_msi)
+				ret = vfio_setup_msi(vdev, nfd, intargp);
+			else if (nfd == 0 && vdev->ev_msi)
+				vfio_drop_msi(vdev);
+			else
+				ret = -EINVAL;
+		}
+		mutex_unlock(&vdev->igate);
+		break;
+
+	case VFIO_EVENTFDS_MSIX:
+		if (get_user(nfd, intargp))
+			return -EFAULT;
+		intargp++;
+		mutex_lock(&vdev->igate);
+		if (nfd > 0 && !vdev->ev_msix)
+			ret = vfio_setup_msix(vdev, nfd, intargp);
+		else if (nfd == 0 && vdev->ev_msix)
+			vfio_drop_msix(vdev);
+		else
+			ret = -EINVAL;
+		mutex_unlock(&vdev->igate);
+		break;
+
+	case VFIO_BAR_LEN:
+		if (get_user(bar, intargp))
+			return -EFAULT;
+		if (bar < 0 || bar > PCI_ROM_RESOURCE)
+			return -EINVAL;
+		if (pci_resource_start(pdev, bar))
+			bar = pci_resource_len(pdev, bar);
+		else
+			bar = 0;
+		if (put_user(bar, intargp))
+			return -EFAULT;
+		break;
+
+	case VFIO_DOMAIN_SET:
+		if (get_user(fd, intargp))
+			return -EFAULT;
+		ret = vfio_domain_set(vdev, fd, allow_unsafe_intrs);
+		break;
+
+	case VFIO_DOMAIN_UNSET:
+		ret = vfio_domain_unset(vdev);
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
+	if (id > vfio_max_minor)
+		vfio_max_minor = id;
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
+int vfio_validate(struct vfio_dev *vdev)
+{
+	int rc = 0;
+	int id;
+
+	mutex_lock(&vfio_minor_lock);
+	for (id = 0; id <= vfio_max_minor; id++)
+		if (vdev == idr_find(&vfio_idr, id))
+			goto out;
+	rc = 1;
+out:
+	mutex_unlock(&vfio_minor_lock);
+	return rc;
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
+	u8 pin;
+
+	pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
+	if (pin == 0)		/* irqs not needed */
+		return 0;
+
+	pci_read_config_word(pdev, PCI_COMMAND, &orig);
+	pci_write_config_word(pdev, PCI_COMMAND,
+			      orig ^ PCI_COMMAND_INTX_DISABLE);
+	pci_read_config_word(pdev, PCI_COMMAND, &new);
+	/* There's no way to protect against
+	 * hardware bugs or detect them reliably, but as long as we know
+	 * what the value should be, let's go ahead and check it. */
+	if ((new ^ orig) & ~PCI_COMMAND_INTX_DISABLE) {
+		dev_err(&pdev->dev, "Command changed from 0x%x to 0x%x: "
+			"driver or HW bug?\n", orig, new);
+		return -EBUSY;
+	}
+	if (!((new ^ orig) & PCI_COMMAND_INTX_DISABLE)) {
+		dev_warn(&pdev->dev, "Device does not support "
+			 "disabling interrupts: unable to bind.\n");
+		return -ENODEV;
+	}
+	/* Now restore the original value. */
+	pci_write_config_word(pdev, PCI_COMMAND, orig);
+	return 0;
+}
+
+static int vfio_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct vfio_dev *vdev;
+	int err;
+	u8 type;
+
+	if (!iommu_found())
+		return -EINVAL;
+
+	pci_read_config_byte(pdev, PCI_HEADER_TYPE, &type);
+	if ((type & 0x7F) != PCI_HEADER_TYPE_NORMAL)
+		return -EINVAL;
+
+	err = verify_pci_2_3(pdev);
+	if (err)
+		return err;
+
+	vdev = kzalloc(sizeof(struct vfio_dev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+	vdev->pdev = pdev;
+
+	mutex_init(&vdev->lgate);
+	mutex_init(&vdev->dgate);
+	mutex_init(&vdev->igate);
+	mutex_init(&vdev->ngate);
+	INIT_LIST_HEAD(&vdev->nlc_list);
+	init_waitqueue_head(&vdev->dev_idle_q);
+	init_waitqueue_head(&vdev->nl_wait_q);
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
+	return 0;
+
+err_vfio_dev_add_attributes:
+	device_destroy(vfio_class->class, vdev->devnum);
+err_device_create:
+	vfio_free_minor(vdev);
+err_get_devnum:
+	kfree(vdev);
+	return err;
+}
+
+static void vfio_remove(struct pci_dev *pdev)
+{
+	struct vfio_dev *vdev = pci_get_drvdata(pdev);
+	int ret;
+
+	/* prevent further opens */
+	vfio_free_minor(vdev);
+
+	/* notify users */
+	ret = vfio_nl_remove(vdev);
+
+	/* wait for all closed */
+	wait_event(vdev->dev_idle_q, vdev->listeners == 0);
+
+	pci_disable_device(pdev);
+
+	vfio_nl_freeclients(vdev);
+	device_destroy(vfio_class->class, vdev->devnum);
+	pci_set_drvdata(pdev, NULL);
+	kfree(vdev);
+}
+
+static struct pci_error_handlers vfio_error_handlers = {
+	.error_detected	= vfio_error_detected,
+	.mmio_enabled	= vfio_mmio_enabled,
+	.link_reset	= vfio_link_reset,
+	.slot_reset	= vfio_slot_reset,
+	.resume		= vfio_error_resume,
+};
+
+static struct pci_driver driver = {
+	.name		= "vfio",
+	.id_table	= NULL, /* only dynamic id's */
+	.probe		 = vfio_probe,
+	.remove		 = vfio_remove,
+	.err_handler	 = &vfio_error_handlers,
+};
+
+static atomic_t vfio_pm_suspend_count;
+static int vfio_pm_suspend_result;
+static DECLARE_WAIT_QUEUE_HEAD(vfio_pm_wait_q);
+
+/*
+ * Notify user level drivers of hibernation/suspend request
+ * Send all the notifies in parallel, collect all the replies
+ * If one ULD can't suspend, none can
+ */
+static int vfio_pm_suspend(void)
+{
+	struct vfio_dev *vdev;
+	int id, alive = 0;
+	int ret;
+
+	mutex_lock(&vfio_minor_lock);
+	atomic_set(&vfio_pm_suspend_count, 0);
+	vfio_pm_suspend_result = NOTIFY_DONE;
+	for (id = 0; id <= vfio_max_minor; id++) {
+		vdev = idr_find(&vfio_idr, id);
+		if (!vdev)
+			continue;
+		if (vdev->listeners == 0)
+			continue;
+		alive++;
+		ret = vfio_nl_upcall(vdev, VFIO_MSG_PM_SUSPEND, 0, 0);
+		if (ret == 0)
+			atomic_inc(&vfio_pm_suspend_count);
+	}
+	mutex_unlock(&vfio_minor_lock);
+	if (alive > atomic_read(&vfio_pm_suspend_count))
+		return NOTIFY_BAD;
+
+	/* sleep for reply */
+	if (wait_event_interruptible_timeout(vfio_pm_wait_q,
+	    (atomic_read(&vfio_pm_suspend_count) == 0),
+	    VFIO_SUSPEND_REPLY_TIMEOUT) <= 0) {
+		printk(KERN_ERR "vfio upcall suspend reply timeout\n");
+		return NOTIFY_BAD;
+	}
+	return vfio_pm_suspend_result;
+}
+
+static int vfio_pm_resume(void)
+{
+	struct vfio_dev *vdev;
+	int id;
+
+	mutex_lock(&vfio_minor_lock);
+	for (id = 0; id <= vfio_max_minor; id++) {
+		vdev = idr_find(&vfio_idr, id);
+		if (!vdev)
+			continue;
+		if (vdev->listeners == 0)
+			continue;
+		(void) vfio_nl_upcall(vdev, VFIO_MSG_PM_RESUME, 0, 0);
+	}
+	mutex_unlock(&vfio_minor_lock);
+	return NOTIFY_DONE;
+}
+
+
+void vfio_pm_process_reply(int reply)
+{
+	if (vfio_pm_suspend_result == NOTIFY_DONE) {
+		if (reply != NOTIFY_DONE)
+			vfio_pm_suspend_result = NOTIFY_BAD;
+	}
+	if (atomic_dec_and_test(&vfio_pm_suspend_count))
+		wake_up(&vfio_pm_wait_q);
+}
+
+static int vfio_pm_notify(struct notifier_block *this, unsigned long event,
+	void *notused)
+{
+	switch (event) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		return vfio_pm_suspend();
+		break;
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		return vfio_pm_resume();
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+struct notifier_block vfio_pm_nb = {
+	.notifier_call = vfio_pm_notify,
+};
+
+static int __init init(void)
+{
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
+	vfio_init_pci_perm_bits();
+	vfio_class_init();
+	vfio_nl_init();
+	register_pm_notifier(&vfio_pm_nb);
+	return pci_register_driver(&driver);
+}
+
+static void __exit cleanup(void)
+{
+	if (vfio_major >= 0)
+		unregister_chrdev(vfio_major, "vfio");
+	pci_unregister_driver(&driver);
+	unregister_pm_notifier(&vfio_pm_nb);
+	unregister_pm_notifier(&vfio_pm_nb);
+	vfio_nl_exit();
+	vfio_class_destroy();
+}
+
+module_init(init);
+module_exit(cleanup);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/vfio_netlink.c b/drivers/vfio/vfio_netlink.c
new file mode 100644
index 0000000..26d2864
--- /dev/null
+++ b/drivers/vfio/vfio_netlink.c
@@ -0,0 +1,459 @@
+/*
+ * Netlink inteface for VFIO
+ * Author: Tom Lyon (pugs@cisco.com)
+ *
+ * Copyright 2010, Cisco Systems, Inc.
+ * Copyright 2007, 2008 Siemens AG
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Derived from net/ieee802154/netlink.c Written by:
+ * Sergey Lapin <slapin@ossfans.org>
+ * Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
+ * Maxim Osipov <maxim.osipov@siemens.com>
+ */
+
+/*
+ * This code handles the signaling of various system events
+ * to the user level driver, using the generic netlink facilities.
+ * In many cases, we wait for replies from the user driver as well.
+ */
+
+#include <linux/kernel.h>
+#include <linux/gfp.h>
+#include <linux/pci.h>
+#include <linux/sched.h>
+#include <net/genetlink.h>
+#include <linux/mmu_notifier.h>
+#include <linux/vfio.h>
+
+static u32 vfio_seq_num;
+static DEFINE_SPINLOCK(vfio_seq_lock);
+
+struct genl_family vfio_nl_family = {
+	.id		= GENL_ID_GENERATE,
+	.hdrsize	= 0,
+	.name		= VFIO_GENL_NAME,
+	.version	= 1,
+	.maxattr	= VFIO_NL_ATTR_MAX,
+};
+
+/* Requests to userspace */
+struct sk_buff *vfio_nl_create(u8 req)
+{
+	void *hdr;
+	struct sk_buff *msg = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+	unsigned long f;
+
+	if (!msg)
+		return NULL;
+
+	spin_lock_irqsave(&vfio_seq_lock, f);
+	hdr = genlmsg_put(msg, 0, ++vfio_seq_num,
+			&vfio_nl_family, 0, req);
+	spin_unlock_irqrestore(&vfio_seq_lock, f);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return NULL;
+	}
+
+	return msg;
+}
+
+/*
+ * We would have liked to use NL multicast, but
+ * (a) multicast sockets are only for root
+ * (b) there's no multicast user level api in libnl
+ * (c) we need to know what net namespaces are involved
+ * Sigh.
+ */
+int vfio_nl_mcast(struct vfio_dev *vdev, struct sk_buff *msg, u8 type)
+{
+	struct list_head *pos;
+	struct vfio_nl_client *nlc;
+	struct sk_buff *skb;
+	/* XXX: nlh is right at the start of msg */
+	void *hdr = genlmsg_data(NLMSG_DATA(msg->data));
+	int good = 0;
+	int rc;
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return -ENOBUFS;
+	}
+
+	mutex_lock(&vdev->ngate);
+	list_for_each(pos, &vdev->nlc_list) {
+		nlc = list_entry(pos, struct vfio_nl_client, list);
+		if (nlc->msgcap & (1LL << type)) {
+			skb = skb_copy(msg, GFP_KERNEL);
+			if (!skb)  {
+				rc = -ENOBUFS;
+				goto out;
+			}
+			rc = genlmsg_unicast(nlc->net, skb, nlc->pid);
+			if (rc == 0)
+				good++;
+		}
+	}
+	rc = 0;
+out:
+	mutex_unlock(&vdev->ngate);
+	nlmsg_free(msg);
+	if (good)
+		return good;
+	return rc;
+}
+
+#ifdef notdef
+struct sk_buff *vfio_nl_new_reply(struct genl_info *info,
+		int flags, u8 req)
+{
+	void *hdr;
+	struct sk_buff *msg = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+
+	if (!msg)
+		return NULL;
+
+	hdr = genlmsg_put_reply(msg, info,
+			&vfio_nl_family, flags, req);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return NULL;
+	}
+
+	return msg;
+}
+
+int vfio_nl_reply(struct sk_buff *msg, struct genl_info *info)
+{
+	/* XXX: nlh is right at the start of msg */
+	void *hdr = genlmsg_data(NLMSG_DATA(msg->data));
+
+	if (genlmsg_end(msg, hdr) < 0)
+		goto out;
+
+	return genlmsg_reply(msg, info);
+out:
+	nlmsg_free(msg);
+	return -ENOBUFS;
+}
+#endif
+
+
+static const struct nla_policy vfio_nl_reg_policy[VFIO_NL_ATTR_MAX+1] = {
+	[VFIO_ATTR_MSGCAP]	= { .type = NLA_U64 },
+	[VFIO_ATTR_PCI_DOMAIN]	= { .type = NLA_U32 },
+	[VFIO_ATTR_PCI_BUS]	= { .type = NLA_U16 },
+	[VFIO_ATTR_PCI_SLOT]	= { .type = NLA_U8 },
+	[VFIO_ATTR_PCI_FUNC]	= { .type = NLA_U8 },
+};
+
+struct vfio_dev *vfio_nl_get_vdev(struct genl_info *info)
+{
+	u32 domain;
+	u16 bus;
+	u8 slot, func;
+	u16 devfn;
+	struct pci_dev *pdev;
+	struct vfio_dev *vdev;
+
+	domain = nla_get_u32(info->attrs[VFIO_ATTR_PCI_DOMAIN]);
+	bus = nla_get_u16(info->attrs[VFIO_ATTR_PCI_BUS]);
+	slot = nla_get_u8(info->attrs[VFIO_ATTR_PCI_SLOT]);
+	func = nla_get_u8(info->attrs[VFIO_ATTR_PCI_FUNC]);
+	devfn = PCI_DEVFN(slot, func);
+	pdev = pci_get_domain_bus_and_slot(domain, bus, devfn);
+	if (!pdev)
+		return NULL;
+	vdev = pci_get_drvdata(pdev);
+	if (!vdev)
+		return NULL;
+	if (vfio_validate(vdev))
+		return NULL;
+	if (vdev->pdev != pdev || strncmp(vdev->name, "vfio", 4))
+		return NULL;
+	return vdev;
+}
+
+/*
+ * The user driver must register here with a bitmask of which
+ * events it is interested in receiving
+ */
+static int vfio_nl_user_register(struct sk_buff *skb, struct genl_info *info)
+{
+	u64 msgcap;
+	struct list_head *pos;
+	struct vfio_nl_client *nlc;
+	int rc = 0;
+	struct vfio_dev *vdev;
+
+	msgcap = nla_get_u64(info->attrs[VFIO_ATTR_MSGCAP]);
+	if (msgcap == 0)
+		return -EINVAL;
+	vdev = vfio_nl_get_vdev(info);
+	if (!vdev)
+		return -EINVAL;
+
+	mutex_lock(&vdev->ngate);
+	list_for_each(pos, &vdev->nlc_list) {
+		nlc = list_entry(pos, struct vfio_nl_client, list);
+		if (nlc->pid == info->snd_pid &&
+		    nlc->net == info->_net)	/* already here */
+			goto update;
+	}
+	nlc = kzalloc(sizeof(struct vfio_nl_client), GFP_KERNEL);
+	if (!nlc) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	nlc->pid = info->snd_pid;
+	nlc->net = info->_net;
+	list_add(&nlc->list, &vdev->nlc_list);
+update:
+	nlc->msgcap = msgcap;
+out:
+	mutex_unlock(&vdev->ngate);
+	return rc;
+}
+
+static const struct nla_policy vfio_nl_err_policy[VFIO_NL_ATTR_MAX+1] = {
+	[VFIO_ATTR_ERROR_HANDLING_REPLY] = { .type = NLA_U32 },
+	[VFIO_ATTR_PCI_DOMAIN]	= { .type = NLA_U32 },
+	[VFIO_ATTR_PCI_BUS]	= { .type = NLA_U16 },
+	[VFIO_ATTR_PCI_SLOT]	= { .type = NLA_U8 },
+	[VFIO_ATTR_PCI_FUNC]	= { .type = NLA_U8 },
+};
+
+static int vfio_nl_error_handling_reply(struct sk_buff *skb,
+					struct genl_info *info)
+{
+	u32 value, seq;
+	struct vfio_dev *vdev;
+
+	value = nla_get_u32(info->attrs[VFIO_ATTR_ERROR_HANDLING_REPLY]);
+	vdev = vfio_nl_get_vdev(info);
+	if (!vdev)
+		return -EINVAL;
+	seq = nlmsg_hdr(skb)->nlmsg_seq;
+	if (seq > vdev->nl_reply_seq) {
+		vdev->nl_reply_value = value;
+		vdev->nl_reply_seq = seq;
+		wake_up(&vdev->nl_wait_q);
+	}
+	return 0;
+}
+
+static const struct nla_policy vfio_nl_pm_policy[VFIO_NL_ATTR_MAX+1] = {
+	[VFIO_ATTR_PM_SUSPEND_REPLY] = { .type = NLA_U32 },
+	[VFIO_ATTR_PCI_DOMAIN]	= { .type = NLA_U32 },
+	[VFIO_ATTR_PCI_BUS]	= { .type = NLA_U16 },
+	[VFIO_ATTR_PCI_SLOT]	= { .type = NLA_U8 },
+	[VFIO_ATTR_PCI_FUNC]	= { .type = NLA_U8 },
+};
+
+static int vfio_nl_pm_suspend_reply(struct sk_buff *skb, struct genl_info *info)
+{
+	u32 value;
+	struct vfio_dev *vdev;
+
+	value = nla_get_u32(info->attrs[VFIO_ATTR_PM_SUSPEND_REPLY]);
+	vdev = vfio_nl_get_vdev(info);
+	if (!vdev)
+		return -EINVAL;
+	if (vdev->listeners == 0)
+		return -EINVAL;
+	vfio_pm_process_reply(value);
+	return 0;
+}
+
+void vfio_nl_freeclients(struct vfio_dev *vdev)
+{
+	struct list_head *pos, *pos2;
+	struct vfio_nl_client *nlc;
+
+	mutex_lock(&vdev->ngate);
+	list_for_each_safe(pos, pos2, &vdev->nlc_list) {
+		nlc = list_entry(pos, struct vfio_nl_client, list);
+		list_del(&nlc->list);
+		kfree(nlc);
+	}
+	mutex_unlock(&vdev->ngate);
+}
+
+static struct genl_ops vfio_nl_reg_ops = {
+	.cmd	= VFIO_MSG_REGISTER,
+	.doit	= vfio_nl_user_register,
+	.policy	= vfio_nl_reg_policy,
+};
+
+static struct genl_ops vfio_nl_err_ops = {
+	.cmd	= VFIO_MSG_ERROR_HANDLING_REPLY,
+	.doit	= vfio_nl_error_handling_reply,
+	.policy	= vfio_nl_err_policy,
+};
+
+static struct genl_ops vfio_nl_pm_ops = {
+	.cmd	= VFIO_MSG_PM_SUSPEND_REPLY,
+	.doit	= vfio_nl_pm_suspend_reply,
+	.policy	= vfio_nl_pm_policy,
+};
+
+int vfio_nl_init(void)
+{
+	int rc;
+
+	rc = genl_register_family(&vfio_nl_family);
+	if (rc)
+		goto fail;
+
+	rc = genl_register_ops(&vfio_nl_family, &vfio_nl_reg_ops);
+	if (rc < 0)
+		goto fail;
+	rc = genl_register_ops(&vfio_nl_family, &vfio_nl_err_ops);
+	if (rc < 0)
+		goto fail;
+	rc = genl_register_ops(&vfio_nl_family, &vfio_nl_pm_ops);
+	if (rc < 0)
+		goto fail;
+	return 0;
+
+fail:
+	genl_unregister_family(&vfio_nl_family);
+	return rc;
+}
+
+void vfio_nl_exit(void)
+{
+	genl_unregister_family(&vfio_nl_family);
+}
+
+int vfio_nl_remove(struct vfio_dev *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	struct sk_buff *msg;
+	int rc;
+
+	msg = vfio_nl_create(VFIO_MSG_REMOVE);
+	if (!msg)
+		return -ENOBUFS;
+
+	NLA_PUT_U32(msg, VFIO_ATTR_PCI_DOMAIN, pci_domain_nr(pdev->bus));
+	NLA_PUT_U16(msg, VFIO_ATTR_PCI_BUS, pdev->bus->number);
+	NLA_PUT_U8(msg, VFIO_ATTR_PCI_SLOT, PCI_SLOT(pdev->devfn));
+	NLA_PUT_U8(msg, VFIO_ATTR_PCI_FUNC, PCI_FUNC(pdev->devfn));
+
+	rc = vfio_nl_mcast(vdev, msg, VFIO_MSG_REMOVE);
+	if (rc > 0)
+		rc = 0;
+	return rc;
+
+nla_put_failure:
+	nlmsg_free(msg);
+	return -ENOBUFS;
+}
+
+int vfio_nl_upcall(struct vfio_dev *vdev, u8 type, int state, int waitret)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	struct sk_buff *msg;
+	u32 seq;
+
+	msg = vfio_nl_create(type);
+	if (!msg)
+		goto null_out;
+	seq = nlmsg_hdr(msg)->nlmsg_seq;
+
+	NLA_PUT_U32(msg, VFIO_ATTR_PCI_DOMAIN, pci_domain_nr(pdev->bus));
+	NLA_PUT_U16(msg, VFIO_ATTR_PCI_BUS, pdev->bus->number);
+	NLA_PUT_U8(msg, VFIO_ATTR_PCI_SLOT, PCI_SLOT(pdev->devfn));
+	NLA_PUT_U8(msg, VFIO_ATTR_PCI_FUNC, PCI_FUNC(pdev->devfn));
+
+	if (type == VFIO_MSG_ERROR_DETECTED)
+		NLA_PUT_U32(msg, VFIO_ATTR_CHANNEL_STATE, state);
+
+	if (vfio_nl_mcast(vdev, msg, type) <= 0)
+		goto null_out;
+	if (!waitret)
+		return 0;
+
+	/* sleep for reply */
+	if (wait_event_interruptible_timeout(vdev->nl_wait_q,
+	    (vdev->nl_reply_seq >= seq), VFIO_ERROR_REPLY_TIMEOUT) <= 0) {
+		printk(KERN_ERR "vfio upcall timeout\n");
+		goto null_out;
+	}
+	if (seq != vdev->nl_reply_seq)
+		goto null_out;
+	return vdev->nl_reply_value;
+
+nla_put_failure:
+	nlmsg_free(msg);
+null_out:
+	return -1;
+}
+
+/* the following routines invoked for pci error handling */
+
+pci_ers_result_t vfio_error_detected(struct pci_dev *pdev,
+					pci_channel_state_t state)
+{
+	struct vfio_dev *vdev = pci_get_drvdata(pdev);
+	int ret;
+
+	ret = vfio_nl_upcall(vdev, VFIO_MSG_ERROR_DETECTED, (int)state, 1);
+	if (ret >= 0)
+		return ret;
+	return PCI_ERS_RESULT_NONE;
+}
+
+pci_ers_result_t vfio_mmio_enabled(struct pci_dev *pdev)
+{
+	struct vfio_dev *vdev = pci_get_drvdata(pdev);
+	int ret;
+
+	ret = vfio_nl_upcall(vdev, VFIO_MSG_MMIO_ENABLED, 0, 1);
+	if (ret >= 0)
+		return ret;
+	return PCI_ERS_RESULT_NONE;
+}
+
+pci_ers_result_t vfio_link_reset(struct pci_dev *pdev)
+{
+	struct vfio_dev *vdev = pci_get_drvdata(pdev);
+	int ret;
+
+	ret = vfio_nl_upcall(vdev, VFIO_MSG_LINK_RESET, 0, 1);
+	if (ret >= 0)
+		return ret;
+	return PCI_ERS_RESULT_NONE;
+}
+
+pci_ers_result_t vfio_slot_reset(struct pci_dev *pdev)
+{
+	struct vfio_dev *vdev = pci_get_drvdata(pdev);
+	int ret;
+
+	ret = vfio_nl_upcall(vdev, VFIO_MSG_SLOT_RESET, 0, 1);
+	if (ret >= 0)
+		return ret;
+	return PCI_ERS_RESULT_NONE;
+}
+
+void vfio_error_resume(struct pci_dev *pdev)
+{
+	struct vfio_dev *vdev = pci_get_drvdata(pdev);
+
+	(void) vfio_nl_upcall(vdev, VFIO_MSG_ERROR_RESUME, 0, 0);
+}
diff --git a/drivers/vfio/vfio_pci_config.c b/drivers/vfio/vfio_pci_config.c
new file mode 100644
index 0000000..88deb19
--- /dev/null
+++ b/drivers/vfio/vfio_pci_config.c
@@ -0,0 +1,1117 @@
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
+ * This code handles reading and writing of PCI configuration registers.
+ * This is hairy because we want to allow a lot of flexibility to the
+ * user driver, but cannot trust it with all of the config fields.
+ * Tables determine which fields can be read and written, as well as
+ * which fields are 'virtualized' - special actions and translations to
+ * make it appear to the user that he has control, when in fact things
+ * must be negotiated with the underlying OS.
+ */
+
+#include <linux/fs.h>
+#include <linux/pci.h>
+#include <linux/mmu_notifier.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+
+
+#define	PCI_CFG_SPACE_SIZE	256
+
+/* treat the standard header region as capability '0' */
+#define PCI_CAP_ID_BASIC	0
+
+/*
+ * Lengths of PCI Config Capabilities
+ * 0 means unknown (but at least 4)
+ * FF means special/variable
+ */
+static u8 pci_capability_length[] = {
+	[PCI_CAP_ID_BASIC]	= PCI_STD_HEADER_SIZEOF, /* pci config header */
+	[PCI_CAP_ID_PM]		= PCI_PM_SIZEOF,
+	[PCI_CAP_ID_AGP]	= PCI_AGP_SIZEOF,
+	[PCI_CAP_ID_VPD]	= PCI_CAP_VPD_SIZEOF,
+	[PCI_CAP_ID_SLOTID]	= 0,		/* bridge - don't care */
+	[PCI_CAP_ID_MSI]	= 0xFF,		/* 10, 14, 20, or 24 */
+	[PCI_CAP_ID_CHSWP]	= 0,		/* cpci - not yet */
+	[PCI_CAP_ID_PCIX]	= 0xFF,		/* 8 or 24 */
+	[PCI_CAP_ID_HT]		= 0xFF,		/* hypertransport */
+	[PCI_CAP_ID_VNDR]	= 0xFF,		/* variable */
+	[PCI_CAP_ID_DBG]	= 0,		/* debug - don't care */
+	[PCI_CAP_ID_CCRC]	= 0,		/* cpci - not yet */
+	[PCI_CAP_ID_SHPC]	= 0,		/* hotswap - not yet */
+	[PCI_CAP_ID_SSVID]	= 0,		/* bridge - don't care */
+	[PCI_CAP_ID_AGP3]	= 0,		/* AGP8x - not yet */
+	[PCI_CAP_ID_SECDEV]	= 0,		/* secure device not yet */
+	[PCI_CAP_ID_EXP]	= 0xFF,		/* 20 or 44 */
+	[PCI_CAP_ID_MSIX]	= PCI_CAP_MSIX_SIZEOF,
+	[PCI_CAP_ID_SATA]	= 0xFF,
+	[PCI_CAP_ID_AF]		= PCI_CAP_AF_SIZEOF,
+};
+
+/*
+ * Lengths of PCIe/PCI-X Extended Config Capabilities
+ * 0 means unknown (but at least 4)
+ * FF means special/variable
+ */
+static u16 pci_ext_capability_length[] = {
+	[PCI_EXT_CAP_ID_ERR]	=	PCI_ERR_ROOT_COMMAND,
+	[PCI_EXT_CAP_ID_VC]	=	0xFF,
+	[PCI_EXT_CAP_ID_DSN]	=	PCI_EXT_CAP_DSN_SIZEOF,
+	[PCI_EXT_CAP_ID_PWR]	=	PCI_EXT_CAP_PWR_SIZEOF,
+	[PCI_EXT_CAP_ID_RCLD]	=	0,	/* root only - don't care */
+	[PCI_EXT_CAP_ID_RCILC]	=	0,	/* root only - don't care */
+	[PCI_EXT_CAP_ID_RCEC]	=	0,	/* root only - don't care */
+	[PCI_EXT_CAP_ID_MFVC]	=	0xFF,
+	[PCI_EXT_CAP_ID_VC9]	=	0xFF,	/* same as CAP_ID_VC */
+	[PCI_EXT_CAP_ID_RCRB]	=	0,	/* root only - don't care */
+	[PCI_EXT_CAP_ID_VSEC]	=	0xFF,
+	[PCI_EXT_CAP_ID_CAC]	=	0,	/* obsolete */
+	[PCI_EXT_CAP_ID_ACS]	=	0xFF,
+	[PCI_EXT_CAP_ID_ARI]	=	PCI_EXT_CAP_ARI_SIZEOF,
+	[PCI_EXT_CAP_ID_ATS]	=	PCI_EXT_CAP_ATS_SIZEOF,
+	[PCI_EXT_CAP_ID_SRIOV]	=	PCI_EXT_CAP_SRIOV_SIZEOF,
+	[PCI_EXT_CAP_ID_MRIOV]	=	0,	/* not yet */
+	[PCI_EXT_CAP_ID_MCAST]	=	PCI_EXT_CAP_MCAST_ENDPOINT_SIZEOF,
+	[PCI_EXT_CAP_ID_PGRQ]	=	PCI_EXT_CAP_PGRQ_SIZEOF,
+	[PCI_EXT_CAP_ID_AMD_XXX] =	0,	/* not yet */
+	[PCI_EXT_CAP_ID_REBAR]	=	0xFF,
+	[PCI_EXT_CAP_ID_DPA]	=	0xFF,
+	[PCI_EXT_CAP_ID_TPH]	=	0xFF,
+	[PCI_EXT_CAP_ID_LTR]	=	PCI_EXT_CAP_LTR_SIZEOF,
+	[PCI_EXT_CAP_ID_SECPCI]	=	0,	/* not yet */
+};
+
+/*
+ * Read/Write Permission Bits - one bit for each bit in capability
+ * Any field can be read if it exists,
+ * but what is read depends on whether the field
+ * is 'virtualized', or just pass thru to the hardware.
+ * Any virtualized field is also virtualized for writes.
+ * Writes are only permitted if they have a 1 bit here.
+ * Any virtualized fields need corresponding code in
+ * vfio_config_rwbyte
+ */
+struct perm_bits {
+	u8	*virt;		/* bits which must be virtualized */
+	u8	*write;		/* writeable bits */
+};
+
+static struct perm_bits pci_cap_perms[PCI_CAP_ID_MAX+1];
+static struct perm_bits pci_ext_cap_perms[PCI_EXT_CAP_ID_MAX+1];
+
+#define	NO_VIRT		0
+#define	ALL_VIRT	0xFFFFFFFFU
+#define	NO_WRITE	0
+#define	ALL_WRITE	0xFFFFFFFFU
+
+static int alloc_perm_bits(struct perm_bits *perm, int sz)
+{
+	/*
+	 * Zero state is
+	 * - All Readable, None Writeable, None Virtualized
+	 */
+	perm->virt = kzalloc(sz, GFP_KERNEL);
+	perm->write = kzalloc(sz, GFP_KERNEL);
+	if (!perm->virt || !perm->write) {
+		kfree(perm->virt);
+		kfree(perm->write);
+		perm->virt = NULL;
+		perm->write = NULL;
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+/*
+ * Helper functions for filling in permission tables
+ */
+static inline void p_setb(struct perm_bits *p, int off, u32 virt, u32 write)
+{
+	p->virt[off] = (u8)virt;
+	p->write[off] = (u8)write;
+}
+
+/* handle endian-ness - pci and tables are little-endian */
+static inline void p_setw(struct perm_bits *p, int off, u32 virt, u32 write)
+{
+	*(u16 *)(&p->virt[off]) = cpu_to_le16((u16)virt);
+	*(u16 *)(&p->write[off]) = cpu_to_le16((u16)write);
+}
+
+/* handle endian-ness - pci and tables are little-endian */
+static inline void p_setd(struct perm_bits *p, int off, u32 virt, u32 write)
+{
+	*(u32 *)(&p->virt[off]) = cpu_to_le32(virt);
+	*(u32 *)(&p->write[off]) = cpu_to_le32(write);
+}
+
+/* permissions for the Basic PCI Header */
+static int __init init_pci_cap_basic_perm(struct perm_bits *perm)
+{
+	if (alloc_perm_bits(perm, PCI_STD_HEADER_SIZEOF))
+		return -ENOMEM;
+
+	/* virtualized for SR-IOV functions, which just have FFFF */
+	p_setw(perm, PCI_VENDOR_ID,		ALL_VIRT, NO_WRITE);
+	p_setw(perm, PCI_DEVICE_ID,		ALL_VIRT, NO_WRITE);
+
+	/* for catching resume-after-reset */
+	p_setw(perm, PCI_COMMAND,
+			PCI_COMMAND_MEMORY + PCI_COMMAND_IO,
+			ALL_WRITE);
+
+	/* no harm to write */
+	p_setb(perm, PCI_CACHE_LINE_SIZE,	NO_VIRT,  ALL_WRITE);
+	p_setb(perm, PCI_LATENCY_TIMER,		NO_VIRT,  ALL_WRITE);
+	p_setb(perm, PCI_BIST,			NO_VIRT,  ALL_WRITE);
+
+	/* virtualize all bars, can't touch the real ones */
+	p_setd(perm, PCI_BASE_ADDRESS_0,	ALL_VIRT, ALL_WRITE);
+	p_setd(perm, PCI_BASE_ADDRESS_1,	ALL_VIRT, ALL_WRITE);
+	p_setd(perm, PCI_BASE_ADDRESS_2,	ALL_VIRT, ALL_WRITE);
+	p_setd(perm, PCI_BASE_ADDRESS_3,	ALL_VIRT, ALL_WRITE);
+	p_setd(perm, PCI_BASE_ADDRESS_4,	ALL_VIRT, ALL_WRITE);
+	p_setd(perm, PCI_BASE_ADDRESS_5,	ALL_VIRT, ALL_WRITE);
+	p_setd(perm, PCI_ROM_ADDRESS,		ALL_VIRT, ALL_WRITE);
+
+	/* sometimes used by sw, just virtualize */
+	p_setb(perm, PCI_INTERRUPT_LINE,	ALL_VIRT, ALL_WRITE);
+	return 0;
+}
+
+/* Permissions for the Power Management capability */
+static int __init init_pci_cap_pm_perm(struct perm_bits *perm)
+{
+	if (alloc_perm_bits(perm, pci_capability_length[PCI_CAP_ID_PM]))
+		return -ENOMEM;
+	/*
+	 * power management is defined *per function*,
+	 * so we let the user write this
+	 */
+	p_setd(perm, PCI_PM_CTRL, NO_VIRT, ALL_WRITE);
+	return 0;
+}
+
+/* Permissions for Vital Product Data capability */
+static int __init init_pci_cap_vpd_perm(struct perm_bits *perm)
+{
+	if (alloc_perm_bits(perm, pci_capability_length[PCI_CAP_ID_VPD]))
+		return -ENOMEM;
+	p_setw(perm, PCI_VPD_ADDR, NO_VIRT, ALL_WRITE);
+	p_setd(perm, PCI_VPD_DATA, NO_VIRT, ALL_WRITE);
+	return 0;
+}
+
+/* Permissions for PCI-X capability */
+static int __init init_pci_cap_pcix_perm(struct perm_bits *perm)
+{
+	/* alloc 24, but only 8 are used in v0 */
+	if (alloc_perm_bits(perm, PCI_CAP_PCIX_SIZEOF_V12))
+		return -ENOMEM;
+	p_setw(perm, PCI_X_CMD, NO_VIRT, ALL_WRITE);
+	p_setd(perm, PCI_X_ECC_CSR, NO_VIRT, ALL_WRITE);
+	return 0;
+}
+
+/* Permissions for PCI Express capability */
+static int __init init_pci_cap_exp_perm(struct perm_bits *perm)
+{
+	/* alloc larger of two possible sizes */
+	if (alloc_perm_bits(perm, PCI_CAP_EXP_ENDPOINT_SIZEOF_V2))
+		return -ENOMEM;
+	/*
+	 * allow writes to device control fields (includes FLR!)
+	 * but not to devctl_phantom which could confuse IOMMU
+	 * or to the ARI bit in devctl2 which is set at probe time
+	 */
+	p_setw(perm, PCI_EXP_DEVCTL, NO_VIRT, ~PCI_EXP_DEVCTL_PHANTOM);
+	p_setw(perm, PCI_EXP_DEVCTL2, NO_VIRT, ~PCI_EXP_DEVCTL2_ARI);
+	return 0;
+}
+
+/* Permissions for MSI-X capability */
+static int __init init_pci_cap_msix_perm(struct perm_bits *perm)
+{
+	/* all default - only written via ioctl */
+	return 0;
+}
+
+/* Permissions for Advanced Function capability */
+static int __init init_pci_cap_af_perm(struct perm_bits *perm)
+{
+	if (alloc_perm_bits(perm, pci_capability_length[PCI_CAP_ID_AF]))
+		return -ENOMEM;
+	p_setb(perm, PCI_AF_CTRL, NO_VIRT, PCI_AF_CTRL_FLR);
+	return 0;
+}
+
+/* Permissions for Advanced Error Reporting extended capability */
+static int __init init_pci_ext_cap_err_perm(struct perm_bits *perm)
+{
+	u32 mask;
+
+	if (alloc_perm_bits(perm,
+	    pci_ext_capability_length[PCI_EXT_CAP_ID_ERR]))
+		return -ENOMEM;
+	mask =    PCI_ERR_UNC_TRAIN	/* Training */
+		| PCI_ERR_UNC_DLP	/* Data Link Protocol */
+		| PCI_ERR_UNC_SURPDN	/* Surprise Down */
+		| PCI_ERR_UNC_POISON_TLP	/* Poisoned TLP */
+		| PCI_ERR_UNC_FCP	/* Flow Control Protocol */
+		| PCI_ERR_UNC_COMP_TIME	/* Completion Timeout */
+		| PCI_ERR_UNC_COMP_ABORT	/* Completer Abort */
+		| PCI_ERR_UNC_UNX_COMP	/* Unexpected Completion */
+		| PCI_ERR_UNC_RX_OVER	/* Receiver Overflow */
+		| PCI_ERR_UNC_MALF_TLP	/* Malformed TLP */
+		| PCI_ERR_UNC_ECRC	/* ECRC Error Status */
+		| PCI_ERR_UNC_UNSUP	/* Unsupported Request */
+		| PCI_ERR_UNC_ACSV	/* ACS Violation */
+		| PCI_ERR_UNC_INTN	/* internal error */
+		| PCI_ERR_UNC_MCBTLP	/* MC blocked TLP */
+		| PCI_ERR_UNC_ATOMEG	/* Atomic egress blocked */
+		| PCI_ERR_UNC_TLPPRE;	/* TLP prefix blocked */
+	p_setd(perm, PCI_ERR_UNCOR_STATUS, NO_VIRT, mask);
+	p_setd(perm, PCI_ERR_UNCOR_MASK,   NO_VIRT, mask);
+	p_setd(perm, PCI_ERR_UNCOR_SEVER,  NO_VIRT, mask);
+
+	mask =    PCI_ERR_COR_RCVR	/* Receiver Error Status */
+		| PCI_ERR_COR_BAD_TLP	/* Bad TLP Status */
+		| PCI_ERR_COR_BAD_DLLP	/* Bad DLLP Status */
+		| PCI_ERR_COR_REP_ROLL	/* REPLAY_NUM Rollover */
+		| PCI_ERR_COR_REP_TIMER	/* Replay Timer Timeout */
+		| PCI_ERR_COR_ADV_NFAT	/* Advisory Non-Fatal */
+		| PCI_ERR_COR_INTERNAL	/* Corrected Internal */
+		| PCI_ERR_COR_LOG_OVER;	/* Header Log Overflow */
+	p_setd(perm, PCI_ERR_COR_STATUS, NO_VIRT, mask);
+	p_setd(perm, PCI_ERR_COR_MASK,   NO_VIRT, mask);
+
+	mask =    PCI_ERR_CAP_ECRC_GENC
+		| PCI_ERR_CAP_ECRC_GENE
+		| PCI_ERR_CAP_ECRC_CHKE;
+	p_setd(perm, PCI_ERR_CAP,	NO_VIRT, mask);
+	return 0;
+}
+
+/* Permissions for Power Budgeting extended capability */
+static int __init init_pci_ext_cap_pwr_perm(struct perm_bits *perm)
+{
+	if (alloc_perm_bits(perm,
+	    pci_ext_capability_length[PCI_EXT_CAP_ID_PWR]))
+		return -ENOMEM;
+	/* writing the data selector is OK, the info is still read-only */
+	p_setb(perm, PCI_PWR_DATA,	NO_VIRT, ALL_WRITE);
+	return 0;
+}
+
+/*
+ * Initialize the shared permission tables
+ */
+void __init vfio_init_pci_perm_bits(void)
+{
+	/* basic config space */
+	init_pci_cap_basic_perm(&pci_cap_perms[PCI_CAP_ID_BASIC]);
+	/* capabilities */
+	init_pci_cap_pm_perm(&pci_cap_perms[PCI_CAP_ID_PM]);
+	init_pci_cap_vpd_perm(&pci_cap_perms[PCI_CAP_ID_VPD]);
+	init_pci_cap_pcix_perm(&pci_cap_perms[PCI_CAP_ID_PCIX]);
+	init_pci_cap_exp_perm(&pci_cap_perms[PCI_CAP_ID_EXP]);
+	init_pci_cap_msix_perm(&pci_cap_perms[PCI_CAP_ID_MSIX]);
+	init_pci_cap_af_perm(&pci_cap_perms[PCI_CAP_ID_AF]);
+	/* extended capabilities */
+	init_pci_ext_cap_err_perm(&pci_ext_cap_perms[PCI_EXT_CAP_ID_ERR]);
+	init_pci_ext_cap_pwr_perm(&pci_ext_cap_perms[PCI_EXT_CAP_ID_PWR]);
+}
+
+/*
+ * MSI determination is per-device, so this routine
+ * gets used beyond initialization time
+ * Don't add __init
+ */
+static int init_pci_cap_msi_perm(struct perm_bits *perm, int len, u16 flags)
+{
+	if (alloc_perm_bits(perm, len))
+		return -ENOMEM;
+	/* next is byte only, not word, hi byte remains default */
+	p_setb(perm, PCI_MSI_FLAGS,		ALL_VIRT, ALL_WRITE);
+	p_setd(perm, PCI_MSI_ADDRESS_LO,	ALL_VIRT, ALL_WRITE);
+	if (flags & PCI_MSI_FLAGS_64BIT) {
+		p_setd(perm, PCI_MSI_ADDRESS_HI, ALL_VIRT, ALL_WRITE);
+		p_setw(perm, PCI_MSI_DATA_64,	 ALL_VIRT, ALL_WRITE);
+		if (flags & PCI_MSI_FLAGS_MASKBIT) {
+			p_setd(perm, PCI_MSI_MASK_64,	 NO_VIRT, ALL_WRITE);
+			p_setd(perm, PCI_MSI_PENDING_64, NO_VIRT, ALL_WRITE);
+		}
+	} else {
+		p_setw(perm, PCI_MSI_DATA_32,	 ALL_VIRT, ALL_WRITE);
+		if (flags & PCI_MSI_FLAGS_MASKBIT) {
+			p_setd(perm, PCI_MSI_MASK_32,	 NO_VIRT, ALL_WRITE);
+			p_setd(perm, PCI_MSI_PENDING_32, NO_VIRT, ALL_WRITE);
+		}
+	}
+	return 0;
+}
+
+/*
+ * Determine MSI CAP field length; also initialize permissions
+ */
+static int vfio_msi_cap_len(struct vfio_dev *vdev, u8 pos)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int len;
+	int ret;
+	u16 flags;
+
+	ret = pci_read_config_word(pdev, pos + PCI_MSI_FLAGS, &flags);
+	if (ret < 0)
+		return ret;
+	len = 10;
+	if (flags & PCI_MSI_FLAGS_64BIT)
+		len += 4;
+	if (flags & PCI_MSI_FLAGS_MASKBIT)
+		len += 10;
+
+	if (vdev->msi_perm)
+		return len;
+	vdev->msi_perm = kmalloc(sizeof(struct perm_bits), GFP_KERNEL);
+	if (vdev->msi_perm)
+		init_pci_cap_msi_perm(vdev->msi_perm, len, flags);
+	return len;
+}
+
+/*
+ * Determine extended capability length for VC (2 & 9) and
+ * MFVC capabilities
+ */
+static int vfio_vc_cap_len(struct vfio_dev *vdev, u8 pos)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	u32 dw;
+	int ret;
+	int evcc, ph, vc_arb;
+	int len = PCI_CAP_VC_BASE_SIZEOF;
+
+	ret = pci_read_config_dword(pdev, pos + PCI_VC_PORT_REG1, &dw);
+	if (ret < 0)
+		return 0;
+	evcc = dw & PCI_VC_REG1_EVCC;
+	ret = pci_read_config_dword(pdev, pos + PCI_VC_PORT_REG2, &dw);
+	if (ret < 0)
+		return 0;
+	if (dw & PCI_VC_REG2_128_PHASE)
+		ph = 128;
+	else if (dw & PCI_VC_REG2_64_PHASE)
+		ph = 64;
+	else if (dw & PCI_VC_REG2_32_PHASE)
+		ph = 32;
+	else
+		ph = 0;
+	vc_arb = ph * 4;
+	/*
+	 * port arbitration tables are root & switch only;
+	 * function arbitration tables are function 0 only.
+	 * In either case, we'll never let user write them so
+	 * we don't care how big they are
+	 */
+	len += (1 + evcc) * PCI_CAP_VC_PER_VC_SIZEOF;
+	if (vc_arb) {
+		len = round_up(len, 16);
+		len += vc_arb/8;
+	}
+	return len;
+}
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
+	u8 pos, cap, tmp, httype;
+	u16 epos, ecap;
+	u16 flags;
+	int ret;
+	int loops;
+	int extended_caps = 0;
+	u32 header, dw;
+
+	map = kmalloc(pdev->cfg_size, GFP_KERNEL);
+	if (!map)
+		return -ENOMEM;
+	for (i = 0; i < pdev->cfg_size; i++)
+		map[i] = 0xFF;
+	vdev->pci_config_map = map;
+
+	/* default config space */
+	for (i = 0; i < PCI_STD_HEADER_SIZEOF; i++)
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
+	loops = (PCI_CFG_SPACE_SIZE - PCI_STD_HEADER_SIZEOF) / PCI_CAP_SIZEOF;
+	while (pos && --loops > 0) {
+		ret = pci_read_config_byte(pdev, pos, &cap);
+		if (ret < 0)
+			return ret;
+		if (cap == 0) {
+			printk(KERN_WARNING "%s: cap 0\n", __func__);
+			break;
+		}
+		if (cap > PCI_CAP_ID_MAX) {
+			printk(KERN_WARNING
+				"%s: unknown pci capability id %x\n",
+				__func__, cap);
+			len = 0;
+		} else
+			len = pci_capability_length[cap];
+		if (len == 0) {
+			printk(KERN_WARNING
+				"%s: unknown length for pci cap %x\n",
+				__func__, cap);
+			len = PCI_CAP_SIZEOF;
+		}
+		if (len == 0xFF) {	/* variable field */
+			switch (cap) {
+			case PCI_CAP_ID_MSI:
+				len = vfio_msi_cap_len(vdev, pos);
+				if (len < 0)
+					return len;
+				break;
+			case PCI_CAP_ID_PCIX:
+				ret = pci_read_config_word(pdev,
+					pos + PCI_X_CMD, &flags);
+				if (ret < 0)
+					return ret;
+				if (PCI_X_CMD_VERSION(flags)) {
+					extended_caps++;
+					len = PCI_CAP_PCIX_SIZEOF_V12;
+				} else
+					len = PCI_CAP_PCIX_SIZEOF_V0;
+				break;
+			case PCI_CAP_ID_VNDR:
+				/* length follows next field */
+				ret = pci_read_config_byte(pdev, pos + 2, &tmp);
+				if (ret < 0)
+					return ret;
+				len = tmp;
+				break;
+			case PCI_CAP_ID_EXP:
+				/* length based on version */
+				ret = pci_read_config_word(pdev,
+					pos + PCI_EXP_FLAGS, &flags);
+				if (ret < 0)
+					return ret;
+				if ((flags & PCI_EXP_FLAGS_VERS) == 1)
+					len = PCI_CAP_EXP_ENDPOINT_SIZEOF_V1;
+				else
+					len = PCI_CAP_EXP_ENDPOINT_SIZEOF_V2;
+				extended_caps++;
+				break;
+			case PCI_CAP_ID_HT:
+				ret = pci_read_config_byte(pdev,
+					pos + 3, &httype);
+				if (ret < 0)
+					return ret;
+				len = (httype & HT_3BIT_CAP_MASK) ?
+					HT_CAP_SIZEOF_SHORT :
+					HT_CAP_SIZEOF_LONG;
+				break;
+			case PCI_CAP_ID_SATA:
+				ret = pci_read_config_byte(pdev,
+					pos + PCI_SATA_CR1, &tmp);
+				if (ret < 0)
+					return ret;
+				tmp &= PCI_SATA_IDP_MASK;
+				if (tmp == PCI_SATA_IDP_INLINE)
+					len = PCI_SATA_SIZEOF_LONG;
+				else
+					len = PCI_SATA_SIZEOF_SHORT;
+			default:
+				printk(KERN_WARNING
+					"%s: unknown length for pci cap %x\n",
+					__func__, cap);
+				len = PCI_CAP_SIZEOF;
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
+	if (!extended_caps)
+		return 0;
+	/*
+	 * We get here if there are PCIe or PCI-X extended capabilities
+	 */
+	epos = PCI_CFG_SPACE_SIZE;
+	loops = (4096 - PCI_CFG_SPACE_SIZE) / PCI_CAP_SIZEOF;
+	while (loops-- > 0) {
+		ret = pci_read_config_dword(pdev, epos, &header);
+		if (ret || header == 0)
+			break;
+		ecap = PCI_EXT_CAP_ID(header);
+		if (ecap > PCI_EXT_CAP_ID_MAX) {
+			printk(KERN_WARNING
+				"%s: unknown pci ext capability id %x\n",
+				__func__, ecap);
+			len = 0;
+		} else
+			len = pci_ext_capability_length[ecap];
+		if (len == 0xFF) {	/* variable field */
+			switch (ecap) {
+			case PCI_EXT_CAP_ID_VSEC:
+				ret = pci_read_config_dword(pdev,
+					epos + PCI_VSEC_HDR, &dw);
+				if (ret)
+					break;
+				len = dw >> PCI_VSEC_HDR_LEN_SHIFT;
+				break;
+			case PCI_EXT_CAP_ID_VC:
+			case PCI_EXT_CAP_ID_VC9:
+			case PCI_EXT_CAP_ID_MFVC:
+				len = vfio_vc_cap_len(vdev, epos);
+				break;
+			case PCI_EXT_CAP_ID_ACS:
+				ret = pci_read_config_byte(pdev,
+					epos + PCI_ACS_CAP, &tmp);
+				if (ret)
+					break;
+				len = 8;
+				if (tmp & PCI_ACS_EC) {
+					int bits;
+
+					ret = pci_read_config_byte(pdev,
+						epos + PCI_ACS_EGRESS_BITS,
+						 &tmp);
+					if (ret)
+						break;
+					bits = tmp ? tmp : 256;
+					bits = round_up(bits, 32);
+					len += bits/8;
+				}
+				break;
+			case PCI_EXT_CAP_ID_REBAR:
+				ret = pci_read_config_byte(pdev,
+					epos + PCI_REBAR_CTRL, &tmp);
+				if (ret)
+					break;
+				len = 4;
+				tmp = (tmp & PCI_REBAR_NBAR_MASK)
+					>> PCI_REBAR_NBAR_SHIFT;
+				len += tmp * 8;
+				break;
+			case PCI_EXT_CAP_ID_DPA:
+				ret = pci_read_config_byte(pdev,
+					epos + PCI_DPA_CAP, &tmp);
+				if (ret)
+					break;
+				tmp &= PCI_DPA_SUBSTATE_MASK;
+				tmp = round_up(tmp+1, 4);
+				len = PCI_DPA_BASE_SIZEOF + tmp;
+				break;
+			case PCI_EXT_CAP_ID_TPH:
+				ret = pci_read_config_dword(pdev,
+					epos + PCI_TPH_CAP, &dw);
+				if (ret)
+					break;
+				len = PCI_TPH_BASE_SIZEOF;
+				flags = dw & PCI_TPH_LOC_MASK;
+				if (flags == PCI_TPH_LOC_CAP) {
+					int sts;
+
+					sts = (dw & PCI_TPH_ST_MASK)
+						>> PCI_TPH_ST_SHIFT;
+					len += round_up(2 * sts, 4);
+				}
+				break;
+			default:
+				len = 0;
+				break;
+			}
+		}
+		if (len == 0 || len == 0xFF) {
+			printk(KERN_WARNING
+				"%s: unknown length for pci ext cap %x\n",
+				__func__, cap);
+			len = PCI_CAP_SIZEOF;
+		}
+		for (i = 0; i < len; i++) {
+			if (map[epos+i] != 0xFF)
+				printk(KERN_WARNING
+					"%s: pci config conflict at %x, "
+					"caps %x %x\n",
+					__func__, i, map[epos+i], ecap);
+			map[epos+i] = ecap;
+		}
+
+		epos = PCI_EXT_CAP_NEXT(header);
+		if (epos < PCI_CFG_SPACE_SIZE)
+			break;
+	}
+	return 0;
+}
+
+/*
+ * Initialize the virtual fields with the contents
+ * of the real hardware fields
+ */
+static int vfio_virt_init(struct vfio_dev *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	u32 *lp;
+	int i;
+
+	vdev->vconfig = kmalloc(pdev->cfg_size, GFP_KERNEL);
+	if (!vdev->vconfig)
+		return -ENOMEM;
+
+	lp = (u32 *)vdev->vconfig;
+	for (i = 0; i < pdev->cfg_size/sizeof(u32); i++, lp++)
+		pci_read_config_dword(pdev, i * sizeof(u32), lp);
+	vdev->bardirty = 1;
+
+	/* for restore after reset */
+	vdev->rbar[0] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
+	vdev->rbar[1] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_1];
+	vdev->rbar[2] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_2];
+	vdev->rbar[3] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_3];
+	vdev->rbar[4] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_4];
+	vdev->rbar[5] = *(u32 *)&vdev->vconfig[PCI_BASE_ADDRESS_5];
+	vdev->rbar[6] = *(u32 *)&vdev->vconfig[PCI_ROM_ADDRESS];
+
+	/* for sr-iov devices */
+	vdev->vconfig[PCI_VENDOR_ID] = pdev->vendor & 0xFF;
+	vdev->vconfig[PCI_VENDOR_ID+1] = pdev->vendor >> 8;
+	vdev->vconfig[PCI_DEVICE_ID] = pdev->device & 0xFF;
+	vdev->vconfig[PCI_DEVICE_ID+1] = pdev->device >> 8;
+
+	return 0;
+}
+
+/*
+ * Restore the *real* BARs after we detect a FLR or backdoor reset.
+ * (backdoor = some device specific technique that we didn't catch)
+ */
+static void vfio_bar_restore(struct vfio_dev *vdev)
+{
+	printk(KERN_WARNING "%s: reset recovery - restoring bars\n", __func__);
+
+#define do_bar(off, which) \
+	pci_user_write_config_dword(vdev->pdev, off, vdev->rbar[which])
+
+	do_bar(PCI_BASE_ADDRESS_0, 0);
+	do_bar(PCI_BASE_ADDRESS_1, 1);
+	do_bar(PCI_BASE_ADDRESS_2, 2);
+	do_bar(PCI_BASE_ADDRESS_3, 3);
+	do_bar(PCI_BASE_ADDRESS_4, 4);
+	do_bar(PCI_BASE_ADDRESS_5, 5);
+	do_bar(PCI_ROM_ADDRESS, 6);
+#undef do_bar
+}
+
+/*
+ * Pretend we're hardware and tweak the values
+ * of the *virtual* pci BARs to reflect the hardware
+ * capabilities
+ */
+static void vfio_bar_fixup(struct vfio_dev *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int bar;
+	u32 *lp;
+	u64 mask;
+
+	for (bar = 0; bar <= 5; bar++) {
+		if (pci_resource_start(pdev, bar))
+			mask = ~(pci_resource_len(pdev, bar) - 1);
+		else
+			mask = 0;
+		lp = (u32 *)(vdev->vconfig + PCI_BASE_ADDRESS_0 + 4*bar);
+		*lp &= (u32)mask;
+
+		if (pci_resource_flags(pdev, bar) & IORESOURCE_IO)
+			*lp |= PCI_BASE_ADDRESS_SPACE_IO;
+		else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
+			*lp |= PCI_BASE_ADDRESS_SPACE_MEMORY;
+			if (pci_resource_flags(pdev, bar) & IORESOURCE_PREFETCH)
+				*lp |= PCI_BASE_ADDRESS_MEM_PREFETCH;
+			if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM_64) {
+				*lp |= PCI_BASE_ADDRESS_MEM_TYPE_64;
+				lp++;
+				*lp &= (u32)(mask >> 32);
+				bar++;
+			}
+		}
+	}
+
+	if (pci_resource_start(pdev, PCI_ROM_RESOURCE)) {
+		mask = ~(pci_resource_len(pdev, PCI_ROM_RESOURCE) - 1);
+		mask = PCI_ROM_ADDRESS_ENABLE;
+	} else
+		mask = 0;
+	lp = (u32 *)(vdev->vconfig + PCI_ROM_ADDRESS);
+	*lp &= (u32)mask;
+
+	vdev->bardirty = 0;
+}
+
+static inline int vfio_read_config_byte(struct vfio_dev *vdev,
+					int pos, u8 *valp)
+{
+	return pci_user_read_config_byte(vdev->pdev, pos, valp);
+}
+
+static inline int vfio_write_config_byte(struct vfio_dev *vdev,
+					int pos, u8 val)
+{
+	vdev->vconfig[pos] = val;
+	return pci_user_write_config_byte(vdev->pdev, pos, val);
+}
+
+/* handle virtualized fields in the basic config space */
+static u8 vfio_virt_basic(struct vfio_dev *vdev, int write,
+				u16 pos, u16 off, u8 val, u8 newval)
+{
+	switch (off) {
+	/*
+	 * vendor and device are virt because they don't
+	 * show up otherwise for sr-iov vfs
+	 */
+	case PCI_VENDOR_ID:
+	case PCI_VENDOR_ID + 1:
+	case PCI_DEVICE_ID:
+	case PCI_DEVICE_ID + 1:
+		/* read only */
+		val = vdev->vconfig[pos];
+		break;
+	case PCI_COMMAND:
+		/*
+		 * If the real mem or IO enable bits are zero
+		 * then there may have been a FLR or backdoor reset.
+		 * Restore the real BARs before allowing those
+		 * bits to re-enable
+		 */
+		if (vdev->pdev->is_virtfn)
+			val |= PCI_COMMAND_MEMORY;
+		if (write) {
+			int upd = 0;
+
+			upd = (newval & PCI_COMMAND_MEMORY) >
+			      (val & PCI_COMMAND_MEMORY);
+			upd += (newval & PCI_COMMAND_IO) >
+			       (val & PCI_COMMAND_IO);
+			if (upd)
+				vfio_bar_restore(vdev);
+			vfio_write_config_byte(vdev, pos, newval);
+		}
+		break;
+	case PCI_BASE_ADDRESS_0:
+	case PCI_BASE_ADDRESS_0+1:
+	case PCI_BASE_ADDRESS_0+2:
+	case PCI_BASE_ADDRESS_0+3:
+	case PCI_BASE_ADDRESS_1:
+	case PCI_BASE_ADDRESS_1+1:
+	case PCI_BASE_ADDRESS_1+2:
+	case PCI_BASE_ADDRESS_1+3:
+	case PCI_BASE_ADDRESS_2:
+	case PCI_BASE_ADDRESS_2+1:
+	case PCI_BASE_ADDRESS_2+2:
+	case PCI_BASE_ADDRESS_2+3:
+	case PCI_BASE_ADDRESS_3:
+	case PCI_BASE_ADDRESS_3+1:
+	case PCI_BASE_ADDRESS_3+2:
+	case PCI_BASE_ADDRESS_3+3:
+	case PCI_BASE_ADDRESS_4:
+	case PCI_BASE_ADDRESS_4+1:
+	case PCI_BASE_ADDRESS_4+2:
+	case PCI_BASE_ADDRESS_4+3:
+	case PCI_BASE_ADDRESS_5:
+	case PCI_BASE_ADDRESS_5+1:
+	case PCI_BASE_ADDRESS_5+2:
+	case PCI_BASE_ADDRESS_5+3:
+	case PCI_ROM_ADDRESS:
+	case PCI_ROM_ADDRESS+1:
+	case PCI_ROM_ADDRESS+2:
+	case PCI_ROM_ADDRESS+3:
+		if (write) {
+			vdev->vconfig[pos] = newval;
+			vdev->bardirty = 1;
+		} else {
+			if (vdev->bardirty)
+				vfio_bar_fixup(vdev);
+			val = vdev->vconfig[pos];
+		}
+		break;
+	default:
+		if (write)
+			vdev->vconfig[pos] = newval;
+		else
+			val = vdev->vconfig[pos];
+		break;
+	}
+	return val;
+}
+
+/*
+ * handle virtualized fields in msi capability
+ * easy, except for multiple-msi fields in flags byte
+ */
+static u8 vfio_virt_msi(struct vfio_dev *vdev, int write,
+				u16 pos, u16 off, u8 val, u8 newval)
+{
+	if (off == PCI_MSI_FLAGS) {
+		u8 num;
+
+		if (write) {
+			if (!vdev->ev_msi)
+				newval &= ~PCI_MSI_FLAGS_ENABLE;
+			num = (newval & PCI_MSI_FLAGS_QSIZE) >> 4;
+			if (num > vdev->msi_qmax)
+				num = vdev->msi_qmax;
+			newval &= ~PCI_MSI_FLAGS_QSIZE;
+			newval |= num << 4;
+			vfio_write_config_byte(vdev, pos, newval);
+		} else {
+			if (vfio_read_config_byte(vdev, pos, &val) < 0)
+				return 0;
+			val &= ~PCI_MSI_FLAGS_QMASK;
+			val |= vdev->msi_qmax << 1;
+		}
+		return val;
+	}
+
+	if (write)
+		vdev->vconfig[pos] = newval;
+	else
+		val = vdev->vconfig[pos];
+	return val;
+}
+
+static int vfio_config_rwbyte(int write,
+				struct vfio_dev *vdev,
+				int pos,
+				char __user *buf)
+{
+	u8 *map = vdev->pci_config_map;
+	u8 cap, val, newval;
+	u16 start, off;
+	int p, bottom;
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
+			(void) vfio_read_config_byte(vdev, pos, &val);
+		if (copy_to_user(buf, &val, 1))
+			return -EFAULT;
+		return 0;
+	}
+
+	/* scan back to start of cap region */
+	bottom = (pos >= PCI_CFG_SPACE_SIZE) ? PCI_CFG_SPACE_SIZE : 0;
+	for (p = pos; p >= bottom; p--) {
+		if (map[p] != cap)
+			break;
+		start = p;
+	}
+	off = pos - start;	/* offset within capability */
+
+	/* lookup permissions for this capability */
+	if (pos >= PCI_CFG_SPACE_SIZE)
+		perm = &pci_ext_cap_perms[cap];
+	else if (cap != PCI_CAP_ID_MSI)
+		perm = &pci_cap_perms[cap];
+	else
+		perm = vdev->msi_perm;
+
+	if (perm) {
+		wr = perm->write ? perm->write[off] : 0;
+		virt = perm->virt ? perm->virt[off] : 0;
+	} else {
+		wr = 0;
+		virt = 0;
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
+				ret = vfio_read_config_byte(vdev, pos,
+							&existing);
+				if (ret < 0)
+					return ret;
+				val |= (existing & ~wr);
+			}
+			vfio_write_config_byte(vdev, pos, val);
+		} else {
+			ret = vfio_read_config_byte(vdev, pos, &val);
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
+		ret = vfio_read_config_byte(vdev, pos, &val);
+		if (ret < 0)
+			return ret;
+		if (write && rbits) {
+			val &= ~rbits;
+			val |= (newval & rbits);
+			vfio_write_config_byte(vdev, pos, val);
+		}
+	}
+	/*
+	 * Now handle entirely virtual fields
+	 */
+	if (pos < PCI_CFG_SPACE_SIZE) {
+		switch (cap) {
+		case PCI_CAP_ID_BASIC:	/* virtualize BARs */
+			val = vfio_virt_basic(vdev, write,
+						pos, off, val, newval);
+			break;
+		case PCI_CAP_ID_MSI:	/* virtualize (parts of) MSI */
+			val = vfio_virt_msi(vdev, write,
+						pos, off, val, newval);
+			break;
+		default:
+			if (write)
+				vdev->vconfig[pos] = newval;
+			else
+				val = vdev->vconfig[pos];
+			break;
+		}
+	} else {
+		/* no virt fields yet in ecaps */
+		switch (cap) {	/* extended capabilities */
+		default:
+			if (write)
+				vdev->vconfig[pos] = newval;
+			else
+				val = vdev->vconfig[pos];
+			break;
+		}
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
+	u16 pos;
+
+
+	if (!vdev->pci_config_map) {
+		ret = vfio_build_config_map(vdev);
+		if (ret)
+			goto out;
+	}
+	if (!vdev->vconfig) {
+		ret = vfio_virt_init(vdev);
+		if (ret)
+			goto out;
+	}
+
+	while (count > 0) {
+		pos = (u16)*ppos;
+		if (pos == pdev->cfg_size)
+			break;
+		if (pos > pdev->cfg_size) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		ret = vfio_config_rwbyte(write, vdev, pos, buf);
+
+		if (ret < 0)
+			goto out;
+		buf++;
+		done++;
+		count--;
+		(*ppos)++;
+	}
+	ret = done;
+out:
+	return ret;
+}
diff --git a/drivers/vfio/vfio_rdwr.c b/drivers/vfio/vfio_rdwr.c
new file mode 100644
index 0000000..b75bf92
--- /dev/null
+++ b/drivers/vfio/vfio_rdwr.c
@@ -0,0 +1,205 @@
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
+ * This code handles normal read and write system calls; allowing
+ * access to device memory or I/O registers
+ * without the need for mmap'ing.
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
+	u8 pci_space;
+	int unit;
+
+	pci_space = vfio_offset_to_pci_space(*ppos);
+	pos = vfio_offset_to_pci_offset(*ppos);
+
+	if (!pci_resource_start(pdev, pci_space))
+		return -EINVAL;
+	end = pci_resource_len(pdev, pci_space);
+	if (pos + count > end)
+		return -EINVAL;
+	if (!vdev->barmap[pci_space]) {
+		int ret;
+
+		ret = pci_request_selected_regions(pdev,
+			(1 << pci_space), "vfio");
+		if (ret)
+			return ret;
+		vdev->barmap[pci_space] = pci_iomap(pdev, pci_space, 0);
+	}
+	if (!vdev->barmap[pci_space])
+		return -EINVAL;
+	io = vdev->barmap[pci_space];
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
+/*
+ * Read and write memory BARs
+ * ROM is special because the ROM decoder can be shared with
+ * other BAR decoders. Practically, that means you can't use
+ * the ROM BAR if anything else is going on in the device.
+ * The pci_map_rom and pci_unmap_rom calls will leave the ROM
+ * BAR disabled upon return.
+ */
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
+	u8 pci_space;
+	int ret;
+
+	pci_space = vfio_offset_to_pci_space(*ppos);
+	pos = vfio_offset_to_pci_offset(*ppos);
+
+	if (!pci_resource_start(pdev, pci_space))
+		return -EINVAL;
+	 end = pci_resource_len(pdev, pci_space);
+
+	if (pci_space == PCI_ROM_RESOURCE) {
+		size_t size = end;
+
+		io = pci_map_rom(pdev, &size);
+	} else {
+		if (!vdev->barmap[pci_space]) {
+			int ret;
+
+			ret = pci_request_selected_regions(pdev,
+				(1 << pci_space), "vfio");
+			if (ret)
+				return ret;
+			vdev->barmap[pci_space] =
+				pci_iomap(pdev, pci_space, 0);
+		}
+		io = vdev->barmap[pci_space];
+	}
+	if (!io)
+		return -EINVAL;
+
+	if (pos > end) {
+		ret = -EINVAL;
+		goto out;
+	}
+	if (pos == end) {
+		ret = 0;
+		goto out;
+	}
+	if (pos + count > end)
+		count = end - pos;
+	if (write) {
+		if (copy_from_user(io + pos, buf, count)) {
+			ret = -EFAULT;
+			goto out;
+		}
+	} else {
+		if (copy_to_user(buf, io + pos, count)) {
+			ret = -EFAULT;
+			goto out;
+		}
+	}
+	*ppos += count;
+	ret = count;
+out:
+	if (pci_space == PCI_ROM_RESOURCE && io)
+		pci_unmap_rom(pdev, io);
+	return ret;
+}
diff --git a/drivers/vfio/vfio_sysfs.c b/drivers/vfio/vfio_sysfs.c
new file mode 100644
index 0000000..c6193fd
--- /dev/null
+++ b/drivers/vfio/vfio_sysfs.c
@@ -0,0 +1,118 @@
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
+ * This code handles vfio related files in sysfs
+ * (not much useful yet)
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
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
+	if (vfio_class) {
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
+static ssize_t show_locked_pages(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct vfio_dev *vdev = dev_get_drvdata(dev);
+
+	if (!vdev)
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
+int vfio_dev_add_attributes(struct vfio_dev *vdev)
+{
+	return sysfs_create_group(&vdev->dev->kobj, &vfio_attr_grp);
+}
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 4e8ea8c..2891588 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -368,6 +368,7 @@ header-y += usbdevice_fs.h
 header-y += utime.h
 header-y += utsname.h
 header-y += veth.h
+header-y += vfio.h
 header-y += vhost.h
 header-y += videodev.h
 header-y += videodev2.h
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
new file mode 100644
index 0000000..c491180
--- /dev/null
+++ b/include/linux/vfio.h
@@ -0,0 +1,267 @@
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
+#include <linux/types.h>
+
+/*
+ * VFIO driver - allow mapping and use of certain PCI devices
+ * in unprivileged user processes. (If IOMMU is present)
+ * Especially useful for Virtual Function parts of SR-IOV devices
+ */
+
+#ifdef __KERNEL__
+
+struct vfio_nl_client {
+	struct list_head	list;
+	u64			msgcap;
+	struct net		*net;
+	u32			pid;
+};
+
+struct perm_bits;
+struct vfio_dev {
+	struct device	*dev;
+	struct pci_dev	*pdev;
+	char		name[8];
+	u8		*pci_config_map;
+	int		pci_config_size;
+	int		devnum;
+	void __iomem	*barmap[PCI_STD_RESOURCE_END+1];
+	spinlock_t	irqlock;	/* guards command register accesses */
+	int		listeners;
+	u32		locked_pages;
+	struct mutex	lgate;		/* listener gate */
+	struct mutex	dgate;		/* dma op gate */
+	struct mutex	igate;		/* intr op gate */
+	struct mutex	ngate;		/* netlink op gate */
+	struct list_head nlc_list;	/* netlink clients */
+	wait_queue_head_t dev_idle_q;
+	wait_queue_head_t nl_wait_q;
+	u32		nl_reply_seq;
+	u32		nl_reply_value;
+	int		mapcount;
+	struct uiommu_domain	*udomain;
+	int			cachec;
+	struct msix_entry	*msix;
+	struct eventfd_ctx	*ev_irq;
+	struct eventfd_ctx	**ev_msi;
+	struct eventfd_ctx	**ev_msix;
+	int			msi_nvec;
+	int			msix_nvec;
+	u8		*vconfig;
+	u32		rbar[7];	/* copies of real bars */
+	u8		msi_qmax;
+	u8		bardirty;
+	struct perm_bits	*msi_perm;
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
+void vfio_drop_msi(struct vfio_dev *);
+void vfio_drop_msix(struct vfio_dev *);
+int vfio_setup_msi(struct vfio_dev *, int, int __user *);
+int vfio_setup_msix(struct vfio_dev *, int, int __user *);
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
+int vfio_domain_set(struct vfio_dev *, int, int);
+int vfio_domain_unset(struct vfio_dev *);
+
+int vfio_class_init(void);
+void vfio_class_destroy(void);
+int vfio_dev_add_attributes(struct vfio_dev *);
+int vfio_build_config_map(struct vfio_dev *);
+void vfio_init_pci_perm_bits(void);
+
+int vfio_nl_init(void);
+void vfio_nl_freeclients(struct vfio_dev *);
+void vfio_nl_exit(void);
+int vfio_nl_remove(struct vfio_dev *);
+int vfio_validate(struct vfio_dev *);
+int vfio_nl_upcall(struct vfio_dev *, u8, int, int);
+void vfio_pm_process_reply(int);
+pci_ers_result_t vfio_error_detected(struct pci_dev *, pci_channel_state_t);
+pci_ers_result_t vfio_mmio_enabled(struct pci_dev *);
+pci_ers_result_t vfio_link_reset(struct pci_dev *);
+pci_ers_result_t vfio_slot_reset(struct pci_dev *);
+void vfio_error_resume(struct pci_dev *);
+#define VFIO_ERROR_REPLY_TIMEOUT	(3*HZ)
+#define VFIO_SUSPEND_REPLY_TIMEOUT	(5*HZ)
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
+ */
+struct vfio_dma_map {
+	__u64	vaddr;		/* process virtual addr */
+	__u64	dmaaddr;	/* desired and/or returned dma address */
+	__u64	size;		/* size in bytes */
+#define	VFIO_MAX_MAP_SIZE	(1LL<<30) /* 1G, must be < (PAGE_SIZE<<32) */
+	__u64	flags;		/* bool: 0 for r/o; 1 for r/w */
+#define	VFIO_FLAG_WRITE		0x1	/* req writeable DMA mem */
+};
+
+/* map user pages at specific dma address */
+/* requires previous VFIO_DOMAIN_SET */
+#define	VFIO_DMA_MAP_IOVA	_IOWR(';', 101, struct vfio_dma_map)
+
+/* unmap user pages */
+#define	VFIO_DMA_UNMAP		_IOW(';', 102, struct vfio_dma_map)
+
+/* request IRQ interrupts; use given eventfd */
+#define	VFIO_EVENTFD_IRQ	_IOW(';', 103, int)
+
+/* Request MSI interrupts: arg[0] is #, arg[1-n] are eventfds */
+#define	VFIO_EVENTFDS_MSI	_IOW(';', 104, int)
+
+/* Request MSI-X interrupts: arg[0] is #, arg[1-n] are eventfds */
+#define	VFIO_EVENTFDS_MSIX	_IOW(';', 105, int)
+
+/* Get length of a BAR */
+#define	VFIO_BAR_LEN		_IOWR(';', 167, __u32)
+
+/* Set the IOMMU domain - arg is fd from uiommu driver */
+#define	VFIO_DOMAIN_SET		_IOW(';', 107, int)
+
+/* Unset the IOMMU domain */
+#define	VFIO_DOMAIN_UNSET	_IO(';', 108)
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
+static inline __u32 vfio_offset_to_pci_offset(__u64 off)
+{
+	return off & (__u32)0xFFFFFFFF;
+}
+
+static inline __u64 vfio_pci_space_to_offset(int sp)
+{
+	return (__u64)(sp) << VFIO_PCI_SPACE_SHIFT;
+}
+
+/*
+ * Netlink defines:
+ */
+#define VFIO_GENL_NAME	"VFIO"
+
+/* message types */
+enum {
+	VFIO_MSG_INVAL = 0,
+	/* kernel to user */
+	VFIO_MSG_REMOVE,		/* unbind, module or hotplug remove */
+	VFIO_MSG_ERROR_DETECTED,	/* pci err handling - error detected */
+	VFIO_MSG_MMIO_ENABLED,		/* pci err handling - mmio enabled */
+	VFIO_MSG_LINK_RESET,		/* pci err handling - link reset */
+	VFIO_MSG_SLOT_RESET,		/* pci err handling - slot reset */
+	VFIO_MSG_ERROR_RESUME,		/* pci err handling - resume normal */
+	VFIO_MSG_PM_SUSPEND,		/* suspend or hibernate notification */
+	VFIO_MSG_PM_RESUME,		/* resume after suspend or hibernate */
+	/* user to kernel */
+	VFIO_MSG_REGISTER,
+	VFIO_MSG_ERROR_HANDLING_REPLY,	/* err handling reply */
+	VFIO_MSG_PM_SUSPEND_REPLY,	/* suspend notify reply */
+};
+
+/* attributes */
+enum {
+	VFIO_ATTR_UNSPEC,
+	VFIO_ATTR_MSGCAP,	/* bitmask of messages desired */
+	VFIO_ATTR_PCI_DOMAIN,
+	VFIO_ATTR_PCI_BUS,
+	VFIO_ATTR_PCI_SLOT,
+	VFIO_ATTR_PCI_FUNC,
+	VFIO_ATTR_CHANNEL_STATE,
+	VFIO_ATTR_ERROR_HANDLING_REPLY,
+	VFIO_ATTR_PM_SUSPEND_REPLY,
+	__VFIO_NL_ATTR_MAX
+};
+#define VFIO_NL_ATTR_MAX (__VFIO_NL_ATTR_MAX - 1)
-- 
1.6.0.2

