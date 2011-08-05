Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab1HEHo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 03:44:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab1HEHoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 03:44:55 -0400
Message-ID: <4E3B9FB4.30709@redhat.com>
Date: Fri, 05 Aug 2011 09:45:56 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        libusb-devel@lists.sourceforge.net, Alexander Graf <agraf@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
        Jan Kiszka <jan.kiszka@siemens.com>,
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
References: <20110610002103.GA7169@xanatos> <4E3B1B7B.2040501@infradead.org> <20110804225603.GA2557@kroah.com>
In-Reply-To: <20110804225603.GA2557@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/05/2011 12:56 AM, Greg KH wrote:
> On Thu, Aug 04, 2011 at 07:21:47PM -0300, Mauro Carvalho Chehab wrote:
>> I know that this problem were somewhat solved for 3G modems, with the usage
>> of the userspace problem usb_modeswitch, and with some quirks for the USB
>> storage driver, but I'm not sure if such tricks will scale forever, as more
>> functions are seen on some USB devices.
>
> Well, no matter how it "scales" it needs to be done in userspace, like
> usb_modeswitch does.  We made that decision a while ago, and it is
> working out very well.  I see no reason why you can't do it in userspace
> as well as that is the easiest place to control this type of thing.
>
> I thought we had a long discussion about this topic a while ago and came
> to this very conclusion.  Or am I mistaken?

I think we've had multiple discussions about this, surrounding various
topics / use cases. I would not call the do it in userspace a conclusion.

I rather more have a feeling of getting stonewalled on this by various people
surrounding the usb system. Me shutting up on this is basically a case of:
"Discussion not getting anywhere and I don't have the time to do a kernel
  proof of concept myself right now".

To be clear about the stonewalling I'm not talking about the dual cam issue
here, nor about the morphing devices thing which usb_modeswitch fixes.

I think it is important to separate oranges from apples here, there are
at least 3 different problem classes which all seem to have gotten thrown
onto a pile here:

1) The reason Mauro suggested having some discussion on this at the
USB summit is because of a discussion about dual mode cameras on the
linux media list. Dual-mode cameras are (usually very cheap) digital
photo cameras which can take still pictures in stand alone mode and
store them in onboard memory, like regular digital photo cameras, this
is one mode. The other mode is they can operate as a regular webcam,
the hardware actually is more regular webcam hardware with some memory
and a battery added (usually no viewfinder screen).

These devices typically use 1 usb interface (and thus 1 driver) for
both modes. We currently have drivers for both modes, but they are
separate drivers, which leads to fighting for device ownership,
with the stillmode driver always winning as that is userspace and
it simply kicks of the kernel webcam /streaming mode driver making
it see a device unplug, even if an app was streaming from the device
at the time. The solution here is simple, move both functions to
1 driver, which can then properly return -EBUSY when the device
is active in one mode and an app tries to use it in the other mode.

This 1 driver will likely end up being a kernel driver, since doing
streaming drivers in userspace is problematic, as the v4l2 API assumes
a kernel device node, and we don't want to invent a new API, we want
something which works with existing applications.

2) So called morphing devices. For example a USB 3G modem which
initially shows up as a cdrom drive with windows software, only
to reveal its real identity (with completely different usb
descriptors) after some magic command. This is solved by the
usb_modeswitch command, nothing to see here move along.

3) Re-direction of usb devices to virtual machines. This works by using
the userspace usbfs interface from qemu / vmware / virtualbox / whatever.
The basics of this work fine, but it lacks proper locking / safeguards
for when a vm takes over a usb device from the in kernel driver.

Example of the problem: usb mass storage devices is mounted, filesystem
is in use and dirty, with writebacks pending, user redirects to vm,
usb mass storage driver sees the cable beeing yanked out of the device.

Now we've lost the pending writebacks and have a dirty, if not journaling
possibly corrupt, fs on the device.

This is the issue on which I feel a bit stonewalled. Simple putting your
fingers in your ears and singing la la la do it in userspace is not going
to cut it here. There is no way to do this race free in userspace, unless
all possible callers of mount get modified. Moreover 99% of the necessary
accounting for this is already done in the kernel. We already have the notion
of a block device being in use. We simply need to add some code to pass
this notion to the usb mass storage driver, and add a new try_disconnect
callback for usb drivers. I'm not saying this is going to be completely
straight forward, but it ain't rocket science either. And it so very
obviously is the *right* thing to do, that I'm getting very tired of
the do it in userspace song I keep hearing.

Regards,

Hans
