Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab1AET2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 14:28:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45051 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1AET2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 14:28:41 -0500
Message-ID: <4D24C662.9070804@codemonkey.ws>
Date: Wed, 05 Jan 2011 13:28:34 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Jamie Lokier <jamie@shareable.org>,
        Thomas Weber <swirl@gmx.li>, gleb@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-pci: add softlinks between virtio and pci
References: <20110105191711.GA27489@redhat.com>
In-Reply-To: <20110105191711.GA27489@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 01:17 PM, Michael S. Tsirkin wrote:
> We sometimes need to map between the virtio device and
> the given pci device. One such use is OS installer that
> gets the boot pci device from BIOS and needs to
> find the relevant block device. Since it can't,
> installation fails.
>    

I have no objection to this patch but I'm a tad confused by the description.

I assume you mean the installer is querying the boot device via int13 
get driver parameters such that it returns the pci address of the device?

Or is it querying geometry information and then trying to find the best 
match block device?

If it's the former, I don't really understand the need for a backlink 
since the PCI address gives you a link to the block device.  OTOH, if 
it's the later, it would make sense but then your description doesn't 
really make much sense.

At any rate, a better commit message would be helpful in explaining the 
need for this.

Regards,

Anthony Liguori

> Supply softlinks between these to make it possible.
>
> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> ---
>
> Gleb, could you please ack that this patch below
> will be enough to fix the installer issue that
> you see?
>
>   drivers/virtio/virtio_pci.c |   18 +++++++++++++++++-
>   1 files changed, 17 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> index ef8d9d5..06eb2f8 100644
> --- a/drivers/virtio/virtio_pci.c
> +++ b/drivers/virtio/virtio_pci.c
> @@ -25,6 +25,7 @@
>   #include<linux/virtio_pci.h>
>   #include<linux/highmem.h>
>   #include<linux/spinlock.h>
> +#include<linux/sysfs.h>
>
>   MODULE_AUTHOR("Anthony Liguori<aliguori@us.ibm.com>");
>   MODULE_DESCRIPTION("virtio-pci");
> @@ -667,8 +668,21 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
>   	if (err)
>   		goto out_set_drvdata;
>
> -	return 0;
> +	err = sysfs_create_link(&pci_dev->dev.kobj,&vp_dev->vdev.dev.kobj,
> +				"virtio_device");
> +	if (err)
> +		goto out_register_device;
> +
> +	err = sysfs_create_link(&vp_dev->vdev.dev.kobj,&pci_dev->dev.kobj,
> +				"bus_device");
> +	if (err)
> +		goto out_create_link;
>
> +	return 0;
> +out_create_link:
> +	sysfs_remove_link(&pci_dev->dev.kobj, "virtio_device");
> +out_register_device:
> +	unregister_virtio_device(&vp_dev->vdev);
>   out_set_drvdata:
>   	pci_set_drvdata(pci_dev, NULL);
>   	pci_iounmap(pci_dev, vp_dev->ioaddr);
> @@ -685,6 +699,8 @@ static void __devexit virtio_pci_remove(struct pci_dev *pci_dev)
>   {
>   	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
>
> +	sysfs_remove_link(&vp_dev->vdev.dev.kobj, "bus_device");
> +	sysfs_remove_link(&pci_dev->dev.kobj, "virtio_device");
>   	unregister_virtio_device(&vp_dev->vdev);
>   }
>
>    

