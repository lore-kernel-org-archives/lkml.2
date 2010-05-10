Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558Ab0EJXyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:54:23 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54129 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab0EJXyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 19:54:20 -0400
Message-ID: <4BE89CA8.3020801@linux.vnet.ibm.com>
Date: Mon, 10 May 2010 16:54:16 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
References: <1273483623.15998.57.camel@minggr.sh.intel.com> <1273484401.5605.3333.camel@twins> <1273486313.15998.76.camel@minggr.sh.intel.com> <1273486708.5605.3342.camel@twins> <1273487195.15998.85.camel@minggr.sh.intel.com> <1273490824.5605.3379.camel@twins>
In-Reply-To: <1273490824.5605.3379.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/10/2010 4:27 AM, Peter Zijlstra wrote:
> On Mon, 2010-05-10 at 18:26 +0800, Lin Ming wrote:
> 
>>> No, I'm assuming there is only 1 PMU per CPU. Corey is the expert on
>>> crazy hardware though, 

:-)

>>> but I think the sanest way is to extend the CPU
>>> topology if there's more structure to it.
>>
>> But our goal is to support multiple pmus, don't we need to assume there
>> are more than 1 PMU per CPU?
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


Just to give a concrete example, the IBM Wire-Speed Processor has four AT-"nodes" per chip, each containing four PowerPC cores.

Those four nodes together share a number of nest PMU accelerators, I/O devices, buses etc. which each have their own PMUs.  Further adding to the structure is that some of the nodes are replicated.  For example, we have two memory controllers, each with a pair of PMUs.

/sys/devices/system/node/node0/mem_ctlr0/
                                        event_source_id
                                        events/
                                              partial_cacheline_read_retried/
                                              partial_cacheline_write_retried/
                                              ...
                               mem_ctlr1/
                                        event_source_id
                                        events/
                                              partial_cacheline_read_retried/
                                              ...

So it's a bit ugly to replicate the event information across identical pmus, but that can be done via links, without too much memory cost, I assume.

Does this seem workable?


-- 
Regards,

- Corey

