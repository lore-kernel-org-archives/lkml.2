Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab2ITGJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:09:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab2ITGJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:09:37 -0400
Date: Thu, 20 Sep 2012 09:10:57 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: sjur.brandeland@stericsson.com
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit.shah@redhat.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCHv2] virtio_console: Add support for remoteproc serial
Message-ID: <20120920061057.GD5721@redhat.com>
References: <1348073458-17592-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348073458-17592-1-git-send-email-sjur.brandeland@stericsson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 06:50:58PM +0200, sjur.brandeland@stericsson.com wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> 
> Add a simple serial connection driver called
> VIRTIO_ID_RPROC_SERIAL (0xB) for communicating with a
> remote processor in an asymmetric multi-processing
> configuration.
> 
> This implementation reuses the existing virtio_console
> implementation, and adds support for DMA allocation
> of data buffers and disables use of tty console and
> the virtio control queue.

Can't repoteproc work with control queue?
Reason I ask, there are known races when
using config space and I was working on
a spec change that uses control queue for
all config accesses.

> This enables use of the exising virtio_console code in
> the remoteproc framework.
> 
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> cc: Michael S. Tsirkin <mst@redhat.com>
> cc: Amit Shah <amit.shah@redhat.com>
> cc: Ohad Ben-Cohen <ohad@wizery.com>
> cc: Linus Walleij <linus.walleij@linaro.org>
> ---
> 
> Hi Rusty,
> 
> Changes since v1:
> o Use proper macros IS_ENABLED(CONFIG_REMOTEPROC)
> o Fix bug at registration of rproc_serial driver
> o Always allocate PAGE_SIZE buffers for rproc_serial,
>   and limit write to port_fops_write to use PAGE_SIZE.
> 
> Regards,
> Sjur
> 
>  drivers/char/virtio_console.c |  160 ++++++++++++++++++++++++++++++++++-------
>  include/linux/virtio_ids.h    |    1 +
>  2 files changed, 134 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index cdf2f54..395522a 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -35,6 +35,8 @@
>  #include <linux/wait.h>
>  #include <linux/workqueue.h>
>  #include <linux/module.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/kconfig.h>
>  #include "../tty/hvc/hvc_console.h"
>  
>  /*
> @@ -323,6 +325,52 @@ static bool is_console_port(struct port *port)
>  	return false;
>  }
>  
> +#if IS_ENABLED(CONFIG_REMOTEPROC)
> +static inline bool is_rproc_serial(struct virtio_device *vdev)
> +{
> +	return vdev->id.device == VIRTIO_ID_RPROC_SERIAL;
> +}
> +#else
> +static inline bool is_rproc_serial(struct virtio_device *vdev)
> +{
> +	return false;
> +}
> +#endif
> +
> +/* Allocate data buffer from DMA memory if requested */
> +static inline void *
> +alloc_databuf(struct virtio_device *vdev, size_t size, gfp_t flag)
> +{
> +	if (is_rproc_serial(vdev)) {
> +		dma_addr_t dma;
> +		struct device *dev = &vdev->dev;
> +		/*
> +		 * Allocate DMA memory from ancestors. Finding the ancestor
> +		 * is a bit quirky when DMA_MEMORY_INCLUDES_CHILDREN is not
> +		 * implemented.
> +		 */
> +		dev = dev->parent ? dev->parent : dev;
> +		dev = dev->parent ? dev->parent : dev;
> +		return dma_alloc_coherent(dev, size, &dma, flag);
> +	}
> +	return kmalloc(size, flag);
> +}
> +
> +static inline void
> +free_databuf(struct virtio_device *vdev, size_t size, void *cpu_addr)
> +{
> +
> +	if (is_rproc_serial(vdev)) {
> +		struct device *dev = &vdev->dev;
> +		dma_addr_t dma_handle = virt_to_bus(cpu_addr);
> +		dev = dev->parent ? dev->parent : dev;
> +		dev = dev->parent ? dev->parent : dev;
> +		dma_free_coherent(dev, size, cpu_addr, dma_handle);
> +		return;
> +	}
> +	kfree(cpu_addr);
> +}
> +
>  static inline bool use_multiport(struct ports_device *portdev)
>  {
>  	/*
> @@ -334,20 +382,22 @@ static inline bool use_multiport(struct ports_device *portdev)
>  	return portdev->vdev->features[0] & (1 << VIRTIO_CONSOLE_F_MULTIPORT);
>  }
>  
> -static void free_buf(struct port_buffer *buf)
> +static void
> +free_buf(struct virtqueue *vq, struct port_buffer *buf, size_t buf_size)
>  {
> -	kfree(buf->buf);
> +	free_databuf(vq->vdev, buf_size, buf->buf);
>  	kfree(buf);
>  }
>  
> -static struct port_buffer *alloc_buf(size_t buf_size)
> +static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size)
>  {
>  	struct port_buffer *buf;
>  
>  	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
>  	if (!buf)
>  		goto fail;
> -	buf->buf = kzalloc(buf_size, GFP_KERNEL);
> +	buf->buf = alloc_databuf(vq->vdev, buf_size, GFP_KERNEL);
> +	memset(buf->buf, 0, buf_size);
>  	if (!buf->buf)
>  		goto free_buf;
>  	buf->len = 0;
> @@ -414,7 +464,7 @@ static void discard_port_data(struct port *port)
>  		port->stats.bytes_discarded += buf->len - buf->offset;
>  		if (add_inbuf(port->in_vq, buf) < 0) {
>  			err++;
> -			free_buf(buf);
> +			free_buf(port->in_vq, buf, PAGE_SIZE);
>  		}
>  		port->inbuf = NULL;
>  		buf = get_inbuf(port);
> @@ -485,7 +535,7 @@ static void reclaim_consumed_buffers(struct port *port)
>  		return;
>  	}
>  	while ((buf = virtqueue_get_buf(port->out_vq, &len))) {
> -		kfree(buf);
> +		free_databuf(port->portdev->vdev, PAGE_SIZE, buf);
>  		port->outvq_full = false;
>  	}
>  }
> @@ -672,6 +722,8 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
>  	char *buf;
>  	ssize_t ret;
>  	bool nonblock;
> +	struct virtio_device *vdev;
> +	size_t buf_size;
>  
>  	/* Userspace could be out to fool us */
>  	if (!count)
> @@ -694,9 +746,16 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
>  	if (!port->guest_connected)
>  		return -ENODEV;
>  
> -	count = min((size_t)(32 * 1024), count);
> +	vdev = port->portdev->vdev;
> +
> +	if (is_rproc_serial(vdev)) {
> +		count = min((size_t)PAGE_SIZE, count);
> +		buf_size = PAGE_SIZE;
> +	} else
> +		buf_size = count = min((size_t)(32 * 1024), count);
> +
> +	buf = alloc_databuf(vdev, buf_size, GFP_KERNEL);
>  
> -	buf = kmalloc(count, GFP_KERNEL);
>  	if (!buf)
>  		return -ENOMEM;
>  
> @@ -720,7 +779,7 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
>  		goto out;
>  
>  free_buf:
> -	kfree(buf);
> +	free_databuf(vdev, buf_size, buf);
>  out:
>  	return ret;
>  }
> @@ -767,6 +826,7 @@ static int port_fops_release(struct inode *inode, struct file *filp)
>  	spin_unlock_irq(&port->inbuf_lock);
>  
>  	spin_lock_irq(&port->outvq_lock);
> +
>  	reclaim_consumed_buffers(port);
>  	spin_unlock_irq(&port->outvq_lock);
>  
> @@ -918,7 +978,8 @@ static void resize_console(struct port *port)
>  		return;
>  
>  	vdev = port->portdev->vdev;
> -	if (virtio_has_feature(vdev, VIRTIO_CONSOLE_F_SIZE))
> +	if (!is_rproc_serial(vdev) &&
> +	    virtio_has_feature(vdev, VIRTIO_CONSOLE_F_SIZE))
>  		hvc_resize(port->cons.hvc, port->cons.ws);
>  }
>  
> @@ -1102,7 +1163,7 @@ static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
>  
>  	nr_added_bufs = 0;
>  	do {
> -		buf = alloc_buf(PAGE_SIZE);
> +		buf = alloc_buf(vq, PAGE_SIZE);
>  		if (!buf)
>  			break;
>  
> @@ -1110,7 +1171,7 @@ static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
>  		ret = add_inbuf(vq, buf);
>  		if (ret < 0) {
>  			spin_unlock_irq(lock);
> -			free_buf(buf);
> +			free_buf(vq, buf, PAGE_SIZE);
>  			break;
>  		}
>  		nr_added_bufs++;
> @@ -1198,10 +1259,18 @@ static int add_port(struct ports_device *portdev, u32 id)
>  		goto free_device;
>  	}
>  
> -	/*
> -	 * If we're not using multiport support, this has to be a console port
> -	 */
> -	if (!use_multiport(port->portdev)) {
> +	if (is_rproc_serial(port->portdev->vdev))
> +		/*
> +		 * For rproc_serial assume remote processor is connected.
> +		 * rproc_serial does not want the console port, but
> +		 * the generic port implementation.
> +		 */
> +		port->host_connected = true;
> +	else if (!use_multiport(port->portdev)) {
> +		/*
> +		 * If we're not using multiport support,
> +		 * this has to be a console port.
> +		 */
>  		err = init_port_console(port);
>  		if (err)
>  			goto free_inbufs;
> @@ -1234,7 +1303,7 @@ static int add_port(struct ports_device *portdev, u32 id)
>  
>  free_inbufs:
>  	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
> -		free_buf(buf);
> +		free_buf(port->in_vq, buf, PAGE_SIZE);
>  free_device:
>  	device_destroy(pdrvdata.class, port->dev->devt);
>  free_cdev:
> @@ -1276,7 +1345,18 @@ static void remove_port_data(struct port *port)
>  
>  	/* Remove buffers we queued up for the Host to send us data in. */
>  	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
> -		free_buf(buf);
> +		free_buf(port->in_vq, buf, PAGE_SIZE);
> +
> +	/*
> +	 * Remove buffers from out queue for rproc-serial. We cannot afford
> +	 * to leak any DMA mem, so reclaim this memory even if this might be
> +	 * racy for the remote processor.
> +	 */
> +	if (is_rproc_serial(port->portdev->vdev)) {
> +		while ((buf = virtqueue_detach_unused_buf(port->out_vq)))
> +			free_databuf(port->portdev->vdev, PAGE_SIZE, buf);
> +	}
> +
>  }
>  
>  /*
> @@ -1478,7 +1558,7 @@ static void control_work_handler(struct work_struct *work)
>  		if (add_inbuf(portdev->c_ivq, buf) < 0) {
>  			dev_warn(&portdev->vdev->dev,
>  				 "Error adding buffer to queue\n");
> -			free_buf(buf);
> +			free_buf(portdev->c_ivq, buf, PAGE_SIZE);
>  		}
>  	}
>  	spin_unlock(&portdev->cvq_lock);
> @@ -1674,10 +1754,10 @@ static void remove_controlq_data(struct ports_device *portdev)
>  		return;
>  
>  	while ((buf = virtqueue_get_buf(portdev->c_ivq, &len)))
> -		free_buf(buf);
> +		free_buf(portdev->c_ivq, buf, PAGE_SIZE);
>  
>  	while ((buf = virtqueue_detach_unused_buf(portdev->c_ivq)))
> -		free_buf(buf);
> +		free_buf(portdev->c_ivq, buf, PAGE_SIZE);
>  }
>  
>  /*
> @@ -1688,7 +1768,7 @@ static void remove_controlq_data(struct ports_device *portdev)
>   * config space to see how many ports the host has spawned.  We
>   * initialize each port found.
>   */
> -static int __devinit virtcons_probe(struct virtio_device *vdev)
> +static int virtcons_probe(struct virtio_device *vdev)
>  {
>  	struct ports_device *portdev;
>  	int err;
> @@ -1724,10 +1804,12 @@ static int __devinit virtcons_probe(struct virtio_device *vdev)
>  
>  	multiport = false;
>  	portdev->config.max_nr_ports = 1;
> -	if (virtio_config_val(vdev, VIRTIO_CONSOLE_F_MULTIPORT,
> -			      offsetof(struct virtio_console_config,
> -				       max_nr_ports),
> -			      &portdev->config.max_nr_ports) == 0)
> +	if (is_rproc_serial(vdev))
> +		multiport = false;
> +	else if (virtio_config_val(vdev, VIRTIO_CONSOLE_F_MULTIPORT,
> +				  offsetof(struct virtio_console_config,
> +					   max_nr_ports),
> +				  &portdev->config.max_nr_ports) == 0)
>  		multiport = true;
>  
>  	err = init_vqs(portdev);
> @@ -1838,6 +1920,16 @@ static unsigned int features[] = {
>  	VIRTIO_CONSOLE_F_MULTIPORT,
>  };
>  
> +static struct virtio_device_id rproc_serial_id_table[] = {
> +#if IS_ENABLED(CONFIG_REMOTEPROC)
> +	{ VIRTIO_ID_RPROC_SERIAL, VIRTIO_DEV_ANY_ID },
> +#endif
> +	{ 0 },
> +};
> +
> +static unsigned int rproc_serial_features[] = {
> +};
> +
>  #ifdef CONFIG_PM
>  static int virtcons_freeze(struct virtio_device *vdev)
>  {
> @@ -1922,6 +2014,16 @@ static struct virtio_driver virtio_console = {
>  #endif
>  };
>  
> +static struct virtio_driver virtio_rproc_serial = {
> +	.feature_table = rproc_serial_features,
> +	.feature_table_size = ARRAY_SIZE(rproc_serial_features),
> +	.driver.name =	"virtio_rproc_serial",
> +	.driver.owner =	THIS_MODULE,
> +	.id_table =	rproc_serial_id_table,
> +	.probe =	virtcons_probe,
> +	.remove =	virtcons_remove,
> +};
> +
>  static int __init init(void)
>  {
>  	int err;
> @@ -1941,12 +2043,16 @@ static int __init init(void)
>  	INIT_LIST_HEAD(&pdrvdata.consoles);
>  	INIT_LIST_HEAD(&pdrvdata.portdevs);
>  
> -	return register_virtio_driver(&virtio_console);
> +	err = register_virtio_driver(&virtio_console);
> +	if (err)
> +		return err;
> +	return register_virtio_driver(&virtio_rproc_serial);
>  }
>  
>  static void __exit fini(void)
>  {
>  	unregister_virtio_driver(&virtio_console);
> +	unregister_virtio_driver(&virtio_rproc_serial);
>  
>  	class_destroy(pdrvdata.class);
>  	if (pdrvdata.debugfs_dir)
> diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
> index 270fb22..07cf6f7 100644
> --- a/include/linux/virtio_ids.h
> +++ b/include/linux/virtio_ids.h
> @@ -37,5 +37,6 @@
>  #define VIRTIO_ID_RPMSG		7 /* virtio remote processor messaging */
>  #define VIRTIO_ID_SCSI		8 /* virtio scsi */
>  #define VIRTIO_ID_9P		9 /* 9p virtio console */
> +#define VIRTIO_ID_RPROC_SERIAL	0xB /* virtio remoteproc serial link */
>  
>  #endif /* _LINUX_VIRTIO_IDS_H */
> -- 
> 1.7.9.5
