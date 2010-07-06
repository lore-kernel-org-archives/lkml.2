Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab0GFEua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 00:50:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab0GFEu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 00:50:28 -0400
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
From: Alex Williamson <alex.williamson@redhat.com>
To: Tom Lyon <pugs@cisco.com>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de, mst@redhat.com,
       avi@redhat.com, gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
In-Reply-To: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 22:50:05 -0600
Message-ID: <1278391805.5764.28.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom.

A few MSI issues below.  Thanks,

Alex

On Tue, 2010-06-08 at 14:21 -0700, Tom Lyon wrote:
> diff -uprN linux-2.6.34/drivers/vfio/vfio_pci_config.c vfio-linux-2.6.34/drivers/vfio/vfio_pci_config.c
> --- linux-2.6.34/drivers/vfio/vfio_pci_config.c	1969-12-31 16:00:00.000000000 -0800
> +++ vfio-linux-2.6.34/drivers/vfio/vfio_pci_config.c	2010-05-28 14:26:47.000000000 -0700
> +/*
> + * Lengths of PCI Config Capabilities
> + * 0 means unknown (but at least 4)
> + * FF means special/variable
> + */
> +static u8 pci_capability_length[] = {
> +	[PCI_CAP_ID_BASIC]	= 64,		/* pci config header */
> +	[PCI_CAP_ID_PM]		= PCI_PM_SIZEOF,
> +	[PCI_CAP_ID_AGP]	= PCI_AGP_SIZEOF,
> +	[PCI_CAP_ID_VPD]	= 8,
> +	[PCI_CAP_ID_SLOTID]	= 4,
> +	[PCI_CAP_ID_MSI]	= 0xFF,		/* 10, 14, or 24 */

I think this is actually 10, 14, 20, or 24.

> +static struct perm_bits pci_cap_msi_perm[] = {
> +	{ 0,		0, },		/* 0x00 MSI message control */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x04 MSI message address */
> +	{ 0xFFFFFFFF,	0xFFFFFFFF, },	/* 0x08 MSI message addr/data */
> +	{ 0x0000FFFF,	0x0000FFFF, },	/* 0x0c MSI message data */
> +	{ 0,		0xFFFFFFFF, },	/* 0x10 MSI mask bits */
> +	{ 0,		0xFFFFFFFF, },	/* 0x14 MSI pending bits */
> +};

Is there any reason for mask bits to have virtualized writes?  I don't
think we can support all 4 MSI capability sizes with this one table.  We
probably need a 32bit and 64bit version, then we can drop the mask,
pending, and reserved fields via the length.

> +		if (len == 0xFF) {
> +			switch (cap) {
> +			case PCI_CAP_ID_MSI:
> +				ret = pci_read_config_word(pdev,
> +						pos + PCI_MSI_FLAGS, &flags);
> +				if (ret < 0)
> +					return ret;
> +				if (flags & PCI_MSI_FLAGS_MASKBIT)
> +					/* per vec masking */
> +					len = 24;
> +				else if (flags & PCI_MSI_FLAGS_64BIT)

These aren't mutually exclusive features aiui.

> +					/* 64 bit */
> +					len = 14;
> +				else
> +					len = 10;
> +				break;

This should probably be something like

len = 10;
if (flags & PCI_MSI_FLAGS_MASKBIT)
    len += 10;
if (flags & PCI_MSI_FLAGS_64BIT) {
    /* set 64bit permission table */
    len += 4;
} else
    /* set 32bit permission table */

> diff -uprN linux-2.6.34/include/linux/vfio.h vfio-linux-2.6.34/include/linux/vfio.h
> --- linux-2.6.34/include/linux/vfio.h	1969-12-31 16:00:00.000000000 -0800
> +++ vfio-linux-2.6.34/include/linux/vfio.h	2010-06-07 12:20:06.000000000 -0700

> +/* request MSI interrupts; use given eventfd */
> +#define	VFIO_EVENTFD_MSI	_IOW(';', 105, int)

Any intention of supporting MSI multiple message capability?  If so,
this might turn into the same interface as MSIX.

