Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab1LGKlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:41:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625Ab1LGKlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:41:39 -0500
Date: Wed, 7 Dec 2011 12:43:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 04/12] virtio: console: Add freeze and restore
 handlers to support S4
Message-ID: <20111207104323.GE8326@redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
 <9f09629340556ddac37135bc3aab233f1154f86a.1323199985.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f09629340556ddac37135bc3aab233f1154f86a.1323199985.git.amit.shah@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 01:18:42AM +0530, Amit Shah wrote:
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


So here, cancel_work_sync might still be running.
If it does run, might it try to access the device
config?  Could not determine this quickly, if yes it's a problem.

> +
> +	cancel_work_sync(&portdev->control_work);
> +	remove_controlq_data(portdev);
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
> 1.7.7.3
