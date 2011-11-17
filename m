Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab1KQM3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 07:29:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757070Ab1KQM3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 07:29:22 -0500
Date: Thu, 17 Nov 2011 14:30:48 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        levinsasha928@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/11] virtio: console: Add freeze and restore
 handlers to support S4
Message-ID: <20111117123047.GD19682@redhat.com>
References: <cover.1321530505.git.amit.shah@redhat.com>
 <44ccf96a9f34b7b9a838af00b2abc97796cbdfe5.1321530505.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44ccf96a9f34b7b9a838af00b2abc97796cbdfe5.1321530505.git.amit.shah@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 05:27:35PM +0530, Amit Shah wrote:
> Remove all vqs and associated buffers in the freeze callback which
> prepares us to go into hibernation state.  On restore, re-create all the
> vqs and populate the input vqs with buffers to get to the pre-hibernate
> state.
> 
> Note: Any outstanding unconsumed buffers are discarded; which means
> there's a possibility of data loss in case the host or the guest didn't
> consume any data already present in the vqs.  This can be addressed in a
> later patch series, perhaps in virtio common code.
> 
> Signed-off-by: Amit Shah <amit.shah@redhat.com>
> ---
>  drivers/char/virtio_console.c |   58 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 58 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index e14f5aa..fd2fd6f 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -1844,6 +1844,60 @@ static unsigned int features[] = {
>  	VIRTIO_CONSOLE_F_MULTIPORT,
>  };
>  
> +#ifdef CONFIG_PM
> +static int virtcons_freeze(struct virtio_device *vdev)
> +{
> +	struct ports_device *portdev;
> +	struct port *port;
> +
> +	portdev = vdev->priv;
> +
> +	vdev->config->reset(vdev);

This does a reset but that's not a guarantee that
interrupt is not running on another CPU.

> +
> +	cancel_work_sync(&portdev->control_work);

And then work can get scheduled after this point.

> +	remove_controlq_data(portdev);

And after this point this will lead to a use after free.

> +
> +	list_for_each_entry(port, &portdev->ports, list) {
> +		/*
> +		 * We'll ask the host later if the new invocation has
> +		 * the port opened or closed.
> +		 */
> +		port->host_connected = false;
> +		remove_port_data(port);
> +	}
> +	remove_vqs(portdev);
> +
> +	return 0;
> +}
> +
> +static int virtcons_restore(struct virtio_device *vdev)
> +{
> +	struct ports_device *portdev;
> +	struct port *port;
> +	int ret;
> +
> +	portdev = vdev->priv;
> +
> +	ret = init_vqs(portdev);
> +	if (ret)
> +		return ret;
> +
> +	if (use_multiport(portdev))
> +		fill_queue(portdev->c_ivq, &portdev->cvq_lock);
> +
> +	list_for_each_entry(port, &portdev->ports, list) {
> +		port->in_vq = portdev->in_vqs[port->id];
> +		port->out_vq = portdev->out_vqs[port->id];
> +
> +		fill_queue(port->in_vq, &port->inbuf_lock);
> +
> +		/* Get port open/close status on the host */
> +		send_control_msg(port, VIRTIO_CONSOLE_PORT_READY, 1);
> +	}
> +	return 0;
> +}
> +#endif
> +
>  static struct virtio_driver virtio_console = {
>  	.feature_table = features,
>  	.feature_table_size = ARRAY_SIZE(features),
> @@ -1853,6 +1907,10 @@ static struct virtio_driver virtio_console = {
>  	.probe =	virtcons_probe,
>  	.remove =	virtcons_remove,
>  	.config_changed = config_intr,
> +#ifdef CONFIG_PM
> +	.freeze =	virtcons_freeze,
> +	.restore =	virtcons_restore,
> +#endif
>  };
>  
>  static int __init init(void)
> -- 
> 1.7.7.1
