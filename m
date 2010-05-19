Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab0ESDle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 23:41:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:54081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab0ESDlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 23:41:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,259,1272870000"; 
   d="scan'208";a="519201042"
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
In-Reply-To: <20100519024823.GA25229@kroah.com>
References: <1274233602.3036.84.camel@localhost>
	 <20100518200524.GA20223@kroah.com>
	 <1274236496.3603.22.camel@minggr.sh.intel.com>
	 <20100519024823.GA25229@kroah.com>
Content-Type: text/plain
Date: Wed, 19 May 2010 11:40:29 +0800
Message-Id: <1274240429.3603.76.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 10:48 +0800, Greg KH wrote:
> On Wed, May 19, 2010 at 10:34:55AM +0800, Lin Ming wrote:
> > On Wed, 2010-05-19 at 04:05 +0800, Greg KH wrote:
> > > On Wed, May 19, 2010 at 01:46:42AM +0000, Lin Ming wrote:
> > > > Now only exports cpu hardware events.
> > > > 
> > > > For each PMU, there are 2 sysfs dirs: event_source and events.
> > > > 
> > > > For example,
> > > > /sys/devices/system/cpu/event_source/
> > > > /sys/devices/system/cpu/events/
> > > > 
> > > > $ tree /sys/devices/system/cpu/event_source/
> > > > /sys/devices/system/cpu/event_source/
> > > > `-- id
> > > > 
> > > > $ tree /sys/devices/system/cpu/events/
> > > > /sys/devices/system/cpu/events/
> > > > |-- L1-dcache-load-misses
> > > > |   |-- event_source -> ../../event_source
> > > 
> > > What is this symlink for?  Is it needed as they all seem to point to the
> > > same thing.
> > 
> > The symlink is used to find the "event_source" of the "event".
> > 
> > /sys/devices/system/cpu/event_source/
> > 
> > /sys/devices/system/cpu/events/
> > |-- L1-dcache-load-misses
> > |   |-- event_source -> ../../event_source
> > 
> > For above example, "event_source" is the cpu pmu and the "event" is
> > L1-dcache-load-misses.
> > 
> > Yes, they point to the same thing, because all the events
> > under /sys/devices/system/cpu/events/* is monitored by the same event
> > source, ie, the cpu pmu(/sys/devices/system/cpu/event_source/).
> 
> Then, why have a symlink if they are all going to be the same?

So how about move the symlink to parent directory, like

/sys/devices/system/cpu/event_source/

/sys/devices/system/cpu/events/
|-- event_source -> ../event_source

> 
> > > I'm still not really understanding what exactly you are trying to show
> > > in the sysfs tree here anyway, perhaps the documentation update will
> > > clear that up for me.
> > 
> > To support multiple pmus
> 
> What is a "pmu"?

Performance Monitoring Unit

> 
> > (or call them event source),
> 
> What is an "event source"?

The source who generates the event.
The event includes hardware events, cache-misses, bus-cycles,
interrupts, error conditions, hotplug......
and software events, context-switches, page-faults, sched events......

> 
> > I want to show all
> > the pmus and events in the sysfs tree.
> 
> Why do these things need to be in sysfs?  What benifit is it going to
> have?

Kernel to provide the information of the event source and
hardware/software events via sysfs and user-space can get
this info from sysfs.

> 
> > For cpu pmu,
> > /sys/devices/system/cpu/event_source/*
> > /sys/devices/system/cpu/events/*
> 
> What is a "cpu pmu"?

The performance monitoring unit in cpu.

> 
> > For node pmu,
> > /sys/devices/system/node/event_source/*
> > /sys/devices/system/node/events/*
> 
> What is a "node pmu"?

The pmu shared by logical cpus in a package, for example, Nehalem uncore
pmu, PowerPc nest units.

> 
> > For mce,
> > /sys/kernel/events/mce/*
> 
> What?  No, don't create /sys/kernel/events/.  Is that in this patchset?

No, not in this patchset.

> Ick, that's such a "general" name that it is going to get confusing very
> quickly.  Heck, I still don't know what this "event" thing is yet :)
> 
> > and so on...the exact placement is not yet final.
> 
> Again, why do you need/want anything in sysfs in the first place?
> What problem is it going to solve?  Who is going to benifit?  Why do
> they care?  What is this whole thing about?
> 
> thanks,
> 
> greg k-h

