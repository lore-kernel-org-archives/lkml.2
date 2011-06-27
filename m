Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1F0WXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:23:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49286 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab1F0WVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 18:21:25 -0400
Date: Mon, 27 Jun 2011 16:21:21 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC 7/8] drivers: introduce rpmsg, a remote-processor messaging
 bus
Message-ID: <20110627222121.GD20865@ponder.secretlab.ca>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-8-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308640714-17961-8-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 10:18:33AM +0300, Ohad Ben-Cohen wrote:
> Add a virtio-based IPC bus, which enables kernel users to communicate
> with remote processors over shared memory using a simple messaging
> protocol.
> 
> Assign a local address for every local endpoint that is created,
> and bind it to the user's callback. Invoke that callback when the
> destination of an inbound message is the user's address.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

Hey Ohad,

Nice patch.  I'm quite thrilled to see this implemented.  Some
comments below, but otherwise I think it looks pretty good.


> ---
>  Documentation/ABI/testing/sysfs-bus-rpmsg |   75 +++
>  Documentation/rpmsg.txt                   |  308 +++++++++
>  drivers/Kconfig                           |    1 +
>  drivers/Makefile                          |    1 +
>  drivers/rpmsg/Kconfig                     |   14 +
>  drivers/rpmsg/Makefile                    |    1 +
>  drivers/rpmsg/virtio_rpmsg_bus.c          | 1036 +++++++++++++++++++++++++++++
>  include/linux/mod_devicetable.h           |   10 +
>  include/linux/rpmsg.h                     |  421 ++++++++++++
>  include/linux/virtio_ids.h                |    1 +
>  10 files changed, 1868 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-rpmsg
>  create mode 100644 Documentation/rpmsg.txt
>  create mode 100644 drivers/rpmsg/Kconfig
>  create mode 100644 drivers/rpmsg/Makefile
>  create mode 100644 drivers/rpmsg/virtio_rpmsg_bus.c
>  create mode 100644 include/linux/rpmsg.h
> 
> diff --git a/Documentation/rpmsg.txt b/Documentation/rpmsg.txt
> new file mode 100644
> index 0000000..0a7c820
> --- /dev/null
> +++ b/Documentation/rpmsg.txt
[...]

Great documentation!  Thanks!

> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 1f6d6d3..840f835 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -128,4 +128,5 @@ source "drivers/clocksource/Kconfig"
>  
>  source "drivers/remoteproc/Kconfig"
>  
> +source "drivers/rpmsg/Kconfig"
>  endmenu
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 4d53a18..2980a15 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -22,6 +22,7 @@ obj-$(CONFIG_ARM_AMBA)		+= amba/
>  obj-$(CONFIG_DMA_ENGINE)	+= dma/
>  
>  obj-$(CONFIG_VIRTIO)		+= virtio/
> +obj-$(CONFIG_RPMSG)		+= rpmsg/
>  obj-$(CONFIG_XEN)		+= xen/
>  
>  # regulators early, since some subsystems rely on them to initialize
> diff --git a/drivers/rpmsg/Kconfig b/drivers/rpmsg/Kconfig
> new file mode 100644
> index 0000000..41303f5
> --- /dev/null
> +++ b/drivers/rpmsg/Kconfig
> @@ -0,0 +1,14 @@
> +# RPMSG always gets selected by whoever wants it
> +config RPMSG
> +	tristate
> +	select VIRTIO
> +	select VIRTIO_RING
> +
> +if RPMSG
> +
> +# OK, it's a little counter-intuitive to do this, but it puts it neatly under
> +# the rpmsg menu (and it's the approach preferred by the virtio folks).
> +
> +source "drivers/virtio/Kconfig"

What happens when kvm and rpmsg both get enabled on the same kernel.
ARM virtualization is currently being worked on, so it will happen.
Also, I can see this finding use in the x86 world to talk to
coprocessor boards (like the Xilinx FPGA plugin board which can have a
soft core on it).

