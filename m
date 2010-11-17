Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab0KQHCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 02:02:46 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63291 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759710Ab0KQHCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 02:02:44 -0500
MIME-Version: 1.0
In-Reply-To: <4CE33F86.7040403@linux.vnet.ibm.com>
References: <1289339119.2191.92.camel@laptop> <AANLkTi=ojOnLyRO4hTgYdCCXLsN0wUeTcme=5h8-mjdz@mail.gmail.com>
 <1289398207.2191.117.camel@laptop> <1289398763.2191.121.camel@laptop>
 <AANLkTimQ7w38wzrYT4MgjHFr6LCVj2M5fB11-n3XCD2w@mail.gmail.com>
 <1289421164.2084.56.camel@laptop> <AANLkTiku7UsVoYv_+6r79rvGPJU7OU=VGDiaYo0H=82y@mail.gmail.com>
 <1289423135.2084.63.camel@laptop> <4CE33F86.7040403@linux.vnet.ibm.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 17 Nov 2010 02:02:22 -0500
Message-ID: <AANLkTikz6+_Ue53P1DmOyZD1+0SoMsX0NwdvqiT-5Ced@mail.gmail.com>
Subject: Re: [RFC][PATCH] perf: sysfs type id
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        "robert.richter" <robert.richter@amd.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 21:35, Corey Ashford
<cjashfor@linux.vnet.ibm.com> wrote:
> On 11/10/2010 01:05 PM, Peter Zijlstra wrote:
>> On Wed, 2010-11-10 at 21:53 +0100, Stephane Eranian wrote:
>>> On Wed, Nov 10, 2010 at 9:32 PM, Peter Zijlstra<peterz@infradead.org> wrote:
>>>> possible, or something like<pmu-name>:<event-name>, cpu:cycles would
>>>> map to /sys/class/pmu/cpu/events/cycles (given the previous patch).
>>>
>>> Ok, but I think you're proposal is missing one bit. You are addressing
>>> the class (or type) of PMU, but you are not addressing the naming of
>>> an instance.
>>>
>>> Let's take an example, suppose you have counters on a graphic card.
>>> Your system has two such graphic cards. In your scheme you would
>>> end up with a sys/class/pmu/gfx/.....

Not quite.  I'm still a relative newbie to bits and pieces of the
device model, but I'll explain what I believe the best representation
would be:

Assuming you have counters on graphics cards, you would already have
the PCI device directories for the GPUs themselves.  For example:
/sys/devices/[...]/0000:01:00.0/
/sys/devices/[...]/0000:02:00.0/

Those already obviously have various DRM-related device directories
under them, but I'll assume the PMU is tied directly to the PCI device
(although it could be put elsewhere if appropriate).

So then I believe you would create your "PMU" devices with names
"pmu0", "pmu1", etc, and set their "parent" to point to the PCI
device, and set their "bus" to point to the "pmu" bus.

What would happen is you would get subdirectories for your "pmu" devices
/sys/devices/[...]/0000:01:00.0/pmu0/
/sys/devices/[...]/0000:02:00.0/pmu1/

Each of those devices would have a "driver" symlink inside pointing to
something like:
/sys/subsystem/pmu/drivers/radeonpmu

There would also be symlinks:
/sys/subsystem/pmu/devices/pmu0 => ../../../../devices/[...]/0000:01:00.0/pmu0
/sys/subsystem/pmu/devices/pmu1 => ../../../../devices/[...]/0000:02:00.0/pmu1

So that lets you find your various PMU devices.

Then you'd have another "bus", perhaps, for "pmuevents", where the
"pmuevent" device nodes get useful names.  Please note that including
the PMU name in the event name is necessary as you cannot have two
devices on the same "bus" with the exact same name.
/sys/devices/[...]/0000:01:00.0/pmu0/pmu0:gpu_idle/
/sys/devices/[...]/0000:01:00.0/pmu0/pmu0:gpu_throttle/
/sys/devices/[...]/0000:02:00.0/pmu1/pmu1:gpu_idle/
/sys/devices/[...]/0000:02:00.0/pmu1/pmu1:gpu_throttle/

Each event directory would contain other directories full of various
registered attributes of the event.

And again the directory full of symlinks (this is what requires the
"different names" thing as mentioned above):
/sys/subsystem/pmuevent/devices/pmu0:gpu_idle => [......]
/sys/subsystem/pmuevent/devices/pmu0:gpu_throttle => [......]
/sys/subsystem/pmuevent/devices/pmu1:gpu_idle => [......]
/sys/subsystem/pmuevent/devices/pmu1:gpu_throttle => [......]

So if you wanted to enumerate all of the "gpu_idle" events on the
system, you could just do:
ls /sys/subsystem/pmuevent/devices/*:gpu_idle

And then by following the symlinks into /sys/devices and traversing
the path upwards you can examine all of the other properties the same
way that udev does.

>>> But now, suppose I want to count cycles on the first graphic card.
>>> Seems to me you need to expose the instances as well. The instance
>>> number needs to be passed in the attr struct somehow.
>>>
>>> You can either create multiple subdir under gfx, or have this info
>>> somewhere
>>> else in the sysfs tree, if people really care about class vs. instance.
>>>
>>> I can see users doing:
>>> $ perf stat -e gfx@1::cycles ...  ->  sys/class/gfx/1/event/cycles
>>>
>>> The reason I am using :: here is because libpfm4 is already using
>>> this as a separator for PMU type vs. event.

So in this case, because all of the events get linked into a global
list, you could just use the "pmu0:gpu_idle" or some similar
derivation as a unique name with an easy lookup in
/sys/subsystem/pmuevent/devices/.  As above it's trivial to follow the
symlinks down into the real /sys/devices/ tree and see where it's
physically located.


> Some of these events may need modifiers / attributes / umasks... whatever
> you want to call them.  And they may need more than one each, and they may
> vary from event to event.  So to add to the hierarchy,
> we'd have:
>
> radeon0/
>    type (for attr.type)
>    event/
>        evt0/
>            id (a base number for attr.config)
>            description (text file - but could be CONFIG_*'d out)
>            modifiers/
>                mod0/
>                    formula (some ascii syntax for describing how
>                             to set .config and/or .config_extra
>                             with this modifer's value)
>                    description (text - can configure out)
>                    constraints (some ascii syntax for describing
>                                 the values mod0 can take on)
>                ..
>                modn/
>        ..
>        evtn/
>
> And this would be replicated for radeon1..n

As for the specific attribute hierarchy, I'm even less sure.  One
*potential* approach would be to create a "struct device_driver" for
each type of pmuevent.  You would then assign those drivers to each
pmuevent device as it is registered.

To determine how to *configure* the event you would then look up the
event name within the PMU driver, so for example:

Considering the previously-described:
/sys/devices/[...]/0000:01:00.0/pmu0/pmu0:gpu_idle/

You would look at the symlink to the PMU event driver:
/sys/devices/[...]/0000:01:00.0/pmu0/pmu0:gpu_idle/driver => [...]

That symlink would point to:
/sys/subsystem/pmuevent/drivers/radeonpmu:gpu_idle

You could then trivially add driver attributes to that directory for
describing the nitty-gritty details of that event.

I believe with the described model you could still use trivial and
short names like "pmu0:gpu_idle", and yet still be perfectly able to
reference them with all of the hardware in the system.  If you have
specific software events or PMUs that are not tied to any particular
hardware, you could easily fiddle with the parent pointer to stuff
them into /sys/devices/virtual/ along with other things like ptys.

Cheers,
Kyle Moffett
