Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965185Ab2FBMKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 08:10:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42823 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759335Ab2FBMKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 08:10:06 -0400
Date: Sat, 2 Jun 2012 05:10:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, thomas.braunstorfinger@rohde-schwarz.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH] add new NRP power meter USB device driver
Message-ID: <20120602121000.GA12097@kroah.com>
References: <1338318858-24144-1-git-send-email-stefani@seibold.net>
 <20120529231549.GB28736@kroah.com>
 <1338454041.6454.67.camel@wall-e>
 <20120531094135.GA3400@kroah.com>
 <1338621013.25409.74.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338621013.25409.74.camel@wall-e>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2012 at 09:10:13AM +0200, Stefani Seibold wrote:
> Hi Grek,

Who is that?  :)

> On Thu, 2012-05-31 at 17:41 +0800, Greg KH wrote:
> 
> > multi-device handling for libusb has been there from the beginning (over
> > 10 years ago) and multi-urb handling has been around for a very long
> > time as well.
> > 
> > So, sorry, I don't buy this argument :)
> > 
> > > So it is a chicken and egg problem. A lot of software is now out with
> > > depends on this driver and a lot of embedded development environments
> > > doesn't provide libudev, libsysfs und libusb. It will also increase the
> > > size of the image and adds additional dependencies to the application.
> > 
> > You don't need any of those libraries to do this.  What's wrong with
> > using "raw" usbfs interactions?
> > 
> 
> usbfs must be mounted. On some distribution this is not the case for
> security reasons.

Not true at all, usbfs does not get mounted anymore, and hasn't for
years.  In fact, with 3.5, it's gone, and can't be mounted.  Your distro
handles this through device nodes for the usb devices dynamically.

> libusb has also this kind of security concerns, since the user must in
> the group for accessing the usb devices.

Nope, not been true for years, distros properly handle this just fine.

> I know there is always a way, but not for the average developer, which
> is not familiar with udev-rules, ACL, capabilities, fstab, groups and so
> on.

Again, this is all set up properly in good distros with no need for
anything to be changed or tweaked by anyone.

> In the embedded world it is also much easier to create an device node by
> hand, because you know your environment. But this is unwinnable fight of
> the emdedded linux user against the fat desktop and server fraction.

The embedded world uses devtmpfs, which also handles all of this
automatically, with no need for external programs at all.  This is even
easier for them to do than "traditional" distros, so this is not a valid
reason, sorry.

> > > Also kernel space is faster and this is a key factor.
> > 
> > I don't buy it.
> > 
> > How much faster?  What numbers do you have?
> > 
> 
> It is not important how much, it is only important that is is!

How is it faster?  I need real numbers to back this up.  I don't believe
it is faster as your limiting factor is the USB bus speed, not the
processor or kernel or userspace at all.

> > We have USB vision systems running at wire speeds using usbfs and
> > libusb, and have had that since the early 2.4 kernel days.  Speed is not
> > a valid argument here, unless you have some really bad userspace code.
> > 
> > > And it possible to simple handling the device from script using printf,
> > > echo, cat and so on.
> > 
> > Not really a valid argument, sorry.
> > 
> 
> Not in the embedded world, where you want check a system outside in the
> field.

Those embedded systems have other tools on them.

> > Which ones?  We have ripped out lots of USB drivers that could have been
> > controlled by usbfs userspace programs over the years for this same
> > reason.  If we missed any, please let me know and I will rectify that.
> > 
> 
> Thats easy, e.g the rio500 driver or cyterm.

Ok, please send patches removing them.  For some reason rio500 stuck
around the last time we purged things, but I can't remember why.

> And if we include any driver which is not needed for booting a linux
> kernel:
> 
> - The whole multi touch driver could be replaced by an user space
> driver, using uinput.
> - VFAT can be done by fuse.
> - And so on...
> 
> Where is the boundary?

Oh come on, that's not what I am talking about here at all and you know
it.  Don't be juvenile.

> > > > > +MODULE_DEVICE_TABLE(usb, nrpz_table);
> > > > > +
> > > > > +/* Structure to hold all of our device specific stuff */
> > > > > +struct usb_nrpz {
> > > > > +	struct usb_device *udev;
> > > > > +	struct usb_interface *intf;
> > > > 
> > > 
> > > I tried to remove the udev entry in the next version. I was successfully
> > > in the most cases, but i find no solution for the nrpz_delete()
> > > function, which needs the udev for the usb_put_dev() call. Since intf is
> > > at this time NULL, there is no way to determinate the struct usb_device
> > > pointer.
> > 
> > Why would intf be NULL at some point in time when you really need to
> > find this out?
> > 
> 
> That is exactly the code of the usb-skeleton driver does.
> 
> BTW: There are some issues with the usb-skeleton driver code, which the
> O_NONBLOCK handling i will fix later.
> 
> And again usb_skeleton store also both usb_device and usb_interface.
> 
> If the skeleton driver is a example full of wrong code and waste memory
> resources, why is it in and should be used as a template for usb
> drivers? Your name is in the source code header! 

My name is in lots of code that probably needs to be fixed, that's not a
valid reason for me to accept that it is correct :)

