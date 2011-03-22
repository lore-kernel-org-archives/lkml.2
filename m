Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1CVWme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:42:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57948 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab1CVWmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:42:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kay Sievers <kay.sievers@suse.de>
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev class and sysdev
Date: Tue, 22 Mar 2011 23:42:20 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Greg KH <gregkh@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
References: <201103100131.58206.rjw@sisk.pl> <201103222305.01808.rjw@sisk.pl> <1300832411.1815.35.camel@zag>
In-Reply-To: <1300832411.1815.35.camel@zag>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103222342.20526.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 22, 2011, Kay Sievers wrote:
> On Tue, 2011-03-22 at 23:05 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, March 22, 2011, Kay Sievers wrote:
> > > On Tue, 2011-03-22 at 22:00 +0100, Rafael J. Wysocki wrote:
> > > > On Tuesday, March 22, 2011, Kay Sievers wrote:
> > > > > On Tue, 2011-03-22 at 21:30 +0100, Rafael J. Wysocki wrote:
> > > > > > 
> > > > > > Perhaps there's a more straightforward way to make some files show up in
> > > > > > sysfs on a specific path than defininig an otherwise useless bus type and
> > > > > > device object?
> > > > > 
> > > > > That's absolutely not the point. Please don't get yourself into that
> > > > > thinking. If people want to "export stuff to userspace", they must not
> > > > > invent new things. We need to get rid of the silly special cases.
> > > > 
> > > > Why exactly?  Do they actually hurt anyone and if so then how?
> > > 
> > > Sure, "devices" are devices, and devices have well-defines set of
> > > properties, not some magic directory, people can mess around with the
> > > way they like.
> > 
> > So it looks like the the problem is that the exported attributes happen to
> > be under /sys/devices/.  Would it still be a problem if they were somewhere
> > else?
> 
> We are not going to invent another location for any devices. They need
> to stay in /devices if they are devices. And all devices need to be
> "struct device".

_They_ _are_ _not_ _devices_.

Please take clocksource as an example.  It needs to export two attributes,
available_clocksource and current_clocksource, which are _useful_ user space
interfaces.  Why the heck are you trying to convince me it's a good idea to
create a special bus type and struct device _specifically_ for exporting them?!

Moreover, is there anything device-alike in those two attributes?  I don't
really think so.

So please stop arguing this way, because it simply isn't going to fly and
people will always say a big fat "no" to such ideas, for a good reason.

> > > > > Userspace is not meant to learn subsystem specific rules for every new
> > > > > thing.
> > > > 
> > > > That depends a good deal of who's writing the user space in question.  If
> > > > that's the same person who's working on the particular part of the kernel,
> > > > I don't see a big problem.
> > > 
> > > Not for "devices". There are rules for devices, which are defined by the
> > > driver core, and the sysdev stuff needs to go, because it does not fit
> > > into that model.
> > 
> > OK, I understand that.
> > 
> > Now, there's stuff that doesn't really match the "device" model.  Where is
> > the right place to export that?  Perhaps we should add something like
> > /sys/platform/ (in analogy with /sys/firmware/)?
> 
> No, add a subsystem (bus_type) for any of them, and register them. There
> is no such thing as "devices which do not fit the device model", they
> are all fine there. Please stop optimizing single bytes and creating a
> mess in /sys. Every device is a "struct device".

Again.  Those things are _not_ devices.  Am I not clear enough?

> Think of "struct bus_type" as "struct subsystem", we will rename that
> when we are ready. It is just a group of devices which are of the same
> type, it has nothing to do with a bus in the sense of hardware.
> 
> We need unified exports of _all devices to userspace, not custom layouts
> in /sys.
> 
> There's is a pretty much outdated Documentation/sysfs-rules.txt, wich
> covers part of the history and the plans.

You seem to be thinking that anything exported through sysfs needs to be
device, which I don't think is event approximately correct (what about
/sys/firmware/ or /sys/kernel/ or /sys/fs/ , for a few examples?).

Think this way: it is useful (and IMHO correct) to export some things to
user space that without necessarily regarding them as "devices", physical
or not.  Some of them _happen_ to be exported through sysdevs, but that
doesn't really mean the _are_ devices.  They are simply _software_ interfaces
to things that have no device representation and don't _need_ one.

> > > > > There is _one_ way to export device attributes, and that is
> > > > > "struct device" today.
> > > > > 
> > > > > If that's to expensive for anybody, just don't use sysfs. It's the rule
> > > > > we have today. :)
> > > > 
> > > > Oh, good to know.  It's changed a bit since I last heard.  Never mind.
> > > 
> > > Oh, don't get me wrong, this is all is about "devices" not any other
> > > controls.
> > >
> > > > Still, I won't let you change the things in /sys/power to struct devices,
> > > > sorry about that. ;-)
> > > 
> > > Fine as long as they are power specific things, and not "devices". You
> > > don't have sysdevs there, right? :)
> > 
> > No, I don't.
> 
> Then all is fine. All other stuff is more like /proc, and can never be
> really unified.

YES!  And _that_'s precisely what I'm (and Paul is) talking about.

> All we care about is devices, which have common methods
> for userspace to trigger and consume, and need to be unified. Power
> specific control files seems all fine in its kobject use.

I understand that, really.

> > > > And I wonder how are you going to deal with clocksource exporting things
> > > > via the sysdev interface right now.  I'd simply create two directories and
> > > > put the two files into them and be done with that, but I guess that
> > > > wouldn't fit into the model somehow, right?
> > > 
> > > Nope, register a bus_type, and use struct device for all of them, Parent
> > > them to /sys/devices/system/ if they should keep their location and
> > > layout.
> > 
> > Well, I'll be watching what happens to the patch trying to do that, but I'm
> > not going to bet anything on its success. ;-)
> 
> It should be pretty straight-forward. We will need to do that for CPUs I
> guess, because the interface is kinda commonly used.

No.  CPUs are _very_ special.

> > > > > > > That way userspace can properly enumerate them in a flat list
> > > > > > > in /sys/bus/<bus_type name>/devices/*, and gets proper events on module
> > > > > > > load and during system coldplug, and can hook into the usual hotplug
> > > > > > > pathes to set/get these values instead of crawling magicly defined and
> > > > > > > decoupled locations in /sys which can not express proper hierarchy,
> > > > > > > classicication, or anything else that all other devices can just do.
> > > > > > 
> > > > > > There's no hotplug involved or anything remotely like that AFAICS.
> > > > > > There are simply static files as I said above, they are created
> > > > > > early during system initialization and simply stay there.
> > > > > 
> > > > > That's not the point. It's about a single way to retrieve information
> > > > > about devices, extendability, and coldplug during bootup, where existing
> > > > > devices need to be handled only after userspace is up.
> > > > 
> > > > I'd say the case at hand has nothing to do with that.
> > > 
> > > It has. As for CPUs. We can not do proper CPU-dependent module
> > > autoloading, because the events happen before userspace runs, and
> > > clodplug can not see the broken sysdevs, because they have no events to
> > > re-trigger, like all others have.
> > 
> > Well, as I said, would it be OK if the things in question happened to be
> > located somewhere outside of /sys/devices/ ?
> 
> No, no device directory can be outside of /sys/devices.

Sorry, I'm repeating that for the last time.  I'm not talking about devices.
I'm talking about _totally_ _random_ _stuff_ which is "like /proc, and can
never be really unified" (your own words) which _happens_ to be exported
through the sysdev interface, because that happend to be _easy_ at one point.
Can we agree on that at least?

Thanks,
Rafael
