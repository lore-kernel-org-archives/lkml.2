Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1CVXq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:46:56 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:53152 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755649Ab1CVXqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:46:51 -0400
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev
 class and sysdev
From: Kay Sievers <kay.sievers@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
In-Reply-To: <201103230032.37417.rjw@sisk.pl>
References: <201103100131.58206.rjw@sisk.pl>
	 <201103222323.42627.rjw@sisk.pl> <1300833843.1815.53.camel@zag>
	 <201103230032.37417.rjw@sisk.pl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 23 Mar 2011 00:46:29 +0100
Message-ID: <1300837589.1424.10.camel@zag>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-23 at 00:32 +0100, Rafael J. Wysocki wrote:
> On Tuesday, March 22, 2011, Kay Sievers wrote:
> > On Tue, 2011-03-22 at 23:23 +0100, Rafael J. Wysocki wrote:
> > > On Tuesday, March 22, 2011, Kay Sievers wrote:
> ...
> > > 
> > > Now, I can easily understand arguments about representing everything under
> > > /sys/devices/ by struct device objects, no question about that.  However,
> > > I also think there should be a place for things like those mentioned in the
> > > comment in sys.c, presumably outside of /sys/devices/.
> > 
> > No, please. We have all we need. Let's do one example, which you might
> > apply to any other thing, because you never know what's the next big
> > thing in hardware. We need to be a future-proof-as-possible, and that's
> > not some second-class out-of-scope sysfs directory.
> > 
> > Lets' take CPUs:
> >   - they send events when registered
> >   - they want to export device specific properties
> >   - userspace wants to take actions when such devices are available
> > 
> > That all fits properly into the driver model in theory. Unless you do
> > coldplug and bootup a box.
> > 
> > These devices are already there before userspace even starts, hence we
> > find all these devices and "trigger" an fake uevent for all of them at
> > bootup. That will match execute all the rules specified for that device,
> > just as it would be hotplugges in that moment, hence we call it
> > coldplug, which works for all devices with the hotplug code, even when
> > they are never hot-pluggable.
> > 
> > What we do for coldplug is that we iterate over all flat lists of
> > subsystems and find the devices lists and trigger the event by poking in
> > the "uevent" sysfs file. Now all the sysdevs do not have a subsystem to
> > find, and do not have a standard "uevent" file.
> > 
> > Back to the CPUs, we have all the nice device directories which could
> > have all the CPU features in properties we need to make autoloading of
> > cpufreq, governer, kvm possible (patch exists from Andi Kleen already) 
> > 
> > But these dumb CPU sysfs device directories are completely invisible for
> > the *usual* logic, and should just join the model and all will just work
> > out-of-the-box.
> 
> That all is cool, but I'm not sure how it is related to things like
> available_clocksource and current_clocksource (which happen to be located
> under /sys/devices/system/clocksource/clocksource0/ being simply a path
> in sysfs).

Sure, it isn't related to clocksource at all. I didn't really get the
idea that there are users that just fake core devices only to get a
place to put a couple of attributes. I was still in the context of the
$SUBJECT of this thread.

This stuff should just stay away from devices, not sysdev, not "struct
device".

For other things like CPUs, which are fine to be represented as driver
core devices, all the above is still valid, and they should be real
devices and have their own subsystem, which exposes them to coldplug and
usual event handling.

> Well, Greg apparently thinks that available_clocksource and current_clocksource
> could be located under /sys/bus/clock/.  Perhaps other attributes now exported
> through sysdevs could be moved to places like this?

Sure, we could do that. All such subsystems have a directory to put
subsystem-global stuff. In this case it would be a subsystem without any
registered device. But it leaves us open to add real devices to it
later, which might be the case for some similar subsystems.

The other option would be /sys/kernel/clocksource/ with the few
attributes to create.

We should decide if "clocksource" is kind of "device-related" or not. Do
you have any list of subsystems besides "clocksource", which would help
to get a bigger picture what we should expect?

Kay

