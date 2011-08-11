Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab1HKPNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:13:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:39040 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab1HKPNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:13:48 -0400
Message-ID: <4E43F17F.6030604@infradead.org>
Date: Thu, 11 Aug 2011 12:13:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Hans de Goede <hdegoede@redhat.com>,
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
References: <Pine.LNX.4.44L0.1108111037240.1958-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1108111037240.1958-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 11-08-2011 11:56, Alan Stern escreveu:
> On Thu, 11 Aug 2011, Hans de Goede wrote:
> 
>>> The alternative seems to be to define a device-sharing protocol for USB
>>> drivers.  Kernel drivers would implement a new callback (asking them to
>>> give up control of the device), and usbfs would implement new ioctls by
>>> which a program could ask for and relinquish control of a device.  The
>>> amount of rewriting needed would be relatively small.
>>>
>>> A few loose ends would remain, such as how to handle suspends, resumes,
>>> resets, and disconnects.  Assuming usbfs is the only driver that will
>>> want to share a device in this way, we could handle them.
>>>
>>> Hans, what do you think?
>>>
>>
>> First of all thanks for the constructive input!
>>
>> When you say: "device-sharing protocol", do you mean 2 drivers been
>> attached, but only 1 being active. Or just some additional glue to make
>> hand-over between them work better?
> 
> I was thinking that the webcam driver would always be attached, but 
> from time to time usbfs would ask to use the device.  When the webcam 
> driver gives away control, it remains bound to the device but does not 
> send any URBs.  If it needs to send an URB, first it has to ask usbfs 
> to give control back.
> 
>> I've 2 concerns with this approach:
>> 1) Assuming we are going for the just make hand over work better solution
>> we will still have the whole disappear / reappear act of the /dev/video#
>> node, which I don't like at all.
> 
> That will not happen any more, because the webcam driver will always be 
> bound to the device.
> 
>> If for example skype gets started it will say the user has no camera. If it
>> were to say the device is busy, the user just might make a link to some
>> application using the device in stillcam mode still being open.
>>
>> 2) The whole notion of the device being in use is rather vague when it comes
>> to the userspace parts of this. Simply leaving say F-Spot running, or having
>> a gvfs libgphoto share mounted, should not lead to not being able to use the
>> device in webcam mode. But currently it will.
> 
> That's true -- but it's true no matter what solution we adopt.  The
> various drivers (whether in the kernel or in userspace) will have to
> decide for themselves when they can give up control.

Between two or more kernel drivers, a resource locking mechanism like the one 
you've proposed works fine, but, when the driver is on userspace, there's one
additional issue that needs to be addressed: What happens if, for example,
if a camera application using libgphoto2 crashes? The lock will be enabled, and
the V4L driver will be locked forever. Also, if the lock is made generic enough
to protect between two different userspace applications, re-starting the
camera application won't get the control back.

To avoid such risk, kernel might need to implement some ugly hacks to detect
when the application was killed, and put the device into a sane state, if this
happens.

>> Fixing all users of libgphoto2 wrt this is unlikely to happen, and even if
>> we do that now, more broken ones will likely come along later. I estimate
>> 98% of all cameras are not dual mode cameras, so the average stillcam
>> application developer will not test for this.
> 
> Not all users of libgphoto2 have to be changed; only those which manage
> dual-mode cameras.  Adding a few ioctls to ask for and give up control
> at the appropriate times must be a lot easier than porting the entire
> driver into the kernel.

Again, applications that won't implement this control will take the lock forever.

>> That leaves us with fixing the busy notion inside libgphoto2, iow, release
>> the device as soon as an operation has completed. This will be quite slow,
>> since both drivers don't know anything about each other, they will just
>> know there is some $random_other_driver. So they need to assume the
>> device state is unclean and re-init the device from scratch each time.
> 
> Well, a user program can assume that the kernel driver left the device
> in a clean state.  The reverse isn't always true, however -- it's one
> of the drawbacks of using a userspace driver.
> 
> Besides, even though drivers don't always have to re-init the device
> from scratch every time, they do send all the current settings each
> time they use the device.  So maybe the extra overhead is tolerable.
> 
>> Where as if we have both functions in one driver, that can remember the
>> actual device state and only make changes if needed, so downloading +
>> deleting 10 photos will lead to setting it to stillcam mode once, rather
>> then 20 times.
> 
> Depends how the ask-for-control ioctl is implemented.  It might return
> a value indicating whether or not the webcam driver took control during
> the interval when the user program wasn't using the device.  If usbfs
> retained control the entire time, the program should be able to assume
> the device's state hasn't changed.
> 
> I'm not claiming that this is a better solution than putting everything
> in the kernel.  Just that it is a workable alternative which would
> involve a lot less coding.
> 
> Alan Stern
> 

