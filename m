Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab2AEJR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 04:17:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048Ab2AEJRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 04:17:22 -0500
Date: Thu, 5 Jan 2012 10:17:00 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, acme@redhat.com
Cc: mingo@elte.hu, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: new syntax for perf event
Message-ID: <20120105091700.GA1700@m.brq.redhat.com>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com>
 <1323963039-7602-2-git-send-email-jolsa@redhat.com>
 <1324044159.18942.104.camel@twins>
 <1324044196.18942.105.camel@twins>
 <20111220103154.GA1861@m.brq.redhat.com>
 <1324378070.24621.32.camel@twins>
 <1324380648.24621.49.camel@twins>
 <1324381161.24621.53.camel@twins>
 <20111221161613.GA1659@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221161613.GA1659@m.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, any feedback?

thanks,
jirka

On Wed, Dec 21, 2011 at 05:16:13PM +0100, Jiri Olsa wrote:
> On Tue, Dec 20, 2011 at 12:39:21PM +0100, Peter Zijlstra wrote:
> > On Tue, 2011-12-20 at 12:30 +0100, Peter Zijlstra wrote:
> > > event   config-0:7
> > > umask   config-8:15
> > > usr     config-16
> > > os      config-17
> > > edge    config-18
> > > any     config-21
> > > inv     config-23
> > > cmask   config-24:31
> > > 
> > > nhm-dmnd_data_rd        config1-0
> > > nhm-dmnd_rfo            config1-1
> > > nhm-dmnd_ifetch         config1-2
> > > ...
> > > 
> > > (the real syntax will likely be a little more complex in order to be
> > > able to express the various other architectures their raw input format). 
> > 
> > for instance AMD would need:
> > 
> > event	config-0:7,32-35
> > guest	config-40
> > host	config-41
> > 
> > (assuming you read that as a mask from LSB to MSB)
> > 
> > And I still haven't actually read how the P4 works so I can't help out
> > there.
> 
> 
> ok first try ;) description + grammar attached
> 
> - event has a general format:
>         pmu/event_def[:modifier] [ ',' pmu/event_def[:modifier] ] ...
> 
>   where event_def depends on the chosen pmu:
>         'cpu' 'tracepoint' 'breakpoint'
> 
> 
> - to keep some of the old interface, symbolic and cache events stays,
>   since they are recognizable by keywords (event_symbol, event_cache)
> 
> 
> - raw events are defined with the help of event keywords like:
>         cpu/raw,config=1,config1=0,config2=0
>         cpu/hw,config=1,config1=0
> 
>   * first symbol after '/' defines the type: raw/hw/cache
>     which match PERF_TYPE_RAW/PERF_TYPE_HARDWARE/PERF_TYPE_HW_CACHE
> 
>   * the rest consists assignments for 'config/config1/config1' keywords
>     that match with the perf_event_attr:config/config1/config values
>     (possibly extended once we have sysfs events representation)
> 
> 
> - tracepoint events are defined like:
>         tracepoint/system:tracepoint
> 
>   where tracepoint could contain '*?'
> 
> 
> - breakpoint events are defined like:
>         breakpoint/addr:type
> 
> 
> - each event could be followed by modifier definition
> 
> 
> - I think pmu names should match registered pmu names,
>   but we could make some shortcuts so we dont need to type 'tracepoint/',
>   but just 'tp/' or smth..
> 
> 
> - as for tracepoints it looks like the old format does not clash with the new one
>   and we could add shortcut (omit the 'tracepoint/') like:
>       event: event_tracepoint
> 
> 
> - not sure I should include 'software' pmu, as it seems to covered by
>   event_symbol events
> 
> 
> thanks for comments,
> jirka
> 
> 
> 
> grammar
> -------
> events:
>                 event_mod ',' event_mod | event_mod
> 
> event_mod:
>                 event | event ':' modifier
> 
> event:
>                 event_symbol |
>                 event_cache |
>                 'cpu' '/' event_cpu |
>                 'tracepoint' '/' event_tracepoint
>                 'breakpoint' '/' event_breakpoint
> 
> event_symbol:
>                 cpu-cycles|cycles
>                 stalled-cycles-frontend|idle-cycles-frontend
>                 stalled-cycles-backend|idle-cycles-backend
>                 instructions
>                 cache-references
>                 cache-misses
>                 branch-instructions|branches
>                 branch-misses
>                 bus-cycles
>                 cpu-clock
>                 task-clock
>                 page-faults|faults
>                 minor-faults
>                 major-faults
>                 context-switches|cs
>                 cpu-migrations|migrations
>                 alignment-faults
>                 emulation-faults
> 
> event_cache:
>                 cache_type
>                 cache_type '-' cache_result_op
>                 cache_type '-' cache_result_op '-' cache_result_op
> 
> cache_type:
>                 L1-dcache|l1-d|l1d|L1-data
>                 L1-icache|l1-i|l1i|L1-instruction
>                 LLC|L2
>                 dTLB|d-tlb|Data-TLB
>                 iTLB|i-tlb|Instruction-TLB
>                 branch|branches|bpu|btb|bpc
>                 node
> 
> cache_result_op:
>                 load|loads|read
>                 store|stores|write
>                 prefetch|prefetches
>                 speculative-read|speculative-load
>                 refs|Reference|ops|access
>                 misses|miss
> 
> event_cpu:
>                 'raw'    ',' event_cpu_def
>                 'hw'     ',' event_cpu_def
>                 'cache'  ',' event_cpu_def
> 
> event_cpu_def:
>                 event_cpu_ass ',' event_cpu_ass |
>                 event_cpu_ass
> 
> event_cpu_ass:
>                 event_cpu_elem '=' value
> 
> event_cpu_elem:
>                 'config' | 'config1' | 'config2'
> 
> event_tracepoint:
>                 system ':' tracepoint
> 
> event_breakpoint:
>                 addr ':' type
> 
> modifier:
>                 [ukhp]{1,4}
