Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab2FBPnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 11:43:19 -0400
Received: from www84.your-server.de ([213.133.104.84]:56990 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279Ab2FBPnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 11:43:18 -0400
Message-ID: <1338651813.31923.39.camel@wall-e>
Subject: Re: [PATCH] add new NRP power meter USB device driver
From: Stefani Seibold <stefani@seibold.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, thomas.braunstorfinger@rohde-schwarz.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Oliver Neukum <oneukum@suse.de>
Date: Sat, 02 Jun 2012 17:43:33 +0200
In-Reply-To: <20120602121000.GA12097@kroah.com>
References: <1338318858-24144-1-git-send-email-stefani@seibold.net>
	 <20120529231549.GB28736@kroah.com> <1338454041.6454.67.camel@wall-e>
	 <20120531094135.GA3400@kroah.com> <1338621013.25409.74.camel@wall-e>
	 <20120602121000.GA12097@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-02 at 05:10 -0700, Greg KH wrote:
> On Sat, Jun 02, 2012 at 09:10:13AM +0200, Stefani Seibold wrote:

> > > > And it possible to simple handling the device from script using printf,
> > > > echo, cat and so on.
> > > 
> > > Not really a valid argument, sorry.
> > > 
> > 
> > Not in the embedded world, where you want check a system outside in the
> > field.
> 
> Those embedded systems have other tools on them.
> 

Murphy's Law: You will never have the tool nor the flash storage u need
in case of a bug.

> > > Which ones?  We have ripped out lots of USB drivers that could have been
> > > controlled by usbfs userspace programs over the years for this same
> > > reason.  If we missed any, please let me know and I will rectify that.
> > > 
> > 
> > Thats easy, e.g the rio500 driver or cyterm.
> 
> Ok, please send patches removing them.  For some reason rio500 stuck
> around the last time we purged things, but I can't remember why.
> 

Maybe you have one ;-) But i am interested to do this.

> > And if we include any driver which is not needed for booting a linux
> > kernel:
> > 
> > - The whole multi touch driver could be replaced by an user space
> > driver, using uinput.
> > - VFAT can be done by fuse.
> > - And so on...
> > 
> > Where is the boundary?
> 
> Oh come on, that's not what I am talking about here at all and you know
> it.  Don't be juvenile.
> 

The boundaries are floating and depending on an arbitrary decisions...
or zeitgeist.
 
> > > > > > +MODULE_DEVICE_TABLE(usb, nrpz_table);
> > > > > > +
> > > > > > +/* Structure to hold all of our device specific stuff */
> > > > > > +struct usb_nrpz {
> > > > > > +	struct usb_device *udev;
> > > > > > +	struct usb_interface *intf;
> > > > > 
> > > > 
> > > > I tried to remove the udev entry in the next version. I was successfully
> > > > in the most cases, but i find no solution for the nrpz_delete()
> > > > function, which needs the udev for the usb_put_dev() call. Since intf is
> > > > at this time NULL, there is no way to determinate the struct usb_device
> > > > pointer.
> > > 
> > > Why would intf be NULL at some point in time when you really need to
> > > find this out?
> > > 
> > 
> > That is exactly the code of the usb-skeleton driver does.
> > 
> > BTW: There are some issues with the usb-skeleton driver code, which the
> > O_NONBLOCK handling i will fix later.
> > 
> > And again usb_skeleton store also both usb_device and usb_interface.
> > 
> > If the skeleton driver is a example full of wrong code and waste memory
> > resources, why is it in and should be used as a template for usb
> > drivers? Your name is in the source code header! 
> 
> My name is in lots of code that probably needs to be fixed, that's not a
> valid reason for me to accept that it is correct :)
> 

For me it is much easier to kick this intf equals zero thing away. But i
thought that the usb skeleton driver is the prefered implementation way.

I have already fixed this issue.  
  
> > > Then the IIO interface needs to be extended to do so.  Seriously, that's
> > > the only way I could see this being a kernel driver, not with this
> > > custom ioctl interface.
> > >


> Have you discussed this with the IIO developers?  That's not the
> impression I got from the interface, but I would need to have them
> verify this.
> 

