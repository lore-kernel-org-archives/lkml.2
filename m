Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab2FYKOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 06:14:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636Ab2FYKOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 06:14:53 -0400
Date: Mon, 25 Jun 2012 13:14:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: akong@redhat.com, habanero@linux.vnet.ibm.com, tahm@linux.vnet.ibm.com,
        jwhan@filewood.snu.ac.kr, mashirle@us.ibm.com, krkumar2@in.ibm.com,
        edumazet@google.com, davem@davemloft.net, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [net-next RFC V4 PATCH 3/4] virtio: introduce a method to get
 the irq of a specific virtqueue
Message-ID: <20120625101439.GC19169@redhat.com>
References: <20120625090829.7263.65026.stgit@amd-6168-8-1.englab.nay.redhat.com>
 <1340617278-8022-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340617278-8022-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 05:41:17PM +0800, Jason Wang wrote:
> Device specific irq optimizations such as irq affinity may be used by virtio
> drivers. So this patch introduce a new method to get the irq of a specific
> virtqueue.
> 
> After this patch, virtio device drivers could query the irq and do device
> specific optimizations. First user would be virtio-net.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/lguest/lguest_device.c |    8 ++++++++
>  drivers/s390/kvm/kvm_virtio.c  |    6 ++++++
>  drivers/virtio/virtio_mmio.c   |    8 ++++++++
>  drivers/virtio/virtio_pci.c    |   12 ++++++++++++
>  include/linux/virtio_config.h  |    4 ++++
>  5 files changed, 38 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
> index 9e8388e..bcd080f 100644
> --- a/drivers/lguest/lguest_device.c
> +++ b/drivers/lguest/lguest_device.c
> @@ -392,6 +392,13 @@ static const char *lg_bus_name(struct virtio_device *vdev)
>  	return "";
>  }
>  
> +static int lg_get_vq_irq(struct virtio_device *vdev, struct virtqueue *vq)
> +{
> +	struct lguest_vq_info *lvq = vq->priv;
> +
> +	return lvq->config.irq;
> +}
> +
>  /* The ops structure which hooks everything together. */
>  static struct virtio_config_ops lguest_config_ops = {
>  	.get_features = lg_get_features,
> @@ -404,6 +411,7 @@ static struct virtio_config_ops lguest_config_ops = {
>  	.find_vqs = lg_find_vqs,
>  	.del_vqs = lg_del_vqs,
>  	.bus_name = lg_bus_name,
> +	.get_vq_irq = lg_get_vq_irq,
>  };
>  
>  /*
> diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
> index d74e9ae..a897de2 100644
> --- a/drivers/s390/kvm/kvm_virtio.c
> +++ b/drivers/s390/kvm/kvm_virtio.c
> @@ -268,6 +268,11 @@ static const char *kvm_bus_name(struct virtio_device *vdev)
>  	return "";
>  }
>  
> +static int kvm_get_vq_irq(struct virtio_device *vdev, struct virtqueue *vq)
> +{
> +	return 0x2603;
> +}
> +
>  /*
>   * The config ops structure as defined by virtio config
>   */
> @@ -282,6 +287,7 @@ static struct virtio_config_ops kvm_vq_configspace_ops = {
>  	.find_vqs = kvm_find_vqs,
>  	.del_vqs = kvm_del_vqs,
>  	.bus_name = kvm_bus_name,
> +	.get_vq_irq = kvm_get_vq_irq,
>  };
>  
>  /*
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index f5432b6..2ba37ed 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -411,6 +411,13 @@ static const char *vm_bus_name(struct virtio_device *vdev)
>  	return vm_dev->pdev->name;
>  }
>  
> +static int vm_get_vq_irq(struct virtio_device *vdev, struct virtqueue *vq)
> +{
> +	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
> +
> +	return platform_get_irq(vm_dev->pdev, 0);
> +}
> +
>  static struct virtio_config_ops virtio_mmio_config_ops = {
>  	.get		= vm_get,
>  	.set		= vm_set,
> @@ -422,6 +429,7 @@ static struct virtio_config_ops virtio_mmio_config_ops = {
>  	.get_features	= vm_get_features,
>  	.finalize_features = vm_finalize_features,
>  	.bus_name	= vm_bus_name,
> +	.get_vq_irq     = vm_get_vq_irq,
>  };
>  
>  
> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> index adb24f2..c062227 100644
> --- a/drivers/virtio/virtio_pci.c
> +++ b/drivers/virtio/virtio_pci.c
> @@ -607,6 +607,17 @@ static const char *vp_bus_name(struct virtio_device *vdev)
>  	return pci_name(vp_dev->pci_dev);
>  }
>  
> +static int vp_get_vq_irq(struct virtio_device *vdev, struct virtqueue *vq)
> +{
> +	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> +	struct virtio_pci_vq_info *info = vq->priv;
> +
> +	if (vp_dev->intx_enabled)
> +		return vp_dev->pci_dev->irq;
> +	else
> +		return vp_dev->msix_entries[info->msix_vector].vector;
> +}
> +
>  static struct virtio_config_ops virtio_pci_config_ops = {
>  	.get		= vp_get,
>  	.set		= vp_set,
> @@ -618,6 +629,7 @@ static struct virtio_config_ops virtio_pci_config_ops = {
>  	.get_features	= vp_get_features,
>  	.finalize_features = vp_finalize_features,
>  	.bus_name	= vp_bus_name,
> +	.get_vq_irq     = vp_get_vq_irq,
>  };
>  
>  static void virtio_pci_release_dev(struct device *_d)
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index fc457f4..acd6930 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -98,6 +98,9 @@
>   *	vdev: the virtio_device
>   *      This returns a pointer to the bus name a la pci_name from which
>   *      the caller can then copy.
> + * @get_vq_irq: get the irq numer of the specific virt queue.
> + *      vdev: the virtio_device
> + *      vq: the virtqueue

What if the vq does not have an IRQ? E.g. control vqs don't.
What if the IRQ is shared between VQs? Between devices?
The need to cleanup affinity on destroy is also nasty.
How about we expose a set_affinity API instead?
Then:
	- non PCI can ignore for now
	- with a per vq vector we can force it
	- with a shared MSI we make it an OR over all affinities
	- with a level interrupt we can ignore it
	- on cleanup we can do it in core


>   */
>  typedef void vq_callback_t(struct virtqueue *);
>  struct virtio_config_ops {
> @@ -116,6 +119,7 @@ struct virtio_config_ops {
>  	u32 (*get_features)(struct virtio_device *vdev);
>  	void (*finalize_features)(struct virtio_device *vdev);
>  	const char *(*bus_name)(struct virtio_device *vdev);
> +	int (*get_vq_irq)(struct virtio_device *vdev, struct virtqueue *vq);
>  };
>  
>  /* If driver didn't advertise the feature, it will never appear. */
> -- 
> 1.7.1
