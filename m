Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab2HMID6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 04:03:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:34495 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab2HMID4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 04:03:56 -0400
Message-ID: <1344845024.31459.9.camel@twins>
Subject: Re: [RFC][PATCH 4/4] perf/events: Use helper functions in event
 assignment to shrink macro size
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 13 Aug 2012 10:03:44 +0200
In-Reply-To: <20120810034708.589220175@goodmis.org>
References: <20120810034302.758092203@goodmis.org>
	 <20120810034708.589220175@goodmis.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-09 at 23:43 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0004-perf-events-Use-helper-functions-in-event-assignment.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The functions that assign the contents for the perf software events are
> defined by the TRACE_EVENT() macros. Each event has its own unique
> way to assign data to its buffer. When you have over 700 events,
> that means there's 700 functions assigning data uniquely for each
> event.
> 
> By making helper functions in the core kernel to do the work
> instead, we can shrink the size of the kernel down a bit.
> 
> With a kernel configured with 707 events, the change in size was:
> 
>    text    data     bss     dec     hex filename
> 19966937        2594648 1945600 24507185        175f331 vmlinux-before
> 19924761        2594584 1945600 24464945        1754e31 vmlinux-after
> 
> That's a total of 42240 bytes, which comes down to 59 bytes per event.

Seems like good stuff.. one nit..


> +void perf_trace_event_submit(void *raw_data, struct ftrace_event_call *event_call,
> +                            struct perf_trace_event *pe)
> +{
> +       struct hlist_head *head;
> +
> +       head = this_cpu_ptr(event_call->perf_events);
> +       perf_trace_buf_submit(raw_data, pe->entry_size, pe->rctx, pe->addr,
> +                             pe->count, &pe->regs, head);
> +}

Can you make perf_trace_buf_submit() go away? Its reduced to a simple
fwd function and layering another wrapper on top seems like pushing it.
