Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab0EKCoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 22:44:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:18105 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486Ab0EKCob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 22:44:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,204,1272870000"; 
   d="scan'208";a="516799454"
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1273490824.5605.3379.camel@twins>
References: <1273483623.15998.57.camel@minggr.sh.intel.com>
	 <1273484401.5605.3333.camel@twins>
	 <1273486313.15998.76.camel@minggr.sh.intel.com>
	 <1273486708.5605.3342.camel@twins>
	 <1273487195.15998.85.camel@minggr.sh.intel.com>
	 <1273490824.5605.3379.camel@twins>
Content-Type: text/plain
Date: Tue, 11 May 2010 10:43:52 +0800
Message-Id: <1273545832.30322.4.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 19:27 +0800, Peter Zijlstra wrote:
> On Mon, 2010-05-10 at 18:26 +0800, Lin Ming wrote:
> 
> > > No, I'm assuming there is only 1 PMU per CPU. Corey is the expert on
> > > crazy hardware though, but I think the sanest way is to extend the CPU
> > > topology if there's more structure to it.
> > 
> > But our goal is to support multiple pmus, don't we need to assume there
> > are more than 1 PMU per CPU?
> 
> No, because as I said, then its ambiguous what pmu you want. If you have
> that, you need to extend your topology information.
> 
> Anyway, I talked with Ingo on this and he'd like to see this somewhat
> extended.
> 
> Instead of a pmu_id field, which we pass into a new
> perf_event_attr::pmu_id field, how about creating an event_source sysfs
> class. Then each class can have an event_source_id and a hierarchy of
> 'generic' events.
> 
> We'd start using the PERF_TYPE_ space for this and express the
> PERF_COUNT_ space in the event attributes found inside that class.
> 
> That way we can include all the existing event enumerations into this as
> well.
> 
> This way we can create:
> 
> /sys/devices/system/cpu/cpuN/cpu_hardware_events 
>                              cpu_hardware_events/event_source_id
>                              cpu_hardware_events/cpu_cycles
>                              cpu_hardware_events/instructions
>                                                 /...
> 
> /sys/devices/system/cpu/cpuN/cpu_raw_events
>                              cpu_raw_events/event_source_id
> 
> 
> These would match the current PERF_TYPE_* values for compatibility
> 
> For new PMUs we can start a dynamic range of PERF_TYPE_ (say at 64k but
> that's not ABI and can be changed at any time, we've got u32 to play
> with).
> 
> For uncore this would result in:
> 
> /sys/devices/system/node/nodeN/node_raw_events
>                                node_raw_events/event_source_id
> 
> and maybe:
> 
> /sys/devices/system/node/nodeN/node_events
>                                node_events/event_source_id
>                                node_events/local_misses
>                                           /local_hits
>                                           /remote_misses
>                                           /remote_hits
>                                           /...
> 
> 
> The software events and tracepoints and kprobes stuff we could hang off
> of /sys/kernel/ or something
> 
> So your registration would indeed look like something:
> 
>  perf_event_register_pmu(struct pmu *pmu, int type),
> 
> where type would normally be -1 (dynamic) but would be PERF_TYPE_ for
> those already laid down in ABI.
> 
> This approach will also give us a good overview
> in /sys/class/event_source/, which will be a flat listing of all
> existing event sources.
> 
> Does this make sense?

Thanks for the idea.

Give me some time to get a clear understanding of the ideas from you and
others.

And then I'll work out a patch as soon as possible.

Lin Ming