No, it was the first time that i have looked at this interface.

> > There is no way for an SCPI communication channel, which is the standard
> > in the instrument world.
> 
> Who uses such a communication channel?  Why have we never seen it before
> on Linux with it's different usages before?  We have both IIO and comedi
> intefaces for Linux, both handling instruments and data measurement
> devices.
> 

SCPI is used by the whole measurement instrument manufacturer like Rohde
& Schwarz, Hewlett Packard (or the company that was split off),
Tektronix and much more.. It is important for inter operability. 

It is based on the old IEEE 488 interface, which is a standard since the
good old 8 bit days (all the Commodore and HP machines provided this
hardware interface). These hardware interface is still in use, because
it has very good latency and you can combine all your measurement
instrument, generators and other.

Today there are a lot more SCPI communication hardware interfaces like
USB, RS232 and Ethernet.

SCPI is a command set for (remote) control this kind of instruments.
E.g. "*idn?" give you the the identification string or "freq 66GHz" set
the frequency to 66 GHz.

See the official web site of the SCPI consortium:

http://www.ivifoundation.org/scpi/default.aspx
      
> > Also IIO does not support float or double data values for accurate
> > measuring nor any text messages interface.
> 
> You shouldn't be doing float in the kernel anyway, that's up to
> userspace to handle, right?  And IIO can pass on floating point
> information the last time I checked.
> 
> What do you mean by "text message interface"?
> 

The devices can also reply text messages.

> > IIO will provide the data in separate queues, which will kick a way the
> > dependencies of the measurement values. So you are not able to say for
> > what value was a trigger for, without scanning all channels and compare
> > the time stamps.  
> > 
> > The IIO userland interface is also good for wasting resources. For the
> > NRP Devices there where a need of a minimum of 10 open files in the
> > sysfs to get the data (trigger, status, measurement values, limit
> > changes and so on) from one device.
> 
> Since when is 10 file handles a big deal?
> 

When you have 10 or 100 of the devices. And why so much splitting. The
IIO Interface is easy for simple devices, but unusable for complex
measurement and generator devices.

Do you have really a good feeling to control one device in that way?
Open 10 or more files and resynchronize them in userspace.

> > Your strive to create a unified userspace API for IIO will currently
> > have no success, the interface is to complex, waste a lot of resources
> > and will never meat the requirements of more complex measurement
> > hardware. It is only good for simple sensor devices.
> > 
> > If you want create a clean and useable interface than have a look at
> > HID. This is more what we need:
> 
> As someone who participated in creating the HID specification almost 20
> years ago, I find this sentance laughable :)
> 

Why do you laugh about your one work. I like it, it is a really good
idea and is exactly what you need for the measurement framework.
 
> > - A descriptor which shows all the capabilities of the device, and which
> > can easily extended.
> > - A report wich say what is going on.
> > - Only one device interface per sensor or instrument
> > 
> > And it would be possible to provide a nice lib which handles and hides
> > most of basic work from the application developer.
> 
> Can't you do that on top of IIO in userspace?
> 

I don't like IIO, it is not a design which provides the feature that are
needed for complex devices.

> Anyway, yes, the descriptor interface of HID is nice, but I don't see
> that type of interface here in this driver, so I don't understand the
> issue.
> 

Because there is no way to integrate the NRPZ Sensors in the IIO
framework.

> If the IIO developers look at this device and driver and agree that it
> does not work for their interface, then I'd be glad to revisit the need
> for a custom interface for it.  But, it needs to be done such that
> future devices that use this type of protocol also are supported.
> 

A framework must capable to handle all kinds of devices out there, the
interface must defined to serve the hardware, because hardware which is
still out there cannot changed in a way that IIO will be happy with it.

> As I stated before, custom syscalls (which is what these ioctls are) for
> a single device, are not acceptable.  Especially when it can be done
> from userspace with no need for a kernel driver that I can see at the
> moment.
> 

A driver internal ioctl() is not a new syscall. The syscall is still
ioctl. And that is what this interface is for.

Anyway i will resend the driver with all the fixes applied.

Greetings,
Stefani


