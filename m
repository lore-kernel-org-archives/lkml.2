Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0ELSn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:43:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48066 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab0ELSn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:43:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bEwmRb1jpwBkiARV29RnI9NXp0eJVve0LehbGEQwhlQeU0rXh1+iiFAkN6jHoqZZrm
         S9S+vE2qpTcFckFcpl0PLhYIY2dnH1Zo9kMRSa0cVzwt/Hb3LoQL5VSA2UOxp2BhiGvW
         lyzneZbNOMRyCkFwSZVwMV9HKkHZmFTbWG3LM=
Date: Wed, 12 May 2010 20:43:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/10 final] tracing: Lowering the footprint of
	TRACE_EVENTs
Message-ID: <20100512184351.GC10028@nowhere>
References: <20100512152810.819338250@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512152810.819338250@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 11:28:10AM -0400, Steven Rostedt wrote:
> 
> [ Final final version! ]
> 
> Ingo,
> 
> This also affects kprobes and perf.
> 
> At the Linux Collaboration Summit, I talked with Mathieu and others about
> lowering the footprint of trace events. I spent all of last two weeks
> trying to get the size as small as I could.
> 
> Currently, each TRACE_EVENT() macro adds 1 - 5K per tracepoint. I got various
> results by adding a TRACE_EVENT() with the compiler, depending on
> config options that did not seem related. The new tracepoint I added
> would add between 1 and 5K, but I did not investigate enough to
> see what the true size was.
> 
> What was consistent, was the DEFINE_EVENT(). Currently, it adds
> a little over 700 bytes per DEFINE_EVENT().
> 
> This patch series does not seem to affect TRACE_EVENT() much (had
> the same various sizes), but consistently brings DEFINE_EVENT()s
> down from 700 bytes to 250 bytes per DEFINE_EVENT(). Since syscalls
> use one "class" and are equivalent to DEFINE_EVENT() this can
> be a significant savings.
> 
> With events and syscalls (82 events and 618 syscalls), before this
> patch series, the size of vmlinux was: 6863829, and afterward: 6768675.
> 
> That is 95,154 bytes in savings! (over 92K)
> 
> Note: I did this series with disabling KERNEL_DEBUG and that made
>  the effect of savings smaller. The original numbers with KERNEL_DEBUG
>  options enabled was: orinal-16161794, new-16058182, savings-103612
>  which was over 100K) This may still be true with KERNEL_DEBUG enabled
>  but I only tried it this time with it disabled.
> 
>  But if I go by percentage, this series saves 1.38% where the
>  KERNEL_DEBUG series only saved 0.64% of the total vmlinux image.
> 
>  Config for this run can be found here:
>   http://rostedt.homelinux.com/config-size
> 
> Without tracing syscalls (82 events), it brought the size of vmlinux
> down from 6617121 to 659870.
> 
> 18,421 bytes in savings.
> 
> Note: Original numbers with KERNEL_DEBUG options enabled:
>  original-1591046, new-15888394, savings-22071
> 
> Final final changes:
> 
>  o  Fixed trace_event.c self tests to use the probe field in the
>     structure to determine if the event should be tested.
>     (old regfunc no longer exists)
> 
>  o  Fixed missing ';' in static struct in macro.
> 
>  o  Fixed the trace register functions in net drop monitor to conform
>     with the new API.
> 
> Final changes:
> 
>  o  Updated the change logs to reflect the sizes with KERNEL_DEBUG
>     disabled.
> 
>  o  Added Mathieu Desnoyers's Acked-by to the change logs.
> 
> Changes in v3:
> 
>  o  Ported to latest tip/tracing/core
> 
>  o  Fixed typo in change log that a comment in LWN noticed:
>     Wrote: 15999394 when it should have been 15888394.
>     (Note: these numbers are from the original posting. I need to
>      redo them again before posting officially).
> 
>  o  Added Mathieu Desnoyers's check_trace patch that will check
>     the callback to make sure it matches what DECLARE_TRACE() expects
>     it.
> 
>  o  Added the check_trace to the ftrace and perf callback probes.
>     Note, kprobes and syscalls do not use the register tracepoint
>     so they are not affected.
> 
>  o  Moved the define of DECLARE_TRACE() and DECLARE_TRACE_NOARGS()
>     out of the #ifdef CONFIG_TRACEPOINTS, since they were the same
>     whether or not CONFIG_TRACEPOINTS was enabled. The internal
>     __DECLARE_TRACE() changed.
> 
> Changes in v2:
> 
>  o  Ported to latest tip/tracing/core
> 
>  o  Removed DECLARE_TRACE_DATA() and made DECLARE_TRACE() have
>     the ability to pass a data parameter. This makes DECLARE_TRACE()
>     not work with no args. A new DECLARE_TRACE_NOARGS() has been created
>     that also allows data to be passed, but does is for tracepoint(void).
> 
>  o  Made the callbacks be "proto, void *data" and typecast the data
>     within the function.
> 
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Mathieu Desnoyers (1):
>       tracepoints: Add check trace callback type
> 
> Steven Rostedt (9):
>       tracing: Create class struct for events
>       tracing: Let tracepoints have data passed to tracepoint callbacks
>       tracing: Remove per event trace registering
>       tracing: Move fields from event to class structure
>       tracing: Move raw_init from events to class
>       tracing: Allow events to share their print functions
>       tracing: Move print functions into event class
>       tracing: Remove duplicate id information in event structure
>       tracing: Combine event filter_active and enable into single flags field


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

