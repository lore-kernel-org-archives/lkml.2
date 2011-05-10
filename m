Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab1EJIAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:00:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54763 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233Ab1EJIAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:00:45 -0400
Date: Tue, 10 May 2011 10:00:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Jiri Olsa <jolsa@redhat.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>
Subject: Re: [RFC][PATCH 00/13] ftrace: Allow multiple users to pick and
 choose functions to trace
Message-ID: <20110510080029.GA27426@elte.hu>
References: <20110506152624.776982312@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506152624.776982312@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo, et. al.
> 
> This is an RFC patch set of the work I did to allow multiple users
> to pick and choose which functions they would like to trace without
> being affected by other users (well, they are still affected, but
> they can choose their own functions).
> 
> Since this rewrote a lot of the guts of ftrace's function handling
> I broke it up into steps that I can sequentially think about how to
> make the conversion. It also helped in understanding the changes that
> had to be made.
> 
> The end result now has this:
> 
>  o The function record list flags item now stores a ref count, and
>    we no longer need to have the flags if the records are filtered
>    or set for "notrace"
> 
>  o Each ftrace_ops has its own set of functions to trace or not trace
>    which is used to update the ref counts of the function records
>    mentioned above. If the ftrace_ops is not currently active, the
>    records are not touched when the filters are changed. If the filters
>    are changed while the ftrace_ops is active, it is done in a way
>    with RCU to make the updates.
> 
>  o If only one ftrace_ops is registered for tracing (actively tracing),
>    its handler is called directly from mcount. Unless the ftrace_ops
>    was allocated and not a static/global core kernel variable (see below).
> 
>  o If more than one ftrace_ops is registered, then a function is called
>    that will iterate over the list of registered ftrace_ops, performing
>    a check of each of its hashes to know if ftrace_ops handler should
>    be called for that function.
> 
>  o If a ftrace_ops is allocated and not a static/global core kernel
>    variable, it will be forced to use the function that loops through
>    the ftrace_ops even if its the only one. This is because that function
>    disables preemption when it performs the loop. This is needed, because
>    dynamically allocated ftrace_ops must call synchronize_sched() before
>    being freed (which is done when the dynamic ftrace_ops has been
>    unregistered).
> 
>  o A file has been created in the debugfs/tracing directory called
>    enabled_functions. This file contains a list of all functions that
>    any ftrace_ops has registered, along with each functions ref count.
>    This can be used to make sure nothing is tracing.

Well, i think we'd like to see the end result as well: i.e. function tracing 
exposed to a tracer that can do per task tracing (perf) and then demonstrating 
that independent tracing sessions can trace functions without impacting each 
other.

Thanks,

	Ingo
