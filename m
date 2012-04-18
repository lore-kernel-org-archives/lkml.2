Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab2DROVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:21:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab2DROVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:21:45 -0400
Date: Wed, 18 Apr 2012 17:21:47 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC PATCH] virtio_console: link vq to port with a private
 pointer in struct virtqueue
Message-ID: <20120418142146.GB11801@redhat.com>
References: <1334756013-11752-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334756013-11752-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 03:33:33PM +0200, Paolo Bonzini wrote:
> For virtio-scsi multiqueue support I would like to have an easy and
> fast way to go from a virtqueue to the internal struct for that
> queue.
> 
> It turns out that virtio-serial has the same need, but it gets
> by with a simple list walk.
> 
> This patch adds a pointer to struct virtqueue that is reserved for
> the virtio device, and uses it in virtio-serial.
> 
> Cc: Amit Shah <amit.shah@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	Untested; what do you think?  Would this patch be acceptable
> 	as is, or only with a more pressing need in virtio-scsi, or never?
> 
>  drivers/char/virtio_console.c |   16 +++++-----------
>  include/linux/virtio.h        |    2 ++
>  2 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index 1c74734..cfc7a63 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -297,17 +297,7 @@ out:
>  static struct port *find_port_by_vq(struct ports_device *portdev,
>  				    struct virtqueue *vq)
>  {
> -	struct port *port;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&portdev->ports_lock, flags);
> -	list_for_each_entry(port, &portdev->ports, list)
> -		if (port->in_vq == vq || port->out_vq == vq)
> -			goto out;
> -	port = NULL;
> -out:
> -	spin_unlock_irqrestore(&portdev->ports_lock, flags);
> -	return port;
> +	return vq->vdev_priv;
>  }
>  
>  static bool is_console_port(struct port *port)
> @@ -1159,6 +1149,8 @@ static int add_port(struct ports_device *portdev, u32 id)
>  
>  	port->in_vq = portdev->in_vqs[port->id];
>  	port->out_vq = portdev->out_vqs[port->id];
> +	port->in_vq->vdev_priv = port;
> +	port->out_vq->vdev_priv = port;
>  
>  	port->cdev = cdev_alloc();
>  	if (!port->cdev) {
> @@ -1872,6 +1864,8 @@ static int virtcons_restore(struct virtio_device *vdev)
>  	list_for_each_entry(port, &portdev->ports, list) {
>  		port->in_vq = portdev->in_vqs[port->id];
>  		port->out_vq = portdev->out_vqs[port->id];
> +		port->in_vq->vdev_priv = port;
> +		port->out_vq->vdev_priv = port;
>  
>  		fill_queue(port->in_vq, &port->inbuf_lock);
>  

Let's add an API to set this pointer.
Document that you must not set it after
probe/restore returned.
With an API we can actually have a BUG_ON that checks it's not modified
after probe.

> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index c193ccf..6b39c1a 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -14,6 +14,7 @@
>   * @callback: the function to call when buffers are consumed (can be NULL).
>   * @name: the name of this virtqueue (mainly for debugging)
>   * @vdev: the virtio device this queue was created for.
> + * @vdev_priv: a pointer for the virtio device to use.

It's for the driver actually.

>   * @priv: a pointer for the virtqueue implementation to use.
>   */
>  struct virtqueue {
> @@ -21,6 +22,7 @@ struct virtqueue {
>  	void (*callback)(struct virtqueue *vq);
>  	const char *name;
>  	struct virtio_device *vdev;
> +	void *vdev_priv;
>  	void *priv;

The name is confusing: it seems to imply it's a device pointer.
Maybe we should rename priv to something like __priv and make
priv useful for devices?

>  };
>  
> -- 
> 1.7.9.3
