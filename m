Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab0EJLtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 07:49:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37875 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab0EJLtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 07:49:04 -0400
Date: Mon, 10 May 2010 13:48:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
Message-ID: <20100510114840.GB6449@elte.hu>
References: <1273483623.15998.57.camel@minggr.sh.intel.com>
 <1273484401.5605.3333.camel@twins>
 <1273486313.15998.76.camel@minggr.sh.intel.com>
 <1273486708.5605.3342.camel@twins>
 <1273487195.15998.85.camel@minggr.sh.intel.com>
 <1273490824.5605.3379.camel@twins>
 <1273491363.5605.3386.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273491363.5605.3386.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2010-05-10 at 13:27 +0200, Peter Zijlstra wrote:
> > On Mon, 2010-05-10 at 18:26 +0800, Lin Ming wrote:
> > 
> > > > No, I'm assuming there is only 1 PMU per CPU. Corey is the expert on
> > > > crazy hardware though, but I think the sanest way is to extend the CPU
> > > > topology if there's more structure to it.
> > > 
> > > But our goal is to support multiple pmus, don't we need to assume there
> > > are more than 1 PMU per CPU?
> > 
> > No, because as I said, then its ambiguous what pmu you want. If you have
> > that, you need to extend your topology information.
> > 
> > Anyway, I talked with Ingo on this and he'd like to see this somewhat
> > extended.
> > 
> > Instead of a pmu_id field, which we pass into a new
> > perf_event_attr::pmu_id field, how about creating an event_source sysfs
> > class. Then each class can have an event_source_id and a hierarchy of
> > 'generic' events.
> > 
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
> > 
> > The software events and tracepoints and kprobes stuff we could hang off
> > of /sys/kernel/ or something
> 
> The GPU folks would hang is off of the drm class or maybe next to it in
> the PCI space.

It could conceivably be in multiple places as well - a given event makes sense 
to enumerate in multiple places.

( For example an 'interrupt' might show up in a given GPU - but it can also
  show up amongst the IRQ tracepoints - or something like that. )

But by far the most common case would be for an event source to be attached to 
one particular place in the sysfs topology.

Note how naturally this scheme extends to all things hardware topology - which 
is already enumerated in sysfs. It also extends to all things software events 
in a pretty natural way via /sys/kernel/mm/.

Plus we want to move out the /sys/kernel/debug/ hacks for kprobes and 
tracepoints into this space as well. (possibly do it with hw-breakpoints as 
well by attaching them to the CPU directory - for completeness)

That way /sys/class/event_source/ would provide an enumeration of all events 
to 'perf list' and would automatically be usable by all the perf tooling.

Thanks,

	Ingo
