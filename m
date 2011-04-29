Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab1D2OnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:43:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab1D2OnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:43:21 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 0/3] x86_64,tracing: multiplexing function tracer
Date: Fri, 29 Apr 2011 16:43:11 +0200
Message-Id: <1304088194-6214-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, me again ;)

from last RFC email it turned out it'd be good to have support
for more than 1 currently running function tracers. With
the possibility to specify separate filter for each of them.

I thought about one way how to do that and put it to the
code for considering. It seems to work properly, though
I was fighting with set_ftrace_filter for a while.. and
it is still not ideal ;)


How does it work?

 - when the function tracer is registered it got assigned unique ID
 - 'mcount callback' beside ip and parent_ip provides bitmask
   set with tracers IDs which are interested in the current function
 - 'mcount callback' calls tracers callbacks as set in the bitmask


How did that bitfield get to the 'mcount callback'?

 - several 'mcount callbacks' are statically generated with code
   providing unique bitmask
 - each combination of tracers (IDs) map to a single 'mcount callback'
   providing bitmask of this combination
 - function pointers of these callbacks are stored and used
   to patch the function 'mcount call' instruction

 To have all bitmask possibilities covered it is generated
 2^(allowed tracers) number of 'mcount callbacks'. As this
 statical part is relativelly small it's probably ok.

 I guess it's possible to use dynamic approach and allocate
 only as many 'mcount callbacks' as needed (similar as
 for optimized kprobes).


How does filtering work (interface) ?

 - each tracer got unique name
 - added file function_tracers providing list of registered tracers
 - one tracer is allways default, and this one will be changed
   via set_ftrace_filter interface
 - default tracer can be changed by write the name to the function_tracers
   file


How does filtering work (code) ?

 - each 'struct dyn_ftrace' record now holds 2 bitmasks:
   filter and notrace
 - those 2 bitmask are updated by the set_ftrace_filter code
   to carry bitmask of tracers interested in the function
 - this info is processed during the 'mcount callback' assigning


Example session

	# echo function > ./current_tracer 
	# cat function_tracers 
	*trace
	# echo 1 > ./function_profile_enabled 
	# cat function_tracers 
	 trace
	*trace_profile
	# cat set_ftrace_filter 
	[               trace] #### all functions enabled ####
	[       trace_profile] #### all functions enabled ####
	# echo sys_read > ./set_ftrace_filter 
	# cat set_ftrace_filter 
	[               trace] #### all functions enabled ####
	[       trace_profile] sys_read
	# echo trace > ./function_tracers 
	# cat function_tracers 
	*trace
	 trace_profile
	# echo sys_write > ./set_ftrace_filter 
	# cat set_ftrace_filter 
	[               trace] sys_write
	[       trace_profile] sys_read


attached patches:
- 1/3 tracing: function tracer registration
- 2/3 tracing: adding statical callers
- 3/3 tracing: set_ftrace_filter support


This is by no means complete solution, and there are
many leftovers.. just wanted to try this way ;)

plz let me know what you think

wbr,
jirka
---
 arch/x86/include/asm/ftrace.h     |    4 +
 arch/x86/kernel/entry_64.S        |   22 ++-
 arch/x86/kernel/ftrace.c          |   50 ++--
 include/linux/ftrace.h            |   16 +-
 kernel/trace/ftrace.c             |  555 +++++++++++++++++++++----------------
 kernel/trace/trace_events.c       |    1 +
 kernel/trace/trace_functions.c    |    2 +
 kernel/trace/trace_irqsoff.c      |    1 +
 kernel/trace/trace_sched_wakeup.c |    1 +
 kernel/trace/trace_stack.c        |    1 +
 10 files changed, 383 insertions(+), 270 deletions(-)
