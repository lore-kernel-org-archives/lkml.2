Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab1HKPoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:44:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47240 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751201Ab1HKPox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:44:53 -0400
Date: Thu, 11 Aug 2011 11:44:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Hans de Goede <hdegoede@redhat.com>,
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <libusb-devel@lists.sourceforge.net>,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        <hector@marcansoft.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, <pbonzini@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
In-Reply-To: <4E43F17F.6030604@infradead.org>
Message-ID: <Pine.LNX.4.44L0.1108111134540.1958-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox raised a bunch of good points.  I'm not going to respond to 
them; they pretty much speak for themselves.

On Thu, 11 Aug 2011, Mauro Carvalho Chehab wrote:

> Between two or more kernel drivers, a resource locking mechanism like the one 
> you've proposed works fine,

It's not a locking mechanism.  More like cooperative multi-access.

>  but, when the driver is on userspace, there's one
> additional issue that needs to be addressed: What happens if, for example,
> if a camera application using libgphoto2 crashes? The lock will be enabled, and
> the V4L driver will be locked forever. Also, if the lock is made generic enough
> to protect between two different userspace applications, re-starting the
> camera application won't get the control back.

You're wrong, because what I proposed isn't a lock.  If the user 
program dies, the usbfs device file will automatically be closed and 
then usbfs will freely give control back to the webcam driver.

If the program hangs at the wrong time, then the webcam driver won't be 
able to regain control.  At least the user will have the option of 
killing the program when this happens; a similar hang in a kernel 
driver tends to be much uglier.

Two different user programs trying to drive the device at the same time 
doesn't necessarily have to cause a problem.  At any particular moment, 
only one of them would be in control of the device.

> To avoid such risk, kernel might need to implement some ugly hacks to detect
> when the application was killed, and put the device into a sane state, if this
> happens.

No ugly hack is needed.  usbfs can directly inform the webcam driver 
whether or not the device file was closed while the user program 
retained control.  If that didn't happen, it's safe to assume that the 
program gave up control voluntarily.

> > Not all users of libgphoto2 have to be changed; only those which manage
> > dual-mode cameras.  Adding a few ioctls to ask for and give up control
> > at the appropriate times must be a lot easier than porting the entire
> > driver into the kernel.
> 
> Again, applications that won't implement this control will take the lock forever.

No, because there is no lock.  Programs that haven't been changed will 
continue to behave as they do today -- they will unbind the webcam 
driver and assume full control of the device.

Alan Stern

