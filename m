Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0C3IAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:00:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:16768 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab0C3IAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:00:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,333,1267430400"; 
   d="scan'208";a="260150532"
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: Lin Ming <ming.m.lin@intel.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <d3f22a1003290213x7d7904an59d50eb6a8616133@mail.gmail.com>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
	 <d3f22a1003290213x7d7904an59d50eb6a8616133@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 30 Mar 2010 15:42:11 +0800
Message-Id: <1269934931.8575.6.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Corey

How is this going now? Are you still working on this?
I'd like to help to add support for uncore, test, write code or anything
else.

Thanks,
Lin Ming

> 
> -----
> Intro
> -----
> One subject that hasn't been addressed since the introduction of
> perf_events in the Linux kernel is that of support for "uncore" or
> "nest" unit events.  Uncore is the term used by the Intel engineers
> for their off-core units but are still on the same die as the cores,
> and "nest" means exactly the same thing for IBM Power processor
> engineers.  I will use the term uncore for brevity and because it's in
> common parlance, but the issues and design possibilities below are
> relevant to both.  I will also broaden the term by stating that uncore
> will also refer to PMUs that are completely off of the processor chip
> altogether.
> 
> Contents
> --------
> 1. Why support PMUs in uncore units?  Is there anything interesting to look at?
> 2. How do uncore events differ from core events?
> 3. Why does a CPU need to be assigned to manage a particular uncore
> unit's events?
> 4. How do you encode uncore events?
> 5. How do you address a particular uncore PMU?
> 6. Event rotation issues with uncore PMUs
> 7. Other issues?
> 8. Feedback?
> 
> ----
> 1. Why support PMUs in uncore units?  Is there anything interesting to look at?
> ----
> 
> Today, many x86 chips contain uncore units, and we think that it's
> likely that the trend will continue, as more devices - I/O, memory
> interfaces, shared caches, accelerators, etc. - are integrated onto
> multi-core chips.  As these devices become more sophisticated and more
> workload is diverted off-core, engineers and performance analysts are
> going to want to look at what's happening in these units so that they
> can find bottlenecks.
> 
> In addition, we think that even off-chip I/O and interconnect devices
> are likely to gain PMUs because engineers will want to find
> bottlenecks in their massively parallel systems.
> 
> ----
> 2. How do uncore events differ from core events?
> ----
> 
> The main difference is that uncore events are mostly likely not going
> to be tied to a particular Linux task, or even a CPU context.  Uncore
> units are resources that are in some sense system-wide, though, they
> may not really be accessible system-wide in some architectures.  In
> the case of accelerators and I/O devices, it's likely they will run
> asynchronously from the cores, and thus keeping track of events on a
> per-task basis doesn't make a lot of sense.  The other existing mode
> in perf_events is a per-CPU context, and it turns out that this mode
> does match up with uncore units well, though the choice of which CPU
> to use to manage that uncore unit is going to need to be
> arch-dependent and may involve other issues as well, such as
> minimizing access latency between the uncore unit and the CPU which is
> managing it.
> 
> ----
> 3. Why does a CPU need to be assigned to manage a particular uncore
> unit's events?
> ----
> 
> * The control registers of the uncore unit's PMU need to be read and
> written, and that may be possible only from a subset of processors in
> the system.
> * A processor is needed to rotate the event list on the uncore unit on
> every tick for the purposes of event scheduling.
> * Because of access latency issues, we may want the CPU to be close in
> locality to the PMU.
> 
> It seems like a good idea to let the kernel decide which CPU to use to
> monitor a particular uncore event, based on the location of the uncore
> unit, and possibly current system load balance.  The user will not
> want to have to figure out this detailed information.
> 
> ----
> 4. How do you encode uncore events?
> ----
> Uncore events will need to be encoded in the config field of the
> perf_event_attr struct using the existing PERF_TYPE_RAW encoding.  64
> bits are available in the config field, and that may be sufficient to
> support events on most systems. However, due to  the proliferation and
> added complexity of PMUs we envision, we might want to add another
> 64-bit config (perhaps call it config_extra or config2) field to
> encode any extra attributes that might be needed.  The exact encoding
> used, just as for the current encoding for core events, will be on a
> per-arch and possibly per-system basis.
> 
> ----
> 5. How do you address a particular uncore PMU?
> ----
> 
> This one is going to be very system- and arch-dependent, but it seems
> fairly clear that we need some sort of addressing scheme that can be
> system/arch-defined by the kernel.
> 
> From a hierarchical perspective, here's an example of possible uncore
> PMU locations in a large system:
> 
> 1) Per-core - units that are shared between all hardware threads in a core
> 2) Per-node - units that are shared between all cores in a node
> 3) Per-chip - units that are shared between all nodes in a chip
> 4) Per-blade - units that are shared between all chips on a blade
> 5) Per-rack - units that are shared between all blades in a rack
> 
> Addressing option 1)
> 
> Reuse the cpu argument: cpu would be interpreted differently if an
> uncore unit is specified (via the perf_event_attr struct's config
> field).
> 
> For the hypothetical system described above, we'd want to have an
> address that contains enough address bits for each of the above.  For
> example:
> 
> bits   field
> ------ -----
> 3..0   PMU number 0-15  /* specifies which of several identical PMUs
> being addressed */
> 7..4   core id 0-15
> 8..8   node id 0-1
> 11..9  chip id 0-7
> 16..12 blade id 0-31
> 23..17 rack id 0-128
> 
> These fields would be exposed via
> /usr/include/linux/perf_events_uncore_addr.h (for example).  How you
> actually assign these numbers to actual hardware is, again,
> system-design dependent, and may be influenced by the use of a
> hypervisor, or other software which allocates resources available to
> the system dynamically.
> 
> How does the user discover the mapping between the hardware made
> available to the system and the addresses shown above?  Again, this is
> system-dependent, and probably outside the scope of this proposal.  In
> other words, I don't know how to do this in a general way, though I
> could probably put something together for a particular system.
> 
> Addressing Option 2)
> 
> Have the kernel create nodes for each uncore PMU in
> /sys/devices/system or other pseudo file system, such as the existing
> /proc/device-tree on Power systems. /sys/devices/system or
> /proc/device-tree could be explored by the
> user tool, and the user could then specify the path of the requested
> PMU via a string which the kernel could interpret.  To be overly
> simplistic, something like
> "/sys/devices/system/pmus/blade4/cpu0/vectorcopro1".  If we settled on
> a common tree root to use, we could specify only the relative path
> name, "blade4/cpu0/vectorcopro1".
> 
> One way to provide this extra "PMU path" argument to the
> sys_perf_event_open() would be to add a bit to the flags argument says
> we're adding a PMU path string onto the end of the argument list.
> 
> This path-string-based addressing option seems to more flexible in the
> long run, and does not have as serious of an issue in mapping PMUs to
> user space; the kernel essentially exposes to user space all of the
> available PMUs for the current partition.   This might create more
> work for the kernel side, but should make the system more transparent
> for user-space tools.  Another system- or at least arch-dependent tool
> would have to be written for user space to help users navigate the
> device tree to find the PMU they want to use.  I don't think it would
> make sense to build that capability into perf, because the software
> would be arch- or system-dependent.
> 
> It could be argued that we should use a common user space tree to
> represent PMUs for all architectures and systems, so that the
> arch-independent perf code would be able to display available uncore
> PMUs.  That may be a goal that's very hard to achieve because of the
> wide variation in architectures.  Any thoughts on that?
> 
> ----
> 6. Event rotation issues with uncore PMUs
> ----
> 
> Currently, the perf_events code rotates the set of events assigned to
> a CPU or task on every system tick, so that event scheduling
> collisions on a PMU are mitigated.  This turns out to cause problems
> for uncore units for two reasons - inefficiency and CPU load.
> 
> a) Rotation of a set of events across more than one PMU causes
> inefficient rotation.
> 
> Consider the following event list; the letter designates the PMU and
> the number is the event number on that PMU.
> A1 A2 A3 B1 B2 B3 B4 C1 C2 C3 C4 C5
> 
> after one rotation, you can see that the event list will be:
> 
> C5 A1 A2 A3 B1 B2 B3 B4 C1 C2 C3 C4
> 
> and then
> 
> C4 C5 A1 A2 A3 B1 B2 B3 B4 C1 C2 C3
> 
> Notice how the relative positions for the A and B PMU events haven't
> changed even after two (or even five) rotations, so they will schedule
> the events in the same order for some time.  This will skew the
> multiplexing so that some events will be scheduled much less often
> than they should or could be.
> 
> What we'd like to have happen is that events for each PMU be rotated
> in their own lists.  For example, before rotation:
> 
> A1 A2 A3
> B1 B2 B3 B4
> C1 C2 C3 C4 C5
> 
> After rotation:
> 
> A3 A1 A2
> B2 B3 B4 B1
> C2 C3 C4 C5 C1
> 
> We've got some ideas about how to make this happen, using either
> separate lists, or placing them on separate CPUs.
> 
> b) Access to some PMU uncore units may be quite slow due to the
> interconnect that is used.  This can place a burden on the CPU if it
> is done every system tick.
> 
> This can be addressed by keeping a counter, on a per-PMU context basis
> that reduces the rate of event rotations.  Setting the rotation period
> to three, for example, would cause event rotations in that context to
> happen on every third tick, instead of every tick.  We think that the
> kernel could measure the amount of time it is taking to do a rotate,
> and then dynamically decrease the rotation rate if it's taking too
> long; "rotation rate throttling" in other words.
> 
> ----
> 7. Other issues?
> ----
> 
> This section left blank for now.
> 
> ----
> 8. Feedback?
> ----
> 
> I'd appreciate any feedback you might have on this topic.  You can
> contact me directly at the email address below, or better yet, reply
> to LKML.
> 
> --
> Regards,
> 
> - Corey
> 
> Corey Ashford
> Software Engineer
> IBM Linux Technology Center, Linux Toolchain
> Beaverton, OR
> 503-578-3507
> cjashfor@us.ibm.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

