Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1HKINW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:13:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1HKINS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:13:18 -0400
Message-ID: <4E438F74.6090700@redhat.com>
Date: Thu, 11 Aug 2011 10:14:44 +0200
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
References: <Pine.LNX.4.44L0.1108091016380.1949-100000@iolanthe.rowland.org> <201108092131.03818.linux@baker-net.org.uk> <4E419F2C.6070707@redhat.com> <201108110004.02314.linux@baker-net.org.uk>
In-Reply-To: <201108110004.02314.linux@baker-net.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/11/2011 01:04 AM, Adam Baker wrote:
> On Tuesday 09 August 2011, Hans de Goede wrote:
>> Hi,
>>
>> On 08/09/2011 10:31 PM, Adam Baker wrote:
>>> On Tuesday 09 August 2011, Hans de Goede wrote:
>> <snip>
>>
>>> It has also just occured to me that it might be possible to solve the
>>> issues we are facing just in the kernel. At the moment when the kernel
>>> performs a USBDEVFS_DISCONNECT it keeps the kernel driver locked out
>>> until userspace performs a USBDEVFS_CONNECT. If the kernel reattached
>>> the kernel driver when the device file was closed then, as gvfs doesn't
>>> keep the file open the biggest current issue would be solved instantly.
>>> If a mechanism could be found to prevent USBDEVFS_DISCONNECT from
>>> succeeding when the corresponding /dev/videox file was open then that
>>> would seem to be a reasonable solution.
>>
>> <sigh>
>>
>> This has been discussed over and over and over again, playing clever
>> tricks with USBDEVFS_[DIS]CONNECT like adding a new USBDEVFS_TRYDISCONNECT
>> which the v4l2 driver could intercept won't cut it. We need some central
>> manager of the device doing multiplexing between the 2 functions, and you
>> can *not* assume that either side will be nice wrt closing file
>> descriptors.
>>
>> Examples:
>> 1) You are wrong wrt gvfs, it does keep the libgphoto2 context open all the
>> time, and through that the usbfs device nodes.
>
> It seems that that depends, on my system gvfs isn't actually automounting the
> camera after it detects it and the file is only open (according to lsof) when
> the device is actually mounted.

Right, but on some systems it does auto-mount, and even if it does not
auto-mount and the user then just clicks on its icon in the filemanager
to look at the photo's it will mount, and it will be non obvious to the
user to umount it.

Once mounted, the /dev/video# node will be gone. So if for example skype
gets started it will say the user has no camera. If it were to say the device
is busy, the user just might make a link to the mounted gvfs share, but even
then that is a big might.

The whole disappear / reappear act of the /dev/video# node is one of my
concerns with the current solution.

> As soon as you unmount it the device gets
> closed again. Because it does do a brief open,  USBDEVFS_DISCONNECT then close
> at connection time it does still disable the kernel driver.

Then you've a bug in your libgphoto2, Fedora had a similar bug which I fixed
(and send the fix upstream). libgphoto2 now a days does make the call to
re-attach the kernel driver.

>
>>
>> 2) Lets say a user starts a photo managing app like f-spot, and that opens
>> the device through libgphoto2 on startup, then the user switches to another
>> virtual desktop and forgets all about having f-spot open. Notice that if
>> the user now tries to stream he will not get a busy error, but the app
>> trying to do the streaming will simply not see the camera at all (kernel
>> driver unbound /dev/video# node is gone).
>
> This does seem like a situation where your approach could potentially give a
> better user experience. I'm wondering slightly how you define busy though. For
> webcams the streamon and streamoff ioctls tell you if you are using mmap or
> userptr transfers but you don't know if when the user has finished if they
> just use read. For stillcam mode it is again hard to determine a busy
> condition other than being in the middle of transfering an individual picture.

Right, so my plan is to define busy for stillcam mode as not being in
the middle of some operation (be it download or delete).

>> 3) Notice that little speaker icon in your panel on your average Linux
>> desktop, that keeps the mixer of the audio device open *all the time* it
>> is quite easy to imagine a similar applet for v4l2 device controls (see
>> for example gtk-v4l) doing the same. Or a user could simply start up a
>> v4l2 control panel app like gtk-v4l, qv4l2 or v4l2ucp, and leave it running
>> minimized ...
>>
>
> This again needs a usable concept of busy

Actually this one is easy. Most streaming drivers already handle controls
while not streaming by remembering the set values, and these cached values
usually then get set on stream start. There are multiple reasons for
this:
- usb transfers are expensive no need to send a value to the device
   if it may change before it gets actually used
- in many cases parts of the device are powered down when not streaming,
   so sending values while not streaming just drops them in a black hole


<snip>

> If we come up with a solution that whilst it would be
> perfect there isn't enough effort available to implement then that is worse
> than a solution that fixes most of the problem.

Agreed.

> This is an even greater
> concern when the technically superior solution has a higher long term
> maintenance overhead (as we no longer get Win32 and OSX users helping to
> maintain the stillcam drivers).

I've been subscribed to the libgphoto2-devel list for quite some time now,
I believe I still have to see the first win32 / OS-X user input. We do get
occasional FreeBSD input, usually in the form of "it no longer compiles".

I'm not saying that portability is not important, but contributions
from users on other platforms should not be overrated either.

Regards,

Hans
