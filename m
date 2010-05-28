Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab0E1X4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 19:56:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51639 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0E1X4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 19:56:50 -0400
Date: Fri, 28 May 2010 16:56:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Tom Lyon" <pugs@cisco.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, mst@redhat.com, avi@redhat.com,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-Id: <20100528165600.68cd2618.randy.dunlap@oracle.com>
In-Reply-To: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com>
References: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C005823.017E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 16:07:38 -0700 Tom Lyon wrote:

> diff -uprN linux-2.6.34/Documentation/vfio.txt vfio-linux-2.6.34/Documentation/vfio.txt
> --- linux-2.6.34/Documentation/vfio.txt	1969-12-31 16:00:00.000000000 -0800
> +++ vfio-linux-2.6.34/Documentation/vfio.txt	2010-05-28 14:03:05.000000000 -0700
> @@ -0,0 +1,176 @@
> +-------------------------------------------------------------------------------
> +The VFIO "driver" is used to allow privileged AND non-privileged processes to
> +implement user-level device drivers for any well-behaved PCI, PCI-X, and PCIe
> +devices.
> +
> +Why is this interesting?  Some applications, especially in the high performance
> +computing field, need access to hardware functions with as little overhead as
> +possible. Examples are in network adapters (typically non tcp/ip based) and

                                                         non-TCP/IP-based)

> +in compute accelerators - i.e., array processors, FPGA processors, etc.
> +Previous to the VFIO drivers these apps would need either a kernel-level
> +driver (with corrsponding overheads), or else root permissions to directly

                corresponding

> +access the hardware. The VFIO driver allows generic access to the hardware
> +from non-privileged apps IF the hardware is "well-behaved" enough for this
> +to be safe.
> +
> +While there have long been ways to implement user-level drivers using specific
> +corresponding drivers in the kernel, it was not until the introduction of the
> +UIO driver framework, and the uio_pci_generic driver that one could have a
> +generic kernel component supporting many types of user level drivers. However,
> +even with the uio_pci_generic driver, processes implementing the user level
> +drivers had to be trusted - they could do dangerous manipulation of DMA
> +addreses and were required to be root to write PCI configuration space
> +registers.
> +
> +Recent hardware technologies - I/O MMUs and PCI I/O Virtualization - provide
> +new hardware capabilities which the VFIO solution exploits to allow non-root
> +user level drivers. The main role of the IOMMU is to ensure that DMA accesses
> +from devices go only to the appropriate memory locations, this allows VFIO to

                                                  locations;

> +ensure that user level drivers do not corrupt inappropriate memory.  PCI I/O
> +virtualization (SR-IOV) was defined to allow "pass-through" of virtual devices
> +to guest virtual machines. VFIO in essence implements pass-through of devices
> +to user processes, not virtual machines.  SR-IOV devices implement a
> +traditional PCI device (the physical function) and a dynamic number of special
> +PCI devices (virtual functions) whose feature set is somewhat restricted - in
> +order to allow the operating system or virtual machine monitor to ensure the
> +safe operation of the system.
> +
> +Any SR-IOV virtual function meets the VFIO definition of "well-behaved", but
> +there are many other non-IOV PCI devices which also meet the defintion.
> +Elements of this definition are:
> +- The size of any memory BARs to be mmap'ed into the user process space must be
> +  a multiple of the system page size.
> +- If MSI-X interrupts are used, the device driver must not attempt to mmap or
> +  write the MSI-X vector area.
> +- If the device is a PCI device (not PCI-X or PCIe), it must conform to PCI
> +  revision 2.3 to allow its interrupts to be masked in a generic way.
> +- The device must not use the PCI configuration space in any non-standard way,
> +  i.e., the user level driver will be permitted only to read and write standard
> +  fields of the PCI config space, and only if those fields cannot cause harm to
> +  the system. In addition, some fields are "virtualized", so that the user
> +  driver can read/write them like a kernel driver, but they do not affect the
> +  real device.
> +- For now, there is no support for user access to the PCIe and PCI-X extended
> +  capabilities configuration space.
> +
> +Even with these restrictions, there are bound to be devices which are unsafe
> +for user level use - it is still up to the system admin to decide whether to
> +grant access to the device.  When the vfio module is loaded, it will have
> +access to no devices until the desired PCI devices are "bound" to the driver.
> +First, make sure the devices are not bound to another kernel driver. You can
> +unload that driver if you wish to unbind all its devices, or else enter the
> +driver's sysfs directory, and unbind a specific device:
> +	cd /sys/bus/pci/drivers/<drivername>
> +	echo 0000:06:02.00 > unbind
> +(The 0000:06:02.00 is a fully qualified PCI device name - different for each
> +device).  Now, to bind to the vfio driver, go to /sys/bus/pci/drivers/vfio and
> +write the PCI device type of the target device to the new_id file:
> +	echo 8086 10ca > new_id
> +(8086 10ca are the vendor and device type for the Intel 82576 virtual function
> +devices). A /dev/vfio<N> entry will be created for each device bound. The final
> +step is to grant users permission by changing the mode and/or owner of the /dev
> +entry - "chmod 666 /dev/vfio0".
> +
> +Reads & Writes:
> +
> +The user driver will typically use mmap to access the memory BAR(s) of a
> +device; the I/O BARs and the PCI config space may be accessed through normal
> +read and write system calls. Only 1 file descriptor is needed for all driver
> +functions -- the desired BAR for I/O, memory, or config space is indicated via
> +high-order bits of the file offset.  For instance, the following implements a
> +write to the PCI config space:
> +
> +	#include <linux/vfio.h>
> +	void pci_write_config_word(int pci_fd, u16 off, u16 wd)
> +	{
> +		off_t cfg_off = VFIO_PCI_CONFIG_OFF + off;
> +
> +		if (pwrite(pci_fd, &wd, 2, cfg_off) != 2)
> +			perror("pwrite config_dword");
> +	}
> +
> +The routines vfio_pci_space_to_offset and vfio_offset_to_pci_space are provided
> +in vfio.h to convert bar numbers to file offsets and vice-versa.

                        BAR

> +
> +Interrupts:
> +
> +Device interrupts are translated by the vfio driver into input events on event
> +notification file descriptors created by the eventfd system call. The user
> +program must one or more event descriptors and pass them to the vfio driver

           must ___ ?  missing word?

> +via ioctls to arrange for the interrupt mapping:
> +1.
> +	efd = eventfd(0, 0);
> +	ioctl(vfio_fd, VFIO_EVENTFD_IRQ, &efd);
> +		This provides an eventfd for traditional IRQ interrupts.
> +		IRQs will be disable after each interrupt until the driver

		             disabled

> +		re-enables them via the PCI COMMAND register.
> +2.
> +	efd = eventfd(0, 0);
> +	ioctl(vfio_fd, VFIO_EVENTFD_MSI, &efd);
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

                                   given

> +useful if KVM or other virtualization facilities use this driver.
> +
> +The VFIO_DMA_UNMAP takes a fully filled vfio_dma_map structure and unmaps
> +the buffer and releases the corresponding system resources.
> +
> +The VFIO_DMA_MASK ioctl is used to set the maximum permissible DMA address
> +(device dependent). It takes a single unsigned 64 bit integer as an argument.
> +This call also has the side effect on enabled PCI bus mastership.

eh?  I don't get that last sentence...

> +
> +Miscellaneous:
> +
> +The VFIO_BAR_LEN ioctl provides an easy way to determine the size of a PCI
> +device's base address region. It is passed a single integer specifying which
> +BAR (0-5 or 6 for ROM bar), and passes back the length in the same field.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
