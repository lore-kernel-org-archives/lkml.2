Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab2ITKZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:25:22 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:52319 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500Ab2ITKZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:25:19 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: =?utf-8?B?U2p1ciBCcsOmbmRlbGFuZA==?= <sjurbren@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>, Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 20 Sep 2012 12:24:48 +0200
Subject: RE: [PATCHv2] virtio_console: Add support for remoteproc serial
Thread-Topic: [PATCHv2] virtio_console: Add support for remoteproc serial
Thread-Index: Ac2WyMjlvqxLfTe6Q7aKwVkmZiNC/wAMy+xQ
Message-ID: <81C3A93C17462B4BBD7E272753C1057923BD6DF30D@EXDCVYMBSTM005.EQ1STM.local>
References: <1348073458-17592-1-git-send-email-sjur.brandeland@stericsson.com>
 <871uhxplvb.fsf@rustcorp.com.au>
In-Reply-To: <871uhxplvb.fsf@rustcorp.com.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8KAQFad003739

Hi Rusty,

> > +#if IS_ENABLED(CONFIG_REMOTEPROC)
> > +static inline bool is_rproc_serial(struct virtio_device *vdev)
> > +{
> > +	return vdev->id.device == VIRTIO_ID_RPROC_SERIAL;
> > +}
> > +#else
> > +static inline bool is_rproc_serial(struct virtio_device *vdev)
> > +{
> > +	return false;
> > +}
> > +#endif
> 
> I prefer to avoid inline in C files.  The compiler knows, and with
> inline you get no warning if it becomes unused.  Also, const struct
> virtio_device *.

Sure, I'll fix this.

