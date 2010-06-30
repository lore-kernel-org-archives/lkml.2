Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0F3Nmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:42:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab0F3Nmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:42:32 -0400
Date: Wed, 30 Jun 2010 16:36:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, avi@redhat.com, gregkh@suse.de,
       aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100630133639.GB4226@redhat.com>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
 <1277878452.3164.26.camel@x201>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277878452.3164.26.camel@x201>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 12:14:12AM -0600, Alex Williamson wrote:
> On Tue, 2010-06-08 at 14:21 -0700, Tom Lyon wrote:
> > The VFIO "driver" is used to allow privileged AND non-privileged processes to 
> > implement user-level device drivers for any well-behaved PCI, PCI-X, and PCIe
> > devices.
> 
> Hi Tom,
> 
> I found a few bugs.  Patch below.  The first chunk clears the
> pci_config_map on close, otherwise we end up passing virtualized state
> from one user to the next.  The second is an off by one in the basic
> perms.  Finally, vfio_bar_fixup() needs an overhaul.  It wasn't setting
> the lower bits right and is allowing virtual writes of bits that aren't
> aligned to the size.  This section probably needs another pass or two of
> refinement.  Thanks,
> 
> Alex
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

I still don't see why are we sticking all this emulation in kernel.  It
is far from performance hotpath and can easily be emulated in userspace.
qemu does this, you can lift code from there if you like.
Maybe we need to protect the BARs from being manipulated by userspace,
but that should be all. No need for tables.


> ---
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 96639e5..a0e8227 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -129,6 +129,10 @@ static int vfio_release(struct inode *inode, struct file *filep)
>  			eventfd_ctx_put(vdev->ev_msi);
>  			vdev->ev_irq = NULL;
>  		}
> +		if (vdev->pci_config_map) {
> +			kfree(vdev->pci_config_map);
> +			vdev->pci_config_map = NULL;
> +		}
>  		vfio_domain_unset(vdev);
>  		/* reset to known state if we can */
>  		(void) pci_reset_function(vdev->pdev);
> diff --git a/drivers/vfio/vfio_pci_config.c b/drivers/vfio/vfio_pci_config.c
> index c821b5d..f6e26b1 100644
> --- a/drivers/vfio/vfio_pci_config.c
> +++ b/drivers/vfio/vfio_pci_config.c
> @@ -79,18 +79,18 @@ struct perm_bits {
>  static struct perm_bits pci_cap_basic_perm[] = {
>  	{ 0xFFFFFFFF,	0, },		/* 0x00 vendor & device id - RO */
>  	{ 0,		0xFFFFFFFC, },	/* 0x04 cmd & status except mem/io */
> -	{ 0,		0xFF00FFFF, },	/* 0x08 bist, htype, lat, cache */
> -	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x0c bar */
> +	{ 0,		0, },		/* 0x08 class code & revision id */
> +	{ 0,		0xFF00FFFF, },	/* 0x0c bist, htype, lat, cache */
>  	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x10 bar */
>  	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x14 bar */
>  	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x18 bar */
>  	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x1c bar */
>  	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x20 bar */
> -	{ 0,		0, },		/* 0x24 cardbus - not yet */
> -	{ 0,		0, },		/* 0x28 subsys vendor & dev */
> -	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x2c rom bar */
> -	{ 0,		0, },		/* 0x30 capability ptr & resv */
> -	{ 0,		0, },		/* 0x34 resv */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x24 bar */
> +	{ 0,		0, },		/* 0x28 cardbus - not yet */
> +	{ 0,		0, },		/* 0x2c subsys vendor & dev */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x30 rom bar */
> +	{ 0,		0, },		/* 0x34 capability ptr & resv */
>  	{ 0,		0, },		/* 0x38 resv */
>  	{ 0x000000FF,	0x000000FF, },	/* 0x3c max_lat ... irq */
>  };
> @@ -318,30 +318,55 @@ static void vfio_virt_init(struct vfio_dev *vdev)
>  static void vfio_bar_fixup(struct vfio_dev *vdev)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
> -	int bar;
> -	u32 *lp;
> -	u32 len;
> +	int bar, mem64 = 0;
> +	u32 *lp = NULL;
> +	u64 len = 0;
>  
>  	for (bar = 0; bar <= 5; bar++) {
> -		len = pci_resource_len(pdev, bar);
> -		lp = (u32 *)&vdev->vinfo.bar[bar * 4];
> -		if (len == 0) {
> -			*lp = 0;
> -		} else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
> -			*lp &= ~0x1;
> -			*lp = (*lp & ~(len-1)) |
> -				(*lp & ~PCI_BASE_ADDRESS_MEM_MASK);
> -			if (*lp & PCI_BASE_ADDRESS_MEM_TYPE_64)
> -				bar++;
> -		} else if (pci_resource_flags(pdev, bar) & IORESOURCE_IO) {
> +		if (!mem64) {
> +			len = pci_resource_len(pdev, bar);
> +			lp = (u32 *)&vdev->vinfo.bar[bar * 4];
> +			if (len == 0) {
> +				*lp = 0;
> +				continue;
> +			}
> +
> +			len = ~(len - 1);
> +		} else
> +			len >>= 32;
> +
> +		if (*lp == ~0U)
> +			*lp = (u32)len;
> +		else
> +			*lp &= (u32)len;
> +		
> +		if (mem64) {
> +			mem64 = 0;
> +			continue;
> +		}
> +
> +		if (pci_resource_flags(pdev, bar) & IORESOURCE_IO)
>  			*lp |= PCI_BASE_ADDRESS_SPACE_IO;
> -			*lp = (*lp & ~(len-1)) |
> -				(*lp & ~PCI_BASE_ADDRESS_IO_MASK);
> +		else {
> +			*lp |= PCI_BASE_ADDRESS_SPACE_MEMORY;
> +			if (pci_resource_flags(pdev, bar) & IORESOURCE_PREFETCH)
> +				*lp |= PCI_BASE_ADDRESS_MEM_PREFETCH;
> +			if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM_64) {
> +				*lp |= PCI_BASE_ADDRESS_MEM_TYPE_64;
> +				mem64 = 1;
> +			}
>  		}
>  	}
> +
>  	lp = (u32 *)vdev->vinfo.rombar;
>  	len = pci_resource_len(pdev, PCI_ROM_RESOURCE);
> -	*lp = *lp & PCI_ROM_ADDRESS_MASK & ~(len-1);
> +	len = ~(len - 1);
> +
> +	if (*lp == ~PCI_ROM_ADDRESS_ENABLE)
> +	    *lp = (u32)len;
> +	else
> +	    *lp = *lp & ((u32)len | PCI_ROM_ADDRESS_ENABLE);
> +
>  	vdev->vinfo.bardirty = 0;
>  }
>  
> 
