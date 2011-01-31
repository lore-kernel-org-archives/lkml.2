Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1AaJxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 04:53:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab1AaJxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 04:53:49 -0500
Date: Mon, 31 Jan 2011 11:52:30 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andy Fleming <afleming@freescale.com>,
        "David S. Miller" <davem@davemloft.net>, axboe@kernel.dk, hch@lst.de
Subject: Re: [RFC Patch] virtio: export model and type in /sys
Message-ID: <20110131095230.GA31089@redhat.com>
References: <1296442381-21652-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296442381-21652-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 10:53:00AM +0800, Amerigo Wang wrote:
> Our kdump script needs /sys/block/X/device/{vendor, model, type},

BTW, it's sys/class/block now? One is new, one is legacy and
deprecated, I am not sure which is which ...

> but virtio devices don't have {model, type}, this patch adds them.
> Actually, I don't know how to fill the model field, other block devices
> seem read it from SCSI. Any comments?
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>

For model, I am guessing "virtio-blk" would be a good value.  But I
think this attribute is specific to block so should be added only for
virito-blk.
As far as I can tell, type is from scsi/scsi.h,
so we can just stick TYPE_DISK (0) there.

BTW, I note that other devices in drivers/block might not
have these either. Does your script work for xen-blkfront?
If we want this to work for all block devices maybe these
attributes should go into block core? model could
default to the driver name, type could default to 0...

> ---
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index efb35aa..5ce70b7 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -17,6 +17,18 @@ static ssize_t vendor_show(struct device *_d,
>  	struct virtio_device *dev = container_of(_d,struct virtio_device,dev);
>  	return sprintf(buf, "0x%04x\n", dev->id.vendor);
>  }
> +static ssize_t model_show(struct device *_d,
> +			   struct device_attribute *attr, char *buf)
> +{
> +	struct virtio_device *dev = container_of(_d,struct virtio_device,dev);
> +	return sprintf(buf, "0x%04x\n", dev->id.model);
> +}
> +static ssize_t type_show(struct device *_d,
> +			   struct device_attribute *attr, char *buf)
> +{
> +	struct virtio_device *dev = container_of(_d,struct virtio_device,dev);
> +	return sprintf(buf, "0x%04x\n", dev->id.type);
> +}
>  static ssize_t status_show(struct device *_d,
>  			   struct device_attribute *attr, char *buf)
>  {
> @@ -49,6 +61,8 @@ static ssize_t features_show(struct device *_d,
>  static struct device_attribute virtio_dev_attrs[] = {
>  	__ATTR_RO(device),
>  	__ATTR_RO(vendor),
> +	__ATTR_RO(model),
> +	__ATTR_RO(type),
>  	__ATTR_RO(status),
>  	__ATTR_RO(modalias),
>  	__ATTR_RO(features),
> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> index 4fb5b2b..3bde99d 100644
> --- a/drivers/virtio/virtio_pci.c
> +++ b/drivers/virtio/virtio_pci.c
> @@ -656,6 +656,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
>  	 * the subsystem ids */
>  	vp_dev->vdev.id.vendor = pci_dev->subsystem_vendor;
>  	vp_dev->vdev.id.device = pci_dev->subsystem_device;
> +	vp_dev->vdev.id.type = pci_dev->pcie_type;
>  
>  	/* finally register the virtio device */
>  	err = register_virtio_device(&vp_dev->vdev);
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 48c007d..b72cd50 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -385,6 +385,8 @@ struct ssb_device_id {
>  struct virtio_device_id {
>  	__u32 device;
>  	__u32 vendor;
> +	__u32 model;
> +	__u32 type;
>  };
>  #define VIRTIO_DEV_ANY_ID	0xffffffff
>  
