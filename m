Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1ECOHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:07:21 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50007 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752910Ab1ECOHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:07:19 -0400
Date: Tue, 3 May 2011 10:07:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC patch 01/32] TRACE_EVENT: gradual semicolon removal
Message-ID: <20110503140717.GA29736@Krystal>
References: <20110502211123.163877033@efficios.com> <20110502213211.250108074@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502213211.250108074@efficios.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:43:38 up 160 days, 18:46,  7 users,  load average: 0.01, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

And here is a self-reply to patch 01/32, due to LKML refusing messages
with more than 20 recipients.

Thanks,

Mathieu

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> Initiate the removal of the extra semicolons at the end of:
> 
> TRACE_EVENT(
>   ...
> );     <---- here,
> 
> TRACE_EVENT_FN(
>   ...
> );     <---- here,
> 
> DEFINE_EVENT(
>   ...
> );     <---- here,
> 
> DEFINE_EVENT_PRINT(
>   ...
> );     <---- and here.
> 
> by removing the semicolon from the comment in tracepoint.h explaining the
> TRACE_EVENT() usage. It is now also mandated that all declarations done in the
> trace event headers should be surrounded by ifdefs checks: it is already
> necessary, but some users get away from this requirement for structure
> forward-declarations.
> 
> I am proposing to merge this patchset through the "tracing" tree for better
> coordination.
> 
> Adding the missing semicolon within the DEFINE_EVENT(), DEFINE_EVENT_PRINT()
> and DEFINE_TRACE_FN() macros is required as a preliminary step to remove extra
> semicolons.  We currently are not seeing any impact of this missing semicolon
> because extra they appear all over the place in the code generated from
> TRACE_EVENT within ftrace stages. The side-effect of these extra semicolons are:
> 
> a) to pollute the preprocessor output, leaving extra ";" between trace event
> instances in trace points creation.
> 
> b) to render impossible creation of an array of events. Extra semicolons are
> not a matter as long as TRACE_EVENT creates statements, structure elements or
> functions, because extra semicolons are discarded by the compiler. However,
> when creating an array, the separator is the comma, and the semicolon causes a
> parse error.
> 
> 
> * So what is the motivation for removing these semicolons ?
> 
> Currently, Ftrace is creating a "ftrace_define_fields_##call" function for each
> event to define the event fields, which consumes space. It also has the
> ".fields" list head to keep a dynamically generated list of event fields.
> 
> By allowing creation of arrays of events, we can do the following: turn the
> dynamically created list of event fields into a first-level const array listing
> event fields. We can use ARRAY_SIZE() on this array to know its size,
> statically. Then, in a following trace event stage, we can create another const
> array containing tuples of (pointers to the event-specific arrays, array size).
> 
> So we get all the same information Ftrace currently gets with much less code
> overall, much less read-write data, and less dynamic initialization code.
> 
> 
> * Why do this incrementally ?
> 
> After this preliminary patch, the semicolon removal can be done gradually
> without breaking the build: we can be in an intermediate state with some files
> having semicolons and others without. This is therefore good for
> bissectability, and seems like a nice way to bring in an internal API change
> without making developers suffer too much. Then, once things are stabilized, we
> can start modifying the Ftrace code to generate the more space-efficient arrays
> (possibly in a release-cycle or so), knowing that this enforces a strict
> requirement on semicolon removal.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Alexander Graf <agraf@suse.de>
> CC: Alex Elder <aelder@sgi.com>
> CC: Anton Blanchard <anton@samba.org>
> CC: Arjan van de Ven <arjan@linux.intel.com>
> CC: Avi Kivity <avi@redhat.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Chris Wilson <chris@chris-wilson.co.uk>
> CC: Dave Airlie <airlied@redhat.com>
> CC: Dave Chinner <david@fromorbit.com>
> CC: Dave Chinner <dchinner@redhat.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Gleb Natapov <gleb@redhat.com>
> CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: James Bottomley <James.Bottomley@suse.de>
> CC: Jean Pihet <j-pihet@ti.com>
> CC: Jeff Moyer <jmoyer@redhat.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: Jeremy Kerr <jk@ozlabs.org>
> CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> CC: Joerg Roedel <joerg.roedel@amd.com>
> CC: Johannes Berg <johannes@sipsolutions.net>
> CC: John W. Linville <linville@tuxdriver.com>
> CC: Josh Stone <jistone@redhat.com>
> CC: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
> CC: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Larry Woodman <lwoodman@redhat.com>
> CC: Len Brown <len.brown@intel.com>
> CC: Li Zefan <lizf@cn.fujitsu.com>
> CC: Marcelo Tosatti <mtosatti@redhat.com>
> CC: Martin K. Petersen <martin.petersen@oracle.com>
> CC: Masami Hiramatsu <mhiramat@redhat.com>
> CC: Mel Gorman <mel@csn.ul.ie>
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Reinette Chatre <reinette.chatre@intel.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Roland McGrath <roland@redhat.com>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Steven Whitehouse <swhiteho@redhat.com>
> CC: Tejun Heo <tj@kernel.org>
> CC: Theodore Ts'o <tytso@mit.edu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Thomas Renninger <trenn@suse.de>
> CC: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
> CC: Vadim Rozenfeld <vrozenfe@redhat.com>
> CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> CC: Zhu Yi <yi.zhu@intel.com>
> ---
>  include/linux/tracepoint.h |    4 ++--
>  include/trace/ftrace.h     |   10 +++++-----
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6-lttng/include/trace/ftrace.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/trace/ftrace.h
> +++ linux-2.6-lttng/include/trace/ftrace.h
> @@ -34,8 +34,8 @@
>  			     PARAMS(args),		       \
>  			     PARAMS(tstruct),		       \
>  			     PARAMS(assign),		       \
> -			     PARAMS(print));		       \
> -	DEFINE_EVENT(name, name, PARAMS(proto), PARAMS(args));
> +			     PARAMS(print))		       \
> +	DEFINE_EVENT(name, name, PARAMS(proto), PARAMS(args))
>  
>  
>  #undef __field
> @@ -69,7 +69,7 @@
>  #undef DEFINE_EVENT
>  #define DEFINE_EVENT(template, name, proto, args)	\
>  	static struct ftrace_event_call	__used		\
> -	__attribute__((__aligned__(4))) event_##name
> +	__attribute__((__aligned__(4))) event_##name;
>  
>  #undef DEFINE_EVENT_PRINT
>  #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
> @@ -588,7 +588,7 @@ static struct ftrace_event_call __used e
>  	.print_fmt		= print_fmt_##template,			\
>  };									\
>  static struct ftrace_event_call __used					\
> -__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
> +__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
>  
>  #undef DEFINE_EVENT_PRINT
>  #define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
> @@ -602,7 +602,7 @@ static struct ftrace_event_call __used e
>  	.print_fmt		= print_fmt_##call,			\
>  };									\
>  static struct ftrace_event_call __used					\
> -__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
> +__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
>  
>  #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
>  
> Index: linux-2.6-lttng/include/linux/tracepoint.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/tracepoint.h
> +++ linux-2.6-lttng/include/linux/tracepoint.h
> @@ -187,7 +187,7 @@ do_trace:								\
>  		&__tracepoint_##name;
>  
>  #define DEFINE_TRACE(name)						\
> -	DEFINE_TRACE_FN(name, NULL, NULL);
> +	DEFINE_TRACE_FN(name, NULL, NULL)
>  
>  #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)				\
>  	EXPORT_SYMBOL_GPL(__tracepoint_##name)
> @@ -345,7 +345,7 @@ do_trace:								\
>   *		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
>   *		__entry->next_comm, __entry->next_pid, __entry->next_prio),
>   *
> - * );
> + * )
>   *
>   * This macro construct is thus used for the regular printk format
>   * tracing setup, it is used to construct a function pointer based
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
