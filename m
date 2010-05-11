Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab0EKIVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:21:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:15281 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab0EKIVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:21:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,206,1272870000"; 
   d="scan'208";a="566035933"
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>
In-Reply-To: <20100511072127.GB10421@elte.hu>
References: <1273484401.5605.3333.camel@twins>
	 <1273486313.15998.76.camel@minggr.sh.intel.com>
	 <1273486708.5605.3342.camel@twins>
	 <1273487195.15998.85.camel@minggr.sh.intel.com>
	 <1273490824.5605.3379.camel@twins> <20100510114311.GA6449@elte.hu>
	 <1273492164.5605.3397.camel@twins> <20100510115344.GA11238@elte.hu>
	 <4BE8931C.9070106@linux.vnet.ibm.com> <1273560419.5605.3426.camel@twins>
	 <20100511072127.GB10421@elte.hu>
Content-Type: text/plain
Date: Tue, 11 May 2010 16:20:31 +0800
Message-Id: <1273566031.30322.31.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 15:21 +0800, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > What we do not want are exhaustive event lists for specific PMU 
> > implementations, those are best left for userspace.
> 
> I'd refine this the following way:
> 
>  - We mandate proper in-kernel enumeration of all things event sources, for
>    example /sys/devices/system/node/nodeN/node_events. Obviously an event source
>    needs to be addressable for it to be useful to userspace.
> 
>  - We want generalized events expressed in those event containers that
>    are used commonly. Whatever people find useful we can enumerate and what
>    is enumerated is an ABI.
> 
>  - The 'rest' can go into /sys/devices/system/node/nodeN/node_events/raw_event/.
>    These will never be guaranteed in an ABI way really (although will work in
>    some cases) - those using raw event codes are really up to themselves and 
>    if it ever gets in the way of proper, more expressive 
>    enumeration/generalization it will have to yield.
> 
> These are the ground rules as i see them.
> 
> 	Ingo

How will this sysfs interface be used for userspace tool?

 /sys/devices/system/node/nodeN/node_events
                               node_events/event_source_id

                               node_events/local_misses/event_id
                                          /local_hits/event_id
                                          /remote_misses/event_id
                                          /remote_hits/event_id

For example, to monitor node event local_misses on node 0, does it work
as below?

1. perf top -e local_misses -n 0 (-n 0 means node 0)

2. read /sys/devices/system/node/node0/node_events/event_source_id to
get the pmu_id

3. read /sys/devices/system/node/node0/node_events/local_misses/event_id
to get the event_id

4. event_attr::pmu_id=pmu_id, event::config=event_id

5. other setting...

6. call syscall perf_event_open(....)

