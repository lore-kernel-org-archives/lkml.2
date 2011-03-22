Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab1CVUkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:40:22 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:59880 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755048Ab1CVUkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:40:16 -0400
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev
 class and sysdev
From: Kay Sievers <kay.sievers@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Paul Mundt <lethal@linux-sh.org>,
        "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
In-Reply-To: <201103222130.46603.rjw@sisk.pl>
References: <201103100131.58206.rjw@sisk.pl>
	 <20110322140420.GA24004@linux-sh.org> <1300803596.1456.10.camel@zag>
	 <201103222130.46603.rjw@sisk.pl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 22 Mar 2011 21:39:50 +0100
Message-ID: <1300826390.1815.5.camel@zag>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 21:30 +0100, Rafael J. Wysocki wrote:
> On Tuesday, March 22, 2011, Kay Sievers wrote:
> > On Tue, 2011-03-22 at 23:04 +0900, Paul Mundt wrote:
> > > On Sat, Mar 19, 2011 at 01:47:27AM +0100, Rafael J. Wysocki wrote:
> > > > On Thursday, March 17, 2011, Paul Mundt wrote:
> > > > > On Sun, Mar 13, 2011 at 02:03:49PM +0100, R. J. Wysocki wrote:
> > > > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > > 
> > > > > > Convert the SuperH clocks framework and shared interrupt handling
> > > > > > code to using struct syscore_ops instead of a sysdev classes and
> > > > > > sysdevs for power managment.
> > > > > > 
> > > > > > This reduces the code size significantly and simplifies it.  The
> > > > > > optimizations causing things not to be restored after creating a
> > > > > > hibernation image are removed, but they might lead to undesirable
> > > > > > effects during resume from hibernation (e.g. the clocks would be left
> > > > > > as the boot kernel set them, which might be not the same way as the
> > > > > > hibernated kernel had seen them before the hibernation).
> > > > > > 
> > > > > > This also is necessary for removing sysdevs from the kernel entirely
> > > > > > in the future.
> > > > > > 
> > > > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > 
> > > > > This misses the use of the sysdev class by the userimask code, though I'm
> > > > > open to suggestions for alternatives.
> > > > 
> > > > For now, I'd simply move the sysdev class definition to userimask.c, like
> > > > in the patch below.  The current goal is to eliminate the suspend/resume and
> > > > shutdown operations from sysdevs (and sysdev drivers), the next step will
> > > > be to replace the remaining sysdevs with alternative mechanisms.
> > > > 
> > > It's not quite that straightforward, you've also killed off the name
> > > attribute for each of the intc sysdevs, so we no longer have a visible
> > > way to map a given intc controller number to the controller name in a
> > > user visible way.
> > > 
> > > I'm not opposed to the syscore thing for suspend/resume ops, but I'm not
> > > willing to trash the userimask and name mapping interface in the process
> > > with no alternatives.
> > > 
> > > userimask was the first global configuration item I added, but there are
> > > other per-controller and global configuration knobs that I plan to export
> > > through the interface, so there really needs to be a compelling reason
> > > for moving off of sysdevs.
> > 
> > Yes, they don't fit into the model. They have been a dumb hack from the
> > first day, and never integrated into the kenrel driver core or hotplug
> > properly.
> > 
> > If you need the userspace visibility, better just add a "struct
> > bus_type" with a proper name for your subsystem and register a "struct
> > device" with the bus_type assigned for all of them, instead of using the
> > broken concept of sydevs. You can even make them show up
> > in /sys/devices/system/<bus_type name>/<struct device name>/ if you want
> > to.
> 
> I don't really think that's going to be useful in this particular case.
> The reason is, first, because the struct device would cause lots of other
> stuff to show up in sysfs which would be totally redundant and confusing
> and, second, because the things exported here are simply static attributes,
> pretty much like the stuff in /sys/power/.
> 
> Perhaps there's a more straightforward way to make some files show up in
> sysfs on a specific path than defininig an otherwise useless bus type and
> device object?

That's absolutely not the point. Please don't get yourself into that
thinking. If people want to "export stuff to userspace", they must not
invent new things. We need to get rid of the silly special cases.
Userspace is not meant to learn subsystem specific rules for every new
thing. There is _one_ way to export device attributes, and that is
"struct device" today.

If that's to expensive for anybody, just don't use sysfs. It's the rule
we have today. :)

> > That way userspace can properly enumerate them in a flat list
> > in /sys/bus/<bus_type name>/devices/*, and gets proper events on module
> > load and during system coldplug, and can hook into the usual hotplug
> > pathes to set/get these values instead of crawling magicly defined and
> > decoupled locations in /sys which can not express proper hierarchy,
> > classicication, or anything else that all other devices can just do.
> 
> There's no hotplug involved or anything remotely like that AFAICS.
> There are simply static files as I said above, they are created
> early during system initialization and simply stay there.

That's not the point. It's about a single way to retrieve information
about devices, extendability, and coldplug during bootup, where existing
devices need to be handled only after userspace is up. That is just a
case of "hotplug" that has the same codepath for userspace, even when
the devices can never really come and go.

> > There is really no reason for any device being a magic and conceptually
> > broken sysdev today - just to be different from any other device the
> > kernel exports to userspace.
> 
> It's not a "device being a sysdev", it's sysdevs being used for creating
> a user space interface, which isn't broken by itself.

Yeah , absolutely. But if any device wants to export anything is _must_
be a "struct device" today. If that does not fit, it must not use sysfs
at all.

Kay

