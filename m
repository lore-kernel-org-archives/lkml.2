Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab0EJUZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 16:25:39 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42195 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756640Ab0EJUZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 16:25:32 -0400
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, eranian@gmail.com,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>, arjan@linux.intel.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1273491725.5605.3391.camel@twins>
References: <1273483623.15998.57.camel@minggr.sh.intel.com>
	 <1273484401.5605.3333.camel@twins>
	 <1273486313.15998.76.camel@minggr.sh.intel.com>
	 <1273486708.5605.3342.camel@twins>
	 <1273487195.15998.85.camel@minggr.sh.intel.com>
	 <1273490824.5605.3379.camel@twins>  <1273491725.5605.3391.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 21:25:27 +0100
Message-ID: <1273523127.25588.33.camel@e200755-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 May 2010 20:25:29.0587 (UTC) FILETIME=[EEC45430:01CAF07E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thanks for CC'ing me on this.

On Mon, 2010-05-10 at 12:42 +0100, Peter Zijlstra wrote:
> (Added Will Deacon)
> 

<snip>


> > We'd start using the PERF_TYPE_ space for this and express the
> > PERF_COUNT_ space in the event attributes found inside that class.
> >
> > That way we can include all the existing event enumerations into this as
> > well.
> >
> > This way we can create:
> >
> > /sys/devices/system/cpu/cpuN/cpu_hardware_events
> >                              cpu_hardware_events/event_source_id
> >                              cpu_hardware_events/cpu_cycles
> >                              cpu_hardware_events/instructions
> >                                                 /...
> >
> > /sys/devices/system/cpu/cpuN/cpu_raw_events
> >                              cpu_raw_events/event_source_id
> >
> >
> > These would match the current PERF_TYPE_* values for compatibility
> >
> > For new PMUs we can start a dynamic range of PERF_TYPE_ (say at 64k but
> > that's not ABI and can be changed at any time, we've got u32 to play
> > with).
> >
> > For uncore this would result in:
> >
> > /sys/devices/system/node/nodeN/node_raw_events
> >                                node_raw_events/event_source_id
> >
> > and maybe:
> >
> > /sys/devices/system/node/nodeN/node_events
> >                                node_events/event_source_id
> >                                node_events/local_misses
> >                                           /local_hits
> >                                           /remote_misses
> >                                           /remote_hits
> >                                           /...
> >


I like this approach, but it only makes sense for ARM if we describe the
common subset of events [that is, those associated with a PERF_COUNT_]
because, although the ARMv7 architecture does define some common event
numberings between cores, implementors are at liberty to extend the
event space as they wish. These extensions are much better off being
handled in userspace.

Another interesting ARM-ism is the vast potential for uncore event
sources in SoC devices. The `node' terminology seems a bit confusing
here, as there may be counters situated at various points of a bus
hierarchy which monitor various types of transactions for example. I
suppose these could live under /sys/devices/system/bus/... ? I would
expect these kind of counters to be controlled via raw events because
having a list of discrete events doesn't really make sense [for example,
if I want to count all bursts of a given size, I can encode the burst
size into the event number].


> So Russell reminded me that the ARM people have the problem that
> their /proc/cpuinfo isn't specific enough to map to a unique event map.

> Whilst extending ARM /proc/cpuinfo seems like a sensible option it will
> not cover anything but cpu events.
> 
> So in that trend (and to avoid exhaustive in kernel event lists for no
> good reason), it might make sense to also add some event_source
> attributes that identify the thing, maybe a event_source_name or
> event_source_driver field that would allow unique maps to exhaustive
> event lists.


The ARM perf events backend already has an ID field in the pmu struct
which can be used to lookup a string describing what the event source
is. Exporting this via sysfs will make it much easier for userspace [and
is basically how OProfile deals with PMU identification].

Cheers,

Will


