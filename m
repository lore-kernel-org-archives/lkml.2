Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab0DQSfT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 14:35:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab0DQSfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 14:35:16 -0400
Message-ID: <4BC9FF38.7040009@redhat.com>
Date: Sat, 17 Apr 2010 21:34:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tom Lyon <pugs@cisco.com>
CC: mst@redhat.com, hjk@linutronix.de, gregkh@suse.de, chrisw@sous-sol.org,
       joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] drivers/uio/uio.c: DMA mapping, interrupt extensions,
 etc.
References: <4bc77d41.njZFTBp9Nkn93l72%pugs@cisco.com>
In-Reply-To: <4bc77d41.njZFTBp9Nkn93l72%pugs@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 11:55 PM, Tom Lyon wrote:
> This is the second of 2 related, but independent, patches. This is for
> uio.c, the previous is for uio_pci_generic.c.
>
> The 2 patches were previously one large patch. Changes for this version:
> - uio_pci_generic.c just gets extensions so that a single fd can be used
>    by non-privileged processes for interrupt control and mmaps
> - All of the DMA and IOMMU related stuff move to uio.c; no longer a need
>    to pass ioctls to individual uio drivers. It turns out that the code
>    is not PCI specific anyways.
> - A new ioctl to pin DMA buffers to certain IO virtual addresses for KVM.
> - New eventfd based interrupt notifications, including support for PCI
>    specific MSI and MSI-X interrupts.
> - PCI specific code to reset PCI functions before and after use
>
>
> @@ -122,4 +126,23 @@
>   #define UIO_PORT_GPIO	2
>   #define UIO_PORT_OTHER	3
>
> +#endif	/* __KERNEL__ */
> +
> +// Kernel&  User level defines for ioctls
> +
> +struct uio_dma_map {
> +	unsigned long	vaddr;
> +	unsigned long long dmaaddr;
>    

Use __u64 for both, otherwise you need to rewrite the structures in the 
kernel in case 32-bit userspace calls a 64-bit kernel.

> +	int	size;
>    

What units?  Size is probably too small.  Suggest unsigned type to avoid 
an extra check in the kernel.

> +	int	rdwr;
>    

What values can this hold?

> +};
> +
> +#define	UIO_DMA_MAP_ANYWHERE	_IOWR(';', 100, struct uio_dma_map)
>    

What does this do?  Ignore vaddr?

> +#define	UIO_DMA_MAP_IOVA	_IOWR(';', 101, struct uio_dma_map)
> +#define	UIO_DMA_UNMAP		_IOW(';', 102, struct uio_dma_map)
> +#define	UIO_DMA_MASK		_IOW(';', 103, unsigned long long)
> +#define	UIO_EVENTFD_IRQ		_IOW(';', 104, int)
> +#define	UIO_EVENTFD_MSI		_IOW(';', 105, int)
> +#define	UIO_EVENTFDS_MSIX	_IOW(';', 106, int)
>    

These three need some documentation.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

