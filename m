Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab0ESGdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 02:33:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:12726 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab0ESGdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 02:33:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,260,1272870000"; 
   d="scan'208";a="622897302"
Subject: Re: [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Greg KH <greg@kroah.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100519050042.GA16022@kroah.com>
References: <1274233602.3036.84.camel@localhost>
	 <20100518200524.GA20223@kroah.com>
	 <1274236496.3603.22.camel@minggr.sh.intel.com>
	 <20100519024823.GA25229@kroah.com>
	 <1274240429.3603.76.camel@minggr.sh.intel.com>
	 <20100519050042.GA16022@kroah.com>
Content-Type: text/plain
Date: Wed, 19 May 2010 14:32:17 +0800
Message-Id: <1274250737.3603.128.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 13:00 +0800, Greg KH wrote:
> On Wed, May 19, 2010 at 11:40:29AM +0800, Lin Ming wrote:
> > On Wed, 2010-05-19 at 10:48 +0800, Greg KH wrote:
> > > On Wed, May 19, 2010 at 10:34:55AM +0800, Lin Ming wrote:
> > > > /sys/devices/system/cpu/events/
> > > > |-- L1-dcache-load-misses
> > > > |   |-- event_source -> ../../event_source
> > > > 
> > > > For above example, "event_source" is the cpu pmu and the "event" is
> > > > L1-dcache-load-misses.
> > > > 
> > > > Yes, they point to the same thing, because all the events
> > > > under /sys/devices/system/cpu/events/* is monitored by the same event
> > > > source, ie, the cpu pmu(/sys/devices/system/cpu/event_source/).
> > > 
> > > Then, why have a symlink if they are all going to be the same?
> > 
> > So how about move the symlink to parent directory, like
> > 
> > /sys/devices/system/cpu/event_source/
> > 
> > /sys/devices/system/cpu/events/
> > |-- event_source -> ../event_source
> 
> Again, why would that make any sense?  You would be creating a symlink
> to something that is always the same symlink.  Why would that even be
> needed?

Do you mean the target of the symlink is also a symlink? No.

/sys/devices/system/cpu/events/event_source points
to /sys/devices/system/cpu/event_source.

/sys/devices/system/cpu/event_source/ is a sysfs dir, not a symlink.

> 
> > > > > I'm still not really understanding what exactly you are trying to show
> > > > > in the sysfs tree here anyway, perhaps the documentation update will
> > > > > clear that up for me.
> > > > 
> > > > To support multiple pmus
> > > 
> > > What is a "pmu"?
> > 
> > Performance Monitoring Unit
> 
> What is a "unit"?
> 
> > > > (or call them event source),
> > > 
> > > What is an "event source"?
> > 
> > The source who generates the event.
> 
> The traditional way to define a word, or phrase, is to not use the word
> or phrase in the definition, otherwise that definition makes no sense.

Ingo's explanation looks much more clear.

<---snip start--->
We _really_ dont want to call it a 'PMU' but 'events coming from an event
source'.

The reason is that a PMU is an existing term that is quite attached to a CPU -
while many hardware events come not from a PMU. Interrupts, error conditions,
hotplug events, etc. etc.

Furthermore, the name 'PMU' is even less correct for software events.

So lets stick with 'events' and with some container that originates them.
(event_source) Ok?
<---snip end--->

> 
> > The event includes hardware events, cache-misses, bus-cycles,
> > interrupts, error conditions, hotplug......
> > and software events, context-switches, page-faults, sched events......
> 
> So, stuff that happens to a CPU that are usually handled in the
> performance counters portion of the CPU, right?

For cpu hardware events(cycles, branch-misses, L1-dcache-loads etc...),
yes.

> 
> Why put this in sysfs?  Why do you think that mapping this information
> there makes sense?

sysfs, "It provides a means to export kernel data structures, their
attributes, and the linkages between them to userspace."

pmus and events have attributes that userspace tool want to know, for
example, pmu id, event config value.

And they also have linkage, for example, cycles event uses cpu pmu to
handle it, so

/sys/devices/system/cpu/events/cycles/event_source
---> /sys/devices/system/cpu/event_source

> 
> > > > I want to show all
> > > > the pmus and events in the sysfs tree.
> > > 
> > > Why do these things need to be in sysfs?  What benifit is it going to
> > > have?
> > 
> > Kernel to provide the information of the event source and
> > hardware/software events via sysfs and user-space can get
> > this info from sysfs.
> 
> But that's not what you were doing with your "open a sysfs file from
> within the kernel and use the kobject there" logic, right?  You were
> doing everything within the kernel itself, so sysfs, and kobjects and
> the like, aren't really needed at all, right?

No. 

In userspace, open a sysfs file, see patch 11.
Then pass the open file's fd to the syscall sys_perf_event_open.

In kernel, use the passed in fd to find the pmu.

> 
> How are you exporting this information to userspace today?

Not export it today.

> 
> > > > For mce,
> > > > /sys/kernel/events/mce/*
> > > 
> > > What?  No, don't create /sys/kernel/events/.  Is that in this patchset?
> > 
> > No, not in this patchset.
> 
> Good :)
> 
> > > Ick, that's such a "general" name that it is going to get confusing very
> > > quickly.  Heck, I still don't know what this "event" thing is yet :)
> > > 
> > > > and so on...the exact placement is not yet final.
> > > 
> > > Again, why do you need/want anything in sysfs in the first place?
> > > What problem is it going to solve?  Who is going to benifit?  Why do
> > > they care?  What is this whole thing about?
> 
> You forgot to answer these questions...

Want to solve the problem of how to address an "event source".
I thought it's clear to export via sysfs, but, I maybe totally wrong...

Thanks,
Lin Ming

> 
> thanks,
> 
> greg k-h

