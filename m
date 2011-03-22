Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1CVXcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:32:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58073 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab1CVXcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:32:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kay Sievers <kay.sievers@suse.de>
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev class and sysdev
Date: Wed, 23 Mar 2011 00:32:37 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
References: <201103100131.58206.rjw@sisk.pl> <201103222323.42627.rjw@sisk.pl> <1300833843.1815.53.camel@zag>
In-Reply-To: <1300833843.1815.53.camel@zag>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103230032.37417.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 22, 2011, Kay Sievers wrote:
> On Tue, 2011-03-22 at 23:23 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, March 22, 2011, Kay Sievers wrote:
...
> > 
> > Now, I can easily understand arguments about representing everything under
> > /sys/devices/ by struct device objects, no question about that.  However,
> > I also think there should be a place for things like those mentioned in the
> > comment in sys.c, presumably outside of /sys/devices/.
> 
> No, please. We have all we need. Let's do one example, which you might
> apply to any other thing, because you never know what's the next big
> thing in hardware. We need to be a future-proof-as-possible, and that's
> not some second-class out-of-scope sysfs directory.
> 
> Lets' take CPUs:
>   - they send events when registered
>   - they want to export device specific properties
>   - userspace wants to take actions when such devices are available
> 
> That all fits properly into the driver model in theory. Unless you do
> coldplug and bootup a box.
> 
> These devices are already there before userspace even starts, hence we
> find all these devices and "trigger" an fake uevent for all of them at
> bootup. That will match execute all the rules specified for that device,
> just as it would be hotplugges in that moment, hence we call it
> coldplug, which works for all devices with the hotplug code, even when
> they are never hot-pluggable.
> 
> What we do for coldplug is that we iterate over all flat lists of
> subsystems and find the devices lists and trigger the event by poking in
> the "uevent" sysfs file. Now all the sysdevs do not have a subsystem to
> find, and do not have a standard "uevent" file.
> 
> Back to the CPUs, we have all the nice device directories which could
> have all the CPU features in properties we need to make autoloading of
> cpufreq, governer, kvm possible (patch exists from Andi Kleen already) 
> 
> But these dumb CPU sysfs device directories are completely invisible for
> the *usual* logic, and should just join the model and all will just work
> out-of-the-box.

That all is cool, but I'm not sure how it is related to things like
available_clocksource and current_clocksource (which happen to be located
under /sys/devices/system/clocksource/clocksource0/ being simply a path
in sysfs).

> When we started to clean up /sys (again only talking about devices, not
> other stuff) we had:
>   /block/*
>   /class/<subsys>/*
>   /bus/<subsys>/devices/*
>   /devices/system/<subsys>/*
> which are 4 different exports of exactly the same thing, a "device".
> "Block" we converted to "class" already, "class" will be converted to
> "bus", and "bus" will be renamed to "subsystem". All the current names
> will be kept as compat symlinks, just as we did for "block". After that,
> _all_ devices have a "subsystem" and a subsystem global directory where
> people can add custom stuff shared by all devices-of-the-same-type. Ev

OK, sounds good.

> You can also argument from the other side, if a kernel device export is
> not worth the few bytes of /sys/devices/ and a "subsystem" (struct
> bus_type) it should not be in /sys at all, especially not hidden
> somehwere outside of /sys/devices when it is something remotely close to
> a device.

Well, Greg apparently thinks that available_clocksource and current_clocksource
could be located under /sys/bus/clock/.  Perhaps other attributes now exported
through sysdevs could be moved to places like this?

Rafael
