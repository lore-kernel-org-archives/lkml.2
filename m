Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab1HIU4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 16:56:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab1HIU4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 16:56:02 -0400
Message-ID: <4E419F2C.6070707@redhat.com>
Date: Tue, 09 Aug 2011 22:57:16 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
CC: Alan Stern <stern@rowland.harvard.edu>,
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
Subject: Re: USB mini-summit at LinuxCon Vancouver
References: <Pine.LNX.4.44L0.1108091016380.1949-100000@iolanthe.rowland.org> <4E41912F.50901@redhat.com> <201108092131.03818.linux@baker-net.org.uk>
In-Reply-To: <201108092131.03818.linux@baker-net.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/09/2011 10:31 PM, Adam Baker wrote:
> On Tuesday 09 August 2011, Hans de Goede wrote:

<snip>

> It has also just occured to me that it might be possible to solve the issues
> we are facing just in the kernel. At the moment when the kernel performs a
> USBDEVFS_DISCONNECT it keeps the kernel driver locked out until userspace
> performs a USBDEVFS_CONNECT. If the kernel reattached the kernel driver when
> the device file was closed then, as gvfs doesn't keep the file open the
> biggest current issue would be solved instantly. If a mechanism could be found
> to prevent USBDEVFS_DISCONNECT from succeeding when the corresponding
> /dev/videox file was open then that would seem to be a reasonable solution.

<sigh>

This has been discussed over and over and over again, playing clever
tricks with USBDEVFS_[DIS]CONNECT like adding a new USBDEVFS_TRYDISCONNECT
which the v4l2 driver could intercept won't cut it. We need some central
manager of the device doing multiplexing between the 2 functions, and you
can *not* assume that either side will be nice wrt closing file descriptors.

Examples:
1) You are wrong wrt gvfs, it does keep the libgphoto2 context open all the
time, and through that the usbfs device nodes.

2) Lets say a user starts a photo managing app like f-spot, and that opens
the device through libgphoto2 on startup, then the user switches to another
virtual desktop and forgets all about having f-spot open. Notice that if
the user now tries to stream he will not get a busy error, but the app trying
to do the streaming will simply not see the camera at all (kernel driver
unbound /dev/video# node is gone).

3) Notice that little speaker icon in your panel on your average Linux
desktop, that keeps the mixer of the audio device open *all the time* it
is quite easy to imagine a similar applet for v4l2 device controls (see
for example gtk-v4l) doing the same. Or a user could simply start up a
v4l2 control panel app like gtk-v4l, qv4l2 or v4l2ucp, and leave it running
minimized ...

4) Some laptops have a Fn + F## key which enables / disables the builtin
webcam by turning its power on / off. Effectively plugging it into / out
of a usb port. We would like to have an on screen notification of this one
day like we have now for brightness and volume controls, based on udev
events. But the current dual mode cam stuff causes udev events for
a *new* video device being added / an existing one being removed
each time libgphoto2 releases / takes control of the camera.

5) More in general, more and more software is dynamically monitoring the
addition / removal of (usb) devices using udev, our current solution
suggests to this software the /dev/video device is being unplugged /
re-plugged all the time, not pretty.


All in all what we've today is a kludge, and if we want to provide
a "seamless" user experience we need to fix it.

Don't get me wrong usbfs is a really nice solution for driving
usb devices from userspace, like scanners and all other sorts of
devices. But what all these devices have in common is that they
have no kernel driver. Having a userspace based driver and a kernel
driver "fight it out" just does not work well.

Regards,

Hans
