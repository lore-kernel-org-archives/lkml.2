Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab0E3M7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 08:59:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354Ab0E3M7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 08:59:50 -0400
Message-ID: <4C026139.3060008@redhat.com>
Date: Sun, 30 May 2010 15:59:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tom Lyon <pugs@cisco.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, mst@redhat.com, gregkh@suse.de,
       aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
References: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com>
In-Reply-To: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2010 02:07 AM, Tom Lyon wrote:
> The VFIO "driver" is used to allow privileged AND non-privileged processes to
> implement user-level device drivers for any well-behaved PCI, PCI-X, and PCIe
> devices.
>    

> +
> +Why is this interesting?  Some applications, especially in the high performance
> +computing field, need access to hardware functions with as little overhead as
> +possible. Examples are in network adapters (typically non tcp/ip based) and
> +in compute accelerators - i.e., array processors, FPGA processors, etc.
> +Previous to the VFIO drivers these apps would need either a kernel-level
> +driver (with corrsponding overheads), or else root permissions to directly
> +access the hardware. The VFIO driver allows generic access to the hardware
> +from non-privileged apps IF the hardware is "well-behaved" enough for this
> +to be safe.
>    


> +
> +Any SR-IOV virtual function meets the VFIO definition of "well-behaved", but
> +there are many other non-IOV PCI devices which also meet the defintion.
> +Elements of this definition are:
> +- The size of any memory BARs to be mmap'ed into the user process space must be
> +  a multiple of the system page size.
>    

You can relax this.
  - smaller than page size can be mapped if the rest of the page unused 
and if the platform tolerates writes to unused areas
  - if the rest of the page is used, we can relocate the BAR
  - otherwise, we can prevent mmap() but still allow mediated access via 
a syscall

> +- If MSI-X interrupts are used, the device driver must not attempt to mmap or
> +  write the MSI-X vector area.
>    

