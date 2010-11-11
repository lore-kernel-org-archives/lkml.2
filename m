Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab0KKUg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:36:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756491Ab0KKUgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:36:24 -0500
Date: Thu, 11 Nov 2010 15:35:27 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFD] Format for the new stable events ABI
Message-ID: <20101111203527.GA4101@redhat.com>
References: <1289498768.12418.313.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289498768.12418.313.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 01:06:08PM -0500, Steven Rostedt wrote:
> At kernel summit, we talked about coming up with stable events. The
> current events which reside in the debugfs directory and are used by
> both ftrace and perf have some issues.
> 
> 1) the format was specific to ftrace, and needs to be changed to be more
> generic.
> 
> 2) there are hundreds of events that can be added by all developers and
> the events can come and go freely and change without notice. This makes
> tools like powerchart break when a tracepoint they rely on changes.
> 
> 3) They reside in debugfs, which is really meant for debugging and not
> for tools. Moving them to /sys would be appropriate.
> 
> I would like to move all stable events into
> 
> /sys/kernel/events
> 
> Keeping a hierarchy, like sched, irqs, etc. Perhaps even allowing
> multiple layer hierarchy.
> 
> Here are a few requirements:
> 
> 1) As Linus stated, absolutely no modules can declare a stable trace
> point. The code to add a trace point here will not be exported to
> modules.
> 
> 2) The trace point must state a purpose. Not just describe some random
> internal description.
> 
> 3) Must describe something that is general and can been seen as being
> with the kernel forever.
> 
> The possible stable tracepoints that come to mind are:
> 
> sched_switch
> sched_migrate
> irq_enter
> irq_exit
> 
> We would also like the power tracepoints, but those need to be pulled
> out of arch specific code and made generic for all archs to use. 
> 
> All other tracepoints will still exist, and I would even expect that the
> stable tracepoints will hook on top of the other tracepoints.
> 
> There will be two types of tracepoints:
> 
> 1) stable tracepoints - exist in /sys/kernel/events
> 
> 2) in field debugging tracepoints - what we currently have. I suggest
> that we can move them into /sys/kernel/debugfs/events, and change the
> format from what is currently in /sys/kernel/debugfs/tracing/events. For
> drivers, we could also add them into /sys/drivers/... as well.
> 
> As stated above, I foresee stable tracepoints sitting on top of other
> tracepoints. Of course, the other tracepoints may change, but the fields
> that are used by the stable tracepoints will remain constant, or code
> that connects the debugging tracepoint to the stable tracepoint is
> changed to keep the output to user the same.
> 
> For example: lets look at sched_switch:
> 
> TRACE_EVENT(sched_switch,
> 
> 	TP_PROTO(struct task_struct *prev,
> 		 struct task_struct *next),
> 
> 	TP_ARGS(prev, next),
> 
> 	TP_STRUCT__entry(
> 		__array(	char,	prev_comm,	TASK_COMM_LEN	)
> 		__field(	pid_t,	prev_pid			)
> 		__field(	int,	prev_prio			)
> 		__field(	long,	prev_state			)
> 		__array(	char,	next_comm,	TASK_COMM_LEN	)
> 		__field(	pid_t,	next_pid			)
> 		__field(	int,	next_prio			)
> 	),
> 
> 	TP_fast_assign(
> 		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
> 		__entry->prev_pid	= prev->pid;
> 		__entry->prev_prio	= prev->prio;
> 		__entry->prev_state	= __trace_sched_switch_state(prev);
> 		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
> 		__entry->next_pid	= next->pid;
> 		__entry->next_prio	= next->prio;
> 	),
> 
> 	TP_printk("prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s ==> next_comm=%s next_pid=%d next_prio=%d",
> 		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
> 		__entry->prev_state ?
> 		  __print_flags(__entry->prev_state, "|",
> 				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
> 				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
> 				{ 128, "W" }) : "R",
> 		__entry->next_comm, __entry->next_pid, __entry->next_prio)
> );
> 
> 
> As Peter Zijlstra has pointed out, prio and state (as a number) may be
> deprecated if SCHED_DEADLINE gets in. We can keep this tracepoint as is,
> but create a new stable event that taps into the trace_sched_switch()
> and extracts only the stable fields. Something like:
> 
> 
> 	TP_fast_assign(
> 		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
> 		__entry->prev_pid	= prev->pid;
> 		__entry->prev_state	= __sched_state(prev->state);
> 		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
> 		__entry->next_pid	= next->pid;
> 	),
> 
> 
> The __sched_state() would return a character that matches what is
> retrieved by ps now, instead of returning a number.
> 
> Also, I would suggest removing the __entry trick, and have:
> 
> 	__assign(prev_pid, prev->pid);
> 
> This would allow us to be more flexible in how we write the field into
> the buffering system.
> 
> Now about format: The format in /debug/tracing/events/... looks like:
> 
> name: sched_switch
> ID: 57
> format:
> 	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
> 	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
> 	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
> 	field:int common_pid;	offset:4;	size:4;	signed:1;
> 	field:int common_lock_depth;	offset:8;	size:4;	signed:1;
> 
> 	field:char prev_comm[TASK_COMM_LEN];	offset:12;	size:16;	signed:1;
> 	field:pid_t prev_pid;	offset:28;	size:4;	signed:1;
> 	field:int prev_prio;	offset:32;	size:4;	signed:1;
> 	field:long prev_state;	offset:40;	size:8;	signed:1;
> 	field:char next_comm[TASK_COMM_LEN];	offset:48;	size:16;	signed:1;
> 	field:pid_t next_pid;	offset:64;	size:4;	signed:1;
> 	field:int next_prio;	offset:68;	size:4;	signed:1;
> 
> print fmt: "prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s ==> next_comm=%s next_pid=%d next_prio=%d", REC->prev_comm, REC->prev_pid, REC->prev_prio, REC->prev_state ? __print_flags(REC->prev_state, "|", { 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" }, { 16, "Z" }, { 32, "X" }, { 64, "x" }, { 128, "W" }) : "R", REC->next_comm, REC->next_pid, REC->next_prio
> 
> 
> The name is redundant. The ID should be specified by the tracer and not
> the event. The print fmt should go. The offset and size is in bytes, and
> I would suggest that we convert that to bits. This would let us compact
> the data better. I would also suggest removing the offset and instead
> specify an alignment:
> 
> 
> 	array:char prev_comm;	align:8;	size:8;	count:16;	signed:1;
> 	field:pid_t prev_pid;	align:8;	size:32;	signed:1;
> 	field:char prev_state;	align:8;	size:8;	signed:1;
> 	array:char next_comm;	align:8;	size:8;	count:16;	signed:1;
> 	field:pid_t next_pid;	align:8;	size:32;	signed:1;
> 
> Note, I removed the [] from prev_comm and next_comm and created an array
> instead. The size is per item in the array, and a count field is added
> to specify the number of items in that array.
> 
> As for dynamic arrays we can have:
> 
> 	dynamic:char name;	align:8;	size:8;	signed:1;
> 
> Where the alignment, size of each item, and signed is specified. The
> size of the array is know to be dynamic. We can discuss how this gets
> recorded into the buffer as well. The way ftrace and perf currently do
> it is to add a 32 bit word into that field. The first two bytes of that
> word specify the offset into the event data where the array exists, and
> the second 2 bytes is the array size.
> 
> Thoughts?
> 

So I assume these are going to be built-in...ie not dependent on
CONFIG_TRACEPOINTS?

Also, I'd like to see these well documented. I've started tracepoint
documentation, via docbook style comments here:

http://www.kernel.org/doc/htmldocs/tracepoint/

But we still have a ways to go...we can add a stable chapter or
notation for this.

thanks,

-Jason
