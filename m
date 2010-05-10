Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab0EJLns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 07:43:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43184 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab0EJLnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 07:43:46 -0400
Date: Mon, 10 May 2010 13:43:11 +0200
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
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
Message-ID: <20100510114311.GA6449@elte.hu>
References: <1273483623.15998.57.camel@minggr.sh.intel.com>
 <1273484401.5605.3333.camel@twins>
 <1273486313.15998.76.camel@minggr.sh.intel.com>
 <1273486708.5605.3342.camel@twins>
 <1273487195.15998.85.camel@minggr.sh.intel.com>
 <1273490824.5605.3379.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273490824.5605.3379.camel@twins>
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

> [...]
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
> The software events and tracepoints and kprobes stuff we could hang off
> of /sys/kernel/ or something

Yeah, we really want a mechanism like this in place instead of continuing with 
the somewhat ad-hoc extensions to the event enumeration space.

One detail: i think we want one more level. Instead of:

 /sys/devices/system/node/nodeN/node_events
                                node_events/event_source_id
                                node_events/local_misses
                                           /local_hits
                                           /remote_misses
                                           /remote_hits
                                           /...

We want the individual events to be a directory, containing the event_id:

 /sys/devices/system/node/nodeN/node_events
                                node_events/event_source_id
                                node_events/local_misses/event_id
                                           /local_hits/event_id
                                           /remote_misses/event_id
                                           /remote_hits/event_id
                                           /...

The reason is that we want to keep our options open to add more attributes to 
individual events. (In fact extended attributes already exist for certain 
event classes - such as the 'format' info for tracepoints.)

Thanks,

	Ingo
