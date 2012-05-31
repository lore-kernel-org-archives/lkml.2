Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab2EaJxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:53:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63249 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2EaJxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:53:11 -0400
Date: Thu, 31 May 2012 17:53:04 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, thomas.braunstorfinger@rohde-schwarz.com
Subject: Re: [PATCH] add new NRP power meter USB device driver
Message-ID: <20120531095304.GA3884@kroah.com>
References: <1338318858-24144-1-git-send-email-stefani@seibold.net>
 <20120529231549.GB28736@kroah.com>
 <1338454041.6454.67.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338454041.6454.67.camel@wall-e>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 10:47:21AM +0200, Stefani Seibold wrote:
> Hi Greg,
> 
> thanks for review the code.
> 
> On Wed, 2012-05-30 at 07:15 +0800, Greg KH wrote:
> > On Tue, May 29, 2012 at 09:14:18PM +0200, stefani@seibold.net wrote:
> > > From: Stefani Seibold <stefani@seibold.net>
> > > 
> > > This driver supports all of the Rohde&Schwarz RF Power Meter NRP Sensors. These
> > > sensors are intelligent standalone instruments that communicate via USB.
> > > 
> > > A power meter is a device for analyzing the RF power output level of an
> > > electrical device, similar to an oscilloscope.
> > 
> > Nice, but why is this a kernel driver?  Can't you control this device
> > from userspace using libusb/usbfs?
> > 
> 
> I have expected this objection. This driver has a long history over 10
> years. At this time, there was no libudev and libsysfs. And libusb was
> not capable to handle multi urb request nor handling multi devices.

Wait, we have had usbfs since the 2.2 kernel days, from the very
beginning of the USB subsystem, so this argument doesn't really fly.
You don't need libsysfs (which is dead, and also, over 8 years old), and
libudev doesn't seem to be needed here either.

multi-device handling for libusb has been there from the beginning (over
10 years ago) and multi-urb handling has been around for a very long
time as well.

So, sorry, I don't buy this argument :)

> So it is a chicken and egg problem. A lot of software is now out with
> depends on this driver and a lot of embedded development environments
> doesn't provide libudev, libsysfs und libusb. It will also increase the
> size of the image and adds additional dependencies to the application.

You don't need any of those libraries to do this.  What's wrong with
using "raw" usbfs interactions?

> Also kernel space is faster and this is a key factor.

I don't buy it.

How much faster?  What numbers do you have?

We have USB vision systems running at wire speeds using usbfs and
libusb, and have had that since the early 2.4 kernel days.  Speed is not
a valid argument here, unless you have some really bad userspace code.

> And it possible to simple handling the device from script using printf,
> echo, cat and so on.

Not really a valid argument, sorry.

> At least it is much more easier and straight forward to do this in
> kernel space, than using libudev, libsysfs and libusb. 
> 
> This devices are very powerfull but also very special and can not
> handled in an easy way,

I don't believe it, you are going to have to prove this somehow, sorry.
Looking at your code, it is very simple, and to write a userspace
program to control these would even be less code that the kernel driver.

> The question why is the a kernel driver can be asked by many kernel
> driver.

Which ones?  We have ripped out lots of USB drivers that could have been
controlled by usbfs userspace programs over the years for this same
reason.  If we missed any, please let me know and I will rectify that.

