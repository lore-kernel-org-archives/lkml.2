Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab1CVWUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:20:38 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:60606 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751850Ab1CVWUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:20:35 -0400
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev
 class and sysdev
From: Kay Sievers <kay.sievers@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Greg KH <gregkh@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
In-Reply-To: <201103222305.01808.rjw@sisk.pl>
References: <201103100131.58206.rjw@sisk.pl>
	 <201103222200.52131.rjw@sisk.pl> <1300828356.1815.15.camel@zag>
	 <201103222305.01808.rjw@sisk.pl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 22 Mar 2011 23:20:11 +0100
Message-ID: <1300832411.1815.35.camel@zag>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 23:05 +0100, Rafael J. Wysocki wrote:
> On Tuesday, March 22, 2011, Kay Sievers wrote:
> > On Tue, 2011-03-22 at 22:00 +0100, Rafael J. Wysocki wrote:
> > > On Tuesday, March 22, 2011, Kay Sievers wrote:
> > > > On Tue, 2011-03-22 at 21:30 +0100, Rafael J. Wysocki wrote:
> > > > > 
> > > > > Perhaps there's a more straightforward way to make some files show up in
> > > > > sysfs on a specific path than defininig an otherwise useless bus type and
> > > > > device object?
> > > > 
> > > > That's absolutely not the point. Please don't get yourself into that
> > > > thinking. If people want to "export stuff to userspace", they must not
> > > > invent new things. We need to get rid of the silly special cases.
> > > 
> > > Why exactly?  Do they actually hurt anyone and if so then how?
> > 
> > Sure, "devices" are devices, and devices have well-defines set of
> > properties, not some magic directory, people can mess around with the
> > way they like.
> 
> So it looks like the the problem is that the exported attributes happen to
> be under /sys/devices/.  Would it still be a problem if they were somewhere
> else?

We are not going to invent another location for any devices. They need
to stay in /devices if they are devices. And all devices need to be
"struct device".

> > > > Userspace is not meant to learn subsystem specific rules for every new
> > > > thing.
> > > 
> > > That depends a good deal of who's writing the user space in question.  If
> > > that's the same person who's working on the particular part of the kernel,
> > > I don't see a big problem.
> > 
> > Not for "devices". There are rules for devices, which are defined by the
> > driver core, and the sysdev stuff needs to go, because it does not fit
> > into that model.
> 
> OK, I understand that.
> 
> Now, there's stuff that doesn't really match the "device" model.  Where is
> the right place to export that?  Perhaps we should add something like
> /sys/platform/ (in analogy with /sys/firmware/)?

No, add a subsystem (bus_type) for any of them, and register them. There
is no such thing as "devices which do not fit the device model", they
are all fine there. Please stop optimizing single bytes and creating a
mess in /sys. Every device is a "struct device".

Think of "struct bus_type" as "struct subsystem", we will rename that
when we are ready. It is just a group of devices which are of the same
type, it has nothing to do with a bus in the sense of hardware.

We need unified exports of _all devices to userspace, not custom layouts
in /sys.

There's is a pretty much outdated Documentation/sysfs-rules.txt, wich
covers part of the history and the plans.

> > > > There is _one_ way to export device attributes, and that is
> > > > "struct device" today.
> > > > 
> > > > If that's to expensive for anybody, just don't use sysfs. It's the rule
> > > > we have today. :)
> > > 
> > > Oh, good to know.  It's changed a bit since I last heard.  Never mind.
> > 
> > Oh, don't get me wrong, this is all is about "devices" not any other
> > controls.
> >
> > > Still, I won't let you change the things in /sys/power to struct devices,
> > > sorry about that. ;-)
> > 
> > Fine as long as they are power specific things, and not "devices". You
> > don't have sysdevs there, right? :)
> 
> No, I don't.

Then all is fine. All other stuff is more like /proc, and can never be
really unified. All we care about is devices, which have common methods
for userspace to trigger and consume, and need to be unified. Power
specific control files seems all fine in its kobject use.

