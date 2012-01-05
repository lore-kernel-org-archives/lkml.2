Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab2AEOLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:11:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:55785 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285Ab2AEOLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:11:09 -0500
Message-ID: <1325772656.2697.57.camel@twins>
Subject: Re: new syntax for perf event
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Thu, 05 Jan 2012 15:10:56 +0100
In-Reply-To: <20111221161613.GA1659@m.brq.redhat.com>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com>
	 <1323963039-7602-2-git-send-email-jolsa@redhat.com>
	 <1324044159.18942.104.camel@twins> <1324044196.18942.105.camel@twins>
	 <20111220103154.GA1861@m.brq.redhat.com> <1324378070.24621.32.camel@twins>
	 <1324380648.24621.49.camel@twins> <1324381161.24621.53.camel@twins>
	 <20111221161613.GA1659@m.brq.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 17:16 +0100, Jiri Olsa wrote:
> grammar

yacc/bison notation it seems.. lemme get the rules for that.

> -------
> events:
>                 event_mod ',' event_mod | event_mod

events = event_mod, {',' , event_mod};

would be the EBNF variant for allowing inf repetition, not sure how to
express that, it seems to want a recursive rule which I'm not sure I
see. The way I read your thing it only allows 1 or 2 events.

> 
> event_mod:
>                 event | event ':' modifier


event_mod = event, [':' , modifier];

Would be the EBNF thing, and I think your rule does indeed match that.

> event:
>                 event_symbol |
>                 event_cache |
>                 'cpu' '/' event_cpu |
>                 'tracepoint' '/' event_tracepoint
>                 'breakpoint' '/' event_breakpoint

I think I'd like to see something like:

event   = pmu, '/', event_config 
	| event_symbol | event_cache;

pmu = ? ls /sys/bus/event_source/devices ?;
(* maybe add some aliasses like you suggest *)

event_config = (event_predef | event_term), {',', event_term};

event_predef = ? special name -> raw mapping read from somewhere ?;

event_term = event_sym, '=', value;

event_sym = "config" | "config1" | "config2"
	  | ? contents of /sys/bus/event_source/devices/$pmu/format ?;

value = integer | hexint;


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

I'd write that as:

event_cache = cache_type, '-', cache_mod, ['-', cache_xs];

cache_type = cache_l1d | cache_l1i | cache_llc 
	   | cache_dtlb | cache_itlb
	   | cache_branch | cache_node;

cache_mod = cache_load | cache_store | cache_prefetch;

cache_xs = cache_accesses | cache_misses;

cache_l1d = "L1-dcache" | ... ;

etc..


> event_cpu:
>                 'raw'    ',' event_cpu_def
>                 'hw'     ',' event_cpu_def
>                 'cache'  ',' event_cpu_def

I think these are superfluous and we could deduce them from the actual
event_term's used. Something using "config" will be a raw event etc..

> 
> event_cpu_def:
>                 event_cpu_ass ',' event_cpu_ass |
>                 event_cpu_ass
> 
> event_cpu_ass:
>                 event_cpu_elem '=' value

Hehehe, you said 'ass', hehe.


> event_tracepoint:
>                 system ':' tracepoint
> 
> event_breakpoint:
>                 addr ':' type

Right, something like that.

> 
> modifier:
>                 [ukhp]{1,4} 

I think you need at least 5, or you can write it like:

modifier = ['u'], ['k'], ['h'], [3*'p'];

Also, I think we grew a few more modifiers with some of the perf kvm
guest muck.
