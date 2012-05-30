Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab2E3INv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 04:13:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092Ab2E3INs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 04:13:48 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: stefani@seibold.net
Subject: Re: [PATCH] add new NRP power meter USB device driver
Date: Wed, 30 May 2012 10:10:22 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, gregkh@linuxfoundation.org,
        thomas.braunstorfinger@rohde-schwarz.com
References: <1338318858-24144-1-git-send-email-stefani@seibold.net>
In-Reply-To: <1338318858-24144-1-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205301010.22913.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 29. Mai 2012, 21:14:18 schrieb stefani@seibold.net:
 
> The device will be controlled by a SCPI like interface.

Are there other devices using that standard whose interface you might reuse?
 

> +static ssize_t nrpz_read(struct file *file, char __user *buffer, size_t count,
> +				loff_t *ppos)
> +{
> +	struct usb_nrpz *dev;
> +	int ret;
> +	struct urb *urb;
> +	size_t n;
> +
> +	dev = (struct usb_nrpz *)file->private_data;
> +
> +	/* verify that we actually have some data to read */
> +	if (!count)
> +		return 0;
> +
> +	/* lock the read data */
> +	ret = mutex_lock_interruptible(&dev->read_mutex);
> +	if (ret)
> +		return ret;
> +
> +	for (;;) {
> +		urb = urb_list_get(&dev->read_lock, &dev->in_avail);
> +		if (urb)
> +			break;
> +
> +		if (file->f_flags & O_NONBLOCK) {
> +			ret = -EAGAIN;
> +			goto exit;
> +		}

You should test for device disconnect before that. Otherwise
a nonblocking reader would never learn of the problem. IIRC
the skeleton has been fixed.

> +
> +		ret = wait_event_interruptible(dev->wq,
> +			!list_empty(&dev->in_avail) || !dev->intf);
> +		if (ret) {
> +			ret = -ERESTARTSYS;
> +			goto exit;
> +		}
> +
> +		/* verify that the device wasn't unplugged */
> +		if (!dev->intf) {
> +			ret = -ENODEV;
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

Is there a good reason you don't resubmit in this case?

> +		}
> +	} else
> +		n = urb->status;

You need to translate this to standard error codes
> +
> +	usb_anchor_urb(urb, &dev->in_running);
> +
> +	ret = usb_submit_urb(urb, GFP_KERNEL);
> +	if (ret) {
> +		usb_unanchor_urb(urb);
> +		urb_list_add_tail(&dev->read_lock, urb, &dev->in_avail);
> +		nrpz_err("Failed submitting read urb (error %d)", ret);
> +	}
> +
> +	ret = n;
> +exit:
> +	mutex_unlock(&dev->read_mutex);
> +	return ret;
> +}

> +#define	VRT_RESET_ALL		1
> +#define	VRT_GET_DEVICE_INFO	6
> +#define	VRI_DEVICE_NAME		5
> +
> +static long nrpz_compat_ioctl(struct file *file, unsigned int cmd,
> +		unsigned long arg)
> +{
> +	struct usb_nrpz *dev;
> +	int ret;
> +
> +	dev = (struct usb_nrpz *)file->private_data;
> +
> +	/* verify that the device wasn't unplugged */
> +	if (!dev->intf)
> +		return -ENODEV;

Locking?

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
> +		__put_user(dev->udev->descriptor.bcdDevice,
> +				&sensor_info->bcdDevice);
> +		__put_user(dev->udev->descriptor.bcdUSB,
> +				&sensor_info->bcdUSB);
> +		__put_user(dev->udev->descriptor.bDescriptorType,
> +				&sensor_info->bDescriptorType);
> +		__put_user(dev->udev->descriptor.bDeviceClass,
> +				&sensor_info->bDeviceClass);
> +		__put_user(dev->udev->descriptor.bDeviceSubClass,
> +				&sensor_info->bDeviceSubClass);
> +		__put_user(dev->udev->descriptor.bDeviceProtocol,
> +				&sensor_info->bDeviceProtocol);
> +		__put_user(dev->udev->descriptor.bMaxPacketSize0,
> +				&sensor_info->bMaxPacketSize0);
> +		__put_user(dev->udev->descriptor.bNumConfigurations,
> +				&sensor_info->bNumConfigurations);
> +		__put_user(dev->udev->descriptor.iManufacturer,
> +				&sensor_info->iManufacturer);
> +		__put_user(dev->udev->descriptor.iProduct,
> +				&sensor_info->iProduct);
> +		__put_user(dev->udev->descriptor.iSerialNumber,
> +				&sensor_info->iSerialNumber);
> +		__put_user(dev->udev->descriptor.idVendor,
> +				&sensor_info->vendorId);
> +		__put_user(dev->udev->descriptor.idProduct,
> +				&sensor_info->productId);
> +		usb_string(dev->udev, dev->udev->descriptor.iManufacturer,
> +				(char __force *)sensor_info->manufacturer,
> +				sizeof(sensor_info->manufacturer));
> +		usb_string(dev->udev, dev->udev->descriptor.iProduct,
> +				(char __force *)sensor_info->productName,
> +				sizeof(sensor_info->productName));
> +		usb_string(dev->udev, dev->udev->descriptor.iSerialNumber,
> +				(char __force *)sensor_info->serialNumber,
> +				sizeof(sensor_info->serialNumber));
> +
> +		return 0;
> +	 }
> +	case NRPZ_START:
> +	 {
> +		u8 device_state[128];

DMA on stack. This may ail on some architectures. You need to use
kmalloc() or better kzalloc().

> +		memset(device_state, 0, sizeof(device_state));
> +
> +		ret = usb_control_msg(dev->udev,
> +			usb_rcvctrlpipe(dev->udev, 0),
> +			VRT_GET_DEVICE_INFO,
> +			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			0,
> +			VRI_DEVICE_NAME,
> +			device_state,
> +			sizeof(device_state),
> +			5000);
> +
> +		if (ret < 0)
> +			return ret;
> +
> +		nrpz_dbg("device state:%s", device_state);
> +
> +		if (strncmp(device_state, "Boot ", 5))
> +			return 0;
> +
> +		return usb_control_msg(dev->udev,
> +			usb_sndctrlpipe(dev->udev, 0),
> +			VRT_RESET_ALL,
> +			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			1,
> +			1,
> +			device_state,
> +			sizeof(device_state),
> +			5000);
> +	 }
> +	case NRPZ_WRITE_DONE:

