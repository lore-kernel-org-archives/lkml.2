Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab1HUQla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 12:41:30 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40411 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755179Ab1HUQl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 12:41:26 -0400
X-Sasl-enc: GWv/FErY3bXnk5nmzlvT3CYTzSFJHClFto7DOxZLkAUH 1313944885
Date: Sun, 21 Aug 2011 09:39:06 -0700
From: Greg KH <greg@kroah.com>
To: Sarah Sharp <sarah.a.sharp@intel.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net
Subject: Re: USB mini-summit report
Message-ID: <20110821163906.GB6229@kroah.com>
References: <20110819213725.GA5018@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819213725.GA5018@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 02:37:25PM -0700, Sarah Sharp wrote:
> The USB mini-summit was a success!  Thank you to all the people who attended.  I
> think we had some productive discussions that could have taken weeks on the
> mailing list.
> 
> Please reply to this email if you have your own notes, or if your memory of the
> mini-summit differs from mine. :)

Cc:s dropped so that the lists can pick this up.

Thanks Sarah for organizing this and running it.  It went really well
and I hope everyone else enjoyed it as much as I did.

I'll leave the rest below for the lists to see it.

greg k-h

> Key decisions:
> =============
> 
> Theodore Kilgore agreed to move the userspace still camera drivers into the
> kernel in order to make the hand-off between still cam and webcam mode more
> user-friendly.  The proposal was to have the V4L2 still cam interface attached
> to a separate file so that userspace could just use the standard READ syscalls,
> rather than adding new ioctls to /dev/videoN.
> 
> The issue with TV tuners having resources that need to be shared across
> separate drivers didn't really get resolved, but Mauro Carvalho Chehab is going
> to look into using the devres subsystem to share resources.
> 
> Hans Geode gave a demo of his USB redirection code that's being used in qemu 0.15, and
> we discussed how to integrate his project with the USB over IP kernel driver
> that Matt Mooney has been working on.  Matt and Hans agreed that the USB over IP
> protocol was fairly inefficient, and that Matt would re-work the kernel driver
> to use Han's protocol instead.  That way, people could use the VHCI driver to
> talk to qemu devices on other computers.
> 
> The discussion with the virtualization folks mostly centered around pain points
> in usbfs: the arbitrary 16KB URB buffer size limit, lack of a zero-copy
> interface, and a request for bulk streams support for USB 3.0 devices.  Hans'
> USB redirect code also seemed to have fairly poor performance and high CPU load
> in comparison to a non-virtualized transfer, which indicates there are issues in
> either qemu, libusb, usbfs, or Hans' USB redirect code.
> 
> 
> Notes:
> =====
> 
> Dual mode cameras
> -----------------
> 
> Theodore confirmed there is always a direct mapping between one webcam driver
> and one still cam driver for each webcam chipset.  All the still cam drivers are
> maybe 5,000 lines of code, so they shouldn't be too difficult to move into the
> kernel.
> 
> Only one camera actually deletes photos when the video starts streaming.  (It
> was unclear whether it was only one camera version, or all the cameras for a
> particular camera chipset.  Theodore, can you comment?)
> 
> The issue with gphoto not re-attaching the kernel driver was mostly caused by
> the fact that it was using libusb0.1, which doesn't have the re-attach
> functionality.  gphoto now directly uses the usbfs ioctl to reattach the kernel
> driver when the still cam media is unmounted.
> 
> The suggestion was made that if the camera was busy, either in still cam mode,
> or in webcam mode and the opposite mode was requested, that we should log a
> message to the kernel log along with returning -EBUSY.  The still cam driver
> should only send a busy error when the mount is actually active -- when a photo
> is being fetched or being deleted.  A warning message about the one camera that
> deletes photos when video streaming is enabled should be printed so users could
> be aware of it.
> 
> At first, the proposal was to attach the new still cam ioctls to /dev/videoN.
> Mauro suggested that we actually create a new file (with the same permissions as
> /dev/videoN).  This followed the UNIX philosophy of separating out different
> functionality into separate programs/files, and allows userspace to use READ
> syscalls directly.
> 
> Debate followed.  The files transferred off of the still cam drivers weren't
> very big, since most devices only have 16MB of RAM, so just passing data in
> ioctls could be acceptable.  Mauro suggested it would be better to have a
> separate file so userspace can just read from it with mmap.  Mauro still wants
> to use v4l class and core, just have a separate file, like they do with dual
> input/outputs.  Hans agreed a separate file seems more elegant.
> 
> Discussion of the decoding code for V4L2 followed, but I will admit it was
> mostly over my head.  Perhaps Hans and Theodore can provide a summary?  I think
> people said V4L2 uses bilinear interpolation, which causes "zippered" bands at
> the edges of objects.  Gphoto uses the "accure" interpolation, which is better,
> but still leaves bluish bands on the edges.  Theordore is exploring AHD
> demosaicing, which eliminates the bands.
> 
> 
> TV tuners
> ---------
> 
> Many TV tuners have both an analog and a digital tuner, and many of them also
> include sound interfaces, 3G modems, or mass storage devices.  Mauro said one
> device had mass storage, 3G, and a TV tuner, and the user would have to
> disconnect the mass storage device and connect through the 3G modem before they
> could even use the TV tuner.
> 
> These TV tuner cards often have hardware resources (MUXes, converters, radios,
> etc) that are shared across the different functions.  However, v4l2, alsa, DVB,
> usbfs, and all the other drivers have no knowledge of what resources are shared.
> For example, users can't access DVB and alsa at the same time, or the DVB and
> V4L analog API at the same time, since many only have one converter that can be
> in either analog or digital mode.  There are also issues with users frying their
> devices when all the hardware functionality is enabled and the device attempts
> to pull more than the 500mA current limit of the USB bus.
> 
> Mauro originally wanted to add new functionality to the driver core to declare
> resources and attempt to claim or release them.  Greg suggested that the driver
> core already has a devres interface that sounds awfully similar to that, so
> Mauro agreed to look into devres before designing a new API.
> 
> Bandwidth discussions
> ---------------------
> 
> I talked a bit with Hans and Mauro about what sorts of things media drivers
> might need if the USB core were to provide an interface to allow drivers to
> declare they use less bandwidth than the device advertises.
> 
> I described one of the logitech cameras I have where the uvcvideo driver always
> attempts to use the most bandwidth-intensive interface (alt setting 11), and
> Hans suggested that the device might be falsely advertising that it needs alt
> setting 11 for all the video resolutions it provides.  He suggested I look at
> the FIX_BANDWIDTH quirk in the uvcvideo driver.
> 
> Alan already pointed out that for devices with non-zero "additional service
> opportunities per microframe", we can't reduce the packet size.  I tried to
> explore whether devices that didn't fall into that categories could have their
> packet size reduced, or if the driver could use less extra service opportunities
> for those alt settings that do advertise it.
> 
> Hans said that cameras will often want to send full packets in a burst, using
> all service opportunities, and then send a bunch of zero packets between frames.
> He said many of them will "barf" if the driver tries to use a smaller buffer
> size or less service opportunities to make the camera send a steady stream of
> bytes.  It was unclear whether all the cameras suffer from this, so more
> experimentation on my part is probably needed.
> 
> As for devices that have the wrong endpoint interval advertised (e.g. HS cameras
> specifying the interval in frames instead of microframes), Hans said that only a
> few devices have the wrong endpoint interval advertised.
> 
> 
> USB disaster talk
> -----------------
> 
> The KVM forum "Fixing the USB disaster" talk mostly covered how qemu has
> improved their USB support and performance over time.  One of the main points
> was the design of the host controller interface (i.e. scheduling through a frame
> list) caused qemu developers to have to poll the data structures every frame
> (1ms), looking for updates, which caused high CPU utilization.
> 
> It's much easier with a virtualized xHCI host, where they only need to look for
> a doorbell ring when the host driver queues a transfer.  There is a patchset
> from Hector Martin to add xHCI support to qemu that uses libusb directly.
> However, in order to take advantage of the better xHCI interface and have USB
> devices only show up under xHCI, the guest OS would have to have an official
> xHCI driver.
> 
> Qemu 0.15 just got EHCI emulation support.  However, with direct device
> redirection, qemu can't give a hub to two guests, which means two guests can't
> share devices under the same roothub on Intel systems with an internal "rate
> matching hub" that is used instead of UHCI companions controllers.  Qemu 0.15
> still uses usbfs directly rather than using libusb, so a lot of code could
> probably be deleted by using libusb instead.
> 
> 
> USB redirection and USB over IP
> -------------------------------
> 
> Hans Geode demoed connecting from within qemu to a USB webcam through the
> loopback interface of his laptop.  He could have demoed connecting to a webcam
> on a different laptop, but he didn't want to run it on the conference network.
> His code is all in userspace, unlike the current USB over IP kernel driver in
> staging.
> 
> Hans said his USB redirect code has a more efficient protocol than what USB over
> IP uses.  For example, it buffers isoc transfers to avoid jitter.  Details of
> the protocol are documented in Hans' git repo:
> 
> http://cgit.freedesktop.org/~jwrdegoede/urbredir/
> 
> Greg said the USB over IP driver in staging works well with USB 2.0, so the
> protocol might not be too much of an issue.  Still, Matt Mooney was up for
> re-working the kernel driver to use the same protocol.  Hans commented that if
> both the in-kernel driver and the USB redirect code used the same protocol, then
> anyone with a VHCI driver could connect to a KVM device running in qemu on
> either the local or remote machine.
> 
> There currently isn't any encryption between the two computers, but Hans made
> the comment that Spice can do encryption over tcp.
> 
> I asked about performance, and Hans used dd on the same USB flash drive, both
> through the in-kernel usb-storage driver, and through qemu in the USB redirect
> code.
> 
> CPU usage (running at max CPU speed):
> non-virtualized:	25-30%
> qemu:			80-90%
> 
> dd stats for 5000 IOPs with a 16K sector size (with iflag=odirect):
> non-virtualized:	6.5, 12.8MB/s
> qemu:			50.3 sec, 1.6MB/s
> 
> When using the USB redirect code in qemu, there seems to be a factor of 10
> difference in performance, while increasing CPU usage by 3x.  There is
> definitely room for improvement, either in qemu, libusb, usbfs, or Hans' USB
> redirect code.
> 
> USB Virtualization
> ------------------
> 
> The KVM folks would love to take advantage of the hardware virtualization for
> the xHCI host controller (including a form of SR-IOV support), but those
> features are optional, and the current host controllers on the market don't
> implement it.  Until they do implement it, the features will remain largely
> uninteresting.  Talk turned to how to improve usbfs and libusb, which is what
> KVM currently uses.
> 
> One of the issues was an arbitrary limit on the size of a bulk transfer by usbfs
> to 16KB.  This causes libusb to attempt to split large transfers into 16KB
> chunks, and scramble to cancel previous transfers if submission of one of the
> later transfers failed.  I asked why the limit was there at all, Greg replied,
> "Well, we have to have something."  The virtualization developers suggested
> looking at the max submission size that Windows uses and setting the limit to
> that.
> 
> The virtualization folks also asked for bulks streams support for usbfs and
> libusb.  Tatyana Brokhman from Code Aurora and Amit Blay from Qualcomm sent an
> RFC to add this support to usbfs, although we're still hammering out the
> interface:
> 
> 	http://marc.info/?l=linux-usb&m=130823114516525&w=2
> 
> I also suggested performance of usbfs might be better if it used a zero-copy
> interface.  Greg suggested looking at the infinaband userspace remote DMA code.
> He thinks they use vmap to map in iovecs to copy to and from, which will ensure
> pages don't get unpinned until the kernel is done with it, even if the userspace
> application crashes.
> 
> 
> There was also some discussion about somehow improving KVM's handling of mass
> storage devices.  David Meggy works for a company that does "USB extension" over
> ethernet cables, and he commented that they get much better performance out of
> mass storage devices by pre-fetching sectors in order to hide the latency of the
> long cable.  The suggestion was made that KVM could do something similar for USB
> mass storage devices.
> 
> We also discussed playing tricks by pretending Bulk-only-transport (BoT) devices
> were actually USB attached SCSI (UAS) devices.  The UAS protocol uses bulk
> streams to allow multiple SCSI commands in flight, while BoT only allows one
> command in flight at a time, and it waits for each of the three command phases
> to complete before sending the next phase.
> 
> Matthew Wilcox and I wondered if presenting a BoT device to the guest as a UAS
> device and allowing the VMM to buffer reads and writes to the device would
> improve USB storage performance.  At the very least, presenting KVM file-backed
> storage devices as a UAS device might allow the guest OS to get better file
> system performance.
> 
> 
> (There was some talk about USB over IP, gadgetfs and ssl here that I was too
> tired to capture.  Can anyone else remember the discussion?)
> 
> 
> HPA noted that he wants to assign a port to a VM.  This is especially useful for
> devices that morph when the firmware is uploaded and disconnect and reconnect.
> Hans said usbfs has a "claim a port" ioctl, so KVM can add that.
> 
> The virtualization folks also suggested that they needed a "try disconnect"
> ioctl.  The problem is that when you tell KVM to use a direct-attached USB
> device, it will disconnect the USB storage driver without any idea of what state
> the filesystem is in, or whether it has any dirty pages.  There was some talk of
> exporting the mount count from the block layer down through the SCSI layer to
> the USB mass storage device.  It's of course racey for userspace to check
> whether a device is busy and then disconnect the driver, but the "try
> disconnect" ioctl could cause the driver to disconnect itself.  In the end there
> wasn't a very good solution to this problem.
