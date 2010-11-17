Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238Ab0KQLbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 06:31:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:37125 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962Ab0KQLbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 06:31:02 -0500
Subject: Re: [RFC][PATCH] perf: sysfs type id
From: Peter Zijlstra <peterz@infradead.org>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        "robert.richter" <robert.richter@amd.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <AANLkTikz6+_Ue53P1DmOyZD1+0SoMsX0NwdvqiT-5Ced@mail.gmail.com>
References: <1289339119.2191.92.camel@laptop>
	 <AANLkTi=ojOnLyRO4hTgYdCCXLsN0wUeTcme=5h8-mjdz@mail.gmail.com>
	 <1289398207.2191.117.camel@laptop> <1289398763.2191.121.camel@laptop>
	 <AANLkTimQ7w38wzrYT4MgjHFr6LCVj2M5fB11-n3XCD2w@mail.gmail.com>
	 <1289421164.2084.56.camel@laptop>
	 <AANLkTiku7UsVoYv_+6r79rvGPJU7OU=VGDiaYo0H=82y@mail.gmail.com>
	 <1289423135.2084.63.camel@laptop> <4CE33F86.7040403@linux.vnet.ibm.com>
	 <AANLkTikz6+_Ue53P1DmOyZD1+0SoMsX0NwdvqiT-5Ced@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 12:30:47 +0100
Message-ID: <1289993447.2109.717.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 02:02 -0500, Kyle Moffett wrote:
> 
> Not quite.  I'm still a relative newbie to bits and pieces of the
> device model, but I'll explain what I believe the best representation
> would be:
> 
> Assuming you have counters on graphics cards, you would already have
> the PCI device directories for the GPUs themselves.  For example:
> /sys/devices/[...]/0000:01:00.0/
> /sys/devices/[...]/0000:02:00.0/
> 
> Those already obviously have various DRM-related device directories
> under them, but I'll assume the PMU is tied directly to the PCI device
> (although it could be put elsewhere if appropriate).
> 
> So then I believe you would create your "PMU" devices with names
> "pmu0", "pmu1", etc, and set their "parent" to point to the PCI
> device, and set their "bus" to point to the "pmu" bus.
> 
> What would happen is you would get subdirectories for your "pmu" devices
> /sys/devices/[...]/0000:01:00.0/pmu0/
> /sys/devices/[...]/0000:02:00.0/pmu1/
> 
> Each of those devices would have a "driver" symlink inside pointing to
> something like:
> /sys/subsystem/pmu/drivers/radeonpmu
> 
> There would also be symlinks:
> /sys/subsystem/pmu/devices/pmu0 => ../../../../devices/[...]/0000:01:00.0/pmu0
> /sys/subsystem/pmu/devices/pmu1 => ../../../../devices/[...]/0000:02:00.0/pmu1
> 
> So that lets you find your various PMU devices.
> 
> Then you'd have another "bus", perhaps, for "pmuevents", where the
> "pmuevent" device nodes get useful names.  Please note that including
> the PMU name in the event name is necessary as you cannot have two
> devices on the same "bus" with the exact same name.
> /sys/devices/[...]/0000:01:00.0/pmu0/pmu0:gpu_idle/
> /sys/devices/[...]/0000:01:00.0/pmu0/pmu0:gpu_throttle/
> /sys/devices/[...]/0000:02:00.0/pmu1/pmu1:gpu_idle/
> /sys/devices/[...]/0000:02:00.0/pmu1/pmu1:gpu_throttle/
> 
> Each event directory would contain other directories full of various
> registered attributes of the event.
> 
> And again the directory full of symlinks (this is what requires the
> "different names" thing as mentioned above):
> /sys/subsystem/pmuevent/devices/pmu0:gpu_idle => [......]
> /sys/subsystem/pmuevent/devices/pmu0:gpu_throttle => [......]
> /sys/subsystem/pmuevent/devices/pmu1:gpu_idle => [......]
> /sys/subsystem/pmuevent/devices/pmu1:gpu_throttle => [......]
> 
> So if you wanted to enumerate all of the "gpu_idle" events on the
> system, you could just do:
> ls /sys/subsystem/pmuevent/devices/*:gpu_idle
> 
> And then by following the symlinks into /sys/devices and traversing
> the path upwards you can examine all of the other properties the same
> way that udev does. 

I've been talking to Kay for a bit and I've settled on one bus
"event_source", I register devices to that, and each device gets an
attribute_group "events" with events in.

Implementing that is painful enough, when I get it working I'll post it
as RFC and if someone with more sysfs skill than me is willing to help
out that's nice, but implementing something like Kyle says is waaaay
beyond me, sysfs is teh crazeh.
