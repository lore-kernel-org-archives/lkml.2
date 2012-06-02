Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966208Ab2FBHKA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 03:10:00 -0400
Received: from www84.your-server.de ([213.133.104.84]:58333 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966022Ab2FBHJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 03:09:59 -0400
Message-ID: <1338621013.25409.74.camel@wall-e>
Subject: Re: [PATCH] add new NRP power meter USB device driver
From: Stefani Seibold <stefani@seibold.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, thomas.braunstorfinger@rohde-schwarz.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Oliver Neukum <oneukum@suse.de>
Date: Sat, 02 Jun 2012 09:10:13 +0200
In-Reply-To: <20120531094135.GA3400@kroah.com>
References: <1338318858-24144-1-git-send-email-stefani@seibold.net>
	 <20120529231549.GB28736@kroah.com> <1338454041.6454.67.camel@wall-e>
	 <20120531094135.GA3400@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grek,

sorry for the late answer, but i must first do some investigations.
 
On Thu, 2012-05-31 at 17:41 +0800, Greg KH wrote:

> multi-device handling for libusb has been there from the beginning (over
> 10 years ago) and multi-urb handling has been around for a very long
> time as well.
> 
> So, sorry, I don't buy this argument :)
> 
> > So it is a chicken and egg problem. A lot of software is now out with
> > depends on this driver and a lot of embedded development environments
> > doesn't provide libudev, libsysfs und libusb. It will also increase the
> > size of the image and adds additional dependencies to the application.
> 
> You don't need any of those libraries to do this.  What's wrong with
> using "raw" usbfs interactions?
> 

usbfs must be mounted. On some distribution this is not the case for
security reasons.

libusb has also this kind of security concerns, since the user must in
the group for accessing the usb devices.

I know there is always a way, but not for the average developer, which
is not familiar with udev-rules, ACL, capabilities, fstab, groups and so
on.
 
In the embedded world it is also much easier to create an device node by
hand, because you know your environment. But this is unwinnable fight of
the emdedded linux user against the fat desktop and server fraction.

> > Also kernel space is faster and this is a key factor.
> 
> I don't buy it.
> 
> How much faster?  What numbers do you have?
> 

It is not important how much, it is only important that is is!

> We have USB vision systems running at wire speeds using usbfs and
> libusb, and have had that since the early 2.4 kernel days.  Speed is not
> a valid argument here, unless you have some really bad userspace code.
> 
> > And it possible to simple handling the device from script using printf,
> > echo, cat and so on.
> 
> Not really a valid argument, sorry.
> 

Not in the embedded world, where you want check a system outside in the
field.

> Which ones?  We have ripped out lots of USB drivers that could have been
> controlled by usbfs userspace programs over the years for this same
> reason.  If we missed any, please let me know and I will rectify that.
> 

Thats easy, e.g the rio500 driver or cyterm.

And if we include any driver which is not needed for booting a linux
kernel:

- The whole multi touch driver could be replaced by an user space
driver, using uinput.
- VFAT can be done by fuse.
- And so on...

Where is the boundary?

>  
> > Sorry, that was one checkpoint in my ToDo List which i have lost. It
> > would be kind if you can assign me a minor range for the NRPZ devices.
> 
> Not yet, sorry, you need to convince me that this really does need to be
> a kernel driver.
> 

I will try to do this ;-)

