Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0ETSmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:42:35 -0400
Received: from kroah.org ([198.145.64.141]:34184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab0ETSme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:42:34 -0400
Date: Thu, 20 May 2010 11:42:13 -0700
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs
Message-ID: <20100520184213.GB21030@kroah.com>
References: <1274233602.3036.84.camel@localhost>
 <20100518200524.GA20223@kroah.com>
 <1274236496.3603.22.camel@minggr.sh.intel.com>
 <20100519024823.GA25229@kroah.com>
 <1274253276.5605.10124.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274253276.5605.10124.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 09:14:36AM +0200, Peter Zijlstra wrote:
> On Tue, 2010-05-18 at 19:48 -0700, Greg KH wrote:
> > Again, why do you need/want anything in sysfs in the first place?
> > What problem is it going to solve?  Who is going to benifit?  Why do
> > they care?  What is this whole thing about? 
> 
> 
> OK, so all of this is about perf_event. The story starts with CPUs
> adding a PMU (Performance Monitor Unit) which allows the user to
> count/sample cpu state.
> 
> The whole perf_counter subsystem was created to abstract this piece of
> hardware and provide an kernel interface to it.
> 
> Then we realized that a generalization of the PMU exists in pretty much
> everything that generates 'events' of interest and so we started adding
> software PMUs that allowed us to do the same for tracepoints etc.
> 
> So we ended up with perf_events. A subsystem dedicated to counting
> events and event based sampling.
> 
> Now the problem this patch set tries to solve; more hardware than the
> CPU has such capabilities. There are memory controllers, bus controllers
> and devices with similar capabilities.
> 
> So we need a way to identify and locate these things, and since sysfs
> has the full machine topology in it, the idea was to represent these
> things in sysfs as an event_source class.
> 
> Since the CPU and memory controllers are (assumed) symmetric on the
> system, we get to add things like:
> 
> 
>   /sys/devices/system/cpu/cpu_event_source/

Wouldn't that really be:
	/sys/devices/system/cpu/cpu0/cpu_event_source/
?

/sys/devices/system/cpu is a "type" of devices in the system here, and
isn't an event source specific to the device itself?

Or is it for all cpus together?

>   /sys/devices/system/node/node_event_source/
> 
> Devices like GPUs can do:
> 
>   /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/radeon_event_source/
> 
> Hooking them into sysfs at the proper device/machine topology location
> allows us to quickly locate and identify these 'event_sources'.

Ok, this all makes a lot more sense now, thanks.

> Since all hardware wants to keep life interesting they all work
> differently and programming PMUs is no different, they count different
> things, have different ways to program them etc. But for each class
> there is a useful subset of things that is pretty uniform.
> 
> CPU based PMUs all can count things like clock-cycles and instructions,
> Memory controllers can count things like local/remote memory accesses
> etc.
> 
> So each class has a number of actual events that are worthy of
> abstracting. The idea was to place these events in the event_source,
> like:
> 
>   /sys/devices/system/cpu/cpu_event_source/cycles/
>   /sys/devices/system/cpu/cpu_event_source/instructions/
> 
> 
> 
> And then there are the software event_sources that expose kernel events
> (through tracepoints), currently tracepoints live
> in /debug/tracing/events/ (or /sys/kernel/debug/tracing/events/ for
> those so inclined). But the above abstraction would suggest we expose
> them similarly.
> 
> I'm not sure where we'd want them to live, we could add them to:
> 
>   /sys/kernel/tracepoint_event_source/
> 
> and have them live there, but I'm open to alternatives :-)

Once you go outside of /sys/devices/ you aren't playing with devices
properly, so you might just want to stick to a "class" and have
/sys/class/tracepoint_event_source/ where all of the devices would end
up symlinking to.

> [ With event_source's being a sysfs-class, we also get a nice flat
>   collection in /sys/class/event_source/ helping those who get lost
>   in the device topology, me :-) ]

Yes, but isn't the fact that you can have different types of
event sources lend itself to different classes of event sources?

> The next issue seems to be the interface between this sysfs
> representation and the perf_event syscall, how do we go about creating
> an actual perf_event object from this rich sysfs event_source class
> object.
> 
> The sys_perf_event_open() call takes a struct perf_event_attr pointer
> which describes the event and its properties. The current event
> classification goes through:
> 
> struct perf_event_attr {
> 	__u32 type;
> 	__u64 config;
> 
> 	...
> };
> 
> So my initial idea was to let each event_source have a type_id and let
> each of its events have a config field and read those and insert them in
> your structure.
> 
> So we'd get:
> 
>   /sys/devices/system/cpu/cpu_event_source/type_id
>   /sys/devices/system/cpu/cpu_event_source/instructions/config
> 
> cat those to get: .type = 0, .config = 1
> (PERF_TYPE_HARDWARE:PERF_COUNT_HW_INSTRUCTIONS).
> 
> Then Ingo objected and said, if we need to open and read those file, you
> might as well just open one file and pass the fd along, saves some
> syscalls.
> 
> So you'd end up doing:
> 
>  fd = open("/sys/devices/system/cpu/cpu_event_source/instructions/config");
>  attr->type = fd | PERF_TYPE_FD;
>  event_fd = perf_event_open(attr, ... );
>  close(fd);
> 
> From that one fd we can find to which 'event_source' it belongs and what
> particular config we need to use.

Ah, pass the fd of a sysfs file to sysfs to get the kobject.  Ick,
that's just, well, something that I never even considered someone would
need/want to do...

sysfs exports single values just fine.  If you are starting to do more
complex things, like you currently are, maybe you shouldn't be in
sysfs...

I can always knock up a eventfs for you do mount at /sys/kernel/events/
or something if you want :)

thanks,

greg k-h
