Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab1K3BRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 20:17:37 -0500
Received: from mgw1.apollo.lv ([80.232.168.216]:42475 "EHLO mgw1.apollo.lv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757072Ab1K3BRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 20:17:36 -0500
X-Greylist: delayed 771 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Nov 2011 20:17:35 EST
Date: Wed, 30 Nov 2011 03:04:39 +0200
From: JohnLM <johnlm@apollo.lv>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: gregkh@suse.de, linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:iio: Use kcalloc instead of kzalloc to allocate
 array
Message-ID: <20111130030439.28bf426f@isg005>
In-Reply-To: <1322600880.1534.334.camel@localhost.localdomain>
References: <1322600880.1534.334.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011 22:08:00 +0100
Thomas Meyer <thomas@m3y3r.de> wrote:

> The advantage of kcalloc is, that will prevent integer overflows
> which could result from the multiplication of number of elements and
> size and it is also a bit nicer to read.

I wish to note that in virtually all cases anything that will
cause integer overflow in size is infeasible to be allocated at all.
On other hand benfit of kcalloc() would be that is such case the
allocation would be avoided at all instead of possible allocation wrong
sized array (due to overflow) potentially resulting in memory leak.
But that shouldn't be relied on and IMO good code should do checks to
avoid calling any alloc() with bad arguments.
Other way of saying this is... don't expect that allocation success
gives you a good array if you didn't check your arguments (undefined
behaviour).

As for code readability... no question about it, that alone may be
sufficient for the patch.

