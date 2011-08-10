Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1HJXE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:04:27 -0400
Received: from woodbine.london.02.net ([87.194.255.145]:36885 "EHLO
	woodbine.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab1HJXEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:04:25 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: USB mini-summit at LinuxCon Vancouver
Date: Thu, 11 Aug 2011 00:04:01 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-10-generic; KDE/4.6.2; i686; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
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
        Theodore Kilgore <kilgota@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.1108091016380.1949-100000@iolanthe.rowland.org> <201108092131.03818.linux@baker-net.org.uk> <4E419F2C.6070707@redhat.com>
In-Reply-To: <4E419F2C.6070707@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108110004.02314.linux@baker-net.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 August 2011, Hans de Goede wrote:
> Hi,
> 
> On 08/09/2011 10:31 PM, Adam Baker wrote:
> > On Tuesday 09 August 2011, Hans de Goede wrote:
> <snip>
> 
> > It has also just occured to me that it might be possible to solve the
> > issues we are facing just in the kernel. At the moment when the kernel
> > performs a USBDEVFS_DISCONNECT it keeps the kernel driver locked out
> > until userspace performs a USBDEVFS_CONNECT. If the kernel reattached
> > the kernel driver when the device file was closed then, as gvfs doesn't
> > keep the file open the biggest current issue would be solved instantly.
> > If a mechanism could be found to prevent USBDEVFS_DISCONNECT from
> > succeeding when the corresponding /dev/videox file was open then that
> > would seem to be a reasonable solution.
> 
> <sigh>
> 
> This has been discussed over and over and over again, playing clever
> tricks with USBDEVFS_[DIS]CONNECT like adding a new USBDEVFS_TRYDISCONNECT
> which the v4l2 driver could intercept won't cut it. We need some central
> manager of the device doing multiplexing between the 2 functions, and you
> can *not* assume that either side will be nice wrt closing file
> descriptors.
> 
> Examples:
> 1) You are wrong wrt gvfs, it does keep the libgphoto2 context open all the
> time, and through that the usbfs device nodes.

It seems that that depends, on my system gvfs isn't actually automounting the 
camera after it detects it and the file is only open (according to lsof) when 
the device is actually mounted. As soon as you unmount it the device gets 
closed again. Because it does do a brief open,  USBDEVFS_DISCONNECT then close 
at connection time it does still disable the kernel driver.

> 
> 2) Lets say a user starts a photo managing app like f-spot, and that opens
> the device through libgphoto2 on startup, then the user switches to another
> virtual desktop and forgets all about having f-spot open. Notice that if
> the user now tries to stream he will not get a busy error, but the app
> trying to do the streaming will simply not see the camera at all (kernel
> driver unbound /dev/video# node is gone).

This does seem like a situation where your approach could potentially give a 
better user experience. I'm wondering slightly how you define busy though. For 
webcams the streamon and streamoff ioctls tell you if you are using mmap or 
userptr transfers but you don't know if when the user has finished if they 
just use read. For stillcam mode it is again hard to determine a busy 
condition other than being in the middle of transfering an individual picture.
> 
> 3) Notice that little speaker icon in your panel on your average Linux
> desktop, that keeps the mixer of the audio device open *all the time* it
> is quite easy to imagine a similar applet for v4l2 device controls (see
> for example gtk-v4l) doing the same. Or a user could simply start up a
> v4l2 control panel app like gtk-v4l, qv4l2 or v4l2ucp, and leave it running
> minimized ...
> 

This again needs a usable concept of busy

> 4) Some laptops have a Fn + F## key which enables / disables the builtin
> webcam by turning its power on / off. Effectively plugging it into / out
> of a usb port. We would like to have an on screen notification of this one
> day like we have now for brightness and volume controls, based on udev
> events. But the current dual mode cam stuff causes udev events for
> a *new* video device being added / an existing one being removed
> each time libgphoto2 releases / takes control of the camera.
> 

Would such a system know what camera is supposed to be the internal one so it 
doesn't show the camera as turned on just because you plug in an external 
camera. If so then it won't turn on and off as an external camera changes 
modes. If not then showing on when any camera is usable and off when it isn't 
seems like sensible behaviour.

> 5) More in general, more and more software is dynamically monitoring the
> addition / removal of (usb) devices using udev, our current solution
> suggests to this software the /dev/video device is being unplugged /
> re-plugged all the time, not pretty.
> 
> 
> All in all what we've today is a kludge, and if we want to provide
> a "seamless" user experience we need to fix it.

I think in summary I'm concerned about the possibility of perfect being the 
enemy of good enough. At the moment we've got a significant usability problem 
(a web search for gvfs-gphoto2-volume-monitor turns up mostly instructions on 
how to disable it). If we come up with a solution that whilst it would be 
perfect there isn't enough effort available to implement then that is worse 
than a solution that fixes most of the problem. This is an even greater 
concern when the technically superior solution has a higher long term 
maintenance overhead (as we no longer get Win32 and OSX users helping to 
maintain the stillcam drivers).

I'm not sure if there is anything in this discussion that is relevant to the 
cameras in phones or tablets. These appear to the user as if they are dual 
mode devices but they don't have any independent storage - taking a photo is 
more like capturing a single higher than usual res frame so I suspect they 
aren't going to be an issue.

Regards

Adam
