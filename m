Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab0EaRKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 13:10:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46536 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756230Ab0EaRKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 13:10:09 -0400
Date: Mon, 31 May 2010 18:17:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Tom Lyon" <pugs@cisco.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, mst@redhat.com, avi@redhat.com,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100531181735.6bb71a5c@lxorguk.ukuu.org.uk>
In-Reply-To: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com>
References: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +/*
> + * Map usr buffer at specific IO virtual address
> + */
> +static int vfio_dma_map_iova(

> +	mlp = kzalloc(sizeof *mlp, GFP_KERNEL);

Not good at that point. I think you need to allocate it first, error if
it can't be allocated and then do the work and free it on error ?


> +	mlp = kzalloc(sizeof *mlp, GFP_KERNEL);
> +	mlp->pages = pages;

Ditto


> +int vfio_enable_msix(struct vfio_dev *vdev, int nvec, void __user *uarg)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct eventfd_ctx *ctx;
> +	int ret = 0;
> +	int i;
> +	int fd;
> +
> +	vdev->msix = kzalloc(nvec * sizeof(struct msix_entry),
> +				GFP_KERNEL);
> +	vdev->ev_msix = kzalloc(nvec * sizeof(struct eventfd_ctx *),
> +				GFP_KERNEL);

These don't seem to get freed on the error path - or indeed protected
against being allocated twice (eg two parallel ioctls ?)



> +	case VFIO_DMA_MAP_ANYWHERE:
> +	case VFIO_DMA_MAP_IOVA:
> +		if (copy_from_user(&dm, uarg, sizeof dm))
> +			return -EFAULT;
> +		ret = vfio_dma_map_common(listener, cmd, &dm);
> +		if (!ret && copy_to_user(uarg, &dm, sizeof dm))

So the vfio_dma_map is untrusted. That seems to be checked ok later but
the dma_map_common code then plays in current->mm-> without apparently
holding any locks to stop the values getting corrupted by a parallel
mlock ?

Actually no I take that back

	dmp->size is 64bit

	So npage can end up with values like 0xFFFFFFFF and cause 32bit
	boxes to go kerblam

> +
> +	case VFIO_EVENTFD_IRQ:
> +		if (copy_from_user(&fd, uarg, sizeof fd))
> +			return -EFAULT;
> +		if (vdev->ev_irq)
> +			eventfd_ctx_put(vdev->ev_irq);

These paths need locking - suppose two EVENTFD irq ioctls occur at once
(in general these paths seem not to be covered)

>
> +	case VFIO_BAR_LEN:
> +		if (copy_from_user(&bar, uarg, sizeof bar))
> +			return -EFAULT;
> +		if (bar < 0 || bar > PCI_ROM_RESOURCE)
> +			return -EINVAL;
> +		bar = pci_resource_len(pdev, bar);
> +		if (copy_to_user(uarg, &bar, sizeof bar))
> +			return -EFAULT;

How does this all work out if the device is a bridge ?

> +	pci_read_config_byte(pdev, PCI_INTERRUPT_LINE, &line);
> +	if (line == 0)
> +		goto out;

That may produce some interestingly wrong answers. Firstly the platform
has interrupt abstraction so dev->irq may not match PCI_INTERRUPT_LINE,
secondly you have devices that report their IRQ via other paths as per
spec (notably IDE class devices in non-native mode)

So that would also want extra checks.


> +	pci_read_config_word(pdev, PCI_COMMAND, &orig);
> +	ret = orig & PCI_COMMAND_MASTER;
> +	if (!ret) {
> +		new = orig | PCI_COMMAND_MASTER;
> +		pci_write_config_word(pdev, PCI_COMMAND, new);
> +		pci_read_config_word(pdev, PCI_COMMAND, &new);
> +		ret = new & PCI_COMMAND_MASTER;
> +		pci_write_config_word(pdev, PCI_COMMAND, orig);

The master bit on some devices can be turned on but not off. Not sure it
matters here.

> +	vdev->pdev = pdev;

Probably best to take/drop a reference. Not needed if you can prove your
last use is before the end of the remove path though.


Does look like it needs a locking audit, some memory and error checks
reviewing and some further review of the ioctl security and
overflows/trusted values.

Rather a nice way of attacking the user space PCI problem.
