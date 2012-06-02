Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945Ab2FBU1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 16:27:43 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:58382 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258Ab2FBU1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 16:27:42 -0400
From: Oliver Neukum <oliver@neukum.org>
To: stefani@seibold.net
Subject: Re: [PATCH] add new NRP power meter USB device driver
Date: Sat, 2 Jun 2012 22:24:21 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, thomas.braunstorfinger@rohde-schwarz.com
References: <1338653939-2090-1-git-send-email-stefani@seibold.net>
In-Reply-To: <1338653939-2090-1-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206022224.21443.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 2. Juni 2012, 18:18:59 schrieb stefani@seibold.net:
> From: Stefani Seibold <stefani@seibold.net>
> 
> This driver supports all of the Rohde&Schwarz RF Power Meter NRP Sensors. These
> sensors are intelligent standalone instruments that communicate via USB.

Hi,

I am commenting here only on the code as such, not on whether it should be
included.


> +static int bulks_init(struct usb_nrpz *dev,
> +		struct usb_device *udev,
> +		struct urb *urb,
> +		unsigned n,
> +		unsigned int pipe,
> +		int buf_size,
> +		usb_complete_t complete_fn)
> +{
> +	void *buffer;
> +
> +	while (n--) {
> +		usb_init_urb(urb);
> +
> +		buffer = usb_alloc_coherent(udev,
> +				buf_size,
> +				GFP_KERNEL,
> +				&urb->transfer_dma);
> +		if (!buffer)
> +			return -ENOMEM;
> +
> +		/* set up our read urb */
> +		usb_fill_bulk_urb(urb,
> +			udev,
> +			pipe,
> +			buffer,
> +			buf_size,
> +			complete_fn,
> +			dev);
> +
> +		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;

I'd prefer |= in case the fill macros set a flag.

> +
> +		++urb;
> +	}
> +	return 0;
> +}
> +
> +static int bulks_in_submit(struct usb_nrpz *dev)
> +{
> +	int ret;
> +	unsigned i;
> +
> +	for (i = 0; i != ARRAY_SIZE(dev->in_urbs); ++i) {
> +		usb_anchor_urb(&dev->in_urbs[i], &dev->in_running);
> +
> +		ret = usb_submit_urb(&dev->in_urbs[i], GFP_KERNEL);
> +		if (ret) {
> +			usb_kill_anchored_urbs(&dev->in_running);
> +			return ret;
> +		}
> +	}
> +	return 0;
> +}

This is used in the resume code path. During resume you
cannot swap, as the swap device may still be asleep.
Therefore GFP_NOIO should be used. It's considered
best practice to pass the gfp parameter to such methods.

