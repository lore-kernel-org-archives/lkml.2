Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab1KOMw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 07:52:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab1KOMw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 07:52:56 -0500
Message-ID: <4EC260A2.8040404@redhat.com>
Date: Tue, 15 Nov 2011 14:52:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Gleb Natapov <gleb@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: Oops while doing "echo function_graph > current_tracer"
References: <20111114140745.GC3225@redhat.com> <1321320682.5011.23.camel@frodo>
In-Reply-To: <1321320682.5011.23.camel@frodo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2011 03:31 AM, Steven Rostedt wrote:
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
>
> But that is just a work around for you and not a complete fix.
>
> I could just make add_preempt_count() notrace and be done with it, but
> I've been reluctant to do this because there's been several times I've
> actually wanted to see the add_preempt_count()s being traced.
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
>

There was a similar fix for Xen which Jeremy noted could be applicable
to kvm, which I forgot.  I'll go look for it.

-- 
error compiling committee.c: too many arguments to function

