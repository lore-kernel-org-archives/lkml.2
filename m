Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab1AJRLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:11:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab1AJRLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:11:13 -0500
Date: Mon, 10 Jan 2011 19:10:46 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Milton Miller <miltonm@bga.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio: remove virtio-pci root device
Message-ID: <20110110171046.GB27292@redhat.com>
References: <20110105191711.GA27489@redhat.com>
 <virtio-pci-whynotsimplify@mdm.bga.com>
 <virtio-pci-noroot@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <virtio-pci-noroot@mdm.bga.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 02:55:06AM -0600, Milton Miller wrote:
> We sometimes need to map between the virtio device and
> the given pci device. One such use is OS installer that
> gets the boot pci device from BIOS and needs to
> find the relevant block device. Since it can't,
> installation fails.
> 
> Instead of creating a top-level devices/virtio-pci
> directory, create each device under the corresponding
> pci device node.  Symlinks to all virtio-pci
> devices can be found under the pci driver link in
> bus/pci/drivers/virtio-pci/devices, and all virtio
> devices under drivers/bus/virtio/devices.
> 
> Signed-off-by: Milton Miller <miltonm@bga.com>
Acked-by: Gleb Natapov <gleb@redhat.com>

> ---
> 
> This is an alternative to the patch by Michael S. Tsirkin
> titled "virtio-pci: add softlinks between virtio and pci"
> https://patchwork.kernel.org/patch/454581/
> 
> It creates simpler code, uses less memory, and should
> be even easier use by the installer as it won't have to
> know a virtio symlink to follow (just follow none).
> 
> Compile tested only as I don't have kvm setup.
> 
> 
> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> index ef8d9d5..4fb5b2b 100644
> --- a/drivers/virtio/virtio_pci.c
> +++ b/drivers/virtio/virtio_pci.c
> @@ -96,11 +96,6 @@ static struct pci_device_id virtio_pci_id_table[] = {
>  
>  MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
>  
> -/* A PCI device has it's own struct device and so does a virtio device so
> - * we create a place for the virtio devices to show up in sysfs.  I think it
> - * would make more sense for virtio to not insist on having it's own device. */
> -static struct device *virtio_pci_root;
> -
>  /* Convert a generic virtio device to our structure */
>  static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
>  {
> @@ -629,7 +624,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
>  	if (vp_dev == NULL)
>  		return -ENOMEM;
>  
> -	vp_dev->vdev.dev.parent = virtio_pci_root;
> +	vp_dev->vdev.dev.parent = &pci_dev->dev;
>  	vp_dev->vdev.dev.release = virtio_pci_release_dev;
>  	vp_dev->vdev.config = &virtio_pci_config_ops;
>  	vp_dev->pci_dev = pci_dev;
> @@ -717,17 +712,7 @@ static struct pci_driver virtio_pci_driver = {
>  
>  static int __init virtio_pci_init(void)
>  {
> -	int err;
> -
> -	virtio_pci_root = root_device_register("virtio-pci");
> -	if (IS_ERR(virtio_pci_root))
> -		return PTR_ERR(virtio_pci_root);
> -
> -	err = pci_register_driver(&virtio_pci_driver);
> -	if (err)
> -		root_device_unregister(virtio_pci_root);
> -
> -	return err;
> +	return pci_register_driver(&virtio_pci_driver);
>  }
>  
>  module_init(virtio_pci_init);
> @@ -735,7 +720,6 @@ module_init(virtio_pci_init);
>  static void __exit virtio_pci_exit(void)
>  {
>  	pci_unregister_driver(&virtio_pci_driver);
> -	root_device_unregister(virtio_pci_root);
>  }
>  
>  module_exit(virtio_pci_exit);

--
			Gleb.
