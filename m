Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1ASRWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:22:55 -0500
Received: from kroah.org ([198.145.64.141]:45673 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab1ASRWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:22:53 -0500
Date: Wed, 19 Jan 2011 09:22:49 -0800
From: Greg KH <greg@kroah.com>
To: Earl Chew <echew@ixiacom.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: UIO  null parent for __uio_register_device and
 uio_device_name()
Message-ID: <20110119172249.GA17807@kroah.com>
References: <4D366104.1000400@ixiacom.com>
 <20110119145619.GA17399@local>
 <4D370654.7020400@ixiacom.com>
 <20110119163005.GA12979@kroah.com>
 <4D371A35.5000009@ixiacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D371A35.5000009@ixiacom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 09:07:01AM -0800, Earl Chew wrote:
> On 19/01/2011 8:30 AM, Greg KH wrote:
> >> No probing is required in this scenario.
> > 
> > Great, then create a platform device for your "hardware device" and you
> > should be fine, right?
> 
> Greg,
> 
> I suppose so. I don't understand the need to enforce !parent
> since device_create() seems to be fine with a NULL parent.
> 
> Would you explain what is to be gained by requiring !parent
> at the Linux UIO level ?

We want things to be "sane" and not have a uio device show up as a child
of a "virtual" device, as in reality, you have a real device so you
had better create one.

> >> Working on the implementation of our new system last night I realise
> >> that our new configuration runs very lean, and I now do not have the
> >> use of udev to populate /dev/uio[0-9].
> > 
> > Then what populates your other device nodes?
> 
> I believe they are fixed in the root file system (ie the major numbers
> are fixed). It is also possible that /etc/rcS script does the rest with
> judicious mknod invocations.

Then do the same for the uio devices and you should be fine, right?

> >> This new configuration runs so lean that I don't have access to sysfs.
> > 
> > I really find this hard to believe.  Why would you not configure sysfs
> > in your system?
> 
> The needs of our hardware and application are such that one of the key system
> designers told me:
> 
> 	For the record, sysfs affects interface scalability in two ways: adds a 
> 	significant memory overhead (IIRC 300-500 bytes per interface) and slows down 
> 	device registration and de-registration.

Really?  How many interfaces do you have that this is a slow-down, and
how is it affecting system speed (I have _never_ heard this complaint.
I've heard others, that have since been fixed, but never this one.)

> >> The result is that I need to figure out the major/minor device number in
> >> order to access the Linux UIO device. I will advertise this through /proc/
> >> entries specific to the UIO client driver. We can then use this information
> >> to mknod /dev/uio[0-9].
> > 
> > Heh, you have /proc/ but not /sys/?  Someone needs to move out of the
> > 90's :)
> 
> LOL  Yes, I see your point.
> 
> >> I've added uio_device_chrdev() alongside uio_device_name() to allow
> >> us to figure out the coordinates of the Linux UIO device.
> > 
> > Ick, no, please use the sysfs files that are alredy present for such a
> > thing, don't reinvent the wheel, I will not accept such a change.
> 
> I think you're telling me you won't accept either of:
> 
> a. uio_device_name()
> b. uio_device_chrdev()
> 
> 
> It is not my intention to reinvent the wheel. The problem I have
> is that the wheel in question won't fit my application context.
> 
> 
> I'm trying to figure out how to get this done without a kernel
> change, but I don't have many options left.

Yes you do, use the kernel interfaces that are already present to
provide this information (i.e. sysfs.)

> I think I can do the following:
> 
> o Use device_create() to make a parent before calling uio_register_device.

No, use a platform device, don't create you own "raw" struct device.

> o Have the application search through /proc/devices to yield the major number
>   of the uio driver.

Yes, you can do that, but again, sysfs is cleaner, nicer, and in the
end, easier to maintain.  It directly provides this information in the
/sys/dev/ files.  I will not accept duplicate kernel code sorry.

And I will be glad to work with anyone who feels that sysfs is somehow
an "unacceptable" overhead.  Look at what you are having to do right
now, to work around not having it.  It's probably caused more than
enough "overhead" and extra work and time and money than it would have
been to just enable it in the first place, instead of trying to work
around it not being present.

And my "move out of the 90's" comment really is true in a way.  To do
thing things that you are wanting to do here, you need to embrace the
way that Linux has changed over the years, as it is doing the things you
need it to do, if you allow it to.  Don't ignore the code already
written, debugged, supported, and used by everyone else in the world
just because it feels "different" than what your engineers are "used
to".

Otherwise, you might as well be using a BSD variant :)

good luck,

greg k-h
