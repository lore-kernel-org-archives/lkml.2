Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab1KOMut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 07:50:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab1KOMus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 07:50:48 -0500
Date: Tue, 15 Nov 2011 14:50:43 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Oops while doing "echo function_graph > current_tracer"
Message-ID: <20111115125043.GF3225@redhat.com>
References: <20111114140745.GC3225@redhat.com>
 <1321320682.5011.23.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321320682.5011.23.camel@frodo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 08:31:22PM -0500, Steven Rostedt wrote:
> On Mon, 2011-11-14 at 16:07 +0200, Gleb Natapov wrote:
> > Hi Steven,
> > 
> > I get an oops with current linux.git when I am doing
> > "echo function_graph > current_tracer" inside a kvm guest.
> > Oopses do not contain much useful information and they are always
> > different. Looks like stack corruption (at least this is what Oopses
> > say when not triple faulting).
> > 
> > Attached is my guest kernel .config. I do not have the same problem on
> > the host, but kernel config is different there.
> 
> 
> Looking into this I see that this is an old bug. I guess this shows how
> many people run function graph tracing from the guest. Or at least how
> many with DEBUG_PREEMPT enabled too.
> 
Indeed. Without DEBUG_PREEMPT oops no longer happens.

> The problem is that kvm_clock_read() does a get_cpu_var(), which calls
> preempt_disable() which calls add_preempt_count() which is then traced.
> But this is outside the recursive protection in function_graph tracing,
> and when add_preempt_count() is traced, kvm_clock_read() calls
> add_preempt_count() and it gets traced again, and so on and causes a
> recursive crash.
> 
> There's a few fixes we can do. For now, because this is an old bug, I
> would just tell you to do this first:
> 
> echo add_preempt_count sub_preempt_count > /sys/kernel/debug/tracing/set_ftrace_notrace
This didn't help for some reason. May be I did something wrong, but I do
see add_preempt_count and sub_preempt_count in set_ftrace_notrace.

> 
> But that is just a work around for you and not a complete fix.
> 
> I could just make add_preempt_count() notrace and be done with it, but
> I've been reluctant to do this because there's been several times I've
> actually wanted to see the add_preempt_count()s being traced.
Yes, tracing (add|sub)_preempt_count() is very useful.

> 
> I could also make a get_cpu_var_notrace() version that kvm_clock_read()
> could use. This is the solution that I would most likely want to do as a
> permanent one.
> 
> Then finally I could force the function_graph tracer to have recursion
> protection and when it recurses, it just exits out nicely. I think I'll
> add that with a WARN_ON_ONCE(). Without the warning, if a recursion
> slips in, we'll have overhead of the recursion on top of the overhead of
> the tracing making it worse than what it already is. Function graph
> tracing is the most invasive tracer, and I want to speed it up if
> possible (I already have ideas on doing so) and I do not want to make it
> slower.
> 
I hope adding recursion protection is on top of fixing current recursion
with kvmclock. Catching recursion before it oops is nice, but having
functional tracer is even nicer :)

--
			Gleb.