> > > And I wonder how are you going to deal with clocksource exporting things
> > > via the sysdev interface right now.  I'd simply create two directories and
> > > put the two files into them and be done with that, but I guess that
> > > wouldn't fit into the model somehow, right?
> > 
> > Nope, register a bus_type, and use struct device for all of them, Parent
> > them to /sys/devices/system/ if they should keep their location and
> > layout.
> 
> Well, I'll be watching what happens to the patch trying to do that, but I'm
> not going to bet anything on its success. ;-)

It should be pretty straight-forward. We will need to do that for CPUs I
guess, because the interface is kinda commonly used.

> > > > > > That way userspace can properly enumerate them in a flat list
> > > > > > in /sys/bus/<bus_type name>/devices/*, and gets proper events on module
> > > > > > load and during system coldplug, and can hook into the usual hotplug
> > > > > > pathes to set/get these values instead of crawling magicly defined and
> > > > > > decoupled locations in /sys which can not express proper hierarchy,
> > > > > > classicication, or anything else that all other devices can just do.
> > > > > 
> > > > > There's no hotplug involved or anything remotely like that AFAICS.
> > > > > There are simply static files as I said above, they are created
> > > > > early during system initialization and simply stay there.
> > > > 
> > > > That's not the point. It's about a single way to retrieve information
> > > > about devices, extendability, and coldplug during bootup, where existing
> > > > devices need to be handled only after userspace is up.
> > > 
> > > I'd say the case at hand has nothing to do with that.
> > 
> > It has. As for CPUs. We can not do proper CPU-dependent module
> > autoloading, because the events happen before userspace runs, and
> > clodplug can not see the broken sysdevs, because they have no events to
> > re-trigger, like all others have.
> 
> Well, as I said, would it be OK if the things in question happened to be
> located somewhere outside of /sys/devices/ ?

No, no device directory can be outside of /sys/devices.

> > > > That is just a case of "hotplug" that has the same codepath for userspace,
> > > > even when the devices can never really come and go.
> > > 
> > > My impression is that when you say "user space", you actually mean some
> > > _specific_ user space, don't you?
> > 
> > On usual boxes it's udev/libudev and all the stuff around it. But
> > andreoid has the same stuff in their own way of doing it. So it's not
> > about an implementation in userspace, it's about a sane event and
> > classification interface for kernel-exported devices. Again tis is not
> > about any other stuff in /sys, only the "devices", and we want to have
> > only a single type, and a single way to handle it in userspace.
> 
> OK
> 
> > > > > > There is really no reason for any device being a magic and conceptually
> > > > > > broken sysdev today - just to be different from any other device the
> > > > > > kernel exports to userspace.
> > > > > 
> > > > > It's not a "device being a sysdev", it's sysdevs being used for creating
> > > > > a user space interface, which isn't broken by itself.
> > > > 
> > > > Yeah , absolutely. But if any device wants to export anything is _must_
> > > > be a "struct device" today. If that does not fit, it must not use sysfs
> > > > at all.
> > > 
> > > Well, it's not a "device wants to export something".  It's platform code
> > > wanting to export some information related to the platform and I really
> > > don't see a reason why it should create bus types and device objects
> > > _specifically_ for that.  It's just too wasteful, both in terms of memory
> > > and time needed for handling that in the device core.
> > 
> > Because they are devices, and there is a lot to win, if the kernel
> > exports all "devices" in the same way. This is not about saving an inode
> > in /sys, it's the ability to do runtime device configuration with common
> > tools.
> 
> If I understand you correctly, the goal is to have everything under
> /sys/devices/ been represented by struct device objects and there are good
> reasons to do that.
> 
> In that case we either have to move the things exported via sysdevs somewhere
> else (presumably having to create that "somewhere" before), or we have to
> introduce struct device objects specifically for exporting them.  I don't
> really think the latter approach will be very popular, so quite likely we'll
> need to have a plan for moving those things to different locations.

We can just keep the same location for anything that is expected to be
in /sys/devices/system. All outside visible difference is that these
devices (then struct device) also have a "subsystem" (bus_type) which
carries the flat list of devices, the devices have a "uevent" file and
with that they are coldpluggable, event re-triggerable, could have
modalias, ... and all the other 1000 things that just work today, and
what we need for many of them. They are then just handled like any other
exported device too.

Kay

