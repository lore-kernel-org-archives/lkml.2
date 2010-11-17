Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935526Ab0KQWTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:19:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:54862 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933707Ab0KQWTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:19:12 -0500
Date: Wed, 17 Nov 2010 14:19:03 -0800
From: Greg KH <gregkh@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101117221903.GA4066@suse.de>
References: <4CE44B1B.9040709@freescale.com>
 <20101117215147.GA26792@suse.de>
 <4CE452CD.3050001@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE452CD.3050001@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 04:10:21PM -0600, Timur Tabi wrote:
> Greg KH wrote:
> 
> > What is ePAPR?
> 
> It's a specification for an interface between the boot loader and the operating
> system.  It's based on the device tree model that exists on PowerPC today.
> ePAPR defines a bunch of extensions, including one for hypervisors.  The byte
> channel concept is an example of that.
> 
> > Why would you need this mapping?  Just do a first-come-first serve
> > assignment of tty minor devices like all other subsystems do (usb,
> > serial, acm, etc.)
> 
> Without some kind of mapping, there's no way for an application to know which
> /dev entry to open.  Each byte channel goes to a different
> 
> > 
> > sysfs will show the representation between your ePAPR device "handle"
> > and the tty device minor just fine, as it does today for those other
> > types of devices.
> 
> I don't see how.  A byte channel node defines several properties, one of which
> could be a text string that acts as a label.  So if an application is looking
> for the "channel-to-partition-two" byte channel, it can search for that string
> in the device tree.  Once it finds the matching node, it can extract the byte
> channel handle.
> 
> At this point, the application will want to open a /dev entry that corresponds
> to that byte channel handle.  This is the piece I'm missing with the tty layer.
> 
> If I want to create a regular character device, I can do this:
> 
> bc->dev_id = MKDEV(MAJOR(dev_id), MINOR(dev_id) + i);
> device_create(ehv_bc_class, NULL, bc->dev_id, bc, "bc%u", bc->handle);
> 
> Here, I control the name of the /dev entry via "bc%u".  I want something similar
> for tty devices.

No, you want to have a tty device attached to your "byte channel
device".  That will give you the correct mapping here.  Your tty device
number is sequencial and has nothing in its name to do with your "byte
channel device number" just like ttyS1 has nothing in its pci device id
that it lives on with my multi-port serial card.

> > Bonus being that udev will create a persistant device id for your tty
> > device based on that handle so you can just open that if you want to, no
> > need to get the kernel involved in sparse minor mappings at all.
> 
> I'm not sure I understand that.  In order for udev to do this, I need to tell it
> what the byte channel handle actually is.  How do I do that using the tty layer?

You just create your tty device and assign the parent of it to be your
"byte channel device".  Just like we do for PCI, USB, and all other bus
device types.

I think you are forgetting that your byte channel devices must be
"devices" in the system here, right?  There is a 'struct bus_id" for
your bus that these devices live on.  Then you create a tty device in
your tty driver that attaches to the byte channel that shows up as a tty
device on your bus.

Does that help explain things a bit better?

thanks,

greg k-h