We can allow mediated access (that's what qemu-kvm does).  I guess the 
ioctls for setting up msi interrupts are equivalent to this mediated access.

(later I see you do provide mediated access via pwrite - please confirm)

> +- The device must not use the PCI configuration space in any non-standard way,
> +  i.e., the user level driver will be permitted only to read and write standard
> +  fields of the PCI config space, and only if those fields cannot cause harm to
> +  the system. In addition, some fields are "virtualized", so that the user
> +  driver can read/write them like a kernel driver, but they do not affect the
> +  real device.
>    

What's wrong with nonstandard fields?

> +
> +Even with these restrictions, there are bound to be devices which are unsafe
> +for user level use - it is still up to the system admin to decide whether to
> +grant access to the device.  When the vfio module is loaded, it will have
> +access to no devices until the desired PCI devices are "bound" to the driver.
> +First, make sure the devices are not bound to another kernel driver. You can
> +unload that driver if you wish to unbind all its devices, or else enter the
> +driver's sysfs directory, and unbind a specific device:
> +	cd /sys/bus/pci/drivers/<drivername>
> +	echo 0000:06:02.00>  unbind
> +(The 0000:06:02.00 is a fully qualified PCI device name - different for each
> +device).  Now, to bind to the vfio driver, go to /sys/bus/pci/drivers/vfio and
> +write the PCI device type of the target device to the new_id file:
> +	echo 8086 10ca>  new_id
> +(8086 10ca are the vendor and device type for the Intel 82576 virtual function
> +devices). A /dev/vfio<N>  entry will be created for each device bound. The final
> +step is to grant users permission by changing the mode and/or owner of the /dev
> +entry - "chmod 666 /dev/vfio0".
>    

What if I have several such devices?  Isn't it better to bind by topoloy 
(device address)?

> +
> +Reads&  Writes:
> +
> +The user driver will typically use mmap to access the memory BAR(s) of a
> +device; the I/O BARs and the PCI config space may be accessed through normal
> +read and write system calls. Only 1 file descriptor is needed for all driver
> +functions -- the desired BAR for I/O, memory, or config space is indicated via
> +high-order bits of the file offset.

My preference would be one fd per BAR, but that's a matter of personal 
taste.

> For instance, the following implements a
> +write to the PCI config space:
> +
> +	#include<linux/vfio.h>
> +	void pci_write_config_word(int pci_fd, u16 off, u16 wd)
> +	{
> +		off_t cfg_off = VFIO_PCI_CONFIG_OFF + off;
> +
> +		if (pwrite(pci_fd,&wd, 2, cfg_off) != 2)
> +			perror("pwrite config_dword");
> +	}
> +
>    

Nice, has the benefit of avoiding endianness issues in the interface.

> +The routines vfio_pci_space_to_offset and vfio_offset_to_pci_space are provided
> +in vfio.h to convert bar numbers to file offsets and vice-versa.
> +
> +Interrupts:
> +
> +Device interrupts are translated by the vfio driver into input events on event
> +notification file descriptors created by the eventfd system call. The user
> +program must one or more event descriptors and pass them to the vfio driver
> +via ioctls to arrange for the interrupt mapping:
> +1.
> +	efd = eventfd(0, 0);
> +	ioctl(vfio_fd, VFIO_EVENTFD_IRQ,&efd);
> +		This provides an eventfd for traditional IRQ interrupts.
> +		IRQs will be disable after each interrupt until the driver
> +		re-enables them via the PCI COMMAND register.
>    

My thinking was to emulate a level-triggered interrupt but I think your 
way is better.  For virtualization, it becomes the responsibility of 
user space to multiplex between the guest writing PCI COMMAND and 
userspace writing PCI COMMAND to re-enable interrupts, but that's fine.

> +2.
> +	efd = eventfd(0, 0);
> +	ioctl(vfio_fd, VFIO_EVENTFD_MSI,&efd);
> +		This connects MSI interrupts to an eventfd.
> +3.
> + 	int arg[N+1];
> +	arg[0] = N;
> +	arg[1..N] = eventfd(0, 0);
> +	ioctl(vfio_fd, VFIO_EVENTFDS_MSIX, arg);
> +		This connects N MSI-X interrupts with N eventfds.
> +
> +Waiting and checking for interrupts is done by the user program by reads,
> +polls, or selects on the related event file descriptors.
>    

This all looks nice and clean.

> +
> +DMA:
> +
> +The VFIO driver uses ioctls to allow the user level driver to get DMA
> +addresses which correspond to virtual addresses.  In systems with IOMMUs,
> +each PCI device will have its own address space for DMA operations, so when
> +the user level driver programs the device registers, only addresses known to
> +the IOMMU will be valid, any others will be rejected.  The IOMMU creates the
> +illusion (to the device) that multi-page buffers are physically contiguous,
> +so a single DMA operation can safely span multiple user pages.  Note that
> +the VFIO driver is still useful in systems without IOMMUs, but only for
> +trusted processes which can deal with DMAs which do not span pages (Huge
> +pages count as a single page also).
> +
> +If the user process desires many DMA buffers, it may be wise to do a mapping
> +of a single large buffer, and then allocate the smaller buffers from the
> +large one.
>    

Or use scatter/gather, if the device supports it.

> +
> +The DMA buffers are locked into physical memory for the duration of their
> +existence - until VFIO_DMA_UNMAP is called, until the user pages are
> +unmapped from the user process, or until the vfio file descriptor is closed.
> +The user process must have permission to lock the pages given by the ulimit(-l)
> +command, which in turn relies on settings in the /etc/security/limits.conf
> +file.
> +
> +The vfio_dma_map structure is used as an argument to the ioctls which
> +do the DMA mapping. Its vaddr, dmaaddr, and size fields must always be a
> +multiple of a page. Its rdwr field is zero for read-only (outbound), and
> +non-zero for read/write buffers.
> +
> +	struct vfio_dma_map {
> +		__u64	vaddr;	  /* process virtual addr */
> +		__u64	dmaaddr;  /* desired and/or returned dma address */
> +		__u64	size;	  /* size in bytes */
> +		int	rdwr;	  /* bool: 0 for r/o; 1 for r/w */
> +	};
> +
> +The VFIO_DMA_MAP_ANYWHERE is called with a vfio_dma_map structure as its
> +argument, and returns the structure with a valid dmaaddr field.
> +
> +The VFIO_DMA_MAP_IOVA is called with a vfio_dma_map structure with the
> +dmaaddr field already assigned. The system will attempt to map the DMA
> +buffer into the IO space at the givne dmaaddr. This is expected to be
> +useful if KVM or other virtualization facilities use this driver.
> +
> +The VFIO_DMA_UNMAP takes a fully filled vfio_dma_map structure and unmaps
> +the buffer and releases the corresponding system resources.
> +
> +The VFIO_DMA_MASK ioctl is used to set the maximum permissible DMA address
> +(device dependent). It takes a single unsigned 64 bit integer as an argument.
> +This call also has the side effect on enabled PCI bus mastership.
>    


How many such mappings can be mapped simultaneously?

Note you need privileges (RLIMIT_MEMLOCK) to lock memory, this should be 
accounted for.

> +	/* account for locked pages */
> +	locked = npage + current->mm->locked_vm;
> +	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur
> +			>>  PAGE_SHIFT;
>    

Ah, you already do.

> +/* Kernel&  User level defines for ioctls */
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
> +	int	rdwr;		/* bool: 0 for r/o; 1 for r/w */
> +};
>    

As noted before, align, add flags, and reserve space.
> +
> +/* Get length of a BAR */
> +#define	VFIO_BAR_LEN		_IOWR(';', 107, __u32)
>    

A 64-bit BAR will overflow on a 32-bit system.

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
>    

64-bit BARs break this.  51 would be a good value for x86 systems (the 
PTE format makes bits 52:62 available to software, so the address space 
cannot grow beyond 2PB).

> +#define VFIO_PCI_CONFIG_OFF vfio_pci_space_to_offset(VFIO_PCI_CONFIG_RESOURCE)
> +
> +static inline int vfio_offset_to_pci_space(__u64 off)
> +{
> +	return (off>>  VFIO_PCI_SPACE_SHIFT)&  0xF;
> +}
> +
> +static __u64 vfio_pci_space_to_offset(int sp)
> +{
> +	return (__u64)(sp)<<  VFIO_PCI_SPACE_SHIFT;
> +}
>    


Needs to be inline too.

Suggest the last function also take the offset, and add a function to 
extract the offset from a space/offset combo.


-- 
error compiling committee.c: too many arguments to function