> > > > +MODULE_DEVICE_TABLE(usb, nrpz_table);
> > > > +
> > > > +/* Structure to hold all of our device specific stuff */
> > > > +struct usb_nrpz {
> > > > +	struct usb_device *udev;
> > > > +	struct usb_interface *intf;
> > > 
> > 
> > I tried to remove the udev entry in the next version. I was successfully
> > in the most cases, but i find no solution for the nrpz_delete()
> > function, which needs the udev for the usb_put_dev() call. Since intf is
> > at this time NULL, there is no way to determinate the struct usb_device
> > pointer.
> 
> Why would intf be NULL at some point in time when you really need to
> find this out?
> 

That is exactly the code of the usb-skeleton driver does.

BTW: There are some issues with the usb-skeleton driver code, which the
O_NONBLOCK handling i will fix later.

And again usb_skeleton store also both usb_device and usb_interface.

If the skeleton driver is a example full of wrong code and waste memory
resources, why is it in and should be used as a template for usb
drivers? Your name is in the source code header! 

> > > > +	unsigned long in_use;		/* in use flag */
> > > 
> > > Why a long for this?
> > > 
> > 
> > test_and_set_bit() expect a unsigned long. This kind of "in use"
> > handling is not uncommon in a kernel driver.
> 
> Don't confuse that with a valid locking primitive.  Please just use a
> bool or char instead.
> 

Why not? I see no benefit, but i will do.

I think it is not necessary to count each byte, in the usb_nrpz
structure. This structure will be only allocated if a device is plugged.
And some of your suggestions will create more code, which is good for 2
or 3 attached sensors.

>  
> > Anchors will be used for the running urbs. The callback will then
> > collect the handled urbs in a list and read() and write() will resubmit
> > this urbs after processing.
> > 
> > Dynamically creation is an option, but i prefer this way, since it is
> > faster, safer and has less error handling.
> 
> How do you know it is faster?  Has it been measured?  How?  What was the
> results?  Why is it less error handling?  Create, submit, and
> automatically have the USB core destroy the urb is simpler and less code
> in a driver than this logic here, right?  If not, then we did something
> wrong a long time ago.
> 

Thats not true. And maybe yes. The code is clean.

I preallocate the urbs which would be needed and initialize it. Than i
can use when it. Simple get the urb from the top op the list and put it
to the other list and submit it. In the callback handler move it back to
the other list. Very easy and straight forward.

> > > > +	case NRPZ_GETSENSORINFO:
> > > > +	 {
> > > > +		struct nrpz_sensor_info __user *sensor_info =
> > > > +			(struct nrpz_sensor_info __user *)arg;
> > > > +
> > > > +		if (!access_ok(VERIFY_WRITE, sensor_info, sizeof(*sensor_info)))
> > > > +			return -EFAULT;
> > > > +
> > > > +		__put_user(dev->udev->descriptor.bcdDevice,
> > > > +				&sensor_info->bcdDevice);
> > > > +		__put_user(dev->udev->descriptor.bcdUSB,
> > > > +				&sensor_info->bcdUSB);
> > > > +		__put_user(dev->udev->descriptor.bDescriptorType,
> > > > +				&sensor_info->bDescriptorType);
> > > > +		__put_user(dev->udev->descriptor.bDeviceClass,
> > > > +				&sensor_info->bDeviceClass);
> > > > +		__put_user(dev->udev->descriptor.bDeviceSubClass,
> > > > +				&sensor_info->bDeviceSubClass);
> > > > +		__put_user(dev->udev->descriptor.bDeviceProtocol,
> > > > +				&sensor_info->bDeviceProtocol);
> > > > +		__put_user(dev->udev->descriptor.bMaxPacketSize0,
> > > > +				&sensor_info->bMaxPacketSize0);
> > > > +		__put_user(dev->udev->descriptor.bNumConfigurations,
> > > > +				&sensor_info->bNumConfigurations);
> > > > +		__put_user(dev->udev->descriptor.iManufacturer,
> > > > +				&sensor_info->iManufacturer);
> > > > +		__put_user(dev->udev->descriptor.iProduct,
> > > > +				&sensor_info->iProduct);
> > > > +		__put_user(dev->udev->descriptor.iSerialNumber,
> > > > +				&sensor_info->iSerialNumber);
> > > > +		__put_user(dev->udev->descriptor.idVendor,
> > > > +				&sensor_info->vendorId);
> > > > +		__put_user(dev->udev->descriptor.idProduct,
> > > > +				&sensor_info->productId);
> > > > +		usb_string(dev->udev, dev->udev->descriptor.iManufacturer,
> > > > +				(char __force *)sensor_info->manufacturer,
> > > > +				sizeof(sensor_info->manufacturer));
> > > > +		usb_string(dev->udev, dev->udev->descriptor.iProduct,
> > > > +				(char __force *)sensor_info->productName,
> > > > +				sizeof(sensor_info->productName));
> > > > +		usb_string(dev->udev, dev->udev->descriptor.iSerialNumber,
> > > > +				(char __force *)sensor_info->serialNumber,
> > > > +				sizeof(sensor_info->serialNumber));
> > > 
> > > Why are you sending this information through an ioctl, when it is
> > > already exported in sysfs?  That seems quite needless.
> > > 
> > 
> > This is very easy to do in the driver and would create a lot of code in
> > the user space using libsysfs and depends on additional libraries.
> 
> You can't do a simple 'cat'?  Sorry, this is duplication, even if I
> could accept this driver, I can't accept this.
> 

Sorry, but collect this data in user space with libudev is a much harder
task and produce a lot of code. So there is no code duplication, also
older software depends on this ioctl.

> > > Anyway, I think the main questions are, "Why is this a kernel driver",
> > > and "If this is a kernel driver, why not use the IIO interface"?
> > > 
> > 
> > The IIO interface is an option, but not for the Rohde&Schwarz company,
> > since the driver is in use by our customers for 10 years.
> 
> Ok, but I'm not that company, and neither is Linux.  We strive to create
> unified userspace apis that all drivers can use to ensure device
> independance (hint, that's what an OS is for.)  Creating one-off
> user/kernel apis, like this one, is really special syscalls just for
> this specific piece of hardware.  Which is something we do not do
> lightly at all.
> 
> > I also not sure that the IIO interface can handle all of the features of
> > the power meter.
> 
> Then the IIO interface needs to be extended to do so.  Seriously, that's
> the only way I could see this being a kernel driver, not with this
> custom ioctl interface.
> 

I have checked the IIO interface the last two days.

I see no reason to spend month to extend the IIO interface for the need
of high sophisticate measurement instruments since it is IMHO not
possible.

IIO is for simple sensor devices. 

There is no way for an SCPI communication channel, which is the standard
in the instrument world.

Also IIO does not support float or double data values for accurate
measuring nor any text messages interface.

IIO will provide the data in separate queues, which will kick a way the
dependencies of the measurement values. So you are not able to say for
what value was a trigger for, without scanning all channels and compare
the time stamps.  

The IIO userland interface is also good for wasting resources. For the
NRP Devices there where a need of a minimum of 10 open files in the
sysfs to get the data (trigger, status, measurement values, limit
changes and so on) from one device.

Your strive to create a unified userspace API for IIO will currently
have no success, the interface is to complex, waste a lot of resources
and will never meat the requirements of more complex measurement
hardware. It is only good for simple sensor devices.

If you want create a clean and useable interface than have a look at
HID. This is more what we need:

- A descriptor which shows all the capabilities of the device, and which
can easily extended.
- A report wich say what is going on.
- Only one device interface per sensor or instrument

And it would be possible to provide a nice lib which handles and hides
most of basic work from the application developer.

Greetings,
Stefani


