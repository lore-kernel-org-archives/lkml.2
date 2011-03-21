Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1CURM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:12:57 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:54483 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753815Ab1CURMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:12:55 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 21 Mar 2011 18:15:50 +0100
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, chatty@enac.fr, dmitry.torokhov@gmail.com
Subject: Re: [PATCH 2/2] hid-ntrig: calibration
Message-ID: <20110321171550.GA4602@polaris.bitmath.org>
References: <1299829072-19489-1-git-send-email-rafi@seas.upenn.edu>
 <1299829072-19489-2-git-send-email-rafi@seas.upenn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299829072-19489-2-git-send-email-rafi@seas.upenn.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1Q1ieH-0003le-8V.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Q1ieH-0003le-8V 84ae4beb11fa8c5b9c5d947ccab02415
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafi,

On Fri, Mar 11, 2011 at 02:37:52AM -0500, Rafi Rubin wrote:
> Adding a function to tell the device to run its calibration routine.
> A number written to the sysfs specifies the duration of the calibration
> in milliseconds
> 
> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
> ---

This is great functionality, and from what it seems, it
works. However, the poking at the usb layer makes me wonder if there
is another way... Jiri? Dmitry? Awaiting answers from someone more
knowledgeable, please find some comments inline.

> diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
> index 24ab6a5..ddf2c76 100644
> --- a/drivers/hid/hid-ntrig.c
> +++ b/drivers/hid/hid-ntrig.c
> @@ -490,6 +490,53 @@ static ssize_t store_mode(struct device *dev,
>  }
>  static DEVICE_ATTR(mode, S_IWUSR | S_IRUGO, show_mode, store_mode);
>  
> +static ssize_t ntrig_calibrate(struct device *dev,
> +			       struct device_attribute *attr,
> +			       const char *buf, size_t count)
> +{
> +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> +	struct usb_device *usb_dev = hid_to_usb_dev(hdev);
> +	struct usbhid_device *usbhid = hdev->driver_data;
> +	int ret;
> +	unsigned long t;
> +	unsigned char *data;
> +
> +	if (strict_strtoul(buf, 0, &t))
> +		return -EINVAL;
> +
> +	data = kmalloc(4, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	spin_lock(&usbhid->lock);
> +	set_bit(HID_DISCONNECTED, &usbhid->iofl);
> +	spin_unlock(&usbhid->lock);

Perhaps an addition to the internal HID api instead of the above?

> +
> +	ret = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
> +			      USB_REQ_CLEAR_FEATURE, USB_TYPE_CLASS
> +			      | USB_RECIP_INTERFACE | USB_DIR_IN,
> +			      0x30b, 1, data, 4, USB_CTRL_GET_TIMEOUT);
> +	if (ret < 0)
> +		goto fail;

How about launching restoration work here, instead of waiting?

> +
> +	msleep(t);
> +
> +	ret = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
> +			      USB_REQ_CLEAR_FEATURE, USB_TYPE_CLASS
> +			      | USB_RECIP_INTERFACE | USB_DIR_IN,
> +			      0x311, 1, data, 4, USB_CTRL_GET_TIMEOUT);
> +
> +fail:
> +	kfree(data);
> +	spin_lock(&usbhid->lock);
> +	clear_bit(HID_DISCONNECTED, &usbhid->iofl);
> +	spin_unlock(&usbhid->lock);
> +	schedule_work(&usbhid->reset_work);
> +
> +	return (ret < 0) ? ret : count;
> +}
> +static DEVICE_ATTR(calibrate, S_IWUSR, NULL, ntrig_calibrate);
> +
>  static struct attribute *sysfs_attrs[] = {
>  	&dev_attr_sensor_physical_width.attr,
>  	&dev_attr_sensor_physical_height.attr,
> @@ -502,6 +549,7 @@ static struct attribute *sysfs_attrs[] = {
>  	&dev_attr_activation_height.attr,
>  	&dev_attr_deactivate_slack.attr,
>  	&dev_attr_mode.attr,
> +	&dev_attr_calibrate.attr,

Maybe one could actually run the calibration at module load, or even
at start/stop? A few seconds of unresponsiveness might be ok at that
time.

>  	NULL
>  };

Thanks,
Henrik