> +static ssize_t nrpz_read(struct file *file, char __user *buffer, size_t count,
> +				loff_t *ppos)
> +{
> +	struct usb_nrpz *dev = file->private_data;
> +	int ret;
> +	struct urb *urb;
> +	size_t n;
> +
> +	/* verify that we actually have some data to read */
> +	if (!count)
> +		return 0;
> +
> +	/* lock the read data */
> +	if (file->f_flags & O_NONBLOCK) {
> +		if (!mutex_trylock(&dev->read_mutex))
> +			return -EAGAIN;

Congratulations. I overlooked this. Does skeleton do it right?

> +	} else {
> +		ret = mutex_lock_interruptible(&dev->read_mutex);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	for (;;) {
> +		urb = urb_list_get(&dev->read_lock, &dev->in_avail);
> +		if (urb)
> +			break;
> +
> +		/* verify that the device wasn't unplugged */
> +		if (!dev->connected) {
> +			ret = -ENODEV;
> +			goto exit;
> +		}
> +
> +		if (file->f_flags & O_NONBLOCK) {
> +			ret = -EAGAIN;
> +			goto exit;
> +		}
> +
> +		ret = wait_event_interruptible(dev->wq,
> +			!list_empty(&dev->in_avail) || !dev->connected);
> +		if (ret) {
> +			ret = -ERESTARTSYS;
> +			goto exit;
> +		}
> +	}
> +
> +	if (!urb->status) {
> +		n = min(count, urb->actual_length);
> +
> +		if (copy_to_user(buffer, urb->transfer_buffer, n)) {
> +			urb_list_add(&dev->read_lock, urb, &dev->in_avail);
> +			ret = -EFAULT;
> +			goto exit;
> +		}
> +	} else {
> +		n = -EPIPE;
> +	}
> +
> +	usb_anchor_urb(urb, &dev->in_running);
> +
> +	ret = usb_submit_urb(urb, GFP_KERNEL);
> +	if (ret) {
> +		usb_unanchor_urb(urb);
> +		urb_list_add_tail(&dev->read_lock, urb, &dev->in_avail);
> +		urb->status = ret;

That is a bug. You will report that error the next time the URB comes up.
That's wrong. I think you need a special error code that will cause you
to just resubmit the URB and go for the next URB.

> +		dev_err(&urb->dev->dev,
> +			"Failed submitting read urb (error %d)", ret);
> +	}
> +
> +	ret = n;
> +exit:
> +	mutex_unlock(&dev->read_mutex);
> +	return ret;
> +}

> +static long nrpz_compat_ioctl(struct file *file, unsigned int cmd,
> +		unsigned long arg)
> +{
> +	struct usb_nrpz *dev = file->private_data;
> +	struct usb_interface *intf = dev->intf;
> +	struct usb_device *udev;
> +	int ret;
> +
> +	/* verify that the device wasn't unplugged */
> +	if (!dev->connected)
> +		return -ENODEV;
> +
> +	udev = interface_to_usbdev(intf);
> +
> +	switch (cmd) {
> +	case NRPZ_GETSENSORINFO:
> +	 {
> +		struct nrpz_sensor_info __user *sensor_info =
> +			(struct nrpz_sensor_info __user *)arg;
> +
> +		if (!access_ok(VERIFY_WRITE, sensor_info, sizeof(*sensor_info)))
> +			return -EFAULT;
> +
> +		__put_user(udev->descriptor.bcdDevice,
> +				&sensor_info->bcdDevice);
> +		__put_user(udev->descriptor.bcdUSB,
> +				&sensor_info->bcdUSB);
> +		__put_user(udev->descriptor.bDescriptorType,
> +				&sensor_info->bDescriptorType);
> +		__put_user(udev->descriptor.bDeviceClass,
> +				&sensor_info->bDeviceClass);
> +		__put_user(udev->descriptor.bDeviceSubClass,
> +				&sensor_info->bDeviceSubClass);
> +		__put_user(udev->descriptor.bDeviceProtocol,
> +				&sensor_info->bDeviceProtocol);
> +		__put_user(udev->descriptor.bMaxPacketSize0,
> +				&sensor_info->bMaxPacketSize0);
> +		__put_user(udev->descriptor.bNumConfigurations,
> +				&sensor_info->bNumConfigurations);
> +		__put_user(udev->descriptor.iManufacturer,
> +				&sensor_info->iManufacturer);
> +		__put_user(udev->descriptor.iProduct,
> +				&sensor_info->iProduct);
> +		__put_user(udev->descriptor.iSerialNumber,
> +				&sensor_info->iSerialNumber);
> +		__put_user(udev->descriptor.idVendor,
> +				&sensor_info->vendorId);
> +		__put_user(udev->descriptor.idProduct,
> +				&sensor_info->productId);
> +		usb_string(udev, udev->descriptor.iManufacturer,
> +				(char __force *)sensor_info->manufacturer,
> +				sizeof(sensor_info->manufacturer));
> +		usb_string(udev, udev->descriptor.iProduct,
> +				(char __force *)sensor_info->productName,
> +				sizeof(sensor_info->productName));
> +		usb_string(udev, udev->descriptor.iSerialNumber,
> +				(char __force *)sensor_info->serialNumber,
> +				sizeof(sensor_info->serialNumber));
> +
> +		return 0;
> +	 }
> +	case NRPZ_START:
> +	 {
> +		u8 *device_state;
> +
> +		device_state = kzalloc(DEVICE_STATE_SIZE, GFP_KERNEL | GFP_DMA);

I apologize for misleading naming in the MM code. GFP_DMA goes back
to the time the ISA bus was alive and kicking. GFP_DMA means memory
that you can do DMA with with the old PC_AT ISA DMA controller. For USB
just GFP_KERNEL will do.

> +		ret = usb_control_msg(udev,
> +			usb_rcvctrlpipe(udev, 0),
> +			VRT_GET_DEVICE_INFO,
> +			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			0,
> +			VRI_DEVICE_NAME,
> +			device_state,
> +			DEVICE_STATE_SIZE,
> +			5000);
> +
> +		if (ret < 0)
> +			goto done;
> +
> +		dev_dbg(&intf->dev,
> +			"device state:%s", device_state);
> +
> +		if (strncmp(device_state, "Boot ", 5)) {
> +			ret = 0;
> +			goto done;
> +		}
> +
> +		ret = usb_control_msg(udev,
> +			usb_sndctrlpipe(udev, 0),
> +			VRT_RESET_ALL,
> +			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			1,
> +			1,
> +			device_state,
> +			sizeof(device_state),
> +			5000);
> +done:
> +		kfree(device_state);
> +		return ret;
> +	 }
> +	case NRPZ_WRITE_DONE:
> +		if (arg) {
> +			ret = wait_event_interruptible_timeout(
> +				dev->out_running.wait,
> +				list_empty(&dev->out_running.urb_list),
> +				msecs_to_jiffies(arg));
> +			if (!ret)
> +				return -ETIMEDOUT;
> +			if (ret < 0)
> +				return ret;
> +			return 0;
> +		} else {
> +			return wait_event_interruptible(
> +				dev->out_running.wait,
> +				list_empty(&dev->out_running.urb_list));
> +		}
> +		break;
> +	case NRPZ_VENDOR_CONTROL_MSG_OUT:
> +	 {
> +		struct nrpz_control_req ncr;
> +		u8 *data;
> +		u16 size;
> +
> +		if (copy_from_user(&ncr, (struct nrpz_control_req __user *)arg, sizeof(ncr)))
> +			return -EFAULT;
> +
> +		if (ncr.data) {
> +			size = ncr.size;
> +
> +			if (!access_ok(VERIFY_READ, (void __user *)ncr.data, size))
> +				return -EFAULT;
> +
> +			data = kzalloc(size, GFP_KERNEL | GFP_DMA);
> +			if (!data)
> +				return -ENOMEM;
> +
> +			memcpy(data, ncr.data, size);
> +		} else {
> +			size = 0;
> +			data = NULL;
> +		}
> +
> +		ret = usb_control_msg(udev,
> +				usb_sndctrlpipe(udev, 0),
> +				ncr.request,
> +				ncr.type,
> +				ncr.value,
> +				ncr.index,
> +				data,
> +				size,
> +				0);
> +
> +
> +		kfree(data);
> +
> +		return ret;
> +	 }
> +	case NRPZ_VENDOR_CONTROL_MSG_IN:
> +	 {
> +		struct nrpz_control_req ncr;
> +		u8 *data;
> +		u16 size;
> +
> +		if (copy_from_user(&ncr, (struct nrpz_control_req __user *)arg, sizeof(ncr)))
> +			return -EFAULT;
> +
> +		if (ncr.data) {
> +			size = ncr.size;
> +
> +			if (!access_ok(VERIFY_WRITE, (void __user *)ncr.data, size))
> +				return -EFAULT;
> +
> +			data = kzalloc(size, GFP_KERNEL | GFP_DMA);
> +			if (!data)
> +				return -ENOMEM;
> +		} else {
> +			size = 0;
> +			data = NULL;
> +		}
> +
> +		ret = usb_control_msg(udev,
> +				usb_rcvctrlpipe(udev, 0),
> +				ncr.request,
> +				ncr.type,
> +				ncr.value,
> +				ncr.index,
> +				data,
> +				size,
> +				0);
> +
> +		if (data) {
> +			memcpy(ncr.data, data, size);
> +			kfree(data);
> +		}
> +
> +		return ret;
> +	 }
> +	default:
> +		dev_dbg(&intf->dev,
> +			"Invalid ioctl call (%08x)", cmd);
> +		return -ENOTTY;
> +	}
> +
> +	return ret;
> +}

> +static int nrpz_release(struct inode *inode, struct file *file)
> +{
> +	struct usb_nrpz *dev = file->private_data;
> +
> +	if (dev == NULL)
> +		return -ENODEV;
> +
> +	usb_kill_anchored_urbs(&dev->in_running);
> +	usb_kill_anchored_urbs(&dev->out_running);

Isn't this a noop as you've implemented flush() ?

> +
> +	bulks_release(dev->out_urbs, ARRAY_SIZE(dev->out_urbs), dev->out_size);
> +	bulks_release(dev->in_urbs, ARRAY_SIZE(dev->in_urbs), dev->in_size);
> +
> +	/* decrement the count on our device */
> +	kref_put(&dev->kref, nrpz_delete);
> +
> +	spin_lock_irq(&dev->read_lock);
> +	dev->in_use = false;
> +	spin_unlock_irq(&dev->read_lock);

Looks like a use after free. You should drop the reference as the very
last thing.

> +
> +	return 0;
> +}
> +

	HTH
		Oliver
