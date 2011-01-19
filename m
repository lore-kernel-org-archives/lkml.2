Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1ASQaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:30:14 -0500
Received: from kroah.org ([198.145.64.141]:55076 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab1ASQaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:30:13 -0500
Date: Wed, 19 Jan 2011 08:30:05 -0800
From: Greg KH <greg@kroah.com>
To: Earl Chew <echew@ixiacom.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: RFC: UIO  null parent for __uio_register_device and
 uio_device_name()
Message-ID: <20110119163005.GA12979@kroah.com>
References: <4D366104.1000400@ixiacom.com>
 <20110119145619.GA17399@local>
 <4D370654.7020400@ixiacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D370654.7020400@ixiacom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 07:42:12AM -0800, Earl Chew wrote:
> Hans,
> 
> Thanks for the quick response.
> 
> >> o Allow a null parent during uio_register_device. We've had
> >>   situations where there was no convenient parent. We could
> >>   concoct a parent, but it seemed to make sense to allow
> >>   for a null.
> > 
> > Hmm. I saw many UIO drivers over the years but we never had that
> > problem. In the probe() function of your UIO driver you get a
> > suitable device as parameter. Why don't you just use it?
> 
> We build custom hardware, and UIO has served us well by providing
> a way out of kernel space.
> 
> [ I'm calling the driver we write the "UIO client driver" to
>   avoid confusion with the Linux UIO driver. ]
> 
> In some implementations, the HW binds directly to the CPU
> physical address space. In particular, it is not accessed via
> PCI space. Thus there is no probe() function required at the
> UIO client driver.
> 
> The physical address assignments for the device are fixed
> at system design time, and the UIO client driver (for the custom hardware)
> has those addresses built into it.
> 
> No probing is required in this scenario.

Great, then create a platform device for your "hardware device" and you
should be fine, right?

> > Yes, we intentionally defined struct uio_device in uio.c and not in
> > a header file to prevent driver authors from using it ;-)
> 
> Yes. This is a good pattern. I like using it too  ;-)
> 
> >> +const char *uio_device_name(struct uio_info *info)
> >> +{
> >> +       return dev_name(info->uio_dev->dev);
> > 
> > No NULL checks? Note that info->uio_dev can be NULL if uio_register_device()
> > failed...
> 
> Apologies. I've tightened up the code.  See below.
> 
> > The function above returns strings like "uio0", "uio1", and so on. What's
> > the value of that? To identify a certain driver or distinguish several
> > instances of it, the "name" member of struct uio_info should be used.
> > 
> > But maybe I just miss the point. What's your use case?
> 
> This is how our code currently works.
> 
> 1. UIO client driver registers with Linux UIO driver.
> 2. UIO client driver advertises the name of the Linux UIO driver
>    instance to which it is bound (eg "uio2") to our custom
>    application
> 3. Our custom application queries for the name of the driver
>    to use (eg "uio2")
> 4. Our custom application issues open("/dev/uio2") to access hardware.
> 
> Working on the implementation of our new system last night I realise
> that our new configuration runs very lean, and I now do not have the
> use of udev to populate /dev/uio[0-9].

Then what populates your other device nodes?

> This new configuration runs so lean that I don't have access to sysfs.

I really find this hard to believe.  Why would you not configure sysfs
in your system?

> I've asked about including sysfs, but there are good reasons not to
> include it.

What are they?

> This means that /sys/class/uio[0-9]/... will not be available.

Nor will lots of other things that you will end up needing.

> The result is that I need to figure out the major/minor device number in
> order to access the Linux UIO device. I will advertise this through /proc/
> entries specific to the UIO client driver. We can then use this information
> to mknod /dev/uio[0-9].

Heh, you have /proc/ but not /sys/?  Someone needs to move out of the
90's :)

> I've added uio_device_chrdev() alongside uio_device_name() to allow
> us to figure out the coordinates of the Linux UIO device.

Ick, no, please use the sysfs files that are alredy present for such a
thing, don't reinvent the wheel, I will not accept such a change.

thanks,

greg k-h
