Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab1CVWBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:01:21 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:47938 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932391Ab1CVWBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:01:20 -0400
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev
 class and sysdev
From: Kay Sievers <kay.sievers@suse.de>
To: Paul Mundt <lethal@linux-sh.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
In-Reply-To: <20110322214922.GA7503@linux-sh.org>
References: <201103100131.58206.rjw@sisk.pl>
	 <201103222130.46603.rjw@sisk.pl> <1300826390.1815.5.camel@zag>
	 <201103222200.52131.rjw@sisk.pl> <1300828356.1815.15.camel@zag>
	 <20110322214922.GA7503@linux-sh.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 22 Mar 2011 23:00:56 +0100
Message-ID: <1300831256.1815.22.camel@zag>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-23 at 06:49 +0900, Paul Mundt wrote:
> On Tue, Mar 22, 2011 at 10:12:36PM +0100, Kay Sievers wrote:
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
> > 
> This is starting to get silly. In the case of interrupt controllers as
> with clocksources the bus abstraction is completely meaningless. I could
> register a type of "system" bus, but how would that be any different from
> what we have from sysdevs already today? All it does is force people to
> duplicate crap all over the place instead and pretend like extra busses
> exist in order to fit some arbitrary definition of how the driver model
> should work.
> 
> You talk about inventing special interfaces to bypass the device model,
> but that's not the case here. Rolling my own interface with kobjects and
> attribute groups as with /sys/power or making an arbitrary bus type for a
> single class of system devices seems infinitely more hackish than the
> current sysdev model.
> 
> The comment at the top of sys.c says:
> 
>  * sys.c - pseudo-bus for system 'devices' (cpus, PICs, timers, etc)

Which is what we need to get rid of. It does not make any sense on the
global picture to have anything like that exported to userspace.

> Which is precisely where I would expect interrupt controllers and timers
> and CPUs to go. I'm not going to make an IRQ bus or a timer bus and
> arbitrarily map some things there and some things somewhere else in the
> name of some abstraction insanity. These interrupt controllers all have
> consistent attributes that make the sysdev class model work well, but
> there are also many other types of interrupt controllers on the same CPUs
> that use a different abstraction.
> 
> Beyond that, we also have sysdev class utilization for DMA controllers,
> per-CPU store queues, etc, etc. all of which would need to be converted
> to something else (see for example arch/sh/kernel/cpu/sh4/sq.c -- which
> in turn was modelled after the cpufreq code, which also would need to
> change to something else). It's not entirely obvious how to convert these
> things, or why one should even bother. I can live with the struct device
> overhead even if I find it to be a meaningless abstraction in this case,
> but what sort of bus/class model to shoe horn these things in to is
> rather beyond me.
> 
> Indeed it seems to me that these are precisely the sorts of things that
> sysdevs are intended for, which is why I elected to use them from the
> onset. Simply saying "don't use sysdevs" and "pretend like you have some
> sort of a magical pseudo-bus that's not a system bus" doesn't quite do it
> for me.

Nope, a device has a "name", a "subsystem" and a "devpath", has
well-defined core-maintained properties at the device directory. It is
not some random custom directory which people can put where they like
it. Userspace has expectations about devices which need to be met, and
that can only happen if these devices are "struct device".

All real devices sort into a hierarchy, possibly in different parent
locations, and have a single point of classification which is the
devices/ directory and contains symlinks. Only that way we can cope with
it in userspace.

People should really stop messing around in /sys for optimization
purposes. We have a common device model, and need to use it. Sysdevs do
not fit into that model.

I can't tell how that fits into your use case, but please use something
else than sysfs, if you need device information exported, but you can't
use "struct device".

Thanks,
Kay