> > +/* Allocate data buffer from DMA memory if requested */
> > +static inline void *
> > +alloc_databuf(struct virtio_device *vdev, size_t size, gfp_t flag)
> > +{
> > +	if (is_rproc_serial(vdev)) {
> > +		dma_addr_t dma;
> > +		struct device *dev = &vdev->dev;
> > +		/*
> > +		 * Allocate DMA memory from ancestors. Finding the ancestor
> > +		 * is a bit quirky when DMA_MEMORY_INCLUDES_CHILDREN is not
> > +		 * implemented.
> > +		 */
> > +		dev = dev->parent ? dev->parent : dev;
> > +		dev = dev->parent ? dev->parent : dev;
> > +		return dma_alloc_coherent(dev, size, &dma, flag);
> 
> Wow, up 2 levels?  Why 2?  What's special about the grandparents?

In remoteproc we have the following hierarchy:
Virtio Device -> Remoteproc Device -> Platform Device
The DMA memory is associated with the Platform Device.
In my case the platform device does dma_declare_coherent_memory()
before registering to the rproc framework. And I need to call
dma_alloc_coherent with the same device reference that originally
did declare the dma memory.

virtio_rpmsg_bus.c does the same thing. When allocating dma
memory is access the parent: dma_alloc_coherent(vdev->dev.parent->parent,...).

As mentioned in the comment, dma-coherent.c does unfortunately
not implement search for devices parent devices with DMA memory
even if the flag DMA_MEMORY_INCLUDES_CHILDREN is set. If this
feature was in place I could have dropped the genealogy research
I have implemented.

> > -static void free_buf(struct port_buffer *buf)
> > +static void
> > +free_buf(struct virtqueue *vq, struct port_buffer *buf, size_t
> buf_size)
> >  {
> 
> Generally prefer to indent buf and buf_size, rather than break at
> free_buf.

Ok, I'll fix this.

> 
> > +	buf = alloc_databuf(vdev, buf_size, GFP_KERNEL);
> >
> > -	buf = kmalloc(count, GFP_KERNEL);
> >  	if (!buf)
> >  		return -ENOMEM;
> 
> This effectively adds a blank line between "buf = ..." and "if (!buf)",
> but they're adjacent because they're logically grouped.

Agree, thanks.

> 
> > @@ -767,6 +826,7 @@ static int port_fops_release(struct inode *inode,
> struct file *filp)
> >  	spin_unlock_irq(&port->inbuf_lock);
> >
> >  	spin_lock_irq(&port->outvq_lock);
> > +
> >  	reclaim_consumed_buffers(port);
> >  	spin_unlock_irq(&port->outvq_lock);
> >
> 
> Weird whitespace addition.  I know you're doing that simply to check if
> I'm reading, right?

Of course not - it's just me being space out.

> > @@ -1688,7 +1768,7 @@ static void remove_controlq_data(struct
> ports_device *portdev)
> >   * config space to see how many ports the host has spawned.  We
> >   * initialize each port found.
> >   */
> > -static int __devinit virtcons_probe(struct virtio_device *vdev)
> > +static int virtcons_probe(struct virtio_device *vdev)
> >  {
> >  	struct ports_device *portdev;
> >  	int err;
> 
> Not sure about this change.  If you actually turn off CONFIG_HOTPLUG,
> I wouldn't think that remoteproc would work at all any more, since it
> needs the driver core to match up devices?

Hm, when adding __devinit I get a section mismatch warning in virtio_rproc_serial.
But I guess this is a false positive? I could silence this warning by annotating
virtio_rproc_serial with __refdata.

> > @@ -1724,10 +1804,12 @@ static int __devinit virtcons_probe(struct
> virtio_device *vdev)
> >
> >  	multiport = false;
> >  	portdev->config.max_nr_ports = 1;
> > -	if (virtio_config_val(vdev, VIRTIO_CONSOLE_F_MULTIPORT,
> > -			      offsetof(struct virtio_console_config,
> > -				       max_nr_ports),
> > -			      &portdev->config.max_nr_ports) == 0)
> > +	if (is_rproc_serial(vdev))
> > +		multiport = false;
> > +	else if (virtio_config_val(vdev, VIRTIO_CONSOLE_F_MULTIPORT,
> > +				  offsetof(struct virtio_console_config,
> > +					   max_nr_ports),
> > +				  &portdev->config.max_nr_ports) == 0)
> >  		multiport = true;
> 
> This is a bit weird, to double-assign multiport = false; it looks
> tacked
> on.
> 
> How about:
> 
>         /* Don't test MULTIPORT at all if we're rproc: not a valid
> feature! */
>         if (!is_rproc_serial(vdev)
>              && virtio_config_val(vdev, VIRTIO_CONSOLE_F_MULTIPORT,
> 				  offsetof(struct virtio_console_config,
> 					   max_nr_ports),
> 				  &portdev->config.max_nr_ports) == 0) {
>                 multiport = true;
>         } else {
>                 multiport = false;
>                 portdev->config.max_nr_ports = 1;
>         }

Yes thanks, this looks much better.

> 
> >  	err = init_vqs(portdev);
> > @@ -1838,6 +1920,16 @@ static unsigned int features[] = {
> >  	VIRTIO_CONSOLE_F_MULTIPORT,
> >  };
> >
> > +static struct virtio_device_id rproc_serial_id_table[] = {
> > +#if IS_ENABLED(CONFIG_REMOTEPROC)
> > +	{ VIRTIO_ID_RPROC_SERIAL, VIRTIO_DEV_ANY_ID },
> > +#endif
> > +	{ 0 },
> > +};
> > +
> > +static unsigned int rproc_serial_features[] = {
> > +};
> > +
> >  #ifdef CONFIG_PM
> >  static int virtcons_freeze(struct virtio_device *vdev)
> >  {
> > @@ -1922,6 +2014,16 @@ static struct virtio_driver virtio_console = {
> >  #endif
> >  };
> >
> > +static struct virtio_driver virtio_rproc_serial = {
> > +	.feature_table = rproc_serial_features,
> > +	.feature_table_size = ARRAY_SIZE(rproc_serial_features),
> > +	.driver.name =	"virtio_rproc_serial",
> > +	.driver.owner =	THIS_MODULE,
> > +	.id_table =	rproc_serial_id_table,
> > +	.probe =	virtcons_probe,
> > +	.remove =	virtcons_remove,
> > +};
> > +
> >  static int __init init(void)
> >  {
> >  	int err;
> > @@ -1941,12 +2043,16 @@ static int __init init(void)
> >  	INIT_LIST_HEAD(&pdrvdata.consoles);
> >  	INIT_LIST_HEAD(&pdrvdata.portdevs);
> >
> > -	return register_virtio_driver(&virtio_console);
> > +	err = register_virtio_driver(&virtio_console);
> > +	if (err)
> > +		return err;
> > +	return register_virtio_driver(&virtio_rproc_serial);
> 
> Hmm, we need to cleanup if the second register fails.

Indeed, I'll add this.

> 
> >  #define VIRTIO_ID_RPMSG		7 /* virtio remote processor
> messaging */
> >  #define VIRTIO_ID_SCSI		8 /* virtio scsi */
> >  #define VIRTIO_ID_9P		9 /* 9p virtio console */
> > +#define VIRTIO_ID_RPROC_SERIAL	0xB /* virtio remoteproc serial link
> */
> 
> Prefer decimal here...

Sure,


Thank you for reviewing, I send out a new respin of this patch soon.

Regards,
Sjur
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
