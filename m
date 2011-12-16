Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab1LPODv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:03:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:34880 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab1LPODp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:03:45 -0500
Message-ID: <1324044159.18942.104.camel@twins>
Subject: Re: [PATCH 1/3] perf, tool: Add parser generator for events parsing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Fri, 16 Dec 2011 15:02:39 +0100
In-Reply-To: <1323963039-7602-2-git-send-email-jolsa@redhat.com>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com>
	 <1323963039-7602-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 16:30 +0100, Jiri Olsa wrote:
> events: events ',' event | event
> 
> event:  event_tracepoint |
>         event_raw |
>         event_numeric |
>         event_symbolic |
>         event_generic_hw |
>         event_breakpoint
> 
> event_tracepoint:       PE_NAME_TP ':' PE_NAME_TP modifier
> event_raw:              PE_SEP_RAW PE_VALUE modifier
> event_numeric:          PE_VALUE ':' PE_VALUE modifier
> event_symbolic:         PE_NAME_SYM modifier
> event_generic_hw:       PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT modifier |
>                         PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT modifier |
>                         PE_NAME_CACHE_TYPE modifier
> event_breakpoint:       PE_SEP_BP ':' PE_VALUE event_breakpoint_type modifier
> event_breakpoint_type:  PE_MODIFIER_BPTYPE | empty
> modifier:               PE_MODIFIER_EVENT | empty

This isn't complete, we need means of specifying
perf_event_attr::config[12] when specifying a raw event.


> PE_NAME_SYM:            cpu-cycles|cycles                              |
>                         stalled-cycles-frontend|idle-cycles-frontend   |
>                         stalled-cycles-backend|idle-cycles-backend     |
>                         instructions                                   |
>                         cache-references                               |
>                         cache-misses                                   |
>                         branch-instructions|branches                   |
>                         branch-misses                                  |
>                         bus-cycles                                     |
>                         cpu-clock                                      |
>                         task-clock                                     |
>                         page-faults|faults                             |
>                         minor-faults                                   |
>                         major-faults                                   |
>                         context-switches|cs                            |
>                         cpu-migrations|migrations                      |
>                         alignment-faults                               |
>                         emulation-faults

It might make sense to allow means of custom symbol -> raw mappings.

> PE_NAME_CACHE_TYPE:     L1-dcache|l1-d|l1d|L1-data             |
>                         L1-icache|l1-i|l1i|L1-instruction      |
>                         LLC|L2                                 |
>                         dTLB|d-tlb|Data-TLB                    |
>                         iTLB|i-tlb|Instruction-TLB             |
>                         branch|branches|bpu|btb|bpc            |
>                         node
> 
> PE_NAME_CACHE_OP_RESULT: load|loads|read                       |
>                         store|stores|write                     |
>                         prefetch|prefetches                    |
>                         speculative-read|speculative-load      |
>                         refs|Reference|ops|access              |
>                         misses|miss
> 
> PE_SEP_RAW:             'r'
> PE_SEP_BP:              'mem'
> PE_MODIFIER_EVENT:      :[ukhp]{1,2}

You can actually have more than 2 modifiers, eg. "upp". 

[u] | [k] | [h] | [p]{,3} would be more correct I think.

> PE_MODIFIER_BPTYPE:     :[rwx]{1,3}
> PE_NAME_TP:             [a-zA-Z_*?]+
> PE_VALUE:               number
> 
> Added flex/bison files for event grammar parsing. Added
> flex/bison Makefile rules plus few special dependencies. 

It might be good to include the .c output of flex/bison so that we can
build perf without a hard dependency on them -- only people changing the
parser will need them.