> 
> The semantic patch that makes this change is available
> in https://lkml.org/lkml/2011/11/25/107
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/staging/iio/accel/lis3l02dq_ring.c
> b/drivers/staging/iio/accel/lis3l02dq_ring.c ---
> a/drivers/staging/iio/accel/lis3l02dq_ring.c 2011-11-13
> 11:07:47.933826988 +0100 +++
> b/drivers/staging/iio/accel/lis3l02dq_ring.c 2011-11-28
> 20:00:44.704446880 +0100 @@ -93,8 +93,7 @@ static int
> lis3l02dq_read_all(struct iio struct spi_message msg; int ret, i, j =
> 0; 
> -	xfers = kzalloc((buffer->scan_count) * 2
> -			* sizeof(*xfers), GFP_KERNEL);
> +	xfers = kcalloc((buffer->scan_count) * 2, sizeof(*xfers),
> GFP_KERNEL); if (!xfers)
>  		return -ENOMEM;
>  
> diff -u -p a/drivers/staging/iio/adc/ad7280a.c
> b/drivers/staging/iio/adc/ad7280a.c ---
> a/drivers/staging/iio/adc/ad7280a.c 2011-11-13 11:07:47.940493760
> +0100 +++ b/drivers/staging/iio/adc/ad7280a.c 2011-11-28
> 20:00:45.707793964 +0100 @@ -487,8 +487,8 @@ static int
> ad7280_channel_init(struct ad { int dev, ch, cnt;
>  
> -	st->channels = kzalloc(sizeof(*st->channels) *
> -				((st->slave_num + 1) * 12 + 2),
> GFP_KERNEL);
> +	st->channels = kcalloc((st->slave_num + 1) * 12 + 2,
> +			       sizeof(*st->channels), GFP_KERNEL);
>  	if (st->channels == NULL)
>  		return -ENOMEM;
>  
> @@ -682,7 +682,7 @@ static irqreturn_t ad7280_event_handler(
>  	unsigned *channels;
>  	int i, ret;
>  
> -	channels = kzalloc(sizeof(*channels) * st->scan_cnt,
> GFP_KERNEL);
> +	channels = kcalloc(st->scan_cnt, sizeof(*channels),
> GFP_KERNEL); if (channels == NULL)
>  		return IRQ_HANDLED;
>  
> diff -u -p a/drivers/staging/iio/meter/ade7758_core.c
> b/drivers/staging/iio/meter/ade7758_core.c ---
> a/drivers/staging/iio/meter/ade7758_core.c 2011-11-13
> 11:07:48.030495178 +0100 +++
> b/drivers/staging/iio/meter/ade7758_core.c 2011-11-28
> 20:00:42.151078595 +0100 @@ -746,12 +746,12 @@ static int __devinit
> ade7758_probe(struc spi_set_drvdata(spi, indio_dev); /* Allocate the
> comms buffers */
> -	st->rx = kzalloc(sizeof(*st->rx)*ADE7758_MAX_RX, GFP_KERNEL);
> +	st->rx = kcalloc(ADE7758_MAX_RX, sizeof(*st->rx),
> GFP_KERNEL); if (st->rx == NULL) {
>  		ret = -ENOMEM;
>  		goto error_free_dev;
>  	}
> -	st->tx = kzalloc(sizeof(*st->tx)*ADE7758_MAX_TX, GFP_KERNEL);
> +	st->tx = kcalloc(ADE7758_MAX_TX, sizeof(*st->tx),
> GFP_KERNEL); if (st->tx == NULL) {
>  		ret = -ENOMEM;
>  		goto error_free_rx;
> diff -u -p a/drivers/staging/iio/iio_simple_dummy.c
> b/drivers/staging/iio/iio_simple_dummy.c ---
> a/drivers/staging/iio/iio_simple_dummy.c 2011-11-13
> 11:07:48.023828408 +0100 +++ b/drivers/staging/iio/iio_simple_dummy.c
> 2011-11-28 20:00:47.407817284 +0100 @@ -514,7 +514,8 @@ static __init
> int iio_dummy_init(void) return -EINVAL; }
>  	/* Fake a bus */
> -	iio_dummy_devs = kzalloc(sizeof(*iio_dummy_devs)*instances,
> GFP_KERNEL);
> +	iio_dummy_devs = kcalloc(instances, sizeof(*iio_dummy_devs),
> +				 GFP_KERNEL);
>  	/* Here we have no actual device so call probe */
>  	for (i = 0; i < instances; i++) {
>  		ret = iio_dummy_probe(i);
> diff -u -p a/drivers/staging/iio/industrialio-buffer.c
> b/drivers/staging/iio/industrialio-buffer.c ---
> a/drivers/staging/iio/industrialio-buffer.c 2011-11-13
> 11:07:48.023828408 +0100 +++
> b/drivers/staging/iio/industrialio-buffer.c 2011-11-28
> 20:00:42.931089264 +0100 @@ -313,10 +313,9 @@ int
> iio_buffer_register(struct iio_dev * attrcount += ret; } if
> (indio_dev->masklength && buffer->scan_mask == NULL) {
> -			buffer->scan_mask
> -				= kzalloc(sizeof(*buffer->scan_mask)*
> -
> BITS_TO_LONGS(indio_dev->masklength),
> -					  GFP_KERNEL);
> +			buffer->scan_mask =
> kcalloc(BITS_TO_LONGS(indio_dev->masklength),
> +
> sizeof(*buffer->scan_mask),
> +						    GFP_KERNEL);
>  			if (buffer->scan_mask == NULL) {
>  				ret = -ENOMEM;
>  				goto error_cleanup_dynamic;
> @@ -326,10 +325,9 @@ int iio_buffer_register(struct iio_dev *
>  
>  	buffer->scan_el_group.name = iio_scan_elements_group_name;
>  
> -	buffer->scan_el_group.attrs
> -		= kzalloc(sizeof(buffer->scan_el_group.attrs[0])*
> -			  (attrcount + 1),
> -			  GFP_KERNEL);
> +	buffer->scan_el_group.attrs = kcalloc(attrcount + 1,
> +
> sizeof(buffer->scan_el_group.attrs[0]),
> +					      GFP_KERNEL);
>  	if (buffer->scan_el_group.attrs == NULL) {
>  		ret = -ENOMEM;
>  		goto error_free_scan_mask;
> diff -u -p a/drivers/staging/iio/industrialio-core.c
> b/drivers/staging/iio/industrialio-core.c ---
> a/drivers/staging/iio/industrialio-core.c 2011-11-28
> 19:36:47.980114184 +0100 +++
> b/drivers/staging/iio/industrialio-core.c 2011-11-28
> 20:00:41.047730176 +0100 @@ -665,10 +665,9 @@ static int
> iio_device_register_sysfs(str if (indio_dev->name) attrcount++; 
> -	indio_dev->chan_attr_group.attrs
> -		=
> kzalloc(sizeof(indio_dev->chan_attr_group.attrs[0])*
> -			  (attrcount + 1),
> -			  GFP_KERNEL);
> +	indio_dev->chan_attr_group.attrs = kcalloc(attrcount + 1,
> +
> sizeof(indio_dev->chan_attr_group.attrs[0]),
> +						   GFP_KERNEL);
>  	if (indio_dev->chan_attr_group.attrs == NULL) {
>  		ret = -ENOMEM;
>  		goto error_clear_attrs;
> @@ -958,10 +957,9 @@ static int iio_device_register_eventset(
>  	}
>  
>  	indio_dev->event_interface->group.name =
> iio_event_group_name;
> -	indio_dev->event_interface->group.attrs =
> -
> kzalloc(sizeof(indio_dev->event_interface->group.attrs[0])
> -			*(attrcount + 1),
> -			GFP_KERNEL);
> +	indio_dev->event_interface->group.attrs = kcalloc(attrcount
> + 1,
> +
> sizeof(indio_dev->event_interface->group.attrs[0]),
> +
> GFP_KERNEL); if (indio_dev->event_interface->group.attrs == NULL) {
>  		ret = -ENOMEM;
>  		goto error_free_setup_event_lines;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