> > > > > +		usb_string(dev->udev, dev->udev->descriptor.iSerialNumber,
> > > > > +				(char __force *)sensor_info->serialNumber,
> > > > > +				sizeof(sensor_info->serialNumber));
> > > > 
> > > > Why are you sending this information through an ioctl, when it is
> > > > already exported in sysfs?  That seems quite needless.
> > > > 
> > > 
> > > This is very easy to do in the driver and would create a lot of code in
> > > the user space using libsysfs and depends on additional libraries.
> > 
> > You can't do a simple 'cat'?  Sorry, this is duplication, even if I
> > could accept this driver, I can't accept this.
> > 
> 
> Sorry, but collect this data in user space with libudev is a much harder
> task and produce a lot of code. So there is no code duplication, also
> older software depends on this ioctl.

Again, we don't care, and can't care, about older software that dealt
with a kernel driver we never approved, sorry.

And you wanted to use 'cat' for other stuff, what's wrong with using it
on the sysfs files for this information.

Again, I can't accept this.

> > > > Anyway, I think the main questions are, "Why is this a kernel driver",
> > > > and "If this is a kernel driver, why not use the IIO interface"?
> > > > 
> > > 
> > > The IIO interface is an option, but not for the Rohde&Schwarz company,
> > > since the driver is in use by our customers for 10 years.
> > 
> > Ok, but I'm not that company, and neither is Linux.  We strive to create
> > unified userspace apis that all drivers can use to ensure device
> > independance (hint, that's what an OS is for.)  Creating one-off
> > user/kernel apis, like this one, is really special syscalls just for
> > this specific piece of hardware.  Which is something we do not do
> > lightly at all.
> > 
> > > I also not sure that the IIO interface can handle all of the features of
> > > the power meter.
> > 
> > Then the IIO interface needs to be extended to do so.  Seriously, that's
> > the only way I could see this being a kernel driver, not with this
> > custom ioctl interface.
> > 
> 
> I have checked the IIO interface the last two days.
> 
> I see no reason to spend month to extend the IIO interface for the need
> of high sophisticate measurement instruments since it is IMHO not
> possible.
> 
> IIO is for simple sensor devices. 

Have you discussed this with the IIO developers?  That's not the
impression I got from the interface, but I would need to have them
verify this.

> There is no way for an SCPI communication channel, which is the standard
> in the instrument world.

Who uses such a communication channel?  Why have we never seen it before
on Linux with it's different usages before?  We have both IIO and comedi
intefaces for Linux, both handling instruments and data measurement
devices.

> Also IIO does not support float or double data values for accurate
> measuring nor any text messages interface.

You shouldn't be doing float in the kernel anyway, that's up to
userspace to handle, right?  And IIO can pass on floating point
information the last time I checked.

What do you mean by "text message interface"?

> IIO will provide the data in separate queues, which will kick a way the
> dependencies of the measurement values. So you are not able to say for
> what value was a trigger for, without scanning all channels and compare
> the time stamps.  
> 
> The IIO userland interface is also good for wasting resources. For the
> NRP Devices there where a need of a minimum of 10 open files in the
> sysfs to get the data (trigger, status, measurement values, limit
> changes and so on) from one device.

Since when is 10 file handles a big deal?

> Your strive to create a unified userspace API for IIO will currently
> have no success, the interface is to complex, waste a lot of resources
> and will never meat the requirements of more complex measurement
> hardware. It is only good for simple sensor devices.
> 
> If you want create a clean and useable interface than have a look at
> HID. This is more what we need:

As someone who participated in creating the HID specification almost 20
years ago, I find this sentance laughable :)

> - A descriptor which shows all the capabilities of the device, and which
> can easily extended.
> - A report wich say what is going on.
> - Only one device interface per sensor or instrument
> 
> And it would be possible to provide a nice lib which handles and hides
> most of basic work from the application developer.

Can't you do that on top of IIO in userspace?

Anyway, yes, the descriptor interface of HID is nice, but I don't see
that type of interface here in this driver, so I don't understand the
issue.

If the IIO developers look at this device and driver and agree that it
does not work for their interface, then I'd be glad to revisit the need
for a custom interface for it.  But, it needs to be done such that
future devices that use this type of protocol also are supported.

As I stated before, custom syscalls (which is what these ioctls are) for
a single device, are not acceptable.  Especially when it can be done
from userspace with no need for a kernel driver that I can see at the
moment.

thanks,

greg k-h
