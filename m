Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab1HENH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 09:07:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:38233 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab1HENHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 09:07:25 -0400
Message-ID: <4E3BEAF5.8040602@infradead.org>
Date: Fri, 05 Aug 2011 10:07:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Greg KH <greg@kroah.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
References: <20110610002103.GA7169@xanatos> <4E3B1B7B.2040501@infradead.org> <20110804225603.GA2557@kroah.com> <4E3B9FB4.30709@redhat.com>
In-Reply-To: <4E3B9FB4.30709@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 05-08-2011 04:45, Hans de Goede escreveu:
> Hi,
> 
> On 08/05/2011 12:56 AM, Greg KH wrote:
>> On Thu, Aug 04, 2011 at 07:21:47PM -0300, Mauro Carvalho Chehab wrote:
>>> I know that this problem were somewhat solved for 3G modems, with the usage
>>> of the userspace problem usb_modeswitch, and with some quirks for the USB
>>> storage driver, but I'm not sure if such tricks will scale forever, as more
>>> functions are seen on some USB devices.
>>
>> Well, no matter how it "scales" it needs to be done in userspace, like
>> usb_modeswitch does.  We made that decision a while ago, and it is
>> working out very well.  I see no reason why you can't do it in userspace
>> as well as that is the easiest place to control this type of thing.
>>
>> I thought we had a long discussion about this topic a while ago and came
>> to this very conclusion.  Or am I mistaken?
> 
> I think we've had multiple discussions about this, surrounding various
> topics / use cases. I would not call the do it in userspace a conclusion.
> 
> I rather more have a feeling of getting stonewalled on this by various people
> surrounding the usb system. Me shutting up on this is basically a case of:
> "Discussion not getting anywhere and I don't have the time to do a kernel
>  proof of concept myself right now".
> 
> To be clear about the stonewalling I'm not talking about the dual cam issue
> here, nor about the morphing devices thing which usb_modeswitch fixes.
> 
> I think it is important to separate oranges from apples here, there are
> at least 3 different problem classes which all seem to have gotten thrown
> onto a pile here:
> 
> 1) The reason Mauro suggested having some discussion on this at the
> USB summit is because of a discussion about dual mode cameras on the
> linux media list. Dual-mode cameras are (usually very cheap) digital
> photo cameras which can take still pictures in stand alone mode and
> store them in onboard memory, like regular digital photo cameras, this
> is one mode. The other mode is they can operate as a regular webcam,
> the hardware actually is more regular webcam hardware with some memory
> and a battery added (usually no viewfinder screen).

Yes, that's my concern.

> These devices typically use 1 usb interface (and thus 1 driver) for
> both modes. 

I also want to cover the case where there are two drivers involved, as
this is a typical trouble we need to do with all devices that have both
analog and digital TV's.

A typical media device exposes several different API's to userspace,
each with its own character device, and sometimes implemented by a
different driver.

For example, Conexant cx23102 USB chipsets provide 2 USB interfaces,
but require 3 different drivers, and exposes 4 different userspace
API's to userspace:

USB interface 0: Remote Controller
	event/input API - Handled by drivers/media/rc/mceusb.c

USB interface 1: Audio/Video
	ALSA API - Handled by drivers/media/video/cx231xx/cx231xx-audio.c
		It is a separate driver, called cx231xx-alsa
	V4L2 API - Handled by drivers/media/video/cx231xx/cx231xx-video.c
	DVB API - Handled by drivers/media/video/cx231xx/cx231xx-dvb.c
		Both DVB and V4L2 are currently part of the same driver
(cx231xx).

The mceusb is completely independent of the other drivers. The cx231xx-alsa
also is almost independent. It only shares a lock with the main cx231xx
driver, and uses the I2C functions implemented by the main driver.

Now, we're starting to see devices like ZTE MF845 that have TV, 3G and 
USB storage, exposing 2 more userspace API's to userspace (vfs and tty).

I don't think that userspace usb_modeswitch-like type of locking "scales"
such complex devices.

Besides that, on a large amount of USB sticks, if you enable both V4L2
and DVB, the power consumption may exceed the 500mA power limit of USB,
and can overheat the device. There are several reports of burnt devices
due to that. Also, there's no way for both to work, as they share the
same tuner, that can either be tuning an analog or a digital channel.

To me, the right solution seems to add some sort of locking schema that
will protect the common resources on complex hardware. Something like:

int get_hw_resource(struct device, enum hw_resource_type);
void put_hw_resource(struct device, enum hw_resource_type);

enum hw_resource_type {
	HW_RES_USB,
	HW_RES_I2C,
	HW_RES_TUNER,
	HW_RES_USB,
...
};

So that, when a device need, for example, an exclusive lock for the USB
device, for example, it could be doing something like:

rc = get_hw_resource(dev, HW_RES_USB);
if (rc < 0)
	return -EBUSY;

and, after finishing, doing a put_hw_resource().

> We currently have drivers for both modes, but they are
> separate drivers, which leads to fighting for device ownership,
> with the stillmode driver always winning as that is userspace and
> it simply kicks of the kernel webcam /streaming mode driver making
> it see a device unplug, even if an app was streaming from the device
> at the time. The solution here is simple, move both functions to
> 1 driver, which can then properly return -EBUSY when the device
> is active in one mode and an app tries to use it in the other mode.
> 
> This 1 driver will likely end up being a kernel driver, since doing
> streaming drivers in userspace is problematic, as the v4l2 API assumes
> a kernel device node, and we don't want to invent a new API, we want
> something which works with existing applications.
> 
> 2) So called morphing devices. For example a USB 3G modem which
> initially shows up as a cdrom drive with windows software, only
> to reveal its real identity (with completely different usb
> descriptors) after some magic command. This is solved by the
> usb_modeswitch command, nothing to see here move along.
> 
> 3) Re-direction of usb devices to virtual machines. This works by using
> the userspace usbfs interface from qemu / vmware / virtualbox / whatever.
> The basics of this work fine, but it lacks proper locking / safeguards
> for when a vm takes over a usb device from the in kernel driver.
> 
> Example of the problem: usb mass storage devices is mounted, filesystem
> is in use and dirty, with writebacks pending, user redirects to vm,
> usb mass storage driver sees the cable beeing yanked out of the device.
> 
> Now we've lost the pending writebacks and have a dirty, if not journaling
> possibly corrupt, fs on the device.
> 
> This is the issue on which I feel a bit stonewalled. Simple putting your
> fingers in your ears and singing la la la do it in userspace is not going
> to cut it here. There is no way to do this race free in userspace, unless
> all possible callers of mount get modified. Moreover 99% of the necessary
> accounting for this is already done in the kernel. We already have the notion
> of a block device being in use. We simply need to add some code to pass
> this notion to the usb mass storage driver, and add a new try_disconnect
> callback for usb drivers. I'm not saying this is going to be completely
> straight forward, but it ain't rocket science either. And it so very
> obviously is the *right* thing to do, that I'm getting very tired of
> the do it in userspace song I keep hearing.
> 
> Regards,
> 
> Hans

