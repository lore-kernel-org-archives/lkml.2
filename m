Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab1HDWWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:22:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:50217 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab1HDWWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:22:07 -0400
Message-ID: <4E3B1B7B.2040501@infradead.org>
Date: Thu, 04 Aug 2011 19:21:47 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
        Felipe Balbi <balbi@ti.com>, Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
References: <20110610002103.GA7169@xanatos>
In-Reply-To: <20110610002103.GA7169@xanatos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah/Greg,

Em 09-06-2011 21:21, Sarah Sharp escreveu:
> I'm pleased to announce a USB mini-summit at LinuxCon Vancouver.
> 
> What:	USB mini-summit
> When:	Tuesday, August 16th, all day
> Where:	At the conference venue, room TBD pending confirmation from
> 	Angela Brown.
> 
> Proposed topics include USB virtualization, and improved bandwidth APIs
> between the USB core and drivers (especially webcam drivers).  See the
> detailed topic list below.  Anyone is also welcome to propose or show up
> with a USB related topic.  MUSB?  USB 3.0 gadget drivers?  USB-IP?
> 
> The USB mini-summit does overlap with the virtualization mini-summit by
> a day, but I'm hoping we can schedule talks so some of the
> virtualization folks can make it to the USB mini-summit.  The other
> option was on Friday during the conference which was not ideal.
> 
> Proposed topics:
> 
> Topic 1
> -------
> 
> The KVM folks suggested that it would be good to get USB and
> virtualization developers together to talk about how to virtualize the
> xHCI host controller.  The xHCI spec architect worked closely with
> VMWare to get some extra goodies in the spec to help virtualization, and
> I'd like to see the other virtualization developers take advantage of
> that.  I'd also like us to hash out any issues they have been finding in
> the USB core or xHCI driver during the virtualization effort.
> 
> 
> Topic 2
> -------
> 
> I'd also like to get the V4L and audio developers who work with USB
> devices together with the core USB folks to talk about bandwidth
> management under xHCI.
> 
> One of the issues is that since the xHCI hardware does bandwidth
> management, not the xHCI driver, a schedule that will take too much
> bandwidth will get rejected much sooner than any USB driver currently
> expects (during a call to usb_set_interface).  This poses issues, since
> most USB video drivers negotiate the video size and frame rate after
> they call usb_set_interface, so they don't know whether they can fall
> back to a less bandwidth-intensive setting.  Currently, they just submit
> URBs with less and less bandwidth until one interval setting gets
> accepted that won't work under xHCI.
> 
> A second issue is that that some drivers need less bandwidth than the
> device advertises, and the xHCI driver currently uses whatever periodic
> interval the device advertises in its descriptors.  This is not what the
> video/audio driver wants, especially in the case of buggy high speed
> devices that advertise the interval in frames, not microframes.  There
> needs to be some way for the drivers to communicate their bandwidth
> needs to the USB core.  We've known about this issue for a while, and I
> think it's time to get everyone in the same room and hash out an API.
> 
> (I will send out an API proposal later this month.)

While discussing the topics for the media workshop that will happen together
with this year's KS/2011, one issue related to the USB stack came on our
discussions: it is related to multi-function USB devices, as you can
see on this thread:
	http://www.spinics.net/lists/linux-media/msg36195.html

We have several cases of multi-function devices at the media subsystem.
For example, most TV grabber devices provides Remote Controller, Video,
audio and MPEG streaming capabilities, either implementing the standard
USB API's, or the vendor class API's. There are even some devices that
support USB storage, 3G modem and Digital TV.

Some of those devices have some resources that are mutually exclusive.

For example, some Digital Cameras can provide either access to the stored
images, or can be used as webcams. Using them as webcams automatically
deletes all stored images from it. So, a properly implemented driver
should be returning -EBUSY (or -EPERM?) if someone tries to stream for
such devices if is there any pictures stored on it. Symmetrically,
accessing the stored pictures there should return -EBUSY if the device
is streaming.

Currently, the data access for Digital Cameras is implemented via libusb,
libgphoto and gvfs, while the streaming interface is implemented via
a gspca Kernel driver.

I know that this problem were somewhat solved for 3G modems, with the usage
of the userspace problem usb_modeswitch, and with some quirks for the USB
storage driver, but I'm not sure if such tricks will scale forever, as more
functions are seen on some USB devices.

So, if we have some time, maybe we could start some discussions about that
during the USB mini-summit.

It should be noticed that the media subsystem has currently similar problems 
on devices that provide both analog and digital TV, as some resources, like 
the tuner can't be used simultaneously by the two API's. This happens even
with PCI devices. So, maybe, in the end, we'll be writing some kernel library
for resource locking, but it would be good if we can have preliminary
discussions there, and let the final discussions to happen during KS/2011. 

What do you think?

Thanks!
Mauro
