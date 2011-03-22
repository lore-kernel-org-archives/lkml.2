Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1CVWo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:44:29 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:47812 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752417Ab1CVWo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:44:26 -0400
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev
 class and sysdev
From: Kay Sievers <kay.sievers@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
In-Reply-To: <201103222323.42627.rjw@sisk.pl>
References: <201103100131.58206.rjw@sisk.pl>
	 <20110322214922.GA7503@linux-sh.org> <1300831256.1815.22.camel@zag>
	 <201103222323.42627.rjw@sisk.pl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 22 Mar 2011 23:44:03 +0100
Message-ID: <1300833843.1815.53.camel@zag>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 23:23 +0100, Rafael J. Wysocki wrote:
> On Tuesday, March 22, 2011, Kay Sievers wrote:
> > On Wed, 2011-03-23 at 06:49 +0900, Paul Mundt wrote:
> ...
> > > You talk about inventing special interfaces to bypass the device model,
> > > but that's not the case here. Rolling my own interface with kobjects and
> > > attribute groups as with /sys/power or making an arbitrary bus type for a
> > > single class of system devices seems infinitely more hackish than the
> > > current sysdev model.
> > > 
> > > The comment at the top of sys.c says:
> > > 
> > >  * sys.c - pseudo-bus for system 'devices' (cpus, PICs, timers, etc)
> > > 
> > > Which is precisely where I would expect interrupt controllers and timers
> > > and CPUs to go. I'm not going to make an IRQ bus or a timer bus and
> > > arbitrarily map some things there and some things somewhere else in the
> > > name of some abstraction insanity. These interrupt controllers all have
> > > consistent attributes that make the sysdev class model work well, but
> > > there are also many other types of interrupt controllers on the same CPUs
> > > that use a different abstraction.
> > > 
> > > Beyond that, we also have sysdev class utilization for DMA controllers,
> > > per-CPU store queues, etc, etc. all of which would need to be converted
> > > to something else (see for example arch/sh/kernel/cpu/sh4/sq.c -- which
> > > in turn was modelled after the cpufreq code, which also would need to
> > > change to something else). It's not entirely obvious how to convert these
> > > things, or why one should even bother.
> 
> The reason why is, if I understand it correctly, because user space tools
> generally expect /sys/devices/ to be consistent in terms of the representation
> of things and /sys/devices/system/ currently violates that expectation which
> leads to all sorts of problems with device discovery, hotplug etc.
> 
> Now, whether or not to convert all the things currently exported through
> sysdevs to struct device objects is not too obvious to me.  I think it simply
> may be better to move them into a different direcory in sysfs (presumably
> creating one for this purpose).
> 
> > > I can live with the struct device overhead even if I find it to be a
> > > meaningless abstraction in this case, but what sort of bus/class model to
> > > shoe horn these things in to is rather beyond me.
> > > 
> > > Indeed it seems to me that these are precisely the sorts of things that
> > > sysdevs are intended for, which is why I elected to use them from the
> > > onset. Simply saying "don't use sysdevs" and "pretend like you have some
> > > sort of a magical pseudo-bus that's not a system bus" doesn't quite do it
> > > for me.
> > 
> > Nope, a device has a "name", a "subsystem" and a "devpath", has
> > well-defined core-maintained properties at the device directory. It is
> > not some random custom directory which people can put where they like
> > it. Userspace has expectations about devices which need to be met, and
> > that can only happen if these devices are "struct device".
> > 
> > All real devices sort into a hierarchy, possibly in different parent
> > locations, and have a single point of classification which is the
> > devices/ directory and contains symlinks. Only that way we can cope with
> > it in userspace.
> > 
> > People should really stop messing around in /sys for optimization
> > purposes. We have a common device model, and need to use it. Sysdevs do
> > not fit into that model.
> > 
> > I can't tell how that fits into your use case, but please use something
> > else than sysfs, if you need device information exported, but you can't
> > use "struct device".
> 
> I really think you shouldn't say "sysfs" when you in fact you mean
> "/sys/devices/". :-)
> 
> Now, I can easily understand arguments about representing everything under
> /sys/devices/ by struct device objects, no question about that.  However,
> I also think there should be a place for things like those mentioned in the
> comment in sys.c, presumably outside of /sys/devices/.

No, please. We have all we need. Let's do one example, which you might
apply to any other thing, because you never know what's the next big
thing in hardware. We need to be a future-proof-as-possible, and that's
not some second-class out-of-scope sysfs directory.

Lets' take CPUs:
  - they send events when registered
  - they want to export device specific properties
  - userspace wants to take actions when such devices are available

That all fits properly into the driver model in theory. Unless you do
coldplug and bootup a box.

These devices are already there before userspace even starts, hence we
find all these devices and "trigger" an fake uevent for all of them at
bootup. That will match execute all the rules specified for that device,
just as it would be hotplugges in that moment, hence we call it
coldplug, which works for all devices with the hotplug code, even when
they are never hot-pluggable.

What we do for coldplug is that we iterate over all flat lists of
subsystems and find the devices lists and trigger the event by poking in
the "uevent" sysfs file. Now all the sysdevs do not have a subsystem to
find, and do not have a standard "uevent" file.

Back to the CPUs, we have all the nice device directories which could
have all the CPU features in properties we need to make autoloading of
cpufreq, governer, kvm possible (patch exists from Andi Kleen already) 

But these dumb CPU sysfs device directories are completely invisible for
the *usual* logic, and should just join the model and all will just work
out-of-the-box.

When we started to clean up /sys (again only talking about devices, not
other stuff) we had:
  /block/*
  /class/<subsys>/*
  /bus/<subsys>/devices/*
  /devices/system/<subsys>/*
which are 4 different exports of exactly the same thing, a "device".
"Block" we converted to "class" already, "class" will be converted to
"bus", and "bus" will be renamed to "subsystem". All the current names
will be kept as compat symlinks, just as we did for "block". After that,
_all_ devices have a "subsystem" and a subsystem global directory where
people can add custom stuff shared by all devices-of-the-same-type. Ev

You can also argument from the other side, if a kernel device export is
not worth the few bytes of /sys/devices/ and a "subsystem" (struct
bus_type) it should not be in /sys at all, especially not hidden
somehwere outside of /sys/devices when it is something remotely close to
a device.

Kay

