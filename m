Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0LDCyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 21:54:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63524 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0LDCyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 21:54:15 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=_hCqAiHmeU0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=jgQfevDBVUav35kChZgA:9 a=6_zRsg3WxhpZyXJ-nHEA:7 a=bpdOqcJvrIQIhQLUSjKkUsyfDCoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 13/15] small_traces: Add config option to shrink trace
 events.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <AANLkTimiMtdfXag6bukxDo21uSDzs0nj4YG-35M2ioiP@mail.gmail.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-14-git-send-email-dhsharp@google.com>
	 <1291427770.16223.15.camel@gandalf.stny.rr.com>
	 <AANLkTimiMtdfXag6bukxDo21uSDzs0nj4YG-35M2ioiP@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Dec 2010 21:54:12 -0500
Message-ID: <1291431252.16223.28.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 18:33 -0800, David Sharp wrote:
> I considered that, and I generally thing it's a good idea. However, I
> also want to use this switch to shrink individual tracepoint event
> structures.
> 
> eg: sched switch is a high frequency event and it is 68 bytes (60
> after these patches)
> 
> Can you suggest a syntax for TRACE_EVENT, DECLARE_EVENT_CLASS, etc,
> that could express the two versions and produce the right code?
> 
> I'm worried about adding even further complexity to the TRACE_EVENT
> macros. I could add TRACE_EVENT_SMALL that takes two versions of
> TP_STRUCT__entry, TP_fast_assign, and TP_printk each, but then this
> will need to be permuted with your TP_CONDITIONAL patches as well.

I would not touch the TRACE_EVENT() structures. They are there as is and
I would not think about changing them. Something like that would never
make it into mainline.

Now what you can do, is to make your own events based off of the same
tracepoints. For example, the TRACE_EVENT(sched_switch...) has in
sched.c:

	trace_sched_switch(prev, next);


You could even write a module that does something like this:

	register_trace_sched_switch(probe_sched_switch, mydata);



void probe_sched_switch(void *mydata,
		struct task_struct *prev,
		struct task_struct *next)
{
	struct ring_buffer *buffer;
	struct ring_buffer_event *event;
	struct myentry *entry;

	event = trace_current_buffer_lock_reserve(buffer,
			mytype, sizeof(*entry),
			0, 0);

	if (!event)
		return;

	entry = ring_buffer_event_data(event);

	entry->myfield = prev->x;
	...

	trace_nowake_buffer_unlock_commit(buffer, event,
					0, 0);
}

You will need to do a register_ftrace_event() to register that 'mytype'
and how to output it. Otherwise it would just be ignored in the "trace"
file.

All of the above would work fine as a loadable module that you could
easily maintain out of tree, and still uses the internals of the system.

-- Steve


