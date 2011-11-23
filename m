Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab1KWJGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 04:06:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab1KWJG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 04:06:27 -0500
Date: Wed, 23 Nov 2011 10:46:41 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCHv3 RFC] virtio-pci: flexible configuration layout
Message-ID: <20111123084640.GE22734@redhat.com>
References: <20111122183621.GA5235@redhat.com>
 <87hb1v1scp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hb1v1scp.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 01:02:22PM +1030, Rusty Russell wrote:
> On Tue, 22 Nov 2011 20:36:22 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > Here's an updated vesion.
> > I'm alternating between updating the spec and the driver,
> > spec update to follow.
> 
> Don't touch the spec yet, we have a long way to go :(
> 
> I want the ability for driver to set the ring size, and the device to
> set the alignment.

Did you mean driver to be able to set the alignment? This
is what BIOS guys want - after BIOS completes, guest driver gets handed
control and sets its own alignment to save memory.

> That's a bigger change than you have here.

Why can't we just add the new registers at the end?
With the new capability, we have as much space as we like for that.

> I imagine it almost rips the driver into two completely different drivers.

If you insist on moving all the rest of registers around, certainly. But
why do this?

> This is the kind of thing I had in mind, for the header.  Want me to
> code up the rest?
> 
> (I've avoided adding the constants for the new layout: a struct is more
> compact and more descriptive).
> 
> Cheers,
> Rusty.

Renaming constants in exported headers will break userspace builds.
Do we care? Why not?

> diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
> --- a/include/linux/virtio_pci.h
> +++ b/include/linux/virtio_pci.h
> @@ -42,56 +42,74 @@
>  #include <linux/virtio_config.h>
>  
>  /* A 32-bit r/o bitmask of the features supported by the host */
> -#define VIRTIO_PCI_HOST_FEATURES	0
> +#define VIRTIO_PCI_LEGACY_HOST_FEATURES		0
>  
>  /* A 32-bit r/w bitmask of features activated by the guest */
> -#define VIRTIO_PCI_GUEST_FEATURES	4
> +#define VIRTIO_PCI_LEGACY_GUEST_FEATURES	4
>  
>  /* A 32-bit r/w PFN for the currently selected queue */
> -#define VIRTIO_PCI_QUEUE_PFN		8
> +#define VIRTIO_PCI_LEGACY_QUEUE_PFN		8
>  
>  /* A 16-bit r/o queue size for the currently selected queue */
> -#define VIRTIO_PCI_QUEUE_NUM		12
> +#define VIRTIO_PCI_LEGACY_QUEUE_NUM		12
>  
>  /* A 16-bit r/w queue selector */
> -#define VIRTIO_PCI_QUEUE_SEL		14
> +#define VIRTIO_PCI_LEGACY_QUEUE_SEL		14
>  
>  /* A 16-bit r/w queue notifier */
> -#define VIRTIO_PCI_QUEUE_NOTIFY		16
> +#define VIRTIO_PCI_LEGACY_QUEUE_NOTIFY		16
>  
>  /* An 8-bit device status register.  */
> -#define VIRTIO_PCI_STATUS		18
> +#define VIRTIO_PCI_LEGACY_STATUS		18
>  
>  /* An 8-bit r/o interrupt status register.  Reading the value will return the
>   * current contents of the ISR and will also clear it.  This is effectively
>   * a read-and-acknowledge. */
> -#define VIRTIO_PCI_ISR			19
> -
> -/* The bit of the ISR which indicates a device configuration change. */
> -#define VIRTIO_PCI_ISR_CONFIG		0x2
> +#define VIRTIO_PCI_LEGACY_ISR			19
>  
>  /* MSI-X registers: only enabled if MSI-X is enabled. */
>  /* A 16-bit vector for configuration changes. */
> -#define VIRTIO_MSI_CONFIG_VECTOR        20
> +#define VIRTIO_MSI_LEGACY_CONFIG_VECTOR        20
>  /* A 16-bit vector for selected queue notifications. */
> -#define VIRTIO_MSI_QUEUE_VECTOR         22
> -/* Vector value used to disable MSI for queue */
> -#define VIRTIO_MSI_NO_VECTOR            0xffff
> +#define VIRTIO_MSI_LEGACY_QUEUE_VECTOR         22
>  
>  /* The remaining space is defined by each driver as the per-driver
>   * configuration space */
> -#define VIRTIO_PCI_CONFIG(dev)		((dev)->msix_enabled ? 24 : 20)
> +#define VIRTIO_PCI_LEGACY_CONFIG(dev)		((dev)->msix_enabled ? 24 : 20)
> +
> +/* How many bits to shift physical queue address written to QUEUE_PFN.
> + * 12 is historical, and due to x86 page size. */
> +#define VIRTIO_PCI_LEGACY_QUEUE_ADDR_SHIFT	12
> +
> +/* The alignment to use between consumer and producer parts of vring.
> + * x86 pagesize again. */
> +#define VIRTIO_PCI_LEGACY_VRING_ALIGN		4096
> +
> +#ifndef __KERNEL__
> +/* Don't break compile of old userspace code.  These will go away. */
> +#define VIRTIO_PCI_HOST_FEATURES VIRTIO_PCI_LEGACY_HOST_FEATURES
> +#define VIRTIO_PCI_GUEST_FEATURES VIRTIO_PCI_LEGACY_GUEST_FEATURES
> +#define VIRTIO_PCI_LEGACY_QUEUE_PFN VIRTIO_PCI_QUEUE_PFN
> +#define VIRTIO_PCI_LEGACY_QUEUE_NUM VIRTIO_PCI_QUEUE_NUM
> +#define VIRTIO_PCI_LEGACY_QUEUE_SEL VIRTIO_PCI_QUEUE_SEL
> +#define VIRTIO_PCI_LEGACY_QUEUE_NOTIFY VIRTIO_PCI_QUEUE_NOTIFY
> +#define VIRTIO_PCI_LEGACY_STATUS VIRTIO_PCI_STATUS
> +#define VIRTIO_PCI_LEGACY_ISR VIRTIO_PCI_ISR
> +#define VIRTIO_MSI_LEGACY_CONFIG_VECTOR VIRTIO_MSI_CONFIG_VECTOR
> +#define VIRTIO_MSI_LEGACY_QUEUE_VECTOR VIRTIO_MSI_QUEUE_VECTOR
> +#define VIRTIO_PCI_LEGACY_CONFIG(dev) VIRTIO_PCI_CONFIG(dev)
> +#define VIRTIO_PCI_LEGACY_QUEUE_ADDR_SHIFT VIRTIO_PCI_QUEUE_ADDR_SHIFT
> +#define VIRTIO_PCI_LEGACY_VRING_ALIGN VIRTIO_PCI_VRING_ALIGN
> +#endif /* ...!KERNEL */
>  
>  /* Virtio ABI version, this must match exactly */
>  #define VIRTIO_PCI_ABI_VERSION		0
>  
> -/* How many bits to shift physical queue address written to QUEUE_PFN.
> - * 12 is historical, and due to x86 page size. */
> -#define VIRTIO_PCI_QUEUE_ADDR_SHIFT	12
> +/* Vector value used to disable MSI for queue */
> +#define VIRTIO_MSI_NO_VECTOR            0xffff
>  
> -/* The alignment to use between consumer and producer parts of vring.
> - * x86 pagesize again. */
> -#define VIRTIO_PCI_VRING_ALIGN		4096
> +/* The bit of the ISR which indicates a device configuration change. */
> +#define VIRTIO_PCI_ISR_CONFIG		0x2
>  
>  /*
>   * Layout for Virtio PCI vendor specific capability (little-endian):
> @@ -133,4 +151,20 @@
>  #define VIRTIO_PCI_CAP_CFG_OFF_MASK	0xffffffff
>  #define VIRTIO_PCI_CAP_CFG_OFF_SHIFT	0
>  
> +/* Fields in VIRTIO_PCI_CAP_COMMON_CFG: */
> +struct virtio_pci_common_cfg {
> +	/* About the whole device. */
> +	__u64 device_features;	/* read-only */
> +	__u64 guest_features;	/* read-write */
> +	__u64 queue_address;	/* read-write */
> +	__u16 msix_config;	/* read-write */
> +	__u8 device_status;	/* read-write */
> +	__u8 unused;
> +
> +	/* About a specific virtqueue. */
> +	__u16 queue_select;	/* read-write */
> +	__u16 queue_align;	/* read-write, power of 2. */
> +	__u16 queue_size;	/* read-write, power of 2. */
> +	__u16 queue_msix_vector;/* read-write */
> +};

Slightly confusing as the registers are in fact little endian ...

>  #endif
> 
> 