> +
> +endif # RPMSG
> diff --git a/drivers/rpmsg/Makefile b/drivers/rpmsg/Makefile
> new file mode 100644
> index 0000000..7617fcb
> --- /dev/null
> +++ b/drivers/rpmsg/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_RPMSG)	+= virtio_rpmsg_bus.o
> diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
> new file mode 100644
> index 0000000..3e98b02
> --- /dev/null
> +++ b/drivers/rpmsg/virtio_rpmsg_bus.c
[...]
> +/* rpmsg devices and drivers are matched using the service name */
> +static inline int rpmsg_id_match(const struct rpmsg_channel *rpdev,
> +				  const struct rpmsg_device_id *id)
> +{
> +	if (strncmp(id->name, rpdev->id.name, RPMSG_NAME_SIZE))
> +		return 0;
> +
> +	return 1;
> +}

or simply: 'return strncmp(id->name, rpdev->id.name, RPMSG_NAME_SIZE) == 0;'

:-)

> +/* for more info, see below documentation of rpmsg_create_ept() */
> +static struct rpmsg_endpoint *__rpmsg_create_ept(struct virtproc_info *vrp,
> +		struct rpmsg_channel *rpdev,
> +		void (*cb)(struct rpmsg_channel *, void *, int, void *, u32),
> +		void *priv, u32 addr)
> +{
> +	int err, tmpaddr, request;
> +	struct rpmsg_endpoint *ept;
> +	struct device *dev = rpdev ? &rpdev->dev : &vrp->vdev->dev;
> +
> +	if (!idr_pre_get(&vrp->endpoints, GFP_KERNEL))
> +		return NULL;
> +
> +	ept = kzalloc(sizeof(*ept), GFP_KERNEL);
> +	if (!ept) {
> +		dev_err(dev, "failed to kzalloc a new ept\n");
> +		return NULL;
> +	}
> +
> +	ept->rpdev = rpdev;
> +	ept->cb = cb;
> +	ept->priv = priv;
> +
> +	/* do we need to allocate a local address ? */
> +	request = addr == RPMSG_ADDR_ANY ? RPMSG_RESERVED_ADDRESSES : addr;
> +
> +	spin_lock(&vrp->endpoints_lock);

Is a spin_lock the right choice for endpoints, or should it be a
mutex (do the endpoints operations need to be atomic)?

> +/*
> + * find an existing channel using its name + address properties,
> + * and destroy it
> + */
> +static int rpmsg_destroy_channel(struct virtproc_info *vrp,
> +					struct rpmsg_channel_info *chinfo)
> +{
> +	struct virtio_device *vdev = vrp->vdev;
> +	struct device *dev;
> +
> +	dev = device_find_child(&vdev->dev, chinfo, rpmsg_channel_match);
> +	if (!dev)
> +		return -EINVAL;
> +
> +	device_unregister(dev);
> +
> +	put_device(dev);
> +
> +	kfree(to_rpmsg_channel(dev));

At put_device time, it is conceivable that the dev pointer is no
longer valid.  You'll need to get do the to_rpmsg_channel() before
putting the dev.

> +
> +	return 0;
> +}
> +
> +/* super simple buffer "allocator" that is just enough for now */
> +static void *get_a_tx_buf(struct virtproc_info *vrp)
> +{
> +	unsigned int len;
> +	void *ret;
> +
> +	/* support multiple concurrent senders */
> +	spin_lock(&vrp->tx_lock);
> +
> +	/*
> +	 * either pick the next unused tx buffer
> +	 * (half of our buffers are used for sending messages)
> +	 */
> +	if (vrp->last_sbuf < vrp->num_bufs / 2)
> +		ret = vrp->sbufs + vrp->buf_size * vrp->last_sbuf++;
> +	/* or recycle a used one */
> +	else
> +		ret = virtqueue_get_buf(vrp->svq, &len);
> +
> +	spin_unlock(&vrp->tx_lock);
> +
> +	return ret;
> +}
> +
> +/**
> + * rpmsg_upref_sleepers() - enable "tx-complete" interrupts, if needed
> + * @vrp: virtual remote processor state
> + *
> + * This function is called before a sender is blocked, waiting for
> + * a tx buffer to become available.
> + *
> + * If we already have blocking senders, this function merely increases
> + * the "sleepers" reference count, and exits.
> + *
> + * Otherwise, if this is the first sender to block, we also enable
> + * virtio's tx callbacks, so we'd be immediately notified when a tx
> + * buffer is consumed (we rely on virtio's tx callback in order
> + * to wake up sleeping senders as soon as a tx buffer is used by the
> + * remote processor).
> + */
> +static void rpmsg_upref_sleepers(struct virtproc_info *vrp)
> +{
> +	/* support multiple concurrent senders */
> +	spin_lock(&vrp->tx_lock);
> +
> +	/* are we the first sleeping context waiting for tx buffers ? */
> +	if (!vrp->sleepers++)

Maybe use a kref?  It might be useful to have a kref_get_first() that
takes a callback used for the first increment.

> +static int rpmsg_remove_device(struct device *dev, void *data)
> +{
> +	struct rpmsg_channel *rpdev = to_rpmsg_channel(dev);
> +
> +	device_unregister(dev);
> +
> +	kfree(rpdev);

put_device() I think.

> +
> +	return 0;
> +}
> +
> +static void __devexit rpmsg_remove(struct virtio_device *vdev)
> +{
> +	struct virtproc_info *vrp = vdev->priv;
> +	int ret;
> +
> +	ret = device_for_each_child(&vdev->dev, NULL, rpmsg_remove_device);
> +	if (ret)
> +		dev_warn(&vdev->dev, "can't remove rpmsg device: %d\n", ret);
> +
> +	idr_remove_all(&vrp->endpoints);
> +	idr_destroy(&vrp->endpoints);
> +
> +	vdev->config->del_vqs(vrp->vdev);
> +
> +	kfree(vrp);
> +}
> +
> +static struct virtio_device_id id_table[] = {
> +	{ VIRTIO_ID_RPMSG, VIRTIO_DEV_ANY_ID },
> +	{ 0 },
> +};
> +
> +static unsigned int features[] = {
> +	VIRTIO_RPMSG_F_NS,
> +};
> +
> +static struct virtio_driver virtio_ipc_driver = {
> +	.feature_table	= features,
> +	.feature_table_size = ARRAY_SIZE(features),
> +	.driver.name	= KBUILD_MODNAME,
> +	.driver.owner	= THIS_MODULE,
> +	.id_table	= id_table,
> +	.probe		= rpmsg_probe,
> +	.remove		= __devexit_p(rpmsg_remove),
> +};
> +
> +static int __init init(void)

Even for static functions, it's a really good idea to prefix all
function names and file scoped symbol with a common prefix like
"rpmsg_".  Doing so avoids even the outside chance of a namespace
conflict.

> +{
> +	int ret;
> +
> +	ret = bus_register(&rpmsg_bus);
> +	if (ret) {
> +		pr_err("failed to register rpmsg bus: %d\n", ret);
> +		return ret;
> +	}
> +
> +	return register_virtio_driver(&virtio_ipc_driver);

And if register_virtio_driver fails?

> +}
> +module_init(init);
> +
> +static void __exit fini(void)
> +{
> +	unregister_virtio_driver(&virtio_ipc_driver);
> +	bus_unregister(&rpmsg_bus);
> +}
> +module_exit(fini);
> +
> +MODULE_DEVICE_TABLE(virtio, id_table);
> +MODULE_DESCRIPTION("Virtio-based remote processor messaging bus");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index ae28e93..561567e 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -533,4 +533,14 @@ struct isapnp_device_id {
>  	kernel_ulong_t driver_data;	/* data private to the driver */
>  };
>  
> +/* rpmsg */
> +
> +#define RPMSG_NAME_SIZE			32
> +#define RPMSG_DEVICE_MODALIAS_FMT	"rpmsg:%s"
> +
> +struct rpmsg_device_id {
> +	char name[RPMSG_NAME_SIZE];
> +	kernel_ulong_t driver_data	/* Data private to the driver */
> +			__attribute__((aligned(sizeof(kernel_ulong_t))));
> +};

Should this be co-located with vio_device_id?

It makes it easier to dereference in kernel code if you do:

#ifdef __KERNEL__
	void *data;
#else
	kernel_ulong_t data;
#endif