EEEEEEK!

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

This is very ugly. If you need fsync(), then implement it.

> +	case NRPZ_VENDOR_CONTROL_MSG_OUT:
> +	 {
> +		struct nrpz_control_req ncr;

DMA on stack.

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
> +		} else {
> +			size = 0;
> +		}
> +
> +		ret = usb_control_msg(dev->udev,
> +				usb_sndctrlpipe(dev->udev, 0),
> +				ncr.request,
> +				ncr.type,
> +				ncr.value,
> +				ncr.index,
> +				ncr.data,
> +				size,
> +				0);
> +
> +		return ret;
> +	 }
> +	case NRPZ_VENDOR_CONTROL_MSG_IN:
> +	 {
> +		struct nrpz_control_req ncr;

DMA on stack

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
> +		} else {
> +			size = 0;
> +		}
> +
> +		ret = usb_control_msg(dev->udev,
> +				usb_rcvctrlpipe(dev->udev, 0),
> +				ncr.request,
> +				ncr.type,
> +				ncr.value,
> +				ncr.index,
> +				ncr.data,
> +				size,
> +				0);
> +
> +		return ret;
> +	 }
> +	default:
> +		nrpz_err("Invalid ioctl call (%08x)", cmd);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return ret;
> +}

> +static int nrpz_open(struct inode *inode, struct file *file)
> +{
> +	struct usb_nrpz *dev;
> +	int minor;
> +	struct usb_interface *intf;
> +	int ret;
> +	unsigned i;
> +
> +	minor = iminor(inode);
> +
> +	intf = usb_find_interface(&nrpz_driver, minor);
> +	if (!intf) {
> +		nrpz_err("Can not find device for minor %d", minor);
> +		return -ENODEV;
> +	}
> +
> +	dev = usb_get_intfdata(intf);
> +	if (!dev)
> +		return -ENODEV;
> +
> +	if (test_and_set_bit(0, &dev->in_use))
> +		return -EBUSY;
> +
> +	/* increment our usage count for the device */
> +	kref_get(&dev->kref);
> +
> +	/* save our object in the file's private structure */
> +	file->private_data = dev;
> +
> +	INIT_LIST_HEAD(&dev->in_avail);
> +	INIT_LIST_HEAD(&dev->out_avail);
> +
> +	ret = bulks_init(dev,
> +			 dev->in_urbs,
> +			 ARRAY_SIZE(dev->in_urbs),
> +			 usb_rcvbulkpipe(dev->udev, dev->in_epAddr),
> +			 dev->in_size,
> +			 nrpz_read_callback);
> +	if (ret)
> +		goto error;
> +
> +	ret = bulks_init(dev,
> +			 dev->out_urbs,
> +			 ARRAY_SIZE(dev->out_urbs),
> +			 usb_sndbulkpipe(dev->udev, dev->out_epAddr),
> +			 dev->out_size,
> +			 nrpz_write_callback);
> +	if (ret)
> +		goto error;
> +
> +	for (i = 0; i != ARRAY_SIZE(dev->in_urbs); ++i) {
> +		usb_anchor_urb(&dev->in_urbs[i], &dev->in_running);
> +
> +		ret = usb_submit_urb(&dev->in_urbs[i], GFP_KERNEL);

You do this here and only here. So this will see a slow attrition if you don't resubmit for som reason.

> +		if (ret) {
> +			usb_kill_anchored_urbs(&dev->in_running);
> +			goto error;
> +		}
> +	}
> +
> +	for (i = 0; i != ARRAY_SIZE(dev->out_urbs); ++i)
> +		list_add(&dev->out_urbs[i].urb_list, &dev->out_avail);
> +
> +	return 0;
> +error:
> +	clear_bit(0, &dev->in_use);
> +
> +	bulks_release(dev, dev->out_urbs, ARRAY_SIZE(dev->out_urbs),
> +			dev->out_size);
> +	bulks_release(dev, dev->in_urbs, ARRAY_SIZE(dev->in_urbs),
> +			dev->in_size);
> +
> +	return 0;
> +}
> +
> +static int nrpz_release(struct inode *inode, struct file *file)
> +{
> +	struct usb_nrpz *dev;
> +
> +	dev = (struct usb_nrpz *)file->private_data;
> +	if (dev == NULL)
> +		return -ENODEV;
> +
> +	usb_kill_anchored_urbs(&dev->in_running);
> +	usb_kill_anchored_urbs(&dev->out_running);
> +
> +	bulks_release(dev, dev->out_urbs, ARRAY_SIZE(dev->out_urbs),
> +			dev->out_size);
> +	bulks_release(dev, dev->in_urbs, ARRAY_SIZE(dev->in_urbs),
> +			dev->in_size);
> +
> +	/* decrement the count on our device */
> +	kref_put(&dev->kref, nrpz_delete);
> +
> +	clear_bit(0, &dev->in_use);
> +
> +	return 0;
> +}
> +
> +static int nrpz_flush(struct file *file, fl_owner_t id)
> +{
> +	struct usb_nrpz *dev;
> +	int ret;
> +
> +	dev = (struct usb_nrpz *)file->private_data;
> +	if (dev == NULL)
> +		return -ENODEV;
> +
> +	/* lock the write data */
> +	ret = mutex_lock_interruptible(&dev->write_mutex);
> +	if (ret)
> +		return ret;
> +
> +	/* verify that the device wasn't unplugged */
> +	if (!dev->intf) {
> +		ret = -ENODEV;
> +		goto exit;
> +	}
> +
> +	ret = wait_event_interruptible(dev->out_running.wait,
> +				list_empty(&dev->out_running.urb_list));
> +	if (ret) {
> +		ret = -ERESTARTSYS;
> +		goto exit;
> +	}
> +exit:
> +	mutex_unlock(&dev->write_mutex);
> +
> +	return ret;
> +}
> +
> +static unsigned int nrpz_poll(struct file *file, poll_table *wait)
> +{
> +	struct usb_nrpz *dev;
> +	int ret = 0;
> +
> +	dev = (struct usb_nrpz *)file->private_data;
> +
> +	poll_wait(file, &dev->wq, wait);
> +
> +	if (!dev->intf)
> +		ret = POLLIN | POLLOUT | POLLPRI | POLLERR | POLLHUP;
> +	else {
> +		if (!list_empty(&dev->in_avail))
> +			ret |= POLLIN;
> +
> +		if (!list_empty(&dev->out_avail))
> +			ret |= POLLOUT;
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct file_operations nrpz_fops = {
> +	.owner = THIS_MODULE,
> +	.read = nrpz_read,
> +	.write = nrpz_write,
> +	.unlocked_ioctl = nrpz_ioctl,
> +	.compat_ioctl = nrpz_compat_ioctl,
> +	.open = nrpz_open,
> +	.release = nrpz_release,
> +	.flush = nrpz_flush,
> +	.poll = nrpz_poll,
> +	.llseek = noop_llseek,
> +};
> +
> +static struct usb_class_driver nrpz_class = {
> +	.name = "nrpz%d",
> +	.fops = &nrpz_fops,
> +	.minor_base = NRPZ_MINOR_BASE,
> +};
> +
> +static int nrpz_probe(struct usb_interface *intf,
> +			const struct usb_device_id *id)
> +{
> +	int i;
> +	int ret;
> +	struct usb_endpoint_descriptor *endpoint;
> +	struct usb_host_interface *iface_desc;
> +	struct usb_nrpz *dev;
> +
> +	/* allocate memory for our device state and intialize it */
> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +	if (!dev) {
> +		nrpz_err("Out of memory");
> +		return -ENOMEM;
> +	}
> +
> +	ret = -EIO;
> +
> +	init_waitqueue_head(&dev->wq);
> +	kref_init(&dev->kref);
> +
> +	mutex_init(&dev->read_mutex);
> +	mutex_init(&dev->write_mutex);
> +
> +	spin_lock_init(&dev->read_lock);
> +	spin_lock_init(&dev->write_lock);
> +
> +	init_usb_anchor(&dev->in_running);
> +	init_usb_anchor(&dev->out_running);
> +
> +	dev->in_use = 0;
> +	dev->udev = usb_get_dev(interface_to_usbdev(intf));
> +	dev->intf = intf;
> +
> +	/* set up the endpoint information */
> +	/* check out the endpoints */
> +	iface_desc = intf->cur_altsetting;
> +	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
> +		endpoint = &iface_desc->endpoint[i].desc;
> +
> +		if (!dev->in_epAddr && usb_endpoint_is_bulk_in(endpoint)) {
> +			/* we found a bulk in endpoint */
> +			dev->in_size = le16_to_cpu(endpoint->wMaxPacketSize);
> +			dev->in_epAddr = endpoint->bEndpointAddress;
> +		} else
> +		if (!dev->out_epAddr && usb_endpoint_is_bulk_out(endpoint)) {
> +			/* we found a bulk out endpoint */
> +			dev->out_size = le16_to_cpu(endpoint->wMaxPacketSize);
> +			dev->out_epAddr = endpoint->bEndpointAddress;
> +		}
> +	}
> +	if (!(dev->in_epAddr && dev->out_epAddr)) {
> +		nrpz_err("Could not find both bulk in and out endpoints");
> +		goto error;
> +	}
> +
> +	usb_set_intfdata(intf, dev);
> +
> +	ret = usb_register_dev(intf, &nrpz_class);
> +	if (ret) {
> +		nrpz_err("Not able to get a minor for this device\n");
> +		goto error;
> +	}
> +
> +	dev->minor = intf->minor - NRPZ_MINOR_BASE;
> +
> +	/* let the user know what node this device is now attached to */
> +	nrpz_info("Device now attached to USB nrpz%u", dev->minor);
> +
> +	return 0;
> +error:
> +	usb_set_intfdata(intf, NULL);
> +	nrpz_delete(&dev->kref);
> +	return ret;
> +}
> +
> +static void nrpz_disconnect(struct usb_interface *intf)
> +{
> +	struct usb_nrpz *dev;
> +	unsigned minor;
> +
> +	dev = usb_get_intfdata(intf);
> +	usb_set_intfdata(intf, NULL);
> +
> +	minor = dev->minor;
> +
> +	/* give back our minor */
> +	usb_deregister_dev(intf, &nrpz_class);
> +
> +	/* prevent more I/O from starting */
> +	dev->intf = NULL;
> +
> +	usb_kill_anchored_urbs(&dev->in_running);
> +	usb_kill_anchored_urbs(&dev->out_running);
> +
> +	wake_up_all(&dev->wq);
> +
> +	/* decrement our usage count */
> +	kref_put(&dev->kref, nrpz_delete);
> +
> +	nrpz_info("nrpz%u now disconnected", minor);
> +}
> +
> +static void nrpz_draw_down(struct usb_nrpz *dev)
> +{
> +	int time;
> +
> +	time = usb_wait_anchor_empty_timeout(&dev->out_running, 1000);
> +	if (!time)
> +		usb_kill_anchored_urbs(&dev->out_running);
> +
> +	usb_kill_anchored_urbs(&dev->in_running);
> +}
> +
> +static int nrpz_suspend(struct usb_interface *intf, pm_message_t message)
> +{
> +	struct usb_nrpz *dev = usb_get_intfdata(intf);
> +
> +	if (dev)
> +		nrpz_draw_down(dev);
> +	return 0;
> +}
> +
> +static int nrpz_resume(struct usb_interface *intf)
> +{
> +	return 0;
> +}

And what restarts reading?

> +
> +static int nrpz_pre_reset(struct usb_interface *intf)
> +{
> +	struct usb_nrpz *dev = usb_get_intfdata(intf);
> +
> +	if (dev)
> +		nrpz_draw_down(dev);
> +	return 0;
> +}
> +
> +static int nrpz_post_reset(struct usb_interface *intf)
> +{
> +	return 0;
> +}

And you don't tell user space that the device has been reset?
And what restarts reading?

	Regards
		Oliver
