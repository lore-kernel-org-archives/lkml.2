Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab1HJCFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 22:05:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57707 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1HJCFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 22:05:51 -0400
MIME-Version: 1.0
In-Reply-To: <4E419F2C.6070707@redhat.com>
References: <Pine.LNX.4.44L0.1108091016380.1949-100000@iolanthe.rowland.org>
	<4E41912F.50901@redhat.com>
	<201108092131.03818.linux@baker-net.org.uk>
	<4E419F2C.6070707@redhat.com>
Date: Wed, 10 Aug 2011 10:05:50 +0800
Message-ID: <CAGjSPUCvDOyhnzn1G6T3YjEL4P8gM94eKFiC9FFPKz1qF68P4w@mail.gmail.com>
Subject: Re: USB mini-summit at LinuxCon Vancouver
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Adam Baker <linux@baker-net.org.uk>,
        Alan Stern <stern@rowland.harvard.edu>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 4:57 AM, Hans de Goede <hdegoede@redhat.com> wrote:
> This has been discussed over and over and over again, playing clever
> tricks with USBDEVFS_[DIS]CONNECT like adding a new
> USBDEVFS_TRYDISCONNECT
> which the v4l2 driver could intercept won't cut it. We need some central
> manager of the device doing multiplexing between the 2 functions, and you
> can *not* assume that either side will be nice wrt closing file descriptors.

So it seems to be both good and bad for Linux's ability to do
multiplexing between the two drivers (one purpose-built kernel driver
and one generic usbfs driver to be used libusb). The good thing
is that it is quite useful in many use cases. The ability to detach
the existing kernel driver and use usbfs is the base for many libusb
based program under Linux and it beats Windows and Mac OS X
handsomely in this aspect. On the other hand, based on the
discussions, it seems to adds quite some issues/complexities
in some other use cases.

Windows typically does not have such an issue. You can use
only one driver. In order to use libusb-win32 or libusb-1.0 Windows
backend, you have to replace the existing kernel driver with
libusb-win32 kernel driver (libusb0.sys) or libusb-1.0 Windows
backend driver (currently winusb.sys).

The exception is the libusb0.sys filter driver. In that case, you
use libusb0.sys as the upper filter driver on top of the existing
kernel driver. On the other hand, libusb-win32 filter driver is not
really widely used due to issues with older versions.

> All in all what we've today is a kludge, and if we want to provide
> a "seamless" user experience we need to fix it.
>
> Don't get me wrong usbfs is a really nice solution for driving
> usb devices from userspace, like scanners and all other sorts of
> devices. But what all these devices have in common is that they
> have no kernel driver. Having a userspace based driver and a kernel
> driver "fight it out" just does not work well.
>

All in all, I think this is a good summary. There are cases where
a kernel driver and a usbfs are both used, an example is FTDI
device where ftdi-sio driver and the user space libftdi (based
on libusb) are used, but there are problems with that as well
with regard to switching between the two drivers.

There are a few discussions here.
http://libusb.6.n5.nabble.com/Patch-libusb-os-linux-usbfs-c-Distingush-between-usbfs-and-other-kernel-mode-drivers-td3199947.html
http://libusb.6.n5.nabble.com/open-device-exclusively-td4524397.html
And there are no good solutions to a "simple" issue as the
above mentioned.

Not so sure if this is a good suggestion or not: just wondering how
the other side (eg Windows) deal with these dual mode cameras?
Does Windows use single driver or does Windows use two drivers
for these dual mode cameras? Since they are customized device,
then there must be a vendor driver for them. And since they will
function as a video cam and a still cam device, I assume there
will be standard Windows drivers on top of the vendor drivers. So
there will be more than one drivers associated with them.


-- 
Xiaofan
