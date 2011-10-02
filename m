Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab1JBJc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 05:32:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab1JBJcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 05:32:19 -0400
Date: Sun, 2 Oct 2011 11:33:26 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/11] virtio: net: Add freeze, restore handlers to
 support S4
Message-ID: <20111002093324.GD29706@redhat.com>
References: <cover.1317311033.git.amit.shah@redhat.com>
 <5b7834c9a30254220f9c079ba54d29abaf63db8f.1317311033.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b7834c9a30254220f9c079ba54d29abaf63db8f.1317311033.git.amit.shah@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 09:19:40PM +0530, Amit Shah wrote:
> Remove all the vqs on hibernation and re-create them after restoring
> from a hibernated image.  This keeps networking working across
> hibernation.
> 
> Signed-off-by: Amit Shah <amit.shah@redhat.com>
> ---
>  drivers/net/virtio_net.c |   28 ++++++++++++++++++++++++++++
>  1 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index dcd4b01..8b9ed43 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1131,6 +1131,30 @@ static void __devexit virtnet_remove(struct virtio_device *vdev)
>  	free_netdev(vi->dev);
>  }
>  
> +#ifdef CONFIG_PM
> +static int virtnet_freeze(struct virtio_device *vdev)
> +{
> +	struct virtnet_info *vi = vdev->priv;

I'm guessing we need to do something like netif_device_detach here,
otherwise guest might be in the process of using the vq for transmit at
this point.

I think we also must make sure NAPI RX handler is not in progress.

We also might need to mask interrupts from the device
to prevent TX or RX from getting rescheduled?


> +
> +	remove_vq_common(vi);
> +
> +	return 0;
> +}
> +
> +static int virtnet_restore(struct virtio_device *vdev)
> +{
> +	struct virtnet_info *vi = vdev->priv;
> +	int err;
> +
> +	err = init_vqs(vi);
> +	if (err)
> +		return err;
> +
> +	try_fill_recv(vi, GFP_KERNEL);
> +	return 0;
> +}
> +#endif
> +
>  static struct virtio_device_id id_table[] = {
>  	{ VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID },
>  	{ 0 },
> @@ -1155,6 +1179,10 @@ static struct virtio_driver virtio_net_driver = {
>  	.probe =	virtnet_probe,
>  	.remove =	__devexit_p(virtnet_remove),
>  	.config_changed = virtnet_config_changed,
> +#ifdef CONFIG_PM
> +	.freeze =	virtnet_freeze,
> +	.restore =	virtnet_restore,
> +#endif
>  };
>  
>  static int __init init(void)
> -- 
> 1.7.6.2
