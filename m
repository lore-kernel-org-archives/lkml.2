Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1CVOUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:20:20 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:36158 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409Ab1CVOUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 10:20:17 -0400
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev
 class and sysdev
From: Kay Sievers <kay.sievers@suse.de>
To: Paul Mundt <lethal@linux-sh.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
In-Reply-To: <20110322140420.GA24004@linux-sh.org>
References: <201103100131.58206.rjw@sisk.pl>
	 <201103131403.49561.rwys@fuw.edu.pl> <20110317082016.GB13315@linux-sh.org>
	 <201103190147.28001.rjw@sisk.pl>  <20110322140420.GA24004@linux-sh.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 22 Mar 2011 15:19:56 +0100
Message-ID: <1300803596.1456.10.camel@zag>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 23:04 +0900, Paul Mundt wrote:
> On Sat, Mar 19, 2011 at 01:47:27AM +0100, Rafael J. Wysocki wrote:
> > On Thursday, March 17, 2011, Paul Mundt wrote:
> > > On Sun, Mar 13, 2011 at 02:03:49PM +0100, R. J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > Convert the SuperH clocks framework and shared interrupt handling
> > > > code to using struct syscore_ops instead of a sysdev classes and
> > > > sysdevs for power managment.
> > > > 
> > > > This reduces the code size significantly and simplifies it.  The
> > > > optimizations causing things not to be restored after creating a
> > > > hibernation image are removed, but they might lead to undesirable
> > > > effects during resume from hibernation (e.g. the clocks would be left
> > > > as the boot kernel set them, which might be not the same way as the
> > > > hibernated kernel had seen them before the hibernation).
> > > > 
> > > > This also is necessary for removing sysdevs from the kernel entirely
> > > > in the future.
> > > > 
> > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > This misses the use of the sysdev class by the userimask code, though I'm
> > > open to suggestions for alternatives.
> > 
> > For now, I'd simply move the sysdev class definition to userimask.c, like
> > in the patch below.  The current goal is to eliminate the suspend/resume and
> > shutdown operations from sysdevs (and sysdev drivers), the next step will
> > be to replace the remaining sysdevs with alternative mechanisms.
> > 
> It's not quite that straightforward, you've also killed off the name
> attribute for each of the intc sysdevs, so we no longer have a visible
> way to map a given intc controller number to the controller name in a
> user visible way.
> 
> I'm not opposed to the syscore thing for suspend/resume ops, but I'm not
> willing to trash the userimask and name mapping interface in the process
> with no alternatives.
> 
> userimask was the first global configuration item I added, but there are
> other per-controller and global configuration knobs that I plan to export
> through the interface, so there really needs to be a compelling reason
> for moving off of sysdevs.

Yes, they don't fit into the model. They have been a dumb hack from the
first day, and never integrated into the kenrel driver core or hotplug
properly.

If you need the userspace visibility, better just add a "struct
bus_type" with a proper name for your subsystem and register a "struct
device" with the bus_type assigned for all of them, instead of using the
broken concept of sydevs. You can even make them show up
in /sys/devices/system/<bus_type name>/<struct device name>/ if you want
to.

That way userspace can properly enumerate them in a flat list
in /sys/bus/<bus_type name>/devices/*, and gets proper events on module
load and during system coldplug, and can hook into the usual hotplug
pathes to set/get these values instead of crawling magicly defined and
decoupled locations in /sys which can not express proper hierarchy,
classicication, or anything else that all other devices can just do.

There is really no reason for any device being a magic and conceptually
broken sysdev today - just to be different from any other device the
kernel exports to userspace.

Thanks,
Kay