> > > + * History:
> > > + *
> > > + * 2012_05_18 - 4.0 - revamp for kernel inclusion
> > > + * 2007_05_15 - 2.0 - Ported the driver to kernel 2.6, mostly rewritten
> > > + * 2001_05_01 - 0.1 - first version
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License as published by
> > > + * the Free Software Foundation; either version 2 of the License, or
> > > + * (at your option) any later version.
> > 
> > Are you sure "any later version"?
> > 
> 
> Fixed in the next version.
> 
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > > + * GNU General Public License for more details.
> > > + *
> > > + * You should have received a copy of the GNU General Public License
> > > + * along with this program; if not, write to the Free Software
> > > + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > 
> > This paragraph is never needed, unless you want to track the movements
> > of the FSF's office for the next 40 years.
> > 
> 
> You are right, will be fixed in the version.
> 
> > > +
> > > +#define nrpz_dbg(format, arg...) \
> > > +	do { if (debug) printk(KERN_DEBUG "nrpz: " format "\n", ##arg); } while (0)
> > > +#define nrpz_err(format, arg...) \
> > > +	do { printk(KERN_ERR "nrpz: " format "\n", ##arg); } while (0)
> > > +#define nrpz_info(format, arg...) \
> > > +	do { printk(KERN_INFO "nrpz: " format "\n", ##arg); } while (0)
> > 
> > Ick, no, please use dev_dbg(), dev_err(), and dev_info() instead, don't
> > create your own macros.
> > 
> 
> Fixed in the next version.
> 
> > > +/* Version Information */
> > > +#define DRIVER_VERSION	"v4.00"
> > 
> > What happened to the first 3 versions of this code?  :)
> > 
> 
>  * 2012_05_18 - 4.0 - revamp for kernel inclusion
>  * 2007_12_07 - 3.0 - Rewritten, multi urbs for read and write
>  * 2007_05_15 - 2.0 - Ported the driver to kernel 2.6, mostly rewritten
>  * 2001_05_01 - 0.1 - first version
> 
> The driver have a long history, the first version was developed for
> kernel 2.4. Since then it was adapted to the newest kernel version and
> was optimized in performance and size.

Ok, but what does that really matter for a kernel driver?  What "value"
is it for this to be here?

> > > +#define DRIVER_AUTHOR	"Stefani Seibold <stefani@seibold.net>"
> > > +#define DRIVER_DESC	"Rohde&Schwarz NRP-Zxx USB Powermeter"
> > > +
> > > +/* Get a minor range for your devices from the usb maintainer */
> > > +#define NRPZ_MINOR_BASE		192
> > 
> > You didn't ask me for a minor base, did you?
> > 
> 
> Sorry, that was one checkpoint in my ToDo List which i have lost. It
> would be kind if you can assign me a minor range for the NRPZ devices.

Not yet, sorry, you need to convince me that this really does need to be
a kernel driver.

> > > +MODULE_DEVICE_TABLE(usb, nrpz_table);
> > > +
> > > +/* Structure to hold all of our device specific stuff */
> > > +struct usb_nrpz {
> > > +	struct usb_device *udev;
> > > +	struct usb_interface *intf;
> > 
> 
> I tried to remove the udev entry in the next version. I was successfully
> in the most cases, but i find no solution for the nrpz_delete()
> function, which needs the udev for the usb_put_dev() call. Since intf is
> at this time NULL, there is no way to determinate the struct usb_device
> pointer.

Why would intf be NULL at some point in time when you really need to
find this out?

> > Do you really need both?
> > 
> > > +	unsigned minor;			/* minor number for this device */
> > > +	unsigned long in_use;		/* in use flag */
> > 
> > Why a long for this?
> > 
> 
> test_and_set_bit() expect a unsigned long. This kind of "in use"
> handling is not uncommon in a kernel driver.

Don't confuse that with a valid locking primitive.  Please just use a
bool or char instead.

> > > +
> > > +static inline void urb_list_add_tail(spinlock_t *lock, struct urb *urb,
> > > +				struct list_head *head)
> > > +{
> > > +	spin_lock_irq(lock);
> > > +	list_add_tail(&urb->urb_list, head);
> > > +	spin_unlock_irq(lock);
> > > +}
> > 
> > Why the lists of urbs?  Why not either just create them all dynamically
> > all the time, or use urb anchors?
> > 
> 
> Anchors will be used for the running urbs. The callback will then
> collect the handled urbs in a list and read() and write() will resubmit
> this urbs after processing.
> 
> Dynamically creation is an option, but i prefer this way, since it is
> faster, safer and has less error handling.

How do you know it is faster?  Has it been measured?  How?  What was the
results?  Why is it less error handling?  Create, submit, and
automatically have the USB core destroy the urb is simpler and less code
in a driver than this logic here, right?  If not, then we did something
wrong a long time ago.

> > > +	case NRPZ_GETSENSORINFO:
> > > +	 {
> > > +		struct nrpz_sensor_info __user *sensor_info =
> > > +			(struct nrpz_sensor_info __user *)arg;
> > > +
> > > +		if (!access_ok(VERIFY_WRITE, sensor_info, sizeof(*sensor_info)))
> > > +			return -EFAULT;
> > > +
> > > +		__put_user(dev->udev->descriptor.bcdDevice,
> > > +				&sensor_info->bcdDevice);
> > > +		__put_user(dev->udev->descriptor.bcdUSB,
> > > +				&sensor_info->bcdUSB);
> > > +		__put_user(dev->udev->descriptor.bDescriptorType,
> > > +				&sensor_info->bDescriptorType);
> > > +		__put_user(dev->udev->descriptor.bDeviceClass,
> > > +				&sensor_info->bDeviceClass);
> > > +		__put_user(dev->udev->descriptor.bDeviceSubClass,
> > > +				&sensor_info->bDeviceSubClass);
> > > +		__put_user(dev->udev->descriptor.bDeviceProtocol,
> > > +				&sensor_info->bDeviceProtocol);
> > > +		__put_user(dev->udev->descriptor.bMaxPacketSize0,
> > > +				&sensor_info->bMaxPacketSize0);
> > > +		__put_user(dev->udev->descriptor.bNumConfigurations,
> > > +				&sensor_info->bNumConfigurations);
> > > +		__put_user(dev->udev->descriptor.iManufacturer,
> > > +				&sensor_info->iManufacturer);
> > > +		__put_user(dev->udev->descriptor.iProduct,
> > > +				&sensor_info->iProduct);
> > > +		__put_user(dev->udev->descriptor.iSerialNumber,
> > > +				&sensor_info->iSerialNumber);
> > > +		__put_user(dev->udev->descriptor.idVendor,
> > > +				&sensor_info->vendorId);
> > > +		__put_user(dev->udev->descriptor.idProduct,
> > > +				&sensor_info->productId);
> > > +		usb_string(dev->udev, dev->udev->descriptor.iManufacturer,
> > > +				(char __force *)sensor_info->manufacturer,
> > > +				sizeof(sensor_info->manufacturer));
> > > +		usb_string(dev->udev, dev->udev->descriptor.iProduct,
> > > +				(char __force *)sensor_info->productName,
> > > +				sizeof(sensor_info->productName));
> > > +		usb_string(dev->udev, dev->udev->descriptor.iSerialNumber,
> > > +				(char __force *)sensor_info->serialNumber,
> > > +				sizeof(sensor_info->serialNumber));
> > 
> > Why are you sending this information through an ioctl, when it is
> > already exported in sysfs?  That seems quite needless.
> > 
> 
> This is very easy to do in the driver and would create a lot of code in
> the user space using libsysfs and depends on additional libraries.

You can't do a simple 'cat'?  Sorry, this is duplication, even if I
could accept this driver, I can't accept this.

> > Anyway, I think the main questions are, "Why is this a kernel driver",
> > and "If this is a kernel driver, why not use the IIO interface"?
> > 
> 
> The IIO interface is an option, but not for the Rohde&Schwarz company,
> since the driver is in use by our customers for 10 years.

Ok, but I'm not that company, and neither is Linux.  We strive to create
unified userspace apis that all drivers can use to ensure device
independance (hint, that's what an OS is for.)  Creating one-off
user/kernel apis, like this one, is really special syscalls just for
this specific piece of hardware.  Which is something we do not do
lightly at all.

> I also not sure that the IIO interface can handle all of the features of
> the power meter.

Then the IIO interface needs to be extended to do so.  Seriously, that's
the only way I could see this being a kernel driver, not with this
custom ioctl interface.

> I have expected this objection "why is this a kernel driver?".
> 
> It took me years to convince the company to provide open source driver
> and libraries. This is the first result of this effort. 

All USB Linux drivers have to be open, this shouldn't have been any
effort at all :)

> Since the driver is very tiny and straight forward and has no side
> effects with other parts to the system it would be great to add it to
> the kernel drivers.
> 
> This work should not done for the trash bin.

I understand your investment in this.  But understand ours as well.  You
are creating a hardware-specific set of custom system calls that no one
else can, or will, use.  You also duplicate interfaces that we have
already standardized on (the USB device information in sysfs and in
usbfs).  Why would that be acceptable?  If you were in my situation,
would you accept this type of duplication?

So, I suggest you either use usbfs from a userspace program or library,
or if you insist on a kernel driver, use the IIO interface, extending it
where needed.  As it is, in the current form, I can not accept this
driver for the above reasons.

thanks,

greg k-h
